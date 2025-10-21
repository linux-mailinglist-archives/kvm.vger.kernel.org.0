Return-Path: <kvm+bounces-60653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F9DABF5C39
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 12:24:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B266E18C6CFE
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F34132D0C2;
	Tue, 21 Oct 2025 10:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YcvTEAOs"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010004.outbound.protection.outlook.com [52.101.61.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBA532C336;
	Tue, 21 Oct 2025 10:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761042231; cv=fail; b=AK7u6h6cPXTz0RdNm1neQRQJprTIh1CBvMFcrd27R6w7yG0qDsaPUbO7NMdAVfBIdB3gTTWGw+B2+OmI+orQ1mEc+f8HtWLVd5B0aAcJwrh3svJcl5zLHHMEMDvyYObl4V3+lmCA2Mhr5kkYc4TqDZPO1Oyty004MI8x6RcsML8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761042231; c=relaxed/simple;
	bh=LYWblBxAELLqxy9lpG1otCPEBEusGrkHb2cD0bLzciI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R5HCKP3woO2IJDUF7mF8B+ww62gShz5K7QiBRjIuU6E6zeZoBXH+yBH6puf59WoUiFR1zQeTjM6Yznix0Ehr0521kXgfQ/DC6F3BUUhH/w8/Dc7snxUODHtXPEIl1xBd+mQaIByXW2cqoNClneEnfQrR5t2MDYmn1TKnBC35xYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YcvTEAOs; arc=fail smtp.client-ip=52.101.61.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O8tLdl1+IGHx0efM2/14WW8HNmfgEyRZz8zE/qWTjqnaz/QOCw5ZLNjeLi5FoX0IoDsMb8vHZ0B3iLtO4v9o6r9M38D+UCcqDgfHXXUnjRuc9zoLR8BkuIDVttz57Sfuzfo4iX5LNcVLVOWgcX9BI3uMtQg+rb+n8WOTixIeNZB96UkplggO0qjhtqVcfwcliQ106kFmLJkFb5ubg1Shfl1fpRzQfbkIaUQHJu3L52gN+MA6Bpme3/pGv/0qQ6eW5zKxp6kKtOmOFkRxIlJhM525kQW+R/cla18H1M5I1woqNpPtADSzcpxkHq6xAvjPoWFzShmHIdIr5yGxad1SrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+NtPtqcmtBNUJmXTDdxef//6j7sywt2r3q7S3p+exyg=;
 b=EePSD54orWqGwkHGhr02Y1qEE3sI+jRCenND5tTYsGXqr3h14QAC6aWTvM8AfAHbUuw/yz+nYhJFXRwGCvzYaM4bZMzWhcNOky+/LdfpMP4BbxUfmI7yIqVr/GI0i+MKNJP4SWbJQef1VaAQT/3W8ZwXEg6gIk77rJ3e1Za9EVp+i9mQfwUr2gOpfQRB1x6gT8I372aPzaLTANuUS9mMprs//VLcCRfcIk6ZU3OXiNErwBX8tE5s7GuV/IPDgNdZK98bFwBrTMq304ug3jGp9vQ/7clOqfpt+BOw1YvY0JNe8iv1WqCSlmRIN1JF4dbt8giQv2C1yIlKkRVsrfsjyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+NtPtqcmtBNUJmXTDdxef//6j7sywt2r3q7S3p+exyg=;
 b=YcvTEAOs4JV4wfEK87dbAOaA/c4ptvb1rSJtaKtSCMsfMHyfkwKRedcsp/U3F0HOzwtZlzc3b2P5xxR2bn5/cQjEm2fYdaciAUuqwrRI8nccgU7nosQPvVNLSuJP+0+fjBznLVCPFoH3DcZ1TwlxHhiH4CPKWpmK8JOztX3ixj7m9wqhhxPO/Zi+2YAHVBff1eIh7kd+MPIpGOxk7tPGKaTVOEkwKQ5xQegYgPSZpwFq1MhkJy92bCMbbXjFoXuqHvB4c9qv4Q6PyGPZhNtinaVBtXu0JFHZ6v7Mh5EpnU6JdKWqBT1WqVvm2PhDPXK+x/bVI/AKQaaT61d35RkMjw==
Received: from SJ0PR05CA0199.namprd05.prod.outlook.com (2603:10b6:a03:330::24)
 by IA1PR12MB8264.namprd12.prod.outlook.com (2603:10b6:208:3f5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 10:23:41 +0000
Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
 (2603:10b6:a03:330:cafe::36) by SJ0PR05CA0199.outlook.office365.com
 (2603:10b6:a03:330::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.10 via Frontend Transport; Tue,
 21 Oct 2025 10:23:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Tue, 21 Oct 2025 10:23:40 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 21 Oct
 2025 03:23:32 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 21 Oct 2025 03:23:31 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 21 Oct 2025 03:23:31 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
	<jgg@nvidia.com>, <mochs@nvidia.com>, <skolothumtho@nvidia.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
	<guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <alex@shazbot.org>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
	<ira.weiny@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>,
	<u.kleine-koenig@baylibre.com>, <peterz@infradead.org>,
	<linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 1/3] mm: handle poisoning of pfn without struct pages
Date: Tue, 21 Oct 2025 10:23:25 +0000
Message-ID: <20251021102327.199099-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251021102327.199099-1-ankita@nvidia.com>
References: <20251021102327.199099-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|IA1PR12MB8264:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f9a77b0-6c25-40b1-90c8-08de108be7ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VkyDKgkK/bFrg1xrCV7AzJp1e2Xe2JqGGbTg7qp6L3ZoQJ35Ks4oJbJepgQ4?=
 =?us-ascii?Q?uuR8S+EA153xzAzQPBARjiQ4rJ08bWe5JovCAfz1p92Cq61DTHZEaA42wL8V?=
 =?us-ascii?Q?1USr+gCk1MBPB34xqy80CYLwfOkBHQ/1kcfus09ubekWwPPYyCGQZMQUJ306?=
 =?us-ascii?Q?x7runWR3sBMn+l97+FRE2tieFFVpOv3QY+UaWQlRv2SaliwEOQ2ApeWWsx2x?=
 =?us-ascii?Q?sZ2E/zqcwB6u5o2GXnNg4brbT6IJaHLSaS/80ZdO6ZY0Ug6WmJsXLr4nU/wE?=
 =?us-ascii?Q?8z9VlPbP6UUolSnQvyULv4rPsbVEfyVsrFjOSBYcu6UQWQkhqwGPBac1pHxG?=
 =?us-ascii?Q?aBuMeB9yjmPbwryy+DAr2qytmEPqT1hvSStAK5ikZc54XFDceoTG6eEFygOB?=
 =?us-ascii?Q?FTL5K/ed6miPTAJHsCZEHd/VDd971x2MLqW5n/O6ilY9jbIsLYfx+9NRGbVe?=
 =?us-ascii?Q?gMyCI7GMVOIfbJb+GwdmPeHqUmAvOZA3dL/MWRSqa7J/P/jVqJtX68IN55Em?=
 =?us-ascii?Q?F9QXpqj+e4niXkebIac5RNNxYvG3ejliZzTd6r0SAeJmID/R7ymB5C3JIZnX?=
 =?us-ascii?Q?OIvkr88Krnri+HIHsW+2HPwHLyydbOutqnp0VCKFqeI5vSV7QgKnqAXgvXFJ?=
 =?us-ascii?Q?WtoLi0Y4lH4qW2ORHBMaGeRznSJQdFbR+HiKO6Vl/VCTe/nH6UqCpimsFuIi?=
 =?us-ascii?Q?w35gfIfwwKvLt+yNYwBIp504AbdvAH1GFFLhBvezRBg88eLBJlS+08OtsVhu?=
 =?us-ascii?Q?oRyj2tPusuq9NOVeda++00SNR8vXJcnXXCe3/ejINTf6JZQZlkcgMtzTVW3m?=
 =?us-ascii?Q?WJlvRNMhjL1lQM09VcOIySP2c3LWSN++NEdAbsS3nrgtU2vOCfTW/I2cCyhg?=
 =?us-ascii?Q?+mEyUAZmbJp8rSLDamfZ/c18Qc9wiYIxFtvhH9jVMR7G0xTaDNmsuXmCqoaK?=
 =?us-ascii?Q?qD/mcJHhKYjKIJzHJyHJx5XLqr1gqtXOkTjCxKfUGG+j0QbWHP/3hL9T0dlh?=
 =?us-ascii?Q?EXquslIoOtQ+/4Lgu3p70Lwi5blFVeCuZVMrxdyE41I65tptCHECleD6CXN9?=
 =?us-ascii?Q?kLH6kBxNsybIyPiNEBLDqIxW5a73vMMLjlX/IsWwV59WMvrOncnfANanO6E1?=
 =?us-ascii?Q?jfsBBB+Mry0GBYMVZ1mzbLdG5nAITPOrR4f49eDaPNbah5MsXDUaSelvVljx?=
 =?us-ascii?Q?Tf59ZLfinQwfBAg3nePyY3SFiDKMtcCFC1C4QKVe1Na3vONh+R//8Euz/+dY?=
 =?us-ascii?Q?UH48T0l3DDHyJ+elos4qXqJX1VT51vg4tXPIIZFfJdKAT0oReNErfQF+eJZf?=
 =?us-ascii?Q?hbjx8D63ikX6kiPRiJnXBJUXKFdhB9nuOSkpJY2Iv2mzqiakE+fsKKS1/z3l?=
 =?us-ascii?Q?PmJTylj8MrdqfMPqse2j0WG+/DVGWfwnfevnfaFODMVTe1WkXizFLvs9LrNS?=
 =?us-ascii?Q?epPFH92XGhGIS6pELm9tl3EaZkzed2nKxmMHrA/xEtib/9DI7irfHbGAXk/y?=
 =?us-ascii?Q?EFMVuK9+oQS64ihHA6J3mkEQsF3hO/N+E9/kgVBOhxaAsNOYNxhdRb4boJ44?=
 =?us-ascii?Q?mhf84qoGbP5E97VAAxyEqhgtMIZqbtEte6g3IAna?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 10:23:40.6320
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f9a77b0-6c25-40b1-90c8-08de108be7ab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8264

From: Ankit Agrawal <ankita@nvidia.com>

The kernel MM currently does not handle ECC errors / poison on a memory
region that is not backed by struct pages. If a memory region mapped
using remap_pfn_range() for example, but not added to the kernel, MM
will not have associated struct pages. Add a new mechanism to handle
memory failure on such memory.

Make kernel MM expose a function to allow modules managing the device
memory to register the device memory SPA and the address space associated
it. MM maintains this information as an interval tree. On poison, MM can
search for the range that the poisoned PFN belong and use the address_space
to determine the mapping VMA.

In this implementation, kernel MM follows the following sequence that is
largely similar to the memory_failure() handler for struct page backed
memory:
1. memory_failure() is triggered on reception of a poison error. An
absence of struct page is detected and consequently memory_failure_pfn()
is executed.
2. memory_failure_pfn() collects the processes mapped to the PFN.
3. memory_failure_pfn() sends SIGBUS to all the processes mapping the
poisoned PFN using kill_procs().

Note that there is one primary difference versus the handling of the
poison on struct pages, which is to skip unmapping to the faulty PFN.
This is done to handle the huge PFNMAP support added recently [1] that
enables VM_PFNMAP vmas to map in either PMD level. Otherwise, a poison
to a PFN would need breaking the PMD mapping into PTEs to unmap only
the poisoned PFN. This will have a major performance impact.

Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 MAINTAINERS                    |   1 +
 include/linux/memory-failure.h |  17 +++++
 include/linux/mm.h             |   1 +
 include/ras/ras_event.h        |   1 +
 mm/Kconfig                     |   1 +
 mm/memory-failure.c            | 128 ++++++++++++++++++++++++++++++++-
 6 files changed, 148 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/memory-failure.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 520fb4e379a3..463d062d0386 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11359,6 +11359,7 @@ M:	Miaohe Lin <linmiaohe@huawei.com>
 R:	Naoya Horiguchi <nao.horiguchi@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	include/linux/memory-failure.h
 F:	mm/hwpoison-inject.c
 F:	mm/memory-failure.c
 
diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
new file mode 100644
index 000000000000..bc326503d2d2
--- /dev/null
+++ b/include/linux/memory-failure.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MEMORY_FAILURE_H
+#define _LINUX_MEMORY_FAILURE_H
+
+#include <linux/interval_tree.h>
+
+struct pfn_address_space;
+
+struct pfn_address_space {
+	struct interval_tree_node node;
+	struct address_space *mapping;
+};
+
+int register_pfn_address_space(struct pfn_address_space *pfn_space);
+void unregister_pfn_address_space(struct pfn_address_space *pfn_space);
+
+#endif /* _LINUX_MEMORY_FAILURE_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..0ab4ea82ce9e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4006,6 +4006,7 @@ enum mf_action_page_type {
 	MF_MSG_DAX,
 	MF_MSG_UNSPLIT_THP,
 	MF_MSG_ALREADY_POISONED,
+	MF_MSG_PFN_MAP,
 	MF_MSG_UNKNOWN,
 };
 
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index c8cd0f00c845..fecfeb7c8be7 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -375,6 +375,7 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_DAX, "dax page" )					\
 	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
 	EM ( MF_MSG_ALREADY_POISONED, "already poisoned" )		\
+	EM ( MF_MSG_PFN_MAP, "non struct page pfn" )                    \
 	EMe ( MF_MSG_UNKNOWN, "unknown page" )
 
 /*
diff --git a/mm/Kconfig b/mm/Kconfig
index e443fe8cd6cf..0b07219390b9 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -777,6 +777,7 @@ config MEMORY_FAILURE
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
 	select MEMORY_ISOLATION
+	select INTERVAL_TREE
 	select RAS
 	help
 	  Enables code to recover from some memory failures on systems
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index df6ee59527dd..acfe5a9bde1d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -38,6 +38,7 @@
 
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/memory-failure.h>
 #include <linux/page-flags.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/task.h>
@@ -154,6 +155,10 @@ static const struct ctl_table memory_failure_table[] = {
 	}
 };
 
+static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
+
+static DEFINE_MUTEX(pfn_space_lock);
+
 /*
  * Return values:
  *   1:   the page is dissolved (if needed) and taken off from buddy,
@@ -957,6 +962,7 @@ static const char * const action_page_types[] = {
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
 	[MF_MSG_ALREADY_POISONED]	= "already poisoned page",
+	[MF_MSG_PFN_MAP]                = "non struct page pfn",
 	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
@@ -1349,7 +1355,7 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 {
 	trace_memory_failure_event(pfn, type, result);
 
-	if (type != MF_MSG_ALREADY_POISONED) {
+	if (type != MF_MSG_ALREADY_POISONED && type != MF_MSG_PFN_MAP) {
 		num_poisoned_pages_inc(pfn);
 		update_per_node_mf_stats(pfn, result);
 	}
@@ -2216,6 +2222,121 @@ static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
 	kill_procs(&tokill, true, pfn, flags);
 }
 
+int register_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+	if (!pfn_space)
+		return -EINVAL;
+
+	mutex_lock(&pfn_space_lock);
+
+	if (interval_tree_iter_first(&pfn_space_itree,
+				     pfn_space->node.start,
+				     pfn_space->node.last)) {
+		mutex_unlock(&pfn_space_lock);
+		return -EBUSY;
+	}
+
+	interval_tree_insert(&pfn_space->node, &pfn_space_itree);
+	mutex_unlock(&pfn_space_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_pfn_address_space);
+
+void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+	if (!pfn_space)
+		return;
+
+	mutex_lock(&pfn_space_lock);
+	interval_tree_remove(&pfn_space->node, &pfn_space_itree);
+	mutex_unlock(&pfn_space_lock);
+}
+EXPORT_SYMBOL_GPL(unregister_pfn_address_space);
+
+static void add_to_kill_pfn(struct task_struct *tsk,
+			    struct vm_area_struct *vma,
+			    struct list_head *to_kill,
+			    unsigned long pfn)
+{
+	struct to_kill *tk;
+
+	tk = kmalloc(sizeof(*tk), GFP_ATOMIC);
+	if (!tk)
+		return;
+
+	/* Check for pgoff not backed by struct page */
+	tk->addr = vma_address(vma, pfn, 1);
+	tk->size_shift = PAGE_SHIFT;
+
+	if (tk->addr == -EFAULT)
+		pr_info("Unable to find address %lx in %s\n",
+			pfn, tsk->comm);
+
+	get_task_struct(tsk);
+	tk->tsk = tsk;
+	list_add_tail(&tk->nd, to_kill);
+}
+
+/*
+ * Collect processes when the error hit a PFN not backed by struct page.
+ */
+static void collect_procs_pfn(struct address_space *mapping,
+			      unsigned long pfn, struct list_head *to_kill)
+{
+	struct vm_area_struct *vma;
+	struct task_struct *tsk;
+
+	i_mmap_lock_read(mapping);
+	rcu_read_lock();
+	for_each_process(tsk) {
+		struct task_struct *t = tsk;
+
+		t = task_early_kill(tsk, true);
+		if (!t)
+			continue;
+		vma_interval_tree_foreach(vma, &mapping->i_mmap, pfn, pfn) {
+			if (vma->vm_mm == t->mm)
+				add_to_kill_pfn(t, vma, to_kill, pfn);
+		}
+	}
+	rcu_read_unlock();
+	i_mmap_unlock_read(mapping);
+}
+
+static int memory_failure_pfn(unsigned long pfn, int flags)
+{
+	struct interval_tree_node *node;
+	LIST_HEAD(tokill);
+
+	mutex_lock(&pfn_space_lock);
+	/*
+	 * Modules registers with MM the address space mapping to the device memory they
+	 * manage. Iterate to identify exactly which address space has mapped to this
+	 * failing PFN.
+	 */
+	for (node = interval_tree_iter_first(&pfn_space_itree, pfn, pfn); node;
+	     node = interval_tree_iter_next(node, pfn, pfn)) {
+		struct pfn_address_space *pfn_space =
+			container_of(node, struct pfn_address_space, node);
+
+		collect_procs_pfn(pfn_space->mapping, pfn, &tokill);
+	}
+	mutex_unlock(&pfn_space_lock);
+
+	/*
+	 * Unlike System-RAM there is no possibility to swap in a different
+	 * physical page at a given virtual address, so all userspace
+	 * consumption of direct PFN memory necessitates SIGBUS (i.e.
+	 * MF_MUST_KILL)
+	 */
+	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
+
+	kill_procs(&tokill, true, pfn, flags);
+
+	return action_result(pfn, MF_MSG_PFN_MAP, MF_RECOVERED);
+}
+
 /**
  * memory_failure - Handle memory failure of a page.
  * @pfn: Page Number of the corrupted page
@@ -2259,6 +2380,11 @@ int memory_failure(unsigned long pfn, int flags)
 	if (!(flags & MF_SW_SIMULATED))
 		hw_memory_failure = true;
 
+	if (!pfn_valid(pfn) && !arch_is_platform_page(PFN_PHYS(pfn))) {
+		res = memory_failure_pfn(pfn, flags);
+		goto unlock_mutex;
+	}
+
 	p = pfn_to_online_page(pfn);
 	if (!p) {
 		res = arch_memory_failure(pfn, flags);
-- 
2.34.1


