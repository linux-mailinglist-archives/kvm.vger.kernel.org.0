Return-Path: <kvm+bounces-54402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE38BB20475
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:52:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5A6116CDC8
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FF77239E82;
	Mon, 11 Aug 2025 09:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cype904B"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2041.outbound.protection.outlook.com [40.107.102.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D5C25B1CE;
	Mon, 11 Aug 2025 09:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905812; cv=fail; b=UCNRXYnyucKfBjf3PPhcESUjGxrmIkJcOUe1lj28C0vDD/QuiiFZL6MgSMD5DHfTpPDO/6ko+T6vX/XtnFCiR5gvs0yPtlBGtI9Z5bZirp/AkJR5MR24Z0VFGFDxHrcj+BIykQrv1XQqH3YwmX55t9jCO7KAIMEVrREA9GI6WcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905812; c=relaxed/simple;
	bh=V8yZZU+TRt0UYHDKlxlELiS0yreBExXqDIB5nLXWVs8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xicghip+6MKTdGaIAPy8iSL1Y1gf4CzYtoy/t6nwWF7Rvy8yj96UAiG/z1px7oxEjIlffnb5BN1UCJNTCKH+ia5ZSCwd4agoe4qdxyaHalUih1h/pF0Xa8kV8lyur+5iATfGa8U63bq0w/skxIr6K3IgHNdJqp9mRUjuVk5ns1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cype904B; arc=fail smtp.client-ip=40.107.102.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bKZ4JtBeShgQcX5AteafDdTd1eFwnCFW+1mE+9x13gr/X37zzPhxwV7H3XvsdrwpxNLEn0N43K08vD5G73KFfHPpLMPM5mhTm2UlDI5+cPoRW8VyKj8K2BSHcburRpV068uQkIsgBNZoO90HaYzux4nl0NrB2r7//ab6Sfd7ycERoZ5o2yPHVXzLLVegwaGSIU54t70DNLZWj/jdCbx+E5DxHy7RiPzpXqowqP7zsGwkb7UeiEA0ZEgdyty9cC5XFTygZfj6fTbENT9ha17bma1mUAFRdvxSPXfZkRTUjGLLhBhlBJ1eMIUeCJoBAPIeGSsSM7Rf5EiOQVchaQAp/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WbNtqqaRvXss1/okZ+oM+FcMUd4/3gyjv9xCbSUt13k=;
 b=Agz1gNxn2sNlLQoWLqTM3Uasj7mDE6eyQ79Ykxb67BUFb0IOQaiPFT6UWtmjHUquoZzu6fV8xqy4Pa4Vhlo7tdfvCyP5NQhF9f49RL1YI7hUc64lgw7MdW3xdb9yl8lTR6EGr1uyzsEaZ+XbqEa1oZba7+CHNvt4Slc8w9GsVh/8IUVAxtMELNGIH/8jU9Bge+BrSDVdm8JmHd/6pKdzNo6gWw+PL2jyvANkPSzsgWf/Zt20vIjMWYxiOZnmP5PRTvtdljHyBHlEHW1/p+4g4yuEHPyVjGQz2s6fmf1Ie/G/L/blZUohvyRtwxkLJCrjIfzRkeodwzii4MUe33hSVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WbNtqqaRvXss1/okZ+oM+FcMUd4/3gyjv9xCbSUt13k=;
 b=cype904Bamo33g8LXbnHzjWOWlQfY287xUAriMgWSFcvmidLvmUC0WIowZPjz9FHDAyiS1ErM4LE6+jI1ZlS791sOHXr4VPnmRpBL95q63txmsSQ8fFUD5iy3nAxdo4mSuJjsCCB4KO6nl727Gm24n5UDao+A9M/YikKCsSFJAg=
Received: from BYAPR02CA0002.namprd02.prod.outlook.com (2603:10b6:a02:ee::15)
 by BL1PR12MB5779.namprd12.prod.outlook.com (2603:10b6:208:392::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Mon, 11 Aug
 2025 09:50:05 +0000
Received: from SJ1PEPF000023D0.namprd02.prod.outlook.com
 (2603:10b6:a02:ee:cafe::63) by BYAPR02CA0002.outlook.office365.com
 (2603:10b6:a02:ee::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.22 via Frontend Transport; Mon,
 11 Aug 2025 09:50:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D0.mail.protection.outlook.com (10.167.244.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:50:04 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:49:54 -0500
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
Subject: [PATCH v9 14/18] x86/apic: Handle EOI writes for Secure AVIC guests
Date: Mon, 11 Aug 2025 15:14:40 +0530
Message-ID: <20250811094444.203161-15-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D0:EE_|BL1PR12MB5779:EE_
X-MS-Office365-Filtering-Correlation-Id: e4f35737-7250-40a8-dedd-08ddd8bc72c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QY9mezXOhyKN9KnKPjNjvl94lh0SjwQvZwe6v+RILjq1jRJT8XKgMh0HVxbC?=
 =?us-ascii?Q?J+qYEmPGNuEkhIox5ZNvKCR2LawX/0qj4K7ZA3m3h3pfe6+Kt1B69Hm6EMcl?=
 =?us-ascii?Q?Ej0G8BQodNijwI0oQk9bMXdxbxnyoxs7JiAu6V5ng6u6v3mej8HNu58D8Wnn?=
 =?us-ascii?Q?mQ6vMGrb9IkQgO4R9Wt1SMd+slIMvdos70KYv24K3l8p8ug670LQVSW/Pg8z?=
 =?us-ascii?Q?k4bK9zBmf6WLBYZLTTNpV4kp0oAZQsBQOERF6QP8oQcfNk63/WsGjVGEQMro?=
 =?us-ascii?Q?qC5Uu4C6gmNWlFDkQQ6YZ5p4MabkjHro08ySJ0/hTijWD4yZMUtOm6t25q1j?=
 =?us-ascii?Q?/FDqg7HRySfHFj36CiiWs7wsAllNSRupa9uwqH8+4Xiw7JCJH+0IjmbyEt78?=
 =?us-ascii?Q?9D9MYZHKaZmN78PYWZsgdP79ALsKV5KMizz9s5LALNRJOzeEh7QGAuFGrh4e?=
 =?us-ascii?Q?8Ts+YQI7h9+dZbq57D7ecniz44c8pHUst9eAwm1GuM3IzdOdE0DO2ZAz3ixG?=
 =?us-ascii?Q?+9xfZNYXtICZw3Vo5RN95r8VMe97RxmBmwgULZHQ9Jkq5c85vFJMgoGAElyO?=
 =?us-ascii?Q?Zu7VyMKB8cuo2TnV5aFKwjemPFzOyS3itOm4IN9uPBPfmq1iM8bHarNSyq+B?=
 =?us-ascii?Q?ufcc2BH635Dc8ahsWhqR799YNL2FBgdUym9+ENHL4r0+WaPGl7AzdgBAG8tL?=
 =?us-ascii?Q?eM6QngZea2W3txrhHLv5MCdBaYCkofHJwMFpj7iQgXiq1FQ7s8EXVLW2GgXO?=
 =?us-ascii?Q?O4vEJiquT9Boe7bepgJbQXiAjcTM54p/4SLgvAgU9fAca6fmYiLtiMZEhFGU?=
 =?us-ascii?Q?vspMaZSxIq0u0KNFOB6heIHqgGiZnbCNG5mYs8706zksRCaQga6kNAPIAa9l?=
 =?us-ascii?Q?tp1Ud0FNICmsnJ6MHkKwRHyIlNMBUtlbG/pjrxpsx70/k5GFmj+n2nWLhuVq?=
 =?us-ascii?Q?ABubpi2VLeHBN201EKA65p0lEBLov3QICpW1NlO6I1i73Wvhn0a9EhDPN389?=
 =?us-ascii?Q?BM/YSLq7iOL6oPyy74jCaO0/jacUfyNR6GWqAMJJSZe2m6m+pX32IXK4J9J0?=
 =?us-ascii?Q?ad6KZMsnzVBdM+g4z+5FspBiNli+0n9tf6+28Z6Lt9P1c7yDPU4svHD9pdf2?=
 =?us-ascii?Q?l7NUIpAo5eC/yozm9oCMtZKW0lNtALW9d5y9Z/nM7x5djWwzeekQR6dcG17C?=
 =?us-ascii?Q?nAPdPwv7k2dZX2VQUsgbZaWK/TLHYq4JJEFOd/LjfiMmaCbwfOOuemKV52vx?=
 =?us-ascii?Q?RHkOVLyZzo+4mdaeGKnRUIl6P9p21IFbsXGektsGtP3piwAD4gSC59F6BhNa?=
 =?us-ascii?Q?OGYk+GiA+B97zrZMPFX1232VAR30eKkPzXcMwmvvupr0u3sfXR2e4YqvjZxq?=
 =?us-ascii?Q?CgFsM8IQK36kDxma4LJmH3JEhFS51/Sz3s8TxWWzTuUpBqIeOr0ATY3+QJTI?=
 =?us-ascii?Q?MHUFeGVdEdIzQlIAvZtOq0qiWkK2I3cyN5xq1KWoYl/tFK77VIMa9UQN3NvQ?=
 =?us-ascii?Q?HGGHFmNc6zG899k9U8829NSyw51Zt3oHuJqu?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:50:04.6224
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4f35737-7250-40a8-dedd-08ddd8bc72c6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5779

Secure AVIC accelerates guest's EOI msr writes for edge-triggered
interrupts.

For level-triggered interrupts, EOI msr writes trigger VC exception
with SVM_EXIT_AVIC_UNACCELERATED_ACCESS error code. To complete EOI
handling, the VC exception handler would need to trigger a GHCB protocol
MSR write event to notify the hypervisor about completion of the
level-triggered interrupt. Hypervisor notification is required for
cases like emulated IOAPIC, to complete and clear interrupt in the
IOAPIC's interrupt state.

However, VC exception handling adds extra performance overhead for
APIC register writes. In addition, for Secure AVIC, some unaccelerated
APIC register msr writes are trapped, whereas others are faulted. This
results in additional complexity in VC exception handling for unacclerated
APIC msr accesses. So, directly do a GHCB protocol based APIC EOI msr write
from apic->eoi() callback for level-triggered interrupts.

Use wrmsr for edge-triggered interrupts, so that hardware re-evaluates
any pending interrupt which can be delivered to guest vCPU. For level-
triggered interrupts, re-evaluation happens on return from VMGEXIT
corresponding to the GHCB event for APIC EOI msr write.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:
 - Added Tianyu's Reviewed-by.
 - Refactored savic_eoi based on Sean's feedback.

 arch/x86/kernel/apic/x2apic_savic.c | 31 ++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 6012c83cbf09..bef77283dd43 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -297,6 +297,35 @@ static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
 	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
 }
 
+static void savic_eoi(void)
+{
+	unsigned int cpu;
+	int vec;
+
+	cpu = raw_smp_processor_id();
+	vec = apic_find_highest_vector(get_reg_bitmap(cpu, APIC_ISR));
+	if (WARN_ONCE(vec == -1, "EOI write while no active interrupt in APIC_ISR"))
+		return;
+
+	/* Is level-triggered interrupt? */
+	if (apic_test_vector(vec, get_reg_bitmap(cpu, APIC_TMR))) {
+		update_vector(cpu, APIC_ISR, vec, false);
+		/*
+		 * Propagate the EOI write to hv for level-triggered interrupts.
+		 * Return to guest from GHCB protocol event takes care of
+		 * re-evaluating interrupt state.
+		 */
+		savic_ghcb_msr_write(APIC_EOI, 0);
+	} else {
+		/*
+		 * Hardware clears APIC_ISR and re-evaluates the interrupt state
+		 * to determine if there is any pending interrupt which can be
+		 * delivered to CPU.
+		 */
+		native_apic_msr_eoi();
+	}
+}
+
 static void savic_setup(void)
 {
 	void *ap = this_cpu_ptr(secure_avic_page);
@@ -375,7 +404,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.read				= savic_read,
 	.write				= savic_write,
-	.eoi				= native_apic_msr_eoi,
+	.eoi				= savic_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= savic_icr_write,
 
-- 
2.34.1


