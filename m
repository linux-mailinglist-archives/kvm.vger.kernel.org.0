Return-Path: <kvm+bounces-46448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 529D2AB6445
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:27:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92878865743
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9DD5212B18;
	Wed, 14 May 2025 07:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SPRPQPoM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508221F4639;
	Wed, 14 May 2025 07:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207582; cv=fail; b=gGIfGw43oL1DfqhsHcV9NGdKGnqppP6mqxZ5S+GHwKj9aTyoJEwBgEnnFtShW+bHjpEGPn5V7JILFHjwVOM377deVqLDkYhRVkAXhw6RAqaZdiHHoSaefE21qF2gHNT8oOv38Qr4Yj528DODDkN0PxYGTbakwh90Jl+59M/sWD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207582; c=relaxed/simple;
	bh=RXcjQ+qMmN5gheEJEvxDtprU9dRqxv6zkQQnEl5Q1uA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FX37sKV2GYc76VA2BZIyJoujmyTc8jEn/YB7aU6faZ2DW5760KYcaWrYSVN9LaY/olT1sUxdTC/cAxfgZsRSRK8ZcrXCWIt1Z2Pg17ZkqHbFPYNlBsGM8iQFXXEc6YxUxrfZ7PcGlGVp5ZujzymJYrdtXNV2C4f6VaMmgH3chIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SPRPQPoM; arc=fail smtp.client-ip=40.107.243.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rWBeAF/e4fCwJH1PIXffN+5aD1S84RYIV+077Q7yImxABeq3hJq3J0B7fHtK4HCOuf9OXToGYOLLIO5GPkrpo0E/B8aCPMfMLR5yBJdSJBnyCFokSJJ5SpGVoIxAMfxOGYvfG4Ee7T8amYXLB7qkxSYRsPt5Ks7Kc7ekVuaEeiszAhG6KUuIsjv/K6H7yqGnf5wpPs+/b93YhQVNJIzcfhY1qL0tlfNnhpcMbCNk/e+GZ2bBDwYJPEOXbUGu8+XkjllRsSTTvwKdlLkGKRt35tD+z1qDMn5VOCS1zvh88vIGYlnA7+Cfa99DzDKZlMLQMYq/y5FUz0b6j7aBc1WbRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3YttdV32gpKlihISOUWTasmn4TKzwYpNWZWvmNyPkac=;
 b=CPB9KZedLjHOkfTTH+007IH6HDt5GZ66feItYq5Kdx8vnOjFAJIb+lRgiH631QhLeMMLb1lO4wxlm/S5g/LVUmDb+qNCtQ5yTHPL0/8SdZdhXq1wG/O39WxPkj1eWRazXBf+UATqMKmZWhms+KI3PfJGc7nr7klyPfJK7vrqUnMOszxbrHgxOcZzDLphUmAUg6DFYRq+9EgR5/lJBuzSqeNC02j1HLXwAfzXhL8vsSt6XCfbVl6u+jPCxXPxyhK0xmNxoWU3Vn0uV6oacH5v6NX7JzoLXIQaRKq01euqulxhhbU6/1KUaiASIyoHO1pc1g3HrX4boLtNbXLpGqO7SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YttdV32gpKlihISOUWTasmn4TKzwYpNWZWvmNyPkac=;
 b=SPRPQPoMLu8TPsudHHelNQ7jgXIrSO5IpVVUKE7qin17fSoWnsed/NW4+lu4gxhbpbBOrYOfD0QAJrlGSIu/59ClADvaIcgQkRFrjg5imvFCqyFl/3HGJMNm8YFsWkQA9OgglmvUmwBBEdpTUo/RS3e4WrCV4af+af3YRK/+1G8=
Received: from BN0PR04CA0200.namprd04.prod.outlook.com (2603:10b6:408:e9::25)
 by MN2PR12MB4304.namprd12.prod.outlook.com (2603:10b6:208:1d0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 07:26:12 +0000
Received: from BN3PEPF0000B071.namprd04.prod.outlook.com
 (2603:10b6:408:e9:cafe::35) by BN0PR04CA0200.outlook.office365.com
 (2603:10b6:408:e9::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.20 via Frontend Transport; Wed,
 14 May 2025 07:26:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B071.mail.protection.outlook.com (10.167.243.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:26:12 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:26:02 -0500
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
Subject: [RFC PATCH v6 19/32] x86/apic: Add update_vector() callback for apic drivers
Date: Wed, 14 May 2025 12:47:50 +0530
Message-ID: <20250514071803.209166-20-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B071:EE_|MN2PR12MB4304:EE_
X-MS-Office365-Filtering-Correlation-Id: 502caab7-6e5a-4f31-a93d-08dd92b89abe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TixHlxgXEMsnz3R0tvVtKj68lj5OGD1lWTJ69Laz/POln6Hqw0Qdb5cQY6fS?=
 =?us-ascii?Q?rSNof1HMJ7nsfqlOnN1AOJu4B18JUJSgeFJ0wK44Kssw2zk3gbkeZM3d0S5+?=
 =?us-ascii?Q?W/cPNAYpZ1T4xkq4msKVZnMdPusG5FasYogQD3ByzpzmYDhgUeLkA00ixV+w?=
 =?us-ascii?Q?m3Rjh8Ir0uBap0YlTNub6wye/XEqvmJyCN6xrVNuLs2luGM4aVgTJd+4C4mS?=
 =?us-ascii?Q?XnjtJG3EkATZyTVlmdysZczcxTN2tFb3+Cza0/shZL9gbzv+/OowNJF6U1v2?=
 =?us-ascii?Q?tW5vueWXVgxYyBElztf7lMAXKSmfTO6JUF+xR/IpeXf0TBFm0DJdS5963+li?=
 =?us-ascii?Q?UhI5s9ZNUjV1KDPMXILwybsqriLcrSEuFa2vrJ1HRYHVhI03F2cIVTLyWhK+?=
 =?us-ascii?Q?p0MgPBB3WkUvbgaCVuat7SbqQebJ9c8iKXyB1fMa7ZV7vlYCjmzc/5fI8YIg?=
 =?us-ascii?Q?uWP2eV8ltBWByda5gb4Ks3tndeqcbJ1TT0yEiYqbXkjFb8y6c7oipI+z7d1p?=
 =?us-ascii?Q?f9w0yJw983MDpuJJGSOGUuj+15tqt0LcfzLP/mvQt16fm9ycZfuEJZMwwp5r?=
 =?us-ascii?Q?23jSr76M0EdofMCuQD8164Zj9jf4wGboMeAcENwVeQOQcHWrNSQSIZwBv5xF?=
 =?us-ascii?Q?Jne3i5eiOt0sDlg6qQuxrU9MJAeIe59Us9HwphKFf6CPVU2bdOf3uA9QftU8?=
 =?us-ascii?Q?DtQjfFbe9MicMtY2Utfy3xbePaJWPEtP9lBZI5sMDtfb7bfSYCaQqa4FTEIA?=
 =?us-ascii?Q?xNKYBH9tPDbqN1l52gfAlG20tVttuqLXq52/G3F6BdS5ZtYHYdDTsG5bmf2+?=
 =?us-ascii?Q?cXa26PxyYdTKe8PUGx2vsieYonDoOmrLhhCw65JlBWlielwCf26Nq0MzUdpg?=
 =?us-ascii?Q?4bZeXiD+qkDk8XFWCx3BoyqfnWeTPD/1YpWfM2N1hQeKyeixk/Ju4LqBkwXj?=
 =?us-ascii?Q?HxwIdmxsQZamHo4uJws6vUjmbXxemK7BS0ZnIJtivuOmXzH7adfYfWz+xnZW?=
 =?us-ascii?Q?x+Z+5fVk5Oj+sH/TrJmBiM6UkcNwWzlz0S8v7R/EShbbdNvqSIxOxh8mPEP7?=
 =?us-ascii?Q?ER7qHYUTCj8eWwo7aC9d+sE63JdgkssYJCGK/t45mls/DbTJgXzAM5e12dj1?=
 =?us-ascii?Q?EeDSJ5sxxRhTCT5YsMrCjzGYR3bDy4YZUIHjQZAUh6lTYhIaHe4HV40Qw/8q?=
 =?us-ascii?Q?u+42Ew0o1wxfrz/MbVyswJ2yQ+8Shy0/4TemADdy9T/iUGCGoZxIAl0K5NuE?=
 =?us-ascii?Q?bebF9XS/AeW5qqIL4aVk64VEQurZDiCtkn54PHV0qRPM136FnEVfwWm18HIF?=
 =?us-ascii?Q?qKCllLa502YfLhdi/vgNxhhkNESuXCr3Uk4N5SIIRjihUnvVxnmhHmr5SvMc?=
 =?us-ascii?Q?OIj4lDoBeDvtkJhQqx4gDKnqUNBLOD8RpXum69oZFQLwSJv/FblAeaKAIR+v?=
 =?us-ascii?Q?9fMkir8jpslSu2C+K4OS1Df8o34ka5iX76WmfMEx9T6RuudCbqYkXkFvd9OO?=
 =?us-ascii?Q?pzwYbxwBLAJSCUqIUqGo0w9X3t7wcYPoNlHV?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:26:12.3881
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 502caab7-6e5a-4f31-a93d-08dd92b89abe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B071.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4304

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
Changes since v5:

 - No change.

 arch/x86/include/asm/apic.h   |  9 +++++++++
 arch/x86/kernel/apic/vector.c | 29 ++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 926cd2c1e203..49abcd85d2f3 100644
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


