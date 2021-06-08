Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39363A0665
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 23:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbhFHVuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 17:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbhFHVuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 17:50:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7113CC061574
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 14:48:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y135-20020a25dc8d0000b029054716974cceso8534691ybe.12
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 14:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9ZoMqiE2Ix8XEX2FQzL2zr/Zx9M+aXu+vadqrJ/vnTw=;
        b=XxSvqxLou4MF4BxFLH0qp6z9iCNGB8fRfuEiXIEK/ImcP+Dl6aGVZQ5neE5XszmYpf
         Z57i2uiMF8yel+7eV37wtdnG8M+hdfascVdwEH1WYmGcPN8QoNJiDlaG+FyzYMr3kiqO
         c0Nb/Gu8xmsdxc91iXouuzftZF2YxXLyjsItZH3CM8YiZpDmOD7FdrE2CcLHgywd+ly3
         dH9dHva14YiQp5i7HqLJYokKiSnxup62jn0HPgQ2I3DLB7MmCHTahF3hAEDiu21v8BYK
         Oo1o3VM6/vOCNcYUphNsg+YXWJ87ZEzGQBl1ty+19uEJbmOyslLtCfALWev7VrQCxOZa
         /xgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9ZoMqiE2Ix8XEX2FQzL2zr/Zx9M+aXu+vadqrJ/vnTw=;
        b=h96kaMecugq0PfFfDRnclzWFcRRlZx/ztnb2VanNZ9orgyCFntdB1K6+HTWKf3xLeE
         l/3ELwDUbDtQrmDlWGLZIsbo6fxlZy98Ab+zsnc7GhnU+i8WrDegGYaYX54HqTDucotp
         F/zRwBWIj3C662vFBfC2t1WGWonOmfxgXUTku5AdZt8nnOMR0/DgiiHzqWOA8gfPfOo5
         tkUlzZeZHgkq5ePC3boodR0LZnQorgXWHs6nSDCp5zorQXFfQtjthrPnack0CaGDLAvG
         MND8nm5sZx9iyL/7juXeYZ/FE+TefBWdqJ3kpvQEDEWBgW+XAYUFCWP9h9KxcIMQ06CT
         r0wQ==
X-Gm-Message-State: AOAM530VungHg6wyBYEJnYLszSE99sifY7u+LLAFXvAOlmPC9c9ZLyPN
        CsnFxJzIBMyipFgmn1qmUl+rRXyT5Qz8xx3UOuXCBqkUJGo1Qc8Mev0UuD+W6Wvhd4qoCCC8+PR
        dh6luGrgKlFkuhf5hSLYE+LO1M25UdImlzp2Bpn8P3FfZtNL8ribmJDNN8Q==
X-Google-Smtp-Source: ABdhPJxLd52vbcGMLWWE2gQyW873IX70SEaG+rVIXWmdXwk5b+dvVT+6qrinH7iDe569lig2y1MvZyvExDc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:dbc4:: with SMTP id g187mr35049365ybf.142.1623188915485;
 Tue, 08 Jun 2021 14:48:35 -0700 (PDT)
Date:   Tue,  8 Jun 2021 21:47:40 +0000
In-Reply-To: <20210608214742.1897483-1-oupton@google.com>
Message-Id: <20210608214742.1897483-9-oupton@google.com>
Mime-Version: 1.0
References: <20210608214742.1897483-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 08/10] KVM: x86: Implement KVM_CAP_SYSTEM_COUNTER_STATE
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

To date, VMM-directed TSC synchronization and migration has been messy.
KVM has some baked-in heuristics around TSC writes to infer if the VMM
is attempting to synchronize. This is problematic, as it depends on the
host writing to the guest's TSC within 1 second of the last write.

A much cleaner approach to configuring the guest's views of the TSC is
to simply migrate the TSC offset for every vCPU. Offsets are idempotent,
and thus are not subject to change depending on when the VMM actually
reads the values from KVM. The VMM can then read the TSC once to
capture the instant at which the guest's TSCs are paused.

Implement the KVM_{GET,SET}_SYSTEM_COUNTER_STATE ioctls and advertise
KVM_CAP_SYSTEM_COUNTER_STATE to userspace.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/include/uapi/asm/kvm.h |  8 ++++
 arch/x86/kvm/x86.c              | 70 +++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..8768173f614c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1018,6 +1018,7 @@ struct kvm_arch {
 	u64 last_tsc_nsec;
 	u64 last_tsc_write;
 	u32 last_tsc_khz;
+	u64 last_tsc_offset;
 	u64 cur_tsc_nsec;
 	u64 cur_tsc_write;
 	u64 cur_tsc_offset;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0662f644aad9..60ad6b9ebcd6 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -490,4 +490,12 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+/* for KVM_CAP_SYSTEM_COUNTER_STATE */
+struct kvm_system_counter_state {
+	__u32 flags;
+	__u32 pad;
+	__u64 tsc_offset;
+	__u64 rsvd[6];
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 61069995a592..bb3ecb5cd548 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2332,6 +2332,11 @@ u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
 }
 EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
 
+static u64 kvm_vcpu_read_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.l1_tsc_offset;
+}
+
 static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	vcpu->arch.l1_tsc_offset = offset;
@@ -2377,6 +2382,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	kvm->arch.last_tsc_nsec = ns;
 	kvm->arch.last_tsc_write = tsc;
 	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
+	kvm->arch.last_tsc_offset = offset;
 
 	vcpu->arch.last_guest_tsc = tsc;
 
@@ -2485,6 +2491,44 @@ static inline void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
 	adjust_tsc_offset_guest(vcpu, adjustment);
 }
 
+static int kvm_vcpu_get_system_counter_state(struct kvm_vcpu *vcpu,
+					     struct kvm_system_counter_state *state)
+{
+	if (state->flags)
+		return -EINVAL;
+
+	state->tsc_offset = kvm_vcpu_read_tsc_offset(vcpu);
+	return 0;
+}
+
+static int kvm_vcpu_set_system_counter_state(struct kvm_vcpu *vcpu,
+					     struct kvm_system_counter_state *state)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 offset, tsc, ns;
+	unsigned long flags;
+	bool matched;
+
+	if (state->flags)
+		return -EINVAL;
+
+	offset = state->tsc_offset;
+
+	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
+
+	matched = (vcpu->arch.virtual_tsc_khz &&
+		   kvm->arch.last_tsc_khz == vcpu->arch.virtual_tsc_khz &&
+		   kvm->arch.last_tsc_offset == offset);
+
+	tsc = kvm_scale_tsc(vcpu, rdtsc()) + offset;
+	ns = get_kvmclock_base_ns();
+
+	__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
+	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
+
+	return 0;
+}
+
 #ifdef CONFIG_X86_64
 
 static u64 read_tsc(void)
@@ -3912,6 +3956,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SGX_ATTRIBUTE:
 #endif
 	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
+	case KVM_CAP_SYSTEM_COUNTER_STATE:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -5200,6 +5245,31 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		break;
 	}
 #endif
+	case KVM_GET_SYSTEM_COUNTER_STATE: {
+		struct kvm_system_counter_state state;
+
+		r = -EFAULT;
+		if (copy_from_user(&state, argp, sizeof(state)))
+			goto out;
+
+		r = kvm_vcpu_get_system_counter_state(vcpu, &state);
+		if (r)
+			goto out;
+		if (copy_to_user(argp, &state, sizeof(state)))
+			r = -EFAULT;
+
+		break;
+	}
+	case KVM_SET_SYSTEM_COUNTER_STATE: {
+		struct kvm_system_counter_state state;
+
+		r = -EFAULT;
+		if (copy_from_user(&state, argp, sizeof(state)))
+			goto out;
+
+		r = kvm_vcpu_set_system_counter_state(vcpu, &state);
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
-- 
2.32.0.rc1.229.g3e70b5a671-goog

