Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96633726159
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 15:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240518AbjFGNe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 09:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235826AbjFGNeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 09:34:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ABD1732
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 06:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686144841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W4Q7/UPwaAYAc96M0seOkOkevOSPM7hdycDvZazPIMM=;
        b=EBtiWbAqAYUPFVzi21bafT1La85IOMaxcSuxJmv1N2MPpO0fb65RVTkICKjvWAXZOa6F1T
        Q0xscrMm2ZrcOdR+JUe2rg/mkuLdvsTIbC0n+K1FhJanQ9Q/8Tnbrt7jH4HK9HCOZequ4s
        2uUPtSx3gydH+pUDBVwtnGqqijyWQG4=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-TUDzHrIXO-G9jgDYnG8h4A-1; Wed, 07 Jun 2023 09:34:00 -0400
X-MC-Unique: TUDzHrIXO-G9jgDYnG8h4A-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-395ff4dc3abso7397739b6e.3
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 06:33:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686144839; x=1688736839;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W4Q7/UPwaAYAc96M0seOkOkevOSPM7hdycDvZazPIMM=;
        b=R+ltsZPahKnF63rXGcVywJakR3eJIfkpZK9/b2fieooQtIND2UODdJBkjqrn0mVf1F
         VacEdr40ttuhXo3GTbhzvNcxiNdVpVWZd+27YgfSD3hqHmajAxLxIuvKrgKGKvY1wNyI
         4hR49WzcCVjKmTRLZOreTdrrb1Icl9Z4K6d0WbI881z0L5Rvn3WLnrmRkS0pvE9h6OYS
         l15b/KVn/7sOZqkJL3qi4CTD5UNl366Tm5vJLbCZobvZ3HB2MUlAMRhQIn+EFbcbnuGv
         hv0d6HGHne1DYYDWsHqkf/DXs7nxEWbRF2fOehl4uTiFLEg76+vGuVnumR0zJTPAzkBs
         IpeA==
X-Gm-Message-State: AC+VfDzfYvH9QCpFHXvBmBIsny00S4KIHlRRzl+6l6256EGud5GibKYI
        tTDuN7Uh7ZjmDj7X2eFsBt7Y83BjiPz9/AHEsKlWbGjtjRpwipwmUT6xf6s3A+x75KWii7xbL+O
        FgSpdedb0M6ck
X-Received: by 2002:aca:1c10:0:b0:39c:76ec:9ba8 with SMTP id c16-20020aca1c10000000b0039c76ec9ba8mr49511oic.44.1686144839236;
        Wed, 07 Jun 2023 06:33:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ79TDNVhK96NPrBpEdoPrnZody9fvWmnJpwtQAPogo1UYPrGVMkkNYIK8CBHrnhDLvZspPTEQ==
X-Received: by 2002:aca:1c10:0:b0:39c:76ec:9ba8 with SMTP id c16-20020aca1c10000000b0039c76ec9ba8mr49491oic.44.1686144839008;
        Wed, 07 Jun 2023 06:33:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id v6-20020ad45286000000b006257e64474asm6083293qvr.113.2023.06.07.06.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 06:33:57 -0700 (PDT)
Message-ID: <de52de5f-a830-dd15-a703-02b5174642a1@redhat.com>
Date:   Wed, 7 Jun 2023 15:33:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/3] vfio/pci: Cleanup Kconfig
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     jgg@nvidia.com, clg@redhat.com, liulongfang@huawei.com,
        shameerali.kolothum.thodi@huawei.com, yishaih@nvidia.com,
        kevin.tian@intel.com
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
 <20230602213315.2521442-2-alex.williamson@redhat.com>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20230602213315.2521442-2-alex.williamson@redhat.com>
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
Reviewed-by: Eric Auger <eric.auger@redhat.com>


Eric

> ---
>  drivers/vfio/Makefile              | 2 +-
>  drivers/vfio/pci/Kconfig           | 8 ++++++--
>  drivers/vfio/pci/hisilicon/Kconfig | 4 ++--
>  drivers/vfio/pci/mlx5/Kconfig      | 2 +-
>  4 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 70e7dcb302ef..151e816b2ff9 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -10,7 +10,7 @@ vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
>  
>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> -obj-$(CONFIG_VFIO_PCI) += pci/
> +obj-$(CONFIG_VFIO_PCI_CORE) += pci/
>  obj-$(CONFIG_VFIO_PLATFORM) += platform/
>  obj-$(CONFIG_VFIO_MDEV) += mdev/
>  obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index f9d0c908e738..86bb7835cf3c 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -1,5 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -if PCI && MMU
> +menu "VFIO support for PCI devices"
> +	depends on PCI && MMU
> +
>  config VFIO_PCI_CORE
>  	tristate
>  	select VFIO_VIRQFD
> @@ -7,9 +9,11 @@ config VFIO_PCI_CORE
>  
>  config VFIO_PCI_MMAP
>  	def_bool y if !S390
> +	depends on VFIO_PCI_CORE
>  
>  config VFIO_PCI_INTX
>  	def_bool y if !S390
> +	depends on VFIO_PCI_CORE
>  
>  config VFIO_PCI
>  	tristate "Generic VFIO support for any PCI device"
> @@ -59,4 +63,4 @@ source "drivers/vfio/pci/mlx5/Kconfig"
>  
>  source "drivers/vfio/pci/hisilicon/Kconfig"
>  
> -endif
> +endmenu
> diff --git a/drivers/vfio/pci/hisilicon/Kconfig b/drivers/vfio/pci/hisilicon/Kconfig
> index 5daa0f45d2f9..cbf1c32f6ebf 100644
> --- a/drivers/vfio/pci/hisilicon/Kconfig
> +++ b/drivers/vfio/pci/hisilicon/Kconfig
> @@ -1,13 +1,13 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config HISI_ACC_VFIO_PCI
> -	tristate "VFIO PCI support for HiSilicon ACC devices"
> +	tristate "VFIO support for HiSilicon ACC PCI devices"
>  	depends on ARM64 || (COMPILE_TEST && 64BIT)
> -	depends on VFIO_PCI_CORE
>  	depends on PCI_MSI
>  	depends on CRYPTO_DEV_HISI_QM
>  	depends on CRYPTO_DEV_HISI_HPRE
>  	depends on CRYPTO_DEV_HISI_SEC2
>  	depends on CRYPTO_DEV_HISI_ZIP
> +	select VFIO_PCI_CORE
>  	help
>  	  This provides generic PCI support for HiSilicon ACC devices
>  	  using the VFIO framework.
> diff --git a/drivers/vfio/pci/mlx5/Kconfig b/drivers/vfio/pci/mlx5/Kconfig
> index 29ba9c504a75..7088edc4fb28 100644
> --- a/drivers/vfio/pci/mlx5/Kconfig
> +++ b/drivers/vfio/pci/mlx5/Kconfig
> @@ -2,7 +2,7 @@
>  config MLX5_VFIO_PCI
>  	tristate "VFIO support for MLX5 PCI devices"
>  	depends on MLX5_CORE
> -	depends on VFIO_PCI_CORE
> +	select VFIO_PCI_CORE
>  	help
>  	  This provides migration support for MLX5 devices using the VFIO
>  	  framework.

