Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C9D588C17
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 14:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237983AbiHCM3y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 08:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237945AbiHCM3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 08:29:53 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B908FD0D;
        Wed,  3 Aug 2022 05:29:52 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id f192so6856476pfa.9;
        Wed, 03 Aug 2022 05:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=G9PkH1/+GSbUEltcAckBvLGPMw9ebhk3UR1knPNLOvw=;
        b=H/bRb9Kwk/bGwyd2hcLSttkHtaI3MrIO/s2OzV56iHRYxjMs0qsifuzdE7dX4IvKEE
         nmvpYl5ku3U9U63wrULY1ffbd+IfBIMrqR06i/fHa6VWO+enWRu0UUfus6ce/HT32isN
         JEhQzAFoOmtPgrl4MiuRuVJjFEE5i71LFV2nHkUN6w9TdY4Xwt1T1phEuQVyp/p2o7vL
         AaEs/wRTz8U2Hq+c4OKSRz89SVEoCHqVebYOHIU6w6x+Y1VZDFxiAvGVvlbrNDDV4BMJ
         vGrxgKGp46R+eR7J5d6k6pI1TZS0RBCPKisPmsfMIZCc5OWd1u0TzgDsEOnAK3zj584n
         QB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G9PkH1/+GSbUEltcAckBvLGPMw9ebhk3UR1knPNLOvw=;
        b=YJZe+a5yyq9boiCjSG0L/oKfJxEsqecg0yRFyzQ9lqBcxvmhGnTT0cvlyS6k5qT/F/
         FwuVNdpoYorXpvBgTlWvXZJAmpJJ01N/48EcSuawaz4vQOZtz4tKSAmMJ121Ou0FgHaQ
         UjSqED9ayE5VngpHPv656N7EIHCcJ3SUn6hWryTo5S6cgnQcfkZ2gLqL6MRj5cOfBxa8
         Z4iSZVjJxmpiYihgOAw769iVcALJEwQ8cGh74BJuDaxjz4EQPWih4w3vMPuwZ565+ESf
         eCD2tN6WnAk/KNB3s/wTm1upowGDzzpfvBFPGoVV42FvpzKHgVU/wCuJBxO7ZzsJ0WX4
         /M5A==
X-Gm-Message-State: AJIora/eOiYr6qhOihUMeptRgfrBrIvOyTdmeI5ngRyAHYDigbmtwLC1
        hjpOOEUqmgRUrXS0q3n/oj0=
X-Google-Smtp-Source: AGRyM1s8bondd8Jp4I0QaatBDW4onlA7wRxIJAUprYTmbXa3rVXPggduaz3fc7qDzbNej1zDsCgZEw==
X-Received: by 2002:a65:49c5:0:b0:412:6e3e:bd91 with SMTP id t5-20020a6549c5000000b004126e3ebd91mr20998201pgs.221.1659529791821;
        Wed, 03 Aug 2022 05:29:51 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id g205-20020a6252d6000000b0052d952b3276sm5916311pfb.103.2022.08.03.05.29.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 05:29:51 -0700 (PDT)
Message-ID: <cb631fe5-103d-30f5-d800-4748f4ea41fa@gmail.com>
Date:   Wed, 3 Aug 2022 20:29:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH 1/3] KVM: x86: Refresh PMU after writes to
 MSR_IA32_PERF_CAPABILITIES
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220727233424.2968356-1-seanjc@google.com>
 <20220727233424.2968356-2-seanjc@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20220727233424.2968356-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/7/2022 7:34 am, Sean Christopherson wrote:
> Refresh the PMU if userspace modifies MSR_IA32_PERF_CAPABILITIES.  KVM
> consumes the vCPU's PERF_CAPABILITIES when enumerating PEBS support, but
> relies on CPUID updates to refresh the PMU.  I.e. KVM will do the wrong
> thing if userspace stuffs PERF_CAPABILITIES _after_ setting guest CPUID.
> 
> Opportunistically fix a curly-brace indentation.
> 
> Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")

Shouldn't it be: Fixes: 27461da31089 ("KVM: x86/pmu: Support full width counting") ?

Now, all the dots have been connected. As punishment, I'd like to cook this 
patch set more
with trackable tests so that you have more time for other things that are not 
housekeeping.

Thank you, Sean.

> Cc: Like Xu <like.xu.linux@gmail.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5366f884e9a7..362c538285db 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3543,9 +3543,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   			return 1;
>   
>   		vcpu->arch.perf_capabilities = data;
> -
> +		kvm_pmu_refresh(vcpu);
>   		return 0;
> -		}
> +	}
>   	case MSR_EFER:
>   		return set_efer(vcpu, msr_info);
>   	case MSR_K7_HWCR:
