Return-Path: <kvm+bounces-7185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C08FA83DFDB
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 18:20:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4D0A1C21BE2
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 17:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCAE520B33;
	Fri, 26 Jan 2024 17:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xPXHZ+Cc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8B920B09
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 17:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706289602; cv=none; b=oqU8/3HZmTbavpoam55rH32Qc1n6uxHF79mIraVbGrtslpmeZOnYx3xgU+HRmOddK2EoT+cV61wJzu+KyFOtBsWl4HbpAZRbUk4v0Pyv/RU3nkGH+yJVJ5exvjSSGnkYuBgv0+UErQaXFHM7MndbnoC1Womu47v06wh/Ebftb+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706289602; c=relaxed/simple;
	bh=tqWw+gdlA0eXivzStNwcw4pZBCJpJC2odyMfrYuEA3s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kbqs+7n9Kx589rDxJoEVWK/Cie05TB5cIq/SY2Qdf5/v/s/4BxoZ4MoQxAPmQ1ExFFGpWE2dBOE5WwsvCggIJhN0J7CIXfKvWv8lm2g8gExhnISCHhz+/sxSskwrY8eQqaWDMYLj93mElC/OrldyeK2ewiL8PI9R9y2XFbxjw/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xPXHZ+Cc; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5ff84361ac3so25738777b3.1
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 09:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706289599; x=1706894399; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mfMEUT//jZaMNfa1P/+SvTPsij4r/uwDLHSKstJdqNE=;
        b=xPXHZ+Cc4rRYWRFQDUlicOdKryWCh6I61fRaXArh5mnSJCVhP3hL6xTHvaKcuuzAIX
         H2Hd3Fftr2svQAFBDr33xg2buM1XKpHfqAh5q9Q/X/RjE6FaLZhqJlNsCRs0mc/L4q0h
         SrMtvGzVVEhSgt5ACWmRHqx6PYa70b4alkKiX0hw+U94XiIvgWipkdWegci33NxyFjl4
         mYuFL2hsq0nGQ7DQHKceAynsnsgYaZVcgY/EU9iRHPBBFIRTl0HIw6znD4eUn+uXO57r
         Rfd3GSKVwbs8Oq1R4WM46kWBNhf/Wg1o33f0jK+y+u8IEb2smw83NLX6GtZTo3qyv8R4
         hyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706289599; x=1706894399;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mfMEUT//jZaMNfa1P/+SvTPsij4r/uwDLHSKstJdqNE=;
        b=xDIDHoXAQbNAvIh4Qw6zfsZG2lTLF/q2ha7P7POSEaWiVMZQZXEypLyZGSp7vm6WU0
         UgUoa4rTBlGWTbcYXLWNG3dFp7wQoSbW6lDBlrVSuklFa7eX+K1qR4PZ5fIHeZIsrDHj
         +OBwQ0MP9Gu2BTb04gyOXolev9XR3dBWghBRkTUzI3EOc16lXR+EgAb/7+cHczDZ/CtA
         8MBbyi/63U/A7bdVUVepMLnlSY6mFDKl/fWtDMrkSflYvUYLEg1XCBbfnwtXLX+XDBdF
         No/6aRgrlQM92chpzcqCJppppmOBxJmZ/3m5gBsb4NBZiMA4QyerQcyHFt8s6VzQq5yq
         PMYw==
X-Gm-Message-State: AOJu0YxuwQLlNGIMpreNaf0HyiTd4g1+dAXfjLWL2V5QbNILywsyVttk
	P9cXJR3u9ghFfGRNaVHVUDiodr/80/ck2f6cXIElJYf0GObkchUFJHPN/6bYJxuxzNe8L5Q284G
	RBA==
X-Google-Smtp-Source: AGHT+IG1mPISLo2QODpxS3wFHDfogrOy0asyv8vMOxyx1L9JxE0laM08dw+rKJfSuA2+6MoEscP5TKw5dlo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:458a:b0:5ff:78d0:b4b2 with SMTP id
 gu10-20020a05690c458a00b005ff78d0b4b2mr407896ywb.3.1706289599628; Fri, 26 Jan
 2024 09:19:59 -0800 (PST)
Date: Fri, 26 Jan 2024 09:19:57 -0800
In-Reply-To: <87le8c82ci.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110011533.503302-1-seanjc@google.com> <20240110011533.503302-2-seanjc@google.com>
 <87le8c82ci.fsf@redhat.com>
Message-ID: <ZbPpvZb51cwSGKfE@google.com>
Subject: Re: [PATCH 1/4] KVM: Always flush async #PF workqueue when vCPU is
 being destroyed
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Xu Yilun <yilun.xu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Vitaly Kuznetsov wrote:
> > +static void kvm_flush_and_free_async_pf_work(struct kvm_async_pf *work)
> > +{
> > +	/*
> > +	 * The async #PF is "done", but KVM must wait for the work item itself,
> > +	 * i.e. async_pf_execute(), to run to completion.  If KVM is a module,
> > +	 * KVM must ensure *no* code owned by the KVM (the module) can be run
> > +	 * after the last call to module_put(), i.e. after the last reference
> > +	 * to the last vCPU's file is put.
> > +	 *
> 
> Do I understand correctly that the problem is also present on the
> "normal" path, i.e.:
> 
>   KVM_REQ_APF_READY
>      kvm_check_async_pf_completion()
>          kmem_cache_free(,work)
> 
> on one CPU can actually finish _before_ work is fully flushed on the
> other (async_pf_execute() has already added an item to 'done' list but
> hasn't completed)? Is it just the fact that the window of opportunity
> to get the freed item re-purposed is so short that no real issue was
> ever noticed?

Sort of?  It's not a problem with accessing a freed obect, the issue is that
async_pf_execute() can still be executing while KVM-the-module is unloaded.

The reason the "normal" path is problematic is because it removes the
work entry from async_pf.done and from async_pf.queue, i.e. makes it invisible
to kvm_arch_destroy_vm().  So to hit the bug where the "normal" path processes
the completed work, userspace would need to terminate the VM (i.e. exit() or
close all fds), and KVM would need to completely tear down the VM, all before
async_pf_execute() finished it's last few instructions.

Which is possible, just comically unlikely :-)

> In that case I'd suggest we emphasize that in the comment as currently it
> sounds like kvm_arch_destroy_vm() is the only probemmatic path.

How's this?

	/*
	 * The async #PF is "done", but KVM must wait for the work item itself,
	 * i.e. async_pf_execute(), to run to completion.  If KVM is a module,
	 * KVM must ensure *no* code owned by the KVM (the module) can be run
	 * after the last call to module_put().  Note, flushing the work item
	 * is always required when the item is taken off the completion queue.
	 * E.g. even if the vCPU handles the item in the "normal" path, the VM
	 * could be terminated before async_pf_execute() completes.
	 *
	 * Wake all events skip the queue and go straight done, i.e. don't
	 * need to be flushed (but sanity check that the work wasn't queued).
	 */

> > +	 * Wake all events skip the queue and go straight done, i.e. don't
> > +	 * need to be flushed (but sanity check that the work wasn't queued).
> > +	 */
> > +	if (work->wakeup_all)
> > +		WARN_ON_ONCE(work->work.func);
> > +	else
> > +		flush_work(&work->work);
> > +	kmem_cache_free(async_pf_cache, work);
> >  }
> >  
> >  void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> > @@ -114,7 +132,6 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> >  #else
> >  		if (cancel_work_sync(&work->work)) {
> >  			mmput(work->mm);
> > -			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
> >  			kmem_cache_free(async_pf_cache, work);
> >  		}
> >  #endif
> > @@ -126,7 +143,18 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
> >  			list_first_entry(&vcpu->async_pf.done,
> >  					 typeof(*work), link);
> >  		list_del(&work->link);
> > -		kmem_cache_free(async_pf_cache, work);
> > +
> > +		spin_unlock(&vcpu->async_pf.lock);
> > +
> > +		/*
> > +		 * The async #PF is "done", but KVM must wait for the work item
> > +		 * itself, i.e. async_pf_execute(), to run to completion.  If
> > +		 * KVM is a module, KVM must ensure *no* code owned by the KVM
> > +		 * (the module) can be run after the last call to module_put(),
> > +		 * i.e. after the last reference to the last vCPU's file is put.
> > +		 */

Doh, this is a duplicate comment, I'll delete it.
 
> > +		kvm_flush_and_free_async_pf_work(work);
> > +		spin_lock(&vcpu->async_pf.lock);
> >  	}
> >  	spin_unlock(&vcpu->async_pf.lock);
> >  
> > @@ -151,7 +179,7 @@ void kvm_check_async_pf_completion(struct kvm_vcpu *vcpu)
> >  
> >  		list_del(&work->queue);
> >  		vcpu->async_pf.queued--;
> > -		kmem_cache_free(async_pf_cache, work);
> > +		kvm_flush_and_free_async_pf_work(work);
> >  	}
> >  }
> >  
> > @@ -186,7 +214,6 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >  	work->arch = *arch;
> >  	work->mm = current->mm;
> >  	mmget(work->mm);
> > -	kvm_get_kvm(work->vcpu->kvm);
> >  
> >  	INIT_WORK(&work->work, async_pf_execute);
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
> 

