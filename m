Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF35526926
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 20:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383272AbiEMSVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 14:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383299AbiEMSVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 14:21:11 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B093C6D4D4
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:21:09 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id t15-20020a17090a3b4f00b001d67e27715dso6579952pjf.0
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=X72LoLVnC1OCMIJrr9dnEWK48TpcsQG8PSeJEATX4wQ=;
        b=LYvU8hmj14eCLU5Anu2e3VHNYawiouiIXgZCbbpLaFKkIPoc/LUzBuFv2MR8MKDtKV
         cRFXBgcGWejhfhzCSFHKFN/tP102wEgJfVLDbClUC+kRM824/ltllfwfB2rBw2Pmtmt3
         Xk8GV/UcsFOvZblycXPuceD9EWFzT4WEjQjBE8H1aXp1bu8VN1pfuMJLoax/lJ7bgBcp
         5lWu5MsEhi+QPvLbSKYQ8FOGOkHGtlZMLFEEf/Ot8c11r7LcGejgC7yY/X2lIJnHpAl1
         Ey4tsmVPd4svd5z3N9zwtVOrNTGdrcmhkp7Vtw4Gt//W3wyzwr2tlWwDF73ueHyvP7p1
         Z20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=X72LoLVnC1OCMIJrr9dnEWK48TpcsQG8PSeJEATX4wQ=;
        b=JAGiepWlBz2tCMWzfGB7f8ImnPYtDQJ2ozpr82HfzMdGh8CUwebPqbae492TKHC7bw
         drtfXYJL6TUxvj98o0JDv1TqmOZfJQkp55wesBBEy2NAFHb5FJNhQNptwSORuV/hrDE+
         mpHQ3jEW4yu/dXamE0nNcuedbVfIGQ1rf8BJjp0q6MTKqQ19Pe3YiIjXhfiA76RACep0
         WUEyY+ZNz+L9A1EOp/dOCdB8WujZSsZq0oP1nQRGesg4T7zAeIXg/Ma1Q8EF2LIvHDtw
         pq7oaOsye6/QeoG5uNXq0/miDOB6i4Hop94wepEf7BIv4uW/MowJrAZcWe7/Rp5zXQfr
         5lzw==
X-Gm-Message-State: AOAM531R+aETeehv7+Vr8G3KYMw5dWB8WxxuJ8vUolxiQFlMcQzi+sgj
        DsQqXYegY5ahc/bt2Y6NUKNjgBw4
X-Google-Smtp-Source: ABdhPJwoL3Dsw1JIYJxvDxYoiEuhUpq03AoaTAT+G33g5ME3AdfrinD6wwLNlWgRKJPvT/AQDfhNZCyK
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:d883:9294:4cf5:a395])
 (user=juew job=sendgmr) by 2002:aa7:9255:0:b0:505:a44b:275c with SMTP id
 21-20020aa79255000000b00505a44b275cmr5840631pfp.40.1652466069208; Fri, 13 May
 2022 11:21:09 -0700 (PDT)
Date:   Fri, 13 May 2022 11:20:37 -0700
In-Reply-To: <20220513182038.2564643-1-juew@google.com>
Message-Id: <20220513182038.2564643-7-juew@google.com>
Mime-Version: 1.0
References: <20220513182038.2564643-1-juew@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v3 6/7] KVM: x86: Add emulation for MSR_IA32_MCx_CTL2 MSRs.
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>, Jue Wang <juew@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds the Corrected Machine Check Interrupt (CMCI) and
Uncorrectable Error No Action required (UCNA) emulation to KVM. The
former is implemented as a LVT CMCI vector. The emulation of UCNA share
the MCE emulation infrastructure.

In Machine Check Architecture (MCA), MCG_CMCI_P is the corrected MC error
counting/signaling extension present flag, bit 10 of MCG_CAP. When this
bit is set, it does not imply CMCI reported corrected MC or UCNA error
is supported across all MCA banks. Software should check the availability
on a bank by bank basis (i.e. bit 30 in individual IA32_MCi_CTL2 register).

Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/x86.c              | 130 ++++++++++++++++++++++----------
 2 files changed, 92 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ec9830d2aabf..639ef92d01d1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -800,6 +800,7 @@ struct kvm_vcpu_arch {
 	u64 mcg_ctl;
 	u64 mcg_ext_ctl;
 	u64 *mce_banks;
+	u64 *mci_ctl2_banks;
 
 	/* Cache MMIO info */
 	u64 mmio_gva;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2eaa6161b227..eab1398cefa5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3149,6 +3149,16 @@ static void kvmclock_sync_fn(struct work_struct *work)
 					KVMCLOCK_SYNC_PERIOD);
 }
 
+/* These helpers are safe iff @msr is known to be an MCx bank MSR. */
+static bool is_mci_control_msr(u32 msr)
+{
+	return (msr & 3) == 0;
+}
+static bool is_mci_status_msr(u32 msr)
+{
+	return (msr & 3) == 1;
+}
+
 /*
  * On AMD, HWCR[McStatusWrEn] controls whether setting MCi_STATUS results in #GP.
  */
@@ -3167,6 +3177,7 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	unsigned bank_num = mcg_cap & 0xff;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
+	u32 offset, last_msr;
 
 	switch (msr) {
 	case MSR_IA32_MCG_STATUS:
@@ -3180,32 +3191,50 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vcpu->arch.mcg_ctl = data;
 		break;
-	default:
-		if (msr >= MSR_IA32_MC0_CTL &&
-		    msr < MSR_IA32_MCx_CTL(bank_num)) {
-			u32 offset = array_index_nospec(
-				msr - MSR_IA32_MC0_CTL,
-				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
-
-			/* only 0 or all 1s can be written to IA32_MCi_CTL
-			 * some Linux kernels though clear bit 10 in bank 4 to
-			 * workaround a BIOS/GART TBL issue on AMD K8s, ignore
-			 * this to avoid an uncatched #GP in the guest
-			 */
-			if ((offset & 0x3) == 0 &&
-			    data != 0 && (data | (1 << 10)) != ~(u64)0)
-				return -1;
-
-			/* MCi_STATUS */
-			if (!msr_info->host_initiated &&
-			    (offset & 0x3) == 1 && data != 0) {
-				if (!can_set_mci_status(vcpu))
-					return -1;
-			}
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
+		last_msr = MSR_IA32_MCx_CTL2(bank_num) - 1;
+		if (msr > last_msr)
+			return 1;
 
-			vcpu->arch.mce_banks[offset] = data;
-			break;
-		}
+		if (!(mcg_cap & MCG_CMCI_P) && (data || !msr_info->host_initiated))
+			return 1;
+		/* An attempt to write a 1 to a reserved bit raises #GP */
+		if (data & ~(MCI_CTL2_CMCI_EN | MCI_CTL2_CMCI_THRESHOLD_MASK))
+			return 1;
+		offset = array_index_nospec(msr - MSR_IA32_MC0_CTL2,
+					    last_msr + 1 - MSR_IA32_MC0_CTL2);
+		vcpu->arch.mci_ctl2_banks[offset] = data;
+		break;
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
+		last_msr = MSR_IA32_MCx_CTL(bank_num) - 1;
+		if (msr > last_msr)
+			return 1;
+
+		/*
+		 * Only 0 or all 1s can be written to IA32_MCi_CTL, all other
+		 * values are architecturally undefined.  But, some Linux
+		 * kernels clear bit 10 in bank 4 to workaround a BIOS/GART TLB
+		 * issue on AMD K8s, allow bit 10 to be clear when setting all
+		 * other bits in order to avoid an uncaught #GP in the guest.
+		 */
+		if (is_mci_control_msr(msr) &&
+		    data != 0 && (data | (1 << 10)) != ~(u64)0)
+			return 1;
+
+		/*
+		 * All CPUs allow writing 0 to MCi_STATUS MSRs to clear the MSR.
+		 * AMD-based CPUs allow non-zero values, but if and only if
+		 * HWCR[McStatusWrEn] is set.
+		 */
+		if (!msr_info->host_initiated && is_mci_status_msr(msr) &&
+		    data != 0 && !can_set_mci_status(vcpu))
+			return 1;
+
+		offset = array_index_nospec(msr - MSR_IA32_MC0_CTL,
+					    last_msr + 1 - MSR_IA32_MC0_CTL);
+		vcpu->arch.mce_banks[offset] = data;
+		break;
+	default:
 		return 1;
 	}
 	return 0;
@@ -3489,7 +3518,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		}
 		break;
-	case 0x200 ... 0x2ff:
+	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
+	case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
 		return kvm_set_apic_base(vcpu, msr_info);
@@ -3646,6 +3676,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
 		return set_msr_mce(vcpu, msr_info);
 
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
@@ -3750,6 +3781,7 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	u64 data;
 	u64 mcg_cap = vcpu->arch.mcg_cap;
 	unsigned bank_num = mcg_cap & 0xff;
+	u32 offset, last_msr;
 
 	switch (msr) {
 	case MSR_IA32_P5_MC_ADDR:
@@ -3767,16 +3799,27 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	case MSR_IA32_MCG_STATUS:
 		data = vcpu->arch.mcg_status;
 		break;
-	default:
-		if (msr >= MSR_IA32_MC0_CTL &&
-		    msr < MSR_IA32_MCx_CTL(bank_num)) {
-			u32 offset = array_index_nospec(
-				msr - MSR_IA32_MC0_CTL,
-				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
+		last_msr = MSR_IA32_MCx_CTL2(bank_num) - 1;
+		if (msr > last_msr)
+			return 1;
 
-			data = vcpu->arch.mce_banks[offset];
-			break;
-		}
+		if (!(mcg_cap & MCG_CMCI_P) && !host)
+			return 1;
+		offset = array_index_nospec(msr - MSR_IA32_MC0_CTL2,
+					    last_msr + 1 - MSR_IA32_MC0_CTL2);
+		data = vcpu->arch.mci_ctl2_banks[offset];
+		break;
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
+		last_msr = MSR_IA32_MCx_CTL(bank_num) - 1;
+		if (msr > last_msr)
+			return 1;
+
+		offset = array_index_nospec(msr - MSR_IA32_MC0_CTL,
+					    last_msr + 1 - MSR_IA32_MC0_CTL);
+		data = vcpu->arch.mce_banks[offset];
+		break;
+	default:
 		return 1;
 	}
 	*pdata = data;
@@ -3873,7 +3916,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	}
 	case MSR_MTRRcap:
-	case 0x200 ... 0x2ff:
+	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
+	case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
 		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
 	case 0xcd: /* fsb frequency */
 		msr_info->data = 3;
@@ -3989,6 +4033,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
 		return get_msr_mce(vcpu, msr_info->index, &msr_info->data,
 				   msr_info->host_initiated);
 	case MSR_IA32_XSS:
@@ -4740,9 +4785,12 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 	/* Init IA32_MCG_CTL to all 1s */
 	if (mcg_cap & MCG_CTL_P)
 		vcpu->arch.mcg_ctl = ~(u64)0;
-	/* Init IA32_MCi_CTL to all 1s */
-	for (bank = 0; bank < bank_num; bank++)
+	/* Init IA32_MCi_CTL to all 1s, IA32_MCi_CTL2 to all 0s */
+	for (bank = 0; bank < bank_num; bank++) {
 		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
+		if (mcg_cap & MCG_CMCI_P)
+			vcpu->arch.mci_ctl2_banks[bank] = 0;
+	}
 
 	static_call(kvm_x86_setup_mce)(vcpu);
 out:
@@ -11128,7 +11176,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mce_banks = kcalloc(KVM_MAX_MCE_BANKS * 4, sizeof(u64),
 				       GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.mce_banks)
+	vcpu->arch.mci_ctl2_banks = kcalloc(KVM_MAX_MCE_BANKS, sizeof(u64),
+					    GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.mce_banks || !vcpu->arch.mci_ctl2_banks)
 		goto fail_free_pio_data;
 	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
 
@@ -11181,6 +11231,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 fail_free_mce_banks:
 	kfree(vcpu->arch.mce_banks);
+	kfree(vcpu->arch.mci_ctl2_banks);
 fail_free_pio_data:
 	free_page((unsigned long)vcpu->arch.pio_data);
 fail_free_lapic:
@@ -11225,6 +11276,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_hv_vcpu_uninit(vcpu);
 	kvm_pmu_destroy(vcpu);
 	kfree(vcpu->arch.mce_banks);
+	kfree(vcpu->arch.mci_ctl2_banks);
 	kvm_free_lapic(vcpu);
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_mmu_destroy(vcpu);
-- 
2.36.0.550.gb090851708-goog

