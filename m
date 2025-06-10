Return-Path: <kvm+bounces-48849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78E49AD41A6
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:07:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BDB21888F6B
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCD25245038;
	Tue, 10 Jun 2025 18:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pYkar1KM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E47A15C0;
	Tue, 10 Jun 2025 18:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578822; cv=fail; b=AfJZLrnVwL6TZGZ9NAtdR7XEJSxA9aB+htx4ABSZmpwTVJlf/LGh3aMWZoaTAP33/CiY1+iV1m4zfrH1CfuHd9WLhPyjS6OIsekNlXvdpZeLqym5E89txkYp803mndp+APXEK8QaJi2l/fcXOr1rkmy6SnJZL/hCnOT2hHnm4hM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578822; c=relaxed/simple;
	bh=xNWvqDY6thVAQ3uZ6ASMm3HI4ma7AY6PRjRbK8gPDZA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j9B8pjEMxYVUAfVhWiOB7zlm5IbDEqma7X+QSXwXgTJylmYK+6/KNCYIdr6AVprAhJEOeUoczDNnG3UWRZc8ZhGCwOB4Fen6cuI12O8F8FkQhCnrYJWS/XBF9U1NB+8HOOSVWKZEYOm5W413iISZzhJXsPNis7b67M4y7360zrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pYkar1KM; arc=fail smtp.client-ip=40.107.93.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GDeD8ZTrM4su+3EU+vODlz/9A4vLKstcsP4DU3u7eDVqGHlpiET4JA0P40fRgEGimr3Sx5TFYZMKDdgBmrsq6pC/dRzM8d4XED/6SmbOOV8jBNecQnglRPNYRYmzcSheNJcYGpJE9nfemmq2hKmY35hB3oboHCQ99HB6N/OiSxGanu/KfBuBm1/41QvwHzymCcklNax/x//5JUQEl9NT/Bp09yTkFRToDaCSsBtG199FjsPwBZ4WIvmBSG4NtOSEmr9tRLLWv3m4MXCVBkOJe2x0+mBFoWtf5ULoaq6xxVwSPwOIzoiivWCJ9li53CbIsQIfU2tReFWtbNFygz30uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9VdstuT+dVr5Lcx+m5rEZ4E1FYwdvmGQKxb8wkE8H4=;
 b=k6D9n5/5OjbU6gl0SzJjDxMParBJZaSkB+2vLwCGaQnfvrh8GaQHZnCNJZR8swMtX8l2kGRv4wwAv04vyGnL0IEOMU3yS1QWBdpbe7ClMrZLurM348CERCGqnRHW084V9NEC6X2sy9EofwL/QJmMCcvgjVFN4qaxEcfRv1triMRKEtW9cdCh001zRY5iuuJ8EQuF3MCb+djaiLyDAlbWMLP0VtvffTMB7KmQT+IZeqe5S/nggCcnuD3PBGNH+WPD5U85Rr7/PNe/bbBub7w1tUbGKVr8PSQPIP/d/sYUdJnWmFYJtt17+q3nhu/qGn0FKa4VbG9mS8F9Kh1CARhCoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9VdstuT+dVr5Lcx+m5rEZ4E1FYwdvmGQKxb8wkE8H4=;
 b=pYkar1KMyVAoooqRwgkqHSgHR5iR2lAKdnkc8CNqR/PzuQHyaZIFTLt2JnD1gBRXB+S92WNxRRwFm8dSjVDr79ezIc2Z2LAGgKIzmyYPAp79lcBI30m6Uiyj1vQE3rK2D0YmMbZE8My0dIgKz3N0c5jEzdmYjgOYmOGjBYa9fvA=
Received: from CH5P222CA0011.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::26)
 by PH7PR12MB6540.namprd12.prod.outlook.com (2603:10b6:510:213::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 18:06:54 +0000
Received: from CH1PEPF0000AD83.namprd04.prod.outlook.com
 (2603:10b6:610:1ee:cafe::f1) by CH5P222CA0011.outlook.office365.com
 (2603:10b6:610:1ee::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.19 via Frontend Transport; Tue,
 10 Jun 2025 18:06:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD83.mail.protection.outlook.com (10.167.244.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:06:54 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:06:45 -0500
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
Subject: [RFC PATCH v7 33/37] x86/apic: Handle EOI writes for Secure AVIC guests
Date: Tue, 10 Jun 2025 23:24:20 +0530
Message-ID: <20250610175424.209796-34-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD83:EE_|PH7PR12MB6540:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c7dcfa9-da4e-4c40-dfcb-08dda849951e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z2TW8ei+kDdCVBrYeIjDtrYEo7+qO7zN0C8q86ZCtIBdqMkYy1lnJX+C4VJ8?=
 =?us-ascii?Q?UvaJGgNIqrYSeTph4H6S0h/+MUDumwg4O+NEKGTfctquGONV3d9TZi70u6jH?=
 =?us-ascii?Q?/gXD/rYKzqMcUoDxUbPy2b5jiXqlmuSkxufaP7DXQzE+XpmOnsnF+lqSBntB?=
 =?us-ascii?Q?gZsBoLinuMyo+uK51vIg1KrmUCzpzCB2kk47VcrhI7kl8I08dcqJu/K46mQ5?=
 =?us-ascii?Q?YBOs2BE8htDOO/7MkNbFYEHhdKK3G/L65rrDmu6XGbfmndhKb0K+yTn9ALPU?=
 =?us-ascii?Q?6jcwaMfHQ9+j5g8A3dzcyeEUcopT4YxWfl3Do8VtjYyZOMMtPFQV/Zo3EfYZ?=
 =?us-ascii?Q?ZxgBpDZYiaQAcMkfLsBUMo7sE6Sf9UOwixw69Ot+u4ssYtVN0nlaEm2NaKgU?=
 =?us-ascii?Q?LC5lwUHe5D9Q6IG89bKM/6M2OWilJV1K3TKWZKCxsAlMC6KnRXGOgthkRju3?=
 =?us-ascii?Q?Lb4afxFUQlsHdrNnalkfmNgzUzdapVxPwUwphD9GtyuIJL06JuEBOT774XMo?=
 =?us-ascii?Q?UYcpkhpQMxsPlfuE7Dg7PSTUNswiW7Ee70OkdGj+kd+4+AEkn6XA+oFRugbU?=
 =?us-ascii?Q?uNjycdgDe2bnMdyJLXj4Y+LqDNuEQhAtqgGwazWnZa4sxLgbduEibrZGg9aU?=
 =?us-ascii?Q?AaOfpyhXhYioKTcNl5uItZrifvj5sNfeRKR/ZH0ixpYmpfl57nvW3la/P99n?=
 =?us-ascii?Q?xKTbf6WDuF6GajwH3vG3RBBdAmRzhEX+WNjqBcgXkIGWR6kZhLVHdJHeqi1O?=
 =?us-ascii?Q?jY+9WyV7H3RnavSk3CRUQzY8cm0/h7Qr0oOQNHFp+tqFEx/s/PjTLzyz+Cy7?=
 =?us-ascii?Q?HnwxmRZ/Nub66MLYmOzyq83Lvl3XXKuD4yyiKr+1oylpHJpSXCRWseOO4FzY?=
 =?us-ascii?Q?iEdoRKT4gTITC3ZRDRob6jm/wL//0KBCwUX9ebeiz3jfRtsmpynFjAIaf1Hl?=
 =?us-ascii?Q?zmeAv7oPNrbRTfpG8+oJv7MXa6EetwxO+I4yYckHDSII8HrfYvey9kk9G53B?=
 =?us-ascii?Q?CHw4fcrywmIByfZZXk5pu3DpnpVTFSr0P5oLfB582tjVCrWpP5/ApaNPn4GW?=
 =?us-ascii?Q?f67V0f7pSOCtwSkZ8m8e7rQ2cFM832r/RVkVkH94iVoZlrTkrNzoWNomQPUL?=
 =?us-ascii?Q?tqYwLNZBhMObxY/+axWNH0rL/CRDdbVxRLNqAnlbyajVj6SjLEeHcppyhqdd?=
 =?us-ascii?Q?gbr4pjDO8hfVCMH+ZAr/cUkWZ6SsxhIKcYdpMhrtpbCgxfs0MHMCN5aGzKt/?=
 =?us-ascii?Q?AfKzKQLfqNcIbJj6mWgey0UL9tHz2H0twd92lI42RtR/0hcBb0vPxAnxEPap?=
 =?us-ascii?Q?Vi5wXwvplzU+dOsyQ2o1xIcAgeTjpDDaIvh+ETEJPj6rxea9WKCYuBaC/ku9?=
 =?us-ascii?Q?vp7QTLQMt4BWE5uR2KQYeK7y8Iruw4tRqPdvpBI33rPNp6LCrz5G1UV9VZkn?=
 =?us-ascii?Q?kD/Exd12JxrpkUxtvS8qrZA4Oa8f2hzvLYQTbKfD6p/G8U6K3W7PnWJfh5FH?=
 =?us-ascii?Q?eKyWehH/1tGqEZ8Hf5sFUeUPSl+HEez8rjwp?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:06:54.3838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c7dcfa9-da4e-4c40-dfcb-08dda849951e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD83.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6540

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
Changes since v6:

 - No change.

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


