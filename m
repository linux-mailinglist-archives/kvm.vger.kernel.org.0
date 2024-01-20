Return-Path: <kvm+bounces-6476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9EE283345A
	for <lists+kvm@lfdr.de>; Sat, 20 Jan 2024 13:44:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D11D1F222DF
	for <lists+kvm@lfdr.de>; Sat, 20 Jan 2024 12:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A0EEEDB;
	Sat, 20 Jan 2024 12:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LFchhK4n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60CDDDC1;
	Sat, 20 Jan 2024 12:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705754650; cv=none; b=HMVFimsaushaer30O0ysmRZb9H0xeHUT+xkDJ1RpbGi9VxjDrXkm0ukLTIolWBmgh5pwg1pZvEkEt5ft5vS35ySyrXQ4F+PsPYt2XPqWTkPZTXJDG+BRg8dqi7v4epstBUODG+5oBsag7tXDstEWKJZP1cspbOJ28x7PzJvrbwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705754650; c=relaxed/simple;
	bh=MJq9EqTMgfUci4DMIWU2In9pgKeV5L7ecAkyQksA8RQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jYZYcwVy3Tf8cv8A8QxMCDyVqnz913oA/Ym4KhBwOJP02yOCSDAe6Gq5SlKz8hxvXlxsQLYceJttiD4n5JLiScQOSYDF5TR/s7Orksp96V8fgqMWHNENCdt37Ow/sMRabNHvw4VKBFeaL+cUd3SfVLSaDwbmixR2y9pmen0H6C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LFchhK4n; arc=none smtp.client-ip=192.55.52.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705754648; x=1737290648;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MJq9EqTMgfUci4DMIWU2In9pgKeV5L7ecAkyQksA8RQ=;
  b=LFchhK4ngkUIzWY3yBpIQb5oq24AVZQnUBBwotSPWXiMV9nlNY3qXeyf
   oRED9DRmFohDjXr3GcskfBaWKrNeqhngUZQuFfnwapD0qNh45TPQrTPzI
   eOQxN6Xd+Tud2fLXtww3gKCpdKP+021VVAoslgLXE9uN4s9O+mBEEedb5
   ifN1ObZCwSED0osDu1YrOlGJy5yKCccLa3WM6CQvSeVKwgSKVM6A6fqZ8
   BKt4S4ex7ZeHxQLztN9dYWFIEC6YgvBclXEttchS550on7xeztRM2FviF
   fg6rimMmMt3tgP9FAFDQvS13LbAslArezGQyycI14ccTHBLcf8YRcaCY/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10957"; a="487081224"
X-IronPort-AV: E=Sophos;i="6.05,208,1701158400"; 
   d="scan'208";a="487081224"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2024 04:44:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,208,1701158400"; 
   d="scan'208";a="895909"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa004.jf.intel.com with ESMTP; 20 Jan 2024 04:44:06 -0800
Date: Sat, 20 Jan 2024 20:40:53 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 1/4] KVM: Always flush async #PF workqueue when vCPU is
 being destroyed
Message-ID: <Zau/VQ0B5MCwoqZT@yilunxu-OptiPlex-7050>
References: <20240110011533.503302-1-seanjc@google.com>
 <20240110011533.503302-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110011533.503302-2-seanjc@google.com>

On Tue, Jan 09, 2024 at 05:15:30PM -0800, Sean Christopherson wrote:
> Always flush the per-vCPU async #PF workqueue when a vCPU is clearing its
> completion queue, e.g. when a VM and all its vCPUs is being destroyed.
> KVM must ensure that none of its workqueue callbacks is running when the
> last reference to the KVM _module_ is put.  Gifting a reference to the
> associated VM prevents the workqueue callback from dereferencing freed
> vCPU/VM memory, but does not prevent the KVM module from being unloaded
> before the callback completes.
> 
> Drop the misguided VM refcount gifting, as calling kvm_put_kvm() from
> async_pf_execute() if kvm_put_kvm() flushes the async #PF workqueue will
> result in deadlock.  async_pf_execute() can't return until kvm_put_kvm()
> finishes, and kvm_put_kvm() can't return until async_pf_execute() finishes:
> 
>  WARNING: CPU: 8 PID: 251 at virt/kvm/kvm_main.c:1435 kvm_put_kvm+0x2d/0x320 [kvm]
>  Modules linked in: vhost_net vhost vhost_iotlb tap kvm_intel kvm irqbypass
>  CPU: 8 PID: 251 Comm: kworker/8:1 Tainted: G        W          6.6.0-rc1-e7af8d17224a-x86/gmem-vm #119
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>  Workqueue: events async_pf_execute [kvm]
>  RIP: 0010:kvm_put_kvm+0x2d/0x320 [kvm]
>  Call Trace:
>   <TASK>
>   async_pf_execute+0x198/0x260 [kvm]
>   process_one_work+0x145/0x2d0
>   worker_thread+0x27e/0x3a0
>   kthread+0xba/0xe0
>   ret_from_fork+0x2d/0x50
>   ret_from_fork_asm+0x11/0x20
>   </TASK>
>  ---[ end trace 0000000000000000 ]---
>  INFO: task kworker/8:1:251 blocked for more than 120 seconds.
>        Tainted: G        W          6.6.0-rc1-e7af8d17224a-x86/gmem-vm #119
>  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>  task:kworker/8:1     state:D stack:0     pid:251   ppid:2      flags:0x00004000
>  Workqueue: events async_pf_execute [kvm]
>  Call Trace:
>   <TASK>
>   __schedule+0x33f/0xa40
>   schedule+0x53/0xc0
>   schedule_timeout+0x12a/0x140
>   __wait_for_common+0x8d/0x1d0
>   __flush_work.isra.0+0x19f/0x2c0
>   kvm_clear_async_pf_completion_queue+0x129/0x190 [kvm]
>   kvm_arch_destroy_vm+0x78/0x1b0 [kvm]
>   kvm_put_kvm+0x1c1/0x320 [kvm]
>   async_pf_execute+0x198/0x260 [kvm]
>   process_one_work+0x145/0x2d0
>   worker_thread+0x27e/0x3a0
>   kthread+0xba/0xe0
>   ret_from_fork+0x2d/0x50
>   ret_from_fork_asm+0x11/0x20
>   </TASK>
> 
> If kvm_clear_async_pf_completion_queue() actually flushes the workqueue,
> then there's no need to gift async_pf_execute() a reference because all
> invocations of async_pf_execute() will be forced to complete before the
> vCPU and its VM are destroyed/freed.  And that in turn fixes the module
> unloading bug as __fput() won't do module_put() on the last vCPU reference
> until the vCPU has been freed, e.g. if closing the vCPU file also puts the

I'm not sure why __fput() of vCPU fd should be mentioned here. I assume
we just need to say that vCPUs are freed before module_put(KVM the module)
in kvm_destroy_vm(), then the whole logic for module unloading fix is:

  1. All workqueue callbacks complete when kvm_clear_async_pf_completion_queue(vcpu)
  2. kvm_clear_async_pf_completion_queue(vcpu) must be executed before vCPU free.
  3. vCPUs must be freed before module_put(KVM the module).

  So all workqueue callbacks complete before module_put(KVM the module).


__fput() of vCPU fd is not the only trigger of kvm_destroy_vm(), that
makes me distracted from reason of the fix.

> last reference to the KVM module.
> 
> Note that kvm_check_async_pf_completion() may also take the work item off
> the completion queue and so also needs to flush the work queue, as the
> work will not be seen by kvm_clear_async_pf_completion_queue().  Waiting
> on the workqueue could theoretically delay a vCPU due to waiting for the
> work to complete, but that's a very, very small chance, and likely a very
> small delay.  kvm_arch_async_page_present_queued() unconditionally makes a
> new request, i.e. will effectively delay entering the guest, so the
> remaining work is really just:
> 
>         trace_kvm_async_pf_completed(addr, cr2_or_gpa);
> 
>         __kvm_vcpu_wake_up(vcpu);
> 
>         mmput(mm);
> 
> and mmput() can't drop the last reference to the page tables if the vCPU is
> still alive, i.e. the vCPU won't get stuck tearing down page tables.
> 
> Add a helper to do the flushing, specifically to deal with "wakeup all"
> work items, as they aren't actually work items, i.e. are never placed in a
> workqueue.  Trying to flush a bogus workqueue entry rightly makes
> __flush_work() complain (kudos to whoever added that sanity check).
> 
> Note, commit 5f6de5cbebee ("KVM: Prevent module exit until all VMs are
> freed") *tried* to fix the module refcounting issue by having VMs grab a
> reference to the module, but that only made the bug slightly harder to hit
> as it gave async_pf_execute() a bit more time to complete before the KVM
> module could be unloaded.
> 
> Fixes: af585b921e5d ("KVM: Halt vcpu if page it tries to access is swapped out")
> Cc: stable@vger.kernel.org
> Cc: David Matlack <dmatlack@google.com>
> Cc: Xu Yilun <yilun.xu@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/async_pf.c | 37 ++++++++++++++++++++++++++++++++-----
>  1 file changed, 32 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index e033c79d528e..876927a558ad 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -87,7 +87,25 @@ static void async_pf_execute(struct work_struct *work)
>  	__kvm_vcpu_wake_up(vcpu);
>  
>  	mmput(mm);
> -	kvm_put_kvm(vcpu->kvm);
> +}
> +
> +static void kvm_flush_and_free_async_pf_work(struct kvm_async_pf *work)
> +{
> +	/*
> +	 * The async #PF is "done", but KVM must wait for the work item itself,
> +	 * i.e. async_pf_execute(), to run to completion.  If KVM is a module,
> +	 * KVM must ensure *no* code owned by the KVM (the module) can be run
> +	 * after the last call to module_put(), i.e. after the last reference
> +	 * to the last vCPU's file is put.

Maybe drop the i.e? It is not exactly true, other components like VFIO
may also be the last one to put KVM reference?

> +	 *
> +	 * Wake all events skip the queue and go straight done, i.e. don't
> +	 * need to be flushed (but sanity check that the work wasn't queued).
> +	 */
> +	if (work->wakeup_all)
> +		WARN_ON_ONCE(work->work.func);
> +	else
> +		flush_work(&work->work);
> +	kmem_cache_free(async_pf_cache, work);
>  }
>  
>  void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> @@ -114,7 +132,6 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  #else
>  		if (cancel_work_sync(&work->work)) {
>  			mmput(work->mm);
> -			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
>  			kmem_cache_free(async_pf_cache, work);
>  		}
>  #endif
> @@ -126,7 +143,18 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  			list_first_entry(&vcpu->async_pf.done,
>  					 typeof(*work), link);
>  		list_del(&work->link);
> -		kmem_cache_free(async_pf_cache, work);
> +
> +		spin_unlock(&vcpu->async_pf.lock);
> +
> +		/*
> +		 * The async #PF is "done", but KVM must wait for the work item
> +		 * itself, i.e. async_pf_execute(), to run to completion.  If
> +		 * KVM is a module, KVM must ensure *no* code owned by the KVM
> +		 * (the module) can be run after the last call to module_put(),
> +		 * i.e. after the last reference to the last vCPU's file is put.
> +		 */
> +		kvm_flush_and_free_async_pf_work(work);
> +		spin_lock(&vcpu->async_pf.lock);
>  	}
>  	spin_unlock(&vcpu->async_pf.lock);
>  
> @@ -151,7 +179,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
>  
>  		list_del(&work->queue);
>  		vcpu->async_pf.queued--;
> -		kmem_cache_free(async_pf_cache, work);
> +		kvm_flush_and_free_async_pf_work(work);
>  	}
>  }
>  
> @@ -186,7 +214,6 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	work->arch = *arch;
>  	work->mm = current->mm;
>  	mmget(work->mm);
> -	kvm_get_kvm(work->vcpu->kvm);
>  
>  	INIT_WORK(&work->work, async_pf_execute);

Overall LGTM, Reviewed-by: Xu Yilun <yilun.xu@intel.com>

>  
> -- 
> 2.43.0.472.g3155946c3a-goog
> 

