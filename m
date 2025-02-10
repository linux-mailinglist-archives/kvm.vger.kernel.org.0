Return-Path: <kvm+bounces-37683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AB57A2E78B
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 10:23:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64DC8164994
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 09:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4695E1C3F04;
	Mon, 10 Feb 2025 09:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JIxwRLkp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D866C1AA1C0
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 09:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739179375; cv=fail; b=bbEAz84bGzsmO1CaYPBhaoaNxtXnv4U0bN9b1TrcjC5sPeVSEmrjGycyuKNv/7297EuF9GtQlcTE/ojC/DaBfHntatQ/izW3QubAe6yunxopTbpnyYSuqq7tp6VkcMs4SJ9xQlPCxOhkEyGl5WqVvCRHa9KqOJGpoW/apRMz4as=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739179375; c=relaxed/simple;
	bh=7MXPim+Xj1N/aZ5OjrsFh7FEBzxSlmr6Ys8JuCXuv/Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EBLoLLJY8HyQY40R6K5gkdWqE13MOV9PeZozIjkIZyXevCCrWzgWFb6fgZ+KqnlXKa6x9CvTrPDlDshp6NFJjhDZpGpro5TyErTD8GWHyGZF6HqM3BeqAPzQOwyj4qvkmxPEMr/BkcZgnQTxNIHrMr9WRITucO59t+QVPpCf4Ww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JIxwRLkp; arc=fail smtp.client-ip=40.107.94.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B/LjZdYRw9lSpJpUI5Z5q2WYPCgJPXC8S5GV+QqQwWlGBG3rZ6BlkliJUcZbn+o2wZFkqm9IPQLLT0cr+bgSFNldhAYPPJUdypcLi71Vcv/ZI64k2QsSPLjBX8IEpsPdWvSVY5WQ4iS7HpJEFNO9WQTdvVlbFzXzTgfMfgDFkvSLcBpg+tvPTPEqpcajx8UahXeBJYU4ZMfiSKHiXa4csNZ9jf94GfCEJumGBDOCoL2vUzEeUOpPfONNzjmfncQNQacEgO4ilgJwCrbnbwZalJ2DdsLhBzhLLZdraPidxfNCN/ShYqgquhH3UZBP/6Sp0xm2VHEthZiofChj/n6DuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+Nw6ukOq9Q5tyzYndx+P9odRvRbGTULF1K+hScO+0g=;
 b=MaQVJBDocNcYxsWCOnoZBxW+atZUnGG2TurV04VYgXwIxHRHc+xluqNSw8DDSZlylNP3f8JwBbkG7GUMAzouZH1EIJz+3N2xf4/u26N1uef+9bLBX9x8S7iA1aQlPiuv8liR8olQHjbfUHImaobvYoR6DpGVUFYJ1XNEaujcErgAFC13TONYqhoJfcsa4zna2C3EcDTc+Y/HmmeRqQR2Y7Eqdvbf0eNTcR23Nq4IG7Kan5MkAuWgTZ1SjkA3EF4vyUJ46kN0IbGudJzAp2xQiKn/1WOEDWBg/sX2oe8IBcRLlJRoVAy0DxQLHbn0NBW0rmSLQgm7TFQatWAua77oQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+Nw6ukOq9Q5tyzYndx+P9odRvRbGTULF1K+hScO+0g=;
 b=JIxwRLkp9gpt6ntKMf2NeJVCe/QvZ0oUvG6eGSkm7+jCGsqOdj9jYkh/AyePH+s3x7/UTBxr1CsCmFmAwrT/m0vPOfqc0+Vvgb7S5a0PIu40tUHwGY1a/g7p1nKg9ZII3qStg8APSzgur53qPDR+kT67sNmlBP8qKvvbsuP04GM=
Received: from MW4PR04CA0304.namprd04.prod.outlook.com (2603:10b6:303:82::9)
 by CY8PR12MB7123.namprd12.prod.outlook.com (2603:10b6:930:60::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Mon, 10 Feb
 2025 09:22:50 +0000
Received: from MWH0EPF000A672E.namprd04.prod.outlook.com
 (2603:10b6:303:82:cafe::29) by MW4PR04CA0304.outlook.office365.com
 (2603:10b6:303:82::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.31 via Frontend Transport; Mon,
 10 Feb 2025 09:22:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A672E.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8445.10 via Frontend Transport; Mon, 10 Feb 2025 09:22:49 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Feb
 2025 03:22:46 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<ketanch@iitk.ac.in>, <nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v2 1/4] x86/cpufeatures: Add SNP Secure TSC
Date: Mon, 10 Feb 2025 14:52:27 +0530
Message-ID: <20250210092230.151034-2-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250210092230.151034-1-nikunj@amd.com>
References: <20250210092230.151034-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672E:EE_|CY8PR12MB7123:EE_
X-MS-Office365-Filtering-Correlation-Id: 879fc50b-2cb4-4bd1-f0d6-08dd49b47d2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QFz8vI33fMKVR7va7K+0wcpuTX7P6u4mIuT3j6qaShqeiSejVdWgi4Tpkrzn?=
 =?us-ascii?Q?4AZrF5pFRvOjA9rLJWY4mqULITG2oqcTAcoYr3EMeQ943evQzMJD3XLIPWxD?=
 =?us-ascii?Q?1lfVjLbCV4r9fArxZ3FfB9iWhMYuO++1I0t0MukY3SjYcxsuLJ81JFaG7qUo?=
 =?us-ascii?Q?UJ5af0EXlz3QAqyUq10vIx2POZh09BFM3wVn6ZZufDvpmiks5gZ14kJvTjOt?=
 =?us-ascii?Q?/IiTcNayiHMW0BqGGKcnJTyCXeJ+euriAYWJA+fscGiaYczfoCxKkVrY3675?=
 =?us-ascii?Q?YSFWPseWQrKdLZpC/f39bfVW7y4crweocO6SWukbiTLHZR4KvzHYeta+DMWK?=
 =?us-ascii?Q?YtheXg+OPNq5CjDSxnqpg3ldCU9vmU+wTnHOacgGvNA3DL5uG2LMhQ53JsNv?=
 =?us-ascii?Q?McOhAd1avpBzzGYwtGQCtU8W6M8MGjBd5SwCQB29pGXlwGLCV8d23MJrFIPs?=
 =?us-ascii?Q?BRh/JFftLwS06IP4IEEfNrKwpcz3KAmgAhvvVgrooWdZfG7dUyUY/GSo7i3q?=
 =?us-ascii?Q?lC5uqui/qyMlpRg5vfNFBOPawj2KfcAurHM/3EI73ZFO2B1ciphG2XlmkkaB?=
 =?us-ascii?Q?H+dS1nmVgc0gbFR0FbVCiGBFt/EaEHSY/61iECdaLkH7gqElgV3mITNTdysu?=
 =?us-ascii?Q?J1N43JhaFgfuKLG07E7jGRyD07rSzvTGEENzLADss9rec6ELVw0ghF1m0Vzd?=
 =?us-ascii?Q?nTBxR3fNMIAmM1Jnv7FhWl3LPrelzEdIco91Y8xfy+vWw9hC5wyKaTK2mQHD?=
 =?us-ascii?Q?JhnVZ4RywUky1Z3PGlBKjoPXfWTUaGTTEzT36E+tWv5CtcedkhBVHdE9Jf63?=
 =?us-ascii?Q?WBXjv5QUi+YrsYaqUObGAfEsHX/fu/dSLXZphIpEkhM01Z7ckdctNJ6oTQDX?=
 =?us-ascii?Q?CQLtAb/Ex4dBfpUjEXYX2A6nJcanTyHdJncbS/sd9to8zxh2ivblob5YpQ4I?=
 =?us-ascii?Q?PJsPlFYIVW47PKfXVsumRy/7H3b4AQDPJpNdRtIy1QD6OeolsRTwl+7vy8Zj?=
 =?us-ascii?Q?zMJ6vVlHuvzmAiyqnqIX3SpGzGgpstgCOa9tGhKYujuQbrf9A3Zdrm8e9gqG?=
 =?us-ascii?Q?6XnEaa7mjuIQZ/jl7jDjDk8wcqLYbdOyISJJMWGgi0+3+DlUdW0l0IKfZKwG?=
 =?us-ascii?Q?B+UwJsGyxy5EF55fnYJfk/pcM88q6V054bhkmq2J/tasrirdVqpWSQvgFfTU?=
 =?us-ascii?Q?col9uhqwzqHz0IO6cMEjBM6mzpOT1lhqix/lecsMHEYKJKsimYNEWoNh96pk?=
 =?us-ascii?Q?a9B6ERANUePaIwIsCmC6A7ncOSwTxe3RZC5y/uNAr/xkhFBCJC+kslTauEFr?=
 =?us-ascii?Q?MlFdsJG2l8JgnoE/nMYTX6WZdVYFe+8PVdaQrbpcoC7Xq9IhfzvG44iRsmP0?=
 =?us-ascii?Q?c4J4wz4NqbHupiZP8UE/lq4EQEO3QYF9K+d3OQybj/Eq1cuFxQWpu/9bzblX?=
 =?us-ascii?Q?+Ohf7ygptH2a9wg5hAR9KlqIapZWhUA3rcknvU3GhfhVYIJZ0tJwzQvGNRRE?=
 =?us-ascii?Q?AevobwuiDqdO3Ic=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 09:22:49.7732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 879fc50b-2cb4-4bd1-f0d6-08dd49b47d2b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7123

The Secure TSC feature for SEV-SNP allows guests to securely use the RDTSC
and RDTSCP instructions, ensuring that the parameters used cannot be
altered by the hypervisor once the guest is launched. For more details,
refer to the AMD64 APM Vol 2, Section "Secure TSC".

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 508c0dad116b..921ed26b0be7 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -448,6 +448,7 @@
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* "sev_es" Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" Secure Encrypted Virtualization - Secure Nested Paging */
+#define X86_FEATURE_SNP_SECURE_TSC	(19*32+ 8) /* SEV-SNP Secure TSC */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
-- 
2.43.0


