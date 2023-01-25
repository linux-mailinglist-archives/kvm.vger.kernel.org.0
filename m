Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1145E67B3CE
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 15:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235586AbjAYOEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Jan 2023 09:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234845AbjAYOEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Jan 2023 09:04:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8245844BDD
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674655406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ncu/m+5+/WI/1e3GSfSo6VdQKJavRU4pao1vU93BlHw=;
        b=ASdeiyC5dQGfefeGpjyx68VeoT1lscEtHhJCvdSy2XhrPeD6NBfdbPBRRGLKJr0lmYyr9W
        VSsMOUad6lX3UvBsY/oELV9+AKBcnwqIrotkq3w98K8f6UUtBSmuTlOiJqPsGSrB/tVEKX
        9xmUXeMnIt/r/xOcU6yahz/LIQl7Da0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-373-VP2gGDSAOluu0k052J1qBw-1; Wed, 25 Jan 2023 09:03:25 -0500
X-MC-Unique: VP2gGDSAOluu0k052J1qBw-1
Received: by mail-ed1-f71.google.com with SMTP id x5-20020a05640226c500b0049e840f68feso11737263edd.23
        for <kvm@vger.kernel.org>; Wed, 25 Jan 2023 06:03:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ncu/m+5+/WI/1e3GSfSo6VdQKJavRU4pao1vU93BlHw=;
        b=fFIS+4e4Bwe8386Dhx5iU1EvMgBILIz3/uRYFZBh13cuGM53EcADiKBW+d9qxPPZmv
         RNfhndKLjwHbVtUmG+EdVCHeer5JfKzHwyAXx+K9P5FhQ6Btdg+panxh8Ra0gx7UiVxV
         nMzaXB5qEYM1JsGQJonn5goVotTVPY3/j2mQKzUAE5BEZKRVklRRFX7Y12rPtXzOzR0c
         4C472+tjsSETc0FkijRf3dH1yssO0G80EX5rXyKyrr70agy2dQLMK4d07/q6D0bQ9yRr
         Q176FYlvVMFYheMftYURyhkClCi71ZZsSohXFIFrPSV9//RN4WlcrmK1m0gw8kMWAOJB
         AFLQ==
X-Gm-Message-State: AFqh2kop4Nipxje3nuEsR12CYlOLW3P/+aistaLSUF/7NBxSwDRvXcQt
        BGrlV2BcQfdacOIdB7C3RSYLiPjGT0JJ+0TSBuevaFUyprOCTN9gmgRvy9R23CHwly4SPTSKK5g
        e8tdsG67A+n0l
X-Received: by 2002:a17:907:8b0a:b0:877:5c3e:706 with SMTP id sz10-20020a1709078b0a00b008775c3e0706mr31811576ejc.73.1674655402445;
        Wed, 25 Jan 2023 06:03:22 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvUCNcE7exKGBNTzRlyuPWTkp0ghZlVVEFfENUI7ck1uWhBq7Q6OM8ofgDDHy/1rAF7l/yHUA==
X-Received: by 2002:a17:907:8b0a:b0:877:5c3e:706 with SMTP id sz10-20020a1709078b0a00b008775c3e0706mr31811559ejc.73.1674655402220;
        Wed, 25 Jan 2023 06:03:22 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id un4-20020a170907cb8400b008775b8a5a5fsm2389452ejc.198.2023.01.25.06.03.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jan 2023 06:03:21 -0800 (PST)
Message-ID: <ad6673bd-1500-eb9e-f5be-95e63bb8ff64@redhat.com>
Date:   Wed, 25 Jan 2023 15:03:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] x86: KVM: Add common feature flag for AMD's PSFD
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230124194519.2893234-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230124194519.2893234-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/24/23 20:45, Sean Christopherson wrote:
> Use a common X86_FEATURE_* flag for AMD's PSFD, and suppress it from
> /proc/cpuinfo via the standard method of an empty string instead of
> hacking in a one-off "private" #define in KVM.  The request that led to
> KVM defining its own flag was really just that the feature not show up
> in /proc/cpuinfo, and additional patches+discussions in the interim have
> clarified that defining flags in cpufeatures.h purely so that KVM can
> advertise features to userspace is ok so long as the kernel already uses
> a word to track the associated CPUID leaf.
> 
> No functional change intended.
> 
> Link: https://lore.kernel.org/all/d1b1e0da-29f0-c443-6c86-9549bbe1c79d@redhat.como
> Link: https://lore.kernel.org/all/YxGZH7aOXQF7Pu5q@nazgul.tnic
> Link: https://lore.kernel.org/all/Y3O7UYWfOLfJkwM%2F@zn.tnic
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/cpufeatures.h | 1 +
>   arch/x86/kvm/cpuid.c               | 8 +-------
>   2 files changed, 2 insertions(+), 7 deletions(-)

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 61012476d66e..2acaebc7bb76 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -330,6 +330,7 @@
>   #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* Virtualized Speculative Store Bypass Disable */
>   #define X86_FEATURE_AMD_SSB_NO		(13*32+26) /* "" Speculative Store Bypass is fixed in hardware. */
>   #define X86_FEATURE_CPPC		(13*32+27) /* Collaborative Processor Performance Control */
> +#define X86_FEATURE_AMD_PSFD            (13*32+28) /* "" Predictive Store Forwarding Disable */
>   #define X86_FEATURE_BTC_NO		(13*32+29) /* "" Not vulnerable to Branch Type Confusion */
>   #define X86_FEATURE_BRS			(13*32+31) /* Branch Sampling available */
>   
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 2a9f1e200dbc..fb2b0e3ecce1 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -59,12 +59,6 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
>   	return ret;
>   }
>   
> -/*
> - * This one is tied to SSB in the user API, and not
> - * visible in /proc/cpuinfo.
> - */
> -#define KVM_X86_FEATURE_AMD_PSFD	(13*32+28) /* Predictive Store Forwarding Disable */
> -
>   #define F feature_bit
>   
>   /* Scattered Flag - For features that are scattered by cpufeatures.h. */
> @@ -710,7 +704,7 @@ void kvm_set_cpu_caps(void)
>   		F(CLZERO) | F(XSAVEERPTR) |
>   		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
>   		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
> -		__feature_bit(KVM_X86_FEATURE_AMD_PSFD)
> +		F(AMD_PSFD)
>   	);
>   
>   	/*
> 
> base-commit: 7cb79f433e75b05d1635aefaa851cfcd1cb7dc4f


