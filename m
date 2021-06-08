Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1C53A0660
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbhFHVt7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 17:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbhFHVt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 17:49:58 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD02EC061574
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 14:48:04 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id ce7-20020a05621403c7b0290238a4eac5c4so1678541qvb.13
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 14:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ca/qZaiknXj3Iq9ZLm3iYeH+fivlx7sz5NKgsuoyOb4=;
        b=FucUvvJFCa05/fx+2iKbRyVJpDUoSdRufaojOSwRTffpsdVFvbdf/J9dXzxOAmTCGK
         m0Z3BztkAnyYMsLiTRVsqHq1OXRbF6kIZkTtKPpx0QwTYLaF+dswbCCEq+ZWNjJmQ+m0
         uuI4gku9wm37sKM0u7PbfqYSD4ol8UUT2aRAA4uMCbaM41+UXNi8wmOZvO42vej34B6G
         Z1N1DHhgMcBAjElxU0oU0lWQd7Isg8O1ff3iAQDBJ02sumAPfBUMYOpMXVjWfl1GWUJ1
         ZxEZ3e7RP+EBvHIHvVRd1m0jn113P0YM7qrkBwukO4eMSu/bqDqfpm+/NKlijZ+MWW63
         zYrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ca/qZaiknXj3Iq9ZLm3iYeH+fivlx7sz5NKgsuoyOb4=;
        b=eYGvYToibIuxMp/GuwaMsihk+wL4nfXABTBMSSHBkWETsXNLALsyDmBWG9EwHEwrpk
         xjD4Urqe37hOgb8jkkbATsaJQDdW46HySp6mdKInr2n1ovatL6FmlNjzELaHBDF6TlA3
         qZR7lTBpq8IIipuFhxPDvbzn0NkS7DcIebqA3npZpLJiEj3JT7Byi3tYCvxbrfSx0l3l
         2nA+S8zILF7ZhaYFKuQBt0QoD5j3r/l9evc2wHxkxPRaDoVied4t3+fB9qwc95l6k/w0
         lWVpWz3HzO1YNrbCSbIrcptTDH22H67yIo5NzroXU7GpR80XzlY9qRCrulJNDRg0YYbH
         lRDQ==
X-Gm-Message-State: AOAM5333LrchCL63Dxnc3HJCzXHDD6wn+CJDvNTq65YQxNaFMHzCcc+E
        HXPaLlX/jx+FxMnNqEOTfcV8Xk1zuUmp5eFtGfEYw6CX1EOtm6CvUDwUbauijyy6Jtkr3/MwMQs
        D/aE04MUbuUdNHItyXl+PSpF7Vr2KMWmE7taJA5g6tTzOG/gxFZeQfaCFzw==
X-Google-Smtp-Source: ABdhPJyOt0TfQ9WWojPwzmuw0t6yU1SRclBJiOl4Nkj1pFOEutp+3uVpbmEDpDFTcOwrVm5OIBfDBOZQmlY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:ad4:4241:: with SMTP id l1mr2485084qvq.2.1623188883854;
 Tue, 08 Jun 2021 14:48:03 -0700 (PDT)
Date:   Tue,  8 Jun 2021 21:47:34 +0000
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Message-Id: <20210608214742.1897483-3-oupton@google.com>
Mime-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 02/10] KVM: arm64: Implement initial support for KVM_CAP_SYSTEM_COUNTER_STATE
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ARMv8 provides for a virtual counter-timer offset that is added to guest
views of the virtual counter-timer (CNTVOFF_EL2). To date, KVM has not
provided userspace with any perception of this, and instead affords a
value-based scheme of migrating the virtual counter-timer by directly
reading/writing the guest's CNTVCT_EL0. This is problematic because
counters continue to elapse while the register is being written, meaning
it is possible for drift to sneak in to the guest's time scale. This is
exacerbated by the fact that KVM will calculate an appropriate
CNTVOFF_EL2 every time the register is written, which will be broadcast
to all virtual CPUs. The only possible way to avoid causing guest time
to drift is to restore counter-timers by offset.

Implement initial support for KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls
to migrate the value of CNTVOFF_EL2. These ioctls yield precise control
of the virtual counter-timers to userspace, allowing it to define its
own heuristics for managing vCPU offsets.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Jing Zhang <jingzhangos@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  5 +++++
 arch/arm64/include/uapi/asm/kvm.h | 10 ++++++++++
 arch/arm64/kvm/arch_timer.c       | 22 ++++++++++++++++++++++
 arch/arm64/kvm/arm.c              | 25 +++++++++++++++++++++++++
 4 files changed, 62 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cd7d5c8c4bc..31107d5e61af 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -781,4 +781,9 @@ void __init kvm_hyp_reserve(void);
 static inline void kvm_hyp_reserve(void) { }
 #endif
 
+int kvm_arm_vcpu_get_system_counter_state(struct kvm_vcpu *vcpu,
+					  struct kvm_system_counter_state *state);
+int kvm_arm_vcpu_set_system_counter_state(struct kvm_vcpu *vcpu,
+					  struct kvm_system_counter_state *state);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 24223adae150..d3987089c524 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -184,6 +184,16 @@ struct kvm_vcpu_events {
 	__u32 reserved[12];
 };
 
+/* for KVM_{GET,SET}_SYSTEM_COUNTER_STATE */
+struct kvm_system_counter_state {
+	/* indicates what fields are valid in the structure */
+	__u32 flags;
+	__u32 pad;
+	/* guest counter-timer offset, relative to host cntpct_el0 */
+	__u64 cntvoff;
+	__u64 rsvd[7];
+};
+
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
 #define KVM_REG_ARM_COPROC_SHIFT	16
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 74e0699661e9..955a7a183362 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1259,3 +1259,25 @@ int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 	return -ENXIO;
 }
+
+int kvm_arm_vcpu_get_system_counter_state(struct kvm_vcpu *vcpu,
+					  struct kvm_system_counter_state *state)
+{
+	if (state->flags)
+		return -EINVAL;
+
+	state->cntvoff = timer_get_offset(vcpu_vtimer(vcpu));
+
+	return 0;
+}
+
+int kvm_arm_vcpu_set_system_counter_state(struct kvm_vcpu *vcpu,
+					  struct kvm_system_counter_state *state)
+{
+	if (state->flags)
+		return -EINVAL;
+
+	timer_set_offset(vcpu_vtimer(vcpu), state->cntvoff);
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1126eae27400..b78ffb4db9dd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -207,6 +207,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_SYSTEM_COUNTER_STATE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -1273,6 +1274,30 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		return kvm_arm_vcpu_finalize(vcpu, what);
 	}
+	case KVM_GET_SYSTEM_COUNTER_STATE: {
+		struct kvm_system_counter_state state;
+
+		if (copy_from_user(&state, argp, sizeof(state)))
+			return -EFAULT;
+
+		r = kvm_arm_vcpu_get_system_counter_state(vcpu, &state);
+		if (r)
+			break;
+
+		if (copy_to_user(argp, &state, sizeof(state)))
+			return -EFAULT;
+
+		break;
+	}
+	case KVM_SET_SYSTEM_COUNTER_STATE: {
+		struct kvm_system_counter_state state;
+
+		if (copy_from_user(&state, argp, sizeof(state)))
+			return -EFAULT;
+
+		r = kvm_arm_vcpu_set_system_counter_state(vcpu, &state);
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
-- 
2.32.0.rc1.229.g3e70b5a671-goog

