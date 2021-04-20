Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC571365CB9
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 17:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhDTP54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 11:57:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43414 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232504AbhDTP54 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 11:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618934244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SvH4spO145jmMethyK98T8GRtAPXYe7MWQzYtlj/MQk=;
        b=ZA2Z4ahuu90AP6a6edg5JnBUY7YNW6BGVR1EJ5u/nZp5VTzUig3Y/0igUsT/ke7efF6JAr
        2IkEcsU6b+yiJi8+bLChmwUjH86ZB+A4fUqx6MLU4v06JC+Qly340xI4YC0u98I7RaBOq8
        F2AAF5gxCF5zbCLUHJLCcf76NGkwN9c=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-qhYxf7w9PPiWHWxhawKhJQ-1; Tue, 20 Apr 2021 11:57:22 -0400
X-MC-Unique: qhYxf7w9PPiWHWxhawKhJQ-1
Received: by mail-ed1-f72.google.com with SMTP id z3-20020a05640240c3b029037fb0c2bd3bso13473061edb.23
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 08:57:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SvH4spO145jmMethyK98T8GRtAPXYe7MWQzYtlj/MQk=;
        b=catbD9UOpXCgE1+LKlx4EWjmJEg6eNh4c467wPKEMinpV1EqKyi1gVxcLinc1r/MDm
         71KcM5DC9rdct414CesjTkdkK+qDk0pC+vqlolGdKlVCZ+7qlIzY2ryzvMjtNeeDqYfi
         MxcIbZ0XPWO9aa6Uu5Tkr2Km0lFnsRwj1QitfOipWp+ZE5vs+xtb0uYJC6YtFrJl+/Y5
         aIR0sfcn4lxUaoET1Gqqqg90a8jbG5Impc1pc/xuIKeSzD8HfMSX6dxhlszjwQ49cQm9
         IBHsIHil90jcTuDmRpn/1kArzXZ/nyyA54CrCFGHVhSJ4fvEqrnHNln8RTqBnXcuR9gx
         Gmrg==
X-Gm-Message-State: AOAM530/vLt/ZxSWfZUEfJ5eQGra60Rj7CaYA/fCRcAuk67GDvBfl1Ni
        M4lOGBfVB4OcO0Mxs6oE0/DTXn5dvJYVfrfl+QMOHTbxFaueas0IWapo9+R+aqNC4oJPRhbVLtP
        IjovI+BqgDQ88
X-Received: by 2002:a17:906:168f:: with SMTP id s15mr28369018ejd.144.1618934241219;
        Tue, 20 Apr 2021 08:57:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3uF5D/pSoiaHMLpHm8CDL6lyniez0u3OyuO4dDYSchmAPAbAdV3sU2eqwNdHyFbxL1j3BsQ==
X-Received: by 2002:a17:906:168f:: with SMTP id s15mr28368992ejd.144.1618934241061;
        Tue, 20 Apr 2021 08:57:21 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id cz2sm16550602edb.13.2021.04.20.08.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 08:57:20 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vineeth Pillai <viremana@linux.microsoft.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        viremana@linux.microsoft.com
Subject: Re: [PATCH v2 3/7] KVM: x86: hyper-v: Move the remote TLB flush
 logic out of vmx
In-Reply-To: <a01a13e4-4c11-962b-83ad-e7fc64cc3be8@linux.microsoft.com>
References: <cover.1618492553.git.viremana@linux.microsoft.com>
 <92207433d0784e123347caaa955c04fbec51eaa7.1618492553.git.viremana@linux.microsoft.com>
 <87y2di7hiz.fsf@vitty.brq.redhat.com>
 <a01a13e4-4c11-962b-83ad-e7fc64cc3be8@linux.microsoft.com>
Date:   Tue, 20 Apr 2021 17:57:19 +0200
Message-ID: <87eef5hrts.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vineeth Pillai <viremana@linux.microsoft.com> writes:

> On 4/16/2021 4:36 AM, Vitaly Kuznetsov wrote:
>>
>>>   struct kvm_vm_stat {
>>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>>> index 58fa8c029867..614b4448a028 100644
>>> --- a/arch/x86/kvm/hyperv.c
>>> +++ b/arch/x86/kvm/hyperv.c
>> I still think that using arch/x86/kvm/hyperv.[ch] for KVM-on-Hyper-V is
>> misleading. Currently, these are dedicated to emulating Hyper-V
>> interface to KVM guests and this is orthogonal to nesting KVM on
>> Hyper-V. As a solution, I'd suggest you either:
>> - Put the stuff in x86.c
>> - Create a dedicated set of files, e.g. 'kvmonhyperv.[ch]' (I also
>> thought about 'hyperv_host.[ch]' but then I realized it's equally
>> misleading as one can read this as 'KVM is acting as Hyper-V host').
>>
>> Personally, I'd vote for the later. Besides eliminating confusion, the
>> benefit of having dedicated files is that we can avoid compiling them
>> completely when !IS_ENABLED(CONFIG_HYPERV) (#ifdefs in C are ugly).
> Makes sense, creating new set of files looks good to me. The default 
> hyperv.c
> for hyperv emulation also seems misleading - probably we should rename it
> to hyperv_host_emul.[ch] or similar. That way, probably I can use 
> hyperv.[ch]
> for kvm on hyperv code. If you feel, thats too big of a churn, I shall use
> kvm_on_hyperv.[ch] (to avoid reading the file differently). What do you 
> think?

I agree that 'hyperv.[ch]' is not ideal but I'm on the fence whether
renaming it is worth it. If we were to rename it, I'd suggest just
'hyperv_emul.[ch]' to indicate that here we're emulating Hyper-V.

I don't think reusing 'hyperv.[ch]' for KVM-on-Hyper-V is a good idea,
it would be doubly misleading and not friendly to backporters. Let's not
do that.

>
>
>>> @@ -10470,7 +10474,6 @@ void kvm_arch_free_vm(struct kvm *kvm)
>>>   	vfree(kvm);
>>>   }
>>>   
>>> -
>> Stray change?
> It was kinda leftover, but I thought I'd keep it as it removes and 
> unnecessary line.

The idea is to have meaninful patches as concise as possible splitting
off cleanup / preparatory patches which don't actually change anything;
this way big series are much easier to review.

>
> Thanks,
> Vineeth
>

-- 
Vitaly

