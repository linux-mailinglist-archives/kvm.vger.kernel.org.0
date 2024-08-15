Return-Path: <kvm+bounces-24284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62DA49536C3
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:13:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D43BF1F22D42
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:13:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D79C1B4C2D;
	Thu, 15 Aug 2024 15:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OUeZlj+Y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE521B32D6
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734716; cv=fail; b=uo9bR9N6eHCZM2V1WZkQBrYuNYTT23h3XpwrxK5UnYpTGKCLw6NYF6wUAmi3uKxyKtdxs9HRCRUWv9TOCdxT1hZGZnIJGoImEcOXMVe0nmTFwcXEF1Cp3GhISDRvfh/bPyZFtWVOstkN5ZwQLpe0U1Opax1/qzNCJcm3ACjwYN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734716; c=relaxed/simple;
	bh=iezv6Cb9leC6dEkHJDjcdJQ5cchfc40jP+jW8mUBytk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Nce1etjqyd78zXEf0BTnVyL01iRwAYXs64BphizWQLxSDEG+3u2wOAszVzSbQhwulCjCBdaXMU00xPNeDVNZFwdGrndEoQ7vgWeWgEmU+i9IyP0fWLVRUbuhBWhcPaQErcOyp4Octr4UI9pu/JeEuWqBrKA2/oFsO9bZyqP4iTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OUeZlj+Y; arc=fail smtp.client-ip=40.107.92.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NDyvsAXFE+UImNepmrP2uZukyuK8T7itDLChP1mRMkcrbQ43lwz6TA+CrRlOfnPXwpAvhQQqT6l53dMSPH2Tq8dtedacFYR796g0bxfMmkeud0OrkFjrkYjb9oxdheCxpk1xQWgqWD6lWsfrI+oRY8F39/P8F/92S/LxVU8zmxgzo3zmspXkFsZnVTxra0JQsmPntSOzrfC9+gt334tPV4RJyfbQiudIuZcUom4ityT+ZsR/avPLTkKRHJm7nqyXKeB+vgC1lj+IXIj0OIEZ6D1Kkxvr/+NDJD7IaXsuh0HLNv8TOoUY18JpKOdJanROUWQGjLW1xgxkZWmGQClUXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CseehZW1/tl+23sWMKn8i2i+3hNkbe8IlewYv7NWFro=;
 b=wVdEfnpVXAs2f/XURwAs32xU8DOdkpmf/AQ7wfL4aOkZ3tSECWgn6Tkf2bIryCVkUKGUKtFT9RZU+DtpWfvfeW1VVgEADjGviqsOtzlXDA91N5YI2HyVvFGh/RD+LRJ8vwjMuyo+I6MSXU94d3527amhNjweu/dEKJZe9kYUd+6BfxzGhGIeVqrnL5112hxzj1jdlPEmrKXeEYhWaTtAm1OidPWSY+SnrlwbVBm4jb8UsEuVqhf638SR7WzmNBVLUPOVKqFglqhQfvNQAsk1dl6uqxrCQ0lHau90o9ulJnkr1QbWTm/IF495nJ2/OjCw9PlpuIjLCDitDJs4qMVjvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CseehZW1/tl+23sWMKn8i2i+3hNkbe8IlewYv7NWFro=;
 b=OUeZlj+YG12xvlNOQivw+1b81M1wuRxcqkvkc96QPg3kEas8yvqOc/uWPR2GeY5Tj7QqzRBFV7CecbE7NLUvtDG8erE+CfJhuLhFSgWhexByURzAindzUKB64IbONj+4p2hVlQyOtyruT57Idgiw7ajG28Kf0yph1QW4e2KPxTzplVABcwXv27Hk15qF6nZQCUCPCtVhJNQHd9oUx+nQZLZEAm9S8QlooK6IS8Xr5ZQCVtNGlo2JNu47q/cIkv7Mz/7usp8M9CBnm7R5bcJcCanwZLxEbugJiCGOPihSHQhvZkT1M6xPBlh5YNjcu/jz/xxQ5dC4W62TLTy9XNLIdg==
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
Subject: [PATCH 03/16] iommupt: Add the basic structure of the iommu implementation
Date: Thu, 15 Aug 2024 12:11:19 -0300
Message-ID: <3-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00016416.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:4) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: 30051ef4-32fb-4d1a-e569-08dcbd3c8ea3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qXM0zrAo/03YIptDigjFnSwsxV//MoZCf3FiSjAHFUqxcpkjBBpkERLmf78b?=
 =?us-ascii?Q?XJrtGX2HW2N9G3jK0eseHnVjYLqsc6DkpGrFz9/etxrM1JV4lezvBChDcX6q?=
 =?us-ascii?Q?8uGW2i3lOlxxKYZBGqN6IW354vV0xf3b7/bkrFZtFpMdCsfnnmcokeSWRU0T?=
 =?us-ascii?Q?FDMLFwFoUE0+rKFhi9SbjkDH49vwiuB8d1eHnLZu9e3z+oGlX//BukB/v7IL?=
 =?us-ascii?Q?hDY7qIgWwZ2MX2AJHdREwran7+JPVrimSX2iXOidoz4xWkIss9SAz61q88Jp?=
 =?us-ascii?Q?eCpwCiChlzbsR9KCVeIIbyCbjxEyTqYGEPGybxW/qHWdKwhCkZwx3x0NP3VJ?=
 =?us-ascii?Q?nt8iGRXK6hr7fjjIZtn3wL5YH292rQlmiI7h5PmtmnOaKDzxpI270+ANwsEw?=
 =?us-ascii?Q?aHZj/clroxpzz1OQxytcvHwbVIp80BfEXu+7ZedQGt1+ofDZlYK5H4vHEL7m?=
 =?us-ascii?Q?nZw4ViqvSFGsHlAjtecf5a1tlBcoNrnUvEjcyzf0ez5k4xXWErvPQdnYR6AQ?=
 =?us-ascii?Q?xY8kG+p1PBARJuZ5WQWF6ASeJsUueKwF4YNcPbvfnl0MQpNxJtzPEAjMxGDr?=
 =?us-ascii?Q?pge0owT1Cojh+dpUFkqh/mBcJjtSLkKoAJ1v65sVt1O9H+UhEsodCNNWxaem?=
 =?us-ascii?Q?ZnC1gh3BT5FKYs1nXk3WD70aiuZSW+GKGhLAqdZDJh0qFDiBLl0gf32cbJLG?=
 =?us-ascii?Q?rtzVeTVdbp1VP835jhpdWr23dgR1949xI+I0NMQcS8nAPEF8fGToV8UaO4QP?=
 =?us-ascii?Q?mVeiepugjQaEH2A08BjmAvnttKQDj3jSy8Mytg/Weqhi4+X+LAX7H2prJVWU?=
 =?us-ascii?Q?okqzcZUKlLQTChir+fUvTOJlSi1QBxSFHmGQQoZ07zikjRBgf5CG1BdIbShZ?=
 =?us-ascii?Q?6b0WhimQ9vzCZ8LPVrXlzhWcw/pI6YYQgsg8ou4BwquGt7jwrWyyb8SiuhOE?=
 =?us-ascii?Q?wJ2QOSixkGOs82WjQRQoSVsT3fdRDS28QwUDAqPBBS8y5YLqLuHwBa+sBjUK?=
 =?us-ascii?Q?qUUjPGwsEwXEa5WnnaU9r0Q1f/dqO+DMPYEQN8hGbbgLKCayET0KvEiEqbNV?=
 =?us-ascii?Q?i5qSHcOFg1Cl7LqPGiXU9xk6jjtkOObbZfOJ0dLFg+nQR0qz/QrT0s8oSq+p?=
 =?us-ascii?Q?QY/e7P/RCRic2r1CLCg4dq8LtHw1LIVO9qg3dc003Sp3HNsC/lZQL5vZcTvB?=
 =?us-ascii?Q?VcfZwamqkzjaQxwVZlCohcVqutDo7RL4IBE15B7ScmCHeVXN9iLo0hLbn6vg?=
 =?us-ascii?Q?vbhNmitEKRsZH/oR38xloBUjznF6gMgqI1x5oz3ChyE8/GNWJvutr5izVsqs?=
 =?us-ascii?Q?B8ng3ZpCDMxjNRlGdydFp617AugGT0dd842sPbHL1uzTdg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8Cqrdyrva3gB/cdyHOmmvSrTNKLVV/3Lw/zM7EwP0lFgx+0/yyPMZ9xd1i7d?=
 =?us-ascii?Q?kaxxRVGG30ryloEJg7fbzI/g41GsMsYqbfqnVakDpZpQnJW+c7wDdJZqMld1?=
 =?us-ascii?Q?D1gySyHgSQQ4A4Y31GN6Ck/2Z7FSHE7tUrKdSX4QP8kVKVlGMsjAD6Qb3Ize?=
 =?us-ascii?Q?si17ZoFGgPpX8OgsITO2P/sHQdud0leT2CV+0w5BCjipnsHmBgrzL/ni0uT4?=
 =?us-ascii?Q?9E9uur+hVMPPeSpkBE0UlGBVdd3oPkNktflyox5JyGoXPcmL1lRvvqDvRMsh?=
 =?us-ascii?Q?aIUXMPDjnAf+AQogbLHH2fgj3Q3oIOJINyaoe/KFGPcOIJOWU2HHzIYHrfv1?=
 =?us-ascii?Q?I2STwjb6TMLunFePX1/IEtjUX+gB+1u5HhJmhU0qQK3lhVSn+calJ+hiX7/t?=
 =?us-ascii?Q?y4YTKi11MyFCFlG/h7ikj9YtsEa0q53mT08bXuTSArDclNJiX02E35jU+KtG?=
 =?us-ascii?Q?gTdjR2DLlaVfM22o/IA43L20oGwYB2HRp4aRmSMa4Nbg3SrY2bWHjQISHI5U?=
 =?us-ascii?Q?ZMZWxAAHVxuxkFtt5tvlm/lKmi+isYHkexGuuyn8oUhSg0ram3UNRikPUFbL?=
 =?us-ascii?Q?CABv8I51dl1NpphF6n4doTiYTeJehrTxjSjSutNjkwOuF70VXVSqSJ+PEO4+?=
 =?us-ascii?Q?IoPCOBMUAi7a94DkuaUANfbAI6C/xtyJf4vvfpEPzNYzBPnfHmqn7lW/iOpc?=
 =?us-ascii?Q?p4Zfnekj0I7oQStLNvZ9G7M4ciZTUuv6qTAKj5oJVJKINngPAjpSuEdaHtTH?=
 =?us-ascii?Q?6XfkC3pgHNQ/6vlp+crVRUPY9wd5G/5fPR6fJo6MqqPZTUgtKdR/rlleSRmT?=
 =?us-ascii?Q?4yeedztEeCdOLIldQ87k2LgY2B3KhFECP7tUXQfR4ESQFllJlM9cu8xcu8OM?=
 =?us-ascii?Q?cfglBltZ6tLNoXNvfUW/YkV8lhr4Z+vy1o5FpE2MdeYMRxINlG1Kwuodwspy?=
 =?us-ascii?Q?VnyLHcz7Zw86jkM+u51iU4xU6S1S3mLjlP+LF5QyeE5Wubr8AbaKwSbUNEZS?=
 =?us-ascii?Q?/akCHeGzYZgoEJv5W6vgdFN5HtSmt4gfKy8L5lIzCfQ+Vb5a0EdPYAlM7WM+?=
 =?us-ascii?Q?dIldidyINi8d93itpDYUYQAcgXtbT19vAUuExXaZHJDhA8g7oY6mNbUVzqyi?=
 =?us-ascii?Q?dmKY7kZWkKcK9RsaKqH2/pltMNUVpBM2CFgjwfSN/0/bzzmSN56FE0U3BPWk?=
 =?us-ascii?Q?fln+53yPRYMX+yYoqMgQxUfXu3EDaWNZIHeip9IlMl4YqPU9HtFpLbTcynt6?=
 =?us-ascii?Q?UAQCB/gpsAODO677SStEpOdWuYUJ1neOGFU4OSmaXmB9o51v+SYjGQczV32S?=
 =?us-ascii?Q?9LAMMN4IVWv73OWnl2X+kKKEkt8w4WptYM36GyvjnBN8eQg9+c9qC6PPD4ru?=
 =?us-ascii?Q?45w8+h65vY0wKe8UpwjplhV31PP/sF3OCbP278JsjM5LuHlo0k1xxiz/mmPM?=
 =?us-ascii?Q?ag7GSzN+LkXUJ7iy0eLSEJOm4laa5It6AIBcn0KVJ7YnFiirom7PbihBOAwf?=
 =?us-ascii?Q?8e8YXNQ85FKUPy0ELLxrJX91PshEWYJv3vA7Tr7U0NmZwnGcYdSbo0AaiPvz?=
 =?us-ascii?Q?E5UfbXqMK1x33eRafdc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30051ef4-32fb-4d1a-e569-08dcbd3c8ea3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:37.0548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: corMjB76D/Ts3sHjDqGOF8ddwwZujGF4zS5cAVLl7JwYZrNLAukH0iFydcT2OxIz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146

The iommu implementation is a single version of the iommu domain
operations, iova_to_phys, map, unmap, read_and_clear_dirty and
flushing. It is intended to be a near drop in replacement for existing
iopt users.

By using the Generic Page Table mechanism it is a single algorithmic
implementation that operates all the different page table formats with
consistent characteristics.

Implement the basic starting point: alloc(), get_info() and deinit().

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/iommu_template.h |  37 ++++
 drivers/iommu/generic_pt/iommu_pt.h           | 166 ++++++++++++++++++
 include/linux/generic_pt/iommu.h              |  87 +++++++++
 3 files changed, 290 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_template.h
 create mode 100644 drivers/iommu/generic_pt/iommu_pt.h
 create mode 100644 include/linux/generic_pt/iommu.h

diff --git a/drivers/iommu/generic_pt/fmt/iommu_template.h b/drivers/iommu/generic_pt/fmt/iommu_template.h
new file mode 100644
index 00000000000000..d6ca1582e11ca4
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_template.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Template to build the iommu module and kunit from the format and
+ * implementation headers.
+ *
+ * The format should have:
+ *  #define PT_FMT <name>
+ *  #define PT_SUPPORTED_FEATURES (BIT(PT_FEAT_xx) | BIT(PT_FEAT_yy))
+ * And optionally:
+ *  #define PT_FORCE_ENABLED_FEATURES ..
+ *  #define PT_FMT_VARIANT <suffix>
+ */
+#include <linux/args.h>
+#include <linux/stringify.h>
+
+#ifdef PT_FMT_VARIANT
+#define PTPFX \
+	CONCATENATE(CONCATENATE(PT_FMT, _), CONCATENATE(PT_FMT_VARIANT, _))
+#else
+#define PTPFX CONCATENATE(PT_FMT, _)
+#endif
+
+#define _PT_FMT_H PT_FMT.h
+#define PT_FMT_H __stringify(_PT_FMT_H)
+
+#define _PT_DEFS_H CONCATENATE(defs_, _PT_FMT_H)
+#define PT_DEFS_H __stringify(_PT_DEFS_H)
+
+#include <linux/generic_pt/common.h>
+#include PT_DEFS_H
+#include "../pt_defs.h"
+#include PT_FMT_H
+#include "../pt_common.h"
+
+#include "../iommu_pt.h"
diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
new file mode 100644
index 00000000000000..708beaf5d812f7
--- /dev/null
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -0,0 +1,166 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * "Templated C code" for implementing the iommu operations for page tables.
+ * This is compiled multiple times, over all the page table formats to pick up
+ * the per-format definitions.
+ */
+#ifndef __GENERIC_PT_IOMMU_PT_H
+#define __GENERIC_PT_IOMMU_PT_H
+
+#include "pt_iter.h"
+#include "pt_alloc.h"
+
+#include <linux/iommu.h>
+#include <linux/export.h>
+
+struct pt_iommu_collect_args {
+	struct pt_radix_list_head free_list;
+	u8 ignore_mapped : 1;
+};
+
+static int __collect_tables(struct pt_range *range, void *arg,
+			    unsigned int level, struct pt_table_p *table)
+{
+	struct pt_state pts = pt_init(range, level, table);
+	struct pt_iommu_collect_args *collect = arg;
+	int ret;
+
+	if (collect->ignore_mapped && !pt_can_have_table(&pts))
+		return 0;
+
+	for_each_pt_level_item(&pts) {
+		if (pts.type == PT_ENTRY_TABLE) {
+			pt_radix_add_list(&collect->free_list, pts.table_lower);
+			ret = pt_descend(&pts, arg, __collect_tables);
+			if (ret)
+				return ret;
+			continue;
+		}
+		if (pts.type == PT_ENTRY_OA && !collect->ignore_mapped)
+			return -EADDRINUSE;
+	}
+	return 0;
+}
+
+static void NS(get_info)(struct pt_iommu *iommu_table,
+			 struct pt_iommu_info *info)
+{
+	struct pt_common *common = common_from_iommu(iommu_table);
+	struct pt_range range = pt_top_range(common);
+	struct pt_state pts = pt_init_top(&range);
+	pt_vaddr_t pgsize_bitmap = 0;
+
+	if (pt_feature(common, PT_FEAT_DYNAMIC_TOP)) {
+		for (pts.level = 0; pts.level <= PT_MAX_TOP_LEVEL;
+		     pts.level++) {
+			if (pt_table_item_lg2sz(&pts) >= common->max_vasz_lg2)
+				break;
+			pgsize_bitmap |= pt_possible_sizes(&pts);
+		}
+	} else {
+		for (pts.level = 0; pts.level <= range.top_level; pts.level++)
+			pgsize_bitmap |= pt_possible_sizes(&pts);
+	}
+
+	/* Hide page sizes larger than the maximum OA */
+	info->pgsize_bitmap = oalog2_mod(pgsize_bitmap, common->max_oasz_lg2);
+}
+
+static void NS(deinit)(struct pt_iommu *iommu_table)
+{
+	struct pt_common *common = common_from_iommu(iommu_table);
+	struct pt_range range = pt_top_range(common);
+	struct pt_iommu_collect_args collect = {
+		.ignore_mapped = true,
+	};
+
+	pt_radix_add_list(&collect.free_list, range.top_table);
+	pt_walk_range(&range, __collect_tables, &collect);
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT))
+		pt_radix_stop_incoherent_list(&collect.free_list,
+					      iommu_table->iommu_device);
+	pt_radix_free_list(&collect.free_list);
+}
+
+static const struct pt_iommu_ops NS(ops) = {
+	.iova_to_phys = NS(iova_to_phys),
+	.get_info = NS(get_info),
+	.deinit = NS(deinit),
+};
+
+static int pt_init_common(struct pt_common *common)
+{
+	struct pt_range top_range = pt_top_range(common);
+
+	if (PT_WARN_ON(top_range.top_level > PT_MAX_TOP_LEVEL))
+		return -EINVAL;
+
+	if (top_range.top_level == PT_MAX_TOP_LEVEL ||
+	    common->max_vasz_lg2 == top_range.max_vasz_lg2)
+		common->features &= ~BIT(PT_FEAT_DYNAMIC_TOP);
+
+	if (!pt_feature(common, PT_FEAT_DYNAMIC_TOP))
+		common->max_vasz_lg2 = top_range.max_vasz_lg2;
+
+	if (top_range.max_vasz_lg2 == PT_VADDR_MAX_LG2)
+		common->features |= BIT(PT_FEAT_FULL_VA);
+
+	/* Requested features must match features compiled into this format */
+	if ((common->features & ~(unsigned int)PT_SUPPORTED_FEATURES) ||
+	    (common->features & PT_FORCE_ENABLED_FEATURES) !=
+		    PT_FORCE_ENABLED_FEATURES)
+		return -EOPNOTSUPP;
+
+	/* FIXME generalize the oa/va maximums from HW better in the cfg */
+	if (common->max_oasz_lg2 == 0)
+		common->max_oasz_lg2 = pt_max_output_address_lg2(common);
+	else
+		common->max_oasz_lg2 = min(common->max_oasz_lg2,
+					   pt_max_output_address_lg2(common));
+	return 0;
+}
+
+#define pt_iommu_table_cfg CONCATENATE(pt_iommu_table, _cfg)
+#define pt_iommu_init CONCATENATE(CONCATENATE(pt_iommu_, PTPFX), init)
+int pt_iommu_init(struct pt_iommu_table *fmt_table,
+		  struct pt_iommu_table_cfg *cfg, gfp_t gfp)
+{
+	struct pt_iommu *iommu_table = &fmt_table->iommu;
+	struct pt_common *common = common_from_iommu(iommu_table);
+	struct pt_table_p *table_mem;
+	int ret;
+
+	memset(fmt_table, 0, sizeof(*fmt_table));
+	spin_lock_init(&iommu_table->table_lock);
+	common->features = cfg->features;
+	common->max_vasz_lg2 = PT_MAX_VA_ADDRESS_LG2;
+	iommu_table->iommu_device = cfg->iommu_device;
+	iommu_table->nid = dev_to_node(cfg->iommu_device);
+
+	ret = pt_iommu_fmt_init(fmt_table, cfg);
+	if (ret)
+		return ret;
+
+	ret = pt_init_common(common);
+	if (ret)
+		return ret;
+
+	table_mem = table_alloc_top(common, common->top_of_table, gfp, false);
+	if (IS_ERR(table_mem))
+		return PTR_ERR(table_mem);
+#ifdef PT_FIXED_TOP_LEVEL
+	pt_top_set(common, table_mem, PT_FIXED_TOP_LEVEL);
+#else
+	pt_top_set(common, table_mem, pt_top_get_level(common));
+#endif
+	iommu_table->ops = &NS(ops);
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(pt_iommu_init, GENERIC_PT_IOMMU);
+
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(GENERIC_PT);
+
+#endif
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
new file mode 100644
index 00000000000000..d9d3da49dc0fe2
--- /dev/null
+++ b/include/linux/generic_pt/iommu.h
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#ifndef __GENERIC_PT_IOMMU_H
+#define __GENERIC_PT_IOMMU_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/mm_types.h>
+
+struct pt_iommu_ops;
+
+/**
+ * DOC: IOMMU Radix Page Table
+ *
+ * The iommu implementation of the Generic Page Table provides an ops struct
+ * that is useful to go with an iommu_domain to serve the DMA API, IOMMUFD and
+ * the generic map/unmap interface.
+ *
+ * This interface uses a caller provided locking approach. The caller must have
+ * a VA range lock concept that prevents concurrent threads from calling ops on
+ * the same VA. Generally the range lock must be at least as large as a single
+ * map call.
+ */
+
+/**
+ * struct pt_iommu - Base structure for iommu page tables
+ *
+ * The format specific struct will include this as the first member.
+ */
+struct pt_iommu {
+	/**
+	 * @ops: Function pointers to access the API
+	 */
+	const struct pt_iommu_ops *ops;
+	/**
+	 * @nid: Node ID to use for table memory allocations. This defaults to
+	 * dev_to_node(iommu_device). The iommu driver may want to set the NID
+	 * to the device's NID, if there are multiple table walkers.
+	 */
+	int nid;
+	/* private: */
+	/* Write lock for pt_common top_of_table */
+	spinlock_t table_lock;
+	struct device *iommu_device;
+};
+
+/**
+ * struct pt_iommu_info - Details about the iommu page table
+ *
+ * Returned from pt_iommu_ops->get_info()
+ */
+struct pt_iommu_info {
+	/**
+	 * @pgsize_bitmap: A bitmask where each set bit indicates
+	 * a page size that can be natively stored in the page table.
+	 */
+	u64 pgsize_bitmap;
+};
+
+/* See the function comments in iommu_pt.c for kdocs */
+struct pt_iommu_ops {
+	/**
+	 * get_info() - Return the pt_iommu_info structure
+	 * @iommu_table: Table to query
+	 *
+	 * Return some basic static information about the page table.
+	 */
+	void (*get_info)(struct pt_iommu *iommu_table,
+			 struct pt_iommu_info *info);
+
+	/**
+	 * deinit() - Undo a format specific init operation
+	 * @iommu_table: Table to destroy
+	 *
+	 * Release all of the memory. The caller must have already removed the
+	 * table from all HW access and all caches.
+	 */
+	void (*deinit)(struct pt_iommu *iommu_table);
+};
+
+static inline void pt_iommu_deinit(struct pt_iommu *iommu_table)
+{
+	iommu_table->ops->deinit(iommu_table);
+}
+
+#endif
-- 
2.46.0


