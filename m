Return-Path: <kvm+bounces-48828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A5EAEAD4169
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:00:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA6AB1893802
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D592494F8;
	Tue, 10 Jun 2025 17:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XEJJSVto"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615B524676A;
	Tue, 10 Jun 2025 17:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578349; cv=fail; b=exEEfH7TMDyIoAdSWsMRj1nuiIDbHylvdjdvJd0Oa9qvEo6e61X8FvhwTMkW9R3JxsIJ+YqqwV1ivVPYYYdnyWxx5/uLuISyQ+ccfxO1SC6qLeXAJoqQL5qMH5SABRJekM6psUQIsvvjDpF5byppDg3xLEjXCWULT386C7oAZaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578349; c=relaxed/simple;
	bh=bP2mjtcUGYJKoLP0tO8rLRU03nqoC+kzgb4jmBLIeKA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C6dcWuFaTs9yyWirCxt0cHnBPhA0pE/MN8ZS1NqqTycu1abThRQcdAANCr6BxFcI6a9GkT7Cj/vy4NZZSQcGzRQ/HTxBT4eCQ9sxg39JnPTzrQfB/sSmBw0QCkBoaHgiHxtfzlDa8W72VgyYk3q+uty3DY18R8na9IOqMGS4Gz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XEJJSVto; arc=fail smtp.client-ip=40.107.236.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LHTfObNPRvW4dLXC6Wn0CayBjZg0gNBc+jt9Ovr5sATP32AtuxLF95N182lUy9gdfzgANbrH+KQfADE1AtPwEwQa2Uel3fyJws4heaU3GubZYW7LXTZNUCjPyMtl+zjCy7nbDh4+sC5U87wj6I8OUhaeeGuHj2lMr4gPLebRqrXMSCzbSkya17Cj16nSCJTJiHVGNNrjS7hjnUZDheH4KU6il/vk3fOrtP0f1SD8cG2O4z84OyqhDn8wVaSauhH8L3C6+SSfnaUph2rVF3C47qfna0a02XIM2LXoIKaSKU5GrNLCubvEYebrVHuRqk9e2HYgBP0cvE9km241F0kGEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZyPZoHd199o4amWgiGzJiidSE44w+tsDqV3vEW4CRQ=;
 b=ve9pztAvj56FnzD5ZOdNAs19rTwtFBngV1HVmC1LeReypHjCXHBcA1eOosZo2NMaAY1L9vlFd4r9wx5763V1KMhTqEJ1y7FlblInoC/wNAYY6WQQpVp61OPgrQGuI0MYgG4/hp1avqHQywe/+dqhI+5NsFrtidNCW32kV4ncvFZlSuwS0ndylKDqENlAU7AcjiVvye9hkgHYIhmqOSdYeT6mbEfnOYbo4oGXi5B9VPBwjDZ6+oBLK23hdaoggzTkhE0woLCgCEUsU2kEchWMLpfl0aE0bfmnRuNvw7do7MmVjK66l83gN22Wh5swWLBQyBUqcdfg52IqpjIuuZRAAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZyPZoHd199o4amWgiGzJiidSE44w+tsDqV3vEW4CRQ=;
 b=XEJJSVto9hQ8+K/eH2d5/0Tf1J2ORvqWjGYu33B67ZsTTKK1gJBss8EZn8bBWuuy9MFwuXRBDDmBgb4zq7C8mrZJxKjS094rSjr+2977yKKTvu3aSr5lKZygrZ9ubBS49TCHEVlwCUZ2NViLh7HzUe5qHw3Fc/EkpnfNTtLh0wI=
Received: from CH5PR02CA0020.namprd02.prod.outlook.com (2603:10b6:610:1ed::25)
 by SJ2PR12MB7797.namprd12.prod.outlook.com (2603:10b6:a03:4c5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.35; Tue, 10 Jun
 2025 17:59:03 +0000
Received: from CH1PEPF0000AD7A.namprd04.prod.outlook.com
 (2603:10b6:610:1ed:cafe::89) by CH5PR02CA0020.outlook.office365.com
 (2603:10b6:610:1ed::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.27 via Frontend Transport; Tue,
 10 Jun 2025 17:59:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7A.mail.protection.outlook.com (10.167.244.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 17:59:03 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 12:58:55 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v7 12/37] x86/apic: KVM: Move lapic get/set_reg() helpers to common code
Date: Tue, 10 Jun 2025 23:23:59 +0530
Message-ID: <20250610175424.209796-13-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7A:EE_|SJ2PR12MB7797:EE_
X-MS-Office365-Filtering-Correlation-Id: f86f5406-576f-4bf4-cc2c-08dda8487c32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YHrvvr5tV5d0d1S5yKFjcY1JcsyDyXIVTshiWNRlrlax/kzUlppzqUkJ36UB?=
 =?us-ascii?Q?5dOp/g17jXYieyKaiCRAhSQmRG/sF7OLNp8KVSwhSguyt169EMop/zpU+Nux?=
 =?us-ascii?Q?1wC+YuhdCfB01vuFovUlAnrL7epYU69bM5qOoexhZBuq8YXqKE8VauH7QW4t?=
 =?us-ascii?Q?clsn6W3P52YSg6f/kuDk/uKYrY3ySNWsiN+Sq9WdRmeSXg83xKZbycBoiven?=
 =?us-ascii?Q?VfWQgUJvHYGthzLINSqIAwQL4/UFKnn57FnLS9X9eTl85urJJQaO2Ne8SyyS?=
 =?us-ascii?Q?aZlQ3/DWDvi0uMBpehb596gaS90ITHA34koCjeMJ+xq66sBobIsL/QhyxQOJ?=
 =?us-ascii?Q?o4cn7cw48ofo9Y/4ImkocXzU6VEWM5jMpGU9mCmayV8/zdq2VbDyzlZfYFPF?=
 =?us-ascii?Q?XYHyoOWycTXOqqyth9P8va8I8xeiQUtKEt1XpUIo2ZKVFc88gXuF4BiEo0WF?=
 =?us-ascii?Q?r2jrxrzlRQmSI+J7NWpEOFUQdRdqpG0OkQQzbvr1yH9y3HJterbUzAu/Lkdm?=
 =?us-ascii?Q?GfG2ir0BgKjFSONjAfFDvgvWu2lMG0vZFr89tTtnLVAwj3ujZQ3/ZSPmGSAx?=
 =?us-ascii?Q?nB0FrUIJjNZx2PLq9fXiNuPe/LGYLIiDxP1Hrfwz5dcif0dQVmJNhdcxgEip?=
 =?us-ascii?Q?C7PB8b2Mw8OUQ1si55nlpZoHTYHMiVFW6HjmF2p24ujJn3cEUgjQAFTkur+S?=
 =?us-ascii?Q?g/ji3uXu4hgzyGC9wvGywjuUvZEgYdXKb30IGCcgrP6Phe/7gmk7GZ0Q8Fhk?=
 =?us-ascii?Q?sY47pFJFBTKe31XvuS+PW7+40/z0xoOGc12HOpZmwCqryMiZm49nldukSKt2?=
 =?us-ascii?Q?SBc64WcAvHRAJfyKfE4GU71KAjxcehHjnk/KmJ9YYtUyAEogH7veqCENJlRW?=
 =?us-ascii?Q?n4fWtAguOptnbuJ/kdfL6qimvG+SArSSafPKaKPtfZk27/mK13EalHCv63gh?=
 =?us-ascii?Q?SHeVAHOCzkGTxvk3V3kdoM4zE1btlQrcfwh0zBt8jf63sXSkE+vb0wehQIhw?=
 =?us-ascii?Q?EVBcch097yhNMYfWo2/+4dyCep3qWHkixdMUezZiXPdqE6PiFgqmfFGVNI8q?=
 =?us-ascii?Q?OazWXE8vK6VM/bn9CG/39c1g7jmElRSQ2RRrDsNkj+LjGe/7Ad4Jq6ZYBxAh?=
 =?us-ascii?Q?8JeLwf0rzT/u+UcvHCfjLwg9Gg7xPlOCi59f0uscRKIPNfgjtLY3JdX+y5m1?=
 =?us-ascii?Q?irAxXj/ECOe++9gdE4NSowqk6dYT3bC6wPYn9H8ePwwsFzjI5nRYNAqcRqyq?=
 =?us-ascii?Q?DCILC6TgV7EHZUSaTPMKw66AReXs9oAULau9/1b8FFlKXnDPC/BGqcA9fb6t?=
 =?us-ascii?Q?l618xXlhTCy3AWJria3/HaxjnHLOUSz8wVmkKkuIaAwDJ5ycmupWy3gfrCUu?=
 =?us-ascii?Q?dbutTsjv7sA2Ln31z6lTYRetmmOR4GeUbApTby7+kHwtT9TR/1G21aTcOY27?=
 =?us-ascii?Q?4OujTVfNsVg/oiSqGwQeWK2N8qR9nvh7WFlNvoFCTHMgIx9AgulRH3Eyc9dJ?=
 =?us-ascii?Q?XMsCbSc9u/fQJ5AfRlaNihFPRJdzfOA111ZE?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 17:59:03.0756
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f86f5406-576f-4bf4-cc2c-08dda8487c32
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7797

Move the apic_get_reg() and apic_set_reg() helper functions to
apic.h in order to reuse them in the Secure AVIC guest apic driver
in later patches to read/write 32-bit registers from/to the APIC
backing page.

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - Moved function renames outside of this patch.

 arch/x86/include/asm/apic.h | 10 ++++++++++
 arch/x86/kvm/lapic.c        |  5 -----
 arch/x86/kvm/lapic.h        |  7 ++-----
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index c7355bcbfd60..904029f6530c 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -525,6 +525,16 @@ static inline int apic_find_highest_vector(void *bitmap)
 	return -1;
 }
 
+static inline u32 apic_get_reg(void *regs, int reg_off)
+{
+	return *((u32 *) (regs + reg_off));
+}
+
+static inline void apic_set_reg(void *regs, int reg_off, u32 val)
+{
+	*((u32 *) (regs + reg_off)) = val;
+}
+
 /*
  * Warm reset vector position:
  */
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f94adcdf242c..b27f111a2634 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -77,11 +77,6 @@ module_param(lapic_timer_advance, bool, 0444);
 static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
 static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data);
 
-static inline void apic_set_reg(void *regs, int reg_off, u32 val)
-{
-	*((u32 *) (regs + reg_off)) = val;
-}
-
 static inline void kvm_lapic_set_reg(struct kvm_lapic *apic, int reg_off, u32 val)
 {
 	apic_set_reg(apic->regs, reg_off, val);
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index c7babae8af83..174df6996404 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -4,6 +4,8 @@
 
 #include <kvm/iodev.h>
 
+#include <asm/apic.h>
+
 #include <linux/kvm_host.h>
 
 #include "hyperv.h"
@@ -165,11 +167,6 @@ static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 	apic->irr_pending = true;
 }
 
-static inline u32 apic_get_reg(void *regs, int reg_off)
-{
-	return *((u32 *) (regs + reg_off));
-}
-
 static inline u32 kvm_lapic_get_reg(struct kvm_lapic *apic, int reg_off)
 {
 	return apic_get_reg(apic->regs, reg_off);
-- 
2.34.1


