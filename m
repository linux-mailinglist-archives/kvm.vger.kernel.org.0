Return-Path: <kvm+bounces-7181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6835783DF32
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 17:52:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C4E72823BA
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 16:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70A31DFCA;
	Fri, 26 Jan 2024 16:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SM9d2cmb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AACD1EB25
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706287910; cv=none; b=jwoUCBRvYMibJi+YxgsQO2MFBuQtq2ho9vK+IqinFcVnQsHUoMxe7gM+Ctv5FE1zmiYZfX9y+9rd5kzBF1q/3OvBmitwqK03I6Gm9q2YcQ73svdj1zuAXHjnmcTZtrT1frlUrNQEKXG3ntj4xFQDZep1eLYEef2rHo2FNtUVmvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706287910; c=relaxed/simple;
	bh=Lce3KRLdGmV39F9gD7N09r8cWhr6hgl/GS49GQljtIg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hpxDpM4VwVYDta0BrrwBIDGHTO1KTgvPSQXXhSFEryl/y68svg2EMWF7k/3+ZbTONNHf0flP6mavJ2ndl3GQS2T44nH7UxrM4vlQIJUe1C1m95jRAuCRNRQdegOdvZFCWo4dMO3G6b3/bbEN1dj86NC4zW29XRmQrPa4c42OJVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SM9d2cmb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706287906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yOpLdaQ89xfs5/J8JNU9a4jsFk4JGMWg+LyrMFItTsw=;
	b=SM9d2cmb30p73pKSm9rJFgjVmeRKwAIKS3pOW3MYpWstL3gqKZJYzo+vuly63mPo4lDOPt
	+d9xinsAPRth4lx8mj6Ne5KN2FI5N4gAqJ/0XN5BetPczUmzHK5qolrA5h3Tintx1m/6Sc
	6iOVJPnrauYO32SSOVKF31XO+VX16XA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-b0nnFAeFO6uALrRHMv948Q-1; Fri, 26 Jan 2024 11:51:44 -0500
X-MC-Unique: b0nnFAeFO6uALrRHMv948Q-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40e47b2f6b8so6312915e9.2
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 08:51:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706287903; x=1706892703;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yOpLdaQ89xfs5/J8JNU9a4jsFk4JGMWg+LyrMFItTsw=;
        b=jeReYjhzAA1iLX0736hnDYVu25/VsxeFJcGcZXKlc3LwH+pZyGScM3/GQgksjId041
         ggqw5/ZZa9ZsdFOSInqW3NoG+QgkPECcq+KbeZM+4rv6CdLKpiL43c3nq/mKS8J2RKmE
         nZVwXKzMkh8Exag0UxkcHi/lJGeUB75gXpfRhKY4jEGHeEZ69169aLDI2PFd5rGxFToS
         IkU24AXwy/Hkv9FDHUlllGUL7DpJ0hohrwS85iiQSKZkKLR5LyYaMfsEIm/Q6FQkPW4W
         edU93h5Oi6SdhfKwI33P+eCNmXJQuYVvFIlJrTAfEWdyt7UIeWm9d4/nMhiWeiS1wvXP
         JbTQ==
X-Gm-Message-State: AOJu0Yx9BCqiv3PG0F+weY58YQHAybcLa4n0lzJRR1/DJfybb5jeZgJv
	4ecdRMzdszFsGATxVuKBqiPUGaf0L6VqUWPzbyDjvr4D3iJCCtgT6hAa2oNG9ZH2oyxracL6p+Z
	glrtsVEaH5hbpvsJgRel4ZprWVBP1lNJC6DJJFVVAnzpz/MGmvw==
X-Received: by 2002:a05:600c:214d:b0:40e:cede:3e95 with SMTP id v13-20020a05600c214d00b0040ecede3e95mr62182wml.59.1706287903466;
        Fri, 26 Jan 2024 08:51:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHlJLRKk+LooyZLJaRI7SmOKPQdWB16LOLnscxV88UXqN3bCKwtGN/A3dYC8NBbHTjmSNMiSQ==
X-Received: by 2002:a05:600c:214d:b0:40e:cede:3e95 with SMTP id v13-20020a05600c214d00b0040ecede3e95mr62169wml.59.1706287903090;
        Fri, 26 Jan 2024 08:51:43 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id bk7-20020a0560001d8700b0033addbf2d2csm1026920wrb.9.2024.01.26.08.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jan 2024 08:51:42 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, David Matlack
 <dmatlack@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, Sean
 Christopherson <seanjc@google.com>
Subject: Re: [PATCH 1/4] KVM: Always flush async #PF workqueue when vCPU is
 being destroyed
In-Reply-To: <20240110011533.503302-2-seanjc@google.com>
References: <20240110011533.503302-1-seanjc@google.com>
 <20240110011533.503302-2-seanjc@google.com>
Date: Fri, 26 Jan 2024 17:51:41 +0100
Message-ID: <87le8c82ci.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

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
> +	 *

Do I understand correctly that the problem is also present on the
"normal" path, i.e.:

  KVM_REQ_APF_READY
     kvm_check_async_pf_completion()
         kmem_cache_free(,work)

on one CPU can actually finish _before_ work is fully flushed on the
other (async_pf_execute() has already added an item to 'done' list but
hasn't completed)? Is it just the fact that the window of opportunity
to get the freed item re-purposed is so short that no real issue was
ever noticed? In that case I'd suggest we emphasize that in the comment
as currently it sounds like kvm_arch_destroy_vm() is the only
probemmatic path.

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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


