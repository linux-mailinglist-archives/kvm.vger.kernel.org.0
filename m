Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897233B2C42
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 12:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbhFXKT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 06:19:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43934 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232186AbhFXKT5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 06:19:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624529858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4frsi0H+HBjHeCdKISuXJMG773wuFNrwEMxUF4xqOQU=;
        b=dovP4N1iiYrWl9ODzKLFt9QXqK5vxRdABecKY/6SY/nGnPWHmvqydDBGuKgr4bR/Dkx6gI
        gYcmSDg4N5n7jaLp7tisEpqFVDmzPqLkCInjIxTx8m9UUdsLfbaxpMfr5EKmfPseGECxA0
        o/pZeKbfVjmxQK+6lnhX3zqUSV0tyy0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-DS6QIF1rMcGrfnynbe2yzw-1; Thu, 24 Jun 2021 06:17:35 -0400
X-MC-Unique: DS6QIF1rMcGrfnynbe2yzw-1
Received: by mail-ej1-f71.google.com with SMTP id lt4-20020a170906fa84b0290481535542e3so1831340ejb.18
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 03:17:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4frsi0H+HBjHeCdKISuXJMG773wuFNrwEMxUF4xqOQU=;
        b=fm5yj1JlEMAALW3z3C8aM+Eurl0MTFdFhPxlRtqwNXMhj17oc6kNOl3+xBeGwybN78
         8C4gCcAgh+N2jXMzhXAlHVTMCqWwLeiCOuINfrUJrDKMF6V66yLraIHZQOTzawbco9x1
         B6X5kfL3FTO1Nvova1ka7ObpE9lIYJrK57TS5HX0+JaBcyrWUNojl69JwNNl/sTdI8Sc
         CyQAK45NTN4qEl4dVPhD3n7W0OJXnd2n4sqfwld5kG7a7Oetqsc78mniTTfnAbAs28Df
         T5o3XJPQbA0H+ghhHwyirxJzVMBeETf+cU2MLM5OoBO/POZLe40XWhtWL1sVyBS/Anc3
         jLtg==
X-Gm-Message-State: AOAM533eyIT/re3Q18VW4p/B+Kd9okGecLdnJRpN7JCuIeKxnf6gAVYv
        pT6BAX4cnWhCj9dXyAnbM4zREhEm22oUkzSts0EN9Vd39ofC3FnwBSQtii+H025oHdM22VorHyr
        +Uv+z6O0I2h9T
X-Received: by 2002:a17:906:b254:: with SMTP id ce20mr4621411ejb.480.1624529854690;
        Thu, 24 Jun 2021 03:17:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxC6TqcAfZORfwKXJXCm8bql8vynsp6j3JYon1fQgnkpoL4xlG5zu/uVtJRITtzGjbxU3KFw==
X-Received: by 2002:a17:906:b254:: with SMTP id ce20mr4621398ejb.480.1624529854552;
        Thu, 24 Jun 2021 03:17:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x21sm1600772edv.97.2021.06.24.03.17.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 03:17:33 -0700 (PDT)
Subject: Re: [PATCH 3/6] KVM: x86/mmu: avoid struct page in MMU
To:     Marc Zyngier <maz@kernel.org>, Nicholas Piggin <npiggin@gmail.com>
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        David Stevens <stevensd@chromium.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        James Morse <james.morse@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>
References: <20210624035749.4054934-1-stevensd@google.com>
 <20210624035749.4054934-4-stevensd@google.com>
 <1624524744.2sr7o7ix86.astroid@bobo.none> <87mtrfinks.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b7f9c30-eb12-35c5-191f-0e8e469e1b88@redhat.com>
Date:   Thu, 24 Jun 2021 12:17:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87mtrfinks.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/21 12:06, Marc Zyngier wrote:
> On Thu, 24 Jun 2021 09:58:00 +0100,
> Nicholas Piggin <npiggin@gmail.com> wrote:
>>
>> Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
>>> From: David Stevens <stevensd@chromium.org>
>>>   out_unlock:
>>>   	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
>>>   		read_unlock(&vcpu->kvm->mmu_lock);
>>>   	else
>>>   		write_unlock(&vcpu->kvm->mmu_lock);
>>> -	kvm_release_pfn_clean(pfn);
>>> +	if (pfnpg.page)
>>> +		put_page(pfnpg.page);
>>>   	return r;
>>>   }
>>
>> How about
>>
>>    kvm_release_pfn_page_clean(pfnpg);
> 
> I'm not sure. I always found kvm_release_pfn_clean() ugly, because it
> doesn't mark the page 'clean'. I find put_page() more correct.
> 
> Something like 'kvm_put_pfn_page()' would make more sense, but I'm so
> bad at naming things that I could just as well call it 'bob()'.

The best way to go would be to get rid of kvm_release_pfn_clean() and 
always go through a pfn_page.  Then we could or could not introduce 
wrappers kvm_put_pfn_page{,_dirty}.

I think for now it's best to limit the churn since these patches will go 
in the stable releases too, and clean up the resulting API once we have 
a clear idea of how all architectures are using kvm_pfn_page.

Paolo

