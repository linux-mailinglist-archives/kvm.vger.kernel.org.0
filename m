Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775B73A189F
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 17:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbhFIPLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 11:11:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49288 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232316AbhFIPLQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 11:11:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623251361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yg61jCXphoB9nPXQMnXt+aTyGxrSoIwADSw1hgPJ030=;
        b=YzaBcY9anGqA69JzXhWlRIJdU/0kJ9l85DoAdeb85rWO700Li+1G0zKFXEOTYz/DfriUNT
        IKmMHNj7jO7SuhwrWB4oeEf5Do0HRuMoPft8wCwfI0EK4uxPt00rMbFMnfKl9DFsy0deqB
        55qV/JjG81BSV8FWp3xk0AlaOLZu30M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-g26gfbHgMsK53EFRmhTpPw-1; Wed, 09 Jun 2021 11:09:20 -0400
X-MC-Unique: g26gfbHgMsK53EFRmhTpPw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16540BBEE1;
        Wed,  9 Jun 2021 15:09:19 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DFD560BD8;
        Wed,  9 Jun 2021 15:09:15 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/4] KVM: x86: Use common 'enable_apicv' variable for both APICv and AVIC
Date:   Wed,  9 Jun 2021 17:09:08 +0200
Message-Id: <20210609150911.1471882-2-vkuznets@redhat.com>
In-Reply-To: <20210609150911.1471882-1-vkuznets@redhat.com>
References: <20210609150911.1471882-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unify VMX and SVM code by moving APICv/AVIC enablement tracking to common
'enable_apicv' variable. Note: unlike APICv, AVIC is disabled by default.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/avic.c         | 14 +++++---------
 arch/x86/kvm/svm/svm.c          | 23 ++++++++++++++---------
 arch/x86/kvm/svm/svm.h          |  2 --
 arch/x86/kvm/vmx/capabilities.h |  1 -
 arch/x86/kvm/vmx/vmx.c          |  1 -
 arch/x86/kvm/x86.c              |  3 +++
 7 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9c7ced0e3171..bb4f827cbacd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1423,6 +1423,7 @@ struct kvm_arch_async_pf {
 extern u32 __read_mostly kvm_nr_uret_msrs;
 extern u64 __read_mostly host_efer;
 extern bool __read_mostly allow_smaller_maxphyaddr;
+extern bool __read_mostly enable_apicv;
 extern struct kvm_x86_ops kvm_x86_ops;
 
 #define KVM_X86_OP(func) \
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 0e62e6a2438c..05cd0b128b02 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -27,10 +27,6 @@
 #include "irq.h"
 #include "svm.h"
 
-/* enable / disable AVIC */
-bool avic;
-module_param(avic, bool, S_IRUGO);
-
 #define SVM_AVIC_DOORBELL	0xc001011b
 
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
@@ -124,7 +120,7 @@ void avic_vm_destroy(struct kvm *kvm)
 	unsigned long flags;
 	struct kvm_svm *kvm_svm = to_kvm_svm(kvm);
 
-	if (!avic)
+	if (!enable_apicv)
 		return;
 
 	if (kvm_svm->avic_logical_id_table_page)
@@ -147,7 +143,7 @@ int avic_vm_init(struct kvm *kvm)
 	struct page *l_page;
 	u32 vm_id;
 
-	if (!avic)
+	if (!enable_apicv)
 		return 0;
 
 	/* Allocating physical APIC ID table (4KB) */
@@ -569,7 +565,7 @@ int avic_init_vcpu(struct vcpu_svm *svm)
 	int ret;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	if (!avic || !irqchip_in_kernel(vcpu->kvm))
+	if (!enable_apicv || !irqchip_in_kernel(vcpu->kvm))
 		return 0;
 
 	ret = avic_init_backing_page(vcpu);
@@ -593,7 +589,7 @@ void avic_post_state_restore(struct kvm_vcpu *vcpu)
 
 void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate)
 {
-	if (!avic || !lapic_in_kernel(vcpu))
+	if (!enable_apicv || !lapic_in_kernel(vcpu))
 		return;
 
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
@@ -653,7 +649,7 @@ void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	struct vmcb *vmcb = svm->vmcb;
 	bool activated = kvm_vcpu_apicv_active(vcpu);
 
-	if (!avic)
+	if (!enable_apicv)
 		return;
 
 	if (activated) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e088086f3de6..200aabe6de23 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -185,6 +185,13 @@ module_param(vls, int, 0444);
 static int vgif = true;
 module_param(vgif, int, 0444);
 
+/*
+ * enable / disable AVIC.  Because the defaults differ for APICv
+ * support between VMX and SVM we cannot use module_param_named.
+ */
+static bool avic;
+module_param(avic, bool, 0444);
+
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
@@ -1009,14 +1016,12 @@ static __init int svm_hardware_setup(void)
 			nrips = false;
 	}
 
-	if (avic) {
-		if (!npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC)) {
-			avic = false;
-		} else {
-			pr_info("AVIC enabled\n");
+	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
 
-			amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
-		}
+	if (enable_apicv) {
+		pr_info("AVIC enabled\n");
+
+		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 	}
 
 	if (vls) {
@@ -4427,13 +4432,13 @@ static int svm_vm_init(struct kvm *kvm)
 	if (!pause_filter_count || !pause_filter_thresh)
 		kvm->arch.pause_in_guest = true;
 
-	if (avic) {
+	if (enable_apicv) {
 		int ret = avic_vm_init(kvm);
 		if (ret)
 			return ret;
 	}
 
-	kvm_apicv_init(kvm, avic);
+	kvm_apicv_init(kvm, enable_apicv);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2908c6ab5bb4..8959b85319bb 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -480,8 +480,6 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
-extern bool avic;
-
 static inline void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data)
 {
 	svm->vmcb->control.avic_vapic_bar = data & VMCB_AVIC_APIC_BAR_MASK;
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index aa0e7872fcc9..4705ad55abb5 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -12,7 +12,6 @@ extern bool __read_mostly enable_ept;
 extern bool __read_mostly enable_unrestricted_guest;
 extern bool __read_mostly enable_ept_ad_bits;
 extern bool __read_mostly enable_pml;
-extern bool __read_mostly enable_apicv;
 extern int __read_mostly pt_mode;
 
 #define PT_MODE_SYSTEM		0
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 50b42d7a8a11..4eb369e66372 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -101,7 +101,6 @@ module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 static bool __read_mostly fasteoi = 1;
 module_param(fasteoi, bool, S_IRUGO);
 
-bool __read_mostly enable_apicv = 1;
 module_param(enable_apicv, bool, S_IRUGO);
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b594275d49b5..7139725303da 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -209,6 +209,9 @@ EXPORT_SYMBOL_GPL(host_efer);
 bool __read_mostly allow_smaller_maxphyaddr = 0;
 EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
 
+bool __read_mostly enable_apicv = true;
+EXPORT_SYMBOL_GPL(enable_apicv);
+
 u64 __read_mostly host_xss;
 EXPORT_SYMBOL_GPL(host_xss);
 u64 __read_mostly supported_xss;
-- 
2.31.1

