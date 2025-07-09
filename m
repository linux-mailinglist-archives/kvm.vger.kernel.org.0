Return-Path: <kvm+bounces-51861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DA4EAFDE69
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:43:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EBAE07B9635
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D3820458A;
	Wed,  9 Jul 2025 03:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FEMwrz4g"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB03D203710;
	Wed,  9 Jul 2025 03:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032489; cv=fail; b=qgLnDdVUUi9O3qFBQnSmQX04qXyg9OHV93BwEwqPUxel008KrhZSepg0mtx5B78UbTfykCFZ5D8+/7pdTqX7hfBEJqz25gPGicFo662UKuIIwvbNTS4co0832UKwVwG+JaiN98+Utz56C/DQUfyoKC2z9EdTXQzfKWoKuBmXeqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032489; c=relaxed/simple;
	bh=M/UKeHL8np2vmCjWBmbaEdrINO7YA8tz854m6d0rDhw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WPAXdv3ZAmWv+ETFw4+nflE4qBE/rN+tTQN6bzOFiAlFIkr4Zh7NSS2zai0rOFpj9/ilacuUbH0O/Phkd//CR1oZxR3A1pAQXhiH8pl62Ky08FVHVunKyyM7J6V4mqJcsIbzvD5kJ9kjHa1Isyol7PmEdsDXS6p9H8fKx1AsXiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FEMwrz4g; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jr2IlXL+3huqnaZu1ELHp/4N+ZxMUVpPQ8OSFHiWwr80cEYVeOm49fWNcbpbSZH++QenwEh4XIJowHUHr+kaL9QLWlWoWA3DD0Bs551rkcZutld70a7tpi7ryu9azh1Jkz8o4rNvRo+BLbE8Gvb3w+R8P+SXwED8wDIm8yn2SHJsFWP4zmO/w/cEn6cb1WL2Zckunia/LAbAnP0IHdmpwA4QcUgrKHz3X2ZTzr2YanVCNI7w+I74iOtvsHkk+rK1Yi4jA6Bq0uTl62ehQayLyJ/IcyZAFUH/7MkYgH5XHDmwi87AeXx6rWu4etAVFfc19K9XlLWs+k08JRswKUp1Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jrs5GSN4cvtGWu49fDenDeET8NqvxI6IGxdEXqnqKSY=;
 b=yvacEcZze+CDXYtztrPbv6Q5LOcUjnzFdbWPs+qkaDeW9A6U09OI7wkf0mU4eQbtEOdTdIRBkFdGPi3PyWnExO65spY+i7gcn80orwlaT14DV08ZKfa0EN017jnuU8B0P1c1k3GbeF7Cvl4uJ5z0PfPapsFVRArM8BoWNiWmjISindK4BcCcQTGRUXeHyGg6hv3XU2aj/NIzh47hcWXiaZeqP/0QJCMxFQfvVtDUs6RvFElciQhBFXT5gjwN6o4mQwDTBNQZOQiKrlLKDBsi3l2LUUTVJYhNvTaPj/jvxFyV8S7O82DGtNY2qyYkYK2hYMebLhuFabvoNI8Szg6IHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jrs5GSN4cvtGWu49fDenDeET8NqvxI6IGxdEXqnqKSY=;
 b=FEMwrz4gzBIsXOCmZ9V7qEtNQMiaaP3RnDzkRpaB+RWgnW79mCCjYVz2GbD5Q6EeFvei9Qj6FYW6JGqZDt+8YHSkMsR02DzQoYNdqSIS/4YDv5Wga/X9MFKyAekhZbnGw9mao1xIYb/Y/Lmtda0X2eZ/F/hvZonxow4hwVI0swM=
Received: from MN2PR02CA0025.namprd02.prod.outlook.com (2603:10b6:208:fc::38)
 by MW6PR12MB9020.namprd12.prod.outlook.com (2603:10b6:303:240::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 03:41:23 +0000
Received: from BL6PEPF0001AB50.namprd04.prod.outlook.com
 (2603:10b6:208:fc:cafe::bd) by MN2PR02CA0025.outlook.office365.com
 (2603:10b6:208:fc::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:41:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB50.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 9 Jul 2025 03:41:23 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:41:17 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 27/35] x86/apic: Add support to send NMI IPI for Secure AVIC
Date: Wed, 9 Jul 2025 09:02:34 +0530
Message-ID: <20250709033242.267892-28-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB50:EE_|MW6PR12MB9020:EE_
X-MS-Office365-Filtering-Correlation-Id: b616861a-6c8b-49aa-4100-08ddbe9a799e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cv8hP7+orzmCXoMbhr2E0/L3KBtqYYs719+gUG4y++SD/xH15WzxGh6XNyFM?=
 =?us-ascii?Q?dp2VhvmpSJ3oB2pkj2FjcKBeeR7OdwBjAOVJOVSOW7d/phD3J9faIoG44rzb?=
 =?us-ascii?Q?a7Qr+nzm6eZLQcw7BeBBkKTgxHs4tF2inVWKytKq4ME5su/5nC3WyOVzGopm?=
 =?us-ascii?Q?/zL9bTE0eEjeVH3S6on3OHUGOYu1uxCcfO9nKbWN7dac3cx0C0ast+JtwM7V?=
 =?us-ascii?Q?fkl6OKeoAQO2HwG8lM7sEqAbzMVu0TpQBaHj+d2JHg7FefTWE+33EJPEvUmq?=
 =?us-ascii?Q?o/b0tRUfxJdoUOyI77fRiloMS6rb4SRiUqDnAjii60Kt1SMQ+69vVyUV/OVx?=
 =?us-ascii?Q?3UYT9l1BGsCNG/nwlLr+V9VdOI/M22+KG39D0iDq7yGCkb/mB3TokaH4dSXc?=
 =?us-ascii?Q?KC/x2kwM+qJOf9yKwjXuLkfrTWvaxLoO1j105g7IVxtlENoIZ7seh2kJe/vW?=
 =?us-ascii?Q?gy9jq+xBtBnR2dSiZTK3Zp3rwJ2+udtpA1xA3Bu2waG8ZIZ4H9YlV+v3GSj9?=
 =?us-ascii?Q?45jAVSE3EOEbBF2Z6reBb0Eeg7la+remuo44V07zoxxee9BStWtClBrleKFC?=
 =?us-ascii?Q?5/tfYDp3ghG7WNi0sS815KjoE99tG2GLASyv/oUOVqpybgsAq2lPFTF/KNC7?=
 =?us-ascii?Q?Gp7I9Ic1KcB5cPKWB3p9Z4famYxLwoMVow8g9lGfmTkYLdxeinLPvnGQQYpU?=
 =?us-ascii?Q?2anz6KJPjtjY6Y6pA1DwsTeBzIkN3YUptzeAgnKfKNCMToAgGvTp9cm8yR3i?=
 =?us-ascii?Q?neb8K2NsIO3DBoiImTf7pLPW7lxczTYhSrirTcVrOybIpMA1pJvGRBnglz6Y?=
 =?us-ascii?Q?t+stH0B1J0qdS0QGpaUiZ5FPv0hgnCAVVaPA1gCltw7FUTlSVtb6ALcw0uAc?=
 =?us-ascii?Q?WGgG9A+f5+Ly6Zud4YPjMqgsrl2lN45WLscEHPvGUNGWVHiOyOALjZHIQ2QN?=
 =?us-ascii?Q?kCn2I4ELpxzwOPBD55x6XXLie4LQAq9+btwzj0vSJfQ3vQqzwpskVKSb4XBZ?=
 =?us-ascii?Q?08MxzgRjik0tFE81yDouezqLIjTD89zgU0XiqeEy+Dcfcv2bP2oRomVHUeln?=
 =?us-ascii?Q?tG3tQGckDVer8ugXk9RMrQ2Y0zg9EftD8LK/auVJFX6BY37Cck7TCwkOCRK/?=
 =?us-ascii?Q?Jdm49urwclmtGhJuQ17SEzGIRJs+7T2rZhNlgdVaI6pCfETSY4aBM+Bf0HuZ?=
 =?us-ascii?Q?orQzruuHgvJndKc9rfH6vNKrY1Lnm5uN65DGznjOVxJ3svShnQrwvOv4aRLq?=
 =?us-ascii?Q?rpmSLyODKR9ByxPqriqjtiCAUJrTSl2SFkshFgI/KgO3kjLIZA4pymNwgSjt?=
 =?us-ascii?Q?YAYSp/IV4Uqos1WRM1yvU8nW4GwssOgUhuRVQLAd7m8GbnOJKN3qJxCKlhks?=
 =?us-ascii?Q?AJAprrVlJZjdZEYqo4R3iO0FH6Ds5I3HsYstFdL1P7fqJd3BDMrJXhom+FPx?=
 =?us-ascii?Q?dkefH1fX7AZrrD/wiUF0XaTyDJfrxhsuL4KxPJFLrpTE5zi+YwF3AkU2hJSg?=
 =?us-ascii?Q?8txcWAE+V+251lxzMb8Eh6IVcLPIHAkWmLLZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:41:23.0690
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b616861a-6c8b-49aa-4100-08ddbe9a799e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB50.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB9020

Secure AVIC has introduced a new field in the APIC backing page
"NmiReq" that has to be set by the guest to request a NMI IPI
through APIC_ICR write.

Add support to set NmiReq appropriately to send NMI IPI.

Sending NMI IPI also requires Virtual NMI feature to be enabled
in VINTRL_CTRL field in the VMSA. However, this would be added by
a later commit after adding support for injecting NMI from the
hypervisor.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/kernel/apic/x2apic_savic.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index e5bf717db1bc..66fa4b8d76ef 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -122,12 +122,19 @@ static inline void self_ipi_reg_write(unsigned int vector)
 	native_apic_msr_write(APIC_SELF_IPI, vector);
 }
 
-static void send_ipi_dest(unsigned int cpu, unsigned int vector)
+static void send_ipi_dest(unsigned int cpu, unsigned int vector, bool nmi)
 {
+	if (nmi) {
+		struct apic_page *ap = per_cpu_ptr(apic_page, cpu);
+
+		apic_set_reg(ap, SAVIC_NMI_REQ, 1);
+		return;
+	}
+
 	update_vector(cpu, APIC_IRR, vector, true);
 }
 
-static void send_ipi_allbut(unsigned int vector)
+static void send_ipi_allbut(unsigned int vector, bool nmi)
 {
 	unsigned int cpu, src_cpu;
 
@@ -138,14 +145,17 @@ static void send_ipi_allbut(unsigned int vector)
 	for_each_cpu(cpu, cpu_online_mask) {
 		if (cpu == src_cpu)
 			continue;
-		send_ipi_dest(cpu, vector);
+		send_ipi_dest(cpu, vector, nmi);
 	}
 }
 
-static inline void self_ipi(unsigned int vector)
+static inline void self_ipi(unsigned int vector, bool nmi)
 {
 	u32 icr_low = APIC_SELF_IPI | vector;
 
+	if (nmi)
+		icr_low |= APIC_DM_NMI;
+
 	native_x2apic_icr_write(icr_low, 0);
 }
 
@@ -154,22 +164,24 @@ static void savic_icr_write(u32 icr_low, u32 icr_high)
 	struct apic_page *ap = this_cpu_ptr(apic_page);
 	unsigned int dsh, vector;
 	u64 icr_data;
+	bool nmi;
 
 	dsh = icr_low & APIC_DEST_ALLBUT;
 	vector = icr_low & APIC_VECTOR_MASK;
+	nmi = ((icr_low & APIC_DM_FIXED_MASK) == APIC_DM_NMI);
 
 	switch (dsh) {
 	case APIC_DEST_SELF:
-		self_ipi(vector);
+		self_ipi(vector, nmi);
 		break;
 	case APIC_DEST_ALLINC:
-		self_ipi(vector);
+		self_ipi(vector, nmi);
 		fallthrough;
 	case APIC_DEST_ALLBUT:
-		send_ipi_allbut(vector);
+		send_ipi_allbut(vector, nmi);
 		break;
 	default:
-		send_ipi_dest(icr_high, vector);
+		send_ipi_dest(icr_high, vector, nmi);
 		break;
 	}
 
-- 
2.34.1


