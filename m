Return-Path: <kvm+bounces-19103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 932C4900EA4
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 02:06:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD2301C21BD7
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 00:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF4B429B0;
	Sat,  8 Jun 2024 00:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GedBEcew"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B97634
	for <kvm@vger.kernel.org>; Sat,  8 Jun 2024 00:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717805206; cv=none; b=JOtiWLetpaVCL55F8NNnJ1PIcNcvmaqjh4ZwSGezjbT77SPeGbdKQqG5r1y5t7VSi1q+UqNIAMNlpJDc1wUijg2LsOQNPHT+q6OYHGeCKWgHvLu+jxgopgsSN21GpVZc/8nDMFg9TtuFQXKBYNkzQlAiSsqX3JFuhjkfDjTIllA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717805206; c=relaxed/simple;
	bh=qJZbgpT2J4Q/YFaFhTfRoIrKqervtsXgKC3zR+tLw5s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nnelvjh+ojTlOeX7jNNFXC6AOUZNCEp7ie4CzekZvBfUrXDp3umWhyDn1Lv3esyWrxG34abbgs8VrdBgmv+4JiqbgyAZHtWV9+VR8euOdvxdUWmZjznszn+n7E+U8fNLCYCZGKCJTp4GLuAfIVX4/84t7KzX7J/YS6q62eEHZnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GedBEcew; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f6efc87606so2508245ad.1
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 17:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717805204; x=1718410004; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iq6DmtHz6SSF9fb08PX7PUoTv1+Fjd4jsK+/PHHPXto=;
        b=GedBEcewHodC7XdXHcWYt+kP49pkS6EW5EXw4wp/ZoE8OtxTv+ZfWPNiRZrRcABdF2
         zy9VA6JCN/6vVbcLHbnRVHKhQROTRN4GmWAd+kDkKUXpieS7qnnHO5MqiPZuyhXMICeR
         gRtB9dRVuHeK/deMXqQneaTkvCReWVv2zCzeIwepVmBqxOAYuthWlx0s1yBRnf+HLoTE
         DH86ILMs2Fy/qg/nfuT2CjqYt/ChTI1deHQbKILK9Nilx6kccRJgR1l+lXytYTTE7T5X
         Rk5jAqdw3F8vLBFJbqLOv+JIaX54k37wg/SWrqzgl+bmjVPnXuodwkRi+bp42WNm9nJM
         fVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717805204; x=1718410004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iq6DmtHz6SSF9fb08PX7PUoTv1+Fjd4jsK+/PHHPXto=;
        b=Z5Lx6Lu7XVwl3h0gmDLM+Tlc7wYIUEKyxR3IM2qjBZaiEDWUdjvkA+eRIdgX0iytym
         cBPsmtYivDfAmoHCpv+9C0Hi2L+G4woo5QgjqZvGV+mddmESvjz38dmxGyu2h081yYMg
         qDbeEjgLnOOOeMhGNb9ZPyC5Ch4TjgQKvJ1AsvlU6PSwqeSrjB+okMLae0Be/u9b/4+S
         AJC8ZriIrIEJWGgLsF7niUblmLS0IX0/pmpQKB5sC9KV1k69R1uW2Bmj1CJUXMH35Be+
         lJ2E2naVZ1qblwZJbL69ftOTtaqdqym+6jQTEvBu5ZJm6XdiqTu36p2kiO9VOyUZyyYC
         YZmA==
X-Gm-Message-State: AOJu0YxI9hRlhGhF84v9kAgYYrRILoFuOt9JjbVv8SHf/LVDBa25J+6z
	6t1KBfCMIkTcw+mtdGhF52N+t3Y9/g76S3H4FR+NfD73ax07Dn+Q+wYUSi28Gl1DbVM0dqp8VIC
	VMA==
X-Google-Smtp-Source: AGHT+IFX7XA1z/r7DTD+xg8pBAk2Ziz2yxBNYPknTvwUeL/gY7i62oOk8PrbJK11m2b86KyxJqzu59I5xl4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:aa8a:b0:1f6:565f:27af with SMTP id
 d9443c01a7336-1f6d03b81d4mr1419915ad.12.1717805203627; Fri, 07 Jun 2024
 17:06:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Jun 2024 17:06:32 -0700
In-Reply-To: <20240608000639.3295768-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240608000639.3295768-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240608000639.3295768-2-seanjc@google.com>
Subject: [PATCH v3 1/8] KVM: Use dedicated mutex to protect kvm_usage_count to
 avoid deadlock
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>
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
__kvmclock_cpufreq_notifier(), but actually triggering such deadlocks is
beyond rare due to the combination of dependencies and timings involved.
E.g. the cpufreq notifier is only used on older CPUs without a constant
TSC, mucking with the NX hugepage mitigation while VMs are running is very
uncommon, and doing so while also onlining/offlining a CPU (necessary to
generate contention on cpu_hotplug_lock) would be even more unusual.

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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/locking.rst | 19 ++++++++++++------
 virt/kvm/kvm_main.c                | 31 +++++++++++++++---------------
 2 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 02880d5552d5..5e102fe5b396 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -227,7 +227,13 @@ time it will be set using the Dirty tracking mechanism described above.
 :Type:		mutex
 :Arch:		any
 :Protects:	- vm_list
-		- kvm_usage_count
+
+``kvm_usage_count``
+^^^^^^^^^^^^^^^^^^^
+
+:Type:		mutex
+:Arch:		any
+:Protects:	- kvm_usage_count
 		- hardware virtualization enable/disable
 :Comment:	KVM also disables CPU hotplug via cpus_read_lock() during
 		enable/disable.
@@ -290,11 +296,12 @@ time it will be set using the Dirty tracking mechanism described above.
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
index 4965196cad58..d9b0579d3eea 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5499,6 +5499,7 @@ __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
 static DEFINE_PER_CPU(bool, hardware_enabled);
+static DEFINE_MUTEX(kvm_usage_lock);
 static int kvm_usage_count;
 
 static int __hardware_enable_nolock(void)
@@ -5531,10 +5532,10 @@ static int kvm_online_cpu(unsigned int cpu)
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
 
@@ -5554,10 +5555,10 @@ static void hardware_disable_nolock(void *junk)
 
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
 
@@ -5573,9 +5574,9 @@ static void hardware_disable_all_nolock(void)
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
 
@@ -5606,7 +5607,7 @@ static int hardware_enable_all(void)
 	 * enable hardware multiple times.
 	 */
 	cpus_read_lock();
-	mutex_lock(&kvm_lock);
+	mutex_lock(&kvm_usage_lock);
 
 	r = 0;
 
@@ -5620,7 +5621,7 @@ static int hardware_enable_all(void)
 		}
 	}
 
-	mutex_unlock(&kvm_lock);
+	mutex_unlock(&kvm_usage_lock);
 	cpus_read_unlock();
 
 	return r;
@@ -5648,13 +5649,13 @@ static int kvm_suspend(void)
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
@@ -5664,7 +5665,7 @@ static int kvm_suspend(void)
 
 static void kvm_resume(void)
 {
-	lockdep_assert_not_held(&kvm_lock);
+	lockdep_assert_not_held(&kvm_usage_lock);
 	lockdep_assert_irqs_disabled();
 
 	if (kvm_usage_count)
-- 
2.45.2.505.gda0bf45e8d-goog


