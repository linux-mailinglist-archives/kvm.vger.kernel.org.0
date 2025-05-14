Return-Path: <kvm+bounces-46458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 85950AB6469
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:31:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 171C3188A647
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D7020C031;
	Wed, 14 May 2025 07:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rdDzOCBj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2042.outbound.protection.outlook.com [40.107.236.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3742063F0;
	Wed, 14 May 2025 07:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207819; cv=fail; b=HwQ1/OorxvadnuAyowZDxrBZyAw5LQMi9i5jwPe8YdvjrtN9rUA1VGq5z570kh1PRVMG0eSAf/HyCJIyIh1CNLXQ1+mgdpANl6XVgDKwPOwFBv8hvdrKI72KGLukIz75ipeIu3gsOEa7j0Lt40mPnFfm1PP7yKNcmLSVKWEo9vc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207819; c=relaxed/simple;
	bh=/b7cK9Sgxh94guol1MhrFwq98Q1p+5Pn8I+TFwAgxq8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AVH9U9DGafJr4aRkeNU1TDZu37vwD/L4De4o0Lr/qv8OFGoNL0eb24crsepnvS4XyasWGlDA716BddNY8lxj2dDR4Z40Ax8y5VxuiNISVQ6XIIteexdbzcv9RjjQGl1U2iuQUhfhWA/WWXY3PElPedS7P2VQmkd6YSWmF4Mvnxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rdDzOCBj; arc=fail smtp.client-ip=40.107.236.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pGFK8uc6aljgl0xqY8CfzS1+dFrbTuAeC6sxp1m6d/kQs1TAc53sjhsprvHVkprniBIhzgsG8Z5S+obsaq/kUgVa+QKL5S83fHdWDmzJQKZpnwwR3Y+U0R+WLq6OxxyfwwIAG9kEJ9uts2WnKXxpDiARg/Y4izMjyuF55xbnhafFXiESFn6Q9UasBLk+UMwIQssnIef4gR8ITEjBzuNP9iRRxj3f/Hp8zgFtcmxeFNUj73p0GGgE7Erf2cuJHqp8sOcnvlQY9Z139IF6mvbE8ZdWr0YAjFhTL+ThuAFbP2PPN0durURMto08/0sCoN5PfwIqQUdcIyUCOMCjagqKHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sGD5k1zHcNaLHI1gFpYueDdjHDEm29BmINYr5zCLB8A=;
 b=GAkn0bWD6CXAZmud3cbMlxxlP1A05idLH2v7cRGj4tRQBrrF4SN26hLrPemEQpx6+hHCoXCxaaneRsgqVxdIsgAxh4Pb7Hz8MtBY37wcemMS4FnA0q5Cq/OC0XiNubOLBWpqKNS/5RcP/mI48PFjUALGXtls+oBAaJIuAMNAQFUQJXgX9DfTja1oM/6H+TiqVZd7IyYk9WqsFknL3RbDDtd4gLbOA727l1h7HUd/GicVwkCqZgTXLkKuLNLJudGUEmSnD3j6FVBloUxb/sIwgwmeJQksNfa5cQL9jGMIet6BPw7WmED4k5vMatHAXngUgsKQjzowtRBgguDZt/oQHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sGD5k1zHcNaLHI1gFpYueDdjHDEm29BmINYr5zCLB8A=;
 b=rdDzOCBj07U8/X5len3/vl/YLxy01L2aNjE1oIuM6uhazDvcE19/5IN5aR7H3TAjTv2aO1eMjXCxUVJxQ4rbP3YQxyZePIjum0ssb97fukTfopbfM/G5FhTOhHRcGisOjYBeq4wpVBqsoiBBqL6n33WYB+aNNlgMdgcs0+N9Rhc=
Received: from CH3P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::12)
 by BN5PR12MB9511.namprd12.prod.outlook.com (2603:10b6:408:2a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Wed, 14 May
 2025 07:30:12 +0000
Received: from CH1PEPF0000AD7A.namprd04.prod.outlook.com
 (2603:10b6:610:1e8:cafe::e) by CH3P220CA0013.outlook.office365.com
 (2603:10b6:610:1e8::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.16 via Frontend Transport; Wed,
 14 May 2025 07:30:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7A.mail.protection.outlook.com (10.167.244.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:30:12 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:30:03 -0500
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
Subject: [RFC PATCH v6 29/32] x86/apic: Add kexec support for Secure AVIC
Date: Wed, 14 May 2025 12:48:00 +0530
Message-ID: <20250514071803.209166-30-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7A:EE_|BN5PR12MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: 8569236f-00d7-4a55-cce5-08dd92b929e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LUaUElAqqWRb5CTYUMqHkAy41GiLNVl2IJx1sh7RoF8wrFWXQYhlaWdiLd6U?=
 =?us-ascii?Q?LR2+2SouRBad/3MIgZh/DwywAo7hE5iOwhf8hlA1t8iGq8xk7y3K6NMIVAlN?=
 =?us-ascii?Q?nXqdURYZqilN3SHETZ29VTBc/7qgeaQ8pGQA//VhOV1DCzHUVr1py46uqm/M?=
 =?us-ascii?Q?ImuG3Q7ajZkuN3rlVztRbcq1T+n7AwOL5EVUYz3D4Pxwa+3dUTjGaiQ03xFZ?=
 =?us-ascii?Q?wYDRnoj2cA7HEO1tbqn6ke4ewaC7XU8P0CUHa9cPB5UGvyS2coWcpQRRhAcj?=
 =?us-ascii?Q?LCyzfWud7aOfX8nfVp+qQ0Fw+tJpB88feYm4zB2C92IUJAKJxA7I/IMwM7Pu?=
 =?us-ascii?Q?7EruF6cUIR9WwYIzFFwJzcHDnqvUAetbbrWikK0/bVIpFsEb+QrxLLXUn0xK?=
 =?us-ascii?Q?tLYGJ7xg6n2BDYGk9tdg+KdCQxvNen6cSMzh8uhmAebFIxOhgFcWjorpL10e?=
 =?us-ascii?Q?ixxsf4fSDCANwC7U3Ova99d2tHkQFtW+d/DpJRnbMDtHOQi1ruC6m8b2MToz?=
 =?us-ascii?Q?+qXuRUeJM3yRoeepiWLAkojIr29bJbtGmerl/K3Ne5zV7y6IOBgAVF9VemYb?=
 =?us-ascii?Q?sma9IFQaNPBQ2oaOVK/aMfuJgzRmxcEyoyyG+yUqP9qjizBZBcS5Oicshknn?=
 =?us-ascii?Q?FI7G0KwkCta/q0YQd6Mtk6pLGhs857qCQbSOM9dvT1tD0n6emHctTJyQjUYj?=
 =?us-ascii?Q?38mYDlENDdjgD600iu9dkbyYzfcAo/EovC8Kafw8JWGTw9ZzopHqEq15IFsM?=
 =?us-ascii?Q?/VpPjoDoZiZRtt81jJLKWNvFDa9Kn51AdpUxfbCAl8VzEPgMW4Fr3IXcwOTD?=
 =?us-ascii?Q?eAFHyN/5zVDl+Vlk9eUbsI/EqnFJMP9ZFLdj6FQF4LZvjWZtkvF4d22YXDn/?=
 =?us-ascii?Q?VsMmCDjG5UD1iVPmtIHJQJreKpO+lz5LVLO4VGycarifXcWfC4Tma3mxE/6S?=
 =?us-ascii?Q?fm66zEh3KD2SUNJRcVc6hQgFJsCi3nrumwfq4W8IhnxzMLrtnY/9pLb1kpjP?=
 =?us-ascii?Q?YyNNYbTS6EqsdeBF9s/O0DxIzjhYoXwWaLr3r1erBtlKD1jHVRJG8DznTy4K?=
 =?us-ascii?Q?FtFQT+bN7jSrJqge4iiYuKayY6vOTR42g7t+52ceFwzqzaYYDW6/sdT4CYnl?=
 =?us-ascii?Q?hqb3bPwuCu6LZqBKtT4wt655SbAgx+yoxCWHGCIXyyb2gFrzkgjNZSfThlHp?=
 =?us-ascii?Q?67oNCplqyYe4Hkh0q34mjyIGz2FuF66UVdDgyBjfIVveOPua0UhG5+sKA8e9?=
 =?us-ascii?Q?TZOgtCTGcNFo7nUmL/Rx4aMn+DlaEyhhHTjA4EYihwcSHAHn0DYdUn1Vcafy?=
 =?us-ascii?Q?tJKVILYZZYwdv2bvtVO7kAW1drC4+wkJLOBgBwdUvDd5BeYudLtmIfGLQhT/?=
 =?us-ascii?Q?eEDcoRClUQYIg1zUsuL7YUT+dXdiOX33IepEgTsQcVAcC8e5/2RIlwDHdPAv?=
 =?us-ascii?Q?hM4jRRvTixNXWGwrGBp4EHsxEvN3PW72fMn1Ln06WtnbiWeDqR5MIpryom2r?=
 =?us-ascii?Q?heYEtFs+FGKqKRE+rgIXkU1lz0CkxcSqbSSu?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:30:12.5260
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8569236f-00d7-4a55-cce5-08dd92b929e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9511

Add a apic->teardown() callback to disable Secure AVIC before
rebooting into the new kernel. This ensures that the new
kernel does not access the old APIC backing page which was
allocated by the previous kernel. Such accesses can happen
if there are any APIC accesses done during guest boot before
Secure AVIC driver probe is done by the new kernel (as Secure
AVIC would have remained enabled in the Secure AVIC control
msr).

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - No change.

 arch/x86/coco/sev/core.c            | 23 +++++++++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  3 +++
 arch/x86/kernel/apic/x2apic_savic.c |  8 ++++++++
 5 files changed, 37 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index d2a752a0eeb8..10f8c6a2555d 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1085,6 +1085,29 @@ enum es_result savic_register_gpa(u64 gpa)
 	return res;
 }
 
+enum es_result savic_unregister_gpa(u64 *gpa)
+{
+	struct ghcb_state state;
+	struct es_em_ctxt ctxt;
+	enum es_result res;
+	struct ghcb *ghcb;
+
+	guard(irqsave)();
+
+	ghcb = __sev_get_ghcb(&state);
+	vc_ghcb_invalidate(ghcb);
+
+	ghcb_set_rax(ghcb, SVM_VMGEXIT_SAVIC_SELF_GPA);
+	res = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SAVIC,
+				  SVM_VMGEXIT_SAVIC_UNREGISTER_GPA, 0);
+	if (gpa && res == ES_OK)
+		*gpa = ghcb->save.rbx;
+
+	__sev_put_ghcb(&state);
+
+	return res;
+}
+
 static void snp_register_per_cpu_ghcb(void)
 {
 	struct sev_es_runtime_data *data;
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 49abcd85d2f3..25e836098aef 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -306,6 +306,7 @@ struct apic {
 	/* Probe, setup and smpboot functions */
 	int	(*probe)(void);
 	void	(*setup)(void);
+	void	(*teardown)(void);
 	int	(*acpi_madt_oem_check)(char *oem_id, char *oem_table_id);
 
 	void	(*init_apic_ldr)(void);
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index bf42cc136c49..ba68d9a17322 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -521,6 +521,7 @@ int snp_svsm_vtpm_send_command(u8 *buffer);
 void __init snp_secure_tsc_prepare(void);
 void __init snp_secure_tsc_init(void);
 enum es_result savic_register_gpa(u64 gpa);
+enum es_result savic_unregister_gpa(u64 *gpa);
 u64 savic_ghcb_msr_read(u32 reg);
 void savic_ghcb_msr_write(u32 reg, u64 value);
 
@@ -596,6 +597,7 @@ static inline int snp_svsm_vtpm_send_command(u8 *buffer) { return -ENODEV; }
 static inline void __init snp_secure_tsc_prepare(void) { }
 static inline void __init snp_secure_tsc_init(void) { }
 static inline enum es_result savic_register_gpa(u64 gpa) { return ES_UNSUPPORTED; }
+static inline enum es_result savic_unregister_gpa(u64 *gpa) { return ES_UNSUPPORTED; }
 static inline void savic_ghcb_msr_write(u32 reg, u64 value) { }
 static inline u64 savic_ghcb_msr_read(u32 reg) { return 0; }
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 69b1084da8f4..badd6a42bced 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1170,6 +1170,9 @@ void disable_local_APIC(void)
 	if (!apic_accessible())
 		return;
 
+	if (apic->teardown)
+		apic->teardown();
+
 	apic_soft_disable();
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index a527d7e4477c..417ea676c37e 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -345,6 +345,13 @@ static void init_apic_page(struct apic_page *ap)
 	apic_set_reg(ap, APIC_ID, apic_id);
 }
 
+static void savic_teardown(void)
+{
+	/* Disable Secure AVIC */
+	native_wrmsr(MSR_AMD64_SECURE_AVIC_CONTROL, 0, 0);
+	savic_unregister_gpa(NULL);
+}
+
 static void savic_setup(void)
 {
 	void *backing_page;
@@ -395,6 +402,7 @@ static struct apic apic_x2apic_savic __ro_after_init = {
 	.probe				= savic_probe,
 	.acpi_madt_oem_check		= savic_acpi_madt_oem_check,
 	.setup				= savic_setup,
+	.teardown			= savic_teardown,
 
 	.dest_mode_logical		= false,
 
-- 
2.34.1


