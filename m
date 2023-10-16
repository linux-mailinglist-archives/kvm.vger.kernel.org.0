Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3C37C9CF2
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 03:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjJPBlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Oct 2023 21:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjJPBlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Oct 2023 21:41:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B89C1
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 18:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697420463; x=1728956463;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1YVfeTOx9T9EeSUglsuZPWcB/6BF29AkQYNt6bzVrQM=;
  b=Rp5Gc5XVYuHKk3FtKga11WrNrUValsftE87ePt66ese0JDaTlG9vBQ05
   PXKinFFMdnVLJvT3RQGr9DAAmhLxWnjjYPMNDHSNWaEOjIGC0zNwSpepU
   4g3HFGyMB3Ko9cBl58gQOBY/o/RgMWVFh05HDss9iXAEoquDzgNFO9lQN
   X+6oqoMKNYRT+a/rXS4vel+tYSwpPOJ371RlMnl6df9WcUlro6UGThRR+
   5O9sTsAy7TamVhlj8d689kpSQjUdwMivDnxjbEmDYMIeQ034DGoQFnHbb
   3uN3821R8O1Ss8VfnYMKaU3+NJnTsGdVray+TmYADoo4pkry6rDeeW109
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="4040265"
X-IronPort-AV: E=Sophos;i="6.03,228,1694761200"; 
   d="scan'208";a="4040265"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2023 18:41:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="732120668"
X-IronPort-AV: E=Sophos;i="6.03,228,1694761200"; 
   d="scan'208";a="732120668"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga006.jf.intel.com with ESMTP; 15 Oct 2023 18:40:57 -0700
Message-ID: <c4816f4b-3fde-4adb-901f-4d568a4fd95a@linux.intel.com>
Date:   Mon, 16 Oct 2023 09:37:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc:     baolu.lu@linux.intel.com, Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20230923012511.10379-20-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/23/23 9:25 AM, Joao Martins wrote:
[...]
>   
> +static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
> +					  bool enable)
> +{
> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
> +	struct device_domain_info *info;
> +	int ret = -EINVAL;
> +
> +	spin_lock(&dmar_domain->lock);
> +	if (!(dmar_domain->dirty_tracking ^ enable) ||

Just out of curiosity, can we simply write

dmar_domain->dirty_tracking == enable

instead? I am not sure whether the compiler will be happy with this.

> +	    list_empty(&dmar_domain->devices)) {

list_for_each_entry is no op if list is empty, so no need to check it.

> +		spin_unlock(&dmar_domain->lock);
> +		return 0;
> +	}
> +
> +	list_for_each_entry(info, &dmar_domain->devices, link) {
> +		/* First-level page table always enables dirty bit*/
> +		if (dmar_domain->use_first_level) {

Since we leave out domain->use_first_level in the user_domain_alloc
function, we no longer need to check it here.

> +			ret = 0;
> +			break;
> +		}
> +
> +		ret = intel_pasid_setup_dirty_tracking(info->iommu, info->domain,
> +						     info->dev, IOMMU_NO_PASID,
> +						     enable);
> +		if (ret)
> +			break;

We need to unwind to the previous status here. We cannot leave some
devices with status @enable while others do not.

> +
> +	}

The VT-d driver also support attaching domain to a pasid of a device. We
also need to enable dirty tracking on those devices.

> +
> +	if (!ret)
> +		dmar_domain->dirty_tracking = enable;
> +	spin_unlock(&dmar_domain->lock);
> +
> +	return ret;
> +}

I have made some changes to the code based on my above comments. Please
let me know what you think.

static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
                                           bool enable)
{
         struct dmar_domain *dmar_domain = to_dmar_domain(domain);
         struct dev_pasid_info *dev_pasid;
         struct device_domain_info *info;
         int ret;

         spin_lock(&dmar_domain->lock);
         if (!(dmar_domain->dirty_tracking ^ enable))
                 goto out_unlock;

         list_for_each_entry(info, &dmar_domain->devices, link) {
                 ret = intel_pasid_setup_dirty_tracking(info->iommu, 
dmar_domain,
                                                        info->dev, 
IOMMU_NO_PASID,
                                                        enable);
                 if (ret)
                         goto err_unwind;
         }

         list_for_each_entry(dev_pasid, &dmar_domain->dev_pasids, 
link_domain) {
                 info = dev_iommu_priv_get(dev_pasid->dev);
                 ret = intel_pasid_setup_dirty_tracking(info->iommu, 
dmar_domain,
                                                        info->dev, 
dev_pasid->pasid,
                                                        enable);
                 if (ret)
                         goto err_unwind;
         }

         dmar_domain->dirty_tracking = enable;
out_unlock:
         spin_unlock(&dmar_domain->lock);

         return 0;

err_unwind:
         list_for_each_entry(info, &dmar_domain->devices, link)
                 intel_pasid_setup_dirty_tracking(info->iommu, 
dmar_domain, info->dev,
                                                  IOMMU_NO_PASID,
 
dmar_domain->dirty_tracking);
         list_for_each_entry(dev_pasid, &dmar_domain->dev_pasids, 
link_domain) {
                 info = dev_iommu_priv_get(dev_pasid->dev);
                 intel_pasid_setup_dirty_tracking(info->iommu, dmar_domain,
                                                  info->dev, 
dev_pasid->pasid,
 
dmar_domain->dirty_tracking);
         }
         spin_unlock(&dmar_domain->lock);

         return ret;
}

Best regards,
baolu
