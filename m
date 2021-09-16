Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773E940EA6D
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhIPS56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243594AbhIPS5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:30 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740A1C05BD0D
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:48 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id c27-20020a05620a165b00b003d3817c7c23so44672205qko.16
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RkkbGR7s65RKrojatUhUcN7AGOVGILJpEmrP2I02yFk=;
        b=XdE2G/H9rYPulSHBgAfwPKILoMSC5zHl88dGQYBg/i+k3tK/Lp6vKr7uKIi1bUdViU
         nO6mVeTKlL84xNt3/RjeQER4b5z04fYNOneo+sSl8hyWRLgRWx95iUtG4Rob9UELNUs5
         49ZPhvIMW2J95O8+ZRMZ3wDpTpXFprQFUHnOo4v6XjG42qe48CzDlEWHDnLjkorS+fCE
         2ennJ2nPGZu9b8rVUjiN2JEl+neb/jih0MVrD8xU0NtCs3//Q3k6ELLj1/lJZgN7Ksp/
         Lpds1Nu+kE2B0NxTAYgjUdDyF4jGzjT36AYL5urhrF1eOhrQKfi0tf3X+b8/KR2bkpcx
         jocg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RkkbGR7s65RKrojatUhUcN7AGOVGILJpEmrP2I02yFk=;
        b=qRfUbmAb2QIhFHnc9Lj/76RINq0vAf24fsbPycxiPodCermqnABAmjWI5w+87tso3H
         pB51/Xz7DDR7/Jju1eD7zXZgSCCov0KA2F4hF0rUZ4HoQ8wWVyMNMcuErrAkBOLJx7qM
         GNgskQuFpXIgP4euC0+yVLOtwP7dsTz3lOe7UPvPrLovsB/QYmaIAY0V0ZjXZ7EqPqQ8
         NSV3AP9erbhJ0bDui/bU77xK6GUkflpVAuGSTfjwZtM76N7VWgVDwe6Ze5CqutYNLM9w
         xZQnluhpgfQ0CwQLRZXLQMkyFsUNnmTPwRonLH52Y7xtRAXLY3oWBKgb/zIiiGT6xfmo
         XsSQ==
X-Gm-Message-State: AOAM530f/UYRu2kc8dmTq1etO088ae27kT/40gvrmbeBVCpgUQhXKFME
        PLjHbNVDYKytFNBekfC3IJWP0MQVzew5xP4wd7bHa14sg6IfQtF+OH/k8fAOkC0vezVZB+yuDjv
        7JMxjfq3+x8rdkmEG+YIkpVvzdGJgbHg5WcISqwUfie9peDPMtlqUyQ96VA==
X-Google-Smtp-Source: ABdhPJz+iJU5f6z/grqrVZ21yLMPrc5CcINLjptZt9ThEios+Cu4etZJHmTZs6+key3lJTsf+GErso+7PVs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:3ca:: with SMTP id
 ce10mr6813032qvb.12.1631816147367; Thu, 16 Sep 2021 11:15:47 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:36 +0000
In-Reply-To: <20210916181538.968978-1-oupton@google.com>
Message-Id: <20210916181538.968978-6-oupton@google.com>
Mime-Version: 1.0
References: <20210916181538.968978-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 5/7] kvm: x86: protect masterclock with a seqcount
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

From: Paolo Bonzini <pbonzini@redhat.com>

Protect the reference point for kvmclock with a seqcount, so that
kvmclock updates for all vCPUs can proceed in parallel.  Xen runstate
updates will also run in parallel and not bounce the kvmclock cacheline.

nr_vcpus_matched_tsc is updated outside pvclock_update_vm_gtod_copy
though, so a spinlock must be kept for that one.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[Oliver - drop unused locals, don't double acquire tsc_write_lock]
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/include/asm/kvm_host.h |  7 ++-
 arch/x86/kvm/x86.c              | 83 +++++++++++++++++----------------
 2 files changed, 49 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9c34b5b63e39..5accfe7246ce 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1087,6 +1087,11 @@ struct kvm_arch {
 
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
+
+	/*
+	 * This also protects nr_vcpus_matched_tsc which is read from a
+	 * preemption-disabled region, so it must be a raw spinlock.
+	 */
 	raw_spinlock_t tsc_write_lock;
 	u64 last_tsc_nsec;
 	u64 last_tsc_write;
@@ -1097,7 +1102,7 @@ struct kvm_arch {
 	u64 cur_tsc_generation;
 	int nr_vcpus_matched_tsc;
 
-	spinlock_t pvclock_gtod_sync_lock;
+	seqcount_raw_spinlock_t pvclock_sc;
 	bool use_master_clock;
 	u64 master_kernel_ns;
 	u64 master_cycle_now;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cb5d5cad5124..29156c49cd11 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2533,9 +2533,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
 
 	kvm_vcpu_write_tsc_offset(vcpu, offset);
-	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 
-	spin_lock_irqsave(&kvm->arch.pvclock_gtod_sync_lock, flags);
 	if (!matched) {
 		kvm->arch.nr_vcpus_matched_tsc = 0;
 	} else if (!already_matched) {
@@ -2543,7 +2541,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
 	}
 
 	kvm_track_tsc_matching(vcpu);
-	spin_unlock_irqrestore(&kvm->arch.pvclock_gtod_sync_lock, flags);
+	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
 }
 
 static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
@@ -2731,9 +2729,6 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
 	int vclock_mode;
 	bool host_tsc_clocksource, vcpus_matched;
 
-	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
-			atomic_read(&kvm->online_vcpus));
-
 	/*
 	 * If the host uses TSC clock, then passthrough TSC as stable
 	 * to the guest.
@@ -2742,6 +2737,10 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
 					&ka->master_kernel_ns,
 					&ka->master_cycle_now);
 
+	lockdep_assert_held(&kvm->arch.tsc_write_lock);
+	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
+			atomic_read(&kvm->online_vcpus));
+
 	ka->use_master_clock = host_tsc_clocksource && vcpus_matched
 				&& !ka->backwards_tsc_observed
 				&& !ka->boot_vcpu_runs_old_kvmclock;
@@ -2760,14 +2759,18 @@ static void kvm_make_mclock_inprogress_request(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MCLOCK_INPROGRESS);
 }
 
-static void kvm_start_pvclock_update(struct kvm *kvm)
+static void __kvm_start_pvclock_update(struct kvm *kvm)
 {
-	struct kvm_arch *ka = &kvm->arch;
+	raw_spin_lock_irq(&kvm->arch.tsc_write_lock);
+	write_seqcount_begin(&kvm->arch.pvclock_sc);
+}
 
+static void kvm_start_pvclock_update(struct kvm *kvm)
+{
 	kvm_make_mclock_inprogress_request(kvm);
 
 	/* no guest entries from this point */
-	spin_lock_irq(&ka->pvclock_gtod_sync_lock);
+	__kvm_start_pvclock_update(kvm);
 }
 
 static void kvm_end_pvclock_update(struct kvm *kvm)
@@ -2776,7 +2779,8 @@ static void kvm_end_pvclock_update(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	int i;
 
-	spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
+	write_seqcount_end(&ka->pvclock_sc);
+	raw_spin_unlock_irq(&ka->tsc_write_lock);
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
@@ -2797,20 +2801,12 @@ static void get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
 {
 	struct kvm_arch *ka = &kvm->arch;
 	struct pvclock_vcpu_time_info hv_clock;
-	unsigned long flags;
 
-	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 	if (!ka->use_master_clock) {
-		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
 		data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
 		return;
 	}
 
-	data->flags |= KVM_CLOCK_TSC_STABLE;
-	hv_clock.tsc_timestamp = ka->master_cycle_now;
-	hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
-	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
-
 	/* both __this_cpu_read() and rdtsc() should be on the same cpu */
 	get_cpu();
 
@@ -2825,6 +2821,9 @@ static void get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
 #endif
 		data->host_tsc = rdtsc();
 
+		data->flags |= KVM_CLOCK_TSC_STABLE;
+		hv_clock.tsc_timestamp = ka->master_cycle_now;
+		hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
 		kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
 				   &hv_clock.tsc_shift,
 				   &hv_clock.tsc_to_system_mul);
@@ -2839,14 +2838,14 @@ static void get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
 u64 get_kvmclock_ns(struct kvm *kvm)
 {
 	struct kvm_clock_data data;
+	struct kvm_arch *ka = &kvm->arch;
+	unsigned seq;
 
-	/*
-	 * Zero flags as it's accessed RMW, leave everything else uninitialized
-	 * as clock is always written and no other fields are consumed.
-	 */
-	data.flags = 0;
-
-	get_kvmclock(kvm, &data);
+	do {
+		seq = read_seqcount_begin(&ka->pvclock_sc);
+		data.flags = 0;
+		get_kvmclock(kvm, &data);
+	} while (read_seqcount_retry(&ka->pvclock_sc, seq));
 	return data.clock;
 }
 
@@ -2912,6 +2911,7 @@ static void kvm_setup_pvclock_page(struct kvm_vcpu *v,
 static int kvm_guest_time_update(struct kvm_vcpu *v)
 {
 	unsigned long flags, tgt_tsc_khz;
+	unsigned seq;
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	struct kvm_arch *ka = &v->kvm->arch;
 	s64 kernel_ns;
@@ -2926,13 +2926,14 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	 * If the host uses TSC clock, then passthrough TSC as stable
 	 * to the guest.
 	 */
-	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
-	use_master_clock = ka->use_master_clock;
-	if (use_master_clock) {
-		host_tsc = ka->master_cycle_now;
-		kernel_ns = ka->master_kernel_ns;
-	}
-	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+	seq = read_seqcount_begin(&ka->pvclock_sc);
+	do {
+		use_master_clock = ka->use_master_clock;
+		if (use_master_clock) {
+			host_tsc = ka->master_cycle_now;
+			kernel_ns = ka->master_kernel_ns;
+		}
+	} while (read_seqcount_retry(&ka->pvclock_sc, seq));
 
 	/* Keep irq disabled to prevent changes to the clock */
 	local_irq_save(flags);
@@ -5855,10 +5856,15 @@ int kvm_arch_pm_notifier(struct kvm *kvm, unsigned long state)
 
 static int kvm_vm_ioctl_get_clock(struct kvm *kvm, void __user *argp)
 {
-	struct kvm_clock_data data;
+	struct kvm_clock_data data = { 0 };
+	unsigned seq;
+
+	do {
+		seq = read_seqcount_begin(&kvm->arch.pvclock_sc);
+		data.flags = 0;
+		get_kvmclock(kvm, &data);
+	} while (read_seqcount_retry(&kvm->arch.pvclock_sc, seq));
 
-	memset(&data, 0, sizeof(data));
-	get_kvmclock(kvm, &data);
 	if (copy_to_user(argp, &data, sizeof(data)))
 		return -EFAULT;
 
@@ -8159,9 +8165,7 @@ static void kvm_hyperv_tsc_notifier(void)
 	kvm_max_guest_tsc_khz = tsc_khz;
 
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-		struct kvm_arch *ka = &kvm->arch;
-
-		spin_lock_irq(&ka->pvclock_gtod_sync_lock);
+		__kvm_start_pvclock_update(kvm);
 		pvclock_update_vm_gtod_copy(kvm);
 		kvm_end_pvclock_update(kvm);
 	}
@@ -11188,8 +11192,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
 	mutex_init(&kvm->arch.apic_map_lock);
-	spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
-
+	seqcount_raw_spinlock_init(&kvm->arch.pvclock_sc, &kvm->arch.tsc_write_lock);
 	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
 	pvclock_update_vm_gtod_copy(kvm);
 
-- 
2.33.0.309.g3052b89438-goog

