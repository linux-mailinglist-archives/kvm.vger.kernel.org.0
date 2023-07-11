Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09AAE74F9B8
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 23:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjGKV1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 17:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjGKV06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 17:26:58 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6799B11B;
        Tue, 11 Jul 2023 14:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689110817; x=1720646817;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C0W4vK0nHZFJTZTCOXP5H3pwC5NtQZZWQEmceLgjBEQ=;
  b=J5XvfZ0EhgHmZMpuM5wtONC1jv0cVzYSeNhLGy8qom0q8Sk/vmiJrTy0
   BwR/A+Zhfq0lV4xgiEYIRTksqq++lbHq61V7lJkt8WpAOpQs2/ngEnduP
   52u2685iLAu+u4H7dDjwtTu9hzceqhdBBxwRcl/hqir/sgGT6H+dct0Jg
   7MSGMcmJjP6VEzsTMs+IkmDtKK+fRlnMfue3IjA5Aflf+E1mw3vsEzNa9
   wo7Jg48gguyS7gqD3Jm4awvb/5G6JV0/xX2QSBE5CgHKvDbJOEsUyt3xO
   hpPCTSxQT1QBJFTubAqwpcJU5wXy3lynVzjChSk7yC58Yafv09XKasULa
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="362206928"
X-IronPort-AV: E=Sophos;i="6.01,197,1684825200"; 
   d="scan'208";a="362206928"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 14:26:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="865865649"
X-IronPort-AV: E=Sophos;i="6.01,197,1684825200"; 
   d="scan'208";a="865865649"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 14:26:55 -0700
Date:   Tue, 11 Jul 2023 14:31:51 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH 5/9] iommu: Make fault_param generic
Message-ID: <20230711143151.3191f23c@jacob-builder>
In-Reply-To: <20230711010642.19707-6-baolu.lu@linux.intel.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-6-baolu.lu@linux.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi BaoLu,

On Tue, 11 Jul 2023 09:06:38 +0800, Lu Baolu <baolu.lu@linux.intel.com>
wrote:

> The iommu faults, including recoverable faults (IO page faults) and
> unrecoverable faults (DMA faults), are generic to all devices. The
> iommu faults could possibly be triggered for every device.
> 
> The fault_param pointer under struct dev_iommu is the per-device fault
> data. Therefore, the fault_param pointer should be allocated during
> iommu device probe and freed when the device is released.
> 
> With this done, the individual iommu drivers that support iopf have no
> need to call iommu_[un]register_device_fault_handler() any more.
> This will make it easier for the iommu drivers to support iopf, and it
> will also make the fault_param allocation and free simpler.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c    | 13 +------------
>  drivers/iommu/intel/iommu.c                    | 18 ++++--------------
>  drivers/iommu/iommu.c                          | 14 ++++++++++++++
>  3 files changed, 19 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c index
> a5a63b1c947e..fa8ab9d413f8 100644 ---
> a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c +++
> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c @@ -437,7 +437,6 @@
> bool arm_smmu_master_sva_enabled(struct arm_smmu_master *master) 
>  static int arm_smmu_master_sva_enable_iopf(struct arm_smmu_master
> *master) {
> -	int ret;
>  	struct device *dev = master->dev;
>  
>  	/*
> @@ -450,16 +449,7 @@ static int arm_smmu_master_sva_enable_iopf(struct
> arm_smmu_master *master) if (!master->iopf_enabled)
>  		return -EINVAL;
>  
> -	ret = iopf_queue_add_device(master->smmu->evtq.iopf, dev);
> -	if (ret)
> -		return ret;
> -
> -	ret = iommu_register_device_fault_handler(dev, iommu_queue_iopf,
> dev);
> -	if (ret) {
> -		iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
> -		return ret;
> -	}
> -	return 0;
> +	return iopf_queue_add_device(master->smmu->evtq.iopf, dev);
>  }
>  
>  static void arm_smmu_master_sva_disable_iopf(struct arm_smmu_master
> *master) @@ -469,7 +459,6 @@ static void
> arm_smmu_master_sva_disable_iopf(struct arm_smmu_master *master) if
> (!master->iopf_enabled) return;
>  
> -	iommu_unregister_device_fault_handler(dev);
>  	iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
>  }
>  
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 5c8c5cdc36cf..22e43db20252 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4594,23 +4594,14 @@ static int intel_iommu_enable_iopf(struct device
> *dev) if (ret)
>  		return ret;
>  
> -	ret = iommu_register_device_fault_handler(dev, iommu_queue_iopf,
> dev);
> -	if (ret)
> -		goto iopf_remove_device;
> -
>  	ret = pci_enable_pri(pdev, PRQ_DEPTH);
> -	if (ret)
> -		goto iopf_unregister_handler;
> +	if (ret) {
> +		iopf_queue_remove_device(iommu->iopf_queue, dev);
> +		return ret;
> +	}
>  	info->pri_enabled = 1;
>  
>  	return 0;
> -
> -iopf_unregister_handler:
> -	iommu_unregister_device_fault_handler(dev);
> -iopf_remove_device:
> -	iopf_queue_remove_device(iommu->iopf_queue, dev);
> -
> -	return ret;
>  }
>  
>  static int intel_iommu_disable_iopf(struct device *dev)
> @@ -4637,7 +4628,6 @@ static int intel_iommu_disable_iopf(struct device
> *dev)
>  	 * fault handler and removing device from iopf queue should never
>  	 * fail.
>  	 */
> -	WARN_ON(iommu_unregister_device_fault_handler(dev));
>  	WARN_ON(iopf_queue_remove_device(iommu->iopf_queue, dev));
>  
>  	return 0;
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 65895b987e22..8d1f0935ea71 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -299,7 +299,15 @@ static int dev_iommu_get(struct device *dev)
>  		return -ENOMEM;
>  
>  	mutex_init(&param->lock);
> +	param->fault_param = kzalloc(sizeof(*param->fault_param),
> GFP_KERNEL);
since fault_param is _always_ allocated/freed along with param, can we merge
into one allocation? i.e.
 struct dev_iommu {
        struct mutex lock;
-       struct iommu_fault_param        *fault_param;
+       struct iommu_fault_param        fault_param;


> +	if (!param->fault_param) {
> +		kfree(param);
> +		return -ENOMEM;
> +	}
> +	mutex_init(&param->fault_param->lock);
> +	INIT_LIST_HEAD(&param->fault_param->faults);
>  	dev->iommu = param;
> +
>  	return 0;
>  }
>  
> @@ -312,6 +320,12 @@ static void dev_iommu_free(struct device *dev)
>  		fwnode_handle_put(param->fwspec->iommu_fwnode);
>  		kfree(param->fwspec);
>  	}
> +	/*
> +	 * All pending faults should have been drained before
> +	 * device release.
> +	 */
> +	WARN_ON_ONCE(!list_empty(&param->fault_param->faults));
> +	kfree(param->fault_param);
>  	kfree(param);
>  }
>  


Thanks,

Jacob
