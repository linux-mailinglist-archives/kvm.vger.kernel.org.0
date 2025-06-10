Return-Path: <kvm+bounces-48840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A3A9AD418C
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:04:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1AFC33A846B
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DCA0245035;
	Tue, 10 Jun 2025 18:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="E3e+8SXU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2068.outbound.protection.outlook.com [40.107.236.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7942367CC;
	Tue, 10 Jun 2025 18:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578623; cv=fail; b=RPOZXAwBEDkjE+EyZW79vutkr+Y691LyM9TgoURFUWBWU+VWLKMSOzUntvtWihgxJB7hDmttA8RKtqV3NPkaXMK3Sh9pESsMv4UPIcmK9sW1OCOrtTiyrsA7/W19DRo2xm9azqj2IDCDrtFzpDzbeI6i16pSvkTJ3IyVhwIM9HA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578623; c=relaxed/simple;
	bh=5rXOctdqo7RuccW6hFtOlQERvrZm7LZ9/XyV5rhYDb4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mGYDiQsDAfVz+kRYoKQriC9ScOEhNweLryjX7iqk1qFa8oOnxj/MTpBKIuVrDAAt7CH8VjFdOoXjgF/ejMqVU8dTCjQdpd8bQlfpNV72kMGcilcdx2hOPLv6LWkt8RrKB6o47oX8G6FXetR/mZTA4uJqJR2OgkYsHTDgws0uSxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=E3e+8SXU; arc=fail smtp.client-ip=40.107.236.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SMXB13VQJ1KGlgK7avDYWgSUXCj+DHZhHQDcuym9goCPVRranQkqvgok3BFS80M7T4Au8Di2oiySMcy/SEShDJS8wS7DqPtmzO1tkTlJMPsnTelRN9TBM8TaRz1/E+LJFXqp0Zvxtdl4A+k4Mh/6EnhSW4AF5uwtmijILsBg83nVjYfWHrnZ9+AE5WSb8PBLtfI7/QFq8lw3ZPNB5acFq0+f9u0IxT7yqMTsjWWYGSyoA9wxNp8lCT6cPH9SmQJRasRuUYTlczymVKRoqEZhJjejKRU0fmxL9SbCfutzGkLyiXjbHiG53C+/t+YH4tOj4ZHHLafPwSPZKXq4TvGVXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcbF95X7ZNbzzfxqi2bMMwIogbp/xQ3tBom6GXKP/MM=;
 b=dJsHtGQtrqy0xBWTF0jBrlfErdm6/YM+3DLm2ApDDxObSXphKQWkCbgG3i8wp4IlSWZti60093YAaBJO5/NPJXw6Eg9AaGvPynW41m7lCeq3s2QUOGnw/9ro4y3J22yFaO8NHxa32CQjtEqaGt8RFszA2Xlhsno36xto7XAQBO2jLvI6FfTCqLU+C/NwY8mm59ITZ6iqtCmFG/yv2TFRN6OuoCY6Bsg9fd5JjjF2owA5za0xwKKNsg0dyR/R95RaxmcxT5wzgaDvs4965/Dsk6bMHzalohS/chkJtw/xJ5AHR5nD1fP9wuyRRSNsL/VVOZup5t/eP4FdkSrtqVqTSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcbF95X7ZNbzzfxqi2bMMwIogbp/xQ3tBom6GXKP/MM=;
 b=E3e+8SXUlmXv8PifP95+8RdALRaURcEA13X6CeKTAzW5G8DC3z19WywVjA7epNMeATH8lhM6HbdM/1ekwW/u6kwhE2rOwfiwTvTZpHMrGimtdyj/rQkMlHQ9kCanoazXTaX/XYlGf8whIHDPEqbAxV+e6jdbk12kkE/Z36d3lKA=
Received: from MN2PR19CA0069.namprd19.prod.outlook.com (2603:10b6:208:19b::46)
 by PH8PR12MB7447.namprd12.prod.outlook.com (2603:10b6:510:215::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.39; Tue, 10 Jun
 2025 18:03:35 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:208:19b:cafe::78) by MN2PR19CA0069.outlook.office365.com
 (2603:10b6:208:19b::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.24 via Frontend Transport; Tue,
 10 Jun 2025 18:03:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:03:35 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:03:26 -0500
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
Subject: [RFC PATCH v7 24/37] x86/apic: Add update_vector() callback for apic drivers
Date: Tue, 10 Jun 2025 23:24:11 +0530
Message-ID: <20250610175424.209796-25-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|PH8PR12MB7447:EE_
X-MS-Office365-Filtering-Correlation-Id: e6fe3adb-0531-4839-e676-08dda8491ea2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X8UnWrJLufnYGHhra1WocaaMIEHGZ0PfC1lWm0QeEZbJyPQd2pw8c2MELn3U?=
 =?us-ascii?Q?Mzqk4ebEU3teu6LZJtSbjfIxduzlI8/zd1kl2DVsjMrkTJMf/a9CMpxvF66b?=
 =?us-ascii?Q?JJ0mwHYpKNJhP3I5EKMHW5YpUUeX2tYnIARdsmGsURe+1GBaaGMD+TFtVsYQ?=
 =?us-ascii?Q?Oly6i5UHS/aduKosIfbhaDxA/acw9PndozPce83gGe2Xr2HJL3WG/hOGZ+8Y?=
 =?us-ascii?Q?P/wTMyfLJ1LlsvTB7TH2s8WLv+75gxSi7UomW0Z9QiPyf5qPgv/izge4SRFr?=
 =?us-ascii?Q?iUPSg6jRIc4M5jdnhFVqAlXp696XbKgzxpPZ+qQeWtGQq4+KgMmeVF4/Ym4J?=
 =?us-ascii?Q?Iyj0jq8R9zD8gI8hbWQBC8QhA1FkUb7F6Q0ZHQb8q6UsvsJcrm4lP7IhHX/J?=
 =?us-ascii?Q?VsjIkZiiWFYFADbPLMcv5arN7zZiF6DmF6qIfGAI4P9Qr2t5EOYhJcMKccW4?=
 =?us-ascii?Q?nuzXypy50ccT4izL9bwaYeAw0vHmrPQrcBjB0KB/oWVeFKt0bInpyh/LvEq3?=
 =?us-ascii?Q?pZGcG44xonPSpZzX1ScBcWZJ+1Y+wIQRtBI2igmolgb1D+sjmSa7kqLFWOZj?=
 =?us-ascii?Q?PUE/yFXeklgYSpr0mz4Dw+V5d4FWILNkia3LYeAukqCX/HW1sSCf3ZaWnExn?=
 =?us-ascii?Q?jORLhO1To+mUZQCn+r1kE6AOfeyVne+T++7NXzHImxjMjcQlekB5ogfEOrGU?=
 =?us-ascii?Q?KnaDKTct/lD0NxyR+rrHrfwRQ0fdKEgURNnU2fQnLhpeMkJMtbUXAvIJKv7e?=
 =?us-ascii?Q?5tZ+SurhEsITX36wIjq6fv/8UfI8mPM4px5R5r8F8BXWbJk8hBZsaimFhEzB?=
 =?us-ascii?Q?0b1IsGfcYAZwndMnYXfokb9Zw28YVpL/esWm3h5CA4UpVAyB1dSXIMMCuK9p?=
 =?us-ascii?Q?do9iF/T4qfDj9/QYJrOwp5v7X5jUFv3AiYc8y4djHR5TJ1aDr8Q3926J9BCF?=
 =?us-ascii?Q?W3udiI5VsINAbdpSjQ3iMMH6VfojaxkwOuy+DhWH0vx7ftFEVvtFHs0C86cK?=
 =?us-ascii?Q?VVJ6YBAgIEV+Q+p8zAV3KAahcnIpc125xja7T3z/ZICYSG1drWT82ozG9TTa?=
 =?us-ascii?Q?ekP4tfvtIOtGcv5F8R6/aD+Jwr4JXls5dE51ZCOTk3w0IQKOgw9Od7tfGt/k?=
 =?us-ascii?Q?diXdlrMfviL2+Mw4UtFJCIBrsmFY2HHQbxCpxwEbU6F2EofzyIb4S4H4zEPb?=
 =?us-ascii?Q?nBrz4+NR8atDnNQEcWt0RKiLSzHI5qFOw0+zDuxlQr4YDVVpL66LnwJDK0tY?=
 =?us-ascii?Q?/wNrQAizItACgqBjyTELUnaVor8VKy96H/1uawaXLGvULoAF0mkuZhsHNwfr?=
 =?us-ascii?Q?fXxfg2dgmGQTgA3HDAV6ArOawwaoE5WL1iuvQeu2hCqLCtZUoVmvMJyDtgML?=
 =?us-ascii?Q?nwsxQbTxJfLU9jrmXfLlsgYITXPdbby7aFpifqlfoWvcRyNR0PL3hushayG1?=
 =?us-ascii?Q?Z7t+R+cObm7W5cAYPmmSJLam+LcBhQklUDLpLuCI7j7XNaIry5okSWzDwzqp?=
 =?us-ascii?Q?uCLvN3JfixrI6QbQ0HqVeanXXhHDkE/lWH8n?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:03:35.5990
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6fe3adb-0531-4839-e676-08dda8491ea2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7447

Add an update_vector() callback to allow apic drivers to perform
driver specific operations on external vector allocation/teardown
on a CPU. This callback will be used in subsequent commits by Secure
AVIC apic driver to configure the vectors which a guest vCPU allows
the hypervisor to send to it.

As system vectors have fixed vector assignments and are not dynamically
allocated, add apic_update_vector() public api to facilitate
update_vector() callback invocation for them. This will be used for
Secure AVIC enabled guests to allow the hypervisor to inject system
vectors which are emulated by the hypervisor such as APIC timer vector
and HYPERVISOR_CALLBACK_VECTOR.

While at it, cleanup line break in apic_update_irq_cfg().

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - No change.

 arch/x86/include/asm/apic.h   |  9 +++++++++
 arch/x86/kernel/apic/vector.c | 29 ++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 184cae6e786b..9c74d1faf3e0 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -318,6 +318,8 @@ struct apic {
 	/* wakeup secondary CPU using 64-bit wakeup point */
 	int	(*wakeup_secondary_cpu_64)(u32 apicid, unsigned long start_eip, unsigned int cpu);
 
+	void	(*update_vector)(unsigned int cpu, unsigned int vector, bool set);
+
 	char	*name;
 };
 
@@ -471,6 +473,12 @@ static __always_inline bool apic_id_valid(u32 apic_id)
 	return apic_id <= apic->max_apic_id;
 }
 
+static __always_inline void apic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+	if (apic->update_vector)
+		apic->update_vector(cpu, vector, set);
+}
+
 #else /* CONFIG_X86_LOCAL_APIC */
 
 static inline u32 apic_read(u32 reg) { return 0; }
@@ -482,6 +490,7 @@ static inline void apic_wait_icr_idle(void) { }
 static inline u32 safe_apic_wait_icr_idle(void) { return 0; }
 static inline void apic_native_eoi(void) { WARN_ON_ONCE(1); }
 static inline void apic_setup_apic_calls(void) { }
+static inline void apic_update_vector(unsigned int cpu, unsigned int vector, bool set) { }
 
 #define apic_update_callback(_callback, _fn) do { } while (0)
 
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index a947b46a8b64..655eeb808ebc 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -134,13 +134,21 @@ static void apic_update_irq_cfg(struct irq_data *irqd, unsigned int vector,
 
 	apicd->hw_irq_cfg.vector = vector;
 	apicd->hw_irq_cfg.dest_apicid = apic->calc_dest_apicid(cpu);
+
+	apic_update_vector(cpu, vector, true);
+
 	irq_data_update_effective_affinity(irqd, cpumask_of(cpu));
-	trace_vector_config(irqd->irq, vector, cpu,
-			    apicd->hw_irq_cfg.dest_apicid);
+	trace_vector_config(irqd->irq, vector, cpu, apicd->hw_irq_cfg.dest_apicid);
 }
 
-static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
-			       unsigned int newcpu)
+static void apic_free_vector(unsigned int cpu, unsigned int vector, bool managed)
+{
+	apic_update_vector(cpu, vector, false);
+	irq_matrix_free(vector_matrix, cpu, vector, managed);
+}
+
+static void apic_chipd_update_vector(struct irq_data *irqd, unsigned int newvec,
+				     unsigned int newcpu)
 {
 	struct apic_chip_data *apicd = apic_chip_data(irqd);
 	struct irq_desc *desc = irq_data_to_desc(irqd);
@@ -174,8 +182,7 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
 		apicd->prev_cpu = apicd->cpu;
 		WARN_ON_ONCE(apicd->cpu == newcpu);
 	} else {
-		irq_matrix_free(vector_matrix, apicd->cpu, apicd->vector,
-				managed);
+		apic_free_vector(apicd->cpu, apicd->vector, managed);
 	}
 
 setnew:
@@ -261,7 +268,7 @@ assign_vector_locked(struct irq_data *irqd, const struct cpumask *dest)
 	trace_vector_alloc(irqd->irq, vector, resvd, vector);
 	if (vector < 0)
 		return vector;
-	apic_update_vector(irqd, vector, cpu);
+	apic_chipd_update_vector(irqd, vector, cpu);
 
 	return 0;
 }
@@ -337,7 +344,7 @@ assign_managed_vector(struct irq_data *irqd, const struct cpumask *dest)
 	trace_vector_alloc_managed(irqd->irq, vector, vector);
 	if (vector < 0)
 		return vector;
-	apic_update_vector(irqd, vector, cpu);
+	apic_chipd_update_vector(irqd, vector, cpu);
 
 	return 0;
 }
@@ -357,7 +364,7 @@ static void clear_irq_vector(struct irq_data *irqd)
 			   apicd->prev_cpu);
 
 	per_cpu(vector_irq, apicd->cpu)[vector] = VECTOR_SHUTDOWN;
-	irq_matrix_free(vector_matrix, apicd->cpu, vector, managed);
+	apic_free_vector(apicd->cpu, vector, managed);
 	apicd->vector = 0;
 
 	/* Clean up move in progress */
@@ -366,7 +373,7 @@ static void clear_irq_vector(struct irq_data *irqd)
 		return;
 
 	per_cpu(vector_irq, apicd->prev_cpu)[vector] = VECTOR_SHUTDOWN;
-	irq_matrix_free(vector_matrix, apicd->prev_cpu, vector, managed);
+	apic_free_vector(apicd->prev_cpu, vector, managed);
 	apicd->prev_vector = 0;
 	apicd->move_in_progress = 0;
 	hlist_del_init(&apicd->clist);
@@ -905,7 +912,7 @@ static void free_moved_vector(struct apic_chip_data *apicd)
 	 *    affinity mask comes online.
 	 */
 	trace_vector_free_moved(apicd->irq, cpu, vector, managed);
-	irq_matrix_free(vector_matrix, cpu, vector, managed);
+	apic_free_vector(cpu, vector, managed);
 	per_cpu(vector_irq, cpu)[vector] = VECTOR_UNUSED;
 	hlist_del_init(&apicd->clist);
 	apicd->prev_vector = 0;
-- 
2.34.1


