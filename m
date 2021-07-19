Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD1F3CEE58
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 23:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387879AbhGSUg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 16:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383750AbhGSSKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 14:10:05 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35884C0613E4
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 11:38:10 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id y3-20020ae9f4030000b02903b916ae903fso8690663qkl.6
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 11:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gVY1OcKTRkdtAsXEWyCj2ppxRNB8jvE/V1F4Gd0MP+c=;
        b=rIe4EYIHZTwOJ/LUiUNHR7ZP9KqycOwxusCIiH31hPQqFcVGTBc1V7P3yBAW5nLMOf
         rVtsH9MK/R3IUquzLnJFycOUHo+NDeEQOzM3VNusblsfRBTvJvyA9sd/uVCjpaPYgN2Z
         Pqzh/O7c+NxCnojD2tFCdhNGFve1zeafT1c2aRlALZVA49Yfo4japt7RG6fVIAICydTj
         nAVp6rKK4uOqi8/bJIJm8Lkmta2iqxjy19MO47gej1GC/N5QLDS8F2hW84QKHy1HuqZo
         FOPG6e4fTJXX8F2b/SlCENE/xNxwWvK6F0wJDI3/YzAyW4CkWurni2c52QqsedvFxsJ2
         vwMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gVY1OcKTRkdtAsXEWyCj2ppxRNB8jvE/V1F4Gd0MP+c=;
        b=Bi+b+qrynnfN016T1sbGUkz7yz/jfJxFf/hwW6Dx0aZ0a3MfztI6UhjoGpiw3pb4RE
         3PqmbKqg78W/xknRheKHGOVne4RIf1FR4loz4Gdq//pHpeHgTa68iGxJGk72CU7VIbSJ
         UU50SaIRSWmN3QvoKYiZgqapNVBWlfvXr6p2TPBMXvfJ2UT+F0hg7qljj2SBdtmHqxLd
         FP093ihX/D1pJfViRWUcwwqQqoTRvwUaOaOKXCHa2iRXbzom2Q95gAZYlF6Q6PrwDe5p
         nTmi8MuiBzHk+cvB8OQy/UeGsVGKNgDfhIGUMVxnsVDjS5p1RdY8YRgOP95e/xYUbWCH
         2+9g==
X-Gm-Message-State: AOAM533ZY6vCXQMZMhxJvPjaJ/fAibKHuwtHTG6bwfCQ2RufNrwGVpZ6
        ycRsFRpeUaGT4ApkajieOhThIlEPADT97qXNjd62z84IfsTMVn79P8ZciyVF7w5kQ0/suRvF5e/
        HHdsAGs8jqaQ7tr5GAY90GEQgkGEAZs5uV9eHlOaEB4ic8rQopQROlomrFw==
X-Google-Smtp-Source: ABdhPJwMtLpMckHH8SI1H19lvBkJcK8ZOjmQJ0hNe6s1ExY+akygtzdlgbYmN9GT8ZpsFuaNtAn7yVUJPzI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:16ca:: with SMTP id
 d10mr25973873qvz.59.1626720603342; Mon, 19 Jul 2021 11:50:03 -0700 (PDT)
Date:   Mon, 19 Jul 2021 18:49:40 +0000
In-Reply-To: <20210719184949.1385910-1-oupton@google.com>
Message-Id: <20210719184949.1385910-4-oupton@google.com>
Mime-Version: 1.0
References: <20210719184949.1385910-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 03/12] KVM: x86: Expose TSC offset controls to userspace
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
index 2acec3b9ef65..b46d5f742e69 100644
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
+   new_off_n = t_0 + off_n = (k_1 - k_0) * freq - t_1
+
+7. Write the KVM_VCPU_TSC_OFFSET attribute for every vCPU with the
+   respective value derived in the previous step.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3fb2b9270d01..5f2e909b83eb 100644
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
index 580ba0e86687..9e7867410091 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2411,6 +2411,11 @@ static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 l1_offset)
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
@@ -2467,6 +2472,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	kvm->arch.last_tsc_nsec = ns;
 	kvm->arch.last_tsc_write = tsc;
 	kvm->arch.last_tsc_khz = vcpu->arch.virtual_tsc_khz;
+	kvm->arch.last_tsc_offset = offset;
 
 	vcpu->arch.last_guest_tsc = tsc;
 
@@ -4914,6 +4920,137 @@ static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
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
@@ -5368,6 +5505,36 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
2.32.0.402.g57bb445576-goog

