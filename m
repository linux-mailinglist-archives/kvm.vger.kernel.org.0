Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A63727970
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 10:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbjFHIBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 04:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbjFHIAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 04:00:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4452102
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 00:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686211184;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bcpfobnsnpwSGK7FBh1zGhAcLR+bKyGszV5tqgJqm/U=;
        b=YnEM7lbOAFivhlEk8sRfINyb35xpk6rTryioY52UMtgMHaBwO0F55kUblsFIvoGhyIBkOL
        oishG3IGN6pXSFkEcry5hzKldCM1NOs2pMf4weOGuCDJftboofe+61kTUqJUA6ud9y9C1n
        HM+YPGMn6yahU627xR3aGjKAaG2IV5M=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-0bnJXfyUOvmZvh0bpfkJQA-1; Thu, 08 Jun 2023 03:59:42 -0400
X-MC-Unique: 0bnJXfyUOvmZvh0bpfkJQA-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-3f9c3168ed4so3431351cf.2
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 00:59:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686211182; x=1688803182;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bcpfobnsnpwSGK7FBh1zGhAcLR+bKyGszV5tqgJqm/U=;
        b=Dyfxa+11+lqeY3Fl0RW5kc9oISEi2VBzyzeYGtUp7pb1f6sy6vQ9AZI9KUxHpzfhSK
         wZWOyu68030xaO9Nm3QbjpY7EtxgDAWr/YM/djTXwUTAjJYlI8+qPRY580tCu9THCJkh
         wMuI94KumgFFNahsmLjLLgEgUjtKbyoIXxPdp5AFhl59nK1hMSUDWXRrgzZAdcvS1oOD
         NTxWXLkB2BhpypTsoLyrKCLCdB3TFRfs9HiyQRv+ky6f+EI34cst6WAeZoNHyz4aT8uX
         VtSr4MRFUOXN3LzoZ8CMdgIC+rjujzRHpxHVWVa2Z5K9mK8O1O8Kxa7JhasL1r9CeQdi
         aNpQ==
X-Gm-Message-State: AC+VfDxnnYbQY6ixWyAhLkxS1UKU7pbWR0iJVLIupn+w/z4juv5GxyDw
        Tj2XxrJ8Nu22KGWgZegX6J9nIemEo3ZOgWl0l3OQLUEuZhbzjTDcuSf1HXDblgkgftqJUeB20la
        aSZYMjSxMmD3g
X-Received: by 2002:a05:622a:202:b0:3f8:6c15:c3a5 with SMTP id b2-20020a05622a020200b003f86c15c3a5mr5349260qtx.33.1686211181797;
        Thu, 08 Jun 2023 00:59:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5aLJOX/fnYU/US4MrlU2mrgTuWb0MKVnR5oa9Qq0ddQFjcE7UzMUj+yPWUJInmeZsolZJJhA==
X-Received: by 2002:a05:622a:202:b0:3f8:6c15:c3a5 with SMTP id b2-20020a05622a020200b003f86c15c3a5mr5349247qtx.33.1686211181471;
        Thu, 08 Jun 2023 00:59:41 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d23-20020ac847d7000000b003f4f6ac0052sm148654qtr.95.2023.06.08.00.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 00:59:40 -0700 (PDT)
Message-ID: <ed625bfd-821e-1f3d-b7af-b0e614230916@redhat.com>
Date:   Thu, 8 Jun 2023 09:59:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 2/3] vfio/platform: Cleanup Kconfig
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Cc:     jgg@nvidia.com, clg@redhat.com
References: <20230607230918.3157757-1-alex.williamson@redhat.com>
 <20230607230918.3157757-3-alex.williamson@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230607230918.3157757-3-alex.williamson@redhat.com>
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

On 6/8/23 01:09, Alex Williamson wrote:
> Like vfio-pci, there's also a base module here where vfio-amba depends on
> vfio-platform, when really it only needs vfio-platform-base.  Create a
> sub-menu for platform drivers and a nested menu for reset drivers.  Cleanup
> Makefile to make use of new CONFIG_VFIO_PLATFORM_BASE for building the
> shared modules and traversing reset modules.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
looks good to me
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  drivers/vfio/Makefile               |  2 +-
>  drivers/vfio/platform/Kconfig       | 18 ++++++++++++++----
>  drivers/vfio/platform/Makefile      |  9 +++------
>  drivers/vfio/platform/reset/Kconfig |  2 ++
>  4 files changed, 20 insertions(+), 11 deletions(-)
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
> index 331a5920f5ab..88fcde51f024 100644
> --- a/drivers/vfio/platform/Kconfig
> +++ b/drivers/vfio/platform/Kconfig
> @@ -1,8 +1,14 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -config VFIO_PLATFORM
> -	tristate "VFIO support for platform devices"
> +menu "VFIO support for platform devices"
>  	depends on ARM || ARM64 || COMPILE_TEST
> +
> +config VFIO_PLATFORM_BASE
> +	tristate
>  	select VFIO_VIRQFD
> +
> +config VFIO_PLATFORM
> +	tristate "Generic VFIO support for any platform device"
> +	select VFIO_PLATFORM_BASE
>  	help
>  	  Support for platform devices with VFIO. This is required to make
>  	  use of platform devices present on the system using the VFIO
> @@ -10,10 +16,10 @@ config VFIO_PLATFORM
>  
>  	  If you don't know what to do here, say N.
>  
> -if VFIO_PLATFORM
>  config VFIO_AMBA
>  	tristate "VFIO support for AMBA devices"
>  	depends on ARM_AMBA || COMPILE_TEST
> +	select VFIO_PLATFORM_BASE
>  	help
>  	  Support for ARM AMBA devices with VFIO. This is required to make
>  	  use of ARM AMBA devices present on the system using the VFIO
> @@ -21,5 +27,9 @@ config VFIO_AMBA
>  
>  	  If you don't know what to do here, say N.
>  
> +menu "VFIO platform reset drivers"
> +	depends on VFIO_PLATFORM_BASE
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
> diff --git a/drivers/vfio/platform/reset/Kconfig b/drivers/vfio/platform/reset/Kconfig
> index 12f5f3d80387..dcc08dc145a5 100644
> --- a/drivers/vfio/platform/reset/Kconfig
> +++ b/drivers/vfio/platform/reset/Kconfig
> @@ -1,4 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> +if VFIO_PLATFORM
>  config VFIO_PLATFORM_CALXEDAXGMAC_RESET
>  	tristate "VFIO support for calxeda xgmac reset"
>  	help
> @@ -21,3 +22,4 @@ config VFIO_PLATFORM_BCMFLEXRM_RESET
>  	  Enables the VFIO platform driver to handle reset for Broadcom FlexRM
>  
>  	  If you don't know what to do here, say N.
> +endif

