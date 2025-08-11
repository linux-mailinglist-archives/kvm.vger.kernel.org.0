Return-Path: <kvm+bounces-54393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B26B20449
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:49:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 023F2424CD8
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE52D23ED5E;
	Mon, 11 Aug 2025 09:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wiL/DCAB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CCC23D28C;
	Mon, 11 Aug 2025 09:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905612; cv=fail; b=tdAKaQEdENwkVWhQBKKhdjUco8BPGBJg/qRrQ2ZUH61P+SQCDVNPdyLB84FxTpCsnpwrt4kcanjjDsFj7/oHNXokynow77Lc4xZgubNeaeXJIWw7+hvNytFBM9vslo31pB7CahiqnvpW+Kj1Ut3Y4NFHCYT789di+Kd4gylyka0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905612; c=relaxed/simple;
	bh=F3XiC79rxgbgokerBwht6nYI71YdNS4LhA3mVP4GtK4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q/0lK85gwGRpRs8pRjJZOKinIWgPZHZ176sBoi3jiAx9dOYOUhE4RpACxhqPmYaxapHltBeW+hGoNxXIV+GEUe55nlxNJcR+XQ/fP5247NPkF/EoUrH/9xRCZ5Mw9K56jZEioR1oA7e3ufrkRHvmsTRKVEXh00+ZhZVrBNRQbys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wiL/DCAB; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mflPM+dyx78rzqIYY9f3KShipKSizLKJEwkbe4zsamswl4EaEXqEhKSekL2pyt9rd/+bXbLhQ+5d0rTo0veIGmv8ez5yk45NPX2sviA3rEAsbHi//JKwOrICNDJeSBky1Wod+BsWOhJwEWlwQEfheZXx1ijEgy5Fhc6Db0NDkz0JmExzWXGPultgVFMsYCNVGlv1GsZhZMpDkRE89U1lO/byNvtnbC27Tf4xp/e1bIAIhNHk3G0WwRwFmRQ9hZUxhQU4bh/KIAC6Wg8XrcG0HY5fgOcW50iYTOJmChh1ZcuEQLew3mP5x6McAT4TUZ9eMZRLN/+fWCWBOV+fi2zO4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8x5kFyst8GRZWfMt9bAT8/V7H6bDoDmNjP6GfGbCEvA=;
 b=p2thkP1JLoScHJpoMO1ZGDwZvAf6uPjfc3XN15f55qQ8gE3FrhrjazIwyZX1cekOIzttIXj0K2VvMmxVc0xUpUq+sZUJo4nySu1R0/L9sLYFnqv/o/voldSOwKZFw43EsBYC+6k98/elZMbk1OuIjvy6A2PfEXvchHtHdZ0+EA+RV3jr7ws1LiZNYTVJf38TMkvX1C/Kwhp8HXItjzjuEpdpqV4Sun42zAUfsGvlf6zSEFvK2CQpadcBrLxaRRLObv0tFXrIoOolvjF1uhkHFXyopFWDFR29Fd+DOsPMMS2qED1lMZNdMY4w1fNP4LvsiKmm0g16Tbqw9N2nRe+A1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8x5kFyst8GRZWfMt9bAT8/V7H6bDoDmNjP6GfGbCEvA=;
 b=wiL/DCABaWAxmz+iuWfzEkAsj8Tkv7ADQQjZwUKWAvtodJSK9ov37UBjd1KSLiQhXfYwyV3WBpdttj+vTNx6pxXsUHAP49ez7YYyHHKuhdanjbSFtMlrr88ICMuwybTijY8NBt9NJqIjHNNMH4RCfmOjaaM2I/y5sHy8ZNo9i2U=
Received: from CH5PR03CA0016.namprd03.prod.outlook.com (2603:10b6:610:1f1::28)
 by SJ1PR12MB6027.namprd12.prod.outlook.com (2603:10b6:a03:48a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Mon, 11 Aug
 2025 09:46:45 +0000
Received: from CH2PEPF0000013E.namprd02.prod.outlook.com
 (2603:10b6:610:1f1:cafe::eb) by CH5PR03CA0016.outlook.office365.com
 (2603:10b6:610:1f1::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.22 via Frontend Transport; Mon,
 11 Aug 2025 09:46:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF0000013E.mail.protection.outlook.com (10.167.244.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:46:45 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:46:38 -0500
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
Subject: [PATCH v9 05/18] x86/apic: Add update_vector() callback for apic drivers
Date: Mon, 11 Aug 2025 15:14:31 +0530
Message-ID: <20250811094444.203161-6-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013E:EE_|SJ1PR12MB6027:EE_
X-MS-Office365-Filtering-Correlation-Id: 27ce8d1f-a7f7-4b55-8aae-08ddd8bbfbd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SZ/c8IiZV5LdwBFvvIap5XEhNv2T8O8fs0+AEIVUGNnZrcmcflSp35BiTDTy?=
 =?us-ascii?Q?hfC3URrDqcdB1Y607JzbFGqsDa55XuP9hX66VDMakyO6fcGcDFRXap2V27ke?=
 =?us-ascii?Q?IfcO9O1m6gO+7bpCvfcvLG8IP0Oon0/xIFugarr7wLG09EjMrFnylVXbxGUI?=
 =?us-ascii?Q?HvmZXrGdb7wTdUx/kU3IzRB9IIdT0TBmkgkatUoVFX2b8Hjs3cNxzGrTMpp7?=
 =?us-ascii?Q?/ev0myI4FU3CWEaTa6bTSkrfHYaRnIBxnXdszQRDRc56CrB/IZdvDesA7w4S?=
 =?us-ascii?Q?dDrA7RyQoAPGjWAKjJGmzt7I8jat3pZmthjJFxDrfJkJjPKqrjLj2rMr/jIN?=
 =?us-ascii?Q?b+GXcsr6HbzeuF2wo+9bzNJdI1BMlBiyjViOdOIHYECFR3YltP4L7tks2tR+?=
 =?us-ascii?Q?YPpeinUJLe9HSJvZZrTQTE0PT/bHYpnfHnBN9rP/vZNpVvs6kbWw/G/bGkk9?=
 =?us-ascii?Q?1M9TBdX2k0h2JZg3VENmFLjaNHqhajDyVQSlnaQgrh4Er8U/sD0LsIHYXu0S?=
 =?us-ascii?Q?SY7OjMLEMI5jGx33jWcWrfIHFmVW97s7U1L+FyCXhIfZ5gMr4oKSrI/0bPw/?=
 =?us-ascii?Q?Sc7dKd2bOBM97ImIlB0MZ1PE/fk9Vekk/GXUJfR8sXgr8PkpCuvj9btcowVD?=
 =?us-ascii?Q?hhS7XBNSCfB8GyVc5VvXi+BqinL6rR9FQU4Jrt/coj4MVZ06LOrni/4GhbRU?=
 =?us-ascii?Q?Gkn0vQSNRhRroVh+fapbYyX2b0rDyukaiOU21ZfxBjuVkTw5DwOnMnIbySuD?=
 =?us-ascii?Q?d7Yht5XesqgoGGis4XoZhI9PoSNe9n9JWUY/WMhLbLcwe0C7PB54E2q+qgcy?=
 =?us-ascii?Q?H5hdFrivNoi1JtWZmj5UlVlEo1vYJtpAAUSTVgBLnRX0d7cAv3yy6nWxpqd8?=
 =?us-ascii?Q?RzTUQGAPyaHIBg8qr6TTnaXawyDQHmXlWKJpfDFol6HEJV7e/j8UifrP5y5U?=
 =?us-ascii?Q?JRweMHhBOVSB2l4MHdFtooU/u4kaMQh9UwqQIadbWcxD7YWmdmAFyKusfDcl?=
 =?us-ascii?Q?Lst7vJYb3fdVamyguiJBn9tSmWZht8T/8Jorx/hHJB4ktU/C2EhndSaNklkq?=
 =?us-ascii?Q?IPQn3gJrjz1Zq4/9Enkef7TG05thv+lhXX6oEdGagbkmN87H3BJ/fnzrJCi5?=
 =?us-ascii?Q?Z4+fT+nwZ1mVOf+1XJ1YKsAYV6xvcnKE8BRWDE0mc8oXLClCByS0o8mSRkBb?=
 =?us-ascii?Q?3UI7XIjxudZSujK4bRfPzV1ROZ4jOP14ORUX2qz1m6yfwaxpMBTeBbUHWxSg?=
 =?us-ascii?Q?zADW9gcPoTODe8NpDBxwsCBevxQl6g4OwGfI3NYG1RutRycF9fWWag0rzR3c?=
 =?us-ascii?Q?dOk5jQI99mXcDEJqA23XS5/CGiyez+2Thk8rw5VeECQPTZex6YN6rCKod9wT?=
 =?us-ascii?Q?IfhqqmfImwOIOXrSxTrxqjZLqYBjlUETYuia1L2zd8q+4ACpZax/UH94mA89?=
 =?us-ascii?Q?lpFrvxZxnowyruxziF4vUF/wcI+6xyRNgJbHhAUuQg2umIIkwGZi2KG8Jus4?=
 =?us-ascii?Q?df4onNd0fgI240//oXPNxYoR6iV5ZN3mROvo?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:46:45.1683
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27ce8d1f-a7f7-4b55-8aae-08ddd8bbfbd8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6027

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
Changes since v8:
 - No change.

 arch/x86/include/asm/apic.h   |  9 +++++++++
 arch/x86/kernel/apic/vector.c | 29 ++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 44b4080721a6..0683318470be 100644
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


