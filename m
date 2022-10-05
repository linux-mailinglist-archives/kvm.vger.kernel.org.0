Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBAD55F5869
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 18:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiJEQh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 12:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiJEQh0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 12:37:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E733244547
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 09:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664987844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PWe4eIv09ga5UelBMp+kWThCIJUVB5ilrsm3Um7UTNI=;
        b=T3PxsFaoj9GAnD1t+5ALCeGg71FPi7fLOWijEnntOOoMRZmgT0Jf7v5C+ENrHehXcxIZBb
        TfbJbo6alcpi+mwwYkn5WaZnsMZh7mLRpJJ954kYSP5v7Wv/bIRH4BQncfhwDFXlF6FKwZ
        7UUWGohhr/p7Gtr7J1TxTG+4e0PEH7s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-424-WTuG__hoO7KGPQUbQ5lm9Q-1; Wed, 05 Oct 2022 12:37:18 -0400
X-MC-Unique: WTuG__hoO7KGPQUbQ5lm9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20AA529AB413;
        Wed,  5 Oct 2022 16:37:18 +0000 (UTC)
Received: from localhost (unknown [10.39.193.112])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E4D0DC15BA4;
        Wed,  5 Oct 2022 16:37:15 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/4] vfio: Fold vfio_virqfd.ko into vfio.ko
In-Reply-To: <4-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
Organization: Red Hat GmbH
References: <4-v2-18daead6a41e+98-vfio_modules_jgg@nvidia.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Wed, 05 Oct 2022 18:37:14 +0200
Message-ID: <87lepuqlad.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 03 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:

> This is only 1.8k, putting it in its own module is going to waste more
> space rounding up to a PAGE_SIZE than it is worth. Put it in the main
> vfio.ko module now that kbuild can support multiple .c files.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/Makefile    |  4 +---
>  drivers/vfio/vfio.h      | 13 +++++++++++++
>  drivers/vfio/vfio_main.c |  7 +++++++
>  drivers/vfio/virqfd.c    | 16 ++--------------
>  4 files changed, 23 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 50b8e8e3fb10dd..0721ed4831c92f 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -1,13 +1,11 @@
>  # SPDX-License-Identifier: GPL-2.0
> -vfio_virqfd-y := virqfd.o
> -
>  obj-$(CONFIG_VFIO) += vfio.o
>  
>  vfio-y += vfio_main.o \
>  	  iova_bitmap.o \
>  	  container.o
> +vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o

I think you need to make VFIO_VIRQFD bool instead of tristate now?

>  
> -obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>  obj-$(CONFIG_VFIO_PCI) += pci/

(...)

> diff --git a/drivers/vfio/virqfd.c b/drivers/vfio/virqfd.c
> index 414e98d82b02e5..0ff3c1519df0bd 100644
> --- a/drivers/vfio/virqfd.c
> +++ b/drivers/vfio/virqfd.c
> @@ -13,14 +13,10 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>

And this needs an #include "vfio.h", I think?

>  
> -#define DRIVER_VERSION  "0.1"
> -#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
> -#define DRIVER_DESC     "IRQFD support for VFIO bus drivers"
> -
>  static struct workqueue_struct *vfio_irqfd_cleanup_wq;
>  static DEFINE_SPINLOCK(virqfd_lock);
>  
> -static int __init vfio_virqfd_init(void)
> +int __init vfio_virqfd_init(void)
>  {
>  	vfio_irqfd_cleanup_wq =
>  		create_singlethread_workqueue("vfio-irqfd-cleanup");
> @@ -30,7 +26,7 @@ static int __init vfio_virqfd_init(void)
>  	return 0;
>  }
>  
> -static void __exit vfio_virqfd_exit(void)
> +void vfio_virqfd_exit(void)
>  {
>  	destroy_workqueue(vfio_irqfd_cleanup_wq);
>  }
> @@ -216,11 +212,3 @@ void vfio_virqfd_disable(struct virqfd **pvirqfd)
>  	flush_workqueue(vfio_irqfd_cleanup_wq);
>  }
>  EXPORT_SYMBOL_GPL(vfio_virqfd_disable);
> -
> -module_init(vfio_virqfd_init);
> -module_exit(vfio_virqfd_exit);
> -
> -MODULE_VERSION(DRIVER_VERSION);
> -MODULE_LICENSE("GPL v2");
> -MODULE_AUTHOR(DRIVER_AUTHOR);
> -MODULE_DESCRIPTION(DRIVER_DESC);

