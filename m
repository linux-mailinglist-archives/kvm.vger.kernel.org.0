Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9BA1D0B6D
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 11:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732392AbgEMJD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 05:03:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47563 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730617AbgEMJD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 05:03:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589360636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2H7WTlkx93S1M3vHX7Cpl36mA7bQH8EpHtVWoXoomnY=;
        b=BSJkQ7FyIMtowPijSu4J9EG0rCMC9WYRp/D95faHwR6O7xRj4/+4s2BubbCViiQQTQn6Ly
        tSiZwIttvBh1+ls9iEiHX/bUMUAI7wbrEc/9te0LqRmkxcJ0SzgssxtiM4yUiwlDLvgYEd
        znFAKe8KJahbNe16Smj512pJ1AZqnds=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-7wmWivA2MX6ODTRDEJip5Q-1; Wed, 13 May 2020 05:03:53 -0400
X-MC-Unique: 7wmWivA2MX6ODTRDEJip5Q-1
Received: by mail-wr1-f69.google.com with SMTP id 30so8341792wrq.15
        for <kvm@vger.kernel.org>; Wed, 13 May 2020 02:03:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2H7WTlkx93S1M3vHX7Cpl36mA7bQH8EpHtVWoXoomnY=;
        b=kmgj8US7iUiNt9xejg5tuAFy65nttBN3flfzCxILeKOmXMtPSCN0ReyuNaBYgazr7h
         frdpSRyUZC9Fw1nyv2cD60L8dCN+dh3FjRXYeyALQ7LDnCTLWFL2m6FxEw3Ym+nBlpsN
         1iGYb454PpP6TwyqXVrvjn005pprgmVVvo+KYkw6PKmKsAKISohrK9RVDwT/yLuqWWQB
         UM1hsL07pdg7vYBnMRBg5mqvJNKtJb87S32JkMmajW9y0yx9IbrzJ1obOK7R8OhMnKCN
         Pqf2KT3nnRJvC8m4dBa4SwTTtybqIpk0svrLOxufVWpplxi3BJPCCjfQatu/Iy9k+xvw
         pWLw==
X-Gm-Message-State: AGi0PuYPyjS4iByR3rfPzKFt71DMeoCvoswVI6/pHUdqw5+HS/YVEu3c
        p7wP4/P3tj6OheTieWpMHC9TxTh6CqpjsWE/Xf2elRdP/SfYC8MVnqxeX8W7opj0iZ3WCfelKWY
        mlGToIeGFh71T
X-Received: by 2002:a7b:c253:: with SMTP id b19mr21502948wmj.110.1589360632278;
        Wed, 13 May 2020 02:03:52 -0700 (PDT)
X-Google-Smtp-Source: APiQypK9eAP8N2DheEgz7iF2kF+kLwS0RnxeO8TnBCVfkzTsjDHkVXtFjuqkdphNM0gkNbd4ZgS3DQ==
X-Received: by 2002:a7b:c253:: with SMTP id b19mr21502904wmj.110.1589360631936;
        Wed, 13 May 2020 02:03:51 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k131sm2544603wma.2.2020.05.13.02.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 02:03:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
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
Subject: Re: [PATCH 4/8] KVM: x86: interrupt based APF page-ready event delivery
In-Reply-To: <20200512180704.GE138129@redhat.com>
References: <20200511164752.2158645-1-vkuznets@redhat.com> <20200511164752.2158645-5-vkuznets@redhat.com> <20200512142411.GA138129@redhat.com> <87lflxm9sy.fsf@vitty.brq.redhat.com> <20200512180704.GE138129@redhat.com>
Date:   Wed, 13 May 2020 11:03:48 +0200
Message-ID: <877dxgmcjv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, May 12, 2020 at 05:50:53PM +0200, Vitaly Kuznetsov wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>> 
>> >
>> > So if we are using a common structure "kvm_vcpu_pv_apf_data" to deliver
>> > type1 and type2 events, to me it makes sense to retain existing
>> > KVM_PV_REASON_PAGE_READY and KVM_PV_REASON_PAGE_NOT_PRESENT. Just that
>> > in new scheme of things, KVM_PV_REASON_PAGE_NOT_PRESENT will be delivered
>> > using #PF (and later possibly using #VE) and KVM_PV_REASON_PAGE_READY
>> > will be delivered using interrupt.
>> 
>> We use different fields for page-not-present and page-ready events so
>> there is no intersection. If we start setting KVM_PV_REASON_PAGE_READY
>> to 'reason' we may accidentally destroy a 'page-not-present' event.
>
> This is confusing. So you mean at one point of time we might be using
> same shared data structure for two events.
>
> - ->reason will be set to 1 and you will inject page_not_present
>   execption.
>
> - If some page gets ready, you will now set ->token and queue 
>   page ready exception. 
>
> Its very confusing. Can't we serialize the delivery of these events. So
> that only one is in progress so that this structure is used by one event
> at a time.

This is not how the mechanism (currently) works:
- A process accesses a page which is swapped out

- We deliver synchronious APF (#PF) to the guest, it freezes the process
and switches to another one.

- Another process accesses a swapped out page, APF is delivered and it
also got frozen

...

- At some point one of the previously unavailable pages become available
(not necessarily the last or the first one) and we deliver this info via
asynchronous APF (now interrupt).

- Note, after we deliver the interrupt and before it is actually
consumed we may have another synchronous APF (#PF) event.

So we really need to separate memory locations for synchronous (type-1,
#PF,...) and asynchronous (type-2, interrupt, ...) data.

The naming is unfortunate and misleading, I agree. What is currently
named 'reason' should be something like 'apf_flag_for_pf' and it just
means to distinguish real #PF from APF. This is going away in the
future, we won't be abusing #PF anymore so I'd keep it as it is now,
maybe add another comment somewhere. The other location is
'pageready_token' and it actually contains the token. This is to stay
long term so any suggestions for better naming are welcome.

We could've separated these two memory locations completely and
e.g. used the remaining 56 bits of MSR_KVM_ASYNC_PF_INT as the new
location information. Maybe we should do that just to avoid the
confusion.

>
> Also how do I extend it now to do error delivery. Please keep that in
> mind. We don't want to be redesigning this stuff again. Its already
> very complicated.
>
> I really need ->reason field to be usable in both the paths so that
> error can be delivered.

If we want to use 'reason' for both we'll get into a weird scenario when
exception is blocking interrupt and, what's more confusing, vice
versa. I'd like to avoid this complexity in KVM code. My suggestion
would be to rename 'reason' to something like 'pf_abuse_flag' so it
doesn't cause the confusion and add new 'reason' after 'token'.

>
> And this notion of same structure being shared across multiple events
> at the same time is just going to create more confusion, IMHO. If we
> can decouple it by serializing it, that definitely feels simpler to
> understand.

What if we just add sub-structures to the structure, e.g. 

struct kvm_vcpu_pv_apf_data {
        struct {
            __u32 apf_flag;
        } legacy_apf_data;
        struct {
            __u32 token;
        } apf_interrupt_data;
        ....
        __u8 pad[56];                                                                                  |
        __u32 enabled;                                                                                 |
};    

would it make it more obvious?

>
>> 
>> With this patchset we have two completely separate channels:
>> 1) Page-not-present goes through #PF and 'reason' in struct
>> kvm_vcpu_pv_apf_data.
>> 2) Page-ready goes through interrupt and 'pageready_token' in the same
>> kvm_vcpu_pv_apf_data.
>> 
>> >
>> >> +
>> >> +	Note, previously, type 2 (page present) events were delivered via the
>> >> +	same #PF exception as type 1 (page not present) events but this is
>> >> +	now deprecated.
>> >
>> >> If bit 3 (interrupt based delivery) is not set APF events are not delivered.
>> >
>> > So all the old guests which were getting async pf will suddenly find
>> > that async pf does not work anymore (after hypervisor update). And
>> > some of them might report it as performance issue (if there were any
>> > performance benefits to be had with async pf).
>> 
>> We still do APF_HALT but generally yes, there might be some performance
>> implications. My RFC was preserving #PF path but the suggestion was to
>> retire it completely. (and I kinda like it because it makes a lot of
>> code go away)
>
> Ok. I don't have strong opinion here. If paolo likes it this way, so be
> it. :-)

APF is a slowpath for overcommited scenarios and when we switch to
APF_HALT we allow the host to run some other guest while PF is
processed. This is not the same from guest's perspective but from host's
we're fine as we're not wasting cycles.

>
>> 
>> >
>> > [..]
>> >>  
>> >>  bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
>> >>  {
>> >> -	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
>> >> +	if (!kvm_pv_async_pf_enabled(vcpu))
>> >>  		return true;
>> >
>> > What does above mean. If async pf is not enabled, then it returns true,
>> > implying one can inject async page present. But if async pf is not
>> > enabled, there is no need to inject these events.
>> 
>> AFAIU this is a protection agains guest suddenly disabling APF
>> mechanism.
>
> Can we provide that protection in MSR implementation. That is once APF
> is enabled, it can't be disabled. Or it is a feature that we allow
> guest to disable APF and want it that way?

We need to allow to disable the feature. E.g. think about kdump
scenario, for example. Before we switch to kdump kernel we need to make
sure there's no more 'magic' memory which can suggenly change. Also,
kdump kernel may not even support APF so it will get very confused when
APF events get delivered.

>
>> What do we do with all the 'page ready' events after, we
>> can't deliver them anymore. So we just eat them (hoping guest will
>> unfreeze all processes on its own before disabling the mechanism).
>> 
>> It is the existing logic, my patch doesn't change it.
>
> I see its existing logic. Just it is very confusing and will be good
> if we can atleast explain it with some comments.
>
> I don't know what to make out of this.
>
> bool kvm_arch_can_inject_async_page_present(struct kvm_vcpu *vcpu)
> {
>         if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED))
>                 return true;
>         else
>                 return kvm_can_do_async_pf(vcpu);
> }
>
> If feature is disabled, then do inject async pf page present. If feature
> is enabled and check whether we can inject async pf right now or not.
>
> It probably will help if this check if feature being enabled/disabled
> is outside kvm_arch_can_inject_async_page_present() at the callsite
> of kvm_arch_can_inject_async_page_present() and there we explain that
> why it is important to inject page ready events despite the fact
> that feature is disabled.

This code would definitely love some comments added, will do in the next
version. And I'll also think how to improve the readability, thanks for
the feedback!

-- 
Vitaly

