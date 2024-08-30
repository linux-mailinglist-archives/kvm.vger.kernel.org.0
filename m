Return-Path: <kvm+bounces-25440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8809996565D
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 06:36:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD71B1C221D5
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 04:36:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FFAB14EC61;
	Fri, 30 Aug 2024 04:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vy5NcXBn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC8214C596
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 04:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724992569; cv=none; b=l4/nw8QQn+fA8j1Ot4RByHYH66MVPnfMmjUNHJd7IUNIBYtnZX4VBNxSRGRX0xB9gJXGJHX+Zqaf71biDckhDZrytgnqi/nG+MSYwvFYFlFkAxuRqM+kbsfMxjovBVTSCyXp568/X6VS4Ai2+EZyEn9S9OFa8C8PlaWPG6t/cHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724992569; c=relaxed/simple;
	bh=AsAMjr3M5eowJL/141Rp5z6U6ynM8B7+aQVy0ucmCwM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V9qD+oDIbMVpbg4UL30AWvIBdBVqeTXNVIHOPVZFjQiWbwyKCQ0aYREiN62j8e+th9b2E3sE5hWb+OqmULHVuoeb9x3nKVdUolTFQsc909FiMag9O3+zGXVQKJquGjB2r2dWXgg21koaOS552kydd1p+LbMnQQGJjMZRujVxoLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vy5NcXBn; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6d2c2cf7473so27065877b3.0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 21:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724992566; x=1725597366; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aHFUvm+FsXoP3qIyVsbx5uEplmYhc4fKnKOy7PZyclA=;
        b=Vy5NcXBnecxTsp85tBMkg8k9i1xin863df7SHVgjO4HyygxYEFP41KkTPth1SkD3Qd
         AsZ34qqMTcHpbGn2iv+ZS0hgRMnA+7lnzbHZhlFA5PB7BJMXFA6ZZxd/VruAKzwbpNj/
         IJaYKRT4nbGdSVZ8aTb5vl5PJTqDUxSlIs4Hm15xkNCPMU+X+oiYaGw5Mkzqd22BkD13
         PQAsiacuJmkyliwDmq/OaksepDqoS/NbL0UBid0smIQpuOLx2MS4eI6iT17XcHnwmD/y
         JqLo11tVCFqqC6l2F/x26Pt5tn5m3ZbLwGve9a1PwpY4iGdAjEltV19tEyfBDQU5/fqp
         M6dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724992566; x=1725597366;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aHFUvm+FsXoP3qIyVsbx5uEplmYhc4fKnKOy7PZyclA=;
        b=xTcZrEz/7jZH1bt7tjdPAKtxxbXPSwi20Jy530MQnrM7JAqFj+XacwpwcxOym5lQkt
         b89A5zK8Aw95cGrEjs7YbefFBewJPeNzOQspDmuxraywtWOlKJlqOhecfJKpI4y2nhep
         JhmPlQiBhatAKI6LPr2Mar8Mh/9v7mJOVkX1EHEBauh9/eI6Q2sVIEhHj5qbGFqGxWQI
         Vdb7KlkY6vf8PPFl70Df/vKol+nE4N6PbzxTN6/E1O0hJfPWP4X6wLVOfhezMTbd/7+2
         iz3ZmRHuhLJxLAj/SafqwXTxiYVTy5pbBfvEUOAiuB52duIuZGFQFUEdUveuZJREKKg4
         MVng==
X-Gm-Message-State: AOJu0YzLSY7HIjsj5dzFlfBad1B20KnWPDgzhNXzJ79D+Xn5gY5sa4Ag
	Gquc6zfLGOe/ixWRbLfSuYg7qUX/f3mS56JckZQaMc6/tCGyR0yRkZj1FP9zjJF4Q7y/ed19fci
	REQ==
X-Google-Smtp-Source: AGHT+IEEIm57E7ZhayVART8ADQcxGPIPqWcj0BvzrgRRlVCf3l6FJVWmFUT6VBh+RffSDLzBCOKmsEJxIDM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:63c8:b0:6af:623c:7694 with SMTP id
 00721157ae682-6d40b0f96b2mr822357b3.0.1724992566315; Thu, 29 Aug 2024
 21:36:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 Aug 2024 21:35:51 -0700
In-Reply-To: <20240830043600.127750-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240830043600.127750-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240830043600.127750-2-seanjc@google.com>
Subject: [PATCH v4 01/10] KVM: Use dedicated mutex to protect kvm_usage_count
 to avoid deadlock
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Farrah Chen <farrah.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"

Use a dedicated mutex to guard kvm_usage_count to fix a potential deadlock
on x86 due to a chain of locks and SRCU synchronizations.  Translating the
below lockdep splat, CPU1 #6 will wait on CPU0 #1, CPU0 #8 will wait on
CPU2 #3, and CPU2 #7 will wait on CPU1 #4 (if there's a writer, due to the
fairness of r/w semaphores).

    CPU0                     CPU1                     CPU2
1   lock(&kvm->slots_lock);
2                                                     lock(&vcpu->mutex);
3                                                     lock(&kvm->srcu);
4                            lock(cpu_hotplug_lock);
5                            lock(kvm_lock);
6                            lock(&kvm->slots_lock);
7                                                     lock(cpu_hotplug_lock);
8   sync(&kvm->srcu);

Note, there are likely more potential deadlocks in KVM x86, e.g. the same
pattern of taking cpu_hotplug_lock outside of kvm_lock likely exists with
__kvmclock_cpufreq_notifier():

  cpuhp_cpufreq_online()
  |
  -> cpufreq_online()
     |
     -> cpufreq_gov_performance_limits()
        |
        -> __cpufreq_driver_target()
           |
           -> __target_index()
              |
              -> cpufreq_freq_transition_begin()
                 |
                 -> cpufreq_notify_transition()
                    |
                    -> ... __kvmclock_cpufreq_notifier()

But, actually triggering such deadlocks is beyond rare due to the
combination of dependencies and timings involved.  E.g. the cpufreq
notifier is only used on older CPUs without a constant TSC, mucking with
the NX hugepage mitigation while VMs are running is very uncommon, and
doing so while also onlining/offlining a CPU (necessary to generate
contention on cpu_hotplug_lock) would be even more unusual.

The most robust solution to the general cpu_hotplug_lock issue is likely
to switch vm_list to be an RCU-protected list, e.g. so that x86's cpufreq
notifier doesn't to take kvm_lock.  For now, settle for fixing the most
blatant deadlock, as switching to an RCU-protected list is a much more
involved change, but add a comment in locking.rst to call out that care
needs to be taken when walking holding kvm_lock and walking vm_list.

  ======================================================
  WARNING: possible circular locking dependency detected
  6.10.0-smp--c257535a0c9d-pip #330 Tainted: G S         O
  ------------------------------------------------------
  tee/35048 is trying to acquire lock:
  ff6a80eced71e0a8 (&kvm->slots_lock){+.+.}-{3:3}, at: set_nx_huge_pages+0x179/0x1e0 [kvm]

  but task is already holding lock:
  ffffffffc07abb08 (kvm_lock){+.+.}-{3:3}, at: set_nx_huge_pages+0x14a/0x1e0 [kvm]

  which lock already depends on the new lock.

   the existing dependency chain (in reverse order) is:

  -> #3 (kvm_lock){+.+.}-{3:3}:
         __mutex_lock+0x6a/0xb40
         mutex_lock_nested+0x1f/0x30
         kvm_dev_ioctl+0x4fb/0xe50 [kvm]
         __se_sys_ioctl+0x7b/0xd0
         __x64_sys_ioctl+0x21/0x30
         x64_sys_call+0x15d0/0x2e60
         do_syscall_64+0x83/0x160
         entry_SYSCALL_64_after_hwframe+0x76/0x7e

  -> #2 (cpu_hotplug_lock){++++}-{0:0}:
         cpus_read_lock+0x2e/0xb0
         static_key_slow_inc+0x16/0x30
         kvm_lapic_set_base+0x6a/0x1c0 [kvm]
         kvm_set_apic_base+0x8f/0xe0 [kvm]
         kvm_set_msr_common+0x9ae/0xf80 [kvm]
         vmx_set_msr+0xa54/0xbe0 [kvm_intel]
         __kvm_set_msr+0xb6/0x1a0 [kvm]
         kvm_arch_vcpu_ioctl+0xeca/0x10c0 [kvm]
         kvm_vcpu_ioctl+0x485/0x5b0 [kvm]
         __se_sys_ioctl+0x7b/0xd0
         __x64_sys_ioctl+0x21/0x30
         x64_sys_call+0x15d0/0x2e60
         do_syscall_64+0x83/0x160
         entry_SYSCALL_64_after_hwframe+0x76/0x7e

  -> #1 (&kvm->srcu){.+.+}-{0:0}:
         __synchronize_srcu+0x44/0x1a0
         synchronize_srcu_expedited+0x21/0x30
         kvm_swap_active_memslots+0x110/0x1c0 [kvm]
         kvm_set_memslot+0x360/0x620 [kvm]
         __kvm_set_memory_region+0x27b/0x300 [kvm]
         kvm_vm_ioctl_set_memory_region+0x43/0x60 [kvm]
         kvm_vm_ioctl+0x295/0x650 [kvm]
         __se_sys_ioctl+0x7b/0xd0
         __x64_sys_ioctl+0x21/0x30
         x64_sys_call+0x15d0/0x2e60
         do_syscall_64+0x83/0x160
         entry_SYSCALL_64_after_hwframe+0x76/0x7e

  -> #0 (&kvm->slots_lock){+.+.}-{3:3}:
         __lock_acquire+0x15ef/0x2e30
         lock_acquire+0xe0/0x260
         __mutex_lock+0x6a/0xb40
         mutex_lock_nested+0x1f/0x30
         set_nx_huge_pages+0x179/0x1e0 [kvm]
         param_attr_store+0x93/0x100
         module_attr_store+0x22/0x40
         sysfs_kf_write+0x81/0xb0
         kernfs_fop_write_iter+0x133/0x1d0
         vfs_write+0x28d/0x380
         ksys_write+0x70/0xe0
         __x64_sys_write+0x1f/0x30
         x64_sys_call+0x281b/0x2e60
         do_syscall_64+0x83/0x160
         entry_SYSCALL_64_after_hwframe+0x76/0x7e

Cc: Chao Gao <chao.gao@intel.com>
Fixes: 0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock")
Cc: stable@vger.kernel.org
Reviewed-by: Kai Huang <kai.huang@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/locking.rst | 32 +++++++++++++++++++++---------
 virt/kvm/kvm_main.c                | 31 +++++++++++++++--------------
 2 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 02880d5552d5..c0cb5ce51c1e 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -9,7 +9,7 @@ KVM Lock Overview
 
 The acquisition orders for mutexes are as follows:
 
-- cpus_read_lock() is taken outside kvm_lock
+- cpus_read_lock() is taken outside kvm_lock and kvm_usage_lock
 
 - kvm->lock is taken outside vcpu->mutex
 
@@ -24,6 +24,12 @@ The acquisition orders for mutexes are as follows:
   are taken on the waiting side when modifying memslots, so MMU notifiers
   must not take either kvm->slots_lock or kvm->slots_arch_lock.
 
+cpus_read_lock() vs kvm_lock:
+- Taking cpus_read_lock() outside of kvm_lock is problematic, despite that
+  being the official ordering, as it is quite easy to unknowingly trigger
+  cpus_read_lock() while holding kvm_lock.  Use caution when walking vm_list,
+  e.g. avoid complex operations when possible.
+
 For SRCU:
 
 - ``synchronize_srcu(&kvm->srcu)`` is called inside critical sections
@@ -227,10 +233,17 @@ time it will be set using the Dirty tracking mechanism described above.
 :Type:		mutex
 :Arch:		any
 :Protects:	- vm_list
-		- kvm_usage_count
+
+``kvm_usage_lock``
+^^^^^^^^^^^^^^^^^^
+
+:Type:		mutex
+:Arch:		any
+:Protects:	- kvm_usage_count
 		- hardware virtualization enable/disable
-:Comment:	KVM also disables CPU hotplug via cpus_read_lock() during
-		enable/disable.
+:Comment:	Exists because using kvm_lock leads to deadlock (see earlier comment
+		on cpus_read_lock() vs kvm_lock).  Note, KVM also disables CPU hotplug via
+		cpus_read_lock() when enabling/disabling virtualization.
 
 ``kvm->mn_invalidate_lock``
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
@@ -290,11 +303,12 @@ time it will be set using the Dirty tracking mechanism described above.
 		wakeup.
 
 ``vendor_module_lock``
-^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+^^^^^^^^^^^^^^^^^^^^^^
 :Type:		mutex
 :Arch:		x86
 :Protects:	loading a vendor module (kvm_amd or kvm_intel)
-:Comment:	Exists because using kvm_lock leads to deadlock.  cpu_hotplug_lock is
-    taken outside of kvm_lock, e.g. in KVM's CPU online/offline callbacks, and
-    many operations need to take cpu_hotplug_lock when loading a vendor module,
-    e.g. updating static calls.
+:Comment:	Exists because using kvm_lock leads to deadlock.  kvm_lock is taken
+    in notifiers, e.g. __kvmclock_cpufreq_notifier(), that may be invoked while
+    cpu_hotplug_lock is held, e.g. from cpufreq_boost_trigger_state(), and many
+    operations need to take cpu_hotplug_lock when loading a vendor module, e.g.
+    updating static calls.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 92901656a0d4..b4cdb659d3e1 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5576,6 +5576,7 @@ __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
 static DEFINE_PER_CPU(bool, hardware_enabled);
+static DEFINE_MUTEX(kvm_usage_lock);
 static int kvm_usage_count;
 
 static int __hardware_enable_nolock(void)
@@ -5608,10 +5609,10 @@ static int kvm_online_cpu(unsigned int cpu)
 	 * be enabled. Otherwise running VMs would encounter unrecoverable
 	 * errors when scheduled to this CPU.
 	 */
-	mutex_lock(&kvm_lock);
+	mutex_lock(&kvm_usage_lock);
 	if (kvm_usage_count)
 		ret = __hardware_enable_nolock();
-	mutex_unlock(&kvm_lock);
+	mutex_unlock(&kvm_usage_lock);
 	return ret;
 }
 
@@ -5631,10 +5632,10 @@ static void hardware_disable_nolock(void *junk)
 
 static int kvm_offline_cpu(unsigned int cpu)
 {
-	mutex_lock(&kvm_lock);
+	mutex_lock(&kvm_usage_lock);
 	if (kvm_usage_count)
 		hardware_disable_nolock(NULL);
-	mutex_unlock(&kvm_lock);
+	mutex_unlock(&kvm_usage_lock);
 	return 0;
 }
 
@@ -5650,9 +5651,9 @@ static void hardware_disable_all_nolock(void)
 static void hardware_disable_all(void)
 {
 	cpus_read_lock();
-	mutex_lock(&kvm_lock);
+	mutex_lock(&kvm_usage_lock);
 	hardware_disable_all_nolock();
-	mutex_unlock(&kvm_lock);
+	mutex_unlock(&kvm_usage_lock);
 	cpus_read_unlock();
 }
 
@@ -5683,7 +5684,7 @@ static int hardware_enable_all(void)
 	 * enable hardware multiple times.
 	 */
 	cpus_read_lock();
-	mutex_lock(&kvm_lock);
+	mutex_lock(&kvm_usage_lock);
 
 	r = 0;
 
@@ -5697,7 +5698,7 @@ static int hardware_enable_all(void)
 		}
 	}
 
-	mutex_unlock(&kvm_lock);
+	mutex_unlock(&kvm_usage_lock);
 	cpus_read_unlock();
 
 	return r;
@@ -5725,13 +5726,13 @@ static int kvm_suspend(void)
 {
 	/*
 	 * Secondary CPUs and CPU hotplug are disabled across the suspend/resume
-	 * callbacks, i.e. no need to acquire kvm_lock to ensure the usage count
-	 * is stable.  Assert that kvm_lock is not held to ensure the system
-	 * isn't suspended while KVM is enabling hardware.  Hardware enabling
-	 * can be preempted, but the task cannot be frozen until it has dropped
-	 * all locks (userspace tasks are frozen via a fake signal).
+	 * callbacks, i.e. no need to acquire kvm_usage_lock to ensure the usage
+	 * count is stable.  Assert that kvm_usage_lock is not held to ensure
+	 * the system isn't suspended while KVM is enabling hardware.  Hardware
+	 * enabling can be preempted, but the task cannot be frozen until it has
+	 * dropped all locks (userspace tasks are frozen via a fake signal).
 	 */
-	lockdep_assert_not_held(&kvm_lock);
+	lockdep_assert_not_held(&kvm_usage_lock);
 	lockdep_assert_irqs_disabled();
 
 	if (kvm_usage_count)
@@ -5741,7 +5742,7 @@ static int kvm_suspend(void)
 
 static void kvm_resume(void)
 {
-	lockdep_assert_not_held(&kvm_lock);
+	lockdep_assert_not_held(&kvm_usage_lock);
 	lockdep_assert_irqs_disabled();
 
 	if (kvm_usage_count)
-- 
2.46.0.469.g59c65b2a67-goog


