Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4502E2489B0
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 17:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgHRPYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 11:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgHRPYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 11:24:51 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80654C061342
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 08:24:51 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id o6so12431121pll.9
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 08:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3rwunzaIr0pe53eeZZ84cz5cFuKQcHL9hoL/E/rE2eA=;
        b=YXBlqJYmwKHf+y9vniL778DPvJvnhUSsNPMj+dEDXNuDZcRUdsGW86sRnVTN1UCqvO
         q0WDNATCKFkNAEUthHK/ybiemCKn9sjzyMhOile8zl+afWPKNlSr32EpKXgMSmE9DPRV
         od2ggm7zPMuFHDnUvld4htuOo1CpOYkaoam82HHHuUulJVR2agfFjaD0ujyWCytdajy/
         p5RNZJQGKeDWmqhQoB0XIkiWGW2U1aLfMJwVsfzAfzlH2aNBVNbPwOHqPzD3uUFUsJfJ
         Fhos4PxbuCCySPiwcSu8pAfDMJetnmNK7HSfhZZYyCC7dYmXo69/slisK52Alm8cWy04
         WS5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3rwunzaIr0pe53eeZZ84cz5cFuKQcHL9hoL/E/rE2eA=;
        b=XOoAVduOGx4mo2X1oXgeU6ZUJlJeh23g7TRMKGbl6PIXTWlcHn7DKgtLU2t2sDFp+I
         /4vl0J8KuphjEv/nUiUOUr5FDE5wdPOJOHl/RnyPtliSSkTwEdkkV3JvbKNey/suolBT
         E8y0IYhohLm5dLaKA9o8xD8l3T20bL+6EKfh6LxfgEOLDu06+77Qix0o9IbUxx1e1tI2
         hiC2tD2wQdno7bMqupvCoRKOONSmTnsADYIACg+WSJnZH+H/0KgrME7qpgUYLwjWsp+7
         iCEEjPB0da4e4FchKA8gggSGGTE80jYwLG12EU7a8sfKKMcah2CXDGNM/AmCapW/Zq4/
         OaHw==
X-Gm-Message-State: AOAM532oqOK/TDnCToH+5FUeGOm5x49VEs4i0Yz3kM+Biqhyp07uDfEA
        f2gBVHBfaHEjJmblYbc2UDMXq2oCQq8+y44db2+ga2SexpEsvDALrQ0/kHu51HopvQ33CASYbbs
        DnooQi2xgWICj4gQuXt+lsDgZ7bROeqHEcwFWp9hxhxb9bvrMp1x/fQ4+Dw==
X-Google-Smtp-Source: ABdhPJy+y7TG43oH7HCWz+kibDVJj84ncJwDOVGa2yYZtUgIMzqKyee4tbnM+5UUVVN+Xx/SlW6VutW/sRU=
X-Received: by 2002:a63:1a49:: with SMTP id a9mr13576701pgm.110.1597764290672;
 Tue, 18 Aug 2020 08:24:50 -0700 (PDT)
Date:   Tue, 18 Aug 2020 15:24:28 +0000
In-Reply-To: <20200818152429.1923996-1-oupton@google.com>
Message-Id: <20200818152429.1923996-4-oupton@google.com>
Mime-Version: 1.0
References: <20200818152429.1923996-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v4 3/4] kvm: x86: only provide PV features if enabled in
 guest's CPUID
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM unconditionally provides PV features to the guest, regardless of the
configured CPUID. An unwitting guest that doesn't check
KVM_CPUID_FEATURES before use could access paravirt features that
userspace did not intend to provide. Fix this by checking the guest's
CPUID before performing any paravirtual operations.

Introduce a capability, KVM_CAP_ENFORCE_PV_FEATURE_CPUID, to gate the
aforementioned enforcement. Migrating a VM from a host w/o this patch to
a host with this patch could silently change the ABI exposed to the
guest, warranting that we default to the old behavior and opt-in for
the new one.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Change-Id: I202a0926f65035b872bfe8ad15307c026de59a98
---
 Documentation/virt/kvm/api.rst  | 11 ++++++
 arch/x86/include/asm/kvm_host.h | 15 ++++++++
 arch/x86/kvm/cpuid.c            |  7 ++++
 arch/x86/kvm/cpuid.h            | 10 +++++
 arch/x86/kvm/x86.c              | 67 ++++++++++++++++++++++++++++++---
 include/uapi/linux/kvm.h        |  1 +
 6 files changed, 106 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eb3a1316f03e..c9e4f092f743 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6159,3 +6159,14 @@ KVM can therefore start protected VMs.
 This capability governs the KVM_S390_PV_COMMAND ioctl and the
 KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
 guests when the state change is invalid.
+
+
+8.24 KVM_CAP_ENFORCE_PV_CPUID
+-----------------------------
+
+Architectures: x86
+
+When enabled, KVM will disable paravirtual features provided to the
+guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
+(0x40000001). Otherwise, a guest may use the paravirtual features
+regardless of what has actually been exposed through the CPUID leaf.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5ab3af7275d8..e0c65e319bdf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -788,6 +788,21 @@ struct kvm_vcpu_arch {
 
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
+
+	/* pv related cpuid info */
+	struct {
+		/*
+		 * value of the eax register in the KVM_CPUID_FEATURES CPUID
+		 * leaf.
+		 */
+		u32 features;
+
+		/*
+		 * indicates whether pv emulation should be disabled if features
+		 * are not present in the guest's cpuid
+		 */
+		bool enforce;
+	} pv_cpuid;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3fd6eec202d7..48fb2ea74906 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -107,6 +107,13 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
+	/*
+	 * save the feature bitmap to avoid cpuid lookup for every PV
+	 * operation
+	 */
+	if (best)
+		vcpu->arch.pv_cpuid.features = best->eax;
+
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
 		best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
 		if (best)
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 3a923ae15f2f..4e2d2e767984 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -5,6 +5,7 @@
 #include "x86.h"
 #include <asm/cpu.h>
 #include <asm/processor.h>
+#include <uapi/asm/kvm_para.h>
 
 extern u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
 void kvm_set_cpu_caps(void);
@@ -308,4 +309,13 @@ static inline bool page_address_valid(struct kvm_vcpu *vcpu, gpa_t gpa)
 	return PAGE_ALIGNED(gpa) && !(gpa >> cpuid_maxphyaddr(vcpu));
 }
 
+static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
+					 unsigned int kvm_feature)
+{
+	if (!vcpu->arch.pv_cpuid.enforce)
+		return true;
+
+	return vcpu->arch.pv_cpuid.features & (1u << kvm_feature);
+}
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e16c71fe1b48..941ab75cf572 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2764,6 +2764,14 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 	if (data & 0x30)
 		return 1;
 
+	if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_VMEXIT) &&
+	    (data & KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT))
+		return 1;
+
+	if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT) &&
+	    (data & KVM_ASYNC_PF_DELIVERY_AS_INT))
+		return 1;
+
 	if (!lapic_in_kernel(vcpu))
 		return 1;
 
@@ -2841,10 +2849,12 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	 * Doing a TLB flush here, on the guest's behalf, can avoid
 	 * expensive IPIs.
 	 */
-	trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
-		st->preempted & KVM_VCPU_FLUSH_TLB);
-	if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
-		kvm_vcpu_flush_tlb_guest(vcpu);
+	if (guest_pv_has(vcpu, KVM_FEATURE_PV_TLB_FLUSH)) {
+		trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
+				       st->preempted & KVM_VCPU_FLUSH_TLB);
+		if (xchg(&st->preempted, 0) & KVM_VCPU_FLUSH_TLB)
+			kvm_vcpu_flush_tlb_guest(vcpu);
+	}
 
 	vcpu->arch.st.preempted = 0;
 
@@ -2999,30 +3009,54 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.smi_count = data;
 		break;
 	case MSR_KVM_WALL_CLOCK_NEW:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
+			return 1;
+
+		kvm_write_wall_clock(vcpu->kvm, data);
+		break;
 	case MSR_KVM_WALL_CLOCK:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
+			return 1;
+
 		kvm_write_wall_clock(vcpu->kvm, data);
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
+			return 1;
+
 		kvm_write_system_time(vcpu, data, false, msr_info->host_initiated);
 		break;
 	case MSR_KVM_SYSTEM_TIME:
-		kvm_write_system_time(vcpu, data, true, msr_info->host_initiated);
+		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
+			return 1;
+
+		kvm_write_system_time(vcpu, data, true,  msr_info->host_initiated);
 		break;
 	case MSR_KVM_ASYNC_PF_EN:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
+			return 1;
+
 		if (kvm_pv_enable_async_pf(vcpu, data))
 			return 1;
 		break;
 	case MSR_KVM_ASYNC_PF_INT:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
+			return 1;
+
 		if (kvm_pv_enable_async_pf_int(vcpu, data))
 			return 1;
 		break;
 	case MSR_KVM_ASYNC_PF_ACK:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
+			return 1;
 		if (data & 0x1) {
 			vcpu->arch.apf.pageready_pending = false;
 			kvm_check_async_pf_completion(vcpu);
 		}
 		break;
 	case MSR_KVM_STEAL_TIME:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME))
+			return 1;
 
 		if (unlikely(!sched_info_on()))
 			return 1;
@@ -3039,11 +3073,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		break;
 	case MSR_KVM_PV_EOI_EN:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_EOI))
+			return 1;
+
 		if (kvm_lapic_enable_pv_eoi(vcpu, data, sizeof(u8)))
 			return 1;
 		break;
 
 	case MSR_KVM_POLL_CONTROL:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_POLL_CONTROL))
+			return 1;
+
 		/* only enable bit supported */
 		if (data & (-1ULL << 1))
 			return 1;
@@ -3523,6 +3563,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_EXCEPTION_PAYLOAD:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_LAST_CPU:
+	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -4390,6 +4431,11 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 
 		return kvm_x86_ops.enable_direct_tlbflush(vcpu);
 
+	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
+		vcpu->arch.pv_cpuid.enforce = cap->args[0];
+
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
@@ -7724,11 +7770,16 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
+	ret = -KVM_ENOSYS;
+
 	switch (nr) {
 	case KVM_HC_VAPIC_POLL_IRQ:
 		ret = 0;
 		break;
 	case KVM_HC_KICK_CPU:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_UNHALT))
+			break;
+
 		kvm_pv_kick_cpu_op(vcpu->kvm, a0, a1);
 		kvm_sched_yield(vcpu->kvm, a1);
 		ret = 0;
@@ -7739,9 +7790,15 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		break;
 #endif
 	case KVM_HC_SEND_IPI:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_SEND_IPI))
+			break;
+
 		ret = kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, op_64_bit);
 		break;
 	case KVM_HC_SCHED_YIELD:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_SCHED_YIELD))
+			break;
+
 		kvm_sched_yield(vcpu->kvm, a0);
 		ret = 0;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6d86033c4fa..48c2d5c10b1e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1035,6 +1035,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_LAST_CPU 184
 #define KVM_CAP_SMALLER_MAXPHYADDR 185
 #define KVM_CAP_S390_DIAG318 186
+#define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 187
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.28.0.220.ged08abb693-goog

