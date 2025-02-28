Return-Path: <kvm+bounces-39669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B96CEA4944A
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:01:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD5A27A435C
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA31B257429;
	Fri, 28 Feb 2025 09:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XjWWX8Dm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980C0254B1B;
	Fri, 28 Feb 2025 09:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740733274; cv=fail; b=i7Gf7e7z6sqLZBKSbWuvDTPDJOW4ai7kjlFR2ZEMga8E6vOKz6/8wweVmzkTWAMR1t384VHy3MlarNmTdWpu4EDxeABk7pfQF4YTKP+Kp2pLXcZqFCZPRtypfZ/u2JHrQXlvr7+K4nBVx5J4eexiuVlI/Ilh+Bi5551a8+yPjvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740733274; c=relaxed/simple;
	bh=fFBcyQPcVRzIA11GLdfiP2bhx+5xYIgbDsjiUqti8/I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ayAkOETNN302FmgouMK0VDJdfmrtPzYAghemOmZcG9ppQsFLjh8PM7SPzxmieTE2PWz2Oi9b7of6QIGo8o1eRNSZ8rNZ0oDMl/U+F6mQMUV621S1EWR7ub8NwlcSuqFEUCRtBWPENgWO2mBEZjFBYtcHi9/2nlA+12nBfIDy0mc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XjWWX8Dm; arc=fail smtp.client-ip=40.107.244.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BYtR8ieA/Pl+k3fl01F+3xlK1/vWhhcFN2lSyO5SAaxBsEexAPjJuE4z45kcMQ153edny+6f62CgCGz4ftrVGqbC60AmqngMtJZpEKtz5dBZzMfuVXJkJPB1Sua9f+sMEwBdZnp6YRgSd9XNAY3JktjkyKZ/F0Abf7wKa02VkUacIVuGX1MObquvWCG06E5VtJtL8OOj1Z5vRPBOTPXtBg8q334iT2+HyZUirNcbD11tqmyKosiHsgucEKppZHDH3O8yZpBHmSHUvJmpemRyyAeUiEN4Mp6qLVOEVyvYA8uYQvxE62MfS8O+oJIi4oRQ5Y9DxA6aY8dR7be7IbZO4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9oExLAbdy9++h3fPmDSbrv8v8y8GidwysKt4q1TF20=;
 b=KOdTLFyV48nVJeXm42HsJrkNLqc8Lulnp5HeHRHiV6qWqzao3sW/r0/03U5VdzdzMCcmPw4Nq3Wh59zT6rjtCwI8KntZLmICr6Ve4I7TJ9u5cGM82AMk2lV7/tSSnQj6PCnZ0xb725rwZHSOG8U15FdXqB9vnd0AxefdGlWh3m1XRKYNvX59QyUm+2tLhz1stJ99KUVLsXAk5axMpw7DZTzG9r5QYyY/jYJ99JlLMJ4hkizlH4rBR169RAN58dOac1EzKQAg/5mwCzgnhxFBgMufB8F1ruiDcOcCSB7vs6Bl17gi5wedc10qCABXyR31HK4dCtbttiVxKVrjAC59yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9oExLAbdy9++h3fPmDSbrv8v8y8GidwysKt4q1TF20=;
 b=XjWWX8DmBxwdRPonudmqto7jotC4vLpBbJwtphnImUO6bg28Bi8ZSjOmUKTWaD3IZAVxKPbrbj3TkBR2cyz2Zp7isk83HHAEY7jS4/mc/YhieGLaZHBrqzrSW4+wvc6dSEdlzURi09Svs6OgpVz59WKEIg1cngEzz3/2YkigjQg=
Received: from BY5PR20CA0026.namprd20.prod.outlook.com (2603:10b6:a03:1f4::39)
 by IA1PR12MB9466.namprd12.prod.outlook.com (2603:10b6:208:595::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Fri, 28 Feb
 2025 09:01:09 +0000
Received: from SJ1PEPF00001CE1.namprd05.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::e3) by BY5PR20CA0026.outlook.office365.com
 (2603:10b6:a03:1f4::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.21 via Frontend Transport; Fri,
 28 Feb 2025 09:01:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE1.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Fri, 28 Feb 2025 09:01:09 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Feb
 2025 02:57:48 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <bp@alien8.de>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <binbin.wu@linux.intel.com>, <isaku.yamahata@intel.com>
Subject: [RFC PATCH 04/19] x86/cpufeatures: Add Secure AVIC CPU Feature
Date: Fri, 28 Feb 2025 14:21:00 +0530
Message-ID: <20250228085115.105648-5-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
References: <20250228085115.105648-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE1:EE_|IA1PR12MB9466:EE_
X-MS-Office365-Filtering-Correlation-Id: 82ef97a2-e44f-420c-4e85-08dd57d6715a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gbe49Knkl5HRMYL+wuGYfCPXX/MP62JvbO7QBT/bf86Oww6JDVkZ2WD+//eH?=
 =?us-ascii?Q?Gfm3fc3/c6N10ia55KTY//LVQp/pitOACaLos3G5zcJ0gRV2qkBUDMkT1gw9?=
 =?us-ascii?Q?kNXGmORCgAF5abfRr9GHs9d6hIZKJ6QqWV7kvyAqcjZoP7gZCDyiHbPrzbPN?=
 =?us-ascii?Q?2oXOakxpYA85JaeJfFyV9K4hO97OghY1qR1xXY4l6kBy+mifLUvH6spOPm1J?=
 =?us-ascii?Q?VCMIvfagEIOjV8BF4JYi30nBucglyeHzwUDLfR201ViZnNEnBZFmFpG2f7fp?=
 =?us-ascii?Q?LvdTwHhS5zDhkEDdry8XIPt68goIJdtkgolbWsTqzM5luv/gpooNRGbmNLBI?=
 =?us-ascii?Q?43NUzMfVbhS/OV7LEhjYh1hE59NksrtrCWfdz0ZPmYrkLM3cNaV0mKqz7c2c?=
 =?us-ascii?Q?EHuDL/Xm8rNgqyILIYq6EY2ywJE1rugrKOtrBnUAXHgUYTfx3/DB7Tij1wbk?=
 =?us-ascii?Q?dKkRUCBAbKSvChmYwozKzoUUETFlWQrKYOKlBEhvgvcWiJLbcDf/oO6/zrN4?=
 =?us-ascii?Q?FNoawI4f1sRvwoVFhb4LVw6hsKrUr7Oz0wZETEZSnKfBaEvrIBNP+BO9mpA3?=
 =?us-ascii?Q?Sn3X6b7dbj8JWfJYq6fb6kE59ymQfjmt5A1zWJEtKohj0dQhcl0glTPMHY6w?=
 =?us-ascii?Q?Uij+/jGtQli0XKABCNzsmDkTRTn6dTGqsBz7aJU+1CIeCbVktUN3mzIdIMDv?=
 =?us-ascii?Q?sMkxHU/hXi9IquMg66vy6kosZAnVfQxWiD17QzC5WY4e9lB/nNcZJoPqWC4H?=
 =?us-ascii?Q?WhPwx6EDTDNjsXKCzL26bfMLHLvORSJZ7wrBMp3jsZY1Ix23hJ1x6zaAbQG3?=
 =?us-ascii?Q?jKr6fvzLoRI2w0cz92xITzjw0LMFreTEiWdn33fE3c+Xj45vUAiuJ1lP/mvu?=
 =?us-ascii?Q?6Eyfmr59y7GBN2qhZVmZ0wCuFTT2vwM9SnQ3erlJk3TY+g83qivWR10hjRh7?=
 =?us-ascii?Q?CTV0IdO4vXfDRLGnwnazQR8proie6yicmmi1VoAcbxWWmhjqHkIEIA4tYtdh?=
 =?us-ascii?Q?lJJnCuQJBuFO/15g9KraRnU61jVtiuhhlRKrKsTSKPDeAENPHGdMC/WvtyCW?=
 =?us-ascii?Q?ZQmskwXbxwS8FHfY7UWBcA9OTySLsN2RjRwPbflTglqXIIJbXG+ZPajQeRYS?=
 =?us-ascii?Q?ok97zqdBqo2HyMxN3dCdf6zRDPu2kdwYIR55B8B+19MsaOuHRextXNJcRKr2?=
 =?us-ascii?Q?jV5Dbb/EmCvaSlCjjnr9Z5QZCtBR0jYko+RbYStWVvsoILim/wnBlWDRL4Um?=
 =?us-ascii?Q?vYwMe0zu58bBLO6mGqMijbakf46zGpQBVs9BH1L8Badf8Vcmwu6qCSklVIEo?=
 =?us-ascii?Q?Sttj/Lpgl8Hsl/hqo3vBGBq1zdaDIjcHejFjxi81iRpEmR/Zt3VKHEqdC4+s?=
 =?us-ascii?Q?zRsroyo3wVH//3ZiNk3wMPo6APJHI5iqTnXkecDVVzvdpX2zn4QVMJBCvbHb?=
 =?us-ascii?Q?diQ7i0ccfPVArhxsgs8D7OswnXdGkl2MoFuYE4KBuItU/CRBjdgfB2tbIFhN?=
 =?us-ascii?Q?42MHGju7E3TWRtk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:01:09.1746
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ef97a2-e44f-420c-4e85-08dd57d6715a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9466

Add CPU feature detection for Secure AVIC. The Secure AVIC feature
provides hardware acceleration for performance sensitive APIC
accesses and support for managing guest owned APIC state for
SEV-SNP guests.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 2ba5c11941ee..a63ca1b34b3a 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -452,6 +452,7 @@
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* AMD hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" AMD SEV-ES full debug state swap support */
+#define X86_FEATURE_SECURE_AVIC		(19*32+26) /* Secure AVIC */
 #define X86_FEATURE_ALLOWED_SEV_FEATURES (19*32+27) /* Allowed SEV Features */
 #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
 #define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Allow Write to in-use hypervisor-owned pages */
-- 
2.34.1


