Return-Path: <kvm+bounces-52573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EE95B06DA9
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 08:09:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC81C7A64B6
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 06:08:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE102E92B2;
	Wed, 16 Jul 2025 06:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YMhgnwjp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2057.outbound.protection.outlook.com [40.107.100.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395DE2E8DF6
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 06:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752646149; cv=fail; b=BcWPn8xs1Haguzqt4ODWrRx1v146E3ObycomB8qtvj8jps4BTQmyJJzuPLbG8S72UYf68qOB7X5KpJX7VJsJYBRz1LcQ0c6m2iajRnErCPEz8FdKMWoelfdvBTUgoBuSxNnrRDWhJ9SnL2cOxrk3xjatl0sZA1dxvKr0dR8m6Ew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752646149; c=relaxed/simple;
	bh=Q9FitB5hKRU1LBUj0K5sjZ1rNzfXLZPKMRWOeNue+gU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E7MKkEZqk/TkowzZ1JHpoIbm0GLWMVbE//IgcKz/Pa8NI+VZNoPU+HClLdf4tP/2oXqdgKpN4ebd6Mk8eFLTg9hh9Fk2uOqH9mE1EtMuMvNwbw1CmSQrdr36K0w3vzCa1FWi3WrPGrhbSZAbWwLczNhbGaoiB1FrceAnwcdjgCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YMhgnwjp; arc=fail smtp.client-ip=40.107.100.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b5URm70mLs87G9PuNRnLccDfdopFri5GhpfOQA6zy7kIsJmoL+Ba1LclO3Oi+PZd0rdTEXon2hGR00NdDul9Uy2cAp/6nAa7s8AwMjfDOaSF3PCtaE6HltNf53gHdIKxAfWuWMcrpE1aeubNnZmzvNuTjmWOmxbWMc0gB/mWVuUper0+3ASnZcKw74MLp4tE8xFQN+hb+ELFWy3/rZzdn3+/3w5qfVaBBRovY+p73OWAv3mSWS5qJOj82zjNL3xzl8/9BEeBTht5PLaV5uLanVDn64I5+9nRmfTxmTDAbLtnzCxybJ1b4vqaxnQc/xbMwpdgNpHlQMakn/iP/+AQ/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4TxkNEoxjg2svLmgx0ffRDRB7iyYRjCjNyYk+5zSH6U=;
 b=cOIXRnyLMpgH5GSYZahO3VzRr1soQ25tEF2x0w/5zhqt+XfEo570CDZlqrEpHngZyj3gz50sUSLXoMQpFResIeWeM3agey4v/BfSHwhgA7E9+glD3JFk6PI44+zxvIWuSVfOiMjH5Zy3ok8Hb8gu0GQhnOuUDgrUHeuM80X6Ma8gMXk2fQufmp8gKkn24ygmWfHPDNNnY6n1ol+ekUkC4y3SmFQugq8YnKwYB6kmRks6j2OJ+gq1ON3wtumpMVIyu5hSEj0UHWxpnQXkIdVAVaiHe7KQAolMS8kxLubJxzAJphzS4DY0YJ6DIGNlIdPXTpZgWtbxZ1e3RKsrYLss3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TxkNEoxjg2svLmgx0ffRDRB7iyYRjCjNyYk+5zSH6U=;
 b=YMhgnwjpz5p4s+Md+9C6J608Wk/gM+nKGJKt4NuO/+Vbb7+XhIZuLOQaqQXQRlOFWCPFXgWhyNHGBYqjIooa/cR0CufxijUUuKz63hrSSVVqOU1nyMt36GafiuS9hdxBko153QZxVtNqv1o0opigJ1oJkXShm94XYdCvdvMFoJU=
Received: from SJ0PR05CA0178.namprd05.prod.outlook.com (2603:10b6:a03:339::33)
 by SA1PR12MB6750.namprd12.prod.outlook.com (2603:10b6:806:257::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.28; Wed, 16 Jul
 2025 06:09:04 +0000
Received: from SJ1PEPF000026C3.namprd04.prod.outlook.com
 (2603:10b6:a03:339:cafe::96) by SJ0PR05CA0178.outlook.office365.com
 (2603:10b6:a03:339::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.17 via Frontend Transport; Wed,
 16 Jul 2025 06:09:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000026C3.mail.protection.outlook.com (10.167.244.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 16 Jul 2025 06:09:04 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 16 Jul
 2025 01:08:58 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>,
	<kai.huang@intel.com>
Subject: [PATCH v9 1/2] x86/cpufeatures: Add SNP Secure TSC
Date: Wed, 16 Jul 2025 11:38:35 +0530
Message-ID: <20250716060836.2231613-2-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250716060836.2231613-1-nikunj@amd.com>
References: <20250716060836.2231613-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C3:EE_|SA1PR12MB6750:EE_
X-MS-Office365-Filtering-Correlation-Id: 13450dc0-f95b-4391-1546-08ddc42f4437
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9aHNLtaUJEzv9AZ3bPDnmmTwS2bhNDb7Wgjo397LlCQVFhmf6iAtKm37RoQa?=
 =?us-ascii?Q?jqNca0K96Q5skGRpVjCB6/aUwAFe5KSIXLUEnffDOspFPsF2vI9fO/h/tvQr?=
 =?us-ascii?Q?KTh+IKmottr89aejYE4fsoVLthD0QBpdxB2ZukAkx3vyiG8FSelAJQn9o6wk?=
 =?us-ascii?Q?5htAdVQ768AMqhLJWaaRos+NLLbJDmFzzGylAned13sN3rLBQI11JUY+J3sv?=
 =?us-ascii?Q?DKvpNH4gJIJpSqNL7pEl3PdvCLGndGU1VMJmdGKZBcVzPTdbc9k2tbPZ+Uwl?=
 =?us-ascii?Q?D5EPj8Ra3b9jt7VBFgL2yCFP375at9uQJ37QjZOiZBSfgcgQD19YRusIcVUm?=
 =?us-ascii?Q?WpYfnTiYqaH0RCDWUB4XasrDMOLMupizistWKm98MK4qwYtXINml7OfO27R/?=
 =?us-ascii?Q?Zqc4e9gK/T2J2GmTF8kCRMUXJzTg7rZChUV/Fx7xjMtUsd9zEf9l6OUXXMVR?=
 =?us-ascii?Q?xnM2G55pAyvP3gXr03yHwcyg2gpHyh9d+I3yS3JLYTxz+FAqxsBy5SjXb2kp?=
 =?us-ascii?Q?KnDQMzFgEc+A3YrSQ/vqW+gMEhZB+biqQGj/P70Tdbf1PNvSdxHhFYm9RtPv?=
 =?us-ascii?Q?srqhslSWVTURF5CLQ7Xsc4kiWF0Mvy7BQHamYy9R7SiZAdNwIn7maQQKV6mo?=
 =?us-ascii?Q?FXd3ByAFWDUSWCBXB3S7i4EmvtVq0MHD1Z25Eb1yPIwb0TFCYS3wsZSSMCtS?=
 =?us-ascii?Q?pXuF67etWzZqoVPEeSRTLioCHI7/qhPQO5iRfpx51D/3xS2Hodl/W/8Tc9O5?=
 =?us-ascii?Q?scvnrfLXsIjcxBIDU/j44VtG/gqIl4wjZzVHk8oR8smGRYeA6jn4w9hDKELo?=
 =?us-ascii?Q?eXa6SB1yeIIN9co9JNgcZ1L8ue6MyxJqd2bJfskZ8FkgFPfrBLH6OmC8B+cp?=
 =?us-ascii?Q?x+O5rea8o0JC/K5Lhb1x+bl9WQGRvkwUgeZc07wq+Hdmx1E6tyiI8szqfGz2?=
 =?us-ascii?Q?EfIS6RXaRWHQcFyvbEWuD/qeB9ayuaV2Prv4jKGUHuvYPt7tsH8N+e0Ef5mG?=
 =?us-ascii?Q?EQkQnZoVGKuK9ZIQXT+aMVTfhgKqHT9X79p1RkOFesHVhnsnKU6QKQrWeR8M?=
 =?us-ascii?Q?DgHIPw17e7l+Vn5QJ4j9BcIsiLTaxicamcP1E+PIHzVKqB1/ubGkAn48HEuZ?=
 =?us-ascii?Q?D286ICw6aWIuPCzm4b9ymULIhQlIUlQZtT6ZQ4PJpCLGLO7J4N6hpTxamWL8?=
 =?us-ascii?Q?u2sNZ+enurezP2luN+SDjWrHGC0QLvK48Ovv8eF6J6wMe7PYzYxD8muB4Sfj?=
 =?us-ascii?Q?8JxSEEoqg5Evf6Egff02yoxJhSDJtieAKwsiCHjDyyza8IJSiCpXAOeuernX?=
 =?us-ascii?Q?//xfw8Iv+oYzWLWimQXMex6WQSx9fvCDIX2pOR12h+0NKmbGCs0B63Qc4fMX?=
 =?us-ascii?Q?jT/A2zsqH9THkR6KHOWpm7nEkX7SvF9ZaJnVur+Deo9OC50qcBtx3baypfML?=
 =?us-ascii?Q?kqU3B/s6HM0eLxslByCsZrDFIBP4qwHKdEGFpyTMzYLz36Q7f5+BquR0PQHM?=
 =?us-ascii?Q?6nplj7fOLR2VMHifV1otallcrDjR3vLPzUkh?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 06:09:04.2116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13450dc0-f95b-4391-1546-08ddc42f4437
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6750

The Secure TSC feature for SEV-SNP allows guests to securely use the RDTSC
and RDTSCP instructions, ensuring that the parameters used cannot be
altered by the hypervisor once the guest is launched. For more details,
refer to the AMD64 APM Vol 2, Section "Secure TSC".

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Vaishali Thakkar <vaishali.thakkar@suse.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 286d509f9363..28dd83afb09b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -443,6 +443,7 @@
 #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* VM Page Flush MSR is supported */
 #define X86_FEATURE_SEV_ES		(19*32+ 3) /* "sev_es" Secure Encrypted Virtualization - Encrypted State */
 #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" Secure Encrypted Virtualization - Secure Nested Paging */
+#define X86_FEATURE_SNP_SECURE_TSC	(19*32+ 8) /* SEV-SNP Secure TSC */
 #define X86_FEATURE_V_TSC_AUX		(19*32+ 9) /* Virtual TSC_AUX */
 #define X86_FEATURE_SME_COHERENT	(19*32+10) /* hardware-enforced cache coherency */
 #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
-- 
2.43.0


