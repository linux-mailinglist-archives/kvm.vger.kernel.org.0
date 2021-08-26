Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5D53F90CF
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243821AbhHZXAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 19:00:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231307AbhHZXAN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 19:00:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630018765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yabQ6TpTO7vfw0IpUXu+/lUjTcUyI+6yR34OCnb71kM=;
        b=ZMTJftH/tyHeTwqQjI+2VPn6MpmCNzF+YSJmxiJkn3F7sIkU5ooWA5ucoEbG28sFckBUXE
        lVpjHdsQJC5UdLn9kVkUL8srBn17OtM4JPOvOIph5+TzcYrYklTRwW4VxZzDvnD3fTf32O
        YHOjuc8sv8qsg9saX6AN12FgtjXJSxo=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-jabQx-GzOwG0-n_8l7dRMA-1; Thu, 26 Aug 2021 18:59:23 -0400
X-MC-Unique: jabQx-GzOwG0-n_8l7dRMA-1
Received: by mail-oi1-f197.google.com with SMTP id q22-20020a0568080a9600b002695b5be070so2339184oij.8
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 15:59:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yabQ6TpTO7vfw0IpUXu+/lUjTcUyI+6yR34OCnb71kM=;
        b=ATa11BX6I8eX/RSoMysuyeaAJRSUikj0VS5LUjxthC/lRpXnPjditNXnOUQ9iCzSet
         RbJBcjDvQDI2V9GXlWpUen1S7trQb7fjS3Y4XHUw4dMFc/s2yWXGtsTjX4IDMR6myi/h
         z7PfTPlc5Ty2OueAuvUoD7zsN66aCJEjZdSXxC7fkkYby9vzauHh2Q/9ExLESUtg+dwg
         ISiehuAyL7q82R6Lls0JS+QnCTKXlcOykqRrCnYSYVW4EcMZhohZSBeMTG1dXuaKIn2T
         Ru3CxYOlB0J9j/kpQXjXzg3edhKiTXLaWyehpotFDKwtsBaFZrl7n72jj3+UXtz00Bdj
         Mp6w==
X-Gm-Message-State: AOAM532OnTvzH0VHsa211avaG5SVNtSbPiqNl1bdsebrWFuveF6I0SQn
        v/qCBC/i7Zl2DLQPFGbT2zYeY3jcQFfKaNRwvuQDkyIliSxHUyYo0pU543X/o6Jnz5GOB6tOB/I
        v5pKJUSR+I6Go
X-Received: by 2002:a05:6808:1d3:: with SMTP id x19mr4174804oic.137.1630018762845;
        Thu, 26 Aug 2021 15:59:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjKrq5G3IQVYgL3xcWlhnAoOrOTA9oUACchbI1vVmemlVLZNEIOv8soGuEfGqrVCzZXtJc7A==
X-Received: by 2002:a05:6808:1d3:: with SMTP id x19mr4174794oic.137.1630018762693;
        Thu, 26 Aug 2021 15:59:22 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id p64sm938814oih.29.2021.08.26.15.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 15:59:22 -0700 (PDT)
Date:   Thu, 26 Aug 2021 16:59:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 07/14] vfio: simplify iommu group allocation for
 mediated devices
Message-ID: <20210826165921.3736f766.alex.williamson@redhat.com>
In-Reply-To: <20210826133424.3362-8-hch@lst.de>
References: <20210826133424.3362-1-hch@lst.de>
        <20210826133424.3362-8-hch@lst.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 26 Aug 2021 15:34:17 +0200
Christoph Hellwig <hch@lst.de> wrote:
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 94c5e18a05e0d0..467432379b91ef 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -67,6 +67,21 @@ struct vfio_unbound_dev {
>  	struct list_head		unbound_next;
>  };
>  
> +/*
> + * Virtual device without IOMMU backing. The VFIO core fakes up an iommu_group
> + * as the iommu_group sysfs interface is part of the userspace ABI.  The user
> + * of these devices must not be able to directly trigger unmediated DMA.
> + */
> +#define VFIO_EMULATED_IOMMU	(1 << 0)
> +
> +/*
> + * Physical device without IOMMU backing. The VFIO core fakes up an iommu_group
> + * as the iommu_group sysfs interface is part of the userspace ABI.  Users can
> + * trigger unmediated DMA by the device, usage is highly dangerous, requires
> + * an explicit opt-in and will taint the kernel.
> + */
> +#define VFIO_NO_IOMMU		(1 << 1)
> +
>  struct vfio_group {
>  	struct kref			kref;
>  	int				minor;
> @@ -83,7 +98,7 @@ struct vfio_group {
>  	struct mutex			unbound_lock;
>  	atomic_t			opened;
>  	wait_queue_head_t		container_q;
> -	bool				noiommu;
> +	unsigned int			flags;

flags suggests to me a bit field, but we can't have EMULATED|NOIOMMU.
Should this be an enum iommu_type?

Note that my next branch now includes the vfio-ap changes, so respins
can include the change Jason noted directly.  Thanks,

Alex

