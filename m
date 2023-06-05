Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6819272220A
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 11:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjFEJXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 05:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjFEJW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 05:22:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A60F7
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 02:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685956938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Es3X6k28jIuRvVZ6C5AM9BoK/uBQMjVrohnoAQ0dB38=;
        b=c6yktmh/7V2sTsqDrJEwIUm6wWAP1gqs+IqRejX3P2TbHghByPNUeLWTkmmVelotQhloNg
        ppegSAsHc60Cw9gsbFsXnbC5HFy7I77qaNOxlwYDolKrk/qkNUCoYcqEkV4aeZraCPEj3E
        XIsoTzIlLQ/bkcWHizR3tgt6hDZo4YI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-EqZZmh59OICqZNbbhkx0iA-1; Mon, 05 Jun 2023 05:22:17 -0400
X-MC-Unique: EqZZmh59OICqZNbbhkx0iA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4f4c62e0c9eso2949121e87.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 02:22:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685956935; x=1688548935;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Es3X6k28jIuRvVZ6C5AM9BoK/uBQMjVrohnoAQ0dB38=;
        b=RadWNDH/vdiEUOdNO1b5FpHUQBfVpITqDipYILYX30xkrstdXbhUTJot1+4BGpgWci
         7mYLmg/BT/or2fdSksK8LoVk9ZCtTz6mVdCaML89yfOxpP6Q1eVGOiwKRxgdZ9iHNE4h
         hrxCA1D9ETtQaU1Z1W3I9i9gaQIA5a8GLgo2uNVyvz8tU/C8IvJ+ORsDCBlxEKb/pDgs
         16+32FBTBfKEXJqun1LLc00jkFlCdOlQMboFbDbiKYPVS1jtPGA5Y0PTyjdbwB3ZvQFQ
         2bdTI2zJjBCCh5wcaYDA6YvHYHFaRZB4TTZA67IHrsZ/gZctxne9GNf+hR1g+vQMlhXb
         RBKA==
X-Gm-Message-State: AC+VfDwRODVDw4vzyqHVpe+gsrmvI25Uj0X9dFmBX4ZRoN3521GwH4+S
        20QF1wLN/cQ6ASeVJPY2uDBDVD21VIrpAy04/1UuzH7NfdIx4t6kFGvqx4B5flyaDUHhnrgaLpd
        LarFJky+6vDxI
X-Received: by 2002:ac2:4c30:0:b0:4f6:d9e:7c3a with SMTP id u16-20020ac24c30000000b004f60d9e7c3amr4897777lfq.47.1685956935632;
        Mon, 05 Jun 2023 02:22:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7dkrgVC98HWzbmI7W4JbeH1gQ2/u2OoUVRCAMCe6MFL8fADy/oZhEfhXe+RfsY9WsOulmLQQ==
X-Received: by 2002:ac2:4c30:0:b0:4f6:d9e:7c3a with SMTP id u16-20020ac24c30000000b004f60d9e7c3amr4897764lfq.47.1685956935250;
        Mon, 05 Jun 2023 02:22:15 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:eb4a:c9d8:c8bb:c0b0? ([2a01:e0a:280:24f0:eb4a:c9d8:c8bb:c0b0])
        by smtp.gmail.com with ESMTPSA id l4-20020a1c7904000000b003f5ffba9ae1sm10151453wme.24.2023.06.05.02.22.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 02:22:14 -0700 (PDT)
Message-ID: <c9600448-e6a1-dde4-5a7d-fcfaf820c4dc@redhat.com>
Date:   Mon, 5 Jun 2023 11:22:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/3] vfio/platform: Cleanup Kconfig
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     jgg@nvidia.com, eric.auger@redhat.com
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
 <20230602213315.2521442-3-alex.williamson@redhat.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20230602213315.2521442-3-alex.williamson@redhat.com>
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
> Like vfio-pci, there's also a base module here where vfio-amba depends on
> vfio-platform, when really it only needs vfio-platform-base.  Create a
> sub-menu for platform drivers and a nested menu for reset drivers.  Cleanup
> Makefile to make use of new CONFIG_VFIO_PLATFORM_BASE for building the
> shared modules and traversing reset modules.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.

> ---
>   drivers/vfio/Makefile          |  2 +-
>   drivers/vfio/platform/Kconfig  | 17 ++++++++++++++---
>   drivers/vfio/platform/Makefile |  9 +++------
>   3 files changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 151e816b2ff9..8da44aa1ea16 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -11,6 +11,6 @@ vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
>   obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>   obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>   obj-$(CONFIG_VFIO_PCI_CORE) += pci/
> -obj-$(CONFIG_VFIO_PLATFORM) += platform/
> +obj-$(CONFIG_VFIO_PLATFORM_BASE) += platform/
>   obj-$(CONFIG_VFIO_MDEV) += mdev/
>   obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
> diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
> index 331a5920f5ab..6d18faa66a2e 100644
> --- a/drivers/vfio/platform/Kconfig
> +++ b/drivers/vfio/platform/Kconfig
> @@ -1,8 +1,14 @@
>   # SPDX-License-Identifier: GPL-2.0-only
> +menu "VFIO support for platform devices"
> +
> +config VFIO_PLATFORM_BASE
> +	tristate
> +
>   config VFIO_PLATFORM
> -	tristate "VFIO support for platform devices"
> +	tristate "Generic VFIO support for any platform device"
>   	depends on ARM || ARM64 || COMPILE_TEST
>   	select VFIO_VIRQFD
> +	select VFIO_PLATFORM_BASE
>   	help
>   	  Support for platform devices with VFIO. This is required to make
>   	  use of platform devices present on the system using the VFIO
> @@ -10,10 +16,11 @@ config VFIO_PLATFORM
>   
>   	  If you don't know what to do here, say N.
>   
> -if VFIO_PLATFORM
>   config VFIO_AMBA
>   	tristate "VFIO support for AMBA devices"
>   	depends on ARM_AMBA || COMPILE_TEST
> +	select VFIO_VIRQFD
> +	select VFIO_PLATFORM_BASE
>   	help
>   	  Support for ARM AMBA devices with VFIO. This is required to make
>   	  use of ARM AMBA devices present on the system using the VFIO
> @@ -21,5 +28,9 @@ config VFIO_AMBA
>   
>   	  If you don't know what to do here, say N.
>   
> +menu "VFIO platform reset drivers"
> +	depends on VFIO_PLATFORM_BASE
> +
>   source "drivers/vfio/platform/reset/Kconfig"
> -endif
> +endmenu
> +endmenu
> diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
> index 3f3a24e7c4ef..ee4fb6a82ca8 100644
> --- a/drivers/vfio/platform/Makefile
> +++ b/drivers/vfio/platform/Makefile
> @@ -1,13 +1,10 @@
>   # SPDX-License-Identifier: GPL-2.0
>   vfio-platform-base-y := vfio_platform_common.o vfio_platform_irq.o
> -vfio-platform-y := vfio_platform.o
> +obj-$(CONFIG_VFIO_PLATFORM_BASE) += vfio-platform-base.o
> +obj-$(CONFIG_VFIO_PLATFORM_BASE) += reset/
>   
> +vfio-platform-y := vfio_platform.o
>   obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
> -obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform-base.o
> -obj-$(CONFIG_VFIO_PLATFORM) += reset/
>   
>   vfio-amba-y := vfio_amba.o
> -
>   obj-$(CONFIG_VFIO_AMBA) += vfio-amba.o
> -obj-$(CONFIG_VFIO_AMBA) += vfio-platform-base.o
> -obj-$(CONFIG_VFIO_AMBA) += reset/

