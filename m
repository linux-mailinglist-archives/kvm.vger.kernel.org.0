Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5FB301093
	for <lists+kvm@lfdr.de>; Sat, 23 Jan 2021 00:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbhAVXEt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 18:04:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49747 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728459AbhAVXBu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 18:01:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611356416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/MGoskr31378raWb9UFWelLGuV5HMy6u8yIdaL3Ay7c=;
        b=P19RSMbuuZo9WljhjgQ0hZsRH+ty7PoP+SAXm9BiA/9/+MEIr5M8uC+fyOSx3dgTfHKABH
        A/kk7sDcL6sLpPx3gTJ/oRWcJQKDkHr2rBxwS+uhNcE8ul2gCwrtYhSYp9rV1im5pEtn13
        r3A6iZ8qZ38su7alMUNtwtfAop5e1Fs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515--HPopS9XNiO2Clj4noPwtg-1; Fri, 22 Jan 2021 18:00:14 -0500
X-MC-Unique: -HPopS9XNiO2Clj4noPwtg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A639E18C89CF;
        Fri, 22 Jan 2021 23:00:13 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F3345C232;
        Fri, 22 Jan 2021 23:00:13 +0000 (UTC)
Date:   Fri, 22 Jan 2021 16:00:12 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V2 8/9] vfio/type1: implement notify callback
Message-ID: <20210122160012.30349b62@omen.home.shazbot.org>
In-Reply-To: <1611078509-181959-9-git-send-email-steven.sistare@oracle.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
        <1611078509-181959-9-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jan 2021 09:48:28 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Implement a notify callback that remembers if the container's file
> descriptor has been closed.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index c307f62..0167996 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -74,6 +74,7 @@ struct vfio_iommu {
>  	bool			nesting;
>  	bool			dirty_page_tracking;
>  	bool			pinned_page_dirty_scope;
> +	bool			controlled;

s/controlled/container_open/?  Thanks,

Alex

>  };
>  
>  struct vfio_domain {
> @@ -2518,6 +2519,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>  	INIT_LIST_HEAD(&iommu->iova_list);
>  	iommu->dma_list = RB_ROOT;
>  	iommu->dma_avail = dma_entry_limit;
> +	iommu->controlled = true;
>  	mutex_init(&iommu->lock);
>  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
>  
> @@ -3043,6 +3045,18 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
>  	return ret;
>  }
>  
> +static void vfio_iommu_type1_notify(void *iommu_data, unsigned int event,
> +				    void *data)
> +{
> +	struct vfio_iommu *iommu = iommu_data;
> +
> +	if (event != VFIO_DRIVER_NOTIFY_CONTAINER_CLOSE)
> +		return;
> +	mutex_lock(&iommu->lock);
> +	iommu->controlled = false;
> +	mutex_unlock(&iommu->lock);
> +}
> +
>  static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
>  	.name			= "vfio-iommu-type1",
>  	.owner			= THIS_MODULE,
> @@ -3056,6 +3070,7 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
>  	.register_notifier	= vfio_iommu_type1_register_notifier,
>  	.unregister_notifier	= vfio_iommu_type1_unregister_notifier,
>  	.dma_rw			= vfio_iommu_type1_dma_rw,
> +	.notify			= vfio_iommu_type1_notify,
>  };
>  
>  static int __init vfio_iommu_type1_init(void)

