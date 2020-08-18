Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D970F248FFB
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 23:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgHRVQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 17:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgHRVQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 17:16:32 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10676C061344
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:32 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id a73so13681616pfa.10
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 14:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Kg5p+9UFPcwoOh4MjqVj3yBHBG36CMVp7JVDzZvMX88=;
        b=NPGxFDC7z+atzMOgbMawAlozyDT43uLCTihArBAMRHNtMk5RcGD2HpdlkoxZpFo5ov
         oyXCLTe0X/YAg+NeRgMOv/ZiS77CweIm0sDpRjYBip8c8tmvcalXseGbp2RfJjcGGYcq
         Gh7kU1psD4Sz0bjc+UYF5rujtezAgrNg9AXodBbY2ZQttszqwBW7j3jZq1ehbLSfLR9v
         y9euc/ZcYuciyxtzcYLzH1462tTZdkoODhmANedn/7ilwYMfgzUhf9tPMOlapHKg4LZV
         WGPNNjkFQQchZYONc23pSFHlG2y7X1iQGE7zwK2y35zNfvhryne9AV1xccdVbnssLQDm
         LAgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Kg5p+9UFPcwoOh4MjqVj3yBHBG36CMVp7JVDzZvMX88=;
        b=r+9R9Ks2OwEv0yyUY5qfGxx8w2NedcHQ7JJU/IpA485VJ3X4Fu5+LUCD+LKc5obur1
         VHyMElDA4+8Pjz7YpWW7ho1WYVEmP993QsuNbAWlNUrLvdGnIHYSvhwJgjc9khB1HR8I
         vLL9OpaS8Rp0EHJdYhecAY8l9lx9apQUP4E1FRXPvDZvKIlBXhNZDmVkiwGmVpdVa8pU
         aX/KCgu91MYXGRSiEAPVPby3Cmz+kLQN2XXOZCfdDb1ox2ikgtw1uBc/F4DyX6+Dakog
         SUqgB5pRThLi+b1ZS0Wgv0UfMhLumg6TCAakVHdXg9ubZoyQKjCJSpiTzegwzY0ehtOw
         So+Q==
X-Gm-Message-State: AOAM533TlSZMBVkbATK3yFV9BtsDjo0Tofl4bOM6lx0IipVRfCkmo04z
        PMK28iqOGTgXMsQB0fQ8307pXLTNWzGiWbrN
X-Google-Smtp-Source: ABdhPJwGBELoFzsBhoyeOi2WysU7aJbVTXEaGPbBImwUIZjs15VWQTKIzEtJKP4c8VsMs2vbgNTExBAOyrBllWZ6
X-Received: from aaronlewis1.sea.corp.google.com ([2620:15c:100:202:a28c:fdff:fed8:8d46])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:f014:: with SMTP id
 bt20mr390165pjb.0.1597785391241; Tue, 18 Aug 2020 14:16:31 -0700 (PDT)
Date:   Tue, 18 Aug 2020 14:15:28 -0700
In-Reply-To: <20200818211533.849501-1-aaronlewis@google.com>
Message-Id: <20200818211533.849501-7-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200818211533.849501-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v3 06/12] KVM: x86: Prepare MSR bitmaps for userspace tracked MSRs
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prepare vmx and svm for a subsequent change that ensures the MSR permission
bitmap is set to allow an MSR that userspace is tracking to force a vmx_vmexit
in the guest.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/svm/svm.c    | 48 +++++++++++-----------
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 83 +++++++++++++++++++--------------------
 arch/x86/kvm/vmx/vmx.h    |  2 +-
 4 files changed, 67 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 03dd7bac8034..56e9cf284c2a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -564,7 +564,7 @@ static bool valid_msr_intercept(u32 index)
 	return false;
 }
 
-static bool msr_write_intercepted(struct kvm_vcpu *vcpu, unsigned msr)
+static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 {
 	u8 bit_write;
 	unsigned long tmp;
@@ -583,9 +583,11 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, unsigned msr)
 	return !!test_bit(bit_write,  &tmp);
 }
 
-static void set_msr_interception(u32 *msrpm, unsigned msr,
-				 int read, int write)
+static void set_msr_interception(struct kvm_vcpu *vcpu, u32 msr, int read,
+				 int write)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 *msrpm = svm->msrpm;
 	u8 bit_read, bit_write;
 	unsigned long tmp;
 	u32 offset;
@@ -609,7 +611,7 @@ static void set_msr_interception(u32 *msrpm, unsigned msr,
 	msrpm[offset] = tmp;
 }
 
-static void svm_vcpu_init_msrpm(u32 *msrpm)
+static void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm)
 {
 	int i;
 
@@ -619,7 +621,7 @@ static void svm_vcpu_init_msrpm(u32 *msrpm)
 		if (!direct_access_msrs[i].always)
 			continue;
 
-		set_msr_interception(msrpm, direct_access_msrs[i].index, 1, 1);
+		set_msr_interception(vcpu, direct_access_msrs[i].index, 1, 1);
 	}
 }
 
@@ -666,26 +668,26 @@ static void init_msrpm_offsets(void)
 	}
 }
 
-static void svm_enable_lbrv(struct vcpu_svm *svm)
+static void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
-	u32 *msrpm = svm->msrpm;
+	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
+	set_msr_interception(vcpu, MSR_IA32_LASTBRANCHFROMIP, 1, 1);
+	set_msr_interception(vcpu, MSR_IA32_LASTBRANCHTOIP, 1, 1);
+	set_msr_interception(vcpu, MSR_IA32_LASTINTFROMIP, 1, 1);
+	set_msr_interception(vcpu, MSR_IA32_LASTINTTOIP, 1, 1);
 }
 
-static void svm_disable_lbrv(struct vcpu_svm *svm)
+static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
 {
-	u32 *msrpm = svm->msrpm;
+	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
-	set_msr_interception(msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTFROMIP, 0, 0);
-	set_msr_interception(msrpm, MSR_IA32_LASTINTTOIP, 0, 0);
+	set_msr_interception(vcpu, MSR_IA32_LASTBRANCHFROMIP, 0, 0);
+	set_msr_interception(vcpu, MSR_IA32_LASTBRANCHTOIP, 0, 0);
+	set_msr_interception(vcpu, MSR_IA32_LASTINTFROMIP, 0, 0);
+	set_msr_interception(vcpu, MSR_IA32_LASTINTTOIP, 0, 0);
 }
 
 void disable_nmi_singlestep(struct vcpu_svm *svm)
@@ -1211,10 +1213,10 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	clear_page(svm->nested.hsave);
 
 	svm->msrpm = page_address(msrpm_pages);
-	svm_vcpu_init_msrpm(svm->msrpm);
+	svm_vcpu_init_msrpm(vcpu, svm->msrpm);
 
 	svm->nested.msrpm = page_address(nested_msrpm_pages);
-	svm_vcpu_init_msrpm(svm->nested.msrpm);
+	svm_vcpu_init_msrpm(vcpu, svm->nested.msrpm);
 
 	svm->vmcb = page_address(page);
 	clear_page(svm->vmcb);
@@ -2556,7 +2558,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		 * We update the L1 MSR bit as well since it will end up
 		 * touching the MSR anyway now.
 		 */
-		set_msr_interception(svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+		set_msr_interception(vcpu, MSR_IA32_SPEC_CTRL, 1, 1);
 		break;
 	case MSR_IA32_PRED_CMD:
 		if (!msr->host_initiated &&
@@ -2571,7 +2573,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			break;
 
 		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
-		set_msr_interception(svm->msrpm, MSR_IA32_PRED_CMD, 0, 1);
+		set_msr_interception(vcpu, MSR_IA32_PRED_CMD, 0, 1);
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr->host_initiated &&
@@ -2635,9 +2637,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->vmcb->save.dbgctl = data;
 		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
 		if (data & (1ULL<<0))
-			svm_enable_lbrv(svm);
+			svm_enable_lbrv(vcpu);
 		else
-			svm_disable_lbrv(svm);
+			svm_disable_lbrv(vcpu);
 		break;
 	case MSR_VM_HSAVE_PA:
 		svm->nested.hsave_msr = data;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 23b58c28a1c9..d50eaaf36f70 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4752,7 +4752,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 
 	if (vmx_pt_mode_is_host_guest()) {
 		vmx->pt_desc.guest.ctl = 0;
-		pt_update_intercept_for_msr(vmx);
+		pt_update_intercept_for_msr(vcpu);
 	}
 
 	return 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 46ba2e03a892..de03df72e742 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -343,7 +343,7 @@ module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
 
 static bool guest_state_valid(struct kvm_vcpu *vcpu);
 static u32 vmx_segment_access_rights(struct kvm_segment *var);
-static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
+static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
 							  u32 msr, int type);
 
 void vmx_vmexit(void);
@@ -2082,7 +2082,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * in the merging. We update the vmcs01 here for L1 as well
 		 * since it will end up touching the MSR anyway now.
 		 */
-		vmx_disable_intercept_for_msr(vmx->vmcs01.msr_bitmap,
+		vmx_disable_intercept_for_msr(vcpu,
 					      MSR_IA32_SPEC_CTRL,
 					      MSR_TYPE_RW);
 		break;
@@ -2118,8 +2118,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * vmcs02.msr_bitmap here since it gets completely overwritten
 		 * in the merging.
 		 */
-		vmx_disable_intercept_for_msr(vmx->vmcs01.msr_bitmap, MSR_IA32_PRED_CMD,
-					      MSR_TYPE_W);
+		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W);
 		break;
 	case MSR_IA32_CR_PAT:
 		if (!kvm_pat_valid(data))
@@ -2169,7 +2168,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vmcs_write64(GUEST_IA32_RTIT_CTL, data);
 		vmx->pt_desc.guest.ctl = data;
-		pt_update_intercept_for_msr(vmx);
+		pt_update_intercept_for_msr(vcpu);
 		break;
 	case MSR_IA32_RTIT_STATUS:
 		if (!pt_can_write_msr(vmx))
@@ -3688,9 +3687,11 @@ void free_vpid(int vpid)
 	spin_unlock(&vmx_vpid_lock);
 }
 
-static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
+static __always_inline void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu,
 							  u32 msr, int type)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
 	int f = sizeof(unsigned long);
 
 	if (!cpu_has_vmx_msr_bitmap())
@@ -3726,9 +3727,11 @@ static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bit
 	}
 }
 
-static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitmap,
+static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 							 u32 msr, int type)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
 	int f = sizeof(unsigned long);
 
 	if (!cpu_has_vmx_msr_bitmap())
@@ -3764,13 +3767,13 @@ static __always_inline void vmx_enable_intercept_for_msr(unsigned long *msr_bitm
 	}
 }
 
-static __always_inline void vmx_set_intercept_for_msr(unsigned long *msr_bitmap,
-			     			      u32 msr, int type, bool value)
+static __always_inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
+						      u32 msr, int type, bool value)
 {
 	if (value)
-		vmx_enable_intercept_for_msr(msr_bitmap, msr, type);
+		vmx_enable_intercept_for_msr(vcpu, msr, type);
 	else
-		vmx_disable_intercept_for_msr(msr_bitmap, msr, type);
+		vmx_disable_intercept_for_msr(vcpu, msr, type);
 }
 
 static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
@@ -3788,8 +3791,8 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
 	return mode;
 }
 
-static void vmx_update_msr_bitmap_x2apic(unsigned long *msr_bitmap,
-					 u8 mode)
+static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu,
+					 unsigned long *msr_bitmap, u8 mode)
 {
 	int msr;
 
@@ -3804,11 +3807,11 @@ static void vmx_update_msr_bitmap_x2apic(unsigned long *msr_bitmap,
 		 * TPR reads and writes can be virtualized even if virtual interrupt
 		 * delivery is not in use.
 		 */
-		vmx_disable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_TASKPRI), MSR_TYPE_RW);
+		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TASKPRI), MSR_TYPE_RW);
 		if (mode & MSR_BITMAP_MODE_X2APIC_APICV) {
-			vmx_enable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_R);
-			vmx_disable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
-			vmx_disable_intercept_for_msr(msr_bitmap, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
+			vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
+			vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
+			vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
 		}
 	}
 }
@@ -3824,30 +3827,24 @@ void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu)
 		return;
 
 	if (changed & (MSR_BITMAP_MODE_X2APIC | MSR_BITMAP_MODE_X2APIC_APICV))
-		vmx_update_msr_bitmap_x2apic(msr_bitmap, mode);
+		vmx_update_msr_bitmap_x2apic(vcpu, msr_bitmap, mode);
 
 	vmx->msr_bitmap_mode = mode;
 }
 
-void pt_update_intercept_for_msr(struct vcpu_vmx *vmx)
+void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
 {
-	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool flag = !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);
 	u32 i;
 
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_STATUS,
-							MSR_TYPE_RW, flag);
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_OUTPUT_BASE,
-							MSR_TYPE_RW, flag);
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_OUTPUT_MASK,
-							MSR_TYPE_RW, flag);
-	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_RTIT_CR3_MATCH,
-							MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_STATUS, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_OUTPUT_BASE, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_OUTPUT_MASK, MSR_TYPE_RW, flag);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_CR3_MATCH, MSR_TYPE_RW, flag);
 	for (i = 0; i < vmx->pt_desc.addr_range; i++) {
-		vmx_set_intercept_for_msr(msr_bitmap,
-			MSR_IA32_RTIT_ADDR0_A + i * 2, MSR_TYPE_RW, flag);
-		vmx_set_intercept_for_msr(msr_bitmap,
-			MSR_IA32_RTIT_ADDR0_B + i * 2, MSR_TYPE_RW, flag);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_ADDR0_A + i * 2, MSR_TYPE_RW, flag);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_RTIT_ADDR0_B + i * 2, MSR_TYPE_RW, flag);
 	}
 }
 
@@ -6980,18 +6977,18 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 		goto free_pml;
 
 	msr_bitmap = vmx->vmcs01.msr_bitmap;
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_TSC, MSR_TYPE_R);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_FS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_GS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
-	vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
+	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
+	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
 	if (kvm_cstate_in_guest(vcpu->kvm)) {
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C1_RES, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
-		vmx_disable_intercept_for_msr(msr_bitmap, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
 	}
 	vmx->msr_bitmap_mode = 0;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 26175a4759fa..8767d5c30bf1 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -351,7 +351,7 @@ bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
 void vmx_set_nmi_mask(struct kvm_vcpu *vcpu, bool masked);
 void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
-void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
+void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
 int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
 int vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
-- 
2.28.0.220.ged08abb693-goog

