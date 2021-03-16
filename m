Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37ECB33E1C1
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 23:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhCPW4C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 18:56:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54931 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229491AbhCPWzd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 18:55:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615935332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FeeGGH8986ZNN6K8zR4yQRvps+v/2ULyhtjvXaVm/BA=;
        b=MjM6NoWlexCC/b7f9Sp3YpuV2GoJoGjNTMgBvBl18Y5RevuMkgOYmeO8fJ7lK9AlmLmLHz
        tfcqDXkDPMJlTyaO3GoJEINC2mtiZhR1FiooSgpxuhH5XURIhAcpPLmt+1vJrRnpCeFf4A
        s4mF1VgUwWpRe3oT8OfrVbPFNvbf2Io=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-984T_BvZPvuKK-BExz28Iw-1; Tue, 16 Mar 2021 18:55:30 -0400
X-MC-Unique: 984T_BvZPvuKK-BExz28Iw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC67F87A82A;
        Tue, 16 Mar 2021 22:55:28 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18AB060C5C;
        Tue, 16 Mar 2021 22:55:28 +0000 (UTC)
Date:   Tue, 16 Mar 2021 16:55:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 11/14] vfio/mdev: Make to_mdev_device() into a static
 inline
Message-ID: <20210316165527.22323c24@omen.home.shazbot.org>
In-Reply-To: <11-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <11-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 20:56:03 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> The macro wrongly uses 'dev' as both the macro argument and the member
> name, which means it fails compilation if any caller uses a word other
> than 'dev' as the single argument. Fix this defect by making it into
> proper static inline, which is more clear and typesafe anyhow.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/mdev/mdev_private.h | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index 7d922950caaf3c..74c2e541146999 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -35,7 +35,10 @@ struct mdev_device {
>  	bool active;
>  };
>  
> -#define to_mdev_device(dev)	container_of(dev, struct mdev_device, dev)
> +static inline struct mdev_device *to_mdev_device(struct device *dev)
> +{
> +	return container_of(dev, struct mdev_device, dev);
> +}
>  #define dev_is_mdev(d)		((d)->bus == &mdev_bus_type)
>  
>  struct mdev_type {

Fixes: 99e3123e3d72 ("vfio-mdev: Make mdev_device private and abstract interfaces")

