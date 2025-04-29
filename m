Return-Path: <kvm+bounces-44706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AC5DFAA0300
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:20:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E82F1882F4B
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D823027057C;
	Tue, 29 Apr 2025 06:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aM6zCCWz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BD926B96E;
	Tue, 29 Apr 2025 06:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907466; cv=fail; b=EBcv4NrRxoDYeBpSkTpyxbiqlDamMiZILOFYxzWs2UsgSfFQs1JQhce/pFXAS6yLizWOtK6uG2yuhCuSDySgT3JT8qo53N4VIgucnPQrIqQUzD+D+HedmO+1f6L/92qf/R7w+gvbq0k0pFWpMMy9bBdcQJG8RRBEF7jJk/hhaJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907466; c=relaxed/simple;
	bh=XwInE5mPgD65k5j3rTdS0DS5cTa47PE3BCPfzEoYWA0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qAAOqkIqNTbpNYb0HUX6lCdESM7NOHwkodh2g971SIESEhhhPy6VfgPOjQaVgkGkGYOjhZuGaTXvvG0xchTR741VhqdRyEX5NVHnrwWFSBYPdi5D//+Z73uYoS8cVFYM4DLBOQSZBYL1EJgQJk3gAq2FAEbxo1ZMEpxOOx62Msc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aM6zCCWz; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ATTJY+xO+66Ltr3Ndbxyml+lihAeQCGfdeuY7Dn3F14So75KHLeaO9VHfx84k5Wz3dDGyXSJlpbNXLEKGqt4BzgSqrqwHHr3DlEiClCianCW23EjlSzHjHCL4AwcXMcJPbhs0WeeBW6tZGytZuoGZLn6jDGoh2IvMH0kC2ZkKVxSmTKxkp5pTdL/BEr8mnBGglxJoEHuO5WRZs79vYsrypdC0gGeqZtETpIi2leADA4xNYbc9Tmd+1ygFI3e3M2OH2dkxqjndZIlD2KgGQb7jV9sLVX1WYnRhcdc4Oqou9wo63RpfBzwRX449qBagXmz3BM/yAsErIYprRNlr1m+nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=00Oo2atKXUAjC2g68QjmtzuVISNPgu1yhjPgmKSQSzM=;
 b=KexBufAzVMXFhx3RkRGoroVwUaOng7fQmeGz01yCkWeIPiYL6sRgtif2yRxDzqpmwVgNXNxHtRDSfKkAN2bXb9fN2DXn21TItbDGf/nvCEQKf1jWCWXd0yIXud909UZleL0rz29eSzqGb/A9M0LrlnJ9Pus3e6fpoXVUMDXjOyBfpJyexAYe393XJ9tPYFTUCbT9Y48vPA7om9bTHZG7YUr8zI1F/Aug+V+VN3/V5FNIUE6qEu8lYm38PkPXNCpcHF08dUMfKOUHCTBEaCsBLkuw3qzIpqRbMXKIaMj2+HzQ3ekycWPbsCr/6wvkRJ8ggxF1IIeJyaX/2XjtkVefxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00Oo2atKXUAjC2g68QjmtzuVISNPgu1yhjPgmKSQSzM=;
 b=aM6zCCWzsAXeKPqIceCHmver4L03TVMPJSkdRKH9NPNR+nOmrzEAh+9FyRMZsvqoMPOGCdaWFrcCT3q6jFIgzGyqPNIgh9w9zLWcJM971Wr+3ARsOrMlaa8XQDRn+qqee5/EN3zVUrXhuPELrZqLL8C5choJnhFO2JBOtSzjucQ=
Received: from DM6PR01CA0012.prod.exchangelabs.com (2603:10b6:5:296::17) by
 SN7PR12MB8170.namprd12.prod.outlook.com (2603:10b6:806:32c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Tue, 29 Apr
 2025 06:17:40 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:5:296:cafe::e) by DM6PR01CA0012.outlook.office365.com
 (2603:10b6:5:296::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.41 via Frontend Transport; Tue,
 29 Apr 2025 06:17:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:17:39 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:17:27 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v5 18/20] x86/apic: Enable Secure AVIC in Control MSR
Date: Tue, 29 Apr 2025 11:40:02 +0530
Message-ID: <20250429061004.205839-19-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|SN7PR12MB8170:EE_
X-MS-Office365-Filtering-Correlation-Id: 29bc1006-2cbc-416b-dafa-08dd86e58b3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a9brD43VfN8nSsuq+gwMwvMux72WYUNyoJb08muSpJGYgdO5+pBFwQ9FzVcV?=
 =?us-ascii?Q?ZF3uJ+MVe9Vg5MjcD9vFz80P2SpMMJit/Z4iMXL9SXTV4ABngEfrsNwEtagp?=
 =?us-ascii?Q?K8rccAoJxTwFa7b1Ya5Jx9b6GVzS3AoDiI0L7CSzft4NPTn1Siaa0V4UxC7Y?=
 =?us-ascii?Q?tMSDg1dua4Jb0YvtdgG/r6og2bMIYDaxcohedW3o1r/vS+3Uwd0BKJp2be9r?=
 =?us-ascii?Q?p78SUlpXp9VfvI92ujNGftWn6XBdjOP5jgMPyNCuayN6tsVKxNvTQfqsWYbT?=
 =?us-ascii?Q?Yl0BnOEVAfnsRV25rYLWFwRDKMfZsIlNFaCttE8k72zhXq+SCZjnDGB2MptB?=
 =?us-ascii?Q?Cw8vQwOeSAbjsnwUGBZKJP50f9txbKBsBD2+SwzOAw7e4QwOWb1qE9Jl4wYo?=
 =?us-ascii?Q?QAGfoJ2fx9DFZI8udpch1Q/o/JpwgrCI0j7+i24PsHfVASGbuZ24CLt/dH2i?=
 =?us-ascii?Q?f+HgwqVgE/WNAn7oh77mLobdIe9v7qL2mb2Nca9vy16Xqm2saLRpAnNWrLIc?=
 =?us-ascii?Q?8QNcFpodqaYa6nfJFOmc22LV1jlsIiLRJQ6vXVaFuZ0PDHRyOwr0Us09Og4R?=
 =?us-ascii?Q?yPyZZYD5HKScG58gi4KQ2T7BWxH2Izz6XNdAWw1lcATrIfQmhhfdAYXG+ue2?=
 =?us-ascii?Q?n9bxAkdgB3gt7nun9Cvfnt6cwAQexNP/u0JsEfJDLv/VTdMX2jSSbQpZt6cN?=
 =?us-ascii?Q?RK1M+CJMWQjjeywO5P7KU0Qhh2IutzjncSCc13KeG8ayT6bEdi5Ods67QUWd?=
 =?us-ascii?Q?2wE5DntKZKL7hoh/O8wmDplUJWdILuMAjdSllqpXdG30Sc5mijsRnBv5uYm0?=
 =?us-ascii?Q?6uoIZA259jabwrXO/kr9h7lcg0VP6TIGMhUIfpbBJ2H+kmcCp7m/fn6XPJjY?=
 =?us-ascii?Q?cAmDWsxbNbcORSlEUFB2e0OY0wyz61y1hr/RBp9A2lz9+Gw9EJypeqKsjQFR?=
 =?us-ascii?Q?FyHiH5ztnx9zxbznSyaLFJhk3AcP/LLtVRLJSsPenvaQpbinBETbukwSe0MJ?=
 =?us-ascii?Q?5XRVPB9yr1YVq2JQusPq8tmkpt+hdnk5G5AfJANReMIWUFEtSoXZb35zPpPq?=
 =?us-ascii?Q?SrqVxU+rE4AGMjLhS2RrXug2TR/TrMMKCULkeB632qc/0ovtAwRiNjFMSYlD?=
 =?us-ascii?Q?H3sZenYHnIgP9iAGsG4IiJPzoaHTicxSxMvY9vwGr3WABjA0q8RdsMaLt33l?=
 =?us-ascii?Q?SrkRtKVyMYkdCQJZosHb7lVIpCPaPlNVZ1Da32uSF8ojHWamX0gPdKgID+YC?=
 =?us-ascii?Q?qUKckcu/7J73yOiBNxDCuMOZoa/Ezm/fd/6b4Ci95IjURrL2rXoKeQCgVWSS?=
 =?us-ascii?Q?NxHPG5cOocrrnsQKSPPbfgTUUNE6PFG9urr2jZ+WSOEi63uXCPlqeMPdlA6a?=
 =?us-ascii?Q?H9kRZ9y504UCl2JUsjfgBi5Jj8+EDvh8W0R6eR5DwfssjvYm7DZQo1QcQA1c?=
 =?us-ascii?Q?nX8M+fgv8adEpdjyLCv10iJSynwe0gMqtt9h8JbpJiTZd6n1n5aApTaTU+vK?=
 =?us-ascii?Q?w/tsQYXzNBvJv+gHGGYUIS8SN3+s/WTxTr6l?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:17:39.7287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29bc1006-2cbc-416b-dafa-08dd86e58b3c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8170

With all the pieces in place now, enable Secure AVIC in Secure
AVIC Control MSR. Any access to x2APIC MSRs are emulated by
the hypervisor before Secure AVIC is enabled in the control MSR.
Post Secure AVIC enablement, all x2APIC MSR accesses (whether
accelerated by AVIC hardware or trapped as VC exception) operate
on vCPU's APIC backing page.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v4:
 - No change.

 arch/x86/include/asm/msr-index.h    | 2 ++
 arch/x86/kernel/apic/x2apic_savic.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 9f3c4dbd6385..c5ce1c256f1d 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -694,6 +694,8 @@
 #define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
 #define MSR_AMD64_SECURE_AVIC_CONTROL	0xc0010138
+#define MSR_AMD64_SECURE_AVIC_EN_BIT	0
+#define MSR_AMD64_SECURE_AVIC_EN	BIT_ULL(MSR_AMD64_SECURE_AVIC_EN_BIT)
 #define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT 1
 #define MSR_AMD64_SECURE_AVIC_ALLOWEDNMI BIT_ULL(MSR_AMD64_SECURE_AVIC_ALLOWEDNMI_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 7ba296ba26e3..b7caadd1b33a 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -363,7 +363,7 @@ static void savic_setup(void)
 	res = savic_register_gpa(gpa);
 	if (res != ES_OK)
 		snp_abort();
-	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_EN | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 }
 
 static int savic_probe(void)
-- 
2.34.1


