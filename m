Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5EF624B96
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 21:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbiKJUSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 15:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbiKJUSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 15:18:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F4B4D5DD
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 12:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668111417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j1cfwq+EPo7bBIFDC0xbmBcIryGnjtScdWzEBgAlEd0=;
        b=YYf28jrVJCQx1yH+CwrypaqXWbdS2DjEDVvp2VSYpqCgecKaQrhgsDJRn2JCz1QaJJYVDn
        7sgrJuURsBSKd79DHN140CAATQBnVMmAjIhtqSG3ApO+79lkNd7LlYXVT87c6cktptCZug
        WbyQxOSKzIg/UC6JgnI2pDxw1vbC+wo=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-171-y4Py8MFmMx-8L37Hyhuk5g-1; Thu, 10 Nov 2022 15:16:56 -0500
X-MC-Unique: y4Py8MFmMx-8L37Hyhuk5g-1
Received: by mail-io1-f71.google.com with SMTP id be26-20020a056602379a00b006dd80a0ba1cso1793171iob.11
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 12:16:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j1cfwq+EPo7bBIFDC0xbmBcIryGnjtScdWzEBgAlEd0=;
        b=kK5z/6av8/gHat248JsA4MeQgknsfOCoyW11iV9kp8sU3CUZEuoe+uBePDfx8qATaK
         v7x9iWOGAkFUnnY2WIqoRLOTj3AlgHIlTOW55m8FUANc5cOutPznZ0TzlBr3LaFF5/LV
         s3t3Lj4PTN9I2uHNltbjHDju5W276wnJYFIi4Z+otHys3N3MB/V9akeht2rGpqfAdo1w
         Wc0DieZwnf9djrkHWao6bM+lS1wGW9+SgfuckliMFlIKTk6prFWFc0sNpgHYUIv6PLgY
         djb+JLKoKP2W7S1Hn5rQZXmCSj3WSVVICxBOaWPQKk+Tmj9rC/2DbuXo8egoo7OOuaId
         P/Tw==
X-Gm-Message-State: ACrzQf2aVkzET7IePsGJoq3kRD47HjCanwyc122s6WVBwl536Iig4JXw
        GTTJGAZDuQDttB+j9iu5jhLipKfl6NK0nhKmHcXlKcQihoJEaYrhH827Lnzgbv+otLKzOS++V5T
        E2fTD0OEj3zgU
X-Received: by 2002:a92:dac4:0:b0:300:d8d4:a98c with SMTP id o4-20020a92dac4000000b00300d8d4a98cmr3423053ilq.6.1668111415677;
        Thu, 10 Nov 2022 12:16:55 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5kK/TK7kIuVdRb8zV2hkx7Q6hS9uc9spMLWOJZV/q3MUOEXyc+TKO4kynItn0n9iCOqBo5MA==
X-Received: by 2002:a92:dac4:0:b0:300:d8d4:a98c with SMTP id o4-20020a92dac4000000b00300d8d4a98cmr3423044ilq.6.1668111415455;
        Thu, 10 Nov 2022 12:16:55 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i7-20020a0566022c8700b006bbea9f45cesm25981iow.38.2022.11.10.12.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 12:16:54 -0800 (PST)
Date:   Thu, 10 Nov 2022 13:16:41 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     <yishaih@nvidia.com>, <jgg@ziepe.ca>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <cohuck@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH -next] vfio/mlx5: Switch to use module_pci_driver()
 macro
Message-ID: <20221110131641.5f05d20b.alex.williamson@redhat.com>
In-Reply-To: <20220922123507.11222-1-shangxiaojing@huawei.com>
References: <20220922123507.11222-1-shangxiaojing@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Sep 2022 20:35:07 +0800
Shang XiaoJing <shangxiaojing@huawei.com> wrote:

> Since pci provides the helper macro module_pci_driver(), we may replace
> the module_init/exit with it.
> 
> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
> ---
>  drivers/vfio/pci/mlx5/main.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 759a5f5f7b3f..42bfa2678b81 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -654,18 +654,7 @@ static struct pci_driver mlx5vf_pci_driver = {
>  	.driver_managed_dma = true,
>  };
>  
> -static void __exit mlx5vf_pci_cleanup(void)
> -{
> -	pci_unregister_driver(&mlx5vf_pci_driver);
> -}
> -
> -static int __init mlx5vf_pci_init(void)
> -{
> -	return pci_register_driver(&mlx5vf_pci_driver);
> -}
> -
> -module_init(mlx5vf_pci_init);
> -module_exit(mlx5vf_pci_cleanup);
> +module_pci_driver(mlx5vf_pci_driver);
>  
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Max Gurtovoy <mgurtovoy@nvidia.com>");

Applied to vfio next branch for v6.2.  Thanks,

Alex

