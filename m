Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3234065FF9B
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 12:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbjAFLfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 06:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbjAFLew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 06:34:52 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA91B6C28C;
        Fri,  6 Jan 2023 03:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673004891; x=1704540891;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=h52bTybgotE/+arZH7dQLP3uJT6YAOrJvSJlk08qNYs=;
  b=MjN84eFLtuzD7Bpwbp/vsJ9IdpUcwYqn37ZDvS4XXWdyRPr/FUsp7qBa
   oPXpawbw4CvM56gBWRb3UY5OKZS1LBXmPH+WdbAjekQKem4rZWmtOa+2v
   IQ+a0JrMEimnBE6MmlECCFu2xs+3jaGYzcwF2WUqw1upBOkYa8FPSTa6K
   8brwitgPvwmc0zFck6o7gAvIjdI4imuhhdtTRSFAB2zPWYbqx9im7XFFg
   iwtLtdCONT/IBRujUFxV4DcM4B5TWI+3DP3OQUCv+/LGd7I+lupVeG1vG
   X8KAkY7Jh/5BG1BHBXJVJ4hQ1PUNl4+1DLzjPYP812AzKJ7ZpUkNtr92M
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322531841"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="322531841"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 03:34:51 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="655934700"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="655934700"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.211.214]) ([10.254.211.214])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 03:34:43 -0800
Message-ID: <654b8a24-e5a5-07b1-3127-46df80c1b545@linux.intel.com>
Date:   Fri, 6 Jan 2023 19:34:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH iommufd v3 3/9] vfio/type1: Convert to
 iommu_group_has_isolated_msi()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
References: <3-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <3-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/6/2023 3:33 AM, Jason Gunthorpe wrote:
> Trivially use the new API.
>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/vfio_iommu_type1.c | 16 +++-------------
>   1 file changed, 3 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 23c24fe98c00d4..393b27a3bd87ee 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -37,7 +37,6 @@
>   #include <linux/vfio.h>
>   #include <linux/workqueue.h>
>   #include <linux/notifier.h>
> -#include <linux/irqdomain.h>
>   #include "vfio.h"
>   
>   #define DRIVER_VERSION  "0.2"
> @@ -2160,12 +2159,6 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
>   	list_splice_tail(iova_copy, iova);
>   }
>   
> -/* Redundantly walks non-present capabilities to simplify caller */
> -static int vfio_iommu_device_capable(struct device *dev, void *data)
> -{
> -	return device_iommu_capable(dev, (enum iommu_cap)data);
> -}
> -
>   static int vfio_iommu_domain_alloc(struct device *dev, void *data)
>   {
>   	struct iommu_domain **domain = data;
> @@ -2180,7 +2173,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>   	struct vfio_iommu *iommu = iommu_data;
>   	struct vfio_iommu_group *group;
>   	struct vfio_domain *domain, *d;
> -	bool resv_msi, msi_remap;
> +	bool resv_msi;
>   	phys_addr_t resv_msi_base = 0;
>   	struct iommu_domain_geometry *geo;
>   	LIST_HEAD(iova_copy);
> @@ -2278,11 +2271,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>   	INIT_LIST_HEAD(&domain->group_list);
>   	list_add(&group->next, &domain->group_list);
>   
> -	msi_remap = irq_domain_check_msi_remap() ||
> -		    iommu_group_for_each_dev(iommu_group, (void *)IOMMU_CAP_INTR_REMAP,
> -					     vfio_iommu_device_capable);
> -
> -	if (!allow_unsafe_interrupts && !msi_remap) {
> +	if (!allow_unsafe_interrupts &&
> +	    !iommu_group_has_isolated_msi(iommu_group)) {
>   		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
>   		       __func__);
>   		ret = -EPERM;

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

--

Best regards,

baolu

