Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B685EA883
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 16:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiIZOfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 10:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234762AbiIZOel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 10:34:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12AC85A81
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 05:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664196792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dZnzkSPkrJhMkyrPYaJDC4tJIosUyBPmaHd/A+YN8Ro=;
        b=BPygqRJd6MmuKpJgrgecIzWd4YOBVhN1ULwrL+8U8qvBO4AWsTP6qz/yyy7A9aWdF9QmfU
        MomvMfIl7MbiH06zpomHsDgpgxSC9uG3FQtmXVnFgjgyzCMMOYmKgv7hCDorXhwLcfKNaR
        aqmzLeP6lC46KvmGqhy8tC6dikbqE9c=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-544-IXSBde-jNI6a5lNkFwnDOg-1; Mon, 26 Sep 2022 08:53:10 -0400
X-MC-Unique: IXSBde-jNI6a5lNkFwnDOg-1
Received: by mail-wr1-f72.google.com with SMTP id x1-20020adfbb41000000b0022b113add45so1146801wrg.10
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 05:53:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=dZnzkSPkrJhMkyrPYaJDC4tJIosUyBPmaHd/A+YN8Ro=;
        b=l3LbLcozmqmk5rClzm0sSXTK00vaXkh3yJwnq+KJIRo21ZcnTO4x5sy7u7DLN4EMnF
         UFl293HHuj9DysdvWAHO839NVHPf0KqicOKBU9cRw9GxUW/DY7/WMiqPzI6ZyP0z8/eC
         tNhvdw/ajwOSP9HpBRkzKNWgpIjnOxehtg9zpwVc/2ht197mKpcGw7T3K3vSnbDjyvtn
         S7890nXV5bLOfb9oaCjC5SoH8on/dXWEwWJGmxuIHKvgJl/Lrf5F7iwval+BMvd/2HYl
         t1NnaQCqVZOUXJtDBs1LniWkv3FEzP/EALjzpmNpL9AyHhW79WkfcnPIzhJeqifyv1O2
         xFNA==
X-Gm-Message-State: ACrzQf2EwECF/pn/bEFvbmeUx4ilRADfEpREJZU1ScVOPcdKCXtUqMBR
        JYiM4u6u8Gu2+AG/oCcd99eS67xXYqGSwiIV2tvZNcgsO+5HkxAY7dgb0LW7RYnuRLOgg5uGAVf
        OA/+xOoe8+s6U
X-Received: by 2002:a5d:584d:0:b0:22b:229:7582 with SMTP id i13-20020a5d584d000000b0022b02297582mr13692747wrf.211.1664196789852;
        Mon, 26 Sep 2022 05:53:09 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6OQZe0Iibwn3qepP2lrKsEYROWRa0JJtctdj+1K8JGXD02l/2/KS+bqh9+e3+0Hw1xBDWGaQ==
X-Received: by 2002:a5d:584d:0:b0:22b:229:7582 with SMTP id i13-20020a5d584d000000b0022b02297582mr13692725wrf.211.1664196789608;
        Mon, 26 Sep 2022 05:53:09 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-177-251.web.vodafone.de. [109.43.177.251])
        by smtp.gmail.com with ESMTPSA id l39-20020a05600c1d2700b003b50428cf66sm12102270wms.33.2022.09.26.05.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 05:53:09 -0700 (PDT)
Message-ID: <597a2761-f718-4a2c-c012-a0d25bf3c7fb@redhat.com>
Date:   Mon, 26 Sep 2022 14:53:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v8 1/8] linux-headers: update to 6.0-rc3
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org,
        richard.henderson@linaro.org,
        Peter Maydell <peter.maydell@linaro.org>,
        "Daniel P. Berrange" <berrange@redhat.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
References: <20220902172737.170349-1-mjrosato@linux.ibm.com>
 <20220902172737.170349-2-mjrosato@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220902172737.170349-2-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/09/2022 19.27, Matthew Rosato wrote:
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
...
> diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
> index bf6e96011d..46de10a809 100644
> --- a/linux-headers/asm-x86/kvm.h
> +++ b/linux-headers/asm-x86/kvm.h
> @@ -198,13 +198,13 @@ struct kvm_msrs {
>   	__u32 nmsrs; /* number of msrs in entries */
>   	__u32 pad;
>   
> -	struct kvm_msr_entry entries[0];
> +	struct kvm_msr_entry entries[];
>   };

Yuck, this fails to compile with Clang:

  https://gitlab.com/thuth/qemu/-/jobs/3084427423#L2206

  ../target/i386/kvm/kvm.c:470:25: error: field 'info' with variable sized 
type 'struct kvm_msrs' not at the end of a struct or class is a GNU 
extension [-Werror,-Wgnu-variable-sized-type-not-at-end]
         struct kvm_msrs info;
                         ^

Anybody any ideas how to fix this best? Simply disable the compiler warning 
in QEMU?

  Thomas

