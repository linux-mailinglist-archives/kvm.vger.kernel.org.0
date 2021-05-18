Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53EA387B88
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 16:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237020AbhEROpR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 10:45:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236904AbhEROpP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 10:45:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621349037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DFMYe5Qt/mGHp1NLSUQLjMeAsDbKsoVFjAV1yKKPeo0=;
        b=TKvJFHe36zJu9D3fPWcxfmDMagpIvPEaf6fKNZgPAOHCv3DF4oTixiE9I935CnRbhxQDKz
        zKBvDi8RF9P/VFdROQ44VtLySFsE4R0VfGtnjrreggO3v2ixu1foPBm017T0mwOG/ejfXP
        Yta61risuPhOStSnyKLIsKU3FD1HFdo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-4UKN_hEJPZqNIgDMzBkMXQ-1; Tue, 18 May 2021 10:43:55 -0400
X-MC-Unique: 4UKN_hEJPZqNIgDMzBkMXQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB52F188E3D2;
        Tue, 18 May 2021 14:43:53 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.193.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F267A19C97;
        Tue, 18 May 2021 14:43:51 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] KVM: x86: Use common 'enable_apicv' variable for both APICv and AVIC
Date:   Tue, 18 May 2021 16:43:37 +0200
Message-Id: <20210518144339.1987982-4-vkuznets@redhat.com>
In-Reply-To: <20210518144339.1987982-1-vkuznets@redhat.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
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
index 55efbacfc244..a2197fcf0e7c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1422,6 +1422,7 @@ struct kvm_arch_async_pf {
 extern u32 __read_mostly kvm_nr_uret_msrs;
 extern u64 __read_mostly host_efer;
 extern bool __read_mostly allow_smaller_maxphyaddr;
+extern bool __read_mostly enable_apicv;
 extern struct kvm_x86_ops kvm_x86_ops;
 
 #define KVM_X86_OP(func) \
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 1c1bf911e02b..05cd0b128b02 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -27,10 +27,6 @@
 #include "irq.h"
 #include "svm.h"
 
-/* enable / disable AVIC */
-int avic;
-module_param(avic, int, S_IRUGO);
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
index 8c3918a11826..0d6ec34d1e4b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -185,6 +185,10 @@ module_param(vls, int, 0444);
 static int vgif = true;
 module_param(vgif, int, 0444);
 
+/* enable / disable AVIC */
+static int avic;
+module_param(avic, int, 0444);
+
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
@@ -1009,14 +1013,15 @@ static __init int svm_hardware_setup(void)
 			nrips = false;
 	}
 
-	if (avic) {
-		if (!npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC)) {
-			avic = false;
-		} else {
-			pr_info("AVIC enabled\n");
+	if (!npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC))
+		avic = false;
 
-			amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
-		}
+	/* 'enable_apicv' is common between VMX/SVM but the defaults differ */
+	enable_apicv = avic;
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
index e44567ceb865..a514b490db4a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -479,8 +479,6 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
-extern int avic;
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
index 4bceb5ca3a89..5e9ba10e9c2d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -101,7 +101,6 @@ module_param(emulate_invalid_guest_state, bool, S_IRUGO);
 static bool __read_mostly fasteoi = 1;
 module_param(fasteoi, bool, S_IRUGO);
 
-bool __read_mostly enable_apicv = 1;
 module_param(enable_apicv, bool, S_IRUGO);
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b6bca616929..23fdbba6b394 100644
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

