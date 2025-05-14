Return-Path: <kvm+bounces-46442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEFD1AB6431
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:25:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E29A2860B25
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FED321CC6C;
	Wed, 14 May 2025 07:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="F/4awUAD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2630F21B9C8;
	Wed, 14 May 2025 07:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207449; cv=fail; b=c6HHQ4+ETynIajBfovpYpwvLK5BGT/RTplSeWrJFGfMraJzdv9AocCwGWi7cIWW58rPodpjQ8LnZ+3giy/R43HP3HzO4V5OsHYcb01rHfeVhGQcNIUFcisnR/+GKOJdfIWNoOZ5zsV7+7pmCyMgO/KL3bGe/Xfdi/TWHIVO38ME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207449; c=relaxed/simple;
	bh=Vminxat5dOi5W6bxlFVNzhcuBFBGZfJ994iDdHmjGxs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ANeW0w7Vs1yVlov0kM/jJx+z1+1pTrBFbn0AdJliPCj1EKAGOIVjRkjf2aFlzYWgiYhG/mKeVHTRqcghDovVcVuZE+dvY+QtMQmw/ftN+WOgcYIxm2VlNdEAj8dStUmhP5ZtaYrmYmvFsSczyC/0ZR5NSkkVlC4ZdEU33LXXw+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=F/4awUAD; arc=fail smtp.client-ip=40.107.94.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BkF2I1DrjBtzk1qpdmKAcKEjcVED5QthmZ2SfN/mtrMbsz27lrXuH2+/syi6Bo4VqdjBxCe4wchi3BgOLCuHla1DMcIgF2d161fPURp1cz/MPY4hzkgUH0jWRiGaX2PuwfDOfdvoQOKuS9DCRAs9JYEAFnXA8KACqtxlG/dZ1FBd1S5bf0LAWm6vteZBGPSetMORL7g4raQHtle/IAQ2szjU6t5E30se5Ie/cv9npDq1EMWS+sBB+oDSfvyGdysl9pc3QShJCjV3KaWbaTrJvpntdksj1dBRn5HK9oMOB3zmrhd0ouXlCRCoHKa8l41kD4+soOKG9JUDCEerHJ6+3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFbbrOCC177wgwy5rUZKVyUnFmfeY2VuJsvYZ0WEGUo=;
 b=XNjnsQteYGyj6eAAp5GpXywggU7nfmvuwVgE0u0oX7mAPgBLHd9XeczDukKGmt5ONt15TdDuVhNzeuNi3bv1K3khB8UVbwE4KTVh3Fu08o3mzIVf2ClYW5SXg0xR/b/qExiUyd11j/NCex4pmCglb2N361cCI6RkIPZjvSnyQmOnfxgvXaTk3MkP/4l7ltW99DwxRYM3wFb1QiSmo4O31ZtAXfe1xOnnDQaEHUELufv4Gp5Fp7X6C/YqRkZZ8tJ5jPka64CzjRLh9ggCoUkb+6cej6DGdawdml+GfKLu4XSF2R+SskvS/Ic7zzTl+aCbOqHLL3jZJFOzB78kNYUc4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFbbrOCC177wgwy5rUZKVyUnFmfeY2VuJsvYZ0WEGUo=;
 b=F/4awUADKhjvikGpBHYXjiVqreeLP0DlNzGFzy1DxiHMGDPKGRMddUA7VWXv2c+dlUHvxE9XeHnnjcE4bbGx+b3YmkoGhaHjTHytpklH1RhHPSLPaHaT+5LyfUH7y55ref5SVFuL2GiLFsm4pKr8Cq8Y2l/JOnvR+HB7fmTfx6k=
Received: from BN9PR03CA0532.namprd03.prod.outlook.com (2603:10b6:408:131::27)
 by IA1PR12MB6410.namprd12.prod.outlook.com (2603:10b6:208:38a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 07:24:03 +0000
Received: from BN3PEPF0000B078.namprd04.prod.outlook.com
 (2603:10b6:408:131:cafe::98) by BN9PR03CA0532.outlook.office365.com
 (2603:10b6:408:131::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.28 via Frontend Transport; Wed,
 14 May 2025 07:24:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B078.mail.protection.outlook.com (10.167.243.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:24:03 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:23:53 -0500
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
Subject: [RFC PATCH v6 14/32] x86/apic: Move apic_update_irq_cfg() calls to apic_update_vector()
Date: Wed, 14 May 2025 12:47:45 +0530
Message-ID: <20250514071803.209166-15-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B078:EE_|IA1PR12MB6410:EE_
X-MS-Office365-Filtering-Correlation-Id: 1054accd-c6be-4d16-4cec-08dd92b84e20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ot8CD6l+Mb/NzNq2FwySnxbpPp4IZlrPlo1Fr+9nk8RDFqBVirjNi+h8ZQ9b?=
 =?us-ascii?Q?XXXbM6MKuWo6rLa2z6oGYavFq95aeJFIKWe+G3nqPiVpYclf80tm3oa8B+yi?=
 =?us-ascii?Q?Ln3foXTGDETsKnYN38ZMTxiFX/4C8N1skadsWXSsPsLcmxB5drAy4K9ilPtL?=
 =?us-ascii?Q?JS7uGHt8bTTSQ/hWia1KHLjP+sb9MBptFK9dgndHQlYDaqM/RHLlg3bBcPzj?=
 =?us-ascii?Q?RmzOwAKGDyCm31eiZVFDf9PoDaVyDTVv5AkyO1CBeyzWeTcGgceej2SULaMa?=
 =?us-ascii?Q?i4qumx8zXVxlx70hdKiOjTFtEXekJzvICN+ECpstDZsi+3g7k5wTC5CQJ/y8?=
 =?us-ascii?Q?/KWU1ZHIfKUa5NvhjIcGOJ3tJedrFljNDfmOp5fNqmy+2pT37UTMVI0UjcZt?=
 =?us-ascii?Q?1GomeVRxfa49HA19ceek+EjiQGLsBHNOMSCaEASrFQdDpie9K2hu6GXpaAie?=
 =?us-ascii?Q?A1Azu21OPUOT1nqnC5rJbuayOJx1ktZvngoo/pccF9MPchJgGAbrm114N7bg?=
 =?us-ascii?Q?v/Mq6mhTn0wbaxVF7SybTi+PhfLnoXgvmLfsIavHQjDEF4a31zSPDwAVqSyb?=
 =?us-ascii?Q?MiAlClCjZVLSwrkk3MMbm434XFC7euDpJwEExl/jRGQSclFVpXzOQye/7TuH?=
 =?us-ascii?Q?1gDI+67MfhY5czjVgOFvSnIKDGMVygDZehbcTFtRQJwR7UMPsIxo95dZ/8Qm?=
 =?us-ascii?Q?diTE9bl7/0uF8f4I6zFKEm082QSX9FyUoNddQ2tN4uRlbzyKHvIUoL7W9gzh?=
 =?us-ascii?Q?ub2jP9x4FIM8mT/e5jnQpE05yKo4LjS//UtyYPIiYatPeBccCtshsmYn2to9?=
 =?us-ascii?Q?1gjpcK7nS1VR2cPKtrm/9aLwaXak+h+t/2VFSBSkq7ub3y6lnOJAtOnDOev1?=
 =?us-ascii?Q?S8AJZfCaJ5cEhqaYo+29JDATjcPK4loLU/WhNpk0NDfufd0LB/DzsADEgi3A?=
 =?us-ascii?Q?mxBWnj5gzfwisyZQ8H4+RqDhh9g/v88UeVsTLfQAsLo7RJu6o0uZLxKCxHuS?=
 =?us-ascii?Q?Ef5qIWUWE+F3558+butnOrQt2iAliJgO4mCfjmy4Q9pRhYRD6AjCT3t5mpGp?=
 =?us-ascii?Q?gUHrpdHC0SAnHcinuPSaeIT3PdzkC+rsrR4EceJwfzxCRLfNyyhjy68GRes1?=
 =?us-ascii?Q?v3Cw4bDdJbJTlBpDfFk4wEd7v1KwjI0YJHhdbhPQvf1icTBWnrcOpAq1JFdw?=
 =?us-ascii?Q?hrDW88ZWXbpb57j1t3QIKzc8tOumVQphVKhTaMYiNq0FzQasuHcWyaaKyk8D?=
 =?us-ascii?Q?GIu5c9dhMM6/GTqw7i6PWvNu9NbU0hPzLWfZXnvg6vKP6BOKN6G/dNn5nf39?=
 =?us-ascii?Q?3nw4rhDsXBDvMilqYyyAmUiOqeJA3xNbiSDM4+Kumhh74hWeULoTtkKVCr2E?=
 =?us-ascii?Q?TO4wfvCbnK7tADABcoax6JirMmDNTTBfuQGEV3WOGqmjlfVTSLWVEefsHBgG?=
 =?us-ascii?Q?5DBOn0QQZMn1USuif+yspaOxDAlK5JqpAB0hd5I2l5PHwYpTFC797kuB/vew?=
 =?us-ascii?Q?VkshswEh2Bv4JNoDG3pUb4zqAZGfLphKIG0+?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:24:03.8419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1054accd-c6be-4d16-4cec-08dd92b84e20
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B078.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6410

All callers of apic_update_vector() also call apic_update_irq_cfg()
after it. So, simplify the code by moving all such apic_update_irq_cfg()
calls to apic_update_vector().

No functional change intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - Commit log updates.

 arch/x86/kernel/apic/vector.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 93069b13d3af..a947b46a8b64 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -183,6 +183,7 @@ static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
 	apicd->cpu = newcpu;
 	BUG_ON(!IS_ERR_OR_NULL(per_cpu(vector_irq, newcpu)[newvec]));
 	per_cpu(vector_irq, newcpu)[newvec] = desc;
+	apic_update_irq_cfg(irqd, newvec, newcpu);
 }
 
 static void vector_assign_managed_shutdown(struct irq_data *irqd)
@@ -261,7 +262,6 @@ assign_vector_locked(struct irq_data *irqd, const struct cpumask *dest)
 	if (vector < 0)
 		return vector;
 	apic_update_vector(irqd, vector, cpu);
-	apic_update_irq_cfg(irqd, vector, cpu);
 
 	return 0;
 }
@@ -338,7 +338,7 @@ assign_managed_vector(struct irq_data *irqd, const struct cpumask *dest)
 	if (vector < 0)
 		return vector;
 	apic_update_vector(irqd, vector, cpu);
-	apic_update_irq_cfg(irqd, vector, cpu);
+
 	return 0;
 }
 
-- 
2.34.1


