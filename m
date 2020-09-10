Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABFD62654D3
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 00:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgIJWGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 18:06:37 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35676 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725379AbgIJWGG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 18:06:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599775564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=05X3JBoOf2nSTm0BfJQfmt6ZAPBt0WusmBmxwnQgG+Y=;
        b=Ql29Bw41v2iZjaZm+9md8b1v75MvRgG/Ql8iUYvJ1gitxEgIBXUOrUnhbK7k5tOXHeHFcS
        h5OhjjKWCcmX0GobvmsS3VQeVoA0ZhavkmcRT6ZulibnQvZX8QFkVlJNLQJjyOOefee7II
        8SVE0ZQt9GR1niZuX68mZ2Ymq7sTfdk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-ed_PetvbPx2GWGF4j7giBg-1; Thu, 10 Sep 2020 18:06:01 -0400
X-MC-Unique: ed_PetvbPx2GWGF4j7giBg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01BE0196634A;
        Thu, 10 Sep 2020 22:05:51 +0000 (UTC)
Received: from w520.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F0E97EB74;
        Thu, 10 Sep 2020 22:05:50 +0000 (UTC)
Date:   Thu, 10 Sep 2020 16:05:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/5] iommu: Add optional subdev in aux_at(de)tach ops
Message-ID: <20200910160549.2b176ac5@w520.home>
In-Reply-To: <20200901033422.22249-2-baolu.lu@linux.intel.com>
References: <20200901033422.22249-1-baolu.lu@linux.intel.com>
        <20200901033422.22249-2-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  1 Sep 2020 11:34:18 +0800
Lu Baolu <baolu.lu@linux.intel.com> wrote:

> In the vfio/mdev use case of aux-domain, the subdevices are created from
> the physical devices with IOMMU_DEV_FEAT_AUX enabled and the aux-domains
> are attached to the subdevices through the iommu_ops.aux_attach_dev()
> interface.
> 
> Current iommu_ops.aux_at(de)tach_dev() design only takes the aux-domain
> and the physical device as the parameters, this is insufficient if we
> want the vendor iommu drivers to learn the knowledge about relationships
> between the aux-domains and the subdevices. Add a @subdev parameter to
> iommu_ops.aux_at(de)tach_dev() interfaces so that a subdevice could be
> opt-in.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/intel/iommu.c | 10 ++++++----
>  drivers/iommu/iommu.c       |  4 ++--
>  include/linux/iommu.h       |  6 ++++--
>  3 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index bce158468abf..3c12fd06856c 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -5338,8 +5338,9 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
>  	return domain_add_dev_info(to_dmar_domain(domain), dev);
>  }
>  
> -static int intel_iommu_aux_attach_device(struct iommu_domain *domain,
> -					 struct device *dev)
> +static int
> +intel_iommu_aux_attach_device(struct iommu_domain *domain,
> +			      struct device *dev, struct device *subdev)
>  {
>  	int ret;
>  
> @@ -5359,8 +5360,9 @@ static void intel_iommu_detach_device(struct iommu_domain *domain,
>  	dmar_remove_one_dev_info(dev);
>  }
>  
> -static void intel_iommu_aux_detach_device(struct iommu_domain *domain,
> -					  struct device *dev)
> +static void
> +intel_iommu_aux_detach_device(struct iommu_domain *domain, struct device *dev,
> +			      struct device *subdev)
>  {
>  	aux_domain_remove_dev(to_dmar_domain(domain), dev);
>  }
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 609bd25bf154..38cdfeb887e1 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2728,7 +2728,7 @@ int iommu_aux_attach_device(struct iommu_domain *domain, struct device *dev)
>  	int ret = -ENODEV;
>  
>  	if (domain->ops->aux_attach_dev)
> -		ret = domain->ops->aux_attach_dev(domain, dev);
> +		ret = domain->ops->aux_attach_dev(domain, dev, NULL);
>  
>  	if (!ret)
>  		trace_attach_device_to_domain(dev);
> @@ -2740,7 +2740,7 @@ EXPORT_SYMBOL_GPL(iommu_aux_attach_device);
>  void iommu_aux_detach_device(struct iommu_domain *domain, struct device *dev)
>  {
>  	if (domain->ops->aux_detach_dev) {
> -		domain->ops->aux_detach_dev(domain, dev);
> +		domain->ops->aux_detach_dev(domain, dev, NULL);
>  		trace_detach_device_from_domain(dev);
>  	}
>  }
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index fee209efb756..871267104915 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -279,8 +279,10 @@ struct iommu_ops {
>  	int (*dev_disable_feat)(struct device *dev, enum iommu_dev_features f);
>  
>  	/* Aux-domain specific attach/detach entries */
> -	int (*aux_attach_dev)(struct iommu_domain *domain, struct device *dev);
> -	void (*aux_detach_dev)(struct iommu_domain *domain, struct device *dev);
> +	int (*aux_attach_dev)(struct iommu_domain *domain, struct device *dev,
> +			      struct device *subdev);
> +	void (*aux_detach_dev)(struct iommu_domain *domain, struct device *dev,
> +			       struct device *subdev);
>  	int (*aux_get_pasid)(struct iommu_domain *domain, struct device *dev);
>  
>  	struct iommu_sva *(*sva_bind)(struct device *dev, struct mm_struct *mm,

Would this be a good spot in the code to provide comments more formally
defining this subdevice concept?  For example, what exactly is the
relationship between the device and the subdevice and which device do
we use for the remaining aux domain functions, ex. aux_get_pasid().
Thanks,

Alex

