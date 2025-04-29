Return-Path: <kvm+bounces-44695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5A51AA02C9
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:15:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 023903B8556
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 06:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F30132777F9;
	Tue, 29 Apr 2025 06:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="L5vJwBZ5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F45270544;
	Tue, 29 Apr 2025 06:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907193; cv=fail; b=rexWtmtFoq4h4iseFZJvZ9O5H4HaiMaIw4+l0H876SPWpuzeBsYPutd4IyJ0dFbI7raqchPzKxiOl+Q24Bi1bi8C3MKkdaSsZrUpqFstHfvg8ApjA3PQze6oegy7ox8O54cuSrC06G3fqn4j0QCAjiG1wDw4i4cwzxKqC9a6yiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907193; c=relaxed/simple;
	bh=Sd8W4WC6C73BsC2I8Wsu3tr2VpSypnIXUxAHwHMKn94=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HmnZapvs50tMkJTKLyPgAMH7qw9c0zlcsCcpzCkhVDM4JYU6azv8X/qzQT7biEoi2gNAMzpAQCglibElhpPS260JqEbivXag2YHJHgxMZiOTqjAoDeh1AcLBf9dZWnQ5+YT4UFekvJsInBTzT2UWYbEjtinBjGTkRLL2qBDjRVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=L5vJwBZ5; arc=fail smtp.client-ip=40.107.237.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cnHcl//lSFy+5SvpSS24cJ/8vo4XzM7y/LRdINjWJAwOmCzssvYTVT4gYnFpz0l0a9DmQeeHjVHPRchnRQDBElb2JYLlWag/MHh4hXvdDuiHjk9sFdpHWUHhS4RpB1FnUj7vzb0IeT2DCgBy3c4JmnxOlgN9gRxBalQC2yzqBfmvNzG7YM/UoPyw0J69ldds+CKpthwO5Cb8yZYT41soWaKVRaqZSkYq+XBIWE+A6XQ2k82c9DzPPNDQeoQSJ0MOthjICVBPpWsC0JsVQEc9bPYdura2qzPO2FAo+mq0fRY7KgvPcV+x2PgNkeklAp++fI9bShCp6BFixPrM0caOQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+svRvz1p62egVWWTd6n8/mcGj9fd5R223mR6J+9XQwc=;
 b=BlPVLXe/v/SZfnqAsJD2e8UUOsMVC3VTtj+ZiHO8b8B08mGKDJXjXx6GYS5g3qn5QqqcGXP+VC2XK9C4hohFO1IZ+W6hu27cAtJptoUG1oyJbIQD8V/+dVY3KJ7nuEnWnVsjWoJOgqgYt3ZAvYDdsfm+uJLZqJfhQPZ6FZVsmpmt5ceuKjQ4frUO50L8wkJJMwW1UvjswM1nX6DhHCvO23FIRC6QHlZOcnCUA0xgmKFa7BSOlhdxp4urGtEz+Q3fLzFbd1uF8Tm/C8CnTJVRgrCzV7Q+FGJ6l0pUWek0YkIbKAx2uXPldAO0+alJTl73TxTPQ/O0vT45df4hBnLpqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+svRvz1p62egVWWTd6n8/mcGj9fd5R223mR6J+9XQwc=;
 b=L5vJwBZ5KxPQLpy4qNEpZatAlA+7eUaic9fP/5h9Eb4It9czYYYjXli/UX3sgmLRshMWoJN2APFhu0x3VHQ1mF8sQYNxTBaG1YGj3immlAVuheId3wEQxn2m9AC1bNaQVBDJUZ48scrTMSrFo37O750+iX1tB+kbznjNnccmv9s=
Received: from BL1PR13CA0418.namprd13.prod.outlook.com (2603:10b6:208:2c2::33)
 by CH3PR12MB7691.namprd12.prod.outlook.com (2603:10b6:610:151::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.34; Tue, 29 Apr
 2025 06:13:05 +0000
Received: from BL6PEPF0001AB55.namprd02.prod.outlook.com
 (2603:10b6:208:2c2:cafe::99) by BL1PR13CA0418.outlook.office365.com
 (2603:10b6:208:2c2::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.15 via Frontend Transport; Tue,
 29 Apr 2025 06:13:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB55.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8678.33 via Frontend Transport; Tue, 29 Apr 2025 06:13:04 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 29 Apr 2025 01:12:57 -0500
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
Subject: [PATCH v5 07/20] x86/apic: Add update_vector() callback for apic drivers
Date: Tue, 29 Apr 2025 11:39:51 +0530
Message-ID: <20250429061004.205839-8-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB55:EE_|CH3PR12MB7691:EE_
X-MS-Office365-Filtering-Correlation-Id: edac3851-9986-495d-f263-08dd86e4e758
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MCSgxb9WpQjNSupI8ADo9r564Urd4XJa/mh/uMKG86srCduUPU14VxXXd/s/?=
 =?us-ascii?Q?uRHjHUKrsof8P6giVghXpeA1b8eV5na5U6QrJXipf/9w1ZtkBL5tzLEkDhwA?=
 =?us-ascii?Q?iZv7Qo1u6uZa67kqMuCwf93EPEKbawtxHVM2VLV4JxgbfxMsqSWu+PUF5PfT?=
 =?us-ascii?Q?JD+qXdFvip+95Fy7gGAhB7uQkMDm6muVqBHmibsPPREZ7gNNmXdHSta5L6lX?=
 =?us-ascii?Q?+a+brCnJs1qjhqCBRnf5gHThFQ8FU5qKCjw3WqroNE9uKo4+NUspass6Pob5?=
 =?us-ascii?Q?lUVWXrktv1ffmMRIb8ZS2qSi1oNg/izhWB/sJFSDoEmKLSLEkTUKG/S7+no5?=
 =?us-ascii?Q?GOfLf6JpatBCqKam5Edv1vbL3DnrAv/VaGA81+djU+5H+MMZoE/KrVq81hOd?=
 =?us-ascii?Q?anaud0Sd16/KU8w25W7cOq3Hx/gM4bJgLB0gVNprKCk3KykeW+eIY0h/WOOk?=
 =?us-ascii?Q?6klqHPLgN0BJdOGerZJeYJHviop9zwSha0WJ3ybug7YBWxaifmOv+N0K1QvT?=
 =?us-ascii?Q?qUoKYm3maaQDa5DiMH8vmgZnc3/BECJDZIDBQju/DY+0/m3EMwwPB1Dochs+?=
 =?us-ascii?Q?62KiqBpImt8Wd3ResaF/RH2i538F4ZPeE/6vhDj5icasG9uRsBYTQFuTBfpI?=
 =?us-ascii?Q?89G8AbX8m7jMuj5X6MOZfu7ntworeu1huqDWTvMDsveH6xtrT7byxGmAfgU1?=
 =?us-ascii?Q?WvbR8m2er/ySu7NoRDeMNwM4OR6P5jdiQj+CweWzRhzPwp1X8bWB6d6bO0x3?=
 =?us-ascii?Q?fItR1UYlU++fYg/K3iAKAyRBiEyKUuG9V0HoS2jKhpPutXgPIS74Bwct1XRo?=
 =?us-ascii?Q?jm1Gdn6qhFClyTNmQdDDRA8El8b31PuT+hLAMX20kZNueFhPu4gxZmZiu+7/?=
 =?us-ascii?Q?ZFgLOy8guo//R52lJJtUWHbkJ0JW18DbsVap2JtoShbk7eJm9zeGj6WcXkwV?=
 =?us-ascii?Q?0Zdkt7O4E0kVRrK+Yi3oqbYl16fSS7GmgNP8IqojanZL06Viyn+aBNRYlhJx?=
 =?us-ascii?Q?aCreWGZrdY/FpRPumDAl0eYabtwXXvplTlPsNf3BL38tWWBHA6+FLCmZm7yq?=
 =?us-ascii?Q?loJflSemnfRZZNAaMJt38S6jryOJR1Tg/D+ozA0rfEnJhc0sMx8Zf3Rwfr3Q?=
 =?us-ascii?Q?KVl3riK/x2eJNwM4lcsDdvi9t8S/bEtqXOfYY231yFbWyvzTQ57SayWROihM?=
 =?us-ascii?Q?8Hxi90z0N9z/tuahpcYDEqEVICNqwNGADrwyK5L42/zWc5YQsZzOgOQONcqF?=
 =?us-ascii?Q?uVLqz27bmOmgyfRhZVman7q+1I2e4UdDHErih+xd3Vk5+0AijQBO5MubTR2j?=
 =?us-ascii?Q?gWj9V+ONEA3joetFGj2x68hCvmFuHtES6OXMjkM450lxbrc0v68bcktgN+u5?=
 =?us-ascii?Q?4cND08Oo14ihdfcWVGsFKZv6SGfhl5TtEDQJ9ow4372xrCAMUs9HRm2YTvU6?=
 =?us-ascii?Q?ZauvQuiovDWGBsFARZa/j8hYsiKnShK78QdbecNVeg6tRFPDqMFV/J1+L/sQ?=
 =?us-ascii?Q?f5UZ4PLeag0btGIcrICgUGwr8Rv16iv7O89/?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 06:13:04.8066
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: edac3851-9986-495d-f263-08dd86e4e758
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB55.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7691

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
Changes since v4:
 - Separated out generic update_vector callback addition code to a
   new patch.
 - Removed irq_alloc_vector() and irq_alloc_managed_vector().
   Moved apic_update_vector() calls to apic_update_irq_cfg().
 - Renamed irq_free_vector to apic_free_vector.
 - Commit log refresh.

 arch/x86/include/asm/apic.h   |  9 +++++++++
 arch/x86/kernel/apic/vector.c | 29 ++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 562115100038..c359cce60b22 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -318,6 +318,8 @@ struct apic {
 	/* wakeup secondary CPU using 64-bit wakeup point */
 	int	(*wakeup_secondary_cpu_64)(u32 apicid, unsigned long start_eip);
 
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
index 155253af3deb..e1f570aed9d2 100644
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


