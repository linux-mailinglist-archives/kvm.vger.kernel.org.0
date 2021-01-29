Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF2E30903C
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 23:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbhA2Wni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 17:43:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55194 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232672AbhA2Wnh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Jan 2021 17:43:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611960130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LbYHO0OIN0PJesUWkEp0jXsyMeQWDXLUzh2xnIMXL3Q=;
        b=OnmU+wbVJCMsuJx1ksR4RvgYw2JDuRfT+GGuAkVoBWMnU6oSwHbD+aOjr1uudvZ/ZK1qfZ
        nPezTe6VGgHI2ItrAyLA/ykb8KTYRIwfmCZcJXJBWBCLIZitl04E/KA+hbCxAJzK+Shz2l
        Q7U+DMXkJ9BBdyPvKBA79jk4h9UJqTQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-dlrWlvNYNPOuC68wSry76g-1; Fri, 29 Jan 2021 17:42:06 -0500
X-MC-Unique: dlrWlvNYNPOuC68wSry76g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3DF81842140;
        Fri, 29 Jan 2021 22:42:04 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E99425C257;
        Fri, 29 Jan 2021 22:42:00 +0000 (UTC)
Date:   Fri, 29 Jan 2021 15:42:00 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH v1 3/4] vfio: Try to enable IOPF for VFIO devices
Message-ID: <20210129154200.5cc727a0@omen.home.shazbot.org>
In-Reply-To: <20210125090402.1429-4-lushenming@huawei.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
        <20210125090402.1429-4-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Jan 2021 17:04:01 +0800
Shenming Lu <lushenming@huawei.com> wrote:

> If IOMMU_DEV_FEAT_IOPF is set for the VFIO device, which means that
> the delivering of page faults of this device from the IOMMU is enabled,
> we register the VFIO page fault handler to complete the whole faulting
> path (HW+SW). And add a iopf_enabled field in struct vfio_device to
> record it.
> 
> Signed-off-by: Shenming Lu <lushenming@huawei.com>
> ---
>  drivers/vfio/vfio.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index ff7797260d0f..fd885d99ee0f 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -97,6 +97,7 @@ struct vfio_device {
>  	struct vfio_group		*group;
>  	struct list_head		group_next;
>  	void				*device_data;
> +	bool				iopf_enabled;
>  };
>  
>  #ifdef CONFIG_VFIO_NOIOMMU
> @@ -532,6 +533,21 @@ static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
>  /**
>   * Device objects - create, release, get, put, search
>   */
> +
> +static void vfio_device_enable_iopf(struct vfio_device *device)
> +{
> +	struct device *dev = device->dev;
> +
> +	if (!iommu_dev_has_feature(dev, IOMMU_DEV_FEAT_IOPF))
> +		return;
> +
> +	if (WARN_ON(iommu_register_device_fault_handler(dev,
> +					vfio_iommu_dev_fault_handler, dev)))

The layering here is wrong, vfio-core doesn't manage the IOMMU, we have
backend IOMMU drivers for that.  We can't even assume we have IOMMU API
support here, that's what the type1 backend handles.  Thanks,

Alex

> +		return;
> +
> +	device->iopf_enabled = true;
> +}
> +
>  static
>  struct vfio_device *vfio_group_create_device(struct vfio_group *group,
>  					     struct device *dev,
> @@ -549,6 +565,8 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
>  	device->group = group;
>  	device->ops = ops;
>  	device->device_data = device_data;
> +	/* By default try to enable IOPF */
> +	vfio_device_enable_iopf(device);
>  	dev_set_drvdata(dev, device);
>  
>  	/* No need to get group_lock, caller has group reference */
> @@ -573,6 +591,8 @@ static void vfio_device_release(struct kref *kref)
>  	mutex_unlock(&group->device_lock);
>  
>  	dev_set_drvdata(device->dev, NULL);
> +	if (device->iopf_enabled)
> +		WARN_ON(iommu_unregister_device_fault_handler(device->dev));
>  
>  	kfree(device);
>  

