Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C40617E1D
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 14:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiKCNkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 09:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbiKCNkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 09:40:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A02E21B1
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 06:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667482767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r7Jfz/F/6Y5sBizojKqCLhfDWCKyK0PcIAb1Yu8ed1g=;
        b=fEg8pjSp9ZFiWeVImAo27oJkbY1O/PDdkiLnbnSF2Ao8Nnr8ouMSqctMGBS+06hdMobCen
        eio2XoNK5rEpVtMkY3tA9Jzlu2VBeG/gQzhpE6bBqKBVic+7B/c/S8cwqP1Aoi6jhesMNO
        FSjuh0yXKNynaKrpHvEgaridvGWNYLA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-352-RKqySj2XMiSJBhPA5OnI5Q-1; Thu, 03 Nov 2022 09:39:26 -0400
X-MC-Unique: RKqySj2XMiSJBhPA5OnI5Q-1
Received: by mail-ed1-f71.google.com with SMTP id z9-20020a05640235c900b0046358415c4fso1398958edc.9
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 06:39:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r7Jfz/F/6Y5sBizojKqCLhfDWCKyK0PcIAb1Yu8ed1g=;
        b=uwYaL/vKRJLa7El4HdQT9z5h9w40WaKYbmeSzu7Qi2Mrw+lA8yxpwFF8BhhQyvlGMq
         t1ADYg2LYbfv6KQmmhbBX6RZwBotwEkXFpPFZ2HuDRJIuguCmMsVUlrEa3IA8DHecsmY
         zPN4uE+QoPIrfbX3hachnU7oeGjcMQXiF7KPOCblcTxpffLio7Rzz+FT3VxYO9TDxBoH
         T/vTtuvX3+BjDbGHuWkR4g1WLoiQ+FwVuS5Yn/Ifvt1AoLhn1m9Ek+ezNcuZAHQ1FT/f
         5LsB1l8D4gE/wFmtjWHuKCke6fnc6dgaECjQgTkPe6VMJXxEZWJuysWuCWzBfKMbraq2
         LJ4w==
X-Gm-Message-State: ACrzQf0Sv5a+g8GoJ8j08sqD9VIYltmt0FPsONDRfQ79biMXEcC18TW9
        Y7SiC/7m/bP4xfotWYWnsheNLVPEt9JhPRFfI67fvj5W/r/5jQe1JCESxj6OzS5Tgb6cQ4Ig9Ks
        Q/foVhUrk9tN7
X-Received: by 2002:a17:907:74a:b0:77e:9455:b4e1 with SMTP id xc10-20020a170907074a00b0077e9455b4e1mr28955291ejb.462.1667482763216;
        Thu, 03 Nov 2022 06:39:23 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM42qH/DeqlviMC5JnBlEig6wTRXuvyniHiTtzvoXqf66RRHr9aDzIoWq9jMNl4pZiDlE3EnhQ==
X-Received: by 2002:a17:907:74a:b0:77e:9455:b4e1 with SMTP id xc10-20020a170907074a00b0077e9455b4e1mr28955268ejb.462.1667482762994;
        Thu, 03 Nov 2022 06:39:22 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id 1-20020a170906210100b007317f017e64sm499755ejt.134.2022.11.03.06.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 06:39:22 -0700 (PDT)
Message-ID: <5374345c-7973-6a3c-d559-73bf4ac15079@redhat.com>
Date:   Thu, 3 Nov 2022 14:39:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 2/2] KVM: x86: Fix a typo about the usage of kvcalloc()
Content-Language: en-US
To:     Liao Chang <liaochang1@huawei.com>, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>
References: <20221103011749.139262-1-liaochang1@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221103011749.139262-1-liaochang1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/22 02:17, Liao Chang wrote:
> Swap the 1st and 2nd arguments to be consistent with the usage of
> kvcalloc().
> 
> Fixes: c9b8fecddb5b ("KVM: use kvcalloc for array allocations")
> Signed-off-by: Liao Chang<liaochang1@huawei.com>
> ---
>   arch/x86/kvm/cpuid.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 7065462378e2..b33c18b142c2 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1331,7 +1331,7 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>   	if (sanity_check_entries(entries, cpuid->nent, type))
>   		return -EINVAL;
>   
> -	array.entries = kvcalloc(sizeof(struct kvm_cpuid_entry2), cpuid->nent, GFP_KERNEL);
> +	array.entries = kvcalloc(cpuid->nent, sizeof(struct kvm_cpuid_entry2), GFP_KERNEL);
>   	if (!array.entries)
>   		return -ENOMEM;
>   

It doesn't make any difference, but scripts/checkpatch.pl checks it so
let's fix the sole occurrence in KVM.

However, please send a patch to scripts/checkpatch.pl to include calloc(),
kvmalloc_array and kvcalloc() in the matched functions:

# check for alloc argument mismatch
                 if ($line =~ /\b((?:devm_)?(?:kcalloc|kmalloc_array))\s*\(\s*sizeof\b/) {
                         WARN("ALLOC_ARRAY_ARGS",
                              "$1 uses number as first arg, sizeof is generally wrong\n" . $herecurr);
                 }


Paolo

