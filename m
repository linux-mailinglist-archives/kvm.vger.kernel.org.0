Return-Path: <kvm+bounces-46449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A553AB644B
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:28:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD00A4A3CD4
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E769214202;
	Wed, 14 May 2025 07:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MpwAFtl+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2068.outbound.protection.outlook.com [40.107.102.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47302040B0;
	Wed, 14 May 2025 07:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207603; cv=fail; b=s4RYtP0NqlWxgrNRub+o7C+vjZtV9GVH+g2yBYiC3CBtICQVmPsmqGSfMNigDuO0QSo5oh0uuIgZJRPpsJuxbTFPff2lrXx/gHSaHAN/N5IYOiipbeDV17tXmohH+jLfxCRWZrp6kSq7u6t+K9J13T9TQ1SinMhLk3iuUDIZhQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207603; c=relaxed/simple;
	bh=MLypz5x+F+4Zg7ZQgBQ0JVVGGOtyC/q8EEPPQo0+Hc0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=onD7qVg3EW7ZjlmMbu//a8wURkAfJRB8u/B9dnR0nF06UrMXfudx2mwkcUZtRfYob7Z+E3QMH6Ad0f2m+GTt0U/892OF+v0I0NsXtbsBAqiXqlEU59PQ8io5OEB2qeKAP8Uo5HEmZBVbOs0FcQF+z7k01DpK5jXUPamAnk2+0u0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MpwAFtl+; arc=fail smtp.client-ip=40.107.102.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d9gWuFTv66ZJneN6Z+14HdH8Ykziio1jOBNQRRg3FhIyXunaoPul+nL1QdMnC/0P8PEoBIuiaGZZqjE8A5cG24Nawr2E8UXFpRthrSrJGKCF9WCxN6Sne7BvfM2UOlOFiOchbBDGsCyhjlnugn2Z5ib0RtCV5WH4+Wo9CLakPhWNlg17eqpxLyPGBxSXMDmCcm7Sf1T3gaGkKh+8qmfcpvpQURajfh7Wa6CqQSYUp2tcNuDpz4tBgP15SLQUhJJhV3kTjDG6q2eEmlNmjLXNsRW177I56ZiWKC3yuNg/Jgx93rguvqWVR9NPbz3wGQpjhk3Pa1rKqanWvK7+BaJ35w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0N+g2xhxf8iJxk+zBjhv9c1acE3159SvmBKyO+wHCLk=;
 b=bSepFEtOdq3zmFrT+UiyjXpCcv3Ns9KzJu25qUI5kyhYIvegUB9rksTqyn9yqeVbbJa/xp0XsBCUJU6dijMVaepYHldPpLsObXxxCXGUxl2HaXdCEgN6miqmWPgLJ+ZsXAIe/dqA06l4+fsnDbVJz75rTEpThJr9oBnV+Uz8chhEyxW7g0Brywn1CcJJRWTC5GpwR5FFT5SdZLUv45ID70TTt+Y9qF/Wo1jfQaZIvp6pqlZqzmQwFmLBNFPeLFGoMyLGKR04DZCGp3F9LovmG+mEoQtcofPBH0Cy2p6mEZ8IchiFQAjMSLLenjgKISrt5dTHg4F1CSM3YfoHGA4ltg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0N+g2xhxf8iJxk+zBjhv9c1acE3159SvmBKyO+wHCLk=;
 b=MpwAFtl+rTiu8mEXxtD8AV0TVYjHccg1hgMMYNsLA+Q61dgslMXdgG5/gmAEIZz8LQmqCSaPDbcXaWNdvwUCJls94KZi3y4uuCSaevHZ8o3VRcCKK8F3XEeiSvUOlKnHY5OHssj/S26XYNLzyD6FORe4uN27jhdCggOBvF4aeQU=
Received: from BLAPR03CA0117.namprd03.prod.outlook.com (2603:10b6:208:32a::32)
 by MW4PR12MB7238.namprd12.prod.outlook.com (2603:10b6:303:229::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 07:26:37 +0000
Received: from BN3PEPF0000B074.namprd04.prod.outlook.com
 (2603:10b6:208:32a:cafe::db) by BLAPR03CA0117.outlook.office365.com
 (2603:10b6:208:32a::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.31 via Frontend Transport; Wed,
 14 May 2025 07:26:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B074.mail.protection.outlook.com (10.167.243.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:26:36 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:26:26 -0500
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
Subject: [RFC PATCH v6 20/32] x86/apic: Add update_vector() callback for Secure AVIC
Date: Wed, 14 May 2025 12:47:51 +0530
Message-ID: <20250514071803.209166-21-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B074:EE_|MW4PR12MB7238:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cf45769-ac26-4482-6b1c-08dd92b8a92f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vm/gMYKODd/aQkX4Q8COoroxrtdbVjNoHkIggDvaaDUIyiipxDXFjDoOO0EP?=
 =?us-ascii?Q?/xcsw2x8pf6Zfm03uUn39WH9ugXhnUrzIE6CmX1hjm3EeYIgSuXZioinSxNl?=
 =?us-ascii?Q?gSv15dKtk0KoecCKW/9mypjtEuGgA7FUUvMZp3YelaT8DTS7n3VqiBqVGQBg?=
 =?us-ascii?Q?72SVTETVK+pZOa2kxL6QbtwJDUs2qesZozBfUOdJFmgiAD3ZNQrAX2eJKjZM?=
 =?us-ascii?Q?S1aYmXjooPQnh09PMyIeEuFBP3gdC1Ez06cXk4+LiLIyt20biNF8UPcjPwyF?=
 =?us-ascii?Q?aTssmVBpgiq7eQpjZZjz74xOBMDkgkSiGj5OaKJZ0WwRPslgz5bkLCx6qcWt?=
 =?us-ascii?Q?uOXmbsNnxsgr+ZsPQradp1D6yU+CODj2WuYKBSdfu/evEWuE80jWScOZs1L8?=
 =?us-ascii?Q?PfXTPMIDEvp6fMaX/ZmAUMj7FDo4TXoPHnPxc/bzLFMNBk6vdL9uwxWGjzgO?=
 =?us-ascii?Q?NoBOnuM8/3+du/VM6fU9JJ9xw/i7v+ZbWcMoUSvSda4MGIIwICYnPhD2VWVB?=
 =?us-ascii?Q?JIEYC5QrBJvdksXnZjAG3uFpXor2XjxAJZ9vx8khrxxsYRGW4gWJB5AdnsBT?=
 =?us-ascii?Q?S5TUdjTrSkANrCq9/YEsRl4WuzVZpf8tpYkDW6soYXvvyDeqrxI9RedZT9VS?=
 =?us-ascii?Q?5YnSEP415HG2soziQNwzYTga2736YrDhuCIQCWGCdSHZS81jS5s1UYUONAJB?=
 =?us-ascii?Q?ENiWZs8U5htCamNzSPg3bFizDIN1IuKyMoqUCUTsU9/vVn6055gF7Mu4fjJ8?=
 =?us-ascii?Q?Idqc3XcFxPV8e6JPLgfnRD40hYPTw9sFW4Ql09ZoX8E9RfQMG1EvaN+uU8gM?=
 =?us-ascii?Q?hiLQ8iPWt1OBjZZnArqOwbdrofbVTRYKekw2SeMVtCO/Fc6wiRT1D3Ob1Bgb?=
 =?us-ascii?Q?rWmn1GWl4lqdi3yg2t/ZR/jEc3dfCOPr1paHbtUumqhK+E77pknQqs6rH2BY?=
 =?us-ascii?Q?E7zYdBI6KmhVpV171npgpLnbDk1C17673fxugcbq17L0Vk+Jsa85/7cXl8UU?=
 =?us-ascii?Q?7ndlaxh+EgRtbhpfSvSUZuswT+WCMn5dyF8O90l+MtpDk9VwP1AwldQ1mYvH?=
 =?us-ascii?Q?+Vy+NL46rL+jjg4dnajIo+QoSwL4Ht5dK5LpGKl8vJAKCv1scnKUumepn/5S?=
 =?us-ascii?Q?+6835Nmv6Z/NUbT5rghxhD0kRpdQbbVE0AcczNHTzE1+7zHThg+yaQnrTb+y?=
 =?us-ascii?Q?tWWQoVDz8T0rwC//AF63n9v9rQsjnvPlX/RSYUfyyQ9A1tPenRckxrdWmLUS?=
 =?us-ascii?Q?C5aOuJ62fs8uMbciiFpRMUinh2gpSl9OL7Y0olOzPtEAUCAoKnQeSd3BGpki?=
 =?us-ascii?Q?5OrF0q2K0WGimZZH1Llhqu5m12jXDfLuMJ7dOulBP2t0gxsJa83pGkUF1CtY?=
 =?us-ascii?Q?46Tl8KcFpRBqL9rRRNWyxoVG3h8PvSfFhJe+NVd2qx5yNqZshak4gClwwLIp?=
 =?us-ascii?Q?tdXluJrxqsMi1FWU/k41WiLO1xawFm0bCMsuClQY3rteKshK2vGGk5VQADUP?=
 =?us-ascii?Q?M/Rcmp1JOFOOeYypJ/VbsV6UxFHGPHnHu97P?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:26:36.6151
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf45769-ac26-4482-6b1c-08dd92b8a92f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7238

Add update_vector() callback to set/clear ALLOWED_IRR field in
a vCPU's APIC backing page for vectors which are emulated by the
hypervisor.

The ALLOWED_IRR field indicates the interrupt vectors which the
guest allows the hypervisor to inject (typically for emulated devices).
Interrupt vectors used exclusively by the guest itself and the vectors
which are not emulated by the hypervisor, such as IPI vectors, should
not be set by the guest in the ALLOWED_IRR fields.

As clearing/setting state of a vector will also be used in subsequent
commits for other APIC regs (such as APIC_IRR update for sending IPI),
add a common update_vector() in Secure AVIC driver.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - Use common apic_set_vector(), apic_clear_vector().

 arch/x86/kernel/apic/x2apic_savic.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 618643e7242f..2e6b62041968 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -23,6 +23,24 @@ static int savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
 }
 
+static inline void *get_reg_bitmap(unsigned int cpu, unsigned int offset)
+{
+	struct apic_page *ap = per_cpu_ptr(apic_page, cpu);
+
+	return &ap->bytes[offset];
+}
+
+static inline void update_vector(unsigned int cpu, unsigned int offset,
+				 unsigned int vector, bool set)
+{
+	void *bitmap = get_reg_bitmap(cpu, offset);
+
+	if (set)
+		apic_set_vector(vector, bitmap);
+	else
+		apic_clear_vector(vector, bitmap);
+}
+
 #define SAVIC_ALLOWED_IRR	0x204
 
 static u32 savic_read(u32 reg)
@@ -131,6 +149,11 @@ static void savic_write(u32 reg, u32 data)
 	}
 }
 
+static void savic_update_vector(unsigned int cpu, unsigned int vector, bool set)
+{
+	update_vector(cpu, SAVIC_ALLOWED_IRR, vector, set);
+}
+
 static void init_apic_page(struct apic_page *ap)
 {
 	u32 apic_id;
@@ -212,6 +235,8 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.eoi				= native_apic_msr_eoi,
 	.icr_read			= native_x2apic_icr_read,
 	.icr_write			= native_x2apic_icr_write,
+
+	.update_vector			= savic_update_vector,
 };
 
 apic_driver(apic_x2apic_savic);
-- 
2.34.1


