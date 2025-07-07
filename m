Return-Path: <kvm+bounces-51663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE04CAFB0D1
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 12:11:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 193AD172976
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 10:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ED1A293C6A;
	Mon,  7 Jul 2025 10:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GFbSJvaD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7C71BD9F0
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 10:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751883058; cv=fail; b=P1tbnAcbRfaqLNG7MPJhZEykcyHEwlc9TntLXnT4F4zZ5XLIxQBqb7GNsx3vUnNl9Fz+1VsVGcytiD5nexOA36FwedyMcO376v61n6iUqQZB2K4SiQUJalNw3UNWXLHIEBKsLQuy2mYH/ZyMnW+mlsxMzbEDsVtkS3X80r/r/+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751883058; c=relaxed/simple;
	bh=uSfpcQ9LkM6EQ0wnqY/9k5yEG0H/MaLR+rUh6+oTRQ0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G1Ah3utpne+wFOJ9Uv3+swS7JIacuGTCo0Ior0VKySNbiAVv84R5AyI8tK480bXrdUcSOeZnIMoSEGmSkB46t57N9sBhmrkzqVm3SAjLrXr0GSNEGPLdDMNA2T8qqx1ZV2tuLEC6jPuw3dTSmLpLMQokc9/EDF77QdVtMmf5sKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GFbSJvaD; arc=fail smtp.client-ip=40.107.223.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tNM44QxNRnVfOwyFKIN9sINlpzcPfFpmmjZitNQ2J0OnxeMqkEq+ZAqZGmTpuHUxkoOylm/jjJB/DX4tQmYpaixJfDQKxu7JbbL3fOJvG8vQa4nzwbr5rzLEUUlu/tpxbtILdWiBFsLeQsF3OduKHP1XSB1nkoVDMxzUJ6rDxJ8Wrq/UXVlP2FxWyQdjZ+UH/VRlOoLFJK7qPMBTr30A4ShiokKnHUN7oLpxJsNJ4iv8oN8/fwQ+M/Yu3OMVtzNOFbXUyh18JbrTPHjdZHAN5Rn1Sp47D2ojU4UpjJIPJuokRG0ePdCgC2UHEvCM1+XYs4FHQQk3JUPIFqTx7XNJOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=baQ0HcVD2kUs/DSxUNDGgZqs0sXLgJHVUZ9CnZiZc8w=;
 b=Va7Rd6kB0cf0qo/tX1IXfWjk3Hatj0biFwEcet8Lg2ByWrJZG/Z0NILnvV6c0QuLmcI/yLhWIReD7vyfZAd3CwTk7vN4VAZBHbLltnzxeVxHucXK9/Zb9DnjXOG3a1PA/DcLN0gb4CnmL+Jvw7V9Z7Ljc4W5/a0YYfC8uv7SmjJa5nwY5BY3RJ1Hf+rFBP3oI8bBrBhd5wZxcNSm8xHJC8I8lGxYpItKyEzNn2b/x8nyab8TBaQ2ed7kqSd8nfB4l85EcqTdjzEdZQEesZbsN9MW6uP7R79SlyuJUHlG0wwg9l8K85tNxTTna2VZJ9vYICZgX+RPgOjW45/EwSyVDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=baQ0HcVD2kUs/DSxUNDGgZqs0sXLgJHVUZ9CnZiZc8w=;
 b=GFbSJvaDwoyNEhnGQkwM65XZTycpFo+BQKWeqx3CU7sibP+YxQokUSmob2h81SG5jIzObltjToDxM0K31ypiX3rh9CbaLGlVP04GQ9eFaVtywPNDQe2QeBTsRq3euBG3f2LVc0cXR5IB3uyJglwejSogfjr7mgV2WYB3TwfiskA=
Received: from BN9PR03CA0037.namprd03.prod.outlook.com (2603:10b6:408:fb::12)
 by DM4PR12MB6543.namprd12.prod.outlook.com (2603:10b6:8:8c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.25; Mon, 7 Jul 2025 10:10:54 +0000
Received: from BL02EPF0002992C.namprd02.prod.outlook.com
 (2603:10b6:408:fb:cafe::18) by BN9PR03CA0037.outlook.office365.com
 (2603:10b6:408:fb::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.27 via Frontend Transport; Mon,
 7 Jul 2025 10:10:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0002992C.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Mon, 7 Jul 2025 10:10:54 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 7 Jul
 2025 05:10:50 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>, <vaishali.thakkar@suse.com>,
	<kai.huang@intel.com>
Subject: [PATCH v8 1/2] x86/cpufeatures: Add SNP Secure TSC
Date: Mon, 7 Jul 2025 15:40:28 +0530
Message-ID: <20250707101029.927906-2-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250707101029.927906-1-nikunj@amd.com>
References: <20250707101029.927906-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0002992C:EE_|DM4PR12MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: a2b95932-21ab-4653-0034-08ddbd3e8efe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zNPkUYA869q5VeAR8kYdN7BQ9/IFwB3BmvFljEgod7UDKkTnWcApjhhmF9D1?=
 =?us-ascii?Q?egQWLuIYtrlij7Y/7JzQkPtl4zMPltvQelDryRDTl+vi1MIM5kl1f4eUFTj+?=
 =?us-ascii?Q?txtXwms+CEVgP0/VEQM3a8dmBN2H9wOXaqL2fB2Lwh7LcMJBBxRJq4YIHXwZ?=
 =?us-ascii?Q?hnW7JVeovXLCQjNReBFu5e9gKgndBmetJnNYE3TDdTCv7UYjdWv8I3X9awZd?=
 =?us-ascii?Q?QVAEelxcm39u1Vs2tytcbJYnAQ/4URDtISiqcaTUGb2AVE+KAP88VLtEQEQP?=
 =?us-ascii?Q?gxj4Hujz8UrvS5iXvai4SAVa5u3/+RoU8ONQZD9j26Z3GeeqxLh/EKPIChgo?=
 =?us-ascii?Q?ICIvuzi6d6lZRZyMzYKPabxX3BqACLYwhr05ZKir2zHYjS8b2Ewk5DEaR9z+?=
 =?us-ascii?Q?JGZna1gXJwu3g4BmqkBFgbdJSAIrBDV4Tj3XOq5EOP1wsyM+gDeqTRmxGuAi?=
 =?us-ascii?Q?/yiJ6zJZD5txFILFeRIVczvpLd82Vd98OOXE5bOXZLD3lvIquR0DUDWdoRD0?=
 =?us-ascii?Q?A4uccgPD3w2N9BRY6CYBMojpQA6q2TKfV/lNLVkeKZ2yhs2Owwfaz0ovbUkl?=
 =?us-ascii?Q?oB3Vrzp8QNhMudiGpgSRFA2s9eFvB4dnem82HDa/r9AHdEx101iS3GrDPDlw?=
 =?us-ascii?Q?YaC//QPgu3WSJ+/71FJdzbPbJJENWzwJtgGpQS0y0xfOOBOvTsZjjpLi03wK?=
 =?us-ascii?Q?hjZMLTLy36N4eGgtA7NQPYMfmeQxGSjD1o6x51uJEeY1dk6zi64daZKhXx9V?=
 =?us-ascii?Q?KvX2H86l922jqLkElUz3zIiUVoA7bP8E18o0ophDpCQo64BTTKh6wIXKwDPY?=
 =?us-ascii?Q?fridP4xj04mEw+WcMwDln/DLDdsvoBFp5sRFhG1TmA1YPBksWGf7Otxbo4XD?=
 =?us-ascii?Q?NxDaIXfS/7h98eS/zVSOnBLxrInMqnuqOzO0tsq4miQSUw7MIZwAqiXWk4c2?=
 =?us-ascii?Q?tRmQroVwrVcx3LwekwSpcsBX3aQaadgYuSyHKKTN2nzElwMO/wPLkS3OUh0e?=
 =?us-ascii?Q?mdq9YQZMahOxG138ZzEqQMDo3HBN5IHk4IHEro6z+GxCB6PiYxR1FibG7zOV?=
 =?us-ascii?Q?G9fjR09qzwhR9wttnI+7WuwWUYd+RMwoF1yUpQmKjQwm1qcmIzA6PhHE4hZN?=
 =?us-ascii?Q?ovbUqYVk23LGPsTVB2KL3CNdgpNC5FdjdkkHX/Bnh7AOU9SeOGboKfzUxM/6?=
 =?us-ascii?Q?9f8B5/AGJU/gzkSDPQdgrbAlA5YdSjvMjuUTyRgwg0cTu/j9w4/OMjtZUvRf?=
 =?us-ascii?Q?kb5mRoHQMx85yaOoDeccN/GUO1n3KZIHgI+NentupmG400PvWG1eIUx/wvac?=
 =?us-ascii?Q?hgxELTE/n/ZezwJSXj6Zz2CdpHro+rAQVyWITCzWUR47Wma8yWjA3L3YXBxg?=
 =?us-ascii?Q?QXn48Lj5xf81VgUYNdyxeB4/WN9uquOfH7UIqBggEPcN1WLtC+Lnv8vgpQBb?=
 =?us-ascii?Q?hAssG8Jte//FvHgMPCgK2jUzAInMeY4agz8QD0wfv8mYxgLSNYsXu9ygZmr8?=
 =?us-ascii?Q?madKfDkAPgRWvWDi14ZENZZH0KwOfMXIm5tH?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 10:10:54.0685
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2b95932-21ab-4653-0034-08ddbd3e8efe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6543

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
index ee176236c2be..e5001c3f7cd4 100644
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


