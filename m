Return-Path: <kvm+bounces-36583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 30322A1BF16
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2025 00:45:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16249188FC85
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 23:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 744581EEA2E;
	Fri, 24 Jan 2025 23:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EKCs0rlc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF542B9BC
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 23:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737762299; cv=none; b=H1GtbTsI+qlwfVuAUhBvFdbzwZLlSpwsLr5S47YrXHzWs9wI7QD/wYIz+5gnEiyoUPchj5l2oFt0FajJo2yir9t3jdf21NVSyPSW3GQPpGZ6z7ga0MwitoUPfUa7vL7qmtkkUKgTeWSeubcCBmTMAW72nW+v5+PpkMtvU2m7ylU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737762299; c=relaxed/simple;
	bh=rUr16Gh2E03IjABERwE87pz2eo3qnk7+IEb2BAuflY4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ffVwE1FxLDqZtyj9CUYRSJkDWtm9VwlsgKRPWvwUaABln0QZ2YhJfVdSmgn81wzNLlxD/zhGZ6Sg6VUgpXFaAYRXU33rrxMxiS006ezRimO3StTbvrsmTYQ9xFEhhNg4y9dSfk13frS9XIE5ckeIjvxlw4NT4NOHCnTiAFzlLHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EKCs0rlc; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21640607349so62156065ad.0
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 15:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737762297; x=1738367097; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=je/I47EYUB+PpcUZ1/0QwgtzzM9PYOHzghBx3MDQBGw=;
        b=EKCs0rlcIhueSH9QMfuTYE0G3YCHCF2ho/HLVGhi9Q+NGJJwgxd0G7iSKFPk+UovbG
         V3TyHwvN47Py8HJsG+gjooXDVP7NJrLUXgQ7LXsMuHV3Sd1KMd62c52r5uN0pNgFkh6J
         JIZ1m/yl5k2JY6bOqBbrs4JH91qKLX1PuXpPV9+WIoiMho/qJ/09j02I+pZT5iPZrzBs
         YRsUWORxAqNZm2S7l0fAi7aNkr5jFEmfBy2Pp9UypYBxXiq6c9IBdx8+q5/VYTMOVN6/
         O20/qG+KzFpdZJBPjOWgdzO6nwZ1WkcyN1e9w/4x6kl+HM6a0NHYhODUyMKPIwu7Pm2A
         IYMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737762297; x=1738367097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=je/I47EYUB+PpcUZ1/0QwgtzzM9PYOHzghBx3MDQBGw=;
        b=vbbUKlQUzztQYlytx0cHWMSFQOJ0i5fcpCJ0esuUTWFYmnU1gqyEalr/liI5wpufT3
         wyWFFYxoSxdm/pmtXcenE+JCWmjw3Uk147GHJ5imO0im6Sy80TmWnA+bIO8UKseD18He
         3AwmAZ9hwP3ch+vcfe0KjkS6rWxzH3LIZlGh38wvxgc/7Jv0a9Uy20b+5bejr4I4obgA
         IfOT14tHl82Erqz9/8Iln9muLC3yRFtqC4zDo7IEwdk/O95YXbColB6qBGqRnGtQgrQf
         KNxAqyW5k2/SaMIy/3hChg31n0I8Ts3STeDKqhJmA7qyeKKIvjLvBPuv3e1Vgsv306fC
         2uoA==
X-Forwarded-Encrypted: i=1; AJvYcCUVMIMV+WU5JwkiiNtvm0/dQdEao/Dd1TpJ78k/+g20RFm7wwCc/fqwQTiTqOqGEqF/V3o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxemp77Vxt86PdbGixkp3AlLTyPODVTZnLwy0S8ysfdLi1Ru7c8
	zohG2HpVdtRFpYaKwLmrLaQu0IP86+MuHtQ7dNNoXJ4GMibodTUs2oSMFk7myT87CnNnsnQDuq+
	LaA==
X-Google-Smtp-Source: AGHT+IGB4Wp3yE5PYJMqITriXU/f4vIMrdEJvPGjRSXHmcRLl3Nat0H8fwN+OOEdwW6nejbdK0FAMPGy3hY=
X-Received: from pfd10.prod.google.com ([2002:a05:6a00:a80a:b0:725:d350:a304])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:918b:b0:1e0:c50c:9842
 with SMTP id adf61e73a8af0-1eb2157fce9mr59488905637.31.1737762297203; Fri, 24
 Jan 2025 15:44:57 -0800 (PST)
Date: Fri, 24 Jan 2025 15:44:55 -0800
In-Reply-To: <CABgObfa4TKcj-d3Spw+TAE7ZfO8wFGJebkW3jMyFY2TrKxMuSw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250124191109.205955-1-pbonzini@redhat.com> <20250124191109.205955-2-pbonzini@redhat.com>
 <Z5Pz7Ga5UGt88zDc@google.com> <CABgObfa4TKcj-d3Spw+TAE7ZfO8wFGJebkW3jMyFY2TrKxMuSw@mail.gmail.com>
Message-ID: <Z5QhGndjNwYdnIZF@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: fix usage of kvm_lock in set_nx_huge_pages()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 24, 2025, Paolo Bonzini wrote:
> Il ven 24 gen 2025, 21:11 Sean Christopherson <seanjc@google.com> ha scritto:
> > Heh, except it's all kinds of broken.
> 
> Yes, I didn't even try.
> 
> > IMO, biting the bullet and converting to
> > an SRCU-protected list is going to be far less work in the long run.
> 
> I did try a long SRCU critical section and it was unreviewable. It
> ends up a lot less manageable than just making the lock a leaf,
> especially as the lock hierarchy spans multiple subsystems (static
> key, KVM, cpufreq---thanks CPU hotplug lock...).

I'm not following.  If __kvmclock_cpufreq_notifier() and set_nx_huge_pages()
switch to SRCU, then the deadlock goes away (it might even go away if just one
of those two switches).

SRCU readers would only interact with kvm_destroy_vm() from a locking perspective,
and if that's problematic then we would already have a plethora of issues.

> I also didn't like adding a synchronization primitive that's... kinda
> single-use, but that would not be a blocker of course.

It would be single use in the it only protects pure reader of vm_list, but there
are plenty of those users.

> So the second attempt was regular RCU, which looked a lot like this
> patch. I started writing all the dances to find a struct kvm that
> passes kvm_get_kvm_safe() before you do rcu_read_unlock() and drop the
> previous one (because you cannot do kvm_put_kvm() within the RCU read
> side) and set aside the idea, incorrectly thinking that they were not
> needed with kvm_lock. Plus I didn't like having to keep alive a bunch
> of data for a whole grace period if call_rcu() is used.
> 
> So for the third attempt I could have chosen between dropping the SRCU
> or just using kvm_lock. I didn't even think of SRCU to be honest,
> because everything so far looked so bad, but it does seem a little
> better than RCU. At least, if kvm_destroy_vm() uses call_srcu(), you
> can call kvm_put_kvm() within srcu_read_lock()...srcu_read_unlock().
> It would look something like
> 
>   list_for_each_entry_srcu(kvm, &vm_list, vm_list, 1) {
>     if (!kvm_get_kvm_safe(kvm))

Unless I'm missing something, we shouldn't need to take a reference so long as
SRCU is synchronized before destroying any part of the VM.  If we don't take a
reference, then we don't need to deal with the complexity of kvm_put_kvm()
creating a recursive lock snafu.

This is what I'm thinking, lightly tested...

---
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 24 Jan 2025 15:15:05 -0800
Subject: [PATCH] KVM: Use an SRCU lock to protect readers of vm_list

Introduce a global SRCU lock to protect KVM's global list of VMs, and use
it in all locations that currently take kvm_lock purely to prevent a VM
from being destroyed.

Keep using kvm_lock for flows that need to prevent VMs from being created,
as SRCU synchronization only guards against use-after-free, it doesn't
ensure a stable vm_list for readers.

This fixes a largely theoretical deadlock where:

  - __kvm_set_memory_region() waits for kvm->srcu with kvm->slots_lock taken
  - set_nx_huge_pages() waits for kvm->slots_lock with kvm_lock taken
  - __kvmclock_cpufreq_notifier() waits for kvm_lock with cpu_hotplug_lock taken
  - KVM_RUN waits for cpu_hotplug_lock with kvm->srcu taken

and therefore __kvm_set_memory_region() never completes
synchronize_srcu(&kvm->srcu).

  __kvm_set_memory_region()
    lock(&kvm->slots_lock)
                           set_nx_huge_pages()
                             lock(kvm_lock)
                             lock(&kvm->slots_lock)
                                                     __kvmclock_cpufreq_notifier()
                                                       lock(cpu_hotplug_lock)
                                                       lock(kvm_lock)
                                                                                   lock(&kvm->srcu)
                                                                                   kvm_lapic_set_base()
                                                                                     static_branch_inc()
                                                                                       lock(cpu_hotplug_lock)
  sync(&kvm->srcu)

Opportunistically add macros to walk the list of VMs, and the array of
vCPUs in each VMs, to cut down on the amount of boilerplate.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c   | 19 +++++++++++------
 arch/x86/kvm/x86.c       | 36 +++++++++++++++++--------------
 include/linux/kvm_host.h |  9 ++++++++
 virt/kvm/kvm_main.c      | 46 +++++++++++++++++++++++++---------------
 4 files changed, 71 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 74fa38ebddbf..f5b7ceb7ca0e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7127,6 +7127,10 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 	} else if (sysfs_streq(val, "never")) {
 		new_val = 0;
 
+		/*
+		 * Take kvm_lock to ensure no VMs are *created* before the flag
+		 * is set.  vm_list_srcu only protect VMs being deleted.
+		 */
 		mutex_lock(&kvm_lock);
 		if (!list_empty(&vm_list)) {
 			mutex_unlock(&kvm_lock);
@@ -7142,17 +7146,19 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 
 	if (new_val != old_val) {
 		struct kvm *kvm;
+		int idx;
 
-		mutex_lock(&kvm_lock);
+		idx = srcu_read_lock(&vm_list_srcu);
 
-		list_for_each_entry(kvm, &vm_list, vm_list) {
+		kvm_for_each_vm_srcu(kvm) {
 			mutex_lock(&kvm->slots_lock);
 			kvm_mmu_zap_all_fast(kvm);
 			mutex_unlock(&kvm->slots_lock);
 
 			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
 		}
-		mutex_unlock(&kvm_lock);
+
+		srcu_read_unlock(&vm_list_srcu, idx);
 	}
 
 	return 0;
@@ -7275,13 +7281,14 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
 	if (is_recovery_enabled &&
 	    (!was_recovery_enabled || old_period > new_period)) {
 		struct kvm *kvm;
+		int idx;
 
-		mutex_lock(&kvm_lock);
+		idx = srcu_read_lock(&vm_list_srcu);
 
-		list_for_each_entry(kvm, &vm_list, vm_list)
+		kvm_for_each_vm_srcu(kvm)
 			vhost_task_wake(kvm->arch.nx_huge_page_recovery_thread);
 
-		mutex_unlock(&kvm_lock);
+		srcu_read_unlock(&vm_list_srcu, idx);
 	}
 
 	return err;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b2d9a16fd4d3..8fb49237d179 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9428,6 +9428,11 @@ static void kvm_hyperv_tsc_notifier(void)
 	struct kvm *kvm;
 	int cpu;
 
+	/*
+	 * Take kvm_lock, not just vm_list_srcu, trevent new VMs from coming
+	 * along in the middle of the update and not getting the in-progress
+	 * request.
+	 */
 	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
 		kvm_make_mclock_inprogress_request(kvm);
@@ -9456,7 +9461,7 @@ static void __kvmclock_cpufreq_notifier(struct cpufreq_freqs *freq, int cpu)
 {
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
-	int send_ipi = 0;
+	int send_ipi = 0, idx;
 	unsigned long i;
 
 	/*
@@ -9500,17 +9505,16 @@ static void __kvmclock_cpufreq_notifier(struct cpufreq_freqs *freq, int cpu)
 
 	smp_call_function_single(cpu, tsc_khz_changed, freq, 1);
 
-	mutex_lock(&kvm_lock);
-	list_for_each_entry(kvm, &vm_list, vm_list) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			if (vcpu->cpu != cpu)
-				continue;
-			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-			if (vcpu->cpu != raw_smp_processor_id())
-				send_ipi = 1;
-		}
+	idx = srcu_read_lock(&vm_list_srcu);
+	kvm_for_each_vcpu_in_each_vm(kvm, vcpu, i) {
+		if (vcpu->cpu != cpu)
+			continue;
+
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
+		if (vcpu->cpu != raw_smp_processor_id())
+			send_ipi = 1;
 	}
-	mutex_unlock(&kvm_lock);
+	srcu_read_unlock(&vm_list_srcu, idx);
 
 	if (freq->old < freq->new && send_ipi) {
 		/*
@@ -9588,13 +9592,13 @@ static void pvclock_gtod_update_fn(struct work_struct *work)
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
+	int idx;
 
-	mutex_lock(&kvm_lock);
-	list_for_each_entry(kvm, &vm_list, vm_list)
-		kvm_for_each_vcpu(i, vcpu, kvm)
-			kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
+	idx = srcu_read_lock(&vm_list_srcu);
+	kvm_for_each_vcpu_in_each_vm(kvm, vcpu, i)
+		kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
+	srcu_read_unlock(&vm_list_srcu, idx);
 	atomic_set(&kvm_guest_has_master_clock, 0);
-	mutex_unlock(&kvm_lock);
 }
 
 static DECLARE_WORK(pvclock_gtod_work, pvclock_gtod_update_fn);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9df590e8f3da..0d0edb697160 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -193,6 +193,11 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req);
 
 extern struct mutex kvm_lock;
 extern struct list_head vm_list;
+extern struct srcu_struct vm_list_srcu;
+
+#define kvm_for_each_vm_srcu(__kvm)				\
+	list_for_each_entry_srcu(__kvm, &vm_list, vm_list,	\
+				 srcu_read_lock_held(&vm_list_srcu))
 
 struct kvm_io_range {
 	gpa_t addr;
@@ -1001,6 +1006,10 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
 	return NULL;
 }
 
+#define kvm_for_each_vcpu_in_each_vm(__kvm, __vcpu, __i)		\
+	kvm_for_each_vm_srcu(__kvm)					\
+		kvm_for_each_vcpu(__i, __vcpu, __kvm)
+
 void kvm_destroy_vcpus(struct kvm *kvm);
 
 void vcpu_load(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e0b9d6dd6a85..7fcc4433bf35 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -109,6 +109,7 @@ module_param(allow_unsafe_mappings, bool, 0444);
 
 DEFINE_MUTEX(kvm_lock);
 LIST_HEAD(vm_list);
+DEFINE_SRCU(vm_list_srcu);
 
 static struct kmem_cache *kvm_vcpu_cache;
 
@@ -1261,13 +1262,21 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	int i;
 	struct mm_struct *mm = kvm->mm;
 
+	mutex_lock(&kvm_lock);
+	list_del(&kvm->vm_list);
+	mutex_unlock(&kvm_lock);
+
+	/*
+	 * Ensure all readers of the global list go away before destroying any
+	 * aspect of the VM.  After this, the VM object is reachable only via
+	 * this task and notifiers that are registered to the VM itself.
+	 */
+	synchronize_srcu(&vm_list_srcu);
+
 	kvm_destroy_pm_notifier(kvm);
 	kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
 	kvm_destroy_vm_debugfs(kvm);
 	kvm_arch_sync_events(kvm);
-	mutex_lock(&kvm_lock);
-	list_del(&kvm->vm_list);
-	mutex_unlock(&kvm_lock);
 	kvm_arch_pre_destroy_vm(kvm);
 
 	kvm_free_irq_routing(kvm);
@@ -6096,14 +6105,16 @@ static int vm_stat_get(void *_offset, u64 *val)
 	unsigned offset = (long)_offset;
 	struct kvm *kvm;
 	u64 tmp_val;
+	int idx;
 
 	*val = 0;
-	mutex_lock(&kvm_lock);
-	list_for_each_entry(kvm, &vm_list, vm_list) {
+	idx = srcu_read_lock(&vm_list_srcu);
+	kvm_for_each_vm_srcu(kvm) {
 		kvm_get_stat_per_vm(kvm, offset, &tmp_val);
 		*val += tmp_val;
 	}
-	mutex_unlock(&kvm_lock);
+	srcu_read_unlock(&vm_list_srcu, idx);
+
 	return 0;
 }
 
@@ -6111,15 +6122,15 @@ static int vm_stat_clear(void *_offset, u64 val)
 {
 	unsigned offset = (long)_offset;
 	struct kvm *kvm;
+	int idx;
 
 	if (val)
 		return -EINVAL;
 
-	mutex_lock(&kvm_lock);
-	list_for_each_entry(kvm, &vm_list, vm_list) {
+	idx = srcu_read_lock(&vm_list_srcu);
+	kvm_for_each_vm_srcu(kvm)
 		kvm_clear_stat_per_vm(kvm, offset);
-	}
-	mutex_unlock(&kvm_lock);
+	srcu_read_unlock(&vm_list_srcu, idx);
 
 	return 0;
 }
@@ -6132,14 +6143,15 @@ static int vcpu_stat_get(void *_offset, u64 *val)
 	unsigned offset = (long)_offset;
 	struct kvm *kvm;
 	u64 tmp_val;
+	int idx;
 
 	*val = 0;
-	mutex_lock(&kvm_lock);
-	list_for_each_entry(kvm, &vm_list, vm_list) {
+	idx = srcu_read_lock(&vm_list_srcu);
+	kvm_for_each_vm_srcu(kvm) {
 		kvm_get_stat_per_vcpu(kvm, offset, &tmp_val);
 		*val += tmp_val;
 	}
-	mutex_unlock(&kvm_lock);
+	srcu_read_unlock(&vm_list_srcu, idx);
 	return 0;
 }
 
@@ -6147,15 +6159,15 @@ static int vcpu_stat_clear(void *_offset, u64 val)
 {
 	unsigned offset = (long)_offset;
 	struct kvm *kvm;
+	int idx;
 
 	if (val)
 		return -EINVAL;
 
-	mutex_lock(&kvm_lock);
-	list_for_each_entry(kvm, &vm_list, vm_list) {
+	idx = srcu_read_lock(&vm_list_srcu);
+	kvm_for_each_vm_srcu(kvm)
 		kvm_clear_stat_per_vcpu(kvm, offset);
-	}
-	mutex_unlock(&kvm_lock);
+	srcu_read_unlock(&vm_list_srcu, idx);
 
 	return 0;
 }

base-commit: eb723766b1030a23c38adf2348b7c3d1409d11f0
-- 

