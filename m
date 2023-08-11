Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCBD7792CA
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 17:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbjHKPTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 11:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236314AbjHKPTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 11:19:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FAD3A87
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 08:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691767099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5jvk9gOBrnZNGwTR3Eif+kJzbn0hYBEZnzfA7q6zH3g=;
        b=T37hwenUB71khBfk3R4xOd5hQxIHh9/A5XyYJHcm1YZaCzksuDgQ+DQQl1J9/N72ZT1Bjt
        QvHrl0lIDAHjeBopfsXrNVsvKnCJgUEflpy+3MXtUh139bZpF/8C1nLiaJEb9WA6FwZ/+u
        FRMWWmYikbXJ6CL4J+hvfZRKC7C+w7E=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-CObXSGaEMDeYWkxQUhSFAA-1; Fri, 11 Aug 2023 11:18:17 -0400
X-MC-Unique: CObXSGaEMDeYWkxQUhSFAA-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-790af528c93so166762339f.2
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 08:18:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691767097; x=1692371897;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5jvk9gOBrnZNGwTR3Eif+kJzbn0hYBEZnzfA7q6zH3g=;
        b=iLOWeYLyp0wT/oaAwNh1UMUxpD+8yLMGfmkcWMBdX6sGO9SKuO3FPI+cBRVaUSbhMm
         iJv7bpSMtcZ94NHJC2RpJxx2XqojZdmP/Yma2kJ0BZQsahM7Tq4GUryyn2VNk4QPFOsD
         KjCUNFVYEoh6VwywG3+d/a/7705Dy/AzFv5QCAXEVC/2NVjHXp/c9k2NKCHHgNaQRX0d
         MFgnQimM1eIj+kPiddS2LksUnq6sSVMY2jZksUfTarOC8IW4AqMRuqUZwcYSLhJHxZg7
         S6XHG59FDjZGLyluvu770Wx8T7wBv4ZWN6Ar37q/150AjlPBhucN/BzuBq9/3ECTvze1
         JRlQ==
X-Gm-Message-State: AOJu0Yx20zOWLYUoCdQhLgPRz1ZQYcUUNTmLTqrbzWd6S9Zvdcudn3jm
        CDYlE4Qex+T0du0/GcyVvyHc1lPU7H0PTuqaLkj6DgzomVx213dGR+bm3sWZ5zQrW57F3JVbFXs
        pDB8HdnM20Rvn
X-Received: by 2002:a6b:e617:0:b0:787:6bd:e590 with SMTP id g23-20020a6be617000000b0078706bde590mr3051927ioh.3.1691767097169;
        Fri, 11 Aug 2023 08:18:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKw28KuDhVAyNPv6MlOEjB1eJ9SY9VxRRQMppZ4UgGp6JYUxVHXcfayh7m4Drb+Z4OuccpNw==
X-Received: by 2002:a6b:e617:0:b0:787:6bd:e590 with SMTP id g23-20020a6be617000000b0078706bde590mr3051912ioh.3.1691767096942;
        Fri, 11 Aug 2023 08:18:16 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id u12-20020a02cb8c000000b00430159b03f1sm1122994jap.93.2023.08.11.08.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 08:18:16 -0700 (PDT)
Date:   Fri, 11 Aug 2023 09:18:14 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <diana.craciun@oss.nxp.com>
Subject: Re: [PATCH -next] vfio/fsl-mc: use module_fsl_mc_driver() macro
Message-ID: <20230811091814.1808a01a.alex.williamson@redhat.com>
In-Reply-To: <20230811092911.894659-1-yangyingliang@huawei.com>
References: <20230811092911.894659-1-yangyingliang@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Aug 2023 17:29:11 +0800
Yang Yingliang <yangyingliang@huawei.com> wrote:

> The driver init/exit() function don't do anything special, it
> can use the module_fsl_mc_driver() macro to eliminate boilerplate
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c | 14 +-------------
>  1 file changed, 1 insertion(+), 13 deletions(-)

Your colleague submitted a nearly identical patch, but also removing
the redundant module owner, 2 days ago:

https://lore.kernel.org/all/20230809131536.4021639-1-lizetao1@huawei.com/

Thanks,
Alex

> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index f2140e94d41e..8053f13c2be5 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -604,19 +604,7 @@ static struct fsl_mc_driver vfio_fsl_mc_driver = {
>  	},
>  	.driver_managed_dma = true,
>  };
> -
> -static int __init vfio_fsl_mc_driver_init(void)
> -{
> -	return fsl_mc_driver_register(&vfio_fsl_mc_driver);
> -}
> -
> -static void __exit vfio_fsl_mc_driver_exit(void)
> -{
> -	fsl_mc_driver_unregister(&vfio_fsl_mc_driver);
> -}
> -
> -module_init(vfio_fsl_mc_driver_init);
> -module_exit(vfio_fsl_mc_driver_exit);
> +module_fsl_mc_driver(vfio_fsl_mc_driver);
>  
>  MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_DESCRIPTION("VFIO for FSL-MC devices - User Level meta-driver");

