Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DEC2F4CD1
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 15:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbhAMOMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 09:12:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31283 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726456AbhAMOMI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 09:12:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610547041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bJJPeCzPrT/sxj0yTskmiKmd9WxFd0iQ25eQQC8YKrI=;
        b=QZB/3+19iYvLP5dhO63w2Nj8R+TXeAcg/btI4Zt/+BXHN/KZyEssNmrPl9OKS7Nc8qQQF5
        vGL03abn3n3MRBX4yhoUc9JBfcDTYz0MOHlrbA65rJD3ud33CHTo79/0tWggxP2adhfab2
        WbfcbYCHv9ICtigVGWJ3JvAcVtGsZx4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-RiIOz881Myyh66FrWGwwaA-1; Wed, 13 Jan 2021 09:10:39 -0500
X-MC-Unique: RiIOz881Myyh66FrWGwwaA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 270CD835BA7;
        Wed, 13 Jan 2021 14:10:21 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84EE660BF1;
        Wed, 13 Jan 2021 14:10:20 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com
Subject: [PATCH v2 1/2] KVM: nSVM: Track the physical cpu of the vmcb vmrun through the vmcb
Date:   Wed, 13 Jan 2021 09:10:18 -0500
Message-Id: <20210113141019.5127-2-cavery@redhat.com>
In-Reply-To: <20210113141019.5127-1-cavery@redhat.com>
References: <20210113141019.5127-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
 arch/x86/kvm/svm/svm.c | 23 +++++++++++++++--------
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 62390fbc9233..be41b7ebfcea 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1299,11 +1299,12 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
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
@@ -1386,11 +1387,6 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
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
@@ -3176,6 +3172,17 @@ static void pre_svm_run(struct vcpu_svm *svm)
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

