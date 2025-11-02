Return-Path: <kvm+bounces-61773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B601C29560
	for <lists+kvm@lfdr.de>; Sun, 02 Nov 2025 19:45:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5EB674E89FA
	for <lists+kvm@lfdr.de>; Sun,  2 Nov 2025 18:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5737625394B;
	Sun,  2 Nov 2025 18:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b0k2iIiH"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010032.outbound.protection.outlook.com [52.101.85.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8BB24339D;
	Sun,  2 Nov 2025 18:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762109100; cv=fail; b=eq1EtpREOcKXbr5inNA/xc22HLMC1LO6UWkTLcAccVQpeqQXjcTUVQtf0LLGVWhfS9yjeJ8y9w0qbO9uAB9b+gmyxSIckwZwaiqiZ6zUV4XxlnDSAD29PibpsHSJxWKDsythUyhylat7NfAWSYkuaW42+llEUfW6Xd7JSsWYGEU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762109100; c=relaxed/simple;
	bh=M8Ohiwrt676sBetcqcPNkWv2P//oCvcFa4OqjXKUFZg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=InZVPSRv0t/oqufDvwtAQ9jv+miaEP/HitXBJWwnjrWa4rfFBgUYVQDMM4938+4SVx7SA8Jxu0S+KmFYmIgJ4xDPpod/TP3iLhjxJgHshdoRa4gkg3Qi/+G2VFL8xpaOcsDnAyvW1OZ2fBtnxSksbXU2oSRa0ZUyabKiaDU3IwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b0k2iIiH; arc=fail smtp.client-ip=52.101.85.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QPfxPuaZ9DGDgJUaY6AXt6Sjp7IqPH1Kuuvc17ARtxZXQYDvHvgHSwqCFoyj12q+u/+J9yuTvQ/GPrkeVIdsBtsM8TMLq51SxmzkQ+jF1JSmhpUj7fPK/mHGXoxTc3aM77q9zNLaTFzKkb2FfiLtoUMO9BHhUBGoEHz1J5Pv8j97Gry2yP/SZbhj2/e7LxTUROlHpMGQmCvJ2lD0F3EwLcr+4kBeiW5mnNcX6r3zgWdEbURquhGms+d/dgiZS/5F+hZ/4fkNGqZ226g1prXiqX68JXr9O8WjqqrgBFnb188lc+vlsUmVP6Kjsn2497SxfYQyJTHMiyZPjb7GoC6NdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PAwxvj/DLDRkughw4hJj4pBQuOdPY7FXIhHFqx8/HEs=;
 b=PmMmyJJ0D7P0ZwcmKOxkeaUjQK15qVskRNQ0EIT3roEmpaseXHEtcejBvDVBcLxol5yfYiG1Prj9eKEA9sIv4rejEnQjInJ4fyDNTkZgzGHWUJA0GeV8k52NaEhChseGbGyaaPbNh+sM+PysG7c3hWW6AwHwyTPsgBZqm0JCS9RSdxyB2QNqwv7Uz+BAUtQJczsWRxEvmmlR0IOEtuNsjk6DD8bZBpZ9VNLHoHJpOMKIdpH+gaDVbpq930jb6CitcGNnYJ10xRwrmc39YJ7zS3LgE95V6XSn8cCglanZHAqnp8oPsoaSI+XsEODeLJsT8jJIDt/5BiGOVqPQeMNZbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAwxvj/DLDRkughw4hJj4pBQuOdPY7FXIhHFqx8/HEs=;
 b=b0k2iIiH4POsKzZvRlmRY0iszKstQQOmybM2hCESrRUBVYriY2ph/LssY4SZ938nMPRXJGkvXva4CK2wsAbQHz1RidfoIHZ04LHNXrGR4rfguteLbjIkIksley81vTXByQtO857s4W0bC2ocTi1SKYPpBiQqB8VAm94TWPstYPeN8x9oMV4jVLPEDYG6utUTfeol8RUayE/orKcaXXwl2oLR2tNV3aKS3hz9kFsBdmzC5wnHBGIHpRPefRTudsv9h3phRRgBpkjmfCX9OOXGNSkhkt3vcHY/34PeyUnK1wkxND2pr5ja5hxbzWZQG9IDMT2+YClbjbIYK5c0JG87Sg==
Received: from CH2PR18CA0039.namprd18.prod.outlook.com (2603:10b6:610:55::19)
 by IA0PR12MB8982.namprd12.prod.outlook.com (2603:10b6:208:481::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Sun, 2 Nov
 2025 18:44:54 +0000
Received: from CH1PEPF0000AD80.namprd04.prod.outlook.com
 (2603:10b6:610:55:cafe::b3) by CH2PR18CA0039.outlook.office365.com
 (2603:10b6:610:55::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.16 via Frontend Transport; Sun,
 2 Nov 2025 18:44:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD80.mail.protection.outlook.com (10.167.244.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.6 via Frontend Transport; Sun, 2 Nov 2025 18:44:53 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 2 Nov
 2025 10:44:41 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 2 Nov
 2025 10:44:40 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sun, 2 Nov 2025 10:44:40 -0800
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
Subject: [PATCH v5 2/3] mm: handle poisoning of pfn without struct pages
Date: Sun, 2 Nov 2025 18:44:33 +0000
Message-ID: <20251102184434.2406-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251102184434.2406-1-ankita@nvidia.com>
References: <20251102184434.2406-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD80:EE_|IA0PR12MB8982:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f3070c5-250f-4361-cd48-08de1a3fe9b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zXyi5WKNyNpmuSDVaWAeAFBxSwZ97/seJHcKoZXF1qkP9iND2tSaq39hK7c7?=
 =?us-ascii?Q?6FjNccawwQSeDlBVatuBHwSzdFBUMVMOHezNUK05ZpkhxWTTmG/sgK0jgCNh?=
 =?us-ascii?Q?0IZqALJGUQwDBGLWzrpxfVEQyRM1BO7ARNhYxZC3Ih5eH5YQV8kMfWOTHHju?=
 =?us-ascii?Q?nC4uVWvLB5rmtCxlfLOLIE6LFENBgxl+8P2vQTGgnPi6tC8Ir4KR6EuqhZ3V?=
 =?us-ascii?Q?QrAMUiHgUHuSwIUfA3J/RetGFffr2HamdNhjl2ct21l55Xs9knXRW8beQG0m?=
 =?us-ascii?Q?+SHhHhAnVSc+gaNoEfQ4b65yJ8whPfelx2cord4qTsMvYzrJGnAMH/it3nNz?=
 =?us-ascii?Q?rYyqJz0PxMbOije1L6ZLHDR13T0TB0I12q5efOdC9XBdsDtsMtvuMhfcGavk?=
 =?us-ascii?Q?jiWZ3OPUIlhRpRRws31dSPBdUd6KiL5A4zq5RVaBDkdyvEWc1ieukxsBVfj/?=
 =?us-ascii?Q?533Yfbc/mZUpfIwYw/Eq1WNd/EOoTQiLO53/R9tSQmxluoDBDyWFYPtMbw7q?=
 =?us-ascii?Q?QVIwn4jh5V6IcMc8Fs9AXj7GJIrfsX/RrH48qCqqquYFKiiDZgPNqQeDJKt3?=
 =?us-ascii?Q?pG2dPRGWMNmUl0wJ/XVzhA/Hb7NHfeSMOkSs3sptMNJzPCRS4Afg9EAAhOEj?=
 =?us-ascii?Q?Uvcgq8ggJz9VSkCyYIyHYCo0938jQaJE19pv+8qUwKUASLhJP10NnPAw1J1C?=
 =?us-ascii?Q?VdEPyTDi2tLUtOHSknI4YKZwf/h+UkCNZ/KhDUUzRhQZ7zhtQX2xjmguW1e9?=
 =?us-ascii?Q?GSU7wuXuAyHUQHOCea/b9Du/gPawVbMkG1l2is1r2F9KZ0t2Q44Yr5bVWmEL?=
 =?us-ascii?Q?CGrsiiV71GQg5FSdwRojYEpVnyouH6bbEjmj1wq2GSww8RFOBobXFnDwK24r?=
 =?us-ascii?Q?T0OxnklG2PcfeWSO+RkWNC6isZsYHBIIIgZ6AbwiWry82XI+Lh2XaeNCr1jP?=
 =?us-ascii?Q?+ZAAEAQF9MlLI7PayJvXs8yjgksOZa9TLgr0XWL9RE2wUUL6YoNnj3GyhI0I?=
 =?us-ascii?Q?g+2FClANkXbFxRoQgWffXhxLtwKJ5JDu/YNZ+t0ZwaaVMA5HNrXmml4GVHh+?=
 =?us-ascii?Q?wfrRq9jbbyzFUcLp+CEzrmmEp4XhQ8EnOFFKz94rASkdKZJYp+PmIkwOQwDD?=
 =?us-ascii?Q?fy4eSTvi9MLdRPEqyfqnD0dbVHGLq+meVwBE49e9xMasBkaUfywrO62iwkoG?=
 =?us-ascii?Q?8r9fOzE1Zem1xyVS6/L5wlhsbSY7DvwU5eI0Ticor502zKpAIhId3+ZEFtmZ?=
 =?us-ascii?Q?Cx198cKz4ucviyBes2eQ08DQKeFkKWiSGHtkIerWH4KdI70mzw7U9/r7fJJm?=
 =?us-ascii?Q?M/wH3TYX98xlDDLXfHYDJjrrb7C/LSAIWjwQ51gSvurP6rNLYLPO7ZB2K5Vw?=
 =?us-ascii?Q?VEn8E1/ER4yRoMvA94uqXQK+Xi92vdkMGoWX/rj/sr2ViBk8Wl4WT8CNr9JS?=
 =?us-ascii?Q?Nb+SqSaGR/oOcLNAMP46rUJJcf9aJdLyWQFz0pS6wEzETnOcP0IqEu3iepEi?=
 =?us-ascii?Q?oJAWGa/mz9trmUFMhD6ds38wxwkkLxvakyA3Dn6jeq1CLhOaF0jT/2iT2A8x?=
 =?us-ascii?Q?xQM0DR+PpWZgIoQo3f28BO4cg4VSREVqN0q0SWkH?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(921020)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2025 18:44:53.8564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f3070c5-250f-4361-cd48-08de1a3fe9b2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD80.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8982

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
 mm/memory-failure.c            | 145 ++++++++++++++++++++++++++++++++-
 6 files changed, 165 insertions(+), 1 deletion(-)
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
index df6ee59527dd..03e4249a9f8f 100644
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
@@ -2216,6 +2222,135 @@ static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
 	kill_procs(&tokill, true, pfn, flags);
 }
 
+int register_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+	guard(mutex)(&pfn_space_lock);
+
+	if (interval_tree_iter_first(&pfn_space_itree,
+				     pfn_space->node.start,
+				     pfn_space->node.last))
+		return -EBUSY;
+
+	interval_tree_insert(&pfn_space->node, &pfn_space_itree);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_pfn_address_space);
+
+void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+	guard(mutex)(&pfn_space_lock);
+
+	if (interval_tree_iter_first(&pfn_space_itree,
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
+	if (!tk) {
+		pr_info("Unable to kill proc %d\n", tsk->pid);
+		return;
+	}
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
+		 * Modules registers with MM the address space mapping to
+		 * the device memory they manage. Iterate to identify
+		 * exactly which address space has mapped to this failing
+		 * PFN.
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
@@ -2265,6 +2400,14 @@ int memory_failure(unsigned long pfn, int flags)
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


