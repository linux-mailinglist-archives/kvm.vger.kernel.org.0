Return-Path: <kvm+bounces-44704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D48DAA0304
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:20:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9006168C98
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35446274FE3;
	Tue, 29 Apr 2025 06:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u6l9BB6U"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DB023370C;
	Tue, 29 Apr 2025 06:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907419; cv=fail; b=rfQ/oLQ3A7gL//OT71ceLZOcU1kq4mrgkolySCMsOAqOediye7LCToggLf8WvAE6ZYv1L8s50rKV6yZYE3lK1kJ199ORx/ZaMW7Zy6BTH9B1E9ds4N3SMicxDpoepSoo4Vv0T5ELsiaOijKNpYXN78Kzi3tPwRF6+xuqBb1Nlvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907419; c=relaxed/simple;
	bh=KcUCjD9Pm22jGJTWbYnkoLwh8NtiJ4bqAmBccrMv51o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eZjG5z68lNsD7a8LF7mBmbhNwMRApRbjpICAkvkToEQ7mLX1jiqdRsLVP8AD/gVt2hkpNXJea6yGIGtg5j5WTlH6WpF3oHuh5b0qgihxFESr5ZNjPdMzHwoo4nSEjaFTKzX3f9nt4zziXLSKCXbithbAzZ4LTcJaGIczwWobE+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=u6l9BB6U; arc=fail smtp.client-ip=40.107.237.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f5P5N7epZg5LrutWh0hJh802Wtg8mqnlIVYfX3sy7tBYJtDTx5KNVeRcV0FzmVL6+1E++7TuEWOMOisLlLC004Bo4jq/1kjyyzODSmSQZVQpiCtjwFp8gl4Z7JqUx4VDwAld7w8mIhLXVtgwPhlbmuRFOhkHmIC0Da8UyNkBGCOLmSxWYqC8U4JAVIZLWc/trBmNTZqqPbVo91fL/gxIYzZIAKggsaImqngejRvujp4EPvB6FTw7dG7criFLsLzLGcOt2VqllSn+dfmanAH71BlahHwTeVE3aneIxNAR7J3y4N5qqUuC3FtvfJN9AVnqMA8j3wpOY31KwaUJkPzU/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=63vbnsghLMHEGOmKZ+QPiy0Dc3tMd87xDStLg7YgHKs=;
 b=R7ItHB5+UXzHsBmvUGQIDEA8a5m4+2rlEfPE2z+3BkLE6wbhpW5uvjF+736KrGm7ZzVxtA29EEVGvqG6EyrtPur5HbQ5x5R7cs5SrJU4uli2UT9E3P2/8XZDqk9dkEa2JdZnnk9VuY0CPCDQkoGkkdjn2t0I4xUDvbagKVtqqs8CvpSrm1O6249Ax8nqq+mJKueqGgS7IS5ug1GOlflgwcryxzIJ41HguZsYq+/3Txt8E/W8lfoU0JRaeVc/8MaHoywUGYBYFkTCPvIxtJjVqAKdYQi2YvihTP2CyQAOiHb61WFrbrGQsHVSTvFE4QKfszJwglRCinzJQc/GSYtnzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63vbnsghLMHEGOmKZ+QPiy0Dc3tMd87xDStLg7YgHKs=;
 b=u6l9BB6U6Hj42bBBxiR09byCs0+oX9JqsVOiO5v3eXa01OjYr53pcTj8k9zi/0NInAjLbIj8RB9BLkBB+M2o0uykjw6Y4T4KUMOOPs4+YyLu27BvRxOJI5anIzP1mmQRVT7EHlEkyLrpzq0gBG0LvJow6ZL4VtKG7zBwzGMecEQ=
Received: from CH2PR20CA0021.namprd20.prod.outlook.com (2603:10b6:610:58::31)
 by PH7PR12MB7987.namprd12.prod.outlook.com (2603:10b6:510:27c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.33; Tue, 29 Apr
 2025 06:16:52 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:610:58:cafe::ce) by CH2PR20CA0021.outlook.office365.com
 (2603:10b6:610:58::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.38 via Frontend Transport; Tue,
 29 Apr 2025 06:16:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:16:51 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:16:44 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v5 16/20] x86/apic: Handle EOI writes for Secure AVIC guests
Date: Tue, 29 Apr 2025 11:40:00 +0530
Message-ID: <20250429061004.205839-17-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|PH7PR12MB7987:EE_
X-MS-Office365-Filtering-Correlation-Id: 00f4c344-9b7e-440b-933e-08dd86e56e83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?irnlIXK7ruARTrcuf/CZdt3ZE3X9SjHH+JVXSm9LeqAGMIf5bJmNf8bKmA8M?=
 =?us-ascii?Q?YZXRWrwoMx40UkVW/05/RICp2chh/LOHaF6Gr4j+5DrYbh024QvYuvor6d/o?=
 =?us-ascii?Q?AaCwn4fzaufOfZJVFyVPB5J9rg2Xyb6qrVqlE69HP4pyH7T2u02IfUL7Oqya?=
 =?us-ascii?Q?JhNBk9Zp5McrMOmJhcSfmPLzFCQQjmAVG1EqRlfU3hs1GvRDNY6EjHsfpJg1?=
 =?us-ascii?Q?PHHC123iqJ2VyiNUPhSZ2t9oKjQmhawYUjIw2juXZsYukcLWb4xKEQ3PyOt+?=
 =?us-ascii?Q?ynCwI6WzZ5/ynvwPp8/vn0S+YzCxYi4UlhP1Jv5CP9i1IohrJnY8kcIILoRe?=
 =?us-ascii?Q?Z5n09Ai5NGKgr8sqeIra884UHjwPTsToHKFX596YzgO8ctDMxV/iCykacx+U?=
 =?us-ascii?Q?8pGT5pTse7W2vYSOzuCsBjEE+DsbenxoI0DlmKgO2NGxOeGg5pHwbqGzNwK2?=
 =?us-ascii?Q?TZDIa5T1tIzfSL50Rrekm3qNTMjuYLnAZLYxO7sHk/bRgOWWac9bE4nZtPj2?=
 =?us-ascii?Q?ZLR8KFmQvNLIYqZ6VMDK2qA6PlB6mbdw0FJ10q8OQYr+kIKVm0dy1gnSf84V?=
 =?us-ascii?Q?2cGn7ytlFaLfXy4GDt+a3m2+ULjKjKErA08DYuAg6OxqolI1GKGVEIK8lEWC?=
 =?us-ascii?Q?5uIayLLxu/HrCxGtdfQQlf/HSxUe9qsWxBK3qNHRlcstYNG9xrULGaLfMRYj?=
 =?us-ascii?Q?TXytAxLo7xKNd643BiwgSzjlg0bW8o0djAAnX1jemalwimiosJbagfV4sqCW?=
 =?us-ascii?Q?TInupebq8Kr66SO8JmKGlaQSWcCgMgYfF2LC8i9Ii9n1INy9lUpa8P4ViLP3?=
 =?us-ascii?Q?jWGb5+bKRFQmNUnc2+Flffa0jVS9dkWiKmBg3M0Dw4C72ZdpYIApQgf8V7qn?=
 =?us-ascii?Q?fs/7rvTPL/0kHssjlj3VndbWUDJeTc3qvAUNzQHo6avtI3jTOy5VZYjDfb2Z?=
 =?us-ascii?Q?SH2ALmE1kXduyqoBfM6IMidj+JECTriCdzMhXB5sC79KMkdQQhR9gcNtcXYB?=
 =?us-ascii?Q?T6T+l11i/k5y86RTR5rrxgzMf09cc0ZZXqVCT6uomAZmM5ipsSjQATp1TPwb?=
 =?us-ascii?Q?yLi1BpM04ieFQiwdmPI7XA4dX51mB4TpyEk257/vU5rpvfIOQjUfWSGx1muA?=
 =?us-ascii?Q?WKvTV0cQ0Sewx0vrLHx6P8cf2FAfe7BbaiVQDa8apjfM1P+hu0SI6BFV+4wo?=
 =?us-ascii?Q?g2hJYdYUDrzhDPNTSbPY4x9Wl7Qsszo4MuQIDpY89Stc+9p1kmW46kVW399k?=
 =?us-ascii?Q?KUGok9m5cBXuL5qhPbs95M5K/oCrs6F/plTYDi5nFTp7xggymPEKHjOX2rIp?=
 =?us-ascii?Q?SQUWksCOxBQpZ6My8K4nbJQyhg4ix9e4FjlyWHkXUUfv6lh+5YID/NFLctCB?=
 =?us-ascii?Q?KICErGIMLEeYIHj76y3WMeEAt4vbIn2aNpsDEvPOPqvrVnHZmpvFhjKWZt++?=
 =?us-ascii?Q?2PPm2FmDp7COgk/5qTQUdORi+ODTrZV/U0ymk5FI0a3PXK9T5MhW09LjggXq?=
 =?us-ascii?Q?BzMyV9O61EEDkJx2IZBPm0ITbzLzwihXeiJG?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:16:51.5389
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00f4c344-9b7e-440b-933e-08dd86e56e83
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7987

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
Changes since v4:
 - Commit log updates.

 arch/x86/kernel/apic/x2apic_savic.c | 38 ++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index fda1bd13aff6..c517abdae314 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -377,6 +377,42 @@ static int savic_probe(void)
 	return 1;
 }
 
+static inline bool is_vector_level_trig(unsigned int cpu, unsigned int vector)
+{
+	unsigned long *reg = get_reg_bitmap(cpu, APIC_TMR);
+	unsigned int bit = get_vec_bit(vector);
+
+	return test_bit(bit, reg);
+}
+
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
+	if (is_vector_level_trig(cpu, vec)) {
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
 static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.name				= "secure avic x2apic",
@@ -407,7 +443,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 
 	.read				= savic_read,
 	.write				= savic_write,
-	.eoi				= native_apic_msr_eoi,
+	.eoi				= savic_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= savic_icr_write,
 
-- 
2.34.1


