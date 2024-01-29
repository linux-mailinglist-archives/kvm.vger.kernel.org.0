Return-Path: <kvm+bounces-7318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B3218400D0
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 10:02:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF1161F2143A
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 09:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8664F54FA2;
	Mon, 29 Jan 2024 09:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RTubcn3+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F180554BEC
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 09:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706518930; cv=none; b=G+Hdxz2H7+dkCIAkR/O0hfvaArr2wQsnHxhT9+87ICZHhJERqLZzVcGw3JshiOlRMMAUrXFVlkkAMJxW/0N2h2c6vK79I/W9wBy52OPyND68v9f7MH4bo5kpRia6LkgansyA1s7ijcAUTxWFGnhvTNZOrj5SSssqh6XR5FaowUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706518930; c=relaxed/simple;
	bh=COFuiXNmMGA/+sVMTkzVPlLDPJNy9RI5YSME7qSVgSU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Xz1/yfGi2KcjK5igN1sMKBy0DsIx9/TD5s5OoArZhKjmSoPji7A8h73Ptx9BsHMNS/Ks79iXD9tUxD10jnRMEBArWvZhn1MYhPSGzX7eNAoKUTvcP9e0Cbzwpjdb8YGWDSy0Y4fst2hFjZeiRHvk5IULys5YcBut6TWkSTj0984=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RTubcn3+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706518927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4MB465tEzjr+uKTTxUcbdkZrnSvI1ObRHpmokNpCVH0=;
	b=RTubcn3+6F3pJLFG9Cc6dPKTKD9NE/9RquVzPxUtCeuLU/CxSmOCJCLRy5No+uw7Y9r1Oa
	6uLNE1FAVgExbrBClHZlx89QhJR1MBWUmr9jQ5AXSUUcktrB80ptyihkn6auiF0RPPjPil
	BEN6KjGUs36Wm/9LPXTu724RZn0nKXs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-kkT72VyfPvyvRSQhppi36w-1; Mon, 29 Jan 2024 04:02:03 -0500
X-MC-Unique: kkT72VyfPvyvRSQhppi36w-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40efb53adbfso934745e9.0
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 01:02:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706518922; x=1707123722;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4MB465tEzjr+uKTTxUcbdkZrnSvI1ObRHpmokNpCVH0=;
        b=GE3BXv6ylMLzjVfHCHFEqWN/MbPu59LGwWyQI5I0CLOGbrJ9gzU3+hKfBR1xM8bKEw
         Hh5tOwbUm2pIMm2H0+Y/AbtAj6oEIEViWIXKufcyVJk0zinkPj0hGgxWi6riXn5Yb2tJ
         VcEOZhLjA/tdkx5vOcVQjzmQJ+bV+khytZigMHgT78IdlYS56hho8XYRJ5p6cb4dh8Yj
         f7p6lKYQeESRG2r4yyvrEWgCCxAAXnRUyne8WGii8tbsM3xhTHAjuRtUIEk7hGewqRSe
         T1auIroiVNFYai6MhYgWb8QpboZj+dSjtIKg4vhrO0/9Ca3UfORynlj5xdwWMdP8/D/s
         OxLg==
X-Gm-Message-State: AOJu0YwoOpDj3N0x53UTkpRuf2jQkjH6JpSddVFI0YYEbocgiT6uWnz6
	h24O2VFqbobthiI7tIKEqL7GdvQ56NObFksCPuvAgr9XWMWl1yQi0ESmP4QfbSjbY69n1gDOoo6
	lMZOIri5I0SyUiMfz62zo8vqBfJ8K5r1guM4waOxj1llCpGFQQc9k0YZ0Aw==
X-Received: by 2002:adf:e98f:0:b0:337:c6a6:622a with SMTP id h15-20020adfe98f000000b00337c6a6622amr4326764wrm.8.1706518921984;
        Mon, 29 Jan 2024 01:02:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEPWj/c/xYotH1IRvnDh4eXeDnY0TXh49+1sT1juVtq7gMiYJvvHJ5SGf52vY6SKojjXyeJSQ==
X-Received: by 2002:adf:e98f:0:b0:337:c6a6:622a with SMTP id h15-20020adfe98f000000b00337c6a6622amr4326743wrm.8.1706518921628;
        Mon, 29 Jan 2024 01:02:01 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id bv4-20020a0560001f0400b0033aec05328csm2803068wrb.6.2024.01.29.01.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 01:02:01 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>, Xu
 Yilun <yilun.xu@linux.intel.com>
Subject: Re: [PATCH 1/4] KVM: Always flush async #PF workqueue when vCPU is
 being destroyed
In-Reply-To: <ZbPpvZb51cwSGKfE@google.com>
References: <20240110011533.503302-1-seanjc@google.com>
 <20240110011533.503302-2-seanjc@google.com> <87le8c82ci.fsf@redhat.com>
 <ZbPpvZb51cwSGKfE@google.com>
Date: Mon, 29 Jan 2024 10:02:00 +0100
Message-ID: <87cytk8qd3.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Jan 26, 2024, Vitaly Kuznetsov wrote:
>> > +static void kvm_flush_and_free_async_pf_work(struct kvm_async_pf *work)
>> > +{
>> > +	/*
>> > +	 * The async #PF is "done", but KVM must wait for the work item itself,
>> > +	 * i.e. async_pf_execute(), to run to completion.  If KVM is a module,
>> > +	 * KVM must ensure *no* code owned by the KVM (the module) can be run
>> > +	 * after the last call to module_put(), i.e. after the last reference
>> > +	 * to the last vCPU's file is put.
>> > +	 *
>> 
>> Do I understand correctly that the problem is also present on the
>> "normal" path, i.e.:
>> 
>>   KVM_REQ_APF_READY
>>      kvm_check_async_pf_completion()
>>          kmem_cache_free(,work)
>> 
>> on one CPU can actually finish _before_ work is fully flushed on the
>> other (async_pf_execute() has already added an item to 'done' list but
>> hasn't completed)? Is it just the fact that the window of opportunity
>> to get the freed item re-purposed is so short that no real issue was
>> ever noticed?
>
> Sort of?  It's not a problem with accessing a freed obect, the issue is that
> async_pf_execute() can still be executing while KVM-the-module is unloaded.
>
> The reason the "normal" path is problematic is because it removes the
> work entry from async_pf.done and from async_pf.queue, i.e. makes it invisible
> to kvm_arch_destroy_vm().  So to hit the bug where the "normal" path processes
> the completed work, userspace would need to terminate the VM (i.e. exit() or
> close all fds), and KVM would need to completely tear down the VM, all before
> async_pf_execute() finished it's last few instructions.
>
> Which is possible, just comically unlikely :-)
>
>> In that case I'd suggest we emphasize that in the comment as currently it
>> sounds like kvm_arch_destroy_vm() is the only probemmatic path.
>
> How's this?
>
> 	/*
> 	 * The async #PF is "done", but KVM must wait for the work item itself,
> 	 * i.e. async_pf_execute(), to run to completion.  If KVM is a module,
> 	 * KVM must ensure *no* code owned by the KVM (the module) can be run
> 	 * after the last call to module_put().  Note, flushing the work item
> 	 * is always required when the item is taken off the completion queue.
> 	 * E.g. even if the vCPU handles the item in the "normal" path, the VM
> 	 * could be terminated before async_pf_execute() completes.
> 	 *
> 	 * Wake all events skip the queue and go straight done, i.e. don't
> 	 * need to be flushed (but sanity check that the work wasn't queued).
> 	 */
>

Sounds good to me, thanks!

>> > +	 * Wake all events skip the queue and go straight done, i.e. don't
>> > +	 * need to be flushed (but sanity check that the work wasn't queued).
>> > +	 */
>> > +	if (work->wakeup_all)
>> > +		WARN_ON_ONCE(work->work.func);
>> > +	else
>> > +		flush_work(&work->work);
>> > +	kmem_cache_free(async_pf_cache, work);
>> >  }
>> >  
>> >  void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>> > @@ -114,7 +132,6 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>> >  #else
>> >  		if (cancel_work_sync(&work->work)) {
>> >  			mmput(work->mm);
>> > -			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
>> >  			kmem_cache_free(async_pf_cache, work);
>> >  		}
>> >  #endif
>> > @@ -126,7 +143,18 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>> >  			list_first_entry(&vcpu->async_pf.done,
>> >  					 typeof(*work), link);
>> >  		list_del(&work->link);
>> > -		kmem_cache_free(async_pf_cache, work);
>> > +
>> > +		spin_unlock(&vcpu->async_pf.lock);
>> > +
>> > +		/*
>> > +		 * The async #PF is "done", but KVM must wait for the work item
>> > +		 * itself, i.e. async_pf_execute(), to run to completion.  If
>> > +		 * KVM is a module, KVM must ensure *no* code owned by the KVM
>> > +		 * (the module) can be run after the last call to module_put(),
>> > +		 * i.e. after the last reference to the last vCPU's file is put.
>> > +		 */
>
> Doh, this is a duplicate comment, I'll delete it.
>  
>> > +		kvm_flush_and_free_async_pf_work(work);
>> > +		spin_lock(&vcpu->async_pf.lock);
>> >  	}
>> >  	spin_unlock(&vcpu->async_pf.lock);
>> >  
>> > @@ -151,7 +179,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
>> >  
>> >  		list_del(&work->queue);
>> >  		vcpu->async_pf.queued--;
>> > -		kmem_cache_free(async_pf_cache, work);
>> > +		kvm_flush_and_free_async_pf_work(work);
>> >  	}
>> >  }
>> >  
>> > @@ -186,7 +214,6 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>> >  	work->arch = *arch;
>> >  	work->mm = current->mm;
>> >  	mmget(work->mm);
>> > -	kvm_get_kvm(work->vcpu->kvm);
>> >  
>> >  	INIT_WORK(&work->work, async_pf_execute);
>> 
>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> 
>> -- 
>> Vitaly
>> 
>

-- 
Vitaly


