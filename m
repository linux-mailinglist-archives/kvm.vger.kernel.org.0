Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA61546B85
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 19:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350167AbiFJRMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 13:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348867AbiFJRL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 13:11:57 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A98A47ACD
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:56 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q62-20020a17090a17c400b001e31a482241so1454762pja.5
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oIputbaVwVPkteJPqyRoXgqBgs5iBwnPffzVStdAjCE=;
        b=ZIM4ETq5uZJxbxyy5GA/yYUdsF7+k1l0paNLOZy9U9yWb7aQkP2KXiwEAmH70VNxU4
         L0AwPPR9p86r40mcnrzAn+CXsKkEYOUGobC9fK96bYnVPqqIG2oFdhohPI5rdMNf13Sm
         Mx0GP9D3yWWXdS9TXul4DYmq6KT1w89SDbeXOHG1PqUEFyq+sa8sYNkdobNwuODHk2dH
         Zo1r2mGn0yXZR3xF8kDz25R28/SnJ3V0zX3EyNHnepe/SODP18VTEVsHxjIhqeWByQsX
         heMSrMWGELAQaB3jqhsoJ0xWs4And6XZd1yyMTtRh/S6AEFRwY35sQ5Q8sYcBaQVw8Na
         +IPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oIputbaVwVPkteJPqyRoXgqBgs5iBwnPffzVStdAjCE=;
        b=MJc+Ij/m6Tg6AhYkRysIukNEyFqxTNhVMghPGzgYfRO0wfu7QmkFeSETT7ShdV7Thz
         w55fK1ea0WM4I23oH5ceJWnC1PDhAGktN9amne+slW+wTazuP618N8vYOkOwENOqo8vc
         ffDvTvTfkqlAQGD6095/fxk2jaOl+RP343xJKYrO08ZKRJ4pQvVXjggHrLqeHCGDxyYb
         Gn6xWfD2gbf8NXsx+6mVa3ffmsenuDXKuJQI7UbB955//bI5P8mkT/jJRDFXa6Nxlwyh
         A3wmGQ3K6pXyjHclMTT7zV/voYzOAC1399sxqQbVJo63KpZcmjBug6ciMi9b4N5Yn29W
         Jdsg==
X-Gm-Message-State: AOAM531eU+Q7Kt4tuyi7xMJZpNeegaeU23aoT7MNw+WiflPIfRBT81nz
        E1L4jwSHa1q7j5DLIjbIBQygyEaa
X-Google-Smtp-Source: ABdhPJwYRvNIG+cUnM/4Nc9FFv7PKCCvf3adF22vpP+zIuWOP+2DRre0F6i9+VcGBSdCq5OKNqZWtbq6
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:9a6e:681b:67df:5cc4])
 (user=juew job=sendgmr) by 2002:a62:be14:0:b0:505:a43b:cf6e with SMTP id
 l20-20020a62be14000000b00505a43bcf6emr114172306pff.33.1654881115947; Fri, 10
 Jun 2022 10:11:55 -0700 (PDT)
Date:   Fri, 10 Jun 2022 10:11:32 -0700
In-Reply-To: <20220610171134.772566-1-juew@google.com>
Message-Id: <20220610171134.772566-7-juew@google.com>
Mime-Version: 1.0
References: <20220610171134.772566-1-juew@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v5 6/8] KVM: x86: Add emulation for MSR_IA32_MCx_CTL2 MSRs.
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

This patch adds the emulation of IA32_MCi_CTL2 registers to KVM. A
separate mci_ctl2_banks array is used to keep the existing mce_banks
register layout intact.

In Machine Check Architecture, in addition to MCG_CMCI_P, bit 30 of
the per-bank register IA32_MCi_CTL2 controls whether Corrected Machine
Check error reporting is enabled.

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
index 71d0e2a7b417..b18994907322 100644
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
 	vcpu->arch.apic->nr_lvt_entries =
 		KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
 
@@ -11228,7 +11276,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mce_banks = kcalloc(KVM_MAX_MCE_BANKS * 4, sizeof(u64),
 				       GFP_KERNEL_ACCOUNT);
-	if (!vcpu->arch.mce_banks)
+	vcpu->arch.mci_ctl2_banks = kcalloc(KVM_MAX_MCE_BANKS, sizeof(u64),
+					    GFP_KERNEL_ACCOUNT);
+	if (!vcpu->arch.mce_banks || !vcpu->arch.mci_ctl2_banks)
 		goto fail_free_pio_data;
 	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
 
@@ -11281,6 +11331,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
 fail_free_mce_banks:
 	kfree(vcpu->arch.mce_banks);
+	kfree(vcpu->arch.mci_ctl2_banks);
 fail_free_pio_data:
 	free_page((unsigned long)vcpu->arch.pio_data);
 fail_free_lapic:
@@ -11325,6 +11376,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_hv_vcpu_uninit(vcpu);
 	kvm_pmu_destroy(vcpu);
 	kfree(vcpu->arch.mce_banks);
+	kfree(vcpu->arch.mci_ctl2_banks);
 	kvm_free_lapic(vcpu);
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_mmu_destroy(vcpu);
-- 
2.36.1.255.ge46751e96f-goog

