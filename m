Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070AC5538EF
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 19:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbiFURcc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 13:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbiFURc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 13:32:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5340E1FA68
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 10:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655832745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OZFSQxmTaNJuAZb5y2EVZ+J98QaHiitC7rwNHGpKrCU=;
        b=Q4VENcizTlyWBoVwezAfdMS9mp3W5oWcLt4bVxBtikexvjOG1A0dN3aT3O7m+yJPv0804n
        1ELyaEAc6TTmktQgZdMqFKIgEbFIZHeU0zlXBfMNNWvUK4qekwTMCBtdO3QsdLLKUOX5vV
        3UgsWyDforvswd1V0Viy+zF+y7ccZR0=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-PpVj0z3fOAm6w-0FGStUzg-1; Tue, 21 Jun 2022 13:32:23 -0400
X-MC-Unique: PpVj0z3fOAm6w-0FGStUzg-1
Received: by mail-il1-f200.google.com with SMTP id p12-20020a056e02144c00b002d196a4d73eso9572782ilo.18
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 10:32:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=OZFSQxmTaNJuAZb5y2EVZ+J98QaHiitC7rwNHGpKrCU=;
        b=o7OFnm+bmWVr1r2oBZ0Z4kCY1uVQjhRUTKMXdCIqXB7PC0vvA7XAubXTr5aaH44ZF7
         dH8SGrCmvYhSGhXqfmbyy2CrEQrGUUD+QIMP77tcMn30AIYySEorSQwDSqVUhHSOu/F8
         3vb8QLwLL2kNVHe7e7qXdH4x1wbF5OHDkDrBjL/Cgcu4cvuiVnj8fTf4RUBUnBr9eAZZ
         WnXkwlaHaimjywetsig93ecLHrbTM+KaqGnsq85xwgERTKrgQSg3V5jHFAqz6KIUHSzM
         TQqaT9v3l5gi60QeWH9R+hHNanjvcOIyxHEQk+NzD0IEJsS6CENM3M4fZclNU/63U46f
         dstg==
X-Gm-Message-State: AJIora+GcqI6m24uEIXQvYeJdkFN6NJIjz0WnxXrs2t+1YqJ0h30fBuy
        IxiWYcLL7hLt/zl799n/Eg5TXY8I5ekLxYJ4KWMXdo4Tnmi+B3mR9KNpPjMa1fmM4QS0zafi+ZR
        u3Ulios/r9CAh
X-Received: by 2002:a02:b708:0:b0:331:67bf:dbef with SMTP id g8-20020a02b708000000b0033167bfdbefmr17185911jam.176.1655832742899;
        Tue, 21 Jun 2022 10:32:22 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sF4srFPFQNwJOpN8K/z1EhjIXVonErqqI9BuR3Dy1OGnO/CsqNoMZRomZ1sVdVuClNcCM87g==
X-Received: by 2002:a02:b708:0:b0:331:67bf:dbef with SMTP id g8-20020a02b708000000b0033167bfdbefmr17185903jam.176.1655832742704;
        Tue, 21 Jun 2022 10:32:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i17-20020a02b691000000b0032b3a7817dbsm7380783jam.159.2022.06.21.10.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 10:32:22 -0700 (PDT)
Date:   Tue, 21 Jun 2022 11:32:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio: check vfio_register_iommu_driver() return value
Message-ID: <20220621113221.5d28623e.alex.williamson@redhat.com>
In-Reply-To: <20220621062112.5771-1-liubo03@inspur.com>
References: <20220621062112.5771-1-liubo03@inspur.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Jun 2022 02:21:12 -0400
Bo Liu <liubo03@inspur.com> wrote:

> As vfio_register_iommu_driver() can fail, we should check the return value.
> 
> Signed-off-by: Bo Liu <liubo03@inspur.com>
> ---
>  drivers/vfio/vfio.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 61e71c1154be..7d4b6dfafd27 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -2159,10 +2159,16 @@ static int __init vfio_init(void)
>  	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");

If we're going to acknowledge that the below can fail, then we should
move the pr_info so that we only advertise that vfio has loaded after
all potential failure points.

>  
>  #ifdef CONFIG_VFIO_NOIOMMU
> -	vfio_register_iommu_driver(&vfio_noiommu_ops);
> +	ret = vfio_register_iommu_driver(&vfio_noiommu_ops);
> +	if (ret)
> +		goto err_driver_register;
>  #endif

We could move this #endif above the ret test so that the goto exists
outside of the #ifdef, then we don't need to wrap the goto target in
#ifdefs below.  Thanks,

Alex

>  	return 0;
>  
> +#ifdef CONFIG_VFIO_NOIOMMU
> +err_driver_register:
> +	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
> +#endif
>  err_alloc_chrdev:
>  	class_destroy(vfio.class);
>  	vfio.class = NULL;

