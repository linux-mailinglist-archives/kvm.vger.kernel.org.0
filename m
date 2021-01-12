Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2282D2F360E
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 17:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404959AbhALQop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 11:44:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53126 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404845AbhALQop (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 11:44:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610469798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wGDTKeYzxrsl9FTH6Ik87RsmFf+MsbUCD0z98AUK1Cc=;
        b=QjwqV+iC3z/rfC0Lmpy6A8tbzU5lk9phFzRwLEGmenvCapIlHD5mR91y3kEJ0JYZw15/w5
        0b3nd7RbL5i94yOrTFlr3eJ4Ep0DhZ/VYbsGVowznjRLCT+dZnS9t7BGd7j8AuQkXnMI42
        Z3srQNybNZagLBlAWgTjoh0dTeYrbfM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-2ZHCZNHLPFWZzY70F-h-Jw-1; Tue, 12 Jan 2021 11:43:16 -0500
X-MC-Unique: 2ZHCZNHLPFWZzY70F-h-Jw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13BEB18C89CF;
        Tue, 12 Jan 2021 16:43:15 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 75D5A5C1B4;
        Tue, 12 Jan 2021 16:43:14 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 1/2] KVM: nSVM: Track the physical cpu of the vmcb vmrun through the vmcb
Date:   Tue, 12 Jan 2021 11:43:12 -0500
Message-Id: <20210112164313.4204-2-cavery@redhat.com>
In-Reply-To: <20210112164313.4204-1-cavery@redhat.com>
References: <20210112164313.4204-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch moves the physical cpu tracking from the vcpu
to the vmcb in svm_switch_vmcb. If either vmcb01 or vmcb02
change physical cpus from one vmrun to the next the vmcb's
previous cpu is preserved for comparison with the current
cpu and the vmcb is marked dirty if different. This prevents
the processor from using old cached data for a vmcb that may
have been updated on a prior run on a different processor.

It also moves the physical cpu check from svm_vcpu_load
to pre_svm_run as the check only needs to be done at run.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 28 ++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 62390fbc9233..5b6998ff7aa1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1287,6 +1287,11 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
 {
+	/*
+	* Track the old VMCB so the new VMCB will be marked
+	* dirty at its next vmrun.
+	*/
+
 	svm->current_vmcb = target_vmcb;
 	svm->vmcb = target_vmcb->ptr;
 	svm->vmcb_pa = target_vmcb->pa;
@@ -1299,11 +1304,12 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
 	svm->asid_generation = 0;
 
 	/*
-	* Workaround: we don't yet track the physical CPU that
-	* target_vmcb has run on.
+	* Track the physical CPU the target_vmcb is running on
+	* in order to mark the VMCB dirty if the cpu changes at
+	* its next vmrun.
 	*/
 
-	vmcb_mark_all_dirty(svm->vmcb);
+	svm->current_vmcb->cpu = svm->vcpu.cpu;
 }
 
 static int svm_create_vcpu(struct kvm_vcpu *vcpu)
@@ -1386,11 +1392,6 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
 	int i;
 
-	if (unlikely(cpu != vcpu->cpu)) {
-		svm->asid_generation = 0;
-		vmcb_mark_all_dirty(svm->vmcb);
-	}
-
 #ifdef CONFIG_X86_64
 	rdmsrl(MSR_GS_BASE, to_svm(vcpu)->host.gs_base);
 #endif
@@ -3176,6 +3177,17 @@ static void pre_svm_run(struct vcpu_svm *svm)
 {
 	struct svm_cpu_data *sd = per_cpu(svm_data, svm->vcpu.cpu);
 
+	/*
+	* If the previous vmrun of the vmcb occurred on
+	* a different physical cpu then we must mark the vmcb dirty.
+	*/
+
+        if (unlikely(svm->current_vmcb->cpu != svm->vcpu.cpu)) {
+		svm->asid_generation = 0;
+		vmcb_mark_all_dirty(svm->vmcb);
+		svm->current_vmcb->cpu = svm->vcpu.cpu;
+        }
+
 	if (sev_guest(svm->vcpu.kvm))
 		return pre_sev_run(svm, svm->vcpu.cpu);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 86bf443d4b2a..05baee934d03 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -85,6 +85,7 @@ struct kvm_vcpu;
 struct kvm_vmcb_info {
 	struct vmcb *ptr;
 	unsigned long pa;
+	int cpu;
 };
 
 struct svm_nested_state {
-- 
2.20.1

