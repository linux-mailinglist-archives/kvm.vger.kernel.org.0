Return-Path: <kvm+bounces-29807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4E019B246C
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:39:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F63FB21E92
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 05:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F418318E354;
	Mon, 28 Oct 2024 05:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gTEBbA4Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F51C192B6F;
	Mon, 28 Oct 2024 05:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093737; cv=fail; b=tw2lWnJ0g/wz+O9CE+UyR6/HhfbPRmpEnfTaI4Iop2PaQQ8rITyg9C85Y40ldyKbgV971Htfx+lXbAM/byzo4QxGpUcLKsqLcHsbKEcRMVeHB9y0+3IeDnIW9vdQCcaeJ2oHN7VHVm9Prm55P5izSY3R9wSv+DMMdrZxp8C6evk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093737; c=relaxed/simple;
	bh=84IW3SMR2DWYi6Rj4+JDj9lTgR8VK13nCyA49M/wkUU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mkd7cljP8HJ+mJ0G0YSMChStPwnFsxYrbYY4GaTh7A1FDwsSrZtfHIOGIaPhBUnLvf+vdn1FPW7BnUPkNZrdfplYlTu88ZYAEjjrsred8n3RSRusIcXoz75RNKfFMjcVm7Rlnd8OcXAvld28YMEYhiWcz1pEf4bxJVlHs58kK0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gTEBbA4Z; arc=fail smtp.client-ip=40.107.92.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KNy3uMMxEZunZBdGXrikDeJFWpBvthz+sc9oCfiqk0++vRpUInRMMn74pIe9DxcfMtNIrBO0CaAYwXu4d6YHT4DcksAHtGOebgJzXTulW8JR575BV8pQ8Aw7x12+qElOFZ6JNUaZDlpXlDUz8DIYjTJttneHZrm+5bBMwKk7LHXBRG+DhhCFPr1dUII6ZoE6vCRWQFt6H85qpX+FC9rkvu91yY9KIAdK5k6pOrmK9cJ45I8x3RAEYNnmb+vzNe3hVCtbmHese8RiQ9YJPeqUtJ66xjFyZ0GvBHyOOVoRFkXFlQmXp18LPTqVG8uGJbUYJOmAiv4QaDm4Nez2y+/UPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bY1L50c0WxQg8MOFHr+tzQWs7PqGLtUwBGPdUbzW1vU=;
 b=KhHOIvFdCw7Q+yrIEFU2HtuKywjjWoX9bZ011ykk6tu+Az+l7m/KCr+nwP73nFGxdIQTRuW9DmPbQXwKEKtkxrPFZppwtolUFTXo40Lo10M/1k50u5HAgi0bWIcILVDyE1pr6UNwK9oP4QbaA6Uw6oG6UlJjLifzpWkDZwBAzV5bztq+viOinSEOXymqYnrIARe2S5RSRkyIbzHuCiHtxm8cH/odQ5TxdgVC917kK0uM5ZEvTHFioFflIpca710grdB3zQVqzQVZn5NjeZi7wnZXR4Bqc2szPXFJlqTANo2/BTVA1STKsV40Qq4/xfUfpaPBgB4U9FTV+ynWx0t2pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bY1L50c0WxQg8MOFHr+tzQWs7PqGLtUwBGPdUbzW1vU=;
 b=gTEBbA4ZVr8s9DUJD0+fYE71Z/fFcV/OhuxF3Lu0WaGFv+hq+seJ+OH76qdEGTJ8hd81d1ZChtuwEFBP7sUYNErzIktRm0ACiYKOxqydPgO17DLOIckmYdk5fj9dolSYqwMDgfOgXMlSazYS8JO245TtgQc8NGx8zlVGhbtuhv8=
Received: from BN9PR03CA0532.namprd03.prod.outlook.com (2603:10b6:408:131::27)
 by PH7PR12MB7966.namprd12.prod.outlook.com (2603:10b6:510:274::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23; Mon, 28 Oct
 2024 05:35:31 +0000
Received: from BL6PEPF0001AB54.namprd02.prod.outlook.com
 (2603:10b6:408:131:cafe::ae) by BN9PR03CA0532.outlook.office365.com
 (2603:10b6:408:131::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.23 via Frontend
 Transport; Mon, 28 Oct 2024 05:35:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB54.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.16 via Frontend Transport; Mon, 28 Oct 2024 05:35:30 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Oct
 2024 00:35:27 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v14 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR interception for Secure TSC enabled guests
Date: Mon, 28 Oct 2024 11:04:24 +0530
Message-ID: <20241028053431.3439593-7-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241028053431.3439593-1-nikunj@amd.com>
References: <20241028053431.3439593-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB54:EE_|PH7PR12MB7966:EE_
X-MS-Office365-Filtering-Correlation-Id: a34b1305-ead8-4d9e-93d8-08dcf7125657
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZvmNsKHPPLu2MACdiePzbolYV10K+JdjUK9SY1J7Ih/4P5UoBxhEAPwTIba5?=
 =?us-ascii?Q?jQbRPlrNLAHGVfLEjItqaCjo1U/IABb1k8L1m8WvjLdwQOjMx/WN6bH+2LxL?=
 =?us-ascii?Q?dTueY3epQkzktmeRS4iyONO4CRPWDeYeCXB3MMSGeeucokhcyKjzckLKa1vI?=
 =?us-ascii?Q?SYVVA5Crf/r4P/BpKjyZTj4j1IEk/yw2KD70c5GZeG9BWUZtRFqpqt4n2s1g?=
 =?us-ascii?Q?+toRONcEGCG5N6n5x8UwJHet2bgGFAb5/p18eCylLphAhLd7KNujqaUEyV5e?=
 =?us-ascii?Q?7oqbnmAI13h2YOw8uf++s7NFgKJwOYFUPVVQ4NmHGFeojSlWXglxgAOE0+iT?=
 =?us-ascii?Q?VVe4RVWSn76NNCVcClzyUPhKTK850ROwZvyWA5OSfa2yuVEAU5/OVCtEtkX2?=
 =?us-ascii?Q?Ax7ZQORCRTrDOYMqSAatdnNO/b53L01BI4ybKMG8BrOHl1V5ffdBR7jKGFNp?=
 =?us-ascii?Q?6uJ5xWESAzBmnFfPBkjJdxW/7fjh3VFPlst1kjD7NWdN3walEF8Z1I1AsKfv?=
 =?us-ascii?Q?sjJ4EBvS+6JXfNuY+Hh/XvZo7DkPzrf3rnx/flpHE3XMMmeNffFSY0+uRSO8?=
 =?us-ascii?Q?o2Gak807aFPq+BtGvS/zjQiFoXCZD/SQh5MQQ7ew/7PECTmKFiDHIZtfBdQ/?=
 =?us-ascii?Q?KOVoq5cMlanxxNvl7rbwSD4SKoYTSXawXlJlgp6raUOefE24Y9MwnkfhxZbG?=
 =?us-ascii?Q?Ks2XnxlHMuZspJ+S16OGwXZSAcGPVR452EzL7JS9GW+V/YqSV+Ws8w6WOUGz?=
 =?us-ascii?Q?TRXkRJg5RqRPyz+OSK3P7aEz+7Q63Np/KPZJKTtiQic5Hli9W2H4XYrcE4jO?=
 =?us-ascii?Q?aVAwD6fqPe2ZQQJkTbGe7qyoCOcmmBVXFE7KLSSEz2RZ32JTCH5OJDe7N2Ub?=
 =?us-ascii?Q?3j6yME4ZszDZXBzbRFR+dmctwY9QZh6FSRB5Kucz6dz+dVmH6p9u6z4uEF1g?=
 =?us-ascii?Q?zQ3IP9GFxCRebmChSdqCA3sCPjWTgIPI6KXEHybk+rNd3/OYV1Fl3b7ld8r2?=
 =?us-ascii?Q?4J1wzdgQv7ulqdjWk3dMdIRnexxcBX0HxAl0rXCRIBCFvX8Snp5cSYRK6oHY?=
 =?us-ascii?Q?u3DhJJmsv7ipVRiAimYrg0chAmfg6IKgGsFhRQts0Xneg+nZ3uZVlNro+Etj?=
 =?us-ascii?Q?Q5bzUP4EdaT6hNO/YCPNtfQdQ9Z9J8DSExtilJuW+x0GgH8dGKVkUJ2mrobK?=
 =?us-ascii?Q?lUfo0nAw7IvFnmMiMTJMV0d/YbFqlnEVwE9qEbPjNrBrbdYozfI+65JQGTLs?=
 =?us-ascii?Q?Kibzs74jknlEXHwadzJN4qFlf4KaNyidMaLnuCr6SUUhELBeZKpJZW4poGQ5?=
 =?us-ascii?Q?P9c86YVjhpDkxyMQMFjpxmFEkFcXIIGr7jDxi1pn4Y7toQUp+4SGeMYsm9eH?=
 =?us-ascii?Q?8xN/JAT5PiSKQaiPDGt0LJbZSJQtTUUP12I0Mn/5Go2mtfYTqw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 05:35:30.9038
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a34b1305-ead8-4d9e-93d8-08dcf7125657
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB54.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7966

The hypervisor should not be intercepting GUEST_TSC_FREQ MSR(0xcOO10134)
when Secure TSC is enabled. A #VC exception will be generated if the
GUEST_TSC_FREQ MSR is being intercepted. If this should occur and SecureTSC
is enabled, terminate guest execution.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/msr-index.h | 1 +
 arch/x86/coco/sev/core.c         | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3ae84c3b8e6d..233be13cc21f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -608,6 +608,7 @@
 #define MSR_AMD_PERF_CTL		0xc0010062
 #define MSR_AMD_PERF_STATUS		0xc0010063
 #define MSR_AMD_PSTATE_DEF_BASE		0xc0010064
+#define MSR_AMD64_GUEST_TSC_FREQ	0xc0010134
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
 #define MSR_AMD_PPIN_CTL		0xc00102f0
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 585022b26028..140759fafe0c 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1332,6 +1332,14 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 		return ES_OK;
 	}
 
+	/*
+	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is
+	 * enabled. Terminate the SNP guest when the interception is enabled.
+	 */
+	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
+		return ES_VMM_ERROR;
+
+
 	ghcb_set_rcx(ghcb, regs->cx);
 	if (exit_info_1) {
 		ghcb_set_rax(ghcb, regs->ax);
-- 
2.34.1


