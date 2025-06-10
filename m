Return-Path: <kvm+bounces-48838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 778BAAD4185
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:03:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1F6C7AD2F9
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6049E24679C;
	Tue, 10 Jun 2025 18:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EAHs25iN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2050.outbound.protection.outlook.com [40.107.243.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063292459D0;
	Tue, 10 Jun 2025 18:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578576; cv=fail; b=WkbE/g1grMtrW4+YMZX6J84wcYKGQmbqWhs6C5t501aDXJkIidb9KHm1ZJULErMXqb5brxjNBUFCo046hW2176AiyvOxQ3ipRVikStSvUyeCGV+x8UyXHVZpFkurDU96iaOBGkHTdR7ZLGsDSiByVL9P65dg4RU9fPVjfyqA7r8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578576; c=relaxed/simple;
	bh=nuI9QZ61PYKMqFwqfJjt9B5BWwNb9eWiYE3gSSaWsYo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mgkq2V3j6jkZUVfMfASuHfDZosRpIAA35nxPIQwMWa7xq59qOBkyJfu29rVSac1fOoD3ZW4OQ0qdcnhvIbCRguZ6EaZgUuFXzt0/bNLtCIfOEZSgPSnRulcLIhI2wNy3GYaDv+wZDcIRPCFUKOYPISD0VL/IGa/gNgJXlYhaJsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EAHs25iN; arc=fail smtp.client-ip=40.107.243.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gk9wnkxr3T287odN0vyDGO+1iEjFjt6JyjSpL6GxClFZH3JvMsozrwQBHQxJ0xbNZ/KRSG6UwgAxXTo+LCADQgL9jaN/uQ8NppSD1CgYTwRRCUiuuxU6c/i2cv98zMU408sUEJuX6GfNMuruwaUaj1SOxgNRbUkdyogzsVPG6RtkoAWI7ckhlN8Wsxj7kIbEjofee3NnIQmXxt4qLnXwm+C0UCtCvroXIrg14Bco+yVdT9ovp8QOD/BpzUBO31ivMLNcjDnmvyb55iTCZhZtbL1fdTSZjwdvscwkkXVA7bJpZLuToYCTsJH2fN1JVGGFa7pQtYhWhig5RyDlVXtg5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=57Jt/XlO7kLsZFK3JDRTa9Isu95SC4RvIHz/AWyCdZ8=;
 b=w77xRLmDW0GSNjEB9P4/Tby6AsMHAh0ap7VbdQjeJhZTT3prcziJTsH9CGrUmD3YzVrj6CzGqMMgrSUo7r5vRDUVr63bNp8WHqqvUFQG38JtNN6JxTSHF6rUC7L9WYjvF1Et0WUHNd/zHWMIYqP3VSHJn98TTdV3WwgciumePx+IE9Kg0QoJIjJxeEx7GB8GvpQTUAdmVJJtgFhHzuZ/biJ1OKTPQCSTmncm5vt4SbJeSZftXmjneyRogW/4sMOZOiYQcTEhxI2HLKHdPtJovN+DDJdnCRV4tRyelm7ZKrpQe5u4UrMXcW/bMeDj7z7/gIgpZs+lDuoKAi3haJYvNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=57Jt/XlO7kLsZFK3JDRTa9Isu95SC4RvIHz/AWyCdZ8=;
 b=EAHs25iNZokxgg7vnJbbjMGh7EJGcFOfPYipWp19od7uIBdQ/jwAbi6DH1p0/0Z5lLCjY+oMw7MasDlGMSlezddXRGCSepdC8FRr5Xi9qM7Dz1vNCc+x8mGhoPJgszElPMFz4YvTDBMWvoHtvR+gAZMrA3WwgS86ivTeLTd5Y9c=
Received: from BN9PR03CA0657.namprd03.prod.outlook.com (2603:10b6:408:13b::32)
 by BL3PR12MB6521.namprd12.prod.outlook.com (2603:10b6:208:3bd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Tue, 10 Jun
 2025 18:02:51 +0000
Received: from BL02EPF0002992C.namprd02.prod.outlook.com
 (2603:10b6:408:13b:cafe::30) by BN9PR03CA0657.outlook.office365.com
 (2603:10b6:408:13b::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.19 via Frontend Transport; Tue,
 10 Jun 2025 18:02:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992C.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:02:50 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:02:42 -0500
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
Subject: [RFC PATCH v7 22/37] x86/apic: Populate .read()/.write() callbacks of Secure AVIC driver
Date: Tue, 10 Jun 2025 23:24:09 +0530
Message-ID: <20250610175424.209796-23-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992C:EE_|BL3PR12MB6521:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d044946-5b75-493e-6227-08dda84903f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SxEIh0mj6sdLr7xsY8ouZy2tASw9EjC5+fj3hHVAb4vQvz0prV1GAD0SRpzR?=
 =?us-ascii?Q?RfpU1Dbg9LY8MMutn/r9SWwd4dvN0dZ8OXg3pDI31sLpLmjUR+/6CjZQOZYk?=
 =?us-ascii?Q?tbEOR3qqZ1Nmdn5wP6636LPDH4CGtuKlcEaO4Hs5jRcifGA8xklRErrHhTZy?=
 =?us-ascii?Q?e8RNFZE/IWMoUqBp28TtGBgCVt9/7peAowbMgl1axWGrbe+tVrd0W5kSc1mN?=
 =?us-ascii?Q?3/WbMGMwht25E+DB5HqG+JoU+B6uPpCiqO89BGI2xj10Y34h764bfHIPKXMv?=
 =?us-ascii?Q?qjViZHClqHgsBbRP1XGo2UoJ0F7IMwRSVDuTaknsQmRRtDcJ1qeROVkRiyWx?=
 =?us-ascii?Q?9ydO27C0hkNwzP5AFzYU2cOX5lUatQvOTCsxfOHAzuTHQlH+Vaerde/gFyGv?=
 =?us-ascii?Q?qy2y4buWlrMuw0kX9bEk4eeZnqWusIzlb1PzhfRzsTO9Q+oLRKMp1dLZreSm?=
 =?us-ascii?Q?N3cVemVz3aYIBzH/R4b717Aoa/ivOE7Gk8/dzCcmGGzuEhrLckb+so2g/Mqi?=
 =?us-ascii?Q?0QZ8jwFxw4tpDM0kp4dooe73WXIUbhphXuf61PP3EInbJeQDOUTKUykXkrqV?=
 =?us-ascii?Q?YxweI7OSTy3gIYFJOueabDtOe3BJRuSXLJHPVEkq0gkABp0T2NvbZRSmRBpt?=
 =?us-ascii?Q?y8C+484xmb6TkqtnQLlGJuYwDSOAqbp0XgRXUMKPr0HrQe8a7v0Wq2NwZeTI?=
 =?us-ascii?Q?n4Iv9IXWtb3Vqkwv5krng5jkccLkrffSRbfg2bkfnLjGKlHkQ/7DZD3Gc3sh?=
 =?us-ascii?Q?ZNDTCLrwu6xrt4NzDUmQHTK0MbCcYIL789RY22/CzdvwL1UsTh1lXGaTbrwG?=
 =?us-ascii?Q?UnFFsEA0Ar93lyn2PRL1VSXBOtgd45c4JdZqTMiFegJWq7amdmE2XVhAakWY?=
 =?us-ascii?Q?mEFAi5Shd2EDQJnb+XCOUtU8wXIPdMHr+l/W97znCrI6RDMKi8HywUHE+A2V?=
 =?us-ascii?Q?vLekRrzFZeMxygPPKXUJwxtGDwpbc5Qb7H756mRJpFxSL7rTKjc9E66rlqNE?=
 =?us-ascii?Q?228zAaA50TWvrBv2k2d8P08OJiNk2mAvcgo5W9Is5+Ngv3flHotx3Kie8CJi?=
 =?us-ascii?Q?CWau1qJTBRDcYRyFrmKhTBrT2T1NVTP6YYa8VMvy1kmajjTDVuFTjyU7GKSg?=
 =?us-ascii?Q?8qRVkGWRK1D3ztJdvMwUtwe5XRoCabXmcSCGiY52EoUyBHIDz+9Lriws2Wyy?=
 =?us-ascii?Q?Bhk2qH6k4McRBvImmtwK5vnODfFv9emzeSmfcflMUs7sUztXlKEH2wOKT40O?=
 =?us-ascii?Q?5paKdyucPVATkBhTkq3Rqc5ZV0yEsdGABojXnhbpLvcrJexgEGoSuCY3/qn3?=
 =?us-ascii?Q?0ZyUFvzYU5OwYl76+n5GmyAHdcv3eShkWKxEKGdVNm6bQgPh8I84s+o+93/H?=
 =?us-ascii?Q?VO+GQKvZ5D8XSd095ZvOFwGVgTCOwKf2ZizWYAkvN4CBus686Y2IG2nUnOZG?=
 =?us-ascii?Q?cnz6Ous06aYWAUxD35qApgVkRTPbI4hSrGQRahWDLVOEfqjmK7Lh14GAkbT7?=
 =?us-ascii?Q?i9XPkiqLrmsIPjRKVH8ld36FEx7M3pUx04F6?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:02:50.8274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d044946-5b75-493e-6227-08dda84903f1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6521

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
Changes since v6:

 - No change.

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


