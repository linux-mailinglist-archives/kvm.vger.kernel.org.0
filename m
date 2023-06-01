Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A9471F409
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 22:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjFAUnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 16:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjFAUna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 16:43:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE98189
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 13:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685652163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U8EfYdQY90bZ/cz7Bxbk7XK+QWwVW4LIw+R7rc15+JY=;
        b=gC3b5nABy4zcVbO9UKi37dwWKL6q+sw+hhXTPl3PJtQdokhB09THFsieT7qwP+TH1ouRbQ
        L0gdmXBEv5S3Ns/ohDlexXqIo5jbb0zoHNkhseC9F9rVuEkTjaOBDSH2mFfvSkkL9pC1jM
        UBzPtdbYJWDr18idozHIQiNsHgwPnD0=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515--5ZNt59rNUWtwlNVDMpi1w-1; Thu, 01 Jun 2023 16:42:41 -0400
X-MC-Unique: -5ZNt59rNUWtwlNVDMpi1w-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-33b0ad1027aso10669885ab.0
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 13:42:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685652161; x=1688244161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U8EfYdQY90bZ/cz7Bxbk7XK+QWwVW4LIw+R7rc15+JY=;
        b=HfD/UacC4/qO4r5keGtfHnenqd8lgKtZYTUDcYdOZau5gJYL3TOxhisfh8pjcknC/5
         dCgadGc2tAY07ALgPHY/VXeW/M+mrRk74hQZNzobe2edGApuh0qiCh6KTmI0uNfOqfEP
         33wMw/SeHDLX4Ln3lHG/GwpuEwjyO86WPXjCny1ct2u0HkgEH29KgduA6QEu82x/Rbvo
         2FGMRNPG3fYuPxwD1Qb2Ns+BnNQqJIEV2AV916eK1n2agluUJXrHNagnOdFtTSiFjn6p
         vUm0T1KV2eByOkHEGIYViAjZ//tjDM+nxe6jd6CcRPDJSdwWaBGUGSY9vldlHjqRZ4du
         Kwdg==
X-Gm-Message-State: AC+VfDzY9WtpXv0zVdwTEiuhg+5mwIJQf4JR57tEeqHOkVq4VU6xHI2A
        K2dJalMKJ3gblB/JA/h4nJnKHYZUF9CpbIp5G92yCRncnijWceXaj3h6EvLPzXaib8UNaY7yr2G
        m24t5VihPO7Zu
X-Received: by 2002:a92:de10:0:b0:33a:a93f:a87e with SMTP id x16-20020a92de10000000b0033aa93fa87emr6595355ilm.14.1685652160769;
        Thu, 01 Jun 2023 13:42:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5edWEdQwDdOisbQxqpaA8WClLh9K8917itQ49g5P0nUa2VhlOsSPWD0UneeoICGi+VJPIkzg==
X-Received: by 2002:a92:de10:0:b0:33a:a93f:a87e with SMTP id x16-20020a92de10000000b0033aa93fa87emr6595341ilm.14.1685652160407;
        Thu, 01 Jun 2023 13:42:40 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p5-20020a92c105000000b003319d8574e2sm3952533ile.25.2023.06.01.13.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jun 2023 13:42:39 -0700 (PDT)
Date:   Thu, 1 Jun 2023 14:42:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH] vfio: Fixup kconfig ordering for VFIO_PCI_CORE
Message-ID: <20230601144238.77c2ad29.alex.williamson@redhat.com>
In-Reply-To: <0-v1-7eacf832787f+86-vfio_pci_kconfig_jgg@nvidia.com>
References: <0-v1-7eacf832787f+86-vfio_pci_kconfig_jgg@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 29 May 2023 14:47:59 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Make VFIO_PCI_CORE the top level menu choice and make it directly
> selectable by the user.
> 
> This makes a sub menu with all the different PCI driver choices and causes
> VFIO_PCI to be enabled by default if the user selects "VFIO support for
> PCI devices"
> 
> Remove the duplicated 'depends on' from variant drivers and enclose all
> the different sub driver choices (including S390 which was wrongly missing
> a depends) in a single if block. This makes all the dependencies more
> robust.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/pci/Kconfig           | 17 ++++++++++++-----
>  drivers/vfio/pci/hisilicon/Kconfig |  1 -
>  drivers/vfio/pci/mlx5/Kconfig      |  1 -
>  3 files changed, 12 insertions(+), 7 deletions(-)
> 
> Slightly different than as discussed as this seem more robust at the cost of
> adding another menu layer.
> 
> diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> index f9d0c908e738c3..5e9868d5ff1569 100644
> --- a/drivers/vfio/pci/Kconfig
> +++ b/drivers/vfio/pci/Kconfig
> @@ -1,9 +1,5 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  if PCI && MMU
> -config VFIO_PCI_CORE
> -	tristate
> -	select VFIO_VIRQFD
> -	select IRQ_BYPASS_MANAGER
>  
>  config VFIO_PCI_MMAP
>  	def_bool y if !S390
> @@ -11,9 +7,19 @@ config VFIO_PCI_MMAP
>  config VFIO_PCI_INTX
>  	def_bool y if !S390
>  
> +config VFIO_PCI_CORE
> +	tristate "VFIO support for PCI devices"
> +	select VFIO_VIRQFD
> +	select IRQ_BYPASS_MANAGER
> +	help
> +	  Base support for VFIO drivers that support PCI devices. At least one
> +	  of the implementation drivers must be selected.

As enforced by what?

This is just adding one more layer of dependencies in order to select
the actual endpoint driver that is actually what anyone cares about.
Despite the above help text, I think this also allows a kernel to be
built with vfio-pci-core and nothing in-kernel that uses it.

I don't see why we wouldn't just make each of the variant drivers
select VFIO_PCI_CORE.  Thanks,

Alex

> +
> +if VFIO_PCI_CORE
> +
>  config VFIO_PCI
>  	tristate "Generic VFIO support for any PCI device"
> -	select VFIO_PCI_CORE
> +	default y
>  	help
>  	  Support for the generic PCI VFIO bus driver which can connect any
>  	  PCI device to the VFIO framework.
> @@ -60,3 +66,4 @@ source "drivers/vfio/pci/mlx5/Kconfig"
>  source "drivers/vfio/pci/hisilicon/Kconfig"
>  
>  endif
> +endif
> diff --git a/drivers/vfio/pci/hisilicon/Kconfig b/drivers/vfio/pci/hisilicon/Kconfig
> index 5daa0f45d2f99b..86826513765062 100644
> --- a/drivers/vfio/pci/hisilicon/Kconfig
> +++ b/drivers/vfio/pci/hisilicon/Kconfig
> @@ -2,7 +2,6 @@
>  config HISI_ACC_VFIO_PCI
>  	tristate "VFIO PCI support for HiSilicon ACC devices"
>  	depends on ARM64 || (COMPILE_TEST && 64BIT)
> -	depends on VFIO_PCI_CORE
>  	depends on PCI_MSI
>  	depends on CRYPTO_DEV_HISI_QM
>  	depends on CRYPTO_DEV_HISI_HPRE
> diff --git a/drivers/vfio/pci/mlx5/Kconfig b/drivers/vfio/pci/mlx5/Kconfig
> index 29ba9c504a7560..d36b18d3e21fe7 100644
> --- a/drivers/vfio/pci/mlx5/Kconfig
> +++ b/drivers/vfio/pci/mlx5/Kconfig
> @@ -2,7 +2,6 @@
>  config MLX5_VFIO_PCI
>  	tristate "VFIO support for MLX5 PCI devices"
>  	depends on MLX5_CORE
> -	depends on VFIO_PCI_CORE
>  	help
>  	  This provides migration support for MLX5 devices using the VFIO
>  	  framework.
> 
> base-commit: 8c1ee346da583718fb0a7791a1f84bdafb103caf

