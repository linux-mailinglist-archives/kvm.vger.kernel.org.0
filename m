Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86CA3D6531
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 19:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237803AbhGZQ2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 12:28:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38617 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242567AbhGZQ0p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 12:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627319233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iyj0IdCLSkgwnmaDrqsm7mbBwKFEPXj/yC7THtFMGXw=;
        b=gZ4aYDv+u+19+lvUZElOJxrMbYtYs++RlQag2s1vQjnMU/lmw9xbiGdus9CqO/nr+ZvyFm
        uwexr2B17yJSOIHasRhjJ4JfksLgiqUEEWnjyqmxsruo77KwUVaFLA3C4w64LjG7MGsMJV
        7AQll1CfLqtf7k2sSv7oLRuQ2za4QkQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-pO7TQPO3OsGcWs182cFoEQ-1; Mon, 26 Jul 2021 13:07:12 -0400
X-MC-Unique: pO7TQPO3OsGcWs182cFoEQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9D33EC1A3;
        Mon, 26 Jul 2021 17:07:10 +0000 (UTC)
Received: from localhost (unknown [10.39.192.44])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6334B5D9D3;
        Mon, 26 Jul 2021 17:07:06 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vfio/mdev: don't warn if ->request is not set
In-Reply-To: <20210726143524.155779-3-hch@lst.de>
Organization: Red Hat GmbH
References: <20210726143524.155779-1-hch@lst.de>
 <20210726143524.155779-3-hch@lst.de>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Mon, 26 Jul 2021 19:07:04 +0200
Message-ID: <87zgu93sxz.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26 2021, Christoph Hellwig <hch@lst.de> wrote:

> Only a single driver actually sets the ->request method, so don't print
> a scary warning if it isn't.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/mdev/mdev_core.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index b16606ebafa1..b314101237fe 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -138,10 +138,6 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
>  	if (!dev)
>  		return -EINVAL;
>  
> -	/* Not mandatory, but its absence could be a problem */
> -	if (!ops->request)
> -		dev_info(dev, "Driver cannot be asked to release device\n");
> -
>  	mutex_lock(&parent_list_lock);
>  
>  	/* Check for duplicate */

We also log a warning if we would like to call ->request() but none was
provided, so I think that's fine.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

But I wonder why nobody else implements this? Lack of surprise removal?

