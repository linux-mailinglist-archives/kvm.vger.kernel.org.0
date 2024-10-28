Return-Path: <kvm+bounces-29811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B5CB49B2477
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:41:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4AEAB20F91
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 05:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88B981D2F50;
	Mon, 28 Oct 2024 05:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kBvo6c/N"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2071.outbound.protection.outlook.com [40.107.244.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28171D1305;
	Mon, 28 Oct 2024 05:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093753; cv=fail; b=Qx81PZOgckD1tR5s9pSHowkztzoeoxWQBDPRPUgj+k85JJsZOv2DmdmmmhxCPVMz+jNP/d6cApOvDwz07eKmVQpeCdSQmh/PXqBYXPOBMC9PC/vRWET/wb9LAUb73892XXSNP27afHHxAJm1I6AsrSQBe3cW0KBmGuOaoxUDnRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093753; c=relaxed/simple;
	bh=JVX7OfWm4DeB7mmK9cRP7mo2EX+qQxw5B1sYp5c/VJE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T5OTfuzyJ2nseDn6mytRq6vfK9jKJNuCJ8M7e8xDWfbCHHe+LaktdktVTjMkIhDhdB1O3wpB0DnKMXeK3fCcGL/WEHts4frq2cR7P6627klV3MAkA1k/bHI3WwjSGWuNkLPu0RMA8p/EPo671b6YDXn0OLX/V02h8Ck8WjYH2uQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kBvo6c/N; arc=fail smtp.client-ip=40.107.244.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bvizQ14VpXRXWDEHLx7v3hiY65OZgL8d7ZgepQixd0bYLpvqmenD/cS5siGDNnyj23GDviSRSza0KUboGQqlA8K/+YPj+b5lTePscQ+7DXIKviNi9jFrgUg8EzCEYU5W4xxluE68B6HKgKn/zo0vrw6cS838SY1Lakd0S5XoxBOeztV49wC5uw/Cr8NMrpMmUZ+BKNeuADGlGElph1J0ld6a4U1pZeeHl6bleOGsJgmtp1shdR7UvANhZymoHtwwaSZs81G7GXBjS4t1w8ZHBevx6dj80qD5D01d+uPUOUTziLe12a3p87mmMvrJyjVp4+IadBhqbuCifUy93vKnww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJhGospZZdvaX4gyCb2Bop62etrYm3d8Va0F14x/EOg=;
 b=i4TCjKdiDwPGDe8dnwDFjW1UoTmRXDW4pWWIEdg/+5LzYuCb+mjZ4+UsxHD3cnZggdc7hTN19MvjOfHwxt/EDYht2LPA7TLO+OQJ2OTGwaafwccogi3TiBhadbAzP/P9N9IXJVYUswKo7kgiUb3X8p/711w5j5wwZEJHV2hUFyKQbxjQwroUpenNT7SPxc+Py6oTYvP04lRjJPZmyztaGM0VkjCu1OJqLg5RmpVpJm9LEWYtZzepRZjc5undoZb7Avyaw2rZIuB8LIB2okgI506qdm2QVqCXQAYTngTvDClMUggOngOqo8eW5kYZsF++LohFcmmj7lgUUKskGLgg7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJhGospZZdvaX4gyCb2Bop62etrYm3d8Va0F14x/EOg=;
 b=kBvo6c/NPJPh4XrsvyjdZ7hsCbO3Y7PH3ciC2IjDjOx5IV2IaYz83gnoum6rXUxTNZ2i/NDAnfH9GX9iHxiqFhLzAHjDYFjQ9H/fisOj2tw2guBwjhYzlhx9dTilCPT2D+dZ9CB3mZ9qb3uW3G3hu45RTrDettYaS/7uV8LwUww=
Received: from SJ0PR03CA0135.namprd03.prod.outlook.com (2603:10b6:a03:33c::20)
 by CY5PR12MB6177.namprd12.prod.outlook.com (2603:10b6:930:26::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Mon, 28 Oct
 2024 05:35:49 +0000
Received: from SJ1PEPF00001CE9.namprd03.prod.outlook.com
 (2603:10b6:a03:33c:cafe::a0) by SJ0PR03CA0135.outlook.office365.com
 (2603:10b6:a03:33c::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.20 via Frontend
 Transport; Mon, 28 Oct 2024 05:35:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE9.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8093.14 via Frontend Transport; Mon, 28 Oct 2024 05:35:48 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Oct
 2024 00:35:41 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>, "Juergen
 Gross" <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v14 10/13] tsc: Upgrade TSC clocksource rating
Date: Mon, 28 Oct 2024 11:04:28 +0530
Message-ID: <20241028053431.3439593-11-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241028053431.3439593-1-nikunj@amd.com>
References: <20241028053431.3439593-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE9:EE_|CY5PR12MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d9cc462-70cd-4e65-73d3-08dcf71260e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jb2KaZWdEhCAgGPTV5235w/5blLol8zGD81+8Mrkbo1QzZG5voh7nC7AH4R2?=
 =?us-ascii?Q?7RSWx1F0lRZSfFcMtN9y/qVexQ7PkOhZX12I91rTSFAlrZc0/96Smcd/9DDI?=
 =?us-ascii?Q?eoWy9mSTiyystg/3q9vPbOI3YvJNPVxcQl/oJ98ycoE0TiZEaltUpiS/VQhG?=
 =?us-ascii?Q?eN6imMX0Z8XQUsV1gh9fySg4pBnRiTL8LCGVdyER7J21UTtgFhlOv2FvS99Q?=
 =?us-ascii?Q?QwgSdf9HcO7ggwZREJ56xLoEOGHDMdLaIZRlBO3UQxgbtP8bZAoLh+MZEi0S?=
 =?us-ascii?Q?/CtcMKgPyl337xHP4wvMghqn5BADdrK17YwtQSmHxXvmH5fNbVxzBU0dCD1u?=
 =?us-ascii?Q?FeTwX1BctbYAZ/N6BFzkoCb5yEh2Mn/e6EYjpqJVDmXrP/4miaWzY/87ll5d?=
 =?us-ascii?Q?0TITm5OQfrv9XRu/Cx5T6Z/Rmt35LW/TK8GaxA5VN7RhLz9NgpOKPk8S4XhN?=
 =?us-ascii?Q?lDhlixjo39Bs4GBJxndtIpdzaOU4B+YC0ogSX89bs0ShPFvuR84XO4ssFDxU?=
 =?us-ascii?Q?iH4faviWkSvm5C68ZtxYCQBkSvfdfnXhwkHI5fvhNJ64V01ogUToIobkdNFj?=
 =?us-ascii?Q?FPfyoZ+QTaJwDbfK96BU80a345BQtawqirZSiWs/Drywf41kHtQ8KZkvrnov?=
 =?us-ascii?Q?8FalgooEE0LsvbfkFkpoDpmboqmeibPPxFHXvIiE0qmosOMYDuKlbZIqbrd/?=
 =?us-ascii?Q?U5eIuS0+gWczE8R4ON2Qz/jIO0liGlKqtxMTnmJcTRxKaMV6oUN97AuffrGn?=
 =?us-ascii?Q?Lc5cVIklp2HFzTmc8mpSnJgXk1aLrZyZbepshLUrjgdx9U2TmfMq1DifaMlG?=
 =?us-ascii?Q?2ZDJIosiPwc4Hh6LgP0++mJipd8hYEVCSGV9NvJnPCDaP5BSIjPWOmhq1izZ?=
 =?us-ascii?Q?GJxUvqOYjljOkgeQnZSlruVUIjxpoUL6/nw6e5BHGi+26BC7h0mAvg5KbEq9?=
 =?us-ascii?Q?y/I/7WEtX3zjGef9NEwQ7g1G9By0nX/EXxkB4iyaBZkK59tFwKxld+YfKdJg?=
 =?us-ascii?Q?f6QBkknoUfnlSytjCmOJEFEU6OZZe70duFqy6UeLi6lLnWeS+WHwaYsYMGYj?=
 =?us-ascii?Q?/eFFUILzIOgwhJVkl6p2uLfV7BEsN0eKFwMChJzrWaI8EygpKnvCsVcLLhyg?=
 =?us-ascii?Q?B5GZW7GwrTIdMw3NVb3oOnivfAQ+bs4EG4mCgEMu7miyg02ClouSniAqsrZs?=
 =?us-ascii?Q?mIQMTG01l6u6y88E0tNEeqdsTkdgVbxJsZr3ypG95s1CF9+276o8ett7Immf?=
 =?us-ascii?Q?C5yu5iTBy0CpH3KgO+F5pFWigFPiY31AsIjEL2VGkGkNmuxgF+qZ8E8e6VzU?=
 =?us-ascii?Q?G91cV3VA163CsSBpq4tgxbks8MVkC8ceTHHUD3/cvmiJjPJ2ZEk31sSGXyez?=
 =?us-ascii?Q?ku/qg23gR9edGd5lEnSibTz4+G6rx8RHdhqdVE8aw7rKtiFiTQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 05:35:48.5302
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d9cc462-70cd-4e65-73d3-08dcf71260e7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6177

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
index 730cbbd4554e..cf29ede4ee80 100644
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


