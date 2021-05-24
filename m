Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9B138F1FE
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 19:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233332AbhEXRIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 13:08:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56980 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232920AbhEXRIS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 13:08:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621876010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eOn3/qS2T3cmcuTz6xvQsP5/9wBu95Fvay4pLeoTJwo=;
        b=E0Bn95wEm+4RkYaaheNITy9bBdTCpYeAu0DkvePZy+XKNYSoQrNqXL2k++c2hYBq+XViHL
        Hc/1M9Fdfqzzf4rJkSIcNAGHL2kyExPbqhP3LsTSmReuCugQLhKxlyDd4/Z/fk4p9QeMuJ
        yQYmd2XO6I5K0BM7/It9l0msIv2e87A=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-fe1TzcnSNDCYmpP6w0JEUw-1; Mon, 24 May 2021 13:06:48 -0400
X-MC-Unique: fe1TzcnSNDCYmpP6w0JEUw-1
Received: by mail-ej1-f70.google.com with SMTP id x20-20020a1709061354b02903cff4894505so7805459ejb.14
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 10:06:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eOn3/qS2T3cmcuTz6xvQsP5/9wBu95Fvay4pLeoTJwo=;
        b=bOsiH/omWF1i6B7n16cAHfhoxoZSQBkGRkniDDqIHFmRfQWJEStplktKa+P0ySkp3d
         x7SVwCZCvtrrtyKMEqb0zUgQJ6vh8eCA3sfcLZ4NLiPTOi3Xb5lcsZCZIIUWpiRxTfzc
         oY3IO8bK5i+fUIVnFK+8Yze1QeEqxFcrekdV8M7G5Tg36tou+DklrnrbbvsF4xjXDuSM
         X95AOGhBPEaeTCunEjXggUAjtB8ag6ToZCVt0V1mDL2hTgUI1JpxhhitjH/iYZyrXq6D
         oI30CoHEQtI8Rno0j/KqYBSo14D+lk2R9Yqfl5XsB5/2nYAPDHjHXdgHp9SvS5x5jU8K
         ZGsw==
X-Gm-Message-State: AOAM5332+/YcB89dwXaWYjArn83NCk+GS9tnwUbm8PWLmTOIAzC3Y77j
        caXsH2sDtA8B/xuDUIBE0juzaqp+0WpXg1uY20+vD59rm9+0/HaJujq5r6HnPMrXidtxralrkND
        bNB3LlIehNyOa
X-Received: by 2002:a17:906:1b42:: with SMTP id p2mr24347776ejg.550.1621876007132;
        Mon, 24 May 2021 10:06:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1/UdQHH7jmu5hfuqX/tqFGzK50pobk7I8Kt7VwHNYQD/F/6XWGGV9hiICdnq7AMbs/2RqPQ==
X-Received: by 2002:a17:906:1b42:: with SMTP id p2mr24347740ejg.550.1621876006889;
        Mon, 24 May 2021 10:06:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h9sm9533465edr.10.2021.05.24.10.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 10:06:46 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Assume a 64-bit hypercall for guests with
 protected state
To:     Sean Christopherson <seanjc@google.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
References: <d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com>
 <87pmxg73h7.fsf@vitty.brq.redhat.com>
 <a947ee05-4205-fb3d-a1e6-f5df7275014e@amd.com>
 <87tums8cn0.fsf@vitty.brq.redhat.com>
 <211d5285-e209-b9ef-3099-8da646051661@amd.com>
 <c6864982-b30a-29b5-9a10-3cfdd331057e@redhat.com>
 <YKvcYeXaxTQ//87M@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0e2544cd-b594-7266-4400-f9c5886ff1c4@redhat.com>
Date:   Mon, 24 May 2021 19:06:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YKvcYeXaxTQ//87M@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/21 19:03, Sean Christopherson wrote:
>> Let's introduce a new wrapper is_64_bit_hypercall, and add a
>> WARN_ON_ONCE(vcpu->arch.guest_state_protected) to is_64_bit_mode.
>
> Can we introduce the WARN(s) in a separate patch, and deploy them much more
> widely than just is_64_bit_mode()?  I would like to have them lying in wait at
> every path that should be unreachable, e.g. get/set segments, get_cpl(), etc...

Each WARN that is added must be audited separately, so this one I'd like 
to have now; it is pretty much the motivation for introducing a new 
function, as the other caller of is_64_bit_mode, kvm_get_linear_rip() is 
already "handling" SEV-ES by always returning 0.

But yes adding more WARNs can only be good.

Paolo

> Side topic, kvm_get_cs_db_l_bits() should be moved to svm.c.  Functionally, it's
> fine to have it as a vendor-agnostic helper, but practically speaking it should
> never be called directly.
> 

