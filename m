Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE283C720B
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 16:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbhGMOX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 10:23:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31576 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236909AbhGMOXz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 10:23:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626186065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NizuknTonLPtfV10+PDZQabcKPTYBFw/w+7o4Dzz+h4=;
        b=E3igu3a9H/wTnVD6gCLU3EFpCe2y5GE4zVZo24PO1CboizOB6HrelS3QPs4JOe2e02OmZc
        lR8mJjqSw5iUpxDCap+/BPSnai7XQ/RhcUn4wgx7WWtDisCgRiSt3NEy/F+31C/o5lHDmm
        TjDSEhzmsWPOPBo1K97/GXesVbGMSts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-g7sPQ8PxNc2RUF4p3PzceA-1; Tue, 13 Jul 2021 10:21:04 -0400
X-MC-Unique: g7sPQ8PxNc2RUF4p3PzceA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5788291FCC0;
        Tue, 13 Jul 2021 14:21:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F16B6267C;
        Tue, 13 Jul 2021 14:20:58 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 7/8] KVM: SVM: call avic_vcpu_load/avic_vcpu_put when enabling/disabling AVIC
Date:   Tue, 13 Jul 2021 17:20:22 +0300
Message-Id: <20210713142023.106183-8-mlevitsk@redhat.com>
In-Reply-To: <20210713142023.106183-1-mlevitsk@redhat.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently it is possible to have the following scenario:

1. AVIC is disabled by svm_refresh_apicv_exec_ctrl
2. svm_vcpu_blocking calls avic_vcpu_put which does nothing
3. svm_vcpu_unblocking enables the AVIC (due to KVM_REQ_APICV_UPDATE)
   and then calls avic_vcpu_load
4. warning is triggered in avic_vcpu_load since
   AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK was never cleared

While it is possible to just remove the warning, it seems to be more robust
to fully disable/enable AVIC in svm_refresh_apicv_exec_ctrl by calling the
avic_vcpu_load/avic_vcpu_put

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 43 ++++++++++++++++++++++-------------------
 arch/x86/kvm/svm/svm.c  |  8 ++++++--
 arch/x86/kvm/x86.c      | 10 ++++++++--
 3 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 64d1e1b6a305..0e4370fe0868 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -80,6 +80,28 @@ enum avic_ipi_failure_cause {
 	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
 };
 
+
+static void __avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
+{
+	if (is_run)
+		avic_vcpu_load(vcpu, vcpu->cpu);
+	else
+		avic_vcpu_put(vcpu);
+}
+
+/*
+ * This function is called during VCPU halt/unhalt.
+ */
+static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->avic_is_running = is_run;
+
+	if (kvm_vcpu_apicv_active(vcpu))
+		__avic_set_running(vcpu, is_run);
+}
+
 /* Note:
  * This function is called from IOMMU driver to notify
  * SVM to schedule in a particular vCPU of a particular VM.
@@ -667,6 +689,7 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	}
 	vmcb_mark_dirty(vmcb, VMCB_AVIC);
 
+	__avic_set_running(vcpu, activated);
 	svm_set_pi_irte_mode(vcpu, activated);
 }
 
@@ -960,9 +983,6 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return;
-
 	/*
 	 * Since the host physical APIC id is 8 bits,
 	 * we can support host APIC ID upto 255.
@@ -990,9 +1010,6 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	u64 entry;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (!kvm_vcpu_apicv_active(vcpu))
-		return;
-
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
 	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
 		avic_update_iommu_vcpu_affinity(vcpu, -1, 0);
@@ -1001,20 +1018,6 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }
 
-/*
- * This function is called during VCPU halt/unhalt.
- */
-static void avic_set_running(struct kvm_vcpu *vcpu, bool is_run)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	svm->avic_is_running = is_run;
-	if (is_run)
-		avic_vcpu_load(vcpu, vcpu->cpu);
-	else
-		avic_vcpu_put(vcpu);
-}
-
 void svm_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	avic_set_running(vcpu, false);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d14be8aba2d7..2c291dfa0e04 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1505,12 +1505,16 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		sd->current_vmcb = svm->vmcb;
 		indirect_branch_prediction_barrier();
 	}
-	avic_vcpu_load(vcpu, cpu);
+
+	if (kvm_vcpu_apicv_active(vcpu))
+		avic_vcpu_load(vcpu, cpu);
 }
 
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	avic_vcpu_put(vcpu);
+	if (kvm_vcpu_apicv_active(vcpu))
+		avic_vcpu_put(vcpu);
+
 	svm_prepare_host_switch(vcpu);
 
 	++vcpu->stat.host_state_reload;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a91e35b92447..213d332664e2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9177,12 +9177,18 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
 
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 {
+	bool activate;
+
 	if (!lapic_in_kernel(vcpu))
 		return;
 
 	mutex_lock(&vcpu->kvm->apicv_update_lock);
 
-	vcpu->arch.apicv_active = kvm_apicv_activated(vcpu->kvm);
+	activate = kvm_apicv_activated(vcpu->kvm);
+	if (vcpu->arch.apicv_active == activate)
+		goto out;
+
+	vcpu->arch.apicv_active = activate;
 	kvm_apic_update_apicv(vcpu);
 	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
 
@@ -9194,7 +9200,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	 */
 	if (!vcpu->arch.apicv_active)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
-
+out:
 	mutex_unlock(&vcpu->kvm->apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
-- 
2.26.3

