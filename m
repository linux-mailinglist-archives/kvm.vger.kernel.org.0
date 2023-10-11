Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A50A7C57C4
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 17:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346731AbjJKPJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 11:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232136AbjJKPJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 11:09:34 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A816990;
        Wed, 11 Oct 2023 08:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697036972; x=1728572972;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zs5CoESx5/0rD+ydUWpNHP61+ukdq59RMMCGa5DFli0=;
  b=TbfAzkYS0BVaHu16iQEtOhJEo2ZfbZZ3lTRLy3m5ZSiFqJNocoJlaFZF
   8N+prv2eShxobZmRgkysApHk28k/5vylj2Ge95dANo0ECRhYVhb5lnfUD
   Ag8XCBiJjNZmn7H/Ud54C98891T3pwBxIew1NC/wJpu/+CsQOH9qjTX35
   NJlcM28/kA2r4usqrPYCQRjhCu3CRg7mYlBZiLRI66TLZTX2nNK+zISh4
   He1lPYWOaBtFbnfnFJvMWw8B3m8VtrS1cXs1+mzyOUwKn469iRb6lDpUe
   RK6xjDjNQ5MYoNo7laFTct2Kobm6/gCFfV3gghXY8uVLCTpqddKVy4Dz4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="415735417"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="415735417"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 08:07:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="1001152317"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="1001152317"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by fmsmga006.fm.intel.com with ESMTP; 11 Oct 2023 08:07:29 -0700
Date:   Wed, 11 Oct 2023 23:06:34 +0800
From:   Xu Yilun <yilun.xu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH gmem FIXUP] kvm: guestmem: do not use a file system
Message-ID: <ZSa5+upNcrclO35a@yilunxu-OptiPlex-7050>
References: <20231009022248.GD800259@ZenIV>
 <ZSQO4fHaAxDkbGyz@google.com>
 <20231009200608.GJ800259@ZenIV>
 <ZSRgdgQe3fseEQpf@google.com>
 <20231009204037.GK800259@ZenIV>
 <ZSRwDItBbsn2IfWl@google.com>
 <20231010000910.GM800259@ZenIV>
 <ZSSaWPc5wjU9k1Kw@google.com>
 <20231010003746.GN800259@ZenIV>
 <ZSXeipdJcWZjLx8k@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSXeipdJcWZjLx8k@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 04:30:18PM -0700, Sean Christopherson wrote:
> On Tue, Oct 10, 2023, Al Viro wrote:
> > On Mon, Oct 09, 2023 at 05:27:04PM -0700, Sean Christopherson wrote:
> > 
> > > If the last reference is effectively held by guest_memfd, it would be:
> > > 
> > >   kvm_gmem_release(), a.k.a. file_operations.release()
> > >   |
> > >   -> kvm_put_kvm()
> > >      |
> > >      -> kvm_destroy_vm()
> > >         |
> > >         -> module_put(kvm_chardev_ops.owner);
> > 
> > ... and now your thread gets preempted and loses CPU; before you get
> > it back, some joker calls delete_module(), and page of code containing
> > kvm_gmem_release() is unmapped.  Even though an address within that
> > page is stored as return address in a frame on your thread's stack.
> > That thread gets the timeslice again and proceeds to return into
> > unmapped page.  Oops...
> 
> *sigh*
> 
> What an absolute snafu.  Sorry for the wall of text.  Feel free to stop reading
> after the "Back to KVM..." part below, it's just gory details on how we screwed
> things up in KVM.
> 
> But one question before I dive into the KVM mess: other than error paths, how is
> module_put(THIS_MODULE) ever safe without being superfluous?  I don't see how a
> module can put the last reference to itself without either hitting the above
> scenario, or without creating deadlock.  Something other than the module must put

I think module_get/put(THIS_MODULE) is not responsible for guarding
this scenario. It just makes a section against module removal. Out of
this section, you still need other mechanisms to ensure no task run on
the module code before its module_exit() return. This is still true even
if no module_get/put(THIS_MODULE) is used.

Today with all your help, I can see the fops.owner = THIS_MODULE is an
efficient way to ensure no entry to file callbacks when module_exit() is
called.

> the last reference, no?
> 
> The only exceptions I see are:
> 
>   1. if module_put() is called via async_run_entry_fn(), as delete_module() invokes
>      async_synchronize_full() before unmapping the module.  But IIUC, the async
>      framework uses workqueues, not the other way around.  I.e. delete_module()
>      doesn't flush arbitrary workqueues.
> 
>   2. if module_put() is called via module_put_and_kthread_exit(), which uses
>      THIS_MODULE but does module_put() from a core kernel helper and never returns
>      to the module's kthread, i.e. doesn't return to module code.
> 
> But then this
> 
>   $ git grep -E "module_put\(THIS_MODULE" | wc -l
>   132
> 
> make me go "huh"?  I've blamed a handful of those calls, and I can't find a single
> one that provides any clue as to why the module gets/puts references to itself,
> let alone actually justifies the usage.
> 
> E.g. drivers/block/loop.c has this gem
> 
> 	/* This is safe: open() is still holding a reference. */
> 	module_put(THIS_MODULE);
> 
> in __loop_clr_fd(), which is invoked from a .release() function.  So open() quite
> clearly doesn't hold a reference, unless the comment is talking about the reference
> that was obtained by the core file systems layer and won't be put until after
> .release() completes.  But then what on earth is the point of doing
> module_get(THIS_MODULE) and module_put(THIS_MODULE)?

I see the comment that .release()->__loop_clr_fd() is only called when in
"autoclear mode". Maybe in some "manual mode", user should explicitly
call IOCTL(LOOP_CLR_FD) to allow module removal. That means in some
case, user called IOCTL(LOOP_CONFIGURE) and then closed all fds, but the
device state was not cleaned up, so that the driver module is not allowed to
be removed.

Thanks,
Yilun

> 
> 
> Back to KVM...
> 
> Commit 5f6de5cbebee ("KVM: Prevent module exit until all VMs are freed") *tried*
> to fix a bug where KVM-the-module could be unloaded while a KVM workqueue callback
> was still in-flight.  The callback had a reference to the VM, but not to the VM's
> file representation.
> 
> After that commit went in, I suggested dropping the use of .owner for VMs and
> vCPUs (each of which is represented by an anon inode file) because keeping the VM
> alive would pin KVM-the-module until all VMs went away.  But I missed the
> obvious-in-hindsight issue Al highlighted above.
> 
> Fixing that particular wart is relatively easy: revert commit 70375c2d8fa3 ("Revert
> "KVM: set owner of cpu and vm file operations""), and give all of the other KVM-owned
> file_operations structures the same treatment by setting .owner correctly.  Note,
> "correctly" isn't THIS_MODULE in most cases, which is why the code existing is a
> bit odd.  For most file_operations, on x86 and PPC (and MIPS?), the effective owner
> is actually a sub-module, e.g. THIS_MODULE will point at kvm.ko, but on x86 the
> effective owner is either kvm-intel.ko or kvm-amd.ko (which holds a reference to
> kvm.ko).
> 
> After staring and fiddling for most of today, I finally discovered that grabbing
> a reference to the module on behalf of the work item didn't fix the actual bugs,
> plural, it just shuffled the deck chairs on the Titanic.  And as above, it set us
> up to make even bigger mistakes regarding .owner :-(
> 
> The problematic code is effectively kvm_clear_async_pf_completion_queue().  That
> helper is called for each vCPU when a VM is being destroyed, i.e. when the last
> reference to a VM is put via kvm_put_kvm().  Clearing the queue *should* also
> flush all work items, except it doesn't when the work is "done", where "done" just
> means the page being faulted in is ready.  Using file_operations.owner doesn't
> solve anything, e.g. even if async_pf_execute() were gifted a reference to the
> VM's file and used the deferred fput(), the same preemption issue exists, it's
> just slightly harder to hit.
> 
> The original async #PF code appears to have fudged around the lack of flushing by
> gifting a VM reference to the async_pf_execute().  Or maybe it was the other way
> around and not flushing was a workaround for the deadlock that occurs if
> kvm_clear_async_pf_completion_queue() does flush the workqueue.  If kvm_put_kvm()
> is called from async_pf_execute() and kvm_put_kvm() flushes the async #PF workqueue,
> deadlock occurs becase async_pf_execute() can't return until kvm_put_kvm() finishes,
> and kvm_put_kvm() can't return until async_pf_execute() finishes.
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
> If kvm_clear_async_pf_completion_queue() actually flushes the workqueue, then
> there's no need to gift async_pf_execute() a reference because all invocations
> of async_pf_execute() will be forced to complete before the vCPU and its VM are
> destroyed/freed.  And that also fixes the module unloading mess because __fput()
> won't do module_put() on the last vCPU reference until the vCPU has been freed.
> 
> The attached patches are lightly tested, but I think they fix the KVM mess.  I
> likely won't post a proper series until next week, I'm going to be offline the
> next two days.

> From 017fedee5608094f2e5535297443db7512a213b8 Mon Sep 17 00:00:00 2001
> From: Sean Christopherson <seanjc@google.com>
> Date: Tue, 10 Oct 2023 11:42:32 -0700
> Subject: [PATCH 1/3] KVM: Set file_operations.owner appropriately for all such
>  structures
> 
> This reverts commit 70375c2d8fa3fb9b0b59207a9c5df1e2e1205c10, and gives
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/debugfs.c |  1 +
>  virt/kvm/kvm_main.c    | 11 ++++++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
> index ee8c4c3496ed..eea6ea7f14af 100644
> --- a/arch/x86/kvm/debugfs.c
> +++ b/arch/x86/kvm/debugfs.c
> @@ -182,6 +182,7 @@ static int kvm_mmu_rmaps_stat_release(struct inode *inode, struct file *file)
>  }
>  
>  static const struct file_operations mmu_rmaps_stat_fops = {
> +	.owner		= THIS_MODULE,
>  	.open		= kvm_mmu_rmaps_stat_open,
>  	.read		= seq_read,
>  	.llseek		= seq_lseek,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 486800a7024b..1e65a506985f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3887,7 +3887,7 @@ static int kvm_vcpu_release(struct inode *inode, struct file *filp)
>  	return 0;
>  }
>  
> -static const struct file_operations kvm_vcpu_fops = {
> +static struct file_operations kvm_vcpu_fops = {
>  	.release        = kvm_vcpu_release,
>  	.unlocked_ioctl = kvm_vcpu_ioctl,
>  	.mmap           = kvm_vcpu_mmap,
> @@ -4081,6 +4081,7 @@ static int kvm_vcpu_stats_release(struct inode *inode, struct file *file)
>  }
>  
>  static const struct file_operations kvm_vcpu_stats_fops = {
> +	.owner = THIS_MODULE,
>  	.read = kvm_vcpu_stats_read,
>  	.release = kvm_vcpu_stats_release,
>  	.llseek = noop_llseek,
> @@ -4431,7 +4432,7 @@ static int kvm_device_release(struct inode *inode, struct file *filp)
>  	return 0;
>  }
>  
> -static const struct file_operations kvm_device_fops = {
> +static struct file_operations kvm_device_fops = {
>  	.unlocked_ioctl = kvm_device_ioctl,
>  	.release = kvm_device_release,
>  	KVM_COMPAT(kvm_device_ioctl),
> @@ -4759,6 +4760,7 @@ static int kvm_vm_stats_release(struct inode *inode, struct file *file)
>  }
>  
>  static const struct file_operations kvm_vm_stats_fops = {
> +	.owner = THIS_MODULE,
>  	.read = kvm_vm_stats_read,
>  	.release = kvm_vm_stats_release,
>  	.llseek = noop_llseek,
> @@ -5060,7 +5062,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
>  }
>  #endif
>  
> -static const struct file_operations kvm_vm_fops = {
> +static struct file_operations kvm_vm_fops = {
>  	.release        = kvm_vm_release,
>  	.unlocked_ioctl = kvm_vm_ioctl,
>  	.llseek		= noop_llseek,
> @@ -6095,6 +6097,9 @@ int kvm_init(unsigned vcpu_size, unsigned vcpu_align, struct module *module)
>  		goto err_async_pf;
>  
>  	kvm_chardev_ops.owner = module;
> +	kvm_vm_fops.owner = module;
> +	kvm_vcpu_fops.owner = module;
> +	kvm_device_fops.owner = module;
>  
>  	kvm_preempt_ops.sched_in = kvm_sched_in;
>  	kvm_preempt_ops.sched_out = kvm_sched_out;
> 
> base-commit: dfdc8b7884b50e3bfa635292973b530a97689f12
> -- 
> 2.42.0.609.gbb76f46606-goog
> 

> From f5be42f3be9967a0591051a7c8d73cac2c0a072b Mon Sep 17 00:00:00 2001
> From: Sean Christopherson <seanjc@google.com>
> Date: Tue, 10 Oct 2023 13:42:13 -0700
> Subject: [PATCH 2/3] KVM: Always flush async #PF workqueue when vCPU is being
>  destroyed
> 
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
> 2.42.0.609.gbb76f46606-goog
> 

> From 0a4238f027e41c64afa2919440420ea56c0cae80 Mon Sep 17 00:00:00 2001
> From: Sean Christopherson <seanjc@google.com>
> Date: Tue, 10 Oct 2023 15:09:43 -0700
> Subject: [PATCH 3/3] Revert "KVM: Prevent module exit until all VMs are freed"
> 
> Revert KVM's misguided attempt to "fix" a use-after-module-unload bug that
> was actually due to failure to flush a workqueue, not a lack of module
> refcounting.
> 
> blah blah blah
> 
> This reverts commit 405294f29faee5de8c10cb9d4a90e229c2835279 and commit
> commit 5f6de5cbebee925a612856fce6f9182bb3eee0db.
> 
> Fixes: 405294f29fae ("KVM: Unconditionally get a ref to /dev/kvm module when creating a VM")
> Fixes: 5f6de5cbebee ("KVM: Prevent module exit until all VMs are freed")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 1e65a506985f..3b1b9e8dd70c 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -115,8 +115,6 @@ EXPORT_SYMBOL_GPL(kvm_debugfs_dir);
>  
>  static const struct file_operations stat_fops_per_vm;
>  
> -static struct file_operations kvm_chardev_ops;
> -
>  static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
>  			   unsigned long arg);
>  #ifdef CONFIG_KVM_COMPAT
> @@ -1157,9 +1155,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>  	if (!kvm)
>  		return ERR_PTR(-ENOMEM);
>  
> -	/* KVM is pinned via open("/dev/kvm"), the fd passed to this ioctl(). */
> -	__module_get(kvm_chardev_ops.owner);
> -
>  	KVM_MMU_LOCK_INIT(kvm);
>  	mmgrab(current->mm);
>  	kvm->mm = current->mm;
> @@ -1279,7 +1274,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>  out_err_no_srcu:
>  	kvm_arch_free_vm(kvm);
>  	mmdrop(current->mm);
> -	module_put(kvm_chardev_ops.owner);
>  	return ERR_PTR(r);
>  }
>  
> @@ -1348,7 +1342,6 @@ static void kvm_destroy_vm(struct kvm *kvm)
>  	preempt_notifier_dec();
>  	hardware_disable_all();
>  	mmdrop(mm);
> -	module_put(kvm_chardev_ops.owner);
>  }
>  
>  void kvm_get_kvm(struct kvm *kvm)
> -- 
> 2.42.0.609.gbb76f46606-goog
> 

