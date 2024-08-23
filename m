Return-Path: <kvm+bounces-24917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C568095CDFD
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 15:33:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47D031F2515D
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 13:33:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 403D9186E3B;
	Fri, 23 Aug 2024 13:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RMsNzXBs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2086.outbound.protection.outlook.com [40.107.92.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071FA186601;
	Fri, 23 Aug 2024 13:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724419982; cv=fail; b=N8SQR0DRFwtGlTKKWe0uwS9YnZp0qieA/GwFfc9P9lJHsTm9bZRyVdYYX/OT2rxB+EL4EKxcwcmpg3IUJeH7tk48im3/wUzZFRQBr7Q2/Q586DC/Cce53npcLHR8rNp8y4MSyJaVhpH5xb/7MyMDljEf5hj+QUxNwYY8HNj1SAc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724419982; c=relaxed/simple;
	bh=Eq44PkT3ADjMRLqYUFXga48zo89H84TBBL0gnuwEo9M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T8iIySVsU/CJkJI4b9kX3I0c6D17xRXOKPVPH2vU4vd67qbg5z3xmV0SYRrYkI6mOHZjeRurXXN4vC7qALoiw3zx8WdfACwrsgD55sAg5q4Dx6QgT+597LuKQrBIvvpZSyjBMkvSb7JcrIwcTGGbpvEDvYyTYDjDK+XsoPCURvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RMsNzXBs; arc=fail smtp.client-ip=40.107.92.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FK7zHoAYpUE8QfQ9prKCAh5l9Ke12gWeN4ZawHvTtSd2ZdHUqHGzgBXPIOzER5P7r8glKB2FXCzoTkd0dH7VlJdaIzhVQqFAd8kjDS+5ZtxXLCtYa3b97t4G2m20T19I7w2HgEe5MJwY7Uhhr5dVqqJs2T238haUAd3USrYoEeKo8gGQaE1G2FTsyl0HU67gTjZFSzki2uGdWBNm2XsEddykth+CdsVTLdbSwaZVZPXZIgGLV94/vEAYQxkOLs4sXd9qgOjt1jaxOp+D7mrnWajJeOBGvjPS7ezL5yTZcW7ImeGcLEmf5zf/f5gMCP8AtIeVZ0lXThmY97efb9H4uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y/W368HCkdO/hjl2kvedwv1N0vOGYLmDkplLP4qKUcg=;
 b=ZxGOk/6045N/sLTL5NBMpIYzfay6iptos/rnI3fmjS/Zbc8i7LBKII5Z1TghpHrdyd2GmXAwG5Lmudh2orQXe115YaQQBHWe77nrnZs8rfvOdsy7H2dqlIGaDuEWZx1qBQCWOV8W6NcRCNIROHhmuArCyuQDRKa5J0leTtLhpkZtF/cpmI9X2VL1ZgtcRb3kCUxM1i7JD8NugKzdKDvOS3CXDm00GJwmKDRnRzNkwLp1ggnn7C1IGvoNbutKJIfwqQnZo0Ai3Bu7K8k7HZKJnEQZTys0+G7TW09UoOp9qjXUCAE1uJk737abucFM+FSWP6+gak46292xT3oFT2eWpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/W368HCkdO/hjl2kvedwv1N0vOGYLmDkplLP4qKUcg=;
 b=RMsNzXBsmzZmmZeXCFCXQfOYqvzEGXWC87ajwnyx5OtLil4fV9C4bxs70YYgBlZhGcY977irhsYEnxTAyW6XJ3g1vROzB9GkbAjG5xL/hu5ozE5s4mxNLpwelA3BGrB4ug24ljlc3FluIOZLA7kETC4bFbVU2fE3/n/bd+ZNmDc=
Received: from PH8PR02CA0019.namprd02.prod.outlook.com (2603:10b6:510:2d0::27)
 by IA1PR12MB6259.namprd12.prod.outlook.com (2603:10b6:208:3e5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Fri, 23 Aug
 2024 13:32:56 +0000
Received: from CY4PEPF0000EE33.namprd05.prod.outlook.com
 (2603:10b6:510:2d0:cafe::fc) by PH8PR02CA0019.outlook.office365.com
 (2603:10b6:510:2d0::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Fri, 23 Aug 2024 13:32:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE33.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Fri, 23 Aug 2024 13:32:56 +0000
Received: from aiemdee.2.ozlabs.ru (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 23 Aug
 2024 08:32:50 -0500
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
Subject: [RFC PATCH 19/21] sev-guest: Stop changing encrypted page state for TDISP devices
Date: Fri, 23 Aug 2024 23:21:33 +1000
Message-ID: <20240823132137.336874-20-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE33:EE_|IA1PR12MB6259:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f63f5de-790e-432a-8e6d-08dcc37818ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NdLDRN7ajAUunRlRjWySkiJ0Ebe8IzXEgA7HA30qy/sJJ7QfnT6W3dS+WK0h?=
 =?us-ascii?Q?F+gfozIQW55G+5byPKeMPPAETPvHpYYZyN2qo4NBGeVqEynyjCqm3vOTEZ9f?=
 =?us-ascii?Q?9jgj7qfPc9BMGbDHOeM+rmbP6q1m/LdTpzZ7GyzbtXCb1aZMtfUNfCF7BAl1?=
 =?us-ascii?Q?1NSCnQqPX+UoPPXbFCAaesO0HObdsf1c7iuoaW5PIF0r4jyvXCtZU10oGVqY?=
 =?us-ascii?Q?kCZg4LASWaB6VoYWCZ+ANsTo6jkXXHdnCvCzUb2CnLOj0CNMxFKT6ipSE3Op?=
 =?us-ascii?Q?A1hB1SLsmwPdNxZi/rfUKuaVoLSoQHtzjo3khIyC9wMTtObE/0IxsO1coXYM?=
 =?us-ascii?Q?e2NNdP/L1qLmjNnLvL9/g61kGmdP71jrss0AfaDwdz4J8BQrZiPbZRJweJWk?=
 =?us-ascii?Q?p1aw1ID3Z+OCMjtGx4vd1jsXFuAmhTKR+XVlL0T/iV9Ln1jck0l5kjBvyoZp?=
 =?us-ascii?Q?XJ5KS2T9nsoX19nZZI9QW/2DAEndrlxOZYPqNaGoRtUjJu/HarMGoxqvhIn/?=
 =?us-ascii?Q?CE26+V9pIYMhbXgxB4WESIzHXGK0cPJM5qnBLxPDZgWoGSfaxBU9gTNkmCxS?=
 =?us-ascii?Q?UM0BsW9qeH1gTpMUVHQw1GbNwAwuRwV0smyc4NgudaA9s0xm4gVwBhr71F9r?=
 =?us-ascii?Q?gRnGCwilaMELaqTVUqyAQWk0aZsQMcRHTs2QsP+oVqb1SeM5g8bmyAE7V83x?=
 =?us-ascii?Q?Hjenq6qDbfJj2YEDAp6EQfoCBg7s0uWBtmGkvEXDYEv8nQClWkEZDco9G4Pw?=
 =?us-ascii?Q?AtXvHisVC6tAe5yxDRSU0ofFSz5YA+a0Mx2CZXPgKliMG2a6XMglgRKvTaBZ?=
 =?us-ascii?Q?baak8nbvsX1FFdQW6iOoVHDKFVf+N2BvRATfPK10RDMJ5PIdHh0mMy2fkMUS?=
 =?us-ascii?Q?Cu4VIFrUiBTTH5OJ4/vAtjsLOAbnGpidP1wS4/gbO6UfKV1qXHNZMpBpCgA5?=
 =?us-ascii?Q?onnC/XpD1+V3vIafdOZmrw372tXa+jGT+TQQS8J0l2HNjAUaDZzBiJ4/CgqT?=
 =?us-ascii?Q?ilWlkGHM6Xuli1NXXuV274HKK+oW+cBRA8yVOyoFEhdJT1fzPHTf1pce5BJy?=
 =?us-ascii?Q?tWc/TH9JGdEq1kZ+Sj3UfuUGGgM+VwAJVKGfVOVAT52Jr/ogcSiX5mUZ4upj?=
 =?us-ascii?Q?itSZkUy4h0uyqKYlUIW2fHe/k+jGFkkqnANWTniFQ7EaICczLmWnWOdoa29x?=
 =?us-ascii?Q?X4D6npALV7npccbPhkumHTbwQG/cNHPOeW2LKt6EBwfJtyGgKwRJ9UVHvEzg?=
 =?us-ascii?Q?tuDQGqclw+QyoHMcY5JbG6xOSwEdSNfEnReO1yVPU61DVA9jSaO7kkMNA6WG?=
 =?us-ascii?Q?RTGZV+k5wtVaASCWK4lxVSGIP9LeIAjW90TmH0k7i8CFCPRPFa4NoPHV2vAA?=
 =?us-ascii?Q?VUxpVZeLMVK92Sa8AFTOPjK15KHsPfVvG9+mEqDBjRNKwm5cz4jS30LNv12N?=
 =?us-ascii?Q?w3ZI230LmSULK6LnRTk3NEkKbKPuxOvd?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 13:32:56.0387
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f63f5de-790e-432a-8e6d-08dcc37818ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE33.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6259

And "sev-guest: Disable SWIOTLB for TIO device's dma_map".

And other things to make secure DMA work.
Like, clear C-bit.
And set GFP_DMA, which does not seem to matter though as down
the stack it gets cleared anyway.

CONFIG_ZONE_DMA must be off too.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 include/linux/dma-direct.h | 4 ++++
 include/linux/swiotlb.h    | 4 ++++
 arch/x86/mm/mem_encrypt.c  | 5 +++++
 3 files changed, 13 insertions(+)

diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index edbe13d00776..f6ed954b05a2 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -94,6 +94,10 @@ static inline dma_addr_t phys_to_dma_unencrypted(struct device *dev,
  */
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
 {
+	if (dev->tdi_enabled) {
+		dev_warn_once(dev, "(TIO) Disable SME");
+		return phys_to_dma_unencrypted(dev, paddr);
+	}
 	return __sme_set(phys_to_dma_unencrypted(dev, paddr));
 }
 
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 3dae0f592063..61e7cff7768b 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -173,6 +173,10 @@ static inline bool is_swiotlb_force_bounce(struct device *dev)
 {
 	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
 
+	if (dev->tdi_enabled) {
+		dev_warn_once(dev, "(TIO) Disable SWIOTLB");
+		return false;
+	}
 	return mem && mem->force_bounce;
 }
 
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 0a120d85d7bb..e288e628ef88 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -19,6 +19,11 @@
 /* Override for DMA direct allocation check - ARCH_HAS_FORCE_DMA_UNENCRYPTED */
 bool force_dma_unencrypted(struct device *dev)
 {
+	if (dev->tdi_enabled) {
+		dev_warn_once(dev, "(TIO) Disable decryption");
+		return false;
+	}
+
 	/*
 	 * For SEV, all DMA must be to unencrypted addresses.
 	 */
-- 
2.45.2


