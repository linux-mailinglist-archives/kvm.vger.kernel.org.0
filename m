Return-Path: <kvm+bounces-42957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E585A813D6
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 19:40:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9392189B39C
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 17:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C464723C8C8;
	Tue,  8 Apr 2025 17:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DvaE8+zZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3791622DFA4
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 17:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744134000; cv=fail; b=oLh3c7ClAD1mgalLPCa/2hmwj4ohuTbjAzUSMsJiGqR7l26R7dSZgHt10rGUjHnRxndhquVaPPcz/gS3JwuCY36jGbeP603LR3ZA+zxhf7WuQuXaL00+zzlwXhqlF3RiYriYPa+/aSisIYP4UrnGO6eUNZ3cDTGtmxgfeD+rQJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744134000; c=relaxed/simple;
	bh=c7FBrr6tRJPjEgmNrRlM+GelfsvTx3ddvWWt4c826Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=dsLJGpohEhHvXtSgHL/+qdWdWk8f9Lp1ipnm7zC23DDEgNZtLAWWZznNVxChiqql9TkBAKTYoXMCFT9ez2vAZ3dtFNLRmSdd3hAPGPqafWqFtuJGCilH1evacnoVXVTPsMmfD5q/SYGy/QOmEb8AQbfnUOT9NzZjurzEPhtgtzY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DvaE8+zZ; arc=fail smtp.client-ip=40.107.93.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gFJ2/9eu3iOTTjJGS06kTxYz20n7yedoJbvEqfNQNmWS95al/kpLGCQAtC3E1vr2puzy/2Xt+t39Bp61+5TIwkpVe8uPdZjLV8MquQ3uMJD4U9t51JYbp+D1uBTuIJDAd7XsLBuyQYj799rFVom4AQY8G4HiUSN72lvdRXmCgVeYBH5qynJJC5l4Vm8325ZXu5n7Hm3E8GKFUId2nlEiGddItw7bDSYHkUwMGVMSP67TqAXQZJp5PCqGPmmLooJur3Nl7e7DGwMyJrlxVK/L9i4WYnDFuwAW5VSZMPfsgXKGxCWDljgkR6S4P6KqIDX3wqgWdYBdoZbV6THlXJ1BUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qeto7JpwEfgNdhwIGSEFwtOCpY34nqf9PbPp49AWhXc=;
 b=CJLaDb+saYhSetGghdp8Sy41r7wuyXCB+IipEaKD4vyVIfpgm0JNswIY7YIoOQIZpS236vMO4hXWlzBf5JdoGXKe+aKcJppxFmsEi8e23r8qoH47rzbcjcGWgLVlZGRoNp+piZ9q0eL2tiqZMHgm+UMod1J399uQeQ7vNfbNcdFo/s2B7N6WDqPQtyxlXLGy8SF44cmaH+wqS1QINi7JexKSPrXkn17B06tPne9JSFXVWMqxzydRG6qp4vKG1cBy0JHFjFl30rVGQlSSDrf4C5Z5VA3bLoSthMRnwdo9mtMuX+cq/NhDowmX5MsFZ+lXovzA00maceNgvru9KSN36Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qeto7JpwEfgNdhwIGSEFwtOCpY34nqf9PbPp49AWhXc=;
 b=DvaE8+zZ9IauA+Thv8C9O50t3h9AXajwMEvRTC/gCYQmRQvMkbuE/R6S2Fk610ksIFqNy0h2FFrylm2ZVrsapCmz1ho1oYMfx7PNy9weNFNeQyH11WeT7biHxPqARiCYYWdXWFeNqSUrurKBq8K8ntVf09nMBA+OFhBFLd3hQ9a3OUWYc5DCMznfpnc6P/wdk8zcDQ4SSME30ILc21nauJr0mUxMNLzYSKAqr/XO0IrP8VPWFL8HPXqWwGRwLIWoc+5s1aJT8zhGCY8ttvbSKHari5M3GVH3hRosZ4JIy7WxcVy5oOCAV9KZcWcU9V5uEPtamkVThuVTXAjGjgx7mw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB6803.namprd12.prod.outlook.com (2603:10b6:303:20e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.31; Tue, 8 Apr
 2025 17:39:53 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 17:39:53 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org
Cc: patches@lists.linux.dev
Subject: [PATCH] vfio/type1: Remove Fine Grained Superpages detection
Date: Tue,  8 Apr 2025 14:39:52 -0300
Message-ID: <0-v1-0eed68063e59+93d-vfio_fgsp_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:208:36e::13) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB6803:EE_
X-MS-Office365-Filtering-Correlation-Id: f04b4605-487b-4fa3-012a-08dd76c45ee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zT2TyPiMtUSlM3Tzvwj096hIVXOuKUKsxP78HAzvfI0ubhr0ni5Mn2JXNGI3?=
 =?us-ascii?Q?2qcsE7dePAHxrmR17RhEpnyNTtVhcMRs04KkIpv3iowed8P7ghC6wO25mnXN?=
 =?us-ascii?Q?a0tVM+bmassA6Yv52kBNEqwSoHQXntKp4fnP9vRjsNVm4Rs0Qiu2Go80fvlF?=
 =?us-ascii?Q?DLeEpAyiNTYWJCvQ65w1jGcigwkg+WoeWAZSLBqgcMn4L88r4ohx50T5+CVS?=
 =?us-ascii?Q?Q4I5YCUanvjGa77HZgWp2tbtlhkz2wuLVYmQUqd55tt23p+LTBAydfYBPpK9?=
 =?us-ascii?Q?s2DBXAziGejvAjiDU5+eqQGx60RZC6flW1Ya1anJgS+XhRTqS5Pp2AmiUBpc?=
 =?us-ascii?Q?UGFXW4zK4Cb1jstwlsb+e4kPhPyts6+v8jY2WZcWdZ1xYsQv481cZjL04/Zi?=
 =?us-ascii?Q?XWoVsAy6AmjOlZwh9HwgurnZpm2mkjKPeHaLQdkiIlZLCwCKm8wk7pCCRBSV?=
 =?us-ascii?Q?JiRLyXlYLQygIge9ifyvoFTIuA5bHKY0UVkM96RRIjF+xIjCEhQhV9c3q9zc?=
 =?us-ascii?Q?fJcxZ5uMsIN1HgN2A1RbnvS2j3PtSBI8K+gJhgOH7encwgC0dRWjF98dglk7?=
 =?us-ascii?Q?sjVrIWB53kr2C9eGKlQTgOwQL+AkfasjEGcRA7z1Wpyr4IGZJ4uPKrqnmshC?=
 =?us-ascii?Q?AnUbmDg70bX6n50bYnLiaTlQrPqm2edsEN+ydzUQqQOq7QXS7axa9OTdbw0m?=
 =?us-ascii?Q?hmYXpMmuI66+6hsplEA22qSFouisGoiUzAH1xCxJw1riby/nZkjYx1qjOzvf?=
 =?us-ascii?Q?ss/or7UlAtKzPkJi2zA6ftwwmf3T5jQWK+wi22B+wUlXB+ezQMY8jQisIIR7?=
 =?us-ascii?Q?kIJBFVzPgE6R/fRiNYkTgd/rCFFwVdN7b/bdyErzwppWkFmeMnOG9FrfxOUi?=
 =?us-ascii?Q?ZCgURKEJ23sbdZe9WoyQNyPq8Vtjvi5VIRDwq6nrGSfDINvSQwQIWnxHw8AT?=
 =?us-ascii?Q?I1nLoK+6/Fz7lUhVsoVmwYvv0yQAcaAppv5rTL6hxcWCeQhdnv4YorSFKaNM?=
 =?us-ascii?Q?p0QAAMbDus8OYNcqUV1RCjeD7HRu6PQIqE0qgPqgylg8CHV4rbgz1eoFrcSW?=
 =?us-ascii?Q?eTTrkdDxC1UVs7XzeYskU56WJSIaw1ATSYoo1RH74td9h4OFmf6akh2A8N8t?=
 =?us-ascii?Q?fmv33TYkZKzFyCqUeLn/r6x2NC941JPqysHuiaI7W4XTyrRtYyIOsrp43+9L?=
 =?us-ascii?Q?l5xMmwcocMt/ZQGGgO6K5BJgG0Z3SIpVkmp6mIpCEOnF0ORth+09r00r36My?=
 =?us-ascii?Q?M7hmu3tgYjT+B3ClOAv6ipe8AnV5qkUKhG5IUvLPYQy+h1d3dHThVwUbYQ9G?=
 =?us-ascii?Q?JEp6/mZqMNgESPHJcEk4q07nO7wUT/mXQC3yWQQav6iANqDwnG5tFjXp8ato?=
 =?us-ascii?Q?YwUv9/++PBzLWW/CRPwlA1nht0CS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mSYkisQxZ9i/L5K1cdk3xPS8XjQEvvh2pdNluyjJAyHBBJM6qadlEgZlWPob?=
 =?us-ascii?Q?Zhs92U1w3XB5/jB78iI8JEeU+laoGyxkTexE4P5ivB2Ft4QMPec8I59EAyVe?=
 =?us-ascii?Q?ZI9KEYgWelw2BMA/oLCnoLY8abkgxb666i5XMHBP0XTe+VB/nI8sN7tlwes6?=
 =?us-ascii?Q?mTSZvQkOvg7i2s0nwjKXchjUQA/jzutyWdbtUWNx1ffLVMWzd7VCM5gvKsyQ?=
 =?us-ascii?Q?frFIZmPRVDYGlZm2FHEu6+28yhA6FjRpCWx+14U+CaZFPhtzDDmLxueflU84?=
 =?us-ascii?Q?q8XQf8x5zHY+bV0cAAjnA8jHttwunpzf5WsYCVmTDcXFE3jsrEWsmLbLevW4?=
 =?us-ascii?Q?6GCbUBuP5wi2Jw+HVlHDwNRKHnI8GzeSPhJ3MiEtDPJ/Jj+bqinBUUHNJ3cH?=
 =?us-ascii?Q?C6d/+tIitsAHCmLham57rl1vnsxFhZEVs8utNjX3c7A2OMLVD32xBzWP62nl?=
 =?us-ascii?Q?kIhBwLdtI6u7LQW8dbXbYnq1lMf3oZqwTq+DiKbvXtRi9IJgVWMi25Wzxi7w?=
 =?us-ascii?Q?Y5SKTf70tLvnmXbhfbb98PYaL+nbYNK6Ved9QUXEjI/PU+hQljlj2Ul+0dzp?=
 =?us-ascii?Q?6HwQKcsgFwUR5yq46+5cdE8e9gqklF8Cw2mKEqKt0sngD3Huqnu0A2v1uh7Q?=
 =?us-ascii?Q?ei1hJ42Yz0Hxdoq/om/jyGjYVbI6nIMzvd2FgiWcI/8GZsnI1R4XltyM6ibi?=
 =?us-ascii?Q?pOVF9/BM7mAFmMtSsU2Q/ZeyIGiXgsF5Zs6dBSuEJ5pjqWBrV7ryxyQM4k4L?=
 =?us-ascii?Q?mRTnHs8WUdwsONZS8pkOr9SMfsDAa4pUuVGX4msqNsezLdgywdOHqY5IK82c?=
 =?us-ascii?Q?54EiAvCYZfFfdKDSlUOmy7ogZQ7skHHIQhdZlUvfRD3ZP8TKPrDbwmBy5MNE?=
 =?us-ascii?Q?z/MjBpuTw9KpeB5vSs6TaTIFKjUQw6onUwHJ4SNJTkeeARB2USC4EH8lE6yk?=
 =?us-ascii?Q?GGZAWi3bCLrQboLd8JycJAmfeUgLppLsnka46zKd9cc5pEvOKZwIvZhsP0dR?=
 =?us-ascii?Q?wCmigqL+5uNHt0E8aVmBBiZPtTPrmuL7BHEiW+KmojYGkNVGGYD+Fc/aNxs+?=
 =?us-ascii?Q?qtj7eba51IsFBANL0PilMGrrb8toP+O2IJawvLuyVSj7w1owkdlttO7l0TUJ?=
 =?us-ascii?Q?ezD0hrKPxZSPCJB3GtS/RmR07cTFJ7T9rRyLcVX8B+8x7OqItRtaADIuazPj?=
 =?us-ascii?Q?u4MHreFY8cHoEDNvFu+OUFJaUHyNzJbXwNnMYuQLrYa85nxlaLsOQGgpY31B?=
 =?us-ascii?Q?IqjgkILxMdZPoN15RJH3nRKVGPnSXCByLrVuR3yQ6i9D43KG/FiOwvqPo/wS?=
 =?us-ascii?Q?qlROQZ2ubOt47XVhQ/XYzG/4u3lpe0yy+UItoayG4ugIc8topObruzfSm6qJ?=
 =?us-ascii?Q?6EuFd7Cczm8lvSeUVs6XaD+F+rPtHh8rXbyaMRPhgDbk5QczO30CPxojhHqO?=
 =?us-ascii?Q?F6LMMNx+HhqxxoclwQ5BYPYQM4iIZGZvNTk98bqAj4Ggi5imA19u2er1c/xv?=
 =?us-ascii?Q?n5fIN6xmSgRsPtCQa0h17uIjU9fuKi+VPWm+9Edg+kD4Lr1LuV8KSC8aykb7?=
 =?us-ascii?Q?o72JQ8p0odCqmdR6Pg1LXPiHzw675/QjCS5pDrkW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f04b4605-487b-4fa3-012a-08dd76c45ee9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 17:39:53.6390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: neNXmNWzxcUTEQE9CqjPRem08PpzLPf+zASuArKBdKZf2nDEpVM3KwIHAKq0AsOS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6803

VFIO is looking to enable an optimization where it can rely on the
unmap operation not splitting and returning the size of a larger IOPTE.

However since commits:
  d50651636fb ("iommu/io-pgtable-arm-v7s: Remove split on unmap behavior")
  33729a5fc0ca ("iommu/io-pgtable-arm: Remove split on unmap behavior")

There are no iommu drivers that do split on unmap anymore. Instead all
iommu drivers are expected to unmap the whole contiguous page and return
its size.

Thus, there is no purpose in vfio_test_domain_fgsp() as it is only
checking if the iommu supports 2*PAGE_SIZE as a contiguous page or not.

Currently only AMD v1 supports such a page size so all this logic only
activates on AMD v1.

Remove vfio_test_domain_fgsp() and just rely on a direct 2*PAGE_SIZE check
instead so there is no behavior change.

Maybe it should always activate the iommu_iova_to_phys(), it shouldn't
have a performance downside since split is gone.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 71 +++++++++------------------------
 1 file changed, 19 insertions(+), 52 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0ac56072af9f23..529561bbbef98a 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -80,7 +80,6 @@ struct vfio_domain {
 	struct iommu_domain	*domain;
 	struct list_head	next;
 	struct list_head	group_list;
-	bool			fgsp : 1;	/* Fine-grained super pages */
 	bool			enforce_cache_coherency : 1;
 };
 
@@ -1056,6 +1055,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	LIST_HEAD(unmapped_region_list);
 	struct iommu_iotlb_gather iotlb_gather;
 	int unmapped_region_cnt = 0;
+	bool scan_for_contig;
 	long unlocked = 0;
 
 	if (!dma->size)
@@ -1079,9 +1079,15 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		cond_resched();
 	}
 
+	/*
+	 * For historical reasons this has only triggered on AMDv1 page tables,
+	 * though these days it should work everywhere.
+	 */
+	scan_for_contig = !(domain->domain->pgsize_bitmap & (2 * PAGE_SIZE));
 	iommu_iotlb_gather_init(&iotlb_gather);
 	while (iova < end) {
-		size_t unmapped, len;
+		size_t len = PAGE_SIZE;
+		size_t unmapped;
 		phys_addr_t phys, next;
 
 		phys = iommu_iova_to_phys(domain->domain, iova);
@@ -1094,12 +1100,18 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 		 * To optimize for fewer iommu_unmap() calls, each of which
 		 * may require hardware cache flushing, try to find the
 		 * largest contiguous physical memory chunk to unmap.
+		 *
+		 * If the iova is part of a contiguous page > PAGE_SIZE then
+		 * unmap will unmap the whole contiguous page and return its
+		 * size.
 		 */
-		for (len = PAGE_SIZE;
-		     !domain->fgsp && iova + len < end; len += PAGE_SIZE) {
-			next = iommu_iova_to_phys(domain->domain, iova + len);
-			if (next != phys + len)
-				break;
+		if (scan_for_contig) {
+			for (; iova + len < end; len += PAGE_SIZE) {
+				next = iommu_iova_to_phys(domain->domain,
+							  iova + len);
+				if (next != phys + len)
+					break;
+			}
 		}
 
 		/*
@@ -1833,49 +1845,6 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 	return ret;
 }
 
-/*
- * We change our unmap behavior slightly depending on whether the IOMMU
- * supports fine-grained superpages.  IOMMUs like AMD-Vi will use a superpage
- * for practically any contiguous power-of-two mapping we give it.  This means
- * we don't need to look for contiguous chunks ourselves to make unmapping
- * more efficient.  On IOMMUs with coarse-grained super pages, like Intel VT-d
- * with discrete 2M/1G/512G/1T superpages, identifying contiguous chunks
- * significantly boosts non-hugetlbfs mappings and doesn't seem to hurt when
- * hugetlbfs is in use.
- */
-static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *regions)
-{
-	int ret, order = get_order(PAGE_SIZE * 2);
-	struct vfio_iova *region;
-	struct page *pages;
-	dma_addr_t start;
-
-	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
-	if (!pages)
-		return;
-
-	list_for_each_entry(region, regions, list) {
-		start = ALIGN(region->start, PAGE_SIZE * 2);
-		if (start >= region->end || (region->end - start < PAGE_SIZE * 2))
-			continue;
-
-		ret = iommu_map(domain->domain, start, page_to_phys(pages), PAGE_SIZE * 2,
-				IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE,
-				GFP_KERNEL_ACCOUNT);
-		if (!ret) {
-			size_t unmapped = iommu_unmap(domain->domain, start, PAGE_SIZE);
-
-			if (unmapped == PAGE_SIZE)
-				iommu_unmap(domain->domain, start + PAGE_SIZE, PAGE_SIZE);
-			else
-				domain->fgsp = true;
-		}
-		break;
-	}
-
-	__free_pages(pages, order);
-}
-
 static struct vfio_iommu_group *find_iommu_group(struct vfio_domain *domain,
 						 struct iommu_group *iommu_group)
 {
@@ -2314,8 +2283,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		}
 	}
 
-	vfio_test_domain_fgsp(domain, &iova_copy);
-
 	/* replay mappings on new domains */
 	ret = vfio_iommu_replay(iommu, domain);
 	if (ret)

base-commit: 5a7ff05a5717e2ac4f4f83bcdd9033f246e9946b
-- 
2.43.0


