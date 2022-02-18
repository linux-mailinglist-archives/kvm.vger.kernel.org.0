Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0BA4BB45B
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 09:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbiBRIgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 03:36:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiBRIgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 03:36:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 67B59DF
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 00:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645173394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GUYAMChQnr7NjIKimTXpIFqJfe1vOQA2h3JNoQ6L42U=;
        b=hEXGH0t/3gDLGlDQ5WdO+ICchfsRe/fQgiyQYAdQ3BA5ZvBnQXLypncQBgWZpv8+oDgI94
        3QHaPXdC/lSF+Cr6/NaXs23voBEGge/LkJl1TuYrcyY16vlvvN3t6uUasVjU/GRAnWJJ5b
        AuHf1YA5SgUZJ9ikFoTbQoZKl+T1vrg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-RsRSSxY4NHukOJ-W3JeXxA-1; Fri, 18 Feb 2022 03:36:32 -0500
X-MC-Unique: RsRSSxY4NHukOJ-W3JeXxA-1
Received: by mail-ej1-f70.google.com with SMTP id m12-20020a1709062acc00b006cfc98179e2so2715151eje.6
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 00:36:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GUYAMChQnr7NjIKimTXpIFqJfe1vOQA2h3JNoQ6L42U=;
        b=NMBwLGeBdED1qjOxXH9d7KtfZVIeB04sH8THpdj+iXmu0V1jcK5bn+t/pqFbzz8RU5
         z6LX5fu9iePI8EPVK0FTI6ys0hqajixqHADuBMuuVCp6DjAGTn3XFFZvkofS/a7YwMhR
         9LcqlxVbB7VZICQ31Rx47FbHa9TCZBgkD5EX79edC0OL2aktFOtJcsGzl8eyaL9q3CoV
         KuptQNO1hytj3DEXRg1nfnATwv9cbvz1cQ7jAou6P0G1AyxXTO4tm7x0fr4aDAHbRXeX
         u/gLX+m8qXvFcV77qhuojtGOHHw3MBMSz8b8aqvTB4V/Ero9hIi5HtQKkvg68LkjC/3J
         LzFw==
X-Gm-Message-State: AOAM532pRPzDWgf7AQDHFajL7ZbUx6htoE0bvR1zc/UjB2/2IOow5lOo
        EICOGOWi1MGALxhFy5hh5Moh6kwRij+JaS1tLoie6XB8i+j4TgD6eizzLemEO8Itwvbum6yI1A6
        DFOs9bo9olMsk
X-Received: by 2002:a50:f686:0:b0:410:e352:e61a with SMTP id d6-20020a50f686000000b00410e352e61amr6735037edn.23.1645173391093;
        Fri, 18 Feb 2022 00:36:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwv2GBWHoOO6U68X+l3CctjTjPD3v/baV4DG8azWxKxG3mZ39eIIGUYse3GmgMzjknk4tnCcw==
X-Received: by 2002:a50:f686:0:b0:410:e352:e61a with SMTP id d6-20020a50f686000000b00410e352e61amr6735018edn.23.1645173390833;
        Fri, 18 Feb 2022 00:36:30 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id b19sm852442edd.91.2022.02.18.00.36.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 00:36:30 -0800 (PST)
Message-ID: <60c796c5-9a24-8e2a-b417-f0d7259029b2@redhat.com>
Date:   Fri, 18 Feb 2022 09:36:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] x86/kvm: Don't use pv tlb/ipi/sched_yield if on 1 vCPU
Content-Language: en-US
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1645171838-2855-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1645171838-2855-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/22 09:10, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Inspired by commit 3553ae5690a (x86/kvm: Don't use pvqspinlock code if
> only 1 vCPU), on a VM with only 1 vCPU, there is no need to enable
> pv tlb/ipi/sched_yield and we can save the memory for __pv_cpu_mask.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>   arch/x86/kernel/kvm.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index a438217cbfac..f734e3b0cfec 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -462,19 +462,22 @@ static bool pv_tlb_flush_supported(void)
>   {
>   	return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
>   		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> -		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
> +		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
> +		(num_possible_cpus() != 1));
>   }
>   
>   static bool pv_ipi_supported(void)
>   {
> -	return kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI);
> +	return (kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI) &&
> +	       (num_possible_cpus() != 1));
>   }
>   
>   static bool pv_sched_yield_supported(void)
>   {
>   	return (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
>   		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
> -	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
> +	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
> +	    (num_possible_cpus() != 1));
>   }
>   
>   #define KVM_IPI_CLUSTER_SIZE	(2 * BITS_PER_LONG)

Queued, thanks.

Paolo

