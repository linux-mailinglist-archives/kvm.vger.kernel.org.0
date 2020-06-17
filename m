Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEBB1FD5A9
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 21:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgFQT7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 15:59:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60146 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726496AbgFQT7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 15:59:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592423949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WRHrkKRbe5k2p3dAble6VV20kKgVJLN2B6hsKhETBAc=;
        b=G8aDsPNK4VHTgr+bqpr5ax04rZtkToY+Rhff51iZcytfWEaYVn3RjgW/LKyYKw+sdKOgFL
        y4N8/Wy3FU/mFqpnVKrS09PMvRqw87wmk2nd+DYdPoRqKhNAOdjqkQTZQkytPZiVgod1LN
        42zE/P44js/Hyt1zy7hPD/zRRlcGPWo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-KyCYzru3NoyzKqzc3jQWBA-1; Wed, 17 Jun 2020 15:59:03 -0400
X-MC-Unique: KyCYzru3NoyzKqzc3jQWBA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 455D2835B4F;
        Wed, 17 Jun 2020 19:59:01 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-47.rdu2.redhat.com [10.10.115.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DD0A10013D6;
        Wed, 17 Jun 2020 19:58:55 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 7A46922363A; Wed, 17 Jun 2020 15:58:54 -0400 (EDT)
Date:   Wed, 17 Jun 2020 15:58:54 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     virtio-fs@redhat.com, miklos@szeredi.hu, stefanha@redhat.com,
        dgilbert@redhat.com, pbonzini@redhat.com, wanpengli@tencent.com,
        sean.j.christopherson@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] kvm,x86: Force sync fault if previous attempts failed
Message-ID: <20200617195854.GD26770@redhat.com>
References: <20200616214847.24482-1-vgoyal@redhat.com>
 <20200616214847.24482-2-vgoyal@redhat.com>
 <87o8phhmlp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8phhmlp.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 03:02:10PM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > Page fault error handling behavior in kvm seems little inconsistent when
> > page fault reports error. If we are doing fault synchronously
> > then we capture error (-EFAULT) returned by __gfn_to_pfn_memslot() and
> > exit to user space and qemu reports error, "error: kvm run failed Bad address".
> >
> > But if we are doing async page fault, then async_pf_execute() will simply
> > ignore the error reported by get_user_pages_remote(). It is assumed that
> > page fault was successful and either a page ready event is injected in
> > guest or guest is brought out of artificial halt state and run again.
> > In both the cases when guest retries the instruction, it takes exit
> > again as page fault was not successful in previous attempt. And then
> > this infinite loop continues forever.
> >
> 
> Indeed, we always assume get_user_pages_remote() will fetch the page we
> need. 
> 
> > This patch tries to make this behavior consistent. That is instead of
> > getting into infinite loop of retrying page fault, exit to user space
> > and stop VM if page fault error happens. This can be improved by
> > injecting errors in guest when it is allowed. Later patches can
> > inject error when a process in guest triggered page fault and
> > in that case guest process will receive SIGBUS. Currently we don't
> > have a way to inject errors when guest is in kernel mode. Once we
> > have race free method to do so, we should be able to inject errors
> > and guest can do fixup_exception() if caller set it up so (virtio-fs).
> >
> > When async pf encounters error then save that pfn and when next time
> > guest retries, do a sync fault instead of async fault. So that if error
> > is encountered, we exit to qemu and avoid infinite loop.
> >
> > As of now only one error pfn is stored and that means it could be
> > overwritten before next a retry from guest happens. But this is
> > just a hint and if we miss it, some other time we will catch it.
> > If this becomes an issue, we could maintain an array of error
> > gfn later to help ease the issue.
> 
> With a single GFN stored we can probably get in the same infinite loop
> you describe when several processes try to access different unavailable
> GFNs.

We could probably have an array and store bunch of error GFNs. But I
am not seeing much value in adding that complexity yet (until and
unless there are easy ways to reproduce). Following is my thought
process.

- error gfn is just a hint to force sync fault. Even if we miss it,
  guest will retry and at some point of time it will be forced to
  do sync fault.

- If page fault happened in guest user space, we will send error back
  and will not save or rely on error gfn.

- If page fault happened in guest kernel, then we have blocked
  async page fault and that means no scheduling (except if interrupt
  happened in between and that resulted in some scheduling).

I will test it with multiple processes doing I/O to same file and
then truncate this file and see if all qemu exits pretty soon or
not.

> Also, is the condition "GFN is unavailable" temporary or
> permanent?

I think it depends on usage. For the nvdimm use case, if file
backing that GFN gets truncated, then it is sort of permanent
failure. But for the case  of virtio-fs, it is possible to reuse
that GFN to map something else dynamically and once it maps
something else, then fault will be successful again.

> I guess it's the former but 'error_gfn' is set permanently
> (assuming no other GFN will overwrite it).

Other GFN can overwrite it. Nothing blocks that. So it is not
permanent.

Also if we have set error_gfn, on next retry qemu will fail. So,
leaving it behind should not be a problem. Even if failure was
temporary for some reason and upon next retry page fault is successful,
that's fine too. All we did was that did a sync fault instead of
async one.

I could look into clearing error_gfn on successful fault. I think
there are bunch of success path, that's why I was avoiding going
in that direction.

> 
> What if we do the following instead: add one more field to APF data
> indicating an error. The guest will kill the corresponding process
> instead of resuming it then.

That's what second patch is doing. I added a field pageready_flag
and used bit 0 to indicate error. But that works only if fault
was triggered by user space otherwise we are not following
async pf protocol.

If fault was triggered by kernel, then error needs to injected
synchronously so that kernel can call fixup_exception(). That's
more complicated and a future TODO item. I think for now, I
think stopping VM probably is better option than looping infinitely.

This first patch I wanted to do to make error behavior uniform and
to agree that it makes sense. That is if page fault error happens,
then either we shoudl inject error back into guest(if it is allowed)
otherwise, exit to user space. Retrying infinitely is not a good
option.

> 
> Also, with KVM_ASYNC_PF_SEND_ALWAYS being deprecated and assuming we
> switch to #VE, under which curcumstances we'll be unable to handle page
> fault asyncronously? Apart from overflowing the async PF queue, are
> there any other scenarios when it still makes sense to keep the guest
> alive? 

I think we should be able to handle it in most of the cases and
inject error back into guest.

> 
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  1 +
> >  arch/x86/kvm/mmu.h              |  2 +-
> >  arch/x86/kvm/mmu/mmu.c          |  2 +-
> >  arch/x86/kvm/x86.c              | 19 +++++++++++++++++--
> >  include/linux/kvm_host.h        |  1 +
> >  virt/kvm/async_pf.c             |  8 ++++++--
> >  6 files changed, 27 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 938497a6ebd7..348a73106556 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -778,6 +778,7 @@ struct kvm_vcpu_arch {
> >  		unsigned long nested_apf_token;
> >  		bool delivery_as_pf_vmexit;
> >  		bool pageready_pending;
> > +		gfn_t error_gfn;
> >  	} apf;
> >  
> >  	/* OSVW MSRs (AMD only) */
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index 0ad06bfe2c2c..6fa085ff07a3 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -60,7 +60,7 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots);
> >  void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer);
> >  void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
> >  			     bool accessed_dirty, gpa_t new_eptp);
> > -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
> > +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn);
> >  int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
> >  				u64 fault_address, char *insn, int insn_len);
> >  
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 15984dfde427..e207900ab303 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4078,7 +4078,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
> >  	if (!async)
> >  		return false; /* *pfn has correct page already */
> >  
> > -	if (!prefault && kvm_can_do_async_pf(vcpu)) {
> > +	if (!prefault && kvm_can_do_async_pf(vcpu, cr2_or_gpa >> PAGE_SHIFT)) {
> >  		trace_kvm_try_async_get_page(cr2_or_gpa, gfn);
> >  		if (kvm_find_async_pf_gfn(vcpu, gfn)) {
> >  			trace_kvm_async_pf_doublefault(cr2_or_gpa, gfn);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 697d1b273a2f..4c5205434b9c 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10513,7 +10513,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
> >  	return true;
> >  }
> >  
> > -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
> > +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn)
> >  {
> >  	if (unlikely(!lapic_in_kernel(vcpu) ||
> >  		     kvm_event_needs_reinjection(vcpu) ||
> > @@ -10527,7 +10527,13 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
> >  	 * If interrupts are off we cannot even use an artificial
> >  	 * halt state.
> >  	 */
> > -	return kvm_arch_interrupt_allowed(vcpu);
> > +	if (!kvm_arch_interrupt_allowed(vcpu))
> > +		return false;
> > +
> > +	if (vcpu->arch.apf.error_gfn == gfn)
> > +		return false;
> > +
> > +	return true;
> >  }
> >  
> >  bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> > @@ -10583,6 +10589,15 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
> >  		kvm_apic_set_irq(vcpu, &irq, NULL);
> >  	}
> >  
> > +	if (work->error_code) {
> > +		/*
> > +		 * Page fault failed and we don't have a way to report
> > +		 * errors back to guest yet. So save this pfn and force
> > +		 * sync page fault next time.
> > +		 */
> > +		vcpu->arch.apf.error_gfn = work->cr2_or_gpa >> PAGE_SHIFT;
> > +	}
> > +
> >  	vcpu->arch.apf.halted = false;
> >  	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
> >  }
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 216cdb6581e2..b8558334b184 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -207,6 +207,7 @@ struct kvm_async_pf {
> >  	struct kvm_arch_async_pf arch;
> >  	bool   wakeup_all;
> >  	bool notpresent_injected;
> > +	int error_code;
> >  };
> >  
> >  void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu);
> > diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> > index a36828fbf40a..6b30374a4de1 100644
> > --- a/virt/kvm/async_pf.c
> > +++ b/virt/kvm/async_pf.c
> > @@ -52,6 +52,7 @@ static void async_pf_execute(struct work_struct *work)
> >  	gpa_t cr2_or_gpa = apf->cr2_or_gpa;
> >  	int locked = 1;
> >  	bool first;
> > +	long ret;
> >  
> >  	might_sleep();
> >  
> > @@ -61,11 +62,14 @@ static void async_pf_execute(struct work_struct *work)
> >  	 * access remotely.
> >  	 */
> >  	down_read(&mm->mmap_sem);
> > -	get_user_pages_remote(NULL, mm, addr, 1, FOLL_WRITE, NULL, NULL,
> > -			&locked);
> > +	ret = get_user_pages_remote(NULL, mm, addr, 1, FOLL_WRITE, NULL, NULL,
> > +				    &locked);
> >  	if (locked)
> >  		up_read(&mm->mmap_sem);
> >  
> > +	if (ret < 0)
> > +		apf->error_code = ret;
> > +
> >  	if (IS_ENABLED(CONFIG_KVM_ASYNC_PF_SYNC))
> >  		kvm_arch_async_page_present(vcpu, apf);
> 
> -- 
> Vitaly
> 

