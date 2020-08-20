Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3C424C754
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 23:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgHTVtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 17:49:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40769 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727011AbgHTVtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 17:49:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597960183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W/SGQdOIGqJRv/JTZUfj1nigkzEJpxbggpHyJJW2C1s=;
        b=bMHghtW55HrEODGyI7uAve/V0fU0c8yqTSXhCpWyuTGC1sqU3AKaf4IvKqtzgZosPesCTq
        4Kqw7P+oVP/wn/fsPn6vrqVeUunn46MPZXkoqsWdr8EdoK9hry+IopVz5UL04MpxA6KwLY
        A9BhUindv8yaYgQOHPP5OZDwGQItq68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-uzFfsYIJMcmgsgWzc7zHIQ-1; Thu, 20 Aug 2020 17:49:24 -0400
X-MC-Unique: uzFfsYIJMcmgsgWzc7zHIQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB9781015C9C;
        Thu, 20 Aug 2020 21:49:02 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9E5E7B90C;
        Thu, 20 Aug 2020 21:48:53 +0000 (UTC)
Date:   Thu, 20 Aug 2020 15:48:53 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     eric.auger@redhat.com, baolu.lu@linux.intel.com, joro@8bytes.org,
        kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 12/15] vfio/type1: Add vSVA support for IOMMU-backed
 mdevs
Message-ID: <20200820154853.21b660d2@x1.home>
In-Reply-To: <1595917664-33276-13-git-send-email-yi.l.liu@intel.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
        <1595917664-33276-13-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Jul 2020 23:27:41 -0700
Liu Yi L <yi.l.liu@intel.com> wrote:

> Recent years, mediated device pass-through framework (e.g. vfio-mdev)
> is used to achieve flexible device sharing across domains (e.g. VMs).
> Also there are hardware assisted mediated pass-through solutions from
> platform vendors. e.g. Intel VT-d scalable mode which supports Intel
> Scalable I/O Virtualization technology. Such mdevs are called IOMMU-
> backed mdevs as there are IOMMU enforced DMA isolation for such mdevs.
> In kernel, IOMMU-backed mdevs are exposed to IOMMU layer by aux-domain

Or a physical IOMMU backing device.

> concept, which means mdevs are protected by an iommu domain which is
> auxiliary to the domain that the kernel driver primarily uses for DMA
> API. Details can be found in the KVM presentation as below:
> 
> https://events19.linuxfoundation.org/wp-content/uploads/2017/12/\
> Hardware-Assisted-Mediated-Pass-Through-with-VFIO-Kevin-Tian-Intel.pdf

I think letting the line exceed 80 columns is preferable so that it's
clickable.  Thanks,

Alex

> This patch extends NESTING_IOMMU ops to IOMMU-backed mdev devices. The
> main requirement is to use the auxiliary domain associated with mdev.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> CC: Jun Tian <jun.j.tian@intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
> v5 -> v6:
> *) add review-by from Eric Auger.
> 
> v1 -> v2:
> *) check the iommu_device to ensure the handling mdev is IOMMU-backed
> ---
>  drivers/vfio/vfio_iommu_type1.c | 40 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index bf95a0f..9d8f252 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2379,20 +2379,41 @@ static int vfio_iommu_resv_refresh(struct vfio_iommu *iommu,
>  	return ret;
>  }
>  
> +static struct device *vfio_get_iommu_device(struct vfio_group *group,
> +					    struct device *dev)
> +{
> +	if (group->mdev_group)
> +		return vfio_mdev_get_iommu_device(dev);
> +	else
> +		return dev;
> +}
> +
>  static int vfio_dev_bind_gpasid_fn(struct device *dev, void *data)
>  {
>  	struct domain_capsule *dc = (struct domain_capsule *)data;
>  	unsigned long arg = *(unsigned long *)dc->data;
> +	struct device *iommu_device;
> +
> +	iommu_device = vfio_get_iommu_device(dc->group, dev);
> +	if (!iommu_device)
> +		return -EINVAL;
>  
> -	return iommu_uapi_sva_bind_gpasid(dc->domain, dev, (void __user *)arg);
> +	return iommu_uapi_sva_bind_gpasid(dc->domain, iommu_device,
> +					  (void __user *)arg);
>  }
>  
>  static int vfio_dev_unbind_gpasid_fn(struct device *dev, void *data)
>  {
>  	struct domain_capsule *dc = (struct domain_capsule *)data;
>  	unsigned long arg = *(unsigned long *)dc->data;
> +	struct device *iommu_device;
>  
> -	iommu_uapi_sva_unbind_gpasid(dc->domain, dev, (void __user *)arg);
> +	iommu_device = vfio_get_iommu_device(dc->group, dev);
> +	if (!iommu_device)
> +		return -EINVAL;
> +
> +	iommu_uapi_sva_unbind_gpasid(dc->domain, iommu_device,
> +				     (void __user *)arg);
>  	return 0;
>  }
>  
> @@ -2401,8 +2422,13 @@ static int __vfio_dev_unbind_gpasid_fn(struct device *dev, void *data)
>  	struct domain_capsule *dc = (struct domain_capsule *)data;
>  	struct iommu_gpasid_bind_data *unbind_data =
>  				(struct iommu_gpasid_bind_data *)dc->data;
> +	struct device *iommu_device;
> +
> +	iommu_device = vfio_get_iommu_device(dc->group, dev);
> +	if (!iommu_device)
> +		return -EINVAL;
>  
> -	iommu_sva_unbind_gpasid(dc->domain, dev, unbind_data);
> +	iommu_sva_unbind_gpasid(dc->domain, iommu_device, unbind_data);
>  	return 0;
>  }
>  
> @@ -3060,8 +3086,14 @@ static int vfio_dev_cache_invalidate_fn(struct device *dev, void *data)
>  {
>  	struct domain_capsule *dc = (struct domain_capsule *)data;
>  	unsigned long arg = *(unsigned long *)dc->data;
> +	struct device *iommu_device;
> +
> +	iommu_device = vfio_get_iommu_device(dc->group, dev);
> +	if (!iommu_device)
> +		return -EINVAL;
>  
> -	iommu_uapi_cache_invalidate(dc->domain, dev, (void __user *)arg);
> +	iommu_uapi_cache_invalidate(dc->domain, iommu_device,
> +				    (void __user *)arg);
>  	return 0;
>  }
>  

