Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F4A5F1304
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 21:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbiI3TyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 15:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiI3TyR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 15:54:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E866448
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 12:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664567655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JdU5zGTtvqneIo63GWIY70QGyez4c6naP1kmYV9v5KE=;
        b=B3AXSZ5vVUlVPyqXtytGR+17FUA87WMRll3NbSDSMnSDRRI/uk5kPc/DyqV4YY9K9s36IB
        JdAvoXUeuF/ZeMfTM+D7anr4lHqOBq0nFdaZIE0E7+NlieB6aXvfgI/5Rz6Ri9ld4rst40
        8DjfZOdTomCsar0THYm2p7QcKugP3Cc=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-85-8fEfD6hrMZmx0WJS1nOWMw-1; Fri, 30 Sep 2022 15:54:13 -0400
X-MC-Unique: 8fEfD6hrMZmx0WJS1nOWMw-1
Received: by mail-io1-f69.google.com with SMTP id e15-20020a5d8acf000000b006a3ed059e49so3467979iot.14
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 12:54:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=JdU5zGTtvqneIo63GWIY70QGyez4c6naP1kmYV9v5KE=;
        b=qSg/1nSi9h0DZAsjMym85v5gpCUyfrNRQEDvbaYf5uzlb2CGLzeoOuhJEqEqikc6zQ
         zw66DvhRfPBOkeCvJ77o5Pk6jDWoztlEjPyvqWQQL8zGJNkNg818MB5WpEBh2emboh8E
         a7KMRLLq+xtkGScdlX4q/OVtS0QM96OzVWneMLocE+1lRTyEZbnniKhS1QrMnajsNBPl
         If0tjnDwTVYeZwCb6IoNH8UTJbbhw+Rof4jtaOvZKMb6k5DMPvnRzldfNUODxjUk5x2R
         tXWG9n8TY2qwgDAjUwu8KQOkC8H2cZ7F3VN9HfWCZ8Hjtpni+N6mjXsM0p/kQe1/UxUF
         HY7w==
X-Gm-Message-State: ACrzQf2agnZuA1QDiVQN60tRthS9Q9MtAAJO4/Rrqa6Pu4ih1Far7gJ1
        KVacTTYEJa+q65PjIdsnGnqoJ9ds51qGsef5k0nRQ2W36mtyUR3n6aCbMqXeHzMzuD5JMaJfTsE
        orjFk6Ra4mbhR
X-Received: by 2002:a05:6e02:160c:b0:2f1:5fe8:9ab4 with SMTP id t12-20020a056e02160c00b002f15fe89ab4mr5181265ilu.92.1664567653168;
        Fri, 30 Sep 2022 12:54:13 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM46HAmkpBhZ6dMRbROwdSQORc0jMbU+7aKUUY626Lu1NUUDXG9Oy4sfxyLQz8TLkC4pwzpf9Q==
X-Received: by 2002:a05:6e02:160c:b0:2f1:5fe8:9ab4 with SMTP id t12-20020a056e02160c00b002f15fe89ab4mr5181259ilu.92.1664567652890;
        Fri, 30 Sep 2022 12:54:12 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h15-20020a92d08f000000b002eb1137a774sm1237333ilh.59.2022.09.30.12.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 12:54:11 -0700 (PDT)
Date:   Fri, 30 Sep 2022 13:54:09 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 4/4] vfio: Fold vfio_virqfd.ko into vfio.ko
Message-ID: <20220930135409.0cdad9b9.alex.williamson@redhat.com>
In-Reply-To: <4-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com>
References: <0-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com>
        <4-v1-10a2dba77915+c23-vfio_modules_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Sep 2022 12:04:58 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This is only 1.8k, putting it in its own module is going to waste more
> space rounding up to a PAGE_SIZE than it is worth. Put it in the main
> vfio.ko module now that kbuild can support multiple .c files.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/Makefile    |  4 +---
>  drivers/vfio/vfio.h      |  3 +++
>  drivers/vfio/vfio_main.c |  7 +++++++
>  drivers/vfio/virqfd.c    | 16 ++--------------
>  4 files changed, 13 insertions(+), 17 deletions(-)
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
>  
> -obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>  obj-$(CONFIG_VFIO_PCI) += pci/
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 4a1bac1359a952..038b5f5c8f163d 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -125,6 +125,9 @@ long vfio_container_ioctl_check_extension(struct vfio_container *container,
>  int __init vfio_container_init(void);
>  void vfio_container_cleanup(void);
>  
> +int __init vfio_virqfd_init(void);
> +void vfio_virqfd_exit(void);

It's the specific bus drivers (pci & platform) that create the
dependency on virqfd, we need some stubs in the !IS_ENABLED case.
Thanks,

Alex

