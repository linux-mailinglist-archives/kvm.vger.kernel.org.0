Return-Path: <kvm+bounces-56089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45058B39AEC
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:04:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8316982B9C
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:04:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2773530DD1A;
	Thu, 28 Aug 2025 11:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="etW5T1uy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB9821D00E;
	Thu, 28 Aug 2025 11:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379022; cv=fail; b=nnK1odTBaMrEvoYXn0BIPWrayYP40pEDDKumQE8nPg7+E0NTtZCSh1IY0Im5enAKTPjrFMxxd2MmR+2PNV/5Hdz34rFazrO9cSErGYR14ZhPyvbqkJrkPOEUa+JBSRg1U5gNQVGZhdafuZsm8K3c+Q/O1KCb1BpEEKyaLA4anTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379022; c=relaxed/simple;
	bh=YJItiqLM+LS/XjILPSuxAp5DOLE73X+T1NeWcp6HHz4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dmnOLQRgDGUFH6rPsdWevEAVsGW85h89aASHE8vbCL2dNYL733W1OMkkWNYfmc8CYXVC3KC3xVncXO6LvUrVOgBvRX5axFkcMKu4b4vgA9BtlsAGufOiAdxek5K6DhN35Ad5oB0kqphRGuUiC3pcS6CDLRDY5Wm/EkO0R979ruk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=etW5T1uy; arc=fail smtp.client-ip=40.107.92.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XGIurJ+gLTAAwaTZvcSsaOcvaiQNGk/u25FM3Vyb2hoKyijAQqi/xoLimQSimOPQJ7vNl29EDSzrIIXNV/qpecObrZBFmMgr5gCRe7DnEySzR7Z6sfObWsALqTsGCF4EhqdJxxohivTLzKcCU20nLMTzN4t9IxeObUcbshvm6RWetH5Ax2u+gS1B1jfyXRv7S9RUHMXekyOQjA0HyJny0olg2rjE43yqM2Mq36B1plCbYej5lHjgVounslO9Tt+Yj8AliZVUeZmJDQ0f7XSzJGywdV6w5U6ORLy44LDwB4FvTKoyFFffZyk4e9pw35SOxq+FxgALG6bTobqhXaEo1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Jh1956G8ojJeKHyMnXBTPwuR0I6fQvle0JjCAYQDdY=;
 b=kNwWt85Lu6V8Vw7IVrg+g/T1kqQLNoKDjpQwW/RWvr3ElV/hgsvuKPynTuUCb2qHAq568NMc8GFQvmSVm9gEP8xM8Y5pyU+etsutlpPNaymiJ5zU48GUTL2o1yOmzM+U6HIBfnAtjdHR1Qqlc+juPrvvqsXH7x0cW0r6s22nR2UnYvZHdMUSEoTtj4KMArYkHLY8Aiv2L5XzQpwMVhrqIaprBYHkr6rgi2JmEL9g/0ZLiIwfH2xibSwKpxOpq1izekL9yb0PpPHZ3LlLZ2b/W+C2r2wYz615YK+9kEB1s1vthRS1XvwxAvGFkt/yY3f9xYWeMfYuTBJEvDInM9EXEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Jh1956G8ojJeKHyMnXBTPwuR0I6fQvle0JjCAYQDdY=;
 b=etW5T1uyo950FQhrjTffg7fQtCwAdpIG/K9T2IGDf7odSGCwRYftmYzy6nLQYDRP55aKcn20qPTzGR2NIZ7fHyEk73b+DAXxGLtzY+SFQBITbM6A77niMwyH9y6MEOxEMjuuxsUJyKo9P9/+tWoJBHXCtjem22k4zj2R+oZnkNU=
Received: from BN8PR15CA0017.namprd15.prod.outlook.com (2603:10b6:408:c0::30)
 by CH3PR12MB7497.namprd12.prod.outlook.com (2603:10b6:610:153::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 11:03:37 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:408:c0:cafe::c2) by BN8PR15CA0017.outlook.office365.com
 (2603:10b6:408:c0::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.17 via Frontend Transport; Thu,
 28 Aug 2025 11:03:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Thu, 28 Aug 2025 11:03:37 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:03:37 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:03:29 -0700
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
Subject: [PATCH v10 04/18] x86/apic: Initialize APIC ID for Secure AVIC
Date: Thu, 28 Aug 2025 16:32:41 +0530
Message-ID: <20250828110255.208779-2-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250828110255.208779-1-Neeraj.Upadhyay@amd.com>
References: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
 <20250828110255.208779-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|CH3PR12MB7497:EE_
X-MS-Office365-Filtering-Correlation-Id: 42c76828-bc8c-4a35-80f5-08dde6228a23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MqBf1VQFYwpRCpJZkJxxfrtkn8SUsu58Ivw81+8CQKGXz4x3kA3368c8Vjas?=
 =?us-ascii?Q?Q9yxvw9nErIK162cS6mQyHEbm21iVATbrvYBy7dKnAevy1kmdXKF8nOd2ct/?=
 =?us-ascii?Q?/AifhYUTQMOnnl5K27BPfCb960FVwDL++f4AHpUNT6PirKtki2I3uqeh9MT0?=
 =?us-ascii?Q?aQk76GJRxfiCXGN8huDH9le/FPXShy8a2bqvMg3994hrRXox39pcDTk3hOuL?=
 =?us-ascii?Q?rHEqclHjNbNbAw267mkxLHBZgkBDzP28FFLNqmpRZffMWbmmCdy/DEYbpJFW?=
 =?us-ascii?Q?8MFEZHE4mj6PvRr/ZjdvRyGvL32KynSE7EZRB5g+iTxvY6wlYcKe4C46U4aw?=
 =?us-ascii?Q?yMiHkSeCSCd1C1z5U3sAG8rBTqSQ9iAny7uBPWmRAPEyUmNLjeoCyyp3j8XA?=
 =?us-ascii?Q?RJHuBdaNtQyG8IIH57Bcq4pm0li2TR+aaC6zjur+gb4fCzfGhUHjE116QQI4?=
 =?us-ascii?Q?b47lDn+P1UpK+yyX1cBzDkmXzI9FiQztv25A9cwtbIvl8XkxrzcDo0wkb2Zu?=
 =?us-ascii?Q?h/NF+3Tcp/FOfMWBvrHOEL0KmtaYwt0g+VddYPSSoL7kzQW2Bsosg4iu4Obe?=
 =?us-ascii?Q?j8OVUQlyAo3GfdceCZKhqd7sUlmwdmTkn6HRyam5wWJz69ANVFDHS3vT8z/5?=
 =?us-ascii?Q?I1gN9gHAVw77EbCq3M8sK1dbkOEJ1K8SoRPEcO0VZVSG9OxDRt8cY4mUv01T?=
 =?us-ascii?Q?s3NcANN67CRuyrlo+fB2WTXHQ+og5hu8oH0eVJbzDgfoK77PyGgHiJvDyl4N?=
 =?us-ascii?Q?zd4Uvm5aiTkbkybdnEAynudAzMlEzCUUZIJuKZuRoKUQc0iiRYrLPjDJs2tp?=
 =?us-ascii?Q?niEzf/An2uje4yegG1nAWglFOs4tE9U4t0P6JAtTgbomRBSZ6A4ojVZqaBEi?=
 =?us-ascii?Q?PsRoS8FXGfrlktt57USo7kIImUAj+27UV+7/vRhsAX467Qwh09DooCxJll88?=
 =?us-ascii?Q?pb6HnMPIW0hp1f6Hcnqf94WQ9t1suiemhuEGpYDnqqI4Bi+IBzVhxdH0n/ao?=
 =?us-ascii?Q?Rw1N0JMyQGbwNQI5EDFGodW3sI3UVGmWw6bLTtXyJZp0R/+awiqYJJdt5ftK?=
 =?us-ascii?Q?21cDH2keYCvSP+u8WRgeqbfUiu544ts/kmhHSIM8OYYaYPTSuumsNpvUy9py?=
 =?us-ascii?Q?SN5Fas7mV/WwpeRS+VJHqh5mV83WzhbU30ncS+PsmUuEhwq3ei5QhGWEV41G?=
 =?us-ascii?Q?wOLZIJoK95wr309mLXRLpkN/kzmGxgCAN9wmtO62maZ351DmuoCudpkcaUFB?=
 =?us-ascii?Q?RQdIWKJjXECRL+XPnEgOD8LSqAZCKSVrW+t8hl/jxrXzgo4UuJWSHzgJeX1c?=
 =?us-ascii?Q?LOuATHVTAcYGQqoPza4wYGpicPPHbONcmr2QN5kQMa8jUZbVw3AUs2aXEv1d?=
 =?us-ascii?Q?nac9zh5gPfUiPvXFWZ25omtdjfTI+khF2ggDDTd+97nVHsz2vFNBzIgkA3UR?=
 =?us-ascii?Q?CGHLM8lKDns/EuQiCyfwl4p0XI0njrM0BaHfo9x3rfDF5EubzGZdMHB1YRvF?=
 =?us-ascii?Q?YAuQpdB64LavNOsZIijL7tgOm5oeTmlLmj7Q?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:03:37.6916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42c76828-bc8c-4a35-80f5-08dde6228a23
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7497

Initialize the APIC ID in the Secure AVIC APIC backing page with
the APIC_ID MSR value read from the hypervisor. CPU topology evaluation
later during boot would catch and report any duplicate APIC ID for
two CPUs.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:
 - Commit log update.

 arch/x86/kernel/apic/x2apic_savic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 5479605429c1..56c51ea4e5ab 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -150,6 +150,12 @@ static void savic_setup(void)
 	enum es_result res;
 	unsigned long gpa;
 
+	/*
+	 * Before Secure AVIC is enabled, APIC MSR reads are intercepted.
+	 * APIC_ID MSR read returns the value from the hypervisor.
+	 */
+	apic_set_reg(ap, APIC_ID, native_apic_msr_read(APIC_ID));
+
 	gpa = __pa(ap);
 
 	/*
-- 
2.34.1


