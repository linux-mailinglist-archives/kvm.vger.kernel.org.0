Return-Path: <kvm+bounces-58182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41DCAB8B06E
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:02:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68C401CC4FCA
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 19:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C4C280309;
	Fri, 19 Sep 2025 19:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="t/KLqELB"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010031.outbound.protection.outlook.com [52.101.46.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F0C21C186;
	Fri, 19 Sep 2025 19:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758308473; cv=fail; b=JeVhQf73YB+l1IM96wmFJj9TUZZXUBOj1w3AgW2CnJVF2pSNekDIpXRbw/FvPTsoDRP7zq4N5DsVwORyto2YD1m07zkUFfzc7umaO+2jZY3yEOWUL4fTl4pthnfd0v/HLiO9gE+uWRtOMpZxIw1SMgyfIJOxB972DVvSVvuVuRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758308473; c=relaxed/simple;
	bh=A1sm/rMy0J1KzlWSbIfr3asp0BJ5iudEP4TEBzdfU10=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QfopCHKXcCdvFTt0ojXjZb+LOu4eX2j6lydFzuu/a/Y1GAEGViWTb1ALEx4iYTmh7eD2zwPbHZLUm4y/Q0Eyxcz+x2bOPru2xpKX9Js0M0Zz7JxhBfZ6xL1gYjC9NripNJmiugo3kUGYeQp88ksaI9kc8itZSyCRhqtzYHHlHHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=t/KLqELB; arc=fail smtp.client-ip=52.101.46.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D2azD50jLu5dBiHBpgp5uJf3tnweUFp3m8OCgjP50ezIS/KTuEkBkFwmE2drwrBPCgTyYiv9Rc8tmVZsE80QNjGz7Rh9NMJuqn6fc/82FqMDy8QmoFM4Hqa9ZTWESyTNWX0L3R6hNaL0Qxb6kUwKBymHZYrgSVZb13xYBayCJZjcMXiPPGqfGIBEKYfQPqxTyyJzMUe7KtTB9G6dYd1RNBvQDlaydkgVSfF75fwL5Z5xe5DIB2t8cDmpqpcFi5sSjGqRWzCkYFNP/L6z+M8aYHonU9cCsbVJLelHSqX2BciK8AcMPJUVU2tIVtb/FXShxouRgaDHSIFg0HdeypLwhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6X9ul9/6b2vLx1EXY4+mKxMdH1rmYhIJ1EuOI8+3n20=;
 b=R463ayuqMoU9IQh/O4EAOK11J67sauwDcUuXxCENWD0kn5a1P0/FV5HhOdus7u0ydBecYGhW9ohhxCkB0M06Tcdm/tA2NGvZsAsgeeVjojymeJ9nZMrYu8Qc8M2tgqe14rFBh4Isbkr24pP8PWGRM308zTdBDfNREWhWf+PgC2xidgKJpAVa2xKpEoTcYTMf429auNl0Wae1xjSZTOtdpy+qOICKhmoBxdokkSNI3ggWda+u2FulCf+8YsMEgSPFy4SW8U9FRSPiSqKuJA0EE681+NvvBsRqPCukjbfJT6j0dyOR+lEJpH9MpAolNXNt1GKYrmdgPNauk87Py5rh7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6X9ul9/6b2vLx1EXY4+mKxMdH1rmYhIJ1EuOI8+3n20=;
 b=t/KLqELBuQlb7xc1rzhK8RI7H8VgL3NU/lSEWBbZATVi/QRKOd8WTQ6p+ZG0gGROoS6I1Y/hVe7gLzQavW5fcqHVNYVIZqqq21o7MgEwaw2jGikC7orkeRgmR93B8L0j4nENTaGKP7CGNsOKGVBbGlNALSVZp1vc6O1p37Q9YPs=
Received: from BY1P220CA0018.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::8)
 by BL3PR12MB9051.namprd12.prod.outlook.com (2603:10b6:208:3ba::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 19:01:06 +0000
Received: from CO1PEPF000044FD.namprd21.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::c2) by BY1P220CA0018.outlook.office365.com
 (2603:10b6:a03:5c3::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.17 via Frontend Transport; Fri,
 19 Sep 2025 19:01:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044FD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.0 via Frontend Transport; Fri, 19 Sep 2025 19:01:04 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 19 Sep
 2025 12:01:03 -0700
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [RFC PATCH v2 4/4] KVM: SEV: Add known supported SEV-SNP policy bits
Date: Fri, 19 Sep 2025 14:00:08 -0500
Message-ID: <27e833d0e988533153a5f786faa92fc6843e5c73.1758308408.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1758308408.git.thomas.lendacky@amd.com>
References: <cover.1758308408.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FD:EE_|BL3PR12MB9051:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b16d609-843a-4535-8d97-08ddf7aee265
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K0W7ywPGK2EL5GVSkeWM0JS6pTXpsxzMCujuyXmTjCWAL/McXS3I8TB1M0F6?=
 =?us-ascii?Q?6k+1NNY3CvNk1eo2T5TRxKKBi/gh7hZcwt7pt24eeErJ4CrTVOaZ9Uo3Bi+k?=
 =?us-ascii?Q?4s4J1gzrefJs2OeQRIL07dREfUW3WkST32Z6/tANKwYa/NVmosHcpQ3PKYxw?=
 =?us-ascii?Q?f40MZZ9fkMWLBcH9wyWyaoLLjRlNC5ts9wjcuY2c9qAJ/6F/kJbWxXKLgGiW?=
 =?us-ascii?Q?cdOWIxZMDrr8w5sbbB+pRZ3sqVhSa1DfH0f/GGFtphjlHISniun3d9xu8BQ0?=
 =?us-ascii?Q?7kZcC1DOFZS7exsfjkFg2byF3y4qFpfabAQDx0croqPP/whoUF6ynN8N46Fz?=
 =?us-ascii?Q?QmwZ/1fc9VMdLI5oYjeSe/llueQYtGNQFTz7yka/eYyAmxfD26EzE0GLjyT5?=
 =?us-ascii?Q?XO9Zw66+/MqNvFohUAiBadE9oE9RnvUSmjSYR3xgFyFfgTZFJ55VPoy0VNHr?=
 =?us-ascii?Q?kY5M586x6sSceVUz8DQNQck+oLu2V7/C1H9niFHs3QmEE2PTJEE4rcFoCc+e?=
 =?us-ascii?Q?G8tyxjT25km1PBdhOe5JaMt3mRFmR1a3hERkV0hhct7sK9JPuiITxJv1lQQt?=
 =?us-ascii?Q?1bBY+3xmMEavdiDFa/8bwxxlndF7Eb/DygFDH6qVdUcFzwBfwC3m9zgXUjPr?=
 =?us-ascii?Q?d3mTAn+5azp/atLZLCG6Q3lNYzX237gJznZPdeANaT6qy7ZHvd8rB+a1NEYI?=
 =?us-ascii?Q?JwT7El9yQaawP7fZ+Ywob48UUrtPpZeHsqRIb9yLZHwEBFUWlrdI4EqETerT?=
 =?us-ascii?Q?gbraGoJrQ1R0Kw6xQ25o2sNsA8/XVhAxorjDXh5PdOLsOARvGtl7zkByTzEo?=
 =?us-ascii?Q?AzvD2eROi0dTfT2OTEwWRgf//VlUXYsvu4bDUv9S5YJL5yJEogrzkq/E2XvY?=
 =?us-ascii?Q?pJVlGosnnF/oyK4PIGILdmA1XUjvnXLO+4CMlBoFXxIUlWtW2Tw+vk2jTLEx?=
 =?us-ascii?Q?iFXjTZ9DGdZOLGiwLqloLjYGGoXSE8a1ko3s++FNGDCwljP5BzPdfCtNUN6H?=
 =?us-ascii?Q?1AmGX0qPKeUSM+HAVmlJe5TqBKKbg5onmN92tBHQJxqCAAj0eK7sIV31XiQ8?=
 =?us-ascii?Q?PPe3HUBhPtO+4txeKvWh79yhqB05rQgNDd3mNCTbaZY72qTClCknL5Z3eYqu?=
 =?us-ascii?Q?nRBSbZkRuVld3rVtsPX5AJ1oTlFG3dndjDVo3rMtZHlyqoIza1jZFVkKOIs1?=
 =?us-ascii?Q?LCL6BFzPJ7bsmIRtVAKca1ey4bhZXVmN6vMmc/FcsuhAsirbHlPy/SNcgMEw?=
 =?us-ascii?Q?X1AK9WGtOFdmUVIykZlPYr6Xrkeno1v9nXwAFJm5XVTDiMLacTfOn0gkNySj?=
 =?us-ascii?Q?r+I9u1t47iT1D34EjtpshuEt9u8ixvUpcT3Q9nZEOvQOG2mLXG7Te/mVdQ9a?=
 =?us-ascii?Q?V31CXQISimsr1Lze3Oe8WI9hSqHqb1l1IoE/MsDPz7JEca/Q7GXVM6zkFFq1?=
 =?us-ascii?Q?P5joWAjgRNDaidcdCrK9Y9ikF1rLCcLGLZoJf1HNV6A96Sksfmw2ZrmZTNtB?=
 =?us-ascii?Q?fgOI3oc42tltz7cvIYBmmLTv6HYVEQ29/j2i?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 19:01:04.9811
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b16d609-843a-4535-8d97-08ddf7aee265
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB9051

Add to the known supported SEV-SNP policy bits that don't require any
implementation support from KVM in order to successfully use them.

At this time, this includes:
  - CXL_ALLOW
  - MEM_AES_256_XTS
  - RAPL_DIS
  - CIPHERTEXT_HIDING_DRAM
  - PAGE_SWAP_DISABLE

Arguably, RAPL_DIS and CIPHERTEXT_HIDING_DRAM require KVM and the CCP
driver to enable these features in order for the setting of the policy
bits to be successfully handled. But, a guest owner may not wish their
guest to run on a system that doesn't provide support for those features,
so allowing the specification of these bits accomplishes that. Whether
or not the bit is supported by SEV firmware, a system that doesn't support
these features will either fail during the KVM validation of supported
policy bits before issuing the LAUNCH_START or fail during the
LAUNCH_START.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f77da22200fb..2385c9a0befe 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -66,12 +66,22 @@ module_param_named(ciphertext_hiding_asids, nr_ciphertext_hiding_asids, uint, 04
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
 
-#define KVM_SNP_POLICY_MASK_VALID	(SNP_POLICY_MASK_API_MINOR	| \
-					 SNP_POLICY_MASK_API_MAJOR	| \
-					 SNP_POLICY_MASK_SMT		| \
-					 SNP_POLICY_MASK_RSVD_MBO	| \
-					 SNP_POLICY_MASK_DEBUG		| \
-					 SNP_POLICY_MASK_SINGLE_SOCKET)
+/*
+ * SEV-SNP policy bits that can be supported by KVM. These include policy bits
+ * that have implementation support within KVM or policy bits that do not rely
+ * on any implementation support within KVM.
+ */
+#define KVM_SNP_POLICY_MASK_VALID	(SNP_POLICY_MASK_API_MINOR		| \
+					 SNP_POLICY_MASK_API_MAJOR		| \
+					 SNP_POLICY_MASK_SMT			| \
+					 SNP_POLICY_MASK_RSVD_MBO		| \
+					 SNP_POLICY_MASK_DEBUG			| \
+					 SNP_POLICY_MASK_SINGLE_SOCKET		| \
+					 SNP_POLICY_MASK_CXL_ALLOW		| \
+					 SNP_POLICY_MASK_MEM_AES_256_XTS	| \
+					 SNP_POLICY_MASK_RAPL_DIS		| \
+					 SNP_POLICY_MASK_CIPHERTEXT_HIDING_DRAM	| \
+					 SNP_POLICY_MASK_PAGE_SWAP_DISABLE)
 
 static u64 snp_supported_policy_bits __ro_after_init;
 
-- 
2.46.2


