Return-Path: <kvm+bounces-23001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F066894562A
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 03:58:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DF931F23E25
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 01:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FFE31804F;
	Fri,  2 Aug 2024 01:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="W90/+otG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2058.outbound.protection.outlook.com [40.107.100.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC430B67E;
	Fri,  2 Aug 2024 01:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722563922; cv=fail; b=fj5w1lmdWZGkaBpsujbUL+ZjoGrc/Se47LxIGSrm3koI5LeBGjyHnUdh59GDmN77m8Grm7sUbY9ejIxgYhIOthZe13QN4frDxXU7xqZ3Gkl2cvOvepqhpGNwH60vocWQCVGkD8F7hOqcJpWiH/gVgxGZg7FlJYAcJIuhJurPK8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722563922; c=relaxed/simple;
	bh=kuZlndxf+OCN0e8phawZbetVkfHYXtUm8fJJ5Zuw+7Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bi3OW6eaMBQR+F2dW23Wt/viB1hkEK3dTILE+tSL1AtEo0FmhpjaGVhwKCxKlPvZB+jFvMhvHyZN0ZR11OyhyQVYSkV5Xb5XqR7pyuvRfeIY6WN2BgKgDmY1XabvXOJDBNKSKkdcWfoRdPr5L6KcB4pz+9KM6HI+pAd3lR58DHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=W90/+otG; arc=fail smtp.client-ip=40.107.100.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V5mzSIBFYX1KlxnBOG2O2fuMZsOfSqDqwVQaZ36rB6C1+GZjSvkfBhwY+7hhG3h29+7ElyZ/nixnoAPv5zZjNxPrG/gQ20wGDP0aY7Ahe/9LDwEUIyZXl4gS58ZhTLfbklQT8Un+5h07GJ4SHA3naHVLWbGx2zLekR4zP0e7n8SbnoTQReQ6ZEawBqbOljI9tTtcYq15TWTIsNn5kmERY+jhIlaPowX5/tqHW6qnlOTEYJPAK5rM73ICegBEQgn7WnIro79JggTC4/URfdM1zUFwRjXjbBzrqvxWTwGLPiXzz7+3PRQSUqEDcNFR2Yr51Kr80gDHw0uHwpw4kwEjQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OrbUUQ73aemR+P2QcMVJf083bVwk3ehc60t6nNZnIH4=;
 b=rMMxmMT+SglXgcYaCcdfP3LO3u95QXcWv7cs+ivnBwqGi5PeiWW/NO6DatUnjcDlFFrmcMqVCxBfc3omHso+Vcy2Xm3kkPiYxng2gLuGQ8ObNyvag/c06guSMb9USA++LbqynWbrM8OSuz4CfCQ6GaAwuOnZ8H9bg2UlI3i2CkYzb3D5RIavl0FpLOPsTSNCvL2tIx/xv/EfnqOHbsN5B+9QbhNTYFx5djMa4BumHYYJARJHD+yFwMrR9sVBJMZ6lXiOkSFp7yYgCLRchSR2IFHR0RXm4uYmoxMbyGo0rRoHEi/qw1dzt+nm95wczfo1IUxgk6CHQEjOyThKjd3j/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrbUUQ73aemR+P2QcMVJf083bVwk3ehc60t6nNZnIH4=;
 b=W90/+otGFTseBuwGYxFCscxwqMqgrBtl1n9/sxwxBmFeX2/e2G85QrjbluuuzlizGfGfOp5vlE7dnRcFNLjHBbix8d9Ab8ht4akSeOzfL7mLs1vvimvgHve9Ml88Z3x15+o0+EdjA17YO51tW8h4nbA8kw3pZSjS8FpTmcAnATg=
Received: from BN9PR03CA0044.namprd03.prod.outlook.com (2603:10b6:408:fb::19)
 by DS0PR12MB7900.namprd12.prod.outlook.com (2603:10b6:8:14e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Fri, 2 Aug
 2024 01:58:37 +0000
Received: from BN3PEPF0000B371.namprd21.prod.outlook.com
 (2603:10b6:408:fb:cafe::f8) by BN9PR03CA0044.outlook.office365.com
 (2603:10b6:408:fb::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22 via Frontend
 Transport; Fri, 2 Aug 2024 01:58:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B371.mail.protection.outlook.com (10.167.243.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.11 via Frontend Transport; Fri, 2 Aug 2024 01:58:36 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 1 Aug
 2024 20:58:35 -0500
From: Kim Phillips <kim.phillips@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
	<michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A
 Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "Kishon
 Vijay Abraham I" <kvijayab@amd.com>, Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH 1/2] x86/cpufeatures: Add "Allowed SEV Features" Feature
Date: Thu, 1 Aug 2024 20:57:31 -0500
Message-ID: <20240802015732.3192877-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240802015732.3192877-1-kim.phillips@amd.com>
References: <20240802015732.3192877-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B371:EE_|DS0PR12MB7900:EE_
X-MS-Office365-Filtering-Correlation-Id: ab30985c-0758-44e5-a52c-08dcb2969f8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mPZtESdfMfkCOqtRLAHYCWuhQ8QJmlYRmE0USEhfyg0u5albmDZqwXZ8dmzi?=
 =?us-ascii?Q?/U3rY3Ys/GB2X8bhJgjJfRXamcE62MKW3ofRekUSMefe46Fyd2pmBo78brqs?=
 =?us-ascii?Q?XxJwIABVZ7zIHg+lTq3zQSpCsm+F8c3nJtPLJ/5sinpf5Ag7BLw8H1P2US6Y?=
 =?us-ascii?Q?zNZtPY3W23SJ6xEjWaQMYyBQ6hVEGRiI59jBCGGdQmVKWm8M3ZOiqDAsEjj9?=
 =?us-ascii?Q?0e99LYYLEbdeBcG6Sk7b4WtL2nfIMbj3L37IuFcCDZXjxDbjok0FTfSGBOqZ?=
 =?us-ascii?Q?qe89T62wBk0RP1rG1yAGlb1pLTNVhlFJVVEyEwnvDmUeAtXRYdL+9oI6UEfH?=
 =?us-ascii?Q?UDRQN+9MpetnUlwrzUlrrKqU7EakTiw6CizM9z5VM/63NVyMXn2fE1/TKPha?=
 =?us-ascii?Q?m5yBp7DYWO1GbKtzfS2h1OVzSPqBAgfN11BosjcxIOW2RNmOtHDJhHkheQkZ?=
 =?us-ascii?Q?GRoGdJsmdwwQZft+6wTbYmiA6uXFTVxlJYGOX0fxtFc+meJTEgFovSgN13CJ?=
 =?us-ascii?Q?qU28W3xXizt4HNr0THuct/oLLvhu7TWm+5e6pj1u3TvATEkTvXnErcnO3Mns?=
 =?us-ascii?Q?LIkxe+fqNWOZ+amLb5zqG7YHbyUSyJxMW9WMl9HbTEokBUi8/XKH6sutnw34?=
 =?us-ascii?Q?VnLFV5dcIqAweCpe3Q1QNDTv8qOnwx2LdftUSQ8Ww2848lnxw82I3K62Ault?=
 =?us-ascii?Q?pXHyiuBPpS7zbkVaL6hMkLGFipG72+1jKWP5u3mQl8P3kDkhQUXBMQo8JHnu?=
 =?us-ascii?Q?chNNxgqjuS9XC2A2xkPMObPySPNs9U4hlc+faMZH53VwFDK2znonmfdPMrbC?=
 =?us-ascii?Q?+vs+dNDI3C4dJCmNT9jpx6TROQKuSWhsMG+H0daKJf8xl3AMsNKV7TGzJzV4?=
 =?us-ascii?Q?1iJbIWhDbPChpnMkX+MzW5uiMdF2+lDfLxvLkywsY0bwjZTxQIorZzo/ERVf?=
 =?us-ascii?Q?JblAoLK+m3ztFjoIHZG8YEl0JTfzar3BmQjicNOA7TbgkIDj2Jnx542c7s10?=
 =?us-ascii?Q?B918BMzU6Mg5zz87WKhJTWAHckZqzUWo31cvu6Hll2Ns6EHNHPr6LNh5WNWI?=
 =?us-ascii?Q?4xB25FKQRJgKk47Xl0fGYwaIrv+f02uOf9bIu3XoatnoM1vAXgeWPlS8/8W/?=
 =?us-ascii?Q?3ucPOPUEsjJauYWwo984/6nbZCStER+QgwWPXuV2kE+MJhvmj0NFHvKP13qv?=
 =?us-ascii?Q?weW9iQ82yjyQivlixqbbzmWKIhVws5Oi9JgbtoY6OcDw4PAvYF30zk8yohFC?=
 =?us-ascii?Q?L0dNNZL9AjaCdwHI0Sokdi/rSNhCywtEDN8FIZGaEEL1MezvItyI/ma5DTMb?=
 =?us-ascii?Q?NdoJkRRGqFw0tvPSdOrb1Y6vb65gIaiNKMvEErlGICD6AVz/67XGs81OrsjR?=
 =?us-ascii?Q?v0WfVR7CEmxtncNXbfhDDn6jKNRnS72s0f8U0+Pvu0ApuK/bukQHbDjCE6pm?=
 =?us-ascii?Q?Ty/dV/iMvzlSbyEt3vZC3nsMzUCfMRE4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2024 01:58:36.9904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab30985c-0758-44e5-a52c-08dcb2969f8d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B371.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7900

From: Kishon Vijay Abraham I <kvijayab@amd.com>

Add CPU feature detection for "Allowed SEV Features" to allow the
Hypervisor to enforce that SEV-ES and SEV-SNP guest VMs cannot
enable features (via SEV_FEATURES) that the Hypervisor does not
support or wish to be enabled.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dd4682857c12..0c73da91a041 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -447,6 +447,7 @@
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* AMD hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" AMD SEV-ES full debug state swap support */
+#define X86_FEATURE_ALLOWED_SEV_FEATURES (19*32+27) /* AMD Allowed SEV Features */
 #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
 
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
-- 
2.34.1


