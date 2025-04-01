Return-Path: <kvm+bounces-42305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5505A779B4
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 13:38:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B251188FF46
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 11:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D161F1FBC8D;
	Tue,  1 Apr 2025 11:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wytVjymD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAE81F03C1;
	Tue,  1 Apr 2025 11:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507491; cv=fail; b=pqAM5duhs7E2CgAgkiuSfn7S4dLJaKUh/5Dzb+b+xji+Y6XNS7HEJnXA0/3zsJFTaTdtN8jXKlwhfZi9QoZif7er7A4gSk8M3+gZSI8hZAdq2WNwuRFojRb+T6XMjW6ieMvgf/mKvqRs0kjxAlGQWhqKChDnvXob5wYKbrtDy0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507491; c=relaxed/simple;
	bh=lA3R67kYElVSZkoqYl9RjJSjlFW4H+eLByAeLeniPZk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QIMr/w+gPCpGuy3bqMIVy353iupX2MHfU6srv2txt+3IchJr5vbl3TpRGpHiSHq3tZqtfs90SMGNo5I38u8T4wrC7kzZ7zlycIn9mmZbtPMq6MpaJXVG133tkujKD9andjMH8kAVUCDGR2BhffQO+M+xUPdsg7IFsLDegbjfh1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wytVjymD; arc=fail smtp.client-ip=40.107.220.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zqfc1+4NNUMugbEPPvSV6PeHuVMlWCHJYjzYNcX6ob6Om3vAe5STEfeMWlWAzTujzHtYrB1tih9nWU9cA+Ei76X7CfSIM+RfcOkv0weND216wVsFUp42oXZZPDy/3+O4NkWGz0hXZn1rLJezglJ7xQYbuzjQV1MKif7xfbN0pGSLDxOTvL7s+Apy9QdMxuNrvD/UjquOhFJYOgIaNxwuN0ng9LziLIYy3VMlXsRYLTeUKUMv5ttrstPWUmYVs/3+OtTcNUNDnZ+j2PxHqEn2LRQvDV2fIImhbUhYl3lzCzRHtjsoDDerpOnLssRo0f7S9o8LjFlV5asqyTRBQuoqPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2P9M4wzkHH1pCo8KCjWMNMngJMUaN9GNP/gXw1wXNY=;
 b=bgaYO59d7GnPxiBRw39e582DYBWueCkobVYG9GgKSu6/Yw5V7m/lymfxF5RgDT/2HnJONzyL1Q94c9SG8+iuSA+zpqSbcoJq+NgffR639r5pLORDuKnBlNQF8eiuP2mKEU0Q2AQZmN7ZWO1JQ/zady2+2MHFRvD5RJHbwPhMyjhYLRJMISjLWYE7F/uhwQV1Fd3jmRvBHP877Wu+1VVmtLGB/3aYobkypQaVeFZjQ9eo4uRkfsAQVTmtTLngYKoUfdrLGPwxeH+h6xGbSSxYnpvakErZq0LVlnwhpIvwqzheARO9NCqWNn0pkPDDkdV5Y4+8OVS/JM90atH5fpug5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2P9M4wzkHH1pCo8KCjWMNMngJMUaN9GNP/gXw1wXNY=;
 b=wytVjymDHNErRuv5/pmxVeh69XHbA0SPSFSRIcvTHHMSjNxsbX8+FFqhIdNCrYpItNPbedBrR0q2XEpHlehcuVS5+dlo0zORTtrbMqfjvmjC7b7PrOjeSem8lQaMZBg3aCx/SNUgPHPFsafRRXOxPmTiJ61NAzYgwTaje/Va/+w=
Received: from BYAPR01CA0021.prod.exchangelabs.com (2603:10b6:a02:80::34) by
 SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.54; Tue, 1 Apr 2025 11:38:06 +0000
Received: from CO1PEPF000044FA.namprd21.prod.outlook.com
 (2603:10b6:a02:80:cafe::9) by BYAPR01CA0021.outlook.office365.com
 (2603:10b6:a02:80::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.52 via Frontend Transport; Tue,
 1 Apr 2025 11:38:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044FA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8632.2 via Frontend Transport; Tue, 1 Apr 2025 11:38:06 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 1 Apr
 2025 06:38:00 -0500
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
Subject: [PATCH v3 05/17] x86/apic: Add update_vector callback for Secure AVIC
Date: Tue, 1 Apr 2025 17:06:04 +0530
Message-ID: <20250401113616.204203-6-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
References: <20250401113616.204203-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FA:EE_|SJ1PR12MB6075:EE_
X-MS-Office365-Filtering-Correlation-Id: 915877db-3c48-4d09-a304-08dd7111ab83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HqIDChtyAuPrEd4COsRBDSpcRL9CLhaJG1T33+S2XebZP9ntuvDZfM0vCRKS?=
 =?us-ascii?Q?jmMQG/7/PxwVvWa4baLvtRsIP8AyyQ6mnkaSgtcnRIHtj1C6SmaDa8GhPg8r?=
 =?us-ascii?Q?HrVYZ6mqugPKabR5SQ4mnUE9PaILs0OvvZtmdnrFXwVXUadGwPdhbo9lJWAI?=
 =?us-ascii?Q?Y0l1VWGZndJoCAbBeI4w6GAI41uxE5MKbacthp8GCwEipYLTW5Hz9fCudcRd?=
 =?us-ascii?Q?BQ5E70wuAWtAxSAAkGyxiWbcd4q7r3sZBzAOj8VvDqNva/vPb1F8NJza6DRW?=
 =?us-ascii?Q?uoeryHeklVZD/qEQlXCNJ3T77MJ+af6kk0bfahx0S5RkdmGDVj7X9tjCD5sS?=
 =?us-ascii?Q?6ZFLwux0IUQbgNJdw+nUBN081VuktAqiSx89mEFDTf76aweomMVRSnx0Jpj8?=
 =?us-ascii?Q?4WRozxNvJpNXtiOho/n1/PnJp8S6yxs/IK9BQYljXITIwaofLfMaPGbA5xmw?=
 =?us-ascii?Q?nhh06jFqmgfQ5gzEJJ1h7DmjK3IDz8paKKS5923MRUChguy3cQHlZaz4lZx7?=
 =?us-ascii?Q?mb2xKuw7aX9hklt5tgTaIHYnrI7wmfhXD4vXzWHxwnfJ7w6VUR3kQQ4TH5uG?=
 =?us-ascii?Q?mXRDekdwLplEo+9SepXW7xnJesRYfF7mtql/C4Q1/gpYhi8MoPjB4Lb2oMrw?=
 =?us-ascii?Q?MxnzJbdBF2qtxIjRGwkF62KzpY4NOoXavY03hzXra8aTOzntlsINn6yXX/tX?=
 =?us-ascii?Q?QVA4HX6LGVK2w3Hnf8pPfccxil2fuwH2r5DUaYG6DNuCY+cl/zx9yabY8TnW?=
 =?us-ascii?Q?GfEHVQWvZU3A/28+TipjfcstR3cBEE66HePehZR6PdKn5+WTjxhR8iJU6eOA?=
 =?us-ascii?Q?+jzJtFChs7eSPk0ygsuP4+f3JCXkOskF2vuUW7AX4v5jr7LTbHL3FenXXg1p?=
 =?us-ascii?Q?agB60mfoUz5X35pknKruXo3ADYnYatv9nyjY1eTMz7joJb6bhlmFebSMYPJW?=
 =?us-ascii?Q?uSQp5BE9dpHBXgI/BYVJoeFY3zsQ2xWyQO1Gowipadgb3VAiWuiMjJ8tllCN?=
 =?us-ascii?Q?GJjR470r6Y4q8IO16qDMXClJOSjCI8/L6XHAdyQkBuAZOpQ8nmwUs2YgDVph?=
 =?us-ascii?Q?u4BuFej1MN1x5m8oSGWNo6d4qWoeXsSMNMNE+ZgVP/Gaj4YqNcG7/yQlbMgZ?=
 =?us-ascii?Q?nKiNqOMQQ/Vjt9y/bfhbMD4kLjLB0Y8fdddrlt3LRB7DYJIxlGiWm0T3zg4Z?=
 =?us-ascii?Q?EMfmzzV1h3uQDcD43XFnaJxKF7wuXnSWq7zHvboO+lbSMYHpTUWQjCYp1AO1?=
 =?us-ascii?Q?jTQFq18dHGq8bQtN8s7peMVw+D5T1OG95nDSP8KYPkoYiWa6boAPYjpickk7?=
 =?us-ascii?Q?0snHmAd+vXPmbQA9Shl1mrh+HP21bnU/B9hkrJ6vmgD3jkDz25lEycYhfVgw?=
 =?us-ascii?Q?AN2RA/dXBGJXaztCUXH1F+76zgSm8NqVBJe6FPY0ERyzpmy1NQZsSolgsD9L?=
 =?us-ascii?Q?dlQtxTUm3Ckk8GKYlxFpHzWd6RrLLHP4qyAD3JZcfH9epadYXlGqscVoWvQO?=
 =?us-ascii?Q?LViApCbE+YhGAhQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 11:38:06.0830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 915877db-3c48-4d09-a304-08dd7111ab83
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6075

Add update_vector callback to set/clear ALLOWED_IRR field in
a vCPU's APIC backing page for external vectors. The ALLOWED_IRR
field indicates the interrupt vectors which the guest allows the
hypervisor to send (typically for emulated devices). Interrupt
vectors used exclusively by the guest itself and the vectors which
are not emulated by the hypervisor, such as IPI vectors, are part
of system vectors and are not set in the ALLOWED_IRR.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v2:

 - Associate update_vector() invocation with vector allocation/free
   calls.
 - Cleanup and simplify vector bitmap calculation for ALLOWED_IRR.

 arch/x86/include/asm/apic.h         |  2 +
 arch/x86/include/asm/apic.h         |  2 +
 arch/x86/kernel/apic/vector.c       | 59 +++++++++++++++++++++++------
 arch/x86/kernel/apic/x2apic_savic.c | 20 ++++++++++
 3 files changed, 69 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index e17c8cb810a2..b510008c586f 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -318,6 +318,8 @@ struct apic {
 	/* wakeup secondary CPU using 64-bit wakeup point */
 	int	(*wakeup_secondary_cpu_64)(u32 apicid, unsigned long start_eip);
 
+	void	(*update_vector)(unsigned int cpu, unsigned int vector, bool set);
+
 	char	*name;
 };
 
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 72fa4bb78f0a..897e85e58139 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -139,8 +139,44 @@ static void apic_update_irq_cfg(struct irq_data *irqd, unsigned int vector,
 			    apicd->hw_irq_cfg.dest_apicid);
 }
 
-static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
-			       unsigned int newcpu)
+static inline void apic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+	if (apic->update_vector)
+		apic->update_vector(cpu, vector, set);
+}
+
+static int irq_alloc_vector(const struct cpumask *dest, bool resvd, unsigned int *cpu)
+{
+	int vector;
+
+	vector = irq_matrix_alloc(vector_matrix, dest, resvd, cpu);
+
+	if (vector >= 0)
+		apic_update_vector(*cpu, vector, true);
+
+	return vector;
+}
+
+static int irq_alloc_managed_vector(unsigned int *cpu)
+{
+	int vector;
+
+	vector = irq_matrix_alloc_managed(vector_matrix, vector_searchmask, cpu);
+
+	if (vector >= 0)
+		apic_update_vector(*cpu, vector, true);
+
+	return vector;
+}
+
+static void irq_free_vector(unsigned int cpu, unsigned int vector, bool managed)
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
@@ -174,8 +210,7 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
 		apicd->prev_cpu = apicd->cpu;
 		WARN_ON_ONCE(apicd->cpu == newcpu);
 	} else {
-		irq_matrix_free(vector_matrix, apicd->cpu, apicd->vector,
-				managed);
+		irq_free_vector(apicd->cpu, apicd->vector, managed);
 	}
 
 setnew:
@@ -256,11 +291,11 @@ assign_vector_locked(struct irq_data *irqd, const struct cpumask *dest)
 	if (apicd->move_in_progress || !hlist_unhashed(&apicd->clist))
 		return -EBUSY;
 
-	vector = irq_matrix_alloc(vector_matrix, dest, resvd, &cpu);
+	vector = irq_alloc_vector(dest, resvd, &cpu);
 	trace_vector_alloc(irqd->irq, vector, resvd, vector);
 	if (vector < 0)
 		return vector;
-	apic_update_vector(irqd, vector, cpu);
+	apic_chipd_update_vector(irqd, vector, cpu);
 	apic_update_irq_cfg(irqd, vector, cpu);
 
 	return 0;
@@ -332,12 +367,11 @@ assign_managed_vector(struct irq_data *irqd, const struct cpumask *dest)
 	/* set_affinity might call here for nothing */
 	if (apicd->vector && cpumask_test_cpu(apicd->cpu, vector_searchmask))
 		return 0;
-	vector = irq_matrix_alloc_managed(vector_matrix, vector_searchmask,
-					  &cpu);
+	vector = irq_alloc_managed_vector(&cpu);
 	trace_vector_alloc_managed(irqd->irq, vector, vector);
 	if (vector < 0)
 		return vector;
-	apic_update_vector(irqd, vector, cpu);
+	apic_chipd_update_vector(irqd, vector, cpu);
 	apic_update_irq_cfg(irqd, vector, cpu);
 	return 0;
 }
@@ -357,7 +391,7 @@ static void clear_irq_vector(struct irq_data *irqd)
 			   apicd->prev_cpu);
 
 	per_cpu(vector_irq, apicd->cpu)[vector] = VECTOR_SHUTDOWN;
-	irq_matrix_free(vector_matrix, apicd->cpu, vector, managed);
+	irq_free_vector(apicd->cpu, vector, managed);
 	apicd->vector = 0;
 
 	/* Clean up move in progress */
@@ -366,7 +400,7 @@ static void clear_irq_vector(struct irq_data *irqd)
 		return;
 
 	per_cpu(vector_irq, apicd->prev_cpu)[vector] = VECTOR_SHUTDOWN;
-	irq_matrix_free(vector_matrix, apicd->prev_cpu, vector, managed);
+	irq_free_vector(apicd->prev_cpu, vector, managed);
 	apicd->prev_vector = 0;
 	apicd->move_in_progress = 0;
 	hlist_del_init(&apicd->clist);
@@ -528,6 +562,7 @@ static bool vector_configure_legacy(unsigned int virq, struct irq_data *irqd,
 	if (irqd_is_activated(irqd)) {
 		trace_vector_setup(virq, true, 0);
 		apic_update_irq_cfg(irqd, apicd->vector, apicd->cpu);
+		apic_update_vector(apicd->cpu, apicd->vector, true);
 	} else {
 		/* Release the vector */
 		apicd->can_reserve = true;
@@ -905,7 +940,7 @@ static void free_moved_vector(struct apic_chip_data *apicd)
 	 *    affinity mask comes online.
 	 */
 	trace_vector_free_moved(apicd->irq, cpu, vector, managed);
-	irq_matrix_free(vector_matrix, cpu, vector, managed);
+	irq_free_vector(cpu, vector, managed);
 	per_cpu(vector_irq, cpu)[vector] = VECTOR_UNUSED;
 	hlist_del_init(&apicd->clist);
 	apicd->prev_vector = 0;
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 21f7c055995e..0bb649e3527d 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -185,6 +185,24 @@ static void x2apic_savic_send_ipi_mask_allbutself(const struct cpumask *mask, in
 	__send_ipi_mask(mask, vector, true);
 }
 
+static void x2apic_savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+	struct apic_page *ap = per_cpu_ptr(apic_page, cpu);
+	unsigned long *sirr = (unsigned long *) &ap->bytes[SAVIC_ALLOWED_IRR];
+	unsigned int bit;
+
+	/*
+	 * The registers are 32-bit wide and 16-byte aligned.
+	 * Compensate for the resulting bit number spacing.
+	 */
+	bit = vector + 96 * (vector / 32);
+
+	if (set)
+		set_bit(bit, sirr);
+	else
+		clear_bit(bit, sirr);
+}
+
 static void init_apic_page(void)
 {
 	u32 apic_id;
@@ -271,6 +289,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
+
+	.update_vector			= x2apic_savic_update_vector,
 };
 
 apic_driver(apic_x2apic_savic);
-- 
2.34.1


