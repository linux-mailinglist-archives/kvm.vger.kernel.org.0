Return-Path: <kvm+bounces-51856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84ADAAFDE5F
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DDC93A1B94
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D27E0221FDE;
	Wed,  9 Jul 2025 03:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lKcaenfT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C5F221FC4;
	Wed,  9 Jul 2025 03:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032392; cv=fail; b=UoQjQHcJ+MvayaFRORgDSy09EahQ6An9/HblbC/nlUO2ESmoTJ9K2R1XbEB94K00+Q7tZXHbhIr0qkobUOQx8hSdvrJyc5Gh8PY5FWzdxn/HqvHbUVLMtWBeWBa+O1Y40P7va3couheS12vHqVWHvoDvare1/4aPzp5Px1pPiSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032392; c=relaxed/simple;
	bh=xIsVxBu+xDyBq3tID9bSe1uqbcqEHdarvFk1uBnJNZI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XqzlwTq1RDp2x1UY+Zr4r+QH5bpWFzkSV3FWa2U9U2wi0vSMH/t5RqLInc/l4NJN1NDfqOCMKz12K88nTxLOMvBlc5sKvIvAubocuBMQEaYFsHAwc8JSYuW7aO7MZKSp/HFO2Nxp8t7AW3DqH1o2AEQBNaQh+usKsGrPuBTj5NQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lKcaenfT; arc=fail smtp.client-ip=40.107.93.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8LTYgqIBQFSAQPdPG7QlxvpyTTgfK0BEljQ2Pgvx2I2WZtcG5IIt6nzzU6Ok6PuiGoaRKspDVWf2t1wuERP2eetlLFcU8rqjyH7SlTTW3tC5xGtYZtIPtOrR7uZhCUeiF4PbN/xfMVNopM/4QWZKdEvY999bu+VoMAQB7kbOACzE7fBz3q13wDG2fpkvM54S37rDMRi+FtY/c+9gKdqthWskY29MXb9o7QVtsMK2T09mZfqikpMrx/BVzzv1zYIftD4LmwrKCYPjMSAtOuWD6C+p3vrBtTDkoCbGrCyAt1WotidOiLP5osBfDDD91klT0qbPdNw/zGHlrSsdAdYMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAoWVQ2PTHI64GTKBwPj+at8l1Noi4Ly28CL6RTVWxE=;
 b=cEyx2pcPaunIBVi5Re9iQ77JgKUq90rgbF06KWB4yWLu2a2KdA7wWN4rnl02tcoe058DTlU6gQ+05wZivhOO05eBmpHkuU7W7tUbQWsRhqM5rVXUa+BLdxgiTGLKC+t78MEcu++57jgr1Eef7cQxFphDVpaeBVELRNn7bi6Bj+gZQnw+HMyTRRhGFG0HfJJ6xBHJf0snV025GsSuEYYYvSA7RrzSexphuxRC+svBYtJ+7ZSy3cLOC+PjVYlfdJKvv2cWEb5fHWGE3OIxCsq7E8CnIt7Pou2TetvkmABMd+yRIlYVJQ12S6n4zK3ET7/o/XnkanQNFVDhMXfIUiUIcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAoWVQ2PTHI64GTKBwPj+at8l1Noi4Ly28CL6RTVWxE=;
 b=lKcaenfTsWtTZuLzdOdR6g6iQbaGKxMJnjaSfYIOW2XDQUth5AuFr5JocHejre+J/iPpAibRmTi3ecXwwwDDTgrhB5C49VMIfjEd/X8dUeK5eB1b4wRv3HxZRjcyuiYDy6aQUBkFrPIMwIDKzTt+Mvai/X8k4jow2mJ3SL2Hrfw=
Received: from MN2PR02CA0023.namprd02.prod.outlook.com (2603:10b6:208:fc::36)
 by DS7PR12MB5718.namprd12.prod.outlook.com (2603:10b6:8:71::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Wed, 9 Jul
 2025 03:39:46 +0000
Received: from BL6PEPF0001AB50.namprd04.prod.outlook.com
 (2603:10b6:208:fc:cafe::41) by MN2PR02CA0023.outlook.office365.com
 (2603:10b6:208:fc::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:39:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB50.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 9 Jul 2025 03:39:46 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:39:40 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 22/35] x86/apic: Add update_vector() callback for apic drivers
Date: Wed, 9 Jul 2025 09:02:29 +0530
Message-ID: <20250709033242.267892-23-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB50:EE_|DS7PR12MB5718:EE_
X-MS-Office365-Filtering-Correlation-Id: 815f3bfe-4ac5-434c-d4aa-08ddbe9a4004
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x4stLj+82X0vQX8mD9T0XfSk7NrpIQhHHQRbZ9X17ruo3rrhR8vzv+D2667Q?=
 =?us-ascii?Q?CJgE245h9WgAaRRmI6qkNhSKiwNFnDA02yVLL+O3V2yEyXFcNqDmvCNo+LJU?=
 =?us-ascii?Q?RQij5Pqy2dutStCWQqm0QlZOzJYJg3Sl5ubeMOgn+KCTfIGWYIn0ebJ+0DwR?=
 =?us-ascii?Q?KgRu1LU/4RVgOE+H6i4NzGiZoydRdeWrRXWsk4BM60v0ZYujRj+CnZJp3XCI?=
 =?us-ascii?Q?tEmyXsVD5VhTo0Eas3GLupFXLi6+hRmAhLSqrTBM3yr1jcZ/r2OtPjT+o1/J?=
 =?us-ascii?Q?rFxrHcBBXKszJ3hJcTVpWNmx/y69Dle21WoQEu4/hUvf+tlOjiui2HWtMPkd?=
 =?us-ascii?Q?/3RfHCWof9/xlpVj+o5pfip3KYR8wMXx9wIkWwPzp2lockjJjyCIB7xGyti0?=
 =?us-ascii?Q?nY0MA7ITrKx2XKPXKndpN3uAkJpWNv4L3jDtzT+MMUzuzkHrIvQTRg4Vvp7I?=
 =?us-ascii?Q?WmDLHzaMYbtCXgg9kRb9Co4IQCvMJ/bDo7UrERp0hF5od6LvMPNlIABTCFlw?=
 =?us-ascii?Q?s1iS/f/LEOT2JgPShd5ezCl47RXfBY5cX5xHGy+FNpJEhu3mo+aLZrkwY9gI?=
 =?us-ascii?Q?NFo8cjp6V5PkhcGhWIyRMv3EqfmRnevLPYwvFIWZCknOxeGgT1zMYsxp0SP1?=
 =?us-ascii?Q?4LsEZLf5KOoMV01jY+ePn/pP/pWLaeUWB+WtiFBiqtil169bZUkxgZ8BCWVD?=
 =?us-ascii?Q?YO+xXYqrsflcpTmzbJJ5koo4lV8nt7gaSvV5WD1rkbPJm03Dt7v/XYOLkshF?=
 =?us-ascii?Q?vn4XzG6zumPJ1Wp8MaWFp/IUvkFXyz0vVRMC/4fAcAEEX6gRK7FSs/tRLpbN?=
 =?us-ascii?Q?K5uGQCflJd9Dm+ZhJJ250vSYqyzR6wnyUbIy3ELwrIX7PZrood7F3IM2O8He?=
 =?us-ascii?Q?/CZz02LZmupeNEBJQZ+E3vuUh1vsMTr4zM+qqwoulkx9G4RGD/wC4CgzSqo9?=
 =?us-ascii?Q?abaHcyUV4d+R/soaNd495g4xLAVYJpu/qrXQ6cZJeEZPhW+uBCRFxyPxqj6Z?=
 =?us-ascii?Q?YAj6sW26VDb5e2ZSVj4IHn+QLM43z2QpBXv/r5mMGx1zuFQ2RNBseZv+lGX7?=
 =?us-ascii?Q?HWWgESjBtFoGa9Oy4P36JQ3WAkXEHCfSj02KXEa8Hoy3+JTmk+wMtPpK8L4s?=
 =?us-ascii?Q?2OIehffRCz+sjHBA2EPnmg5OCqnbT5iCScOGxJ07btbAMqQZ8SzjOvPzOjJV?=
 =?us-ascii?Q?vIjPBVFPq+Qu82SThPODOkHWAmutQj3XVDw0c1uRG6qz1Poe44ir3OgWnRVe?=
 =?us-ascii?Q?Qe4iTSypx4sBgntcpO2uyIoynug7/o0KyIPhZM7PjHy54GGHJSr/zEDIDzzp?=
 =?us-ascii?Q?4mjG+ds7tfK8p4hWRDXUHphwPPzYklFfrQ/Ydz1TSivZDy7n299hgt3qJaNe?=
 =?us-ascii?Q?AB/8AO45+NFLI02HRLx8ZqkMeF2XYgpMuvj1m9Z3blpWNFeCaYjwt2yWqmcZ?=
 =?us-ascii?Q?iLOMiKEK8BnwG96yyG5v7qAclhp3uiACSOPK98wCsYk7Kg0A/0frVlwJjxPD?=
 =?us-ascii?Q?TqEH6FKUUYgO6pzLCu22AUThD88wkLbN/BvJ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:39:46.4344
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 815f3bfe-4ac5-434c-d4aa-08ddbe9a4004
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB50.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5718

Add an update_vector() callback to allow APIC drivers to perform
driver specific operations on external vector allocation/teardown
on a CPU. This callback will be used in subsequent commits by Secure
AVIC APIC driver to configure the vectors which a guest vCPU allows
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
Changes since v7:
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


