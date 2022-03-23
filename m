Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA724E585F
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 19:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343499AbiCWSab (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 14:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiCWSa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 14:30:29 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B02938184
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:28:59 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id v10-20020a17090a0c8a00b001c7a548e4f7so736159pja.2
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7XBw7WG7y3oSmvKR8Q6YH60zgDqKUaqajgXOKo47DUA=;
        b=GAnWyELH9WO7oWzy7OgzvGfsUrRSyQezFLku3hiAfzpyVmh4U6InQ8l7c/YNwHAS7u
         CwcHbyRc7TkdSXSKN6gtR4YiJHH326rok64hGj39c/1gy/byLdRC6WTKsbIgXIZyt2y4
         WsfWP4wmsvshRwy4eQkn3LbOQxmeB3JmX6PApvSdTSlMkqRT/h5SlJADPbX+5kBc0kI4
         huz5HHVEwzST1jMZuCwOS5+nAQR4OeFCuh5oSS0ERQIX3TuvJ43atJZ0inm3En3p3viM
         i7KF44Im5n1DNRvmmaRkmnzVgFsH0A5RF4TbjBheYj4z5XLngxwUf/FmLd1mqsOovQH8
         oIbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7XBw7WG7y3oSmvKR8Q6YH60zgDqKUaqajgXOKo47DUA=;
        b=7HyAMbCwE5WjILh6zVcwdJV/NXOZpmN96PxyMUz5SHI9gapqNvjNzjHCw+bmzKXixy
         VkJ8dcco03+Twfc3OqYpSBltN3ReLmBNzspiZ8uO791qh/k0nBUZ1+48bSfPddni8Sxo
         vQwbTYAa/ibbUzakLSRLNvKiKZF3dqulyqIdutlremyhOoljp3UVb42dtI36rnmgHQC/
         jk1ihWmTiRDUJF60x1K0csQmW3p6XBhUWacvsUZrBh4HX22ZM5Lc/mZeCI8ygYi2So6+
         cmJBwbrkYaGufQGQPTTNJq0AjEDrQbhLWXJku7zm+xfRexOw8YkmdIat3ZgcwvKRVmrn
         9NsQ==
X-Gm-Message-State: AOAM530XPcNVJ/IwQJnwOZHiA7zmm2XfsZ1MgPAwLA2b/Ksy4TuBinc9
        yyw75blCJ8nYBmNS3haQ7PCT4A2p
X-Google-Smtp-Source: ABdhPJwxRpWH9QL/E+uNNg13YzHMK9Yq2IyyKWiLnCw6vb0N8ja63Oyz6i9Rt1MHP/8Jhb9CaYbtUJ8W
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:629e:dc12:a3fd:86de])
 (user=juew job=sendgmr) by 2002:a17:903:2ca:b0:14f:522c:d33c with SMTP id
 s10-20020a17090302ca00b0014f522cd33cmr1327541plk.143.1648060138739; Wed, 23
 Mar 2022 11:28:58 -0700 (PDT)
Date:   Wed, 23 Mar 2022 11:28:16 -0700
Message-Id: <20220323182816.2179533-1-juew@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH] KVM: x86: Add support for CMCI and UCNA.
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Jue Wang <juew@google.com>
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

CMCI is supported since Nehalem. UCNA (uncorrectable no action required)
errors signaled via CMCI allows a guest to be notified as soon as
uncorrectable memory errors get detected by some background threads,
e.g., threads that migrate guest memory across hosts.

Upon receiving UCNAs, guest kernel isolates the poisoned pages from
future accesses much earlier than a potential fatal Machine Check
Exception due to accesses from a guest thread.

Add CMCI signaling based on the per vCPU opt-in of MCG_CMCI_P.

Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/include/asm/kvm_host.h |  11 +++
 arch/x86/kvm/lapic.c            |  65 ++++++++++++++----
 arch/x86/kvm/lapic.h            |   2 +-
 arch/x86/kvm/vmx/vmx.c          |   1 +
 arch/x86/kvm/x86.c              | 115 +++++++++++++++++++++++++++++---
 5 files changed, 171 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ec9830d2aabf..d57f3d1284a3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -613,6 +613,8 @@ struct kvm_vcpu_xen {
 	unsigned long evtchn_pending_sel;
 };
 
+#define KVM_MCA_REG_PER_BANK 5
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -799,6 +801,15 @@ struct kvm_vcpu_arch {
 	u64 mcg_status;
 	u64 mcg_ctl;
 	u64 mcg_ext_ctl;
+	/*
+	 * 5 registers per bank for up to KVM_MAX_MCE_BANKS.
+	 * Register order within each bank:
+	 * mce_banks[5 * bank]   - IA32_MCi_CTL
+	 * mce_banks[5 * bank + 1] - IA32_MCi_STATUS
+	 * mce_banks[5 * bank + 2] - IA32_MCi_ADDR
+	 * mce_banks[5 * bank + 3] - IA32_MCi_MISC
+	 * mce_banks[5 * bank + 4] - IA32_MCi_CTL2
+	 */
 	u64 *mce_banks;
 
 	/* Cache MMIO info */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9322e6340a74..b388eb82308a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -27,6 +27,7 @@
 #include <linux/math64.h>
 #include <linux/slab.h>
 #include <asm/processor.h>
+#include <asm/mce.h>
 #include <asm/msr.h>
 #include <asm/page.h>
 #include <asm/current.h>
@@ -53,8 +54,6 @@
 #define PRIu64 "u"
 #define PRIo64 "o"
 
-/* 14 is the version for Xeon and Pentium 8.4.8*/
-#define APIC_VERSION			(0x14UL | ((KVM_APIC_LVT_NUM - 1) << 16))
 #define LAPIC_MMIO_LENGTH		(1 << 12)
 /* followed define is not in apicdef.h */
 #define MAX_APIC_VECTOR			256
@@ -367,7 +366,10 @@ static inline int apic_lvt_nmi_mode(u32 lvt_val)
 void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 v = APIC_VERSION;
+	int lvt_num = vcpu->arch.mcg_cap & MCG_CMCI_P ? KVM_APIC_LVT_NUM :
+			KVM_APIC_LVT_NUM - 1;
+	/* 14 is the version for Xeon and Pentium 8.4.8*/
+	u32 v = 0x14UL | ((lvt_num - 1) << 16);
 
 	if (!lapic_in_kernel(vcpu))
 		return;
@@ -390,7 +392,8 @@ static const unsigned int apic_lvt_mask[KVM_APIC_LVT_NUM] = {
 	LVT_MASK | APIC_MODE_MASK,	/* LVTTHMR */
 	LVT_MASK | APIC_MODE_MASK,	/* LVTPC */
 	LINT_MASK, LINT_MASK,	/* LVT0-1 */
-	LVT_MASK		/* LVTERR */
+	LVT_MASK,		/* LVTERR */
+	LVT_MASK | APIC_MODE_MASK	/* LVTCMCI */
 };
 
 static int find_highest_vector(void *bitmap)
@@ -1405,6 +1408,9 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 		APIC_REG_MASK(APIC_TMCCT) |
 		APIC_REG_MASK(APIC_TDCR);
 
+	if (apic->vcpu->arch.mcg_cap & MCG_CMCI_P)
+		valid_reg_mask |= APIC_REG_MASK(APIC_LVTCMCI);
+
 	/* ARBPRI is not valid on x2APIC */
 	if (!apic_x2apic_mode(apic))
 		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI);
@@ -1993,6 +1999,18 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
 	}
 }
 
+static int kvm_lvt_reg_by_index(int i)
+{
+	if (i < 0 || i >= KVM_APIC_LVT_NUM) {
+		pr_warn("lvt register index out of bound: %i\n", i);
+		return 0;
+	}
+
+	if (i < KVM_APIC_LVT_NUM - 1)
+		return APIC_LVTT + 0x10 * i;
+	return APIC_LVTCMCI;
+}
+
 int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 {
 	int ret = 0;
@@ -2038,12 +2056,17 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		if (!(val & APIC_SPIV_APIC_ENABLED)) {
 			int i;
 			u32 lvt_val;
-
-			for (i = 0; i < KVM_APIC_LVT_NUM; i++) {
-				lvt_val = kvm_lapic_get_reg(apic,
-						       APIC_LVTT + 0x10 * i);
-				kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i,
-					     lvt_val | APIC_LVT_MASKED);
+			int lvt_reg;
+			int lvt_num = apic->vcpu->arch.mcg_cap & MCG_CMCI_P ?
+					KVM_APIC_LVT_NUM : KVM_APIC_LVT_NUM - 1;
+
+			for (i = 0; i < lvt_num; i++) {
+				lvt_reg = kvm_lvt_reg_by_index(i);
+				if (lvt_reg) {
+					lvt_val = kvm_lapic_get_reg(apic, lvt_reg);
+					kvm_lapic_set_reg(apic, lvt_reg,
+							  lvt_val | APIC_LVT_MASKED);
+				}
 			}
 			apic_update_lvtt(apic);
 			atomic_set(&apic->lapic_timer.pending, 0);
@@ -2093,6 +2116,17 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		apic_update_lvtt(apic);
 		break;
 
+	case APIC_LVTCMCI:
+		if (!(apic->vcpu->arch.mcg_cap & MCG_CMCI_P)) {
+			ret = 1;
+			break;
+		}
+		if (!kvm_apic_sw_enabled(apic))
+			val |= APIC_LVT_MASKED;
+		val &= apic_lvt_mask[KVM_APIC_LVT_NUM - 1];
+		kvm_lapic_set_reg(apic, APIC_LVTCMCI, val);
+		break;
+
 	case APIC_TMICT:
 		if (apic_lvtt_tscdeadline(apic))
 			break;
@@ -2322,6 +2356,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u64 msr_val;
 	int i;
+	int lvt_num;
 
 	if (!init_event) {
 		msr_val = APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE;
@@ -2341,8 +2376,14 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
 	kvm_apic_set_version(apic->vcpu);
 
-	for (i = 0; i < KVM_APIC_LVT_NUM; i++)
-		kvm_lapic_set_reg(apic, APIC_LVTT + 0x10 * i, APIC_LVT_MASKED);
+	lvt_num = vcpu->arch.mcg_cap & MCG_CMCI_P ? KVM_APIC_LVT_NUM :
+			KVM_APIC_LVT_NUM - 1;
+	for (i = 0; i < lvt_num; i++) {
+		int lvt_reg = kvm_lvt_reg_by_index(i);
+
+		if (lvt_reg)
+			kvm_lapic_set_reg(apic, lvt_reg, APIC_LVT_MASKED);
+	}
 	apic_update_lvtt(apic);
 	if (kvm_vcpu_is_reset_bsp(vcpu) &&
 	    kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_LINT0_REENABLED))
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 2b44e533fc8d..e2ae097613ca 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -10,7 +10,7 @@
 
 #define KVM_APIC_INIT		0
 #define KVM_APIC_SIPI		1
-#define KVM_APIC_LVT_NUM	6
+#define KVM_APIC_LVT_NUM	7
 
 #define APIC_SHORT_MASK			0xc0000
 #define APIC_DEST_NOSHORT		0x0
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b730d799c26e..63aa2b3d30ca 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8035,6 +8035,7 @@ static __init int hardware_setup(void)
 	}
 
 	kvm_mce_cap_supported |= MCG_LMCE_P;
+	kvm_mce_cap_supported |= MCG_CMCI_P;
 
 	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
 		return -EINVAL;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eb4029660bd9..6626723bf51b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3180,6 +3180,25 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vcpu->arch.mcg_ctl = data;
 		break;
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
+		{
+			u32 offset;
+			/* BIT[30] - CMCI_ENABLE */
+			/* BIT[0:14] - CMCI_THRESHOLD */
+			u64 mask = (1 << 30) | 0x7fff;
+
+			if (!(mcg_cap & MCG_CMCI_P) &&
+			    (data || !msr_info->host_initiated))
+				return 1;
+			/* An attempt to write a 1 to a reserved bit raises #GP*/
+			if (data & ~mask)
+				return 1;
+			offset = array_index_nospec(
+				msr - MSR_IA32_MC0_CTL2,
+				MSR_IA32_MCx_CTL2(bank_num) - MSR_IA32_MC0_CTL2);
+			vcpu->arch.mce_banks[offset * KVM_MCA_REG_PER_BANK + 4] = (data & mask);
+		}
+		break;
 	default:
 		if (msr >= MSR_IA32_MC0_CTL &&
 		    msr < MSR_IA32_MCx_CTL(bank_num)) {
@@ -3203,7 +3222,14 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 					return -1;
 			}
 
-			vcpu->arch.mce_banks[offset] = data;
+			/* MSR_IA32_MCi_CTL addresses are incremented by 4 bytes
+			 * per bank.
+			 * kvm_vcpu_arch.mce_banks has 5 registers per bank, see
+			 * register layout details in kvm_host.h.
+			 * MSR_IA32_MCi_CTL is the first register in each bank
+			 * within kvm_vcpu_arch.mce_banks.
+			 */
+			vcpu->arch.mce_banks[offset * KVM_MCA_REG_PER_BANK / 4] = data;
 			break;
 		}
 		return 1;
@@ -3489,7 +3515,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		}
 		break;
-	case 0x200 ... 0x2ff:
+	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
+	case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
 		return kvm_set_apic_base(vcpu, msr_info);
@@ -3646,6 +3673,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
 		return set_msr_mce(vcpu, msr_info);
 
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
@@ -3767,6 +3795,18 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	case MSR_IA32_MCG_STATUS:
 		data = vcpu->arch.mcg_status;
 		break;
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
+		{
+			u32 offset;
+
+			if (!(mcg_cap & MCG_CMCI_P) && !host)
+				return 1;
+			offset = array_index_nospec(
+				msr - MSR_IA32_MC0_CTL2,
+				MSR_IA32_MCx_CTL2(bank_num) - MSR_IA32_MC0_CTL2);
+			data = vcpu->arch.mce_banks[offset * KVM_MCA_REG_PER_BANK + 4];
+		}
+		break;
 	default:
 		if (msr >= MSR_IA32_MC0_CTL &&
 		    msr < MSR_IA32_MCx_CTL(bank_num)) {
@@ -3774,7 +3814,7 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 				msr - MSR_IA32_MC0_CTL,
 				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
 
-			data = vcpu->arch.mce_banks[offset];
+			data = vcpu->arch.mce_banks[offset * KVM_MCA_REG_PER_BANK / 4];
 			break;
 		}
 		return 1;
@@ -3873,7 +3913,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	}
 	case MSR_MTRRcap:
-	case 0x200 ... 0x2ff:
+	case 0x200 ... MSR_IA32_MC0_CTL2 - 1:
+	case MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) ... 0x2ff:
 		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
 	case 0xcd: /* fsb frequency */
 		msr_info->data = 3;
@@ -3989,6 +4030,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
 		return get_msr_mce(vcpu, msr_info->index, &msr_info->data,
 				   msr_info->host_initiated);
 	case MSR_IA32_XSS:
@@ -4740,15 +4782,64 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 	/* Init IA32_MCG_CTL to all 1s */
 	if (mcg_cap & MCG_CTL_P)
 		vcpu->arch.mcg_ctl = ~(u64)0;
-	/* Init IA32_MCi_CTL to all 1s */
-	for (bank = 0; bank < bank_num; bank++)
-		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
+	/* Init IA32_MCi_CTL to all 1s, IA32_MCi_CTL2 to all 0s */
+	for (bank = 0; bank < bank_num; bank++) {
+		vcpu->arch.mce_banks[bank * KVM_MCA_REG_PER_BANK] = ~(u64)0;
+		if (mcg_cap & MCG_CMCI_P)
+			vcpu->arch.mce_banks[bank * KVM_MCA_REG_PER_BANK + 4] = 0;
+	}
 
 	static_call(kvm_x86_setup_mce)(vcpu);
 out:
 	return r;
 }
 
+static bool is_ucna(u64 mcg_status, u64 mci_status)
+{
+	return !mcg_status &&
+		!(mci_status & (MCI_STATUS_PCC|MCI_STATUS_S|MCI_STATUS_AR));
+}
+
+static int kvm_vcpu_x86_set_ucna(struct kvm_vcpu *vcpu,
+				       struct kvm_x86_mce *mce)
+{
+	u64 mcg_cap = vcpu->arch.mcg_cap;
+	unsigned int bank_num = mcg_cap & 0xff;
+	u64 *banks = vcpu->arch.mce_banks;
+
+	/* Check for legal bank number in guest */
+	if (mce->bank >= bank_num)
+		return -EINVAL;
+
+	/* Disallow bits that are used for machine check signalling */
+	if (mce->mcg_status ||
+	    (mce->status & (MCI_STATUS_PCC|MCI_STATUS_S|MCI_STATUS_AR)))
+		return -EINVAL;
+
+	 /* UCNA must have VAL and UC bits set */
+	if ((mce->status & (MCI_STATUS_VAL|MCI_STATUS_UC)) !=
+	    (MCI_STATUS_VAL|MCI_STATUS_UC))
+		return -EINVAL;
+
+	banks += KVM_MCA_REG_PER_BANK * mce->bank;
+	banks[1] = mce->status;
+	banks[2] = mce->addr;
+	banks[3] = mce->misc;
+	vcpu->arch.mcg_status = mce->mcg_status;
+
+	/*
+	 * if MCG_CMCI_P is 0 or BIT[30] of IA32_MCi_CTL2 is 0, CMCI signaling
+	 * is disabled for the bank
+	 */
+	if (!(mcg_cap & MCG_CMCI_P) || !(banks[4] & (1 << 30)))
+		return 0;
+
+	if (lapic_in_kernel(vcpu))
+		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTCMCI);
+
+	return 0;
+}
+
 static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 				      struct kvm_x86_mce *mce)
 {
@@ -4758,14 +4849,18 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 
 	if (mce->bank >= bank_num || !(mce->status & MCI_STATUS_VAL))
 		return -EINVAL;
-	/*
+
+	if (is_ucna(mce->mcg_status, mce->status))
+		return kvm_vcpu_x86_set_ucna(vcpu, mce);
+
+		/*
 	 * if IA32_MCG_CTL is not all 1s, the uncorrected error
 	 * reporting is disabled
 	 */
 	if ((mce->status & MCI_STATUS_UC) && (mcg_cap & MCG_CTL_P) &&
 	    vcpu->arch.mcg_ctl != ~(u64)0)
 		return 0;
-	banks += 4 * mce->bank;
+	banks += KVM_MCA_REG_PER_BANK * mce->bank;
 	/*
 	 * if IA32_MCi_CTL is not all 1s, the uncorrected error
 	 * reporting is disabled for the bank
@@ -11126,7 +11221,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		goto fail_free_lapic;
 	vcpu->arch.pio_data = page_address(page);
 
-	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * 4,
+	vcpu->arch.mce_banks = kzalloc(KVM_MAX_MCE_BANKS * sizeof(u64) * KVM_MCA_REG_PER_BANK,
 				       GFP_KERNEL_ACCOUNT);
 	if (!vcpu->arch.mce_banks)
 		goto fail_free_pio_data;
-- 
2.35.1.1021.g381101b075-goog

