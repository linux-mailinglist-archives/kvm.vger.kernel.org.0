Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8226E32B59F
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381809AbhCCHSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:18:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39712 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835966AbhCBTfX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=maylFet1yoroxKQLdT6XFqfjUxYjLc/3Q+mM/kcNxv0=;
        b=AiJO5onQXI9a438cTa6uoiktjg+OJUljc1fNPK9Ri/Eoezh/mmFYurALfvGUyHy25BKvaP
        3BJJKTNJmCRVL6l8P+szk4fXmFI6o9Hwzb62qnlIdXQgct+bpj/FjP4FF0/5EMk4lA9KVa
        SnZx/Km09rGf1FP9nhRZJug/oyfK5fs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-o-tVigR5OfGeZqBR8DWeVg-1; Tue, 02 Mar 2021 14:33:46 -0500
X-MC-Unique: o-tVigR5OfGeZqBR8DWeVg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFD31107ACC7;
        Tue,  2 Mar 2021 19:33:45 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7981D60BFA;
        Tue,  2 Mar 2021 19:33:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Cathy Avery <cavery@redhat.com>
Subject: [PATCH 02/23] KVM: nSVM: Track the physical cpu of the vmcb vmrun through the vmcb
Date:   Tue,  2 Mar 2021 14:33:22 -0500
Message-Id: <20210302193343.313318-3-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Cathy Avery <cavery@redhat.com>

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
Message-Id: <20210112164313.4204-2-cavery@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 23 +++++++++++++++--------
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1d24129496d0..c35285c926e0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1317,11 +1317,12 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
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
@@ -1497,11 +1498,6 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
 
-	if (unlikely(cpu != vcpu->cpu)) {
-		svm->asid_generation = 0;
-		vmcb_mark_all_dirty(svm->vmcb);
-	}
-
 	if (sd->current_vmcb != svm->vmcb) {
 		sd->current_vmcb = svm->vmcb;
 		indirect_branch_prediction_barrier();
@@ -3433,6 +3429,17 @@ static void pre_svm_run(struct vcpu_svm *svm)
 {
 	struct svm_cpu_data *sd = per_cpu(svm_data, svm->vcpu.cpu);
 
+	/*
+	 * If the previous vmrun of the vmcb occurred on
+	 * a different physical cpu then we must mark the vmcb dirty.
+	 */
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
index 818b37388d8c..a37281097751 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -84,6 +84,7 @@ struct kvm_vcpu;
 struct kvm_vmcb_info {
 	struct vmcb *ptr;
 	unsigned long pa;
+	int cpu;
 };
 
 struct svm_nested_state {
-- 
2.26.2


