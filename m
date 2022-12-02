Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61492640DD4
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbiLBSvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbiLBSvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:51:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181D8E2AA3
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 10:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670007040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CSWTn6gYmgD96vxWDsZinDIC3fAz6H3F+3zJlICbnLw=;
        b=fSGEm6JQ/IqRrGJA7s9QOQYLJ0QPIZ4oBb6BwBIoLTWrNkyLy49BqaP3iD2S9bRHz7OUdt
        OJAHAnFSmoRSnqc7Dylvxh2mPa4NtclUTWJkv91nkyyG9wFSXOoEiTDxTvfylLGXx1Dx0q
        veSaxyV7eoOvv6nnmXevlA5zbou6ZaM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-480-Xy8UZOBVP-uogFV3pAgS_Q-1; Fri, 02 Dec 2022 13:50:31 -0500
X-MC-Unique: Xy8UZOBVP-uogFV3pAgS_Q-1
Received: by mail-wm1-f70.google.com with SMTP id j2-20020a05600c1c0200b003cf7397fc9bso2901653wms.5
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 10:50:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CSWTn6gYmgD96vxWDsZinDIC3fAz6H3F+3zJlICbnLw=;
        b=dT+aGbu8NAMdHuiPMSeXwKAoa8IZwI8Zdv+5IvenY/j/fbygUckROivSiWFnn1Iqw1
         ReHhuSjZgJ1x5ofbYxCWsQOzZd5HpCksmOB6t9GH+uzwr3tJlhSAkyJkNXWMmL3IyrHj
         8YN2suylR5oFoH66AMd6TAcX9SWWtqO4BLOGX/fjeZnaxRqJpzAI5DszPGCicsDMHU4B
         S+7fdMbnW1AAqaL/nF4okKHyzAl+U66ik48YN6QDGKUTkeox/McI7INMKjxEdA8AF6s4
         lVu4Cud0Bean67xkTKJAnzVDUsz2MNVo5gxiXijFUhD4HYCWCk5eIVnrbMCZ1E0ODmGv
         2IkQ==
X-Gm-Message-State: ANoB5pkF53WUQCnPFlSaMr6vhd2YNAPS5OLMkMeIqA0v1kN5SFFfYT8L
        93MTF+XnKLQuvYJXHeub874gp1kAz548xJEWJQswX5ATEAkGSrkb+oyqGS4LwDgLM0mlRd2e80e
        7pPOSPkRUCWjD
X-Received: by 2002:a5d:5684:0:b0:236:61bb:c79d with SMTP id f4-20020a5d5684000000b0023661bbc79dmr43659183wrv.632.1670007030464;
        Fri, 02 Dec 2022 10:50:30 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7MWUXsG5BQtnXTGjOz4QH7kSZvAwN8PFHUW3Nha4FcUmOhkvLbyMcpph0KxVareqwKTI3tvQ==
X-Received: by 2002:a5d:5684:0:b0:236:61bb:c79d with SMTP id f4-20020a5d5684000000b0023661bbc79dmr43659177wrv.632.1670007030246;
        Fri, 02 Dec 2022 10:50:30 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id q128-20020a1c4386000000b003c71358a42dsm17852654wma.18.2022.12.02.10.50.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 10:50:29 -0800 (PST)
Message-ID: <bf1d172f-df7c-844c-587e-cfedd82e509b@redhat.com>
Date:   Fri, 2 Dec 2022 19:50:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] KVM: x86: Advertise that the SMM_CTL MSR is not supported
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        seanjc@google.com
References: <20221007221644.138355-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221007221644.138355-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/8/22 00:16, Jim Mattson wrote:
> CPUID.80000021H:EAX[bit 9] indicates that the SMM_CTL MSR (0xc0010116)
> is not supported. This defeature can be advertised by
> KVM_GET_SUPPORTED_CPUID regardless of whether or not the host
> enumerates it.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/kvm/cpuid.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 2796dde06302..b748fac2ae37 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1199,8 +1199,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		 * Other defined bits are for MSRs that KVM does not expose:
>   		 *   EAX      3      SPCL, SMM page configuration lock
>   		 *   EAX      13     PCMSR, Prefetch control MSR
> +		 *
> +		 * KVM doesn't support SMM_CTL.
> +		 *   EAX       9     SMM_CTL MSR is not supported
>   		 */
>   		entry->eax &= BIT(0) | BIT(2) | BIT(6);
> +		entry->eax |= BIT(9);
>   		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
>   			entry->eax |= BIT(2);
>   		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))

Queued, thanks.  Negative features suck, though.

Paolo

