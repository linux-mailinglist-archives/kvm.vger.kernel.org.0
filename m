Return-Path: <kvm+bounces-26805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0180E977E9A
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:39:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 879A71F236A5
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:39:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB80F1D88C1;
	Fri, 13 Sep 2024 11:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="D450a0YX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012CC1D7E3F;
	Fri, 13 Sep 2024 11:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227575; cv=fail; b=Z/FQdbSaAp8/FtE5kyK1COd8BI8Rds07nv9lhEVPE50datC7DYgm4R9zD1sfV55b+IMdVBjCN5fucIwqNNrjAGXEzrycoqWyvmDeUpAlMedZLUBPVN5sBkEFf/l7mDSSoxVTJJUdAhZacjQfB7Gnph2eV2Y+A+TjWD+UlEtTo1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227575; c=relaxed/simple;
	bh=VRzS48gKThwjY6CcF8oSngmtwgeY2853m1MjnydV/PM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ga/FoHbVCGMbLujBUS9AZ4W8iSshC3m0x8M1l6pGWMhF+dac7+HbZBOl8Z1gsiHDLiSkX9gTvCr1Ei6yXHLxN/98OjGBOrlQx+4vDTibBGvaw2D1S5G9gLshudtV36VTusePT9uhZURLeZg3lpYNJREVc1Pd8gaAucB3qSNuijs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=D450a0YX; arc=fail smtp.client-ip=40.107.237.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bf/cIp36mMOdZpwUPnPKs9+RHGrCoU8QovHXPW5CimbGxriHf1zwGdhKTYtfTx5q9km3fYacpL+LrYMLSuqSIIHF8qYnvPXh3XnHV8Ib71mL+ya53XG3N92WXjh42dT91gnCeOkw2U3KoywQs4LYjX+Ld1qrKNpgaH/1IHPIWrYmnoS1b8mb1m73sFt4Xf2PBnT0bbMhlX1qrk1SMlj2NpNiG/HddQoFXaFd7QjWsFfHmmGtCvtGBTM5UnprZG9u7BVjFVFwjvBVVxQFMIYB6L8lesPQIFTC2TNwF7NYcc8y7pdHRJexxuAQ2PGet15VxD15dGXgTk6dYevX2NG0hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o5/bscksYkaxWOQ5jJW5pRwaSTz+EUzgYIbAgJ6gveY=;
 b=Y3nS6cza0uh9rid8vkAhGCOElHRT4DZEvaTL9Rpvs5d32bfLfH9rYAhOSoXNAZ8BJuZCNN9mNTxZydC8g6XT+gO6szrKO7v3RQrNmtAzJeh0RtfgGpSlshN1DXpNMnqA3fP5Qd1FcaY6/x0PR0kKFnVzsNCy8k1f9rBBZClaNaA4tQNdpffg6QA+sx+tutRnQQjCLdnW7pKHoIIm74OuFo8oxUyGmw+FNVHpC7sWCu2lgWInQIiJ14zIv3BfhsVvkY3zovmsBnxQU450z1NDoupxKk/L2hoV/KDMyPWl3TiPll+bFVtBAxyGzrzR1VM6KmhC3YVazjj6bXQGpplr7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5/bscksYkaxWOQ5jJW5pRwaSTz+EUzgYIbAgJ6gveY=;
 b=D450a0YXyfhGyukkC6P4WJ5rLpw+i6evUNiUbNdRsGPZTVD4RKAWRZnAYB1GHksjQB9TKEV0OW1m5j+ZD9upWE91oIlEZPFv6z/MdJ1ysbIhZ3YhGQslbvgHTV19Gyu2Eu2NmCuRdXXxULCW5u9JnYGKJz9tCxiXGWMouvyPUPQ=
Received: from CH0PR04CA0048.namprd04.prod.outlook.com (2603:10b6:610:77::23)
 by SA1PR12MB7294.namprd12.prod.outlook.com (2603:10b6:806:2b8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Fri, 13 Sep
 2024 11:39:24 +0000
Received: from DS3PEPF000099E2.namprd04.prod.outlook.com
 (2603:10b6:610:77:cafe::d1) by CH0PR04CA0048.outlook.office365.com
 (2603:10b6:610:77::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25 via Frontend
 Transport; Fri, 13 Sep 2024 11:39:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099E2.mail.protection.outlook.com (10.167.17.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Fri, 13 Sep 2024 11:39:24 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Sep
 2024 06:39:18 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [RFC 07/14] x86/apic: Add support to send IPI for Secure AVIC
Date: Fri, 13 Sep 2024 17:06:58 +0530
Message-ID: <20240913113705.419146-8-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E2:EE_|SA1PR12MB7294:EE_
X-MS-Office365-Filtering-Correlation-Id: 39357a88-c67e-4a5d-322a-08dcd3e8b7b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nkzo+8sOMu3N9mGKMU3hXq12S5fzA+ZuS+8xTLUObX/g6DpEImpeHnZdre7L?=
 =?us-ascii?Q?s/NRW1LJoHb7g4Nfo7ldpyUzwz3zYxKxmlK+enfr7vZBTw4iDG1q2uORKe0O?=
 =?us-ascii?Q?NUhWcx6bbBmxreGNVvJIreUVtnnLuAZavZDB4Ddm9o32CxtVAgPWj8xqg+n6?=
 =?us-ascii?Q?q31sRJGoSV8SQC5VuuXdZRh+J1OgsvqcewwRrwYAeekYdYcAtS3djF3TVHy7?=
 =?us-ascii?Q?1kYzUhJbVZGy/fd6cTGH2E+J5H1vmUm/hgeyPrO4VuMHdyLCmzsXdTXXzPDq?=
 =?us-ascii?Q?ANC4/hXorumFNp+MYYot/eAtNxB59nbSpnSWjhrT260oOCAaqOyxiFV4V1vV?=
 =?us-ascii?Q?SKu6L8H9Nya0X2JnV1Ww0mg4ojUM1jCLAN0Tyu/f6m//s8bcyC+vzC5b31L9?=
 =?us-ascii?Q?l3+H6s0uY1ZhdQdPU/nurz59qUJ2WD1pNh+OHybvjJx42WorS6coDhJums7G?=
 =?us-ascii?Q?rVFjk2Pp+4jdg/Qz8hY9WJjt6oyXUHIiS9wqm2+Sd7k45cRBGczSnXAVCUPZ?=
 =?us-ascii?Q?6dDdrlOvGPyPDYVSDKzx5aljBBWfmS7kjACErHuZ9//4Y4jQAQXgHPEdiuIc?=
 =?us-ascii?Q?cDeksnAudnCgZeIyjHXxXcNhDArObnG/B8dIGL4BXhMANpXK4FReAx4aQmbA?=
 =?us-ascii?Q?ppaZQYKpk6OJZSbeoWH9ux8eCfbSI3WFiisrymnyHVwjGfpb7ILlAJ0JHkJ+?=
 =?us-ascii?Q?+9ut4hEVjLZMRwiQcDESGJwULV+Hu10rYbPI6F0JlxS2SlxmNBgUZVwOYomM?=
 =?us-ascii?Q?hmXFhUOiSPHuStq8cSWzHfdGWn3/BhtyrX/bHyZBn6XrFN7c/BzYge4cSH1V?=
 =?us-ascii?Q?ORjTlWfAsiwKabwkirFzZfu3WR9FXuG0Sjq6qbzHr+uH+UcB5ND158UBsqe+?=
 =?us-ascii?Q?nUnFXCEJ9EQOXApl9+UnFTmySOhHaDf0gSdkjkArYElveffbtcRX3NvAJ8Fw?=
 =?us-ascii?Q?bMurxnWRa8i5EX2DMLTmPW03fLDQNd/DzO0wwDiwzDHAaIM0csGlwQwebwuv?=
 =?us-ascii?Q?2r4fYe8jETx3L8m3I1h5EbtzlRMx61DNoykhyERnpyoIEDn5zNgIt5bgg4qH?=
 =?us-ascii?Q?pHD84Tj+v5O/8HYns4GQeRHBw5ypF80x1MtVoqQ23+Wa58dd4zWQ5slgJoVV?=
 =?us-ascii?Q?16zW1CJ8vo+BkNG8ESA0zuKgt43dfxCHCSODvUi8+aJlvAtA3VhqXL/9cucX?=
 =?us-ascii?Q?PiogPGO09J8aYVP6AKIR6y6ReTbLw+RsM10on7eBXPN1XdQdXgWf5UBui+GG?=
 =?us-ascii?Q?BKbR0HiuppEU0JSIao+Hm1ivbXl4ZENQc4yhSgpEwA3UfZ9Sk9ocE4CcibFy?=
 =?us-ascii?Q?IwW2OPGVuq3KoYuVjzLxegAUyHaZcPwLQz3Oo8QbFl4BFks0knJRTg7Yg9c7?=
 =?us-ascii?Q?AexNGeSuC2kPYJB6WsNSP0ciwbdDLFuy8O5xWP2+tpI/LXPesdwXjq/tmK7X?=
 =?us-ascii?Q?C4EtZjXktgyCfaSalVXwbXlYHO4bEJwM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 11:39:24.6365
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39357a88-c67e-4a5d-322a-08dcd3e8b7b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7294

From: Kishon Vijay Abraham I <kvijayab@amd.com>

With Secure AVIC only Self-IPI is accelerated. To handle all the
other IPIs, add new callbacks for sending IPI, which write to the
IRR of the target guest APIC backing page (after decoding the ICR
register) and then issue VMGEXIT for the hypervisor to notify the
target vCPU.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Co-developed-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/coco/sev/core.c            |  25 +++++
 arch/x86/include/asm/sev.h          |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 152 +++++++++++++++++++++++++---
 3 files changed, 166 insertions(+), 13 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 0e140f92cfef..63ecab60cab7 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1392,6 +1392,31 @@ enum es_result sev_ghcb_msr_read(u64 msr, u64 *value)
 	return ret;
 }
 
+enum es_result sev_ghcb_msr_write(u64 msr, u64 value)
+{
+	struct pt_regs regs = {
+		.cx = msr,
+		.ax = lower_32_bits(value),
+		.dx = upper_32_bits(value)
+	};
+	struct es_em_ctxt ctxt = { .regs = &regs };
+	struct ghcb_state state;
+	unsigned long flags;
+	enum es_result ret;
+	struct ghcb *ghcb;
+
+	local_irq_save(flags);
+	ghcb = __sev_get_ghcb(&state);
+	vc_ghcb_invalidate(ghcb);
+
+	ret = __vc_handle_msr(ghcb, &ctxt, true);
+
+	__sev_put_ghcb(&state);
+	local_irq_restore(flags);
+
+	return ret;
+}
+
 enum es_result sev_notify_savic_gpa(u64 gpa)
 {
 	struct ghcb_state state;
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 5e6385bfb85a..1e55e3f1b7da 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -401,6 +401,7 @@ void sev_show_status(void);
 void snp_update_svsm_ca(void);
 enum es_result sev_notify_savic_gpa(u64 gpa);
 enum es_result sev_ghcb_msr_read(u64 msr, u64 *value);
+enum es_result sev_ghcb_msr_write(u64 msr, u64 value);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -439,6 +440,7 @@ static inline void sev_show_status(void) { }
 static inline void snp_update_svsm_ca(void) { }
 static inline enum es_result sev_notify_savic_gpa(u64 gpa) { return ES_UNSUPPORTED; }
 static inline enum es_result sev_ghcb_msr_read(u64 msr, u64 *value) { return ES_UNSUPPORTED; }
+static inline enum es_result sev_ghcb_msr_write(u64 msr, u64 value) { return ES_UNSUPPORTED; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index a9e54c1c6446..30a24b70e5cb 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -69,6 +69,20 @@ static u32 read_msr_from_hv(u32 reg)
 	return lower_32_bits(data);
 }
 
+static void write_msr_to_hv(u32 reg, u64 data)
+{
+	u64 msr;
+	int ret;
+
+	msr = APIC_BASE_MSR + (reg >> 4);
+	ret = sev_ghcb_msr_write(msr, data);
+	if (ret != ES_OK) {
+		pr_err("Secure AVIC msr (%#llx) write returned error (%d)\n", msr, ret);
+		/* MSR writes should never fail. Any failure is fatal error for SNP guest */
+		snp_abort();
+	}
+}
+
 #define SAVIC_ALLOWED_IRR_OFFSET	0x204
 
 static u32 x2apic_savic_read(u32 reg)
@@ -124,6 +138,7 @@ static u32 x2apic_savic_read(u32 reg)
 static void x2apic_savic_write(u32 reg, u32 data)
 {
 	void *backing_page = this_cpu_read(apic_backing_page);
+	unsigned int cfg;
 
 	switch (reg) {
 	case APIC_LVTT:
@@ -131,7 +146,6 @@ static void x2apic_savic_write(u32 reg, u32 data)
 	case APIC_LVT1:
 	case APIC_TMICT:
 	case APIC_TDCR:
-	case APIC_SELF_IPI:
 	/* APIC_ID is writable and configured by guest for Secure AVIC */
 	case APIC_ID:
 	case APIC_TASKPRI:
@@ -149,6 +163,11 @@ static void x2apic_savic_write(u32 reg, u32 data)
 	case APIC_EILVTn(0) ... APIC_EILVTn(3):
 		set_reg(backing_page, reg, data);
 		break;
+	/* Self IPIs are accelerated by hardware, use wrmsr */
+	case APIC_SELF_IPI:
+		cfg = __prepare_ICR(APIC_DEST_SELF, data, 0);
+		native_x2apic_icr_write(cfg, 0);
+		break;
 	/* ALLOWED_IRR offsets are writable */
 	case SAVIC_ALLOWED_IRR_OFFSET ... SAVIC_ALLOWED_IRR_OFFSET + 0x70:
 		if (IS_ALIGNED(reg - SAVIC_ALLOWED_IRR_OFFSET, 16)) {
@@ -161,13 +180,100 @@ static void x2apic_savic_write(u32 reg, u32 data)
 	}
 }
 
+static void send_ipi(int cpu, int vector)
+{
+	void *backing_page;
+	int reg_off;
+
+	backing_page = per_cpu(apic_backing_page, cpu);
+	reg_off = APIC_IRR + REG_POS(vector);
+	/*
+	 * Use test_and_set_bit() to ensure that IRR updates are atomic w.r.t. other
+	 * IRR updates such as during VMRUN and during CPU interrupt handling flow.
+	 */
+	test_and_set_bit(VEC_POS(vector), (unsigned long *)((char *)backing_page + reg_off));
+}
+
+static void send_ipi_dest(u64 icr_data)
+{
+	int vector, cpu;
+
+	vector = icr_data & APIC_VECTOR_MASK;
+	cpu = icr_data >> 32;
+
+	send_ipi(cpu, vector);
+}
+
+static void send_ipi_target(u64 icr_data)
+{
+	if (icr_data & APIC_DEST_LOGICAL) {
+		pr_err("IPI target should be of PHYSICAL type\n");
+		return;
+	}
+
+	send_ipi_dest(icr_data);
+}
+
+static void send_ipi_allbut(u64 icr_data)
+{
+	const struct cpumask *self_cpu_mask = get_cpu_mask(smp_processor_id());
+	unsigned long flags;
+	int vector, cpu;
+
+	vector = icr_data & APIC_VECTOR_MASK;
+	local_irq_save(flags);
+	for_each_cpu_andnot(cpu, cpu_present_mask, self_cpu_mask)
+		send_ipi(cpu, vector);
+	write_msr_to_hv(APIC_ICR, icr_data);
+	local_irq_restore(flags);
+}
+
+static void send_ipi_allinc(u64 icr_data)
+{
+	int vector;
+
+	send_ipi_allbut(icr_data);
+	vector = icr_data & APIC_VECTOR_MASK;
+	native_x2apic_icr_write(APIC_DEST_SELF | vector, 0);
+}
+
+static void x2apic_savic_icr_write(u32 icr_low, u32 icr_high)
+{
+	int dsh, vector;
+	u64 icr_data;
+
+	icr_data = ((u64)icr_high) << 32 | icr_low;
+	dsh = icr_low & APIC_DEST_ALLBUT;
+
+	switch (dsh) {
+	case APIC_DEST_SELF:
+		vector = icr_data & APIC_VECTOR_MASK;
+		x2apic_savic_write(APIC_SELF_IPI, vector);
+		break;
+	case APIC_DEST_ALLINC:
+		send_ipi_allinc(icr_data);
+		break;
+	case APIC_DEST_ALLBUT:
+		send_ipi_allbut(icr_data);
+		break;
+	default:
+		send_ipi_target(icr_data);
+		write_msr_to_hv(APIC_ICR, icr_data);
+	}
+}
+
+static void __send_IPI_dest(unsigned int apicid, int vector, unsigned int dest)
+{
+	unsigned int cfg = __prepare_ICR(0, vector, dest);
+
+	x2apic_savic_icr_write(cfg, apicid);
+}
+
 static void x2apic_savic_send_IPI(int cpu, int vector)
 {
 	u32 dest = per_cpu(x86_cpu_to_apicid, cpu);
 
-	/* x2apic MSRs are special and need a special fence: */
-	weak_wrmsr_fence();
-	__x2apic_send_IPI_dest(dest, vector, APIC_DEST_PHYSICAL);
+	__send_IPI_dest(dest, vector, APIC_DEST_PHYSICAL);
 }
 
 static void
@@ -177,18 +283,16 @@ __send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 	unsigned long this_cpu;
 	unsigned long flags;
 
-	/* x2apic MSRs are special and need a special fence: */
-	weak_wrmsr_fence();
-
 	local_irq_save(flags);
 
 	this_cpu = smp_processor_id();
 	for_each_cpu(query_cpu, mask) {
 		if (apic_dest == APIC_DEST_ALLBUT && this_cpu == query_cpu)
 			continue;
-		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
-				       vector, APIC_DEST_PHYSICAL);
+		__send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu), vector,
+				      APIC_DEST_PHYSICAL);
 	}
+
 	local_irq_restore(flags);
 }
 
@@ -202,6 +306,28 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
 	__send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }
 
+static void __send_IPI_shorthand(int vector, u32 which)
+{
+	unsigned int cfg = __prepare_ICR(which, vector, 0);
+
+	x2apic_savic_icr_write(cfg, 0);
+}
+
+static void x2apic_savic_send_IPI_allbutself(int vector)
+{
+	__send_IPI_shorthand(vector, APIC_DEST_ALLBUT);
+}
+
+static void x2apic_savic_send_IPI_all(int vector)
+{
+	__send_IPI_shorthand(vector, APIC_DEST_ALLINC);
+}
+
+static void x2apic_savic_send_IPI_self(int vector)
+{
+	__send_IPI_shorthand(vector, APIC_DEST_SELF);
+}
+
 static void x2apic_savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
 {
 	void *backing_page;
@@ -322,16 +448,16 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.send_IPI			= x2apic_savic_send_IPI,
 	.send_IPI_mask			= x2apic_savic_send_IPI_mask,
 	.send_IPI_mask_allbutself	= x2apic_savic_send_IPI_mask_allbutself,
-	.send_IPI_allbutself		= x2apic_send_IPI_allbutself,
-	.send_IPI_all			= x2apic_send_IPI_all,
-	.send_IPI_self			= x2apic_send_IPI_self,
+	.send_IPI_allbutself		= x2apic_savic_send_IPI_allbutself,
+	.send_IPI_all			= x2apic_savic_send_IPI_all,
+	.send_IPI_self			= x2apic_savic_send_IPI_self,
 	.nmi_to_offline_cpu		= true,
 
 	.read				= x2apic_savic_read,
 	.write				= x2apic_savic_write,
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
-	.icr_write			= native_x2apic_icr_write,
+	.icr_write			= x2apic_savic_icr_write,
 
 	.update_vector			= x2apic_savic_update_vector,
 };
-- 
2.34.1


