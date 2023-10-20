Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777D87D066E
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 04:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346758AbjJTCZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 22:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbjJTCZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 22:25:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC78C115
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 19:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697768724; x=1729304724;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DJAPxqpO5NqYvYxw6N+vBjoq1534FJBWd4yKS9r+g00=;
  b=kjfu9hyRUxqAAZMGIRRkSisA0CFzPJf6q0ix1/m4FP81Tg86xcIgr2qq
   swSl5YiLLiO+Hi8ov+t8qnZTta0sMPGZDOw4SJXu9/QCJQ9/CTFDAEnoQ
   Y1BpBXGAOiKuv4n+sLhHUA2Utg2CPzCWLH+uP4Hx5IK2/lKJAnog+q0Xr
   TRCnq3iiFopwGjDtofx2SHedRH68uvW0xhKZJFlsYjXV6ZscDH2seI6/3
   ZkhT/+OTNGgWzf7SYwGb3Q0lWHNkZSdMkLv0fEt+n2Ml3822vboz7jtf2
   2kbJZVRzOJ74E4mVo2pRy83XGDB8R4WP3/tPBmhp47GekAP2oANMFFcTi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="7979341"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="7979341"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 19:25:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="880925313"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="880925313"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga004.jf.intel.com with ESMTP; 19 Oct 2023 19:25:18 -0700
Message-ID: <31612252-e6e1-4bfc-8b82-620e79422cbc@linux.intel.com>
Date:   Fri, 20 Oct 2023 10:21:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc:     baolu.lu@linux.intel.com, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 11/18] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-12-joao.m.martins@oracle.com>
 <20231018231111.GP3952@nvidia.com>
 <2a8b0362-7185-4bca-ba06-e6a4f8de940b@oracle.com>
 <f2109ca9-b194-43f2-bed0-077d03242d1a@oracle.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <f2109ca9-b194-43f2-bed0-077d03242d1a@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/23 7:58 PM, Joao Martins wrote:
> On 19/10/2023 01:17, Joao Martins wrote:
>> On 19/10/2023 00:11, Jason Gunthorpe wrote:
>>> On Wed, Oct 18, 2023 at 09:27:08PM +0100, Joao Martins wrote:
>>>> +static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
>>>> +					 unsigned long iova, size_t size,
>>>> +					 unsigned long flags,
>>>> +					 struct iommu_dirty_bitmap *dirty)
>>>> +{
>>>> +	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
>>>> +	unsigned long end = iova + size - 1;
>>>> +
>>>> +	do {
>>>> +		unsigned long pgsize = 0;
>>>> +		u64 *ptep, pte;
>>>> +
>>>> +		ptep = fetch_pte(pgtable, iova, &pgsize);
>>>> +		if (ptep)
>>>> +			pte = READ_ONCE(*ptep);
>>> It is fine for now, but this is so slow for something that is such a
>>> fast path. We are optimizing away a TLB invalidation but leaving
>>> this???
>>>
>> More obvious reason is that I'm still working towards the 'faster' page table
>> walker. Then map/unmap code needs to do similar lookups so thought of reusing
>> the same functions as map/unmap initially. And improve it afterwards or when
>> introducing the splitting.
>>
>>> It is a radix tree, you walk trees by retaining your position at each
>>> level as you go (eg in a function per-level call chain or something)
>>> then ++ is cheap. Re-searching the entire tree every time is madness.
>> I'm aware -- I have an improved page-table walker for AMD[0] (not yet for Intel;
>> still in the works),
> Sigh, I realized that Intel's pfn_to_dma_pte() (main lookup function for
> map/unmap/iova_to_phys) does something a little off when it finds a non-present
> PTE. It allocates a page table to it; which is not OK in this specific case (I
> would argue it's neither for iova_to_phys but well maybe I misunderstand the
> expectation of that API).

pfn_to_dma_pte() doesn't allocate page for a non-present PTE if the
target_level parameter is set to 0. See below line 932.

  913 static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
  914                           unsigned long pfn, int *target_level,
  915                           gfp_t gfp)
  916 {

[...]

  927         while (1) {
  928                 void *tmp_page;
  929
  930                 offset = pfn_level_offset(pfn, level);
  931                 pte = &parent[offset];
  932                 if (!*target_level && (dma_pte_superpage(pte) || 
!dma_pte_present(pte)))
  933                         break;

So both iova_to_phys() and read_and_clear_dirty() are doing things
right:

	struct dma_pte *pte;
	int level = 0;

	pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT,
                              &level, GFP_KERNEL);
	if (pte && dma_pte_present(pte)) {
		/* The PTE is valid, check anything you want! */
		... ...
	}

Or, I am overlooking something else?

Best regards,
baolu
