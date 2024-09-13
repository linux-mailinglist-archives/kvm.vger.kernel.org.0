Return-Path: <kvm+bounces-26803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B3E5977E97
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 13:39:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C20FBB250B5
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ED941D88D8;
	Fri, 13 Sep 2024 11:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IzsvzCL0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2066.outbound.protection.outlook.com [40.107.212.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37521D86F0;
	Fri, 13 Sep 2024 11:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726227534; cv=fail; b=aO7lW1IiHJToVSrGGVQ7bQsjjFCngfEDSg/C4TdnOo6CuDtLxo+c6g8DxnAiqwh0MmoW/y2r1LsHpGyWRTEKSnzqv5KibtU6qta1B7MsjTN/Gm5vyYwsa6BmrMfILllTr1xhOioFtRIID5xeCBNrQN7yR+uOR1Ow/Qw90mCkEsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726227534; c=relaxed/simple;
	bh=688OwTuSKRUrr+niWsRX47KaQUr+at/gFIaoZaLdDIU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LQFGi1LSF6A9niKnHOG/vybKT1eftJ/gH1uL9EDkAFdvvgxIporTkMwqw2AfsdUVFi3GhN//xiaNaVowTBQhPqZkxCGfDrSl3XIN06e8HBczyX0LwebphRURXorq+Fib9umkxngbYjU6tZ+iJUi/Q7miOYrnN6C8xj4+eFcFT04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IzsvzCL0; arc=fail smtp.client-ip=40.107.212.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VYqIFRWiw6SD5cgc0qVdvQ1aZxsFfuWQWXRg/3WLk+n6kRSuITikawAxSAYa42KH2rlsMcO2yMpLidYxn4Q9DZFUdGq6l2HA7fpL0WAy1CRhcDmctY30gAV9CJKccduO2Qazofq1qAS2YwtMQscFJUbseH4mTAtBuZo5Fs1Ts98MQ0y5R1JS27ANpbZpo3lbdxy5aS3I3jVVUiZevgq5he3mdGRfGEmnoHf34fLqSVEZfJRKyobxkRUNIZtUapZ+Bb1DfqSL0ngGL9Bu4dEyQupBjkNFvngS38PwyYRiYYg7JxRsEoQoClcwYqeaLAkUNggEuIy2OM8J5Lpgmbzlkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FSrkFnyDES4wibsgsbditU1xGjgk9SHYJpltoDLO7Ts=;
 b=tt09BnYMutR3U//EQh7UH5PbFq07MPv47C4YZaXL/W2TuFeuIn/cfPvpNe897/UDjQPwZpfa1SGWiwOX9wlxQ2xqKp6DYXCrXTPSFoxkHNX00d9QKrwgCl6NxACP+O0QIEce9ybt+Pl7+CdMJ97WWFcqCdak0Mkj+WzBqTnonEvdagS8n3CpN0f9byHJLm7Yqh0aETsRlv7zu18/9f3PJtZNA1xgGHozHm5tV473sLq9W9Q8Grr++GBnF7AOj3ECO8o+IjKyxrt9VVE1rvfhaxqbx3W8DPgGC6xW6UaP8xCWYXL5BDFr17uVKuhpinxNvW7tZbl4kiITPbJi2DWGgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSrkFnyDES4wibsgsbditU1xGjgk9SHYJpltoDLO7Ts=;
 b=IzsvzCL0XjeglSSvhxQsCla7Aeir6HEQsc6Ih3eb7sxnRLownmfZFo8/F/rP1YZFXvjgaUiYn8PiyfpRzedsaXPL95YBjFD9O4Pa42yR4/k+a8eTi+D1MekiPUoek6J8KzkI+XN4ZDRZx+m4YFW0ED+WzyaXszhCr5hHCHMi8LI=
Received: from DS7PR05CA0060.namprd05.prod.outlook.com (2603:10b6:8:2f::13) by
 SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7962.18; Fri, 13 Sep 2024 11:38:48 +0000
Received: from DS3PEPF000099E1.namprd04.prod.outlook.com
 (2603:10b6:8:2f:cafe::5) by DS7PR05CA0060.outlook.office365.com
 (2603:10b6:8:2f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Fri, 13 Sep 2024 11:38:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099E1.mail.protection.outlook.com (10.167.17.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Fri, 13 Sep 2024 11:38:47 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 13 Sep
 2024 06:38:42 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
Subject: [RFC 05/14] x86/apic: Initialize APIC ID for Secure AVIC
Date: Fri, 13 Sep 2024 17:06:56 +0530
Message-ID: <20240913113705.419146-6-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E1:EE_|SA0PR12MB4432:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dc23e07-6566-449a-f0c9-08dcd3e8a1bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ddvp8ogxlUZrQYqr3WOVBKGUFPmiFhQyErXU3n14CGCjZCyr0ZO3iFzoQT6u?=
 =?us-ascii?Q?pPZRXFcv7H6zE6WTjKXnd1y9Z+sEivRM7ctTqJHnGi1sXzrI5jzft81X4k0b?=
 =?us-ascii?Q?9CQ8WxXZC/PFUgmEHl82oIVt2oNHLbEk4nYc7w6PQaiQQ4fnKcZ2g9cZTaUg?=
 =?us-ascii?Q?1jrm2SCNuyuEpC7Hh2bADLDHNyDV8XOFH0PRMZACRlYgrioC3kTjLP+FiGtD?=
 =?us-ascii?Q?n88iZ+DsXK3shZV604yjjWVdVK3WQUaxiodsRdHR6op5wf+RBQ40oZFr61oW?=
 =?us-ascii?Q?mjt9e7R99PWf0Rk7adLR+I4tm5u2rJYutW43N3HiuZPUMq9Oxxcyzx4DdXU+?=
 =?us-ascii?Q?eUotHFq/OP3E2loQ4B3WIeIASTvVEY1f2Pz0eaJTLaDIEBoMlnlMAT9ggJFg?=
 =?us-ascii?Q?Z0yi9TwqPUWjHlL6KU8Yc6PpMWOaFJI1U76Ov7IuT64/tIbAeKNJFdGsv4Gw?=
 =?us-ascii?Q?UhrMh51afYr6SFYdC1iVHi9T5xNGkjp7QB6ZIO5J4ZCbmtEKgbPjhUMxbSjD?=
 =?us-ascii?Q?FyoFkNb/DodcMhwGJYy8OBpkN8YPr4ISx2MpBuWcaAv5KycQVm2q0+NBW7uD?=
 =?us-ascii?Q?Wo3G4t3aQFbjmXsz4e3jCgxV6+QPlmT8BcQxfac1ZeOmqMBX5wVpRkC8iY03?=
 =?us-ascii?Q?qiQKQGGgJZzUljYbpAOS1R0qGIo0XPCdA3Oj0hB6iehjCgK+DfEVjRjyHZWB?=
 =?us-ascii?Q?YzTfv7IgVMICZ24+QWT1DpbkY9ZPxWA2wnK8mNwgxDMketcbPTy3iufa7V9j?=
 =?us-ascii?Q?9UtMOv5AEL+vrlA0nU37cjx/+X3evQj5f+BnBEh3T8s4apReF4GlyyUnpboM?=
 =?us-ascii?Q?ZlsoArAqDaT+GOAdPCk11BDdEqIhHnXYHUAmpquX6m6LbClS8lACt7hVArtA?=
 =?us-ascii?Q?wlfXqVWgs045tvu/HNI2dpXo+tQEDIWqPQmXF7RMxQtm5kc0voJKYzT25k6m?=
 =?us-ascii?Q?2KeHQfffuqqbyLiQY74zJ7IDaftY/KrVIak7gaLxl6BjCvQEB/Mgp4w1uWKq?=
 =?us-ascii?Q?rNEn6lREaKxgVUZ6h+LTZGTKMwgyD/9GosFuvRs+ZWCYGk4b1zkTEuBJJ1d9?=
 =?us-ascii?Q?Ahgj7tMD5oFa2IwJA9cr7IGE8d+VLBpBwdaWh5I70grV8Khwcmin2n2aogwz?=
 =?us-ascii?Q?nODra21quNJzLIJf53WXGx4YoKUAW5BekfAXGI8q0Ap/mQAwsiGUE7tBnnLE?=
 =?us-ascii?Q?ILZ/Tb7nIcha4kkZpR9m4pWls07N19uN5242fKGSTOtjp9WsMXMAD2jLWFWn?=
 =?us-ascii?Q?l6uZlC1gtmqnptTpvikuQNSQHnDkfCWNgwqZ9ENjdCJVVZOnHY497JVbBft7?=
 =?us-ascii?Q?+csrzzPm/RP/PPVzjsM8VnZDATckTqLPTPxxYjR5o83cKLZTYghe6KIIWsxG?=
 =?us-ascii?Q?h4UWoHfCz+nBBYRw2NGXZ5gMrd5qCn0lPPFqKEXvN52kFjiIjQKNU2S3L3s6?=
 =?us-ascii?Q?oZmhej+hrJcOxH5BrCZd1gfiAYaHGvHe?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2024 11:38:47.8127
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc23e07-6566-449a-f0c9-08dcd3e8a1bd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432

Initialize the APIC ID in the APIC backing page with the
CPUID function 0000_000bh_EDX (Extended Topology Enumeration),
and ensure that APIC ID msr read from hypervisor is consistent
with the value read from CPUID.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/kernel/apic/x2apic_savic.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 99151be4e173..09fbc1857bf3 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -14,6 +14,7 @@
 #include <linux/sizes.h>
 
 #include <asm/apic.h>
+#include <asm/cpuid.h>
 #include <asm/sev.h>
 
 #include "local.h"
@@ -200,6 +201,8 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
 
 static void init_backing_page(void *backing_page)
 {
+	u32 hv_apic_id;
+	u32 apic_id;
 	u32 val;
 	int i;
 
@@ -220,6 +223,13 @@ static void init_backing_page(void *backing_page)
 
 	val = read_msr_from_hv(APIC_LDR);
 	set_reg(backing_page, APIC_LDR, val);
+
+	/* Read APIC ID from Extended Topology Enumeration CPUID */
+	apic_id = cpuid_edx(0x0000000b);
+	hv_apic_id = read_msr_from_hv(APIC_ID);
+	WARN_ONCE(hv_apic_id != apic_id, "Inconsistent APIC_ID values: %d (cpuid), %d (msr)",
+			apic_id, hv_apic_id);
+	set_reg(backing_page, APIC_ID, apic_id);
 }
 
 static void x2apic_savic_setup(void)
-- 
2.34.1


