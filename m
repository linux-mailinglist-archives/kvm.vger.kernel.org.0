Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB684232635
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 22:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgG2UdJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 16:33:09 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28557 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726476AbgG2UdJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Jul 2020 16:33:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596054788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sAxbxuOUrGRWu8VuagSnwVAFhx+iq+NHP625/yyVrik=;
        b=BwYyrLfj+PIvY+LR4fCi089g95r75QmSyiPous/k1grb79Z2X/itWz3Dv6wXZxiJWYH9nT
        FsIbQ5SLw/Bg+UhFoL8o0I0ixbdpndOVqXb/WSoMr/Mf2NDEauQWS1Foqf4yQKP6qIrfem
        HJ0qq8xXnLWlqNkWbILdraEhg10yPrM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-NEoZvTTrOlS3-Y8YSKhqag-1; Wed, 29 Jul 2020 16:33:03 -0400
X-MC-Unique: NEoZvTTrOlS3-Y8YSKhqag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A65C106B243;
        Wed, 29 Jul 2020 20:33:01 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5EEE71928;
        Wed, 29 Jul 2020 20:32:58 +0000 (UTC)
Date:   Wed, 29 Jul 2020 14:32:58 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 4/4] vfio/type1: Use iommu_aux_at(de)tach_group()
 APIs
Message-ID: <20200729143258.22533170@x1.home>
In-Reply-To: <20200714055703.5510-5-baolu.lu@linux.intel.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
        <20200714055703.5510-5-baolu.lu@linux.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jul 2020 13:57:03 +0800
Lu Baolu <baolu.lu@linux.intel.com> wrote:

> Replace iommu_aux_at(de)tach_device() with iommu_aux_at(de)tach_group().
> It also saves the IOMMU_DEV_FEAT_AUX-capable physcail device in the
> vfio_group data structure so that it could be reused in other places.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 44 ++++++---------------------------
>  1 file changed, 7 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 5e556ac9102a..f8812e68de77 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -100,6 +100,7 @@ struct vfio_dma {
>  struct vfio_group {
>  	struct iommu_group	*iommu_group;
>  	struct list_head	next;
> +	struct device		*iommu_device;
>  	bool			mdev_group;	/* An mdev group */
>  	bool			pinned_page_dirty_scope;
>  };
> @@ -1627,45 +1628,13 @@ static struct device *vfio_mdev_get_iommu_device(struct device *dev)
>  	return NULL;
>  }
>  
> -static int vfio_mdev_attach_domain(struct device *dev, void *data)
> -{
> -	struct iommu_domain *domain = data;
> -	struct device *iommu_device;
> -
> -	iommu_device = vfio_mdev_get_iommu_device(dev);
> -	if (iommu_device) {
> -		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
> -			return iommu_aux_attach_device(domain, iommu_device);
> -		else
> -			return iommu_attach_device(domain, iommu_device);
> -	}
> -
> -	return -EINVAL;
> -}
> -
> -static int vfio_mdev_detach_domain(struct device *dev, void *data)
> -{
> -	struct iommu_domain *domain = data;
> -	struct device *iommu_device;
> -
> -	iommu_device = vfio_mdev_get_iommu_device(dev);
> -	if (iommu_device) {
> -		if (iommu_dev_feature_enabled(iommu_device, IOMMU_DEV_FEAT_AUX))
> -			iommu_aux_detach_device(domain, iommu_device);
> -		else
> -			iommu_detach_device(domain, iommu_device);
> -	}
> -
> -	return 0;
> -}
> -
>  static int vfio_iommu_attach_group(struct vfio_domain *domain,
>  				   struct vfio_group *group)
>  {
>  	if (group->mdev_group)
> -		return iommu_group_for_each_dev(group->iommu_group,
> -						domain->domain,
> -						vfio_mdev_attach_domain);
> +		return iommu_aux_attach_group(domain->domain,
> +					      group->iommu_group,
> +					      group->iommu_device);

No, we previously iterated all devices in the group and used the aux
interface only when we have an iommu_device supporting aux.  If we
simply assume an mdev group only uses an aux domain we break existing
users, ex. SR-IOV VF backed mdevs.  Thanks,

Alex


>  	else
>  		return iommu_attach_group(domain->domain, group->iommu_group);
>  }
> @@ -1674,8 +1643,8 @@ static void vfio_iommu_detach_group(struct vfio_domain *domain,
>  				    struct vfio_group *group)
>  {
>  	if (group->mdev_group)
> -		iommu_group_for_each_dev(group->iommu_group, domain->domain,
> -					 vfio_mdev_detach_domain);
> +		iommu_aux_detach_group(domain->domain, group->iommu_group,
> +				       group->iommu_device);
>  	else
>  		iommu_detach_group(domain->domain, group->iommu_group);
>  }
> @@ -2007,6 +1976,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  			return 0;
>  		}
>  
> +		group->iommu_device = iommu_device;
>  		bus = iommu_device->bus;
>  	}
>  

