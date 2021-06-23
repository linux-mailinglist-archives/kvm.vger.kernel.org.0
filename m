Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A9F3B2281
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 23:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFWVfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 17:35:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56689 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhFWVfc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 17:35:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624483994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PFYcdOACUL59Qvc4FRYngRxPwSqQBpDBN6EEDPGjjUk=;
        b=CYju/gXKj/EfVHb5hklqFEi4d9A0sVMTpptFzz255eUKwJMdK8HdvTaxnsFN8iACC2P7Cw
        mDMk0+pcAM4a0L8FOn8hMybdnQ9FLcnKtO+OGkOUjN+131QJr7m7b26wvyc/WrlNnnVfF6
        lLXnUoYe/A9FlblOQNQ9hDyWkbNGPPo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-QuzoSIEsPEOaPFJ0oXR03w-1; Wed, 23 Jun 2021 17:33:12 -0400
X-MC-Unique: QuzoSIEsPEOaPFJ0oXR03w-1
Received: by mail-ed1-f72.google.com with SMTP id x10-20020aa7cd8a0000b0290394bdda92a8so2073185edv.8
        for <kvm@vger.kernel.org>; Wed, 23 Jun 2021 14:33:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PFYcdOACUL59Qvc4FRYngRxPwSqQBpDBN6EEDPGjjUk=;
        b=icBVuNl6FBiI6c5TYxmfE38UWheSX3yLR2ERIkxwJMI6Um5AC31P/Yhzxfh67GIcBC
         QWdZQwQnLJ8QHaHLCadSAo1tPeD/DZkJIyABQTCkcfKZAgLgfRdLJDwJuOtXZy9HZ10j
         s4XMcaU0ShYhWYlxPdQk2P90h6f2FSWWTooyp7IbrD7ZO2XbjdPmDWIQH1Y4H0+NzqUM
         WkOfIVMmaUPHwLAJtBHksPLmkoPWqRJHFvaaYWYlfpnq8nZrY5xxA+5sSeoxQkC5vs5s
         d1N1FkH/6HffSfPaK4IbhimqWEighxV5C6OD9q9UHxteNwjfzkNnPhzt5l3k0AgP4/hP
         rKyQ==
X-Gm-Message-State: AOAM530WOmiIAzkozeS46UEP2fwtIkfI0vYzGAzFUOhmkuNndbiMaP7n
        07qNLU2vpn2hF0S/kBezV9+q4HlRnapAfHWuCEjkNlMYWTrRIuNXtj3Zd2MEVv2LJu0E0vxsp0y
        8MatXAfbX/mpC
X-Received: by 2002:a05:6402:31a9:: with SMTP id dj9mr2459678edb.164.1624483991666;
        Wed, 23 Jun 2021 14:33:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7loBBFqTPbXnGVrSMX7KEDA1IKgrhU2wGwS08VkIiayRVDOaVyT3cWE10La9bhIXhoN+FnQ==
X-Received: by 2002:a05:6402:31a9:: with SMTP id dj9mr2459667edb.164.1624483991509;
        Wed, 23 Jun 2021 14:33:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p13sm662608edh.79.2021.06.23.14.33.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:33:10 -0700 (PDT)
Subject: Re: [PATCH 00/54] KVM: x86/mmu: Bug fixes and summer cleaning
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210622175739.3610207-1-seanjc@google.com>
 <b4efb3fd-9591-3153-5a64-19afb12edb2b@redhat.com>
 <YNOiar3ySxs0Z3N3@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d9004cf0-d7ac-dc7d-06ad-6669fe11a21b@redhat.com>
Date:   Wed, 23 Jun 2021 23:33:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YNOiar3ySxs0Z3N3@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/06/21 23:06, Sean Christopherson wrote:
>>
>> This is good stuff, I made a few comments but almost all of them (all except
>> the last comment on patch 9, "Unconditionally zap unsync SPs") are cosmetic
>> and I can resolve them myself.
> The 0-day bot also reported some warnings.  vcpu_to_role_regs() needs to be
> static, the helpers are added without a user.  I liked the idea of adding the
> helpers in one patch, but I can't really defend adding them without a user. :-/

Yep, I noticed them too.

We can just mark them static inline, which is a good idea anyway and 
enough to shut up the compiler (clang might behave different in this 
respect for .h and .c files, but again it's just a warning and not a 
bisection breakage).

Paolo

>     arch/x86/kvm/mmu/mmu.c:209:26: warning: no previous prototype for function 'vcpu_to_role_regs' [-Wmissing-prototypes]
>     struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
>                              ^
>     arch/x86/kvm/mmu/mmu.c:209:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
>     struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
>     ^
>     static
>     arch/x86/kvm/mmu/mmu.c:199:1: warning: unused function '____is_cr0_wp' [-Wunused-function]
>     BUILD_MMU_ROLE_REGS_ACCESSOR(cr0, wp, X86_CR0_WP);
> 

