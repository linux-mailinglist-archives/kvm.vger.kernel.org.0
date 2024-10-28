Return-Path: <kvm+bounces-29812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B4B9B2479
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:41:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDB30283ED5
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 05:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06F901D416B;
	Mon, 28 Oct 2024 05:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wkyhbzzb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444F61D2796;
	Mon, 28 Oct 2024 05:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093756; cv=fail; b=EccitYo+zUtcRxt3Dgl+0lgY/VhSDzg6gn1zqKZcbVBA3NFnI6QKiOhiccLwKOVe58R40IRZFE1HxyjOlJTL42vq/aUOBESq3uflngyWUqokbQ0I1YSrJhsEQXHPJOovb32OM/UMq33ykt4sOtteVBSFX0bawjTGX0wW2CeTwMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093756; c=relaxed/simple;
	bh=xRjLm55uZZf34G6ds8D/krpLHmfwoDqavN6Bg0q75aI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ge41Rs7dCo+nhb6myfVSNvUY0//pqlXcrPTTt0+waSd2T063m7jAOXaMDJKHi2Gjob2gXgGymLL+UkZ/gni0DC8ZWbQ/8FIzmOc9/PBa4/IkSkC6N54CcptgVwmcAPN1lWHN2Lb2/EPbG0gEiyCSr0v7y3FsiHRogZ14FILzIow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wkyhbzzb; arc=fail smtp.client-ip=40.107.94.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RxBWfun1C5K3QYxHSmRDLI4zoKfhQCOyCrd41LNKFO+Sn5kMmt4Vko+TuECu9uARDjA7xHvQnPWuOHH7K3T33dOpwE0kvmdnUbCXphVmcbnn9IHzc4cS2tfKKjUeJB78BINNyY2AQbP+4+ZUVB9mB/4qYUP1M8OT9Ikj+1JWm5p92nRpZFVSzsSbMsA5HrnKl6EkjutUzsDKIMKoK2Pt4kRSpJyOSEcUNYsuVclp3wOMl9PTKlTmXiOo0dckr4b/tRNh7GYJjyetjMgGu8fIWo8cLGZ1FApymHbOHGJ8T8IUKqtld3bUt6ZhnIobt/GpaemBCJHWp4xPB9Vf4ShP+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=puOvZD7dMnyP/mSy5fX3y3C0dWkvUQhiYs0GJr6meQc=;
 b=w7ubDvFJSJa4nRNh/SSjR4sI9NVsUkHhBHLjlz/dWQ2GTJDJK2ngd8GGeN7cuoYE2ZVDmvTQBipHQSDnqI2tsRUTkc0GdqtHBGpNDzs5/XQd8aDFvu8+5u1W4S8OKDrlWCq9TQCkaxwC/kHqLCS7JOiR3lSnIQnBDsbWkIznTwb6/QmJwYy+I8Wp6Zida30M8S4Xt2WozaZHqheg8JSE+4jfZHgD1biErQHkLP80xe1ZAsZPF8YcBsevWj0/+od8zSF8Q4HN2Q0agMXJtmRALFsS8THY8KhCpU2c9fs6xn2Xd3wA5U5aeAmhlX0YnrBtQxl9XdRkGcGltfjHH8UjAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=puOvZD7dMnyP/mSy5fX3y3C0dWkvUQhiYs0GJr6meQc=;
 b=wkyhbzzb2ThoXvnkmQDLcoCALAG451CbTYXfuIeNHZeB/9ipxeYGvrZauKLVg6G8Ze4imLT9rkbx64puljyf8X+9I7weMyt+5N4w1bSnQnO4IFVknM+oakI4Pq4BCk1NvWeWAMqNcZevBX4yKtrreITA7QcPJkAKEw89Blu85Ak=
Received: from SJ0PR13CA0078.namprd13.prod.outlook.com (2603:10b6:a03:2c4::23)
 by SJ2PR12MB7992.namprd12.prod.outlook.com (2603:10b6:a03:4c3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Mon, 28 Oct
 2024 05:35:50 +0000
Received: from SJ1PEPF00001CE7.namprd03.prod.outlook.com
 (2603:10b6:a03:2c4:cafe::f2) by SJ0PR13CA0078.outlook.office365.com
 (2603:10b6:a03:2c4::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.14 via Frontend
 Transport; Mon, 28 Oct 2024 05:35:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE7.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.16 via Frontend Transport; Mon, 28 Oct 2024 05:35:50 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Oct
 2024 00:35:45 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>, "Juergen
 Gross" <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v14 11/13] tsc: Switch to native sched clock
Date: Mon, 28 Oct 2024 11:04:29 +0530
Message-ID: <20241028053431.3439593-12-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE7:EE_|SJ2PR12MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e117700-9a39-4799-e2c8-08dcf712621c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BibSuHp9VLA5N+QT33c5AG8UElOKm10GTdb0ISFTqNI0kOoNEWm2oAElcgrt?=
 =?us-ascii?Q?uyz4BgaRfDa9yJjeEPTqF5oJ5k+w8LxddOJQUY+xjYRrhHchxibTy7GIgc8j?=
 =?us-ascii?Q?2h3U2UGZLejuLEeCdFJPQ2MkIPMDc9b6bCTR4Zm4Lj7C2qYBq+A/GdJAhcZt?=
 =?us-ascii?Q?9j0KXDWzB39Jx6dpNepR/9SgsFv6QG9UzT47a6hcforxTLog0rh6Ty6GPzLm?=
 =?us-ascii?Q?A+2NcTtlhJ3vBOj0oY+4EgsBIaIDfNRTkL8KHlKrsOAVFw2MDBpSeLn6CLqh?=
 =?us-ascii?Q?Gm0FD4F7g7d/3C++6A6qtb6z8nkHwSKO1MM8Nt1A7NVxS2AwvV4gmXVLz4rS?=
 =?us-ascii?Q?yOY1fHrrD63KLpACCHMlPlNcPX8vApHLJd0KAW8AsoBw9Bxl00qQs+PeGitX?=
 =?us-ascii?Q?NSs4as/9fkmlri/Lt1MfdNVulHWE8yg6leqF3F8K3CHk5VQdHqEIN1rS3lPJ?=
 =?us-ascii?Q?1WW5NGq6NE/9zeBeLCovr5X8we3CGJi+oz2WjgdM9AmhUFZpH/OuCGTMji7k?=
 =?us-ascii?Q?zxWxP2b21D9XAg/B1WBDmeu5e9uXoQWIWzI1pktmndSVW0zRHY1OpJDGX3Mj?=
 =?us-ascii?Q?lfraeGLvYwhv3dVFllUiUv3hEp54uIJOSS3MjTFTUb2Siuo8Ev4yTDDpXL8u?=
 =?us-ascii?Q?FC/c20xE6DalBV3zDGbHmT6Dl0UqrRxIuoG6w+XY3vrguxg2zT2qJvam7Og1?=
 =?us-ascii?Q?Lh+D4KtO/z4Mvq/4CsQmpi2dhvkNp1edH3PTJkxCm8Sb47kXf/3dIAMnk0J2?=
 =?us-ascii?Q?P0HoWNib48lgWqtVzsUG2LraS/Z33fdNvOX3+vfHcR3zfNmdxm9Ha2X1iKa0?=
 =?us-ascii?Q?wMGf3NxUIwEYPEwcZUrKPA6cm2mn9SJ9pcICW/fWZUt2wSFqdH6XmmxDMRjz?=
 =?us-ascii?Q?+lgHDptNzf0Aq/zrp1TBWzCkaz+iAxs3sn5eeOlHKdCevYdpzbXaZuFm++NG?=
 =?us-ascii?Q?aDQLcWs0j8NtlczZOpmk/vsz89MWQJLQnXd711dc7y5CpHwIJ7bw3iwwE16m?=
 =?us-ascii?Q?+P4XQ1veu7tU1+oAYOKUezmryNOgHAm9YNtjLB/HRibIlSQT814Tz1tNyBnW?=
 =?us-ascii?Q?ghbTGZnOXu7p7u1vj+EpVhbqJ6ia4NbsuZOoJnFqN+lB6H0JC3h5Gy+rYZqz?=
 =?us-ascii?Q?B+E2X3vm7YVQeB0+rY66vPU+M0eM/IkX65YoCdIaIIGvkhO00nrtzP+bacdy?=
 =?us-ascii?Q?+46WojWsFmJEFga/LblIG3zZ++P8rwPIN3xJcLbaNBynCWa81ZZnRXdArgBa?=
 =?us-ascii?Q?l+DvvXjzxHURSBHReWgOkm2Wuysn1Jah+lA2b0KC3B6UnKqaYjgf+lXWgBp6?=
 =?us-ascii?Q?+mHzykxHuezNndprsCxXrd3WK1QqzDOQJ04w/cJHHYWVraIsa75ZWlIl0x4f?=
 =?us-ascii?Q?bpm2P/ZNbbhXZmFv3XoQdtc9Xf2Gn8iW3my0MVpXKN8qI+RGnQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 05:35:50.5737
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e117700-9a39-4799-e2c8-08dcf712621c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7992

Although the kernel switches over to stable TSC clocksource instead of PV
clocksource, the scheduler still keeps on using PV clocks as the sched
clock source. This is because KVM, Xen and VMWare, switch the paravirt
sched clock handler in their init routines. HyperV is the only PV clock
source that checks if the platform provides an invariant TSC and does not
switch to PV sched clock.

When switching back to stable TSC, restore the scheduler clock to
native_sched_clock().

As the clock selection happens in the stop machine context, schedule
delayed work to update the static_call()

Cc: Alexey Makhalov <alexey.makhalov@broadcom.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/tsc.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index cf29ede4ee80..d8f4844244f4 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -272,10 +272,25 @@ bool using_native_sched_clock(void)
 {
 	return static_call_query(pv_sched_clock) == native_sched_clock;
 }
+
+static void enable_native_sc_work(struct work_struct *work)
+{
+	pr_info("using native sched clock\n");
+	paravirt_set_sched_clock(native_sched_clock);
+}
+static DECLARE_DELAYED_WORK(enable_native_sc, enable_native_sc_work);
+
+static void enable_native_sched_clock(void)
+{
+	if (!using_native_sched_clock())
+		schedule_delayed_work(&enable_native_sc, 0);
+}
 #else
 u64 sched_clock_noinstr(void) __attribute__((alias("native_sched_clock")));
 
 bool using_native_sched_clock(void) { return true; }
+
+static void enable_native_sched_clock(void) { }
 #endif
 
 notrace u64 sched_clock(void)
@@ -1157,6 +1172,10 @@ static void tsc_cs_tick_stable(struct clocksource *cs)
 static int tsc_cs_enable(struct clocksource *cs)
 {
 	vclocks_set_used(VDSO_CLOCKMODE_TSC);
+
+	/* Restore native_sched_clock() when switching to TSC */
+	enable_native_sched_clock();
+
 	return 0;
 }
 
-- 
2.34.1


