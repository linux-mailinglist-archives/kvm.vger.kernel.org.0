Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD57C563144
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 12:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbiGAKWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 06:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbiGAKWA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 06:22:00 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C98EA1AD90;
        Fri,  1 Jul 2022 03:21:58 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0D94113E;
        Fri,  1 Jul 2022 03:21:58 -0700 (PDT)
Received: from [10.57.85.162] (unknown [10.57.85.162])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ADFA03F66F;
        Fri,  1 Jul 2022 03:21:52 -0700 (PDT)
Message-ID: <fab41f28-8f48-9f40-09c8-fd5f0714a9e0@arm.com>
Date:   Fri, 1 Jul 2022 11:21:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Content-Language: en-GB
To:     Nicolin Chen <nicolinc@nvidia.com>, joro@8bytes.org,
        will@kernel.org, marcan@marcan.st, sven@svenpeter.dev,
        robdclark@gmail.com, baolu.lu@linux.intel.com, orsonzhai@gmail.com,
        baolin.wang7@gmail.com, zhang.lyra@gmail.com,
        jean-philippe@linaro.org, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
Cc:     suravee.suthikulpanit@amd.com, alyssa@rosenzweig.io,
        dwmw2@infradead.org, mjrosato@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, thierry.reding@gmail.com,
        vdumpa@nvidia.com, jonathanh@nvidia.com, cohuck@redhat.com,
        thunder.leizhen@huawei.com, christophe.jaillet@wanadoo.fr,
        chenxiang66@hisilicon.com, john.garry@huawei.com,
        yangyingliang@huawei.com, iommu@lists.linux-foundation.org,
        iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
References: <20220630203635.33200-1-nicolinc@nvidia.com>
 <20220630203635.33200-2-nicolinc@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220630203635.33200-2-nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-06-30 21:36, Nicolin Chen wrote:
> Cases like VFIO wish to attach a device to an existing domain that was
> not allocated specifically from the device. This raises a condition
> where the IOMMU driver can fail the domain attach because the domain and
> device are incompatible with each other.
> 
> This is a soft failure that can be resolved by using a different domain.
> 
> Provide a dedicated errno from the IOMMU driver during attach that the
> reason attached failed is because of domain incompatability. EMEDIUMTYPE
> is chosen because it is never used within the iommu subsystem today and
> evokes a sense that the 'medium' aka the domain is incompatible.
> 
> VFIO can use this to know attach is a soft failure and it should continue
> searching. Otherwise the attach will be a hard failure and VFIO will
> return the code to userspace.
> 
> Update all drivers to return EMEDIUMTYPE in their failure paths that are
> related to domain incompatability. Also remove adjacent error prints for
> these soft failures, to prevent a kernel log spam, since -EMEDIUMTYPE is
> clear enough to indicate an incompatability error.
> 
> Add kdocs describing this behavior.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
[...]
> diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> index 2ed3594f384e..072cac5ab5a4 100644
> --- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
> +++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
> @@ -1135,10 +1135,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
>   	struct arm_smmu_device *smmu;
>   	int ret;
>   
> -	if (!fwspec || fwspec->ops != &arm_smmu_ops) {
> -		dev_err(dev, "cannot attach to SMMU, is it on the same bus?\n");
> -		return -ENXIO;
> -	}
> +	if (!fwspec || fwspec->ops != &arm_smmu_ops)
> +		return -EMEDIUMTYPE;

This is the wrong check, you want the "if (smmu_domain->smmu != smmu)" 
condition further down. If this one fails it's effectively because the 
device doesn't have an IOMMU at all, and similar to patch #3 it will be 
removed once the core code takes over properly (I even have both those 
patches written now!)

Thanks,
Robin.

>   	/*
>   	 * FIXME: The arch/arm DMA API code tries to attach devices to its own
