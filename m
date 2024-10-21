Return-Path: <kvm+bounces-29237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C5B29A5A12
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 08:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C55ED1F220E6
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 06:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D44DD1D0B8C;
	Mon, 21 Oct 2024 05:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pQLaltzV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2047.outbound.protection.outlook.com [40.107.212.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC8C26296;
	Mon, 21 Oct 2024 05:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729490381; cv=fail; b=axIG7HFA21VyIDrh0zxQ/Asz16vFUepwbUpukQIR7E1PFdyODltSr578fnNnbdUfOzWpUFhWDSU4aUBmsKVfaTL/oTnQq0fwT7b+UcZcKi9OgdutkysBbMNF/7gQkmqQ9MTALD4U0L+ILPe78Ubts8biWTnePtGLCQy28iehRvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729490381; c=relaxed/simple;
	bh=V4KyIGiXLsSt5rp0pras/n1yuoyPfbjxB91aViF42DU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V7iwAH5Rf781LcNvIdsV5gILxo3LlzZUvr+SL9k3Al4VPTPYX5OyiMjyHzBxeCW5lkIb6zlGXztyeL5Kglcmqd9pr2rsRA1GS84ZDHYCBI3BDACWWgb0d3tZUlebagGdp1z0siUsx5A4gXuaNkBIugcIMh/cH5IrmhFLocqq1zM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pQLaltzV; arc=fail smtp.client-ip=40.107.212.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k0E1x16O0N7oFBIwdwwe2/ieRuYnAnIaG01bUtg5m5prG/ev22BYgY/e/s4HAxyaqqcIBdkFBFLlYv9XkHp+eIuhv6MQx1o7Qmp42G28BXzAi3wjp9DVNKwY6tBVs1Je/21YDx/C1TPR6bukpdKSIFYBg9lOcEFEKQ4MHzKlWUzGRZ2WfnHLxq18FqJfK8t54atYbQRT1qTNNSPQyvRsNzi5zYbL4QUi04a7VKgwCOkR8YZzdl9GtBT5rJrUOfiHIj1aJOMSraY16o8YphaRRTNJW7YB5YlLGmKWn9BOGDSwBSTImc3Dc3QzcLzjffbIR+GJzBBW2l5vVuDEL3fUSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y5hTOszLnzdUX3QyH7+2TnFYfdi0tPk+yHKMIbpkn+w=;
 b=e/QfOhB8NX3N4NnMONUDOX/ZAb0Z6nqfyTSNlORDlJZ6zCJ21yWdJ6/XkBfyBzkcBDikNDmGVDEUaH5X4WbpKYWjoaBF74hgW6VRm2aoSa+jRuEuRjtM8lrRNzTbWZtpf38zXmRCNpyC9gkDR1543V6JrDurtbJB/aJttCemYvnz5T4SdFmyirQlhENWRyP3oHL43dFFElnef3rI0bQA3cya48XSq8MD2Q8pXS6zlS+FQg7QAruD4uHY4moQg+fkYMioDwocSBortgSPSOg0GLPUDujNrU22aLUyP3nth5Twg+XNZCE/DlopqQG6zmv5wRd9Z1jNpB1V7OeeKtNG3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5hTOszLnzdUX3QyH7+2TnFYfdi0tPk+yHKMIbpkn+w=;
 b=pQLaltzVElQSd//mArg/IIYSiKAr69sqPX/u2Rv5BUGrxWDPDFbi02Vvch8EAnYfavT88OzB+8i32ltgrXFV1AGEsZ0Jm5QbVLI4B/Ld7baXhApaP/JrdVfpfs+wxjl99FEYqAbN2s93xMDC2QV82Gtaa6dWGprWqh4hXZhlCZY=
Received: from SJ0PR05CA0209.namprd05.prod.outlook.com (2603:10b6:a03:330::34)
 by SJ2PR12MB8033.namprd12.prod.outlook.com (2603:10b6:a03:4c7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 05:59:35 +0000
Received: from SJ5PEPF000001D2.namprd05.prod.outlook.com
 (2603:10b6:a03:330:cafe::96) by SJ0PR05CA0209.outlook.office365.com
 (2603:10b6:a03:330::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.10 via Frontend
 Transport; Mon, 21 Oct 2024 05:59:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D2.mail.protection.outlook.com (10.167.242.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8093.14 via Frontend Transport; Mon, 21 Oct 2024 05:59:35 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Oct
 2024 00:58:10 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>, Alexey Makhalov <alexey.makhalov@broadcom.com>, "Juergen
 Gross" <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v13 11/13] tsc: Switch to native sched clock
Date: Mon, 21 Oct 2024 11:21:54 +0530
Message-ID: <20241021055156.2342564-12-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D2:EE_|SJ2PR12MB8033:EE_
X-MS-Office365-Filtering-Correlation-Id: acbc184f-1b30-4129-392a-08dcf1958a8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1KyArbATalfD04ZvsqGy0F1U7N7L0dYY2WsiusUW7Qu+h4ji4nRzXuOoX7PV?=
 =?us-ascii?Q?N+ydI2PnwPzx5c89IWQou5ENY3jjoy9PrpbRyhKGeY5/i5k/DhTK4rAqVFdv?=
 =?us-ascii?Q?dRaXUiRLxWd4TAJpTpEBL0Oc/ZxvHUw1zhl7kQyZhIZlFYK9aP/2mHPTWkWk?=
 =?us-ascii?Q?Bz69Nf/u2yx2FTwoUlRVFNqIWbVj6oPs4VyVxLBjhrhzgm2Z8NMeHX/dxFah?=
 =?us-ascii?Q?2u/v65Ac0xMGa9ZwvhncoyC3EkTiH6PDT671b4uYhiAWGkwSMu9ilGLWY07V?=
 =?us-ascii?Q?UZGCQRVezY/Ikhko8X45JStUoTNNrcswdW2u3qXNdsZf2lwwn4H3eOzHYupK?=
 =?us-ascii?Q?R1sYmr+b2lSSQNvlDjb5bArgFJq6nfTBArB3yxojatUlJlFGFKHC+6zUdHDZ?=
 =?us-ascii?Q?Blj31k9JSfOaDbE+0J2TdNek5q9L+xuy1IvFiPi75QiclKlk0P59p1uDXtll?=
 =?us-ascii?Q?Up4ksgVdQW+RhLvd11q9dVv2XQWG/5fmQT2rt5/XMfJ4rvIVCkccoBZ6c5/S?=
 =?us-ascii?Q?EVdtQIJE1cBLq4LNjd5aaFQfKLokxTVIV4XI8DwvMqhSzywtABNaGFe0Vt6U?=
 =?us-ascii?Q?77BnaAWz7BUWo1Bfxsg15OXOPWU1UNGKxnxeJcdu1fgM/99NhdNNr0KpQYfs?=
 =?us-ascii?Q?C61/LQfHWUhv2NsNy/BE0XQqlofcJCUpBFgk3ywgXQw7UZxsfFM7ZlLaR4y/?=
 =?us-ascii?Q?af5dWdbipvIiWPZNu8xT63aw0AiabdtUpYxXyYf30RApd4bTk+ZgRcgNubgF?=
 =?us-ascii?Q?TljuW7Le24pd3XQFilLq9UoPI+egwjq9iZ7Kop0GQrb1VCzaI7f61K+Hyww/?=
 =?us-ascii?Q?5xlwR+rTUuEO3aPOF30rXrX3qqdI7ug8+cdVoGTwwHNxMlPwKfRFsCVCvlw2?=
 =?us-ascii?Q?d/84s91h3It3jzuK4d5gkHgTgmixeZiu0agXH/PEwnutOdAbCseWbBgSF5a2?=
 =?us-ascii?Q?Aw5LON2OWsHH+kYHf+ZmHwz6ldq6hOzh15s2dyjKkW3ZE2QGdUys4ENeLeX0?=
 =?us-ascii?Q?TxS5LWU/HX1aOoffV+rHzHWe5FXu3SULvrBYFzqIzaeWE95EnT3IcV1OFmnL?=
 =?us-ascii?Q?SEW315oQ3DcLUkp96D+AI3JmbYumOwEYhVt3uiSybunQEts5T2ybeECpW1Dp?=
 =?us-ascii?Q?6xpTM/P/bjJrdDybw0td0O2jbW2Sd91g4+6EJo5SBvRuLgsGOTQEFTe1AMnq?=
 =?us-ascii?Q?DKnlV4FxNQlzTkUcFWtIVSpbY/GW7bjK2yUg12RYAeob7oVWfx3U3iW8hftP?=
 =?us-ascii?Q?EQGKuMVYCnKnAf9/7PW5a8h+9bauI4T8amLKkur8kuF+R7RfN3AZAfesAls+?=
 =?us-ascii?Q?7QHbvqeJFpDKt/WTcaYR/GeX4g4n6g4WAwtQZC2+ZAo7+cHsyuZWWhfjHGKU?=
 =?us-ascii?Q?kO2pEvBr2tYoOcvyLhnCJpL1jRIOVlF3LsK7g1qKmhg19M91Vw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 05:59:35.5097
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acbc184f-1b30-4129-392a-08dcf1958a8a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8033

Although the kernel switches over to stable TSC clocksource instead of PV
clocksource, the scheduler still keeps on using PV clocks as the sched
clock source. This is because the following KVM, Xen and VMWare, switches
the paravirt sched clock handler in their init routines. The HyperV is the
only PV clock source that checks if the platform provides invariant TSC and
does not switch to PV sched clock.

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
index 27faf121fb78..38e35cac6c42 100644
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
+void enable_native_sched_clock(void) { }
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


