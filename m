Return-Path: <kvm+bounces-24273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67C9A9536B8
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:12:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B6F41C254A9
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDBBF1AD3F5;
	Thu, 15 Aug 2024 15:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lfnh7nbv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF381A76C1
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734706; cv=fail; b=keDlrUHdetpxmQfe6ZmyIv/N6niiAJ+ZfwSK7iOzFDCDpNVqKGBv161pZhLq/lSFDjzziKI982QAybx24JOzDZu7NHU+jmue6AZs3geYJ7g0rw8CCc5i9ov/1ZC2K20gZynVFbSTCColzFFWnDkYoYi8O8cH9ujDdx/bEQ2Xmes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734706; c=relaxed/simple;
	bh=oltgfHj9xgYo8yABidDClvE1piQ2hALUW8LC5JoluPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iEygaaSN/COSfWXLxIZO3YadyJEBXk7wr/kwNxaxfUo3fHeZleXW0E66aSsk+Kn1xUrxICdG2CHFkYsIWgqDaSyph5M8Z6NQzSZkuCP6KlFPNQRU/CpZZNbnuU+jAUMb8hrOI1k9bMByLg5Coln95NfgRR913wjnru6OTvzEst8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lfnh7nbv; arc=fail smtp.client-ip=40.107.92.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XK+PUYIpQA0hR7cKxsEWkRAzQOvFCJ2HiiYQ8dUrJ/rbCnqnQzIYPNQNa/ZCI7yUeDdNv0/gZnEeVWt7bSKd04j4gEVSbfldHh7q54WRZWkZLuvfv9xxpKcfp87olcKoNcC7dV+A4hL7BZNlQxtOSdLtbUcmS6Me4Zod70MSN4YXoHAuVXT+xBcXtKKRJ9EvmDarvkT6qS+3gBrHedA8nL7MD2dTGHtkVtqzFhPzqtKdPfuRjJKoIyFXRcV3ecKxPPem2yNy37DTXeu1pd3UB6H6YSwTGvsLKWTOqCBX4W4rlOKNce2n1wwrfZ18NqSMDSQj52xdFoihd78rrMaJvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pqIJ5+fLddzVg4CGWYrqo+HDxROaojy29XidMrKBPsk=;
 b=eNHbvct3Ext7cTGPAwp01grIl5ZcalWz/2GaRgvV/JlZCNexkI7p6xv9XF+V9/UddlM8a8B3Xs7NxLGpnJBoLvY4U0a/DbGPt/s6nWh2fXV1N4mVpCTiPF80kp4QXyeI2pUditl2FGi9pP4vulovLJP2tfD5qAcQdlIzoeNEEWMft7UuvrFsL0OBKo68l/T1bNEhCN9UrrFUDWYaZk5rIjUjLcj9xXNkD5uPzpgnxnMAcBn6EZj5kxmDxjzUMBgVBzIrKGToP3zZxntfkJoqHCwoX67hBggNcle0d9lcZFFVe41aYZ9hbMTYjfihLQAM///c6H5BuDgTPK0gsBn7lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqIJ5+fLddzVg4CGWYrqo+HDxROaojy29XidMrKBPsk=;
 b=lfnh7nbvZveojA+w98i8Zby6N3Bkpq9ByAnSoQCwDcxfeTRQDxZDsQsGNh3Kp4wGu8jOsrd5/EvyTKQmEeMUPx+Ex+USBf9odjxmliTBcn0rTHmWqvNhpM8pyQZlc/olvORmvn6WUtxUer/C1GRHOSKdb90o2qPWwH6ce9oGobIIVk6ZvbS1BNFxds51bN+dBRW2ocq72hFWnWl6qnQ21XyDZjqdktSftfAlxGjcEK6hQ6UthfloTjNm9g5lLCFsfFGB7OwGAfVYDOWuwPS2XMgnlX41c3/867DFWFUCmshuKbRngEEHv3xU2QKBNUGD/SGGTNTj/0jeTPLuLoEUlg==
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
Subject: [PATCH 05/16] iommupt: Add unmap_pages op
Date: Thu, 15 Aug 2024 12:11:21 -0300
Message-ID: <5-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0049.namprd20.prod.outlook.com
 (2603:10b6:208:235::18) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d69deff-d8be-4258-2a07-08dcbd3c8d29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3R4stLRy0bdo6vwkKvfHENmEVgJ2spyWsshcZCeuniioktuk5D0DF85O/eZP?=
 =?us-ascii?Q?1NgJl8sBBu8zEFUR4wLPMmYHS/3AzWns/RCxTr4kBMiTCENYxAn1hACKoKvK?=
 =?us-ascii?Q?NYPkAc1DpeIjdgq6TXkMYafBYjaVHvDtKCNKfMjxDCkuxkGgHKP1SYU+Ld25?=
 =?us-ascii?Q?pf8MhJXkJxYOmA8nJWPvWaDdZEc8hbrUyd7g4nRbl15voCMaeFAuwd4/BoyL?=
 =?us-ascii?Q?ZsQtaFDAA6ipQGnn5kzDGCZ658Ia5C6DVjcStmaBeQYlEc0ItBkdvFIY1pUV?=
 =?us-ascii?Q?KUz/pcnyPyZLYhB51Q0QGp6flF17+8IzYnesozJWmfhaBgixO+99uU3OlmqG?=
 =?us-ascii?Q?MT3gkBOubfw8u0m5wF23GpQz6aTyXLuA11i6tIKDcyTBi8aTF0Mvkg/ZHZjP?=
 =?us-ascii?Q?nNXfy6jtXeL/cFoMzkCWgUADZf7BuXJb3Q4I2D/htFFK5na21fJ99FHf8efe?=
 =?us-ascii?Q?4t6ndE5DQrcPk3Fkm0FNVo+oDQpKKSzbaSydlTyjAhP5RQ1N2e3SKk2/Q7Jh?=
 =?us-ascii?Q?9LyASAUwcbsHYDoyU1nEbVOoJHHvKvEQZbqSBNJ9o5WXhhwzTBbgf8Mo/DSG?=
 =?us-ascii?Q?fho12UxPBx+Qzh1LJWD8LNDm/o7jBKlI/NMoEtYXUmnSTpy9NSTWzdhgrnBy?=
 =?us-ascii?Q?we+VAXhL4mVftCnPNX4M4Jki1C2b9aBxjfv97KJIkbqLrvb0rCdwBIWOM6SV?=
 =?us-ascii?Q?TfFGsQUEaOLHBYfiVuhaPkRyFZS1L2PwRC2mjMp1GHgnOJOoVA6aJsI3h6FR?=
 =?us-ascii?Q?azrT/po7FiW9KthC4ipPFbd186kGMTuJGIDsg9aVRar2RZlHv6XWAyrTakId?=
 =?us-ascii?Q?aDLyAYdCHDmT7PGG7pjnB/8QlBKDCxeENnM6N18VTF7anNUSa1r3ZZIMB/mW?=
 =?us-ascii?Q?VTyGZbzT4UoB5JpoL75d3iz+Sup/tsFRk3yTKObayJErUZAViBqHF3pTBTxa?=
 =?us-ascii?Q?Td5KPtdQUwIfOK7U8etmohqQl6bIeDEHipkinXdW/m94VFyjYWWeebAzZg3d?=
 =?us-ascii?Q?Ym+v8rvZY+DJfCFRp2s15BNiwEjqJZlY2pgZZJjGlixdC4jgkUK3PwK5npBI?=
 =?us-ascii?Q?Wo9iC8CZ9QVtJRJzswa5f4V3jAFVbFKSCk7VE71NPexu0BsW+X6peX/lMrI1?=
 =?us-ascii?Q?V9Bv8wJFwn9bzdmg+5n2Ye2aentRo0QdpURznyUzois127CTd57j0idnvOmD?=
 =?us-ascii?Q?TagDC8uq/NnQA0OLktoGeNE27ZgJPBz2gIhBsYDadnFEUDUgHTfCfjXnHFlr?=
 =?us-ascii?Q?/GhFozwLFyqmUg/ImlQiCSXzvPJphp5aY2lI0HX4dN4AhJG4U/rp7YXR1l9W?=
 =?us-ascii?Q?rSgOIeuOsAh3vKuXxV04I+LAL7Gsj91TrrC08QuWQ2Uj1A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N4nSCERX4YPbhUjo4qkhlLT4pOJ32cgSbObx3rOr+PqQM0Aujd6bftlDX9ne?=
 =?us-ascii?Q?0wsGaW9rXRPglJkM/89gnG2t60MufuXAiOKFZ50J1iPWGMvvCmN1DXlnKNGh?=
 =?us-ascii?Q?khVXXUiIGEcsKcw1V1yrw0yddbjOoOqZf5qQ/b/M0eU5xRPw4x+6R9IJfzDR?=
 =?us-ascii?Q?HPRpyDyKFWF6orMnbyI0Cmc12qdz7jdf6JEBuTW8ar26sCgxO1Y2FhR1rSSF?=
 =?us-ascii?Q?EWZSG8NZRblhZSnkOV/yvur5RbRrW3TwSU+wDhfs90gTTF4v4svkCf6yyGYH?=
 =?us-ascii?Q?IYPHbFnXXEgJZCR7Rc3rRfTg12V0gWfTdpyN+brMAKdfB1LxbFwUTWSuUvEr?=
 =?us-ascii?Q?sAQIOwlrYPNjg+tZ+uOebRnhrQPBazMtfqyE5Gemlf0IOSmDpZF2bJ3xWU5L?=
 =?us-ascii?Q?mHMdn65rBalMEFO9Q5NVAPCUsnlXHv6pyVU/URgzWPjR3Lr3iGwFP/x3jnHH?=
 =?us-ascii?Q?Z2FK9WAhHZgUumS8+Ph86GfVsULi8BEQX0sA85rlX0uVBN4g9K8uPzidtvpn?=
 =?us-ascii?Q?rOtAHwcyZlf/c1zBSv4ECUF15x85WvA6rRbZsJdGie6k8IK75lakRsqVrJ/I?=
 =?us-ascii?Q?NwRQpuHo/LUTt7GxvPTEx0OB9b0omiM5TKCgVKFZ0Djd0aTYQ5dr3JTelY2C?=
 =?us-ascii?Q?MefE8Dpx2yDgHLg0QntFpe80NkPvq0+6TBwDB87tJrh1gqSDMXA3nJm25zFz?=
 =?us-ascii?Q?8pplfLuTh84hT4vlpgPneZWaBipDx0xhM4/+ndWvmu2VnDbUjyUxIb5lqgZb?=
 =?us-ascii?Q?7SEEnX2ZI6ZR5Fxpn/KFTMgANTSXBG9xDvn47garl9SrjiXKDUJmUhmNVBLq?=
 =?us-ascii?Q?DB4/ws4jKmG5xsu4Uk3typhmx6TApRxSOmvs3FZVvJLL09PDZ+U2ZgqZLXka?=
 =?us-ascii?Q?iShMuo9QLFeHFgUfUxHYqnH+3o7UuvOgA+WPspw2ADYAEqHXctM8lft/i3lE?=
 =?us-ascii?Q?I/MjOnLt7iy2A3+9Ow5l0Y13oG3Who1jGaSgSZs5DzhKbLXdCwiM/vny74wN?=
 =?us-ascii?Q?x4ul3nkJm3DQBxfEYY/XhHJqWOZuS8h14SwRRdS1deH+ru+AmBMQLfbvwHEU?=
 =?us-ascii?Q?9bOnO+10DWfQwhJIPN6JQmHo6kkNVGpfC9BCq7XuCsYcfYQsW8G0R2R0d8L8?=
 =?us-ascii?Q?IMy8UadOfSAfp+bsE3XFK5uW1rUyz/OvFbmtvaQsu1+po/OzdkQu4REkWba7?=
 =?us-ascii?Q?GdbkTcpgz7UjD3cqDrDmvIfLbZVBvxUeKPBAg4gHq3oTSF7IEm970lkNrGe3?=
 =?us-ascii?Q?2REW8QzFxq4e4Ox6nxuBmwXBa4pKKRJ7XLqCGHQclcAyhHAiZuyGJZnxp3Ua?=
 =?us-ascii?Q?OxSXhI4vcJiLhQ18ueXKqDN+pokG0Exrn2xMIgQtE2eMR71sHM/CYQmfjH5b?=
 =?us-ascii?Q?vHmmjucpCiiLQ5mNUndyOAo1dLkPjZIty40efH6EKRXyHv4WiOgUlGcHVDQg?=
 =?us-ascii?Q?YS0qEYYdG29aX6VihqINezsKmH5ZBjR2tnKy5wvi7GCjjvS+QR9vsYRGvCnB?=
 =?us-ascii?Q?BQyATKvvUriZXkFgUOnOfCF97h2DfzojnaIITd3JzBq4s0EtXo2cLmXGveMp?=
 =?us-ascii?Q?YdffruhVrYwF46y/o4o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d69deff-d8be-4258-2a07-08dcbd3c8d29
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:34.5865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p1lprTzD8GPAQkVY8Dx8d0cWK65+t5sgsFz6m077qn8HEtIH5DrBmZ3Qj55vwqIB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146

unmap_pages removes mappings and any fully contained interior tables from
the given range. This follows the strict iommu_domain API definition where
it does not split up larger page sizes into smaller. The caller must
perform unmap only on ranges created by map or it must have somehow
otherwise determined safe cut points (eg iommufd/vfio use iova_to_phys to
scan for them)

A following patch will provide 'cut' which explicitly does the page size
split if the HW can support it.

unmap is implemented with a recursive descent of the tree. It has an
additional cost of checking that the entire VA range is mapped. If the
caller provides a VA range that spans an entire table item then the table
can be freed as well.

Cache incoherent HW is handled by keep tracking of what table memory
ranges need CPU cache invalidation at each level and performing that
invalidation once when ascending from that level.

Currently, the only user I know of for partial unmap is VFIO type 1 v1.0.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 143 ++++++++++++++++++++++++++++
 include/linux/generic_pt/iommu.h    |  24 +++++
 2 files changed, 167 insertions(+)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 835c84ea716093..6d1c59b33d02f3 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -14,6 +14,63 @@
 
 #include <linux/iommu.h>
 #include <linux/export.h>
+#include <linux/cleanup.h>
+#include <linux/dma-mapping.h>
+
+/*
+ * Keep track of what table items are being written too during mutation
+ * operations. When the HW is DMA Incoherent these have to be cache flushed
+ * before they are visible. The write_log batches flushes together and uses a C
+ * cleanup to make sure the table memory is flushed before walking concludes
+ * with that table.
+ *
+ * There are two notable cases that need special flushing:
+ *  1) Installing a table entry requires the new table memory (and all of it's
+ *     children) are flushed.
+ *  2) Installing a shared table requires that other threads using the shared
+ *     table ensure it is flushed before they attempt to use it.
+ */
+struct iommu_write_log {
+	struct pt_range *range;
+	struct pt_table_p *table;
+	unsigned int start_idx;
+	unsigned int last_idx;
+};
+
+static void record_write(struct iommu_write_log *wlog,
+			 const struct pt_state *pts,
+			 unsigned int index_count_lg2)
+{
+	if (!(PT_SUPPORTED_FEATURES & BIT(PT_FEAT_DMA_INCOHERENT)))
+		return;
+
+	if (!wlog->table) {
+		wlog->table = pts->table;
+		wlog->start_idx = pts->index;
+	}
+	wlog->last_idx =
+		max(wlog->last_idx,
+		    log2_set_mod(pts->index + log2_to_int(index_count_lg2), 0,
+				 index_count_lg2));
+}
+
+static void done_writes(struct iommu_write_log *wlog)
+{
+	struct pt_iommu *iommu_table = iommu_from_common(wlog->range->common);
+	dma_addr_t dma;
+
+	if (!pt_feature(wlog->range->common, PT_FEAT_DMA_INCOHERENT) ||
+	    !wlog->table)
+		return;
+
+	dma = virt_to_phys(wlog->table);
+	dma_sync_single_for_device(iommu_table->iommu_device,
+				   dma + wlog->start_idx * PT_ENTRY_WORD_SIZE,
+				   (wlog->last_idx - wlog->start_idx + 1) *
+					   PT_ENTRY_WORD_SIZE,
+				   DMA_TO_DEVICE);
+	wlog->table = NULL;
+}
 
 static int make_range(struct pt_common *common, struct pt_range *range,
 		      dma_addr_t iova, dma_addr_t len)
@@ -102,6 +159,91 @@ static int __collect_tables(struct pt_range *range, void *arg,
 	return 0;
 }
 
+struct pt_unmap_args {
+	struct pt_radix_list_head free_list;
+	pt_vaddr_t unmapped;
+};
+
+static int __unmap_pages(struct pt_range *range, void *arg, unsigned int level,
+			 struct pt_table_p *table)
+{
+	struct iommu_write_log wlog __cleanup(done_writes) = { .range = range };
+	struct pt_state pts = pt_init(range, level, table);
+	struct pt_unmap_args *unmap = arg;
+	int ret;
+
+	for_each_pt_level_item(&pts) {
+		switch (pts.type) {
+		case PT_ENTRY_TABLE: {
+			/* descend will change va */
+			bool fully_covered = pt_entry_fully_covered(
+				&pts, pt_table_item_lg2sz(&pts));
+
+			ret = pt_descend(&pts, arg, __unmap_pages);
+			if (ret)
+				return ret;
+
+			/*
+			 * If the unmapping range fully covers the table then we
+			 * can free it as well. The clear is delayed until we
+			 * succeed in clearing the lower table levels.
+			 */
+			if (fully_covered) {
+				pt_radix_add_list(&unmap->free_list,
+						  pts.table_lower);
+				record_write(&wlog, &pts, ilog2(1));
+				pt_clear_entry(&pts, ilog2(1));
+			}
+			break;
+		}
+		case PT_ENTRY_EMPTY:
+			return -EFAULT;
+		case PT_ENTRY_OA:
+			/*
+			 * The IOMMU API does not require drivers to support
+			 * unmapping parts of pages. Only legacy VFIO type 1 v1
+			 * will attempt it after probing for "fine-grained
+			 * superpages" support. There it allows the v1 version
+			 * of VFIO (that nobody uses) to pass more than
+			 * PAGE_SIZE to map.
+			 */
+			if (!pt_entry_fully_covered(&pts,
+						    pt_entry_oa_lg2sz(&pts)))
+				return -EADDRINUSE;
+			unmap->unmapped += log2_to_int(pt_entry_oa_lg2sz(&pts));
+			record_write(&wlog, &pts,
+				     pt_entry_num_contig_lg2(&pts));
+			pt_clear_entry(&pts, pt_entry_num_contig_lg2(&pts));
+			break;
+		}
+	}
+	return 0;
+}
+
+static size_t NS(unmap_pages)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			      dma_addr_t len,
+			      struct iommu_iotlb_gather *iotlb_gather)
+{
+	struct pt_common *common = common_from_iommu(iommu_table);
+	struct pt_unmap_args unmap = {};
+	struct pt_range range;
+	int ret;
+
+	ret = make_range(common_from_iommu(iommu_table), &range, iova, len);
+	if (ret)
+		return ret;
+
+	pt_walk_range(&range, __unmap_pages, &unmap);
+
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT))
+		pt_radix_stop_incoherent_list(&unmap.free_list,
+					      iommu_table->iommu_device);
+
+	/* FIXME into gather */
+	pt_radix_free_list_rcu(&unmap.free_list);
+	return unmap.unmapped;
+}
+
 static void NS(get_info)(struct pt_iommu *iommu_table,
 			 struct pt_iommu_info *info)
 {
@@ -143,6 +285,7 @@ static void NS(deinit)(struct pt_iommu *iommu_table)
 }
 
 static const struct pt_iommu_ops NS(ops) = {
+	.unmap_pages = NS(unmap_pages),
 	.iova_to_phys = NS(iova_to_phys),
 	.get_info = NS(get_info),
 	.deinit = NS(deinit),
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 5cd56eac14b41d..bdb6bf2c2ebe85 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -8,6 +8,7 @@
 #include <linux/generic_pt/common.h>
 #include <linux/mm_types.h>
 
+struct iommu_iotlb_gather;
 struct pt_iommu_ops;
 
 /**
@@ -60,6 +61,29 @@ struct pt_iommu_info {
 
 /* See the function comments in iommu_pt.c for kdocs */
 struct pt_iommu_ops {
+	/**
+	 * unmap_pages() - Make a range of IOVA empty/not present
+	 * @iommu_table: Table to manipulate
+	 * @iova: IO virtual address to start
+	 * @len: Length of the range starting from @iova
+	 * @gather: Gather struct that must be flushed on return
+	 *
+	 * unmap_pages() will remove translation created by map_pages().
+	 * It cannot subdivide a mapping created by map_pages(),
+	 * so it should be called with IOVA ranges that match those passed
+	 * to map_pages. The IOVA range can aggregate contiguous map_pages() calls
+	 * so long as no individual range is split.
+	 *
+	 * Context: The caller must hold a write range lock that includes
+	 * the whole range.
+	 *
+	 * Returns: Number of bytes of VA unmapped. iova + res will be the
+	 * point unmapping stopped.
+	 */
+	size_t (*unmap_pages)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			      dma_addr_t len,
+			      struct iommu_iotlb_gather *iotlb_gather);
+
 	/**
 	 * iova_to_phys() - Return the output address for the given IOVA
 	 * @iommu_table: Table to query
-- 
2.46.0


