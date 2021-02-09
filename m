Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEB1314EBD
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 13:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhBIMLH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 07:11:07 -0500
Received: from mga03.intel.com ([134.134.136.65]:2684 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhBIMKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 07:10:00 -0500
IronPort-SDR: xagN38vN6YCwwHcRN9pVmg1E7rvUECPcCWbwaHjohs1uRhpgPMtoJcnPBrJe5ZWD5dllMyoRHz
 0IeIc3SXHyKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="181931417"
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="181931417"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 04:08:04 -0800
IronPort-SDR: EkElaaO7PCIBA7u/r7+YS4trpQvRbTAKGLXQ9dXFuJaQMYuagqKw+/nG+EKN+fuOkgJwNMxnEj
 bFzIa3t3AiOA==
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="396095446"
Received: from yisun1-ubuntu.bj.intel.com (HELO yi.y.sun) ([10.238.156.116])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 09 Feb 2021 04:07:59 -0800
Date:   Tue, 9 Feb 2021 20:02:31 +0800
From:   Yi Sun <yi.y.sun@linux.intel.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Keqian Zhu <zhukeqian1@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>, jiangkunkun@huawei.com,
        wanghaibin.wang@huawei.com, kevin.tian@intel.com,
        yan.y.zhao@intel.com, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, lushenming@huawei.com,
        iommu@lists.linux-foundation.org, James Morse <james.morse@arm.com>
Subject: Re: [RFC PATCH 10/11] vfio/iommu_type1: Optimize dirty bitmap
 population based on iommu HWDBM
Message-ID: <20210209120231.GC28580@yi.y.sun>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-11-zhukeqian1@huawei.com>
 <20210207095630.GA28580@yi.y.sun>
 <8150bd3a-dbb9-2e2b-386b-04e66f4b68dc@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8150bd3a-dbb9-2e2b-386b-04e66f4b68dc@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21-02-09 11:16:08, Robin Murphy wrote:
> On 2021-02-07 09:56, Yi Sun wrote:
> >Hi,
> >
> >On 21-01-28 23:17:41, Keqian Zhu wrote:
> >
> >[...]
> >
> >>+static void vfio_dma_dirty_log_start(struct vfio_iommu *iommu,
> >>+				     struct vfio_dma *dma)
> >>+{
> >>+	struct vfio_domain *d;
> >>+
> >>+	list_for_each_entry(d, &iommu->domain_list, next) {
> >>+		/* Go through all domain anyway even if we fail */
> >>+		iommu_split_block(d->domain, dma->iova, dma->size);
> >>+	}
> >>+}
> >
> >This should be a switch to prepare for dirty log start. Per Intel
> >Vtd spec, there is SLADE defined in Scalable-Mode PASID Table Entry.
> >It enables Accessed/Dirty Flags in second-level paging entries.
> >So, a generic iommu interface here is better. For Intel iommu, it
> >enables SLADE. For ARM, it splits block.
> 
> From a quick look, VT-D's SLADE and SMMU's HTTU appear to be the
> exact same thing. This step isn't about enabling or disabling that
> feature itself (the proposal for SMMU is to simply leave HTTU
> enabled all the time), it's about controlling the granularity at
> which the dirty status can be detected/reported at all, since that's
> tied to the pagetable structure.
> 
> However, if an IOMMU were to come along with some other way of
> reporting dirty status that didn't depend on the granularity of
> individual mappings, then indeed it wouldn't need this operation.
> 
Per my thought, we can use these two start/stop interfaces to make
user space decide when to start/stop the dirty tracking. For Intel
SLADE, I think we can enable this bit when this start interface is
called by user space. I don't think leave SLADE enabled all the time
is necessary for Intel Vt-d. So I suggest a generic interface here.
Thanks!

> Robin.
> 
> >>+
> >>+static void vfio_dma_dirty_log_stop(struct vfio_iommu *iommu,
> >>+				    struct vfio_dma *dma)
> >>+{
> >>+	struct vfio_domain *d;
> >>+
> >>+	list_for_each_entry(d, &iommu->domain_list, next) {
> >>+		/* Go through all domain anyway even if we fail */
> >>+		iommu_merge_page(d->domain, dma->iova, dma->size,
> >>+				 d->prot | dma->prot);
> >>+	}
> >>+}
> >
> >Same as above comment, a generic interface is required here.
> >
> >>+
> >>+static void vfio_iommu_dirty_log_switch(struct vfio_iommu *iommu, bool start)
> >>+{
> >>+	struct rb_node *n;
> >>+
> >>+	/* Split and merge even if all iommu don't support HWDBM now */
> >>+	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> >>+		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> >>+
> >>+		if (!dma->iommu_mapped)
> >>+			continue;
> >>+
> >>+		/* Go through all dma range anyway even if we fail */
> >>+		if (start)
> >>+			vfio_dma_dirty_log_start(iommu, dma);
> >>+		else
> >>+			vfio_dma_dirty_log_stop(iommu, dma);
> >>+	}
> >>+}
> >>+
> >>  static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
> >>  					unsigned long arg)
> >>  {
> >>@@ -2812,8 +2900,10 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
> >>  		pgsize = 1 << __ffs(iommu->pgsize_bitmap);
> >>  		if (!iommu->dirty_page_tracking) {
> >>  			ret = vfio_dma_bitmap_alloc_all(iommu, pgsize);
> >>-			if (!ret)
> >>+			if (!ret) {
> >>  				iommu->dirty_page_tracking = true;
> >>+				vfio_iommu_dirty_log_switch(iommu, true);
> >>+			}
> >>  		}
> >>  		mutex_unlock(&iommu->lock);
> >>  		return ret;
> >>@@ -2822,6 +2912,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
> >>  		if (iommu->dirty_page_tracking) {
> >>  			iommu->dirty_page_tracking = false;
> >>  			vfio_dma_bitmap_free_all(iommu);
> >>+			vfio_iommu_dirty_log_switch(iommu, false);
> >>  		}
> >>  		mutex_unlock(&iommu->lock);
> >>  		return 0;
> >>-- 
> >>2.19.1
> >_______________________________________________
> >iommu mailing list
> >iommu@lists.linux-foundation.org
> >https://lists.linuxfoundation.org/mailman/listinfo/iommu
> >
