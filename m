Return-Path: <kvm+bounces-64129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B4FCC791E4
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 14:05:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 812234EE200
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 13:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7243634250D;
	Fri, 21 Nov 2025 13:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xJQuqDiO"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010059.outbound.protection.outlook.com [52.101.61.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2711E3DCD;
	Fri, 21 Nov 2025 13:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730131; cv=fail; b=IxwXP6uJ5Cfxp5uKuy3qOZmbOK6mJJnYgulGlJ1HntpzHwMkM8AS/gJhsCk+IHj1Z3FQG6KIkP8UdHN6AX7R05pBYm1eKznpDhBQCrzFL2dXrWJAtwrpPVKG2Ll2GzXWNHnc4PzghdlHgojKVNbW0Mj1kDgdJo8haeFr5HzZDWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730131; c=relaxed/simple;
	bh=PkwoDoy8h6vL+yMysDrVKncg3xI2GNYZerhipDR7Wws=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BpGaReJ22I8wJaXmXj8q38Ney3UNcwkT3cI14VRmLAw3ShxoipsOG+7lZVPmXUksnMwjiZQ4QA9jS3982T23VaD82jtQ7aAS0EuqHcJiuZRE4Up5ayQxL4dnI8xyLa5TRgd2J9dPKmzvwmHMSv5rGvwp2OOBJvXb+0DIB7kOkWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xJQuqDiO; arc=fail smtp.client-ip=52.101.61.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CD3rffElwTKxTDrc56RKBK/4MgtW5zMmqfI3igvSVOCR6DLVd63XNSPGrq7FqZf2MzWM3xe4kTFMiFdHTuDjm5c6zHyXt1MR1CvxYvngv0QakjNCjMEUYbzRGJ1+h141tkaxW3275/HI4k7LPN1+yp5BaBPCCw1JcwoVOwDR9j6LubwXXkopY9wtd3zoEks5TaaHLYUmfN3/78o77BGCYwptZuH4D5NxWPhS/8kQuEvj17+b2LKDbN0dXHzCD0ZWlwVzBri1g9AlNVmSG4tFcm8L91dnX5dYM1dATipmhlpppuMf7mURR/4u8qzykKEgX8RVVq1A7GbqOtDZCwL2VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=we2VkBdh5UZarUmXwwIF1Ksq7xaZVW9+cjtUQQE7VXo=;
 b=ys4G5lsvtdaF8LHy2VI3rg5UTnonjMz0iAOE0YhC7VECV++Hhogcw+b1q2aNG4VoZwDa7SoDWet6nMKpT636cTLdFRIaLqlgRvEkVorUVJir1c4dUChXxBHs9bMbIMhwPB9sdLBVGKE1e6qdOlfjx31O8oMvLyJVNEzThjNTi3p08qxv5aMkhCx/IZXopgtXC9tdW412vh2gUwifIZZIgymqqy7fqS5AElf67dtIqZS0oaCxzBZzlKC3Wv/TwlWN9uyA6yK2LKTTPeY7CKGoW3fnDdaSIk6SapY3gZjLme6v0JFlU6x9jPl/ekCgxZ6y15UAwzKThoP8V7x1x0nH5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=we2VkBdh5UZarUmXwwIF1Ksq7xaZVW9+cjtUQQE7VXo=;
 b=xJQuqDiOewq+ki709vhnE30NKFHE5RCWHCqEN1gIamsp9haSAwBlLSFomUHOSwL+Ww8/wMsZslwRNZkv/fao0cM5JkOv2Iv6vpfkAmhhR3u4VlyKQdjnaVdsEvgp9E/K5AXncUIIzbZVbtT7j/wLgh51JeKKF9f7BWZriHfB2b4=
Received: from DM6PR08CA0024.namprd08.prod.outlook.com (2603:10b6:5:80::37) by
 DM4PR12MB6279.namprd12.prod.outlook.com (2603:10b6:8:a3::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.11; Fri, 21 Nov 2025 13:02:04 +0000
Received: from DS3PEPF000099E0.namprd04.prod.outlook.com
 (2603:10b6:5:80:cafe::60) by DM6PR08CA0024.outlook.office365.com
 (2603:10b6:5:80::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.14 via Frontend Transport; Fri,
 21 Nov 2025 13:02:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF000099E0.mail.protection.outlook.com (10.167.17.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 13:02:04 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 21 Nov
 2025 05:02:04 -0800
Date: Fri, 21 Nov 2025 07:01:44 -0600
From: Michael Roth <michael.roth@amd.com>
To: Yan Zhao <yan.y.zhao@intel.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
Message-ID: <20251121130144.u7eeaafonhcqf2bd@amd.com>
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-4-michael.roth@amd.com>
 <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aR7bVKzM7rH/FSVh@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E0:EE_|DM4PR12MB6279:EE_
X-MS-Office365-Filtering-Correlation-Id: d59b55ab-e597-47da-00ce-08de28fe2b33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SzvDLJ2SyY2UhG070VcvTGGQtMXLdK/scKjblfPzxm38vDrctYo7Q6ATGXu3?=
 =?us-ascii?Q?TSlxYo1YYIjmHGvVnHF18p2XwsEpq6FuvdsUm5+vR868BQs/HlGiqdySkAjH?=
 =?us-ascii?Q?kjkexghXjRYIz5NLxSUpvmrHqGSGLaBM5AuAkehC3FkpXM/EM+W8LzKglKFE?=
 =?us-ascii?Q?DCBq5QO9ZCHWu8ZCBJfTeOKUD46WFhd8TmE1ZgecHo9hxUIOLbPevVkNT/RI?=
 =?us-ascii?Q?Q/7cUKp8yCBI11w6ZuvZp/AfHdR7SIpCxsuqLNbTbEOfyyTH6LBQqOVKLW86?=
 =?us-ascii?Q?KFQNW5pv6DOBMAnSaGg2/r7+SBNjctQucaWfYJI/QRYQQSg0SS5GZxXlm0JK?=
 =?us-ascii?Q?dwKH/6FbMDZmDGZ7qjsnSjS8OFS4glQqqx0ge583Mv0WOQu8fKAIovPFnwGz?=
 =?us-ascii?Q?VU7JiKI33mt8TcUmZAFXK/OOIrqd3n8pJHFsnTh9epP6t1MLFkD/N0W45glp?=
 =?us-ascii?Q?1KwBLwRHuB58RND5M6sy59ArsxsO2neWTMCTFJO8vl+lmFBWoTI4PTLWvHW2?=
 =?us-ascii?Q?buDAQJrP/83NRUcday4KPraROzyMxRjpu32c6CgOli1lECFBvG0Vn37fB3wx?=
 =?us-ascii?Q?WaRPO+oLzDmrDI0D6BaVLVa6BGQ5vG758RHtn0ZNSzKSDFkSPDGDRmGAKU5+?=
 =?us-ascii?Q?RhK7XCNtQKAIGT6qe1xv7jbWq6ozdFq1yKiV2SlGwCK64gxl5JuqEyVamOJ5?=
 =?us-ascii?Q?6AKeP9thmgml4CKeLCNRcO7ze8vCzUv1IDt8zbj/b2QcFvfSlPRxNIFBeSAv?=
 =?us-ascii?Q?o8fFfBhG1ug7Vq3HkEMW7x1nNbuViyNhc0BxHT/YKxlBzZ5X17+X4TfGC0Af?=
 =?us-ascii?Q?r2vIHglH5O6YlrJdGBF6P6coNOauwdEoH1gYlfVYmtu2fOxwKNYgFuKRl1+W?=
 =?us-ascii?Q?3noFgckTloep2A/G4HyI76VWMmYj8dn32FOFbROSeCjvmaebHQs8dKulNWTb?=
 =?us-ascii?Q?6KkoPq3KXvveWR/wBqDVq1IJirj0B42PhgSk76Dbh4ImG+1bvSFLqirpkFxj?=
 =?us-ascii?Q?xFRBDLy1M45cDUVZ9eiV/4pEJx72VGmGVPQB7n+xZFKqEv1f6PE4R4xbr03r?=
 =?us-ascii?Q?bDOMRtn3DNTZrpnk0JHGmUKF+Hx4hUeBN063MvTwG5E3qRzPXfn33EKQ+hH0?=
 =?us-ascii?Q?AzBjm9WEdzd1jlkCNoB9TiQJrwuW/Cs/LeHcdb+dACECapfkuKDU2lY5O1SE?=
 =?us-ascii?Q?Sl1STG6KbF2fBgK3wtg/u5hGDNyttyLJb7qtEfbZ5pNnx96Rr9LAnuGsaV92?=
 =?us-ascii?Q?eL3iK9W1YLJdHVh8NSKtd1VvDz8fwJHghu76a7nd7JF8YEYQQCxKkD1BJl+7?=
 =?us-ascii?Q?Bpc/RYP6u3DG82ApaXlLTw1BgPRDp7FKAZktag+yEH+jJ92Yi1rKAHNqv2cY?=
 =?us-ascii?Q?0uyJyiu2aTz3YUXURcfiHvp8bz8Yz41/Z6kZ7CPeB6NKNaJT1aovM7aiRzqB?=
 =?us-ascii?Q?57jBs3XNbwDeBxoAetvzHZbRZOwoWWlm2kz4wjAB8x8rPBzNB5I2kzVgDEuW?=
 =?us-ascii?Q?n2PoVANhrefNWvjuxqSm4vQOR4kAwMlfFdT6IB5ScZrq74fEJdJko6W5hNZ0?=
 =?us-ascii?Q?sopIJJ+RrxTS+8r6UQE=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 13:02:04.3955
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d59b55ab-e597-47da-00ce-08de28fe2b33
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6279

On Thu, Nov 20, 2025 at 05:11:48PM +0800, Yan Zhao wrote:
> On Thu, Nov 13, 2025 at 05:07:59PM -0600, Michael Roth wrote:
> > Currently the post-populate callbacks handle copying source pages into
> > private GPA ranges backed by guest_memfd, where kvm_gmem_populate()
> > acquires the filemap invalidate lock, then calls a post-populate
> > callback which may issue a get_user_pages() on the source pages prior to
> > copying them into the private GPA (e.g. TDX).
> > 
> > This will not be compatible with in-place conversion, where the
> > userspace page fault path will attempt to acquire filemap invalidate
> > lock while holding the mm->mmap_lock, leading to a potential ABBA
> > deadlock[1].
> > 
> > Address this by hoisting the GUP above the filemap invalidate lock so
> > that these page faults path can be taken early, prior to acquiring the
> > filemap invalidate lock.
> > 
> > It's not currently clear whether this issue is reachable with the
> > current implementation of guest_memfd, which doesn't support in-place
> > conversion, however it does provide a consistent mechanism to provide
> > stable source/target PFNs to callbacks rather than punting to
> > vendor-specific code, which allows for more commonality across
> > architectures, which may be worthwhile even without in-place conversion.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  arch/x86/kvm/svm/sev.c   | 40 ++++++++++++++++++++++++++------------
> >  arch/x86/kvm/vmx/tdx.c   | 21 +++++---------------
> >  include/linux/kvm_host.h |  3 ++-
> >  virt/kvm/guest_memfd.c   | 42 ++++++++++++++++++++++++++++++++++------
> >  4 files changed, 71 insertions(+), 35 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 0835c664fbfd..d0ac710697a2 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2260,7 +2260,8 @@ struct sev_gmem_populate_args {
> >  };
> >  
> >  static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
> > -				  void __user *src, int order, void *opaque)
> > +				  struct page **src_pages, loff_t src_offset,
> > +				  int order, void *opaque)
> >  {
> >  	struct sev_gmem_populate_args *sev_populate_args = opaque;
> >  	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> > @@ -2268,7 +2269,7 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> >  	int npages = (1 << order);
> >  	gfn_t gfn;
> >  
> > -	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
> > +	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src_pages))
> >  		return -EINVAL;
> >  
> >  	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
> > @@ -2284,14 +2285,21 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> >  			goto err;
> >  		}
> >  
> > -		if (src) {
> > -			void *vaddr = kmap_local_pfn(pfn + i);
> > +		if (src_pages) {
> > +			void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> > +			void *dst_vaddr = kmap_local_pfn(pfn + i);
> >  
> > -			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
> > -				ret = -EFAULT;
> > -				goto err;
> > +			memcpy(dst_vaddr, src_vaddr + src_offset, PAGE_SIZE - src_offset);
> > +			kunmap_local(src_vaddr);
> > +
> > +			if (src_offset) {
> > +				src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> > +
> > +				memcpy(dst_vaddr + PAGE_SIZE - src_offset, src_vaddr, src_offset);
> > +				kunmap_local(src_vaddr);
> IIUC, src_offset is the src's offset from the first page. e.g.,
> src could be 0x7fea82684100, with src_offset=0x100, while npages could be 512.
> 
> Then it looks like the two memcpy() calls here only work when npages == 1 ?

src_offset ends up being the offset into the pair of src pages that we
are using to fully populate a single dest page with each iteration. So
if we start at src_offset, read a page worth of data, then we are now at
src_offset in the next src page and the loop continues that way even if
npages > 1.

If src_offset is 0 we never have to bother with straddling 2 src pages so
the 2nd memcpy is skipped on every iteration.

That's the intent at least. Is there a flaw in the code/reasoning that I
missed?

> 
> >  			}
> > -			kunmap_local(vaddr);
> > +
> > +			kunmap_local(dst_vaddr);
> >  		}
> >  
> >  		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
> > @@ -2331,12 +2339,20 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
> >  	if (!snp_page_reclaim(kvm, pfn + i) &&
> >  	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
> >  	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
> > -		void *vaddr = kmap_local_pfn(pfn + i);
> > +		void *src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i]));
> > +		void *dst_vaddr = kmap_local_pfn(pfn + i);
> >  
> > -		if (copy_to_user(src + i * PAGE_SIZE, vaddr, PAGE_SIZE))
> > -			pr_debug("Failed to write CPUID page back to userspace\n");
> > +		memcpy(src_vaddr + src_offset, dst_vaddr, PAGE_SIZE - src_offset);
> > +		kunmap_local(src_vaddr);
> > +
> > +		if (src_offset) {
> > +			src_vaddr = kmap_local_pfn(page_to_pfn(src_pages[i + 1]));
> > +
> > +			memcpy(src_vaddr, dst_vaddr + PAGE_SIZE - src_offset, src_offset);
> > +			kunmap_local(src_vaddr);
> > +		}
> >  
> > -		kunmap_local(vaddr);
> > +		kunmap_local(dst_vaddr);
> >  	}
> >  
> >  	/* pfn + i is hypervisor-owned now, so skip below cleanup for it. */
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 57ed101a1181..dd5439ec1473 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -3115,37 +3115,26 @@ struct tdx_gmem_post_populate_arg {
> >  };
> >  
> >  static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > -				  void __user *src, int order, void *_arg)
> > +				  struct page **src_pages, loff_t src_offset,
> > +				  int order, void *_arg)
> >  {
> >  	struct tdx_gmem_post_populate_arg *arg = _arg;
> >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> >  	u64 err, entry, level_state;
> >  	gpa_t gpa = gfn_to_gpa(gfn);
> > -	struct page *src_page;
> >  	int ret, i;
> >  
> >  	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
> >  		return -EIO;
> >  
> > -	if (KVM_BUG_ON(!PAGE_ALIGNED(src), kvm))
> > +	/* Source should be page-aligned, in which case src_offset will be 0. */
> > +	if (KVM_BUG_ON(src_offset))
> 	if (KVM_BUG_ON(src_offset, kvm))
> 
> >  		return -EINVAL;
> >  
> > -	/*
> > -	 * Get the source page if it has been faulted in. Return failure if the
> > -	 * source page has been swapped out or unmapped in primary memory.
> > -	 */
> > -	ret = get_user_pages_fast((unsigned long)src, 1, 0, &src_page);
> > -	if (ret < 0)
> > -		return ret;
> > -	if (ret != 1)
> > -		return -ENOMEM;
> > -
> > -	kvm_tdx->page_add_src = src_page;
> > +	kvm_tdx->page_add_src = src_pages[i];
> src_pages[0] ? i is not initialized. 

Sorry, I switched on TDX options for compile testing but I must have done a
sloppy job confirming it actually built. I'll re-test push these and squash
in the fixes in the github tree.

> 
> Should there also be a KVM_BUG_ON(order > 0, kvm) ?

Seems reasonable, but I'm not sure this is the right patch. Maybe I
could squash it into the preceeding documentation patch so as to not
give the impression this patch changes those expectations in any way.

> 
> >  	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
> >  	kvm_tdx->page_add_src = NULL;
> >  
> > -	put_page(src_page);
> > -
> >  	if (ret || !(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
> >  		return ret;
> >  
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index d93f75b05ae2..7e9d2403c61f 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2581,7 +2581,8 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
> >   * Returns the number of pages that were populated.
> >   */
> >  typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> > -				    void __user *src, int order, void *opaque);
> > +				    struct page **src_pages, loff_t src_offset,
> > +				    int order, void *opaque);
> >  
> >  long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
> >  		       kvm_gmem_populate_cb post_populate, void *opaque);
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 9160379df378..e9ac3fd4fd8f 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -814,14 +814,17 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
> >  
> >  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
> > +
> > +#define GMEM_GUP_NPAGES (1UL << PMD_ORDER)
> Limiting GMEM_GUP_NPAGES to PMD_ORDER may only work when the max_order of a huge
> folio is 2MB. What if the max_order returned from  __kvm_gmem_get_pfn() is 1GB
> when src_pages[] can only hold up to 512 pages?

This was necessarily chosen in prep for hugepages, but more about my
unease at letting userspace GUP arbitrarilly large ranges. PMD_ORDER
happens to align with 2MB hugepages while seeming like a reasonable
batching value so that's why I chose it.

Even with 1GB support, I wasn't really planning to increase it. SNP
doesn't really make use of RMP sizes >2MB, and it sounds like TDX
handles promotion in a completely different path. So atm I'm leaning
toward just letting GMEM_GUP_NPAGES be the cap for the max page size we
support for kvm_gmem_populate() path and not bothering to change it
until a solid use-case arises.

> 
> Increasing GMEM_GUP_NPAGES to (1UL << PUD_ORDER) is probabaly not a good idea.
> 
> Given both TDX/SNP map at 4KB granularity, why not just invoke post_populate()
> per 4KB while removing the max_order from post_populate() parameters, as done
> in Sean's sketch patch [1]?

That's an option too, but SNP can make use of 2MB pages in the
post-populate callback so I don't want to shut the door on that option
just yet if it's not too much of a pain to work in. Given the guest BIOS
lives primarily in 1 or 2 of these 2MB regions the benefits might be
worthwhile, and SNP doesn't have a post-post-populate promotion path
like TDX (at least, not one that would help much for guest boot times)

Thanks,

Mike

> 
> Then the WARN_ON() in kvm_gmem_populate() can be removed, which would be easily
> triggered by TDX when max_order > 0 && npages == 1:
> 
>       WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
>               (npages - i) < (1 << max_order));
> 
> 
> [1] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/
> 
> >  long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
> >  		       kvm_gmem_populate_cb post_populate, void *opaque)
> >  {
> >  	struct kvm_memory_slot *slot;
> > -	void __user *p;
> > -
> > +	struct page **src_pages;
> >  	int ret = 0, max_order;
> > -	long i;
> > +	loff_t src_offset = 0;
> > +	long i, src_npages;
> >  
> >  	lockdep_assert_held(&kvm->slots_lock);
> >  
> > @@ -836,9 +839,28 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >  	if (!file)
> >  		return -EFAULT;
> >  
> > +	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> > +	npages = min_t(ulong, npages, GMEM_GUP_NPAGES);
> > +
> > +	if (src) {
> > +		src_npages = IS_ALIGNED((unsigned long)src, PAGE_SIZE) ? npages : npages + 1;
> > +
> > +		src_pages = kmalloc_array(src_npages, sizeof(struct page *), GFP_KERNEL);
> > +		if (!src_pages)
> > +			return -ENOMEM;
> > +
> > +		ret = get_user_pages_fast((unsigned long)src, src_npages, 0, src_pages);
> > +		if (ret < 0)
> > +			return ret;
> > +
> > +		if (ret != src_npages)
> > +			return -ENOMEM;
> > +
> > +		src_offset = (loff_t)(src - PTR_ALIGN_DOWN(src, PAGE_SIZE));
> > +	}
> > +
> >  	filemap_invalidate_lock(file->f_mapping);
> >  
> > -	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> >  	for (i = 0; i < npages; i += (1 << max_order)) {
> >  		struct folio *folio;
> >  		gfn_t gfn = start_gfn + i;
> > @@ -869,8 +891,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >  			max_order--;
> >  		}
> >  
> > -		p = src ? src + i * PAGE_SIZE : NULL;
> > -		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> > +		ret = post_populate(kvm, gfn, pfn, src ? &src_pages[i] : NULL,
> > +				    src_offset, max_order, opaque);
> Why src_offset is not 0 starting from the 2nd page?
> 
> >  		if (!ret)
> >  			folio_mark_uptodate(folio);
> >  
> > @@ -882,6 +904,14 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> >  
> >  	filemap_invalidate_unlock(file->f_mapping);
> >  
> > +	if (src) {
> > +		long j;
> > +
> > +		for (j = 0; j < src_npages; j++)
> > +			put_page(src_pages[j]);
> > +		kfree(src_pages);
> > +	}
> > +
> >  	return ret && !i ? ret : i;
> >  }
> >  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_populate);
> > -- 
> > 2.25.1
> > 

