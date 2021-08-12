Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F7C3EA998
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 19:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbhHLRjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 13:39:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46987 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236631AbhHLRjN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 13:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628789927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H0a2yTJZSWzNBVH6vRpTpspwcHUOMwI/yXcXRTmK2RY=;
        b=D2WtVSvJhXMd6HUxIvl2yCISIwu8rVK3PyzkDC29EVfI4Qw2Sv9toZu/ujShVQ8cceQG9D
        v4eEoG9zA7m7UcVoSj/bZyfQWcTbz8qODgf0O5ZqgSspSzwtcXX06qAoQIeFYfvdgwMWjO
        67BPPuDsCKYhrPKjPvLe/HsBx6DA1tA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135--K_QRdGHMui_1ifjBesA0w-1; Thu, 12 Aug 2021 13:38:46 -0400
X-MC-Unique: -K_QRdGHMui_1ifjBesA0w-1
Received: by mail-ed1-f69.google.com with SMTP id y39-20020a50bb2a0000b02903bc05daccbaso3404877ede.5
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 10:38:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H0a2yTJZSWzNBVH6vRpTpspwcHUOMwI/yXcXRTmK2RY=;
        b=JCNuVxx5aCkGhk0H0pneMeY6aovK0hM5fWgVUjA5oGErQEFbO7Ei4ajF4c9SHXp/gn
         a8L+rShilLCyioZUjyb+/Dk1arO3UHNB6FDikzOMEVvaeB99lGxqMnK0A7v4pM2i9+oK
         3M++hqBDoocFaq4uxs218t51pxyU4FJFNzaFX4lxl4wFCkmT7NcTsk1+nuOiH13xPkTy
         6TAR1t5846wruQGGvfstOylxv+DA0OEnZPzgX59cakAeUoegFoG0TdMMNUGlytNgwsQx
         AgXBIJu3NKsRRiloJ0CWD3tjigX+jFQQDUMdDBGm6jXYbuDBuqaE3AaPI9H3/d48JlFA
         kLNQ==
X-Gm-Message-State: AOAM532EjRTH895UFdZQg1+mBJBe33u3b9837Kcnj4Cyzj9ipyFaqYvQ
        XcoEWi5xKFJTj5ZUL67RMk8dhGDaY1WshO4wl1x9VPiIWSZ/4ibRfFiUESDSRUixkZdjY5vTHJJ
        lfxrp3DG/PrJv
X-Received: by 2002:a17:907:3e05:: with SMTP id hp5mr4772839ejc.527.1628789925275;
        Thu, 12 Aug 2021 10:38:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGIauZ1M4pv9JYwwtqfs9CGEZTYw4rF6feLaT5xuwnVPEbUu6+iMXnsoUOxagvmXF1nnVrcA==
X-Received: by 2002:a17:907:3e05:: with SMTP id hp5mr4772813ejc.527.1628789925064;
        Thu, 12 Aug 2021 10:38:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f12sm1491206edx.37.2021.08.12.10.38.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 10:38:44 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Don't step down in the TDP iterator
 when zapping all SPTEs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210812050717.3176478-1-seanjc@google.com>
 <20210812050717.3176478-3-seanjc@google.com>
 <CANgfPd8HSYZbqmi21XQ=XeMCndXJ0+Ld0eZNKPWLa1fKtutiBA@mail.gmail.com>
 <YRVVWC31fuZiw9tT@google.com>
 <928be04d-e60e-924c-1f3a-cb5fef8b0042@redhat.com>
 <YRVbamoQhvPmrEgK@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7a95b2f6-a7ad-5101-baa5-6a19194695a3@redhat.com>
Date:   Thu, 12 Aug 2021 19:38:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRVbamoQhvPmrEgK@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/21 19:33, Sean Christopherson wrote:
> On Thu, Aug 12, 2021, Paolo Bonzini wrote:
>> On 12/08/21 19:07, Sean Christopherson wrote:
>>> Yeah, I was/am on the fence too, I almost included a blurb in the cover letter
>>> saying as much.  I'll do that for v2 and let Paolo decide.
>>
>> I think it makes sense to have it.  You can even use the ternary operator
> 
> Hah, yeah, I almost used a ternary op.  Honestly don't know why I didn't, guess
> my brain flipped a coin.
> 
>>
>> 	/*
>> 	 * When zapping everything, all entries at the top level
>> 	 * ultimately go away, and the levels below go down with them.
>> 	 * So do not bother iterating all the way down to the leaves.
> 
> The subtle part is that try_step_down() won't actually iterate down because it
> explicitly rereads and rechecks the SPTE.
> 
> 	if (iter->level == iter->min_level)
> 		return false;
> 
> 	/*
> 	 * Reread the SPTE before stepping down to avoid traversing into page
> 	 * tables that are no longer linked from this entry.
> 	 */
> 	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));  \
>                                                                       ---> this is the code that is avoided
> 	child_pt = spte_to_child_pt(iter->old_spte, iter->level);   /
> 	if (!child_pt)
> 		return false;

Ah, right - so I agree with Ben that it's not too important.

Paolo

