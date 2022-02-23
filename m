Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62BA64C1A73
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 19:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243705AbiBWSA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 13:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243744AbiBWSAp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 13:00:45 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5C4B9424A5;
        Wed, 23 Feb 2022 10:00:17 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA723D6E;
        Wed, 23 Feb 2022 10:00:16 -0800 (PST)
Received: from [10.57.40.147] (unknown [10.57.40.147])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C7A5F3F70D;
        Wed, 23 Feb 2022 10:00:10 -0800 (PST)
Message-ID: <f830c268-daca-8e8f-a429-0c80496a7273@arm.com>
Date:   Wed, 23 Feb 2022 18:00:06 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v6 01/11] iommu: Add dma ownership management interfaces
Content-Language: en-GB
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
Cc:     Will Deacon <will@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220218005521.172832-1-baolu.lu@linux.intel.com>
 <20220218005521.172832-2-baolu.lu@linux.intel.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220218005521.172832-2-baolu.lu@linux.intel.com>
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

On 2022-02-18 00:55, Lu Baolu wrote:
[...]
> +/**
> + * iommu_group_claim_dma_owner() - Set DMA ownership of a group
> + * @group: The group.
> + * @owner: Caller specified pointer. Used for exclusive ownership.
> + *
> + * This is to support backward compatibility for vfio which manages
> + * the dma ownership in iommu_group level. New invocations on this
> + * interface should be prohibited.
> + */
> +int iommu_group_claim_dma_owner(struct iommu_group *group, void *owner)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&group->mutex);
> +	if (group->owner_cnt) {

To clarify the comment buried in the other thread, I really think we 
should just unconditionally flag the error here...

> +		if (group->owner != owner) {
> +			ret = -EPERM;
> +			goto unlock_out;
> +		}
> +	} else {
> +		if (group->domain && group->domain != group->default_domain) {
> +			ret = -EBUSY;
> +			goto unlock_out;
> +		}
> +
> +		group->owner = owner;
> +		if (group->domain)
> +			__iommu_detach_group(group->domain, group);
> +	}
> +
> +	group->owner_cnt++;
> +unlock_out:
> +	mutex_unlock(&group->mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_claim_dma_owner);
> +
> +/**
> + * iommu_group_release_dma_owner() - Release DMA ownership of a group
> + * @group: The group.
> + *
> + * Release the DMA ownership claimed by iommu_group_claim_dma_owner().
> + */
> +void iommu_group_release_dma_owner(struct iommu_group *group)
> +{
> +	mutex_lock(&group->mutex);
> +	if (WARN_ON(!group->owner_cnt || !group->owner))
> +		goto unlock_out;
> +
> +	if (--group->owner_cnt > 0)
> +		goto unlock_out;

...and equivalently just set owner_cnt directly to 0 here. I don't see a 
realistic use-case for any driver to claim the same group more than 
once, and allowing it in the API just feels like opening up various 
potential corners for things to get out of sync.

I think that's the only significant concern I have left with the series 
as a whole - you can consider my other grumbles non-blocking :)

Thanks,
Robin.

> +
> +	/*
> +	 * The UNMANAGED domain should be detached before all USER
> +	 * owners have been released.
> +	 */
> +	if (!WARN_ON(group->domain) && group->default_domain)
> +		__iommu_attach_group(group->default_domain, group);
> +	group->owner = NULL;
> +
> +unlock_out:
> +	mutex_unlock(&group->mutex);
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_release_dma_owner);
> +
> +/**
> + * iommu_group_dma_owner_claimed() - Query group dma ownership status
> + * @group: The group.
> + *
> + * This provides status query on a given group. It is racey and only for
> + * non-binding status reporting.
> + */
> +bool iommu_group_dma_owner_claimed(struct iommu_group *group)
> +{
> +	unsigned int user;
> +
> +	mutex_lock(&group->mutex);
> +	user = group->owner_cnt;
> +	mutex_unlock(&group->mutex);
> +
> +	return user;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
