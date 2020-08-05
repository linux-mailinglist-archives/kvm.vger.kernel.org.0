Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903D923D38E
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 23:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgHEVVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 17:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHEVVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 17:21:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DEFCC061575
        for <kvm@vger.kernel.org>; Wed,  5 Aug 2020 14:21:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l67so20540537ybb.7
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 14:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ayJsOn3aKHLyJjQL5fsgNNxb6FwO0IBguHhnmJqaAIY=;
        b=B14dUjdclIe8/Bov3DdhxL4QRWljXc6vQPMK4dYoUxpAXcTfOxLGcEwbJek9OBsyd1
         SdJ1DOqedtKHF2Qd0lHIsRFaVJwcMvsOGGnjmEG0WtPxT0tqfoWYMKMz4jUxpY/VNUiB
         gr1IZKKNFEa4gg23noR2x93BWYJ0gOrJsFHvIz8gkz8v97yDeKQrr/o2hvcJ+ZM0jO0i
         ipIKkX6BEkAmnjAt0yk4LVWc4bOxY3kKbHyfvoFcHftNlXnfA4bLvZE3BjgYUUVB2W0a
         LdKb50yn7SHD+mKSUh8ZfIsg10fVdyrQ7MfxVqkThAnU1813BcBf76NEdK1FuzMR8TJM
         wv4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ayJsOn3aKHLyJjQL5fsgNNxb6FwO0IBguHhnmJqaAIY=;
        b=GgRV0O2UUg64RFAhqHVy3RNwYK4Dvb0VRqOx7jypFYFraAt6MB39wfO6PTZyunlpzw
         EPT2W3qFfxLRVNTqrbiVMWBYILS9kFRKIq4WNnDtjPU2hWsBjz0vYCBaMS6dsU/0g+XU
         I7c4z7mXd61wcVwhcqDAtx9rg4SLoKl25Bqg6ntIs1zr1LBW/+ySaJAiq5z01fc2acvO
         8P3S6oOmRUSFTuvv2ZZvMbU57JgHaCPWeIilydEQ6tZmDAhLuUGnRB3DS1xesMJwQ/Z9
         xmhIpkGmJNqz0R5lEdNoTadGP5grXj0KTCuD3Dqokj/mB1fQwgtbGhjc+kUEDHKS7XYi
         2MjA==
X-Gm-Message-State: AOAM5311hFVxEhdwogYM/lIq5aMVl/QBh+rLJjTcQ+yTQ+yd8WoxDlLN
        mG71FQ+EP8lNOEza0o4WoGXlZ4xmT8pyjNk37OUKIpFKCIB6I2PaQ6sjEaR3ZnTg4dv/9C0fzbt
        xOxqNsulMsh9bJrPw9laQ9CU45FpynRaT6lv9Rx75nuJlvbl0S3LGZ3gTXQ==
X-Google-Smtp-Source: ABdhPJyXgqq0BogW1hC+fzLivTNb4KxKh9WfBkm8UxjfAsc7FHYlnIvAsNKm+/LkpBm2xndq6ugN4qI/2n4=
X-Received: by 2002:a25:aaf3:: with SMTP id t106mr7341598ybi.56.1596662502698;
 Wed, 05 Aug 2020 14:21:42 -0700 (PDT)
Date:   Wed,  5 Aug 2020 21:21:30 +0000
In-Reply-To: <20200805212131.2059634-1-oupton@google.com>
Message-Id: <20200805212131.2059634-4-oupton@google.com>
Mime-Version: 1.0
References: <20200805212131.2059634-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v2 3/4] kvm: x86: only provide PV features if enabled in
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
index 53d3a5ffde9c..51a9e8e394a5 100644
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

