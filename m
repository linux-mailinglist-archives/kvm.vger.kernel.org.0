Return-Path: <kvm+bounces-56090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F4CCB39AF3
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:04:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E5381C81472
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 210B230DD12;
	Thu, 28 Aug 2025 11:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="E8AyKbis"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA66C14A4DB;
	Thu, 28 Aug 2025 11:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379048; cv=fail; b=e0eQW5dRkZ6LFCPcvPO2+JeSxYgTwMbKReEhVp/yHUfNqw0+XQXfKCAWkFW9hRTVbALkufc1YuDqHLq5v9gvm6bDrP9YNtfDtPA2swU5jXLg1WdTrCrNQE5SFgO5yU6Qdf4IRPA17x7zA7pFSckk1yIVHvjSLu/y4p5cYwtaNcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379048; c=relaxed/simple;
	bh=MUZQ0sdP9AxFmsncMVXSdG7NEjb+mDLC+6c1zqWyLFM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J0cifMDMn7ZnmZ/CgpFig0u95+jCe23pvd0y0GeEmc8WK6s0tupXyjYyarVnHX7//g91Qw9/rnowcR5V27FL2RR5CPeZ0n073GL32+5jvw3FLI4qUQvPDiABwU1DP6TvpDSTCmyvke4H2vu48A9APFVvAKlW4fbA6KduipPC2KY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=E8AyKbis; arc=fail smtp.client-ip=40.107.236.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BDXU/WijGbCqe+NrQFkl9zN7UWzM9cDQvpufJsNKgNw1TjdPB6Znexkjof1NOZl9L3OUSqu6+EbXtkPMEr3Lf77xUcT/wBFFO451fCXFijSDHHqZaluBfb8yIrnyuycyEUG15Lbjo1jw5TUqvHtNelKtcKaFRV0pw1BdgP9/qvlL0CmTF+lYCWQSpu6qajeIeJLAsrt4kk+nRt4mVcowb7dRfB9E5fJ1+vhkWoBAuNovJCED7hQXCROlncq/7mZ5gepVKc+HJboNoelZNjfTmOLeNwneJQYs86IavYouBJG4NnLl2WfU1Gtq9KacXsJNSHPeHrfuLt1UupM1M8atFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HiPN4HtWAjz9zAPl4YJf5fRl2sHm48sc3w6Lp/TeLtw=;
 b=NjvB9nnrCpPWz1h6nNdLEn7oUW/0wmgcK0aEKQbo42AgxD/6/2FepD+h7TWJeEyG6pWUT9eCdpfIATvs2hTjO9FADuADuAOE3FzFu+LPnPikVaD42tC7+MAl1fHafOG8PyYeFlWETJBVHghA1SYW/3HHU+V4uMlIVxL5zRIv06O6FE4XBNr9Y6ziRPzR3HQ0f30NNiQ2mC+e9jUMDEFL8Ol3vkSPX3nccnus0Trk67GbyrZIHEYzuRAGNuTi6XASlKeOZiocSP7CARL2crq66Bj+S3keGnsrw7+SSRm1tdEwzOi13lSD7v+A2Umu/T3ZTkgunksgSvelwut9l3+g5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HiPN4HtWAjz9zAPl4YJf5fRl2sHm48sc3w6Lp/TeLtw=;
 b=E8AyKbisRRs1ncJvvystvtVUxNxuF368/58bJBIN0aovnCQX5Q+ArKYnqebeOfqY3BreE4Xz+AoPIQ+VIRlv+uMzAJY6nnK3fUJiB54dW6BA6pdip1vVXGV5tjj8DcQS0ooyVgsLRXYr/h9R+evbDL1Sj/TbhSHPkf/SNpXUPKg=
Received: from MW4PR03CA0178.namprd03.prod.outlook.com (2603:10b6:303:8d::33)
 by IA0PR12MB8713.namprd12.prod.outlook.com (2603:10b6:208:48e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 11:03:59 +0000
Received: from CO1PEPF000042AC.namprd03.prod.outlook.com
 (2603:10b6:303:8d:cafe::ed) by MW4PR03CA0178.outlook.office365.com
 (2603:10b6:303:8d::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.13 via Frontend Transport; Thu,
 28 Aug 2025 11:03:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1PEPF000042AC.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Thu, 28 Aug 2025 11:03:58 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 06:03:57 -0500
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb09.amd.com (10.181.42.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Thu, 28 Aug 2025 04:03:50 -0700
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
Subject: [PATCH v10 05/18] x86/apic: Add update_vector() callback for APIC drivers
Date: Thu, 28 Aug 2025 16:32:42 +0530
Message-ID: <20250828110255.208779-3-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250828110255.208779-1-Neeraj.Upadhyay@amd.com>
References: <20250828070334.208401-1-Neeraj.Upadhyay@amd.com>
 <20250828110255.208779-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AC:EE_|IA0PR12MB8713:EE_
X-MS-Office365-Filtering-Correlation-Id: c86246cf-a963-4bd6-cf29-08dde62296ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xj4+o6Ne3xaVa3+2xFu0dMPKEI4XTlyRSwPklu2MDEieV1MNc/TQvvfCxP4i?=
 =?us-ascii?Q?rZybIzyhUMfwFI3SPfAnGuiAmMvlfDCr35Kxns8jdsImpzmso3WIqm4JrXno?=
 =?us-ascii?Q?ZXhGr/dfhRPEcC7rMxtU/FLk+DMrFpwXyYKMwhE1fRNxv0+v33s+09LC7dCk?=
 =?us-ascii?Q?qB8+Iiv7yViOFe5thvSk2neYuEMygjKH/hNUAdiWJr1npQBDpE8lnu/QXjCL?=
 =?us-ascii?Q?pTIMLCZlFvYBu5nfEpvJtyPFuAK4uSKfStTfyLVjGjw3E3nVUBxOQB3Oa027?=
 =?us-ascii?Q?kiJMMl2OuuNRXETWzGSY4trXk8JNY+qu99n04HNqgqKNwKcUOnU2nja7FeQj?=
 =?us-ascii?Q?Jqhd33TZejEMbD0HIdPD3wIeuWPDKGw17DN5p3bjsa8HpZ5WkPAvCyGeSb1I?=
 =?us-ascii?Q?YT6evzvxETfD8R1WAERBN9KKw5kfq0oWhXx6zQlRP6Koa4+AKoQgEvGs5tVb?=
 =?us-ascii?Q?eQbPED8s1vzk0o10FvR+PA116xT4+fbBblQ24cC9ejK2Bo45yCAX2G3tzfF/?=
 =?us-ascii?Q?TzDUktbrKlkvsgf9CUnRAnSN3TbZPoC6Alti9sT7AwWt28WANBaDochI7liB?=
 =?us-ascii?Q?Lt1VWZrydSTkON6v3/WDjBagPDVreqV25zGVArDe0zxixR6ntjyySy6dxi0C?=
 =?us-ascii?Q?KVHQdBfyD8uGO0jKkc7h0HB0EhIRVIfL3URcwmg+/ZkNKZSwOeeg6c8uC9g1?=
 =?us-ascii?Q?3fxWV9F/wL1MajmuKbQ+PIUr1IAkwAyS9UiFdqQEHwGqPX5koFZAv9ZPD026?=
 =?us-ascii?Q?rr/sUO7rDlU6hHWX+EHl36sMKbuky0XGE5J3XTdNbGePO99ISI6KCFda1TCl?=
 =?us-ascii?Q?eRFn/OD3GWGMAtBKsw+viLcwmM/zstv2XPf3FAkdVFPho2bWgMi2/KhrFdWy?=
 =?us-ascii?Q?tm+qIc4Xfbej36Zhtl1n8a5HqG4iwGiHJmH0Yu1eaAsef6ylutrWxDHBZNbl?=
 =?us-ascii?Q?WX0l8l/efL3CmFTKJ3xjUo5OJMM1exm44UAr0tyUPzwxyKttW2+49Chgze89?=
 =?us-ascii?Q?s/RqGklE8IUEKX2SsIp8EkRsgNOv1wpRSDjKVagHnwErxDdoe2e/hhj8xPkb?=
 =?us-ascii?Q?I9UelmyerFOnkYmMAVzR3O1YsvbKyqA0ZOdd+HOh3lzET8kDKY6z9/NuQoa2?=
 =?us-ascii?Q?bM40O6QT/m9KONq8OsqX38/aAldCTSh4T2vlBH06LHy5uqCTmHpG+zbSrIxg?=
 =?us-ascii?Q?VTZwcJtg/zj85ZpJjk6hvumouQTEd20mXcW9AY6QH0mLcgH1U4bk0FCUQVAp?=
 =?us-ascii?Q?yY8bAkWZJHh1vjm3GIlu0icl3AThkOCnrnA520HO8AySsbMH0idF1umd5fa/?=
 =?us-ascii?Q?KzVUeyxKxtis0iJLhIzQzRtg2XGCN7G24EIUfgFgxRtag1qoSYGTI9D9L79S?=
 =?us-ascii?Q?3g1IkGkYVAlkGRAGU0v2QLpd4x/Av7USh026E/VkVpCGREWT4FH2BWNZ+Tv7?=
 =?us-ascii?Q?Yhuo7Z2iikz4VZUzPHnXrTa9sB3kerOpOv+feuo7XuBZKABZOL6pudtR7p7D?=
 =?us-ascii?Q?whGhdz6D6P2q2oiwhS9jBdFmqkrcDPtzipXi?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 11:03:58.6307
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c86246cf-a963-4bd6-cf29-08dde62296ac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8713

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
Changes since v9:

 - Rename apic_chipd_update_vector() to chip_data_update().

 arch/x86/include/asm/apic.h   |  9 +++++++++
 arch/x86/kernel/apic/vector.c | 28 +++++++++++++++++-----------
 2 files changed, 26 insertions(+), 11 deletions(-)

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
index a947b46a8b64..bddc54465399 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -134,13 +134,20 @@ static void apic_update_irq_cfg(struct irq_data *irqd, unsigned int vector,
 
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
+static void chip_data_update(struct irq_data *irqd, unsigned int newvec, unsigned int newcpu)
 {
 	struct apic_chip_data *apicd = apic_chip_data(irqd);
 	struct irq_desc *desc = irq_data_to_desc(irqd);
@@ -174,8 +181,7 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
 		apicd->prev_cpu = apicd->cpu;
 		WARN_ON_ONCE(apicd->cpu == newcpu);
 	} else {
-		irq_matrix_free(vector_matrix, apicd->cpu, apicd->vector,
-				managed);
+		apic_free_vector(apicd->cpu, apicd->vector, managed);
 	}
 
 setnew:
@@ -261,7 +267,7 @@ assign_vector_locked(struct irq_data *irqd, const struct cpumask *dest)
 	trace_vector_alloc(irqd->irq, vector, resvd, vector);
 	if (vector < 0)
 		return vector;
-	apic_update_vector(irqd, vector, cpu);
+	chip_data_update(irqd, vector, cpu);
 
 	return 0;
 }
@@ -337,7 +343,7 @@ assign_managed_vector(struct irq_data *irqd, const struct cpumask *dest)
 	trace_vector_alloc_managed(irqd->irq, vector, vector);
 	if (vector < 0)
 		return vector;
-	apic_update_vector(irqd, vector, cpu);
+	chip_data_update(irqd, vector, cpu);
 
 	return 0;
 }
@@ -357,7 +363,7 @@ static void clear_irq_vector(struct irq_data *irqd)
 			   apicd->prev_cpu);
 
 	per_cpu(vector_irq, apicd->cpu)[vector] = VECTOR_SHUTDOWN;
-	irq_matrix_free(vector_matrix, apicd->cpu, vector, managed);
+	apic_free_vector(apicd->cpu, vector, managed);
 	apicd->vector = 0;
 
 	/* Clean up move in progress */
@@ -366,7 +372,7 @@ static void clear_irq_vector(struct irq_data *irqd)
 		return;
 
 	per_cpu(vector_irq, apicd->prev_cpu)[vector] = VECTOR_SHUTDOWN;
-	irq_matrix_free(vector_matrix, apicd->prev_cpu, vector, managed);
+	apic_free_vector(apicd->prev_cpu, vector, managed);
 	apicd->prev_vector = 0;
 	apicd->move_in_progress = 0;
 	hlist_del_init(&apicd->clist);
@@ -905,7 +911,7 @@ static void free_moved_vector(struct apic_chip_data *apicd)
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


