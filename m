Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9C646CA9D
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 02:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243843AbhLHB7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 20:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243617AbhLHB7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 20:59:01 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55043C0698E0
        for <kvm@vger.kernel.org>; Tue,  7 Dec 2021 17:55:24 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id x18-20020a17090a789200b001a7317f995cso2733159pjk.4
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 17:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=PCuzB5pfHw4IaCRSemTFnysvFEMuEDu5PRfQ3pPXwxU=;
        b=b1FC/n1ztxU8zvUrnOhZn3XdiSr0dCb6A/dlGBMbmHabbL+76rVM/F0TVrUhZkMPRk
         XStcD8hkcpEUXS+Rq0kJi558TKgDPXvBbtQB0Q3x0prBC7n1A0ueUU/hkDqWHVeVasi+
         Ww9Dw5JiOmX2Bx/9R4sPbBAcrxaIgTDQssChK3mssNl8xLTwxL99H8mam326B7KAMtoU
         65ju2G52IlJpFbdE70UhB/CIlc/L5PGvwsc3ee/xloIgaDYHqWOj7MWWCpwx7A/Nn6Ea
         AkrvrERWjT81qiic9QmsmYueXS89fvaMhUFcNyaS1JxEKUmGSbMuHrAU3aqa+Jp4sNdJ
         svOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=PCuzB5pfHw4IaCRSemTFnysvFEMuEDu5PRfQ3pPXwxU=;
        b=2jcroB+b0Kd9uwbh7u8+ib4k4SeLzIzxAqO6oNfqs7Y3TwPOFJ6jbGDQPUl3aa2HxJ
         6jc76CEoyK/5sUbkVBtUAJHglan2zyBYnRrOzleuTO7DK8pDFAgvHuSixsxs/HOVPfo+
         Mb15vJR5uawL3WAspdeumOKvgzdUEx7vKWs6M/VlJNEMeQdFuJUe1at611Z1bRtF/pPL
         RuzZg7YiBA7Nl/MslxggM2gmISyfVPE1hZ/lA/LTfyx4+0V17TZIEXMhxUz+D4Vj0UR9
         gHM3rX/DoCWSHzP2e0KdKelUhVx/ZwwzBqRMv1ioRZXQjDlcZ3etrkMiHSZ916nL5cN8
         AP5Q==
X-Gm-Message-State: AOAM532pyr8pIjKARsP61hckqJpyp77RFsjtD2TyNb+AyOpcDfDaByH/
        YuoE6OhVPMuWH5NURXy8HcwM5fVWSSQ=
X-Google-Smtp-Source: ABdhPJyu1ad+rkG1Jli7pOqvOhrEW73pKVgwhUaTZwl3Uau9sm2aNGKsbVSDI2Tz1J+1NHg0lqSljVJy3tI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:590d:: with SMTP id
 k13mr3456418pji.184.1638928523872; Tue, 07 Dec 2021 17:55:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Dec 2021 01:52:32 +0000
In-Reply-To: <20211208015236.1616697-1-seanjc@google.com>
Message-Id: <20211208015236.1616697-23-seanjc@google.com>
Mime-Version: 1.0
References: <20211208015236.1616697-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH v3 22/26] KVM: SVM: Move svm_hardware_setup() and its helpers
 below svm_x86_ops
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move svm_hardware_setup() below svm_x86_ops so that KVM can modify ops
during setup, e.g. the vcpu_(un)blocking hooks can be nullified if AVIC
is disabled or unsupported.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 466 ++++++++++++++++++++---------------------
 1 file changed, 233 insertions(+), 233 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dde0106ffc47..98f7c454a784 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -873,47 +873,6 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	}
 }
 
-/*
- * The default MMIO mask is a single bit (excluding the present bit),
- * which could conflict with the memory encryption bit. Check for
- * memory encryption support and override the default MMIO mask if
- * memory encryption is enabled.
- */
-static __init void svm_adjust_mmio_mask(void)
-{
-	unsigned int enc_bit, mask_bit;
-	u64 msr, mask;
-
-	/* If there is no memory encryption support, use existing mask */
-	if (cpuid_eax(0x80000000) < 0x8000001f)
-		return;
-
-	/* If memory encryption is not enabled, use existing mask */
-	rdmsrl(MSR_AMD64_SYSCFG, msr);
-	if (!(msr & MSR_AMD64_SYSCFG_MEM_ENCRYPT))
-		return;
-
-	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
-	mask_bit = boot_cpu_data.x86_phys_bits;
-
-	/* Increment the mask bit if it is the same as the encryption bit */
-	if (enc_bit == mask_bit)
-		mask_bit++;
-
-	/*
-	 * If the mask bit location is below 52, then some bits above the
-	 * physical addressing limit will always be reserved, so use the
-	 * rsvd_bits() function to generate the mask. This mask, along with
-	 * the present bit, will be used to generate a page fault with
-	 * PFER.RSV = 1.
-	 *
-	 * If the mask bit location is 52 (or above), then clear the mask.
-	 */
-	mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
-
-	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
-}
-
 static void svm_hardware_teardown(void)
 {
 	int cpu;
@@ -928,198 +887,6 @@ static void svm_hardware_teardown(void)
 	iopm_base = 0;
 }
 
-static __init void svm_set_cpu_caps(void)
-{
-	kvm_set_cpu_caps();
-
-	supported_xss = 0;
-
-	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
-	if (nested) {
-		kvm_cpu_cap_set(X86_FEATURE_SVM);
-
-		if (nrips)
-			kvm_cpu_cap_set(X86_FEATURE_NRIPS);
-
-		if (npt_enabled)
-			kvm_cpu_cap_set(X86_FEATURE_NPT);
-
-		if (tsc_scaling)
-			kvm_cpu_cap_set(X86_FEATURE_TSCRATEMSR);
-
-		/* Nested VM can receive #VMEXIT instead of triggering #GP */
-		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
-	}
-
-	/* CPUID 0x80000008 */
-	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
-	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
-		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
-
-	/* AMD PMU PERFCTR_CORE CPUID */
-	if (pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
-		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
-
-	/* CPUID 0x8000001F (SME/SEV features) */
-	sev_set_cpu_caps();
-}
-
-static __init int svm_hardware_setup(void)
-{
-	int cpu;
-	struct page *iopm_pages;
-	void *iopm_va;
-	int r;
-	unsigned int order = get_order(IOPM_SIZE);
-
-	/*
-	 * NX is required for shadow paging and for NPT if the NX huge pages
-	 * mitigation is enabled.
-	 */
-	if (!boot_cpu_has(X86_FEATURE_NX)) {
-		pr_err_ratelimited("NX (Execute Disable) not supported\n");
-		return -EOPNOTSUPP;
-	}
-	kvm_enable_efer_bits(EFER_NX);
-
-	iopm_pages = alloc_pages(GFP_KERNEL, order);
-
-	if (!iopm_pages)
-		return -ENOMEM;
-
-	iopm_va = page_address(iopm_pages);
-	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
-	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
-
-	init_msrpm_offsets();
-
-	supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
-
-	if (boot_cpu_has(X86_FEATURE_FXSR_OPT))
-		kvm_enable_efer_bits(EFER_FFXSR);
-
-	if (tsc_scaling) {
-		if (!boot_cpu_has(X86_FEATURE_TSCRATEMSR)) {
-			tsc_scaling = false;
-		} else {
-			pr_info("TSC scaling supported\n");
-			kvm_has_tsc_control = true;
-			kvm_max_tsc_scaling_ratio = TSC_RATIO_MAX;
-			kvm_tsc_scaling_ratio_frac_bits = 32;
-		}
-	}
-
-	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
-
-	/* Check for pause filtering support */
-	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
-		pause_filter_count = 0;
-		pause_filter_thresh = 0;
-	} else if (!boot_cpu_has(X86_FEATURE_PFTHRESHOLD)) {
-		pause_filter_thresh = 0;
-	}
-
-	if (nested) {
-		printk(KERN_INFO "kvm: Nested Virtualization enabled\n");
-		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
-	}
-
-	/*
-	 * KVM's MMU doesn't support using 2-level paging for itself, and thus
-	 * NPT isn't supported if the host is using 2-level paging since host
-	 * CR4 is unchanged on VMRUN.
-	 */
-	if (!IS_ENABLED(CONFIG_X86_64) && !IS_ENABLED(CONFIG_X86_PAE))
-		npt_enabled = false;
-
-	if (!boot_cpu_has(X86_FEATURE_NPT))
-		npt_enabled = false;
-
-	/* Force VM NPT level equal to the host's paging level */
-	kvm_configure_mmu(npt_enabled, get_npt_level(),
-			  get_npt_level(), PG_LEVEL_1G);
-	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
-
-	/* Note, SEV setup consumes npt_enabled. */
-	sev_hardware_setup();
-
-	svm_hv_hardware_setup();
-
-	svm_adjust_mmio_mask();
-
-	for_each_possible_cpu(cpu) {
-		r = svm_cpu_init(cpu);
-		if (r)
-			goto err;
-	}
-
-	if (nrips) {
-		if (!boot_cpu_has(X86_FEATURE_NRIPS))
-			nrips = false;
-	}
-
-	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
-
-	if (enable_apicv) {
-		pr_info("AVIC enabled\n");
-
-		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
-	}
-
-	if (vls) {
-		if (!npt_enabled ||
-		    !boot_cpu_has(X86_FEATURE_V_VMSAVE_VMLOAD) ||
-		    !IS_ENABLED(CONFIG_X86_64)) {
-			vls = false;
-		} else {
-			pr_info("Virtual VMLOAD VMSAVE supported\n");
-		}
-	}
-
-	if (boot_cpu_has(X86_FEATURE_SVME_ADDR_CHK))
-		svm_gp_erratum_intercept = false;
-
-	if (vgif) {
-		if (!boot_cpu_has(X86_FEATURE_VGIF))
-			vgif = false;
-		else
-			pr_info("Virtual GIF supported\n");
-	}
-
-	if (lbrv) {
-		if (!boot_cpu_has(X86_FEATURE_LBRV))
-			lbrv = false;
-		else
-			pr_info("LBR virtualization supported\n");
-	}
-
-	if (!pmu)
-		pr_info("PMU virtualization is disabled\n");
-
-	svm_set_cpu_caps();
-
-	/*
-	 * It seems that on AMD processors PTE's accessed bit is
-	 * being set by the CPU hardware before the NPF vmexit.
-	 * This is not expected behaviour and our tests fail because
-	 * of it.
-	 * A workaround here is to disable support for
-	 * GUEST_MAXPHYADDR < HOST_MAXPHYADDR if NPT is enabled.
-	 * In this case userspace can know if there is support using
-	 * KVM_CAP_SMALLER_MAXPHYADDR extension and decide how to handle
-	 * it
-	 * If future AMD CPU models change the behaviour described above,
-	 * this variable can be changed accordingly
-	 */
-	allow_smaller_maxphyaddr = !npt_enabled;
-
-	return 0;
-
-err:
-	svm_hardware_teardown();
-	return r;
-}
-
 static void init_seg(struct vmcb_seg *seg)
 {
 	seg->selector = 0;
@@ -4714,6 +4481,239 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 };
 
+/*
+ * The default MMIO mask is a single bit (excluding the present bit),
+ * which could conflict with the memory encryption bit. Check for
+ * memory encryption support and override the default MMIO mask if
+ * memory encryption is enabled.
+ */
+static __init void svm_adjust_mmio_mask(void)
+{
+	unsigned int enc_bit, mask_bit;
+	u64 msr, mask;
+
+	/* If there is no memory encryption support, use existing mask */
+	if (cpuid_eax(0x80000000) < 0x8000001f)
+		return;
+
+	/* If memory encryption is not enabled, use existing mask */
+	rdmsrl(MSR_AMD64_SYSCFG, msr);
+	if (!(msr & MSR_AMD64_SYSCFG_MEM_ENCRYPT))
+		return;
+
+	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
+	mask_bit = boot_cpu_data.x86_phys_bits;
+
+	/* Increment the mask bit if it is the same as the encryption bit */
+	if (enc_bit == mask_bit)
+		mask_bit++;
+
+	/*
+	 * If the mask bit location is below 52, then some bits above the
+	 * physical addressing limit will always be reserved, so use the
+	 * rsvd_bits() function to generate the mask. This mask, along with
+	 * the present bit, will be used to generate a page fault with
+	 * PFER.RSV = 1.
+	 *
+	 * If the mask bit location is 52 (or above), then clear the mask.
+	 */
+	mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
+
+	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
+}
+
+static __init void svm_set_cpu_caps(void)
+{
+	kvm_set_cpu_caps();
+
+	supported_xss = 0;
+
+	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
+	if (nested) {
+		kvm_cpu_cap_set(X86_FEATURE_SVM);
+
+		if (nrips)
+			kvm_cpu_cap_set(X86_FEATURE_NRIPS);
+
+		if (npt_enabled)
+			kvm_cpu_cap_set(X86_FEATURE_NPT);
+
+		if (tsc_scaling)
+			kvm_cpu_cap_set(X86_FEATURE_TSCRATEMSR);
+
+		/* Nested VM can receive #VMEXIT instead of triggering #GP */
+		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
+	}
+
+	/* CPUID 0x80000008 */
+	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
+	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
+		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
+
+	/* AMD PMU PERFCTR_CORE CPUID */
+	if (pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
+		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
+
+	/* CPUID 0x8000001F (SME/SEV features) */
+	sev_set_cpu_caps();
+}
+
+static __init int svm_hardware_setup(void)
+{
+	int cpu;
+	struct page *iopm_pages;
+	void *iopm_va;
+	int r;
+	unsigned int order = get_order(IOPM_SIZE);
+
+	/*
+	 * NX is required for shadow paging and for NPT if the NX huge pages
+	 * mitigation is enabled.
+	 */
+	if (!boot_cpu_has(X86_FEATURE_NX)) {
+		pr_err_ratelimited("NX (Execute Disable) not supported\n");
+		return -EOPNOTSUPP;
+	}
+	kvm_enable_efer_bits(EFER_NX);
+
+	iopm_pages = alloc_pages(GFP_KERNEL, order);
+
+	if (!iopm_pages)
+		return -ENOMEM;
+
+	iopm_va = page_address(iopm_pages);
+	memset(iopm_va, 0xff, PAGE_SIZE * (1 << order));
+	iopm_base = page_to_pfn(iopm_pages) << PAGE_SHIFT;
+
+	init_msrpm_offsets();
+
+	supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
+
+	if (boot_cpu_has(X86_FEATURE_FXSR_OPT))
+		kvm_enable_efer_bits(EFER_FFXSR);
+
+	if (tsc_scaling) {
+		if (!boot_cpu_has(X86_FEATURE_TSCRATEMSR)) {
+			tsc_scaling = false;
+		} else {
+			pr_info("TSC scaling supported\n");
+			kvm_has_tsc_control = true;
+			kvm_max_tsc_scaling_ratio = TSC_RATIO_MAX;
+			kvm_tsc_scaling_ratio_frac_bits = 32;
+		}
+	}
+
+	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
+
+	/* Check for pause filtering support */
+	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
+		pause_filter_count = 0;
+		pause_filter_thresh = 0;
+	} else if (!boot_cpu_has(X86_FEATURE_PFTHRESHOLD)) {
+		pause_filter_thresh = 0;
+	}
+
+	if (nested) {
+		printk(KERN_INFO "kvm: Nested Virtualization enabled\n");
+		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
+	}
+
+	/*
+	 * KVM's MMU doesn't support using 2-level paging for itself, and thus
+	 * NPT isn't supported if the host is using 2-level paging since host
+	 * CR4 is unchanged on VMRUN.
+	 */
+	if (!IS_ENABLED(CONFIG_X86_64) && !IS_ENABLED(CONFIG_X86_PAE))
+		npt_enabled = false;
+
+	if (!boot_cpu_has(X86_FEATURE_NPT))
+		npt_enabled = false;
+
+	/* Force VM NPT level equal to the host's paging level */
+	kvm_configure_mmu(npt_enabled, get_npt_level(),
+			  get_npt_level(), PG_LEVEL_1G);
+	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
+
+	/* Note, SEV setup consumes npt_enabled. */
+	sev_hardware_setup();
+
+	svm_hv_hardware_setup();
+
+	svm_adjust_mmio_mask();
+
+	for_each_possible_cpu(cpu) {
+		r = svm_cpu_init(cpu);
+		if (r)
+			goto err;
+	}
+
+	if (nrips) {
+		if (!boot_cpu_has(X86_FEATURE_NRIPS))
+			nrips = false;
+	}
+
+	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
+
+	if (enable_apicv) {
+		pr_info("AVIC enabled\n");
+
+		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
+	}
+
+	if (vls) {
+		if (!npt_enabled ||
+		    !boot_cpu_has(X86_FEATURE_V_VMSAVE_VMLOAD) ||
+		    !IS_ENABLED(CONFIG_X86_64)) {
+			vls = false;
+		} else {
+			pr_info("Virtual VMLOAD VMSAVE supported\n");
+		}
+	}
+
+	if (boot_cpu_has(X86_FEATURE_SVME_ADDR_CHK))
+		svm_gp_erratum_intercept = false;
+
+	if (vgif) {
+		if (!boot_cpu_has(X86_FEATURE_VGIF))
+			vgif = false;
+		else
+			pr_info("Virtual GIF supported\n");
+	}
+
+	if (lbrv) {
+		if (!boot_cpu_has(X86_FEATURE_LBRV))
+			lbrv = false;
+		else
+			pr_info("LBR virtualization supported\n");
+	}
+
+	if (!pmu)
+		pr_info("PMU virtualization is disabled\n");
+
+	svm_set_cpu_caps();
+
+	/*
+	 * It seems that on AMD processors PTE's accessed bit is
+	 * being set by the CPU hardware before the NPF vmexit.
+	 * This is not expected behaviour and our tests fail because
+	 * of it.
+	 * A workaround here is to disable support for
+	 * GUEST_MAXPHYADDR < HOST_MAXPHYADDR if NPT is enabled.
+	 * In this case userspace can know if there is support using
+	 * KVM_CAP_SMALLER_MAXPHYADDR extension and decide how to handle
+	 * it
+	 * If future AMD CPU models change the behaviour described above,
+	 * this variable can be changed accordingly
+	 */
+	allow_smaller_maxphyaddr = !npt_enabled;
+
+	return 0;
+
+err:
+	svm_hardware_teardown();
+	return r;
+}
+
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
-- 
2.34.1.400.ga245620fadb-goog

