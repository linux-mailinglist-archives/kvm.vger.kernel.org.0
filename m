Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2549323DFC6
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbgHFRxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 13:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727936AbgHFQbD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 12:31:03 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1258AC008688
        for <kvm@vger.kernel.org>; Thu,  6 Aug 2020 08:14:45 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id k21so27446496pls.2
        for <kvm@vger.kernel.org>; Thu, 06 Aug 2020 08:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LAEdgjlTVf1hTtRKfm4PTzrcSwYjp4TQd8jrl5e77wk=;
        b=PbGGktM2lHbrpi61tVJsiQKUX/nyB6Ib/WEIfcT9BM2LfM/SNOkrB4mDgokA78i9+f
         q/u0VRw402jpTQvMX2gMgzpUwBzCrwwmhTrJIR38wLjGyK4jgEBCNlBvj6OlwNs5uzyL
         tC/DHVm72Srb/ZKWWmSasKz3EFeO1rU+jqnpc2cHBZuF3SIrq6gwsu9GUFJKAOK1qJi7
         TgiMX+kAi/AXx+qoDFkQRZVRPNOcwsHjBbkA2wZ5lPLBU7QevxoBAcrMUpsa5PTs6krD
         3EjYNzuhDSmDosDPhDYP9nwpcw/ps1n8LYlk3dBR86IhAPSKo6gAFgASdQzS7x9dZJvr
         3/og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LAEdgjlTVf1hTtRKfm4PTzrcSwYjp4TQd8jrl5e77wk=;
        b=Pp6UIzJfvW5h76pWvIIGxZMnV794uPAurw72sybQ2XzL+mWRbExNWanqt64SxF+3qd
         kjqH3JJYwPEbW2VaMD3CbmS7kuxk5FmfStaj73BMwF76zAVfs+HftUYNvYophApZ4WoF
         O0T/ZXnmiNCgNMJnBTdSTGNWg0kPhROp+eFb8lOqq2QCLbfytM7IsW6g6kDXVesMPKBv
         EQGpsrkBVh7IQTT43p1uh9/heKfjKBU+jUoVREWo3NeXn3lurJUmHNjNshdQ8wXU4VUY
         xpZi35JAIEiOFqFShuKtMovo2j9Zfno4aDvQP4Xy6uiLHlLvSfkN0h4gMPCyAKdt6SNA
         mGaQ==
X-Gm-Message-State: AOAM531poFHPviUH2CMpXhdWdLnogak6cGSyVgV3a9xw3CGbmP+Vc+PM
        OB4dSxN4JQGIHzV1N02ytcBPMRZMakhYchpGk4tPpHKmHFGwjin6zaGi11+yV0SZTvD9lLJEx9k
        CDsNRvG3x7+otZIYXDTh4tC3X6wQWwom4ziK1KR2AiVStBBwkzFkj17+9Mw==
X-Google-Smtp-Source: ABdhPJw9dzpQLNg0cjoNS1OreAhKWmkuObYVgcE6xuPEYPqfCE/7NE6QdNRguzX+Br9/pRiXW30UKb4s65Q=
X-Received: by 2002:a63:b91e:: with SMTP id z30mr7677471pge.329.1596726881267;
 Thu, 06 Aug 2020 08:14:41 -0700 (PDT)
Date:   Thu,  6 Aug 2020 15:14:32 +0000
In-Reply-To: <20200806151433.2747952-1-oupton@google.com>
Message-Id: <20200806151433.2747952-4-oupton@google.com>
Mime-Version: 1.0
References: <20200806151433.2747952-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v3 3/4] kvm: x86: only provide PV features if enabled in
 guest's CPUID
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
---
 Documentation/virt/kvm/api.rst  | 11 ++++++
 arch/x86/include/asm/kvm_host.h |  6 +++
 arch/x86/kvm/cpuid.h            | 16 ++++++++
 arch/x86/kvm/x86.c              | 67 ++++++++++++++++++++++++++++++---
 include/uapi/linux/kvm.h        |  1 +
 5 files changed, 96 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 644e5326aa50..e8fc6e34f344 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6155,3 +6155,14 @@ KVM can therefore start protected VMs.
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
index 5ab3af7275d8..a641c3840a1e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -788,6 +788,12 @@ struct kvm_vcpu_arch {
 
 	/* AMD MSRC001_0015 Hardware Configuration */
 	u64 msr_hwcr;
+
+	/*
+	 * Indicates whether PV emulation should be disabled if not present in
+	 * the guest's cpuid.
+	 */
+	bool enforce_pv_feature_cpuid;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 3a923ae15f2f..c364c2877583 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -5,6 +5,7 @@
 #include "x86.h"
 #include <asm/cpu.h>
 #include <asm/processor.h>
+#include <uapi/asm/kvm_para.h>
 
 extern u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
 void kvm_set_cpu_caps(void);
@@ -308,4 +309,19 @@ static inline bool page_address_valid(struct kvm_vcpu *vcpu, gpa_t gpa)
 	return PAGE_ALIGNED(gpa) && !(gpa >> cpuid_maxphyaddr(vcpu));
 }
 
+static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
+					   unsigned int kvm_feature)
+{
+	struct kvm_cpuid_entry2 *cpuid;
+
+	if (!vcpu->arch.enforce_pv_feature_cpuid)
+		return true;
+
+	cpuid = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
+	if (!cpuid)
+		return false;
+
+	return cpuid->eax & (1u << kvm_feature);
+}
+
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 683ce68d96b2..9900a846dfc0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2763,6 +2763,14 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
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
 
@@ -2840,10 +2848,12 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
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
 
@@ -2998,30 +3008,54 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -3038,11 +3072,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
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
@@ -3522,6 +3562,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_EXCEPTION_PAYLOAD:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_LAST_CPU:
+	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -4389,6 +4430,11 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 
 		return kvm_x86_ops.enable_direct_tlbflush(vcpu);
 
+	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
+		vcpu->arch.enforce_pv_feature_cpuid = cap->args[0];
+
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
@@ -7723,11 +7769,16 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
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
@@ -7738,9 +7789,15 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
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
2.28.0.236.gb10cc79966-goog

