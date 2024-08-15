Return-Path: <kvm+bounces-24275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C16A59536B9
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:12:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42A5C1F22577
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B661A76BC;
	Thu, 15 Aug 2024 15:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="izF+pujD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEC61ABEC8
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734708; cv=fail; b=Ftk/C5HZxEO6wMZHA3lgkll1snJ5e80G0g429ZAcKqle8MQ49KIpjpUKsgAiXhdsYRnl6pBE6ta7lZf5LnvpNGrUtwZupgUqIZI5AFT8o7UAgoAl9wldIj32hahx1sJnVhMGrX8wioH29LSnbdNbF5NoDBK3UgNu5aZfHZFO/kc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734708; c=relaxed/simple;
	bh=5q8ox8u6ER/A2O25TMKyRiddQ8hXgbfucnlYAQsfHoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rbBpd5edEb2D+31It5NOUyEmK2667J0DdJZfcZYFli1wNyVvoqwo8hTod4zvuiy/E/m/5b7C7j9G+lzwfh7Wc3r1ha9AmBP1EINv8/GEzbfPN58duYMzHlHKmt/iHE3qRdQDUiLq7WLld16ekvcWS6+luYwJUW7ew5S+DMuuDd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=izF+pujD; arc=fail smtp.client-ip=40.107.92.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MFiusJvmurS8wISARywhk/bKo8z36QuBoLE+aV+z0NeddEyZkHoLSHC526DpntkDG2JwSOY/kkK2JPUNej8czxwziqNlHlaI3z+1iH5Rs8nt+0eeMVPR6U3cMrscesIVVNKdwO42IYkUTsmAl6VVZLAG34+Uuj7t+6elfOegv18eGjYifiDPdmNyZb6vReaCbKcyMG4rc3Gwopc5++LdOYy8RQi6bL8sWjis8s8j87XAWVIzxlQkLBhFD5FrllbBlVoqRNosH8SFgrA4b7MfP4jklDPBbv43dkXa3Lg/3uOZ30IBF5I9OxGcLeEe4FXzEMjg5ZJM7NL0cGKQDrfA3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJJA1GQA3vJPtmW3yZinNnfONAqFQ4KjojeNqa3Q0/k=;
 b=YJKGUUblNrCZDaga5IqFrQNsuIXIIHzsziedgvaAN0RU9fgsrDfc9mz0hYE5wCfExVxueL5unfNheZVlV3lH3+31aYe3iHyMyq66U7VBKzQuj4omgnxt6uyE7AIIS1sd+OCog5Wi176XiDHVK/eXjhq+ktMfKVModjUlwjIvGzyoZGC0NBU39gWtfODH/KKmp6S1MAEGCouTV7R/oJQc2EXLNNqBoyjc2n1N+llCJ7aMJrnQy2cD1O5pqZ0M+taw6gzGYn/oMUK2C3JbziMXRCLqFq0tSmTAuBb/d+aKYKqp7OFND40U43BhvgFWgaQtYBIqzYDTgbSp5OU1rQEFxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJJA1GQA3vJPtmW3yZinNnfONAqFQ4KjojeNqa3Q0/k=;
 b=izF+pujDchOiDYDyEc2zpKeWQehgzlmWdDMVXwS9CYAQFBhhNKQwVF39qYbGqNWpq86YfDwUMCDPPzA7UOuzDnr8r3AnEkne2mA0MrPSPiTv0usnlB/qRzu4uZOYBqKeKjAvuF+EKH5g8HHaQiopT3eRq8h5N+4qAXFxCudftgzIK2PcIZOQUvFLAdzS0+yHtk+ocWig3QfCVgncG5YdP+BaSbCX1/k+pR/uNyr1zD7oTQpcgL4vEsCo/1W5H1orGM3sn8Odfshxq6HSX6SCsTj9pcV/zL1A6hn/9j8pmRZ9i05qijOkHTmrfNRiW2HgQpQbIDKpwxsnKhRiBUKsKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB6631.namprd12.prod.outlook.com (2603:10b6:8:d1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Thu, 15 Aug
 2024 15:11:40 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 15:11:40 +0000
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
Subject: [PATCH 02/16] genpt: Add a specialized allocator for page table levels
Date: Thu, 15 Aug 2024 12:11:18 -0300
Message-ID: <2-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:208:335::26) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: 64bd94e8-6c90-4333-4927-08dcbd3c8e12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VP6dQLmgY3NjXPaFZ6xFFwUkqgXP5NkntvAg5PTwcnrgnYeEK/Zegm+7FQsz?=
 =?us-ascii?Q?erpVNs2NbecLyJ9ntgRaC2gqhCuHoaSNRjFCLCKHnX+PQ9IjyXBpI+HOmLVT?=
 =?us-ascii?Q?FlVd/w0h/02pvhwa3y0dfFB06YDT6Cx8Rfa5UQsrYJSZ0ozCCU38/p3UcQvJ?=
 =?us-ascii?Q?zzlqIn/mHMTzG/G7yhy/ucfslfQhWm9fLnLOI4c1qksnGBWVDd5B2GwHVpp/?=
 =?us-ascii?Q?fh3bySVq5ZWUhJBiKa44Ylhj7MOBhB8XMpIs6e1YuS4QTknW85fRdyjL0ZK6?=
 =?us-ascii?Q?XjGlvzRraDVkrJ0XyIBbnSKmn0LK2SX5pzx7qzUlGybTKvLe9Xi2se01rQAB?=
 =?us-ascii?Q?Dp2GYpMs8rvAO4/gDSZoTI1kIXkgvbPlQATFNVFyRShOG7g2/tNeEzFfuw/n?=
 =?us-ascii?Q?CUq1SzySH+J93Lr3HXT1+6Dw3GM5bqJ+FjT3LIsbLP/YAL8maaOoiEE/UsEr?=
 =?us-ascii?Q?bvnapvfJHsJIUhmpZphSAP+J0aIe1a7X6cUT/E4kPyanmxuIE6TpZ4GGTsYM?=
 =?us-ascii?Q?SvqD5YtlZs0R3L2QeQ48aN5+m8q6GHHr7z/+Ln3YhuTWEnG5y5XV4N7Q0kBg?=
 =?us-ascii?Q?aRnayh587WMZnfj86Npnz9z9jICkhOeKo/+/6HuhWTWljzfqAn0F8L9CDyTo?=
 =?us-ascii?Q?b3d9VZibbJMTSUeUNAfF8e3fUIVvDDTMiZYEhdcFWacS4dyyXCu52sIteiXL?=
 =?us-ascii?Q?6PlDFV8wj85WbimjOr4doHysKZOAGKyrqv8fYcL6TdssSjsq39iKBEPwYRFo?=
 =?us-ascii?Q?928SRlsrUjB2noP7473c98qlFM4OfxEpK0JgAe/FVWEZO55kAwEPw+Oay6Xn?=
 =?us-ascii?Q?8Cel/DA6aIlfQRQqInR61JQ0mrHwrhKsj9vP0sd+ewTByPUxkXzBwSfWVere?=
 =?us-ascii?Q?e/F6rC/6Y/FF+IYtaJD5Pv9jrXtK4On+RXXjzad03spqY1dlsxseUSvMmrQW?=
 =?us-ascii?Q?e34J9v4OwS4iv4FbLM+vCc2a3d1MYs7zhJaFG9T1pNaMtQ98iDhlC8qwqbwb?=
 =?us-ascii?Q?Tdc87xGWrSkEjoJpmlv+VPXmX58d9xKMsM1bhuyRI0lNsFOo63oOf4JkM2OP?=
 =?us-ascii?Q?Kj7s0iPypAgaI/xtW4BogEeqbhGDtEBBBbsKbfu856RkHGg2CfmZrHwTSYvo?=
 =?us-ascii?Q?HiL/4h5D4jgY2wuceVX1uyXHIcDNGdOhIA3GZfArf6ZGwu7lq2fOgX+mkSMx?=
 =?us-ascii?Q?O+F94vY4Y1MQmDUNsVK8t7oxrSu6C57jJif5g/S/JzwLnvy4Fo7fjm31hr8+?=
 =?us-ascii?Q?z6UR8ojWOJx/TPAJ7L6PGVL3JZrr/2uTHzHjMgIkDFSfjwRVjYkI1ldOP1+x?=
 =?us-ascii?Q?+w2/EEwsvYer6EorNzkfhVXHyUwu2qwb9w//Kif801zncg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k+fZLrzDM102u+qlw/t1/ymr1XjRCe5ES7bAhGZfpA4VoqGKFfmQEVKXAzyR?=
 =?us-ascii?Q?Noi7ta/epMRn8bcsBK9MPive+NnqXjSNB+OJyR6zvbCStpYxQ/Jm9MnT03BD?=
 =?us-ascii?Q?HB8HdszG+1636MNN+gTSh6fzgppcAEikuEPCn0FhJVWR7bwJ1nzJkSNE9DRY?=
 =?us-ascii?Q?dgxj0c4VGw51U5oGgOXEKjCW5qf7ZfiOQo3SmV2sXJdKbKiZJwIzEHMdZRkU?=
 =?us-ascii?Q?P571OTHFuacLLXdjzZUjhGJNFLmL1yMaiySn0jMv6iiQcBjAphxrCQW1V8Xj?=
 =?us-ascii?Q?MAhHYgeQFuC5/dZA9w5Ehbx5KkaUU9ChPZPJp8AZ9CG47ogz0Nz3jNkzj12b?=
 =?us-ascii?Q?zv5AKmIe2DWAxqjgMeoQmevz89czLFspMOEY2F0X9Y2IRovte990FdT9+lON?=
 =?us-ascii?Q?thesm8iaj3Ch+p6bI/U8iKtYm4UGsSsCMw9vQrajlTtFE3wsPjp0O//fa/ZA?=
 =?us-ascii?Q?SfkRVVBRH4FFp3CdjRSenjLghTlualMAeT0OFFYRbh2/6HBTbF/zDZu3Fiiy?=
 =?us-ascii?Q?afVUWZXL0Fu98KC5ejPREMJBQwTfchmtEa627CGDRWvVZK0ObJusTN+BeS1t?=
 =?us-ascii?Q?DVP+YhD3K8INTX8NnUbVTyz9iNQN7EBDnP/HuECqscS+x7et4/6m9JsXyIUQ?=
 =?us-ascii?Q?ohyR+f0PD7glaTXuuTSx/IomhiNFUzkCRFuioaSaJ6nPTVN1kLdf9tAlKOSB?=
 =?us-ascii?Q?1jVDic/IoMWlcC+MfSzF22bWhevdg2pR/nE5+nKjuEvzG1D+9JaEjP0w/Uo9?=
 =?us-ascii?Q?B7koVPbFsAoc6qeOnMotjC7ovpcor8ZA1GGodvsKBiM2tyDoq9w3JfwMY6q3?=
 =?us-ascii?Q?ZIDfW+vgHU2HRwIChFmJ9WgERRXorxNh9LWFCBeGyRj0LfQXX20Vz/ktcebw?=
 =?us-ascii?Q?FunqLs9Pw96RLaPTQL0yfJVXR43LcVzHOuf88ZeQBst9fkXNdXLIpEEqZyqa?=
 =?us-ascii?Q?Ssmn/2RWl0RzN9hqEIAUC2paBS1+QjzYTF2QTccNmS9MmXQaWD0j8/ddT+0x?=
 =?us-ascii?Q?Zm0zmmD8PhEUSR4J/ksg37/xZcuEPVtmkHVbp+ZwwbiFeyXy0P+tA70WPL5H?=
 =?us-ascii?Q?+nCvboxr6nFNropeSPVn4fr2XbKZ1YusykaJNJ0a8clOPLrm9kztHD3R9Iz2?=
 =?us-ascii?Q?fcxOyN22KC6bP8bR3P7cAyjym0kqKJX9kfH1u5qR5GBy8ERn3fD0iC42pHY1?=
 =?us-ascii?Q?1GQqaMa4UMImyCMocpBrxzFUTmh282zUHi4PlICkhkwkruSOxOALh7s5F+bl?=
 =?us-ascii?Q?sCPChhlWN2rsjUpzb+6XDJrdA9woVNOcRdyUQ3J4r8eRLIJRmJStAfV2lOXx?=
 =?us-ascii?Q?7EOqu7WOoVZkm1QnD1FAZ3tH+b954CUuqRX9GriP+os9fxGjQmkYIbxdYgag?=
 =?us-ascii?Q?SHu7v+MPIP4Bg/1cp0ye03E7GraoEVu/2sr3T9r/rCrkjQ3hQVIGmENh0C5L?=
 =?us-ascii?Q?pUmVK+oYFxfxJ4DHJSxY1B41dL9yoelNi3S4Y1Nil4VB5BiZdMtH1KGqM8bP?=
 =?us-ascii?Q?AVEZppk6I7pxrp5C9kb1slRc9YU5LKG9q6Kz1Eet2iwYA8JKLbmakq3O+HkN?=
 =?us-ascii?Q?OgsdWnOhqL73OITT99E=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64bd94e8-6c90-4333-4927-08dcbd3c8e12
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:36.0880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E2y5zo4N9OLEQHsgU/xG0d1seYXm6CE0zU7Aft7XzSB4AMOBaj3xglyrqOLZ4o95
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6631

A radix or "page table level" is the memory inside the page table used to
store the data. Generally formats have a fixed size for these tables and
all are uniform. It is usually PAGE_SIZE of their respective
architectures, but not always. Often the top most table level has a
different size than the rest.

The key function of this allocator is a way to maintain a linked list of
the memory, and a RCU free capability of those lists. Most of the
algorithms in the iommu implementation rely on the linked lists, and the
RCU is necessary for debugfs support.

Use the new folio-ish infrastructure for creating a custom struct page to
store the additional data.

Included in this is some support for managing the CPU cache invalidation
algorithm that ARM uses. The folio is used to record when the table memory
has been DMA mapped along with helpers to DMA API map/unmap the memory.

FIXME: Several of the formats require sub-page sizes (ie ARMv7s uses 1k
tables pages on a 4k architecture, ARMv8 can use 4k/16k/64k pages
regardless of the CPU PAGE_SIZE). 4:1 can be handled by giving up on the
no-allocate RCU and storing 4 next pointers directly in the folio. The
16:1 case would require allocating additional memory to hold the metadata,
much like Matthew's proposed memdesc. In a future memdesc world the
per-folio metadata would be allocated to the required size. This logic is
not implemented yet.

FIXME:
 - sub-page sizes. Without support it wastes memory but is suitable for
   funtional testing.
 - This has become weirdly named
 - This is general, except it does use NR_IOMMU_PAGES

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/Kconfig    |   8 ++
 drivers/iommu/generic_pt/Makefile   |   4 +
 drivers/iommu/generic_pt/pt_alloc.c | 174 ++++++++++++++++++++++++++++
 drivers/iommu/generic_pt/pt_alloc.h |  98 ++++++++++++++++
 4 files changed, 284 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/pt_alloc.c
 create mode 100644 drivers/iommu/generic_pt/pt_alloc.h

diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index 775a3afb563f72..c22a55b00784d0 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -19,4 +19,12 @@ config DEBUG_GENERIC_PT
 	  kernels.
 
 	  The kunit tests require this to be enabled to get full coverage.
+
+config IOMMU_PT
+	tristate "IOMMU Page Tables"
+	depends on IOMMU_SUPPORT
+	depends on GENERIC_PT
+	default n
+	help
+	  Generic library for building IOMMU page tables
 endif
diff --git a/drivers/iommu/generic_pt/Makefile b/drivers/iommu/generic_pt/Makefile
index f66554cd5c4518..f7862499642237 100644
--- a/drivers/iommu/generic_pt/Makefile
+++ b/drivers/iommu/generic_pt/Makefile
@@ -1 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+iommu_pt-y := \
+	pt_alloc.o
+
+obj-$(CONFIG_IOMMU_PT) += iommu_pt.o
diff --git a/drivers/iommu/generic_pt/pt_alloc.c b/drivers/iommu/generic_pt/pt_alloc.c
new file mode 100644
index 00000000000000..4ee032161103f3
--- /dev/null
+++ b/drivers/iommu/generic_pt/pt_alloc.c
@@ -0,0 +1,174 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#include "pt_alloc.h"
+#include "pt_log2.h"
+#include <linux/mm.h>
+#include <linux/dma-mapping.h>
+
+#define RADIX_MATCH(pg, rl)                        \
+	static_assert(offsetof(struct page, pg) == \
+		      offsetof(struct pt_radix_meta, rl))
+RADIX_MATCH(flags, __page_flags);
+RADIX_MATCH(rcu_head, rcu_head);	/* Ensure bit 0 is clear */
+RADIX_MATCH(mapping, __page_mapping);
+RADIX_MATCH(private, free_next);
+RADIX_MATCH(page_type, __page_type);
+RADIX_MATCH(_refcount, __page_refcount);
+#ifdef CONFIG_MEMCG
+RADIX_MATCH(memcg_data, memcg_data);
+#endif
+#undef RADIX_MATCH
+static_assert(sizeof(struct pt_radix_meta) <= sizeof(struct page));
+
+static inline struct folio *meta_to_folio(struct pt_radix_meta *meta)
+{
+	return (struct folio *)meta;
+}
+
+void *pt_radix_alloc(struct pt_common *owner, int nid, size_t lg2sz, gfp_t gfp)
+{
+	struct pt_radix_meta *meta;
+	unsigned int order;
+	struct folio *folio;
+
+	/*
+	 * FIXME we need to support sub page size tables, eg to allow a 4K table
+	 * on a 64K kernel. This should be done by allocating extra memory
+	 * per page and placing the pointer in the meta. The extra memory can
+	 * contain the additional list heads and rcu's required.
+	 */
+	if (lg2sz <= PAGE_SHIFT)
+		order = 0;
+	else
+		order = lg2sz - PAGE_SHIFT;
+
+	folio = (struct folio *)alloc_pages_node(
+		nid, gfp | __GFP_ZERO | __GFP_COMP, order);
+	if (!folio)
+		return ERR_PTR(-ENOMEM);
+
+	meta = folio_to_meta(folio);
+	meta->owner = owner;
+	meta->free_next = NULL;
+	meta->lg2sz = lg2sz;
+
+	mod_node_page_state(folio_pgdat(folio), NR_IOMMU_PAGES,
+			    log2_to_int_t(long, order));
+	lruvec_stat_mod_folio(folio, NR_SECONDARY_PAGETABLE,
+			      log2_to_int_t(long, order));
+
+	return folio_address(folio);
+}
+EXPORT_SYMBOL_NS_GPL(pt_radix_alloc, GENERIC_PT);
+
+void pt_radix_free_list(struct pt_radix_list_head *list)
+{
+	struct pt_radix_meta *cur = list->head;
+
+	while (cur) {
+		struct folio *folio = meta_to_folio(cur);
+		unsigned int order = folio_order(folio);
+		long pgcnt = 1UL << order;
+
+		mod_node_page_state(folio_pgdat(folio), NR_IOMMU_PAGES, -pgcnt);
+		lruvec_stat_mod_folio(folio, NR_SECONDARY_PAGETABLE, -pgcnt);
+
+		cur = cur->free_next;
+		folio->mapping = NULL;
+		__free_pages(&folio->page, order);
+	}
+}
+EXPORT_SYMBOL_NS_GPL(pt_radix_free_list, GENERIC_PT);
+
+void pt_radix_free(void *radix)
+{
+	struct pt_radix_meta *meta = virt_to_meta(radix);
+	struct pt_radix_list_head list = { .head = meta };
+
+	pt_radix_free_list(&list);
+}
+EXPORT_SYMBOL_NS_GPL(pt_radix_free, GENERIC_PT);
+
+static void pt_radix_free_list_rcu_cb(struct rcu_head *head)
+{
+	struct pt_radix_meta *meta =
+		container_of(head, struct pt_radix_meta, rcu_head);
+	struct pt_radix_list_head list = { .head = meta };
+
+	pt_radix_free_list(&list);
+}
+
+void pt_radix_free_list_rcu(struct pt_radix_list_head *list)
+{
+	if (!list->head)
+		return;
+	call_rcu(&list->head->rcu_head, pt_radix_free_list_rcu_cb);
+}
+EXPORT_SYMBOL_NS_GPL(pt_radix_free_list_rcu, GENERIC_PT);
+
+/*
+ * For incoherent memory we use the DMA API to manage the cache flushing. This
+ * is a lot of complexity compared to just calling arch_sync_dma_for_device(),
+ * but it is what the existing iommu drivers have been doing.
+ */
+int pt_radix_start_incoherent(void *radix, struct device *dma_dev,
+			      bool still_flushing)
+{
+	struct pt_radix_meta *meta = virt_to_meta(radix);
+	dma_addr_t dma;
+
+	dma = dma_map_single(dma_dev, radix, log2_to_int_t(size_t, meta->lg2sz),
+			     DMA_TO_DEVICE);
+	if (dma_mapping_error(dma_dev, dma))
+		return -EINVAL;
+
+	/* The DMA API is not allowed to do anything other than DMA direct. */
+	if (WARN_ON(dma != virt_to_phys(radix))) {
+		dma_unmap_single(dma_dev, dma,
+				 log2_to_int_t(size_t, meta->lg2sz),
+				 DMA_TO_DEVICE);
+		return -EOPNOTSUPP;
+	}
+	meta->incoherent = 1;
+	meta->still_flushing = 1;
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(pt_radix_start_incoherent, GENERIC_PT);
+
+int pt_radix_start_incoherent_list(struct pt_radix_list_head *list,
+				   struct device *dma_dev)
+{
+	struct pt_radix_meta *cur;
+	int ret;
+
+	for (cur = list->head; cur; cur = cur->free_next) {
+		if (cur->incoherent)
+			continue;
+
+		ret = pt_radix_start_incoherent(
+			folio_address(meta_to_folio(cur)), dma_dev, false);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(pt_radix_start_incoherent_list, GENERIC_PT);
+
+void pt_radix_stop_incoherent_list(struct pt_radix_list_head *list,
+				   struct device *dma_dev)
+{
+	struct pt_radix_meta *cur;
+
+	for (cur = list->head; cur; cur = cur->free_next) {
+		struct folio *folio = meta_to_folio(cur);
+
+		if (!cur->incoherent)
+			continue;
+		dma_unmap_single(dma_dev, virt_to_phys(folio_address(folio)),
+				 log2_to_int_t(size_t, cur->lg2sz),
+				 DMA_TO_DEVICE);
+	}
+}
+EXPORT_SYMBOL_NS_GPL(pt_radix_stop_incoherent_list, GENERIC_PT);
diff --git a/drivers/iommu/generic_pt/pt_alloc.h b/drivers/iommu/generic_pt/pt_alloc.h
new file mode 100644
index 00000000000000..9751cc63b7d13f
--- /dev/null
+++ b/drivers/iommu/generic_pt/pt_alloc.h
@@ -0,0 +1,98 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#ifndef __GENERIC_PT_PT_ALLOC_H
+#define __GENERIC_PT_PT_ALLOC_H
+
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/device.h>
+
+/*
+ * Per radix table level allocation meta data. This is very similar in purpose
+ * to the struct ptdesc.
+ *
+ * radix levels have special properties:
+ *   - Always a power of two size
+ *   - Can be threaded on a list without a memory allocation
+ *   - Can be RCU freed without a memory allocation
+ */
+struct pt_radix_meta {
+	unsigned long __page_flags;
+
+	struct rcu_head rcu_head;
+	union {
+		struct {
+			u8 lg2sz;
+			u8 incoherent;
+			u8 still_flushing;
+		};
+		unsigned long __page_mapping;
+	};
+	struct pt_common *owner;
+	struct pt_radix_meta *free_next;
+
+	unsigned int __page_type;
+	atomic_t __page_refcount;
+#ifdef CONFIG_MEMCG
+	unsigned long memcg_data;
+#endif
+};
+
+static inline struct pt_radix_meta *folio_to_meta(struct folio *folio)
+{
+	return (struct pt_radix_meta *)folio;
+}
+
+static inline struct pt_radix_meta *virt_to_meta(const void *addr)
+{
+	return folio_to_meta(virt_to_folio(addr));
+}
+
+struct pt_radix_list_head {
+	struct pt_radix_meta *head;
+};
+
+void *pt_radix_alloc(struct pt_common *owner, int nid, size_t log2size,
+		     gfp_t gfp);
+void pt_radix_free(void *radix);
+void pt_radix_free_list(struct pt_radix_list_head *list);
+void pt_radix_free_list_rcu(struct pt_radix_list_head *list);
+
+static inline void pt_radix_add_list(struct pt_radix_list_head *head,
+				     void *radix)
+{
+	struct pt_radix_meta *meta = virt_to_meta(radix);
+
+	meta->free_next = head->head;
+	head->head = meta->free_next;
+}
+
+int pt_radix_start_incoherent(void *radix, struct device *dma_dev,
+			      bool still_flushing);
+int pt_radix_start_incoherent_list(struct pt_radix_list_head *list,
+				   struct device *dma_dev);
+void pt_radix_stop_incoherent_list(struct pt_radix_list_head *list,
+				   struct device *dma_dev);
+
+static inline void pt_radix_done_incoherent_flush(void *radix)
+{
+	struct pt_radix_meta *meta = virt_to_meta(radix);
+
+	/*
+	 * Release/acquire is against the cache flush,
+	 * pt_radix_still_incoherent() must not return 0 until the HW observes
+	 * the flush.
+	 */
+	smp_store_release(&meta->still_flushing, 0);
+}
+
+static inline bool pt_radix_incoherent_still_flushing(void *radix)
+{
+	struct pt_radix_meta *meta = virt_to_meta(radix);
+
+	return smp_load_acquire(&meta->still_flushing);
+}
+
+#endif
-- 
2.46.0


