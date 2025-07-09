Return-Path: <kvm+bounces-51867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24CEBAFDE76
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:44:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64D6B16DE42
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C65218ADD;
	Wed,  9 Jul 2025 03:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nvZGH6VC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003AE1FAC48;
	Wed,  9 Jul 2025 03:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032605; cv=fail; b=jjSZnYLteUiuK1Jdei2qURzcN5DKlbLNP75V6daJW6MSxDUwyO6xVC9lO2qNTmPJmBHlVUgXsGPhfN/KHos7PXW1Vmu427a33VpjnUrz57it1/JXb1r2F5vHomja028JONNsNSMzeldWEg+GVOgcsE8lTP/i8JQbUEQn+mIMNXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032605; c=relaxed/simple;
	bh=08LTUfimBEw5QoC1ubuVgnXNsmLVJmaV4RRGuUGoTxk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lnJu3Qq8DjEjrn+hdWFyjO35wiqOipKM7OGsE2zllUGP+0hUzL6/u+BHMQRzrEMvLvuzklqYGem+qdatDOm8JM/c0zZyxFW7rOguzh/iUW6ryaExJ3gYhpCY2vh1JI5N+Ozeb9ivqPhbaLKEe4VSSCDWtq6scFVqRSnXuGpwf/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nvZGH6VC; arc=fail smtp.client-ip=40.107.243.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nWy7xrM2yFHzC/UHJG3evti6AOQTuBt4h3UTDjF0ta6b2DMZbMJCeAHAod3ghi5xcqzzuJyPoodeJ6g7/YkPHiwMOKtXARKJXyBUCxktDM7OII02NiSMGkxtgmDOc52fGe4Kwc5Gqv7XIPyrBMbt637GSOl8ZiqhAXqli5c9xsB+v/suqNdfoipKzw9kXGtIk6lPNCSsUpgOMkrZuv3m/OmKoencgCttWnqCm/Ox+KLRf2A378kjd4SOGfBjZqIuxDLBSf+oXDXkKYgjmKvbknLiynfyzY1lION0iqlAmiOJwaVeMHQU3HE23raQJtwSDB02PH3zA6PIxW2NpGnEWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZIwXS8kRBTCFZSPSTlxpWqe8eSQZdHfgUM3zuEzzFEU=;
 b=lzCDK7S5z2+PHna1nA4ER7n2n7OHHdA6GWvVboLa6f2//0dFQB5xNMlL/TiNk7ltZuVSMliM6u3bJ/i/3bXgBZSjJ/NfWFCFFDuryxZeApK67IGTHUdWQKix30M+GeWmbDcGXJ9IUSesmZs5dJsVuOr6QV3sAq/L7g7/NuGjJB16xb9VCmuskVVs63KMrunbNmxCpotyNHm+xqFB5OisEKWA42W0FnTnCijR0fJge6YQeBY8/3LiGv9b64cZSkvNivPkUjjYhqbSRw+w2WlmTpjU38lUSRc8nwTInRqB1++DepbhTmSLUjFakNfWgQHo5DzenSbKzLr8RD+Qyk8nUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZIwXS8kRBTCFZSPSTlxpWqe8eSQZdHfgUM3zuEzzFEU=;
 b=nvZGH6VCMTmMRZOkh8+An18hRs42SKsKSOFJS+/OItfrwhhP09EVoqynLp17MDThqOoKaFbd1dEj42uHyl0TkX0ZgKqtjcspCqEQmzHPTBI75+gqgkfc1Cqyhp+DJ1+vzjplaML+8AgHFup9v5VzkiQ4WVnUsOHv6fhqcYFaS2A=
Received: from MW4PR04CA0381.namprd04.prod.outlook.com (2603:10b6:303:81::26)
 by DM4PR12MB6208.namprd12.prod.outlook.com (2603:10b6:8:a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 03:43:19 +0000
Received: from CO1PEPF000044FD.namprd21.prod.outlook.com
 (2603:10b6:303:81:cafe::63) by MW4PR04CA0381.outlook.office365.com
 (2603:10b6:303:81::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.22 via Frontend Transport; Wed,
 9 Jul 2025 03:43:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044FD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8943.1 via Frontend Transport; Wed, 9 Jul 2025 03:43:19 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:43:12 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 33/35] x86/apic: Enable Secure AVIC in Control MSR
Date: Wed, 9 Jul 2025 09:02:40 +0530
Message-ID: <20250709033242.267892-34-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FD:EE_|DM4PR12MB6208:EE_
X-MS-Office365-Filtering-Correlation-Id: bee324a2-8ba4-4ae7-f354-08ddbe9abf0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ml8WUVR6vIU7iW4up88X5ff5Wq1npxDRUvoHVLBehE3Zm/atYYs5rVz528Zn?=
 =?us-ascii?Q?Doz1wbKOc6snixcBoDZKCfwMC7FXGz0HmC3Sy86dTC077TLPARHbmsLAX5nQ?=
 =?us-ascii?Q?DOTWPSODH4aWnszW4v9fKpVuPoRqoRWXmWCGd/JBJDXdjVjFzf3MwnYFZe9g?=
 =?us-ascii?Q?nRSBolcWJDuhjZWBRxS/7ra7Mo9QkFPOlEiJhYvrC6N0GeXIUxFYquDEM9lT?=
 =?us-ascii?Q?AeAzBtiwi06vs4Wv6iKuncr1Ar8Z5pznb62NLevzJN/KZwg52dZswbB9jZtU?=
 =?us-ascii?Q?TB55/VMa3sULeHCAt8bgz3mdO9mLuax80blNs/R6KbAJfIJ9pXZqYLbNb3AA?=
 =?us-ascii?Q?BDXUGD8sso7vxhyj9qZTclyRm0PWIvA3cqoG7ke8mKzyx4UvI2QN8I9vXi7Q?=
 =?us-ascii?Q?6kWfPw5qUPyF1xdHwWEcBZJkNhYgA43hW/MQZX4hHWv0d0bewvV8H3d7fz1S?=
 =?us-ascii?Q?yYnl/80lnUzuGEE2MZt+adHU35KkjjDiI5sWm08Hev0x9TGg+ZueRJogAEoe?=
 =?us-ascii?Q?n4F2KoB+CSvZDdTn8Nvo/mH2QZeSV1Pu4w+BBV3ogLoAbLBkaDq9lsFJXJOG?=
 =?us-ascii?Q?JQKQ+XJCFyW4omNhpSjqFddPyoP70sLXsDnD6ndXbMGsCm4tS1VlVEYYaKli?=
 =?us-ascii?Q?ENrphOUgmtziH6w24S14ICoczTFvR4EZEpY0KKtvjixwW4ZdZGU4tVN+0G1k?=
 =?us-ascii?Q?GvaIXPTz43QhQawuhKtqUeZ3uLp5Xi8yasHDzU/wI3qwKRtlnxJgWlBnm1Rp?=
 =?us-ascii?Q?1eDHXcg5cTO06iGisYx+EnTLvSdbUc3P5immOJZJh4ncww3BaDH9c9owoCZO?=
 =?us-ascii?Q?W+6VZ4oSw+Uxk0kjr0C/WDm/C7oLO08iCKI7mgOXDQNoM399JY7F+FJNdnOy?=
 =?us-ascii?Q?ubvMx8OQcHz17CM/8Y72vXBousdHp7fofZnLJw6nfajprvz7pp4mCORwnxev?=
 =?us-ascii?Q?ESEAKH9QIGMq3Y4i4S9RweCuKlHAp8yh2sG0ZZ8eaTTIyOQeqElcLoyZ2m4U?=
 =?us-ascii?Q?VBI8i/rw1hI9GAHYjuNro8m4/JuV70H6fC5JznrHLkWAv52c2OQ4GJfhDvFg?=
 =?us-ascii?Q?JCppMclDGtalPuuZiqnxBcyQhZwZq2B/1FHnMAxpN8n5ckAOR8XXT9BEZ94P?=
 =?us-ascii?Q?Wnl1AxX26xMokyGRjuDCIqtbCCQxjLeX6XHXw6V5AGVo+U2U9V9I7gSDvh4A?=
 =?us-ascii?Q?Qy9hwPJQhw4ioGfI2OvpoLhcf+qTeuv1sN5kzltMQZsnasyltTC81BDxzyCO?=
 =?us-ascii?Q?ZPRyFXQBC5NuEdgNPKKW4lEXCSfr/+fQ3rogL3icZcgismm4r/SpSVaXTA3H?=
 =?us-ascii?Q?lwyfYxbFKko55hMw+Yw7Gq4J5kOGNyi37yIrAF08qqGtv7DmA26NmJyKpOkI?=
 =?us-ascii?Q?EldzfViomsyZcIrN5oyb4u9VMzK19hlYU15R+JD+yhZHnCd/P2j1zH4wdCfK?=
 =?us-ascii?Q?6Jovg/EZobER4xajrcLLr2eBbMiOfy4QDNS4wXPfEfJzsW7KXd4jo8Gfm/J6?=
 =?us-ascii?Q?FgqqAsHpTV2kJPROm/H2Lmstc/YoTDWviclJ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:43:19.4680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bee324a2-8ba4-4ae7-f354-08ddbe9abf0f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6208

With all the pieces in place now, enable Secure AVIC in Secure
AVIC Control MSR. Any access to x2APIC MSRs are emulated by
the hypervisor before Secure AVIC is enabled in the control MSR.
Post Secure AVIC enablement, all x2APIC MSR accesses (whether
accelerated by AVIC hardware or trapped as VC exception) operate
on vCPU's APIC backing page.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/include/asm/msr-index.h    | 2 ++
 arch/x86/kernel/apic/x2apic_savic.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a3a2b99d5745..9561184ff989 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -703,6 +703,8 @@
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


