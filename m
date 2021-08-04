Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34693DFD5F
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbhHDI6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235421AbhHDI6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:58:50 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A48C0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:58:37 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id p7-20020a6b63070000b02904f58bb90366so1048348iog.14
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=K7pLZDgIPuV12HPJ9thky4TOXLt6Z7al5u7GtuvUBZA=;
        b=by4LiJhYPpMwogtLXJ7fjEm8BONAI58MOYgbyTmmvv9mv9oTtLGatcNERorAuv0dmW
         UC3XjcBEb+sx3noaVxjS+QVNRj+biM3Lo1eV/RlruKJ50GC+iadfF6aaHguozUNiI3b8
         YVhEsnwcNXmmJJqaEt39Vf/k1B6m654tV9mllpPUiOfRIYnAY37fY/gsmCSkNxueDDY4
         CHN0wKT96CZGFhb8xqQkHDHbLL8+lrMg5+vDb+3rcZNwb2534M5p+W2BHQjONV2mDibP
         t5YC7m8i/+Un2HWG0r/tiICiXyhzpxJRCRei0WxRWZFxrCaI8v+wY5+1CvTYu5q7gqWn
         QVGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=K7pLZDgIPuV12HPJ9thky4TOXLt6Z7al5u7GtuvUBZA=;
        b=qNMo8/5Lj1dZ8RvV9qKXr935185BTeFD44RXIT6A5Fh32BK5RFOGbc+9NqYRc35EPM
         dgpI3wVlZjYd3AqSNo8KYw/p8xe/E1Ptp7os+KqPptaHabngoaUKisEENsWLBRY5hCUE
         96FcWgIj+uALbnEFhNLgVOG7advdWMIOPQKNKzIKEvDbg4qkF+yeZ/g5ZiY4mGeZBZxm
         4VseUcMUAZksw/DaP6vVVTAIB9v7m/eMB6RyQ/9og0qQd/W32oI0Gak7RGh41YUepcnF
         YdnvuGNPMLAyjJmsndG5WmrDn9vBHPboON8r3EUvCq3rAeC4cbzO1pzu+V1OHSZdOsLD
         pv2g==
X-Gm-Message-State: AOAM532UxjomMFpGGlYtPec3SID4EtU/meipJd9xNw1ubw/OYOjFphhG
        0D2qh8zFQwHc1N34B0Hlk/uEq6jvAUC7V5x7rdszG4Fd3DPGeSvw9Z2fbJO8fQJRkJjeIJlEzxL
        Vsz6sBCOYwG8TyHOOxZ51/oDwWBjhBoOGwAo/R7xrnwm8GL8ooedepbWxbQ==
X-Google-Smtp-Source: ABdhPJz2W1LC0u615gdgeVlOBMaE1ErBs2fgBK7IpnYekTHQRjIlezwcsg27qu68TXmnKqnX9nsOS4p49MQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5d:824e:: with SMTP id n14mr394806ioo.134.1628067517220;
 Wed, 04 Aug 2021 01:58:37 -0700 (PDT)
Date:   Wed,  4 Aug 2021 08:58:00 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-3-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 02/21] KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
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

Handling the migration of TSCs correctly is difficult, in part because
Linux does not provide userspace with the ability to retrieve a (TSC,
realtime) clock pair for a single instant in time. In lieu of a more
convenient facility, KVM can report similar information in the kvm_clock
structure.

Provide userspace with a host TSC & realtime pair iff the realtime clock
is based on the TSC. If userspace provides KVM_SET_CLOCK with a valid
realtime value, advance the KVM clock by the amount of elapsed time. Do
not step the KVM clock backwards, though, as it is a monotonic
oscillator.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst  |  42 ++++++++---
 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/kvm/x86.c              | 127 ++++++++++++++++++--------------
 include/uapi/linux/kvm.h        |   7 +-
 4 files changed, 112 insertions(+), 67 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index dae68e68ca23..8d4a3471ad9e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -993,20 +993,34 @@ such as migration.
 When KVM_CAP_ADJUST_CLOCK is passed to KVM_CHECK_EXTENSION, it returns the
 set of bits that KVM can return in struct kvm_clock_data's flag member.
 
-The only flag defined now is KVM_CLOCK_TSC_STABLE.  If set, the returned
-value is the exact kvmclock value seen by all VCPUs at the instant
-when KVM_GET_CLOCK was called.  If clear, the returned value is simply
-CLOCK_MONOTONIC plus a constant offset; the offset can be modified
-with KVM_SET_CLOCK.  KVM will try to make all VCPUs follow this clock,
-but the exact value read by each VCPU could differ, because the host
-TSC is not stable.
+FLAGS:
+
+KVM_CLOCK_TSC_STABLE.  If set, the returned value is the exact kvmclock
+value seen by all VCPUs at the instant when KVM_GET_CLOCK was called.
+If clear, the returned value is simply CLOCK_MONOTONIC plus a constant
+offset; the offset can be modified with KVM_SET_CLOCK.  KVM will try
+to make all VCPUs follow this clock, but the exact value read by each
+VCPU could differ, because the host TSC is not stable.
+
+KVM_CLOCK_REALTIME.  If set, the `realtime` field in the kvm_clock_data
+structure is populated with the value of the host's real time
+clocksource at the instant when KVM_GET_CLOCK was called. If clear,
+the `realtime` field does not contain a value.
+
+KVM_CLOCK_HOST_TSC.  If set, the `host_tsc` field in the kvm_clock_data
+structure is populated with the value of the host's timestamp counter (TSC)
+at the instant when KVM_GET_CLOCK was called. If clear, the `host_tsc` field
+does not contain a value.
 
 ::
 
   struct kvm_clock_data {
 	__u64 clock;  /* kvmclock current value */
 	__u32 flags;
-	__u32 pad[9];
+	__u32 pad0;
+	__u64 realtime;
+	__u64 host_tsc;
+	__u32 pad[4];
   };
 
 
@@ -1023,12 +1037,22 @@ Sets the current timestamp of kvmclock to the value specified in its parameter.
 In conjunction with KVM_GET_CLOCK, it is used to ensure monotonicity on scenarios
 such as migration.
 
+FLAGS:
+
+KVM_CLOCK_REALTIME.  If set, KVM will compare the value of the `realtime` field
+with the value of the host's real time clocksource at the instant when
+KVM_SET_CLOCK was called. The difference in elapsed time is added to the final
+kvmclock value that will be provided to guests.
+
 ::
 
   struct kvm_clock_data {
 	__u64 clock;  /* kvmclock current value */
 	__u32 flags;
-	__u32 pad[9];
+	__u32 pad0;
+	__u64 realtime;
+	__u64 host_tsc;
+	__u32 pad[4];
   };
 
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6818095dd157..d6376ca8efce 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1926,4 +1926,7 @@ int kvm_cpu_dirty_log_size(void);
 
 int alloc_all_memslots_rmaps(struct kvm *kvm);
 
+#define KVM_CLOCK_VALID_FLAGS						\
+	(KVM_CLOCK_TSC_STABLE | KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 34287c522f4e..26f1fa263192 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2804,10 +2804,20 @@ static void get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
 	get_cpu();
 
 	if (__this_cpu_read(cpu_tsc_khz)) {
+#ifdef CONFIG_X86_64
+		struct timespec64 ts;
+
+		if (kvm_get_walltime_and_clockread(&ts, &data->host_tsc)) {
+			data->realtime = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
+			data->flags |= KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC;
+		} else
+#endif
+		data->host_tsc = rdtsc();
+
 		kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
 				   &hv_clock.tsc_shift,
 				   &hv_clock.tsc_to_system_mul);
-		data->clock = __pvclock_read_cycles(&hv_clock, rdtsc());
+		data->clock = __pvclock_read_cycles(&hv_clock, data->host_tsc);
 	} else {
 		data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
 	}
@@ -4047,7 +4057,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_SYNC_X86_VALID_FIELDS;
 		break;
 	case KVM_CAP_ADJUST_CLOCK:
-		r = KVM_CLOCK_TSC_STABLE;
+		r = KVM_CLOCK_VALID_FLAGS;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
 		r |=  KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
@@ -5834,6 +5844,60 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
 }
 #endif /* CONFIG_HAVE_KVM_PM_NOTIFIER */
 
+static int kvm_vm_ioctl_get_clock(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_clock_data data;
+
+	memset(&data, 0, sizeof(data));
+	get_kvmclock(kvm, &data);
+
+	if (copy_to_user(argp, &data, sizeof(data)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_arch *ka = &kvm->arch;
+	struct kvm_clock_data data;
+	u64 now_raw_ns;
+
+	if (copy_from_user(&data, argp, sizeof(data)))
+		return -EFAULT;
+
+	if (data.flags & ~KVM_CLOCK_REALTIME)
+		return -EINVAL;
+
+	/*
+	 * TODO: userspace has to take care of races with VCPU_RUN, so
+	 * kvm_gen_update_masterclock() can be cut down to locked
+	 * pvclock_update_vm_gtod_copy().
+	 */
+	kvm_gen_update_masterclock(kvm);
+
+	spin_lock_irq(&ka->pvclock_gtod_sync_lock);
+	if (data.flags & KVM_CLOCK_REALTIME) {
+		u64 now_real_ns = ktime_get_real_ns();
+
+		/*
+		 * Avoid stepping the kvmclock backwards.
+		 */
+		if (now_real_ns > data.realtime)
+			data.clock += now_real_ns - data.realtime;
+	}
+
+	if (ka->use_master_clock)
+		now_raw_ns = ka->master_kernel_ns;
+	else
+		now_raw_ns = get_kvmclock_base_ns();
+	ka->kvmclock_offset = data.clock - now_raw_ns;
+	spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
+
+	kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
+	return 0;
+}
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
@@ -6077,63 +6141,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		break;
 	}
 #endif
-	case KVM_SET_CLOCK: {
-		struct kvm_arch *ka = &kvm->arch;
-		struct kvm_clock_data user_ns;
-		u64 now_ns;
-
-		r = -EFAULT;
-		if (copy_from_user(&user_ns, argp, sizeof(user_ns)))
-			goto out;
-
-		r = -EINVAL;
-		if (user_ns.flags)
-			goto out;
-
-		r = 0;
-		/*
-		 * TODO: userspace has to take care of races with VCPU_RUN, so
-		 * kvm_gen_update_masterclock() can be cut down to locked
-		 * pvclock_update_vm_gtod_copy().
-		 */
-		kvm_gen_update_masterclock(kvm);
-
-		/*
-		 * This pairs with kvm_guest_time_update(): when masterclock is
-		 * in use, we use master_kernel_ns + kvmclock_offset to set
-		 * unsigned 'system_time' so if we use get_kvmclock_ns() (which
-		 * is slightly ahead) here we risk going negative on unsigned
-		 * 'system_time' when 'user_ns.clock' is very small.
-		 */
-		spin_lock_irq(&ka->pvclock_gtod_sync_lock);
-		if (kvm->arch.use_master_clock)
-			now_ns = ka->master_kernel_ns;
-		else
-			now_ns = get_kvmclock_base_ns();
-		ka->kvmclock_offset = user_ns.clock - now_ns;
-		spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
-
-		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
+	case KVM_SET_CLOCK:
+		r = kvm_vm_ioctl_set_clock(kvm, argp);
 		break;
-	}
-	case KVM_GET_CLOCK: {
-		struct kvm_clock_data user_ns;
-
-		/*
-		 * Zero flags as it is accessed RMW, leave everything else
-		 * uninitialized as clock is always written and no other fields
-		 * are consumed.
-		 */
-		user_ns.flags = 0;
-		get_kvmclock(kvm, &user_ns);
-		memset(&user_ns.pad, 0, sizeof(user_ns.pad));
-
-		r = -EFAULT;
-		if (copy_to_user(argp, &user_ns, sizeof(user_ns)))
-			goto out;
-		r = 0;
+	case KVM_GET_CLOCK:
+		r = kvm_vm_ioctl_get_clock(kvm, argp);
 		break;
-	}
 	case KVM_MEMORY_ENCRYPT_OP: {
 		r = -ENOTTY;
 		if (kvm_x86_ops.mem_enc_op)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d9e4aabcb31a..53a49cb8616a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1223,11 +1223,16 @@ struct kvm_irqfd {
 
 /* Do not use 1, KVM_CHECK_EXTENSION returned it before we had flags.  */
 #define KVM_CLOCK_TSC_STABLE		2
+#define KVM_CLOCK_REALTIME		(1 << 2)
+#define KVM_CLOCK_HOST_TSC		(1 << 3)
 
 struct kvm_clock_data {
 	__u64 clock;
 	__u32 flags;
-	__u32 pad[9];
+	__u32 pad0;
+	__u64 realtime;
+	__u64 host_tsc;
+	__u32 pad[4];
 };
 
 /* For KVM_CAP_SW_TLB */
-- 
2.32.0.605.g8dce9f2422-goog

