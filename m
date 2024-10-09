Return-Path: <kvm+bounces-28215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 312C499657B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:34:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B5C791F22216
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C0E4192D9A;
	Wed,  9 Oct 2024 09:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xMs2SzvC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02644188A00;
	Wed,  9 Oct 2024 09:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466212; cv=fail; b=Td5OfLQMp8hQwfWigktQPT62Y1BW65FMWSp1Ttvagr1+n+dIWOMYbNZtQuT4JCJQHbiyDRsR72bV0EVbBXG29ZNDBV4GBsXytkGaT9HTIhKaz/5/tSbv5LSaJRbuGKC8fD4pd+B5kfEuaG9GBKERfy2zfY8t+bKdDiZnrP6ckfw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466212; c=relaxed/simple;
	bh=cm+JJ8AVEPP7aMVpJngz0lZCljTqydBTuNDLoVxQGdE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L/F8z0vJ7CNlycehz55FjfJBmtaI6cvGFcM5rO1nay3CaFCxkKtqFk0LD/ub6dqnBEw/nVDxNrKlalGkCnofnKY4f4h2pREPUXEpEWmPLLhrDMqzGC62wGIrhdhic5G7eQf766RTEG4p12ZdOjfojjcSd65g50lAjOysJotCPpA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xMs2SzvC; arc=fail smtp.client-ip=40.107.223.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fDcACBycPapiE/rEhPpa3/Y+GTS1ou0w7kln4IVIeUSuuYZq2kiFd1Ti9UHgpRH1ObVddjbtyFVa+Shfl/iEDtkkMHvZhaFlwKQuc+IjubvhXePlrtavHgW1hkd9rFHCFjiX2ZE0V9gFhhB9leVLvBTskXX8G8u4aRUIknP0WTIDgmqSemHRcY3jcBUwHqXuGJLnnWqBC/FbszZ5ZMZqhNRDLUWLNswPLTThnMqQHkaxhepOwweLvWSEScggSVVKF7TxjSjoWaB0+Ny38PdY6rDRZIVJmhp3GGJ/fcLvthySzUTPTVk/Gdvn0voYWa7zMiFtDDkA7LMg7Fk2Eknx1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pq3EC4XhIJZAGlFQNoMnt4aW83Fg6qOxirkSaBau4rk=;
 b=QmkfmYl8KdAWvNomNtKiLbvPjFeNWPX50jkvP+veY7efGJgNefzojYY/EZlNFLSYPZtaxBYQapkHsIQyAN3wwiL8cMdREmwEyc6/GJfAKfKqPCgAQ0r6jFmU8iMe8qMYCQUKh50xwyakbpjhcdIjx7X8m/QAUo3xt8jCEWgDH1HSvgas9L0nhNM1YAuFRv0U7CxfLEhY/308RSwx6T0xn8sMLJrF5sB5RXhuLEsRpnORJCFCXMvRBL9GWzzr6zbDW0UXQdqS4Vf8IoLGocVq/aiOhOsaovsh93gjTTgZf+ItQ0IUZrGspTh7zBYJcFUIXkGXHXxvcNfA8bmXSPaUvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pq3EC4XhIJZAGlFQNoMnt4aW83Fg6qOxirkSaBau4rk=;
 b=xMs2SzvCgVoQQ6xgWPChJe0osNM0kcTXPOCicU+7NO3brJou8+sFmgqvGPwX6XWwC/mQ1rpH+6sl/xJfA36umLzTBlX/RJKGofwV0OzTFMkad6v2eBy0p1vHq/4HTIb0WLJoHq+gqISoYiNW8jXeM5MLnzp2d7w6MVI0mrxr4/w=
Received: from MN0P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::20)
 by SN7PR12MB6815.namprd12.prod.outlook.com (2603:10b6:806:265::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.16; Wed, 9 Oct
 2024 09:30:08 +0000
Received: from BL02EPF00021F68.namprd02.prod.outlook.com
 (2603:10b6:208:52e:cafe::93) by MN0P220CA0010.outlook.office365.com
 (2603:10b6:208:52e::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 09:30:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F68.mail.protection.outlook.com (10.167.249.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:30:08 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:30:02 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 15/19] tsc: Upgrade TSC clocksource rating
Date: Wed, 9 Oct 2024 14:58:46 +0530
Message-ID: <20241009092850.197575-16-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241009092850.197575-1-nikunj@amd.com>
References: <20241009092850.197575-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F68:EE_|SN7PR12MB6815:EE_
X-MS-Office365-Filtering-Correlation-Id: 947e641a-fbf0-4001-37a2-08dce844f74d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A//1BD10ZYG53Qruh0HtsoQl0ur1CU0oW7rhBXXOzVpxcDbhMPTQdi7S058S?=
 =?us-ascii?Q?Tpr9MWpN82rW7kPNvv1Sa4B60Rr1tBHBd94dp6GMltXQe3WCGNZOsMk9+kMg?=
 =?us-ascii?Q?nHuadxv4Tv2koL66CsBJW8o1InGOI0GUSwwlGgMA1KxN8N8X6WNMyhVMDBg7?=
 =?us-ascii?Q?4/LD01EONf+zOZDzBs9Kp8CNSF6k1/yRCB38fsGk8DvJUNMv7C7ZE5rG3JQY?=
 =?us-ascii?Q?hIsQrYQh2C19FurBIvo1akwSICXZ6JLy0VpEqDzS25/qeV7KwGtkDERgCtIh?=
 =?us-ascii?Q?NMvFJg98yvTIEvZSHxkxmVPjxkP0JlIbS23hiBYnbgIRJIYN3YHG7CYaCHm+?=
 =?us-ascii?Q?K3FBFzaUSEuleMhhdD1nsQ+V6i5wW7Ehm9xX1C/ZO9ex3rPO0DD0SGqszqua?=
 =?us-ascii?Q?pJQlUT3iP9U8kzz1Crku+hsVf3tJtXIbRC8evZf38bKIJcJ61/jcBxF5aMIh?=
 =?us-ascii?Q?UVRANFUocRgjpzIEXTBZ9jUec3gEYpWmj7QxyAuSQajQu0YMWP59MOmDeoeF?=
 =?us-ascii?Q?CQuiTcnJ//JagK14th/y/gaA2aeVpOXlJpjSOwGQRz/dphYV29svgEXqs5PG?=
 =?us-ascii?Q?cDPXKLYCR7ChP365bKpaTFZkhU8ZRRnbUijSLRAIENoLnAupsU2oKvILnzSd?=
 =?us-ascii?Q?4nmBLGzms+CcxYY0RQbLXsylNnWq+ITG7PD1CeitFmj0NIanZslI5i/Nnnmr?=
 =?us-ascii?Q?UD/eIDCwglNe1vSkXKCaN7octbCprxWonlkmJfYbrdqSnWYpdkOhb5kxp0+M?=
 =?us-ascii?Q?ICSegiY6xu1c1A8yqK4Vh1+MIrFECNKsvDJGAhJuzCx0ITOEfVN8k/kUVlQP?=
 =?us-ascii?Q?gujdK1t7cKXrfda+Yf/2psjQL9rMG/LMZhfV+lznPX1OBHUTPYCGgX409ssg?=
 =?us-ascii?Q?gVTWyO2pLZhJbFhEm1oEO/LVSkMprHv7ltBZE8jtyvwoAhx5xMcBu3HHZNAV?=
 =?us-ascii?Q?lfdEzgc3FyvcHFV4SyJ1cGkOM3nBL1MPSjd/MCfSxWpmI0Y9KEJcmIQq1mYE?=
 =?us-ascii?Q?hfeawAyHFx96T5MejOvWh+IaFZTuRxOtnCojd7VHVNgWnFSlossAt0MGGfYa?=
 =?us-ascii?Q?XxqLBPz9geqHUnRRsMc/4skHG+3ZCrqKJfjxf/ha9FyJEcMz2QR0najBIaKo?=
 =?us-ascii?Q?9g8r1GTvb7nj6Dyhp3D2m3EH1rmsSkJxPlNdpJagg5L6Ly7oZjf4BvrXuiUn?=
 =?us-ascii?Q?qOL9Y5X2uxqL1A97BNiUsuNxK7mSd0CY4KX7Ue9+6LBvfLxLC6i8q0jGqzp4?=
 =?us-ascii?Q?UZ3YKsm29AdRNwQ5PKiRQv4+isHHUXBIQt+t/HAwNF6uUauSzMyLucLCH2s4?=
 =?us-ascii?Q?/Vmjz6u5utejq7+otvMXiCfx3u5j2jr9jTbk/uxr8+plK/VA4qkLJnQlDQMk?=
 =?us-ascii?Q?Kkc9mKH1reZJuwR8TA2za/71dQRa?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:30:08.3439
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 947e641a-fbf0-4001-37a2-08dce844f74d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F68.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6815

In virtualized environments running on modern CPUs, the underlying
platforms guarantees to have a stable, always running TSC, i.e. that the
TSC is a superior timesource as compared to other clock sources (such as
kvmclock, HPET, ACPI timer, APIC, etc.).

Upgrade the rating of the early and regular clock source to prefer TSC over
other clock sources when TSC is invariant, non-stop and stable.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/tsc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index c83f1091bb4f..8150f2104474 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1264,6 +1264,21 @@ static void __init check_system_tsc_reliable(void)
 		tsc_disable_clocksource_watchdog();
 }
 
+static void __init upgrade_clock_rating(struct clocksource *tsc_early,
+					struct clocksource *tsc)
+{
+	/*
+	 * Upgrade the clock rating for TSC early and regular clocksource when
+	 * the underlying platform provides non-stop, invaraint and stable TSC.
+	 */
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
+	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
+	    !tsc_unstable) {
+		tsc_early->rating = 499;
+		tsc->rating = 500;
+	}
+}
+
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.
@@ -1565,6 +1580,8 @@ void __init tsc_init(void)
 	if (tsc_clocksource_reliable || no_tsc_watchdog)
 		tsc_disable_clocksource_watchdog();
 
+	upgrade_clock_rating(&clocksource_tsc_early, &clocksource_tsc);
+
 	clocksource_register_khz(&clocksource_tsc_early, tsc_khz);
 	detect_art();
 }
-- 
2.34.1


