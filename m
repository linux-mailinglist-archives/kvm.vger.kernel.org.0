Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6FB32437D
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 19:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhBXSFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 13:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhBXSFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 13:05:07 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F66C061574
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 10:04:27 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id l2so1988780pgb.1
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 10:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8oyKdQoy6n2rMkEX7kMXfHHxsrCJ0CPEN9zor11kQnE=;
        b=CCambHuN4LCpOo5sCt3e9KV5M4MRlgTzM/h7J4FYk0axWZavuhsAyfdVSQ551JXG63
         sIv61nGIlqdKZISi46/kIWqo1t+pMaDAniBBEM5R9J5R+QXHtNpyA2QxTEUKtq9yervy
         41FQGw1Ch+M+Wzp1a6xkaQUA79yOeoCe7w/GhNkZGl6iAC7PftvKtP8VJCWRaQpasQcQ
         jNnyzrFSGdf66d4AEHKsN90b8KY0bDZGw76bc6K5Ob0FPJw/Kfh+ZHbqkKVeOmzhDyFp
         cwf83c8zQ+LvzZB9LbdUqc1cP22ICiVYDM/wy7/eS5ZlhGIG0NzPRbmQiu6lwJjpi0ww
         ECFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8oyKdQoy6n2rMkEX7kMXfHHxsrCJ0CPEN9zor11kQnE=;
        b=SIAoNehxiirjtEw0jBoFCEzepQQazaYgy0vdM/Vtw3BgkrRdPh4DP+QNZSRbPV2FJA
         oP2A2HFlZd7HfJrJ5XDF1fmhiNzngF+0kwMD3eDGX61pUiLopsirZtE49X5YaGSaeI1j
         /7XCJyKXEMVTUvSyISh+xdZx1B2g/BBKahpiqKZ4lJiFliyWUASDN7nt2IgUfbVaN/er
         vCWahgS+2RIelDZsjU6XbwuTg/gHm816UTRBecSq6hTkCfVSTOhHEabTsqIw17EJweRN
         nZWvEuyRWEIyoF8NAK6AgkfAw+u05VQLSBoM/e/pCjqqv3UyXtQnbgkgIun1Fms19H++
         Laog==
X-Gm-Message-State: AOAM531Zj/uqmxEYEkfa6yvmYM2EShR7IKczeaNi9JWCulXI7krvBOsS
        2Y+ndgYd9HSbtIotuYw8DRcV5Q==
X-Google-Smtp-Source: ABdhPJyzPVSGdeH/K5eiwSDWTXEgj41XYlEROJqHK1pQF9VV6HUhI4Y5jyWsBs9APTbw+c/XSbEiRw==
X-Received: by 2002:a62:7e01:0:b029:1ed:8173:40a1 with SMTP id z1-20020a627e010000b02901ed817340a1mr19468716pfc.6.1614189866571;
        Wed, 24 Feb 2021 10:04:26 -0800 (PST)
Received: from google.com ([2620:15c:f:10:385f:4012:d20f:26b5])
        by smtp.gmail.com with ESMTPSA id m19sm3480979pjn.21.2021.02.24.10.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 10:04:26 -0800 (PST)
Date:   Wed, 24 Feb 2021 10:04:19 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Remove the best->function == 0x7 assignment
Message-ID: <YDaVIyWSO2hTVAkp@google.com>
References: <20210224022931.14094-1-yejune.deng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224022931.14094-1-yejune.deng@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hmm, the shortlog should provide a higher level overview of the change.  Stating
the literal code change doesn't provide much context.  Maybe:

  KVM: x86: Remove an unnecessary best->function check

On Wed, Feb 24, 2021, Yejune Deng wrote:
> In kvm_update_cpuid_runtime(), there is no need the best->function
> == 0x7 assignment, because there is e->function == function in

s/assignment/check, here and in the shortlog.

> cpuid_entry2_find().
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>

With the shortlog and changelog cleaned up:

Reviewed-by: Sean Christopherson <seanjc@google.com>

> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index c8f2592ccc99..eb7a01b1907b 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -120,7 +120,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  	}
>  
>  	best = kvm_find_cpuid_entry(vcpu, 7, 0);
> -	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
> +	if (best && boot_cpu_has(X86_FEATURE_PKU))
>  		cpuid_entry_change(best, X86_FEATURE_OSPKE,
>  				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
>  
> -- 
> 2.29.0
> 
