Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960F872615F
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 15:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240829AbjFGNfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 09:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240670AbjFGNfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 09:35:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAA119BF
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 06:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686144872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8d8TRLKrvahE1yaTmwWJvhbmr3vvIcSEYzLsqgk0JUs=;
        b=Ag24cF1G/XOFsz0E0rso2B5Hb39V7+FG+dLGqcUCv/H5B8789YhH4nd44+ZbeOmaps69Km
        ZSouhWCpqrH45C8F5NophdHOFkEoEhDFxXfmPVFe2bskKwpTKlxOu3EU3dlUvauLgNadhs
        nBkoPX3vcWpAVD7Z97mdPbwdALapVNI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-iqGOYJfaMPi5kD79HRRR7A-1; Wed, 07 Jun 2023 09:34:31 -0400
X-MC-Unique: iqGOYJfaMPi5kD79HRRR7A-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-626187749a6so102906066d6.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 06:34:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686144871; x=1688736871;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8d8TRLKrvahE1yaTmwWJvhbmr3vvIcSEYzLsqgk0JUs=;
        b=UkXm78jWA1M+rxrYPGaYD/iV4xLFhbOQ2rYfv1ZtQlAVZzxJdIi/bS0XNFuHZFZJs4
         cD44O0wxIhH4B0rYMg867N6eAfN7pH0eB1in0LiVF3hM5cPxdzoR9oSITgBKOC8vvtV8
         UbbaH58Mf/cp8cCoDUo2uRwbarRYg0eLkoi1D+jP0FnzRbQbLqqkcNsLtNzDgnS2XQQD
         Cs8ZpWRPwT9KhWmQSXh9WdSHMJ94GC8J//HnGdCqsEM7z9kjv3fnZKSrTAxgO3dy+VZd
         fpEWh+u6rY7hsXsqG6PnGTukkOSYo7McVhmIdKuF3QqG1PEWdWVYxWCmb0xfkDR+N143
         +Z6A==
X-Gm-Message-State: AC+VfDysFpwDDoK4wUiqIdr1QcN2sNAwqaNQH801t9vQXR1i+rx7bWb1
        mCVXB+vUo+4tr7EptESUW7hZqURQxHV2F5jlUOGDSeWH+JnHIy9B9TztAwwGisnGghj9e6EWLBc
        19BUCGnAKslgi
X-Received: by 2002:a05:6214:20a2:b0:626:e55:dfaf with SMTP id 2-20020a05621420a200b006260e55dfafmr2411407qvd.40.1686144871042;
        Wed, 07 Jun 2023 06:34:31 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7nR3AaE0ywuMUz33lsHi7Gu410ESYRxtm032yi7NL7dqbaquN8NVpm6MdCjvSbofWfe/YZFQ==
X-Received: by 2002:a05:6214:20a2:b0:626:e55:dfaf with SMTP id 2-20020a05621420a200b006260e55dfafmr2411394qvd.40.1686144870815;
        Wed, 07 Jun 2023 06:34:30 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id v12-20020a0ccd8c000000b006261c80d76dsm6089093qvm.71.2023.06.07.06.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 06:34:29 -0700 (PDT)
Message-ID: <2280733a-85d1-2cd9-9c77-7d0c90a5c63d@redhat.com>
Date:   Wed, 7 Jun 2023 15:34:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 3/3] vfio/fsl: Create Kconfig sub-menu
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     jgg@nvidia.com, clg@redhat.com, diana.craciun@oss.nxp.com
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
 <20230602213315.2521442-4-alex.williamson@redhat.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20230602213315.2521442-4-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 6/2/23 23:33, Alex Williamson wrote:
> For consistency with pci and platform, push the vfio-fsl-mc option into a
> sub-menu.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/fsl-mc/Kconfig | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
> index 597d338c5c8a..d2757a1114aa 100644
> --- a/drivers/vfio/fsl-mc/Kconfig
> +++ b/drivers/vfio/fsl-mc/Kconfig
> @@ -1,3 +1,5 @@
> +menu "VFIO support for FSL_MC bus devices"
> +
>  config VFIO_FSL_MC
>  	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
>  	depends on FSL_MC_BUS
> @@ -8,3 +10,5 @@ config VFIO_FSL_MC
>  	  fsl-mc bus devices using the VFIO framework.
>  
>  	  If you don't know what to do here, say N.
> +
> +endmenu
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

