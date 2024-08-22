Return-Path: <kvm+bounces-24856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E95795C0C9
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 00:21:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 621D41C22157
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 22:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C1D01D1F74;
	Thu, 22 Aug 2024 22:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="D3BEoJnz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5E31684AE;
	Thu, 22 Aug 2024 22:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724365208; cv=fail; b=CcrES58DvbTM2KjB7v8MhGu80I5pwI1AD3sn9lGeZMgH/7tkKFCqSwotCVorDxh1zHhxUEoeS8EUsPd/sRJ2sx//zYnbZ5BYlkmm492vWTqHE5kqRR/TBkqAQ0+Gmv1/gFqJpH0/idyNvCBhsFil+6jNcPHtiF/1rY0YDTOqWws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724365208; c=relaxed/simple;
	bh=BWBXnUFN6MC8SPonOoj3CduVFQQVU80i+FDCr6oTVMU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BeXYd0yDk3yZ8UkU8vdWUCVH5dIdcbqCpZYLMeCsxogOpcOSK5tjzKebuuHMIU0psarrWXNYHRgXrUCiYWmaWhKRuDAIPD/1MeEDW0ajeCglD/i234pEhZWvhpNh9B3H0ZOlbmEdtJrS+OnddetTMduls6+QpIrpNAln5tVAwTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=D3BEoJnz; arc=fail smtp.client-ip=40.107.223.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EsKOAdaNgcvHMSuXe8WqiC188q+Bvh69Kk2gm+Qm4scd8lR5R/YVu1qvh/f7C+iLLx6m+mCNdRGjxVu8MTZ71zr/0SYcNi/oHlcHzcTTawGXbwNp+Dbg8umKFc8BZUtpJhgYWjC/R8R0MiR0wWuc4WTZua0pbVnx6NKGDsIwHbI2f3KcqSKiU1+c9V17lt+h7FECT4KfXCnIMC2AyQQbqSSvdmkICQGOz6Wk5hSD3QU9aRfcKwThdTnHAfqk3Bj2eeieLEOI5Gg2pGS6FzA/YfJEwLbcna1RLm4VwNHrJO5/O4RdAofwy93UyMK3J2zewTqSbiwJDrkE9CKMEjFeAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+xX8RWyiC919O077M+oZ1zXnt5fQ2YXgM0r5aiAtbI=;
 b=y02F4IXrvxa9ZnBcblfdkmbQekePXhDPK4gHXyiwPACmar4RbHepFdyNl3/xvRQb5z7QmvlcGlV3bY5w4/c7eqv0PYeZc2Eyshyhq1Qk+f8GeKuGpoVsL/ceVHnJnNgS2MY2VGpgCMibr63sy4c0czSP6V1jkZ+gOvqZ+1CAFDK51GdkIBvhyprbfbsXQjp7tGdlD1Uzy0X+MUj57NRJLKhpR0Oi8j0iJuM2AXjPSAOBQy8ZCld/l/oWqOuebyjtPOlDkGdoO606/Ll4yTC+P05nvPQ+/JFkWD21oRu0WDri4cYQ21gWI3iXwp0CHwT5MGjvbKD+gNwHztfg1vp0pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+xX8RWyiC919O077M+oZ1zXnt5fQ2YXgM0r5aiAtbI=;
 b=D3BEoJnzkg5giYszdosxLzybXEiErmY0MhhKc1N+kQOvqJ2KXjln5DDWUTyZOeb7CxtLX97nqD8Hy6uK/xJsbvDv6KqFPxYEE13ZKNnoPbJHnBNiSuV/K+djuOqYjITBos5YrEmLU9EUU6gRKEuUH5mDtjy/hpwsRrvxNPNRDNE=
Received: from SJ0PR05CA0107.namprd05.prod.outlook.com (2603:10b6:a03:334::22)
 by IA1PR12MB8496.namprd12.prod.outlook.com (2603:10b6:208:446::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Thu, 22 Aug
 2024 22:20:03 +0000
Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
 (2603:10b6:a03:334:cafe::2) by SJ0PR05CA0107.outlook.office365.com
 (2603:10b6:a03:334::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19 via Frontend
 Transport; Thu, 22 Aug 2024 22:20:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7897.11 via Frontend Transport; Thu, 22 Aug 2024 22:20:02 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 22 Aug
 2024 17:20:00 -0500
From: Kim Phillips <kim.phillips@amd.com>
To: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
	<michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Nikunj A .
 Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Kim
 Phillips <kim.phillips@amd.com>
Subject: [PATCH v2 1/2] x86/cpufeatures: Add "Allowed SEV Features" Feature
Date: Thu, 22 Aug 2024 17:19:37 -0500
Message-ID: <20240822221938.2192109-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240822221938.2192109-1-kim.phillips@amd.com>
References: <20240822221938.2192109-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|IA1PR12MB8496:EE_
X-MS-Office365-Filtering-Correlation-Id: c3742c60-02c5-4154-77a8-08dcc2f89193
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Lv2JbVuH/Nw5bSEi32+STPGwSWvyH6tmiVgoNddGWra3lvbn3HinfxoV1nQs?=
 =?us-ascii?Q?U4qllRKa8XXxsZLjBtjsfRHbPJ4Z7NdJXNNZcMeE54/0mIVP++aaeOKPsDRM?=
 =?us-ascii?Q?ta3IsP7hSSOuRshLtpKs+NxrEu53oSJnEiYKa4nm9diUKe2B0mdadYU+58tR?=
 =?us-ascii?Q?clnM1Q4T65DRlmZ3RxjJmAJLEjX6CMK4keZsIA6komrwL9Rw6N9oWmp1poVx?=
 =?us-ascii?Q?F/kKok0fgZR2V/rwxJmrjYjbS92Fqo7NjL/mDv4neFKhC48Y737KO3um8Gz7?=
 =?us-ascii?Q?qHT18cX6DyrETBGlLiqbzORBsny4PRiXsd+KQrzgxZyuiFOyT/NnieEw7drm?=
 =?us-ascii?Q?wMLYa50ZpWPG/9KMg11LEUocm6TVid4B5NYdZfGj/HsrOuA36MBL6PGzH68G?=
 =?us-ascii?Q?5WXwb+4jOrEZcU4t6zXi0VcCmuTUInxwQjs5e6l4HoUS+wuFcQBhmfKfGpqM?=
 =?us-ascii?Q?sWnQt56yxYex3vEUv/MLWBjc01Ipcm/0F4uIDcH79xNSjNFlIBTvF8F+b9q0?=
 =?us-ascii?Q?E1oLZgZK4ScdePjSDj1Bn4Y79aUBeAOU4P+HO2/ra9uQapQ3Ab/PWj3mG4RC?=
 =?us-ascii?Q?AzfEoXDm5QMIRjDnECtRqy+h6U6Sq73+g6FCadRICH+bfRSli69Z30TLgVZL?=
 =?us-ascii?Q?wL61I+a0U5LICFcs1ekUHEmSpiyrUkFOdzQXe44AgV8rdnCNKvSbxR6ZbXsz?=
 =?us-ascii?Q?XpPoM3RKUL+kbEa5hF/8nLZN9/GVEUftPTGwUql6b6NgO1frf6jMH4lscOAS?=
 =?us-ascii?Q?e+YcEwKW47uCq5M/tz4988Jza+wvD1N/s1pAUO1bwCnS5rNDCti/x2uYyRP3?=
 =?us-ascii?Q?A4kG5CQ/ClSPZozP5k1R2bFGoHSGNQTiOgu55DVrDcSCyzVwMck5p7/nSNZ8?=
 =?us-ascii?Q?R7BY8Xy7bNTm8YkFkIAKhyiaNjMUfZqp+k00fxIfZnD69nTPe3EzhIaCyCuz?=
 =?us-ascii?Q?a4FjXroH1KLpzpHNgd1pp2MQixAOcbxIzOUt6TzNwMMKsyE3RZgzuzMe5dCG?=
 =?us-ascii?Q?nqgs1jZ4tsXSJJNrLaw1UMIlSvhzH2nqUIgDYOM9HKKgxejVLH04fr3Desvm?=
 =?us-ascii?Q?/ItgtQSKjz6UPo/m5c2D8/e2DPonfRya6l5zQMRsFdvHGtu+6lVlxYKsJSJC?=
 =?us-ascii?Q?eyulRoCT4zrawYZql2+/IfU9akwIeTo0sHqiuRpUUyCLC+TW+ruaSMuJPfff?=
 =?us-ascii?Q?O5HpVgDDAL1Bz5ZPfX1Y6oBVtziBKWd3I75EGU+HftL5+jswQ4B2fZ4iC7ax?=
 =?us-ascii?Q?L0rbCvuhgKEuBJXl6H0hKod6zKLivSqpNHOk5byqy8XDMvuiCygaWEZaBJJ6?=
 =?us-ascii?Q?BKdFfRcpcfx1fmFsbWC6Zo9qMOudHwW9NzPY1bldO5X7hfJu8mhzWrHHFbAW?=
 =?us-ascii?Q?WUccYdTWaxgaWEeSVxaMPzImBwncpBK9jx0vSLwL6NDK3ZSi9MKvkBtKAHMu?=
 =?us-ascii?Q?BZfrh4KYAXm60PE8Px4U7XRxKRfiOlQ/?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 22:20:02.7306
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3742c60-02c5-4154-77a8-08dcc2f89193
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8496

Add CPU feature detection for "Allowed SEV Features" to allow the
Hypervisor to enforce that SEV-ES and SEV-SNP guest VMs cannot
enable features (via SEV_FEATURES) that the Hypervisor does not
support or wish to be enabled.

Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
v2: no changes

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


