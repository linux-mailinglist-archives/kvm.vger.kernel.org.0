Return-Path: <kvm+bounces-46446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C581AB6443
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:27:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8380E19E1D56
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0933321C16D;
	Wed, 14 May 2025 07:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OVfGy1Un"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB86215075;
	Wed, 14 May 2025 07:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207529; cv=fail; b=OAOOb0TTixIcgN64B2LDvD4Pio4eynAvQfrgSiwyvhRMI/Cyjaiascj9G8qDSCkKwvlpOLzU7BjzwXrcKiV1nEBLUJaOLK9GGXAHUHVJrtvnCYvY/RQT+b5UY+/EWEJT5iPcZEbooIOz2elP69/yM4Y775jj/uIASYiXbV7i/fo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207529; c=relaxed/simple;
	bh=RxFI3zRdzyyEoxAmGNHbo45PUurz6g33PzOohlMKDFc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uCsAZ/vhhNW3JTLKc81y99cxddy5fYAlX2maONI/35VQmcCOjUBhDU3ccqFmoQr5hWqiupe6aSY6GC/sWaXTB7Jp9opB7sHNTHFOxcm0d+e4h90/FQVmeEd2HfBCCgDRNaHndIO3d9FttYQ640FpKnoc6LF8KTJFmqbpd0uXtd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OVfGy1Un; arc=fail smtp.client-ip=40.107.223.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S481kXg7m22YoALUgCDlwY7GMmAyQT49vM4X7uMaH1t1/yC6kfoxXWWifhkCTkOMFhoBHmgWMQfhu+/t3B65U4ZfOHIKaLC4t9ogZByWy/3YXbQKTiiRb3H87mwYQ6mtzxPkSYUP3tS/odvNlKpTtwiKYXsDb6q1GyGHBIu8aPkV75bxvJo5AXynhY/gRmGqlnZ6b/DCORjRoNkDGxkWXUUIJCS0o4JtW7nwg33bfNBAkIh+V5RNR5QlLdJ52sYl1qpA2m14mrHw3U7uWw9QYlnfc6ZziBJqtvRVEYqPYcr8WP7vBr3Ul48maJfzOFKTl65Ad8JFujFFw16TLWGbvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZ5O+l9OCwdADnbvs51zYEjBVs3s001Q0HCHR9aa22E=;
 b=tURkN5QAaOSAEHa1+JnVdQp9pSNuljRS51gFxkLkCXwWnbjN24LcjLtn6vBkI59acxL3y+lo9Cs3hsEfTXLkcZugwNiYqQbqk5zTMddKRmhyKT0luhbPzmLjqcDzGb2phlJP6Z0Jce74wQzYHdZpGg2jdd56wiE8oF1DT889Psx6nMkdW5HyFW+RXGHSsqrJ4bJYgHch/nnLqEU7P4JRJkLZLT/+HDLlS0j3iB3ANQCJMu8ntJUvZYnkDQQ34K2c8FYTLwTdLS8uErjlDZmUadHfRET0NGH8h9cdWs1oCPWycWCk5PP1pYdWSEnZxYkZY6jQzW+kFdKGs6k7GClFPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZ5O+l9OCwdADnbvs51zYEjBVs3s001Q0HCHR9aa22E=;
 b=OVfGy1Un5hcwZLqudynHsrrkhUR6fzdmkx79FIpco2e8CzYvnq3cpM+v46anfmJRmBqYVPMg99q098q9Zcaw0BzWWBjJxA+MZwBGQO6b08NIt4rnsZIpIJ64yxdcP8vmh1VR0ekNefVFVZBQySE/Xtprh+oqq9+JUnCVq4pWsWY=
Received: from MN2PR20CA0060.namprd20.prod.outlook.com (2603:10b6:208:235::29)
 by DM6PR12MB4076.namprd12.prod.outlook.com (2603:10b6:5:213::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 07:25:23 +0000
Received: from BN3PEPF0000B076.namprd04.prod.outlook.com
 (2603:10b6:208:235:cafe::37) by MN2PR20CA0060.outlook.office365.com
 (2603:10b6:208:235::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.26 via Frontend Transport; Wed,
 14 May 2025 07:25:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B076.mail.protection.outlook.com (10.167.243.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:25:23 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:25:12 -0500
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
Subject: [RFC PATCH v6 17/32] x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
Date: Wed, 14 May 2025 12:47:48 +0530
Message-ID: <20250514071803.209166-18-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B076:EE_|DM6PR12MB4076:EE_
X-MS-Office365-Filtering-Correlation-Id: ec8a2b54-3038-4bd7-5ae9-08dd92b87d6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8Jo80GmAUnA9KXLQ97N7zc0s12xgrC9UDxXdZ9KGynPV+6b2k2DpE2b05cq8?=
 =?us-ascii?Q?JbO3D0wXyi6mNhDI1mYOdU1eyjXT0uy+WToT28olM/oJXzanXMThGqVKYvrB?=
 =?us-ascii?Q?+JaL5YOyjua0HOF+7SMuoVJeX0UEv+a1jR3EiWH7c8Yn8ZtWgDszxUjldLQV?=
 =?us-ascii?Q?y1UAwlHs8O9AhimGhpeCag2qvvyjgHVTkHs8nVrIwnoH6lsUMSPoAuXI11No?=
 =?us-ascii?Q?61JvopaOCSCA+8cjZcERz4mbzR44R0FXs7A1HnvSMOtY3UPimJdVitHzFRTa?=
 =?us-ascii?Q?yUWhgDfTjUZpRIjLYq5WCjdbxg/Wq8eqbiU17PGmIYjNAs/OF/shRaCy7tnC?=
 =?us-ascii?Q?hjfCe5qAXwP6DvZXxZezJmTNi1/nDoxJNaiJagrwHQoOFjC+z3VdBalOHUhy?=
 =?us-ascii?Q?DMkPG6bOKUM8hH5mLOKnGmdOf6OTA3Jw5NGBgeWKCCRPIo+prN4ZEZM3E1/6?=
 =?us-ascii?Q?fLxHAMyTm/lUp/pkZ8R9AL88bFOeqn2Ih39lHLv2jzG+BjL1d+HPaHIOmOXY?=
 =?us-ascii?Q?8FgZr9M/bOcrNWD9TeR2K2nb+tYOFAL8O6IuZOAq+l1sRZDpBsJM/vWO6Gtp?=
 =?us-ascii?Q?bWBJpeJsonupyiB17bls6OfjnDM+wckMBF6kL7uppPnnXSORbwk+Ws/d0Zw+?=
 =?us-ascii?Q?GO7KuRV//ZoHHaIWoBxVNh61RvW9F19xAt4gj6nawxlCFZXjNeUaMmMbi1xy?=
 =?us-ascii?Q?aejV/9ujQfGl9CEEp3mJNQfWWDxiDjANg8eOSzXCJQ+IrBJYRb4yRe1GDaye?=
 =?us-ascii?Q?J+QEjl4bMloMRiZ+jxMx0Eo97XCJXxTyAuKpvx248jQ5bp3+nBwkIYBALTIz?=
 =?us-ascii?Q?BqX70WU79hrSLnuVYXaTe+/ElLh96p6uASdQO2OOUgVdvRQCrwggrgYt62EF?=
 =?us-ascii?Q?MGDBhJx/6q39hg76rpVg6GshuR0UGYKMTwe80Oij7zykNGvDojwId3TR822i?=
 =?us-ascii?Q?XPirpQDWgdshUDcBzVN1Km+4WOD6njm8mUQDvl75TYZIYAtn7N6RCl+3K3wu?=
 =?us-ascii?Q?HrihBTs4Hp80jcWqL6gfQb8eCRPO3z3KmQdmp42ulc23MbitA3SiAIu+4nrX?=
 =?us-ascii?Q?/bun0BnSCiHOPzLMrFylBlJPRwFrIsAc8uG54utV0w1b7q0vo8VMo7zsfn7p?=
 =?us-ascii?Q?4jqf3m/PscAFg2XnC4Bbplow3esnf19rV9LJmwJz60HbwvYqJ4c2/oPgguu6?=
 =?us-ascii?Q?rRHOP34k1IJr0PoV+gOAyEa8TqU/w4AZ8LwkyHBeJxaV+46RYC5ZaIaOmFE2?=
 =?us-ascii?Q?CxVjFX8rlL3qAqiixJkyjvF3nqmdm+X1L2COt1hYh8opwyniMgCkDzrjfe8d?=
 =?us-ascii?Q?zEDfRNLG/x6Jkm8TZdJOMQur55QY/vgDGKjEaK6uf1bYdNEN61Kff9oNLtsV?=
 =?us-ascii?Q?IdYwS+jiF5xZ6v1ghl5rUYdUxnMSiOmRerg8F3uEK1XpeuVuCkzqwLd3vswE?=
 =?us-ascii?Q?hiwOJDgbfFbTS5vwt3ahmn2h/SgzuWG8tRVGPiNB1suL1cffLgRqbWEaNvEW?=
 =?us-ascii?Q?5bDGdpki9l3w+fZi+nmANdUjHLqoNyFxs6Lt?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:25:23.2146
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec8a2b54-3038-4bd7-5ae9-08dd92b87d6f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B076.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4076

Add read() and write() APIC callback functions to read and write x2APIC
registers directly from the guest APIC backing page of a vCPU.

The x2APIC registers are mapped at an offset within the guest APIC
backing page which is same as their x2APIC MMIO offset. Secure AVIC
adds new registers such as ALLOWED_IRRs (which are at 4-byte offset
within the IRR register offset range) and NMI_REQ to the APIC register
space.

When Secure AVIC is enabled, guest's rdmsr/wrmsr of APIC registers
result in VC exception (for non-accelerated register accesses) with
error code VMEXIT_AVIC_NOACCEL. The VC exception handler can read/write
the x2APIC register in the guest APIC backing page to complete the
rdmsr/wrmsr. Since doing this would increase the latency of accessing
x2APIC registers, instead of doing rdmsr/wrmsr based reg accesses
and handling reads/writes in VC exception, directly read/write APIC
registers from/to the guest APIC backing page of the vCPU in read()
and write() callbacks of the Secure AVIC APIC driver.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - Use common helpers apic_get_reg(), apic_set_reg(), apic_get_reg64(),
   apic_set_reg64().
 - Fix APIC_ICR handling in savic_read() and savic_write().

 arch/x86/include/asm/apicdef.h      |   2 +
 arch/x86/kernel/apic/x2apic_savic.c | 113 +++++++++++++++++++++++++++-
 2 files changed, 113 insertions(+), 2 deletions(-)

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
index a2747ab9200a..186e69a5e169 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -9,6 +9,7 @@
 
 #include <linux/cc_platform.h>
 #include <linux/percpu-defs.h>
+#include <linux/align.h>
 
 #include <asm/apic.h>
 #include <asm/sev.h>
@@ -22,6 +23,114 @@ static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+#define SAVIC_ALLOWED_IRR	0x204
+
+static u32 savic_read(u32 reg)
+{
+	struct apic_page *ap = this_cpu_ptr(apic_page);
+
+	/*
+	 * When Secure AVIC is enabled, rdmsr/wrmsr of APIC registers
+	 * result in VC exception (for non-accelerated register accesses)
+	 * with VMEXIT_AVIC_NOACCEL error code. The VC exception handler
+	 * can read/write the x2APIC register in the guest APIC backing page.
+	 * Since doing this would increase the latency of accessing x2APIC
+	 * registers, instead of doing rdmsr/wrmsr based accesses and
+	 * handling apic register reads/writes in VC exception, the read()
+	 * and write() callbacks directly read/write APIC register from/to
+	 * the vCPU APIC backing page.
+	 */
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
+		return (u32) apic_get_reg64(ap, reg);
+	case APIC_ISR ... APIC_ISR + 0x70:
+	case APIC_TMR ... APIC_TMR + 0x70:
+		if (WARN_ONCE(!IS_ALIGNED(reg, 16),
+			      "APIC reg read offset 0x%x not aligned at 16 bytes", reg))
+			return 0;
+		return apic_get_reg(ap, reg);
+	/* IRR and ALLOWED_IRR offset range */
+	case APIC_IRR ... APIC_IRR + 0x74:
+		/*
+		 * Either aligned at 16 bytes for valid IRR reg offset or a
+		 * valid Secure AVIC ALLOWED_IRR offset.
+		 */
+		if (WARN_ONCE(!(IS_ALIGNED(reg, 16) ||
+				IS_ALIGNED(reg - SAVIC_ALLOWED_IRR, 16)),
+			      "Misaligned IRR/ALLOWED_IRR APIC reg read offset 0x%x", reg))
+			return 0;
+		return apic_get_reg(ap, reg);
+	default:
+		pr_err("Permission denied: read of Secure AVIC reg offset 0x%x\n", reg);
+		return 0;
+	}
+}
+
+#define SAVIC_NMI_REQ		0x278
+
+static void savic_write(u32 reg, u32 data)
+{
+	struct apic_page *ap = this_cpu_ptr(apic_page);
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
+		apic_set_reg64(ap, reg, (u64) data);
+		break;
+	/* ALLOWED_IRR offsets are writable */
+	case SAVIC_ALLOWED_IRR ... SAVIC_ALLOWED_IRR + 0x70:
+		if (IS_ALIGNED(reg - SAVIC_ALLOWED_IRR, 16)) {
+			apic_set_reg(ap, reg, data);
+			break;
+		}
+		fallthrough;
+	default:
+		pr_err("Permission denied: write to Secure AVIC reg offset 0x%x\n", reg);
+	}
+}
+
 static void savic_setup(void)
 {
 	void *backing_page;
@@ -85,8 +194,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
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


