Return-Path: <kvm+bounces-39253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3349A45989
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 10:10:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92B64170912
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 09:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 221B1226CF3;
	Wed, 26 Feb 2025 09:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aAWsJuv8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2089.outbound.protection.outlook.com [40.107.95.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFE9213254;
	Wed, 26 Feb 2025 09:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740560914; cv=fail; b=Y/SW7xvrwW+Ir2uPSCLKMlDjYFLNsYguSJaUkI0zpcS9aCvwnczOQPbVjQXOUFKilVZ+s5Gn7x9bY2hapKyXhTHDMlZxBziHG9KFgP3t8r6uC7V1ieOQkqM8iPSDCj4jUfhOMgTUbBKd1u5N1lrG+3Kv+mkBeqZ17JJSudjRm/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740560914; c=relaxed/simple;
	bh=jEEYbJT1L4Q7H7+5QdYLOETQ6pjG1djCiT6oT4IPceU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZWXxG7tLaFG0YAgm3iH9r4g73ovVIRNMXgZiCj1wrrmgKyBbsH/H7CtmaJeUPbAiXMEGH8dtKfTOfZcdkwg07AhbZ/yUQogrVtDn1QNjEv6hTLYGK49ZsUCG6Eptq6a8TR775ZAciGr3uDn+EtJsSmsh40yMcfNkJlirohInev8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aAWsJuv8; arc=fail smtp.client-ip=40.107.95.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LnzExZVLobnrWjAX3rtz4AQP7q8zTHnOIGXRvBsiiH0Y/WEJzFTP4DP3iUxaIuNHWJaPo/cClUToFfCWCRfRbdQ9hQqc4tVqHRS8HMO9ErE0i2N/dPoyvb/oyYhECAzKIU7N4DFxynI98G3aWaGvSGvtTULdJfV1EZFpHpMFFFnjUJ/AqjJtlEEMTSs+nASbq9W/TbtQ5s45JRJAgZKRHvnMmVqn2ONtudKcf2e/gKyJir7amGpLYHZHKYItxQWkDSro/UQAKQkp3HbYaslE76e2CQ1brgxQevdoE3hvaTvLSYTnOhB5xAhLaduaDLZeHmVWkGYRkF/f5CeSzHkoMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xx6cLOYHtbVoY76XeTmFPsaZCqRrn/lbLYfOgv6vwE0=;
 b=Oc1KdvLRZ6NycLaLcPlQiWB22J1VKM6CL+XZTdvWhwNN/NAsS4Gvx3bypVpftnsU3ixp5kukosGzfV4qXctPzqI0jhh/1YPHJLhGzjkKZvRA2vZxDsE4ebCpXfFr19X8djF4W+CF2bCOUlL+QZEJdhiamQwveeEolCipAPgw/Q4ZFE1XAhqa+8UW2dhgMAwwOT3y2fvDL/bfaGT86ucd0HYj3vQB400RrEHcPz6rqgHOE7knIJAlJ7aa7W5vjUBKY7Mu0ZknTtrcZ//B4BZ6x+RuKTVpbrbHx3+yfxaXTVpAMi+nb6W98/2g5hVvTWf6q/McAZ1fP6zz9Ls6NZb21g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xx6cLOYHtbVoY76XeTmFPsaZCqRrn/lbLYfOgv6vwE0=;
 b=aAWsJuv8vLToHPpBZQheOBY+y9T6L6jpHWlCH56+xZLsTbOfbMBal9F9yAai+5duScCxjoI9EEf21FqsT0gWsBmoqHPIFiS7gG7rqfbB4S/KBf4I2jT9LKRp1hxhoFU7BC9hXWo95f4fvkhHUE9T8ti4Jzsie8lmE7yFTCNOWvs=
Received: from SJ0PR05CA0170.namprd05.prod.outlook.com (2603:10b6:a03:339::25)
 by CY8PR12MB7097.namprd12.prod.outlook.com (2603:10b6:930:51::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Wed, 26 Feb
 2025 09:08:30 +0000
Received: from SJ1PEPF00002322.namprd03.prod.outlook.com
 (2603:10b6:a03:339:cafe::c3) by SJ0PR05CA0170.outlook.office365.com
 (2603:10b6:a03:339::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.15 via Frontend Transport; Wed,
 26 Feb 2025 09:08:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002322.mail.protection.outlook.com (10.167.242.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 09:08:30 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Feb
 2025 03:08:24 -0600
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>, <naveen.rao@amd.com>
Subject: [RFC v2 09/17] x86/apic: Add support to send NMI IPI for Secure AVIC
Date: Wed, 26 Feb 2025 14:35:17 +0530
Message-ID: <20250226090525.231882-10-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002322:EE_|CY8PR12MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: fd322955-9315-4a07-536b-08dd564523b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p4jm1eupGXhXKFxWWZe2LBghdj590KQVAuoujwZII6uDdnTQlHOrENshFtzD?=
 =?us-ascii?Q?kdm/2R4ESne4EmAEALInr0evlvSE5+PDiA8rePnP7Fiob+pK9jkHX43ivJpB?=
 =?us-ascii?Q?FlDsRFyIklM9MsTyhKJ1Mp+dc36Gun/IS12LVa2mP7nn61rPVvkD2hXJiDrW?=
 =?us-ascii?Q?ADJMghVDzL96wOlXEJfg2snbrAql23zEQ5vvKeiPNj+IXUMnmbfq37Y5Tvej?=
 =?us-ascii?Q?vtAh9jR+rEEbWyR+5zFlI7N9LtJ1iPucuKkS6K0uAWkqNMDYP6NMOaX6XW9b?=
 =?us-ascii?Q?63WotkqvgQolHakbA3upjG6GV2ZmypnImW2s9CJOiadvU8+y4cYdNlZh0lLz?=
 =?us-ascii?Q?CmWTEbw1AYngRdUUEARIkDXHwlIn6WIemO1YB++KsI8udYsNsvH0w5uwiDYR?=
 =?us-ascii?Q?Nv7q9JiZom3g4dDB1QdWCZOsrQXWFj9rNJl2u/4wZTJP9eexShkqdEeuUAVs?=
 =?us-ascii?Q?87QC6cGAYanyhxZNmPxqqCt1rJC7dWAqkBnkgjlqs7NB2rPc2DLh66/X2jdQ?=
 =?us-ascii?Q?8InsYMJoAigt4XLCDkYJ1hgsVsgpqrnuUp6BsPnOAUtUo84NjJEmrLVYVBay?=
 =?us-ascii?Q?z5MkCwWFmbPBT+Db3ZzSAHFMM5iUH+9cgovMLr3T05ZLx+0Sx46+Zo4sTmAc?=
 =?us-ascii?Q?ssDDFxE3eMaP0TWIg5HLbkzC2B6LjKEO/I7vQNAYNKYJYLJG+FRgElnh8jh/?=
 =?us-ascii?Q?3gXFx/u9kwqfHHAkeevcfyHbN1DqIyNEaxsie2/Ovqg4Tjy4qoXYnqmN/mlE?=
 =?us-ascii?Q?ASK/jKkinukDjn+Lx2oyAJKgC8V/7NCXPZ5Ov3meLcS4kMRWqotXYt057f1t?=
 =?us-ascii?Q?SFOH7Wwh+CVH9kOY6NLD4A8OsZYsef9qK1qno/UC6nJpAE0PxpD7DanSTQq/?=
 =?us-ascii?Q?CBM7/VreP4Y96VounZedAPoK+tiObjoBxiCzx0OLia1o6Q1Rup1l/N2BjKjm?=
 =?us-ascii?Q?MzCOXJrzRWfn7LHXmnmdxCmF3Y5AMM6cKItJv+BEHj3TucjIQZ8qtV8NI2o8?=
 =?us-ascii?Q?YNoc2dbDqGavyx26EURpbH5B31JJGfOzti4p3rW6Sxx5qicxHqHTIJJZd0w+?=
 =?us-ascii?Q?tsRuhye1QOas40hGre8CWx/2NA5EOyUWC6OZAYBQ3dV0groPyNlquByWQZ6/?=
 =?us-ascii?Q?MBu59ZOawidwllTMQExP75nksQVuU5IJ5tfwwHkNwZu0BTPb3kYyp5bZchsm?=
 =?us-ascii?Q?fY+7n6KSYr9jQ+lExfhyBKkK5oEdgEGIwRyaizDdAHaTW1sbixTAuiy4HU6t?=
 =?us-ascii?Q?1hGs73koMyqeK62C7C26JoKAjdM8ayE6jjlmjsuBzSrQc99Eva42RCaVqS4D?=
 =?us-ascii?Q?AyihSuc3JFnUTCPwLo2Ga5CvdqXyBP4CKBFfmIPJscfTFoloe/gJbmsQOJvl?=
 =?us-ascii?Q?NliJz0289AdiMIypziJBqbevIXCGQ6PyiXxlcsQpp9ox9YeRMA3vpMArOwrj?=
 =?us-ascii?Q?iYjis8b2ZKP0RYZFUXt7vJO4b+iMGmX23Zyl6n8T8DJay0FrRwDjLMWBg1yK?=
 =?us-ascii?Q?dCfvr4vf7TmaMno=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 09:08:30.6668
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd322955-9315-4a07-536b-08dd564523b4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002322.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7097

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Secure AVIC has introduced a new field in the APIC backing page
"NmiReq" that has to be set by the guest to request a NMI IPI.

Add support to set NmiReq appropriately to send NMI IPI.

This also requires Virtual NMI feature to be enabled in VINTRL_CTRL
field in the VMSA. However this would be added by a later commit
after adding support for injecting NMI from the hypervisor.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v1:
 - Do not set APIC_IRR for NMI IPI.

 arch/x86/kernel/apic/x2apic_savic.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index af46e1b57017..0067fc5c4ef3 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -162,28 +162,34 @@ static void x2apic_savic_write(u32 reg, u32 data)
 	}
 }
 
-static void send_ipi(int cpu, int vector)
+static void send_ipi(int cpu, int vector, bool nmi)
 {
 	void *backing_page;
 	int reg_off;
 
 	backing_page = per_cpu(apic_backing_page, cpu);
 	reg_off = APIC_IRR + REG_POS(vector);
-	/*
-	 * Use test_and_set_bit() to ensure that IRR updates are atomic w.r.t. other
-	 * IRR updates such as during VMRUN and during CPU interrupt handling flow.
-	 */
-	test_and_set_bit(VEC_POS(vector), (unsigned long *)((char *)backing_page + reg_off));
+	if (!nmi)
+		/*
+		 * Use test_and_set_bit() to ensure that IRR updates are atomic w.r.t. other
+		 * IRR updates such as during VMRUN and during CPU interrupt handling flow.
+		 * */
+		test_and_set_bit(VEC_POS(vector),
+				 (unsigned long *)((char *)backing_page + reg_off));
+	else
+		set_reg(backing_page, SAVIC_NMI_REQ_OFFSET, nmi);
 }
 
 static void send_ipi_dest(u64 icr_data)
 {
 	int vector, cpu;
+	bool nmi;
 
 	vector = icr_data & APIC_VECTOR_MASK;
 	cpu = icr_data >> 32;
+	nmi = ((icr_data & APIC_DM_FIXED_MASK) == APIC_DM_NMI);
 
-	send_ipi(cpu, vector);
+	send_ipi(cpu, vector, nmi);
 }
 
 static void send_ipi_target(u64 icr_data)
@@ -201,11 +207,13 @@ static void send_ipi_allbut(u64 icr_data)
 	const struct cpumask *self_cpu_mask = get_cpu_mask(smp_processor_id());
 	unsigned long flags;
 	int vector, cpu;
+	bool nmi;
 
 	vector = icr_data & APIC_VECTOR_MASK;
+	nmi = ((icr_data & APIC_DM_FIXED_MASK) == APIC_DM_NMI);
 	local_irq_save(flags);
 	for_each_cpu_andnot(cpu, cpu_present_mask, self_cpu_mask)
-		send_ipi(cpu, vector);
+		send_ipi(cpu, vector, nmi);
 	savic_ghcb_msr_write(APIC_ICR, icr_data);
 	local_irq_restore(flags);
 }
-- 
2.34.1


