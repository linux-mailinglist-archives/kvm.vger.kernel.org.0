Return-Path: <kvm+bounces-48845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E162EAD419B
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:05:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 928B416EC78
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C6E24635E;
	Tue, 10 Jun 2025 18:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ng5LXkh9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43652367CC;
	Tue, 10 Jun 2025 18:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578732; cv=fail; b=INSV4OVCPUPfcXmeMFftmekaOA4o2zQPHg/rtHQMzNeS1Z4vpU3dNXtGviIH8jXJ6fMdAk3eHlGrgA4SwVFwofZv+0CL8SbTp5qc/wGF8N5QglzmtQfI1C5FDhd2OexL4iehMx6RbLoluUAxLXOPx8OZlPrDAGeql9U5IYUk/RI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578732; c=relaxed/simple;
	bh=jpWjsXp2JN+FJhGF/36PqVz72QtriBTtGUCO/JctJ1c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ritjJsFbuADXGuaryhpPfJVi+4EZyfhh9fVmCQzncMMFQKyp3f36Rj3mYcCnyal4tmWtBis2J6cmpjao7QgkLQPEk9+chYNyFPRtR8lkZD5NMlOKTu6rNCWEcvDbUsfK4XCGATz5XH5k+7IWYlFVBK6bnHezDBLmLpPsoFDflrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ng5LXkh9; arc=fail smtp.client-ip=40.107.101.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lBU+yKO3dtJ45tySs6SwFhj7uNrHkms4olSlHRTL2qHXURLSPGtAwUQjMXWUpg0+8bzGC3rn8mJCS3bGGo5g6WF45rssWB4bAIMR7ZC2xeG9wqwn2sl054eyw9tK3TQWbyvyBSE59DBn3gxqd1UYMmmQLJ4haRpEGT+Vn6WykPUUREIQejmcVZRT2hQ5GX050ru6pjXIu6JSMdo2P8KLi/u5gObNKU3Z3zwdNUx0ROkMroLP4qdTOSTrivCbCTZEQldWbv74CdI3vkkCFMNQ+ofRm13tiCh1CDuXIvpXlokzaAVXzJoqQ8Ke/GjcZNP1MrrozWxIrGtMQVD+tWSnuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2AapnTyEb3zvgPNtp6ibOk/mKxbeyJo5UAzXlDAEFE8=;
 b=daMcm8D6op5+qdVlNGMo0gtLBEQQQImFV2APR4tvG4h0iJelzj01AcvTxPP7cnCEM80+LCuZplAQka89zNLJTCIYM+24x4je6vMFrrM1SuGNiYAkefPo73OkqxW9nzESV7EDvRX623UEhWzDLc+tzYtx+58YWmcEAWymB8a0Iv+5wmM8UWcfMqIJ9Hr2H48Eo/+jQSxdI2jPB1YSANAwlkTxFY0pHlloZgT5GH1rrefhak6P9q/UfTFrWAnx6J5vCKjAMUBqOuC3vvEHfF6bnTS2rYi+wt7+3F06+w8Nw7SnYR7iLk+JVcC5VTrCEI8dxHQjTnRBj7AekO9d+/xBuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AapnTyEb3zvgPNtp6ibOk/mKxbeyJo5UAzXlDAEFE8=;
 b=ng5LXkh9nR1+/3BjTojyYBfmCAEdPP5dTCtRm6JUq50cKJdJS6AvgLLFwnjka3Ne3dZMh16mAMZHuDoJLcslERdxjEBq0fiUIxEOpZXBmtbFWlP4+fwcIkE6G2giPlejQWOev2Xln67gPz5ekqpyuLtN+kRg0djZmP0embvY2C0=
Received: from BL1PR13CA0164.namprd13.prod.outlook.com (2603:10b6:208:2bd::19)
 by LV2PR12MB5965.namprd12.prod.outlook.com (2603:10b6:408:172::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.39; Tue, 10 Jun
 2025 18:05:28 +0000
Received: from BL02EPF0002992B.namprd02.prod.outlook.com
 (2603:10b6:208:2bd:cafe::ca) by BL1PR13CA0164.outlook.office365.com
 (2603:10b6:208:2bd::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.19 via Frontend Transport; Tue,
 10 Jun 2025 18:05:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992B.mail.protection.outlook.com (10.167.249.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:05:27 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:05:20 -0500
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
Subject: [RFC PATCH v7 29/37] x86/apic: Add support to send NMI IPI for Secure AVIC
Date: Tue, 10 Jun 2025 23:24:16 +0530
Message-ID: <20250610175424.209796-30-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992B:EE_|LV2PR12MB5965:EE_
X-MS-Office365-Filtering-Correlation-Id: 04eb1afb-f22a-458d-8128-08dda8496199
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LkSBv+k0czPIrHHulhddKx6CtUiSrwCsJtUcW92bVt98G1ed105+E8UMPv3q?=
 =?us-ascii?Q?SwKGfmOZjMHkQ3PEMeGc9Jly315JshaFmTvGi9qR9l8PAGOLmiUGnlQWoeyT?=
 =?us-ascii?Q?d54QKBNce9PZEajrSy0plmDrNhLDhClNCLMt1zSJQUO44d/nv8JGQ+eHwOPF?=
 =?us-ascii?Q?+I3jk9roCpVQt2Do0hHJo4654FBHCix4EoIaB8vnDoNUotWSFM5cGIKvVg0f?=
 =?us-ascii?Q?YLNhRL67P2GM+odzAsOEjmp5q3ZL6UsGmLa0PQ9RSmReb9ArjnlnrLestZ48?=
 =?us-ascii?Q?zbScR6iQu8FB0pmP207ggeZqy6RezwfqkjgV5jOB0S+T3U0U5OeQ9VniMS2i?=
 =?us-ascii?Q?8ANQhUBMgd5wpfeBBZVX8b5Ly/6KMrC5OeGptoCvpxJIBDh8YnYmhliinXPf?=
 =?us-ascii?Q?jUDZA4mugeQS9lHiE/5vMlW/qO46fenPeP0WRbvn6zYD5iQ1u9+ePcEgIuSL?=
 =?us-ascii?Q?GxCnxxyIsEAEVGhIHrky9fhWrIBJ94hRdo3s/x+7X0tKKtFq/3LZSFGyxH8J?=
 =?us-ascii?Q?KJo2kCFaEc5dSwPvFmW6gu34SnTWMUDr4CwOFD0CpAif5tSfpOhRVDgvwLQj?=
 =?us-ascii?Q?ZdG7Mf4OASsxG+SabUBdEgAMTWbX6prgyYY/kpYDZNFz5yRpxeOsYzHIHIj0?=
 =?us-ascii?Q?8KuJ68Z8J9KQxjAkgWhCeGSsys5zK+ACXlU80CM8N/7UuR9pexofJ969i8VW?=
 =?us-ascii?Q?BHGg/P9SM9dizRNFewgrHLYPPSByttIEummykjReMEiGuSF0aBpBEYt1HKec?=
 =?us-ascii?Q?+UFUORCo/JRRc+XetmOjHOB0ehs/sVFNT8jWxYsKpye+jA+WHI+h/z5/J7zw?=
 =?us-ascii?Q?+566kMMvBQXrFmdCW5qoAskoV7W1B6DImTrDJMgmmXgKqkyjixT0n6FmBqmC?=
 =?us-ascii?Q?5mp+ec0tduT1+nIrBdiWoKfEQ6BGDDeN6UR6HykTL0mj0tRTVlTrE5Q8e5T7?=
 =?us-ascii?Q?lxSHtbrJJooMRMdk44BCxkTq4A9EtuIf0f0MvNGJljs83JxYNIUCjWRxvCcb?=
 =?us-ascii?Q?RhcD6iWrTrnEdK1Uf/WuszMImUo5+sZCgz8bGUKyj5bMejWuRoBf9CXlLr8o?=
 =?us-ascii?Q?QD9iIsamfqLI7ZfVPYXzYdX9UK27uTm2Hmr+aectg8Qe+4zJxIrxxn6/q1Sp?=
 =?us-ascii?Q?mIan+aJiyx71GR2CnIitY/C3PTKWfbCJMioUi/3dP4d77zNJGqLjUfPOm5nK?=
 =?us-ascii?Q?RvMrIaUT03RiMcP6SKjthnHiRefCDMWV3Ja1FRE2YNio7LDiwiuHSLCPds6x?=
 =?us-ascii?Q?EljSsRSVhe4X4gVaQLCpUaIUoxnKDTmU0z1l0g+whkBXzu3Gp+otte6YYO4w?=
 =?us-ascii?Q?NOqvKn84+V5YEPHVxhTPpA//0poAuSoKupJ9BLqJSuMt53EhKrYRDFy0vYQI?=
 =?us-ascii?Q?VioiiaKJdvTkzHJ3ndvMGjc/2I4tQOT7wsv7aaDNQuqfIyVA70flrFh+Dixy?=
 =?us-ascii?Q?pAuVrCdlWf+L/DzOs4KWuXwyRHWjwfduse/qvbWpD5TRu63yITauAc31yJ4H?=
 =?us-ascii?Q?9LA76UI0OFpQd38rkGnptwIbTCdSUUFZmYqs?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:05:27.9577
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04eb1afb-f22a-458d-8128-08dda8496199
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5965

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
Changes since v6:

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


