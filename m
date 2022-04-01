Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9FC4EEC48
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345427AbiDALZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343620AbiDALZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:25:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6799B5132A
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648812196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wbnHJsOa3OkhhmPzC8CDbVMXsKDpOLdvf6K+TgYYTfU=;
        b=PtHbBzSLf82awvwIStyQyLBsKW2xhas95xJp8LeWlC142mIxvi3ns6kXXub7RNhHyFNztA
        DpkT57eAJc+QspTmDEwhVPZJoAJM9wrRxQNNQdePXzR/ReIrrN3eJ6yM73RITbRmjaA+Ng
        5XKyL0bxWH/uJHhEmoP1+IkD6/aFnbw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-E9Ro5wUWOPaVdMcbx8lnmQ-1; Fri, 01 Apr 2022 07:23:15 -0400
X-MC-Unique: E9Ro5wUWOPaVdMcbx8lnmQ-1
Received: by mail-ej1-f71.google.com with SMTP id m12-20020a1709062acc00b006cfc98179e2so1423381eje.6
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 04:23:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wbnHJsOa3OkhhmPzC8CDbVMXsKDpOLdvf6K+TgYYTfU=;
        b=5Y9ggjag9vf00f2wJ+JsQ+TpVG0jNE4MjWp4ZZDfPP4QHcOmMU3DKs4l+nPUVNFEV9
         XJH/OCaRDFtEk/+mdKa6mQpYKuqJ9prZkl4SZYfNouwQIXfWzjbll4sIQlutsFZMI2Bf
         Jj4d82EKTzwYWHvkbgbspvhH6QdSAcr+TD3/5AGRfZH2hGPEZInIycq8QfNayrQ5/No5
         idra2/NW2mW+twxZAWwRDz0qJhonKJjO5NO6cdPkWta7xDwIu0PZYXxcb2RWGN1Y/jDu
         YbXNIG/Pl9ZJGCLsf0J5V0mF3oM0BwJM3EFNCtuL4Caw97cktV0oAmM+y7AVarzEx/Ci
         FcjQ==
X-Gm-Message-State: AOAM533cNIpxYIU4GZTc0xJ7KMTcl8T3eerR1OI6PUehXr1GtJLBuoEQ
        Lgg3k/BSmqUhvoK11TB7DiuubqrCJxkjevgPC0Y9ck2Gp49MLaKaTXQKfRw8Gwlr2i3ZhlQKHlW
        0XNCNsXJ5yrTi
X-Received: by 2002:a17:907:1c0a:b0:6da:7ac4:5349 with SMTP id nc10-20020a1709071c0a00b006da7ac45349mr8826150ejc.596.1648812193890;
        Fri, 01 Apr 2022 04:23:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcxHDVJnHI1X2NEbHLMJMiwFe+hcsJR5WLhis7f05d2t0gZ2OJ0wwpuxMsndWuIBwu+J+pHw==
X-Received: by 2002:a17:907:1c0a:b0:6da:7ac4:5349 with SMTP id nc10-20020a1709071c0a00b006da7ac45349mr8826131ejc.596.1648812193567;
        Fri, 01 Apr 2022 04:23:13 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:8ca6:a836:a237:fed1? ([2001:b07:6468:f312:8ca6:a836:a237:fed1])
        by smtp.googlemail.com with ESMTPSA id bn14-20020a170906c0ce00b006c5ef0494besm928096ejb.86.2022.04.01.04.23.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 04:23:12 -0700 (PDT)
Message-ID: <1b262351-c56a-9c85-6038-d23a425b34f0@redhat.com>
Date:   Fri, 1 Apr 2022 13:23:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH -next] KVM: x86/mmu: Fix return value check in
 kvm_mmu_init_tdp_mmu()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220401071531.1841927-1-yangyingliang@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220401071531.1841927-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/1/22 09:15, Yang Yingliang wrote:
> If alloc_workqueue() fails, it returns NULL pointer, replaces
> IS_ERR() check with NULL pointer check.
> 
> Fixes: 1a3320dd2939 ("KVM: MMU: propagate alloc_workqueue failure")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index a2f9a34a0168..7bddbb51033a 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -22,8 +22,8 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
>   		return 0;
>   
>   	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
> -	if (IS_ERR(wq))
> -		return PTR_ERR(wq);
> +	if (!wq)
> +		return -ENOMEM;
>   
>   	/* This should not be changed for the lifetime of the VM. */
>   	kvm->arch.tdp_mmu_enabled = true;

Sent already by Dan Carpenter, thanks though!

Paolo

