Return-Path: <kvm+bounces-61221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DE8EC1133F
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 20:41:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3F10567CD3
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 19:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96CCE3164B6;
	Mon, 27 Oct 2025 19:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tcaH7nrU"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012013.outbound.protection.outlook.com [40.107.209.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203482868B0;
	Mon, 27 Oct 2025 19:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593679; cv=fail; b=Pelag2Nr6DI+3iP4E9U+SaMOTiaQa0RDj8J5ZLyvpGZ7AwBIrs82AnlU9lz4nfGtOfMiIZxGJ7+qAu4i8hq2QNpo1Bh1cVY7GGdv0MieynsUA1d+7wMKKiISZjBY/A8iykTlFYwyfGrruF1mZ41w4UqIK7CVomMK3sgtboE+ViI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593679; c=relaxed/simple;
	bh=ww3DfptoAQ/Np7t952uK7mQ5jgg5bDteDlj4fUPf4zY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YF1GeRAppYbdl4A22gPguxiHNL8nZCwI2XVTKvHePfq2Gg/3yJkm4F6+fsERL6X79aDK0RB97gHlsBCcKi7fIbdh2rFlMyr0YMYyBigzWqVKzxZL5EnMLYI9CXtGP9NibfF2jG60W5KhA9s5viDpccha68lbrrW5hTXpYRNI3sI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tcaH7nrU; arc=fail smtp.client-ip=40.107.209.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MBN1vk50wMJCPHzbUgQZNUA3eGtmeK+jDmIOc89GxKfDtnURUJi1tYpkCW/K4DFMHX4JJRqFUTeYt3n2yV3PA+1PTdB7PLNmfyi8SDbpx+j1x1PucFWmeqwXNSQ4GqGcSEri4hPZ5uwK37rYjvuJs6rtYAw5n1lJqXzzEhMHD0pB8jTZF/ZSJz2rvKGBVgRIBDNVRym1SP/EDr3+P3yetEle6Ud+ByPV8KxO9i3xqYYlTD/+cfdENbswKbtPI9Za/3tDHrJ8GNisTe+t3VVmbTk5YFyz6DMuuTREponbzbn0wjhRzd7RJmxJuX8U8S6BwRThVn0N7x8AkrNotoVxvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rNTU8A8J2jq6f8KDamMKEb9gy6taq3v5IkPkW6gtdDM=;
 b=rMQtcrXVOO1eEG9eX2Y74lflJY3NPfZxfYCCqKDvD1+tZTRCh4Oq9riSCDBRHp/xx2f0hF2pX8+ky3BNF6xpuh0rdC//1yHEGzFf76X0Y+b0SHetpXBsWvvk8pJIMBLmiP205O7RRm636v1rZdV8J2Ahp7I7ovcOEHYqWYRB9SSfIc8GGhegk+EKoDQO99M5x1xERkzOLr36AslEoV6xP9hZOH740U87C1Htw5TvBFAQSowoGqJ5hSR+j51VOLnlWysDfmAhXkLy98bWFMKQ/qlhhOS4L7UHR6xADGIW+M+Y8fpzNi9EOIz91mMp+t1GZ6pavvXcNZ+2C8y46Q1pbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rNTU8A8J2jq6f8KDamMKEb9gy6taq3v5IkPkW6gtdDM=;
 b=tcaH7nrUwGwzeFPsCuStvONik4QyTJDDxbJLTUVDvCYRFtBU2L1KqWIFNk9OOAiJOWyZJPyacJl79zdz3jm8r8at8TiWWgO09cNP0ggC+ohAO6oJSgwC+CllKZWlvc9lEr7ELXgEKAL66yuS7wwbv2vw02s9LdFsd/ApxLZFTLM=
Received: from MN2PR22CA0008.namprd22.prod.outlook.com (2603:10b6:208:238::13)
 by DM4PR12MB5939.namprd12.prod.outlook.com (2603:10b6:8:6a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 19:34:35 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:208:238:cafe::ad) by MN2PR22CA0008.outlook.office365.com
 (2603:10b6:208:238::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.17 via Frontend Transport; Mon,
 27 Oct 2025 19:34:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Mon, 27 Oct 2025 19:34:34 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 27 Oct
 2025 12:34:34 -0700
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [PATCH v4 4/4] KVM: SEV: Add known supported SEV-SNP policy bits
Date: Mon, 27 Oct 2025 14:33:52 -0500
Message-ID: <ec040de9864099cf592a97c201dc4cc110b2b0cf.1761593632.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <cover.1761593631.git.thomas.lendacky@amd.com>
References: <cover.1761593631.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|DM4PR12MB5939:EE_
X-MS-Office365-Filtering-Correlation-Id: 4afdd9b2-95fb-4d60-e07e-08de158fdc14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KeT/bFPQ59B6nvHFV5c6dYlTf/VshUPWYidYaf0VW5zK0AvhqQhEeloV6f9I?=
 =?us-ascii?Q?UmqM66uM4/ui2tbUPX+FOwyv6mhV+IMM8yg6wjaZ7P3tdSDhPWIuocnKj68F?=
 =?us-ascii?Q?g7gj0OBnqqKNd2pox7o57g1YhET5QQLVI/lPzyJiaOBrMYvPBTdtxipI3uh2?=
 =?us-ascii?Q?ivWqmkfbcE+eTePr3WRKP01+aaWm8eOZKuEDnMDmYR3jIvCq8RAsLbhunYhb?=
 =?us-ascii?Q?81h6piWiaIgLmFqVFCmgIvLV7ufRgABxb+LzscI4wXMQ68xkXZ2SzZelkrNF?=
 =?us-ascii?Q?ntUV5ls/fb5++V93mT/jYNQkTIbLwh0Ts7nO4R80Du3f7hKJUsmiOdRvglgw?=
 =?us-ascii?Q?EW6kfkS1WGjulqTgwxyxAFMdmIlxciE+jDIwJLGRHtgJy1LKidcTYoKNwyU2?=
 =?us-ascii?Q?h22234ya8/CvSyTVSgGvGarxkJr3uEg0gZPb55UiO89yTfCdLhQvjkQrpwtI?=
 =?us-ascii?Q?nw7xAJQa80gGoAaVutit6cG6yY/RIfTjVZWXUJNO4xCctI46bddroH0mgRnj?=
 =?us-ascii?Q?sLbjWYuVOZ4hwHJOj6kQn+apAETRGzrIIHYLpdspLfzsQiiGxAocL3wgLeB9?=
 =?us-ascii?Q?p5vBc2s8ItNVBoufIAUoO4kWRS7IUTCs2twms6Wt6l+SvGcu4X1sGK0XdIfq?=
 =?us-ascii?Q?uV61o47zaautnuhIDI0nO3uZZxfHnTwyeFr4XuBIsQmcN4AFBQXcSaQKybGl?=
 =?us-ascii?Q?fXc0ppD9fbhD806ztk6NLHswBJoGsR8ixaaEH6zh/LWgWCwxd2ETDck+fRWV?=
 =?us-ascii?Q?5bTWcM8jO9ZQhk1LAewju/SU+Ta6fANWzuNMyXgmv7JxXfjOtxFyuVi7WC7T?=
 =?us-ascii?Q?mtmb3JoJn1Cos5Bygi2tMnvI7eOlyyoxxYC8Zi/bVdmB2wLiJQ2PadSQkNyU?=
 =?us-ascii?Q?SYSM7kSYlbtSWNTrRm2jjYu2bGaHyoj8ERKSeG1gN2L8dzv45YmiftVxVikD?=
 =?us-ascii?Q?k9Fo40pd91GqfmBGXt4zJN43tH/OSjxfV+MKZNPitSgltKaL0K3Bu4bzATAH?=
 =?us-ascii?Q?wJAGPf+shNtd2G346PJpzxc2II65Y5GZPH0FzGuDx5QGOauTDXaDSGod3F6A?=
 =?us-ascii?Q?stCRBigm6tBUfZAraTG3dkdmIi4pojmVm1CFGLv5ak7J6CejKPE3ETPrJ5UR?=
 =?us-ascii?Q?n9fifNDNFCIXlNVX3KHLKsJn8GGM7i6YeCM+R/PEVCM/yp3yPgioP+SEuxM9?=
 =?us-ascii?Q?Cm7HLPhFA0gVQuseSD6Q0pKf5jPQiNcq7b0l32iZLDzxB6+P5CdasspPqLIf?=
 =?us-ascii?Q?l+dD9flsNtoW0hmkerDznDKFOY5d+cIJhQtLE26ZNBLTk0tEG12QnVAHBbSj?=
 =?us-ascii?Q?izD24a6Vl5UG7B2neWO87bEhvv4FkqditsiXokSNGhqSKD03gqJChT/5NU3y?=
 =?us-ascii?Q?/HuCXdOc+HpBKYGEwyeyeA7FtzBirhFOMcI7clwc1lp6pdVzYBhV1n9c4lsx?=
 =?us-ascii?Q?LZg1eoZBjdSv7hXfths4VT6CvmoPcC2xG3gqqyogimFX1DMiQV1gOTbN/Vy8?=
 =?us-ascii?Q?OtYRWDzQz5lmJ77sNESvOPMvRo4FPPRR9ngxAbcZgmSQEGLqdXl1alCpdA1E?=
 =?us-ascii?Q?7eGX8NC84r9GSNlz+2g=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2025 19:34:34.9624
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4afdd9b2-95fb-4d60-e07e-08de158fdc14
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5939

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
index a425674fe993..f59c65abe3cf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -65,12 +65,22 @@ module_param_named(ciphertext_hiding_asids, nr_ciphertext_hiding_asids, uint, 04
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
+ * that have implementation support within KVM or policy bits that do not
+ * require implementation support within KVM to enforce the policy.
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
2.51.1


