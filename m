Return-Path: <kvm+bounces-48850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B56CCAD41A8
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:07:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68EB118902D3
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:07:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603FC245038;
	Tue, 10 Jun 2025 18:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nqVuFtbS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2065.outbound.protection.outlook.com [40.107.236.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA4B236424;
	Tue, 10 Jun 2025 18:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578840; cv=fail; b=E3NP8/q0zDcW+s4MWP0QtUHMfFZ8zngz5f9R6qJvgz6XgzzvDN6aycHgnwq+R/Rt+YA+tHiTg5liy+rLtrwIqTmehI4XKlpvD/WVQg1zH5N7glEosCfnKknkT2kbv+hXR+3HG/XQu5KWYxLkZbMPe5/sjtoN8YD9TyxgEV7jRfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578840; c=relaxed/simple;
	bh=mhU5Um2FLqJc+2ttzQyDHE4Jq/S+AFkz7oC94YBB3qU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dRkeGnEpR+aFR0wBSkIkdE9LIAbB48X0+Y7i+lXV86aA//iO1IKmRyueiejY0Hzoa55H2XYc/o/oWNAbdAFTz4+JKrmqK9eJh15ZXKyFvRexo6JAM/DMeYkDVT+bxysobh3SrYn/f+v1LUvELZIn6ivD6GX7WiZs1Dma1Q4zuy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nqVuFtbS; arc=fail smtp.client-ip=40.107.236.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VV5c5y97xKyHJqUa5C/9cfdYbHEGV64QR468lsSWGBdCz09+pE9WFH1HGatX7rPoob011CIVE8tv5rGFtmO61rLCrsiyVntZGfxglgWaU5QERMqO1wpKoKcnxgsMMDJd8kQKWp0BqDw0Ys1KLttly/jqRaBCr415LODz+28AbWXCKkCsWKMS4ghrnmJWG9jvB5DxKn9S+B/Rs6vC1U7x2+MinqQDcyc0LENI/Ht77VNUiNuYGU+jip/ucxelr9JpcrvSreYpkVbwrYayHkFtpRSuOUxj6TtrVB9Kb9pNaLgj0oGaF+JXxx9JU9cHRHst69yWlTKGwgidXs31JlGjmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9fdZs53FOX6ui2E85Fu3mMwOonVibiUIIkzE/qU/rw=;
 b=iw8UMA+wOzMGhcRXB9w02fwphIZArXRGJdHs5C9o/ScSONhSh32XNysaLP8fWHZCjHtJkIVIkWi0T6QVBNgVcaKvekZyY4SW91pUnRpFcRZ3EptGwMJBVgSNCJ7hYzXAT/3j8rnm9NE7OiGI3EuyVlLpZYGzQFeOgVmuRLtLGdTQVtuqQQoP5Ry6x/xfQgm3h6b+ektse7BMctU6KFdRRHaYDqNXIQpb8bSEeYjDACz/2ZxYI5p5QJzNsFbMkuE1Do/n5NmL0BLAuLZdWnyQfKJDb3UeIyN1rODtCccoakJVs1c6Tbz0sI6W8d87EspX9aDfHRcxWy3/NlIaafFDgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9fdZs53FOX6ui2E85Fu3mMwOonVibiUIIkzE/qU/rw=;
 b=nqVuFtbSk+Umz/PlPd9QF53qrh2NiC7IQpkxjJbURVtTMo+FeupdH/W/hkxZLXxtJD8C9Yniw3LojGB2s/BkhjBax9eCU6PJ/Qo0NkIZbOwoDRdKnU9ioZfsZYVcIbSrzKX4aCArLLQ8hPBnX1hfc3d7dT4wrc3gZqszTKcln3g=
Received: from CH0PR03CA0229.namprd03.prod.outlook.com (2603:10b6:610:e7::24)
 by DS4PR12MB9796.namprd12.prod.outlook.com (2603:10b6:8:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Tue, 10 Jun
 2025 18:07:16 +0000
Received: from CH1PEPF0000AD80.namprd04.prod.outlook.com
 (2603:10b6:610:e7:cafe::62) by CH0PR03CA0229.outlook.office365.com
 (2603:10b6:610:e7::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Tue,
 10 Jun 2025 18:07:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD80.mail.protection.outlook.com (10.167.244.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:07:16 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 13:07:07 -0500
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
Subject: [RFC PATCH v7 34/37] x86/apic: Add kexec support for Secure AVIC
Date: Tue, 10 Jun 2025 23:24:21 +0530
Message-ID: <20250610175424.209796-35-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD80:EE_|DS4PR12MB9796:EE_
X-MS-Office365-Filtering-Correlation-Id: f3124923-d515-48e6-4673-08dda849a21d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xye3WTXb4Ef6sCnR7u6VVNe4hPuVu8XExvABmGaJLx3N5Jo8qdSXwgUzSwaE?=
 =?us-ascii?Q?+mcsVkayGSc0Y2JHIMpSmhg5H8A7FQZ0zxgs7Gxa7pF97/x32RrvXMk67xbP?=
 =?us-ascii?Q?ZqioRQ/A7ZkWq0OYbLd88z9S+v/rx9RQWd1yk/uGHm6n4SodIq4occypDyOQ?=
 =?us-ascii?Q?CDLblHe3LZz2IM+/ZexBHQweb8pT1SyuMaXErAKb8851kmMeN17NrT1r2L0t?=
 =?us-ascii?Q?EUaEocCNmd4JWGAvcU0jdBjJmR3A/IrREyWZQlu1s61ZJo5ZRXFnIZi6XNBF?=
 =?us-ascii?Q?G4sSuXgCx28mXrHNizF8uiux22TO5UPVnRfn+MqUzbxHkj156LfNkPaNFBCo?=
 =?us-ascii?Q?sxGU7u6BCpTk7xgNOqMzhi/8vAKKT9N7miAOIcg3UgNU3TbjyTolEbB/Bux3?=
 =?us-ascii?Q?X3BOLm1Uit/a9q0PN3M0jVE1Mr+83/W096/1LDndEof7dXM9NcW+gJxuxEev?=
 =?us-ascii?Q?jnkTklTQ0OESbFN9NbFMDcTudJsTtAEPtKJD+uzFlfNdD9g9iVq/ZQJuzKeE?=
 =?us-ascii?Q?FTEzgMBxH13wiPaC8dyp7SWWQ4i3FCgR1GTuYGdvWtP8vmlh/fDW0xFQss5a?=
 =?us-ascii?Q?f5Ro4O0NI2Vf6zpXuWY/bGIZHQkF/Wq/ZNYKmaGqzhmXBsqnXQsDPmicYE60?=
 =?us-ascii?Q?QFGt5d53blEfUyYUTwQM+fxziPXcqRM/BooDwUDhhyavAn7+ge+7qazQp6PB?=
 =?us-ascii?Q?UQfYQ6NevIsE8Udrrx7baTACSz4eWkfHAJVxku7HTqnoLbHOAw3WKvetD/7F?=
 =?us-ascii?Q?fWvz84uDUL4aRJ/Ktu9pWyAlvi2KMq90eS+KP7d90Mm5FdcLnTohqtsen7IT?=
 =?us-ascii?Q?oJDtWuS3hseYL/OQWayZWdplrSa3lh+2LGQHiDIzYKqJ/vAN9mmuxMQB0Bd7?=
 =?us-ascii?Q?R6x/tzLCgHVl4p9CTFf0d4BUtADXpglwS/OGYIbN/UYmZphpobNgyF1UM2Tr?=
 =?us-ascii?Q?tjujoc23M7JSDCBWwjvTX5yZ2hqyhoit0Q5LO+A4oA444HuKQS0UOhMXOh+R?=
 =?us-ascii?Q?tjrIm98B5/xmxm3jadUtadi3uU2UkRkf2pXXvso4aVO//U0j3TLDshXpIYfw?=
 =?us-ascii?Q?QJ/n/XIKwbNJmWe9073XBu/A0EiEtqS+eAO1pj+GHV76igYSAglCY5ioGPUu?=
 =?us-ascii?Q?G2lEctDwz8lGdJD6SSZte6DIlvo24WAEH8WBNoxejrjC+uvN1sOFwmiuqgII?=
 =?us-ascii?Q?ORrFVFUfq4cab7VNZovSYFNzRNG21rsOLwGZQJVc/ybSo2mm4n8PP3rufFDs?=
 =?us-ascii?Q?4uopXm/wQWBkDGOD52G2VSOGNAUeKcMR++hO6ucoeq5FTA97zz4yswGpVd91?=
 =?us-ascii?Q?fZwP+CCytbWK78CROsOY7kbKqc3pRmjYiLC8XOsllIsN8MlJEmmZy4QYccfx?=
 =?us-ascii?Q?zkuQHXS20S34ya0jxaD9TPU6UkLxzTKJ7hKowYfo+2FzU+l6fFGBJqcl0nOj?=
 =?us-ascii?Q?9YO6s3o65fXOMIB9kDrgI5eK2H1AqoCbaO42V/y/8Ja81D5HRLWcF4PcAPmP?=
 =?us-ascii?Q?fFbRE02OZ0nGTtgK+wFGUHp3nFojc42V8Qyv?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:07:16.1829
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3124923-d515-48e6-4673-08dda849a21d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD80.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9796

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
Changes since v6:

 - No change.

 arch/x86/coco/sev/core.c            | 23 +++++++++++++++++++++++
 arch/x86/include/asm/apic.h         |  1 +
 arch/x86/include/asm/sev.h          |  2 ++
 arch/x86/kernel/apic/apic.c         |  3 +++
 arch/x86/kernel/apic/x2apic_savic.c |  8 ++++++++
 5 files changed, 37 insertions(+)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 50166c16428a..3afafcc14541 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1151,6 +1151,29 @@ enum es_result savic_register_gpa(u64 gpa)
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
index 9c74d1faf3e0..e8a32a3eea86 100644
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


