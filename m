Return-Path: <kvm+bounces-56104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 923FBB39B65
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:22:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5C181C815CD
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9FEB30DD29;
	Thu, 28 Aug 2025 11:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JuI4PtGi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430C3849C;
	Thu, 28 Aug 2025 11:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756380117; cv=fail; b=nyfrA29J1hiDpWfSHjn+fOCyTKmnkqLugzbM2b4d50sYVXPvJpjc3e03MIMTTn5SxZEPMZghj3SwaapR1IIKNIfvPok6V/U5AKjvgqR4MD+GRIh5lQhh5WARBiqgvmhLgO8+dW4MahorxfFP9HEO79kimJGoQfFcXJkAWRwg7qc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756380117; c=relaxed/simple;
	bh=F8s50AzdciZsj4yxUPOpsQgtm6PSiLu7ZgJk1+f0vWs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aA8dHFKthvobFcQYk5HZD+jr8w9XwRfIs4DfZkLvqXBbcQh6F46g9MXi4g6+OSeQCHVs4BzvyqD/mLzOfLOVr5NrUXjHa91ARlCVaODVzmOKnKlsk4zwVIa62p3bfP2YwwnVNg21MIW2HY+sfvNLcKQsyHgT3CuimTwqc1s8WEM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JuI4PtGi; arc=fail smtp.client-ip=40.107.94.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VUMfqEQ70vEP8ZianOAehYzRrcgdp/WqERgMtdTMweSZgzd315NXDSL6rxQn5L8kAk39wYxFK1dk7WpxxHDgCq0zLUXS1RCaW/3H4t4X1khERBu3p3OaAT0E4rc8Za96P/BeWgbNr1qpKYWA2sZnRV3LXpY8OryQ6PlNAyn+/iZxZJSFWvwTCbknoP/gruOtyznzxVeYzhNiiAHgJd6Yd9fBOOhqZjsBq/H0q12hiRuaHZwsXNgkKyYQYi6rmoHO2LM2E5Ezj+DTQlRamthJXA/EVi9p6IWHlam6z05aVLeSa2Sl273rYICG1tXp/llYJfkl/Ex7/bgAhv/pKOPlRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4tvGS+kUVbGYsjSeNTJ44UYIQ2EspKreCFxiDz3YxM=;
 b=bu6arhceNM7RazSyQs5sLYcsQxLZPgV60uLAFy/y6LQnA0xoJgWw17LougTmnZjIssovUlpg+VPLSPYfHSPQce1vhB4qlWlXfVL1vImxPSfrBPBiQNwtv+8o4qIHor/8WXwPpqq+vf75vK3BAY3UHuDspdUrAP9nW4w/DPbHNJXYIrsxPM3XEuuUAs7ea6le2FW1xp5AOiUN9riuxOboC37HZ+cet+KN83ItqvgvlMVHs0q+FEERxu9rNu4mcSZJRcMlB89mtExWN0Lp+/6piXk67cZP+NHXgduuJLrbJWCSV5ZU77Ds/AZYSlDSmhPjwL+6RvyLMjelu6Rs7nz46g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4tvGS+kUVbGYsjSeNTJ44UYIQ2EspKreCFxiDz3YxM=;
 b=JuI4PtGiHXYV2E+XNzpcecTTOl8oDM3Eejn4UAjZ3IuKwNjrR16umWK4mOOPNhGqoDf9TOY//EatdwGV0f6Zm9zRHavpEGqIIfMIenEXJrmIIz2I4Oqox3WwsbncW+kcCYqNN5apOovTRapAz7+870EcunbCyjPr8iwU785lNVA=
Received: from CH2PR07CA0045.namprd07.prod.outlook.com (2603:10b6:610:5b::19)
 by SJ5PPFABE38415D.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::99e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Thu, 28 Aug
 2025 11:21:45 +0000
Received: from DS3PEPF000099D6.namprd04.prod.outlook.com
 (2603:10b6:610:5b:cafe::21) by CH2PR07CA0045.outlook.office365.com
 (2603:10b6:610:5b::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.16 via Frontend Transport; Thu,
 28 Aug 2025 11:21:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D6.mail.protection.outlook.com (10.167.17.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Thu, 28 Aug 2025 11:21:42 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:21:41 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:21:35 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v10 16/18] x86/apic: Enable Secure AVIC in Control MSR
Date: Thu, 28 Aug 2025 16:51:26 +0530
Message-ID: <20250828112126.209028-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D6:EE_|SJ5PPFABE38415D:EE_
X-MS-Office365-Filtering-Correlation-Id: 46fcef5e-0215-4646-0430-08dde62510ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZSh8uL+Aj8klGv+Ys1iEwYg93RelUHafww0wHyroyF+dfPTbtF5cK/4yzLZ/?=
 =?us-ascii?Q?ToiGheoktqcmyFdXVdPhEbR5sZ5Xbt04vUJp1pSMjvnrk0jK9ySV/YOwPDJg?=
 =?us-ascii?Q?jrwbbxtRWZOYj8IVLgwxy9x1Ktl52X2BzZhsu5awXhOWvKlbdbouyebGD5ov?=
 =?us-ascii?Q?FztDu4Mk7sJua7N2dTxl1/CsmxUG5J2PwxRRGO8M++RgVtj1Yhj4sTkDBhkU?=
 =?us-ascii?Q?nof4z7XkCQT4XUWdAw0RXdZ2ls1W4bKh/WPBn0r472hWb3h2YIJkGszosHqV?=
 =?us-ascii?Q?S8ALoPj38O65KIoKxIHTCnvfLvtUYwLZldt5zkxv94Ihgn6xdvUF0tEMbmKD?=
 =?us-ascii?Q?cK1ES3gprZFyZulLtA1rAvUkhUljk57nYxWmMZN9xqy6ILCbBtUneejey8Fo?=
 =?us-ascii?Q?NlTiTwE+vpVZmnhUqnKVZtSNiooPmhFAUwCHUfOWmAh9At5Ih1/4OifkkZ5L?=
 =?us-ascii?Q?59mqCwc/t/SPJYzy63Nbod4FuqLmv0mAhkBgWyS6yJmmVbWyfc2bAnc19Xx/?=
 =?us-ascii?Q?RUkfvLvreJ0XmoP6Z7I29J/JcvwGX/aExOElMQEfKcu93a48VSRTHRYzha1y?=
 =?us-ascii?Q?mG9YjFkKKS1nyyNTfWrGQkvUXrx/8ugRAJms5dIJMU+dPKGOCgEpZGBRzPHa?=
 =?us-ascii?Q?M9DYwzw1o0ZA4Uuq5gSEDbhoozKPcbFNUeiMq1frRvS1SgoT+IrF4bEjxN1L?=
 =?us-ascii?Q?J7co83EEyIkAMrRRSRl8n/8tMZQM1eNsVZeUREbCTBCvO+LlszmKLpdwoNDM?=
 =?us-ascii?Q?lcBUwsG7XyBys0TV0EEbxHZmHr8jkiVAO/ztw4ubs8bqr1N/+P/VQtGfjJMB?=
 =?us-ascii?Q?f7HCqvI+sUNK9RG7HpsW4EZ72YIml0eo0EDvKfgwEt/+2quDnr3o4/9IkE/6?=
 =?us-ascii?Q?JM2CVdZnE+SMHoFKLwb1aGKfXhGkRGBC1Ni76N7k+KJfQ6/Y7yzABqwwXTnb?=
 =?us-ascii?Q?pqok6WLb79p9pcxKPY/8tNbJiq7PK8PIXhLJOy673QVOg34l/aDyPg2QGqWL?=
 =?us-ascii?Q?/qBY2YYyw9Gg5Tqc6voCj6xXBpZZRXGfnT5JF57FzUG8FrOZxKuQSYdXK0Ar?=
 =?us-ascii?Q?solN921WR/b/OLRkbnVxkeJwF8wZ0Y+u5rz1cmHMOjEfDmCX15/s2FHo18nS?=
 =?us-ascii?Q?3/ciXexrqHpslB7hku0OiXv/LGC3gnn/xc7OBB3skjKSm6lIkeunSMzTQkFy?=
 =?us-ascii?Q?6XQqEKxkR2VmZ27me8S80eiDTarvl19zm/TDMGUG2HYyD9i4bD9ix+SIk5N4?=
 =?us-ascii?Q?i6cChMcf7prYmOdGFMwitaX8hqnj4bbcSiaL9S9APek32wUJc77WrXgI212T?=
 =?us-ascii?Q?Zv4cU+K2OxY5NvYtYhje5ZGZClWnR65AuntlA8yoKvJNzI6EMG8TolQbR9iY?=
 =?us-ascii?Q?9CcpOYuaYLVbUiUUuHmvt3ao+MdswT1kILZWJmKZMYozqTSGSwyUF3IBdgVc?=
 =?us-ascii?Q?o5wZzCUs94vNI0HkjnNUdKnyZiOsNl3Lgcr+dc2lrVcliHnrI68fsyWK3HVx?=
 =?us-ascii?Q?tXVKPN4TgyTwhkoCwTyLMR7hqAiYWC4Hs8cx?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:21:42.3617
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46fcef5e-0215-4646-0430-08dde62510ad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFABE38415D

With all the pieces in place now, enable Secure AVIC in Secure
AVIC Control MSR. Any access to x2APIC MSRs are emulated by
the hypervisor before Secure AVIC is enabled in the control MSR.
Post Secure AVIC enablement, all x2APIC MSR accesses (whether
accelerated by AVIC hardware or trapped as VC exception) operate
on vCPU's APIC backing page.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:
 - Rename MSR_AMD64_SECURE_AVIC_EN* macros.

 arch/x86/include/asm/msr-index.h    | 2 ++
 arch/x86/kernel/apic/x2apic_savic.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1291e053e40c..5951344009f1 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -704,6 +704,8 @@
 #define MSR_AMD64_SNP_RESV_BIT		19
 #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
 #define MSR_AMD64_SAVIC_CONTROL		0xc0010138
+#define MSR_AMD64_SAVIC_EN_BIT		0
+#define MSR_AMD64_SAVIC_EN		BIT_ULL(MSR_AMD64_SAVIC_EN_BIT)
 #define MSR_AMD64_SAVIC_ALLOWEDNMI_BIT	1
 #define MSR_AMD64_SAVIC_ALLOWEDNMI	BIT_ULL(MSR_AMD64_SAVIC_ALLOWEDNMI_BIT)
 #define MSR_AMD64_RMP_BASE		0xc0010132
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 88e0ac9ad092..d65282e103c3 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -364,7 +364,8 @@ static void savic_setup(void)
 	res = savic_register_gpa(gpa);
 	if (res != ES_OK)
 		snp_abort();
-	native_wrmsrq(MSR_AMD64_SAVIC_CONTROL, gpa | MSR_AMD64_SAVIC_ALLOWEDNMI);
+	native_wrmsrq(MSR_AMD64_SAVIC_CONTROL,
+		      gpa | MSR_AMD64_SAVIC_EN | MSR_AMD64_SAVIC_ALLOWEDNMI);
 }
 
 static int savic_probe(void)
-- 
2.34.1


