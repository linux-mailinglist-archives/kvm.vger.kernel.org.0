Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0116B4AA287
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245218AbiBDVmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244216AbiBDVmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 16:42:36 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E614C06175B
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 13:42:23 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 127-20020a630585000000b0035de5e88314so3558300pgf.2
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=kNn5kmycZpHizGyMseukHBNM5EVLI5S3mexM+IcIDc8=;
        b=bsJgW4pUqug+LJkswu0nu9aMl6fltK/3EatKIY8F2+/GmNfGLy+IOjy3JpmcZCLLrr
         IBT8LGANUnGa03JrWtUG4C9deOJ9yvIdRrV5O9aPTkaRePCo3t+9LrTP29/vcjfF8XAY
         2eAp/Hx3uqkH1iJIh6Et38+OTJNUq27lX52V0/o9vBhudEHZtPxaaFINDKkqnnFpHO1h
         6lUNvF7DuKqwHMw+v6E9e1VX5X6I8QwyLgWa4TF88dIN3QqYi54DNAMvmZH4IW01iGbV
         KRPSQZreyNMBzbY0hijXTV807KbMwfHTrPW2bwtomFrGRJ+MK6WR0RGphFidoNJyXtOr
         s0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=kNn5kmycZpHizGyMseukHBNM5EVLI5S3mexM+IcIDc8=;
        b=PwsBOySq8l+X0RvyT2o5jLjT725ZxP6Su9ZaLlipmdcSUkGZ4eHHgnwvA9EkHxXcZe
         f6kXNA1Yjn4lAiLJfGCWbN8S7kVVJJa7c/p9iZ4GnwiSCBXCeOtq2m5XkXjqXIwv13Do
         iDNNUfc18nhGgnYT4hzbPK9r6raafSNBkxeeWEKG/H1k5Ms6Pjf07mzW4DY8bH55UeOw
         b+1vMgGs90FbY4y9I0uD/RGgvbu6VlhvkAjtWlaRaJMNL1LcW8awMOLCGWQvWhv3/zQX
         Zcf/IcZRWDHb5EWAvnTHPHkMIXvBvOxxhQ3xN8ERYMhMc3l/XVxSuWEQKEI4TPGP4KEy
         qJiw==
X-Gm-Message-State: AOAM532yodmp0C8/A/bY2drdkLD2hbAKIU/7mLUUtz1JpLmFG4uNsHLP
        XOoWsXYT/xTnnmTIf6PLA/Vs+Jjbbbo=
X-Google-Smtp-Source: ABdhPJyPHFn6HwwC2P0Wu06hsDDfrsaCIQB01NlsXbfqbAbN5H8aXAcZPGae3xOTnbxLfo+h9ZSL6C/Ut28=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:9a4b:: with SMTP id
 x11mr5212375plv.138.1644010942766; Fri, 04 Feb 2022 13:42:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  4 Feb 2022 21:42:03 +0000
In-Reply-To: <20220204214205.3306634-1-seanjc@google.com>
Message-Id: <20220204214205.3306634-10-seanjc@google.com>
Mime-Version: 1.0
References: <20220204214205.3306634-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH 09/11] KVM: x86: Treat x2APIC's ICR as a 64-bit register, not
 two 32-bit regs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Emulate the x2APIC ICR as a single 64-bit register, as opposed to forking
it across ICR and ICR2 as two 32-bit registers.  This mirrors hardware
behavior for Intel's upcoming IPI virtualization support, which does not
split the access.

Previous versions of Intel's SDM and AMD's APM don't explicitly state
exactly how ICR is reflected in the vAPIC page for x2APIC, KVM just
happened to speculate incorrectly.

Handling the upcoming behavior is necessary in order to maintain
backwards compatibility with KVM_{G,S}ET_LAPIC, e.g. failure to shuffle
the 64-bit ICR to ICR+ICR2 and vice versa would break live migration if
IPI virtualization support isn't symmetrical across the source and dest.

Cc: Zeng Guang <guang.zeng@intel.com>
Cc: Chao Gao <chao.gao@intel.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 114 +++++++++++++++++++++++++++++++++----------
 arch/x86/kvm/lapic.h |   8 ++-
 arch/x86/kvm/trace.h |   6 +--
 arch/x86/kvm/x86.c   |  10 +---
 4 files changed, 99 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f72f3043134e..dd185367a62c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -68,6 +68,29 @@ static bool lapic_timer_advance_dynamic __read_mostly;
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
 
+static __always_inline u64 __kvm_lapic_get_reg64(char *regs, int reg)
+{
+	BUILD_BUG_ON(reg != APIC_ICR);
+	return *((u64 *) (regs + reg));
+}
+
+static __always_inline u64 kvm_lapic_get_reg64(struct kvm_lapic *apic, int reg)
+{
+	return __kvm_lapic_get_reg64(apic->regs, reg);
+}
+
+static __always_inline void __kvm_lapic_set_reg64(char *regs, int reg, u64 val)
+{
+	BUILD_BUG_ON(reg != APIC_ICR);
+	*((u64 *) (regs + reg)) = val;
+}
+
+static __always_inline void kvm_lapic_set_reg64(struct kvm_lapic *apic,
+						int reg, u64 val)
+{
+	__kvm_lapic_set_reg64(apic->regs, reg, val);
+}
+
 static inline int apic_test_vector(int vec, void *bitmap)
 {
 	return test_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
@@ -1404,7 +1427,6 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 		APIC_REGS_MASK(APIC_IRR, APIC_ISR_NR) |
 		APIC_REG_MASK(APIC_ESR) |
 		APIC_REG_MASK(APIC_ICR) |
-		APIC_REG_MASK(APIC_ICR2) |
 		APIC_REG_MASK(APIC_LVTT) |
 		APIC_REG_MASK(APIC_LVTTHMR) |
 		APIC_REG_MASK(APIC_LVTPC) |
@@ -1415,9 +1437,16 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 		APIC_REG_MASK(APIC_TMCCT) |
 		APIC_REG_MASK(APIC_TDCR);
 
-	/* ARBPRI is not valid on x2APIC */
+	/*
+	 * ARBPRI and ICR2 are not valid in x2APIC mode.  WARN if KVM reads ICR
+	 * in x2APIC mode as it's an 8-byte register in x2APIC and needs to be
+	 * manually handled by the caller.
+	 */
 	if (!apic_x2apic_mode(apic))
-		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI);
+		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI) |
+				  APIC_REG_MASK(APIC_ICR2);
+	else
+		WARN_ON_ONCE(offset == APIC_ICR);
 
 	if (alignment + len > 4)
 		return 1;
@@ -2061,16 +2090,18 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		break;
 	}
 	case APIC_ICR:
+		WARN_ON_ONCE(apic_x2apic_mode(apic));
+
 		/* No delay here, so we always clear the pending bit */
 		val &= ~APIC_ICR_BUSY;
 		kvm_apic_send_ipi(apic, val, kvm_lapic_get_reg(apic, APIC_ICR2));
 		kvm_lapic_set_reg(apic, APIC_ICR, val);
 		break;
-
 	case APIC_ICR2:
-		if (!apic_x2apic_mode(apic))
-			val &= 0xff000000;
-		kvm_lapic_set_reg(apic, APIC_ICR2, val);
+		if (apic_x2apic_mode(apic))
+			ret = 1;
+		else
+			kvm_lapic_set_reg(apic, APIC_ICR2, val & 0xff000000);
 		break;
 
 	case APIC_LVT0:
@@ -2130,10 +2161,9 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		break;
 
 	case APIC_SELF_IPI:
-		if (apic_x2apic_mode(apic)) {
-			kvm_lapic_reg_write(apic, APIC_ICR,
-					    APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
-		} else
+		if (apic_x2apic_mode(apic))
+			kvm_x2apic_icr_write(apic, APIC_DEST_SELF | (val & APIC_VECTOR_MASK));
+		else
 			ret = 1;
 		break;
 	default:
@@ -2359,8 +2389,12 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (!apic_x2apic_mode(apic))
 		kvm_apic_set_ldr(apic, 0);
 	kvm_lapic_set_reg(apic, APIC_ESR, 0);
-	kvm_lapic_set_reg(apic, APIC_ICR, 0);
-	kvm_lapic_set_reg(apic, APIC_ICR2, 0);
+	if (!apic_x2apic_mode(apic)) {
+		kvm_lapic_set_reg(apic, APIC_ICR, 0);
+		kvm_lapic_set_reg(apic, APIC_ICR2, 0);
+	} else {
+		kvm_lapic_set_reg64(apic, APIC_ICR, 0);
+	}
 	kvm_lapic_set_reg(apic, APIC_TDCR, 0);
 	kvm_lapic_set_reg(apic, APIC_TMICT, 0);
 	for (i = 0; i < 8; i++) {
@@ -2577,6 +2611,7 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 	if (apic_x2apic_mode(vcpu->arch.apic)) {
 		u32 *id = (u32 *)(s->regs + APIC_ID);
 		u32 *ldr = (u32 *)(s->regs + APIC_LDR);
+		u64 icr;
 
 		if (vcpu->kvm->arch.x2apic_format) {
 			if (*id != vcpu->vcpu_id)
@@ -2588,9 +2623,21 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 				*id <<= 24;
 		}
 
-		/* In x2APIC mode, the LDR is fixed and based on the id */
-		if (set)
+		/*
+		 * In x2APIC mode, the LDR is fixed and based on the id.  And
+		 * ICR is internally a single 64-bit register, but needs to be
+		 * split to ICR+ICR2 in userspace for backwards compatibility.
+		 */
+		if (set) {
 			*ldr = kvm_apic_calc_x2apic_ldr(*id);
+
+			icr = __kvm_lapic_get_reg(s->regs, APIC_ICR) |
+			      (u64)__kvm_lapic_get_reg(s->regs, APIC_ICR2) << 32;
+			__kvm_lapic_set_reg64(s->regs, APIC_ICR, icr);
+		} else {
+			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
+			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
+		}
 	}
 
 	return 0;
@@ -2782,27 +2829,43 @@ int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr)
 	return 0;
 }
 
+int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data)
+{
+	data &= ~APIC_ICR_BUSY;
+
+	kvm_apic_send_ipi(apic, (u32)data, (u32)(data >> 32));
+	kvm_lapic_set_reg64(apic, APIC_ICR, data);
+	trace_kvm_apic_write(APIC_ICR, data);
+	return 0;
+}
+
 static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data)
 {
-	u32 low, high = 0;
+	u32 low;
+
+	if (reg == APIC_ICR) {
+		*data = kvm_lapic_get_reg64(apic, APIC_ICR);
+		return 0;
+	}
 
 	if (kvm_lapic_reg_read(apic, reg, 4, &low))
 		return 1;
 
-	if (reg == APIC_ICR &&
-	    WARN_ON_ONCE(kvm_lapic_reg_read(apic, APIC_ICR2, 4, &high)))
-		return 1;
-
-	*data = (((u64)high) << 32) | low;
+	*data = low;
 
 	return 0;
 }
 
 static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data)
 {
-	/* For 64-bit ICR writes, set ICR2 (dest) before ICR (command). */
+	/*
+	 * ICR is a 64-bit register in x2APIC mode (and Hyper'v PV vAPIC) and
+	 * can be written as such, all other registers remain accessible only
+	 * through 32-bit reads/writes.
+	 */
 	if (reg == APIC_ICR)
-		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
+		return kvm_x2apic_icr_write(apic, data);
+
 	return kvm_lapic_reg_write(apic, reg, (u32)data);
 }
 
@@ -2814,9 +2877,6 @@ int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(apic))
 		return 1;
 
-	if (reg == APIC_ICR2)
-		return 1;
-
 	return kvm_lapic_msr_write(apic, reg, data);
 }
 
@@ -2828,7 +2888,7 @@ int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 	if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(apic))
 		return 1;
 
-	if (reg == APIC_DFR || reg == APIC_ICR2)
+	if (reg == APIC_DFR)
 		return 1;
 
 	return kvm_lapic_msr_read(apic, reg, data);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index ab76896a8c3f..e39e7ec5c2b4 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -118,6 +118,7 @@ int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu);
 void kvm_lapic_sync_to_vapic(struct kvm_vcpu *vcpu);
 
+int kvm_x2apic_icr_write(struct kvm_lapic *apic, u64 data);
 int kvm_x2apic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 
@@ -150,9 +151,14 @@ static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 	apic->irr_pending = true;
 }
 
+static inline u32 __kvm_lapic_get_reg(char *regs, int reg_off)
+{
+	return *((u32 *) (regs + reg_off));
+}
+
 static inline u32 kvm_lapic_get_reg(struct kvm_lapic *apic, int reg_off)
 {
-	return *((u32 *) (apic->regs + reg_off));
+	return __kvm_lapic_get_reg(apic->regs, reg_off);
 }
 
 static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 92e6f6702f00..340394a8ce7a 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -251,13 +251,13 @@ TRACE_EVENT(kvm_cpuid,
  * Tracepoint for apic access.
  */
 TRACE_EVENT(kvm_apic,
-	TP_PROTO(unsigned int rw, unsigned int reg, unsigned int val),
+	TP_PROTO(unsigned int rw, unsigned int reg, u64 val),
 	TP_ARGS(rw, reg, val),
 
 	TP_STRUCT__entry(
 		__field(	unsigned int,	rw		)
 		__field(	unsigned int,	reg		)
-		__field(	unsigned int,	val		)
+		__field(	u64,		val		)
 	),
 
 	TP_fast_assign(
@@ -266,7 +266,7 @@ TRACE_EVENT(kvm_apic,
 		__entry->val		= val;
 	),
 
-	TP_printk("apic_%s %s = 0x%x",
+	TP_printk("apic_%s %s = 0x%llx",
 		  __entry->rw ? "write" : "read",
 		  __print_symbolic(__entry->reg, kvm_trace_symbol_apic),
 		  __entry->val)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9024e33c2add..eaad2f485b64 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2014,14 +2014,8 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 	if (((data & APIC_SHORT_MASK) == APIC_DEST_NOSHORT) &&
 	    ((data & APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
 	    ((data & APIC_MODE_MASK) == APIC_DM_FIXED) &&
-	    ((u32)(data >> 32) != X2APIC_BROADCAST)) {
-		data &= ~APIC_ICR_BUSY;
-		kvm_apic_send_ipi(vcpu->arch.apic, (u32)data, (u32)(data >> 32));
-		kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, (u32)(data >> 32));
-		kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR, (u32)data);
-		trace_kvm_apic_write(APIC_ICR, (u32)data);
-		return 0;
-	}
+	    ((u32)(data >> 32) != X2APIC_BROADCAST))
+		return kvm_x2apic_icr_write(vcpu->arch.apic, data);
 
 	return 1;
 }
-- 
2.35.0.263.gb82422642f-goog

