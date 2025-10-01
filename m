Return-Path: <kvm+bounces-59376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B357BB20F2
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 01:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1B8A4A3BAF
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 23:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85EB829C325;
	Wed,  1 Oct 2025 23:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FMh9DG61"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013062.outbound.protection.outlook.com [40.107.201.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F96F228CBC;
	Wed,  1 Oct 2025 23:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759360984; cv=fail; b=DY1ZWFtP8yvfp3BEg9ut9y36fk2aV1FPKjoGfHTjKlYYmHRmGJEL1A9xFx6I7BDZyNdkUIWEV1/4ZT13Mp5GYBO6UGMKVdMZiGrNtzjqwPeU3juNUz0XxGdNBukG4qL+9siLszSSJI8obyceX6PBnaQp6YGdxvtOQq+iYYlz3bo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759360984; c=relaxed/simple;
	bh=fNqFtuvL8bNcdc9eVDfc51LHSgaL9xV91GpJQPGNTUI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TCYt2rvYNnXSwApjriwqe82GwvNPJaxl0H7+zWUzlz7mg1dVN5i7bImG775EKsAsS4lWZ4FvX2Xp21REuZy0U028AO+/6IGZ21VgDnzQ/m4A3rI+L41Rw6uomt1EowZU1OsvwtCyH0tLOI4PLmaE0mehG3yn+7hbLlf2/K+JjVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FMh9DG61; arc=fail smtp.client-ip=40.107.201.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pf3Kk1C8tA7OpEhA31/DVi1nP2Urs+MEOW2TxZ2cNX/pgRMVlzpoeJlJNZXNhX3wsWStY3stP+p4DGtMHs9InmzemS6aJw2fxdZHxXSvy7Q7hn8znO6RwyLirRMTTqFKqedXmZrlR1dL2TYPz8u0RFAlmtPIrvtpjgLquakK9oBeeKVs+POLsDHV74ijfj21FygIwOAiSis4WMM3bCHOnYBj+tcA/llmNleVnFNWsGzSjCUd6AZ20JxOqWsUz0ZZZorrbDHQJXoAo60UCYOtgdx15WnfMV92TpmwbMDuR95ZCZQjZ20W22tVeBimNqquVKtlj8HxVMwJNBB6LTRilw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KiAG++CfWN6gJmYWhMrn6DYvmziM8jC9WixskkC33cY=;
 b=Ko9g/oWK+nYf37vXIRMpEz1GBAr6bZ7tZyPHx4d9r6XvNMUilmas5b0R4nLkGMyRwbaFvlyYwSMhQ2dmIU+lW5eyqMiR/Bq6I17IGefO2/nMqn5Vr1mAQD+mTbpuDVel8tIVwp/bKVCmCK+m5FV61/Te47vDKz+VFBZnQOvqZaFgcL7YXQBlX4JjpxAYZoacrIMKgUoY9s2+7gglroPxr2Cx1Wfck3N+pRsuMhodpORlK0BEezNJv4gBJUAX/7cwD2DMMfPOkMcN1zOkSO68rDza6QePUKgKmSHOPlSlstxWsZQLLFbnKoeqkE2YOkHBnKX49k2GHpWyQbfPjCTJwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KiAG++CfWN6gJmYWhMrn6DYvmziM8jC9WixskkC33cY=;
 b=FMh9DG61lJDNTI4rYo5RqH81hIDZkB+cD+eIsL/ucyELfghg1Rw8RTK3ZhrQ/3eUr/NG1HISRvJkmMgHnso5MFGwcqyRirtRf3zf8/C67Z42t2G4waI4sJ3rLt0e6lqlv9LvH/1nfBpJJsfbUM9V2K+KFVatw+gt69uZXXxY2fs=
Received: from BY3PR10CA0017.namprd10.prod.outlook.com (2603:10b6:a03:255::22)
 by CH1PR12MB9672.namprd12.prod.outlook.com (2603:10b6:610:2b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.15; Wed, 1 Oct
 2025 23:22:53 +0000
Received: from CO1PEPF000044FA.namprd21.prod.outlook.com
 (2603:10b6:a03:255:cafe::7b) by BY3PR10CA0017.outlook.office365.com
 (2603:10b6:a03:255::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.14 via Frontend Transport; Wed,
 1 Oct 2025 23:22:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044FA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.1 via Frontend Transport; Wed, 1 Oct 2025 23:22:53 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 1 Oct
 2025 16:22:51 -0700
Date: Wed, 1 Oct 2025 18:15:16 -0500
From: Michael Roth <michael.roth@amd.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yan.y.zhao@intel.com>, <tabba@google.com>, <binbin.wu@linux.intel.com>,
	<rick.p.edgecombe@intel.com>, <vannapurve@google.com>, <david@redhat.com>,
	<pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 32/51] KVM: guest_memfd: Support guestmem_hugetlb
 as custom allocator
Message-ID: <20251001231516.i7smszhzoxqebddz@amd.com>
References: <cover.1747264138.git.ackerleytng@google.com>
 <4d16522293c9a3eacdbe30148b6d6c8ad2eb5908.1747264138.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4d16522293c9a3eacdbe30148b6d6c8ad2eb5908.1747264138.git.ackerleytng@google.com>
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FA:EE_|CH1PR12MB9672:EE_
X-MS-Office365-Filtering-Correlation-Id: 40fce601-03b3-4545-c772-08de0141722d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|30052699003|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?o3KSnz4rYAdIv/Bu42EkLXImTZtxpoLFMUCOoYL0wxmX0KgYGr1/eBWfkG90?=
 =?us-ascii?Q?kEAg6rdCUn84qybs9Zw+cP5AbHzwzPf/bcV8GmOGZ5Ma7JqvR1L6XRN+Yh4X?=
 =?us-ascii?Q?IybxW4jD56Q6sjnzlXC0xjnBj6e5qHo6tbrd89hVrKpXRX3s0KnpR4D8xLdG?=
 =?us-ascii?Q?xlCccadGCoHYWbEODD8Ddml1wTDHVyKn/Dclsep/D41gYrOV9+yvt/pQWFsL?=
 =?us-ascii?Q?na6pEltpuH9QYIog6oIWzG4xTNUFLFyPrbie/HBeeMU2ULLqhY6Sj5W+Qj5U?=
 =?us-ascii?Q?ZC4s57a281SkO/FHtMOHdjGsiuT8SJQdNqsM0vDmSnFmaqcTJl+PrpWNkJzU?=
 =?us-ascii?Q?wV0a+i3hqZ2ecVZT5F/DmeL4TonlweRzoiGDYNgb4p2XD3dYEpvZ9RiWe0fB?=
 =?us-ascii?Q?G0BD718EWJMkscnBF2e8B22NhZdbwvhwSZio4ghhdzFbvqlD7cFvfcJdcCOd?=
 =?us-ascii?Q?EBYtXu1+fB+8Qtwrm4c9bKktdfww1LYgJnNDFzv87GGF2Uhkhw0UCKTEFzYF?=
 =?us-ascii?Q?tjuQc3li3k410GsKQ92L1JmAxpuUPvcJ3kyYyXoCVBs4dCeJWDinRgnpKL02?=
 =?us-ascii?Q?1KpOJ5dfb27epEzkjjYunM1107tfdg/Bgp/xCZb8/Kzd4ntZpuYIdccmpiVo?=
 =?us-ascii?Q?bVH4BJr6QMm66MUKoJAADddwcZjQvLsguEjWBRn54/9Qhn6QiPGNKUbZWQh8?=
 =?us-ascii?Q?0JonuSGcQEP1apAYsRL0WodJKnSb5i2xfL4vGfGX+JqMYOavi7fCPL/5k6sY?=
 =?us-ascii?Q?gUGe2HEbRzIOA7hTWLCQavq5w+M9/1lh/TLRISg6P3Winj5vwuXWB/RdaMNv?=
 =?us-ascii?Q?aazMEj4pgJtRj1Q33A+msOp6kTm0nImgUuE1bV5La80Qtvp99sXEAMV6NFUX?=
 =?us-ascii?Q?QgtpX7Pq1Y2euDpq9A1GPS1o12s9wMNFXufjIQeoZ7OyOpV7UlX0ahzuBxJ4?=
 =?us-ascii?Q?9LxJLbYQkZ/AjkwvNXjV53umtXGY54jryLomndFcVOE/YKQb09h7Jqo6vehJ?=
 =?us-ascii?Q?/tNCAjvlHKSvN439Q+SJekcVx9lJec8Nx8FioiISUL7kyWLp4WEiXhKwzfc+?=
 =?us-ascii?Q?5DSk5VmyL8+bT3OdyuBQHQDFsyumdYW7zuML+u+iGuZpebNyu1UZvJiGZZXu?=
 =?us-ascii?Q?aLaOqFYYiIU24rok0iw1u31dKMLVRA1Bwh+btWaDFjnD+CydA/MmEiJXmk9p?=
 =?us-ascii?Q?5VqlAzO62LHJC+3wsAmpmjUdKHUbkPqy0Y5IVXk/GIcr9oPyey5eK/QrNwLX?=
 =?us-ascii?Q?NM6kDf7G4gg2YAsy9Qt0cNuOxwfoywkFoO/5w9u+UpVU9yzJNbZeQLfj9oUd?=
 =?us-ascii?Q?f+6e7I2CNRyLsSHMfSeBwrUApflV5yeUOGQ9qW+P7JZeoQwmVzsSBuB0rcJd?=
 =?us-ascii?Q?9dUFG+jsgrcs0KKjcdzr0wiu7MKDEeHPakRdtJQh0EcObSce2HTF5xyV2WcM?=
 =?us-ascii?Q?Deh1RkO5L3D7pWd7QrxtdUhnhr3+lhCQyu922SsU2iJSYJvT4VYcHoV7bz2I?=
 =?us-ascii?Q?Aea8PI9BONHdwfhFDBTJ6dJ3qRGMeZcvJklwIsV95PPBmr9RAFwknv8R6v/8?=
 =?us-ascii?Q?wnqgXyX64BRVQ+918kg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(30052699003)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 23:22:53.1927
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40fce601-03b3-4545-c772-08de0141722d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9672

Taking Sean's cue on trimming Cc list:

On Wed, May 14, 2025 at 04:42:11PM -0700, Ackerley Tng wrote:
> This patch adds support for guestmem_hugetlb as the first custom
> allocator in guest_memfd.
> 
> If requested at guest_memfd creation time, the custom allocator will
> be used in initialization and cleanup.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> 
> Change-Id: I1eb9625dc761ecadcc2aa21480cfdfcf9ab7ce67
> ---
>  include/uapi/linux/kvm.h |   1 +
>  virt/kvm/Kconfig         |   5 +
>  virt/kvm/guest_memfd.c   | 203 +++++++++++++++++++++++++++++++++++++--
>  3 files changed, 199 insertions(+), 10 deletions(-)
> 

<snip>

> @@ -518,17 +562,24 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
>  	if (!IS_ERR(folio))
>  		return folio;
>  
> -	gfp = mapping_gfp_mask(inode->i_mapping);
> +	if (kvm_gmem_has_custom_allocator(inode)) {
> +		void *p = kvm_gmem_allocator_private(inode);
>  
> -	/* TODO: Support huge pages. */
> -	folio = filemap_alloc_folio(gfp, 0);
> -	if (!folio)
> -		return ERR_PTR(-ENOMEM);
> +		folio = kvm_gmem_allocator_ops(inode)->alloc_folio(p);
> +		if (IS_ERR(folio))
> +			return folio;

One issue with current guestmem_hugetlb implementation of ->alloc_folio()
is that if you have 2 vCPUs faulting in the same GPA range, they might both
attempt to reserve the allocation, and if they happen to be fighting
over the last folio available in the subpool, then 1 of them might return
ENOMEM and the guest will crash (this is much more likely if using 1GB
pages).

It seems like we need to allow the allocator to return EAGAIN to signal
that it's still worth retrying, but at the same time I'm not sure
guestmem_hugetlb will be able to distinguish between *actually* being
out of memory vs. a temporary situation like this. We can make
guestmem_hugetlb smarter so that it could do this but it would need to
track stuff like whether 2 allocations are in-flight for the same GPA
range, and that's sounding a lot more like something guest_memfd proper
should be doing.

There's also another potential/related issue below that I haven't run
into but seems possible...

> +	} else {
> +		gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
>  
> -	ret = mem_cgroup_charge(folio, NULL, gfp);
> -	if (ret) {
> -		folio_put(folio);
> -		return ERR_PTR(ret);
> +		folio = filemap_alloc_folio(gfp, 0);
> +		if (!folio)
> +			return ERR_PTR(-ENOMEM);
> +
> +		ret = mem_cgroup_charge(folio, NULL, gfp);
> +		if (ret) {
> +			folio_put(folio);
> +			return ERR_PTR(ret);
> +		}
>  	}
>  
>  	ret = kvm_gmem_filemap_add_folio(inode->i_mapping, folio, index);

I think the relevant bits are in another patch, but it's closely related
to the above scenario so I'll just paste it here for context:

    ret = kvm_gmem_filemap_add_folio(inode->i_mapping, folio, index_floor);
    if (ret) {
            folio_put(folio);

            /*
             * There was a race, two threads tried to get a folio indexing
             * to the same location in the filemap. The losing thread should
             * free the allocated folio, then lock the folio added to the
             * filemap by the winning thread.
             */
            if (ret == -EEXIST)
                    goto repeat;

            WARN_ON_ONCE(ret);
            return ERR_PTR(ret);
    }

    /* Leave just filemap's refcounts on folio. */
    folio_put(folio);

    ret = kvm_gmem_try_split_folio_in_filemap(inode, folio);
    if (ret)
            goto err;

    spin_lock(&inode->i_lock);
    inode->i_blocks += allocated_size / 512;
    spin_unlock(&inode->i_lock);

    /*
     * folio is the one that is allocated, this gets the folio at the
     * requested index.
     */
    folio = filemap_lock_folio(inode->i_mapping, index); 

Here you check for a similar race like the above (except the reservation
doesn't fail so you get 2+ vCPUs with allocated folios they are trying to
map), and the losing vCPUs are expected to free their un-filemapped folios
and retry to get the winning/mapped one. However, later in this function you
might end up splitting the winning page, which involves unmapping it
beforehand, so with really bad timing it seems like a "losing" vCPU can still
insert its folio in the filemap and trip up the splitting path, which I'm not
sure is handled gracefully.

This is another case where I wish we had something like a range lock so we
can still parallelize allocations with having vCPUs interleaving
allocation/splitting work for a particular range. Lacking that, maybe some
other locking scheme will work, but with allocation/splitting/HVO in the mix
it would be pretty easy to kill performance if we're not careful.

-Mike

> @@ -611,6 +662,80 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
>  	}
>  }
>  
> +/**
> + * kvm_gmem_truncate_indices() - Truncates all folios beginning @index for
> + * @nr_pages.
> + *
> + * @mapping: filemap to truncate pages from.
> + * @index: the index in the filemap to begin truncation.
> + * @nr_pages: number of PAGE_SIZE pages to truncate.
> + *
> + * Return: the number of PAGE_SIZE pages that were actually truncated.
> + */
> +static long kvm_gmem_truncate_indices(struct address_space *mapping,
> +				      pgoff_t index, size_t nr_pages)
> +{
> +	struct folio_batch fbatch;
> +	long truncated;
> +	pgoff_t last;
> +
> +	last = index + nr_pages - 1;
> +
> +	truncated = 0;
> +	folio_batch_init(&fbatch);
> +	while (filemap_get_folios(mapping, &index, last, &fbatch)) {
> +		unsigned int i;
> +
> +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +			struct folio *f = fbatch.folios[i];
> +
> +			truncated += folio_nr_pages(f);
> +			folio_lock(f);
> +			truncate_inode_folio(f->mapping, f);
> +			folio_unlock(f);
> +		}
> +
> +		folio_batch_release(&fbatch);
> +		cond_resched();
> +	}
> +
> +	return truncated;
> +}
> +
> +/**
> + * kvm_gmem_truncate_inode_aligned_pages() - Removes entire folios from filemap
> + * in @inode.
> + *
> + * @inode: inode to remove folios from.
> + * @index: start of range to be truncated. Must be hugepage aligned.
> + * @nr_pages: number of PAGE_SIZE pages to be iterated over.
> + *
> + * Removes folios beginning @index for @nr_pages from filemap in @inode, updates
> + * inode metadata.
> + */
> +static void kvm_gmem_truncate_inode_aligned_pages(struct inode *inode,
> +						  pgoff_t index,
> +						  size_t nr_pages)
> +{
> +	size_t nr_per_huge_page;
> +	long num_freed;
> +	pgoff_t idx;
> +	void *priv;
> +
> +	priv = kvm_gmem_allocator_private(inode);
> +	nr_per_huge_page = kvm_gmem_allocator_ops(inode)->nr_pages_in_folio(priv);
> +
> +	num_freed = 0;
> +	for (idx = index; idx < index + nr_pages; idx += nr_per_huge_page) {
> +		num_freed += kvm_gmem_truncate_indices(
> +			inode->i_mapping, idx, nr_per_huge_page);
> +	}
> +
> +	spin_lock(&inode->i_lock);
> +	inode->i_blocks -= (num_freed << PAGE_SHIFT) / 512;
> +	spin_unlock(&inode->i_lock);
> +}
> +
>  static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>  {
>  	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
> @@ -940,6 +1065,13 @@ static void kvm_gmem_free_inode(struct inode *inode)
>  {
>  	struct kvm_gmem_inode_private *private = kvm_gmem_private(inode);
>  
> +	/* private may be NULL if inode creation process had an error. */
> +	if (private && kvm_gmem_has_custom_allocator(inode)) {
> +		void *p = kvm_gmem_allocator_private(inode);
> +
> +		kvm_gmem_allocator_ops(inode)->inode_teardown(p, inode->i_size);
> +	}
> +
>  	kfree(private);
>  
>  	free_inode_nonrcu(inode);
> @@ -959,8 +1091,24 @@ static void kvm_gmem_destroy_inode(struct inode *inode)
>  #endif
>  }
>  
> +static void kvm_gmem_evict_inode(struct inode *inode)
> +{
> +	truncate_inode_pages_final_prepare(inode->i_mapping);
> +
> +	if (kvm_gmem_has_custom_allocator(inode)) {
> +		size_t nr_pages = inode->i_size >> PAGE_SHIFT;
> +
> +		kvm_gmem_truncate_inode_aligned_pages(inode, 0, nr_pages);
> +	} else {
> +		truncate_inode_pages(inode->i_mapping, 0);
> +	}
> +
> +	clear_inode(inode);
> +}
> +
>  static const struct super_operations kvm_gmem_super_operations = {
>  	.statfs		= simple_statfs,
> +	.evict_inode	= kvm_gmem_evict_inode,
>  	.destroy_inode	= kvm_gmem_destroy_inode,
>  	.free_inode	= kvm_gmem_free_inode,
>  };
> @@ -1062,6 +1210,12 @@ static void kvm_gmem_free_folio(struct folio *folio)
>  {
>  	folio_clear_unevictable(folio);
>  
> +	/*
> +	 * No-op for 4K page since the PG_uptodate is cleared as part of
> +	 * freeing, but may be required for other allocators to reset page.
> +	 */
> +	folio_clear_uptodate(folio);
> +
>  	kvm_gmem_invalidate(folio);
>  }
>  
> @@ -1115,6 +1269,25 @@ static struct inode *kvm_gmem_inode_make_secure_inode(const char *name,
>  	if (err)
>  		goto out;
>  
> +#ifdef CONFIG_KVM_GMEM_HUGETLB
> +	if (flags & GUEST_MEMFD_FLAG_HUGETLB) {
> +		void *allocator_priv;
> +		size_t nr_pages;
> +
> +		allocator_priv = guestmem_hugetlb_ops.inode_setup(size, flags);
> +		if (IS_ERR(allocator_priv)) {
> +			err = PTR_ERR(allocator_priv);
> +			goto out;
> +		}
> +
> +		private->allocator_ops = &guestmem_hugetlb_ops;
> +		private->allocator_private = allocator_priv;
> +
> +		nr_pages = guestmem_hugetlb_ops.nr_pages_in_folio(allocator_priv);
> +		inode->i_blkbits = ilog2(nr_pages << PAGE_SHIFT);
> +	}
> +#endif
> +
>  	inode->i_private = (void *)(unsigned long)flags;
>  	inode->i_op = &kvm_gmem_iops;
>  	inode->i_mapping->a_ops = &kvm_gmem_aops;
> @@ -1210,6 +1383,10 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	return err;
>  }
>  
> +/* Mask of bits belonging to allocators and are opaque to guest_memfd. */
> +#define SUPPORTED_CUSTOM_ALLOCATOR_MASK \
> +	(GUESTMEM_HUGETLB_FLAG_MASK << GUESTMEM_HUGETLB_FLAG_SHIFT)
> +
>  int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  {
>  	loff_t size = args->size;
> @@ -1222,6 +1399,12 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  	if (flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED)
>  		valid_flags |= GUEST_MEMFD_FLAG_INIT_PRIVATE;
>  
> +	if (IS_ENABLED(CONFIG_KVM_GMEM_HUGETLB) &&
> +	    flags & GUEST_MEMFD_FLAG_HUGETLB) {
> +		valid_flags |= GUEST_MEMFD_FLAG_HUGETLB |
> +			       SUPPORTED_CUSTOM_ALLOCATOR_MASK;
> +	}
> +
>  	if (flags & ~valid_flags)
>  		return -EINVAL;
>  
> -- 
> 2.49.0.1045.g170613ef41-goog
> 
> 

