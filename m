Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4158C3735F5
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhEEIC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:02:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50850 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231844AbhEEICz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:02:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620201719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o5qx/tux63yhpA+wbBJMEnO707eoeKsE9vMXUK3A6WA=;
        b=TOGOFCVNiCoBEpkUbxX0HrvCsR4bBlEV/swFG429TqgghKFyjSbdsfWKUcE8di3fmEflpp
        iCW7X1slxWQ7VncHhMwawGSQ+F6UoEe5j8ZkZiVsPBqXqLjaPjtnQh5JyhazuvTULxXDyK
        mXoDR4Fp5w4fMuxgZDsQBUoZqX/GEek=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-b35BSaGNOra7vZZKZbk3WQ-1; Wed, 05 May 2021 04:01:57 -0400
X-MC-Unique: b35BSaGNOra7vZZKZbk3WQ-1
Received: by mail-ej1-f70.google.com with SMTP id w23-20020a1709061857b029039ea04b02fdso158115eje.22
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 01:01:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o5qx/tux63yhpA+wbBJMEnO707eoeKsE9vMXUK3A6WA=;
        b=DxnFH4FMbV6Cp+oZK2spzH7MiM18MQqw8l9+KwurZUlCSHoJXsbTss+KOZnSQmHq5I
         dONXTc43cbalkiAU1p8Cjq4BGRbPTle+XQIEMU9R2LY6aNRm/OqsKczvxhP+RJe4swYI
         FzecPCRiUT73KYCKp350lhGB/hnq844AXH+J/0+VfWHIypelNw51C++Ol12stYevXQz1
         iw0uoNeSwXEbs+wmPY/MnXtc3mZHQln5ySqFOqRcYSAHHYEjQLBO3o1dD68bygC08rtp
         DulgitcdrawhJwOUVQjomtsy5NfhKxxKDzXjUlKPTDcXYrd4CSfuXvOelgfRi8iqkT9n
         Vmjw==
X-Gm-Message-State: AOAM532bJRVjXEQMGfszgR/gJ9cupwhkOIaZi+emmH1rqC1i4Nkyr7T1
        jyIjtUrZl2ngrNk5rjvKmjrZtGc/8yc4XJBI9HSsvcBA9bBWHcuvkLPrg3TbOuG/67QNq9AyV5p
        dj4LIVXEC1hIt
X-Received: by 2002:a17:906:2511:: with SMTP id i17mr24291675ejb.198.1620201716645;
        Wed, 05 May 2021 01:01:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrVxfYIB3jt2bZhK7Mv1cXV5hHwNeR5Y3b/l7UvZaWKRYVvayeN0ZRhl4nPFFZLSpfIxrCcQ==
X-Received: by 2002:a17:906:2511:: with SMTP id i17mr24291658ejb.198.1620201716443;
        Wed, 05 May 2021 01:01:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id p4sm2499967ejr.81.2021.05.05.01.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 01:01:55 -0700 (PDT)
Subject: Re: [PATCH 02/15] KVM: x86: Emulate RDPID only if RDTSCP is supported
To:     Reiji Watanabe <reijiw@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20210504171734.1434054-1-seanjc@google.com>
 <20210504171734.1434054-3-seanjc@google.com>
 <CAAeT=FycnR2BonmiHSWobsLCGTuQuTS3kg9x_eYCKLRQGOvYzQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <92131802-68b7-3d27-3e61-9b388bfcbc7f@redhat.com>
Date:   Wed, 5 May 2021 10:01:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAAeT=FycnR2BonmiHSWobsLCGTuQuTS3kg9x_eYCKLRQGOvYzQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/21 05:51, Reiji Watanabe wrote:
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -637,7 +637,8 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>>          case 7:
>>                  entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>>                  entry->eax = 0;
>> -               entry->ecx = F(RDPID);
>> +               if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
>> +                       entry->ecx = F(RDPID);
>>                  ++array->nent;
>>          default:
>>                  break;
> I'm wondering if entry->ecx should be set to F(RDPID) here
> even if the CPU supports RDPID natively.
> (i.e. kvm_cpu_cap_has(X86_FEATURE_RDPID) is true)
> 
> The document "Documentation/virt/kvm/api.rst" says:
> ---
> 4.88 KVM_GET_EMULATED_CPUID
> ---------------------------
> <...>
> Userspace can use the information returned by this ioctl to query
> which features are emulated by kvm instead of being present natively.
> ---

Setting it always is consistent with the treatment of MOVBE above. 
Either way is okay but it should be done for both bits.

Paolo

