Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1523314EAA
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 13:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhBIMGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 07:06:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:42985 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhBIMFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 07:05:20 -0500
IronPort-SDR: Zkke3K6ZRBiGI6nMCMcIQ9TCibpcKJN8455RqHcBwmzO5Gc2SSgp8aMT1QIBXZUm1j2PFVQeuo
 BfTbjNLQ0hmw==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="182012859"
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="182012859"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 04:03:16 -0800
IronPort-SDR: 0ieoaeAKU7d3c11pykydksMQ7vj3nDDcGmtrF0t/KBBgWNh9lq8KKHEiw0mCbglS6xKJI2v75a
 mLYjV2Vco98Q==
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="396093725"
Received: from yisun1-ubuntu.bj.intel.com (HELO yi.y.sun) ([10.238.156.116])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA256; 09 Feb 2021 04:03:10 -0800
Date:   Tue, 9 Feb 2021 19:57:44 +0800
From:   Yi Sun <yi.y.sun@linux.intel.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org, Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        wanghaibin.wang@huawei.com, jiangkunkun@huawei.com,
        yuzenghui@huawei.com, lushenming@huawei.com, kevin.tian@intel.com,
        yan.y.zhao@intel.com, baolu.lu@linux.intel.com
Subject: Re: [RFC PATCH 10/11] vfio/iommu_type1: Optimize dirty bitmap
 population based on iommu HWDBM
Message-ID: <20210209115744.GB28580@yi.y.sun>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-11-zhukeqian1@huawei.com>
 <20210207095630.GA28580@yi.y.sun>
 <407d28db-1f86-8d4f-ab15-3c3ac56bbe7f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <407d28db-1f86-8d4f-ab15-3c3ac56bbe7f@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21-02-07 18:40:36, Keqian Zhu wrote:
> Hi Yi,
> 
> On 2021/2/7 17:56, Yi Sun wrote:
> > Hi,
> > 
> > On 21-01-28 23:17:41, Keqian Zhu wrote:
> > 
> > [...]
> > 
> >> +static void vfio_dma_dirty_log_start(struct vfio_iommu *iommu,
> >> +				     struct vfio_dma *dma)
> >> +{
> >> +	struct vfio_domain *d;
> >> +
> >> +	list_for_each_entry(d, &iommu->domain_list, next) {
> >> +		/* Go through all domain anyway even if we fail */
> >> +		iommu_split_block(d->domain, dma->iova, dma->size);
> >> +	}
> >> +}
> > 
> > This should be a switch to prepare for dirty log start. Per Intel
> > Vtd spec, there is SLADE defined in Scalable-Mode PASID Table Entry.
> > It enables Accessed/Dirty Flags in second-level paging entries.
> > So, a generic iommu interface here is better. For Intel iommu, it
> > enables SLADE. For ARM, it splits block.
> Indeed, a generic interface name is better.
> 
> The vendor iommu driver plays vendor's specific actions to start dirty log, and Intel iommu and ARM smmu may differ. Besides, we may add more actions in ARM smmu driver in future.
> 
> One question: Though I am not familiar with Intel iommu, I think it also should split block mapping besides enable SLADE. Right?
> 
I am not familiar with ARM smmu. :) So I want to clarify if the block
in smmu is big page, e.g. 2M page? Intel Vtd manages the memory per
page, 4KB/2MB/1GB. There are two ways to manage dirty pages.
1. Keep default granularity. Just set SLADE to enable the dirty track.
2. Split big page to 4KB to get finer granularity.

But question about the second solution is if it can benefit the user
space, e.g. live migration. If my understanding about smmu block (i.e.
the big page) is correct, have you collected some performance data to
prove that the split can improve performance? Thanks!

> Thanks,
> Keqian
