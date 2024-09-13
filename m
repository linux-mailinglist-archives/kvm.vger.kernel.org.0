Return-Path: <kvm+bounces-26810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82F77977EA6
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:41:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 945421C240BB
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AA491D88B4;
	Fri, 13 Sep 2024 11:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u7vIAIfy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DC21D7E31;
	Fri, 13 Sep 2024 11:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227670; cv=fail; b=e3BB++DgtEJfKqcfPJoBwjG4oDyxRFfsaqRO/VJ8EJCiItoka3tIkULXF62j0Ju1MeityYoVIbVZBybqCapZlaR77qVnLNsrTxnQXLqGjFkmRA2Lf5yvvCE4CMk+/V4Xxo/zrXDOPKg398j8vzPN2exAaaaczDstmxYijmCGLeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227670; c=relaxed/simple;
	bh=5XbAyGasawBq3CFiIArCmeBuFfEABQDsf7m3Dqdpq/I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F2hSdVxfWZ0AKvEzTPV7duqNIXyZMkNshGveWeLn4h7VgEA9tRcMGOxrNX0XWXx7fur11ZfWI6+UZiTD0p6TtnOJVopGBW8Ix0L6DM4GoCqERgQunkqv6TOQ52WQK3LFpPhgS9F29uKCuSPRp15wACAO4XFB1lmjE2Rjg3YhTMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=u7vIAIfy; arc=fail smtp.client-ip=40.107.92.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WC0TQ7eLwfNvzahKKLUej9P2L3nEXZk8rjL6+f20uGCxrDAMpRHsKlcL6A1uurFTkIF1ZUVrTKPYRvwoEIYrp5ESoC+gXYD2BTvF10+DCXBTelTpRiShtBgSZAB/0YbAMbSaz1tMVitOEWGaVXyhAoqt9R9DVGMnSBM2o2V1p6PP+MBEjJ2OoekHWOm6WqObwzRIYWrcyvRAfzvgunhMSfLOvxF8SH10c13LFyHMKocP+FzOcUMNdKakaSHQ37/IcHDaSYv3UvrzSp4rTrONi0q4px1z1omi8QwBr+4Dhw+aKW7LHHtCrL0PCKv9L9HXqy8gSp9sSbuCXZKIz2bOKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NCQ5bYcHhcYRjFlhO7mE2Ggwr9FkFGgXxrKcwYmC7VU=;
 b=JdARpX1hpvgnpH/f748+Xur/TeE7uwLm8ILmtGvaZwToX2OY0P4rE7ZIVqZjq8jSdHuJ2FWN0iKKzgAE9rfo0f0zRJ6AC6y3rRKclcZJNXzQYURr2xJpNxxJcN4Aiyk4WdhqsmklodCIERltk1dMYhTZjzbWdz5W0hbRb9h+5AcpTJjuFRRrv9K1ZB6wA2w2PdqPbvPZqpMU6vK1UCCMAMGgWFLS1q0M/1mLDt5wP455+5lb9sDu22DLdD+WWT1jsRiKxve/3rjNrq6dIuq4Qbxvcgwrjy78e5cx9dVmvcO1dgdawvkFc59VzcV13+lufeoVeTjlR+bKMTkFOAJNfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCQ5bYcHhcYRjFlhO7mE2Ggwr9FkFGgXxrKcwYmC7VU=;
 b=u7vIAIfyVSL3h06kEUdZ9PmOKbKsQh38Z2U7ZbhPcz1JC4NBKOT1RgtRYC0FjUyfDMjuLSL6Aix6ncFCjHtiClmNYawmruJTLIwkqQKApGlhxTJiCEQiJWwQsUdLsW/ImzlwFCwJR7dAkrnMXftD6P5/tnNg6hhyxoRj+S0jCkU=
Received: from BN9P223CA0018.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::23)
 by BL3PR12MB6476.namprd12.prod.outlook.com (2603:10b6:208:3bc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Fri, 13 Sep
 2024 11:41:05 +0000
Received: from BN1PEPF00004685.namprd03.prod.outlook.com
 (2603:10b6:408:10b:cafe::b5) by BN9P223CA0018.outlook.office365.com
 (2603:10b6:408:10b::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.27 via Frontend
 Transport; Fri, 13 Sep 2024 11:41:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004685.mail.protection.outlook.com (10.167.243.86) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Fri, 13 Sep 2024 11:41:05 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Sep
 2024 06:41:00 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [RFC 12/14] x86/sev: Enable NMI support for Secure AVIC
Date: Fri, 13 Sep 2024 17:07:03 +0530
Message-ID: <20240913113705.419146-13-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004685:EE_|BL3PR12MB6476:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e0fe1ab-eeee-45fb-3568-08dcd3e8f394
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M91/ig967k8bu5+WUs2nkABnY4Z+meWlW5xv7nF2sYFhoV6Mc2xDnalrFp9t?=
 =?us-ascii?Q?+tOS8rmT/j5qlSW/6oXVGccHSb9UanyA7U0AkI75jvdyIMY92q8zbDggwb/f?=
 =?us-ascii?Q?RNLuyCuUuoqdJEMnkWHzcqqXw8hwDYWNR7albBIPcvamF9avEFpW557YxFKV?=
 =?us-ascii?Q?qE5AFMm9hx02LOWFpsOQezErly6ad2cePw3upne2KxP58WzAm0BzAwVlifmU?=
 =?us-ascii?Q?pvLGxDAjHUXOJXe8QlbLWFQKge6bVUgCo/aiNcIutnTrltIWO/GBbFVu21Vr?=
 =?us-ascii?Q?1IP4u7XIcYO7OZlDaz6n94Dy4cvwwsRB0ZgPXzjVRLvg75hTABL3QXpG/kgN?=
 =?us-ascii?Q?TqG799ZSAr9xBGO68oRrqrRM2FwS3S8pfbrewP3TJsOmm5G51gDTgkdeoz+O?=
 =?us-ascii?Q?ThIT2+COjx2rAsgQn0Yg79hbHIif0VREw44Nm/t2ECSV4TgPubIDPOFLIvI4?=
 =?us-ascii?Q?nzZ0LBPVc5h63A6b8E/KwKZyTqlTrnsKGhybKtSeIhOcymEnZ4DUhRBdHV6o?=
 =?us-ascii?Q?7b6b6Ne9QTGxHnJ9hlLTrtAxmbB7nd6yEfDocWsyrZjRZ7mxeFMWJXLujKVS?=
 =?us-ascii?Q?p6AsOTpy1Stl3x2edqMzKLaDqX+Uk3S98LmGReYw29uay+/jVsV+adDOvlNj?=
 =?us-ascii?Q?F/v8qcfp3LwYnEfqPCz3j6NFBCdyLBLthRwF+85FtzcsPvl6diD1f+Zp4dk/?=
 =?us-ascii?Q?ETl6lCuigdBLvI0MHoDzOnOgs4Puzk3ocwqqIYNiZNDt9Z6nAlthixbngFMZ?=
 =?us-ascii?Q?lwPMvfaZeiJ5rsULQFVDu72FeyBgt0SWtnyY579sOOIxVMfiHfIjA8tCARae?=
 =?us-ascii?Q?gUHiDqpipI2RxcxF2QbCbkiDNURRPNd34egLwhU6MMYcZGWppuQdPlBlcDbO?=
 =?us-ascii?Q?UIWOQauIy2gzvUaibS1YaWdO5dOn6jAlSDGXE17XYVeiedeyKGI/bHKmIith?=
 =?us-ascii?Q?GYmxrAblwRSo9XXfi1wDezjrHvZMPS9Jt5hOpC6r0FAQsmyPlbSx4lsdmq1C?=
 =?us-ascii?Q?NHotg38TjQy1lnJfl4U6PGkHw0D60X34mRP6VsheM39PhrDXIoUhMQzGlKpH?=
 =?us-ascii?Q?Hz/bDsF9zGeq3WlizV83ACbNgzJSxGXCRaImU6w7xcBrAy1rR0t+FDLJiSAl?=
 =?us-ascii?Q?AhFZYM/+HRiOa+Ya2AwJjWnwP+Ozh2tOEONZDDBAIKYd1UkLvr/yFZyPJaYJ?=
 =?us-ascii?Q?Na/nOAXmGKwV7C3Ph8gX7IB6nOYv7mJ4D5rExd2wLr7hwapFwtZ5ieeDuzGG?=
 =?us-ascii?Q?5R5JoIvcEFKiw1lnH0cK7TGOzRxVGOUGVRlXj2cpnIiNMsv5kYdOID+f5tXy?=
 =?us-ascii?Q?IKwpLs1ZDYUW89bKY7GEX2jcAngZYTp3hEIW+2mmI3u1CD/VxjOtDiXamxMi?=
 =?us-ascii?Q?df83SIZGp8p/TErgRzlzH7F8tMMlNJFZcxCbKM0wYDmatpg56jTcKX0Q7wMr?=
 =?us-ascii?Q?P0fMYBDCCKQwNWCzI610fvWM/9WsG6Tr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 11:41:05.1436
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e0fe1ab-eeee-45fb-3568-08dcd3e8f394
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004685.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6476

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Now that support to send NMI IPI and support to inject NMI from
hypervisor has been added, set V_NMI_ENABLE in VINTR_CTRL field of
VMSA to enable NMI.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/coco/sev/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 3c832c9befab..d0057a2a7d4a 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1191,7 +1191,7 @@ static int wakeup_cpu_via_vmgexit(u32 apic_id, unsigned long start_ip)
 	vmsa->x87_fcw		= AP_INIT_X87_FCW_DEFAULT;
 
 	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
-		vmsa->vintr_ctrl	|= V_GIF_MASK;
+		vmsa->vintr_ctrl	|= (V_GIF_MASK | V_NMI_ENABLE_MASK);
 
 	/* SVME must be set. */
 	vmsa->efer		= EFER_SVME;
-- 
2.34.1


