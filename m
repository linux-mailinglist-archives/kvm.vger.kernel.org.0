Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166B31CFCD4
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 20:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730763AbgELSHN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 14:07:13 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30969 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726465AbgELSHM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 May 2020 14:07:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589306830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EiXzHCHsEp9QkdzpBux6/llPUJHd2DVaMn3hAkzR5d8=;
        b=hfGHLWHMfU5bHV8k9iOiG7J7ycetYEKt546rjlZ3d0CkcwD+/+FG7lBXYUAORuATA282Kw
        5Muj8t+sQn9KrzsztbvliKggDKwtuK6kRuAAm7uPGixEOqcMByoQ451HjFl6al95qCe75E
        fIMX1h1VS+TsyhZkriJz/WljVlDsHLo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-93Uyic9fO2Wz9SFRYWk_YQ-1; Tue, 12 May 2020 14:07:07 -0400
X-MC-Unique: 93Uyic9fO2Wz9SFRYWk_YQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6903872FE0;
        Tue, 12 May 2020 18:07:05 +0000 (UTC)
Received: from horse.redhat.com (ovpn-116-85.rdu2.redhat.com [10.10.116.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2475938E;
        Tue, 12 May 2020 18:07:05 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 9D350220C05; Tue, 12 May 2020 14:07:04 -0400 (EDT)
Date:   Tue, 12 May 2020 14:07:04 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] KVM: x86: interrupt based APF page-ready event
 delivery
Message-ID: <20200512180704.GE138129@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com>
 <20200511164752.2158645-5-vkuznets@redhat.com>
 <20200512142411.GA138129@redhat.com>
 <87lflxm9sy.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lflxm9sy.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 12, 2020 at 05:50:53PM +0200, Vitaly Kuznetsov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Mon, May 11, 2020 at 06:47:48PM +0200, Vitaly Kuznetsov wrote:
> >> Concerns were expressed around APF delivery via synthetic #PF exception as
> >> in some cases such delivery may collide with real page fault. For type 2
> >> (page ready) notifications we can easily switch to using an interrupt
> >> instead. Introduce new MSR_KVM_ASYNC_PF_INT mechanism and deprecate the
> >> legacy one.
> >> 
> >> One notable difference between the two mechanisms is that interrupt may not
> >> get handled immediately so whenever we would like to deliver next event
> >> (regardless of its type) we must be sure the guest had read and cleared
> >> previous event in the slot.
> >> 
> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> ---
> >>  Documentation/virt/kvm/msr.rst       | 91 +++++++++++++++++---------
> >>  arch/x86/include/asm/kvm_host.h      |  4 +-
> >>  arch/x86/include/uapi/asm/kvm_para.h |  6 ++
> >>  arch/x86/kvm/x86.c                   | 95 ++++++++++++++++++++--------
> >>  4 files changed, 140 insertions(+), 56 deletions(-)
> >> 
> >> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> >> index 33892036672d..f988a36f226a 100644
> >> --- a/Documentation/virt/kvm/msr.rst
> >> +++ b/Documentation/virt/kvm/msr.rst
> >> @@ -190,35 +190,54 @@ MSR_KVM_ASYNC_PF_EN:
> >>  	0x4b564d02
> >>  
> >>  data:
> >> -	Bits 63-6 hold 64-byte aligned physical address of a
> >> -	64 byte memory area which must be in guest RAM and must be
> >> -	zeroed. Bits 5-3 are reserved and should be zero. Bit 0 is 1
> >> -	when asynchronous page faults are enabled on the vcpu 0 when
> >> -	disabled. Bit 1 is 1 if asynchronous page faults can be injected
> >> -	when vcpu is in cpl == 0. Bit 2 is 1 if asynchronous page faults
> >> -	are delivered to L1 as #PF vmexits.  Bit 2 can be set only if
> >> -	KVM_FEATURE_ASYNC_PF_VMEXIT is present in CPUID.
> >> -
> >> -	First 4 byte of 64 byte memory location will be written to by
> >> -	the hypervisor at the time of asynchronous page fault (APF)
> >> -	injection to indicate type of asynchronous page fault. Value
> >> -	of 1 means that the page referred to by the page fault is not
> >> -	present. Value 2 means that the page is now available. Disabling
> >> -	interrupt inhibits APFs. Guest must not enable interrupt
> >> -	before the reason is read, or it may be overwritten by another
> >> -	APF. Since APF uses the same exception vector as regular page
> >> -	fault guest must reset the reason to 0 before it does
> >> -	something that can generate normal page fault.  If during page
> >> -	fault APF reason is 0 it means that this is regular page
> >> -	fault.
> >> -
> >> -	During delivery of type 1 APF cr2 contains a token that will
> >> -	be used to notify a guest when missing page becomes
> >> -	available. When page becomes available type 2 APF is sent with
> >> -	cr2 set to the token associated with the page. There is special
> >> -	kind of token 0xffffffff which tells vcpu that it should wake
> >> -	up all processes waiting for APFs and no individual type 2 APFs
> >> -	will be sent.
> >> +	Asynchronous page fault (APF) control MSR.
> >> +
> >> +	Bits 63-6 hold 64-byte aligned physical address of a 64 byte memory area
> >> +	which must be in guest RAM and must be zeroed. This memory is expected
> >> +	to hold a copy of the following structure::
> >> +
> >> +	  struct kvm_vcpu_pv_apf_data {
> >> +		__u32 reason;
> >> +		__u32 pageready_token;
> >> +		__u8 pad[56];
> >> +		__u32 enabled;
> >> +	  };
> >> +
> >> +	Bits 5-4 of the MSR are reserved and should be zero. Bit 0 is set to 1
> >> +	when asynchronous page faults are enabled on the vcpu, 0 when disabled.
> >> +	Bit 1 is 1 if asynchronous page faults can be injected when vcpu is in
> >> +	cpl == 0. Bit 2 is 1 if asynchronous page faults are delivered to L1 as
> >> +	#PF vmexits.  Bit 2 can be set only if KVM_FEATURE_ASYNC_PF_VMEXIT is
> >> +	present in CPUID. Bit 3 enables interrupt based delivery of type 2
> >> +	(page present) events.
> >
> > Hi Vitaly,
> >
> > "Bit 3 enables interrupt based delivery of type 2 events". So one has to
> > opt in to enable it. If this bit is 0, we will continue to deliver
> > page ready events using #PF? This probably will be needed to ensure
> > backward compatibility also.
> >
> 
> No, as Paolo suggested we don't enable the mechanism at all if bit3 is
> 0. Legacy (unaware) guests will think that they've enabled the mechanism
> but it won't work, they won't see any APF notifications.
> 
> >> +
> >> +	First 4 byte of 64 byte memory location ('reason') will be written to
> >> +	by the hypervisor at the time APF type 1 (page not present) injection.
> >> +	The only possible values are '0' and '1'.
> >
> > What do "reason" values "0" and "1" signify?
> >
> > Previously this value could be 1 for PAGE_NOT_PRESENT and 2 for
> > PAGE_READY. So looks like we took away reason "PAGE_READY" because it will
> > be delivered using interrupts.
> >
> > But that seems like an opt in. If that's the case, then we should still
> > retain PAGE_READY reason. If we are getting rid of page_ready using
> > #PF, then interrupt based deliver should not be optional. What am I
> > missing.
> 
> It is not optional now :-)
> 
> >
> > Also previous text had following line.
> >
> > "Guest must not enable interrupt before the reason is read, or it may be
> >  overwritten by another APF".
> >
> > So this is not a requirement anymore?
> >
> 
> It still stands for type 1 (page not present) events.
> 
> >> Type 1 events are currently
> >> +	always delivered as synthetic #PF exception. During delivery of type 1
> >> +	APF CR2 register contains a token that will be used to notify the guest
> >> +	when missing page becomes available. Guest is supposed to write '0' to
> >> +	the location when it is done handling type 1 event so the next one can
> >> +	be delivered.
> >> +
> >> +	Note, since APF type 1 uses the same exception vector as regular page
> >> +	fault, guest must reset the reason to '0' before it does something that
> >> +	can generate normal page fault. If during a page fault APF reason is '0'
> >> +	it means that this is regular page fault.
> >> +
> >> +	Bytes 5-7 of 64 byte memory location ('pageready_token') will be written
> >> +	to by the hypervisor at the time of type 2 (page ready) event injection.
> >> +	The content of these bytes is a token which was previously delivered as
> >> +	type 1 event. The event indicates the page in now available. Guest is
> >> +	supposed to write '0' to the location when it is done handling type 2
> >> +	event so the next one can be delivered. MSR_KVM_ASYNC_PF_INT MSR
> >> +	specifying the interrupt vector for type 2 APF delivery needs to be
> >> +	written to before enabling APF mechanism in MSR_KVM_ASYNC_PF_EN.
> >
> > What is supposed to be value of "reason" field for type2 events. I
> > had liked previous values "KVM_PV_REASON_PAGE_READY" and
> > "KVM_PV_REASON_PAGE_NOT_PRESENT". Name itself made it plenty clear, what
> > it means. Also it allowed for easy extension where this protocol could
> > be extended to deliver other "reasons", like error.
> >
> > So if we are using a common structure "kvm_vcpu_pv_apf_data" to deliver
> > type1 and type2 events, to me it makes sense to retain existing
> > KVM_PV_REASON_PAGE_READY and KVM_PV_REASON_PAGE_NOT_PRESENT. Just that
> > in new scheme of things, KVM_PV_REASON_PAGE_NOT_PRESENT will be delivered
> > using #PF (and later possibly using #VE) and KVM_PV_REASON_PAGE_READY
> > will be delivered using interrupt.
> 
> We use different fields for page-not-present and page-ready events so
> there is no intersection. If we start setting KVM_PV_REASON_PAGE_READY
> to 'reason' we may accidentally destroy a 'page-not-present' event.

This is confusing. So you mean at one point of time we might be using
same shared data structure for two events.

- ->reason will be set to 1 and you will inject page_not_present
  execption.

- If some page gets ready, you will now set ->token and queue 
  page ready exception. 

Its very confusing. Can't we serialize the delivery of these events. So
that only one is in progress so that this structure is used by one event
at a time.

Also how do I extend it now to do error delivery. Please keep that in
mind. We don't want to be redesigning this stuff again. Its already
very complicated.

I really need ->reason field to be usable in both the paths so that
error can be delivered.

And this notion of same structure being shared across multiple events
at the same time is just going to create more confusion, IMHO. If we
can decouple it by serializing it, that definitely feels simpler to
understand.

> 
> With this patchset we have two completely separate channels:
> 1) Page-not-present goes through #PF and 'reason' in struct
> kvm_vcpu_pv_apf_data.
> 2) Page-ready goes through interrupt and 'pageready_token' in the same
> kvm_vcpu_pv_apf_data.
> 
> >
> >> +
> >> +	Note, previously, type 2 (page present) events were delivered via the
> >> +	same #PF exception as type 1 (page not present) events but this is
> >> +	now deprecated.
> >
> >> If bit 3 (interrupt based delivery) is not set APF events are not delivered.
> >
> > So all the old guests which were getting async pf will suddenly find
> > that async pf does not work anymore (after hypervisor update). And
> > some of them might report it as performance issue (if there were any
> > performance benefits to be had with async pf).
> 
> We still do APF_HALT but generally yes, there might be some performance
> implications. My RFC was preserving #PF path but the suggestion was to
> retire it completely. (and I kinda like it because it makes a lot of
> code go away)

Ok. I don't have strong opinion here. If paolo likes it this way, so be
it. :-)

> 
> >
> > [..]
> >>  
> >>  bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
> >>  {
> >> -	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
> >> +	if (!kvm_pv_async_pf_enabled(vcpu))
> >>  		return true;
> >
> > What does above mean. If async pf is not enabled, then it returns true,
> > implying one can inject async page present. But if async pf is not
> > enabled, there is no need to inject these events.
> 
> AFAIU this is a protection agains guest suddenly disabling APF
> mechanism.

Can we provide that protection in MSR implementation. That is once APF
is enabled, it can't be disabled. Or it is a feature that we allow
guest to disable APF and want it that way?

> What do we do with all the 'page ready' events after, we
> can't deliver them anymore. So we just eat them (hoping guest will
> unfreeze all processes on its own before disabling the mechanism).
> 
> It is the existing logic, my patch doesn't change it.

I see its existing logic. Just it is very confusing and will be good
if we can atleast explain it with some comments.

I don't know what to make out of this.

bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
{
        if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
                return true;
        else
                return kvm_can_do_async_pf(vcpu);
}

If feature is disabled, then do inject async pf page present. If feature
is enabled and check whether we can inject async pf right now or not.

It probably will help if this check if feature being enabled/disabled
is outside kvm_arch_can_inject_async_page_present() at the callsite
of kvm_arch_can_inject_async_page_present() and there we explain that
why it is important to inject page ready events despite the fact
that feature is disabled.

Thanks
Vivek

