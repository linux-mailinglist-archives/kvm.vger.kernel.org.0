Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092E66200F9
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 22:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbiKGVWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 16:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbiKGVVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 16:21:48 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2D7111F
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 13:21:44 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d20so11199851plr.10
        for <kvm@vger.kernel.org>; Mon, 07 Nov 2022 13:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xs/BKtx4lrZPG4HHpLSInfwwnPv6eJu0PAN3rulJKFM=;
        b=mis67Slgd2RX0Kkiy0/vAHh/7h0Klhdoi4bTVPAlO/f/wyy2jblyqvek9+SBF13BK0
         3Mna4PnVem9gUa/qQ6PlPumUAnxcPd7eRLfSH2twWUdxFIDEWCzQ2SybVd9qcYM2qyEp
         hg4+vamlQOU39ilRDvNbWWs2EDNZViHmNKdFNuwk/1KjFSDzlKyUF+YuzZ5FsUMaxPgs
         hFWIWBMn5qwTyfi9E1G69zz0ZuUn7ToP5kOCZ5YFRFv/Tuo9qhKYFxIM1wq6LuXyYLtd
         61bP2IJrOsXKpvM3tQ/a5e1pROXtbtdfX02kSqXLYhqI5CPuuj5Bj1Sh2S8x11JCTYO/
         GfKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xs/BKtx4lrZPG4HHpLSInfwwnPv6eJu0PAN3rulJKFM=;
        b=nIEoG2WHliF6o5n2sUuUr/KkCARD9fVlnRuG7/fvDbR0WYypIZ2ot1fIhz6s3U9fkE
         /dyutgMb98Fm8ZfdTRy2PRSOwtHKAc7xyAHm8Qpe9Ro7lxNRBnPoTwObce31LvOU9tFj
         unDp3pFQtFknCXke0Q7r1AAYimh8uYjbU24g+JxMDHAnXWvIS6+9RPXKbmxsyUH30mHv
         z9JRwJO4RAohczpZ2+EaEx3EJVGyc/31F97+hkeFpu+TVMmOxyZnwBkGRj0eeoazSjYO
         Uv3BglX7eG92+9Bgiz1QXZ4MrtyXvTZLc+SR4fb1xutQTy7a/0TLEyAMtb1D8rkaK3hf
         9Eow==
X-Gm-Message-State: ACrzQf2eH0/ssRf1jxRJnmwemYH+bR2n/6+XbGau7rfjMLvFKVE9lPjn
        xKTwmMfv2D7hKglBO8bqf4oxRg==
X-Google-Smtp-Source: AMsMyM4wVgpNAnW6VA1kADTU0ZUoX28CJSN54/tdgCg3cFspB2LvBT355ci4jpUthV/Mb49WxuW38g==
X-Received: by 2002:a17:903:40ce:b0:188:62b9:cece with SMTP id t14-20020a17090340ce00b0018862b9cecemr21704844pld.93.1667856103531;
        Mon, 07 Nov 2022 13:21:43 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u2-20020a17090341c200b00186afd756edsm5390757ple.283.2022.11.07.13.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 13:21:43 -0800 (PST)
Date:   Mon, 7 Nov 2022 21:21:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86/mmu: Do not recover dirty-tracked NX Huge
 Pages
Message-ID: <Y2l247/1GzVm4mJH@google.com>
References: <20221103204421.1146958-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103204421.1146958-1-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03, 2022, David Matlack wrote:
> Do not recover (i.e. zap) an NX Huge Page that is being dirty tracked,
> as it will just be faulted back in at the same 4KiB granularity when
> accessed by a vCPU. This may need to be changed if KVM ever supports
> 2MiB (or larger) dirty tracking granularity, or faulting huge pages
> during dirty tracking for reads/executes. However for now, these zaps
> are entirely wasteful.
> 
> This commit does nominally increase the CPU usage of the NX recover
> worker by about 1% when testing with a VM with 16 slots.

Probably should include the benefits of the change (avoiding zaps) if you're going
to list the downsides.  I suspect you'll have a hard time quantifying capturing the
positives because the behavior is heavily dependent on the zapping frequency, which
is controlled by userspace, but having some understanding of the tradeoffs is
important otherwise it's basically impossible to know whether or not that 1% CPU
usage is worth eating.

Hmm, and the memslot heuristic doesn't address the recovery worker holding mmu_lock
for write.  On a non-preemptible kernel, rwlock_needbreak() is always false, e.g.
the worker won't yield to vCPUs that are trying to handle non-fast page faults.
The worker should eventually reach steady state by unaccounting everything, but
that might take a while.

An alternative idea to the memslot heuristic would be to add a knob to allow
disabling the recovery thread on a per-VM basis.  Userspace should know that it's
dirty logging a given VM for migration.

E.g.

---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          | 12 +++++++-----
 arch/x86/kvm/x86.c              |  9 +++++++++
 include/uapi/linux/kvm.h        |  4 ++++
 tools/include/uapi/linux/kvm.h  |  4 ++++
 5 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7551b6f9c31c..2b982cea11ee 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1341,6 +1341,7 @@ struct kvm_arch {
 	u32 max_vcpu_ids;
 
 	bool disable_nx_huge_pages;
+	bool disable_nx_huge_page_recovery;
 
 	/*
 	 * Memory caches used to allocate shadow pages when performing eager
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f81539061d6..44d2cce14f38 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6856,12 +6856,13 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
 }
 
-static long get_nx_lpage_recovery_timeout(u64 start_time)
+static long get_nx_lpage_recovery_timeout(struct kvm *kvm, u64 start_time)
 {
 	bool enabled;
 	uint period;
 
-	enabled = calc_nx_huge_pages_recovery_period(&period);
+	enabled = !READ_ONCE(kvm->arch.disable_nx_huge_page_recovery) &&
+		  calc_nx_huge_pages_recovery_period(&period);
 
 	return enabled ? start_time + msecs_to_jiffies(period) - get_jiffies_64()
 		       : MAX_SCHEDULE_TIMEOUT;
@@ -6874,12 +6875,12 @@ static int kvm_nx_lpage_recovery_worker(struct kvm *kvm, uintptr_t data)
 
 	while (true) {
 		start_time = get_jiffies_64();
-		remaining_time = get_nx_lpage_recovery_timeout(start_time);
+		remaining_time = get_nx_lpage_recovery_timeout(kvm, start_time);
 
 		set_current_state(TASK_INTERRUPTIBLE);
 		while (!kthread_should_stop() && remaining_time > 0) {
 			schedule_timeout(remaining_time);
-			remaining_time = get_nx_lpage_recovery_timeout(start_time);
+			remaining_time = get_nx_lpage_recovery_timeout(kvm, start_time);
 			set_current_state(TASK_INTERRUPTIBLE);
 		}
 
@@ -6888,7 +6889,8 @@ static int kvm_nx_lpage_recovery_worker(struct kvm *kvm, uintptr_t data)
 		if (kthread_should_stop())
 			return 0;
 
-		kvm_recover_nx_lpages(kvm);
+		if (!READ_ONCE(kvm->arch.disable_nx_huge_page_recovery))
+			kvm_recover_nx_lpages(kvm);
 	}
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 521b433f978c..04f287c65ac3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4409,6 +4409,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VAPIC:
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
+	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGE_RECOVERY:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -6376,6 +6377,14 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGE_RECOVERY:
+		r = -EINVAL;
+		if (cap->args[0] & ~KVM_X86_DISABLE_NX_HUGE_PAGE_RECOVERY)
+			break;
+
+		WRITE_ONCE(kvm->arch.disable_nx_huge_page_recovery, !!cap->args[0]);
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0d5d4419139a..097661a867d9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1178,6 +1178,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
+#define KVM_CAP_VM_DISABLE_NX_HUGE_PAGE_RECOVERY 224
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2198,6 +2199,9 @@ struct kvm_stats_desc {
 #define KVM_X86_NOTIFY_VMEXIT_ENABLED		(1ULL << 0)
 #define KVM_X86_NOTIFY_VMEXIT_USER		(1ULL << 1)
 
+/* Available with KVM_CAP_VM_DISABLE_NX_HUGE_PAGE_RECOVERY */
+#define KVM_X86_DISABLE_NX_HUGE_PAGE_RECOVERY	(1ULL << 0)
+
 /* Available with KVM_CAP_S390_ZPCI_OP */
 #define KVM_S390_ZPCI_OP         _IOW(KVMIO,  0xd1, struct kvm_s390_zpci_op)
 
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 0d5d4419139a..097661a867d9 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1178,6 +1178,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
+#define KVM_CAP_VM_DISABLE_NX_HUGE_PAGE_RECOVERY 224
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -2198,6 +2199,9 @@ struct kvm_stats_desc {
 #define KVM_X86_NOTIFY_VMEXIT_ENABLED		(1ULL << 0)
 #define KVM_X86_NOTIFY_VMEXIT_USER		(1ULL << 1)
 
+/* Available with KVM_CAP_VM_DISABLE_NX_HUGE_PAGE_RECOVERY */
+#define KVM_X86_DISABLE_NX_HUGE_PAGE_RECOVERY	(1ULL << 0)
+
 /* Available with KVM_CAP_S390_ZPCI_OP */
 #define KVM_S390_ZPCI_OP         _IOW(KVMIO,  0xd1, struct kvm_s390_zpci_op)
 

base-commit: 7f7bac08d9e31cd6e2c0ea1685c86ec6f1e7e03c
-- 


> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
> In order to check if this commit increases the CPU usage of the NX
> recovery worker thread I used a modified version of execute_perf_test
> [1] that supports splitting guest memory into multiple slots and reports
> /proc/pid/schedstat:se.sum_exec_runtime for the NX recovery worker just
> before tearing down the VM. The goal was to force a large number of NX
> Huge Page recoveries and see if the recovery worker used any more CPU.
> 
> Test Setup:
> 
>   echo 1000 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
>   echo 10 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
> 
> Test Command:
> 
>   ./execute_perf_test -v64 -s anonymous_hugetlb_1gb -x 16 -o
> 
>         | kvm-nx-lpage-re:se.sum_exec_runtime      |
>         | ---------------------------------------- |
> Run     | Before             | After               |
> ------- | ------------------ | ------------------- |
> 1       | 730.084105         | 724.375314          |
> 2       | 728.751339         | 740.581988          |
> 3       | 736.264720         | 757.078163          |
> 
> Comparing the median results, this commit results in about a 1% increase
> CPU usage of the NX recovery worker.
> 
> [1] https://lore.kernel.org/kvm/20221019234050.3919566-2-dmatlack@google.com/
> 
> v2:
>  - Only skip NX Huge Pages that are actively being dirty tracked [Paolo]
> 
> v1: https://lore.kernel.org/kvm/20221027200316.2221027-1-dmatlack@google.com/
> 
>  arch/x86/kvm/mmu/mmu.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 82bc6321e58e..1c443f9aeb4b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6831,6 +6831,7 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
>  static void kvm_recover_nx_huge_pages(struct kvm *kvm)
>  {
>  	unsigned long nx_lpage_splits = kvm->stat.nx_lpage_splits;
> +	struct kvm_memory_slot *slot;
>  	int rcu_idx;
>  	struct kvm_mmu_page *sp;
>  	unsigned int ratio;
> @@ -6865,7 +6866,21 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
>  				      struct kvm_mmu_page,
>  				      possible_nx_huge_page_link);
>  		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
> -		if (is_tdp_mmu_page(sp))
> +		WARN_ON_ONCE(!sp->role.direct);

This is an unrelated change, no?  In the sense that nothing below will break if
the SP isn't direct.

> +
> +		slot = gfn_to_memslot(kvm, sp->gfn);
> +		WARN_ON_ONCE(!slot);
> +
> +		/*
> +		 * Unaccount and do not attempt to recover any NX Huge Pages
> +		 * that are being dirty tracked, as they would just be faulted
> +		 * back in as 4KiB pages. The NX Huge Pages in this slot will be
> +		 * recovered, along with all the other huge pages in the slot,
> +		 * when dirty logging is disabled.
> +		 */
> +		if (slot && kvm_slot_dirty_track_enabled(slot))

Not sure it's cleaner, but this could be:

		if (!WARN_ON_ONCE(!slot) && kvm_slot_dirty_track_enabled(slot))

to show that KVM doesn't blow up if the above WARN fires.

> +			unaccount_nx_huge_page(kvm, sp);
> +		else if (is_tdp_mmu_page(sp))
>  			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
>  		else
>  			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
> 
> -- 
> 2.38.1.431.g37b22c650d-goog
> 
