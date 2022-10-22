Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1593608B0F
	for <lists+kvm@lfdr.de>; Sat, 22 Oct 2022 11:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiJVJZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Oct 2022 05:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJVJYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Oct 2022 05:24:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30D8474E6
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 01:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666427688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ftHTqRJd3ZxuBZu0EHd3NcrA500jUHfUivQrVqD1tIc=;
        b=IPS1wljQRDxXMSGvSboHPQaL/mqEkYHZ61iccCahkldZBXY6NVEckltqaz+T2P1wf46u0O
        52M997wVDZswNdAeS/ceya5hdK+rOSRchGmH/7DfILMlzQIv66C14A+ixU+XsecKLgw2Fs
        HoASs/9mDaeO9H21n80ff1nLoX0W74A=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-27-aE2xoJlFNQi6XFobucXD_w-1; Sat, 22 Oct 2022 04:34:36 -0400
X-MC-Unique: aE2xoJlFNQi6XFobucXD_w-1
Received: by mail-ed1-f69.google.com with SMTP id h9-20020a05640250c900b0045cfb639f56so4842226edb.13
        for <kvm@vger.kernel.org>; Sat, 22 Oct 2022 01:34:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ftHTqRJd3ZxuBZu0EHd3NcrA500jUHfUivQrVqD1tIc=;
        b=SWktSku0KaCWAKZIHZJEduvNzvUZmHXTN6vbcKD2sZRBNnXE2X9qonLj+/zMbL3SWT
         H3zLXsGnuYmU9UJ7MRMW19DKWXgsoJXNp+oMM2dO12xjWskEYGowHhftCmpb41ofjKdZ
         ManPxMIyoktOBYboG8Pm+rC6+zMPI+cqf6H+IL5u+CLQ/08f361GGxCIKBqrRYHxxpW/
         ZYUmxvWx6bhc471UfaomXG4zpU2BMXrcBX38c0ICisQ3LtkN1+sS0yySScVKc0zfi18a
         dE565NlV2HdCEEnOw/pEhrq+jPLO2wwna/khcGXWzkkW/RVrgUhK3yCOFhJejTlGT9ne
         qw+A==
X-Gm-Message-State: ACrzQf3YBtfMzvXdVUSGJuHcNVDQDp6w32TMaosPmrNicHFNH/mZ39rj
        5+bVCFXVKFbOzzt4Awi6azKT6isVrDPQLvViGgbgl+V7Kelaid2BsrkAhZH9h3iKW31B3z8v1Sn
        Xgspu0P2JU55d
X-Received: by 2002:a17:906:cc52:b0:78d:d477:5b7f with SMTP id mm18-20020a170906cc5200b0078dd4775b7fmr19036139ejb.558.1666427675706;
        Sat, 22 Oct 2022 01:34:35 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4DG7u0AHcICnxoiMTC/nadKyO8pd6axcl7z2fu8Mg8khmxymfhzB/iY43sq0/+srS3l3M1ug==
X-Received: by 2002:a17:906:cc52:b0:78d:d477:5b7f with SMTP id mm18-20020a170906cc5200b0078dd4775b7fmr19036125ejb.558.1666427675436;
        Sat, 22 Oct 2022 01:34:35 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:2f4b:62da:3159:e077? ([2001:b07:6468:f312:2f4b:62da:3159:e077])
        by smtp.googlemail.com with ESMTPSA id m11-20020aa7d34b000000b0046182b3ad46sm376198edr.20.2022.10.22.01.34.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Oct 2022 01:34:34 -0700 (PDT)
Message-ID: <bb34193c-0b53-9ff1-e493-ca53819480cd@redhat.com>
Date:   Sat, 22 Oct 2022 10:34:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 6/6] KVM: x86: Mask off reserved bits in CPUID.8000001FH
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        seanjc@google.com
References: <20220929225203.2234702-1-jmattson@google.com>
 <20220929225203.2234702-6-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220929225203.2234702-6-jmattson@google.com>
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

On 9/30/22 00:52, Jim Mattson wrote:
> KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
> actually supports. CPUID.8000001FH:EBX[31:16] are reserved bits and
> should be masked off.
> 
> Fixes: 8765d75329a3 ("KVM: X86: Extend CPUID range to include new leaf")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>   arch/x86/kvm/cpuid.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 576cbcf489ce..58dabc9e54db 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1188,7 +1188,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>   		} else {
>   			cpuid_entry_override(entry, CPUID_8000_001F_EAX);
> -
> +			entry->ebx &= ~GENMASK(31, 16);
>   			/*
>   			 * Enumerate '0' for "PA bits reduction", the adjusted
>   			 * MAXPHYADDR is enumerated directly (see 0x80000008).

I think 15:12 (number of VMPLs supported) should also be masked off 
since KVM does not support SEV-SNP.

Paolo

