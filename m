Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADA5C515AC1
	for <lists+kvm@lfdr.de>; Sat, 30 Apr 2022 08:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239244AbiD3GQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Apr 2022 02:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236585AbiD3GQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Apr 2022 02:16:29 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA2A8566D
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 23:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651299186; x=1682835186;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bduZeRhtcqMCTEtbZUvcivc11HeyoC6C/e3RwE5iqPo=;
  b=YknFpzfAniVh3X9WVFA6vq9Dzk7aGNv46XWAE/R0yOzf+/iKrR4pG3kL
   8c8GioB8TnquKuEhEiGQFwDB9qg8kX7laaxrdY0rdh5+joF2P2Y1tw3hn
   lWtysdWRtCKOXa0nXHT5xxQw3CevGx2W3suayLgeObTtc9wynrXFBS/zN
   EXIXmDSQ6YdJRRWmGhLoNyOdrHWkJdMKS+yJM0eacutTLj+uI9odWUOji
   MAczht3eIzXEErUc+lqQraHmkctpE3iugA6IiNo2joraOj7WQHuQ1sU8G
   /4a3DcEJprbHR1WeA6F/9VrrbIhY7ijR2cSq7B3kTOLjQ+wMbrwtI1l5s
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="265690618"
X-IronPort-AV: E=Sophos;i="5.91,187,1647327600"; 
   d="scan'208";a="265690618"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 23:13:05 -0700
X-IronPort-AV: E=Sophos;i="5.91,187,1647327600"; 
   d="scan'208";a="582625957"
Received: from aliu1-mobl.ccr.corp.intel.com (HELO [10.255.30.71]) ([10.255.30.71])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 23:13:01 -0700
Message-ID: <b214e55d-a1aa-4681-22fe-8f4fc03ca8df@linux.intel.com>
Date:   Sat, 30 Apr 2022 14:12:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC 18/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>,
        iommu@lists.linux-foundation.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-19-joao.m.martins@oracle.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20220428210933.3583-19-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/4/29 05:09, Joao Martins wrote:
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -5089,6 +5089,113 @@ static void intel_iommu_iotlb_sync_map(struct iommu_domain *domain,
>   	}
>   }
>   
> +static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
> +					  bool enable)
> +{
> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
> +	struct device_domain_info *info;
> +	unsigned long flags;
> +	int ret = -EINVAL;

	if (domain_use_first_level(dmar_domain))
		return -EOPNOTSUPP;

> +
> +	spin_lock_irqsave(&device_domain_lock, flags);
> +	if (list_empty(&dmar_domain->devices)) {
> +		spin_unlock_irqrestore(&device_domain_lock, flags);
> +		return ret;
> +	}

I agreed with Kevin's suggestion in his reply.

> +
> +	list_for_each_entry(info, &dmar_domain->devices, link) {
> +		if (!info->dev || (info->domain != dmar_domain))
> +			continue;

This check is redundant.

> +
> +		/* Dirty tracking is second-stage level SM only */
> +		if ((info->domain && domain_use_first_level(info->domain)) ||
> +		    !ecap_slads(info->iommu->ecap) ||
> +		    !sm_supported(info->iommu) || !intel_iommu_sm) {
> +			ret = -EOPNOTSUPP;
> +			continue;

Perhaps break and return -EOPNOTSUPP directly here? We are not able to
support a mixed mode, right?

> +		}
> +
> +		ret = intel_pasid_setup_dirty_tracking(info->iommu, info->domain,
> +						     info->dev, PASID_RID2PASID,
> +						     enable);
> +		if (ret)
> +			break;
> +	}
> +	spin_unlock_irqrestore(&device_domain_lock, flags);
> +
> +	/*
> +	 * We need to flush context TLB and IOTLB with any cached translations
> +	 * to force the incoming DMA requests for have its IOTLB entries tagged
> +	 * with A/D bits
> +	 */
> +	intel_flush_iotlb_all(domain);
> +	return ret;
> +}

Best regards,
baolu
