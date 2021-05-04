Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591D9372EC2
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhEDRTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbhEDRTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:19:10 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24D3C06134D
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:18:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y5-20020a2586050000b02904ee36d3b170so12617034ybk.10
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=I0YgTTuADCddU7gmQFiimvdU+bEYx4FI76LT0CJf50k=;
        b=WsX+UOIow9SVeSekUUUEP42Bla3aG09c7lCeheves/gmCrujgJGG87UyJ4m7cJeJN1
         wnUUM1dANdZ8mQ8om84Y12/x6dn4Kft3RKNNuvRu33si3QODEkp3DOq2RNjlC5ovblVE
         G3UryiQJrlaUDYIO2ZXr1SBeQmN8dYgc5KqNUlnwDLTCPk5tVsLbqC1Qa01MlU0fdwGs
         pHDrf5VQX/feY0r67svoSFElzASM+ocj2nDrLeUZI7xnei7/Bb+xpVZNlIaQtHVfnpeH
         QjTkjqkPW1dz07H+PZG/yukqHvMIVDzrJt8+7yc29RIAYgH47VA8e6FdEcE7ZSItBlv1
         roqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=I0YgTTuADCddU7gmQFiimvdU+bEYx4FI76LT0CJf50k=;
        b=Caga8XWxsB2ZVL2fjKUp17T4DVL9Dbb0HzADq9M7BWqZzCyGNFaA4/BcjYV6vP2A+2
         VbVxLrmFoK3aWrP1FfFhEUCZKuSS45xYg8fSyAzbrk8PwPBKiEdICvCmhMNjOl6SI1xc
         cOHC6bT2sSmUuOfd67E/pKi48nNvK4fy6LO4dKYCLa123VWNwztLuESwagR5MdOdbIzN
         3ZysZKXZ6A+YYTbIX5hcx0dU2i0A11TVQdcs8JMHO9eYX9vKgTuG/zjmrvoFto5Bgl+d
         J4lPjTySWor5yC3oMFKG1+eCrsCpgX8La3r/e1Q3ISS2O2uA/LrVMpZn1FdyaUZXRTmu
         ebVA==
X-Gm-Message-State: AOAM530H9SnLaOnyNFl2VJuVNT5Pu1RxV3J/mE/E+YEdj8qkpP+5IcK8
        fASpGrN/qvF2Qc9Lfn8hlwd2mpU91kU=
X-Google-Smtp-Source: ABdhPJzteeOdR219s7VgR2XpDpavvwOQHfDWKk4e7CibhAkBQS4q/EgxJG4LPRotVa6mT3PVcXfHbqXxObs=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a25:b993:: with SMTP id r19mr37069140ybg.445.1620148692865;
 Tue, 04 May 2021 10:18:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 10:17:32 -0700
In-Reply-To: <20210504171734.1434054-1-seanjc@google.com>
Message-Id: <20210504171734.1434054-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH 13/15] KVM: x86: Move uret MSR slot management to common x86
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that SVM and VMX both probe MSRs before "defining" user return slots
for them, consolidate the code for probe+define into common x86 and
eliminate the odd behavior of having the vendor code define the slot for
a given MSR.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/svm/svm.c          |  5 +----
 arch/x86/kvm/vmx/vmx.c          | 19 ++++---------------
 arch/x86/kvm/x86.c              | 19 +++++++++++--------
 4 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 10663610f105..a4b912f7e427 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1778,9 +1778,8 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 		    unsigned long ipi_bitmap_high, u32 min,
 		    unsigned long icr, int op_64_bit);
 
-void kvm_define_user_return_msr(unsigned index, u32 msr);
+int kvm_add_user_return_msr(u32 msr);
 int kvm_find_user_return_msr(u32 msr);
-int kvm_probe_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
 
 u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 231b9650d864..de921935e8de 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -959,10 +959,7 @@ static __init int svm_hardware_setup(void)
 		kvm_tsc_scaling_ratio_frac_bits = 32;
 	}
 
-	if (!kvm_probe_user_return_msr(MSR_TSC_AUX)) {
-		tsc_aux_uret_slot = 0;
-		kvm_define_user_return_msr(tsc_aux_uret_slot, MSR_TSC_AUX);
-	}
+	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
 
 	/* Check for pause filtering support */
 	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7a53568b34fc..26f82f302391 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -454,9 +454,6 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 
 static unsigned long host_idt_base;
 
-/* Number of user return MSRs that are actually supported in hardware. */
-static int vmx_nr_uret_msrs;
-
 #if IS_ENABLED(CONFIG_HYPERV)
 static bool __read_mostly enlightened_vmcs = true;
 module_param(enlightened_vmcs, bool, 0444);
@@ -1218,7 +1215,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 */
 	if (!vmx->guest_uret_msrs_loaded) {
 		vmx->guest_uret_msrs_loaded = true;
-		for (i = 0; i < vmx_nr_uret_msrs; ++i) {
+		for (i = 0; i < kvm_nr_uret_msrs; ++i) {
 			if (!vmx->guest_uret_msrs[i].load_into_hardware)
 				continue;
 
@@ -6921,7 +6918,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 			goto free_vpid;
 	}
 
-	for (i = 0; i < vmx_nr_uret_msrs; ++i) {
+	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
 		vmx->guest_uret_msrs[i].data = 0;
 		vmx->guest_uret_msrs[i].mask = -1ull;
 	}
@@ -7810,20 +7807,12 @@ static __init void vmx_setup_user_return_msrs(void)
 		MSR_EFER, MSR_TSC_AUX, MSR_STAR,
 		MSR_IA32_TSX_CTRL,
 	};
-	u32 msr;
 	int i;
 
 	BUILD_BUG_ON(ARRAY_SIZE(vmx_uret_msrs_list) != MAX_NR_USER_RETURN_MSRS);
 
-	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i) {
-		msr = vmx_uret_msrs_list[i];
-
-		if (kvm_probe_user_return_msr(msr))
-			continue;
-
-		kvm_define_user_return_msr(vmx_nr_uret_msrs, msr);
-		vmx_nr_uret_msrs++;
-	}
+	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i)
+		kvm_add_user_return_msr(vmx_uret_msrs_list[i]);
 }
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2fd46e917666..adca491d3b4b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -336,7 +336,7 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
 	}
 }
 
-int kvm_probe_user_return_msr(u32 msr)
+static int kvm_probe_user_return_msr(u32 msr)
 {
 	u64 val;
 	int ret;
@@ -350,16 +350,18 @@ int kvm_probe_user_return_msr(u32 msr)
 	preempt_enable();
 	return ret;
 }
-EXPORT_SYMBOL_GPL(kvm_probe_user_return_msr);
 
-void kvm_define_user_return_msr(unsigned slot, u32 msr)
+int kvm_add_user_return_msr(u32 msr)
 {
-	BUG_ON(slot >= KVM_MAX_NR_USER_RETURN_MSRS);
-	kvm_uret_msrs_list[slot] = msr;
-	if (slot >= kvm_nr_uret_msrs)
-		kvm_nr_uret_msrs = slot + 1;
+	BUG_ON(kvm_nr_uret_msrs >= KVM_MAX_NR_USER_RETURN_MSRS);
+
+	if (kvm_probe_user_return_msr(msr))
+		return -1;
+
+	kvm_uret_msrs_list[kvm_nr_uret_msrs] = msr;
+	return kvm_nr_uret_msrs++;
 }
-EXPORT_SYMBOL_GPL(kvm_define_user_return_msr);
+EXPORT_SYMBOL_GPL(kvm_add_user_return_msr);
 
 int kvm_find_user_return_msr(u32 msr)
 {
@@ -8169,6 +8171,7 @@ int kvm_arch_init(void *opaque)
 		printk(KERN_ERR "kvm: failed to allocate percpu kvm_user_return_msrs\n");
 		goto out_free_x86_emulator_cache;
 	}
+	kvm_nr_uret_msrs = 0;
 
 	r = kvm_mmu_module_init();
 	if (r)
-- 
2.31.1.527.g47e6f16901-goog

