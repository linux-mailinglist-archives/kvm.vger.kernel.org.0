Return-Path: <kvm+bounces-34597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0934FA025F9
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:50:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65BB31881B8A
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:50:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B9D81DF961;
	Mon,  6 Jan 2025 12:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mxfD57op"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A3D1DE3B1;
	Mon,  6 Jan 2025 12:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167675; cv=fail; b=mPQl7yskpY1Jfb8cD5iGhdTgW5IeVFG0mwiWklSSqr45PHJnM58BleM80qeZZBUF6UbHcF5KdPtNv3XFKuBeDDK6znyVcP2Af8BbQgGRC07OJRWqGhbqGhIGksUS0ZHp8k1IiusL5xU55ALy/s/lBeHrhClz8bDOewKwvoesCMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167675; c=relaxed/simple;
	bh=YszAZMvBlOXvasG8UDojCvsCYO8MNSbd8WrkgfdmzaU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mqpAyHia8YOCUHQQWHUABd3es/4b32AxrfuVB7CtaYa/NjiMd1kzWJkwISNhSdLpj9kJ+exGxsN64LQA2/l+AfjBi1BEMrFHxQbym9ApX6Lmaj+WF4aLTnjbrRxaWN4viExP70hvK95eGMAnWDcRGfyzF2yWPylpkn9Rf2IAf1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mxfD57op; arc=fail smtp.client-ip=40.107.92.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hG/dHGMM7EqTpJpM5ctswkTrmOG+G4bdJTfbksdlUnP6kCgnTIHZaWw6xgRsSHWFdSm1GVDZBy3OjN6f7BwYPo3/PHrZT4XEKxHADgxfHsnyRjhmssHO+8G69AJDmwGYwriMsbDJj/M2MVnXJdhC0E64GwqgYmX6BPn5wVrF4b7NJQTL9AyX813UI0BRRviKXctSyvaJfxTYPrv7r+oXJiPJScEUlhUo+GhwteKj8sWhRGlcGQZWw49IF9CHNKsYL0Q8S3Sma2xXjKQaHskYGYQOyP+HO1Y3FNzPjAqRR3gns/VmhsTjZbGCvIJ0knNOFtJB2TpaT4q3HA802s82TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y6y+B9tGmnsxansPvzLyIMVM3tbGm63q2nr5j1JATqQ=;
 b=hqjNNYMmv5vSjGrvxPpDVAjEnDcr+GVZAwctZDkXknJaQIRQsD24MYXBnvoBHnGVik8bM82I4yNNdegInRWMlNtwvDqBQGsRSf0vGTSbteLw+NqDUuRQceBUlA8s6svr/JvGBKsjNfdRPdCf8fglCaeKYYAfVZf5ZzsDa26sfXzAZGyZmswifsR5nM7kLzOYA66rnjq57fJfcdTQAL0QjCg13QQjNB1aCe8vWdEVlyQDrNxpLi5/5/dCSPAU1l0TLah9eLSIFSG8m+39esBUa46e1c29q724Pwhho6yGY97EwtMDKrLRAPbRkqjsJPDL6Qvtd+x5WJYC5RdGqbJr8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6y+B9tGmnsxansPvzLyIMVM3tbGm63q2nr5j1JATqQ=;
 b=mxfD57op5tqjRceGiGP9cUoAEb4PnU55y9uxjWCto5l73LyP70PkfOR9IOxG55pkembrgEmXe1jmRLokm+Ijphi/k75n28n0RLvxwrxfG75PsiqjXQig6rl6qQsCp1CWoMuAlN6DubKcRTHMb1VRjQJnhC0ymQehiSnBNhBbHBw=
Received: from DM5PR07CA0069.namprd07.prod.outlook.com (2603:10b6:4:ad::34) by
 CY5PR12MB6408.namprd12.prod.outlook.com (2603:10b6:930:3b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8314.17; Mon, 6 Jan 2025 12:47:44 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:4:ad:cafe::e6) by DM5PR07CA0069.outlook.office365.com
 (2603:10b6:4:ad::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Mon,
 6 Jan 2025 12:47:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Mon, 6 Jan 2025 12:47:44 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 6 Jan
 2025 06:47:38 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>
CC: <kvm@vger.kernel.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <pgonda@google.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <nikunj@amd.com>, <francescolavra.fl@gmail.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>, Juergen Gross
	<jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v16 11/13] x86/tsc: Upgrade TSC clocksource rating for guests
Date: Mon, 6 Jan 2025 18:16:31 +0530
Message-ID: <20250106124633.1418972-12-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250106124633.1418972-1-nikunj@amd.com>
References: <20250106124633.1418972-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|CY5PR12MB6408:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ce75f8e-e942-4dcd-eb1d-08dd2e5050d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iAp1yU+TcoB2kpOojp9Az6SQTNUf0yEvWWxz3wy1LJB641Dxgo86vVNPSCAz?=
 =?us-ascii?Q?dhaSEmPgjfgOQlMUAOkpkGRmycgkk3Ax1g82zFHYGVbcN8wTigFFoZQXfN1K?=
 =?us-ascii?Q?PsgtU2pNa7Lukq8OTUlFOC9qnvpYqyq53AE0vf8ZtJ8GhBiud4woIxudM+5f?=
 =?us-ascii?Q?lliVfKOT3XD9+HB4phOdnRQsm6JPqtoFoZvpjFLHQvzyucQcNfHfMs10coSl?=
 =?us-ascii?Q?EiN7ShfxWTZxh2xL8EUlvLjOR7syBcPKM13BIXPTKcFA5oECNdxyn1lBiAiI?=
 =?us-ascii?Q?oPdb6zTzwHKTckht07Se/d8VRGx4cSWfLspXfMVJV31CBPmptFO8tNHlZCk2?=
 =?us-ascii?Q?5SYokRhraDMqJ9AXFMzmoHK5Vwv3m8q+Vz+DKdeJLjPUPE+2eQR/9nNECY5W?=
 =?us-ascii?Q?r7masAK+/DSecc/OaAUMvd8/0zd97ymTheI3ZNsDnirwgddQ96XzUTPP9iZ/?=
 =?us-ascii?Q?fJGu1anfHmtVTiX8oPZ+wUX1O/JuIvd2LjLTrum+1RwCWSIBGtv2mG8+ELCw?=
 =?us-ascii?Q?vi4zru/gY0vnAARdDtewFF9fX9t8Wx8JxuZAXFtlU1lcScVqVde2rTtkKOdL?=
 =?us-ascii?Q?n7UtxVTCr9ipe1aMtIVUxptIdLHjxeyuSJQhZSF/9Q9qPbetQRXQGud54Mhc?=
 =?us-ascii?Q?sJQJ1UmgefFZfS/734cE+urYOKLiwYGVye4Q8b7fbqoijiJoJUSqVGff1Ga4?=
 =?us-ascii?Q?mLRnzsH4wzztLFPbtlA/EpjzVzwaSkkK17nwQQaaokSDawkmdC7i1D3QauPj?=
 =?us-ascii?Q?wQZaRv5IdsA+LkzD74lfY4bO5BwIlVCN1E3HA0snCMcPrlBG1op4z5KWVqAz?=
 =?us-ascii?Q?+v0/RE4kORipOBmQt61wiTaOe+I8niULUSDGwVJONqujZk0ep51HR88TmZvC?=
 =?us-ascii?Q?XEgrVjQU5c4sGmcZbJc7L/Jf3znmDhlQJjcTn1ke+f7iqHRF5Jp6XcON9p7T?=
 =?us-ascii?Q?gOpcsVCqySNJDfdOc5qPtwPiVMETMsE2Ly9IKrt0/0gRw9sUXWgIb5e/sRpC?=
 =?us-ascii?Q?r/tMsZa3ogqKuZWSetPhXDETDsJO4oWuFE3pmYzi+Bw0IMpj+bJ9H1OsrDpb?=
 =?us-ascii?Q?V6EH9Yt4eJqxWMaGbfB99wNZHXSk3hGqvna5smhJ3/KAKSZUnBDfn0f2kOpp?=
 =?us-ascii?Q?1gHNwwk6qqboN3ilSS8MBnvleZV9BGCo7OR5PpD1ubhCwom0l2lBxJImX/Aq?=
 =?us-ascii?Q?14eNfoxTMxuNXfte1am1GsdL9JiUZfuMqfRNAv58lqVURdhTrDG78wFtGkua?=
 =?us-ascii?Q?MDzmrWc5JbTGZKcNpDvw3RnUI5PgXENqxIM7DUb40LhhK6EGzvsvY0Dyzc/n?=
 =?us-ascii?Q?PLOSaMJ01JHyMw87cvf7dyyBV1b3ylixuL9b08/bpMnO71gPzITy4kRoLI4D?=
 =?us-ascii?Q?xr1bW6NBE0rFeYoF1xu6z8pqNdXWddNw6XXuHMNTTVD7wNuFVb7ANGRc03Q+?=
 =?us-ascii?Q?V2OXkuAYfLtX/IceOnceF3gYxyDqTzjqT0aeXKG/H/L0BViDiUio9Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:47:44.3283
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ce75f8e-e942-4dcd-eb1d-08dd2e5050d6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6408

Hypervisor platform setup (x86_hyper_init::init_platform) routines register
their own PV clock sources (KVM, HyperV, and Xen) at different clock
ratings, resulting in PV clocksource being selected even when a stable TSC
clocksource is available. Upgrade the clock rating of the TSC early and
regular clocksource to prefer TSC over PV clock sources when TSC is
invariant, non-stop, and stable

Cc: Alexey Makhalov <alexey.makhalov@broadcom.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/tsc.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 34dec0b72ea8..88d8bfceea04 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -274,10 +274,29 @@ bool using_native_sched_clock(void)
 {
 	return static_call_query(pv_sched_clock) == native_sched_clock;
 }
+
+/*
+ * Upgrade the clock rating for TSC early and regular clocksource when the
+ * underlying platform provides non-stop, invariant, and stable TSC. TSC
+ * early/regular clocksource will be preferred over other PV clock sources.
+ */
+static void __init upgrade_clock_rating(struct clocksource *tsc_early,
+					struct clocksource *tsc)
+{
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR) &&
+	    cpu_feature_enabled(X86_FEATURE_CONSTANT_TSC) &&
+	    cpu_feature_enabled(X86_FEATURE_NONSTOP_TSC) &&
+	    !tsc_unstable) {
+		tsc_early->rating = 449;
+		tsc->rating = 450;
+	}
+}
 #else
 u64 sched_clock_noinstr(void) __attribute__((alias("native_sched_clock")));
 
 bool using_native_sched_clock(void) { return true; }
+
+static void __init upgrade_clock_rating(struct clocksource *tsc_early, struct clocksource *tsc) { }
 #endif
 
 notrace u64 sched_clock(void)
@@ -1564,6 +1583,8 @@ void __init tsc_init(void)
 	if (tsc_clocksource_reliable || no_tsc_watchdog)
 		tsc_disable_clocksource_watchdog();
 
+	upgrade_clock_rating(&clocksource_tsc_early, &clocksource_tsc);
+
 	clocksource_register_khz(&clocksource_tsc_early, tsc_khz);
 	detect_art();
 }
-- 
2.34.1


