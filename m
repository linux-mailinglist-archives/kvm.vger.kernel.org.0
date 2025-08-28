Return-Path: <kvm+bounces-56100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF440B39B4F
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:17:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFED81882719
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:17:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF1A30BBB2;
	Thu, 28 Aug 2025 11:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IZ38CBRi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB746214813;
	Thu, 28 Aug 2025 11:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379841; cv=fail; b=D9sSU0syozJY67UGY3nDRDOHKI11MoynwOMeblFVoe0rnbj4V4qANt/9OHLrSE8zN4Ok6Bf2WiwjPbMLvD/wmMKfRHehOZUWfxrShAjbrbLmU2TmMkY/TQisslr8aIH1VqjcUsuSojQpo8W4Ws4pWWCehrIi9e68bq36HExadvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379841; c=relaxed/simple;
	bh=ckJiUT/pe0WJIFq0pnGwVzwVL4dkysLQ6zkk/9q33AU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=smQtNZnNH3zS1NkQQnVWOLMS2WmtD0rScBNQkSnQCWpQrAi74AeDLNxnqNXXdycUsVMf+Jp7kdcwjW9sDHPsXw31l+g1dK4qw1Zw7ZfqSx2QNGeS8eY8/VoTX2NyZmni8qyUOmqTQ+L/m9VGYirMgespCMnCle1m40sKQ21wt+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IZ38CBRi; arc=fail smtp.client-ip=40.107.236.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XwbOjLppec4o8kjps2Hudmi05fgiBs8uofCRry+nQAzejrZEAV4ilapEEFOglAwCN+Am9PJWq6oQJKeQZEKjCSgol40cB2BqD2/oLN4yrhhifOFauTJNFVku7WjWjql0pol2ONI+FJfhO5GrSF88yZyeunBhHFph8lLYjASY3McgJekGPF1TF78gvreoJ3frJb64XlQAiGrfmeVfYqs3fpbf+uQnLMwj9wELerXMQfA9eYlXU7yQrMEJXoM/SKHRHe7/cPCE6XebW5As0WSbOc+6dHpkyNHI5GjYvSPwGQJeSaorA/koHINtyvZPvXxe/0uSpGXh3fXNd+sOdCYRqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+39mCEPyMBHNLpeTgk5rjRsrpMHDus/YKluoq4LzGKY=;
 b=hIxbtxPjD55mhvnMFUfWY6awht90pafob3mYTKIsI+kGiKHvUozBKJWkKhmEqgKJHs0ioGjNY7glmVPdRz3ZQzdi2zcz0K/+fnZtNVCiQz36ezhbVx+yCu3BAVC5Q8FVBjtmCJuBpr2XIJajWbPbPMzOK5x5wLrpBR/BxbHbOGswT53s7YLDM2R5kIClwexDI8XaiEpHvol0taEAE/myxx7QQDJ2meuZCfDoFyq4Mo+XPAPWD1VOqxXfK9jjgmgcQJEbRQzKCzCI57FOypmkdsRD90DbLVY039oHSr6HQAbQcOVs6tF8suCuuH064db03rnoIV9kzIRsaekA3QKTgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+39mCEPyMBHNLpeTgk5rjRsrpMHDus/YKluoq4LzGKY=;
 b=IZ38CBRit/VIhL6P9VTG8m/O/cTz+fIn6jtwY87iSY7A0i34awDqoPAUzEm17mMV//NF7yqm52dm9SPRJagQt+fkorKQzT1JTWPaEkidj6QB8rPmBiLrRw3VQBW9HSzv+WgG3GGM91bcZcEd1+bJFAkniM6Bkfk0cE7GSyFKO7o=
Received: from CH2PR15CA0006.namprd15.prod.outlook.com (2603:10b6:610:51::16)
 by IA1PR12MB9063.namprd12.prod.outlook.com (2603:10b6:208:3a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.16; Thu, 28 Aug
 2025 11:17:10 +0000
Received: from CH1PEPF0000A34C.namprd04.prod.outlook.com
 (2603:10b6:610:51:cafe::db) by CH2PR15CA0006.outlook.office365.com
 (2603:10b6:610:51::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.17 via Frontend Transport; Thu,
 28 Aug 2025 11:17:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A34C.mail.protection.outlook.com (10.167.244.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Thu, 28 Aug 2025 11:17:09 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:17:09 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:17:03 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [PATCH v10 14/18] x86/apic: Handle EOI writes for Secure AVIC guests
Date: Thu, 28 Aug 2025 16:46:54 +0530
Message-ID: <20250828111654.208987-1-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
References: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34C:EE_|IA1PR12MB9063:EE_
X-MS-Office365-Filtering-Correlation-Id: 4132a04c-1f9c-4a75-0ac4-08dde6246e4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LKVKFeKNaAptC3vRFqmdteOC3jkhmAwTGcyz72OkKz7FZE4jPir9mCVqbQ10?=
 =?us-ascii?Q?SAtstvagJ3i9RubWYJBdWY2Uf6IzyDp+nSraY4pc7jj1rSj94K/mDS8ubFJC?=
 =?us-ascii?Q?hlQM2tVJ8ZDSw3pmP7HLCwM33mt8ZOArW0rJQvtY7rF1Ff8v+stkl1jBEHMT?=
 =?us-ascii?Q?JBzhk2C4AeeXqP5XoPLt8id0pBgbOyDKyNK+VAeTWONO0b73aUzFfj0cLk00?=
 =?us-ascii?Q?o6IfBg/xuN4F91pZEQdnx2vrJ+BCSBPMtJZzGegUHkUS48INfkAJ66aPFnsz?=
 =?us-ascii?Q?UkxOGiRESmb7+c98gaT/nvubklGxiN0dw7v/s61M4W7m4oqWbtHjlYfzWfJ7?=
 =?us-ascii?Q?XOSg2yfaUoWqdlJtN8h+fDYSDWODu0jmv04Mfn3bko1zqajPovepUPOXgkPu?=
 =?us-ascii?Q?9wMNvL1nBEq8l9IrMf12NQ5O0ylMpSeIpgCmYocm1A8u2iom9c712HHQ4QWL?=
 =?us-ascii?Q?0Y7Z7BCN/hmypv/H4CfIHXaf+HsJOGx6sx2RhP5N9LxGDjxXAh+/Goh31fRD?=
 =?us-ascii?Q?8s6KV36WzUlntHpP/YU0dPLt1JQEknis7ycHg8RxMRcG2XyuTE+nf5RgyyeG?=
 =?us-ascii?Q?+65GOzBej6s3PH+Syl5YaHTBX2qdSe+9eHv4QP+Zlso5J7MbyzQ7OtHEQPHp?=
 =?us-ascii?Q?UgW/06fQT3OMNhSQsXUrrSZnSDjlWoo3zqaGhwTuItjik28jrlBkenmwS7J4?=
 =?us-ascii?Q?+XAS46smhVYLCSG+jXlpRF1WWnsXCPvkkwXyRhy3jtGN7IqfbarqtwBtQDFD?=
 =?us-ascii?Q?LFouD5l9vB3sxZNjgRmYaJXc2PAPo4yl/sygM5NgCOFBVGS/TZmIwy+rlVrf?=
 =?us-ascii?Q?naATUp/cXYGK8CBGdw5dxbnNenIf9ZOLrfJ3vi1u3jmvFHefeB8L2bfVke7J?=
 =?us-ascii?Q?ooo3PkDPpvjiP8vHQnw4o851OoaMbkI27fc8kAPlbwaepHbcVSiw29NK8E0I?=
 =?us-ascii?Q?liPNFcyw16vrnQ3fMQfYe6+yovG1e9pnOwXRCGmgL0+rLY/iGN0/W85YXG2P?=
 =?us-ascii?Q?eMlZ9/rOrtu9yGYB5GXz5UhgYLhxG+6hXKfj0+HIDb7jLtFfxQLpnrw4I9n7?=
 =?us-ascii?Q?GUybgrS0xeVkrz1+SLMkw0SYXS6C2V1IlXVlC2VT2yuE+eV/D//fX44MNdaf?=
 =?us-ascii?Q?v1j/qdihNBWVauQp1D6d+OQwh48Ij2RuwBHUW8Tl0UCdKvvHHIOH72X4zCkf?=
 =?us-ascii?Q?ja4P9wygVUWzWFG+4V80T/B9ZDDL4AMJcf/c/hkMMlZWDgK1+EYdWlw3bXyD?=
 =?us-ascii?Q?PDy1OtkgXSvj2fulh834JPh0QDK5pI6/cCz0CY3o0ZheEX7v4N43aU083bAa?=
 =?us-ascii?Q?/wZp93ogEgTvGWo4OE5RjvkHQF6im/xWJTTFrp7vFpajtBeNoY4kRuoweyIR?=
 =?us-ascii?Q?1zhrjxCCinsT+VYE2uSx5M11VigRDu11Ywk+P9eNi34B1HRoLwwUfDjb/gfn?=
 =?us-ascii?Q?kzr4NpkofAwZnJvNUsw7IcAUSGXaz+5M2d4rEWRbvStVtXGlllstTXbXf/Ov?=
 =?us-ascii?Q?cFesSwphN2hBBXUoVJBfJEoDSUtWC9qvs+2M?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:17:09.9616
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4132a04c-1f9c-4a75-0ac4-08dde6246e4c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9063

Secure AVIC accelerates the guest's EOI MSR writes for edge-triggered
interrupts.

For level-triggered interrupts, EOI MSR writes trigger #VC exception
with SVM_EXIT_AVIC_UNACCELERATED_ACCESS error code. To complete EOI
handling, the #VC exception handler would need to trigger a GHCB protocol
MSR write event to notify the hypervisor about completion of the
level-triggered interrupt. Hypervisor notification is required for
cases like emulated IOAPIC, to complete and clear interrupt in the
IOAPIC's interrupt state.

However, #VC exception handling adds extra performance overhead for
APIC register writes. In addition, for Secure AVIC, some unaccelerated
APIC register MSR writes are trapped, whereas others are faulted. This
results in additional complexity in #VC exception handling for unacclerated
APIC MSR accesses. So, directly do a GHCB protocol based APIC EOI MSR write
from apic->eoi() callback for level-triggered interrupts.

Use WRMSR for edge-triggered interrupts, so that hardware re-evaluates
any pending interrupt which can be delivered to the guest vCPU. For level-
triggered interrupts, re-evaluation happens on return from VMGEXIT
corresponding to the GHCB event for APIC EOI MSR write.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v9:
 - Commit log update.

 arch/x86/kernel/apic/x2apic_savic.c | 31 ++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index c569b6e23777..08cd1f51d909 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -301,6 +301,35 @@ static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
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
+		 * Propagate the EOI write to the hypervisor for level-triggered
+		 * interrupts. Return to the guest from GHCB protocol event takes
+		 * care of re-evaluating interrupt state.
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
 	void *ap = this_cpu_ptr(savic_page);
@@ -379,7 +408,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.read				= savic_read,
 	.write				= savic_write,
-	.eoi				= native_apic_msr_eoi,
+	.eoi				= savic_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= savic_icr_write,
 
-- 
2.34.1


