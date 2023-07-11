Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9976974F71B
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 19:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbjGKRXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 13:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbjGKRWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 13:22:54 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2D81994;
        Tue, 11 Jul 2023 10:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689096149; x=1720632149;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CpW8kvvc/ZnO1puaWFpehGXVctv82waY7wFcuPwcuzU=;
  b=XtVnyhXu8Nu7yV4wY2n/VpnK6jzCxC10gg4pV/fSwWz/d9Tf8C1K5vWL
   rmKm1+ga3Q8pSAovZlHxZ/TclBcs3ajJwW6NJOjcZ4d8cwn51c1GI+rka
   rtjeMkXnGFTQVrWe/EI4fwSzoMXz4hj05bRm94i9TpWWyv8IwFCc4Oc+4
   01DP8Xx5ABAnrqmB/1GTO6lftTFcG+tXgiK2PuaMlZuCt5D/G31N8lJX5
   SMzM2GxFGP7VxSYLFgtpy/zIntlDIBEbh6H+/NPDj/ulFz95I9WtVLZPS
   eBqzzf7ErzUlKa/YicEstQLRtCRcWfxpenhvLiqGtKEkIQ2NJhRB1xd7M
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="451046126"
X-IronPort-AV: E=Sophos;i="6.01,197,1684825200"; 
   d="scan'208";a="451046126"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 10:21:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="895249329"
X-IronPort-AV: E=Sophos;i="6.01,197,1684825200"; 
   d="scan'208";a="895249329"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.24.100.114])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 10:21:23 -0700
Date:   Tue, 11 Jul 2023 10:26:20 -0700
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
Subject: Re: [PATCH 2/9] iommu: Add device parameter to iopf handler
Message-ID: <20230711102620.37b06884@jacob-builder>
In-Reply-To: <20230711010642.19707-3-baolu.lu@linux.intel.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
        <20230711010642.19707-3-baolu.lu@linux.intel.com>
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

On Tue, 11 Jul 2023 09:06:35 +0800, Lu Baolu <baolu.lu@linux.intel.com>
wrote:

> Add the device parameter to the iopf handler so that it can know which
> device this fault was generated.
> 
> This is necessary for use cases such as delivering IO page faults to user
> space. The IOMMUFD layer needs to be able to lookup the device id of a
> fault and route it together with the fault message to the user space.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  include/linux/iommu.h      | 1 +
>  drivers/iommu/iommu-sva.h  | 4 ++--
>  drivers/iommu/io-pgfault.c | 2 +-
>  drivers/iommu/iommu-sva.c  | 2 +-
>  4 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 0eb0fb852020..a00fb43b5e73 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -249,6 +249,7 @@ struct iommu_domain {
>  	struct iommu_domain_geometry geometry;
>  	struct iommu_dma_cookie *iova_cookie;
>  	enum iommu_page_response_code (*iopf_handler)(struct iommu_fault
> *fault,
> +						      struct device *dev,
>  						      void *data);
>  	void *fault_data;
>  	union {
> diff --git a/drivers/iommu/iommu-sva.h b/drivers/iommu/iommu-sva.h
> index 54946b5a7caf..c848661c4e20 100644
> --- a/drivers/iommu/iommu-sva.h
> +++ b/drivers/iommu/iommu-sva.h
> @@ -23,7 +23,7 @@ struct iopf_queue *iopf_queue_alloc(const char *name);
>  void iopf_queue_free(struct iopf_queue *queue);
>  int iopf_queue_discard_partial(struct iopf_queue *queue);
>  enum iommu_page_response_code
> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data);
> +iommu_sva_handle_iopf(struct iommu_fault *fault, struct device *dev,
> void *data); 
>  #else /* CONFIG_IOMMU_SVA */
>  static inline int iommu_queue_iopf(struct iommu_fault *fault, void
> *cookie) @@ -63,7 +63,7 @@ static inline int
> iopf_queue_discard_partial(struct iopf_queue *queue) }
>  
>  static inline enum iommu_page_response_code
> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
> +iommu_sva_handle_iopf(struct iommu_fault *fault, struct device *dev,
> void *data) {
>  	return IOMMU_PAGE_RESP_INVALID;
>  }
> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
> index e5b8b9110c13..fa604e1b5c5c 100644
> --- a/drivers/iommu/io-pgfault.c
> +++ b/drivers/iommu/io-pgfault.c
> @@ -88,7 +88,7 @@ static void iopf_handler(struct work_struct *work)
>  		 * faults in the group if there is an error.
>  		 */
>  		if (status == IOMMU_PAGE_RESP_SUCCESS)
> -			status = domain->iopf_handler(&iopf->fault,
> +			status = domain->iopf_handler(&iopf->fault,
> group->dev, domain->fault_data);
>  
>  		if (!(iopf->fault.prm.flags &
> diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
> index 3ebd4b6586b3..14766a2b61af 100644
> --- a/drivers/iommu/iommu-sva.c
> +++ b/drivers/iommu/iommu-sva.c
> @@ -157,7 +157,7 @@ EXPORT_SYMBOL_GPL(iommu_sva_get_pasid);
>   * I/O page fault handler for SVA
>   */
>  enum iommu_page_response_code
> -iommu_sva_handle_iopf(struct iommu_fault *fault, void *data)
> +iommu_sva_handle_iopf(struct iommu_fault *fault, struct device *dev,
dev has no use for sva handler, right? mark them __always_unused?

> void *data) {
>  	vm_fault_t ret;
>  	struct vm_area_struct *vma;


Thanks,

Jacob
