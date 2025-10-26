Return-Path: <kvm+bounces-61097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE82C0A9DB
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 15:25:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDC2318856AD
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 14:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B892EE268;
	Sun, 26 Oct 2025 14:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="USFCZGYo"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011044.outbound.protection.outlook.com [52.101.62.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A332E8DFC;
	Sun, 26 Oct 2025 14:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761488388; cv=fail; b=gHf3B8eVPcAVF4beNrlUSKMbPG5K0s8ppEMZuoW7103ZpuS5pn44bTGI0WJgEfd2QCHy69dBiqPx2vP0XA+nyJq+d1m0SzosnjOsb9Ks+cQfbaQUH2jShA+TOzrICVUDRSzL2Lt1vyW9Kzg1p0LW2IALWWqs7aML7m2vbzmDyVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761488388; c=relaxed/simple;
	bh=pgRuqUTE/S+upHFDgW7F6L9B4cb7D7djZnVtwwD+GIA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4X+UELDEkK8yu+USqJeXU8ctpagLjFHb7UE9zVhOxcylWb1IjuRYKQYFTSgTFWvOlHcIvx4mAg7Fm/zAFBR9gc0VTaCAgczBHjU5fSez0covrqmSXSlNghAX55FMDcSwG8I8TG4I3a9BB5s8cWjdBFg0rhIVP7zepJHZOLrM3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=USFCZGYo; arc=fail smtp.client-ip=52.101.62.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=McrXE32aGOryWOzf4JZ6mWYaa+Nsr/IIDUH9wXOHngvBxK2RD8bmWBudZ2xwgGX5orvd/hzVtFtsjJtoI+HAfIQCNxnc4F8wlpwmQyS/dNepfRN3B8VQ4kV3WncNneJ1IxaWaLXwYPWEZiPABVjejKVccPq/MqrH9VjibMOcOhMV0oJzm31+ObszMPZEfNMtD/2xOn4ZQeK0R192v9a9RWUE/6ivmWYtSyDB82lRUFzITMphdJ4Y9ZUrRZD9iuAhlCesMl/sEH4a7oT7W84P6L9qbmcZj72qsMH1u7JBB5NlYtqRs5IYD7JCcXO8rCCmZTxoW2sxzk0Q9/svTTgY1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=irkkKUrrAhTnqh3H1unWXce0l/IyqR+qtme5TMLE3ws=;
 b=YyezqrI1jfYEY2DB+XKv4Eo4mfrUpDWIw9QbxstUGhCddywWMyhaDVWDB1baPYLvrW8HGtDCLFZKtpUupx+O10JfssGSg96EuAtiQ2hhX9JvRtdSUQchdn6XJXB2nArmHKySj78uQpnrgpyfE/GNXLnGGL4bMiIikRB0aDwYVjZbGWpnXrhs3JwP5Kyea25SEckiCMuc//nHsfAWELGYxMqkR4iPYkn/e9ZGISUAVIvlHAOc/92dPldLKfN4ZNsGdy8FZF7sSn+3GVouYxDqwQPor/nNUfStwdRiNUsJ/3fI89Lk21MApFbt2HdApd7XZTs81769fDiO3UZGOBbXbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irkkKUrrAhTnqh3H1unWXce0l/IyqR+qtme5TMLE3ws=;
 b=USFCZGYoMvOMvfETjmFAqX8fuoPztxd3iy4CJsGEK+ILAO9Aq4dLA+Ps/YPTmnVVav2bUm53kueTJQ6NxIJnprHrnztlsHbMC6efJlrxXfK03IFvUIOilr0u92w5Vaq1e41mkWl6pLxU2wvFWbK7bUjJ243WFQGhXdJufsdP/cnFe0fqC1pIOF92SMqncpNS4TvAOHskufFWYQHSD6MHvrJa7Rxl+/eWxRUQJ0vprpWKh+M1eLtF9iHIR2ZUzUtj5im3s/zfsatjRFVVXEIrWt3ZSV9V/lGdwDEFSHOmmTvGMxAEWGJgd5yxAnmWcBHyH5h0N8q+hLlX7EmQXje93A==
Received: from MW4PR03CA0358.namprd03.prod.outlook.com (2603:10b6:303:dc::33)
 by PH7PR12MB6811.namprd12.prod.outlook.com (2603:10b6:510:1b5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.16; Sun, 26 Oct
 2025 14:19:40 +0000
Received: from SJ1PEPF00002326.namprd03.prod.outlook.com
 (2603:10b6:303:dc:cafe::98) by MW4PR03CA0358.outlook.office365.com
 (2603:10b6:303:dc::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.15 via Frontend Transport; Sun,
 26 Oct 2025 14:19:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00002326.mail.protection.outlook.com (10.167.242.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Sun, 26 Oct 2025 14:19:40 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sun, 26 Oct
 2025 07:19:26 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 26 Oct
 2025 07:19:25 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sun, 26 Oct 2025 07:19:25 -0700
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
Subject: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Date: Sun, 26 Oct 2025 14:19:18 +0000
Message-ID: <20251026141919.2261-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251026141919.2261-1-ankita@nvidia.com>
References: <20251026141919.2261-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002326:EE_|PH7PR12MB6811:EE_
X-MS-Office365-Filtering-Correlation-Id: 135a3a78-a703-41c1-ef19-08de149ab370
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fK6qRfhdgdzzaApTntf74b0WqaLgviG6OmgFljiCCD/yxYRAyt4VXrAe41FY?=
 =?us-ascii?Q?5/EjEIWZUE/5KW21ON0Q3ZQiIU5ynv+HKLWuBna1s5a8A5hgjr6dhpAH9u6+?=
 =?us-ascii?Q?uAe83bRT2SbC9VNCmRWGQbhNF68xFapXs2PPLQkiblx9CZgS3MuH6W0B+c3/?=
 =?us-ascii?Q?ibkTFwi0dFW+QfP34ybiaADvwjZhi6yFlFsbDQaFsf49ejPmMp1t37Ap+8AR?=
 =?us-ascii?Q?JGp474hKEA1eLepgu3YdAhIQ30ccujZ2j9437L+36h8/PwniONa2c2o/ARyR?=
 =?us-ascii?Q?+r4z/ovbAqVhg+8rY4MMmISnkSqM4DTcxuTW/H6+HaoBPV2PpazJK6EQrI/b?=
 =?us-ascii?Q?W0dCsm0V51j49+fg6QmuGrxg5kak7KmfMljIq6SpbxIZzkSfOG1XpS/LDqpB?=
 =?us-ascii?Q?tuFly080Iwy86oyny+q6+JKHvlW1cR3cfMbkTWMQacckYc9n9yCR4Wp9M+fa?=
 =?us-ascii?Q?n69O+DVns4UavscQRE/msfjghOLvpv4o2r/XU7XzbTGudOZwFx4gQDRSWYlZ?=
 =?us-ascii?Q?+6najaXEzz+c1OTIcYE5KRxHvPgk2z3ULKoUHicoUex1cNtf3xHHzOUNcIYW?=
 =?us-ascii?Q?pbWMNYALtQGx33FliyVo/86zLHKBTAuP+myAzjXIcKb0/+YTMYs5OyWncW0x?=
 =?us-ascii?Q?+cVjqn5/CZXHcEcuTwxoo3KBQYumnDIvCs63Cfhb44xf4qV1rJV2aeSEJ8Bn?=
 =?us-ascii?Q?NPgoNX10z8hPcUjDi9Sa9dVNJtbYT5CCg6wR6ctzaozJqeffPUCdoOylEzLA?=
 =?us-ascii?Q?DSJu2565lXYqNSvT/gwVkIrWjc35C0ybi7z4n99BeBk/4y4XudBTQVu/9ZBC?=
 =?us-ascii?Q?/6Bb3kC5es41lrPr7pPkahMpzrTk7/TIMhsDplimFhZ6rFcXZSLVsLnZ3Xic?=
 =?us-ascii?Q?jbfW4usWGWkWKlIN83PU5HOxZNl+PFYEf/TQ7+512mUDw3Eba5jteYkjtlbl?=
 =?us-ascii?Q?3fdezJN/MqKW4PaEdr/rZzvaV55wh9oQcxqKUPENR9oJhJeSGZRHMvo5L5qT?=
 =?us-ascii?Q?auCXdO1xL0PnxQ57TmOfOiPYRXMceNQd0zdSbiZpXaJJROxdHZ9OfAEk9vXz?=
 =?us-ascii?Q?ct+44QiA/21Xx0R2jc0ntC4pa99Zwv5FvcSwfqHo9Kxwf/ZVXG1K8m7kk/1m?=
 =?us-ascii?Q?dOe38sBP2RdiCsLRofxT61MB7B3z2VdJ5aqXpxn3jR6t5th24v17LF1A+lrB?=
 =?us-ascii?Q?+hNe0a+0Z/Yegm+r7qCsC6H3hgNAVMaYHNYVItu/dzTMs98ADs8GKqr0vGmf?=
 =?us-ascii?Q?o9GebvInMrAEECb3EYvwB/wISSUzUo501IzuHugmstDVbzs+2e9pRhscxx5u?=
 =?us-ascii?Q?OzNDNA7HVxZhxkW8f9a2i4E9djyLQIlh/+pmP58RJpdZl64raDOQcH5eNhD5?=
 =?us-ascii?Q?8RDJuzgHG6/TZtEBirleHfWXVRBRSKKLNvtutwTWWI8xZ94sxW+YjpLWfy5a?=
 =?us-ascii?Q?V9vabc/oxMkgaACSC2/96zwDHTwxI1gWgEKN5ApmdXCbyjuHOGgRNCIovghF?=
 =?us-ascii?Q?1Q55lFlQNg81czoJmYs7CZXT7rkQZL3eONKpHDKzVKaniWGwK8tG4TU1t/D6?=
 =?us-ascii?Q?tAe2aPJLrjQ4eLqyEWnXI/foevtcI+2+fyJLIaR9?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2025 14:19:40.0683
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 135a3a78-a703-41c1-ef19-08de149ab370
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002326.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6811

From: Ankit Agrawal <ankita@nvidia.com>

Poison (or ECC) errors can be very common on a large size cluster.
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
faulty PFN using kill_procs().

Note that there is one primary difference versus the handling of the
poison on struct pages, which is to skip unmapping to the faulty PFN.
This is done to handle the huge PFNMAP support added recently [1] that
enables VM_PFNMAP vmas to map at PMD or PUD level. A poison to a PFN
mapped in such as way would need breaking the PMD/PUD mapping into PTEs
that will get mirrored into the S2. This can greatly increase the cost
of table walks and have a major performance impact.

Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 MAINTAINERS                    |   1 +
 include/linux/memory-failure.h |  17 ++++
 include/linux/mm.h             |   1 +
 include/ras/ras_event.h        |   1 +
 mm/Kconfig                     |   1 +
 mm/memory-failure.c            | 146 ++++++++++++++++++++++++++++++++-
 6 files changed, 166 insertions(+), 1 deletion(-)
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
index df6ee59527dd..afac4ed2694e 100644
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
@@ -2216,6 +2222,136 @@ static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
 	kill_procs(&tokill, true, pfn, flags);
 }
 
+int register_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+	if (!pfn_space)
+		return -EINVAL;
+
+	scoped_guard(mutex, &pfn_space_lock) {
+		if (interval_tree_iter_first(&pfn_space_itree,
+					     pfn_space->node.start,
+					     pfn_space->node.last))
+			return -EBUSY;
+
+		interval_tree_insert(&pfn_space->node, &pfn_space_itree);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_pfn_address_space);
+
+void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+	guard(mutex)(&pfn_space_lock);
+
+	if (pfn_space &&
+	    interval_tree_iter_first(&pfn_space_itree,
+				     pfn_space->node.start,
+				     pfn_space->node.last))
+		interval_tree_remove(&pfn_space->node, &pfn_space_itree);
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
+/**
+ * memory_failure_pfn - Handle memory failure on a page not backed by
+ *                      struct page.
+ * @pfn: Page Number of the corrupted page
+ * @flags: fine tune action taken
+ *
+ * Return:
+ *   0             - success,
+ *   -EBUSY        - Page PFN does not belong to any address space mapping.
+ */
+static int memory_failure_pfn(unsigned long pfn, int flags)
+{
+	struct interval_tree_node *node;
+	LIST_HEAD(tokill);
+
+	scoped_guard(mutex, &pfn_space_lock) {
+		bool mf_handled = false;
+
+		/*
+		 * Modules registers with MM the address space mapping to the device memory they
+		 * manage. Iterate to identify exactly which address space has mapped to this
+		 * failing PFN.
+		 */
+		for (node = interval_tree_iter_first(&pfn_space_itree, pfn, pfn); node;
+		     node = interval_tree_iter_next(node, pfn, pfn)) {
+			struct pfn_address_space *pfn_space =
+				container_of(node, struct pfn_address_space, node);
+
+			collect_procs_pfn(pfn_space->mapping, pfn, &tokill);
+
+			mf_handled = true;
+		}
+
+		if (!mf_handled)
+			return action_result(pfn, MF_MSG_PFN_MAP, MF_IGNORED);
+	}
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
@@ -2265,6 +2401,14 @@ int memory_failure(unsigned long pfn, int flags)
 		if (res == 0)
 			goto unlock_mutex;
 
+		if (!pfn_valid(pfn) && !arch_is_platform_page(PFN_PHYS(pfn))) {
+			/*
+			 * The PFN is not backed by struct page.
+			 */
+			res = memory_failure_pfn(pfn, flags);
+			goto unlock_mutex;
+		}
+
 		if (pfn_valid(pfn)) {
 			pgmap = get_dev_pagemap(pfn, NULL);
 			put_ref_page(pfn, flags);
-- 
2.34.1


