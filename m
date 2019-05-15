Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC0A1FA36
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 20:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfEOSsf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 14:48:35 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35116 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfEOSsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 14:48:35 -0400
Received: by mail-wr1-f68.google.com with SMTP id m3so457478wrv.2
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 11:48:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=De9JgMDQ06C9LaVnjG7+zOeHQpYKMqwwpbwqcPz8V5U=;
        b=BQWI996fVw7OTB8DdCwvT9SjVH0lI2fCp4H4sAay7cJdGHZtqY5y2qYWJ9EFnC3XKN
         blPS7wANmq+zIOqlC7wLV/IA/YJ23oqoDP/bKUoaiQB27a8BNbYsYVjsicw58ABEKSl6
         kKGgx//zq5Pa5SX25yPZW58jjpxpRwIgs9OSBVMq0SwzUIfGkPlk+/7yH9t2M1JT0uyW
         64sZiJhFrLiyd3H4fbNU/BqOVmdCnAl0mq9emWTnp7OhM8kQLuXADyVJAGeFV8ONmZ11
         XckQGhitGsQ5Ml6E0yZ5b3W52EzSaH6SY0zwZ9Gbd1L/lY8+4w0EMYx1CycE4FIN8cGH
         jLsQ==
X-Gm-Message-State: APjAAAUXFcFwOBhMFshAjqEeppLNcaWQEsMtKcPWl6yKiq9QBZjZdNwq
        cNwXy7O86SuwrQPrQCrCtU9Vna4nGaY=
X-Google-Smtp-Source: APXvYqyCrswnIJuD6YiAXmuOSBdYdrYb44qjo/xkUBflvHhr3+nXv9Tx2+m82xzrh7RVGbBIJlLYdg==
X-Received: by 2002:a5d:4109:: with SMTP id l9mr6245786wrp.204.1557946113135;
        Wed, 15 May 2019 11:48:33 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-62-245-115-84.net.upcbroadband.cz. [62.245.115.84])
        by smtp.gmail.com with ESMTPSA id v137sm3232500wmf.28.2019.05.15.11.48.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 May 2019 11:48:32 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        Jim Mattson <jmattson@google.com>,
        Marc Orr <marcorr@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: nVMX: KVM_SET_NESTED_STATE - Tear down old EVMCS state before setting new state
In-Reply-To: <CAAAPnDHPCztgDCCKkaux=2=Fr-YrVhARR_8qrdYo-+AT3CQ+LQ@mail.gmail.com>
References: <20190502183133.258026-1-aaronlewis@google.com> <87zho37s2h.fsf@vitty.brq.redhat.com> <CAAAPnDHJ=ZC+CoKYkYkRsv+WJJjHJ66iN6jU72spL3+LckUpvA@mail.gmail.com> <878svgsovg.fsf@vitty.brq.redhat.com> <CAAAPnDFsixYb2R-0uN-_DCEb4U-MEo0Pd1hmFzpqqAojc9GxXA@mail.gmail.com> <CAAAPnDHPCztgDCCKkaux=2=Fr-YrVhARR_8qrdYo-+AT3CQ+LQ@mail.gmail.com>
Date:   Wed, 15 May 2019 14:48:31 -0400
Message-ID: <87bm03mu4g.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Aaron Lewis <aaronlewis@google.com> writes:

> On Wed, May 8, 2019 at 2:18 PM Aaron Lewis <aaronlewis@google.com> wrote:
>>
>> From: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Date: Wed, May 8, 2019 at 12:55 PM
>> To: Aaron Lewis
>> Cc: Peter Shier, Paolo Bonzini, <rkrcmar@redhat.com>, Jim Mattson,
>> Marc Orr, <kvm@vger.kernel.org>
>>
>> > Aaron Lewis <aaronlewis@google.com> writes:
>> >
>> > > From: Vitaly Kuznetsov <vkuznets@redhat.com>
>> > > Date: Fri, May 3, 2019 at 3:25 AM
>> > > To: Aaron Lewis
>> > > Cc: Peter Shier, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
>> > > <jmattson@google.com>, <marcorr@google.com>, <kvm@vger.kernel.org>
>> > >
>> > >> Aaron Lewis <aaronlewis@google.com> writes:
>> > >>
>> > >> > Move call to nested_enable_evmcs until after free_nested() is complete.
>> > >> >
>> > >> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>> > >> > Reviewed-by: Marc Orr <marcorr@google.com>
>> > >> > Reviewed-by: Peter Shier <pshier@google.com>
>> > >> > ---
>> > >> >  arch/x86/kvm/vmx/nested.c | 6 +++---
>> > >> >  1 file changed, 3 insertions(+), 3 deletions(-)
>> > >> >
>> > >> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> > >> > index 081dea6e211a..3b39c60951ac 100644
>> > >> > --- a/arch/x86/kvm/vmx/nested.c
>> > >> > +++ b/arch/x86/kvm/vmx/nested.c
>> > >> > @@ -5373,9 +5373,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>> > >> >       if (kvm_state->format != 0)
>> > >> >               return -EINVAL;
>> > >> >
>> > >> > -     if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
>> > >> > -             nested_enable_evmcs(vcpu, NULL);
>> > >> > -
>> > >> >       if (!nested_vmx_allowed(vcpu))
>> > >> >               return kvm_state->vmx.vmxon_pa == -1ull ? 0 : -EINVAL;
>> > >> >
>> > >> > @@ -5417,6 +5414,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>> > >> >       if (kvm_state->vmx.vmxon_pa == -1ull)
>> > >> >               return 0;
>> > >> >
>> > >> > +     if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
>> > >> > +             nested_enable_evmcs(vcpu, NULL);
>> > >> > +
>> > >> >       vmx->nested.vmxon_ptr = kvm_state->vmx.vmxon_pa;
>> > >> >       ret = enter_vmx_operation(vcpu);
>> > >> >       if (ret)
>> > >>
>> > >> nested_enable_evmcs() doesn't do much, actually, in case it was
>> > >> previously enabled it doesn't do anything and in case it wasn't ordering
>> > >> with free_nested() (where you're aiming at nested_release_evmcs() I
>> > >> would guess) shouldn't matter. So could you please elaborate (better in
>> > >> the commit message) why do we need this re-ordered? My guess is that
>> > >> you'd like to perform checks for e.g. 'vmx.vmxon_pa == -1ull' before
>> > >> we actually start doing any changes but let's clarify that.
>> > >>
>> > >> Thanks!
>> > >>
>> > >> --
>> > >> Vitaly
>> > >
>> > > There are two reasons for doing this:
>> > > 1. We don't want to set new state if we are going to leave nesting and
>> > > exit the function (ie: vmx.vmxon_pa = -1), like you pointed out.
>> > > 2. To be more future proof, we don't want to set new state before
>> > > tearing down state.  This could cause conflicts down the road.
>> > >
>> > > I can add this to the commit message if there are no objections to
>> > > these points.
>> >
>> > Sounds good to me, please do. Thanks!
>> >
>> > --
>> > Vitaly
>>
>> Here is the updated patch:
>>
>>
>> Move call to nested_enable_evmcs until after free_nested() is
>> complete.  There are two reasons for doing this:
>> 1. We don't want to set new state if we are going to leave nesting and
>> exit the function (ie: vmx.vmxon_pa = -1).
>> 2. To be more future proof, we don't want to set new state before
>> tearing down state.  This could cause conflicts down the road.
>>
>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>> Reviewed-by: Marc Orr <marcorr@google.com>
>> Reviewed-by: Peter Shier <pshier@google.com>
>> ---
>>  arch/x86/kvm/vmx/nested.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index fe5814df5149..6ecc301df874 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -5373,9 +5373,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>>   if (kvm_state->format != 0)
>>   return -EINVAL;
>>
>> - if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
>> - nested_enable_evmcs(vcpu, NULL);
>> -
>>   if (!nested_vmx_allowed(vcpu))
>>   return kvm_state->vmx.vmxon_pa == -1ull ? 0 : -EINVAL;
>>
>> @@ -5417,6 +5414,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>>   if (kvm_state->vmx.vmxon_pa == -1ull)
>>   return 0;
>>
>> + if (kvm_state->flags & KVM_STATE_NESTED_EVMCS)
>> + nested_enable_evmcs(vcpu, NULL);
>> +
>>   vmx->nested.vmxon_ptr = kvm_state->vmx.vmxon_pa;
>>   ret = enter_vmx_operation(vcpu);
>>   if (ret)
>
> Hi Vitaly,
>
> Does this update look good or are any other changes needed?
>

Hi Aaron,

my apologies for not replying earlier. The changelog looks good to me
now, thanks!

-- 
Vitaly
