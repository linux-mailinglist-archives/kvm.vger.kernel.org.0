Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4967421F75E
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 18:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgGNQct (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 12:32:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:63516 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbgGNQct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 12:32:49 -0400
IronPort-SDR: TBhSCOYiAfpQiyktt+PWuzmEWTFArAYRyBIgxuMsJCl6PciaDARBnS/FRbJYuLsHGFHmbGcJfQ
 myKhi0rwQ0ww==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="148957026"
X-IronPort-AV: E=Sophos;i="5.75,352,1589266800"; 
   d="scan'208";a="148957026"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 09:32:48 -0700
IronPort-SDR: VIIs1ZhnFb2/oR+R9r078i98dlsTEFvH/PoGIlyJf5/fUblIkEDHEi6vJ4Rx8zhuKXqvbKt5+I
 Cscr8DBfInkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,352,1589266800"; 
   d="scan'208";a="317775607"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by fmsmga002.fm.intel.com with ESMTP; 14 Jul 2020 09:32:47 -0700
Date:   Tue, 14 Jul 2020 09:39:09 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v3 2/4] iommu: Add iommu_aux_at(de)tach_group()
Message-ID: <20200714093909.1ab93c9e@jacob-builder>
In-Reply-To: <20200714055703.5510-3-baolu.lu@linux.intel.com>
References: <20200714055703.5510-1-baolu.lu@linux.intel.com>
        <20200714055703.5510-3-baolu.lu@linux.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jul 2020 13:57:01 +0800
Lu Baolu <baolu.lu@linux.intel.com> wrote:

> This adds two new aux-domain APIs for a use case like vfio/mdev where
> sub-devices derived from an aux-domain capable device are created and
> put in an iommu_group.
> 
> /**
>  * iommu_aux_attach_group - attach an aux-domain to an iommu_group
> which
>  *                          contains sub-devices (for example mdevs)
> derived
>  *                          from @dev.
>  * @domain: an aux-domain;
>  * @group:  an iommu_group which contains sub-devices derived from
> @dev;
>  * @dev:    the physical device which supports IOMMU_DEV_FEAT_AUX.
>  *
>  * Returns 0 on success, or an error value.
>  */
> int iommu_aux_attach_group(struct iommu_domain *domain,
>                            struct iommu_group *group,
>                            struct device *dev)
> 
> /**
>  * iommu_aux_detach_group - detach an aux-domain from an iommu_group
>  *
>  * @domain: an aux-domain;
>  * @group:  an iommu_group which contains sub-devices derived from
> @dev;
>  * @dev:    the physical device which supports IOMMU_DEV_FEAT_AUX.
>  *
>  * @domain must have been attached to @group via
> iommu_aux_attach_group(). */
> void iommu_aux_detach_group(struct iommu_domain *domain,
>                             struct iommu_group *group,
>                             struct device *dev)
> 
> It also adds a flag in the iommu_group data structure to identify
> an iommu_group with aux-domain attached from those normal ones.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/iommu.c | 58
> +++++++++++++++++++++++++++++++++++++++++++ include/linux/iommu.h |
> 17 +++++++++++++ 2 files changed, 75 insertions(+)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index e1fdd3531d65..cad5a19ebf22 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -45,6 +45,7 @@ struct iommu_group {
>  	struct iommu_domain *default_domain;
>  	struct iommu_domain *domain;
>  	struct list_head entry;
> +	unsigned int aux_domain_attached:1;
>  };
>  
>  struct group_device {
> @@ -2759,6 +2760,63 @@ int iommu_aux_get_pasid(struct iommu_domain
> *domain, struct device *dev) }
>  EXPORT_SYMBOL_GPL(iommu_aux_get_pasid);
>  
> +/**
> + * iommu_aux_attach_group - attach an aux-domain to an iommu_group
> which
> + *                          contains sub-devices (for example mdevs)
> derived
> + *                          from @dev.
> + * @domain: an aux-domain;
> + * @group:  an iommu_group which contains sub-devices derived from
> @dev;
> + * @dev:    the physical device which supports IOMMU_DEV_FEAT_AUX.
> + *
> + * Returns 0 on success, or an error value.
> + */
> +int iommu_aux_attach_group(struct iommu_domain *domain,
> +			   struct iommu_group *group, struct device
> *dev) +{
> +	int ret = -EBUSY;
> +
> +	mutex_lock(&group->mutex);
> +	if (group->domain)
> +		goto out_unlock;
> +
Perhaps I missed something but are we assuming only one mdev per mdev
group? That seems to change the logic where vfio does:
iommu_group_for_each_dev()
	iommu_aux_attach_device()

> +	ret = iommu_aux_attach_device(domain, dev);
> +	if (!ret) {
> +		group->domain = domain;
> +		group->aux_domain_attached = true;
> +	}
> +
> +out_unlock:
> +	mutex_unlock(&group->mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_aux_attach_group);
> +
> +/**
> + * iommu_aux_detach_group - detach an aux-domain from an iommu_group
> + *
> + * @domain: an aux-domain;
> + * @group:  an iommu_group which contains sub-devices derived from
> @dev;
> + * @dev:    the physical device which supports IOMMU_DEV_FEAT_AUX.
> + *
> + * @domain must have been attached to @group via
> iommu_aux_attach_group().
> + */
> +void iommu_aux_detach_group(struct iommu_domain *domain,
> +			    struct iommu_group *group, struct device
> *dev) +{
> +	mutex_lock(&group->mutex);
> +
> +	if (WARN_ON(!group->aux_domain_attached || group->domain !=
> domain))
> +		goto out_unlock;
> +
> +	iommu_aux_detach_device(domain, dev);
> +	group->aux_domain_attached = false;
> +	group->domain = NULL;
> +
> +out_unlock:
> +	mutex_unlock(&group->mutex);
> +}
> +EXPORT_SYMBOL_GPL(iommu_aux_detach_group);
> +
>  /**
>   * iommu_sva_bind_device() - Bind a process address space to a device
>   * @dev: the device
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 5657d4fef9f2..9506551139ab 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -635,6 +635,10 @@ bool iommu_dev_feature_enabled(struct device
> *dev, enum iommu_dev_features f); int iommu_aux_attach_device(struct
> iommu_domain *domain, struct device *dev); void
> iommu_aux_detach_device(struct iommu_domain *domain, struct device
> *dev); int iommu_aux_get_pasid(struct iommu_domain *domain, struct
> device *dev); +int iommu_aux_attach_group(struct iommu_domain *domain,
> +			   struct iommu_group *group, struct device
> *dev); +void iommu_aux_detach_group(struct iommu_domain *domain,
> +			   struct iommu_group *group, struct device
> *dev); 
>  struct iommu_sva *iommu_sva_bind_device(struct device *dev,
>  					struct mm_struct *mm,
> @@ -1023,6 +1027,19 @@ iommu_aux_get_pasid(struct iommu_domain
> *domain, struct device *dev) return -ENODEV;
>  }
>  
> +static inline int
> +iommu_aux_attach_group(struct iommu_domain *domain,
> +		       struct iommu_group *group, struct device *dev)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline void
> +iommu_aux_detach_group(struct iommu_domain *domain,
> +		       struct iommu_group *group, struct device *dev)
> +{
> +}
> +
>  static inline struct iommu_sva *
>  iommu_sva_bind_device(struct device *dev, struct mm_struct *mm, void
> *drvdata) {

[Jacob Pan]
