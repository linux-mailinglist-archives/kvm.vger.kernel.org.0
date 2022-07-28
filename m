Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9C7583E3B
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 14:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237566AbiG1MDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 08:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235664AbiG1MDE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 08:03:04 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8998C67151;
        Thu, 28 Jul 2022 05:03:03 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c3so1725019pfb.13;
        Thu, 28 Jul 2022 05:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6nvKbT9kndzSOUcfK+zc9MvubXEZk6miyWHNHn+5OxY=;
        b=f1YeSeTjLcomvltM6VYE8CROdkCKG4NTbFMbj45rMThgoM6sGFv8czsgRRZfgd1WKt
         f/08GfGCfpugkNkzhZUBer6T79p1kpE4c4DXPGSZNsCf2T0QJ2VCkuWLqJo0ziYiPCDz
         GvwVufYfxqJRU595/YjWWArmjF9unlseUWacHYEBZmo13XHJxCJ6tuyGAbG65R+7HwNr
         uo2WTpmy2euBKPbcYPy28keUFAt/3oP9OJ1JFjEoaHfZYfyWUBB8/FpBtlv3XNF1hiO5
         3uFGN7/p7PfTIf+xlNLn/R9PWIus6jG9WetHyv8CdccXU0FfYs4GlnzKyd9hXY1rfNE5
         AbFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6nvKbT9kndzSOUcfK+zc9MvubXEZk6miyWHNHn+5OxY=;
        b=C0+fM6FK8o5hemvJkcpS2lrO5toy6iD96j0HqQ8WkWxPt9uURaZ3e1FTOnTQNUZHiW
         AHThJpUB+bnrRlCP3cYGy2ZyIhk74ycZt8UwNZruQwi0a21vhPa2R/q0paSQDHyCQvf2
         +sy/AMU/XMT6GXozQNcha5PeVFBWkH9QTIrVxsYQlMe3amfMQTeix4gtPOlmF0qbOmtn
         DsBCz05bCQhNnUF1ltKZlWfuMgmI11N2kv2qVr37/n6W4kkLupxsPqJPb5pZDc3nOU9U
         PpSLjqIGPb38DNtl/ODGv+aIN+b/Wan37CvU6X7INknrn5HIXPJh05l6QEhmlJKLvq+i
         C/aA==
X-Gm-Message-State: AJIora+brUw6vrhrPJaqsfjwnUsWGbrqp1qUPWUq72jJvJS21GEY5AOl
        qmWX6IvQugzoLdizGHPqvdbjK0Ghn5oOlw==
X-Google-Smtp-Source: AGRyM1ufvExeCGCzYxqGycF0uLOFYtynrFUL0MSe6SOxjvtAeuwZiJkNue2cpzf3SNcK4og20Lnzyg==
X-Received: by 2002:a65:6494:0:b0:419:9527:2a69 with SMTP id e20-20020a656494000000b0041995272a69mr22789010pgv.80.1659009782991;
        Thu, 28 Jul 2022 05:03:02 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902a3cc00b0016397da033csm1108413plb.62.2022.07.28.05.03.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 05:03:02 -0700 (PDT)
Message-ID: <271bddfa-9e48-d5f6-6147-af346d7946bf@gmail.com>
Date:   Thu, 28 Jul 2022 20:02:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH 1/3] KVM: x86: Refresh PMU after writes to
 MSR_IA32_PERF_CAPABILITIES
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Unwise userspace should reap its consequences if it does not break KVM or host.

When a guest feature can be defined/controlled by multiple KVM APIs entries,
(such as SET_CPUID2, msr_feature, KVM_CAP, module_para), should KVM
define the priority of these APIs (e.g. whether they can override each other) ?

Removing this ambiguity ensures consistency in the architecture and behavior of 
all KVM features.
Any further performance optimizations can be based on these finalized values as 
you do.

> 
> Opportunistically fix a curly-brace indentation.
> 
> Fixes: c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS")
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

I had proposed this diff but was met with silence.

>   		return 0;
> -		}
> +	}
>   	case MSR_EFER:
>   		return set_efer(vcpu, msr_info);
>   	case MSR_K7_HWCR:
