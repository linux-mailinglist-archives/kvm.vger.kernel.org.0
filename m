Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FC821D68D
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 15:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgGMNPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 09:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729523AbgGMNPB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 09:15:01 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF34D206F0;
        Mon, 13 Jul 2020 13:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594646100;
        bh=vsfrQkQHuwH4Y1vXh/4DmCZ6tKypfE6qSWFzh+Q1CxI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TwkkICUs4b3I5XsQCZ7NO0M3cnFT6s/5dWcTpCmKe+uCGj+BCDhAyzY9QAqbHuGFb
         CKYDfi+beNX2Cxevmjuhay0f5WcEEfX0KSrJFnDh06AEKGNQOd1Ncu48GrSps1DD5Y
         8px6YzdOOCHDGSYWOPvvAFmzP/UfGbRI/OhrpNNc=
Date:   Mon, 13 Jul 2020 14:14:54 +0100
From:   Will Deacon <will@kernel.org>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, ashok.raj@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, jean-philippe@linaro.org,
        peterx@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v5 03/15] iommu/smmu: Report empty domain nesting info
Message-ID: <20200713131454.GA2739@willie-the-truck>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-4-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1594552870-55687-4-git-send-email-yi.l.liu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 12, 2020 at 04:20:58AM -0700, Liu Yi L wrote:
> This patch is added as instead of returning a boolean for DOMAIN_ATTR_NESTING,
> iommu_domain_get_attr() should return an iommu_nesting_info handle.
> 
> Cc: Will Deacon <will@kernel.org>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Suggested-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
> v4 -> v5:
> *) address comments from Eric Auger.
> ---
>  drivers/iommu/arm-smmu-v3.c | 29 +++++++++++++++++++++++++++--
>  drivers/iommu/arm-smmu.c    | 29 +++++++++++++++++++++++++++--
>  2 files changed, 54 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
> index f578677..ec815d7 100644
> --- a/drivers/iommu/arm-smmu-v3.c
> +++ b/drivers/iommu/arm-smmu-v3.c
> @@ -3019,6 +3019,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
>  	return group;
>  }
>  
> +static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
> +					void *data)
> +{
> +	struct iommu_nesting_info *info = (struct iommu_nesting_info *)data;
> +	unsigned int size;
> +
> +	if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> +		return -ENODEV;
> +
> +	size = sizeof(struct iommu_nesting_info);
> +
> +	/*
> +	 * if provided buffer size is smaller than expected, should
> +	 * return 0 and also the expected buffer size to caller.
> +	 */
> +	if (info->size < size) {
> +		info->size = size;
> +		return 0;
> +	}
> +
> +	/* report an empty iommu_nesting_info for now */
> +	memset(info, 0x0, size);
> +	info->size = size;
> +	return 0;
> +}

Have you verified that this doesn't break the existing usage of
DOMAIN_ATTR_NESTING in drivers/vfio/vfio_iommu_type1.c?

Will
