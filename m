Return-Path: <kvm+bounces-24272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F44D9536B7
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:12:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A34C81F2287F
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76A691AC43B;
	Thu, 15 Aug 2024 15:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YnuUYWUD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F951A7076
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734706; cv=fail; b=LfUD1MRxfhSSxJqeGsn2qmSdCqn82gJUbwkRo0GqV+6/hn5IlDkMV9HuCHCXrV1LLp32hGsIIp7p545LObQzFqD8C2lxKycDfI5clw36nqXKbp0xHUIZolLtwNYgJXy/hNK4JvF8KA59KpNkbWf/y7FZ2jcA6l9ZgVXajcBGnHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734706; c=relaxed/simple;
	bh=7KNGKp/GaxE9Y6hTQ5T0KZZgOn7HXT0kRIqjAlt03xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DgkhKGsRHwA980tc9vByLdyb0mmwRibUBZkCyF47zkkc+LITA9eiWyY8g61RyDR50eAgNYgPZX0MP5x8U5lkjjPfCibiR7s8NfAQJyhQiXDlifnRTwqCpFdyLccJCCUXFbGm5qKA/KGHzhOMzk4XdV1BZh5TCNDJ85HpsfPecZo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YnuUYWUD; arc=fail smtp.client-ip=40.107.92.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kJKHuRXzk+Tcy0vBAUCL1X0jojrh7/++AooYuMcDBLRGDIf0/lE7v0bQGt8HwgQDMM91wYbxDTJKs6bmzk2pD7w8l0AHYX+I8o22TH7IleVuHV4Wrtw2mUFWnV8EKWznRChe875X9c+dR2Ket5ravAaOOyuj7biWoGJPT8Y8ToFeQ5y229aO7xBMr+Acwr0W1q2ubCRRxOi8QZOFtEer3YVkqS8C+/HXgvNI1NORgP2rXwnBJ3I3PPpM8pirTE84BgB5MHuHOBux+JeMo2YsCx/bRKnCLXIzVlIBn2e4bHHFjUoM0RUWmNzRveBa0RAnchLzK5eMwCTwSvRPuyE7Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ih2iiSzTZXbZw5C0UvsFEnc7n2vkMt87bzhOXl2eUhg=;
 b=n3jZ/8/ymiZqrHdsDUsplrYryHWVpIMeq2zgveW45l4XfZqaL9GZxd8HCtoo3A69Q2lQ0yuN5tmwOoInrwCMoB/WvnnYSzwkOGlAKuR1qbFDx4WaRUiZLCR7kEUdzakEk7Nr806Qq6cHhXwvg6ol4uOsYLFNNiSLCk2LJmiKEkdKuCZ5L3Yj9xQ3rAkti44Gx7RaXZ5GLgezhDthoRnjvSeCnuZi9Sf3CT1ky1kbjm5FLBj9jp0Fb91oOVF1gp6hu4S5rq1ZWxrmL8IsDujT+2gQ8uM2HU7FBWvdX26fsKZKo/4Kx1aAI67qRKRiK5liWQiC6Ay7xMiY4SXDtcoxdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ih2iiSzTZXbZw5C0UvsFEnc7n2vkMt87bzhOXl2eUhg=;
 b=YnuUYWUD9wjjuuDSf2HDzaYTUPdZrNVYdDb8BWvC7d9exXY+fFq5xbDCEKLUXLt1IO/OV+gQ8GfBVH9idlUpU+uC8si76AKWmyniOeQDE2QjF+PKIfHvwes0FFoHaahAlBCi7mRA7tQV+PYgHuWxGYQd3urFatLMlwtfS/I3T0nPW0Wl/7GLknJ8RBGhqHkWoG3H+ZC/ajkGVql1mkjVlxM2lU8iDJFmPZSbVGL+uR20WYcJCsqa7xxRQuXs3ka6/mOQCkaa4CLGffeMOYQmXeJmzSTVHyDitipWrum7jAkLc8fq2BfcMf8oFRn9DBJ49rC5QShKkbHX99AZW4jA1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB8146.namprd12.prod.outlook.com (2603:10b6:806:323::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Thu, 15 Aug
 2024 15:11:34 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 15:11:34 +0000
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
Subject: [PATCH 04/16] iommupt: Add iova_to_phys op
Date: Thu, 15 Aug 2024 12:11:20 -0300
Message-ID: <4-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:208:335::13) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: 24ec37ee-8034-4c88-5ab5-08dcbd3c8d25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Un7aPPwuGhvbOkb+rfT/uc+jo7mEwZyuUIEzbkIQQcFQ6moqOgtWZ93/IhCS?=
 =?us-ascii?Q?kV7YzFZZndkZ0304C86pGPYtQcTEWSWdJ9zOUGdyuGwiAL8D7gTMeyPzibAA?=
 =?us-ascii?Q?FlzEWTQN9NKwr8yRtU6tD+itRTBYUMwSEbuamuyvhSR/LnEf8hE+gZpqUIAp?=
 =?us-ascii?Q?tKv8m/fxVfA8g6n/ifOjN6URy0u8P1bangx6JhxLvQM85WREw7ZjOW+twQDm?=
 =?us-ascii?Q?iqLzvVwcE+WndC47KxsKevXsR0Uh0pOwe5okIDL/wWdkZ7Hkd8EPLDJ/y5oC?=
 =?us-ascii?Q?swfaDfvNMd1pnLaL2stO2E3U9nVXIfgJnBqYr3IoMA195uixXcUbgXtrgn9H?=
 =?us-ascii?Q?Mi7iDr2Fx+1n17eLN/n5GFWtoz0lWh7RgGdpJNrCOQFOg3R4974kkHrhwuYn?=
 =?us-ascii?Q?gEwg8/i1vAiqcpYgDKuFZOTtutL8TDdJIM7sArl1RNc02/D0QZECOSiLt75m?=
 =?us-ascii?Q?wD6dOnc0kM0X1/jHVy2D+NKQOYwpr1A1G1DeYEdOBI9tVqe9sodn4J4wy4OR?=
 =?us-ascii?Q?fLsP/+UhlJzgTPw18/Yh52u0hFbuBM3DnjS5XAn80CGzxKPjlz0e0fw5pL3F?=
 =?us-ascii?Q?LGy7jag5xLEZpFK96ic9loCHOXxJQKziOTESPND/GWNEbr5biKpmB6pZiB1W?=
 =?us-ascii?Q?9Vkt1FsFEbNQwv90BlbpgIzdsrqgbr476nbtbgu6rXwyfy3Ox59Ge9vPkMJn?=
 =?us-ascii?Q?sjYLPNmiEHGMVeWI2jMrsuBNOV3daO7RhOlBQoYs+YpImDLZci5gEC8q19CP?=
 =?us-ascii?Q?JFVNbSBP09RvJLx5rTzR0/PGQf1dCw/qoorEM6Jd3kqrolbI0jaV8t/CcdBA?=
 =?us-ascii?Q?xJhJ2gjnZkb2d/hNeAiGZcUqutVjH02cL+i53lYBxIar8Zd5k1vcwT6DIMtV?=
 =?us-ascii?Q?HVD1lhUpHHXVtHdpJPEoSZosG2zHJKB1nP0vfuT9HxXjcaaRhowB8FCwI3gO?=
 =?us-ascii?Q?nsB6iHZ/kb9V8ynAWxJADoTvXYeAIy+TPPggBZUZzWZyy2OHBrlj+28F7d+o?=
 =?us-ascii?Q?ESzBvPiXxwE6ZkrxHVuoEGJW+SceXZKBB8j19DGn78KMfn3oKZfG2EfjNcqh?=
 =?us-ascii?Q?hyUILgcRzYmXNFSKnLXIHzqiNd26kO7D2oD+e4ivDvZqCGabLbmfQuF2rveC?=
 =?us-ascii?Q?d7B0r/+mESG0Tb/LATWfB1UPW9XaSN/rq52SRu8PbsiPP3RbNIFIyDYa2cwO?=
 =?us-ascii?Q?Yy7MtsGdc4D/d9iOwooetbwg4qla3z/uq421rmeu5tFeDMTHgb41+V3sHYkb?=
 =?us-ascii?Q?9gW5epyyE32JXGiJOQX7Ekl4ID7QrE87frx+s/Jdd+HVg7XEgTtdqBVZ+YU+?=
 =?us-ascii?Q?fArPBQp9eE+vOM/Y5ebbtzXrBcC6e6+LjsOyVYEpxnrU8w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zHaaUriN71aEAQVsBSX/P7JY/DlE580xWLToJ7c4T9EBvScwFimH5tp1pIou?=
 =?us-ascii?Q?U4BXHcSZ1/9QI+/HO8Csfm5OphIm5PlE4AnAEfcPfnDhXL+ftU1NnJIJup87?=
 =?us-ascii?Q?Ug7REFnglNXXg8YQNFNINe5kwwad7wlyHen3vLWK+NflCFjvKCACcV13VxxZ?=
 =?us-ascii?Q?UQkhGkCWaoTYaGoKYg63QrzhUa9WNLvea0FL8CFApl9DIOelxayZCbHmZvOZ?=
 =?us-ascii?Q?ttqCW8BdR/NMuimZBOn4ijiF5myutH0OWNUNG/NsdnjVRim1JcWTzT/0vfUQ?=
 =?us-ascii?Q?VCXKLZzxXzJrlt5goFP7bapDEBPFHNEwF6VJcfMYDMoXNvG+JTbE+YU4WEgJ?=
 =?us-ascii?Q?+Zw0wqmItJsq3oyO+sHX/AUBuL9LVR22jTD4fuD8rzG9O50YsncpMGWSiD+S?=
 =?us-ascii?Q?716i54T0bac81P4v7yUqkbZxn5b7r6ajQBgd/C3jwfmsthdlq93uhDZApetA?=
 =?us-ascii?Q?mBFQ/HZIShR6HuGjT4NjMPRqoug+lhZbzFDp+3WKTFsQYE8w1ebJcasF7hXD?=
 =?us-ascii?Q?30O7L5znv9db/HCxHWfI7mUV+ZBq+bstKcjQ/FP5oZ49gO5oFmuJOgBL8Rxf?=
 =?us-ascii?Q?n0dOhIMVxHa2rE4/ECgSokqQ2oryrHC0xbrlPXPU5bgyMWYI5c/Nh+LxvuxZ?=
 =?us-ascii?Q?46C+KLLErT9VE+c12ypEFo2CMkbx/GoW3LUdl1bNe33lz6qp37qYs7Iisyrl?=
 =?us-ascii?Q?mNbEaJtxXhYbfl04PT94UZtnY3YdQIRJ+/iMf/iuoLASZq14fwzz0ON+Zy/X?=
 =?us-ascii?Q?mmmfxPZ4x6L1IAghGaU1LO27UIwAL8Ucm4GNT8apENIE4fV9Z+iHU+pL/rr9?=
 =?us-ascii?Q?ER+WwpZZPh2bSw9oyFA/Zd8eyxZ2iGgk1R6q3J9npVZr+vN+TTBTBYni4QZ1?=
 =?us-ascii?Q?E58a+9OJ2/qUAh15R01QmQNYzuYYpfgCAwLIh9E92sjfHAAAe5JDBPM3pTBt?=
 =?us-ascii?Q?3x/X5W2MMRrP5GGcz3s+qPhCJ4us5KWvwbTnReK45UjFJM8jIzi0EWyQ+aK+?=
 =?us-ascii?Q?Fq1XO7/LRuaAz8CPpj+h791O90rmQMBSgCDDRzqQshOkytVM/7fskBGpadTg?=
 =?us-ascii?Q?/iE3GTxTJmuNt/IVB/DVYRLX/RnhWvdUs5xqCBPOBUpyL5pTmdAhz9vUapzr?=
 =?us-ascii?Q?54REQr7Dw7kHZd8KTSKtpYRPszSBEqrjyMoNKPZZKaazekC+UoOM7NQue5V2?=
 =?us-ascii?Q?yJWJoVA5wrsvsCebC+WS21iCgPkK/cnDOhDDWOsJHt+yYiIktRWq6iVxzqiY?=
 =?us-ascii?Q?x0J6JWul/x/A8a8FZOO28SQAHIVsFDbSQVLLDBZQwrugdDzhVPANaWl/hlcJ?=
 =?us-ascii?Q?dCGoKlqLsWnVlusNAImmBYdeAbdd8eS6wQ1MgEsoyOkb6HOtvBYJ8s01WWA8?=
 =?us-ascii?Q?/+Cd4rox8CooLG8NkFz3JDCulqu9OsGjhDry+BaGuz7kHK1MmtNoQ1urtNQ6?=
 =?us-ascii?Q?N1bKQinygQELrQHk91UQe2jD4x9mk5Cg/8jNf9BxSMhCzmeCmfoKv2zm9vWe?=
 =?us-ascii?Q?+1WCSMd2RQG8i+Bekip1B8m4jRL2ld0VD0wuQk4/C1oNePT5ghWcRDiIMfPE?=
 =?us-ascii?Q?Xfnd6Yq/kPKeCKltnzE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24ec37ee-8034-4c88-5ab5-08dcbd3c8d25
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:34.4851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vTnM+g2enx9VxjQBLA39q/LZBtRau75PYHiwyKcrGHMX4YeHNIMFQ1tFY8hDuVQ1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146

iova_to_phys is a performance path for the DMA API and iommufd, implement
it using an unrolled get_user_pages() like function waterfall scheme.

The implementation itself is fairly trivial.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 58 +++++++++++++++++++++++++++++
 include/linux/generic_pt/iommu.h    | 16 ++++++++
 2 files changed, 74 insertions(+)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 708beaf5d812f7..835c84ea716093 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -15,6 +15,64 @@
 #include <linux/iommu.h>
 #include <linux/export.h>
 
+static int make_range(struct pt_common *common, struct pt_range *range,
+		      dma_addr_t iova, dma_addr_t len)
+{
+	dma_addr_t last;
+
+	if (unlikely(len == 0))
+		return -EINVAL;
+
+	if (check_add_overflow(iova, len - 1, &last))
+		return -EOVERFLOW;
+
+	*range = pt_make_range(common, iova, last);
+	if (sizeof(iova) > sizeof(range->va)) {
+		if (unlikely(range->va != iova || range->last_va != last))
+			return -EOVERFLOW;
+	}
+	return pt_check_range(range);
+}
+
+static __always_inline int __do_iova_to_phys(struct pt_range *range, void *arg,
+					     unsigned int level,
+					     struct pt_table_p *table,
+					     pt_level_fn_t descend_fn)
+{
+	struct pt_state pts = pt_init(range, level, table);
+	pt_oaddr_t *res = arg;
+
+	switch (pt_load_single_entry(&pts)) {
+	case PT_ENTRY_EMPTY:
+		return -ENOENT;
+	case PT_ENTRY_TABLE:
+		return pt_descend(&pts, arg, descend_fn);
+	case PT_ENTRY_OA:
+		*res = pt_entry_oa_full(&pts);
+		return 0;
+	}
+	return -ENOENT;
+}
+PT_MAKE_LEVELS(__iova_to_phys, __do_iova_to_phys);
+
+static phys_addr_t NS(iova_to_phys)(struct pt_iommu *iommu_table,
+				    dma_addr_t iova)
+{
+	struct pt_range range;
+	pt_oaddr_t res;
+	int ret;
+
+	ret = make_range(common_from_iommu(iommu_table), &range, iova, 1);
+	if (ret)
+		return ret;
+
+	ret = pt_walk_range(&range, __iova_to_phys, &res);
+	/* PHYS_ADDR_MAX would be a better error code */
+	if (ret)
+		return 0;
+	return res;
+}
+
 struct pt_iommu_collect_args {
 	struct pt_radix_list_head free_list;
 	u8 ignore_mapped : 1;
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index d9d3da49dc0fe2..5cd56eac14b41d 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -60,6 +60,22 @@ struct pt_iommu_info {
 
 /* See the function comments in iommu_pt.c for kdocs */
 struct pt_iommu_ops {
+	/**
+	 * iova_to_phys() - Return the output address for the given IOVA
+	 * @iommu_table: Table to query
+	 * @iova: IO virtual address to query
+	 *
+	 * Determine the output address from the given IOVA. @iova may have any
+	 * alignment, the returned physical will be adjusted with any sub page
+	 * offset.
+	 *
+	 * Context: The caller must hold a read range lock that includes @iova.
+	 *
+	 * Return: 0 if there is no translation for the given iova.
+	 */
+	phys_addr_t (*iova_to_phys)(struct pt_iommu *iommu_table,
+				    dma_addr_t iova);
+
 	/**
 	 * get_info() - Return the pt_iommu_info structure
 	 * @iommu_table: Table to query
-- 
2.46.0


