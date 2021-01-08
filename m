Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9192EF84E
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 20:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbhAHTke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 14:40:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22757 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728820AbhAHTke (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Jan 2021 14:40:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610134748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2BR1wW2L5clVoPBa++VkM/GA7N41sXwMjVNBIkbCu8o=;
        b=gjPMxUz7618rwYJzm7qbcA46qNYjXHb9TElHgXy2Ml68mDgoSCTcWhQqRaWU0t3IQqhZoK
        1WcvF/oeh2aN7lyC1lENrUVcUK105TrAfANACUV6LfEPUrTnfrFW2iP/Ycifi0PmbjsW42
        tUw4wkj3OO2K69xaBjlMsBMY05Fslyg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-EGJ4uVrOP7GwytZsBySrWQ-1; Fri, 08 Jan 2021 14:39:06 -0500
X-MC-Unique: EGJ4uVrOP7GwytZsBySrWQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C638D180A093;
        Fri,  8 Jan 2021 19:39:05 +0000 (UTC)
Received: from omen.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D22719C48;
        Fri,  8 Jan 2021 19:39:05 +0000 (UTC)
Date:   Fri, 8 Jan 2021 12:39:05 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V1 3/5] vfio: detect closed container
Message-ID: <20210108123905.30d647d4@omen.home>
In-Reply-To: <1609861013-129801-4-git-send-email-steven.sistare@oracle.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
        <1609861013-129801-4-git-send-email-steven.sistare@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 Jan 2021 07:36:51 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Add a function that detects if an iommu_group has a valid container.
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio.c  | 12 ++++++++++++
>  include/linux/vfio.h |  1 +
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 262ab0e..f89ab80 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -61,6 +61,7 @@ struct vfio_container {
>  	struct vfio_iommu_driver	*iommu_driver;
>  	void				*iommu_data;
>  	bool				noiommu;
> +	bool				closed;
>  };
>  
>  struct vfio_unbound_dev {
> @@ -1223,6 +1224,7 @@ static int vfio_fops_release(struct inode *inode, struct file *filep)
>  
>  	filep->private_data = NULL;
>  
> +	container->closed = true;
>  	vfio_container_put(container);
>  
>  	return 0;
> @@ -2216,6 +2218,16 @@ void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
>  }
>  EXPORT_SYMBOL_GPL(vfio_group_set_kvm);
>  
> +bool vfio_iommu_group_contained(struct iommu_group *iommu_group)
> +{
> +	struct vfio_group *group = vfio_group_get_from_iommu(iommu_group);
> +	bool ret = group && group->container && !group->container->closed;
> +
> +	vfio_group_put(group);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(vfio_iommu_group_contained);

This seems like a pointless interface, the result is immediately stale.
Anything that relies on the container staying open needs to add itself
as a user.  We already have some interfaces for that, ex.
vfio_group_get_external_user().  Thanks,

Alex

> +
>  static int vfio_register_group_notifier(struct vfio_group *group,
>  					unsigned long *events,
>  					struct notifier_block *nb)
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 38d3c6a..b2724e7 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -148,6 +148,7 @@ extern int vfio_unregister_notifier(struct device *dev,
>  
>  struct kvm;
>  extern void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
> +extern bool vfio_iommu_group_contained(struct iommu_group *group);
>  
>  /*
>   * Sub-module helpers

