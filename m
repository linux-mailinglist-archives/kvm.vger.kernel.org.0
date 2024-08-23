Return-Path: <kvm+bounces-24913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 560F595CDF2
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:32:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D79431F2512F
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 411E9188011;
	Fri, 23 Aug 2024 13:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="p1p5BCvz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A50188584;
	Fri, 23 Aug 2024 13:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419912; cv=fail; b=eC0f3zEPwzsg/UlJJrcxMbzIS3h3EePDSM9S0q+qvCJkb7VOziRwbvPuUm/6TVxnSWW1fH0nCZMH9RrBxXCuxAlf+wML8n+17dqNlIM/fCgXQbAEpHMsV7usOVpBKt489g1IZBUyzlQ95D42gJrHbNwcZQWsGKYU6Vy/qfUpZ4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419912; c=relaxed/simple;
	bh=7GzMks0EYKrLv+VixKNXp/5E2wJy9qmganXkUUhZdk4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=olzh7J1fHI5TVHXrdSyF9WXoyAKF9bV7uq52DuYyvlyAL7RwKdnvGomeWScS9arIWinVSjdA8hjSBVDdI/zkBsvKzQ0BdTahJkE5k6igsnTARu6GtJJbFDTNA90N7stKVedWgHCPfwg6WItPP5k/G1cwnBBZSDvYgjKLbWw77w8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=p1p5BCvz; arc=fail smtp.client-ip=40.107.243.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fXzvmTXXla09gYQG99tcVBOvJg8j2fc1gBTwOLulTr0kvboo0So4d0GSpoYvlvR92K1ZIZ9/C5/GDQDrVWpONKf2TkMbODi74zTZdDzXPxsy+3Fydrv4hvRFGXyCQ1MeiTEf4lNSSva68lyvkWGoW3cMMApkwgydizHciAqV8I9XbdWjcULyy17MWebdyujl0GNVnLYcLbxol6KNVhYgcOHQ6pOaaGx3f2HTn1/vK49yMTzMApWmUAPUktxMywkhM5fjMtvRxSt+wEoJWoFq0CeRrrcEqL/6LRl+nll4ekTymX/wcseyYnJ4HnOuHG6c04DOuFrHg/nYaQcsNP856Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1xPQ3U96dvoS7pmq/ZA66j9P+pMgBy4tVEZt9dP+ew=;
 b=Xw1Ux0er/o26eGrf4TjXcHtG7qCf0vBQ3BxD15sl7jBniFufxAJQzT3cmPUaxUjlFZg28dWaJp96vGTCpbjGfDOxN2Wl/UpvXh9CXIJoCV6vd1iCmdkuh5NSZKioVZqDT3eRArQSeUI+SwWNawh8tAT8PkNbbwJHvP1jYvcP1DdfxUX0Mz3xMfv8t2RTT1oG3b7RqU/M1GOA2xpE2tbSK19DA7P47hIeoc01ll2vzr6oQ6WR/PCL0rARDiDOAQ9uLEAuZRUJkqsQRgS5k/Mh/IGzuPbxAPZXFvrK+U+OtbQkbAo4c2TNIqN6X94R2Yg2VPdosNB1WhazkQAU9ls4pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1xPQ3U96dvoS7pmq/ZA66j9P+pMgBy4tVEZt9dP+ew=;
 b=p1p5BCvztzGDLDD4MYQRBJEnlhtqAFu2yyo9wbR8vfto5OUoSsVLOVVnBbguYbHDXX/gtqGkXejAWk0xGYxb4KdxMB5DUSt2fV3GBu5bRm+slzv6ywehmUF0mJaCQ40ddZ3dLocemYRxspM2sVlkkWZm73O8mcd7sgDiARSKva8=
Received: from PH8P222CA0012.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:2d7::25)
 by CH3PR12MB7547.namprd12.prod.outlook.com (2603:10b6:610:147::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Fri, 23 Aug
 2024 13:31:46 +0000
Received: from CY4PEPF0000EE37.namprd05.prod.outlook.com
 (2603:10b6:510:2d7:cafe::30) by PH8P222CA0012.outlook.office365.com
 (2603:10b6:510:2d7::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Fri, 23 Aug 2024 13:31:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE37.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:31:45 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:31:39 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: [RFC PATCH 15/21] coco/sev-guest: Allow multiple source files in the driver
Date: Fri, 23 Aug 2024 23:21:29 +1000
Message-ID: <20240823132137.336874-16-aik@amd.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240823132137.336874-1-aik@amd.com>
References: <20240823132137.336874-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE37:EE_|CH3PR12MB7547:EE_
X-MS-Office365-Filtering-Correlation-Id: e4a62538-00f2-4bce-5a7e-08dcc377eef4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1qk/NSFIokSl7ZRhlxMrP9a3OkcVSb3YAZzIsPlvgPbzO2KGQihTQ33mfFyc?=
 =?us-ascii?Q?57So+4sAGZt2/1KNcctGMb3GKb9wwckBwgfZMCV2DjL8T6bwaDMPjF1gFTSa?=
 =?us-ascii?Q?bf6Kc5uF6FDSxUuDIIeJac5ItYgfVBMbSpoEhjKfb9piZ5oIl0cmp4P4uU4N?=
 =?us-ascii?Q?9RQvcU/P9BZklILrgJQfHnJqHEglDJuYhSI9JIJQTI10YGpcKc4X0NkkjKql?=
 =?us-ascii?Q?Sy8qFLS20NrFGI/rBOIkYU2NudpiQFfaof1teU+rG5cSDJGILOWgoEAll8f9?=
 =?us-ascii?Q?nQB6IyPxrYQB+EAlseIAyDEvlOMNa8OmEiTuc9tF4W8jzEH33VdZckjGmlB8?=
 =?us-ascii?Q?E0SX/u9gusglPjHXotmShVkkjt9kLvEdiOP204wSZ2QFKxUuK3H0+2bTWWq2?=
 =?us-ascii?Q?qHDmoPhx0E0lkRks/bbN+wAtVLrd5+IrQ+8Ui7peCSipvF16BFn1RLPZA/dq?=
 =?us-ascii?Q?qaCiLwgQYu9VgNfJST/miYffR3q/WZTOI1+NlAUYqaEt0DL9abAmReLiJiXF?=
 =?us-ascii?Q?DNlTjxjILQAoaHdWKC2tzFIR6zoO0Q0pJLkEQOspFT9G195bkpsu6h/HZS+t?=
 =?us-ascii?Q?AaYql56JcJjSfq9Q7DAicWwmazK98zHD4IL7szYzKnhB90Xz7S3y6zWlKQbJ?=
 =?us-ascii?Q?Rn5MWQg7LWkuCVXVA4CD8n2YtsdexmvmeJ5W+9sM05l0k2C1dxX2SMrpocsl?=
 =?us-ascii?Q?3slMKrOXtEaF5eLWjznKSmtRo9mHUIwyDGxp5TcZ+TJ2ky2ie/UfUQoYp8Ng?=
 =?us-ascii?Q?rJ8Ts1h57q0YUgRJUo7S6R/LobFUMlfDSHbMJBL52QTRyritatsYUoJ4YJQC?=
 =?us-ascii?Q?qq+O3Ocu8i3I+INUp5mWhDasaCQnZVuHF80UB4U1FQXRQUVqAgLxNClx8hZK?=
 =?us-ascii?Q?wLNxrjkdw4iAz6oHSb9ajnXo2vOu7XQUbx4hLiHr80zJn5q1JxP//I2yUa4j?=
 =?us-ascii?Q?nhAuozw6zyvQzofj6eIYNRDA99YxcvKUw01F984AhKiZnDKlgJ/m0841xZ1+?=
 =?us-ascii?Q?RvngEUR9Wuwe4Zjc9Un9DgFbqHyvEmTMD74xmLU2hi5bU8dVxGQSGPcsKBcs?=
 =?us-ascii?Q?IRPNo+CHMyfUUN6sBCMamcNjpJpXmT+EvG0OEd7AyNONf8zuUlmF8l+QFItZ?=
 =?us-ascii?Q?1cw7diNc35imJVJy+OLjr/CQUxflTocyPI5UruVZA4QnGlVuATVtLO9RxLLc?=
 =?us-ascii?Q?16ipeSuYhPiY9nKRNrzq/M97wilz+xnb/QNPpUwkoLA/Xz5oIbDgMPa0Zt8M?=
 =?us-ascii?Q?lHQkoRDDesERXhJ7XDffPNd68kVBP8VDHIPNfRAoxg3inquRvwQD0IjI27H3?=
 =?us-ascii?Q?V7Hv+wcDOlIsy9qFGpWn5UZ9FrVn8BTHklCtMwQv5zH6nr16+Mg2TidFPyOW?=
 =?us-ascii?Q?LekKZWMCvvlDM72iryqc4D24nimuMZ6+HvIS3gcgfiGgIfptygoPJmoVxD4e?=
 =?us-ascii?Q?kYoO0Cr9Ecwerirn/qRII0hwZK5oDfec?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:31:45.5564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4a62538-00f2-4bce-5a7e-08dcc377eef4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE37.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7547

No behavioural change expected.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/virt/coco/sev-guest/Makefile                     | 1 +
 drivers/virt/coco/sev-guest/{sev-guest.c => sev_guest.c} | 0
 2 files changed, 1 insertion(+)

diff --git a/drivers/virt/coco/sev-guest/Makefile b/drivers/virt/coco/sev-guest/Makefile
index 63d67c27723a..2d7dffed7b2f 100644
--- a/drivers/virt/coco/sev-guest/Makefile
+++ b/drivers/virt/coco/sev-guest/Makefile
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_SEV_GUEST) += sev-guest.o
+sev-guest-y += sev_guest.o
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev_guest.c
similarity index 100%
rename from drivers/virt/coco/sev-guest/sev-guest.c
rename to drivers/virt/coco/sev-guest/sev_guest.c
-- 
2.45.2


