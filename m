Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188A3266652
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 19:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgIKRZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 13:25:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28095 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726274AbgIKRZk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 13:25:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599845139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rq3sqFL6vTqtj3WUeeDyK7taU7BHDxoUtnP2+8arByI=;
        b=Kl26PxtOhvtWqBfSSDoCoIXncw4coBjumtv7GkbKAdOM8uC3Jouhl/pU6BjOLqznwWFyoq
        uBkGOKm+KNwW4N+t8vg8eWPdZ06gemfQVU2YyR4NL5C5H9McYlqx3wA9OOMsJA+xF0yBNb
        E8QJMVRdi4tkuN5SYFlStaXCRbm84Rg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-Jzq7PMvbOeiXp_r_ngdemg-1; Fri, 11 Sep 2020 13:25:36 -0400
X-MC-Unique: Jzq7PMvbOeiXp_r_ngdemg-1
Received: by mail-wm1-f70.google.com with SMTP id 23so1614373wmk.8
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 10:25:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Rq3sqFL6vTqtj3WUeeDyK7taU7BHDxoUtnP2+8arByI=;
        b=JB0FYxkuhDSy9X+WxVVUcL0BAmIceAuF/2nQXqfyYGwTZ5b6XwfAReJUWQJ83l4W4V
         JrIYuyCCYlNsQZP8PtlJRffc+PZnx8uDb0OduRv6YwZDxxW5yGbHlxYoWEV6a1TTFpb3
         FHG7iwjuybZdo42vhoei0euEh+T7TB+5qHyTSoIQmD20eKsjZPqYaXLzffWqno0CPeqL
         VnM7tzq9hBZLkO0d/8uA3o5GJk/R6FHoq636xx9pEETl1YwqUX0uc2jHm8q7RSIg/M6/
         ZIlCd2oZ1BxhptJU+kbziTzULJdo2NMGQhjiF+3vGBj5cGu4pWTxNJ2cPYTZ5IUDy/gB
         LXLg==
X-Gm-Message-State: AOAM533wZ5r9alrEUjWSZM8w1EgRwWH1bPtB1D9OhQN0HXTcRHF9F7RN
        mCwOCMqmtFGUgDYU2Vfxm7oI3SPnIpN9RiE7vT9JMuO7i+kvxWxs5jcSN4HJlpkl9SEoKBCsu3Y
        rG/Bg1Pz2F1Jl
X-Received: by 2002:a1c:2e4b:: with SMTP id u72mr3249508wmu.69.1599845134541;
        Fri, 11 Sep 2020 10:25:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzE3otLO4wRNpP+aV23Yy58U5CCa3uZE7eu4+twKiyBsylZXDLRLWm38SWtnPOOlZPoIflB5g==
X-Received: by 2002:a1c:2e4b:: with SMTP id u72mr3249501wmu.69.1599845134341;
        Fri, 11 Sep 2020 10:25:34 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id k84sm5399436wmf.6.2020.09.11.10.25.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 10:25:33 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: always allow writing '0' to MSR_KVM_ASYNC_PF_EN
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20200911093147.484565-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f8e18679-dd49-f3e0-49fa-6f7cf1e1c025@redhat.com>
Date:   Fri, 11 Sep 2020 19:25:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200911093147.484565-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/09/20 11:31, Vitaly Kuznetsov wrote:
> Even without in-kernel LAPIC we should allow writing '0' to
> MSR_KVM_ASYNC_PF_EN as we're not enabling the mechanism. In
> particular, QEMU with 'kernel-irqchip=off' fails to start
> a guest with
> 
> qemu-system-x86_64: error: failed to set MSR 0x4b564d02 to 0x0
> 
> Fixes: 9d3c447c72fb2 ("KVM: X86: Fix async pf caused null-ptr-deref")
> Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d39d6cf1d473..44a86f7f2397 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2730,9 +2730,6 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>  	if (data & 0x30)
>  		return 1;
>  
> -	if (!lapic_in_kernel(vcpu))
> -		return 1;
> -
>  	vcpu->arch.apf.msr_en_val = data;
>  
>  	if (!kvm_pv_async_pf_enabled(vcpu)) {
> @@ -2741,6 +2738,9 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>  		return 0;
>  	}
>  
> +	if (!lapic_in_kernel(vcpu))
> +		return 1;
> +
>  	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
>  					sizeof(u64)))
>  		return 1;
> 

Queued, thanks.

Paolo

