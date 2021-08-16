Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE683ECBE9
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbhHPAM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhHPAMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:12:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607D6C061764
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:11:38 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w201-20020a25dfd2000000b00594695384d1so1664319ybg.20
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fOqzwvgotEAk4OwdvYZ5BEZVM02Y3lbMzgT+LwM/G40=;
        b=gTZB/ZB/2P56kjMc1lKSCKMylc+9raK1aQ56bRXEHO3bpP/HN84Z2Z7FPl0iTMF2t0
         3eYmTEPW2KF4yFED9pzDdLF6LaqF/eeuCylPGwe/vhiaVb8hiCPZSoDq1lgtw/NeP7yS
         CSMDPoQkJ3ZsB1IA+jgpZv4Y0ADwHzHhGyHxRWhwDTANC3C3iM37jl7shZi414dwxyBL
         oKe01LTg4IyRAqwhEhEye2DqNrU/rofkIMgqsV1rZR3pRqK3eD/3a1Ub1VQro+dytRhc
         BRGWJYN5CK3oeH2kj/UxJHm/9pi0im1RVruUevIWBgbRQb0dq/F9OKW0cxb2T1ghkiPL
         Pwyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fOqzwvgotEAk4OwdvYZ5BEZVM02Y3lbMzgT+LwM/G40=;
        b=P4NEhg8WnxyjYtTJImK2b2cLaUjReT68y0OJ0BDAmqeFOrmeJiH7WYB4jBPb8/PV10
         1QM3Bq5OOFp3v3xZ6J+yyp+mCHC8ciVeSv6aU+sYhQteYh595A+OeumLXJsHmIK9Mh+Q
         eNEJK2NtuQt4Ncp0iSenbpseSoirSOQXKLpROdbPewtUaZLpXlADTDp0Ri5gQCt+aXT1
         C3FbGVGKR3QBoQ69JTUv85bivItUSMSh+jDwCd7adm5TVAwZCKHOe12+JPfH6EuzI8TS
         ugggZMuVWKEhXX2jZoEavTlAuoKGXiX3EQzlDgTn3tTq/CF+lEU4WjvmgD77FDRmqEcs
         +8gA==
X-Gm-Message-State: AOAM531aXe1G30uuO4lR3dqk7DggesxKCqDQHF5DzXrfyg+jNeVObrs6
        PijJepVlKNhL3oJPrWZuFU+aFF3MITb38hPzLb8Wfm3ngrBBXmBP/26IWNnjFA6bXG114gzJHnL
        C56RgjdzEph4U8pwK3vqifwtrBLELxw+3NYbK6cfAkgoRagY3EXLn9BMskg==
X-Google-Smtp-Source: ABdhPJxATQFnfStab+dOOYxVKWby13GU3DJ5ljaK+HxeHk2KhPLVTDc5Fu1HrzQZMUMtpIj5HWzGmsC1BrY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:7405:: with SMTP id p5mr18675318ybc.94.1629072697457;
 Sun, 15 Aug 2021 17:11:37 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:11:27 +0000
In-Reply-To: <20210816001130.3059564-1-oupton@google.com>
Message-Id: <20210816001130.3059564-4-oupton@google.com>
Mime-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 3/6] KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
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
 Documentation/virt/kvm/api.rst  | 42 ++++++++++++++++++++++++++-------
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/x86.c              | 34 ++++++++++++++++++--------
 include/uapi/linux/kvm.h        |  7 +++++-
 4 files changed, 66 insertions(+), 20 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 86d7ad3a126c..b3d12bf9fbf5 100644
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
index 20daaf67a5bf..7fad2615f4a9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1916,4 +1916,7 @@ int kvm_cpu_dirty_log_size(void);
 
 int alloc_all_memslots_rmaps(struct kvm *kvm);
 
+#define KVM_CLOCK_VALID_FLAGS						\
+	(KVM_CLOCK_TSC_STABLE | KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC)
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 39eaa2fb2001..b1e9a4885be6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2809,10 +2809,20 @@ static void get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
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
@@ -4052,7 +4062,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_SYNC_X86_VALID_FIELDS;
 		break;
 	case KVM_CAP_ADJUST_CLOCK:
-		r = KVM_CLOCK_TSC_STABLE;
+		r = KVM_CLOCK_VALID_FLAGS;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
 		r |=  KVM_X86_DISABLE_EXITS_HLT | KVM_X86_DISABLE_EXITS_PAUSE |
@@ -5837,14 +5847,8 @@ static int kvm_vm_ioctl_get_clock(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_clock_data data;
 
-	/*
-	 * Zero flags as it is accessed RMW, leave everything else
-	 * uninitialized as clock is always written and no other fields
-	 * are consumed.
-	 */
-	data.flags = 0;
+	memset(&data, 0, sizeof(data));
 	get_kvmclock(kvm, &data);
-	memset(&data.pad, 0, sizeof(data.pad));
 
 	if (copy_to_user(argp, &data, sizeof(data)))
 		return -EFAULT;
@@ -5861,13 +5865,23 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
 	if (copy_from_user(&data, argp, sizeof(data)))
 		return -EFAULT;
 
-	if (data.flags)
+	if (data.flags & ~KVM_CLOCK_REALTIME)
 		return -EINVAL;
 
 	kvm_hv_invalidate_tsc_page(kvm);
 	kvm_start_pvclock_update(kvm);
 	pvclock_update_vm_gtod_copy(kvm);
 
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
 	/*
 	 * This pairs with kvm_guest_time_update(): when masterclock is
 	 * in use, we use master_kernel_ns + kvmclock_offset to set
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a067410ebea5..d228bf394465 100644
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
2.33.0.rc1.237.g0d66db33f3-goog

