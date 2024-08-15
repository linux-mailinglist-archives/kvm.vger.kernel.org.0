Return-Path: <kvm+bounces-24283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 318379536C2
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:13:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 800D5B23E3A
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6211B3F1F;
	Thu, 15 Aug 2024 15:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y64niQxM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6069B1B1429
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734714; cv=fail; b=kpTipy9IJSy1VQ5VshTiw+2h3iwFiimD7wTeC3rrArAhIdFPgKAF0YPBX9WADF0qBFLRgB/vV4JC4GOneerkWb+/Wd7Q4/pd4AKmv73tDNftfYqeOwmBUJS5Pe8EdAshrsrJdG2Y74g0wn0o8o7V1fg5isU9ME1fbzY2KjuJ/AI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734714; c=relaxed/simple;
	bh=QdY8jnCU2kLVqGAgphb+9eEnoFMrqbDklhmnbIr5Pf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ValUkifFvXszMppHFdyPR2d3EqLWKXQV16B0qGjSfQVbTAeVaWOUmPGDTB/+fTelHdx+BZC/go5cPYropGre/0jRXpemX8oB4iXnjT2go6TF30QR+8vCeKSSxIiXJyZkAxZEgyOZSpVhE5A/97up9qqwgtrgJETTHJ3BkYlO13M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y64niQxM; arc=fail smtp.client-ip=40.107.92.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z4okiP7z7MNHngJMrLL9eR1dFvLtJC20q1onPL7SNUTmRCKK5ppWqBnb70Brrjdr+U24NCSYLM09+8rKI/6kJz8xeJ3wScGIvc9E8W7w7dubU1ayp44/uZ+Wz6J5AcXVS/WTSxd2erR6ZvElnL1369Y7HY5aejTUSO93IAuV/DH3PwShhJ4KkyEahsl+kIPRNC4rkfHYguYuEhta9ckVsG46Vwg7kfV46xVj/kdCzjIxENqsNrpgD9vCz94ggvjGFRDVTwzbGZHhnsvc+89/55XG5f8ncQUufpHrhHvk05l0+dwlqvZiyBbqd1EBRWitD05LLnWLSGpgZHcpiqGy7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dc6OFVd1fJllHqtUdTj1JI7YguQmswQxuE+3IZV/Ec=;
 b=Aho6P2s4CMzQP/XXrzlYJbBkFqBUvc86UiU8lgzDE5E1gBiiauJccgWr5NWm3RACmD952omHKizfqmuA6nC+jG7+/ExHa9IjsIqLYj5Wh/9K2oPAPaTT37fPspMHQsbh20RJ9VXS3yOJRuWuuvUd9lkBRObumiIlXaVjBQif3JUutMA03Xy4yMWnrIEWz65rLDUKV4sPrSKQsfm4oVOpTGiruqG9VXpwIimwZwSQe/gi2xfpJkCcygoXe9bkKh+fjO5VlrjsuaHL/lG6qqq827SlU+25TyW2s8f/rn7/0h6Fxk6GtoBYWbCD07EthSaDbcJToL+N1Unzh+vEGaPO1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/dc6OFVd1fJllHqtUdTj1JI7YguQmswQxuE+3IZV/Ec=;
 b=Y64niQxM2AMmQYAd73O5Ilgs0OOAM+D5Bl4DWHbwxVWyMXj06LHgbZTfBOdiehQzYHFGqf26K+B5cgrvTDJibvpAFFj6T/YectITKc5giYcLUkZ85A2/HedSeXGtDhJWrNhQU0yrKfAq1OLW+q3J8OrOg2B+7OmgQnqsXugMSGOVvxEZMvjGcWEMgTmv7ATKiBScqO7uDHWJ6kGRBrAtpG3Xut1rFd1S9k7BZnBZ7g0iFB0SbzgeJ8pyTw6mgns3/fy1fPLfZlbIKogR7qRKv84+7GD4PCFYn/vET2tdFk9ZD/MBGELSmDgBXmp+nCB8T0Ho47zqWjbT8V33gT3Gdg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB8146.namprd12.prod.outlook.com (2603:10b6:806:323::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Thu, 15 Aug
 2024 15:11:43 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 15:11:43 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To:
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	iommu@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Tina Zhang <tina.zhang@intel.com>
Subject: [PATCH 06/16] iommupt: Add map_pages op
Date: Thu, 15 Aug 2024 12:11:22 -0300
Message-ID: <6-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF0001641B.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:10) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: 42c00cdc-9801-4e5c-aed7-08dcbd3c8e74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xWmIRYpPWlXtM1obgfF04hhP7fttpYJJis5uswm5fGeFg/8eykNhEdtCEdTW?=
 =?us-ascii?Q?Ej8NMPvVOE5mWz+L8lDjQIOISa/yjyWymUE6tN3Doe64oAXr/hQDyTUHQMsE?=
 =?us-ascii?Q?CtOxD1QIF7Gi1tVcQN0xr1DjIieUZdV3mMbXoCkwGl9pto1jSKxStjqGd1y3?=
 =?us-ascii?Q?IMdu1m/iX2OHLRQsXRDv7E3ulL8bf7zNIplnruc2U78zH23wCYdEGErtsRI/?=
 =?us-ascii?Q?P63srFDPEEBZs4roXjNUwalbJWWfNxg22a/XStrlLMIM2crdpeSXvTIGS70K?=
 =?us-ascii?Q?bAgW0DaR5ATK//OTug+NFHGbwIHy7Q+TRhrrSh5n3j/4bR2lJaycRwMXFz+J?=
 =?us-ascii?Q?YY7zNutZuA4psb0j4nQL3xqnvddbL2PJVGG1m9rHITB3FgbK4D5Zll0WFt40?=
 =?us-ascii?Q?3TsvSzdB49NgzqCxohigRtXlv0GUdbAdkOUboAcq9Cr+23+qgfr6OCTPpMEk?=
 =?us-ascii?Q?SKLgXE7KA98ewls5pdqdBooKGsupZOk2nIraQgX61byOCm/17grsehIo617k?=
 =?us-ascii?Q?tLBGvWWkOUVKbtrfy37uw+/uIEDVspcix6eE/Tpbu+S5kNibNBQFmDoju4U9?=
 =?us-ascii?Q?3dYjjODvxW4io3SPpuLlmerUSGvWcKUAMWhW3kLM2ciR7fkCh0gDnif5P11R?=
 =?us-ascii?Q?GDRiiXreKYfPsl1xFhpSb49lAmH1rfh1vScdI4pVVZOB5lTRNFADmFpXVEyW?=
 =?us-ascii?Q?EszE7saTCEIPzXZsLbhmXlmk0VtAylLNkIgd7z0cDUaRKv8IcmFnGSjyx9Pz?=
 =?us-ascii?Q?++v4gMZLRd4Bku0uJmL+9aiYrP/qmHjNJ5QKPVmQC+MxpyLE7bgph2LqAt2l?=
 =?us-ascii?Q?ALMQFvzwBlAvyE/J46ND8/MLgb7UnaO/88L4pgqvadc+4xLTZsB5xwwsUQZ3?=
 =?us-ascii?Q?45iIqvyY8T72l7IuigUExT0aovPCSwzUgb/H37kAJmfgaoHVgHhUqErEnQlF?=
 =?us-ascii?Q?xFnUcK+c0ytjY1GHOOCy+2RqDkS1pvd4XVtmGhkoU4viDjo+x+nOuoc+reLT?=
 =?us-ascii?Q?bDTwFKugyZgUVhKS12aLdbgQMUieTBCl284EebutQzdpDqjK7EN6s/CCA7Zw?=
 =?us-ascii?Q?E292+QafccLVgMqyptBl81mlajJOdc9/Jk4FjMr11thj6U8EhbDSY8SSvjDE?=
 =?us-ascii?Q?FZ3mF1YDvb6S7YFOs+eNerhX/OEYOHG4BghFboOpCZ+24C9XXmYd1vYFs/KC?=
 =?us-ascii?Q?fCBTwoLKHNBcJf/xW6cUNuD94ygrtJ4i6mGYCtQCGoF1JW0Qxzf7MLXVcwRx?=
 =?us-ascii?Q?qEexLYCsoqr08vnMcT+mZsnLXF4DyiEwK+59/WG+BKkbA/cMKUzhSPMTvDyn?=
 =?us-ascii?Q?puLkr6SpcFrs3uY4JXx16lbTQVqYzyzLEUcxXy36XLgT4A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DiaaBDsWzdFR+Gi9RgXy8lKErpnHrKXD7uPPoknAD2N1yu1erw6IzaifmtEp?=
 =?us-ascii?Q?cyX0l5ETxebZQmlFKsbmu9lTKpCJJIAys+w9L9I7HM5MWzXjmRK24GYCc/ph?=
 =?us-ascii?Q?tMBtXwhaeXVwXEStVlUGfNLCDm2x5xRj8ezzSECi6sixccyPX90MCihqaayW?=
 =?us-ascii?Q?x1qx7bK1p+hzBu+EKPZVchkqn61Tu57Kd5h4G7bwOTq/jRKJE2PpdxVyEm2D?=
 =?us-ascii?Q?n0nmjrELy95hXP1tTKzz924DRw0m7VtnSmcwT5J5AWxSbUdI4Sj+4GpyziiT?=
 =?us-ascii?Q?7utAoDTOMFFeODorTVQTfIoUtSU7NpFRpgXxHRUdyu1I+oW2e/7e5JCkIS0M?=
 =?us-ascii?Q?GGxTZiYCcCR6bXWMjTaTFZ7+61EK4vC/+34wQxG0GdIOSsB+uFQxaeelo9wF?=
 =?us-ascii?Q?WiSo4W8MLDE+msgFS4djWO2G89L+brx7Gy7yBNe+mU25iDK4zuoLorWVAwIS?=
 =?us-ascii?Q?nEEqJXZQnoys9ntguT/hESE6J/0G0S79tzw0euEk/SDPW59InDsG4KzCuC3R?=
 =?us-ascii?Q?Jf95jwih8JywpOnjTX0INMVBy7p17B89qdI84fyrKtrhccjnuey2yOJ9xbZS?=
 =?us-ascii?Q?/kSjMyzXSKzkr1dNhvG/eGAMCqm742q+iM+h+pMGTezGxTTGV8wVvZU2rc4z?=
 =?us-ascii?Q?4n4BOxx3Fonh43H96q+KhhPV0S330s8Nb6DKz6dXC1CIjvIwsaxgM1PmSN+9?=
 =?us-ascii?Q?rdgZPdkaeoFi9Uwpd7lxyD3AdkqXdeGjxCpIYwuadEzCCib57NxGRTKxaM5+?=
 =?us-ascii?Q?uKcl5DShEqjUIzF796T8assS5xDMBrRkTEgcqFS2riXHVEDKL5Jvgli0zkxP?=
 =?us-ascii?Q?MCUQhMPw8VOcHjVsr7rSp4nW/7Eiho5r1IhU1UWFuvAe46+AUh8DSl5VTjlY?=
 =?us-ascii?Q?vgUq1cLV4o6LhiBRghjmKvQej7r6HQ9LHy89SyC71JuCBF6lxPJubOkGTmzo?=
 =?us-ascii?Q?Mr6ykKoQ1LXI/qpPuG93zhjkQjYE5pOIQN6nInQUyacp4unxZNb9+kALysCL?=
 =?us-ascii?Q?kAuP91UPbzqAZNHJ4EiO6p1bCJ8GcTBAZ9LtP6AfRC0/hAly48lGEpeHL2J6?=
 =?us-ascii?Q?MHDv3af8jdOYV8vP5o4VCrRA8ZNH8Rji55FchOFtk6esWXiWWDMcaSGocBxe?=
 =?us-ascii?Q?N8HHuPunPptJqbaqOb1J/iQRQ54oS1RbRAtU1S5XDkb5shFeOQD6NRa+G4A/?=
 =?us-ascii?Q?8aXGzUzyTgupN/XsleVdE3fhbvB+WdxypQDJorD/iW6VKN3WdFFhrEmrcYv0?=
 =?us-ascii?Q?xl5cCsO8aQF9QjEbd6G4JGxseCFXsGGK3q8sameMlHaXsW94S9Pce++ZfNP+?=
 =?us-ascii?Q?F/Jdr+dhLqxyLLBquHDvBubXHVycCX6ENEQJfPRuOjG4MgfWQHRwOPGchv9X?=
 =?us-ascii?Q?Q4IF7hWWeGhaIfqVunzUwdftUsvULGErA/N7jSZQSP6RMKXGsGWyrmq6YhIG?=
 =?us-ascii?Q?s+fQ4s2plSAJgdN/+W7ThN7xcTpVDv1RTs8+Jl7iyejJ1LC/FDP4EfEoP2NW?=
 =?us-ascii?Q?GnwNrn4QcP6ujqf/uKzm+MrGl8Mi3Q1tcpXFSHw7EpIiJDAFelATe1voXAcJ?=
 =?us-ascii?Q?ymPjcRPRRIxk2m+c5cI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42c00cdc-9801-4e5c-aed7-08dcbd3c8e74
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:36.8048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oSWpNNT5aCHYJk/pkr56MaBZbRsfklrg6iSdmulqLvw6Oz+zahG4gMkH9CJ9DZ/i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146

Implement a self-segmenting algorithm for map_pages. This can handle any
valid input VA/length and will automatically break it up into
appropriately sized table entries using a recursive descent algorithm.

The appropriate page size is computed each step using some bitwise
calculations.

map is slightly complicated because it has to handle a number of special
edge cases:
 - Overmapping a previously shared table with an OA - requries validating
   and discarding the possibly empty tables
 - Doing the above across an entire to-be-created contiguous entry.
 - Installing a new table concurrently with another thread
 - Racing table installation with CPU cache flushing
 - Expanding the table by adding more top levels on the fly

Managing the table installation race is done using a flag in the
folio. When the shared table entry is possibly unflushed the flag will be
set. This works for all pagetable formats but is less efficient than the
io-pgtable-arm-lpae approach of using a SW table bit. It may be
interesting to provide the latter as an option.

Table expansion is a unique feature of AMDv1, this version is quite
similar except we handle racing concurrent lockless map. The table top
pointer and starting level are encoding in a single uintptr_t which
ensures we can READ_ONCE() without tearing. Any op will do the READ_ONCE()
and use that fixed point as its starting point. Concurrent expansion is
handled with a table global spinlock.

When inserting a new table entry map checks that the portion of the table
is empty. This includes removing an empty interior tables. The approach
here is atomic per entry. Either the new entry is written, or no change is
made to the table. This is done by keeping a list of interior tables to
free and only progressing once the entire space is checked to be empty.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 337 ++++++++++++++++++++++++++++
 include/linux/generic_pt/iommu.h    |  29 +++
 2 files changed, 366 insertions(+)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 6d1c59b33d02f3..a886c94a33eb6c 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -159,6 +159,342 @@ static int __collect_tables(struct pt_range *range, void *arg,
 	return 0;
 }
 
+/* Allocate a table, the empty table will be ready to be installed. */
+static inline struct pt_table_p *_table_alloc(struct pt_common *common,
+					      size_t lg2sz, gfp_t gfp,
+					      bool no_incoherent_start)
+{
+	struct pt_iommu *iommu_table = iommu_from_common(common);
+	struct pt_table_p *table_mem;
+
+	table_mem = pt_radix_alloc(common, iommu_table->nid, lg2sz, gfp);
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT) &&
+	    !no_incoherent_start) {
+		int ret = pt_radix_start_incoherent(
+			table_mem, iommu_table->iommu_device, true);
+		if (ret) {
+			pt_radix_free(table_mem);
+			return ERR_PTR(ret);
+		}
+	}
+	return table_mem;
+}
+
+static inline struct pt_table_p *table_alloc_top(struct pt_common *common,
+						 uintptr_t top_of_table,
+						 gfp_t gfp,
+						 bool no_incoherent_start)
+{
+	/*
+	 * FIXME top is special it doesn't need RCU or the list, and it might be
+	 * small. For now just waste a page on it regardless.
+	 */
+	return _table_alloc(common,
+			    max(pt_top_memsize_lg2(common, top_of_table),
+				PAGE_SHIFT),
+			    gfp, no_incoherent_start);
+}
+
+/* Allocate an interior table */
+static inline struct pt_table_p *table_alloc(struct pt_state *pts, gfp_t gfp,
+					     bool no_incoherent_start)
+{
+	return _table_alloc(pts->range->common,
+			    pt_num_items_lg2(pts) + ilog2(PT_ENTRY_WORD_SIZE),
+			    gfp, no_incoherent_start);
+}
+
+static inline int pt_iommu_new_table(struct pt_state *pts,
+				     struct pt_write_attrs *attrs,
+				     bool no_incoherent_start)
+{
+	struct pt_table_p *table_mem;
+
+	/* Given PA/VA/length can't be represented */
+	if (unlikely(!pt_can_have_table(pts)))
+		return -ENXIO;
+
+	table_mem = table_alloc(pts, attrs->gfp, no_incoherent_start);
+	if (IS_ERR(table_mem))
+		return PTR_ERR(table_mem);
+
+	if (!pt_install_table(pts, virt_to_phys(table_mem), attrs)) {
+		pt_radix_free(table_mem);
+		return -EAGAIN;
+	}
+	pts->table_lower = table_mem;
+	return 0;
+}
+
+struct pt_iommu_map_args {
+	struct pt_radix_list_head free_list;
+	struct pt_write_attrs attrs;
+	pt_oaddr_t oa;
+};
+
+/*
+ * Check that the items in a contiguous block are all empty. This will
+ * recursively check any tables in the block to validate they are empty and
+ * accumulate them on the free list. Makes no change on failure. On success
+ * caller must fill the items.
+ */
+static int pt_iommu_clear_contig(const struct pt_state *start_pts,
+				 struct pt_iommu_map_args *map,
+				 struct iommu_write_log *wlog,
+				 unsigned int pgsize_lg2)
+{
+	struct pt_range range = *start_pts->range;
+	struct pt_state pts =
+		pt_init(&range, start_pts->level, start_pts->table);
+	struct pt_iommu_collect_args collect = {
+		.free_list = map->free_list,
+	};
+	int ret;
+
+	pts.index = start_pts->index;
+	pts.table_lower = start_pts->table_lower;
+	pts.end_index = start_pts->index +
+			log2_to_int(pgsize_lg2 - pt_table_item_lg2sz(&pts));
+	pts.type = start_pts->type;
+	pts.entry = start_pts->entry;
+	while (true) {
+		if (pts.type == PT_ENTRY_TABLE) {
+			ret = pt_walk_child_all(&pts, __collect_tables,
+						&collect);
+			if (ret)
+				return ret;
+			pt_radix_add_list(&collect.free_list,
+					  pt_table_ptr(&pts));
+		} else if (pts.type != PT_ENTRY_EMPTY) {
+			return -EADDRINUSE;
+		}
+
+		_pt_advance(&pts, ilog2(1));
+		if (pts.index == pts.end_index)
+			break;
+		pt_load_entry(&pts);
+	}
+	map->free_list = collect.free_list;
+	return 0;
+}
+
+static int __map_pages(struct pt_range *range, void *arg, unsigned int level,
+		       struct pt_table_p *table)
+{
+	struct iommu_write_log wlog __cleanup(done_writes) = { .range = range };
+	struct pt_state pts = pt_init(range, level, table);
+	struct pt_iommu_map_args *map = arg;
+	int ret;
+
+again:
+	for_each_pt_level_item(&pts) {
+		/*
+		 * FIXME: This allows us to segment on our own, but there is
+		 * probably a better performing way to implement it.
+		 */
+		unsigned int pgsize_lg2 = pt_compute_best_pgsize(&pts, map->oa);
+
+		/*
+		 * Our mapping fully covers this page size of items starting
+		 * here
+		 */
+		if (pgsize_lg2) {
+			if (pgsize_lg2 != pt_table_item_lg2sz(&pts) ||
+			    pts.type != PT_ENTRY_EMPTY) {
+				ret = pt_iommu_clear_contig(&pts, map, &wlog,
+							    pgsize_lg2);
+				if (ret)
+					return ret;
+			}
+
+			record_write(&wlog, &pts, pgsize_lg2);
+			pt_install_leaf_entry(&pts, map->oa, pgsize_lg2,
+					      &map->attrs);
+			pts.type = PT_ENTRY_OA;
+			map->oa += log2_to_int(pgsize_lg2);
+			continue;
+		}
+
+		/* Otherwise we need to descend to a child table */
+
+		if (pts.type == PT_ENTRY_EMPTY) {
+			record_write(&wlog, &pts, ilog2(1));
+			ret = pt_iommu_new_table(&pts, &map->attrs, false);
+			if (ret) {
+				/*
+				 * Racing with another thread installing a table
+				 */
+				if (ret == -EAGAIN)
+					goto again;
+				return ret;
+			}
+			if (pts_feature(&pts, PT_FEAT_DMA_INCOHERENT)) {
+				done_writes(&wlog);
+				pt_radix_done_incoherent_flush(pts.table_lower);
+			}
+		} else if (pts.type == PT_ENTRY_TABLE) {
+			/*
+			 * Racing with a shared pt_iommu_new_table()? The other
+			 * thread is still flushing the cache, so we have to
+			 * also flush it to ensure that when our thread's map
+			 * completes our mapping is working.
+			 *
+			 * Using the folio memory means we don't have to rely on
+			 * an available PTE bit to keep track.
+			 *
+			 */
+			if (pts_feature(&pts, PT_FEAT_DMA_INCOHERENT) &&
+			    pt_radix_incoherent_still_flushing(pts.table_lower))
+				record_write(&wlog, &pts, ilog2(1));
+		} else {
+			return -EADDRINUSE;
+		}
+
+		/*
+		 * Notice the already present table can possibly be shared with
+		 * another concurrent map.
+		 */
+		ret = pt_descend(&pts, arg, __map_pages);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+/*
+ * Add a table to the top, increasing the top level as much as necessary to
+ * encompass range.
+ */
+static int increase_top(struct pt_iommu *iommu_table, struct pt_range *range,
+			struct pt_write_attrs *attrs)
+{
+	struct pt_common *common = common_from_iommu(iommu_table);
+	uintptr_t top_of_table = READ_ONCE(common->top_of_table);
+	uintptr_t new_top_of_table = top_of_table;
+	struct pt_radix_list_head free_list = {};
+	unsigned long flags;
+	int ret;
+
+	while (true) {
+		struct pt_range top_range =
+			_pt_top_range(common, new_top_of_table);
+		struct pt_state pts = pt_init_top(&top_range);
+		struct pt_table_p *table_mem;
+
+		top_range.va = range->va;
+		top_range.last_va = range->last_va;
+
+		if (!pt_check_range(&top_range))
+			break;
+
+		pts.level++;
+		if (pts.level > PT_MAX_TOP_LEVEL ||
+		    pt_table_item_lg2sz(&pts) >= common->max_vasz_lg2) {
+			ret = -ERANGE;
+			goto err_free;
+		}
+
+		table_mem = table_alloc_top(
+			common, _pt_top_set(NULL, pts.level), attrs->gfp, true);
+		if (IS_ERR(table_mem))
+			return PTR_ERR(table_mem);
+		pt_radix_add_list(&free_list, table_mem);
+
+		/* The new table links to the lower table always at index 0 */
+		top_range.va = 0;
+		pts.table_lower = pts.table;
+		pts.table = table_mem;
+		pt_load_single_entry(&pts);
+		PT_WARN_ON(pts.index != 0);
+		pt_install_table(&pts, virt_to_phys(pts.table_lower), attrs);
+		new_top_of_table = _pt_top_set(pts.table, pts.level);
+
+		top_range = _pt_top_range(common, new_top_of_table);
+	}
+
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
+		ret = pt_radix_start_incoherent_list(
+			&free_list, iommu_from_common(common)->iommu_device);
+		if (ret)
+			goto err_free;
+	}
+
+	/*
+	 * top_of_table is write locked by the spinlock, but readers can use
+	 * READ_ONCE() to get the value. Since we encode both the level and the
+	 * pointer in one quanta the lockless reader will always see something
+	 * valid. The HW must be updated to the new level under the spinlock
+	 * before top_of_table is updated so that concurrent readers don't map
+	 * into the new level until it is fully functional. If another thread
+	 * already updated it while we were working then throw everything away
+	 * and try again.
+	 */
+	spin_lock_irqsave(&iommu_table->table_lock, flags);
+	if (common->top_of_table != top_of_table) {
+		spin_unlock_irqrestore(&iommu_table->table_lock, flags);
+		ret = -EAGAIN;
+		goto err_free;
+	}
+
+	/* FIXME update the HW here */
+	WRITE_ONCE(common->top_of_table, new_top_of_table);
+	spin_unlock_irqrestore(&iommu_table->table_lock, flags);
+
+	*range = pt_make_range(common, range->va, range->last_va);
+	PT_WARN_ON(pt_check_range(range));
+	return 0;
+
+err_free:
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT))
+		pt_radix_stop_incoherent_list(
+			&free_list, iommu_from_common(common)->iommu_device);
+	pt_radix_free_list(&free_list);
+	return ret;
+}
+
+static int NS(map_pages)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			 phys_addr_t paddr, dma_addr_t len, unsigned int prot,
+			 gfp_t gfp, size_t *mapped,
+			 struct iommu_iotlb_gather *iotlb_gather)
+{
+	struct pt_common *common = common_from_iommu(iommu_table);
+	struct pt_iommu_map_args map = { .oa = paddr };
+	struct pt_range range;
+	int ret;
+
+	if (WARN_ON(!(prot & (IOMMU_READ | IOMMU_WRITE))))
+		return -EINVAL;
+
+	if ((sizeof(pt_oaddr_t) > sizeof(paddr) && paddr > PT_VADDR_MAX) ||
+	    (common->max_oasz_lg2 != PT_VADDR_MAX_LG2 &&
+	     oalog2_div(paddr, common->max_oasz_lg2)))
+		return -ERANGE;
+
+	ret = pt_iommu_set_prot(common, &map.attrs, prot);
+	if (ret)
+		return ret;
+	map.attrs.gfp = gfp;
+
+again:
+	ret = make_range(common_from_iommu(iommu_table), &range, iova, len);
+	if (pt_feature(common, PT_FEAT_DYNAMIC_TOP) && ret == -ERANGE) {
+		ret = increase_top(iommu_table, &range, &map.attrs);
+		if (ret) {
+			if (ret == -EAGAIN)
+				goto again;
+			return ret;
+		}
+	}
+	if (ret)
+		return ret;
+
+	ret = pt_walk_range(&range, __map_pages, &map);
+
+	/* Bytes successfully mapped */
+	*mapped += map.oa - paddr;
+	return ret;
+}
+
 struct pt_unmap_args {
 	struct pt_radix_list_head free_list;
 	pt_vaddr_t unmapped;
@@ -285,6 +621,7 @@ static void NS(deinit)(struct pt_iommu *iommu_table)
 }
 
 static const struct pt_iommu_ops NS(ops) = {
+	.map_pages = NS(map_pages),
 	.unmap_pages = NS(unmap_pages),
 	.iova_to_phys = NS(iova_to_phys),
 	.get_info = NS(get_info),
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index bdb6bf2c2ebe85..88e45d21dd21c4 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -61,6 +61,35 @@ struct pt_iommu_info {
 
 /* See the function comments in iommu_pt.c for kdocs */
 struct pt_iommu_ops {
+	/**
+	 * map_pages() - Install translation for an IOVA range
+	 * @iommu_table: Table to manipulate
+	 * @iova: IO virtual address to start
+	 * @paddr: Physical/Output address to start
+	 * @len: Length of the range starting from @iova
+	 * @prot: A bitmap of IOMMU_READ/WRITE/CACHE/NOEXEC/MMIO
+	 * @gfp: GFP flags for any memory allocations
+	 * @gather: Gather struct that must be flushed on return
+	 *
+	 * The range starting at IOVA will have paddr installed into it. The
+	 * rage is automatically segmented into optimally sized table entries,
+	 * and can have any valid alignment.
+	 *
+	 * On error the caller will probably want to invoke unmap on the range
+	 * from iova up to the amount indicated by @mapped to return the table
+	 * back to an unchanged state.
+	 *
+	 * Context: The caller must hold a write range lock that includes
+	 * the whole range.
+	 *
+	 * Returns: -ERRNO on failure, 0 on success. The number of bytes of VA
+	 * that were mapped are added to @mapped, @mapped is not zerod first.
+	 */
+	int (*map_pages)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			 phys_addr_t paddr, dma_addr_t len, unsigned int prot,
+			 gfp_t gfp, size_t *mapped,
+			 struct iommu_iotlb_gather *iotlb_gather);
+
 	/**
 	 * unmap_pages() - Make a range of IOVA empty/not present
 	 * @iommu_table: Table to manipulate
-- 
2.46.0


