Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F543E90B7
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 14:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237989AbhHKMY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 08:24:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58658 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238172AbhHKMXy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 08:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628684610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y+vIRCIEBNPiZxd3aPkEVCtJRnECofb6ATzwMF02AG0=;
        b=gsY35lGL3fPESoBPKYwc7nZHg06E2fFJOJKELNc4ylVOvUNXjDkDAevxLTgBXtFcwO/MvD
        nxBdDzhL8ffruvApuKaNnSIXECFAqPwx6K0PjxEYoPX1HhDA7B9/KmbZGh2vQKkb9MT3/J
        8f2FNzgegi6oPmrlOErDpL4jkZN0gVk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-_CPnI1YUNKSxuEj5NTFRLQ-1; Wed, 11 Aug 2021 08:23:29 -0400
X-MC-Unique: _CPnI1YUNKSxuEj5NTFRLQ-1
Received: by mail-ed1-f69.google.com with SMTP id n4-20020aa7c6840000b02903be94ce771fso565641edq.11
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 05:23:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y+vIRCIEBNPiZxd3aPkEVCtJRnECofb6ATzwMF02AG0=;
        b=PKRfw3XdDNHUTa6TifsIlBxwafWlyNdoo83VVaa8qHDdaus67q/mBGTCa2Am9eSlOI
         3nAwRnE+jpSXV7/EIO3fown0DywGalmxmQcOxlvKy/NnxRfrJyHgEiBGl+nkSi3C1US7
         gD4q7/wH5KFsYmP6nqYJ2ap9ri+TXbjzv35EJ7tVYg1qh8qmpXzS55C0TIT57KWv814V
         Tto2UXXxygYVx+kMudb627NvZq+NHbEuYWI2HEcDhIOvkzKvsnZ6Kr0sehWkgLuW8SvK
         TTSJ7iM9JF3qLVk8qxYecH+d5ycVQ8xC5ORpc6f+UJH4DPc4Ak84Xk34SZ7Y+p32aNmi
         89vg==
X-Gm-Message-State: AOAM533YWa2GstBLt9MUDDqCOqVCvulpmQ0N3ce0CyCJhRoOtdn+UrSX
        DwJEa/8Nk/iboIRs6N0qOlIFjHAbQXoICRp0FedyMg86PhJILhElb1Wm3n3HBMjCOhz0p2DWw1U
        pepak13LYPTRf
X-Received: by 2002:a05:6402:5210:: with SMTP id s16mr11207359edd.343.1628684608342;
        Wed, 11 Aug 2021 05:23:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9izQQ4pSzCAywJGWwpUx4uStMGwprYlBWkpymRc1hMb3MBsGF2Qkfwg/Vq+iaMHLB9z8VvA==
X-Received: by 2002:a05:6402:5210:: with SMTP id s16mr11207330edd.343.1628684608110;
        Wed, 11 Aug 2021 05:23:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id c6sm11062504ede.48.2021.08.11.05.23.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 05:23:26 -0700 (PDT)
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Sean Christopherson <seanjc@google.com>,
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
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-2-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6 01/21] KVM: x86: Fix potential race in KVM_GET_CLOCK
Message-ID: <78eeaf83-2bfa-8452-1301-a607fba7fa0c@redhat.com>
Date:   Wed, 11 Aug 2021 14:23:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210804085819.846610-2-oupton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/08/21 10:57, Oliver Upton wrote:
> Sean noticed that KVM_GET_CLOCK was checking kvm_arch.use_master_clock
> outside of the pvclock sync lock. This is problematic, as the clock
> value written to the user may or may not actually correspond to a stable
> TSC.
> 
> Fix the race by populating the entire kvm_clock_data structure behind
> the pvclock_gtod_sync_lock.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   arch/x86/kvm/x86.c | 39 ++++++++++++++++++++++++++++-----------
>   1 file changed, 28 insertions(+), 11 deletions(-)

I had a completely independent patch that fixed the same race.  It unifies
the read sides of tsc_write_lock and pvclock_gtod_sync_lock into a seqcount
(and replaces pvclock_gtod_sync_lock with kvm->lock on the write side).

I attach it now (based on https://lore.kernel.org/kvm/20210811102356.3406687-1-pbonzini@redhat.com/T/#t),
but the testing was extremely light so I'm not sure I will be able to include
it in 5.15.

Paolo

-------------- 8< -------------
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 8 Apr 2021 05:03:44 -0400
Subject: [PATCH] kvm: x86: protect masterclock with a seqcount

Protect the reference point for kvmclock with a seqcount, so that
kvmclock updates for all vCPUs can proceed in parallel.  Xen runstate
updates will also run in parallel and not bounce the kvmclock cacheline.

This also makes it possible to use KVM_REQ_CLOCK_UPDATE (which will
block on the seqcount) to prevent entering in the guests until
pvclock_update_vm_gtod_copy is complete, and thus to get rid of
KVM_REQ_MCLOCK_INPROGRESS.

nr_vcpus_matched_tsc is updated outside pvclock_update_vm_gtod_copy
though, so a spinlock must be kept for that one.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 8138201efb09..ed41da172e02 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -29,6 +29,8 @@ The acquisition orders for mutexes are as follows:
  
  On x86:
  
+- the seqcount kvm->arch.pvclock_sc is written under kvm->lock.
+
  - vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock
  
  - kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock is
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 20daaf67a5bf..6889aab92362 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -68,8 +68,7 @@
  #define KVM_REQ_PMI			KVM_ARCH_REQ(11)
  #define KVM_REQ_SMI			KVM_ARCH_REQ(12)
  #define KVM_REQ_MASTERCLOCK_UPDATE	KVM_ARCH_REQ(13)
-#define KVM_REQ_MCLOCK_INPROGRESS \
-	KVM_ARCH_REQ_FLAGS(14, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+/* 14 unused */
  #define KVM_REQ_SCAN_IOAPIC \
  	KVM_ARCH_REQ_FLAGS(15, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
  #define KVM_REQ_GLOBAL_CLOCK_UPDATE	KVM_ARCH_REQ(16)
@@ -1067,6 +1066,11 @@ struct kvm_arch {
  
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
@@ -1077,7 +1081,7 @@ struct kvm_arch {
  	u64 cur_tsc_generation;
  	int nr_vcpus_matched_tsc;
  
-	spinlock_t pvclock_gtod_sync_lock;
+	seqcount_mutex_t pvclock_sc;
  	bool use_master_clock;
  	u64 master_kernel_ns;
  	u64 master_cycle_now;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 74145a3fd4f2..7d73c5560260 100644
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
@@ -2730,9 +2728,7 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
  	struct kvm_arch *ka = &kvm->arch;
  	int vclock_mode;
  	bool host_tsc_clocksource, vcpus_matched;
-
-	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
-			atomic_read(&kvm->online_vcpus));
+	unsigned long flags;
  
  	/*
  	 * If the host uses TSC clock, then passthrough TSC as stable
@@ -2742,9 +2738,14 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
  					&ka->master_kernel_ns,
  					&ka->master_cycle_now);
  
+	raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
+	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
+			atomic_read(&kvm->online_vcpus));
+
  	ka->use_master_clock = host_tsc_clocksource && vcpus_matched
  				&& !ka->backwards_tsc_observed
  				&& !ka->boot_vcpu_runs_old_kvmclock;
+	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
  
  	if (ka->use_master_clock)
  		atomic_set(&kvm_guest_has_master_clock, 1);
@@ -2758,25 +2759,26 @@ static void pvclock_update_vm_gtod_copy(struct kvm *kvm)
  static void kvm_start_pvclock_update(struct kvm *kvm)
  {
  	struct kvm_arch *ka = &kvm->arch;
-	kvm_make_all_cpus_request(kvm, KVM_REQ_MCLOCK_INPROGRESS);
  
-	/* no guest entries from this point */
-	spin_lock_irq(&ka->pvclock_gtod_sync_lock);
+	mutex_lock(&kvm->lock);
+	/*
+	 * write_seqcount_begin disables preemption.  This is needed not just
+	 * to avoid livelock, but also because the preempt notifier is a reader
+	 * for ka->pvclock_sc.
+	 */
+	write_seqcount_begin(&ka->pvclock_sc);
+	kvm_make_all_cpus_request(kvm,
+		KVM_REQ_CLOCK_UPDATE | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP);
+
+	/* no guest entries from this point until write_seqcount_end */
  }
  
  static void kvm_end_pvclock_update(struct kvm *kvm)
  {
  	struct kvm_arch *ka = &kvm->arch;
-	struct kvm_vcpu *vcpu;
-	int i;
  
-	spin_unlock_irq(&ka->pvclock_gtod_sync_lock);
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
-
-	/* guest entries allowed */
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu);
+	write_seqcount_end(&ka->pvclock_sc);
+	mutex_unlock(&kvm->lock);
  }
  
  static void kvm_update_masterclock(struct kvm *kvm)
@@ -2787,27 +2789,21 @@ static void kvm_update_masterclock(struct kvm *kvm)
  	kvm_end_pvclock_update(kvm);
  }
  
-u64 get_kvmclock_ns(struct kvm *kvm)
+static u64 __get_kvmclock_ns(struct kvm *kvm)
  {
  	struct kvm_arch *ka = &kvm->arch;
  	struct pvclock_vcpu_time_info hv_clock;
-	unsigned long flags;
  	u64 ret;
  
-	spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
-	if (!ka->use_master_clock) {
-		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
+	if (!ka->use_master_clock)
  		return get_kvmclock_base_ns() + ka->kvmclock_offset;
-	}
-
-	hv_clock.tsc_timestamp = ka->master_cycle_now;
-	hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
-	spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
  
  	/* both __this_cpu_read() and rdtsc() should be on the same cpu */
  	get_cpu();
  
  	if (__this_cpu_read(cpu_tsc_khz)) {
+		hv_clock.tsc_timestamp = ka->master_cycle_now;
+		hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
  		kvm_get_time_scale(NSEC_PER_SEC, __this_cpu_read(cpu_tsc_khz) * 1000LL,
  				   &hv_clock.tsc_shift,
  				   &hv_clock.tsc_to_system_mul);
@@ -2816,6 +2812,19 @@ u64 get_kvmclock_ns(struct kvm *kvm)
  		ret = get_kvmclock_base_ns() + ka->kvmclock_offset;
  
  	put_cpu();
+	return ret;
+}
+
+u64 get_kvmclock_ns(struct kvm *kvm)
+{
+	struct kvm_arch *ka = &kvm->arch;
+	unsigned seq;
+	u64 ret;
+
+	do {
+		seq = read_seqcount_begin(&ka->pvclock_sc);
+		ret = __get_kvmclock_ns(kvm);
+	} while (read_seqcount_retry(&ka->pvclock_sc, seq));
  
  	return ret;
  }
@@ -2882,6 +2891,7 @@ static void kvm_setup_pvclock_page(struct kvm_vcpu *v,
  static int kvm_guest_time_update(struct kvm_vcpu *v)
  {
  	unsigned long flags, tgt_tsc_khz;
+	unsigned seq;
  	struct kvm_vcpu_arch *vcpu = &v->arch;
  	struct kvm_arch *ka = &v->kvm->arch;
  	s64 kernel_ns;
@@ -2896,13 +2906,14 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
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
@@ -6098,11 +6109,13 @@ long kvm_arch_vm_ioctl(struct file *filp,
  	}
  	case KVM_GET_CLOCK: {
  		struct kvm_clock_data user_ns;
-		u64 now_ns;
+		unsigned seq;
  
-		now_ns = get_kvmclock_ns(kvm);
-		user_ns.clock = now_ns;
-		user_ns.flags = kvm->arch.use_master_clock ? KVM_CLOCK_TSC_STABLE : 0;
+		do {
+			seq = read_seqcount_begin(&kvm->arch.pvclock_sc);
+			user_ns.clock = __get_kvmclock_ns(kvm);
+			user_ns.flags = kvm->arch.use_master_clock ? KVM_CLOCK_TSC_STABLE : 0;
+		} while (read_seqcount_retry(&kvm->arch.pvclock_sc, seq));
  		memset(&user_ns.pad, 0, sizeof(user_ns.pad));
  
  		r = -EFAULT;
@@ -11144,8 +11157,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
  
  	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
  	mutex_init(&kvm->arch.apic_map_lock);
-	spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
-
+	seqcount_mutex_init(&kvm->arch.pvclock_sc, &kvm->lock);
  	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
  	pvclock_update_vm_gtod_copy(kvm);
  

