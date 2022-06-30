Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09412562397
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 21:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbiF3Twl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 15:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236823AbiF3Twi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 15:52:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9721B44756
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 12:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656618756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YuG2y2ZB4QP84uKg4ters0wFa448pqv2dml+Y1Tj1iM=;
        b=bbGg14TriMozqQUBrki4ABjKf3xuzVUmUFtUEPLp7rhnsgHAmAMHQmhyyRzLQliNaeYwp2
        TvolyWwNa5H9w9N1ZX/SpW5lKtIIb84WgvKNKAm3zWZn6Xd5MuPAHDkLuFQTxJFpBURjV+
        XOGjOmfvVOCOBDKkC3oBTIVbQhwnm9Y=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-94VrKiC4MGurHBEBtBGQNw-1; Thu, 30 Jun 2022 15:52:35 -0400
X-MC-Unique: 94VrKiC4MGurHBEBtBGQNw-1
Received: by mail-io1-f70.google.com with SMTP id p123-20020a6bbf81000000b00674f66cf13aso77701iof.23
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 12:52:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YuG2y2ZB4QP84uKg4ters0wFa448pqv2dml+Y1Tj1iM=;
        b=yFGkNdQVccyotAj1Pi8QKv+6GpQsl2Agpbk+ne3rn6dL8uUTYOgcvX9tdcm3vjQPJF
         1vqpSCbSIyh2ihA7UTaL9p0kktiFf5jVQ1rAdGS3Bv0MfMSAL7f3c//X0lL7vD8Nc0Gi
         OBw/9d8d1ZTjXuTXFg06YPM5s1AoRddkHqNw3MV+f6PmYxuXQR45CPtHjBwUtlET6h5D
         aGEJIXX7sjYUOZm2McoZdozqOTvxNjwCtanNv0JcMOirUDKTiYrB7t1xzbovA9Isblt4
         1Hp81H6rGe0mG37BtSiYMAl3eaIQaSXeXBVj1pnnY9WoLNYjQiXnnC4HRmnmXDniFt8w
         sVwA==
X-Gm-Message-State: AJIora8ekR0swfB172YSLASR+RWv+HYPHA44WWf0LYwgHRXR7rkw6tct
        78i9k6zgSREqJxt7C/ld1lUR6P0VGJVHC3XvXSHfDEG4TIX3aGxTyyLEgb5sCygaDUIlWw/o4RL
        mHv4Cgj4bDWuA
X-Received: by 2002:a05:6638:2104:b0:33c:be1e:8d67 with SMTP id n4-20020a056638210400b0033cbe1e8d67mr6449867jaj.196.1656618754204;
        Thu, 30 Jun 2022 12:52:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vbucyqQv+gwXM0W06NeNVvHRpysJftS4fb0I3/j0Q3zn/CNWBBDNBOEgMD60z7AaBt5n5aTg==
X-Received: by 2002:a05:6638:2104:b0:33c:be1e:8d67 with SMTP id n4-20020a056638210400b0033cbe1e8d67mr6449858jaj.196.1656618753954;
        Thu, 30 Jun 2022 12:52:33 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x42-20020a0294ad000000b00330c5581c03sm8880286jah.1.2022.06.30.12.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 12:52:33 -0700 (PDT)
Date:   Thu, 30 Jun 2022 13:51:43 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] vfio: check vfio_register_iommu_driver() return
 value
Message-ID: <20220630135143.585d3575.alex.williamson@redhat.com>
In-Reply-To: <20220622045651.5416-1-liubo03@inspur.com>
References: <20220622045651.5416-1-liubo03@inspur.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Jun 2022 00:56:51 -0400
Bo Liu <liubo03@inspur.com> wrote:

> As vfio_register_iommu_driver() can fail, we should check the return value.
> 
> Signed-off-by: Bo Liu <liubo03@inspur.com>
> ---
>  Changes from v1:
>  -move the pr_info()
>  -move  #endif above the ret test
>  -remove #ifdefs above the err_driver_register
> 
>  drivers/vfio/vfio.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)

Applied to vfio next branch for v5.20.  Thanks,

Alex

> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 61e71c1154be..8f435c0d7748 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -2156,13 +2156,17 @@ static int __init vfio_init(void)
>  	if (ret)
>  		goto err_alloc_chrdev;
>  
> -	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
> -
>  #ifdef CONFIG_VFIO_NOIOMMU
> -	vfio_register_iommu_driver(&vfio_noiommu_ops);
> +	ret = vfio_register_iommu_driver(&vfio_noiommu_ops);
>  #endif
> +	if (ret)
> +		goto err_driver_register;
> +
> +	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
>  	return 0;
>  
> +err_driver_register:
> +	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
>  err_alloc_chrdev:
>  	class_destroy(vfio.class);
>  	vfio.class = NULL;

