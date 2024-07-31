Return-Path: <kvm+bounces-22791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF2A49432E7
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:16:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 254071F28B87
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 940191CB324;
	Wed, 31 Jul 2024 15:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PpTBIwE/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2080.outbound.protection.outlook.com [40.107.100.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C4F1CB31C;
	Wed, 31 Jul 2024 15:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438586; cv=fail; b=bpjuKMxA4EurvlfGq4oBvnM1ebwg48e58HgQj1MrejHx8vzNhS235To6VdFKXUqDihDZwhGSLfO5BInE/UR93VmRfat2l0ZM/YJJ8gkkjihwHKWhp5rkqlYK/BY0JSAV0rRwyHizjkAK4szLgX5SQlepZ5xZkrXWSrw+Xew69+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438586; c=relaxed/simple;
	bh=4uyj7G0a4vT6/sxbJBvIsYtflmX5hLJGrOmw6Kq2PNg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I8ggTlzg8mCICflotBg1bt7IJ11OnJ2gJrzYmuPExGskE8R7ld91Cgw4Qqyi0TwW49mBLJl/xPtjWiWveiPwRExysp1cfkRF3dvh/zP2VcPddAYIx/oHugwOBZ+kY5xVHTuwuA9Z9AykQZl3uXEbGH8PrBzN97mU2qHAciLkXMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PpTBIwE/; arc=fail smtp.client-ip=40.107.100.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RXS7sYEOrTfp8IXvNJcYG7gj17DoHZkaPMeQP/ypqHD6rqwKM6a92qgh/dPXwdLeH+Uvtg+jCyeHbjVGRKVRo0JLvqmClPMV+UNycCBUy4P9AKc8dgw2g8quwe9bHa2T7liA1EyxcQ/UgOR4xubMCWOLxp2RX/zll0vE2nBj/141Yqe2aq1N+qrvyPxydvOmTO4rYzq7SQSbcuDeGYC88WnIuOquyR0APpu5qgcQtgZ3l42rh+KLANor4s3RmUBAodSqTsW5Sv6o7XgScfV/PIIXNNPhdN332XbylHCLdB4fvN7NJzWrpL25dvYcmWIZlAoO1jL86FSbOP++c6JaTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpq2RL7/mLnCVwuZz+gs7mct4r+12ku081S+bYQqtYs=;
 b=CBVHmOiz+H5l+yxTf7t2iVk2i91H0Ggeua9LsKXEDBcMfi6RhtfWhWdHPDyd3UQux7m37czWztXJWQINzJwwdxGy4+AaKLrQ3Q63K5mv/TYzkbhLzJhusSewb9qo1dMW7Pmmv8i+aLCOpXIQ9DdIdBUBdFaLLEzRAfAuCoBGe5Ds7FxTMbPy5UpU9cmRdF6RFpmQqnpm7BmxKfPIPzj7tV8zoPmHhkssn4Qley3zuwivhF0+bQ3OIXPIU5FUKrAL7m7WxqQnLe1H8jMR1gFgUJyxgQLlJowYgm9FttRrpz/e/O8qiWkJBCO2eLlO/rYQ0Outuw68ruuPf9CWsoQaYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpq2RL7/mLnCVwuZz+gs7mct4r+12ku081S+bYQqtYs=;
 b=PpTBIwE/Qk2icD1VG3r7TC2mpWXEQI0Cn/CrDiN1nxgUOYraVmp9wTHKID8UK6G6MNWnFRPHfdjZoXT0hvJ7nwzgrsYM2X6RWnbtfCAKQ4Mnj2z6mwIZslWhVPRGx9HF92SL2JJVBHGwt0X5VypgE73MrXJPZReLyXURocVEQjA=
Received: from DS7PR06CA0029.namprd06.prod.outlook.com (2603:10b6:8:54::29) by
 IA0PR12MB8208.namprd12.prod.outlook.com (2603:10b6:208:409::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Wed, 31 Jul
 2024 15:09:42 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:8:54:cafe::b0) by DS7PR06CA0029.outlook.office365.com
 (2603:10b6:8:54::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21 via Frontend
 Transport; Wed, 31 Jul 2024 15:09:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:09:41 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:09:37 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 19/20] x86/kvmclock: Skip kvmclock when Secure TSC is available
Date: Wed, 31 Jul 2024 20:38:10 +0530
Message-ID: <20240731150811.156771-20-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|IA0PR12MB8208:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b0714bb-dbbb-4ce1-d022-08dcb172cdf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xfc1v0G8ZdUYL8aIaRI+zW7dgSsrDUcBtN3DsyPQa7d1OGcdJSYeiVaDqTu0?=
 =?us-ascii?Q?O8Lbxlx4Uw460N/Pt+Fdc1cfXsMMJT/T2HTj9PCi6CrCxBUXMvH7txiTxzMj?=
 =?us-ascii?Q?WYuNotGrenB1t30N3UI5k6aB2hxrKY0kODwUHqVJLVytMPaB83WZdJQUcptP?=
 =?us-ascii?Q?ldVfURGbm1C5KmieO8QLWPBpuOecLIII0v6JR481UyuhjmC/zX8EUsrzbLJ8?=
 =?us-ascii?Q?YPPnjYcE8PsKO/JbpD8u0LrMvrZ2GXIFRyTHKjuM+1y1yN5o9KmnjciELPCT?=
 =?us-ascii?Q?WdT3ufqYKVDJ7u/967EUp8UVHHB46pPkvBHgmaurkirWP7slDWIDt/jlSQe3?=
 =?us-ascii?Q?d8Ao7K0Bcz4uVQ1ESZ7pVflPOpskctdnyju0ca3YxMjLpsrL9kqVp4CJxjWA?=
 =?us-ascii?Q?Es5gL9HoIP246viT9fA24doHH1aTokNDqcQ7Rbgd5v5tnk+9dbNVhZvY1VZ1?=
 =?us-ascii?Q?Eka8D2xBdRcURLiJb/CYZApAvgxfDMtPBhFP4EJcosYF8aef5Jd7EGLt8Q5I?=
 =?us-ascii?Q?gMC/7GHegF69bTf2dOmwrCQxH+/GdBVf1Mg/WgEpHqTBTgYJ8FSVq2hNpw/p?=
 =?us-ascii?Q?acTn2dZK+0Tqa4ZdgFFSvtxSPYzOWbEYm7Uo7iEilug2OclMJx1Zd1BtWC5a?=
 =?us-ascii?Q?XqcDKKqgJoAlHVOGSRRtJT3WYCaT97iIQ/h9LN9bKSfOY89G4wamBNprINX7?=
 =?us-ascii?Q?wo3jroxQ9GqKiAMoVkDKMNxhvPoBxUEM4hjj3f4Bj7KByYrbTRm/v6lI44v5?=
 =?us-ascii?Q?nL8bWHdB9SXur0/wdwG2kpqkhk+SaqND2n4YM6N2aWAs7whKnoEhCeRAr4xW?=
 =?us-ascii?Q?19INQXep8YqJh+D8CixunPoa89bWi84+7lxkyyR1l7W5tg9W6SGlsGYHjQt9?=
 =?us-ascii?Q?GTFrIkSqbBr76wGOTOJ9ZI3tj5yUbRdw4x3aWM08U7iXGP7VKOINUj11cCiy?=
 =?us-ascii?Q?ZpVXY1nQW+E6LveVBz1xLJhWXSRl+dJFn015d95/Lx7wpXkE+yeSfbcA9QFJ?=
 =?us-ascii?Q?yX7nlSjDpk4dCL0+RtAmDU1wUxEDHU5ExQIJugPGrJCtzmkWKJ2fz5Ft4fLg?=
 =?us-ascii?Q?sdpp4f6ief3HOHwXDk59PuHpeHtfRgcHcsE6+q3PX6ZLXgXrRTYD974rTcNO?=
 =?us-ascii?Q?u1Brxeqzm6231cuox+Qp+5O9TjII7L/Ef7wiCq42v/H6eyybk1L29yJ5n2wv?=
 =?us-ascii?Q?faTiDxO8itwrUHiStiQsviUr0zhR8CgB1BTjybFJgZe4nHW96tDYx2FGAaWH?=
 =?us-ascii?Q?rR2efn5bg2WACjcXnSQxvgC6Wpyc1eCvqSeVCWHOOy4W11oISL79d0YyEqTf?=
 =?us-ascii?Q?e8YStgYNsBnCHS8gtYiqVY3Az2c+HpBRqkbC3moA5pNVEOK19Var91zI4o4Y?=
 =?us-ascii?Q?KkI63ZLovWrRA0MnAx1jPN8rZ5Q+NZqxUyoJnH3ge+Z9DHvS3aM3dCD35LN8?=
 =?us-ascii?Q?XFZNT5z2EtkXFZYZt3OcfXq8UWjdiXlh?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:09:41.8566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b0714bb-dbbb-4ce1-d022-08dcb172cdf6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8208

For AMD SNP guests with SecureTSC enabled, kvm-clock is being picked up
momentarily instead of selecting more stable TSC clocksource.

[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000001] kvm-clock: using sched offset of 1799357702246960 cycles
[    0.001493] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.006289] tsc: Detected 1996.249 MHz processor
[    0.305123] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x398cadd9d93, max_idle_ns: 881590552906 ns
[    1.045759] clocksource: Switched to clocksource kvm-clock
[    1.141326] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x398cadd9d93, max_idle_ns: 881590552906 ns
[    1.144634] clocksource: Switched to clocksource tsc

When Secure TSC is enabled, skip using the kvmclock. The guest kernel will
fallback and use Secure TSC based clocksource.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/kvmclock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5b2c15214a6b..3d03b4c937b9 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -289,7 +289,7 @@ void __init kvmclock_init(void)
 {
 	u8 flags;
 
-	if (!kvm_para_available() || !kvmclock)
+	if (!kvm_para_available() || !kvmclock || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
 		return;
 
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2)) {
-- 
2.34.1


