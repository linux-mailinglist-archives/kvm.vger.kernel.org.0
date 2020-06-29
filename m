Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5781D20E181
	for <lists+kvm@lfdr.de>; Mon, 29 Jun 2020 23:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389818AbgF2U4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jun 2020 16:56:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45356 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732615AbgF2U4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jun 2020 16:56:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593464191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aRQrdsYtdz9TEMhxqjBAh1xPQQzLPEecZg/rMh8RDx4=;
        b=C89z/gBJGYnhfYPm0ySKLbFlw4wavnO7XwW5AS+ur5NbiMV5682ILXz4FjpvsvZ1T9bze/
        3vCGBXNEDr92iykStU9TvCZj4k0peF4OOwc0Kk/OCsZcPHh9/Mlx8a2TfamFdnX81y/Q1R
        BaWqZsj+lj8KSUgPP7Ssyxvz5EO0TfY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-qvSXpq2gNZ6T_oj5Fi6gVg-1; Mon, 29 Jun 2020 16:56:29 -0400
X-MC-Unique: qvSXpq2gNZ6T_oj5Fi6gVg-1
Received: by mail-ed1-f72.google.com with SMTP id dg19so15387551edb.6
        for <kvm@vger.kernel.org>; Mon, 29 Jun 2020 13:56:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=aRQrdsYtdz9TEMhxqjBAh1xPQQzLPEecZg/rMh8RDx4=;
        b=Tla/c7KmMtYsfcMBqFY8tDmvwppIi5c9MdS0WB3c85QMQ9vANTH88G30UfcTShgYT7
         5m8CDEgJ7o+tfqOFieg3JfPpjVnD3qaMyBV2+bmsCl+iqfRG680S23bIGd6i1daJfiYG
         fbBPX5vYgWpcVp8amcrvm2e0SxwZ0LzOs5mEAldnnvYngjmrNHD/7aBKAX2ZWd0pYiun
         UQQYtc6IXU+ENrd2TBoWBRUXmJKxxml/Ca0q88+J1j/3UT0HdmolBBDMSBuIOMF4fxey
         P4tUPmgoUIfTTxAIjTGFmR8C6Aa3qFpsCTOmzcYwWL3/8X9fukUlgrj13neVeov9ucuH
         pzYg==
X-Gm-Message-State: AOAM531Gv9eMlkoMGMoZOFjokYOD5mW5sODaMJl0SRAID2oIHv0I8Ush
        2WaxbSPVwnWT2OCn8rA1aTJcqUW5cHTBtlk3xr4EdRwjf+JRbpplIGWeRfPLpgoeokRmMsu9dmA
        UaLehmCbVPfwJ
X-Received: by 2002:a17:906:84ef:: with SMTP id zp15mr10621019ejb.3.1593464187937;
        Mon, 29 Jun 2020 13:56:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHdIZLY3hhNXt/4xdioAbRVeieXYk6DH7NPYX8LiJS5d6DyXmdnCg4gn1Oy4NQ/J3h17oTlg==
X-Received: by 2002:a17:906:84ef:: with SMTP id zp15mr10620996ejb.3.1593464187650;
        Mon, 29 Jun 2020 13:56:27 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x11sm478312ejv.81.2020.06.29.13.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 13:56:26 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, virtio-fs@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] kvm,x86: Exit to user space in case of page fault error
In-Reply-To: <20200626150303.GC195150@redhat.com>
References: <20200625214701.GA180786@redhat.com> <87lfkach6o.fsf@vitty.brq.redhat.com> <20200626150303.GC195150@redhat.com>
Date:   Mon, 29 Jun 2020 22:56:25 +0200
Message-ID: <874kqtd212.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Fri, Jun 26, 2020 at 11:25:19AM +0200, Vitaly Kuznetsov wrote:
>
> [..]
>> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> > index 76817d13c86e..a882a6a9f7a7 100644
>> > --- a/arch/x86/kvm/mmu/mmu.c
>> > +++ b/arch/x86/kvm/mmu/mmu.c
>> > @@ -4078,7 +4078,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>> >  	if (!async)
>> >  		return false; /* *pfn has correct page already */
>> >  
>> > -	if (!prefault && kvm_can_do_async_pf(vcpu)) {
>> > +	if (!prefault && kvm_can_do_async_pf(vcpu, cr2_or_gpa >> PAGE_SHIFT)) {
>> 
>> gpa_to_gfn(cr2_or_gpa) ?
>
> Will do.
>
> [..]
>> > -bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>> > +bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu, gfn_t gfn)
>> >  {
>> >  	if (unlikely(!lapic_in_kernel(vcpu) ||
>> >  		     kvm_event_needs_reinjection(vcpu) ||
>> > @@ -10504,7 +10506,13 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>> >  	 * If interrupts are off we cannot even use an artificial
>> >  	 * halt state.
>> >  	 */
>> > -	return kvm_arch_interrupt_allowed(vcpu);
>> > +	if (!kvm_arch_interrupt_allowed(vcpu))
>> > +		return false;
>> > +
>> > +	if (vcpu->arch.apf.error_gfn == gfn)
>> > +		return false;
>> > +
>> > +	return true;
>> >  }
>> >  
>> >  bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>> 
>> I'm a little bit afraid that a single error_gfn may not give us
>> deterministric behavior. E.g. when we have a lot of faulting processes
>> it may take many iterations to hit 'error_gfn == gfn' because we'll
>> always be overwriting 'error_gfn' with new values and waking up some
>> (random) process.
>> 
>> What if we just temporary disable the whole APF mechanism? That would
>> ensure we're making forward progress. Something like (completely
>> untested):
>> 
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index f8998e97457f..945b3d5a2796 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -778,6 +778,7 @@ struct kvm_vcpu_arch {
>>  		unsigned long nested_apf_token;
>>  		bool delivery_as_pf_vmexit;
>>  		bool pageready_pending;
>> +		bool error_pending;
>>  	} apf;
>>  
>>  	/* OSVW MSRs (AMD only) */
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index fdd05c233308..e5f04ae97e91 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -4124,8 +4124,18 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
>>  	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
>>  		return RET_PF_RETRY;
>>  
>> -	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r))
>> +	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, pfn, ACC_ALL, &r)) {
>> +		/*
>> +		 * In case APF mechanism was previously disabled due to an error
>> +		 * we are ready to re-enable it here as we're about to inject an
>> +		 * error to userspace. There is no guarantee we are handling the
>> +		 * same GFN which failed in APF here but at least we are making
>> +		 * forward progress.
>> +		 */
>> +
>> +		vcpu->arch.apf.error_pending = false;
>
> I like this idea. It is simple. But I have a concern with it though.
>
> - Can it happen that we never retry faulting in error pfn.  Say a process
>   accessed a pfn, we set error_pending, and then process got killed due
>   to pending signal. Now process will not retry error pfn. And
>   error_pending will remain set and we completely disabled APF
>   mechanism till next error happens (if it happens).

Can a process in kvm_async_pf_task_wait_schedule() get killed? I don't
see us checking signals/... in the loop, just 'if
(hlist_unhashed(&n.link))' -- and this only happens when APF task
completes. I don't know much about processes to be honest, could easily
be wrong completely :-)

>
> In another idea, we could think of maintaining another hash of error
> gfns. Similar to "vcpu->arch.apf.gfns[]". Say "vgpu->arch.apf.error_gfns[]"
>
> - When error happens on a gfn, add it to hash. If slot is busy, overwrite
>   it.
>
> - When kvm_can_do_async_pf(gfn) is called, check if this gfn is present
>   in error_gfn, if yes, clear it and force sync fault.
>
> This is more complicated but should take care of your concerns. Also 
> even if process never retries that gfn, we are fine. At max that
> gfn will remain error_gfn array but will not disable APF completely.

Yes, we can do that but I'm not sure it wouldn't be an overkill: we are
not trying to protect the mechanism against a malicious guest. Using APF
is guest's choice anyway so even if there's going to be an easy way to
disable it completely (poke an address and never retry upon wakeup) from
guest's side it doesn't sound like a big deal.

Also, we can introduce a status bit in the APF 'page ready' notification
stating that the page is actually NOT ready and the mecanism was blocked
because if that, the guest will have to access the GFN to get the error
injected (and unblock the mechanism).

-- 
Vitaly

