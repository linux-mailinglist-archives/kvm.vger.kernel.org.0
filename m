Return-Path: <kvm+bounces-58453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C89B7B94464
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC9ED18A72E1
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:05:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A0B0266584;
	Tue, 23 Sep 2025 05:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b02Ao9Re"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011057.outbound.protection.outlook.com [40.107.208.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F229026E16F;
	Tue, 23 Sep 2025 05:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758603880; cv=fail; b=ZXqzpiqv1Orki4BE96mIFjLklM/l63L1FP08ZEV6tVsJ+tPacPQ4MU/YAqSBBX3XXqT6PwZ1HQ4u/Lqi+pbAe2FRKj1CXtYCnj3LzJKh4EMT+CS1OxufL129/BXyRPdIQYUiDEWUTbFn2dD3Que7a/BJrzfHL2/IQzuqMLJGBWA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758603880; c=relaxed/simple;
	bh=f0mjxw/cd34ivXhJ+2eevESt3tC6L3p4fr99YYvaiaE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iQihjQbks/6Vc0FcWi5ov3G3C040flzjiT6FQOl8B7E0jAj8+7/ZmLyCbnGSPYmQlQ0KdNLjfqBuLhPjUoytukO2a4mc576qjj5BkS6/9ID1xNbUH2ObvMkwO0iOAqkOBu6EeBPOqioZCUh/dHmeLhkNk7ZZ8SEaduhZzy+DL9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b02Ao9Re; arc=fail smtp.client-ip=40.107.208.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dHEoK3lexTOQ+FV1naPuOlxgcL9krC9fZnZBG1RbgZ2Mjp1Vkfx8YQRB9ImivFC9SrmPhag7+I1DDsDpA8X1Ag3mlhsqg68TKlE+ZxWxj+P2Y/jPk59YEvGIA0coz/g7DTWbvNYhGQKiFQ+rlQgcUV3rMD6i3tGjXsgcTgp75ZrCGB4t6MPSSVaUbNV82nSBZixz3sundpbM/as6qrz3IE1iHsOURoNmLVLk66NU5Az9U/0HxHpVP/NmYk0ADcmCZqNvmhVwsNlVqTMFlQ+ghKQsj8zrQ7kQJF2dXAFs3iWAx08XOKxTgh2mQHH8KREiZeSz8qvOe24zV215xVD8Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQtivF9Y+lzTdkv2YC/3nMyLJ1YtLEh5+l/yUmeCz8o=;
 b=U0xtUrOElgEWI9zOn+uY1hPitcETS9B5m2XULYZXvRsTdinbUHTnEaECgeLHzJbDtY/n5vTf8DfoirYJSrYbkfi+Q7JUWpY5mUfA9zREQKhqMWylP5JNRNaxCDXYK7ZSd+io8ppK7jU4l7aYlMASEFb1zyDtEFflVoZ3/utbxA4vZ5wRBuPOvz1TD4Y4twjnGVCE0xn8WzxiWasQthCeot/1rYcU5+4rujlqR54BQFkelk8VU97lYR2mPVbzazB8kdsIizGn+G1hFmKyc6zx+1rcpgusbl8jdYt/W36mM1pAJC1FqUpAot+MJ62Vj83tQGQgl/Zc053Ibm7U2CEIug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQtivF9Y+lzTdkv2YC/3nMyLJ1YtLEh5+l/yUmeCz8o=;
 b=b02Ao9RewN4Sq0q/nHBjTlCs649rL0tYc7eWoGuvwexo8LoSmuLZ66FUugFmoGI3cXXNfknMO0hpIeeW8wYYDkSqoL0xywncrMp6svVO+FPI/4vSeuEvYpwowkOoL+wPstylnR+A7uE8dLPI3MIx1l/Q7C0iwQeCsOwf0Jo1hqw=
Received: from SJ0PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:33a::22)
 by PH7PR12MB5596.namprd12.prod.outlook.com (2603:10b6:510:136::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 05:04:34 +0000
Received: from MWH0EPF000971E5.namprd02.prod.outlook.com
 (2603:10b6:a03:33a:cafe::4d) by SJ0PR03CA0017.outlook.office365.com
 (2603:10b6:a03:33a::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.19 via Frontend Transport; Tue,
 23 Sep 2025 05:04:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E5.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:04:34 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:04:16 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 03/17] KVM: SVM: Add support for Secure AVIC capability in KVM
Date: Tue, 23 Sep 2025 10:33:03 +0530
Message-ID: <20250923050317.205482-4-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E5:EE_|PH7PR12MB5596:EE_
X-MS-Office365-Filtering-Correlation-Id: 91da916c-10f8-4747-6076-08ddfa5eb037
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IG5QuF6jJE6wmyWMG6i9VY1rbJ9UTcZrUH+0TyQSX+UxlJlRfRpNRXVqg6CJ?=
 =?us-ascii?Q?OY2dapnyIxP3pFLkrwtwkjiFdSH49xytDrhMOQhInbdJ5lRPa3bAetK5Ur3Y?=
 =?us-ascii?Q?I9r5zQnRHkoTtcrPtqDlXmkAGGyw8bIx3nbN2/CswRsvumXpTtotKp//HadQ?=
 =?us-ascii?Q?0dyVibyEErmtJ2igOSX5aIrBZxfEAMrJsLGFHTta/dgfrpTrORak0ITVQ3sw?=
 =?us-ascii?Q?b99wrSktNuF/MoRGkdXvFeQzdvp0G0Zl1wV9YM8NlDHrGmJ7TTcMN4ibvapZ?=
 =?us-ascii?Q?ERbhTEio7GZad8GcCmMB/we5RMykkd3s5tEcu0ig3/lwhJwusTa7wJ3emlMS?=
 =?us-ascii?Q?N7MDPWbfwPEwi2bfC/2Sj/LkZQqP7Pww5JPu9LHqnoc1skRt/kd8fCI4sCxJ?=
 =?us-ascii?Q?7geWk2e+p/jWoDxwT/breKDZPbadKpOSmyBzZcgtrnNbb5KW0JZOIRTTmnuY?=
 =?us-ascii?Q?FroG389nPvDLU00ycme4W4OPE565G/Gj/nIYf4YJu/vMSZzRT88Ps2VsYPI9?=
 =?us-ascii?Q?Tw2yxGOoyNnIxdGadKtaI+fZ49dOTbR/pgBfpxMvUelXg43lrJ7K6A/QlIXi?=
 =?us-ascii?Q?tdZIZ0e6WRsS0wkMMUVOrMXNPxMaDBQ5aEQPg9HSEyhoof/kabl7g8+n+YN9?=
 =?us-ascii?Q?xQ83ek7yEruzdsF8kn0fYK9YPKd4SovLL1UbEyq9owCjNGaCoqmd1Dk/jk80?=
 =?us-ascii?Q?s4L3cUNPrrvGW9mA8mhglTKCNCzISVdWSLcyHkWIjVzK7WBuzV3GYOwSZxfm?=
 =?us-ascii?Q?ICtvLrGwElvVwWMx+zeXVyeQeH1UYOUB/4xJ1i41yGy7tJB2GS7dW1cqKj2Q?=
 =?us-ascii?Q?A6GoCr5Xhlv9LLUVh7uwu3zhLremCfb2jL5KDrxOLvU59Qtohze9YIVuZNOD?=
 =?us-ascii?Q?o/Fa+wc1HMNA4JZghoS4K0jAFk+jE1eVpn6mw2ELbtYLZNTCf4BFLo7vuQg+?=
 =?us-ascii?Q?Wo5oTsnev/svj/vE4Vc2bI10+nfoFCRhGNCLB4+H/S57hG3V/g3nr9PsLbPe?=
 =?us-ascii?Q?7qefHahxw6cuOjWyGfoZgdtDyXA2mZ+MWtx/OWKSYC8azmDjepE5EwuOf7wA?=
 =?us-ascii?Q?FZYz1HRz+I06fvGwchnu34KcsFwnPouhv+hRXrf8PGPdc4twTNe51Q3pWGyX?=
 =?us-ascii?Q?dDg6JXOvvgZN5hsLt4ZG0q3LAAcED7zYau1iL9CEvLHknpqnNWosOovEnIYd?=
 =?us-ascii?Q?BAfIF259tOJrXjDOnc2n2XB0b+Wqn4y/FMur4sBSHtuhbl6ASwYk1pj8iqdz?=
 =?us-ascii?Q?4Y8Fhd8N+sUMxBfxOjykbBQJWIal0HKfIrES/K/2bGAURyHg7L2PKEnDdlfz?=
 =?us-ascii?Q?9RBmZBNXsujoA4OdnE21ZfC5AmFJhjaXURo8dUF0RwCT5eZicbSq882YyK7H?=
 =?us-ascii?Q?iTBX94fU7hPnkxesnP4eqs0eP07QD0f4qbKl5E7nV9d4Lr/Sv153W3F551SF?=
 =?us-ascii?Q?b8iR13+HPJO9dFwdL4Ywi7UhIp/mm897HJtJNZCT48h/jUyIxG4eMQp0tOGf?=
 =?us-ascii?Q?t7dTApYAV6F+rpYAC/0LPc9sCGsZpi87e85w?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:04:34.5338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91da916c-10f8-4747-6076-08ddfa5eb037
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5596

Add support to KVM for determining if a system is capable of supporting
Secure AVIC feature.

Secure AVIC feature support is determined based on:

- secure_avic module parameter is set.
- X86_FEATURE_SECURE_AVIC CPU feature bit is set.
- SNP feature is supported.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/include/asm/svm.h | 1 +
 arch/x86/kvm/svm/sev.c     | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc27f676243..ab3d55654c77 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -299,6 +299,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define SVM_SEV_FEAT_RESTRICTED_INJECTION		BIT(3)
 #define SVM_SEV_FEAT_ALTERNATE_INJECTION		BIT(4)
 #define SVM_SEV_FEAT_DEBUG_SWAP				BIT(5)
+#define SVM_SEV_FEAT_SECURE_AVIC			BIT(16)
 
 #define VMCB_ALLOWED_SEV_FEATURES_VALID			BIT_ULL(63)
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5bac4d20aec0..b2eae102681c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -59,6 +59,10 @@ static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
 static u64 sev_supported_vmsa_features;
 
+/* enable/disable SEV-SNP Secure AVIC support */
+bool sev_snp_savic_enabled = true;
+module_param_named(secure_avic, sev_snp_savic_enabled, bool, 0444);
+
 #define AP_RESET_HOLD_NONE		0
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
@@ -2911,6 +2915,8 @@ void __init sev_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
 		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
 	}
+	if (sev_snp_savic_enabled)
+		kvm_cpu_cap_set(X86_FEATURE_SECURE_AVIC);
 }
 
 static bool is_sev_snp_initialized(void)
@@ -3075,6 +3081,9 @@ void __init sev_hardware_setup(void)
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled = false;
 
+	if (!sev_snp_supported || !cpu_feature_enabled(X86_FEATURE_SECURE_AVIC))
+		sev_snp_savic_enabled = false;
+
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
-- 
2.34.1


