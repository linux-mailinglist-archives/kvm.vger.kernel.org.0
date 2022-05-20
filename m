Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64BDE52F1BB
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 19:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352315AbiETRhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 13:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352291AbiETRg6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 13:36:58 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAB28CCDE
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:56 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id j23-20020aa78017000000b005180c6e4ef2so4546507pfi.12
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GkWWUJ5UHxNAMkMwmQ8pt3Dz4eac3cPZcPaxr3WNiBY=;
        b=YwyQ8S8284TzSQLhmWCpvf+otP9mk9dVBBrQuujKvlQKf7/VyhEZXz6a3o19skP7T6
         BkS5704oyu7u+E5COhBFVgsoYI/eO7WE+7QVRfXR0y1KGMVfzrkVLFdImReuBYW0cloY
         +m3bQrySDDS87yiS9vahC95njn25+9htpVwnBxxjq59YsxNjy1DVPpIfOPy22I/W+tTj
         OSdb9Yu+KkFaJV9MzB8R2oq5EpSNNQyPXOxPofbvSkLmTuQUAsfUe4QorN41PgtYNu7g
         rmuKAfxCtimg0ACY12Vr+kc3dQsX/Ne5f1hhWhvagEiuE6wv9QkK/xOlqalKWT1Ka8Ky
         aKTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GkWWUJ5UHxNAMkMwmQ8pt3Dz4eac3cPZcPaxr3WNiBY=;
        b=eCeJNGzrRAC2UFtCmxn5XI2CI88usU/miuM7pvY1iLVgFFQ/98ddZRSyAHqsn20yoJ
         v5hSQzNtxIPqyDV94kn7D+Hxsjac/eLdOT3lHAsaoiWPXqr4Jw4Ad66Al4TkvFpp4HaW
         3pmiLU1gC0bniYvHsCwpUilCa/b+tEeVDESOh4OqbALOkS7T5czfvAiYpPyTEu96Y9vM
         ZKVmuK7EdMwdRy8UqBMfuHPxvFgPbWkeorm6dXc2mHNIjXK7AjW4xwArLTObPsy9Zg3l
         3mBP5VKKtgllCNzeip3p4sjUQLiy9UL/WUmMXPuEZwdn53TYqz7obfO54njG6Fr7rzn3
         Q20A==
X-Gm-Message-State: AOAM530vUuLpqrCMO+fSH1alIKRNrRDCfqXz79YG/ib3O4AZlUeMpi5m
        64Z8fLOOMSzRQD8NfcIe2L8Xdfe8
X-Google-Smtp-Source: ABdhPJww4OQ7R2geI+UnDtj2h18YQ/m+7uHdW/mwiZ2s9dXuV13il9Z2dOyyZCKbo/hA/Bv4eHbzjzV7
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:4c5:ddc5:8182:560f])
 (user=juew job=sendgmr) by 2002:a17:90b:3b81:b0:1dc:32ac:a66b with SMTP id
 pc1-20020a17090b3b8100b001dc32aca66bmr12135469pjb.49.1653068216331; Fri, 20
 May 2022 10:36:56 -0700 (PDT)
Date:   Fri, 20 May 2022 10:36:36 -0700
In-Reply-To: <20220520173638.94324-1-juew@google.com>
Message-Id: <20220520173638.94324-7-juew@google.com>
Mime-Version: 1.0
References: <20220520173638.94324-1-juew@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 6/8] KVM: x86: Add emulation for MSR_IA32_MCx_CTL2 MSRs.
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>
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

Corrected Machine Check Interrupt (CMCI) can be configured via the per
Machine Check bank registers: IA32_MCi_CTL2. This patch adds the
emulation of IA32_MCi_CTL2 registers to KVM. A separate mci_ctl2_banks
array is used to keep the existing mce_banks register layout intact.

In Machine Check Architecture (MCA), MCG_CMCI_P (bit 10 of MCG_CAP) is
the corrected MC error counting/signaling extension present flag. When
this bit is set, it does not imply CMCI reported corrected error or UCNA
error is supported across all MCA banks. Software should check on a bank
by bank basis (i.e. if bit 30 in each IA32_MCi_CTL2 register is set).

Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/x86.c              | 130 ++++++++++++++++++++++----------
 2 files changed, 92 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4ff36610af6a..178b7e01bf8f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -806,6 +806,7 @@ struct kvm_vcpu_arch {
 	u64 mcg_ctl;
 	u64 mcg_ext_ctl;
 	u64 *mce_banks;
+	u64 *mci_ctl2_banks;
 
 	/* Cache MMIO info */
 	u64 mmio_gva;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0e839077ce52..f8ab592f519b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3174,6 +3174,16 @@ static void kvmclock_sync_fn(struct work_struct *work)
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
@@ -3192,6 +3202,7 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	unsigned bank_num = mcg_cap & 0xff;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
+	u32 offset, last_msr;
 
 	switch (msr) {
 	case MSR_IA32_MCG_STATUS:
@@ -3205,32 +3216,50 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -3514,7 +3543,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		}
 		break;
-	case 0x200 ... 0x2ff:
+	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
+	case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
 		return kvm_set_apic_base(vcpu, msr_info);
@@ -3671,6 +3701,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
 		return set_msr_mce(vcpu, msr_info);
 
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
@@ -3775,6 +3806,7 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	u64 data;
 	u64 mcg_cap = vcpu->arch.mcg_cap;
 	unsigned bank_num = mcg_cap & 0xff;
+	u32 offset, last_msr;
 
 	switch (msr) {
 	case MSR_IA32_P5_MC_ADDR:
@@ -3792,16 +3824,27 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
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
@@ -3898,7 +3941,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	}
 	case MSR_MTRRcap:
-	case 0x200 ... 0x2ff:
+	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
+	case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
 		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
 	case 0xcd: /* fsb frequency */
 		msr_info->data = 3;
@@ -4014,6 +4058,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
 		return get_msr_mce(vcpu, msr_info->index, &msr_info->data,
 				   msr_info->host_initiated);
 	case MSR_IA32_XSS:
@@ -4769,9 +4814,12 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
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
@@ -11226,7 +11274,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mce_banks = kcalloc(KVM_MAX_MCE_BANKS * 4, sizeof(u64),
 				       GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.mce_banks)
+	vcpu->arch.mci_ctl2_banks = kcalloc(KVM_MAX_MCE_BANKS, sizeof(u64),
+					    GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.mce_banks || !vcpu->arch.mci_ctl2_banks)
 		goto fail_free_pio_data;
 	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
 
@@ -11279,6 +11329,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 fail_free_mce_banks:
 	kfree(vcpu->arch.mce_banks);
+	kfree(vcpu->arch.mci_ctl2_banks);
 fail_free_pio_data:
 	free_page((unsigned long)vcpu->arch.pio_data);
 fail_free_lapic:
@@ -11323,6 +11374,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_hv_vcpu_uninit(vcpu);
 	kvm_pmu_destroy(vcpu);
 	kfree(vcpu->arch.mce_banks);
+	kfree(vcpu->arch.mci_ctl2_banks);
 	kvm_free_lapic(vcpu);
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_mmu_destroy(vcpu);
-- 
2.36.1.124.g0e6072fb45-goog

