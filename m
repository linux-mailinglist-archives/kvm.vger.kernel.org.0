Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FBE642C5A
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiLEP6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiLEP6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:58:50 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BA21AF05
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 07:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670255930; x=1701791930;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JNqk2zo29jRbPdA2MLbxtaNrrxw57qCJpdGVShNnXcM=;
  b=WvMRs3Cd59KepwfflK4NUX7/hpInBsppz2vPU4lukqUeNRkYNAFX3c6K
   DbK08n3XMX2lg/VdNhyh14jt/JjuE8oJtU4QpS98ZPyvczot3AKD35Ias
   ZdlvFVn71CXTLOZmDrnCjo6NacHx3IBVq+ZYG9qlrI1aF6qGYSQjHRBr4
   Ran0hH2YQ99uAAV7OiHNdSDomyEOy/981WzTTQwCBjrDmClv6B6JInDSW
   OS1f909FFzLrISEDseZF3zKo1nNL2Fy7m2I5PcCpU1B/pNpU1RX297Fv8
   yvrDEGoFAB67uP8Wccvzhy53QySpDzveSD+m5N1gYEA3qcm+4LYyeewFp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="296077586"
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="296077586"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 07:58:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="734641288"
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="734641288"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.28.239]) ([10.255.28.239])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 07:58:43 -0800
Message-ID: <7403f46e-90ff-9761-0b92-8dc8c163ebf8@linux.intel.com>
Date:   Mon, 5 Dec 2022 23:58:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v6 08/19] iommufd: PFN handling for iopt_pages
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <8-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <8-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/30/2022 4:29 AM, Jason Gunthorpe wrote:
> +#ifndef __IO_PAGETABLE_H
> +#define __IO_PAGETABLE_H
> +
> +#include <linux/interval_tree.h>
> +#include <linux/mutex.h>
> +#include <linux/kref.h>
> +#include <linux/xarray.h>
> +
> +#include "iommufd_private.h"
> +
> +struct iommu_domain;
> +
> +/*
> + * Each io_pagetable is composed of intervals of areas which cover regions of
> + * the iova that are backed by something. iova not covered by areas is not
> + * populated in the page table. Each area is fully populated with pages.
> + *
> + * iovas are in byte units, but must be iopt->iova_alignment aligned.
> + *
> + * pages can be NULL, this means some other thread is still working on setting
> + * up or tearing down the area. When observed under the write side of the
> + * domain_rwsem a NULL pages must mean the area is still being setup and no
> + * domains are filled.
> + *
> + * storage_domain points at an arbitrary iommu_domain that is holding the PFNs
> + * for this area. It is locked by the pages->mutex. This simplifies the locking
> + * as the pages code can rely on the storage_domain without having to get the
> + * iopt->domains_rwsem.
> + *
> + * The io_pagetable::iova_rwsem protects node
> + * The iopt_pages::mutex protects pages_node
> + * iopt and immu_prot

typo, immu_prot -> iommu_prot


>   are immutable

> +
> +/*
> + * Carry means we carry a portion of the final hugepage over to the front of the
> + * batch
> + */
> +static void batch_clear_carry(struct pfn_batch *batch, unsigned int keep_pfns)
> +{
> +	if (!keep_pfns)
> +		return batch_clear(batch);
> +
> +	batch->total_pfns = keep_pfns;
> +	batch->npfns[0] = keep_pfns;
> +	batch->pfns[0] = batch->pfns[batch->end - 1] +
> +			 (batch->npfns[batch->end - 1] - keep_pfns);

The range of the skip_pfns is checked in batch_skip_carry, should 
keep_pfns also be checked in this function?


> +	batch->end = 0;
> +}
> +
> +static void batch_skip_carry(struct pfn_batch *batch, unsigned int skip_pfns)
> +{
> +	if (!batch->total_pfns)
> +		return;
> +	skip_pfns = min(batch->total_pfns, skip_pfns);

Should use batch->npfns[0] instead of batch->total_pfns?



> +	batch->pfns[0] += skip_pfns;
> +	batch->npfns[0] -= skip_pfns;
> +	batch->total_pfns -= skip_pfns;
> +}
> +
> +static int __batch_init(struct pfn_batch *batch, size_t max_pages, void *backup,
> +			size_t backup_len)
> +{
> +	const size_t elmsz = sizeof(*batch->pfns) + sizeof(*batch->npfns);
> +	size_t size = max_pages * elmsz;
> +
> +	batch->pfns = temp_kmalloc(&size, backup, backup_len);
> +	if (!batch->pfns)
> +		return -ENOMEM;
> +	batch->array_size = size / elmsz;
> +	batch->npfns = (u32 *)(batch->pfns + batch->array_size);
> +	batch_clear(batch);
> +	return 0;
> +}
> +
> +static int batch_init(struct pfn_batch *batch, size_t max_pages)
> +{
> +	return __batch_init(batch, max_pages, NULL, 0);
> +}
> +
> +static void batch_init_backup(struct pfn_batch *batch, size_t max_pages,
> +			      void *backup, size_t backup_len)
> +{
> +	__batch_init(batch, max_pages, backup, backup_len);
> +}
> +
> +static void batch_destroy(struct pfn_batch *batch, void *backup)
> +{
> +	if (batch->pfns != backup)
> +		kfree(batch->pfns);
> +}
> +
> +/* true if the pfn could be added, false otherwise */

It is not accurate to use "could be" here because returning ture means 
the pfn has been added.


> +static bool batch_add_pfn(struct pfn_batch *batch, unsigned long pfn)
> +{
> +	const unsigned int MAX_NPFNS = type_max(typeof(*batch->npfns));
> +
> +	if (batch->end &&
> +	    pfn == batch->pfns[batch->end - 1] + batch->npfns[batch->end - 1] &&
> +	    batch->npfns[batch->end - 1] != MAX_NPFNS) {
> +		batch->npfns[batch->end - 1]++;
> +		batch->total_pfns++;
> +		return true;
> +	}
> +	if (batch->end == batch->array_size)
> +		return false;
> +	batch->total_pfns++;
> +	batch->pfns[batch->end] = pfn;
> +	batch->npfns[batch->end] = 1;
> +	batch->end++;
> +	return true;
> +}
> +
> +/*
> + * Fill the batch with pfns from the domain. When the batch is full, or it
> + * reaches last_index, the function will return. The caller should use
> + * batch->total_pfns to determine the starting point for the next iteration.
> + */
> +static void batch_from_domain(struct pfn_batch *batch,
> +			      struct iommu_domain *domain,
> +			      struct iopt_area *area, unsigned long start_index,
> +			      unsigned long last_index)
> +{
> +	unsigned int page_offset = 0;
> +	unsigned long iova;
> +	phys_addr_t phys;
> +
> +	iova = iopt_area_index_to_iova(area, start_index);
> +	if (start_index == iopt_area_index(area))
> +		page_offset = area->page_offset;
> +	while (start_index <= last_index) {
> +		/*
> +		 * This is pretty slow, it would be nice to get the page size
> +		 * back from the driver, or have the driver directly fill the
> +		 * batch.
> +		 */
> +		phys = iommu_iova_to_phys(domain, iova) - page_offset;

seems no need to handle the page_offset, since PHYS_PFN(phys) is used in 
batch_add_pfn below?



> +		if (!batch_add_pfn(batch, PHYS_PFN(phys)))
> +			return;
> +		iova += PAGE_SIZE - page_offset;
> +		page_offset = 0;
> +		start_index++;
> +	}
> +}
> +
> +static struct page **raw_pages_from_domain(struct iommu_domain *domain,
> +					   struct iopt_area *area,
> +					   unsigned long start_index,
> +					   unsigned long last_index,
> +					   struct page **out_pages)
> +{
> +	unsigned int page_offset = 0;
> +	unsigned long iova;
> +	phys_addr_t phys;
> +
> +	iova = iopt_area_index_to_iova(area, start_index);
> +	if (start_index == iopt_area_index(area))
> +		page_offset = area->page_offset;
> +	while (start_index <= last_index) {
> +		phys = iommu_iova_to_phys(domain, iova) - page_offset;

ditto, since only PHYS_PFN(phys) is actually used, no need to handle 
page_offset



> +		*(out_pages++) = pfn_to_page(PHYS_PFN(phys));
> +		iova += PAGE_SIZE - page_offset;
> +		page_offset = 0;
> +		start_index++;
> +	}
> +	return out_pages;
> +}
> +
> +/* Continues reading a domain until we reach a discontiguity

typo, discontiguity -> discontinuity


>   in the pfns. */
> +static void batch_from_domain_continue(struct pfn_batch *batch,
> +				       struct iommu_domain *domain,
> +				       struct iopt_area *area,
> +				       unsigned long start_index,
> +				       unsigned long last_index)
> +{
> +	unsigned int array_size = batch->array_size;
> +
> +	batch->array_size = batch->end;
> +	batch_from_domain(batch, domain, area, start_index, last_index);
> +	batch->array_size = array_size;
> +}
> +

BTW, this is a quite big patch, maybe break into smaller ones?


