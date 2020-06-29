Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA49E20E82A
	for <lists+kvm@lfdr.de>; Tue, 30 Jun 2020 00:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391811AbgF2WEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 18:04:15 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22304 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391790AbgF2WED (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Jun 2020 18:04:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593468240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OroByE+ZA4eo1TKqSWrc9f6rGehIx74LiX2dBIjDA5w=;
        b=J0zzIaPZJoZgpH9tHznV42DtSf3j/b+YKQEYzosJGsbENh4CjRq5EOtCorGN068FxFLCcF
        d2njdj+DRidBKENPw96gpA57InqQlQ16l5X6XIyp9n6M7gCLQEPhQTJELVm/vuenFYMsen
        Er0h9QlWjpCX/rbn3+hFEPrGlbv3uPE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-v-ThWQ5WO2SX0pxOeOnuAw-1; Mon, 29 Jun 2020 18:03:58 -0400
X-MC-Unique: v-ThWQ5WO2SX0pxOeOnuAw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA85F80183C;
        Mon, 29 Jun 2020 22:03:57 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-176.rdu2.redhat.com [10.10.115.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4541C5D9C9;
        Mon, 29 Jun 2020 22:03:54 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id BAD12220C58; Mon, 29 Jun 2020 18:03:53 -0400 (EDT)
Date:   Mon, 29 Jun 2020 18:03:53 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, virtio-fs@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] kvm,x86: Exit to user space in case of page fault
 error
Message-ID: <20200629220353.GC269627@redhat.com>
References: <20200625214701.GA180786@redhat.com>
 <87lfkach6o.fsf@vitty.brq.redhat.com>
 <20200626150303.GC195150@redhat.com>
 <874kqtd212.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kqtd212.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 29, 2020 at 10:56:25PM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Fri, Jun 26, 2020 at 11:25:19AM +0200, Vitaly Kuznetsov wrote:
> >
> > [..]
> >> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >> > index 76817d13c86e..a882a6a9f7a7 100644
> >> > --- a/arch/x86/kvm/mmu/mmu.c
> >> > +++ b/arch/x86/kvm/mmu/mmu.c
> >> > @@ -4078,7 +4078,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
> >> >  	if (!async)
> >> >  		return false; /* *pfn has correct page already */
> >> >  
> >> > -	if (!prefault && kvm_can_do_async_pf(vcpu)) {
> >> > +	if (!prefault && kvm_can_do_async_pf(vcpu, cr2_or_gpa >> PAGE_SHIFT)) {
> >> 
> >> gpa_to_gfn(cr2_or_gpa) ?
> >
> > Will do.
> >
> > [..]
> >> > -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
> >> > +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn)
> >> >  {
> >> >  	if (unlikely(!lapic_in_kernel(vcpu) ||
> >> >  		     kvm_event_needs_reinjection(vcpu) ||
> >> > @@ -10504,7 +10506,13 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
> >> >  	 * If interrupts are off we cannot even use an artificial
> >> >  	 * halt state.
> >> >  	 */
> >> > -	return kvm_arch_interrupt_allowed(vcpu);
> >> > +	if (!kvm_arch_interrupt_allowed(vcpu))
> >> > +		return false;
> >> > +
> >> > +	if (vcpu->arch.apf.error_gfn == gfn)
> >> > +		return false;
> >> > +
> >> > +	return true;
> >> >  }
> >> >  
> >> >  bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> >> 
> >> I'm a little bit afraid that a single error_gfn may not give us
> >> deterministric behavior. E.g. when we have a lot of faulting processes
> >> it may take many iterations to hit 'error_gfn == gfn' because we'll
> >> always be overwriting 'error_gfn' with new values and waking up some
> >> (random) process.
> >> 
> >> What if we just temporary disable the whole APF mechanism? That would
> >> ensure we're making forward progress. Something like (completely
> >> untested):
> >> 
> >> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >> index f8998e97457f..945b3d5a2796 100644
> >> --- a/arch/x86/include/asm/kvm_host.h
> >> +++ b/arch/x86/include/asm/kvm_host.h
> >> @@ -778,6 +778,7 @@ struct kvm_vcpu_arch {
> >>  		unsigned long nested_apf_token;
> >>  		bool delivery_as_pf_vmexit;
> >>  		bool pageready_pending;
> >> +		bool error_pending;
> >>  	} apf;
> >>  
> >>  	/* OSVW MSRs (AMD only) */
> >> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >> index fdd05c233308..e5f04ae97e91 100644
> >> --- a/arch/x86/kvm/mmu/mmu.c
> >> +++ b/arch/x86/kvm/mmu/mmu.c
> >> @@ -4124,8 +4124,18 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> >>  	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
> >>  		return RET_PF_RETRY;
> >>  
> >> -	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
> >> +	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r)) {
> >> +		/*
> >> +		 * In case APF mechanism was previously disabled due to an error
> >> +		 * we are ready to re-enable it here as we're about to inject an
> >> +		 * error to userspace. There is no guarantee we are handling the
> >> +		 * same GFN which failed in APF here but at least we are making
> >> +		 * forward progress.
> >> +		 */
> >> +
> >> +		vcpu->arch.apf.error_pending = false;
> >
> > I like this idea. It is simple. But I have a concern with it though.
> >
> > - Can it happen that we never retry faulting in error pfn.  Say a process
> >   accessed a pfn, we set error_pending, and then process got killed due
> >   to pending signal. Now process will not retry error pfn. And
> >   error_pending will remain set and we completely disabled APF
> >   mechanism till next error happens (if it happens).
> 
> Can a process in kvm_async_pf_task_wait_schedule() get killed? I don't
> see us checking signals/... in the loop, just 'if
> (hlist_unhashed(&n.link))' -- and this only happens when APF task
> completes. I don't know much about processes to be honest, could easily
> be wrong completely :-)

I think a waiting process will be woken up and scheduled again. And
when it is starts running again and goes back to user space (faulting
instruction was in user space), then we should check for pending SIGNAL
and kill it.

That's how my patches for sending SIGBUS were working. I queued SIGBUS
and then when process got scheduled, it got SIGBUS and got killed and
stopped retrying instruction. (Otherwise this fault cycle will never
end).

Hence, I think it is possible. Another process can send SIGKILL to
this process which is waiting for APF. Once APF page ready event
comes in, process will be killed after that without retrying the
instruct. I will be glad to be corrected if I understood it wrong.

> 
> >
> > In another idea, we could think of maintaining another hash of error
> > gfns. Similar to "vcpu->arch.apf.gfns[]". Say "vgpu->arch.apf.error_gfns[]"
> >
> > - When error happens on a gfn, add it to hash. If slot is busy, overwrite
> >   it.
> >
> > - When kvm_can_do_async_pf(gfn) is called, check if this gfn is present
> >   in error_gfn, if yes, clear it and force sync fault.
> >
> > This is more complicated but should take care of your concerns. Also 
> > even if process never retries that gfn, we are fine. At max that
> > gfn will remain error_gfn array but will not disable APF completely.
> 
> Yes, we can do that but I'm not sure it wouldn't be an overkill: we are
> not trying to protect the mechanism against a malicious guest. Using APF
> is guest's choice anyway so even if there's going to be an easy way to
> disable it completely (poke an address and never retry upon wakeup) from
> guest's side it doesn't sound like a big deal.

Sure but if guest chose APF and then it got disabled completely
intentionally, then its a probelm, isn't it. This is just a race
condition which can disable APF unintentionally and leave it like
that till next error happens. 

> 
> Also, we can introduce a status bit in the APF 'page ready' notification
> stating that the page is actually NOT ready and the mecanism was blocked
> because if that, the guest will have to access the GFN to get the error
> injected (and unblock the mechanism).

I am not sure how will we force guest to access that pfn if accessing
process gets killed. This actually feels like least preferred of all
options.

Thanks
Vivek

