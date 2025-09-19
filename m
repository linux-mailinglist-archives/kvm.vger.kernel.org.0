Return-Path: <kvm+bounces-58179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E67D9B8B053
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:01:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68FD81CC4F8A
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 19:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF9727FB05;
	Fri, 19 Sep 2025 19:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CXgx+ROs"
X-Original-To: kvm@vger.kernel.org
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011008.outbound.protection.outlook.com [52.101.57.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4C72566F2;
	Fri, 19 Sep 2025 19:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758308445; cv=fail; b=OWl874pp2BdLwnIzVo7sU1XyrBv8ckTH+cIyc6CTLEWuDSSbRVoBmX6tSs4BqGR4zPMOGgumEuPelJT2RhjbksvwlJnaFVBR3v4nyeyHU7wXRi1YFIgMOVQXQlWUjniB7gTkt2rBdNPRZ/kPAe6MKdrhqsYL4FQgo5X0WTa10pQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758308445; c=relaxed/simple;
	bh=o7UyrwIyfDWhoJ3SMqHQVCb1URnHcvcHpDmOeRsbxS0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lr3tckaHYgWrMF6MRoVuVfzj+136VktAHRi8m9w4YPRDTyNp5zA1hLj4/mCOUiP9z2jBKS2zLTvCU5bFv2frcVYx209+sSW3kcMLKMOk3IOKHarYC0oU5Y75K1Og2JYqEhJ/kSpdtgXxYAxN8MqYEXXEK67IMk7GSU0U0K9wTio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CXgx+ROs; arc=fail smtp.client-ip=52.101.57.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s9m8x1u97CXwhvqoZK3FfbpX+sOadhFOnTFrPTGHQ1MpUQN/eECLgGRvDgjEUPUiSxZ6umVYS4Lu6KvYSWiwaCWbW+d43vsgRDVVPi7R/mojJpB73gl1Rz6huJUNQjCvNF5Ua29cNiPMJ0Hvd4XS7o8vQ7cX+zlcod2ifyQWIxZKKr385BbKQ8c/jUDlJNCHCNon3pfLA77hrw2V8XkWmTSybgdVYvAhCFlp6i+pq9mdN1867hUrDgEeq45juLDaM5bbm3Gjx/B3zq6f9QWLkq3F5+8LXBCrh9b70aLOAGaVFSZ6m2U62W6OyRXX6IaAV6gNCtUscZkxmIa7YGk6rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5GJkbMdy7D/J9OYUDeUIhozUifSnIls4ii58/toN5pg=;
 b=bSNNydUJEI3EZWdRfxskeg94Yjj762Resd77bZUmscYfXOg3/fJBuDGqPgdRjJMM4HswxT1KAGE5FlWMnSMbCfBwqty4Bla7iCNtO3dJbI21DtPh+vZLb3Wemq3Dmj2tf17Vkr27EzdLe4lAtGrHPXgUrJfgdO/Vad7pYBWXGCHfgL8qcasoyDDukna2DB/aYk/ifS19du6cHLs/5NAEcNGBpckLE+HA5HpfakqloRqHW1+f1xKT7f3dzaajcZHJxgvFDwUYsJFzAEJZ+8q7ddwhzozLL24piPW82YRngtgMMxHQlJC/iF3eeXgvaabw4y2M08Q6Et8UjL6qP38oAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GJkbMdy7D/J9OYUDeUIhozUifSnIls4ii58/toN5pg=;
 b=CXgx+ROs7SYV62Dxgy+EqI6v4NSTqBAyAxRv0hGbgtbZcdZ2x93sUzhNgVzCWGgcEmQQGpDwQ3GCnBfrvYSN0yliSZZPNq7+likh6JlkKdN7r6ZhcA0iX3355+juLH2bOoQHvEVjMo517IOz0H/kaGvLZgzu63A8LeO69bcgjts=
Received: from MW4PR04CA0365.namprd04.prod.outlook.com (2603:10b6:303:81::10)
 by PH8PR12MB6794.namprd12.prod.outlook.com (2603:10b6:510:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 19:00:37 +0000
Received: from CO1PEPF000044F6.namprd21.prod.outlook.com
 (2603:10b6:303:81:cafe::46) by MW4PR04CA0365.outlook.office365.com
 (2603:10b6:303:81::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.16 via Frontend Transport; Fri,
 19 Sep 2025 19:00:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044F6.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.0 via Frontend Transport; Fri, 19 Sep 2025 19:00:37 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 19 Sep
 2025 12:00:35 -0700
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [RFC PATCH v2 1/4] KVM: SEV: Publish supported SEV-SNP policy bits
Date: Fri, 19 Sep 2025 14:00:05 -0500
Message-ID: <f48af9278ab89a27e521930c8ae02adfd2819bcc.1758308408.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F6:EE_|PH8PR12MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d4194b8-9980-44d4-5a23-08ddf7aed1c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uVL8kPcHvXNU3bEJ1J/Id3WYZQkoUZRMSRhpdgfn3k25k30xkqoPBReYucLL?=
 =?us-ascii?Q?orgszyKafaPotyqo6TCQOubupmmca9Jw/+n/nNcFipQmGcugfaWFeCbs+0vY?=
 =?us-ascii?Q?p826k+mL/qXr3tD5kqbZK02oZK0383zbmaqzyIrogXC09RZk3z0Sa2Uv4wEC?=
 =?us-ascii?Q?7yNvTa8DXeItog647FefiiCZC10zbv9xHU0MwsGEaPFmXpSUyZGMvkYwolT5?=
 =?us-ascii?Q?ggarKO8ecmm19gFMbaUSgUDK6lv00OHW0Pi7NUlMHWM6J7gsfHxeW5a7B4S7?=
 =?us-ascii?Q?L/z8yZJmRBNiLfVnl8FvLLHg6+Xbe9IM2v8lK6S47Hq7GHhBq2UYDBSZC0NX?=
 =?us-ascii?Q?Mt4vNK7JuxtYg0VGX1hFYdT9itDazEdCic6lPEsm+V0vmnA6lAr4c4INNWjX?=
 =?us-ascii?Q?jLQ2w3kBW/cROAaaa9y8tKZYYzlL08u7Rac3b7Y8tTFZEncnVkoTfP58BM8l?=
 =?us-ascii?Q?vjO70sOvRZL7FkccvuFtf51Uap9YEAAWXutrLKeBNlK1akwWdb0dPyZH/lxl?=
 =?us-ascii?Q?fzD22d5tDipMkJPWsI/Z0ePimtuXFCcpv/ZUugpqfFSmn4zBGdWUyl7m34tZ?=
 =?us-ascii?Q?6iJt+6KwNDm30YFYPWiobslEYG3je/40owz9JEKkhqC8HareKW0AetTF1UV9?=
 =?us-ascii?Q?l76sjH0FXPKBrETl+l67KxIMdk9+L9sr61urDjbNA2yHSktE8xWPE1zDiGDP?=
 =?us-ascii?Q?d85VA9i2viSUEN3TnZNsp2YLwUws7cLdqxzUA5GkhDH/ceRi3008TKQV8XHy?=
 =?us-ascii?Q?xTn0d30XNPCUc3DcqZN4whYUOdIdu3Cg7DWK7dX3kGng17ovjEuT1pqwMdLj?=
 =?us-ascii?Q?O8sDJTbmXFBJ+3N82JMtMT5jkceyWYIGUF+y6f+gKj+gSOGd9MQqMrF3+Pqy?=
 =?us-ascii?Q?Cqgh9YOwIl55yhC1FIBUKI8PyKdBcx1gOX3OAZxqNuUbyE6Z6k95MHcKDzg/?=
 =?us-ascii?Q?8BGs3dRJUhXJRdm4oDEe2PfsxuKxfLWTobATbWsm3Ah/gRY1ecgXVkiae8Al?=
 =?us-ascii?Q?f/afx/D1lvjPVD4cT15xe1HzalW1aCZOcvlz1OKlpoqJ11C+hiJGUS78NCj+?=
 =?us-ascii?Q?YNBS5dfXJuVcVwapiIkRgFXJOuAU0G4CynSg5cxW02xQx2kTtTDoIWqJHTiW?=
 =?us-ascii?Q?aK3yrg4VqN+vPje55sGsRd6X5eLu3cBgbqvj1mxbSY/ymCbmU2NG1rgU2I/g?=
 =?us-ascii?Q?SfIgz/gCX99qisYOEkohAGstNvWb9Bm2btnC9T0UO9zhQxJGz/NCSClVA6mz?=
 =?us-ascii?Q?UmOwy74qVJCSYK70lFi7ELBCmfzQZs1rhG5Eq0K1JWksX0A3yQUIgegRBJ+x?=
 =?us-ascii?Q?j1af6qAPD8ko8iafIlLtBHz8NGxDcJZ1oyL1Trn4G4bgKGDDQAK2euFQvhEd?=
 =?us-ascii?Q?7BHgAokeU0Oq6EgKWRBpbtIQskLnjjlz09cD/awwQkMlUIuLUGuDOs8LswFg?=
 =?us-ascii?Q?jGG2PElsK5aE9HMaIwrlo+Bo8tWp3YVeN94PwlUzjKFK+105FIuK0A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 19:00:37.1145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d4194b8-9980-44d4-5a23-08ddf7aed1c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F6.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6794

Define the set of policy bits that KVM currently knows as not requiring
any implementation support within KVM. Provide this value to userspace
via the KVM_GET_DEVICE_ATTR ioctl.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/svm/sev.c          | 12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 0f15d683817d..90e9c4551fa6 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -468,6 +468,7 @@ struct kvm_sync_regs {
 /* vendor-specific groups and attributes for system fd */
 #define KVM_X86_GRP_SEV			1
 #  define KVM_X86_SEV_VMSA_FEATURES	0
+#  define KVM_X86_SNP_POLICY_BITS	1
 
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 01345b73f879..65bb2515ffb7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -81,6 +81,8 @@ module_param_named(ciphertext_hiding_asids, nr_ciphertext_hiding_asids, uint, 04
 					 SNP_POLICY_MASK_DEBUG		| \
 					 SNP_POLICY_MASK_SINGLE_SOCKET)
 
+static u64 snp_supported_policy_bits __ro_after_init;
+
 #define INITIAL_VMSA_GPA 0xFFFFFFFFF000
 
 static u8 sev_enc_bit;
@@ -2134,6 +2136,10 @@ int sev_dev_get_attr(u32 group, u64 attr, u64 *val)
 		*val = sev_supported_vmsa_features;
 		return 0;
 
+	case KVM_X86_SNP_POLICY_BITS:
+		*val = snp_supported_policy_bits;
+		return 0;
+
 	default:
 		return -ENXIO;
 	}
@@ -2198,7 +2204,7 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (params.flags)
 		return -EINVAL;
 
-	if (params.policy & ~SNP_POLICY_MASK_VALID)
+	if (params.policy & ~snp_supported_policy_bits)
 		return -EINVAL;
 
 	/* Check for policy bits that must be set */
@@ -3084,8 +3090,10 @@ void __init sev_hardware_setup(void)
 		else if (sev_snp_supported)
 			sev_snp_supported = is_sev_snp_initialized();
 
-		if (sev_snp_supported)
+		if (sev_snp_supported) {
+			snp_supported_policy_bits = SNP_POLICY_MASK_VALID;
 			nr_ciphertext_hiding_asids = init_args.max_snp_asid;
+		}
 
 		/*
 		 * If ciphertext hiding is enabled, the joint SEV-ES/SEV-SNP
-- 
2.46.2


