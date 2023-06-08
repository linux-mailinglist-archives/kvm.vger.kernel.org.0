Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BC2727A20
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 10:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbjFHIjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 04:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbjFHIjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 04:39:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737A526B2
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 01:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686213526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cm04P6oO+2SFxwGKMr4pe3MThSM5MjevPEnBRvwrbac=;
        b=J9H9uzSXV2ix3fO0JfIUZD/Gn8Njs3gLykEm9Ryncl0RIk2fA1t+b+A8LGP+wZ+pOQSiW7
        mPwHN4wCBWHBX8QciHLUnnDWUJe+97R7CKcNuWLIDHktqYDtsL6SJOdSg19JQZe6F2vLbs
        zxGkGOHjSKrXHjHcKumvcw8gQQQNuME=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-kQdEq8o9PKGLh1oIdNMs6Q-1; Thu, 08 Jun 2023 04:38:45 -0400
X-MC-Unique: kQdEq8o9PKGLh1oIdNMs6Q-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-75ec66a016fso50853885a.2
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 01:38:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686213524; x=1688805524;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cm04P6oO+2SFxwGKMr4pe3MThSM5MjevPEnBRvwrbac=;
        b=MmVK1pAoy+htdjgoKuIdp2jFXqzjh5ZuyR7FqBtPfrd+5f+GEimuWqujyKjHme/iYZ
         Q3o8wSRV6niO6deUxcloAIsCY7OBaXe6eatvSHWcjR+ilFGWcuedRrAXtSOefLmrld2e
         XU3KkwFx1pUcHOEhCfirFKjLuP0xEyjlG29AG77UuV20gpywRdu75HwXxkVoA5yMbAHP
         yC/OSEk6KCdiKHOH1TLfX/fX1DkB/uXaad5FY70Ga2S+qB/LjtUR2ECv4VVy1/ZM+3cl
         29+4mjTWTNvlZ4dY/tsbcDg6wYlIBzifQdkUlDVqaZZS2BbNWzV1N3ABG/gyjnXGv/zO
         9kzg==
X-Gm-Message-State: AC+VfDz5bK8cwex5eBnDOI4GchCjcY6RJFGCP8J09nCDZi9dQ9VOjO2J
        sDMTb/ywszjyUNe7Vm+DuYvmSznnDYxcDOT/X6IVJSFyLMu4zymVTm9IzhdyF37+qDYm08LLAbG
        Dai79ZAgFpN4j/Aj5czY8
X-Received: by 2002:a05:620a:4409:b0:75b:23a0:deb3 with SMTP id v9-20020a05620a440900b0075b23a0deb3mr6147084qkp.49.1686213524707;
        Thu, 08 Jun 2023 01:38:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4orzMDg7bdRnj87cNIyHE8cwQ0iswuE/nKoM1GIYeWN+tL5mD6A2x1t01yagmchtYCmPjjOA==
X-Received: by 2002:a05:620a:4409:b0:75b:23a0:deb3 with SMTP id v9-20020a05620a440900b0075b23a0deb3mr6147074qkp.49.1686213524440;
        Thu, 08 Jun 2023 01:38:44 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:9e2:9000:9283:b79f:cbb3:327a? ([2a01:e0a:9e2:9000:9283:b79f:cbb3:327a])
        by smtp.gmail.com with ESMTPSA id t17-20020a05620a035100b007594a7aedb2sm175661qkm.105.2023.06.08.01.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 01:38:44 -0700 (PDT)
Message-ID: <551f2741-a4da-fa7c-8947-398d0bd75d7d@redhat.com>
Date:   Thu, 8 Jun 2023 10:38:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 2/3] vfio/platform: Cleanup Kconfig
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     jgg@nvidia.com, eric.auger@redhat.com
References: <20230607230918.3157757-1-alex.williamson@redhat.com>
 <20230607230918.3157757-3-alex.williamson@redhat.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20230607230918.3157757-3-alex.williamson@redhat.com>
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

On 6/8/23 01:09, Alex Williamson wrote:
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
>   drivers/vfio/Makefile               |  2 +-
>   drivers/vfio/platform/Kconfig       | 18 ++++++++++++++----
>   drivers/vfio/platform/Makefile      |  9 +++------
>   drivers/vfio/platform/reset/Kconfig |  2 ++
>   4 files changed, 20 insertions(+), 11 deletions(-)
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
> index 331a5920f5ab..88fcde51f024 100644
> --- a/drivers/vfio/platform/Kconfig
> +++ b/drivers/vfio/platform/Kconfig
> @@ -1,8 +1,14 @@
>   # SPDX-License-Identifier: GPL-2.0-only
> -config VFIO_PLATFORM
> -	tristate "VFIO support for platform devices"
> +menu "VFIO support for platform devices"
>   	depends on ARM || ARM64 || COMPILE_TEST
> +
> +config VFIO_PLATFORM_BASE
> +	tristate
>   	select VFIO_VIRQFD
> +
> +config VFIO_PLATFORM
> +	tristate "Generic VFIO support for any platform device"
> +	select VFIO_PLATFORM_BASE
>   	help
>   	  Support for platform devices with VFIO. This is required to make
>   	  use of platform devices present on the system using the VFIO
> @@ -10,10 +16,10 @@ config VFIO_PLATFORM
>   
>   	  If you don't know what to do here, say N.
>   
> -if VFIO_PLATFORM
>   config VFIO_AMBA
>   	tristate "VFIO support for AMBA devices"
>   	depends on ARM_AMBA || COMPILE_TEST
> +	select VFIO_PLATFORM_BASE
>   	help
>   	  Support for ARM AMBA devices with VFIO. This is required to make
>   	  use of ARM AMBA devices present on the system using the VFIO
> @@ -21,5 +27,9 @@ config VFIO_AMBA
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
> diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
> index 12f5f3d80387..dcc08dc145a5 100644
> --- a/drivers/vfio/platform/reset/Kconfig
> +++ b/drivers/vfio/platform/reset/Kconfig
> @@ -1,4 +1,5 @@
>   # SPDX-License-Identifier: GPL-2.0-only
> +if VFIO_PLATFORM
>   config VFIO_PLATFORM_CALXEDAXGMAC_RESET
>   	tristate "VFIO support for calxeda xgmac reset"
>   	help
> @@ -21,3 +22,4 @@ config VFIO_PLATFORM_BCMFLEXRM_RESET
>   	  Enables the VFIO platform driver to handle reset for Broadcom FlexRM
>   
>   	  If you don't know what to do here, say N.
> +endif

