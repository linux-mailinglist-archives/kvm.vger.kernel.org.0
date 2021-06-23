Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5503B1983
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 14:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhFWMCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 08:02:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54085 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhFWMCu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 08:02:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624449632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=40lufiefSAXJYxyzql25e+wiCU9kJZcVj8CF016XD70=;
        b=CEstZ7cIdGOqDR+jnolP/XRG/JXhBLjDflf7lCofp0kpQHaMDnWWthH34tcmchbvdBV0ct
        GJl0+gObI3CuwmCiDP0LxOQZ8lsmAOI+mWDkiJj3CBZWA3Zdc6hRvOOm/ZGUvW7Rt6GMvx
        f+zXS2rNdBJfAth/dDRE3/o+8wCG0zQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-txznQztfP_KLp_njZYFmnQ-1; Wed, 23 Jun 2021 08:00:30 -0400
X-MC-Unique: txznQztfP_KLp_njZYFmnQ-1
Received: by mail-wr1-f71.google.com with SMTP id x5-20020adff0c50000b029011a7be832b7so973620wro.18
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 05:00:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=40lufiefSAXJYxyzql25e+wiCU9kJZcVj8CF016XD70=;
        b=cO2tgsR0K7Tl/qQ/UAoqY4ckep1HEyl1A2P2ajEncD9cAQI2OYGfk63X4hSMXd7TTr
         2H6j/tS+KAoqJCATvbyUYbz8+m0VKxds7ItC8GG/2w376pRBayudkHamX/b/s5NxjL8b
         n8tzSt44P9VOmrHUCesRu6MrCiGcRx5oXPG88zF80ZT7OwRhG326uRVLMR7iSaNZydj+
         bHZo0mD+R6dEHtYs1pmjuh3IWjsIHxBmGiP4zC66LDZvj9gSlN0Qoo/6Ah35S/bi5XSU
         UWlBCEwNsguPIpearl12yrDGss0TDgxhxmxKEk1U96njztsCN2He+EUVBVNYPxQ6F4fG
         wHDg==
X-Gm-Message-State: AOAM532BtBB+x94zfjaWOkytRFQsawUBNOkf2B8DHGQCOTICjQ7vVwlA
        TMgaUSpwukq5NyJ/Sp8YXhnxA0jLMeqACCJp8z5jcddnnlyNfshcfuDnDDt2JjHZDSkCmvsQmzg
        BcKE3SHNvCJk5
X-Received: by 2002:a05:600c:b57:: with SMTP id k23mr10532630wmr.133.1624449629597;
        Wed, 23 Jun 2021 05:00:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNmyUviHSGAy39wspBqD/44uhbsty4Dt6H2q9/tUgrngrqOMapjcP5jZzJYKbXJOEg9kj0+A==
X-Received: by 2002:a05:600c:b57:: with SMTP id k23mr10532600wmr.133.1624449629425;
        Wed, 23 Jun 2021 05:00:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o203sm5900649wmo.36.2021.06.23.05.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 05:00:28 -0700 (PDT)
Subject: Re: [PATCH RFC] KVM: nSVM: Fix L1 state corruption upon return from
 SMM
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Cathy Avery <cavery@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20210623074427.152266-1-vkuznets@redhat.com>
 <a3918bfa-7b4f-c31a-448a-aa22a44d4dfd@redhat.com>
 <2eaa94bcc697fec92d994146f7c69625b6a84cd0.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e4ba5286-f683-5876-1cd7-7fc83bc1638e@redhat.com>
Date:   Wed, 23 Jun 2021 14:00:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2eaa94bcc697fec92d994146f7c69625b6a84cd0.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 13:39, Maxim Levitsky wrote:
> On Wed, 2021-06-23 at 11:39 +0200, Paolo Bonzini wrote:
>> On 23/06/21 09:44, Vitaly Kuznetsov wrote:
>>> - RFC: I'm not 100% sure my 'smart' idea to use currently-unused HSAVE area
>>> is that smart. Also, we don't even seem to check that L1 set it up upon
>>> nested VMRUN so hypervisors which don't do that may remain broken. A very
>>> much needed selftest is also missing.
>>
>> It's certainly a bit weird, but I guess it counts as smart too.  It
>> needs a few more comments, but I think it's a good solution.
>>
>> One could delay the backwards memcpy until vmexit time, but that would
>> require a new flag so it's not worth it for what is a pretty rare and
>> already expensive case.
> 
> I wonder what would happen if SMM entry is triggered by L1 (say with ICR),
> on a VCPU which is in L2. Such exit should go straight to L1 SMM mode.

Yes, it does, but it still records the L2 state in the guest's SMM state 
save area.  Everything works right as long as the guest stays in L2 (the 
vmcb12 control save area is still there in svm->nested and is 
saved/restored by KVM_GET/SET_NESTED_STATE), the problem that Vitaly 
found is the destruction of the saved L1 host state.

Paolo

> I will very very soon, maybe even today start testing SMM with my migration
> tests and such. I hope I will find more bugs in this area.
> 
> Thanks for fixing this issue!
> 
> Best regards,
> 	Maxim Levitsky
> 

