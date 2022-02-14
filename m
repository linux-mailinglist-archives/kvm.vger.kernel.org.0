Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65CE74B4FB0
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 13:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352473AbiBNMJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 07:09:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiBNMJy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 07:09:54 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A36FC488A8;
        Mon, 14 Feb 2022 04:09:46 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E8861396;
        Mon, 14 Feb 2022 04:09:46 -0800 (PST)
Received: from [10.57.70.89] (unknown [10.57.70.89])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A6763F718;
        Mon, 14 Feb 2022 04:09:41 -0800 (PST)
Message-ID: <43f2fc07-19ea-53a4-af86-a9192a950c96@arm.com>
Date:   Mon, 14 Feb 2022 12:09:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v1 1/8] iommu: Add iommu_group_replace_domain()
Content-Language: en-GB
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     kvm@vger.kernel.org, rafael@kernel.org,
        David Airlie <airlied@linux.ie>, linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-2-baolu.lu@linux.intel.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220106022053.2406748-2-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-01-06 02:20, Lu Baolu wrote:
> Expose an interface to replace the domain of an iommu group for frameworks
> like vfio which claims the ownership of the whole iommu group.

But if the underlying point is the new expectation that 
iommu_{attach,detach}_device() operate on the device's whole group where 
relevant, why should we invent some special mechanism for VFIO to be 
needlessly inconsistent?

I said before that it's trivial for VFIO to resolve a suitable device if 
it needs to; by now I've actually written the patch ;)

https://gitlab.arm.com/linux-arm/linux-rm/-/commit/9f37d8c17c9b606abc96e1f1001c0b97c8b93ed5

Robin.

> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>   include/linux/iommu.h | 10 ++++++++++
>   drivers/iommu/iommu.c | 37 +++++++++++++++++++++++++++++++++++++
>   2 files changed, 47 insertions(+)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 408a6d2b3034..66ebce3d1e11 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -677,6 +677,9 @@ void iommu_device_unuse_dma_api(struct device *dev);
>   int iommu_group_set_dma_owner(struct iommu_group *group, void *owner);
>   void iommu_group_release_dma_owner(struct iommu_group *group);
>   bool iommu_group_dma_owner_claimed(struct iommu_group *group);
> +int iommu_group_replace_domain(struct iommu_group *group,
> +			       struct iommu_domain *old,
> +			       struct iommu_domain *new);
>   
>   #else /* CONFIG_IOMMU_API */
>   
> @@ -1090,6 +1093,13 @@ static inline bool iommu_group_dma_owner_claimed(struct iommu_group *group)
>   {
>   	return false;
>   }
> +
> +static inline int
> +iommu_group_replace_domain(struct iommu_group *group, struct iommu_domain *old,
> +			   struct iommu_domain *new)
> +{
> +	return -ENODEV;
> +}
>   #endif /* CONFIG_IOMMU_API */
>   
>   /**
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 72a95dea688e..ab8ab95969f5 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -3431,3 +3431,40 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group)
>   	return user;
>   }
>   EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
> +
> +/**
> + * iommu_group_replace_domain() - Replace group's domain
> + * @group: The group.
> + * @old: The previous attached domain. NULL for none.
> + * @new: The new domain about to be attached.
> + *
> + * This is to support backward compatibility for vfio which manages the dma
> + * ownership in iommu_group level.
> + */
> +int iommu_group_replace_domain(struct iommu_group *group,
> +			       struct iommu_domain *old,
> +			       struct iommu_domain *new)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&group->mutex);
> +	if (!group->owner || group->domain != old) {
> +		ret = -EPERM;
> +		goto unlock_out;
> +	}
> +
> +	if (old)
> +		__iommu_detach_group(old, group);
> +
> +	if (new) {
> +		ret = __iommu_attach_group(new, group);
> +		if (ret && old)
> +			__iommu_attach_group(old, group);
> +	}
> +
> +unlock_out:
> +	mutex_unlock(&group->mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_replace_domain);
