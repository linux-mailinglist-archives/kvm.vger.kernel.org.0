Return-Path: <kvm+bounces-56088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F37BB39AF1
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:04:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A59417E541
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CC3F30E0FA;
	Thu, 28 Aug 2025 11:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XxB6mzGu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D3521D00E;
	Thu, 28 Aug 2025 11:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379000; cv=fail; b=HcjRun7WEkzcJwGjTDn38NV6b+WQH/B/jbKoI0Oeno8Cf7uk0QN0ZDJrKT729dv1av+30UfnnM6hcBYQn3aopylm+8XoLVC6SQj0QOYYI9/ydvYvz+pRUd/a/raQJhZtfAjQsJgaQX8xhjqmqgm+2XjaxX8VyBX3OKg46ZHZosA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379000; c=relaxed/simple;
	bh=MSAFv86QPPRxzBOpznwmC2CCvX2+xVohp4pDGJePSO8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=drRjaT7Ad9BPQLe9g8q3qlq+s7nntPQlxsUPngzq1oPZVu0Lh5loPDYtNzcLhGvjMcLXQ2p1a3ygvHxwRvVPsqWWeX1YPI4w1XHRvxzkTz7nCusQMqe9NZcCbzcRsrw1GY/c4ZppkvbSPxi5f9+LM3tMcJKzSM4xVymoL/Ocajg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XxB6mzGu; arc=fail smtp.client-ip=40.107.237.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gNW0V5kutA2tG6tcsaRM8Gd6aBmCqeWkto0utKFlC6d5acaKpQc6y1UNt1hpS8INm5dTyszfsSM9SZsKA253ummXBpVE15zfC9eNKoD+9a0HUl5F5e5cmV+g/52sg1JRn82aSy0mRViGHqMydQB7UBoCvq0eJWPN0atxCjPNzVT1mHhTaccF9EPu8hEukqHYKliBp+50Gdws/7cSD2/L8bk7ZCaR22Fsh2x/us+SJc4+dxuk0JkVJ2ZqjpwO0uDOQJWjrRT0On9YU49KWC+Gffy1bDvi2gK9mme6XzrrFS7wo37waS1YAs/GL5OGWeurQyMkY130noAtQuUMxoBcqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e99A5Fu5/qILiEm6zG7dAigab/BekQfgo1woCmCDK0k=;
 b=n5+LDzVHGEwMmmgdyBYH3ngnjfiTpmdydVFhZ/4yGplsLwF8SFyz/KkCn8lNJz3pDDVQR6r4Y9qmihkeaql7bu1KgGbytpNjrJVDEbFBlFb2ilu1Fv/hwSUx/YnqDlgjokNOPjyDRIch+IaQO+NAhrdPpREN8kTZAOlhEkLE2WcX6FHRq4e14kP9W/H//e8myUDcjkHxfc4EHFUAc9Ne5+abvaSH1bw5WDHWF7il6MOqZ6gYoVCTvn27XveJwafQm3V8dyZPgsw6MnQtEDXk0xjB8xE1hW3YYPl+HeV2yqYAwojaAo3sUsxd+ct2pl1LgA/io5ha1fmmY2lbTx5pug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e99A5Fu5/qILiEm6zG7dAigab/BekQfgo1woCmCDK0k=;
 b=XxB6mzGudgaH5UUqhBlpWm0v4eFH1OW57Jo8X5Lua2GMA0ujHAuYrLAGfOhcW8miAGyqg58UDECExDLYdRBv4J5sa4rNQdxwA/KhXFiqrY1eOlf68HcxP31pS8A2JeT9+SWZ7DcwyNYPfMfeGh55Gl9ZFnSb7mgfPYyK7DYleSw=
Received: from MN2PR06CA0026.namprd06.prod.outlook.com (2603:10b6:208:23d::31)
 by PH0PR12MB7929.namprd12.prod.outlook.com (2603:10b6:510:284::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 11:03:11 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:208:23d:cafe::71) by MN2PR06CA0026.outlook.office365.com
 (2603:10b6:208:23d::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.16 via Frontend Transport; Thu,
 28 Aug 2025 11:03:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Thu, 28 Aug 2025 11:03:11 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:03:10 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:03:03 -0700
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
Subject: [PATCH v10 03/18] x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
Date: Thu, 28 Aug 2025 16:32:40 +0530
Message-ID: <20250828110255.208779-1-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
References: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|PH0PR12MB7929:EE_
X-MS-Office365-Filtering-Correlation-Id: e06313f8-1971-4edf-9919-08dde6227a7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9YSarBtRH3ZO7pclTJd2rw7ooz9e/NVr1gGWKKYMowYjz9SSInYUBIk/qW8/?=
 =?us-ascii?Q?YWPFJ/18SSok4UBhEveL21GN+RJXUXnmynKAXuq23KLjtpLI0q8Nlh33hx1m?=
 =?us-ascii?Q?JBW7I4iU5SPh+hj3Z0U/ztw1b6LEswPPJapBDtYzc+uzNY9vrPcT+DCQ53S4?=
 =?us-ascii?Q?zkIYBwNwxYezOoVxpq44z25rFXPSFrl3SXUOow4jQFE4KOPEzvoZqSQewC14?=
 =?us-ascii?Q?CMooHuI9XTohaQONEQh5pLtoiS10XLOdpaxH5nO97w7Ru96+iArM8J3xqtNO?=
 =?us-ascii?Q?jZj32icP2ZVbAbryWkKWxXpS5oGVIXL9c3rWXZ3k7w8nNUFYfzsQR65XZjCg?=
 =?us-ascii?Q?C4NbNjiGSEOqRdyRDXUxsN3oXKEQOw5MVcQqZTp9mPPKK8tw7l02SqWb3Mnc?=
 =?us-ascii?Q?LHErLzVkv1XON1J19Xo79EF06vBdA0xcOfmFt6WoFVvkbUEaw2mnbhjt0SIz?=
 =?us-ascii?Q?WvuDrPUMrU235hiNXzFlUbx8PkoUuvaFEfodvM1omvyECrjOj9topMa+MqGW?=
 =?us-ascii?Q?HDyt+dEREtGupefbZOGml05mYLb8bulyjD+0DE27rDtx8JMPpfWZ7ECs+ZiU?=
 =?us-ascii?Q?BDvFDDueLWg5Rb0rmZF1zJurLi3avBHcS0DZDkVs5zWPbKBtQN2dxASJpV8W?=
 =?us-ascii?Q?VYRUcWeKARdiqoybiUN+VHb1OTApOT/rm0RnaXYgDcMdZLFtlTha+oafR4d8?=
 =?us-ascii?Q?uuNrJiLxIFp/iChFn5mzXqHvSw9WPRqGFbaS4eMu4EscujfPXbcJ04DsE35v?=
 =?us-ascii?Q?pAshELmr+ArczXkCUZPtuY3WxWwhT9gkSsMfYSfGwTsErrzZrImJs17T8ieN?=
 =?us-ascii?Q?fey1C8IbFx0dioXbGuDeJ2kJgIkSeh38JU2Nm0tGM22k7saC7tJDddxt7SBq?=
 =?us-ascii?Q?xZiKAKMJqLobEJCcpkDjHRYRLobboRDe6Oet4d7HVI0XSUvVw1598FHom1p6?=
 =?us-ascii?Q?e3qeEDyXRUQLSzuZvZdfu1e8GuEloxe4zJM775jSMuTZGJaWvn4OQWiVzmvB?=
 =?us-ascii?Q?13vI51rRgTx6Gk1KZRQrq3AqrNneJKsUv9qqawre0xXo6JYI4HQNM0CbXokV?=
 =?us-ascii?Q?FwMmovlRUkcoxEPOyoLjDpbBoH/Ul6y1P8s09KETBfBOJqzxUJlH6UnE9F8q?=
 =?us-ascii?Q?tfTOEMlg57xBXBuHUfKO7J/PmWBlbNKWY7PnnyOrVSz4JIOrKRUHIcRmh1Z8?=
 =?us-ascii?Q?FB+f2gScyA59aCV9jA14Zs0iATM9zfDj4CUdXSriCtjUaYKpdXmq1fOGZbEV?=
 =?us-ascii?Q?yr0Cz3dXHDBJFOsvk8v/tS0+psJeUz7YnuzspE6DYeMVtxKmrOjfJ2EcFekk?=
 =?us-ascii?Q?nuX+ZUy3mbCvP3nMt9VhiKIwVbtIvmoZvYPtUiWgsRz9DEZPD5pnxDeFrd5R?=
 =?us-ascii?Q?X042IVf0J4an0rbAdHoDh9lkLCuTS1IHiCNZiBTXveqXwVIdgOBlQ4YMuKC8?=
 =?us-ascii?Q?NUX+oqL8Y0kQXxicr1AWXQlBjual5noeJNvYFKw2wyN/I3tSPKOblcRd8KFL?=
 =?us-ascii?Q?aEOOkPc5s6pHnPp8JNyk0QyvQiyTafHIWCWc?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:03:11.4487
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e06313f8-1971-4edf-9919-08dde6227a7f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7929

Add read() and write() APIC callback functions to read and write the
x2APIC registers directly from the guest APIC backing page of a vCPU.

The x2APIC registers are mapped at an offset within the guest APIC
backing page which is same as their x2APIC MMIO offset. Secure AVIC
adds new registers such as ALLOWED_IRRs (which are at 4-byte offset
within the IRR register offset range) and NMI_REQ to the APIC register
space.

When Secure AVIC is enabled, guest's RDMSR/WRMSR of the APIC registers
result in #VC exception (for non-accelerated register accesses) with
error code VMEXIT_AVIC_NOACCEL. The #VC exception handler can read/write
the x2APIC register in the guest APIC backing page to complete the
RDMSR/WRMSR. Since doing this would increase the latency of accessing
the x2APIC registers, instead of doing RDMSR/WRMSR based register
accesses and handling reads/writes in the #VC exception, directly
read/write the APIC registers from/to the guest APIC backing page of
the vCPU in read() and write() callbacks of the Secure AVIC APIC
driver.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:
 - Clean up the ALLOWED_IRR alignment condition check.
 - Update comments describing the alignment of APIC_IRR and
   ALLOWED_IRR.
 - Commit log updates.

 arch/x86/include/asm/apicdef.h      |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 122 +++++++++++++++++++++++++++-
 2 files changed, 122 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 094106b6a538..be39a543fbe5 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -135,6 +135,8 @@
 #define		APIC_TDR_DIV_128	0xA
 #define	APIC_EFEAT	0x400
 #define	APIC_ECTRL	0x410
+#define APIC_SEOI	0x420
+#define APIC_IER	0x480
 #define APIC_EILVTn(n)	(0x500 + 0x10 * n)
 #define		APIC_EILVT_NR_AMD_K8	1	/* # of extended interrupts */
 #define		APIC_EILVT_NR_AMD_10H	4
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 948d89497baa..5479605429c1 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -9,6 +9,7 @@
 
 #include <linux/cc_platform.h>
 #include <linux/percpu-defs.h>
+#include <linux/align.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
@@ -26,6 +27,123 @@ static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+#define SAVIC_ALLOWED_IRR	0x204
+
+/*
+ * When Secure AVIC is enabled, RDMSR/WRMSR of the APIC registers
+ * result in #VC exception (for non-accelerated register accesses)
+ * with VMEXIT_AVIC_NOACCEL error code. The #VC exception handler
+ * can read/write the x2APIC register in the guest APIC backing page.
+ *
+ * Since doing this would increase the latency of accessing x2APIC
+ * registers, instead of doing RDMSR/WRMSR based accesses and
+ * handling the APIC register reads/writes in the #VC exception handler,
+ * the read() and write() callbacks directly read/write the APIC register
+ * from/to the vCPU's APIC backing page.
+ */
+static u32 savic_read(u32 reg)
+{
+	void *ap = this_cpu_ptr(savic_page);
+
+	switch (reg) {
+	case APIC_LVTT:
+	case APIC_TMICT:
+	case APIC_TMCCT:
+	case APIC_TDCR:
+	case APIC_ID:
+	case APIC_LVR:
+	case APIC_TASKPRI:
+	case APIC_ARBPRI:
+	case APIC_PROCPRI:
+	case APIC_LDR:
+	case APIC_SPIV:
+	case APIC_ESR:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVT0:
+	case APIC_LVT1:
+	case APIC_LVTERR:
+	case APIC_EFEAT:
+	case APIC_ECTRL:
+	case APIC_SEOI:
+	case APIC_IER:
+	case APIC_EILVTn(0) ... APIC_EILVTn(3):
+		return apic_get_reg(ap, reg);
+	case APIC_ICR:
+		return (u32)apic_get_reg64(ap, reg);
+	case APIC_ISR ... APIC_ISR + 0x70:
+	case APIC_TMR ... APIC_TMR + 0x70:
+		if (WARN_ONCE(!IS_ALIGNED(reg, 16),
+			      "APIC register read offset 0x%x not aligned at 16 bytes", reg))
+			return 0;
+		return apic_get_reg(ap, reg);
+	/* IRR and ALLOWED_IRR offset range */
+	case APIC_IRR ... APIC_IRR + 0x74:
+		/*
+		 * Valid APIC_IRR/SAVIC_ALLOWED_IRR registers are at 16 bytes strides from
+		 * their respective base offset. APIC_IRRs are in the range
+		 *
+		 * (0x200, 0x210,  ..., 0x270)
+		 *
+		 * while the SAVIC_ALLOWED_IRR range starts 4 bytes later, in the range
+		 *
+		 * (0x204, 0x214, ..., 0x274).
+		 *
+		 * Filter out everything else.
+		 */
+		if (WARN_ONCE(!(IS_ALIGNED(reg, 16) ||
+				IS_ALIGNED(reg - 4, 16)),
+			      "Misaligned APIC_IRR/ALLOWED_IRR APIC register read offset 0x%x", reg))
+			return 0;
+		return apic_get_reg(ap, reg);
+	default:
+		pr_err("Error reading unknown Secure AVIC reg offset 0x%x\n", reg);
+		return 0;
+	}
+}
+
+#define SAVIC_NMI_REQ		0x278
+
+static void savic_write(u32 reg, u32 data)
+{
+	void *ap = this_cpu_ptr(savic_page);
+
+	switch (reg) {
+	case APIC_LVTT:
+	case APIC_LVT0:
+	case APIC_LVT1:
+	case APIC_TMICT:
+	case APIC_TDCR:
+	case APIC_SELF_IPI:
+	case APIC_TASKPRI:
+	case APIC_EOI:
+	case APIC_SPIV:
+	case SAVIC_NMI_REQ:
+	case APIC_ESR:
+	case APIC_LVTTHMR:
+	case APIC_LVTPC:
+	case APIC_LVTERR:
+	case APIC_ECTRL:
+	case APIC_SEOI:
+	case APIC_IER:
+	case APIC_EILVTn(0) ... APIC_EILVTn(3):
+		apic_set_reg(ap, reg, data);
+		break;
+	case APIC_ICR:
+		apic_set_reg64(ap, reg, (u64)data);
+		break;
+	/* ALLOWED_IRR offsets are writable */
+	case SAVIC_ALLOWED_IRR ... SAVIC_ALLOWED_IRR + 0x70:
+		if (IS_ALIGNED(reg - 4, 16)) {
+			apic_set_reg(ap, reg, data);
+			break;
+		}
+		fallthrough;
+	default:
+		pr_err("Error writing unknown Secure AVIC reg offset 0x%x\n", reg);
+	}
+}
+
 static void savic_setup(void)
 {
 	void *ap = this_cpu_ptr(savic_page);
@@ -88,8 +206,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.nmi_to_offline_cpu		= true,
 
-	.read				= native_apic_msr_read,
-	.write				= native_apic_msr_write,
+	.read				= savic_read,
+	.write				= savic_write,
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
-- 
2.34.1


