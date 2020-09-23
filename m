Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614F2275E8C
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 19:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgIWRZg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 13:25:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726419AbgIWRZg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 13:25:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600881934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q6tnByusYeU+TVxG5Re3j+mmtEuKFnOyGqlIj3o5A10=;
        b=JZ9JbVtDZRjJSeKGPDY6aMReoQEsV7R+nCfEhZ7WEqSJO71bQDjOJJDzqxfDrPItMwujRg
        FQwO5T9p5o9b0AF7Xqc30YSeaULeXdqqK+FnVFNVvYEQNQDpxUf1ZnjlQW9qWlzGnwJlDZ
        uh8OQbvzoo45XQxEcKWRffyfCuOCvOw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-kVbdEKKPPgKeA3cBzwO48A-1; Wed, 23 Sep 2020 13:25:32 -0400
X-MC-Unique: kVbdEKKPPgKeA3cBzwO48A-1
Received: by mail-wr1-f70.google.com with SMTP id b7so114471wrn.6
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 10:25:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q6tnByusYeU+TVxG5Re3j+mmtEuKFnOyGqlIj3o5A10=;
        b=YpZUMatDBeAHb1fxb5MDQwO+fhWi3uLq9YdNOVaj7EFaUf+vQXN7anoO0sqQd3cCk4
         CRWdCLDJ4Up718YrKbJvGTDyd1Y6aRSSCZOBvUKHSINImA3q8bCtMr53gVvrz82M7blW
         41iHOrVs3MtLDjbwg1NWkwcNdI1VTXWFKVdFNMw7cm2HB5K4gtH2PlMwN00QPek2EWmw
         yhjwSDSncq+Slf3DBG+4j9VXBSZJ3Fj3QkBfm0eDpLina28w2P7t/tWdaDTVs0tYR1nF
         rjnaFjtkLqCMzI5kdvofSEhWslckAofedlHyoFKnX27ZcxbyzwoMJpwXQaiK4JyBnQ1o
         cYfQ==
X-Gm-Message-State: AOAM533YGz/BjvaW3rBUFqU0BfChnFWZm9yRIgUDtq1xUpsGZI6a1z8w
        RGO22NxA73JCTST66dl6Mr3SlQRa6G3ytlZ5eZpMvIs7GIYb0RaJy9BD2CAo512aQUYEoE+ZgAY
        CtrfRc8TQJpt3
X-Received: by 2002:a1c:2e08:: with SMTP id u8mr659679wmu.156.1600881930818;
        Wed, 23 Sep 2020 10:25:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIIw+44nwPJJJ//1KslPu6gF+MH4SLCC4Xd9t8DFAYnRxG6RDZ+KUfqRMuH7NdGDhmkiJ4Rw==
X-Received: by 2002:a1c:2e08:: with SMTP id u8mr659651wmu.156.1600881930529;
        Wed, 23 Sep 2020 10:25:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id p1sm10824020wma.0.2020.09.23.10.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 10:25:29 -0700 (PDT)
Subject: Re: [PATCH 2/4] KVM: VMX: Unconditionally clear CPUID.INVPCID if
 !CPUID.PCID
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200923165048.20486-1-sean.j.christopherson@intel.com>
 <20200923165048.20486-3-sean.j.christopherson@intel.com>
 <CALMp9eTPG14Mwd_NcMf-f86U5GyfcOAVHk=ugydyJj0PybiRMA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <010a907b-d838-532d-7869-7342c3aca1c8@redhat.com>
Date:   Wed, 23 Sep 2020 19:25:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTPG14Mwd_NcMf-f86U5GyfcOAVHk=ugydyJj0PybiRMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 19:15, Jim Mattson wrote:
> On Wed, Sep 23, 2020 at 9:51 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
>>
>> If PCID is not exposed to the guest, clear INVPCID in the guest's CPUID
>> even if the VMCS INVPCID enable is not supported.  This will allow
>> consolidating the secondary execution control adjustment code without
>> having to special case INVPCID.
>>
>> Technically, this fixes a bug where !CPUID.PCID && CPUID.INVCPID would
>> result in unexpected guest behavior (#UD instead of #GP/#PF), but KVM
>> doesn't support exposing INVPCID if it's not supported in the VMCS, i.e.
>> such a config is broken/bogus no matter what.
>>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> ---
>>  arch/x86/kvm/vmx/vmx.c | 16 +++++++++++-----
>>  1 file changed, 11 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index cfed29329e4f..57e48c5a1e91 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -4149,16 +4149,22 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>>                 }
>>         }
>>
>> +       /*
>> +        * Expose INVPCID if and only if PCID is also exposed to the guest.
>> +        * INVPCID takes a #UD when it's disabled in the VMCS, but a #GP or #PF
>> +        * if CR4.PCIDE=0.  Enumerating CPUID.INVPCID=1 would lead to incorrect
>> +        * behavior from the guest perspective (it would expect #GP or #PF).
>> +        */
>> +       if (!guest_cpuid_has(vcpu, X86_FEATURE_PCID))
>> +               guest_cpuid_clear(vcpu, X86_FEATURE_INVPCID);
>> +
> 
> I thought the general rule for userspace provided CPUID bits was that
> kvm only made any adjustments necessary to prevent bad things from
> happening at the host level. Proper guest semantics are entirely the
> responsibility of userspace. Or did I misunderstand?
> 

Yes, that's generally the idea.  INVPCID has always been a bit special
due to the secondary execution control being of the "enable" kind; this
led the original author to try and disable the instruction (which is by
itself something we do not always do, and sometimes cannot always do).

So I agree that Sean's patch is of marginal utility by itself; however
it lets him use the new macros in patch 4 and it is a good idea to
separate the small functional change into its own commit.

Paolo

