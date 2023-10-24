Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85347D49E8
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 10:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233722AbjJXIWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 04:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbjJXIWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 04:22:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8E28F;
        Tue, 24 Oct 2023 01:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698135767; x=1729671767;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Zh7bEL2SIcxsxyb8VslBMEHSYS/0n/9QeAnOCDwU9XY=;
  b=dUowm9kElgnHBzguBUF5Zz8SSsZzFzfDabopOfsbZFZt9ng+YujjmMXY
   axZ31DuqrDHTZi7nz2ic/Dku5w4+JFHPJUHO/BKxAaG5N7+jvL3OJpcTq
   JgM8+DVk2x/dyg6JFIbLBzDqFQ/zw2F7G3XoOeO5bCRkV1iBUJZlDrVwG
   +YKjGugJ6Xw1FgmealEtYzRnmcTT1wtyNANCWt7ZWakxLiIgcAWn3vnNG
   uMF5XAIUVegcEQ4JH8L6qsBoB2FvxllDUVLft2EpYD+KZYgNITgk26cZZ
   kpyEAyIQqFF24i9wdQhAP00GvmvqbbgH6aRdL+wg2XNxYsf3v5FymzqHE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="453469889"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="453469889"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 01:22:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="758393523"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="758393523"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orsmga002.jf.intel.com with ESMTP; 24 Oct 2023 01:22:44 -0700
Date:   Tue, 24 Oct 2023 16:21:31 +0800
From:   Xu Yilun <yilun.xu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 2/3] KVM: Always flush async #PF workqueue when vCPU is
 being destroyed
Message-ID: <ZTd+i2I5n0NyzuuT@yilunxu-OptiPlex-7050>
References: <20231018204624.1905300-1-seanjc@google.com>
 <20231018204624.1905300-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018204624.1905300-3-seanjc@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 01:46:23PM -0700, Sean Christopherson wrote:
> Always flush the per-vCPU async #PF workqueue when a vCPU is clearing its
> completion queue, i.e. when a VM and all its vCPUs is being destroyed.
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
> last reference to the KVM module.
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
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/async_pf.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index e033c79d528e..7aeb9d1f43b1 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -87,7 +87,6 @@ static void async_pf_execute(struct work_struct *work)
>  	__kvm_vcpu_wake_up(vcpu);
>  
>  	mmput(mm);
> -	kvm_put_kvm(vcpu->kvm);
>  }
>  
>  void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> @@ -114,7 +113,6 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  #else
>  		if (cancel_work_sync(&work->work)) {
>  			mmput(work->mm);
> -			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
>  			kmem_cache_free(async_pf_cache, work);
>  		}
>  #endif
> @@ -126,7 +124,19 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  			list_first_entry(&vcpu->async_pf.done,
>  					 typeof(*work), link);
>  		list_del(&work->link);
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
> +		flush_work(&work->work);

I see the flush_work() is inside the check:

  while (!list_empty(&vcpu->async_pf.done))

Is it possible all async_pf are already completed but the work item,
i.e. async_pf_execute, is not completed before this check? That the
work is scheduled out after kvm_arch_async_page_present_queued() and
all APF_READY requests have been handled. In this case the work
synchronization will be skipped...

Thanks,
Yilun

>  		kmem_cache_free(async_pf_cache, work);
> +		spin_lock(&vcpu->async_pf.lock);
>  	}
>  	spin_unlock(&vcpu->async_pf.lock);
>  
> @@ -186,7 +196,6 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  	work->arch = *arch;
>  	work->mm = current->mm;
>  	mmget(work->mm);
> -	kvm_get_kvm(work->vcpu->kvm);
>  
>  	INIT_WORK(&work->work, async_pf_execute);
>  
> -- 
> 2.42.0.655.g421f12c284-goog
> 
