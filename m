Return-Path: <kvm+bounces-43552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3BB2A917B0
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 11:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 15A45189619F
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 09:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42C4E227599;
	Thu, 17 Apr 2025 09:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SHJomxzg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2062.outbound.protection.outlook.com [40.107.102.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA08218EB8;
	Thu, 17 Apr 2025 09:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744881795; cv=fail; b=AkRqs0k+eRGfjuIzfzxP7KQTQDNpvAx99AjSXFNTMR93loC1Dmf+51X755tPkI6EuvEwqm+iNAPAk/WjLeUJvty7dMSsc1lwj2H1KrT9hWY8dfXFdD6X6isf0j72jeW3TUl5qL3ykh4nC4/BcVd9m8xkCDb/cCObra17zULJxH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744881795; c=relaxed/simple;
	bh=kfVdRHexGQVa+ZX248sx4+f6OPtQPGRC56aSuCvmKqU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fZIbdvZeOc7Htl62HPf1/y+4lMxu5SIyGKD1G8fc2evryyT2aFrVimrvIWmc7VNw5P/RDJ5P9/ozuh4jMYTWpGx1Q1GX0u9k0TRRbS0pDRWKIx/wBzGWn/HRMWvFrSWCc1oXn8a9aS6Edr29XI+PV58kxVytGq/JmW2GQRfs5lw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SHJomxzg; arc=fail smtp.client-ip=40.107.102.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aZ2Sih2C3D4tml539vD/vZIf/rGVUwuM94xPLRNvE0TaOodYW27Pa2Fj6Ld+U5K/w7rud6ZTqQxvfdo0juzFGKDXZ1e8GK7Fxp5Euy0BR9s1ueyjjL9htkhBMxDU55psqwJqBhx5a4IBhVBaYJ+RmRbLz8TuhyCPHwkhLrvcIrNn7u18RS5XUvZQu9Jv/5d1SFeq19prPliil1qYpD2PCrrFMEEJ3ikrIeKywZt2P4wLxr/uTKuBzyHjZKmlX5yHc1oq+VwimBl8AWaSvFRj31bYMpbnAwFIKKCdsX7ybT3meNjt7w8/pSVHvSPb3lNsoX5vS654KTzixv0t2lK0GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMRXuxMN5ZXT4ZlmxoSfOt+r3U6PR80JvQjp12zWKt0=;
 b=h4yREzrJNSGIlk11y3UBHy/YJQOnbsitNc/pXNA8Yuoa8wqx+wY/wTjayHyaOzzbS4qLzt0WGS5zmBXRyyDG+7GaetjCq68K7qf7cCTNQxajjPH224dqDDiVz613cE2BM9VQX4/p64iWdRlgnh3NxegdU7SEUpR8XmYYfCNKRXOEeH4RyHIS9Rd+oYhEM/bpoOrt+MPrMwt3g8flGI6Z/PZlB27SVnsbch3NxIYTeDOQsrSANlwvs/kTjSLL92I/tdw2DtdsG5cJfRp/FMCO/iCVO6pv0Lx9H4REuCwQWOrBCzj4xZfYe1N8Uof3DRAgsJ+NL1nVe1s5ofOMxPysNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMRXuxMN5ZXT4ZlmxoSfOt+r3U6PR80JvQjp12zWKt0=;
 b=SHJomxzgei7n+kI3xjBmHX5Vz9W075mfXwg6jdfyew0InMCTagXZJEFZLVWHutYcqJyvmbRAv7oZg8/KNemRYWizxvDHXPr04CrgXF2fHjNPCyVUaNQ2oKP7ADzrjEfxtWtGI7NGDGERrTTHtMd2y38M7k//2koG4jqbok3qsNU=
Received: from BN9PR03CA0476.namprd03.prod.outlook.com (2603:10b6:408:139::31)
 by DS0PR12MB8317.namprd12.prod.outlook.com (2603:10b6:8:f4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Thu, 17 Apr
 2025 09:23:10 +0000
Received: from BL6PEPF0001AB54.namprd02.prod.outlook.com
 (2603:10b6:408:139:cafe::4a) by BN9PR03CA0476.outlook.office365.com
 (2603:10b6:408:139::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.34 via Frontend Transport; Thu,
 17 Apr 2025 09:23:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB54.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Thu, 17 Apr 2025 09:23:10 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 17 Apr 2025 04:23:02 -0500
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
Subject: [PATCH v4 14/18] x86/apic: Handle EOI writes for SAVIC guests
Date: Thu, 17 Apr 2025 14:47:04 +0530
Message-ID: <20250417091708.215826-15-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB54:EE_|DS0PR12MB8317:EE_
X-MS-Office365-Filtering-Correlation-Id: d91d07c1-d5b0-4e80-82dd-08dd7d917873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4HZ79lr5VfQ4UoMFFxh18Hg8o5zpJ6dyGJDDP8pt7oLnn+hqfEHl6hMxKwkf?=
 =?us-ascii?Q?TOFDHdSMSZkWwJLICXrKJRGp+TRvC7mDj0K/dDM3IGXujnPJch1WEjWg2X2l?=
 =?us-ascii?Q?aGoTC0L2drKyekZ9FLPBQPhSlDk57eECs+bs3ULh93O89titPb0zE04dhfdE?=
 =?us-ascii?Q?btwp/YlkZpcXNLxRe9py5+5s3pfew1mur+XOuvuGkyw/Mn9J5f/Det9xUkjQ?=
 =?us-ascii?Q?fDteNRJrzm8IHQvgqcdz2j8NjGTB/1ItOsaUgCAEody5mlo4WPHqbOlL62vZ?=
 =?us-ascii?Q?LzBMxqS0NhQE/AGCca2hCePudT9XUtiXep4w0cornwiCCCxv8FJiMhWVlzr6?=
 =?us-ascii?Q?u0Kr8crR4auBAquZkziIwicdW2UnUSskBpjmJ6ztVvzag0tcoyd+yt0Szsu7?=
 =?us-ascii?Q?LSeE2rq6cL78GuEvqjuPa7sn4/u9wjA4wzd1jEfCwgiFP2hFQvixFV3+Z+hX?=
 =?us-ascii?Q?rNWBPltKCx3sAJBp/TeA4DVhnPc9c2QckcoY6RuKLM5GtoR4VnW2qFacYZj8?=
 =?us-ascii?Q?W1IEHAcHDBMmUMnwYh7iLxTUpHV+Xqcv5PJvG8l5p1YfAQuvZVKjxF0vaotj?=
 =?us-ascii?Q?hjUQuGGSdxJ1Y+vEpT77dqOaB7ZpQFKceib/2V5RzUc4pYnP1aEb1Kz5+a+S?=
 =?us-ascii?Q?1Z5ZPMyJD3fWRLNRmltxGn6H0b9RJh0ZZRW8xuD8UpNKLud8vTXwoCXugdn+?=
 =?us-ascii?Q?06huEemBmqsOe1XtCiKcYUOJJMIcG/H+xr1aR7KgKNUV1ORC0dmiUvCPes1b?=
 =?us-ascii?Q?w4lHMaF3neMl5DogEzjRWegxZwZY28MHv+2F53heZ7cbkLrCBY2d54gK2krK?=
 =?us-ascii?Q?eCvHYyZ1bbn8bdLHOhlwV5HYU0aoSPB0V9Pz9+1X7ocNLX/sx0HDi715v/gk?=
 =?us-ascii?Q?Av2WVO/chx8Omf6LSk1/tyv5rTAzOnZETflHO+5iImIKvBci/vG6rt4FLFGw?=
 =?us-ascii?Q?F78I1ce7tBhD59psrPVu8mdOGw8f6cPpdzOYWP/XiIFHIIj/GEwMiOr/WI/A?=
 =?us-ascii?Q?uaH6GbgW0EuIse4dGcE0fV2PfrzZd/bOThqHzv+lQ3fEgOq9hkv1KPJAh3jM?=
 =?us-ascii?Q?ZgJIsbfH12QUggv9UWiwFsnW7zUS18+4sr5w38oFfHbRLwJFrb5wylRhhOTy?=
 =?us-ascii?Q?xV0Kf13V3KrhmFoZmGdLORP1dmifflZyGvNc8IiiFKX6NhEGKpG7vxV/0xE2?=
 =?us-ascii?Q?ugrg9If5c7mu9dtv1ES0Qh1gL9/jPzkggMaVKt83YyFYU5exq5vWXfEekd88?=
 =?us-ascii?Q?naKtKkCXRgluMRz+gQOB7gbZYLjhA6UugCVXp/5knHG1cbvCufDhG7zuV1Oh?=
 =?us-ascii?Q?0fJDjjM1I2gfORVH9l+7d9WgyIXmbmTzCk5VRhFLImWczPJBdhXhcyb4ysOa?=
 =?us-ascii?Q?azUJ6ZZdemsUiOF8sOSTeRb1Pfll4OIzNCCB4k1NONXEMuP/+fzwPMRWrHIl?=
 =?us-ascii?Q?g1F7oCh7rEhYvc+IUCYvgh0cEcluW9UGiKZ8hKgODKYFe6PobgJGchC4ieH6?=
 =?us-ascii?Q?/Euf2y6oGngIjyAEkVFbLKrb50xHt4qLqEiI?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 09:23:10.0607
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d91d07c1-d5b0-4e80-82dd-08dd7d917873
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB54.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8317

Secure AVIC accelerates guest's EOI msr writes for edge-triggered
interrupts. For level-triggered interrupts, EOI msr writes trigger
VC exception with SVM_EXIT_AVIC_UNACCELERATED_ACCESS error code. The
VC handler would need to trigger a GHCB protocol MSR write event to
notify the Hypervisor about completion of the level-triggered interrupt.
This is required for cases like emulated IOAPIC. VC exception handling
adds extra performance overhead for APIC register write. In addition,
some unaccelerated APIC register msr writes are trapped, whereas others
are faulted. This results in additional complexity in VC exception
handling for unacclerated accesses. So, directly do a GHCB protocol
based EOI write from apic->eoi() callback for level-triggered interrupts.
Use wrmsr for edge-triggered interrupts, so that hardware re-evaluates
any pending interrupt which can be delivered to guest vCPU. For level-
triggered interrupts, re-evaluation happens on return from VMGEXIT
corresponding to the GHCB event for EOI msr write.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v3:

 - Removed KVM updates and moved to separate patch.
 - Rename callback to savic_eoi().
 - Changed test_vector() to is_vector_level_trig(), as there
   is a single user of that.

 arch/x86/kernel/apic/x2apic_savic.c | 38 ++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index f113c04b0352..bfb6f2770f7e 100644
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


