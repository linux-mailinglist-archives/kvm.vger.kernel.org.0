Return-Path: <kvm+bounces-46459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D258AB6477
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:33:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05DBF8C0308
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA55217F5C;
	Wed, 14 May 2025 07:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="13LMihYG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572A020CCE4;
	Wed, 14 May 2025 07:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207844; cv=fail; b=KtY35yHksvnxxmfHN+7NGRW96169rqhzooBKDiV1473GZhYdm7bKYXCcScH78sNiH84R0WeuZRL3WRT+6UFDLm3ZSu+bWsNw94pNAAdMw0a3/SUWTcsBFKgz+TOFbzmdEZIu3dVdzJe1abfnl8uO5K5RRrF3vWSa3TnSlxTMMA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207844; c=relaxed/simple;
	bh=YBr8JoPnwNBdKvsWnBDOC4RrjvaOGKw0QrWsBfqY4e4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JNIeWEzA2Oca25Hpxq0GjKxSyP6ahm9hbhsMWVJc3XvegaIejEu+YkiSVdL+W9IuK8v41ZsS/IXkLp2cWAN3QZlOwp9HFXUMEJBaN8t+Ob5sdOQKuJkJyczTl2jNkJS1t9Bdbo6GpCIeZqbDT0K9xgkJKicv5TzYVGgZXnifqRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=13LMihYG; arc=fail smtp.client-ip=40.107.243.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nP56GvPRSNreaVYPVEiodg3IJxpP7NZceSQMsrMTEVELiDZvJiPGR5CJN5ykK49hkz1BCGev8th81FVj+IYsqOsQ0joYqnH8CPzzHcjvOAZYrtE/HuzdBnTCRsZaznst7YeKzvttLmKRhapiFAeGSpU+qaF/c778OSNEFuyWbzpWJfx0MtlhmimoFOVahmC5dYdwgq5pgLegSDWGgjCAmEomdaPoYPsthoZsSZEGT6wLmcOF5ZWVtC+XbBGyxftMCtL9TCVUVWooXx7RaYFoemHcn2k27NfqzIopNj8cfEzS33+x4hsQ1wiUhb+G7PLdP3MSL3lvd0wrH/tCVSA7kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y5TyyI+QdtkCzHw4b1TkirXlqx3k1kndRyOVi5cTubg=;
 b=bhVkT5Fewk02GatU2WTOwWL+z1+qzeKosfVlFMYxS7lP3+V83eqOdH/v+HXM4H6ueQmplJNhppFKavs5idbqYi5Dk4t6S8bKzA8+eUD9tjNq0/KiwoJNOUS8g+hpOIoB0r9Mehgz1HpCEr4DuT4Uu7XoxWebtQ+PH1JUzaaIjJ3KRYWclML9f5hhgnqvqLvzj3LR40whqBqOu6yqoiBrjn8DAjOzEziAfa8Icxnz+JruZjKSc9furuF2LjurvwJ0cGWAiQyp/nSFxJrgd5vSdDPx3oIE5ZvUz5NGjduYHM2HjFOSDiQrt7Y0t9GVyHGEyR5nEEyLgeIzmbqfxqySKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5TyyI+QdtkCzHw4b1TkirXlqx3k1kndRyOVi5cTubg=;
 b=13LMihYGFESuE+s01mPjGBL+iypk017GwlC94jbvEcjf82Q8gZMja/PFjfsEt7fjpKBczbWPbLLsq9tA4SwrgWVkyA63FW/hXE+DmQlEVCA0vM5T0qYDUIJqnhkzUE1IuD8chMcCP17uyXMOZFT0pPeaNKCrdqxxNnt3cWcBJfg=
Received: from CH2PR19CA0024.namprd19.prod.outlook.com (2603:10b6:610:4d::34)
 by IA1PR12MB7590.namprd12.prod.outlook.com (2603:10b6:208:42a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 07:30:37 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:4d:cafe::2) by CH2PR19CA0024.outlook.office365.com
 (2603:10b6:610:4d::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.25 via Frontend Transport; Wed,
 14 May 2025 07:30:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:30:36 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:30:26 -0500
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
Subject: [RFC PATCH v6 30/32] x86/apic: Enable Secure AVIC in Control MSR
Date: Wed, 14 May 2025 12:48:01 +0530
Message-ID: <20250514071803.209166-31-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|IA1PR12MB7590:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e09a020-8f49-4e67-40d6-08dd92b9385f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p2fZ/r0PC/lr7wWEejBckfl7XQgiDKaIlp3vjz4SUK8occBVaHoiBLtNCyA9?=
 =?us-ascii?Q?z0KieoJEoSBmc4etr/uRW1JEoAngjljpW4mVIB7uNXZmOy7Lz3LQwvhPRziq?=
 =?us-ascii?Q?sqNAbESUtDHHCqoz3luf/lytDgbyGy9ijgWQ+5ZU20DSuxkpwDVfWReiPFMF?=
 =?us-ascii?Q?r0rjMac2m3FHL1nqvKRDD7kf7oBjF+xYv9KqMQuwVCjDSIlCoNBoRos6ng+v?=
 =?us-ascii?Q?Thqz5B9OQNwKU8va74u7Ujs4YP3bgcSL7/dg4QE09FoSRnlZs9Pe/9/6d0qb?=
 =?us-ascii?Q?ScWoopesOdakDxCF0ymAYetwqiWeWpqFnG5QlEU+PHTgfHVk+HZRgTgb7OJA?=
 =?us-ascii?Q?5h3BUV6tYAPqaTZ3Qptc71R1d7ryCsRoQ99Qkb1NPDPi5qflQMPbVc3V4l22?=
 =?us-ascii?Q?vPVSKXzqaGzqXhqxLZE6/D+4LdG/OhcUkd5m/F5aYOmeMMmA7EvA6ogH8CNF?=
 =?us-ascii?Q?HTqTcO8TpjPpnQfL+caQ5Qi+jEn7a2vCcZ700E2FTmKBC0LRcydG87dnkgn6?=
 =?us-ascii?Q?l0DTa9k41NkkYRq5sfLcj0/egpTU5vMBJg6VbcwJ4lLzK5UwLgK6U3r9M7tD?=
 =?us-ascii?Q?wEdDBoOxS+ei0j+Hik43qrAjCgML5A9oqzXFumaEZ2ppdm6rR5F6SVrtgmMR?=
 =?us-ascii?Q?wJJq14txDgtpf5r4D+EZDtIxNOzAC2w23OAr39Vdnl2VXGG4imyaoj9y04Jj?=
 =?us-ascii?Q?2mNMAq5tCUllUa4/jtMFSB+JdTrQarhzrCdDShrkquPYLjL2AQ5/XAGROSsY?=
 =?us-ascii?Q?uMjIOTgMTTVnIlYzM9iSbe9IRDLc3QVQHPN7iQMAS3iNlqEcKLBJfPCK+F+V?=
 =?us-ascii?Q?JDX6KF0+9MF44bybFjWDrkCjOgW8yKLUh0FR2JmwSjU2ixbeta60UQiaIepW?=
 =?us-ascii?Q?ILSEtpXDLle5oItWAmlqxxHpsgMm9IwR4gr3vmjli/kU/AzQly3+uhuLOem5?=
 =?us-ascii?Q?FyqqLrGvmbY9Vun8YZM+8PYGGvkHoFK7l8MGtL3K64z4BSmmX1KM6oQoUq8k?=
 =?us-ascii?Q?UDXj3k7imWJfdPuihw9l6YxxBimAyyE1+qbvhORA85jXL5/m6u/A0BSn6Vpe?=
 =?us-ascii?Q?MrPylAV4XmF7OQh7fOGMLBALq0H7QCnNX3BZYKYnzbkVYEdXYv5rGrUT1OCK?=
 =?us-ascii?Q?KkrXmOkA7vsXHdOxOS80Shoehktdj0AKGaZHmYq6VtF46BN2XC7JSceOIftn?=
 =?us-ascii?Q?Oz4c3S1vW4hWHrt1BeZb5Mc116z/+jYh3+dmdWiJ/zp/85emxE/MAi+QHKdq?=
 =?us-ascii?Q?3SFb1U/GAeyoMkiTAWSL0t0Fy09XkYAQoJwl4Pf6Ia8TtS+DVHuFoJyQpCX+?=
 =?us-ascii?Q?XB9ZDha/HE34KvKqoGw0rGlUVwgz+Do0gIGh749wGsLoOMNpxhYIGh8j9GZs?=
 =?us-ascii?Q?seZNS5Aj7ST/E5B6MTXzmHoCcNcK55kf27QcpHtAjI1LzdJOk5DZmYGDRU+D?=
 =?us-ascii?Q?HnPR6MJzmOEalnKxTfhLXZ6E506xGfOW6qTEDwlisEhiP1jbYcXu5GGYQrqT?=
 =?us-ascii?Q?VHFOWhkc9YwJOeQualfGm2mQKJlKmuRPBK0W?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:30:36.7662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e09a020-8f49-4e67-40d6-08dd92b9385f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7590

With all the pieces in place now, enable Secure AVIC in Secure
AVIC Control MSR. Any access to x2APIC MSRs are emulated by
the hypervisor before Secure AVIC is enabled in the control MSR.
Post Secure AVIC enablement, all x2APIC MSR accesses (whether
accelerated by AVIC hardware or trapped as VC exception) operate
on vCPU's APIC backing page.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

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
index 417ea676c37e..2849f2354bf9 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -375,7 +375,7 @@ static void savic_setup(void)
 	res = savic_register_gpa(gpa);
 	if (res != ES_OK)
 		snp_abort();
-	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
+	savic_wr_control_msr(gpa | MSR_AMD64_SECURE_AVIC_EN | MSR_AMD64_SECURE_AVIC_ALLOWEDNMI);
 }
 
 static int savic_probe(void)
-- 
2.34.1


