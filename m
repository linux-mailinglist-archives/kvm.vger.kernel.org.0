Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0DD726153
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 15:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239459AbjFGNdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 09:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238955AbjFGNdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 09:33:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E491732
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 06:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686144733;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oX1CYdf07lMEuCzjPdqVejCnuPsmafxZ4wjNe6bkcGo=;
        b=BmDQY9Mmsm2Cw9pt5uKVhUsm1VVImxG+aLYy8lAEbM2yZ6Uyuc5wlQGFc6zzmXeI8Wqqdx
        /T5yKo5j10iGs7JkB9tggli7uRtQ8jw8+M49wzmhfXIpnG+GZ4dCmYdhJ5NA9MnJYIH6ot
        e86LXExO9hXnkby1IXFmpZn4xIcwF04=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185-BpD4m0JkOjKOm8bGpagKmA-1; Wed, 07 Jun 2023 09:32:12 -0400
X-MC-Unique: BpD4m0JkOjKOm8bGpagKmA-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6261a25e981so80391326d6.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 06:32:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686144732; x=1688736732;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oX1CYdf07lMEuCzjPdqVejCnuPsmafxZ4wjNe6bkcGo=;
        b=UcBsP9rDfVSsEfP367gF8PVgp9GI7h8zC+XT3yH2MJZjBiqznEJATdnC4yAuv5qlS8
         zHTnkGFxpglBrgPWcIPkJi7dL1m7tHa/y2goHXDTwhI2FRhzQVb1TKHEVe+2TCa+oUsm
         TQLXNkFWnehO8AnHy1hsUPixGQXT3+BOOP5pNspGfxJ2FFwFsBY14Bp0e4FJ8mtzQ318
         bY3ikVPZXKcb52xY0GOgnF+OwWjbB5Xe2wi4rX4UDrnCvkQRE8NQ6f/el9HsmlzJnXNz
         VQ0dqY+bf+dWRx6nxbaXqVNWwEI67TR2Wm7HB2ZBkijxyTzo5GuLLUDne0hgEUbWj+S1
         78vw==
X-Gm-Message-State: AC+VfDxtQLeWkyMsGkaN8mL8izxpV9+sDJ+mptCdnKH4eq7dYXBP3Ewp
        WK2hsZOmal0qN6J0gRwWx1FCNVU3bR9y7PvhjvJwddE0GOrZiaGKqbcRfLyt9aNl8W/B4LrIIva
        S1JnOKpzuEV8X
X-Received: by 2002:ad4:576c:0:b0:623:a60e:e50 with SMTP id r12-20020ad4576c000000b00623a60e0e50mr3424896qvx.40.1686144731876;
        Wed, 07 Jun 2023 06:32:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ANxGr3WK6NltmzTy72t+dvp99D8KtdPDwpxUiUJOLTYc94vNIyhAkKqI47XoBpirM93NOaQ==
X-Received: by 2002:ad4:576c:0:b0:623:a60e:e50 with SMTP id r12-20020ad4576c000000b00623a60e0e50mr3424870qvx.40.1686144731572;
        Wed, 07 Jun 2023 06:32:11 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id v6-20020ad45286000000b0062623d8ab7esm6085535qvr.111.2023.06.07.06.32.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 06:32:09 -0700 (PDT)
Message-ID: <7b4b8592-7857-b437-da06-2a6854fbf36b@redhat.com>
Date:   Wed, 7 Jun 2023 15:32:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 2/3] vfio/platform: Cleanup Kconfig
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     jgg@nvidia.com, clg@redhat.com
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
 <20230602213315.2521442-3-alex.williamson@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230602213315.2521442-3-alex.williamson@redhat.com>
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
> Like vfio-pci, there's also a base module here where vfio-amba depends on
> vfio-platform, when really it only needs vfio-platform-base.  Create a
> sub-menu for platform drivers and a nested menu for reset drivers.  Cleanup
> Makefile to make use of new CONFIG_VFIO_PLATFORM_BASE for building the
> shared modules and traversing reset modules.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/Makefile          |  2 +-
>  drivers/vfio/platform/Kconfig  | 17 ++++++++++++++---
>  drivers/vfio/platform/Makefile |  9 +++------
>  3 files changed, 18 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 151e816b2ff9..8da44aa1ea16 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -11,6 +11,6 @@ vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>  obj-$(CONFIG_VFIO_PCI_CORE) += pci/
> -obj-$(CONFIG_VFIO_PLATFORM) += platform/
> +obj-$(CONFIG_VFIO_PLATFORM_BASE) += platform/
>  obj-$(CONFIG_VFIO_MDEV) += mdev/
>  obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
> diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
> index 331a5920f5ab..6d18faa66a2e 100644
> --- a/drivers/vfio/platform/Kconfig
> +++ b/drivers/vfio/platform/Kconfig
> @@ -1,8 +1,14 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +menu "VFIO support for platform devices"
> +
> +config VFIO_PLATFORM_BASE
> +	tristate
> +
>  config VFIO_PLATFORM
> -	tristate "VFIO support for platform devices"
> +	tristate "Generic VFIO support for any platform device"
>  	depends on ARM || ARM64 || COMPILE_TEST
I wonder if we couldn't put those dependencies at the menu level. I
guess this also applies to AMBA. And just leave 'depends on ARM_AMBA ' in

config VFIO_AMBA?

>  	select VFIO_VIRQFD
> +	select VFIO_PLATFORM_BASE
>  	help
>  	  Support for platform devices with VFIO. This is required to make
>  	  use of platform devices present on the system using the VFIO
> @@ -10,10 +16,11 @@ config VFIO_PLATFORM
>  
>  	  If you don't know what to do here, say N.
>  
> -if VFIO_PLATFORM
>  config VFIO_AMBA
>  	tristate "VFIO support for AMBA devices"
>  	depends on ARM_AMBA || COMPILE_TEST
> +	select VFIO_VIRQFD
> +	select VFIO_PLATFORM_BASE
>  	help
>  	  Support for ARM AMBA devices with VFIO. This is required to make
>  	  use of ARM AMBA devices present on the system using the VFIO
> @@ -21,5 +28,9 @@ config VFIO_AMBA
>  
>  	  If you don't know what to do here, say N.
>  
> +menu "VFIO platform reset drivers"
> +	depends on VFIO_PLATFORM_BASE
I wonder if this shouldn't depend on VFIO_PLATFORM instead?
There are no amba reset devices at the moment so why whould be compile
them if VFIO_AMBA is set (which is unlikely by the way)?

Eric
> +
>  source "drivers/vfio/platform/reset/Kconfig"
> -endif
> +endmenu
> +endmenu
> diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
> index 3f3a24e7c4ef..ee4fb6a82ca8 100644
> --- a/drivers/vfio/platform/Makefile
> +++ b/drivers/vfio/platform/Makefile
> @@ -1,13 +1,10 @@
>  # SPDX-License-Identifier: GPL-2.0
>  vfio-platform-base-y := vfio_platform_common.o vfio_platform_irq.o
> -vfio-platform-y := vfio_platform.o
> +obj-$(CONFIG_VFIO_PLATFORM_BASE) += vfio-platform-base.o
> +obj-$(CONFIG_VFIO_PLATFORM_BASE) += reset/
>  
> +vfio-platform-y := vfio_platform.o
>  obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
> -obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform-base.o
> -obj-$(CONFIG_VFIO_PLATFORM) += reset/
>  
>  vfio-amba-y := vfio_amba.o
> -
>  obj-$(CONFIG_VFIO_AMBA) += vfio-amba.o
> -obj-$(CONFIG_VFIO_AMBA) += vfio-platform-base.o
> -obj-$(CONFIG_VFIO_AMBA) += reset/

