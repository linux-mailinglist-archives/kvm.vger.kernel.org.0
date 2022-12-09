Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07242647ED9
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 08:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiLIH7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 02:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiLIH7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 02:59:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1D92181D
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 23:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670572688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kJkxtEofXGhCe4VQkQjFhh7s3+3iK2GsHQU4hYy6IGE=;
        b=imcb4oNFTEc9eoZcyLxyOPxZcexRd90dv4R3WzVo/8vwVjxn/96CUibLSQ6neN6mvN8Ila
        8K7ULUDApjpBJMqPF+bW7DplBYkoc4xpV4vvhUYKGkwCV+kLtwIE8ZXF6GNGQF9zzeHvCL
        ILj4nhhdpNC+YDJMbm1dnhVxJcArJcU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-615-OSs4Bi1GOjSYNk2YibyP2g-1; Fri, 09 Dec 2022 02:58:07 -0500
X-MC-Unique: OSs4Bi1GOjSYNk2YibyP2g-1
Received: by mail-ed1-f71.google.com with SMTP id m18-20020a056402511200b0046db14dc1c9so913136edd.10
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 23:58:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kJkxtEofXGhCe4VQkQjFhh7s3+3iK2GsHQU4hYy6IGE=;
        b=NISGm/LqDDTjZCWAW/ZzgrlTK3qFQXkchFL4L6i7LVhzqospHBjR1+/ilrTIdixtJT
         R/YcP7hPjjcjnqxWqi4WK5wKMUGkQlpLZDCLIEdMJ5Habzr71wdSLhWo8kraJY8k446D
         XMYyE3BnDNlwHQC9wrEoZRKJb9U8dzORVySNmBCuCQUAGx5bQxpQY1ZcmJrcahGVX/lV
         MtkUGAIKJ/ZZn02Tqx8fQzLXRsuIrHHiOIeJlVx+U9R4fJ3h0Eqz0OXN3vRLmK9qSPTl
         ODPpjiL63Q/0YdoOPMWDlXrIFvkdsjY7mUMOfdLoJwqosu6h4zFBCxAVQJPWejGTpWVZ
         Otlw==
X-Gm-Message-State: ANoB5plP6QCkDpNbqxUjNPOoN45l9T3wKAy2Se2ltvr3bPrNqckKy58d
        tVEySFWm4FFrMu2kwUyBrJXYfj9vX2INgnwlfWplm6tXRO1SINd3AyBrqiyYVWAuzsQGfmhWOEO
        wFPob8zp0iI9U
X-Received: by 2002:a17:906:524f:b0:7bf:f0e9:4edc with SMTP id y15-20020a170906524f00b007bff0e94edcmr4086486ejm.31.1670572685992;
        Thu, 08 Dec 2022 23:58:05 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6i0TQ3Xhw65UIRvHVMmUoAAjbduI+KKQncw1NJRxCSd3w+/VfgIaqmJAowxyPwR81ecO3bwQ==
X-Received: by 2002:a17:906:524f:b0:7bf:f0e9:4edc with SMTP id y15-20020a170906524f00b007bff0e94edcmr4086476ejm.31.1670572685632;
        Thu, 08 Dec 2022 23:58:05 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:e3ec:5559:7c5c:1928? ([2001:b07:6468:f312:e3ec:5559:7c5c:1928])
        by smtp.googlemail.com with ESMTPSA id r2-20020a17090609c200b007bc3a621224sm245953eje.196.2022.12.08.23.58.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 23:58:05 -0800 (PST)
Message-ID: <c958aa5a-1bd2-7f81-0f20-fd3a42393528@redhat.com>
Date:   Fri, 9 Dec 2022 08:58:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] kvm: Remove the unused macro KVM_MMU_READ_LOCK()
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>, kvm@vger.kernel.org
References: <20221207120617.9409-1-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221207120617.9409-1-jiangshanlai@gmail.com>
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

On 12/7/22 13:06, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> No code is using KVM_MMU_READ_LOCK().

And KVM_MMU_READ_UNLOCK() is also unused.

Paolo

> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>   virt/kvm/kvm_mm.h | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
> index a1ab15006af3..e98e294080bf 100644
> --- a/virt/kvm/kvm_mm.h
> +++ b/virt/kvm/kvm_mm.h
> @@ -14,13 +14,11 @@
>   #define KVM_MMU_LOCK_INIT(kvm)		rwlock_init(&(kvm)->mmu_lock)
>   #define KVM_MMU_LOCK(kvm)		write_lock(&(kvm)->mmu_lock)
>   #define KVM_MMU_UNLOCK(kvm)		write_unlock(&(kvm)->mmu_lock)
> -#define KVM_MMU_READ_LOCK(kvm)		read_lock(&(kvm)->mmu_lock)
>   #define KVM_MMU_READ_UNLOCK(kvm)	read_unlock(&(kvm)->mmu_lock)
>   #else
>   #define KVM_MMU_LOCK_INIT(kvm)		spin_lock_init(&(kvm)->mmu_lock)
>   #define KVM_MMU_LOCK(kvm)		spin_lock(&(kvm)->mmu_lock)
>   #define KVM_MMU_UNLOCK(kvm)		spin_unlock(&(kvm)->mmu_lock)
> -#define KVM_MMU_READ_LOCK(kvm)		spin_lock(&(kvm)->mmu_lock)
>   #define KVM_MMU_READ_UNLOCK(kvm)	spin_unlock(&(kvm)->mmu_lock)
>   #endif /* KVM_HAVE_MMU_RWLOCK */
>   

