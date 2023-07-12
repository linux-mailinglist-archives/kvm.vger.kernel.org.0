Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58F374FEC8
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 07:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjGLFlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 01:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbjGLFlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 01:41:13 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956E61733;
        Tue, 11 Jul 2023 22:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689140472; x=1720676472;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VdCkG+aUHB+YX+QrB1JB0j57V4c65Im7txgpR3sGBjk=;
  b=TyF9+S4gEdocRVwlomau7t0BOitrH6CXmXUwtCTPzAa1uowuVxNbdkuu
   IdCKXGAYVg1OjY7bKD3kZq2+FOGaWTqqyDdPXn/VaFZhiDOSRTgvPzM4A
   27/lIkd9Lh6Qq/v0AqtQ+3sle4XZaTvdOmL5VxqKX1jWmPMj/LXuSFOfd
   bUNvBj8S6QQAdTETVDtfu/s0mejRkUOG1mwnp5M1aW7HA3BskidzyAY30
   tkYOFyJ/caydEO/gGGuEMiFcBQ9fmyrBOxZkLuo64Kbt3KCsd6wfviVSW
   hjXM6F1/iDtw66gmrHUoA/NcRzNhykxLU8JDKDwce1/HtoZPVDZLzLlCi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="362272866"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="362272866"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 22:41:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="786900335"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="786900335"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 22:41:04 -0700
Date:   Tue, 11 Jul 2023 22:46:01 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH 2/9] iommu: Add device parameter to iopf handler
Message-ID: <20230711224601.5973ec3f@jacob-builder>
In-Reply-To: <4519fb58-9b56-3c99-48be-a70505571f4a@linux.intel.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
        <20230711010642.19707-3-baolu.lu@linux.intel.com>
        <20230711102620.37b06884@jacob-builder>
        <4519fb58-9b56-3c99-48be-a70505571f4a@linux.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Baolu,

On Wed, 12 Jul 2023 10:16:11 +0800, Baolu Lu <baolu.lu@linux.intel.com>
wrote:

> On 2023/7/12 1:26, Jacob Pan wrote:
> > Hi BaoLu,  
> 
> Hi Jacob,
> 
> > 
> > On Tue, 11 Jul 2023 09:06:35 +0800, Lu Baolu<baolu.lu@linux.intel.com>
> > wrote:
> >   
> >> Add the device parameter to the iopf handler so that it can know which
> >> device this fault was generated.
> >>
> >> This is necessary for use cases such as delivering IO page faults to
> >> user space. The IOMMUFD layer needs to be able to lookup the device id
> >> of a fault and route it together with the fault message to the user
> >> space.
> >>
> >> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
> >> ---
> >>   include/linux/iommu.h      | 1 +
> >>   drivers/iommu/iommu-sva.h  | 4 ++--
> >>   drivers/iommu/io-pgfault.c | 2 +-
> >>   drivers/iommu/iommu-sva.c  | 2 +-
> >>   4 files changed, 5 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> >> index 0eb0fb852020..a00fb43b5e73 100644
> >> --- a/include/linux/iommu.h
> >> +++ b/include/linux/iommu.h
> >> @@ -249,6 +249,7 @@ struct iommu_domain {
> >>   	struct iommu_domain_geometry geometry;
> >>   	struct iommu_dma_cookie *iova_cookie;
> >>   	enum iommu_page_response_code (*iopf_handler)(struct
> >> iommu_fault *fault,
> >> +						      struct device
> >> *dev, void *data);
> >>   	void *fault_data;
> >>   	union {
> >> diff --git a/drivers/iommu/iommu-sva.h b/drivers/iommu/iommu-sva.h
> >> index 54946b5a7caf..c848661c4e20 100644
> >> --- a/drivers/iommu/iommu-sva.h
> >> +++ b/drivers/iommu/iommu-sva.h
> >> @@ -23,7 +23,7 @@ struct iopf_queue *iopf_queue_alloc(const char
> >> *name); void iopf_queue_free(struct iopf_queue *queue);
> >>   int iopf_queue_discard_partial(struct iopf_queue *queue);
> >>   enum iommu_page_response_code
> >> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data);
> >> +iommu_sva_handle_iopf(struct iommu_fault *fault, struct device *dev,
> >> void *data);
> >>   #else /* CONFIG_IOMMU_SVA */
> >>   static inline int iommu_queue_iopf(struct iommu_fault *fault, void
> >> *cookie) @@ -63,7 +63,7 @@ static inline int
> >> iopf_queue_discard_partial(struct iopf_queue *queue) }
> >>   
> >>   static inline enum iommu_page_response_code
> >> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
> >> +iommu_sva_handle_iopf(struct iommu_fault *fault, struct device *dev,
> >> void *data) {
> >>   	return IOMMU_PAGE_RESP_INVALID;
> >>   }
> >> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
> >> index e5b8b9110c13..fa604e1b5c5c 100644
> >> --- a/drivers/iommu/io-pgfault.c
> >> +++ b/drivers/iommu/io-pgfault.c
> >> @@ -88,7 +88,7 @@ static void iopf_handler(struct work_struct *work)
> >>   		 * faults in the group if there is an error.
> >>   		 */
> >>   		if (status == IOMMU_PAGE_RESP_SUCCESS)
> >> -			status = domain->iopf_handler(&iopf->fault,
> >> +			status = domain->iopf_handler(&iopf->fault,
> >> group->dev, domain->fault_data);
> >>   
> >>   		if (!(iopf->fault.prm.flags &
> >> diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
> >> index 3ebd4b6586b3..14766a2b61af 100644
> >> --- a/drivers/iommu/iommu-sva.c
> >> +++ b/drivers/iommu/iommu-sva.c
> >> @@ -157,7 +157,7 @@ EXPORT_SYMBOL_GPL(iommu_sva_get_pasid);
> >>    * I/O page fault handler for SVA
> >>    */
> >>   enum iommu_page_response_code
> >> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
> >> +iommu_sva_handle_iopf(struct iommu_fault *fault, struct device *dev,  
> > dev has no use for sva handler, right? mark them __always_unused?  
> 
> My understanding is that __always_unused attribute in Linux kernel code
> marks a variable or function as unused. It implies that the compiler is
> free to optimize the variable or function away.
that is my understanding as well, I meant
iommu_sva_handle_iopf(struct iommu_fault *fault, struct device
__always_unused *dev,  

I tested compile w/ and w/o __always_unused, seems no difference but it
makes the code clear that dev is not used here.


Thanks,

Jacob
