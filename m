Return-Path: <kvm+bounces-56097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AF63B39B35
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:13:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1B3A1C80FF9
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3853A30E0C3;
	Thu, 28 Aug 2025 11:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0cGJZ33U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2062.outbound.protection.outlook.com [40.107.236.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58EF30ACFF;
	Thu, 28 Aug 2025 11:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379588; cv=fail; b=LFk/KbEB9n6fIruvmca+wbHinmDAdHSvRzYc7zvLrQ2NDYfMkGWwZH7DZwweRFS3vbm0EEHr8aS7m8EyiHe2LCIuDmTwGFlVhG12/yW5WXTLcps63Y8016hesF8MnfECWglBxPhJEbseAhM87Nw8mBOD/bu7Iou1kdIwm7ahybI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379588; c=relaxed/simple;
	bh=iA6kegTmBIKCuqXVPYrUuBkCpDsFmNviXhVEgN+rYEQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XFkf+XtV0YF/qT9sImR2VhTmAoLc4jMBy3ykVqqbt2gaDehzS4SPHe/oKQsNiECADevP6wnzWjhirHzDPHsWwXOnzultiBkrSVJ+9/XD/wUvZA+Vw8YhtiGPiA/y+HiDzUBLzjpkWbx9mJYYV18bOry/d5+piKl1ma8L4Z0S1co=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0cGJZ33U; arc=fail smtp.client-ip=40.107.236.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kLvhMUIGA2bXyk/PQCNCCKMJ/uVTsOhZGqcr/uwaoD4cQ3qvS4reS3BGV+ev8luHKQLuU+RqglpViNEHvQGv1QCYVaScgbIYMBlRtQI5FZlzldvP9zdkYie7hRIx5pE2s5+5tO632ckzVJAXixr0VZwf1FCFPjRbHV1H1h0+WUAGxgXPPrBZzxoI/ktOe6Wgi4A8F+vXzwrxJm8Tokjk8ZGpL/vfV8eRcqBXoOndakRwJUj5ZRYITCVsm+HPbTwyPiRLRLFmHQ9uQ1iLatjBDoscPXkOcE+iCrQ568Hv+fR89Bz8K3zgOB2eP/4G7XjClZeRtlofZMkwpHIJNU/j7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNdG+uDF6NZgf+sciG8/J+zfb3tTKwFhu0gXg9/4En0=;
 b=GJ8ZfUT/Rq8N5nq+RDVgo7Zz80MK7OKOY32IljAR6DXvu9B2DrwOdjp+AgFhr1mf449edHlOoQ4sNk3KEDph9KutnFDeeET7jjqQHQinp14gpg7ud2ZydfMwYqWkrQkKjklChi72vervGBdOfOFqvoJ9FnjEF/NxPnCpScPf04VmEzGT/1+aKMpOuebUXLyQFoccHtIZfO/imGN6PFQxzxURK5Vz25nAK77pqXEy8TvcSo8/2AjG4Ll4I41BMvJydQ4iLZekfqADHg/XxEI5X0AtTAzGE6JG0uJyNNxCRC2p3D/KjSLfagceRMwU8Wqu3YQwlzr+gmdWJnrkZq86Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNdG+uDF6NZgf+sciG8/J+zfb3tTKwFhu0gXg9/4En0=;
 b=0cGJZ33Uwqu9UUArEzgxVgdYGh0OB88rXyImGivMGFQpaoP+H5wRE9iKtzWoLJnmgKja7BhstO6n2cSVTzhlfT8pW5IxChijc8TXe9UGeQfrEIkr0B/qeNiVPW825pDu1w3WdjNPR42vVmC6V/HPxDNZXCUBOQkFlWJGlCdndo8=
Received: from MN2PR17CA0010.namprd17.prod.outlook.com (2603:10b6:208:15e::23)
 by LV2PR12MB5774.namprd12.prod.outlook.com (2603:10b6:408:17a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Thu, 28 Aug
 2025 11:13:00 +0000
Received: from BL6PEPF0001AB59.namprd02.prod.outlook.com
 (2603:10b6:208:15e:cafe::a3) by MN2PR17CA0010.outlook.office365.com
 (2603:10b6:208:15e::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Thu,
 28 Aug 2025 11:12:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL6PEPF0001AB59.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Thu, 28 Aug 2025 11:12:59 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:12:59 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:12:52 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v10 11/18] x86/apic: Allow NMI to be injected from hypervisor for Secure AVIC
Date: Thu, 28 Aug 2025 16:42:43 +0530
Message-ID: <20250828111243.208946-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB59:EE_|LV2PR12MB5774:EE_
X-MS-Office365-Filtering-Correlation-Id: 546da022-4b8a-4883-3fc3-08dde623d932
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NmMrytSQTM/CYzHkYZrTCGYh7JQmBy8viKePt8+o9tkzMzjz0Cka31k5HegA?=
 =?us-ascii?Q?TcWtljsVFFihyFXB/7Fc+3MrMZM2G2dzQhT2AHbZMMbMjA6r+m4aD30NmNyc?=
 =?us-ascii?Q?a3xEjCm09UXToBh13Bc4i1L5q9MBx/JHgDtzigDJqVkLuKuygbQhXU0jdOtx?=
 =?us-ascii?Q?Al0bQkBNqh6ICdGqmpT4C8j4G+OtlrTpqaEBxCKMbKauZiiorGi7S2vOjNOT?=
 =?us-ascii?Q?T1SN3OQth/qjlr5yziEESOym7kXHuh6NiXDHUTN2OParqhhze8EKkkwo4Ml4?=
 =?us-ascii?Q?mzfcrH9IYvpybTA8qhgouQ3CfqGvW8BRdS/Z1RVLG/wHTekwxAajt2voqvzz?=
 =?us-ascii?Q?bNGBmDp2ZeSUL2X2awRl1ldrwIbLI0+hahwsaWKYB2YBMUiXowItOEqDhhb0?=
 =?us-ascii?Q?yl/o2ylJJiYIMU1RQbLTUFgHweabKe4ZsLaUA/SecR0mMUtd7ldCkRhHTB0z?=
 =?us-ascii?Q?TOtd1vGqlMJW++7BuvYfHiRIcafg65m1pRRkqANEO9K9eE9pUM9Fizu4eSW2?=
 =?us-ascii?Q?/otgqekpk/NHaFlKK+TQXtckJYVHTqWD0x22oOXa+37Jibn+GZUq4jj6kcDj?=
 =?us-ascii?Q?8XScoeuPjEOjb6G3mMOfe4aInQKAspmoUi7BoAtjdNS8GdrfRqcWihDrjdSm?=
 =?us-ascii?Q?H09s5D4oUV5y8LaO4SzRPafd/OfIha8bFEVUmZzm3NHID3qSd+GI3b8FRF7B?=
 =?us-ascii?Q?YbMeUpGoT9bJwGk/HW0yxQdzzC/56+AfWSrOfEYTnDuoN+pPopcMHS7kXCWB?=
 =?us-ascii?Q?ej1LlqDHzBYbBoklBNOo0Z/yX1o29oOturOf0bFU6H9+4Y1V9uWuaIoBmq1q?=
 =?us-ascii?Q?1cDjE71naUOEnkyW+j/BrZnyuFEwAY6mcK1Gg1Bwgzw5drjFfgyHF4e7rn/l?=
 =?us-ascii?Q?VGPWauG7Cg4th5CYw6BUdZNcKqRTJiE0AN3Owyo/x9FBpATmxYcZLoE0/lAv?=
 =?us-ascii?Q?7MhUjFnJOQGgncfd78WOQEX0nrXmIS5Uc8U0qow0Yf98ilgeTmNBhG2IJxc/?=
 =?us-ascii?Q?LWPewTuAh69JMpi0mfxlp7X9q9BTfdr4kciH75l0LXP8AeW/rQNIHiW1Cb/d?=
 =?us-ascii?Q?iUSTDzLiasr5s9jQ19/v/KFI2L8ZjDhyHKEc6ujTDrbl9fmZV7lrWIesGgeA?=
 =?us-ascii?Q?WXRIZbIN3zBUVzp56IM+HLteA6VoZuQapyP0zs0IA+pDW2w3E65Qd0MnK/NY?=
 =?us-ascii?Q?Fa0Uxair3ngw+41J6wA8PDtHOKJPBoqr8WKiheYAp7EdqMc6QoxKVXpFvPLV?=
 =?us-ascii?Q?YzPKjH6c4e4VJgrbMkk8Wh5Je8nnKmyDTZTaT2BmzX7T6onceKDQjG1NI9QK?=
 =?us-ascii?Q?aAbByWnutjkBwI+u2NW33QOrcLivuSYTwxaOMJA3PbHzECHbMzAxHGGclZ1a?=
 =?us-ascii?Q?MKanUXovZ6F4KTTVvquVv6Koe0TzImDuPr7XnlRkYReQBBg4n0xZsDIevjIb?=
 =?us-ascii?Q?9o3I7rcszLysB8MDrLkrOtURPXgbRsTv4l1PgqefbOAuvt++RSM0mhdpsMJX?=
 =?us-ascii?Q?zHLUal02WNyM3UUCkMt3BySuK+IhyRUsVobZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:12:59.8227
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 546da022-4b8a-4883-3fc3-08dde623d932
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB59.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5774

Secure AVIC requires "AllowedNmi" bit in the Secure AVIC Control MSR
to be set for NMI to be injected from the hypervisor. So set it.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:

 - Commit log updates.
 - Rename SAVIC_CONTROL MSR and its bitfield macros.
 - Drop savic_wr_control_msr().

 arch/x86/include/asm/msr-index.h    | 3 +++
 arch/x86/kernel/apic/x2apic_savic.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 2a6d4fd8659a..1291e053e40c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -703,6 +703,9 @@
 #define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
 #define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
+#define MSR_AMD64_SAVIC_CONTROL		0xc0010138
+#define MSR_AMD64_SAVIC_ALLOWEDNMI_BIT	1
+#define MSR_AMD64_SAVIC_ALLOWEDNMI	BIT_ULL(MSR_AMD64_SAVIC_ALLOWEDNMI_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132
 #define MSR_AMD64_RMP_END		0xc0010133
 #define MSR_AMD64_RMP_CFG		0xc0010136
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 8ed56e87c32f..bb8d4032dcf9 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -328,6 +328,7 @@ static void savic_setup(void)
 	res = savic_register_gpa(gpa);
 	if (res != ES_OK)
 		snp_abort();
+	native_wrmsrq(MSR_AMD64_SAVIC_CONTROL, gpa | MSR_AMD64_SAVIC_ALLOWEDNMI);
 }
 
 static int savic_probe(void)
-- 
2.34.1


