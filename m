Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0815722209
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 11:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjFEJWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 05:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjFEJWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 05:22:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF23A7
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 02:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685956910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zIhDVrJsTcNOJm5g4/x77Bbnet/BA09hSGoph56Dc8U=;
        b=Uy7zSe7L54DIvBRff3OkOdnaXN1PT6/G8kB0MuYpfDZOx/Esy2ETYIDnJfzFq/AUhhqy8n
        BgTuD8KPW9Y24XaSJagyVnquVRQ0uK5U1cDt9dyLzPyjtommb5Z7mBi3sCaNYGUEguFcj0
        miEsewM/Ok+bJQgX7J4YNqVdiMhbHWA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-fS3oPa90NIusvxI5_ksqPw-1; Mon, 05 Jun 2023 05:21:49 -0400
X-MC-Unique: fS3oPa90NIusvxI5_ksqPw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f5df65f9f4so22324145e9.2
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 02:21:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685956908; x=1688548908;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zIhDVrJsTcNOJm5g4/x77Bbnet/BA09hSGoph56Dc8U=;
        b=SGeV+O0AYL9WY5ZzBQrLIxDL3LTAq7fwFFeK1lh95yuWBUBUwBFbFeg7IFsnJ9INjb
         SQxBRF7vcnt8QsjQYltnSrTyChy8Fy/GOZ04wmej0Mn+ECpWPRwVtBtByaqv4UB+1Gvo
         YXXVtVc1yB6smmxgB14MgDZ1w8hmckoYFoAxluUEyzK3dSB7vdzp5Jb6DdxuttQylmxr
         20qAKGFUgQ9f5YQa+0sAoNKHxGr44aXTUCJXcP6SKnTUC551t/qbHDsUF3F6Tobo/KXE
         0PKdpdcJawDiit2j8N9nyHW53BmI4xUh6RI0W459M11gnJYptABC8d5TP6KDfGPFTmBL
         6/gQ==
X-Gm-Message-State: AC+VfDzkCXQOOJShV7SxxqQmWnpbXf2x3dSdLcrIu+wj1N+Jyeo9nupG
        tcmRoBq7SRdzDk/RR/Nfn4xXnjeEj7ZCLrn7R06KLLecHXRFwBrMrolAHWS3ZmR2iOTiS5AKt6W
        Z5C2x3gVBufpY
X-Received: by 2002:a7b:c8c3:0:b0:3f6:da2:bc83 with SMTP id f3-20020a7bc8c3000000b003f60da2bc83mr6166617wml.33.1685956908212;
        Mon, 05 Jun 2023 02:21:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6OfNkdbFo5Iizry96XA+Qr0ZXhhcv+Bbq8zlyM77usPsu77xGIKNe8pt323i9DR6tfCAGBzw==
X-Received: by 2002:a7b:c8c3:0:b0:3f6:da2:bc83 with SMTP id f3-20020a7bc8c3000000b003f60da2bc83mr6166610wml.33.1685956907924;
        Mon, 05 Jun 2023 02:21:47 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:eb4a:c9d8:c8bb:c0b0? ([2a01:e0a:280:24f0:eb4a:c9d8:c8bb:c0b0])
        by smtp.gmail.com with ESMTPSA id u1-20020a05600c210100b003f73a101f88sm3916318wml.16.2023.06.05.02.21.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 02:21:47 -0700 (PDT)
Message-ID: <60be5ccf-88d0-07c7-204f-ef97374dffbc@redhat.com>
Date:   Mon, 5 Jun 2023 11:21:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/3] vfio/pci: Cleanup Kconfig
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     jgg@nvidia.com, liulongfang@huawei.com,
        shameerali.kolothum.thodi@huawei.com, yishaih@nvidia.com,
        kevin.tian@intel.com
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
 <20230602213315.2521442-2-alex.williamson@redhat.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20230602213315.2521442-2-alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/2/23 23:33, Alex Williamson wrote:
> It should be possible to select vfio-pci variant drivers without building
> vfio-pci itself, which implies each variant driver should select
> vfio-pci-core.
> 
> Fix the top level vfio Makefile to traverse pci based on vfio-pci-core
> rather than vfio-pci.
> 
> Mark MMAP and INTX options depending on vfio-pci-core to cleanup resulting
> config if core is not enabled.
> 
> Push all PCI related vfio options to a sub-menu and make descriptions
> consistent.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.

> ---
>   drivers/vfio/Makefile              | 2 +-
>   drivers/vfio/pci/Kconfig           | 8 ++++++--
>   drivers/vfio/pci/hisilicon/Kconfig | 4 ++--
>   drivers/vfio/pci/mlx5/Kconfig      | 2 +-
>   4 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 70e7dcb302ef..151e816b2ff9 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -10,7 +10,7 @@ vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
>   
>   obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>   obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> -obj-$(CONFIG_VFIO_PCI) += pci/
> +obj-$(CONFIG_VFIO_PCI_CORE) += pci/
>   obj-$(CONFIG_VFIO_PLATFORM) += platform/
>   obj-$(CONFIG_VFIO_MDEV) += mdev/
>   obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index f9d0c908e738..86bb7835cf3c 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -1,5 +1,7 @@
>   # SPDX-License-Identifier: GPL-2.0-only
> -if PCI && MMU
> +menu "VFIO support for PCI devices"
> +	depends on PCI && MMU
> +
>   config VFIO_PCI_CORE
>   	tristate
>   	select VFIO_VIRQFD
> @@ -7,9 +9,11 @@ config VFIO_PCI_CORE
>   
>   config VFIO_PCI_MMAP
>   	def_bool y if !S390
> +	depends on VFIO_PCI_CORE
>   
>   config VFIO_PCI_INTX
>   	def_bool y if !S390
> +	depends on VFIO_PCI_CORE
>   
>   config VFIO_PCI
>   	tristate "Generic VFIO support for any PCI device"
> @@ -59,4 +63,4 @@ source "drivers/vfio/pci/mlx5/Kconfig"
>   
>   source "drivers/vfio/pci/hisilicon/Kconfig"
>   
> -endif
> +endmenu
> diff --git a/drivers/vfio/pci/hisilicon/Kconfig b/drivers/vfio/pci/hisilicon/Kconfig
> index 5daa0f45d2f9..cbf1c32f6ebf 100644
> --- a/drivers/vfio/pci/hisilicon/Kconfig
> +++ b/drivers/vfio/pci/hisilicon/Kconfig
> @@ -1,13 +1,13 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   config HISI_ACC_VFIO_PCI
> -	tristate "VFIO PCI support for HiSilicon ACC devices"
> +	tristate "VFIO support for HiSilicon ACC PCI devices"
>   	depends on ARM64 || (COMPILE_TEST && 64BIT)
> -	depends on VFIO_PCI_CORE
>   	depends on PCI_MSI
>   	depends on CRYPTO_DEV_HISI_QM
>   	depends on CRYPTO_DEV_HISI_HPRE
>   	depends on CRYPTO_DEV_HISI_SEC2
>   	depends on CRYPTO_DEV_HISI_ZIP
> +	select VFIO_PCI_CORE
>   	help
>   	  This provides generic PCI support for HiSilicon ACC devices
>   	  using the VFIO framework.
> diff --git a/drivers/vfio/pci/mlx5/Kconfig b/drivers/vfio/pci/mlx5/Kconfig
> index 29ba9c504a75..7088edc4fb28 100644
> --- a/drivers/vfio/pci/mlx5/Kconfig
> +++ b/drivers/vfio/pci/mlx5/Kconfig
> @@ -2,7 +2,7 @@
>   config MLX5_VFIO_PCI
>   	tristate "VFIO support for MLX5 PCI devices"
>   	depends on MLX5_CORE
> -	depends on VFIO_PCI_CORE
> +	select VFIO_PCI_CORE
>   	help
>   	  This provides migration support for MLX5 devices using the VFIO
>   	  framework.

