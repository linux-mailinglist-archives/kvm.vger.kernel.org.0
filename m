Return-Path: <kvm+bounces-18489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B14878D5988
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 27213B25727
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BFAF132109;
	Fri, 31 May 2024 04:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mqxqcnqx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C8C823BC;
	Fri, 31 May 2024 04:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130091; cv=fail; b=gANCK0/+IrgrB0eR6UhyJg7xSAlRnPn14c0799GSfcpjQIWhPVLszOqzAPqb9+KPsDO+GNZxyg89MZsokYm/LPH4ukOwo86JUgQyUJyhtcmEGUz78+gmszOGQ4+24RDlfFqCQvbm/nydvWDPV5LK/3GaGCr7vBucfzOW7d6gReQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130091; c=relaxed/simple;
	bh=Qhaju30KipVL3Ll8fiKoLEqeztNPGqtph/BGVhSyR00=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P+2QvwCjtK683FvF30nA5gUv76J5EdHeeM/XZMlN9Lf2W4wRlHclncS7BXua3s6CK3Crua4ZYGtNv1A7eVSUxS2MoAmf5fqwOFKxl4AZNEQWuF0t7qFYEJyIfvw3pA4SB5EeBhq8GWkmvZV0AU/9en/RLh67OF0CeXqbQTrn9z4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mqxqcnqx; arc=fail smtp.client-ip=40.107.237.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XU80TUA+KqrFw8thbC8/HSX3sr5cdmnPfwedzxjrBUAT2hMdPtWnpNhl3S3jF2aCb/WlxVyMka1AsAsDYHpTgFSDFXZ1gjIRiuf6hE/aFkwDaknPo0WIkftAmxIryBt29piblJ4rhP50sGHuHoxqbhyMYphLTlQcChYzXxt5ZlL7K8N5usJxkTctQ5kbCoiAo5TONesCY09bq67PwAA7m3jWvnd1PzQeuprOm+Ck4SqMdnKnSbsgbPF/1jtM86ABE61SyiGqJvESq4Xjfet3HzpWcz1IlcjbxsSQ6z/T5H9/zC3Bs77+qXlshdNGKvnIy/n7ToW+OV5nrMtwC+6xCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cqwMbsLTloE6koXkAIOHwo2P0VGFRONchM4ZooyM3iY=;
 b=Ml7VVGVrHfirmqhVJD+TAvkl03lmzKYGGFNPL5FtqYl0j8xuYjvx7jwLpmcl/G2hlTv+PdihfmsKOlR9vAqJF8LRo2eozogQZMi/TtzOjVPVylxWHwG6OOmn60crtPleX6OEkwnw81RP/yjSZDDNiKGEX8pB53mwWfQy2JtXrE/TBdMr3m8NuRRhp/OLsRNp0KybOtc/Bft1BBLrpZkgOv+yveRsYNRvD1r3osabPjnZJUhsxyPEoOnV5T3Eso/WMGHdXlwp69SakZ/pbq095BsHscQzEA38fp+itfp6OOe/6rSwL/6p5wpV5uV5v0jta2OihJ8KA2etNXmfgNLMVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqwMbsLTloE6koXkAIOHwo2P0VGFRONchM4ZooyM3iY=;
 b=mqxqcnqx0cBnC+/1ulozspS+ZYG4FhdhVu64h6tKQ5yqiw+grn3m61BndMcgaTNEQB59nLjlmSFrF3HWIo/CmJ1oSDPHCRX2nCb87CFu1FNxsRJZwpaGR1ddgvEBcU1kc2sfDXmbRYnnvtszntk2QA4k0qlIEdMPfDR2xjuIdso=
Received: from CH2PR07CA0046.namprd07.prod.outlook.com (2603:10b6:610:5b::20)
 by MN2PR12MB4424.namprd12.prod.outlook.com (2603:10b6:208:26a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 31 May
 2024 04:34:47 +0000
Received: from DS3PEPF000099D8.namprd04.prod.outlook.com
 (2603:10b6:610:5b:cafe::68) by CH2PR07CA0046.outlook.office365.com
 (2603:10b6:610:5b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22 via Frontend
 Transport; Fri, 31 May 2024 04:34:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D8.mail.protection.outlook.com (10.167.17.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:34:47 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:34:43 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 20/24] x86/sev: Prevent RDTSC/RDTSCP interception for Secure TSC enabled guests
Date: Fri, 31 May 2024 10:00:34 +0530
Message-ID: <20240531043038.3370793-21-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D8:EE_|MN2PR12MB4424:EE_
X-MS-Office365-Filtering-Correlation-Id: ab0180ac-01c1-4996-7b14-08dc812b0080
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|1800799015|82310400017|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IQMvkIeLADztyziUK7JbWdZLnJNqgYYBYqJ/uIFG6CtmqDWJiFE1oZbJ0vJh?=
 =?us-ascii?Q?/iNPNwo6fq/0CfhOkKF7t9vC1AZUkmUYKZSItKfUbMzWqUchP64ZZGvF4nVm?=
 =?us-ascii?Q?fu2EMU0Kytvln0cnhMb/fGkMSnkITN7cq78u58J4+Aoh3ZvoR8TuTzOpmB8g?=
 =?us-ascii?Q?Z1hL0Yxex60GE9w98ciobrlsPfxCQucrQ4p55Wtht3dmFvnFDEaqifQojFg8?=
 =?us-ascii?Q?Xif/TEg4NzT/4na2bCFhPvHaHQPAG9xz9VvXOeksIReRH+1ThaNcraciXmaA?=
 =?us-ascii?Q?xwLZvFHfVhruGcYQm0+88BqGw4yrU+zxqDt3ykMrj0EO6e7rVsoFpMRkWeNc?=
 =?us-ascii?Q?vd0maHj/fMuge9kbMeFpb4MZdIMfFk6kRKnTUan5iKJwcHm11p9RW9GnxAdw?=
 =?us-ascii?Q?BYR9hvBCMV8bZTauDfJ4ItY8pjOllJQA4pDXO+uncauIhUklw6tBm3Thth0d?=
 =?us-ascii?Q?UzcOYeq5I3Ie+LHPq9jDjfdTKvXkXeeAnSoS9kM2VJ1HEQKdgqkmBxnp0AsA?=
 =?us-ascii?Q?QfaANipv3TzK4gwwbwTlybKaqx/DXVY+jY558TXhMeVv/E+dj6fFS+QooH92?=
 =?us-ascii?Q?I2b8GFmjM+AaMb4ptErpooVChtylVqrQPeKoAQIzGtzJuosRHrStim3c0SqO?=
 =?us-ascii?Q?2l3z8w/rJpfkKoRUbZ3Ae/wlTkUoHMkLRD4KBsvPj7XEen/DYsxpnd/e1cZq?=
 =?us-ascii?Q?MEfgBs776GlYf8YXUCU6z7LGnD5igeN9i3VtOat7EfyB4YqdzwUnggEox/nC?=
 =?us-ascii?Q?RcstovN34niydPtxyEpmQP4RyiRE/qw4IEu6gy0NgNU79ulU/3Jm8ryOqNf8?=
 =?us-ascii?Q?m/OAZOiTjdSGZB48qAIl7dNuXM6ba4w5+WoYAsViSM8q2ypdLGPzIR5mkZCM?=
 =?us-ascii?Q?vd3eOtMQCbv0ukklEK0cNOCjl2rmYHCl2M6VPyGAhZKXOJoYx9wbHPOIzga0?=
 =?us-ascii?Q?j1Xqjs0Z+mIOnR8ohr7ea6mq21RV4LRBmrnQJJ6Ewva4EP8761f4JmPcCajH?=
 =?us-ascii?Q?gdoW2wVDIacieTd5aiF/ec6gjnK3Hl+KborwfT95q9bfEUt9DAXVe2zHXyBI?=
 =?us-ascii?Q?Gj7+mHfsaGc7GCwYxbhHU4/v3X7F92XkYasTkPY1TKfcCvaVFz98Y3MfcZk7?=
 =?us-ascii?Q?JqGzfPrJ0wxQzT/zDqW/5xpmp3s4UGUKvnujizAGRt5TnLfUVvptxM/12oOa?=
 =?us-ascii?Q?/dQGE3QRfL03LuaPzVJIoI2h+1MHuoDFjER8Wsdkubah6i/pA54uT3ptaVwq?=
 =?us-ascii?Q?dwHxYL8+7hRvWt1NYOdPxfYMWe8VEN6iBx0o+ALI12vooqwdNdMdLTPNCfGq?=
 =?us-ascii?Q?gO1MpGpE28JC14ujgfOX3r01JQzQmE9jE7rZinTZ7wfSRZWjCY0DnNtzvPHa?=
 =?us-ascii?Q?y6DQYvc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(82310400017)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:34:47.0983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab0180ac-01c1-4996-7b14-08dc812b0080
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4424

The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC
is enabled. A #VC exception will be generated if the RDTSC/RDTSCP
instructions are being intercepted. If this should occur and Secure
TSC is enabled, terminate guest execution.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/sev-shared.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index b4f8fa0f722c..58888a086dcd 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -998,6 +998,16 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
 	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
 	enum es_result ret;
 
+	/*
+	 * RDTSC and RDTSCP should not be intercepted when Secure TSC is
+	 * enabled. Terminate the SNP guest when the interception is enabled.
+	 * This file is included from kernel/sev.c and boot/compressed/sev.c,
+	 * use sev_status here as cc_platform_has() is not available when
+	 * compiling boot/compressed/sev.c.
+	 */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		return ES_VMM_ERROR;
+
 	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
 	if (ret != ES_OK)
 		return ret;
-- 
2.34.1


