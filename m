Return-Path: <kvm+bounces-46457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D63AB6464
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:31:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AAC881899B6D
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E910D216386;
	Wed, 14 May 2025 07:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cHmZ6ljy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A663205501;
	Wed, 14 May 2025 07:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207794; cv=fail; b=stEhC2q35N62l/Br5IzQi92qKP5P5idqjZI4cYShRFYqYlaEcb0drmvMwa/1KzuMTfsxbe8WiuNv4yJDPMzMQgP7Sy26XjBrnj4UH6pLaIPMrAexKgK0GnF+J5+HCu5olnGPrfCH7AF1HqsQ23o2YKMdvGURrkeIiSmzs0NNTjY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207794; c=relaxed/simple;
	bh=9KZipDRR/9BiIYtvAM7XMrHl/WCcM5Pe08B2Ih90LFo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Thif6f+RwtfSAlgeaPS072Q7bywUO5QzJWXHp33kFmWHa8q6jiUAYu0eg3Rojd47PLlrTHFApRgd3W/u4c9OzY+YPIbgv8iv289dTK20A7TgWjW0qU+evNL6q0JWeBcTLLLOE7Rwcc1IdxFJoAQnDL8u0wIa2nhpljlI10ZVXaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cHmZ6ljy; arc=fail smtp.client-ip=40.107.223.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qCYJHUxwy3kSsCMha898irvwUD4LX5BDmnV6c2cyvzgDtljJgLvQkaA4E96/ptB2543xghv2OpnznZuhISA8q4CfxKPImQKrIhtYu/HlkmBgZyOGRu63G9g/c6KrG3L+7a79KVtt7r7uwN1o+KvlOITTClq4b1rRdMEbYkBeAKsc2Qy9nDcPr6vb70TTFaI2K1TpEXj20slOjDqq3YuCZ31DtaVuK4tu6JRg4I7B20cmchy/FmtZCwE1TO2c/yyMdH46KEjgDj9iwr/deglQOWE3F3Z4fefroa3OE29XI3gED3Fw+NrbvoE1OlnbBMgalvPZE7SuPx1LlHGwCKHQFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fnOj999y4FbPuEHB8vd5cW0fSNtS63p6YcCPVAHbS/o=;
 b=LeTACaMQUB2Eyb0/h768JkVwQvQqa259r0vbs/Ma0o5SinmH7c7nU1tiAOP5elypkNkuQrxTO1ErJCfN/fgIR+Jkz+Ya1B8tPut0hr9GFGFTNhNZtDkRTQWwu3xaH55u3etby9VjD7aDr3V7AVxo/7jKxe/F/1dRGjI8f5Oj9P+dzU7QZN4QhU0QwCnbjDgx6lHkYYdqskBZnLOZGVWHwEsg6NHapgn5VVrHOsQsa+IJlkeGj15c26wd1khFBuTyQM+HM5bhLB4WAnBXjo93y62yyZ1HLDQou2WAs0ShNkKlb2gjGUZhkXMfs5glRLZBe9B1LRMxx/cqEoj4DkzqKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fnOj999y4FbPuEHB8vd5cW0fSNtS63p6YcCPVAHbS/o=;
 b=cHmZ6ljyVpi/OMvvYMUi/aASbcd5wfKXWHq+HL5o/VTadr0h8tlOXW1hTCD/9YKn3DR+ALVL3OAWKvzvbcGgC1nRJtpt63lcUmIkWYmfFTDdU0lE3eGxxRVA6P3ZZzcSWgWc84QI+3Jdw5q47M/FC3TAHztjlo8tmxeJMblOcTY=
Received: from CH2PR19CA0028.namprd19.prod.outlook.com (2603:10b6:610:4d::38)
 by BN3PR12MB9594.namprd12.prod.outlook.com (2603:10b6:408:2cb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 07:29:48 +0000
Received: from CH1PEPF0000AD76.namprd04.prod.outlook.com
 (2603:10b6:610:4d:cafe::ba) by CH2PR19CA0028.outlook.office365.com
 (2603:10b6:610:4d::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.25 via Frontend Transport; Wed,
 14 May 2025 07:29:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD76.mail.protection.outlook.com (10.167.244.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:29:48 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:29:38 -0500
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
Subject: [RFC PATCH v6 28/32] x86/apic: Handle EOI writes for Secure AVIC guests
Date: Wed, 14 May 2025 12:47:59 +0530
Message-ID: <20250514071803.209166-29-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD76:EE_|BN3PR12MB9594:EE_
X-MS-Office365-Filtering-Correlation-Id: e3f83df1-8a2e-475f-9945-08dd92b91b93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/pTKFLvTXZ+VrMVp3Bv4xpmi/a/jo1iVMu/RXPn9VE2zIcQRkiiFnMndEX+L?=
 =?us-ascii?Q?zX/+IBqbEKF2kbx38MfSx6EJ+MnwovXL6S3BapAE2Phkt9OdZPaWlUvc8fQg?=
 =?us-ascii?Q?W4T+iD8DShnqSSG6pJ38q3NmJEVyE7/nwkxtS5nhvb17rhnCBUiIFpHEA7hb?=
 =?us-ascii?Q?oPpwUXTmWAD8FX+B9WVbR8rndNr1ZtExiCHs2BTndW7ysxluhhIzAAo03Pbf?=
 =?us-ascii?Q?w2kBweLdkrb0j+nAoJwxWqC+wEUv5zvXAyWcvnUZqCuLPuDli8pbIc8U41ne?=
 =?us-ascii?Q?kb/d7i+X35Z7sICGvgP8imTlQJSpGzGlvIi7lf6k6Xo6dngQSwoxNFH4fsZA?=
 =?us-ascii?Q?MLoV7OOqIugbWtLilsXdDwjRmx6t+3boTtY5bydmggiAFJwa5ed+cKod3AjI?=
 =?us-ascii?Q?DZHKWogo8kFUui3/1aFInoEDNwW3inZPPMTvf3v8jcHTAFlAS5kQ9d1n3HWV?=
 =?us-ascii?Q?bhCN5EqKV6dsFWlE39TTfXIvCoTw0U4TWQVHTh+75/w/IxiZf/cvqm7j7u0C?=
 =?us-ascii?Q?mBvd2kBJ8FB6ymz4A5T2/IRN+fv3FPDCmctWeSe+2ipJLwyrB8psnbGGhV89?=
 =?us-ascii?Q?8M6PjGjvpDGMvTbwS1F6xgGvmqiQn6yto/+q2CexNO8Y4Mq44lDo6SkUX4Qg?=
 =?us-ascii?Q?rMHv5eqBVgKggsLhmO/lAw+PQQaY+tie2lZFsY9Z+2YGKa0Y5ZROlRJ0fRIP?=
 =?us-ascii?Q?JimuwXmpkDP7/5Vvr6m4E6Mkcfr2TKHgIX5d60+ht7txfFk1JXWfJVMKKo2X?=
 =?us-ascii?Q?07xntsmtsqu8GuHr8sSOxNBfI6y1UmL0y896KrIMnDJuG+sQhEHLLs7iFj5u?=
 =?us-ascii?Q?DM7e/ma719mRhzPMVslsPjfI/8i1XO9H7nbh2nMJdR7i179SbSams7chQfc3?=
 =?us-ascii?Q?JuzspgeWnCgzdJoZqqq8DANyjg6odzyBOruPzNzivmFzCS9ZCGjhMt3+HItL?=
 =?us-ascii?Q?mvU1lltEM+a9TRAJ7j/s0x0Ws+T99TijDBKgmQ94iYFpnyb/CnjHh6lTi1V0?=
 =?us-ascii?Q?rqBVwiWC1I6rmDp47UPSJyhdzO6yOE854mmhaQ3AxT4qhmQmkkxff+wgNJhF?=
 =?us-ascii?Q?quYQ3AnVDUBLviNo7EEsgwo189RE0ACJTI7EBrqYIjYnv/+wQ2mJ+WC86w/Y?=
 =?us-ascii?Q?Nnl11ddtg/TfdSeKBsK7oq+qKuSg1OgT0V/UKmOKlfoxV7SZBYoPBNMcmGQE?=
 =?us-ascii?Q?Y5eoiHWepkOq6QoCehhFO+bBKX83aGQiwAvJiFslDgVkx9Y48HOnxwzbmOnG?=
 =?us-ascii?Q?uVDzmLmwqORYI3KlyHZrXRg6Z/jJlXG3/cbsv4Rw69G4DVxe5Ut7TLLlmotv?=
 =?us-ascii?Q?vXpVAWBNDSgWKdbTrQKhSkSSI/ZU/XiCJiE+PpijOHWSY20brXB11umOyywm?=
 =?us-ascii?Q?4gfbBZl5f2fMn9ocHFmXI4yb6eIVVKnfiub/g8q3OurB7wJdWxdpolnQasE2?=
 =?us-ascii?Q?qBOh+pnelxC+I2xgx4YaZ1RT0Y2ZFGPSx4TpqhWw7s3H+ws/yFmbzHmu+Kfr?=
 =?us-ascii?Q?uKpS6JnMnUnjZUUKTakc91JzvYwGHJEylS25?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:29:48.5152
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3f83df1-8a2e-475f-9945-08dd92b91b93
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD76.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9594

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

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - Use apic_test_vector() in apic.h

 arch/x86/kernel/apic/x2apic_savic.c | 35 ++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 0fecc295874e..a527d7e4477c 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -300,6 +300,39 @@ static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
 	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
 }
 
+static void savic_eoi(void)
+{
+	unsigned int cpu;
+	void *bitmap;
+	int vec;
+
+	cpu = raw_smp_processor_id();
+	bitmap = get_reg_bitmap(cpu, APIC_ISR);
+	vec = apic_find_highest_vector(bitmap);
+	if (WARN_ONCE(vec == -1, "EOI write while no active interrupt in APIC_ISR"))
+		return;
+
+	bitmap = get_reg_bitmap(cpu, APIC_TMR);
+
+	/* Is level-triggered interrupt? */
+	if (apic_test_vector(vec, bitmap)) {
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
 static void init_apic_page(struct apic_page *ap)
 {
 	u32 apic_id;
@@ -386,7 +419,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.read				= savic_read,
 	.write				= savic_write,
-	.eoi				= native_apic_msr_eoi,
+	.eoi				= savic_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= savic_icr_write,
 
-- 
2.34.1


