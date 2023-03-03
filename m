Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572E56A938C
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 10:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjCCJQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 04:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjCCJQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 04:16:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9E342BD2
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 01:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677834924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LNqEuEiEzWe2jgeg251D+2ct+/tYWoRur835TeYZSMU=;
        b=f0lZoO/YTQyT1e9lg4NGX7cAlboC/Twg72EcSq6wnS/a8w9of+FJO5nUCZFbJfIuxhr5Pc
        /kG/a8hetWTckUzDAfFcxIPljGZS39/j9SkWdZEQ+Ptd9EwkXmSLb8ZgQ8BgqxZtKPSDSV
        s0dXbRlhOTnbnDvWxGwKtsbR2XP0SVw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-4jF2C3qXOcqngUFJFONF-Q-1; Fri, 03 Mar 2023 04:15:23 -0500
X-MC-Unique: 4jF2C3qXOcqngUFJFONF-Q-1
Received: by mail-qv1-f71.google.com with SMTP id ny17-20020a056214399100b00570f687e908so1073481qvb.14
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 01:15:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677834922;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LNqEuEiEzWe2jgeg251D+2ct+/tYWoRur835TeYZSMU=;
        b=zArPbUfC2OrtPXee6WTKiY6PY9TGYWIutO7yBKx/I2DHhpx4emuZHlMkoD/KV9619o
         i4pbbAUtFLn38RW5sVGnK6wX3hWL6S9Geh9Ndq7BI9gwd81oG11W91d7H8/udqCn9aMF
         kiUMRMgY6QiORhZJbcJuFMr+dPp0a/vKII0xYlPEe0NtTBB3BWNTdDJvLIFZwjxdtc6b
         nPCnP6/Q2Mdp7pJwBuLkpFL+5SOl9BQA+mDv661hXu/qH2d+jkpotQWkWbZRhbuKHGtc
         shRosxl+GdtsnznhmkKlTsA4BIiGn9NOChkA4bpyTMyEAyFV7lPvKK4yERRPXjIssSO8
         Yl3Q==
X-Gm-Message-State: AO0yUKW7PZ/zv5KgOiwXGbHy0rra7L1QPWT09KYsWLT3V0Utzffq0EPP
        yXmKGwtnAtaJBbIJmh+WKLXW/OHOhCoo9DrePvZP1HzCPBiEvzfQdGvzrxhXQLUa27KxenxVKrW
        sJGEHU6IIPnkc
X-Received: by 2002:a05:622a:4c7:b0:3bf:be4b:8094 with SMTP id q7-20020a05622a04c700b003bfbe4b8094mr2370070qtx.0.1677834922675;
        Fri, 03 Mar 2023 01:15:22 -0800 (PST)
X-Google-Smtp-Source: AK7set+UeqoMKcIosUwwAvK/fDenT1tjSie9A46dCLMPQhkR6X0C2i0/CIvJ1yTjWhB+gyCFHQ8ZSg==
X-Received: by 2002:a05:622a:4c7:b0:3bf:be4b:8094 with SMTP id q7-20020a05622a04c700b003bfbe4b8094mr2370041qtx.0.1677834922456;
        Fri, 03 Mar 2023 01:15:22 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q28-20020a05620a2a5c00b007422fd3009esm1402815qkp.20.2023.03.03.01.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 01:15:22 -0800 (PST)
Message-ID: <be0df523-188d-d12a-a819-fbcb9b88b31e@redhat.com>
Date:   Fri, 3 Mar 2023 17:15:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
Content-Language: en-US
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
References: <20230301210928.565562-1-ricarkol@google.com>
 <20230301210928.565562-8-ricarkol@google.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230301210928.565562-8-ricarkol@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/2/23 05:09, Ricardo Koller wrote:
> Export kvm_are_all_memslots_empty(). This will be used by a future
> commit when checking before setting a capability.
> 
> No functional change intended.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   include/linux/kvm_host.h | 2 ++
>   virt/kvm/kvm_main.c      | 2 +-
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4f26b244f6d0..8c5530e03a78 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -991,6 +991,8 @@ static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
>   	return RB_EMPTY_ROOT(&slots->gfn_tree);
>   }
>   
> +bool kvm_are_all_memslots_empty(struct kvm *kvm);
> +
>   #define kvm_for_each_memslot(memslot, bkt, slots)			      \
>   	hash_for_each(slots->id_hash, bkt, memslot, id_node[slots->node_idx]) \
>   		if (WARN_ON_ONCE(!memslot->npages)) {			      \
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9c60384b5ae0..3940d2467e1b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4604,7 +4604,7 @@ int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   	return -EINVAL;
>   }
>   
> -static bool kvm_are_all_memslots_empty(struct kvm *kvm)
> +bool kvm_are_all_memslots_empty(struct kvm *kvm)
>   {
>   	int i;
>   

-- 
Shaoqin

