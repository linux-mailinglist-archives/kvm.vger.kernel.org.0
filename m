Return-Path: <kvm+bounces-29235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D62A99A5A0D
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 07:59:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB5AC1C2127A
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 05:59:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73DAC1CF7A6;
	Mon, 21 Oct 2024 05:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oTH6QNzJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2086.outbound.protection.outlook.com [40.107.101.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DE622315;
	Mon, 21 Oct 2024 05:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729490342; cv=fail; b=Z9ix05s8M6HMhj2/Q3lp18HSx3iOQ6JbOSDm5AcMECA79pV2CuHWvLWod2B2Xnn9z6mOQ1Ri2uuGQEUovcadL5WsSmZ4dLLB5B4MHEpnE6iMUrMmF4vN3HwvoSk/QSuwmhTJyjetVWHwCZaPXTpyZ/SCSflYQZqugtHGzi8pHM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729490342; c=relaxed/simple;
	bh=RC1ceEsd4TJKbZnbyiivDykW162VzJKHcT21cOWHsM0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tlnwNKN2WMF0vSNNZdwjPQ94KzxDtL9B7iMY9xwTZjiN4bHsXH1bRvoKN8ywOXgwjtSEQYvvTG5AvsxzmjAQgIJtr1+WvzTZYPp244bZGkkLXIaqlTWyT32ufXUXUAvKi8NIuUzCDGYdHI6MRxrNiUQIGk+c7nXh/GL6GxOrBWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oTH6QNzJ; arc=fail smtp.client-ip=40.107.101.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qqi3DWHyhnN2RgVVLKkj511BERhqyUhR/eT48rT15acl7/fKrvphCwD0Gtpx3SkqiX0W7Wn9B2oEv9bM9cuyJUjkUbqr1AzYIVsnFU8ie0k/G8ZK4VFLTHozUKRVNhXDmxgOawzGlXIVnKFg1FKWxKrusPBThi0mS/T2bw/qHrBgS23ZkSL3hjg/mrKl5APVU4Ep7s+eTe1stVkepy2RW07ioEuDnryPDqrGh4Wx4fffWjikXlm72AWuVlEGy+Ofxc23r38yaVZ0qf8wPeO7pm7nNxP4C3pZqYDE0KjIPZYUXOwPLV9oplwSCyL12E0UbMrS3JSWJC9m90nmayY2Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=62zDEoFlkhCEX3fQ9O+YQkWhc8sMjZ5r2L0YtVeQA9Q=;
 b=WGVLjQaMjIIxuEMga4CzRBOl/lAmtESM3d6u4oROHm9kl+6MJWA7c214MO5lqZ2FMrwHPGC+nBqoF4KBf6n14pRl0gsWLr5bOeeqgbeebksokO+ELovVTpzRMwBX60Ka3/ppT1Of24/WCvfI/C71tNmz3f7p4v8BRCF59MD5ZtYzj7Ym7Zuw0n75NPNXakzYxbnwQpglC9jhr3v6LNHoehTp4t9Ej5lBUBxnd+8svx2Ymmi6D8t5mZNyssFGKle0vQLwikjN0dgl38YoHzLEz+If7z/+n44wc/ZlY4vv6F7uhpOidRbkQrDuBy6C5RQWdkm38aylRub5DyzCnGi7Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62zDEoFlkhCEX3fQ9O+YQkWhc8sMjZ5r2L0YtVeQA9Q=;
 b=oTH6QNzJtQiSc+rWB57aptM48Ssj/3uipF2inWNn+rbWIZxyVzf/FGp7NwZFCC7lU44CgtoHT/2tMIVxVCCqbsqkmBeIFbxvqZD3gy3A16lU5b3bINQgjR9mucIuFrUsdqybnoszwkr/0xy7C4V57y+jr3SdqEDVIc+j8fqd/tI=
Received: from BYAPR08CA0036.namprd08.prod.outlook.com (2603:10b6:a03:100::49)
 by SA1PR12MB8842.namprd12.prod.outlook.com (2603:10b6:806:378::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.20; Mon, 21 Oct
 2024 05:58:57 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2603:10b6:a03:100:cafe::d2) by BYAPR08CA0036.outlook.office365.com
 (2603:10b6:a03:100::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28 via Frontend
 Transport; Mon, 21 Oct 2024 05:58:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D1.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8093.14 via Frontend Transport; Mon, 21 Oct 2024 05:58:57 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Oct
 2024 00:58:01 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>, "Juergen
 Gross" <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v13 10/13] tsc: Upgrade TSC clocksource rating
Date: Mon, 21 Oct 2024 11:21:53 +0530
Message-ID: <20241021055156.2342564-11-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241021055156.2342564-1-nikunj@amd.com>
References: <20241021055156.2342564-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|SA1PR12MB8842:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e161e39-94b3-4048-566c-08dcf19573c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fwOKya3czLfPQPixnwcFbCoUvq48+eVbRPgjThnckel8/r8gWpq30EqSJ7Sx?=
 =?us-ascii?Q?Z/UxYCiQvynf5sI0CsXS6nfjDF5EA9UUvktvBD3zJSY5aUA41ngqEMu7Hvvg?=
 =?us-ascii?Q?iUjGmrA+HfelbpMkzaO9UKyCI7bBwBiGgnQav7beR1E+rz5WmN/lpXf/AePI?=
 =?us-ascii?Q?zH1Q39fAfjgr6gd8Ss+aGrTz2QmMwSExjkTt+0mGCYd8XulL4Khrj15l+vEk?=
 =?us-ascii?Q?Jdsd93LUxJZsGvNwgj2XcZi/AYYLNN6YE3QTjgrg/7vJCcApO11GA34EDY12?=
 =?us-ascii?Q?GnuvNz8dVGLlAHKFeKH718A6ye5tVxrQaLN3JWb8JkOCtZ8orHM6l7ZXQsBS?=
 =?us-ascii?Q?NsdhzygzAcqoclj95F93jjAlgmCHrNoRHzgOYcUmSpU24quya1SK5JkTBPcd?=
 =?us-ascii?Q?uHVGPQIEE0vvG2y13hyJMSfyLo/4p54WugByXUHjLgdcFz4/7KJN8OUFIS3R?=
 =?us-ascii?Q?3s0C/EAAfJQ9EL+wc+9oDA2JWOz+dIYCNPCDSavKFGp0cm0jafop0JPt+1C5?=
 =?us-ascii?Q?pHbMI2Zl3xXcOr+ttkAdnjWBkFRpyhaT/6mZQyWTePwO3gkONsbB04cboCyp?=
 =?us-ascii?Q?gv3XIDoKivptctcl6WAh6x8WVPAB+vQo+F0uN8FPqTh9W5JshbcHFdowLl6r?=
 =?us-ascii?Q?ycUrjRUk4CvWAX2vUfFCu8v+ElrdhYRzLITCCvaMQQGoR/qNeyIybPcZ4BEP?=
 =?us-ascii?Q?iAlsOwWOnF0qv7B1LZi81/y/xl39r6forPRcB4efU3shQdacu59b0jRa7EHk?=
 =?us-ascii?Q?8qyhuGBtX19DFRML8BXobS/Pgbte3+3RR0/xqPNNI8vZxlE/IwUZDgnbe9u2?=
 =?us-ascii?Q?L0Bt/5Mo5TLw8lCaAVDlzhHkE5rEMxAeM+h0jA7xima02K+BVMKpRDOGJv1Y?=
 =?us-ascii?Q?5WwxuSCPqJ0c0HOj1gTjsRk7zIO3f5klrS4643Hrsr5t+m1gmjZLIduo6W8Q?=
 =?us-ascii?Q?aK7Jb8BSaHJ3Rqbfa4x0CBmx1y6+5u5jYiMvoWhpP+z1TRmaL08y4gd3/32Z?=
 =?us-ascii?Q?tXGYkSVdD2MznKmnuyxIbytRctm2w/BuZNOo24lk7pdZEh4Y2dGbo5ieMbYZ?=
 =?us-ascii?Q?/JnkXAJwqM7mfWHEig8Jr5C7tbTh6EYRRDArWMlA09o4gHFOIZZfuqvSH/7K?=
 =?us-ascii?Q?/ispf3dd6YtbmjAPVAHSyX7mll+T8UczDqdt2kV+JwwH0ifbcSRvsoaU/7kE?=
 =?us-ascii?Q?k5CturHGm0kbXcnvtx4K/9ZbrOHlyjoNwhJmm5WYJgcLQuNgHv/I67Ua39sq?=
 =?us-ascii?Q?jevFaS7XBCvqk3bXbNKcNR3lwc/NN+8UlSGDWLozsfQxoN6XrgTt/NdME4Zb?=
 =?us-ascii?Q?oY16ncp3AoEOOqrySFoWQzASd3b5lSB4tUsvciPs7+K0Q/woOHteuFM2bKEm?=
 =?us-ascii?Q?4ipDLcboKKmbVKlzRw4HaRTDtBQjqTZokRTUT9ellCV/WPR+xg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 05:58:57.2833
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e161e39-94b3-4048-566c-08dcf19573c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8842

In virtualized environments running on modern CPUs, the underlying
platforms guarantees to have a stable, always running TSC, i.e. that the
TSC is a superior timesource as compared to other clock sources (such as
kvmclock, HPET, ACPI timer, APIC, etc.).

Upgrade the rating of the early and regular clock source to prefer TSC over
other clock sources when TSC is invariant, non-stop and stable.

Cc: Alexey Makhalov <alexey.makhalov@broadcom.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/tsc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index c83f1091bb4f..27faf121fb78 100644
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
+		tsc_early->rating = 449;
+		tsc->rating = 450;
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


