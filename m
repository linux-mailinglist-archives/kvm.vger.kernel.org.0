Return-Path: <kvm+bounces-24271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A9129536B6
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:11:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CF2D1C2402D
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC1561AB53B;
	Thu, 15 Aug 2024 15:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PDDTmYK7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D1319DF9C
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734705; cv=fail; b=ck1l857myTo1si2RXy+Yg2hKpkJZEMn9autTjB8mjIfKDm7IBzNzradJrMX7PXi8nOSMZPbqX2jUu9H5mRZXzLktsqgvq+Su5aDJewAPRu1VSPjIQKKTNTh8vnjpamMK9GCaDVYYp4lAfvPs2UHkNitH2suouC8LDP4dNvUKGSg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734705; c=relaxed/simple;
	bh=6wBlfx6SyuNxYG5csajEvknGLVOQeAH6aakFu4Ff2So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J1CjP744xb9/9/sXC0PvcXOcHrEw3IcV+oTJwROrqrYIO5FQOj8lfe5jhlw566n6Wjup6ledp4z5545IVz7j6srU9gvzVJiPhUOq/wFofmg5z/79SbNNczKjuEqtZNTqMp3uVTE5BA1eHA/JhEmVQUkcIbk6zTa+ARRUOTMtuqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PDDTmYK7; arc=fail smtp.client-ip=40.107.92.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aHaKy78KbNTc0SAtOlDhX/zR6XSuD8DyymaN6LTXhHksRIuDR/iWAgUgo9MXfpr5zBfi9VcIxyKB+L8KhxXRWNUGvsJchnrdc7eP7PIeYNjvMPYm3POq0GaUE4Bc6+4i9hd+IEvM9f0Dbj9wQWOci191fTHk2DHaDTW6M37Hoh/tdgzRZhVeB1bZcQXjBZAK3gS7xFbHZK1aOdeq1Pzg8BX/ya43JnhXQtIc8Lu1ysYh8iWngrsAtcAsOBPXAHJxIN8KZQwVPIV+5qmngXZNoMyNwHiWFSyyKVdws3Xfpy68SPLar/AftEBsPOUkySPAe+3DJrXWoO0eGjDkVmP7jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cT5OYTyoXYx5X/x38jJiW1W79T0WeY2Tg2D25rF5DZI=;
 b=gqSbBNBZ0qLxXxCPhNZUyeEwcpafirGWgcCYpjMYodStmRHt/LEQ0titBlHfFjtMqa2yV7H/9vZqDiWBwHiwBpYk25p9wiUl8JeYk8dsuvKa5gYmh0Bc8O+bYgD4iGt0r2650RWZNYzemn+e9BxRCMbUyoYlOUmGfIp6rHlLn/BS9xTrDYmdzMvG5R9X04fqck7HSbxTK3xfoXLJKOA5HDAo3YBz3aJo6/K9SZYd7Sq6eKNh++iM15vqtd6aLT1Fj5kBXrVyigUtnvhxTi/t0zJwQctYV9qCjFHDzbdrBgbdbwshCJtXNZVqruBrWV1y80rkbcesu4KPK+aV1eIxnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cT5OYTyoXYx5X/x38jJiW1W79T0WeY2Tg2D25rF5DZI=;
 b=PDDTmYK7316KTvAwV7FLzV8k3mZmXVLDVlofUDnukLePag6A2/aXe4cPJcU8SP23eCGV/y/CEBtPl4xszH6YY6q1nB89vXoDDkjInlETMtRRnuroM/glx0t5ZTP/JOQjDseOrxH1BJ1TsAaWBFPOJhZL6eafgKQyF0pAYsYbTUzdT0EatlE2XjNe/DzYegcyDhK8p4ifwJysfBaGhnuylETndQKqqTQfKBH8S71/LCJOEhICa+ogw97QdOGRbqkYMTSvXUfGieK6oCXSFeZnzVApV5P9Y6Lqvch3fjfgsr/KKsT8KbwDMgbBbijFHf8mlm2GuuEJFfDOkb8qi2q3tA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB8146.namprd12.prod.outlook.com (2603:10b6:806:323::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Thu, 15 Aug
 2024 15:11:35 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 15:11:35 +0000
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
Subject: [PATCH 08/16] iommupt: Add read_and_clear_dirty op
Date: Thu, 15 Aug 2024 12:11:24 -0300
Message-ID: <8-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0049.namprd05.prod.outlook.com
 (2603:10b6:208:236::18) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e4e0405-7df8-4d98-055f-08dcbd3c8d29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pos61fFPSFsNDtfDkVWGj5nL47JRth8Vp8W1ggD6VTclyqXVb+KbWbu5eRtk?=
 =?us-ascii?Q?mhI4kqzX7aSkcGurLR6l9cWwbvNXNMZZO8624PunO4uta0N2zt+1MtoY09EY?=
 =?us-ascii?Q?+dfQpNqtBrqlAw8Dgs4PoXSSdwJJJffB4Iiivc0uJ0O7zfeExnggrCBsccO0?=
 =?us-ascii?Q?29EHELZhYO1qkfUB0nL2u7ABt3uv139U1g+f6ex7/I6NAD92yN70uCG2v+wu?=
 =?us-ascii?Q?murXM3GoHkRoqZpcPa6GmdUc6WZ5mshCz1bjzrRsplpnCN7pi9EX3G0+gFp4?=
 =?us-ascii?Q?6V0wkSXVw5yiJdJSdasZxewdPk6BbN0crlzpS+PtdrXfXoo1sqi0VIikehBB?=
 =?us-ascii?Q?J7uQc5eKVuXPzX6AurpQBtPDFJzj0xAgDNOND0N89UMBCABCEtPJDM7iP8TU?=
 =?us-ascii?Q?Ip4K56VS5uSfY6Dl9bW+jBNWeRaU1u748Emx0wUSBhFYqwPH98fOL6vmp1t+?=
 =?us-ascii?Q?EuQsH4xdvq8yf1duJr5yiUC27HcVVbmP9LKQxQxMnuxAAYUWw3bL19nFKLFl?=
 =?us-ascii?Q?0e6zNQrvIz9FCBVxFYmbV5rM8SD2pfa6cMoTufh5DtnMCLzdwsquAI0e5kvx?=
 =?us-ascii?Q?tVTEQFi0f/uIKkZoIAnb6ImaNfwUyMcUduPBwYsKIFq+jXAy1JDI8Mz2XqnL?=
 =?us-ascii?Q?trGJIaPv7zfFuStplyTtGDXKaPs5D+E9sx74sg+87H+0GIp8A6jnXzsnOj66?=
 =?us-ascii?Q?28EuAeRwMTkoNY1Pf/H/FbLo+UIMLJLy1KdCG5UtiNE6RRpar/yqa53sbt7j?=
 =?us-ascii?Q?k99DpslRP88Tf+kcDCStaxFmlwBu5qHYr5pMwPbwhCbNV59qz2It1i8hR4d0?=
 =?us-ascii?Q?3gVvog5KtJAwCDH964Etwv/m5ow9vzwR31byG9ATvDRVbDkyc+rZwDx3iIIs?=
 =?us-ascii?Q?n18z2mdYyF7xvLk63Wj7xIXyyjwWedB4hgPYHSq50ViTArvLbTjPxR8D/hz9?=
 =?us-ascii?Q?pI+aCd3AbGbFCZXH0HhR7XKCrxW5ErbCmZVUzGTe5DYPSkIzWUVsC5EzrEya?=
 =?us-ascii?Q?KcNx+ZBmO8V65eXTITOcv1l8JByuECl6QT5Iym8Xy9VCYU51CP+Mgc5TxyLb?=
 =?us-ascii?Q?GAlp79Lj5aSVbwyGifZMttxUjC8Fkkf7EY3D+loSWEahHWl5UhfIlGXlD0Pa?=
 =?us-ascii?Q?qeoehbu3f3zo2R7ohgzcI3T+uE2z7hfsJU5/1+BV09okcv7zJNa7IUParFOr?=
 =?us-ascii?Q?1Y4fZLRY1O+3D5JUmkCyZ64w9q6/reo9nTumTx9wU+DRkwvra/jHlfJzIdvd?=
 =?us-ascii?Q?pL3QJeBwYOYICnIVhcrY3KpKtVFoR5rVXOnsKNf/3/iNqAZe2QAnRl087je/?=
 =?us-ascii?Q?3DHMnvHUHOfIf0/O6eMi6b8tkyTu8FRFZvJM5avTtmn+cQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ir7ZpkrRUOqHNZea6VR2AyfWPQHG1IwReI25VUlwWUB0fD/XlSQS7UmLhTzS?=
 =?us-ascii?Q?CpocQeysA6cn9fQ3KnJgrHHMNfu05EdxRI5uspOOkLzkoGwG+zbaW6dnCprQ?=
 =?us-ascii?Q?zhtdjOxicIQo3u08QnXHgfK4FtteF7vD6uY/134c5Isq0RQjs1p8IWfwOkzb?=
 =?us-ascii?Q?KHfQzaoRw4d2717zXYDIXKGQKEXjIqHXUactvrAF3zDihyoGtU/rTabSPd0u?=
 =?us-ascii?Q?FOfolXZTVK5RhRB/mRDGupqy4OVXBcs5ORftOwgvQtryPxlHhv0ObnWhfqqp?=
 =?us-ascii?Q?lLkWHcKojrI1S/nXe0JeBLi2dY0GIMSDO4VrDdGv2dvmIez0BABxccrhHV/s?=
 =?us-ascii?Q?okbm4MbTvC7SYOK62PjF1eXbM4wyLkCSL/M8gQVdbbAWOhY0Kg2IMvKCQS+u?=
 =?us-ascii?Q?iWVwYG6KDacrRZr+WYvtH/xi2/34AthRw1JySsBp10dtlSA+dGsdn4eAdaho?=
 =?us-ascii?Q?pvsO3C4G3JssSpMqnFJA85mxN1JMtBQ0LHOGbZnb/mW0oWgJxBV8jnRxEdRk?=
 =?us-ascii?Q?Cq4GSjmVn02mRjoGUxP27/5Tq2oEeSxw60W0KRw4Cn0Nof7sxnEI3Q7BEGlQ?=
 =?us-ascii?Q?K93qhsvlBD7Wshu/CUbcXChAn50pMgUL4FCCstEsMSa1IX+ZQcVqF0wFBX7r?=
 =?us-ascii?Q?kWKTwCjdUWSlwiHNmCq/NdszcnjHdghWQ3C2OvAJlRjVFKEaAgrFnBwC6QhY?=
 =?us-ascii?Q?xHH5iWjIWGDEO1ESg6iIxPF+7HNrdSXkljQrI9YJV+1mMfSNEwZ/hZr7Vq39?=
 =?us-ascii?Q?l98CWPfqbgeadVxhhrNHN5rROpABD36qO9PZVR+uhmBL8KyFWhdj3RlhhUS3?=
 =?us-ascii?Q?rwRBvO4jWsqrVrlxgIjSKo6lOLGnoUQespTLXjOIGd4CjJe2EixDG55eRj9d?=
 =?us-ascii?Q?AJm/T3waMPZI2KvEdZ7L9VdhEmnl9SoX7id00FIH/tf0l8NgMqHil1d11LpD?=
 =?us-ascii?Q?q2yMh4r5pQeJ3eRUlVhuAOvsZI1ErBYXzmOxl+5cSUGrTbU7KIivsiBtoHf1?=
 =?us-ascii?Q?bysIPsjgGhuxycl37mbLum/j9C0jJP+k/swHBB+qEblNyMcdKVyDdJwz6Gck?=
 =?us-ascii?Q?SvstIlzjnP3KJ/keTshzT5nMoHYE+NhQ84tANwxYkbZ3eFjqrG7EGD+QDouA?=
 =?us-ascii?Q?cmZlaG6fdM6XbKLRU7XYZI4sjn3LAjt9K5xTKitxbjIj7ZnmwGO26k6cRdZU?=
 =?us-ascii?Q?SM+SJJ4Pmmyiy4wFewYInWLe21+gs+b/3v4drS9XzSAVoirkeEJ8piD324sA?=
 =?us-ascii?Q?BJbhfP5+37HRATAb6vPKGl8NG7IzhFCuv1Ygd9GzYlPZ/eT//KkYL5a88E8o?=
 =?us-ascii?Q?4cbCrGZRU70EsZGjBENSNeNC0yq49BW5w1Ml7aIWAC6H73UPe5ZLMTYfZVS0?=
 =?us-ascii?Q?d7vZXw8ckzgH+j7U+hPOzDJnv5tQoB8LBVQIvE6D/ixPOWrI9JtxnkxGBRY+?=
 =?us-ascii?Q?DLfYqpvZd5SlihBRIZi0b9gKht8q73gz7sUjGafYD7mlWGmIamUHzDAdTkSh?=
 =?us-ascii?Q?la+pDb+uwu02BU45izip5glnbua/6O3BL8voRUHLtGwvWL9K71WYQjlCjvIS?=
 =?us-ascii?Q?PgRh3fAcMQKneZQ2law=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e4e0405-7df8-4d98-055f-08dcbd3c8d29
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:34.4977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I7X6qejelVoqfoseLkmQuK1oXVBfGoK8hA/OonVnJvvblp49TVse+P18MA3cR990
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146

IOMMU HW now supports updating a dirty bit in an entry when a DMA writes
to the entry's VA range. iommufd has a uAPI to read and clear the dirty
bits from the tables.

This is a trivial recrusive descent algorithm unwound into a function call
waterfall. The format needs a function to tell if a contiguous entry is
dirty, and a function to clear a contiguous entry back to clean.

FIXME: needs kunit testing

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 63 +++++++++++++++++++++++++++++
 include/linux/generic_pt/iommu.h    | 22 ++++++++++
 2 files changed, 85 insertions(+)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 4fccdcd58d4ba6..79b0ecbdc1adf6 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -130,6 +130,64 @@ static phys_addr_t NS(iova_to_phys)(struct pt_iommu *iommu_table,
 	return res;
 }
 
+struct pt_iommu_dirty_args {
+	struct iommu_dirty_bitmap *dirty;
+	unsigned int flags;
+};
+
+/* FIXME this is a bit big on formats with contig.. */
+static __always_inline int
+__do_read_and_clear_dirty(struct pt_range *range, void *arg, unsigned int level,
+			  struct pt_table_p *table, pt_level_fn_t descend_fn)
+{
+	struct pt_state pts = pt_init(range, level, table);
+	struct pt_iommu_dirty_args *dirty = arg;
+
+	for_each_pt_level_item(&pts) {
+		if (pts.type == PT_ENTRY_TABLE)
+			return pt_descend(&pts, arg, descend_fn);
+		if (pts.type == PT_ENTRY_EMPTY)
+			continue;
+
+		if (!pt_entry_write_is_dirty(&pts))
+			continue;
+
+		/* FIXME we should probably do our own gathering? */
+		iommu_dirty_bitmap_record(dirty->dirty, range->va,
+					  log2_to_int(pt_entry_oa_lg2sz(&pts)));
+		if (!(dirty->flags & IOMMU_DIRTY_NO_CLEAR)) {
+			/*
+			 * No write log required because DMA incoherence and
+			 * atomic dirty tracking bits can't work together
+			 */
+			pt_entry_set_write_clean(&pts);
+		}
+		break;
+	}
+	return 0;
+}
+PT_MAKE_LEVELS(__read_and_clear_dirty, __do_read_and_clear_dirty);
+
+static int __maybe_unused NS(read_and_clear_dirty)(
+	struct pt_iommu *iommu_table, dma_addr_t iova, dma_addr_t len,
+	unsigned long flags, struct iommu_dirty_bitmap *dirty_bitmap)
+{
+	struct pt_iommu_dirty_args dirty = {
+		.dirty = dirty_bitmap,
+		.flags = flags,
+	};
+	struct pt_range range;
+	int ret;
+
+	ret = make_range(common_from_iommu(iommu_table), &range, iova, len);
+	if (ret)
+		return ret;
+
+	ret = pt_walk_range(&range, __read_and_clear_dirty, &dirty);
+	PT_WARN_ON(ret);
+	return ret;
+}
+
 struct pt_iommu_collect_args {
 	struct pt_radix_list_head free_list;
 	u8 ignore_mapped : 1;
@@ -887,6 +945,9 @@ static const struct pt_iommu_ops NS(ops) = {
 	.unmap_pages = NS(unmap_pages),
 	.iova_to_phys = NS(iova_to_phys),
 	.cut_mapping = NS(cut_mapping),
+#if IS_ENABLED(CONFIG_IOMMUFD_DRIVER) && defined(pt_entry_write_is_dirty)
+	.read_and_clear_dirty = NS(read_and_clear_dirty),
+#endif
 	.get_info = NS(get_info),
 	.deinit = NS(deinit),
 };
@@ -963,5 +1024,7 @@ EXPORT_SYMBOL_NS_GPL(pt_iommu_init, GENERIC_PT_IOMMU);
 
 MODULE_LICENSE("GPL");
 MODULE_IMPORT_NS(GENERIC_PT);
+/* For iommu_dirty_bitmap_record() */
+MODULE_IMPORT_NS(IOMMUFD);
 
 #endif
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index d83f293209fa77..f77f6aef3f5958 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -10,6 +10,7 @@
 
 struct iommu_iotlb_gather;
 struct pt_iommu_ops;
+struct iommu_dirty_bitmap;
 
 /**
  * DOC: IOMMU Radix Page Table
@@ -158,6 +159,27 @@ struct pt_iommu_ops {
 	phys_addr_t (*iova_to_phys)(struct pt_iommu *iommu_table,
 				    dma_addr_t iova);
 
+	/**
+	 * read_and_clear_dirty() - Manipulate the HW set write dirty state
+	 * @iommu_table: Table to manipulate
+	 * @iova: IO virtual address to start
+	 * @size: Length of the IOVA
+	 * @flags: A bitmap of IOMMU_DIRTY_NO_CLEAR
+	 *
+	 * Iterate over all the entries in the mapped range and record their
+	 * write dirty status in iommu_dirty_bitmap. If IOMMU_DIRTY_NO_CLEAR is
+	 * not specified then the entries will be left dirty, otherwise they are
+	 * returned to being not write dirty.
+	 *
+	 * Context: The caller must hold a read range lock that includes @iova.
+	 *
+	 * Returns: -ERRNO on failure, 0 on success.
+	 */
+	int (*read_and_clear_dirty)(struct pt_iommu *iommu_table,
+				    dma_addr_t iova, dma_addr_t len,
+				    unsigned long flags,
+				    struct iommu_dirty_bitmap *dirty_bitmap);
+
 	/**
 	 * get_info() - Return the pt_iommu_info structure
 	 * @iommu_table: Table to query
-- 
2.46.0


