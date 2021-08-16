Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94BDE3ECBEC
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhHPAM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231861AbhHPAMM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:12:12 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8719EC0617AD
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:11:41 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id s9-20020ad450090000b029034fef0edad8so11783890qvo.21
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=J/3kqHaHqhmnKwrHoMPM0ZlNGfNvJm2eth5nUFdCMDA=;
        b=lWAe2bkLnP2RZHENEsb3Km2+TAYR519X/MWjvSccLXFB2GldsN1VyRPQ5mW0F2BYlw
         E9v7oknYR2V65GsyUntrQnqDKFtRBVHvGhVVUDjamUf3oiSkNNuze/bWX8zPVJVJzXNC
         hHHwv6p56PtA8BIjOvzL7w53kdQqVjJbYIugRTjWxNWXnk+r/vDs2rqGf1iZY9bqSh9C
         DeEN2q7ZSoOT3+VNV9HhGyx1woN8GWQ0Vfj07KcMpKumaafSVDj+JBsFmuQeHd/cj1eI
         4vd3yGpSENidn2i2tzDtNxKbl97FMVgvxNyFkAVx2x4+p4OLafFcs1G9EAKuhyf6/H8X
         P+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=J/3kqHaHqhmnKwrHoMPM0ZlNGfNvJm2eth5nUFdCMDA=;
        b=DpxM8bQGd0N6Mia04pWxUyaBwX4VkEqc+0iVVKI91FNCnGBnDARVvQEfNKgO2Sdwk5
         BvKqNW5Fy6LHnPcIPgmhTgvuH40bJxIB7QaQRPBraLqTcVWT/fsOtaZC0laSUOf7bpNM
         YX2KrJmnNKB0Nbp035qLUu0d1ytgxqRmUL4g7mnPZn9peL7nQHdYE3Of0oWdRSR2GvlB
         seWnpMVayRewS1t1R6hL5P4eCFnUGXUaQRdkjuAx8D9NJoYVtsFqmuG/KsypP4VlTbyU
         vOo/noLVm6aUAEVJ8zxQhYbx36sEgubOT1EONH0fwAHYawet3AUfUR17LyRhCwLD8j9i
         epfA==
X-Gm-Message-State: AOAM533fbrgBpnb+YuZVLTgEgQN3nJIlAvTEeT4RTgDpZYbe+mlntaOY
        hqvPhWjaH++BC1fzngwmI39npZETyO+8PVK6kYSG94KbmHbrxY4nJmXQLjNsTilKLSjPPhGqTWn
        NeEt0L4Bq64NzD1PUQ2LrwI00VuyuZ2Rnf3Vh6L/PatsD9RvUjAP3HGupng==
X-Google-Smtp-Source: ABdhPJyRvEL0jJdTP2zROUoA9tF1O2ZqfbMeyOeNxHBxzx4l3GZm/jafv62X7H59aGC5dQa5XzTEAGZtmbo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:2465:: with SMTP id
 im5mr13584587qvb.46.1629072700634; Sun, 15 Aug 2021 17:11:40 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:11:30 +0000
In-Reply-To: <20210816001130.3059564-1-oupton@google.com>
Message-Id: <20210816001130.3059564-7-oupton@google.com>
Mime-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 6/6] KVM: x86: Expose TSC offset controls to userspace
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
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To date, VMM-directed TSC synchronization and migration has been a bit
messy. KVM has some baked-in heuristics around TSC writes to infer if
the VMM is attempting to synchronize. This is problematic, as it depends
on host userspace writing to the guest's TSC within 1 second of the last
write.

A much cleaner approach to configuring the guest's views of the TSC is to
simply migrate the TSC offset for every vCPU. Offsets are idempotent,
and thus not subject to change depending on when the VMM actually
reads/writes values from/to KVM. The VMM can then read the TSC once with
KVM_GET_CLOCK to capture a (realtime, host_tsc) pair at the instant when
the guest is paused.

Cc: David Matlack <dmatlack@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/devices/vcpu.rst |  57 +++++++++++++
 arch/x86/include/asm/kvm_host.h         |   1 +
 arch/x86/include/uapi/asm/kvm.h         |   4 +
 arch/x86/kvm/x86.c                      | 109 ++++++++++++++++++++++++
 4 files changed, 171 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 2acec3b9ef65..3b399d727c11 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -161,3 +161,60 @@ Specifies the base address of the stolen time structure for this VCPU. The
 base address must be 64 byte aligned and exist within a valid guest memory
 region. See Documentation/virt/kvm/arm/pvtime.rst for more information
 including the layout of the stolen time structure.
+
+4. GROUP: KVM_VCPU_TSC_CTRL
+===========================
+
+:Architectures: x86
+
+4.1 ATTRIBUTE: KVM_VCPU_TSC_OFFSET
+
+:Parameters: 64-bit unsigned TSC offset
+
+Returns:
+
+	 ======= ======================================
+	 -EFAULT Error reading/writing the provided
+		 parameter address.
+	 -ENXIO  Attribute not supported
+	 ======= ======================================
+
+Specifies the guest's TSC offset relative to the host's TSC. The guest's
+TSC is then derived by the following equation:
+
+  guest_tsc = host_tsc + KVM_VCPU_TSC_OFFSET
+
+This attribute is useful for the precise migration of a guest's TSC. The
+following describes a possible algorithm to use for the migration of a
+guest's TSC:
+
+From the source VMM process:
+
+1. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (t_0),
+   kvmclock nanoseconds (k_0), and realtime nanoseconds (r_0).
+
+2. Read the KVM_VCPU_TSC_OFFSET attribute for every vCPU to record the
+   guest TSC offset (off_n).
+
+3. Invoke the KVM_GET_TSC_KHZ ioctl to record the frequency of the
+   guest's TSC (freq).
+
+From the destination VMM process:
+
+4. Invoke the KVM_SET_CLOCK ioctl, providing the kvmclock nanoseconds
+   (k_0) and realtime nanoseconds (r_0) in their respective fields.
+   Ensure that the KVM_CLOCK_REALTIME flag is set in the provided
+   structure. KVM will advance the VM's kvmclock to account for elapsed
+   time since recording the clock values.
+
+5. Invoke the KVM_GET_CLOCK ioctl to record the host TSC (t_1) and
+   kvmclock nanoseconds (k_1).
+
+6. Adjust the guest TSC offsets for every vCPU to account for (1) time
+   elapsed since recording state and (2) difference in TSCs between the
+   source and destination machine:
+
+   new_off_n = t_0 + off_n + (k_1 - k_0) * freq - t_1
+
+7. Write the KVM_VCPU_TSC_OFFSET attribute for every vCPU with the
+   respective value derived in the previous step.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7fad2615f4a9..376b26a294c9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1071,6 +1071,7 @@ struct kvm_arch {
 	u64 last_tsc_nsec;
 	u64 last_tsc_write;
 	u32 last_tsc_khz;
+	u64 last_tsc_offset;
 	u64 cur_tsc_nsec;
 	u64 cur_tsc_write;
 	u64 cur_tsc_offset;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index a6c327f8ad9e..0b22e1e84e78 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -503,4 +503,8 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+/* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
+#define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
+#define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9d0445527dad..0b1398d439c0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2470,6 +2470,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	kvm->arch.last_tsc_nsec = ns;
 	kvm->arch.last_tsc_write = tsc;
 	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
+	kvm->arch.last_tsc_offset = offset;
 
 	vcpu->arch.last_guest_tsc = tsc;
 
@@ -4923,6 +4924,109 @@ static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int kvm_arch_tsc_has_attr(struct kvm_vcpu *vcpu,
+				 struct kvm_device_attr *attr)
+{
+	int r;
+
+	switch (attr->attr) {
+	case KVM_VCPU_TSC_OFFSET:
+		r = 0;
+		break;
+	default:
+		r = -ENXIO;
+	}
+
+	return r;
+}
+
+static int kvm_arch_tsc_get_attr(struct kvm_vcpu *vcpu,
+				 struct kvm_device_attr *attr)
+{
+	u64 __user *uaddr = (u64 __user *)attr->addr;
+	int r;
+
+	switch (attr->attr) {
+	case KVM_VCPU_TSC_OFFSET:
+		r = -EFAULT;
+		if (put_user(vcpu->arch.l1_tsc_offset, uaddr))
+			break;
+		r = 0;
+		break;
+	default:
+		r = -ENXIO;
+	}
+
+	return r;
+}
+
+static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
+				 struct kvm_device_attr *attr)
+{
+	u64 __user *uaddr = (u64 __user *)attr->addr;
+	struct kvm *kvm = vcpu->kvm;
+	int r;
+
+	switch (attr->attr) {
+	case KVM_VCPU_TSC_OFFSET: {
+		u64 offset, tsc, ns;
+		unsigned long flags;
+		bool matched;
+
+		r = -EFAULT;
+		if (get_user(offset, uaddr))
+			break;
+
+		raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
+
+		matched = (vcpu->arch.virtual_tsc_khz &&
+			   kvm->arch.last_tsc_khz == vcpu->arch.virtual_tsc_khz &&
+			   kvm->arch.last_tsc_offset == offset);
+
+		tsc = kvm_scale_tsc(vcpu, rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
+		ns = get_kvmclock_base_ns();
+
+		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
+		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
+
+		r = 0;
+		break;
+	}
+	default:
+		r = -ENXIO;
+	}
+
+	return r;
+}
+
+static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
+				      unsigned int ioctl,
+				      void __user *argp)
+{
+	struct kvm_device_attr attr;
+	int r;
+
+	if (copy_from_user(&attr, argp, sizeof(attr)))
+		return -EFAULT;
+
+	if (attr.group != KVM_VCPU_TSC_CTRL)
+		return -ENXIO;
+
+	switch (ioctl) {
+	case KVM_HAS_DEVICE_ATTR:
+		r = kvm_arch_tsc_has_attr(vcpu, &attr);
+		break;
+	case KVM_GET_DEVICE_ATTR:
+		r = kvm_arch_tsc_get_attr(vcpu, &attr);
+		break;
+	case KVM_SET_DEVICE_ATTR:
+		r = kvm_arch_tsc_set_attr(vcpu, &attr);
+		break;
+	}
+
+	return r;
+}
+
 static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 				     struct kvm_enable_cap *cap)
 {
@@ -5377,6 +5481,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = __set_sregs2(vcpu, u.sregs2);
 		break;
 	}
+	case KVM_HAS_DEVICE_ATTR:
+	case KVM_GET_DEVICE_ATTR:
+	case KVM_SET_DEVICE_ATTR:
+		r = kvm_vcpu_ioctl_device_attr(vcpu, ioctl, argp);
+		break;
 	default:
 		r = -EINVAL;
 	}
-- 
2.33.0.rc1.237.g0d66db33f3-goog

