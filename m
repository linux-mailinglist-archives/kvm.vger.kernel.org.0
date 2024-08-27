Return-Path: <kvm+bounces-25208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64FD49619C0
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 00:01:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A9EB2859D3
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA4751D47BB;
	Tue, 27 Aug 2024 22:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Mz+JiJRT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2A717A5BC;
	Tue, 27 Aug 2024 22:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724796023; cv=fail; b=qyYfSXqva0372e6J/gQJX2Fr+CiFAt3/5Sd4etz5k8AS7v9UtC55G3rzleOx3Xwlq/ZHtmPG7bmBsVXHQrlw/y6X6AZQzRjqz8VDThi3xCptvR1ChsoSSC3rx/iElD1+oqipr0X7WGInLxnLR5bpHLm5Arc7kQx8OKbQ5v4vzgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724796023; c=relaxed/simple;
	bh=T1kGWvbN0XQBhRi/13lHiklHHKcGpPpdrCg/H2aeMRY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oCVI1G9ghILQvGeKeW4zhXS3INRd6dmsjIMG0dac6xSHu0Ev5kSI4J6h/aObeOldXmSdst96/EyN9/njscnDL3JwFEeJSyEt3UiWM82Qt8DaYBQdRZRTwDpFP+eJ1AZZ5YoNKifzYP6cu7ieH+esw6uwvY1av75/5Vlwj/tJsUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Mz+JiJRT; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OQo5nLZhQnkQC1nWGSXIamYtRy6qBmysNjQGRAPleALo62ze8EXPTASKWJ2qeKRLyheoJaOMTtziA+IhYsB6RUzu8CmBq2fE/S2UUQSaHIFJm2DIGN/hMJdm4aeHtPlnyeuUsc9XiiEcvHAXWh19W7b+QrVrDJ59PYwCGV6AEDwLv15b+ya77EqesWWSVZuMO54C6jgaq4FR6gmSJTLIQq18i3ZUj4uhtvc5oSBLk8pIgf4uIUdF/YrF4ARyL6Jk5+/RB6CTtFwia8mWnyG/K2S3oCUTLcmnKFUciuzM+4686k8U/xACyDSi1uyCHKyCJ5CrS7YYNMNmhAS8cNR82Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BPVAfw+rt4VzsF2tjyc7JjXx6ScgRpCQ+PG7vAKtPnA=;
 b=Gr0C/4WAHtSs7vcBMiziLTvp8vOk0z91Dz7lVX5vzbVHyNdkdq3M5mBz5xyBmiLwPmD2zcnWkkvhVEEeD4sGJjQ8YWvmIGbcz5uiuufNrCRmr8+6qKu+OSQDrxYwi+7Z2rGtCq0Bm40Cm//EEsyU9qr+P0xrLXcRDD13YYjYFEGUMEhB+cJh6TKv2GGH1YA5bRG2us0IkaWl8/+3KzWwEoSqPjpRs34XOh5rCUQv4+8VByjdWJoq1zk8sdC4gVVhrDEMVCIPty/VY+yMOlAe/J6H6IDOwJmdk0/j6FZkC1k0a0Q0CmfxNLjzGfzsynOBosGs7SwTeaZsPhcDpFByEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPVAfw+rt4VzsF2tjyc7JjXx6ScgRpCQ+PG7vAKtPnA=;
 b=Mz+JiJRTUsUf66Rq/e+WZA3Ri8H2KQutHfducCXnSiNUAHrpnGPQWqsoCGFhSDJdB+8KS/3jS1oWdxs9LJEKx+Mdn5dTnDe9RkPML6L2FtXBqwksV2WyrUl4HZlsbvVvMNxBpLwvKaESmfjB1uftgLSkNIAMaqppBmbiB8K+H8k=
Received: from BN9PR03CA0519.namprd03.prod.outlook.com (2603:10b6:408:131::14)
 by SJ1PR12MB6243.namprd12.prod.outlook.com (2603:10b6:a03:456::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Tue, 27 Aug
 2024 22:00:17 +0000
Received: from BN3PEPF0000B069.namprd21.prod.outlook.com
 (2603:10b6:408:131:cafe::47) by BN9PR03CA0519.outlook.office365.com
 (2603:10b6:408:131::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25 via Frontend
 Transport; Tue, 27 Aug 2024 22:00:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B069.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7939.2 via Frontend Transport; Tue, 27 Aug 2024 22:00:17 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 27 Aug
 2024 17:00:15 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Joerg Roedel <jroedel@suse.de>, Roy Hopkins
	<roy.hopkins@suse.com>, Carlos Bilbao <carlos.bilbao@amd.com>
Subject: [RFC PATCH 4/7] KVM: SVM: Maintain per-VMPL SEV features in kvm_sev_info
Date: Tue, 27 Aug 2024 16:59:28 -0500
Message-ID: <95d863d50c0984058b37681271a2034e65edcb89.1724795971.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1724795970.git.thomas.lendacky@amd.com>
References: <cover.1724795970.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B069:EE_|SJ1PR12MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: 2becf6f7-1480-428a-bca2-08dcc6e3a2f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FfJ7XBMB03ejayw2zcw3BYoItUkX1lhUbqQB7KY5aD5MwKbpHBwKFIcmRjLt?=
 =?us-ascii?Q?DOkUrDPxSmh0YHqRm7bIY7MqCxV+Bbyfvvwbc4qjcRVKTEdG14r06Omqgmsb?=
 =?us-ascii?Q?PbjCDx9LA+MlN/CcxPKnIMI4uu4Od77iXEd3G4zIjTxt4Yzyfy3nVoVHrfmP?=
 =?us-ascii?Q?JVKhx0U27hdTeeTWZAVIMMIV+HkstC/XLIEnok7+6wD0aQ3+yYmJ65XBK3Bz?=
 =?us-ascii?Q?L/5I1nFpAF0quGh7qch7209snhDzTv1tZ7rgN26umH5IbhK64dm6nE/B4p7C?=
 =?us-ascii?Q?eop/FAuexFeST8oSai+En2VJ2Sp8kGHpNnvFHZ7HECj4py61z2t0dQBAFXjp?=
 =?us-ascii?Q?m1xYBhbrQq5NKtcuaLAdTmGaEuq6z41O5QuOPdY1p1mH0f2nl+T5qGvmC/tA?=
 =?us-ascii?Q?YoIfo/aek36tC+nDmWEvCgIkhUhB6IMdtc5o2pTJOdiW2YPt2TfbzWVpAU1T?=
 =?us-ascii?Q?XlT9h2RGV+CsPA5QGRTIJNPR6sIHvdnMXhqNEPjc6XXYot9BR/mWJqIi9xnA?=
 =?us-ascii?Q?D2DWw7Wb2Zu4ag1W3e+H0Vyv7KVUaHr6QMqk4H4q5gMDFhTtNKj4SbXL/xeN?=
 =?us-ascii?Q?qmONeMzLzH58JZlIMyDZXOcT3RaiLMxEz45cTsMrk7tV1yjSgCyowOd8qph1?=
 =?us-ascii?Q?ft7DCb+e/dLaiSmAKdNLrUs6AJ/MGwD2sopa3U+tOPJBYuQnzDsm5wgIJXoC?=
 =?us-ascii?Q?WTJVSi6piKnpfFAJd5Omj/bGiumMwsplXEqhyayfXCREbHurlmn4kqyfo+3M?=
 =?us-ascii?Q?3rtJdFvAf9LoTad6RbHtmV5uOSe9taq+QBbwbDPuN3ZUOF6C/PH58M1PSrF/?=
 =?us-ascii?Q?g3A9DrtdhzyR7itj+XjLHze3Rhl4lSAkFcnjzxvLFCj3KGtSWP5czRk3FfUy?=
 =?us-ascii?Q?fmRSWN4KPu1DvKoYMZXrm42e7X+o9Zj5fdOTi9KP2fhsV9kFaeY15Vc8eFdE?=
 =?us-ascii?Q?oxV1flgT8M6MU3mDmpYk+o/+GSQKCr4OIgF1wzp537PCc8DR3xeVoYnNkdYb?=
 =?us-ascii?Q?WA5e6jJjI7FkQY2Awz2vTU89wwqbIYe1qYJXVLzDGZBy0d9RJ2OIsHdfFeFc?=
 =?us-ascii?Q?gxzKpZEZvu3kdO47OfFu/EY8vz4IZrfXTngVebTqQ5p4U+4utfFGABAz5J18?=
 =?us-ascii?Q?s6JPoBmBWoXRfewkn8Fn+wiGn38o2rAoy+fiNPBOJRtyw6nK+Nq3QDyLjOru?=
 =?us-ascii?Q?3CfGo0t/v7gDpKS+bISg9PteWyD0uG+OkA1h33/o/Q+mioeokdMpY/9UbwiC?=
 =?us-ascii?Q?p6KEOQwU16bylGOFJmVWWGg283FqPxAhIHpQ/13186m51IELUIbT0ATwPrmP?=
 =?us-ascii?Q?0fUduflAfPwD4o48b5IJlwNWrt4B2bnpHINcamvhzEwi9k43xqE7RnVN43LW?=
 =?us-ascii?Q?6SsMfQQQIyjimddcKTvNxfHPMGUSd/x0/Kgo5h1wYKkG0W5PZiAvl3VJfVtQ?=
 =?us-ascii?Q?NH2mpASUvCd8NJmYsBiS0rMm9LjFBp22?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 22:00:17.2901
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2becf6f7-1480-428a-bca2-08dcc6e3a2f3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B069.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6243

From: Carlos Bilbao <carlos.bilbao@amd.com>

Make struct kvm_sev_info maintain separate SEV features per VMPL, allowing
distinct SEV features depending on VMs privilege level.

Signed-off-by: Carlos Bilbao <carlos.bilbao@amd.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 22 +++++++++++++++-------
 arch/x86/kvm/svm/svm.h |  4 ++--
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e0f5122061e6..c6c9306c86ef 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -144,7 +144,7 @@ static bool sev_vcpu_has_debug_swap(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
 
-	return sev->vmsa_features & SVM_SEV_FEAT_DEBUG_SWAP;
+	return sev->vmsa_features[cur_vmpl(svm)] & SVM_SEV_FEAT_DEBUG_SWAP;
 }
 
 /* Must be called with the sev_bitmap_lock held */
@@ -428,7 +428,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 
 	sev->active = true;
 	sev->es_active = es_active;
-	sev->vmsa_features = data->vmsa_features;
+	sev->vmsa_features[SVM_SEV_VMPL0] = data->vmsa_features;
 	sev->ghcb_version = data->ghcb_version;
 
 	/*
@@ -440,7 +440,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 		sev->ghcb_version = GHCB_VERSION_DEFAULT;
 
 	if (vm_type == KVM_X86_SNP_VM)
-		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
+		sev->vmsa_features[SVM_SEV_VMPL0] |= SVM_SEV_FEAT_SNP_ACTIVE;
 
 	ret = sev_asid_new(sev);
 	if (ret)
@@ -468,7 +468,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	sev_asid_free(sev);
 	sev->asid = 0;
 e_no_asid:
-	sev->vmsa_features = 0;
+	sev->vmsa_features[SVM_SEV_VMPL0] = 0;
 	sev->es_active = false;
 	sev->active = false;
 	return ret;
@@ -852,7 +852,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
-	save->sev_features = sev->vmsa_features;
+	save->sev_features = sev->vmsa_features[SVM_SEV_VMPL0];
 
 	/*
 	 * Skip FPU and AVX setup with KVM_SEV_ES_INIT to avoid
@@ -1985,7 +1985,7 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 	dst->pages_locked = src->pages_locked;
 	dst->enc_context_owner = src->enc_context_owner;
 	dst->es_active = src->es_active;
-	dst->vmsa_features = src->vmsa_features;
+	memcpy(dst->vmsa_features, src->vmsa_features, sizeof(dst->vmsa_features));
 
 	src->asid = 0;
 	src->active = false;
@@ -4034,8 +4034,16 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 
 		/* Interrupt injection mode shouldn't change for AP creation */
 		sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
-		sev_features ^= sev->vmsa_features;
 
+		/*
+		 * The SNPActive feature must at least be set. If the SEV
+		 * features of this AP are zero, this is the first vCPU created at
+		 * this VMPL.
+		 */
+		if (!sev->vmsa_features[vmpl])
+			sev->vmsa_features[vmpl] = sev_features | SVM_SEV_FEAT_SNP_ACTIVE;
+
+		sev_features ^= sev->vmsa_features[vmpl];
 		if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
 			vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#lx] from guest\n",
 				    vcpu->arch.regs[VCPU_REGS_RAX]);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d1ef349556f7..55f1f6ffb871 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -87,7 +87,7 @@ struct kvm_sev_info {
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
-	u64 vmsa_features;
+	u64 vmsa_features[SVM_SEV_VMPL_MAX];
 	u16 ghcb_version;	/* Highest guest GHCB protocol version allowed */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct list_head mirror_vms; /* List of VMs mirroring */
@@ -416,7 +416,7 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
 #ifdef CONFIG_KVM_AMD_SEV
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 
-	return (sev->vmsa_features & SVM_SEV_FEAT_SNP_ACTIVE) &&
+	return (sev->vmsa_features[SVM_SEV_VMPL0] & SVM_SEV_FEAT_SNP_ACTIVE) &&
 	       !WARN_ON_ONCE(!sev_es_guest(kvm));
 #else
 	return false;
-- 
2.43.2


