Return-Path: <kvm+bounces-67002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FDE7CF2160
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 07:38:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7191B30222CF
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 06:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 789BD261573;
	Mon,  5 Jan 2026 06:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SjAxZ/A8"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012012.outbound.protection.outlook.com [52.101.43.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878011BD9C9
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 06:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767595034; cv=fail; b=sMxBgCIYAOQrJa1f0fi+QZFAUVHOVek28Q2jMW85tBCtBLIlo33EJjUiamSUX37hReNwc1ILYlVaTWoeiIS02fmXVsZWaE84Sfh+IVpdIwNu1e2/XnMidjfMd+7ndZzsW/98DDUNPl3JYx++5bBM39tGgXX13UnJqv4rz3pps30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767595034; c=relaxed/simple;
	bh=YKrYYEJdw0OHc5Nv4SDfjdtVk0dWtboCn/xkQu5Kpjo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mBElTPD7P/XOX0ZCKwEvQlWMcpLxaQEckl0R5mJs4tO9LaI8KjOy7mijqZ83zmtmyWnfdienCMF30zOTP/3j3BaDdrppJIovr4ErFHb+WrvTe8Yld0UHmcd18TVIDn9pBdsIvVvolDTHybLFLDbvErdohScunq+YkzUNLnzgV6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SjAxZ/A8; arc=fail smtp.client-ip=52.101.43.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ABlGLyOvS8iEpZwLAYFWihhLnRQu+s+quX0yEOyZ82Gyiq3ch6ixnGVvWpLk/TKTYL4enpjvQeHafcsZyhefjq9TCZUiBfsEIZK8SAzMmh+cqoXankmEeXurtbVOAWBgq70QIC6lpPNBp64IueDOmoywL17u/B714TbC+OOzbFdkYDN/4wZknDt9EJEQ9w1AU3zR1dwVAO68CnZH6NFy+dxzrULXgAYJI/AD/63x+zwduyR74wyCZHlORuneK7KNfQBJXeqV7REHIbQJRnX9ZvNWzN4tfCbYSB7ABP9TF838hd/lC9RXd3wD4DsZybar1VkEOHhpYSxWmflJKyYPuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0utvYGxJf8FgwNhrvD0MYooyA3OyR14I9s8ZM/kaQ6Q=;
 b=QriheeQ1t6l9Nw9vf4abxL3xBRDI0iwphNLG/f3nh0D3yYCjnRHf/9ig0pzyI/GlLAeC/VEFmpBrrSPPP7IIZJXTbOHZq9a1iEMHXFqO2ynnf3dnxiJKxDiri7c7oKRvsiPaAH0wQFv176BIPutPKyfSM5dNg2y67mhoDni0ZSMBs9molKu0wHpnQFySxOzKTLo6mMkjO33OeCg6sxzZpEfYLq7jwqmeeK9t44ur9dEfoDKb00HUwuodztRRzc0eU/Ombl+6mPfVQlHhcZzdTs4kNx+rlFJwEiXGK4c2JbDRF5E1i5bOLh8rtsBbqPJsBK2KQFx4VoSybfqdxQGU1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0utvYGxJf8FgwNhrvD0MYooyA3OyR14I9s8ZM/kaQ6Q=;
 b=SjAxZ/A8OxDylOKwHMcCPlb91mvCBS33XaXCMeGnwT7h7JUnp1gCtTZuY47A8UNU5fL4UO3WCL8ZvtnT/rLg/yQRc6pjY98HW4ApX1pb/fQveb2bTJ7lMB86uTAQRWwgHkGoxkslNz0R6Ge/f4k+zOx4W5mfzI9kbziwXYt9ibA=
Received: from DM6PR03CA0088.namprd03.prod.outlook.com (2603:10b6:5:333::21)
 by IA0PR12MB8351.namprd12.prod.outlook.com (2603:10b6:208:40e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 06:37:08 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:5:333:cafe::3e) by DM6PR03CA0088.outlook.office365.com
 (2603:10b6:5:333::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Mon, 5
 Jan 2026 06:37:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Mon, 5 Jan 2026 06:37:08 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 5 Jan
 2026 00:37:04 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v5 5/8] x86/cpufeatures: Add Page modification logging
Date: Mon, 5 Jan 2026 06:36:19 +0000
Message-ID: <20260105063622.894410-6-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260105063622.894410-1-nikunj@amd.com>
References: <20260105063622.894410-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|IA0PR12MB8351:EE_
X-MS-Office365-Filtering-Correlation-Id: f317c84d-a2a0-48cb-4a7b-08de4c24d98a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n/qveSnBqsOcFLb6+SUTKIvPiheIyX50SmLmHPShsnfRitKUIZRqmB4YLawr?=
 =?us-ascii?Q?G6cj/mzwpvn4n9+lc99WYAf3UUP0KYEGe8egfICgNPGDggqzLJF87fHAur1l?=
 =?us-ascii?Q?HXKp7r3WJ4dy9JuBPNAjF+lqcXmHcMv8pOJELiAIsKewld44FUtyqPzC5ho/?=
 =?us-ascii?Q?7XL3VtMY4o0r25Vy8H/DrkuSNVbPn51YhnFzQjlxifgtlISzrHxjuk+ZoHBm?=
 =?us-ascii?Q?vcVQSFhiDf6hRQgEPUeYXDgasCwukDOSYKSfWvth6LT2TBrT4y4dgF6uBDD3?=
 =?us-ascii?Q?EENbFEFNwk8BgPtRdaGcixveFYAszQI0AQ3kNHZ+Ffj4FMaV/lnDPoUZHKME?=
 =?us-ascii?Q?ojt2+dblZ7mnGDsRtp+EpPFgYlKSdUbVo6sZKYSX863UoqP5zXBrbpd9U5+n?=
 =?us-ascii?Q?E90vkJZsnx2O3W4XdDQwCKwo/TzgtwaX+bmD6HF9CJ8odKTLxLqIhjhTzFsX?=
 =?us-ascii?Q?4dVUdH0MHDIbTDYyoZOWcLBPIgkRl8tHoEbU79HBLnnwlzVv1Dh5DSY2eqhd?=
 =?us-ascii?Q?AXUUc/LESLc/j9FcSAXAFLmOtzBl0XN7cKjdTI+Ecj2IIiXCFsrR6W90VhIc?=
 =?us-ascii?Q?mMPKj6kC/shMvlx0VbGOkdAaKsLjJ2N1FnhH/GA8oNvNMfaYEXG7CGfP4laA?=
 =?us-ascii?Q?SpElkH7GkyeuvxUIlDlwwWETIud+OO3qGUolShDCFIyl55LuSEaJyZ1QVdp9?=
 =?us-ascii?Q?PLeQSYswDtPolX+d7Q4y05schN4rwvNYM5NuELjQedwe+Tc79wvxP95Euk1v?=
 =?us-ascii?Q?1xfiRl0ZY772aojSgK7b2+OeojlBOTbsVT1SZguglEHnfce6FpyyB+vmIVQ7?=
 =?us-ascii?Q?IWPiRDLLNb2nJ+n7LFDGpMMUl+8dq1EZy7Hi+40c+S6X5675+a30xuHblUIM?=
 =?us-ascii?Q?eJPeryHJbSucB3rAfNJHJtzplNfdUPw35Mzec8BoHqssBivzFsLl1hhGvbYR?=
 =?us-ascii?Q?6/9gEgiC0uUIdXT7oHa/rw79iH6x3NJSda2IbzMo0m96knt6UClO1beBgzXH?=
 =?us-ascii?Q?loxBLnVB1El+PrC7lbcSiuuXJClopolfTNkNa31CP3jcVg1NhZlui4VAn6Ro?=
 =?us-ascii?Q?Wke2wMQf8SJDQOhQ/JCNThyfIIJKzLRxMlkd4o3zsQ0T78troiK1zqMeXmhD?=
 =?us-ascii?Q?+rtUyxeRUqHReT+CxHs3+iuI2Yn6vL2sPr4Sy1tqr0v5Bkt52gmwItvHlUQp?=
 =?us-ascii?Q?HDY24/yJG3mEDrCr9f7dT3ZFRWWqkBcGF5tNUK8IbV+cUcO+fOWtV2uyglkx?=
 =?us-ascii?Q?tXZyv1wgYgdxEKmJQtLLAcC5yeFKZiz5G7fypX0hXmi795Bu8PqC2f9ZyR0p?=
 =?us-ascii?Q?UirpmH500C7XV/w2dTkKeeAQInGxjuYvyBW2kaXr+u16cIKfHUdf6OuVEahS?=
 =?us-ascii?Q?MReEh9zOhSMSrD9m39QRWpBoofL0/D7+W64WERwqBU4Q8VE1Evk+YfS3XwHn?=
 =?us-ascii?Q?ssTHEqXWOfjWl7fYzZcVgbkKcBTq3rvxbSWxcfxfLkFnJukT3Ki0WGrV2Jm/?=
 =?us-ascii?Q?rb+ScE1mEc+rJO5EktY1moSGDjONkvunk6ntQYPhrj1CjgOwoH1Rn71oePra?=
 =?us-ascii?Q?MXNeoewcaHmYQGyxgfw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 06:37:08.4653
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f317c84d-a2a0-48cb-4a7b-08de4c24d98a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8351

Page modification logging(PML) is a hardware feature designed to track
guest modified memory pages. PML enables the hypervisor to identify which
pages in a guest's memory have been changed since the last checkpoint or
during live migration.

The PML feature is advertised via CPUID leaf 0x8000000A ECX[4] bit.

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index c3b53beb1300..235e4745c6f2 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -228,6 +228,7 @@
 #define X86_FEATURE_PVUNLOCK		( 8*32+20) /* PV unlock function */
 #define X86_FEATURE_VCPUPREEMPT		( 8*32+21) /* PV vcpu_is_preempted function */
 #define X86_FEATURE_TDX_GUEST		( 8*32+22) /* "tdx_guest" Intel Trust Domain Extensions Guest */
+#define X86_FEATURE_PML			( 8*32+23) /* AMD Page Modification logging */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* "fsgsbase" RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 42c7eac0c387..cdda4e72c5e6 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -53,6 +53,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PROC_FEEDBACK,		CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_AMD_FAST_CPPC,		CPUID_EDX, 15, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,			CPUID_EBX,  6, 0x80000008, 0 },
+	{ X86_FEATURE_PML,                      CPUID_ECX,  4, 0x8000000a, 0 },
 	{ X86_FEATURE_X2AVIC_EXT,		CPUID_ECX,  6, 0x8000000a, 0 },
 	{ X86_FEATURE_COHERENCY_SFW_NO,		CPUID_EBX, 31, 0x8000001f, 0 },
 	{ X86_FEATURE_SMBA,			CPUID_EBX,  2, 0x80000020, 0 },
-- 
2.48.1


