Return-Path: <kvm+bounces-40574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46A27A58C42
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 07:46:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 070333A5FCE
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB2E11D54F4;
	Mon, 10 Mar 2025 06:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ti3OiUmv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BCF29D0B
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 06:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741589157; cv=fail; b=dECZkc3CRHZyl0Hr+Su/lHFEIPaau8/jFUF5iEHLkBPdXdKn29DfIIEKzr7lq36oFLiacBFViHN1ku+0BmmKHHOeVpy5pCgsKGVCoYfTC35QyQYtRsjd07S10+luRB/373eBx4SB/jhA3uz46ApKIAZxBJgeTbShRwnEatCa3Bk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741589157; c=relaxed/simple;
	bh=dBnzNm0E+Ky1N4x/CrZnEsHBIwXk50GIdUybsv3i6Go=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MIn+0NbBTGF+8rQjLvbaI2Ok8aLKEwwi3VCAMLBVAPSS/bXWtuoB7yAaM7tv/eY38xXTVojKkvopXZ5lmBs1MClTJLjqWClkXMtL4CWl9yfGcBYbRIKFybYiMbWKKpoMHDXq2mcJQfHfOvm3L+HXySaxdEesWbNH6XpZoXIZAo8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ti3OiUmv; arc=fail smtp.client-ip=40.107.223.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hltp0FF57YdF2gdS46khNfl2BYdsDC1TU8do61b3k7HUj4eVlMIqIq/rpIazxSXXcjTjPQPso6rtdbR6OnuGx4R+EWrsouRwgU8toKhs4bgFRnSOX6zhulCaPp4gwgYqV480yFoKY+Lk3j57O6BUUIQqyznsUq6sdYuYnt/y0D0zSQMkgZdX07Ozz/uEk7ITkfzOAFaAUa3BbOXqj4sQ5upEdHqASOtRxW7gH2jsfh1mqg4aAziJ6rBJhGm0ldtbEZi29H0zg4DZkixJuiaHq7wsQT82OTJYZ16j4WzKtb07aYzdLsxlwKpr2jGasrbr65j+kve4ro1LScuaqEgrOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O56VsIY3dGKUiMb3gK0GbY1E0ibSEWcjpDJQE/4A40c=;
 b=zQ4Wtrwc4b9Ur2wt5eLsXCr3lKgfsRy3lqI0rfYd1sVCbGZ7oKac4K3VjUw1KfsWCA4B8n3kJA70oHIjOEa3oX0Ykc33YR3r9a44EP8TAhAw/cxlDKdjaAFMGugsoJ953uPv5W8QPfRPAcudCbAfSNZBUj3bNQSffHOqWLXmSA2se2JRKKBGr/XCvoVCNqAMGRuxHWHdtWyRzuokqvs8iCKL6r+ONcb/EUtBt7XoA6/WMuBIDBZs5j8qm1ArjTMsIQMn4fjqUpXPViw+lCdIrcFWIPPtTQRateRdBkIw6dyBTclwem8IGSrY1fdwM6C7AOecXTknrZd2ytauDnpv/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O56VsIY3dGKUiMb3gK0GbY1E0ibSEWcjpDJQE/4A40c=;
 b=ti3OiUmvBH+zIbaazsompihFlzJG/h+Axtc3bEVP3fOpyuxqPY7nCl9dFVvM7GxSqRSa+XxCJmBPjKEELebmCwUWn9WPcImVyYoq4D3Z/UMYdWwTa1h12KxWlJ8JzDmWeTeLv8SzvKKLEyN8HybOuVgXkTpzY1oRpuFbY5U8dpY=
Received: from BN0PR08CA0008.namprd08.prod.outlook.com (2603:10b6:408:142::30)
 by LV8PR12MB9641.namprd12.prod.outlook.com (2603:10b6:408:295::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 06:45:50 +0000
Received: from BN2PEPF00004FC0.namprd04.prod.outlook.com
 (2603:10b6:408:142:cafe::14) by BN0PR08CA0008.outlook.office365.com
 (2603:10b6:408:142::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.26 via Frontend Transport; Mon,
 10 Mar 2025 06:45:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FC0.mail.protection.outlook.com (10.167.243.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 10 Mar 2025 06:45:50 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 10 Mar
 2025 01:45:47 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v4 5/5] KVM: SVM: Enable Secure TSC for SNP guests
Date: Mon, 10 Mar 2025 12:15:22 +0530
Message-ID: <20250310064522.14100-4-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250310064522.14100-1-nikunj@amd.com>
References: <20250310063938.13790-1-nikunj@amd.com>
 <20250310064522.14100-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC0:EE_|LV8PR12MB9641:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cbb487a-89ee-453b-5e87-08dd5f9f323e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NxqYS+Ii8OCvLqZn0cd+okRKvUtMF5YokgTPDT1gWyOleT3flhTsME9XCDtn?=
 =?us-ascii?Q?zHHyH/LqbTMFh75V3FwflubUXO3GNFoDsuz44e4ohGtlO265eZBHBC+QIFAE?=
 =?us-ascii?Q?YGkjzf/ITjsGpVM0JFK7SFm6NYAb9SQE31QmW7iea7v142H8YjXWmyWyck3c?=
 =?us-ascii?Q?VHUL/HU14/AOBKviLwc5Z7Do8AXC1EB45LWKbFJhYJlJ9aqnSfhq3yQpXl8+?=
 =?us-ascii?Q?/BIjzZLJ8h8be/fBHZ+PCD/+s8TXwL30I8brHbcy48Lm9T6MkUoUrXfENorf?=
 =?us-ascii?Q?TJStRzwhynaZysJ6cNV90chnpd04l+/ZCIIFiDuljVe6voMW+nYx1Hbe1oTY?=
 =?us-ascii?Q?DBX/MhPKLVgrugGSMMfLZOfTtX17wCMqfNcvmdcKQ1RJAi8YaUO2tBdXhQ8W?=
 =?us-ascii?Q?X/CC+o0yb0zgk7XDqxzfAahA0HNsBYIKeEkfl8GzZ3wRhMCF7wqsh3kbRY4c?=
 =?us-ascii?Q?Bh5sz2qGGFJ6P4+jzpUW0fe8evkYdffHVxf689zXYVWaF7xOxFmMsHcPhKW7?=
 =?us-ascii?Q?h1Gu6VY5+o6GwnhSteFMGLwv1rm6NnVSyj7CTU0GZfmUjrYBsktXLmGI2C8V?=
 =?us-ascii?Q?P5W1s5nSWBStEgR9YRUKWxWTDmIKI3hkcmNwDbgTjFCi2bY+bVyuH8ZORovg?=
 =?us-ascii?Q?bGS3COMaisi91RDqFehIMxHTBPdIYwnBBRTnboaaEBr+waLjDSfcspqgwMP2?=
 =?us-ascii?Q?miZMVUzqPtzpfmKic8fJU0vAlbA+qgL7dMYTXZcAFGEI1PoqI3B135XxUfay?=
 =?us-ascii?Q?FovRGcWGHmz2E0HB3NRNx7ux2Llh81sb7n9oLuhWQcmNOzpDeAZYLcnI/Em2?=
 =?us-ascii?Q?1aGmfvaA38dl09pQyqtfGldJa7/lQjhro/999otQhypPu5gnKl3HrZlufR1i?=
 =?us-ascii?Q?a9h6pn2VySditqJj294mupqURrw+m2ojALxQAXXxlXp3AAuhtqd8Bfdg1s+L?=
 =?us-ascii?Q?dkbvXfU35qCuoC8S9r69AIkv4rZLS/8n7glYnXrnFL7oBAarrzy7dZFVdrLA?=
 =?us-ascii?Q?Mp1xztz2G/nj8lMO1+gSwq9jkLXsdlLt+Zz0uW784B+WNm5bmNT4U+7bCoJF?=
 =?us-ascii?Q?mgMlBQEpLjHgk4eOFrew/FySBkbCSu4GOhtpn2DDeYA/arqlzPPwCsjTXs3l?=
 =?us-ascii?Q?5gLOOsaHu1gtGSsdewPUvmXHj89znIdtVKTvbC8kaGwuwWffWYSuWKF78IY5?=
 =?us-ascii?Q?l02LOPuHn/r4IUexGQNcdm/XiiLjviyPqyZVSTMli0/tDyJ2m2vPa6nxMHES?=
 =?us-ascii?Q?2fiG6skZZu+NXdspW0m/jNCDDQfgKDR7AeH8JQPdd1+nGAL5yWyJZKW/1tfJ?=
 =?us-ascii?Q?RLj2ea7MK47DKP7HaIlFwYeQUxGHSdrGfnN61WUNOwik0Uabkn9SAHn9iY8h?=
 =?us-ascii?Q?cl6pNWJFR3iYf2X10mzioqv76PNIEeWD/0Z4pLUgf/Wrp1VCZ3+6b6auJ/fO?=
 =?us-ascii?Q?64HJhbU2tlD1wGsRvv59ZUz5Il4JFkIfbjKEFuXbgyh6y9P4eFxkxlKPbB5y?=
 =?us-ascii?Q?CNIdgvsVK44t9B0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 06:45:50.3396
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cbb487a-89ee-453b-5e87-08dd5f9f323e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9641

From: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>

Add support for Secure TSC, allowing userspace to configure the Secure TSC
feature for SNP guests. Use the SNP specification's desired TSC frequency
parameter during the SNP_LAUNCH_START command to set the mean TSC
frequency in KHz for Secure TSC enabled guests. If the frequency is not
specified by the VMM, default to tsc_khz.

Signed-off-by: Ketan Chaturvedi <Ketan.Chaturvedi@amd.com>
Co-developed-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/uapi/asm/kvm.h |  3 ++-
 arch/x86/kvm/svm/sev.c          | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 460306b35a4b..075af0dcee25 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -839,7 +839,8 @@ struct kvm_sev_snp_launch_start {
 	__u64 policy;
 	__u8 gosvw[16];
 	__u16 flags;
-	__u8 pad0[6];
+	__u8 pad0[2];
+	__u32 desired_tsc_khz;
 	__u64 pad1[4];
 };
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 50263b473f95..b61d6bd75b37 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2205,6 +2205,20 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	start.gctx_paddr = __psp_pa(sev->snp_context);
 	start.policy = params.policy;
+
+	if (snp_secure_tsc_enabled(kvm)) {
+		u32 user_tsc_khz = params.desired_tsc_khz;
+
+		/* Use tsc_khz if the VMM has not provided the TSC frequency */
+		if (!user_tsc_khz)
+			user_tsc_khz = tsc_khz;
+
+		start.desired_tsc_khz = user_tsc_khz;
+
+		/* Set the arch default TSC for the VM*/
+		kvm->arch.default_tsc_khz = user_tsc_khz;
+	}
+
 	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
 	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
 	if (rc) {
@@ -2927,6 +2941,8 @@ void __init sev_set_cpu_caps(void)
 	if (sev_snp_enabled) {
 		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
 		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
+
+		kvm_cpu_cap_check_and_set(X86_FEATURE_SNP_SECURE_TSC);
 	}
 }
 
@@ -3059,6 +3075,9 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (sev_snp_enabled && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+		sev_supported_vmsa_features |= SVM_SEV_FEAT_SECURE_TSC;
 }
 
 void sev_hardware_unsetup(void)
-- 
2.43.0


