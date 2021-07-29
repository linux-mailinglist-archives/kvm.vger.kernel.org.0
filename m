Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7353DAA44
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 19:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhG2RdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 13:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbhG2RdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 13:33:11 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EB4C0613C1
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 10:33:07 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id v7-20020ac874870000b029024e8ccfcd07so3052330qtq.11
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 10:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fRUdGbH40i8TrYigfFw4dJ7fLH6f4HtYWhV617kGra0=;
        b=daNKW6WBfjhN+oBfFEXjXHPz325Oxlx2mdlJsKwyF9lsxo1CUZ5OimMv7JWQ66go8E
         zwGOhBPhgzcQhKBlCAmh8/ycnHye/fnzJHAFOYpLxi5LPd7VFfyVFOdmqOP3EoCfVK/W
         7rmQK+iPZHNeL8owwDmcyEfXUbZ0ZbSM4VhSEeopQwtxkSFFr4IXmo2vlrXnm/rbuR8v
         Qx1z7MAWNGw0x60TZCLQSulV2G2HANvd/Kxv4FSV4NE2FzPQAyJtk3ye3K3Yw1V4u3ht
         oqRs4dxcXBwNN+s0nY6rApW/XqI5oxZ8HcPkNG6zqWTwxzQpq2n4srVMWt5P985cClpW
         6wTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fRUdGbH40i8TrYigfFw4dJ7fLH6f4HtYWhV617kGra0=;
        b=uBNxzHSj7atltbJFgmbx7U6bSCPtSqf8NZCkdpnyP0LzkJ8ebOjMtFHT4tv3GDEpg8
         0GBZUXRyyMy9XVF+0KPM+wCR/NXGdTEuoIfNKdzYgmAnb7cLdHGW/r/b4NzWGqk7a8gj
         vHLIui0Itn+atyn1h+J+KNpE2OHJ4vEJxzHNSxh13lWKzb/OsMtFwexN02jWVgmxk17l
         aNTv4nU1z1BjJ7VrPkcpV0q1MB0sOCPTQgfxFn5rHHaIKKnVhxYxv72i/m9cbcSyOZBb
         ZmuVKiI9EHFQstLN+ou/HIqh+rfP6hvtzV/Vj4tHA+EqF2aiaUfE7BuMljhOytJxech3
         x4og==
X-Gm-Message-State: AOAM530OKKowxJl340MDEwYbjA83D3fitKjMhj/21B2KnqmM4SbeCFgu
        rutFqQQpZGzTd6aJkqI5gHPIQfMPLPAy9o9Li3zuZwHH+E1d3RTCyJn+VrblvoIGfnAjIqul6pD
        9XUqBqOvnyKZG6zbTS9mctoxH6XSdP4ZnUIiKJn8f+dG9BZEOEwSTjXaAZQ==
X-Google-Smtp-Source: ABdhPJxrnlzJIztE0Ak40tXrn1c4p96Wl8YIEoTFnxkqsB1vH3t2z7VH/xJJzTkP/nAKjmOj858hAJyozVU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:4006:: with SMTP id
 kd6mr6389368qvb.61.1627579986942; Thu, 29 Jul 2021 10:33:06 -0700 (PDT)
Date:   Thu, 29 Jul 2021 17:32:50 +0000
In-Reply-To: <20210729173300.181775-1-oupton@google.com>
Message-Id: <20210729173300.181775-4-oupton@google.com>
Mime-Version: 1.0
References: <20210729173300.181775-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v5 03/13] KVM: x86: Expose TSC offset controls to userspace
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
Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/devices/vcpu.rst |  57 ++++++++
 arch/x86/include/asm/kvm_host.h         |   1 +
 arch/x86/include/uapi/asm/kvm.h         |   4 +
 arch/x86/kvm/x86.c                      | 167 ++++++++++++++++++++++++
 4 files changed, 229 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 2acec3b9ef65..0f46f2588905 100644
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
+	 	 parameter address.
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
index 65a20c64f959..855698923dd0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1070,6 +1070,7 @@ struct kvm_arch {
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
index 27435a07fb46..17d87a8d0c75 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2413,6 +2413,11 @@ static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
 	static_call(kvm_x86_write_tsc_offset)(vcpu, vcpu->arch.tsc_offset);
 }
 
+static u64 kvm_vcpu_read_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.l1_tsc_offset;
+}
+
 static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 l1_multiplier)
 {
 	vcpu->arch.l1_tsc_scaling_ratio = l1_multiplier;
@@ -2469,6 +2474,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	kvm->arch.last_tsc_nsec = ns;
 	kvm->arch.last_tsc_write = tsc;
 	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
+	kvm->arch.last_tsc_offset = offset;
 
 	vcpu->arch.last_guest_tsc = tsc;
 
@@ -4928,6 +4934,137 @@ static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
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
+	void __user *uaddr = (void __user *)attr->addr;
+	int r;
+
+	switch (attr->attr) {
+	case KVM_VCPU_TSC_OFFSET: {
+		u64 offset;
+
+		offset = kvm_vcpu_read_tsc_offset(vcpu);
+		r = -EFAULT;
+		if (copy_to_user(uaddr, &offset, sizeof(offset)))
+			break;
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
+static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
+				 struct kvm_device_attr *attr)
+{
+	void __user *uaddr = (void __user *)attr->addr;
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
+		if (copy_from_user(&offset, uaddr, sizeof(offset)))
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
+static int kvm_vcpu_ioctl_has_device_attr(struct kvm_vcpu *vcpu,
+					  struct kvm_device_attr *attr)
+{
+	int r;
+
+	switch (attr->group) {
+	case KVM_VCPU_TSC_CTRL:
+		r = kvm_arch_tsc_has_attr(vcpu, attr);
+		break;
+	default:
+		r = -ENXIO;
+		break;
+	}
+
+	return r;
+}
+
+static int kvm_vcpu_ioctl_get_device_attr(struct kvm_vcpu *vcpu,
+					  struct kvm_device_attr *attr)
+{
+	int r;
+
+	switch (attr->group) {
+	case KVM_VCPU_TSC_CTRL:
+		r = kvm_arch_tsc_get_attr(vcpu, attr);
+		break;
+	default:
+		r = -ENXIO;
+		break;
+	}
+
+	return r;
+}
+
+static int kvm_vcpu_ioctl_set_device_attr(struct kvm_vcpu *vcpu,
+					  struct kvm_device_attr *attr)
+{
+	int r;
+
+	switch (attr->group) {
+	case KVM_VCPU_TSC_CTRL:
+		r = kvm_arch_tsc_set_attr(vcpu, attr);
+		break;
+	default:
+		r = -ENXIO;
+		break;
+	}
+
+	return r;
+}
+
 static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 				     struct kvm_enable_cap *cap)
 {
@@ -5382,6 +5519,36 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = __set_sregs2(vcpu, u.sregs2);
 		break;
 	}
+	case KVM_HAS_DEVICE_ATTR: {
+		struct kvm_device_attr attr;
+
+		r = -EFAULT;
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			goto out;
+
+		r = kvm_vcpu_ioctl_has_device_attr(vcpu, &attr);
+		break;
+	}
+	case KVM_GET_DEVICE_ATTR: {
+		struct kvm_device_attr attr;
+
+		r = -EFAULT;
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			goto out;
+
+		r = kvm_vcpu_ioctl_get_device_attr(vcpu, &attr);
+		break;
+	}
+	case KVM_SET_DEVICE_ATTR: {
+		struct kvm_device_attr attr;
+
+		r = -EFAULT;
+		if (copy_from_user(&attr, argp, sizeof(attr)))
+			goto out;
+
+		r = kvm_vcpu_ioctl_set_device_attr(vcpu, &attr);
+		break;
+	}
 	default:
 		r = -EINVAL;
 	}
-- 
2.32.0.432.gabb21c7263-goog

