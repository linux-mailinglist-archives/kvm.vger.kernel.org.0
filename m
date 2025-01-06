Return-Path: <kvm+bounces-34598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07FD1A025FC
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:51:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B42233A59C4
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:50:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4DE1DF97F;
	Mon,  6 Jan 2025 12:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XpACFrIq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802521DF737;
	Mon,  6 Jan 2025 12:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167677; cv=fail; b=oGT6F8g3JuNSopYdQIFsYl9V8m/wyFpJUPxLZtLoqKmq1x+xoTSXONshzNF3QGrakQJygizhqNmixd0Me4TWeZwZ/jO4nIUmWfwZdz5LY7UB45x+R9u1iD/D2eORP60j1KIyDB9TCNKBFRcsNm/oHy6FZtd3+txN7io44zWdkaI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167677; c=relaxed/simple;
	bh=rfwLFXSxAks3mBuumk9So9/kwBkSoaxEgUOqP0q/Sl4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ClO1LPkShs05FT2oL5Nn+P4MSUlevManLyB7TqBgIEMNYKygZqD7vWNwxp1nMms/ru8ZpaN1KN1jgIgXHAYRx9dzdLM+W6C5uPW8FAlIc9Sj874OCaE0Az9uURfTCByx8MT7rGmo7Axr2XjYawo0ltdDEnic5oWx2YwCuJVw6GI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XpACFrIq; arc=fail smtp.client-ip=40.107.220.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wgtpbMxH7ROMdwXu220RqCk1zv6hhaaAALOYkCl9ecJsB8EJ/0fJvPx5VQded9WmKzetJdPqeK+19qz+eLLMzxb22Eu4FaOMLV2vcrluns/1B+a+zg/15mHXT8ieHTEjpiX6vXHZi4tOqZbPLSpUh0NB95r9rEf/EEi6Q24zF/LojpScMlx2oAkyiPNwyDedUoxX7gAGaGOs420w+INcbH0MrT1TA7pmUtixaJDv7UOAVo8203t+31iTkowBgtjKrKbcLT0+YzWCfQ3LXyCpLXrvIpt0z14OcYUjfFBLc04wYwAxeAukosFvOgfIq927xZVZKxMokT8qYmHYzICr9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0gXkxfMwYtmdZNyZQPON4xBjcGWk27qC1ATBlY0Mlc=;
 b=rpb6cd402OZ95U4FF5+CWJrLafSOo7jAM/oyVjsquuR5kTEU4B8T4lm+XukKYsYH9tW8FkQseZV5gOahfpuLge1AlveCTeemQ9QBCARDYPkyCACeitGfQSVyNFeDvg6sZdgLcD7MX1Az4/4dTmAsuQUupjfj1tR7ZeSMdEwYvfy26zx883hfibIrHGORgO4iX6ChNklKa7xoOQ5PoOHK2BVTJLR+B/A5QCGB5V5u6R2/ChPqlLsAAjRYOeyFnfT6iWwk5ww2EZv14ahPrNs70TkTfGT7tEE5mTA7oIkATqUjoKtYVq+y1bKFCQwTTK93DfJy+W78hgDqWgkY78epNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0gXkxfMwYtmdZNyZQPON4xBjcGWk27qC1ATBlY0Mlc=;
 b=XpACFrIqpAaEmnDlcgkzW8JyD/lBWIGEvzBMCb1zEhf8AMInLS66TzGPUUbHCakLZ47EpE0WhYm4PoZT6GshVtoTc41AfH6GBsvfKFe924xT6bHIqNjEAFs2IBqVfnl+wZ1tspFYVVBf6Jx4m+KIS+op3zU2jewQMw6FkTOzVv4=
Received: from PH7P221CA0004.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::14)
 by CYYPR12MB8869.namprd12.prod.outlook.com (2603:10b6:930:bf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 12:47:49 +0000
Received: from CY4PEPF0000EDD2.namprd03.prod.outlook.com
 (2603:10b6:510:32a:cafe::d5) by PH7P221CA0004.outlook.office365.com
 (2603:10b6:510:32a::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Mon,
 6 Jan 2025 12:47:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD2.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Mon, 6 Jan 2025 12:47:48 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 6 Jan
 2025 06:47:43 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>
CC: <kvm@vger.kernel.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <pgonda@google.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <nikunj@amd.com>, <francescolavra.fl@gmail.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>, Juergen Gross
	<jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH v16 12/13] x86/tsc: Switch to native sched clock
Date: Mon, 6 Jan 2025 18:16:32 +0530
Message-ID: <20250106124633.1418972-13-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD2:EE_|CYYPR12MB8869:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b5cc946-52a9-4804-e3b7-08dd2e505335
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3LO4QOoakH9x/eNoKoVoO9CJUIwksBQGOQVrv8iTaesRAili77+3fUbOq1wK?=
 =?us-ascii?Q?qRg9DBB0WynyS7FLXNQ5UIRwqzvgp3sKalnNLpfPo/+fxt8CFAbc2M9JD/Yx?=
 =?us-ascii?Q?Bhd5Kfdr71LVN11uwj/a/MKgzfvvV0A564YYDOopnY0kIfOgac6t+J73mQKD?=
 =?us-ascii?Q?g1qBOn7frKhUT1pYee7hxJQKAulIwhzq2RVHys3XoedTQ3G1g0GbXC1XeQgn?=
 =?us-ascii?Q?QZ56+OExXRv1n+TlKsQHShahT+IP4aYLmxB2HTxEt1MtbsApLTSKr8HV0bme?=
 =?us-ascii?Q?KQFR2pOyUzNCi4TnPywNtXMR0vDSy0HV/QsL4WNOXyEL0NDrJFAqJZaqtSO/?=
 =?us-ascii?Q?b2+GnEx8SKyvl+KbjO3D2Sip7yz0EVbc0w0VdnSKfVAlXyv35DiWneFDkj9C?=
 =?us-ascii?Q?uXKzE2WA4aZKIUl6/RtANQy+hueZNiod/g4VYpMIyjhAg0xa0gV/1JVT/Qzr?=
 =?us-ascii?Q?Yvpm8nBsHB+OpvrqF0+h0vOyYeUH0/gj1S2eItj7gcEv0cuqK6fluYjMFcHY?=
 =?us-ascii?Q?r/oroI4XEwkpk5eihQpQxottBvSdfXg4fTlQj+IirhUMnSYDXR+zcDE0OPZG?=
 =?us-ascii?Q?7xCZx86TA7W2DjjR84Y+twEl3rHWCUK4jp3CDztDV9UNCzK7bQCOEatoaZFZ?=
 =?us-ascii?Q?febLExx82QjuHAxEffiBGduz0zVGHOuHa6IaGRCKzJVDFzviOWG30Q/MbGA2?=
 =?us-ascii?Q?qmek9T3MMHnOtoWMTKNrj3GRmYwAyB3pbiaKg4ZUIT1WrM+CFOFIFKKazw+R?=
 =?us-ascii?Q?uZsm2nyTKPzeu8sUV3iK9N6UbY9Vb+Hwc6lqdZPHDCY7UqfWqS9kmRFMjfU8?=
 =?us-ascii?Q?bqmFj5cB4K3zWga8mKRq/r/fTJVTdeN4YJoXNfV2glXDDQpuaIU9Ienlq+Qk?=
 =?us-ascii?Q?DoumCOjLa5bYAGwTSlUS+qAUgWQgnLR0h3tJtI6So78RAT8p7QH2snQzhi65?=
 =?us-ascii?Q?qIQ+TO4UIBiNolPtsWOnLnACXRs7NehleRE5fENHSZGEyWtf75VWAl8AclIY?=
 =?us-ascii?Q?Y2zQxi/S/QeUNKvaUbYBQnEj9kVGJOU/aQUghkdp5adownS5v+Z1DW9ZDe4w?=
 =?us-ascii?Q?1RSza/mmN36X0S+HFXFPMvf+th4TW+cXum3E2/h7T3NebhDVfWP8DoJe1g0n?=
 =?us-ascii?Q?0Mx2NUaJnvNDoH2Mnox5cvbw189fGtfzRUiRXgX/Yznir5+JaTzP8efVdieZ?=
 =?us-ascii?Q?sa3AzPZFUSeBPOHIX9AMLTOuAoVYrjgqTxgsI4ZLe8vQmDAsSxXoMkYDi1bb?=
 =?us-ascii?Q?UBJ3kpufE9w9xVGV9EFjq76hiOI639I+uzYMEYM0KeU38xoQ2Y1H8wSY6tCr?=
 =?us-ascii?Q?WK/Hh+uu73Eht4yjNNzmCtq9s4K8wrBiCecttL4oC3k2hwm4/HvjDYIdeI6d?=
 =?us-ascii?Q?2pGyivzYiz969EKlVy1U7j63eF3Hpt9mH28xL34+H1cV2P5XKCsdiSpLUN9i?=
 =?us-ascii?Q?MyvRAu4/3mof9n1jetW8QHnUbtZ1wkkZQnijzaJe8TA/XGx6B6WiWgxZb7Dj?=
 =?us-ascii?Q?rKEMdC2lCTX/1dI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:47:48.3061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b5cc946-52a9-4804-e3b7-08dd2e505335
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8869

Although the kernel switches over to stable TSC clocksource instead of
PV clocksource, the scheduler still keeps on using PV clocks as the
sched clock source. This is because KVM, Xen and VMWare, switch the
paravirt sched clock handler in their init routines. HyperV is the
only PV clock source that checks if the platform provides an invariant
TSC and does not switch to PV sched clock.

When switching back to stable TSC, restore the scheduler clock to
native_sched_clock().

As the clock selection happens in the stop machine context, schedule
delayed work to update the static_call()

Cc: Alexey Makhalov <alexey.makhalov@broadcom.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/tsc.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 88d8bfceea04..fe7a0b1b7cfd 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -291,12 +291,26 @@ static void __init upgrade_clock_rating(struct clocksource *tsc_early,
 		tsc->rating = 450;
 	}
 }
+
+static void enable_native_sc_work(struct work_struct *work)
+{
+	pr_info("Using native sched clock\n");
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
 
 static void __init upgrade_clock_rating(struct clocksource *tsc_early, struct clocksource *tsc) { }
+static void enable_native_sched_clock(void) { }
 #endif
 
 notrace u64 sched_clock(void)
@@ -1176,6 +1190,10 @@ static void tsc_cs_tick_stable(struct clocksource *cs)
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


