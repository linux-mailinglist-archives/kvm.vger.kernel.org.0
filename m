Return-Path: <kvm+bounces-46455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 913BDAB645C
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AF301897858
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87ED620C465;
	Wed, 14 May 2025 07:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wpngRpWG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A331171C9;
	Wed, 14 May 2025 07:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207749; cv=fail; b=nw9PT19m4WOTiFd0m6Vn2PtT1LunxqAOTINOh19ILeBmL3ZpDQFumT/soNJUemZDcQrOgmTC1urY/NtrssrXjDTXw2eGB16I8UPlMveRv97kr+b00mEKU3/evTSjw0B+SGzBMndri2W8GIBY3RudPzuTwEmPA1uhkcm3aBGB/8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207749; c=relaxed/simple;
	bh=YI4ybmFHjASN3S73Xtv5NVN8wS5pzee8pJBG1aRSZw0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QUXNCG4CBb7M1dh9k2lgVo7VD1St6BR4ZwYGMwJ3WryFxO5COw4nffXMczBEWl/Sjqij6pi/Mg/NAQ2WfNcbbMgG4FWp2orB8hFrr16ZSPlkGJjdBgU4WPph7uwf//Onyv1roH/MKaQLF5Ip+fDbHoSDcYNgbamBYhGNSb5nzTk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wpngRpWG; arc=fail smtp.client-ip=40.107.220.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g9X98xZtMtyq09EQmC+HPocyyu6JkyY2xd+HXLl/P0tV67Uchs66sBjACy8odHSofERJj+6uN16FeSuBXU3dj/KPdpN2VIK2t4lGMYkwqHm4TxVTi0Am3Nhlc93RdgmYH9HKJJBQTiF+dtz5DpVB3hwKHAUcO0z8wr4ePb7FJ83+EM9QO5nqcfK4q5F/MLaujYYYtSTgjJAbJ5upLy8jfFYfoyfhgo47jNoPV9RDPypidAFNITRUZGouad2ZG0poDnbuEmaX7Yvq1bB/LZx0PEKB/bCFHxeZ0WX9t1fDFCQO8zoQ+AXHe3RKz/QWtYYi99pBAS0h1kXMGwqVlRonvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vTewJzkSdDXXs2fluGD1o9G9+v/uoXatK/D4bq1ahMc=;
 b=QqpakUD7DO5zgcI724K4wRDR2m0KRUSw8UiOUJu9UHYZhtLtb+o1jxEGQnn59NUt5HQetPmVwwRMBwRWh4ycYPEHA+22Acc140RN/sbh495nbPVGn/va+bOwr7GBWWmekii3foar6TV7ZPuGOQOOVSmwXpUWzqt3IZSwnyfVmMcZKAno1d7PpKd1X0GgGmQk6/ESSE8GCr8JtZcwV2PcKAdhFNaT1utAurMQ1GfAn57PHsS4d9yjz8R5MsdRQQ2h27ccHwE9xHzyJOCveXrlYM0Cu4IQH4yUPzOo9uc+4/DqfmxmuN8ZoNgECNcrKkidCJoLHM7YHFS8vmKceIpGLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTewJzkSdDXXs2fluGD1o9G9+v/uoXatK/D4bq1ahMc=;
 b=wpngRpWG4ThF0ukvRs70VgMZ3i4cQbLRz8w9EIOKGCb6h9dOx+jlAXXQ9h/22T4MR++wzzVFdxHV8ZrFD1R/7zlgIcvVsOIXCpMU/IucwTIOBnPqEI3IMc59mTKOjCu2wFgOq/oxx70iaOi8EdvjaTwv/oAAmi67+IFaHPsr3K8=
Received: from CH5P223CA0019.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:1f3::6)
 by SA5PPFCAFD069B8.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Wed, 14 May
 2025 07:28:59 +0000
Received: from CH1PEPF0000AD76.namprd04.prod.outlook.com
 (2603:10b6:610:1f3:cafe::ed) by CH5P223CA0019.outlook.office365.com
 (2603:10b6:610:1f3::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.16 via Frontend Transport; Wed,
 14 May 2025 07:28:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD76.mail.protection.outlook.com (10.167.244.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:28:59 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:28:50 -0500
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
Subject: [RFC PATCH v6 26/32] x86/sev: Enable NMI support for Secure AVIC
Date: Wed, 14 May 2025 12:47:57 +0530
Message-ID: <20250514071803.209166-27-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD76:EE_|SA5PPFCAFD069B8:EE_
X-MS-Office365-Filtering-Correlation-Id: 373d0d19-4421-459f-e3ee-08dd92b8fe44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?k3//MN5wJvcGH0P3zKhJzRfulGINiERxPRXkHBiowg3/SNI8Bc3qA9eSc3Kn?=
 =?us-ascii?Q?wmCfzQYexToryTM28lbSM2QDJE5uzGwx1pUXBsiNHz2h1+xMud8uUl+oeBxc?=
 =?us-ascii?Q?TBLyQWFrPnWhZ6zePpuhiUXDHbizZgFi3MvNzabSwY7z+Z0P8MV5+8o892WP?=
 =?us-ascii?Q?FcxwKN/htsQQ70uQCJJztQn0RiekdQ79Jwt8gGZllfldmUfRuqPS5Y/dt9+k?=
 =?us-ascii?Q?8w0doP7dg/STEYnZncNZTnNICClBD2VexFfKbI3hO7RbaX8jlpciV9D4rS+f?=
 =?us-ascii?Q?X71E9xUM/EKlsmpPP2NrJUlcOYqSPdRtRiiAuZPIMluAbX8XMUhC3AHGSHSc?=
 =?us-ascii?Q?6V8gyo1BqwWgT9+FNk+P7udQZRh0ML1y2XiD71w/y7IYuMNrotR/pSA77wGv?=
 =?us-ascii?Q?KfRDnjMV1hPkTlZZYeo5YRBz70KXPeSCFb0ad3/YsOIMKDM2bQDMYIHtW2YC?=
 =?us-ascii?Q?MMbQbE3CSqsnUPx/U0964bMn1TwC7pGVs0F7cDor9BEqj/SzFG+pzKqfEjTi?=
 =?us-ascii?Q?rLliuifCkHQbUNrdVqB2CTtQspQ7QbV7EOyMTqu4o/1YcgC3oH5N+bMrvfaC?=
 =?us-ascii?Q?nMNWjmOIFCbtANXKhhqepvNd94jThlYFJJXwkYb7TPQrxOkd9Lwm2b1awcap?=
 =?us-ascii?Q?0qPeoxNZlVYggYoCjdV22dAXfe2RflnXdLYGCTp0GAChRf2QY4nIzYvX2x/5?=
 =?us-ascii?Q?+RFj9qg1sBtklz3izL1kAan2YXpTloS6dpHjX9qiTXA4FdZSw/wNXhnfDNx4?=
 =?us-ascii?Q?cSKzmL0sUXU+ZQsbUnFAiVbMxg2KoR4uRa8sM231hM1uf/tSz8WmWf+v2zaV?=
 =?us-ascii?Q?gsR38QzW8wl3/lej02AULPR1sGKd5J7yk1JHJpBM5oP9kW8lJ5B3PbGHeeKD?=
 =?us-ascii?Q?2OjtkFgFCztpULk25zayqehwdWhav24v+/CcPOhwD5vV5mX2HKA02dlgx37p?=
 =?us-ascii?Q?ieAp7ACrvI4tJ7JNQV1Zgo7G7ziAyORKV/q1qdCw0D4OljDuB6DT7nUt5KA2?=
 =?us-ascii?Q?PgjFSvhFMfv8mGoBof6rSAMFSPNgIC7JgXjC/xRUZ2+wb2MKBB47GemIx6J0?=
 =?us-ascii?Q?WT0lctPBqeCahg4mPivRrsUdRV9aXhg3xDiRITW2RL1zCH/Bq3Djm6A/TPZO?=
 =?us-ascii?Q?OkXwgQR8tk2NvYVSRSKDP+rq2I0y76zLmhPIz+IAFW6De5xfgrEgAFTAXsYr?=
 =?us-ascii?Q?A8/E+UNEp6ebdLlJSwq0rdJqBJF3YIQI+ailjoukOMVHrsWkgUAWz+LEUJL6?=
 =?us-ascii?Q?jdMtgj+z75zrsb9iII9I9Gx/LrQexYfcuhwuOF5ZBUUThX5cp0j1LG2RVEO4?=
 =?us-ascii?Q?+t9RInYqI8XqWs5EplA8YacsoXOnoK2t8mM0kjWEIX0xIk9upMpGT3YcWMrd?=
 =?us-ascii?Q?WDA6ttWS1t7nAt8irKb0SaYAVyGdn5nKJTdlpre63P6TB2WcP2AWee46BZi8?=
 =?us-ascii?Q?lnb3KXVakIszaVKun25vLfCLi7d311/nlCAK6OQeG3tEBgz1COF80hN/5k1V?=
 =?us-ascii?Q?kaBODmVXv3G6AWRKJ+Dx45oH4vtAoO5sIT3W?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:28:59.3495
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 373d0d19-4421-459f-e3ee-08dd92b8fe44
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD76.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFCAFD069B8

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Now that support to send NMI IPI and support to inject NMI from
the hypervisor has been added, set V_NMI_ENABLE in VINTR_CTRL
field of VMSA to enable NMI for Secure AVIC guests.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - No change.

 arch/x86/coco/sev/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 4250337aa882..d2a752a0eeb8 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -860,7 +860,7 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
 	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
-		vmsa->vintr_ctrl	|= V_GIF_MASK;
+		vmsa->vintr_ctrl	|= (V_GIF_MASK | V_NMI_ENABLE_MASK);
 
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
-- 
2.34.1


