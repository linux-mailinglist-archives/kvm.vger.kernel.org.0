Return-Path: <kvm+bounces-25207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12E549619BE
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 00:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C022F285361
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A6001D4177;
	Tue, 27 Aug 2024 22:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hl4ehui+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2068.outbound.protection.outlook.com [40.107.212.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D64A3C08A;
	Tue, 27 Aug 2024 22:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724796016; cv=fail; b=uO9CxVe2crLRhLbFNyZnJ35R3kVZmPEtBHscZJwFWrk4syN4jpaUO6al7V3qc8oxessFaJDkLdCb0vtXC3u7Mq2kn7sENvtw2UOEc+967UrCvgjQ4jT77R3os6vAF3AQXn0PM25evjaQZAN5ujSCCrwBZ6RahARDxrwIlfg2s0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724796016; c=relaxed/simple;
	bh=Hfr5fwqMX1k88AfHrWaUUgULW25MOwtdzC7HZ6hvfGM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uYi0hgMMrF6oCU58+5PadhiFuciKoQn85kZ39AdXbxRwddOsJgStbLsh4sWQq1Ltx6oYl62+KhmEGQlslI5raiKiIXzBc05dYrqtKve4giZNBgzvdauyIAPD6TXBh5rKCqxcUvVl8qHmmm4tPQ3okxR+RohVcutqAzvtTLE7a7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hl4ehui+; arc=fail smtp.client-ip=40.107.212.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YuFSS1mUI5RUTtSC/vBvCRbQu6a04IkF3nlasGQ8jKQRLJNS7XchvYt+MbiNf/D38RrsRMq9VHXM8mvsgQGLPCaaBTYykSMNhIstDtceP0WEhN6KSj7XIEpkKpemmZzVsZpgzp4j12Zc+6PViOmO5013SRk2+kRTrhKeh+Ycj+dlmhIncXA0B/mqoKA3ssVWbWYS7isbs889riBNgxMzakUQUGwm4FOFeQ6uXAXeSoTgf55C0s8KH46cY2fvWGbHKAyiIXCpJk+WNwltnKqDkQvL+R6f0aDCrd374WZ2ZMNy7pcg66vaGWzpuQh940vao8tk7LUkPaA+MF5qfAzRvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/dwp1JFmwXNR+Gz2MJjCP5cbccsoRFsz1qirH4ozExo=;
 b=kuT5SJQV/lvfvgHeUwJewOq1SL2zGH9bbclmicDB5UDWsRk0oByCI++ldhH5/0phNfkzr+LKCdHwl1lpGK/4qDzWoscIZK948I4wUlqI/fTO5RRavIFlvXhqekqhviON1LiLXWkdzfW1Di1R/sGAIJv0YUXppYo+gMjVKIT+m9LiXz6WUeaMOThMYi7KMUZJn9U9sDWQM/OkBTAnZzI60fzK46Y+ozB8Ci88lzmVKXFglh0WzQfcBYR67vDV+U9ioync1UVwZrSB/N6e6V4n0FnWydi3A3ctgS7DN3yCIJwDTvCPHnzhFUIDDjq7hqSWHf7p9TicqCrkdTw1QhGO6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/dwp1JFmwXNR+Gz2MJjCP5cbccsoRFsz1qirH4ozExo=;
 b=hl4ehui+eq7mWgt2B0jsD15H9kYWZCaNgfrQExtqlJjKO0WfPbC3XiLShANT2hfZP1Yhiw4K1J09U2t8VbwqDSX0DRbKMUcLiwc7/wmfn591ugfPm5OiBqNV20yAs/Ux1n40QQFT7gY8rj5d27DWbkxKdRO65Hi47VH0pLoGLRo=
Received: from BN9PR03CA0519.namprd03.prod.outlook.com (2603:10b6:408:131::14)
 by PH7PR12MB6834.namprd12.prod.outlook.com (2603:10b6:510:1b4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Tue, 27 Aug
 2024 22:00:04 +0000
Received: from BN3PEPF0000B069.namprd21.prod.outlook.com
 (2603:10b6:408:131:cafe::40) by BN9PR03CA0519.outlook.office365.com
 (2603:10b6:408:131::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25 via Frontend
 Transport; Tue, 27 Aug 2024 22:00:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B069.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7939.2 via Frontend Transport; Tue, 27 Aug 2024 22:00:03 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 27 Aug
 2024 17:00:01 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Joerg Roedel <jroedel@suse.de>, Roy Hopkins
	<roy.hopkins@suse.com>
Subject: [RFC PATCH 2/7] KVM: SEV: Allow for VMPL level specification in AP create
Date: Tue, 27 Aug 2024 16:59:26 -0500
Message-ID: <e9d20a118e42962e29d46a137c7934e5014af709.1724795971.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B069:EE_|PH7PR12MB6834:EE_
X-MS-Office365-Filtering-Correlation-Id: b35ab5b4-507b-4907-5b9a-08dcc6e39b10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fyNdBgZLFT14twbqylcTFr7hnv8N6XZPJ+maCY7yc+TmLCn8uyyX56fFfNd1?=
 =?us-ascii?Q?5wC/af4VLQne1jtnbKvq+d5aew8uuWqPHHJQ99LZFtFozNx3NyFKIvs+xeJx?=
 =?us-ascii?Q?Oa9ncdL0qfy9yoLgALdaFRaV+FU+jAuPqUgIk/HstmWDlQ54rI2mZbDatszN?=
 =?us-ascii?Q?GNujXtssWSEVg7iVvo/jtOEGHNXoQItbpJm20Q/6/O5XQ0y8jpG72aj00RzV?=
 =?us-ascii?Q?0wo49pesrcHgBpDIWNpdqhI4Vam19LktGROyMOk6M3YAXUQiZNvQzaMov76l?=
 =?us-ascii?Q?PIbwaE9c7IEVEOnXJpEpDzT/RuvhFzIm9DqeLyOn9Qb7pqOTbkz+jE9hcwR1?=
 =?us-ascii?Q?NDQHulq73rlqOYVJ/9K7OoLod1pnLgoej3t+JuJaw1UsQOHP2R6k2dBo1EMS?=
 =?us-ascii?Q?BYPr0mg+BAjK1LoK0bmoSNPg1AZZNhyTNV8RsV7vVO4tbhvc+C3a71zGCl0y?=
 =?us-ascii?Q?dMmm/jIKdgtRCpuHF6izypmBjKZuGk+IaO4rXF/hEL0ijNXnkIixlgs1M1zT?=
 =?us-ascii?Q?HFK7PT8Z4rNZvJjdeEsRBievzNvVaWTJp/+oDL1hh4KnbTzCLcHdjZksF/A3?=
 =?us-ascii?Q?L+CWDcHcjPUQ5qMDvhP8b5wD4IuvLY6zypgxeLGmznSWN7aQUuS968IlAJNs?=
 =?us-ascii?Q?P9viUzybOmvK8NZOJK+4rTnnL1i7du8r4/bAqjXpWd/kUd0SGWL2JJgbQu2h?=
 =?us-ascii?Q?Uzvrt2I6UMRdjPZMUDxDBDSwy09GfX1IIJ+mmgVZ7tQDs6q7LmUThzyR3TF1?=
 =?us-ascii?Q?zE2NPV2NWo0egWDzcDpMaXt5wowVGmDx7IprNeysjz4mJ2GwBbMGr7/063qp?=
 =?us-ascii?Q?WkPvgnqGIOV6fuyBJDG/ilNJ8K8ClpuqeS9jzpcQkXaiUgU82UkZOfSDO7Gl?=
 =?us-ascii?Q?vurOsilUHoUBPBE0PGYP5HvDEUzQuj/+dljONmCXXLiKkDZ7qVMYmIut7g70?=
 =?us-ascii?Q?w5JRsCcTYnL8VPY7cS8ZWA4dH0KtNNhbGvFsYzHurlLRYNMMaCujqAsPErCS?=
 =?us-ascii?Q?cMB0FOUaYFQHDHoT6Nrg6b/ztDY7Cu/Xwus/JVUGcLDqUxVTVFd4El+vJGQm?=
 =?us-ascii?Q?m7B61DDuiwherrqRu5AUEv7PaUUOAyMC0OH77C38LvzHjSoyP5b6vhF89cH1?=
 =?us-ascii?Q?YA10qyLMCZeVe977sO72L2bRAme6DALvxU1Vf4VLM7BA+ohaDod7UsLvbZ9Q?=
 =?us-ascii?Q?W6zPnuotfgjN2vduKcb46tSIDQkBieWm+uRAX3DAGZPufU8oA0x0lgL+4zQl?=
 =?us-ascii?Q?od0WEXFE75GOrzFr7G5SDGorrRfN3UNAhukXEX2noMVK6FO/Vs1tLnG2PItJ?=
 =?us-ascii?Q?Li+UFK6sqxomLVlpry1tJ8mYA3XZYE6WKJPDCSC7FYDvaHR4wpTdmfufKF2q?=
 =?us-ascii?Q?zIKyjz9en47+HqxWWJvv5KYALew4JXI6k2lKtq9/ET3fQNf1YF/p8lF0D3PN?=
 =?us-ascii?Q?BMJJ+VJZlD5EnUq/Eb4Dtfhq8HUPitht?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 22:00:03.9934
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b35ab5b4-507b-4907-5b9a-08dcc6e39b10
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B069.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6834

Update AP creation to support ADD/DESTROY of VMSAs at levels other than
VMPL0 in order to run under an SVSM at VMPL1 or lower. To maintain
backwards compatibility, the VMPL is specified in bits 16 to 19 of the
AP Creation request in SW_EXITINFO1 of the GHCB.

In order to track the VMSAs at different levels, create arrays for the
VMSAs, GHCBs, registered GHCBs and others. When switching VMPL levels,
these entries will be used to set the VMSA and GHCB physical addresses
in the VMCB for the VMPL level.

In order ensure that the proper responses are returned in the proper GHCB,
the GHCB must be unmapped at the current level and saved for restoration
later when switching back to that VMPL level.

Additional checks are applied to prevent a non-VMPL0 vCPU from being able
to perform an AP creation request at VMPL0. Additionally, a vCPU cannot
replace its own VMSA.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/svm.h      |   9 ++
 arch/x86/include/uapi/asm/svm.h |   2 +
 arch/x86/kvm/svm/sev.c          | 146 +++++++++++++++++++++++---------
 arch/x86/kvm/svm/svm.c          |   6 +-
 arch/x86/kvm/svm/svm.h          |  45 ++++++++--
 arch/x86/kvm/x86.c              |   9 ++
 6 files changed, 169 insertions(+), 48 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index f0dea3750ca9..26339d94c00f 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -294,6 +294,15 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
 	 SVM_SEV_FEAT_ALTERNATE_INJECTION)
 
+enum {
+	SVM_SEV_VMPL0 = 0,
+	SVM_SEV_VMPL1,
+	SVM_SEV_VMPL2,
+	SVM_SEV_VMPL3,
+
+	SVM_SEV_VMPL_MAX
+};
+
 struct vmcb_seg {
 	u16 selector;
 	u16 attrib;
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index f8fa3c4c0322..4a963dd12bb4 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -115,6 +115,8 @@
 #define SVM_VMGEXIT_AP_CREATE_ON_INIT		0
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
+#define SVM_VMGEXIT_AP_VMPL_MASK		GENMASK(19, 16)
+#define SVM_VMGEXIT_AP_VMPL_SHIFT		16
 #define SVM_VMGEXIT_GET_APIC_IDS		0x80000017
 #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 199bdc7c7db1..c22b6f51ec81 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -807,7 +807,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
-	struct sev_es_save_area *save = svm->sev_es.vmsa;
+	struct sev_es_save_area *save = vmpl_vmsa(svm, SVM_SEV_VMPL0);
 	struct xregs_state *xsave;
 	const u8 *s;
 	u8 *d;
@@ -920,11 +920,11 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	 * the VMSA memory content (i.e it will write the same memory region
 	 * with the guest's key), so invalidate it first.
 	 */
-	clflush_cache_range(svm->sev_es.vmsa, PAGE_SIZE);
+	clflush_cache_range(vmpl_vmsa(svm, SVM_SEV_VMPL0), PAGE_SIZE);
 
 	vmsa.reserved = 0;
 	vmsa.handle = to_kvm_sev_info(kvm)->handle;
-	vmsa.address = __sme_pa(svm->sev_es.vmsa);
+	vmsa.address = __sme_pa(vmpl_vmsa(svm, SVM_SEV_VMPL0));
 	vmsa.len = PAGE_SIZE;
 	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_UPDATE_VMSA, &vmsa, error);
 	if (ret)
@@ -2452,7 +2452,7 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		struct vcpu_svm *svm = to_svm(vcpu);
-		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+		u64 pfn = __pa(vmpl_vmsa(svm, SVM_SEV_VMPL0)) >> PAGE_SHIFT;
 
 		ret = sev_es_sync_vmsa(svm);
 		if (ret)
@@ -2464,7 +2464,7 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
 			return ret;
 
 		/* Issue the SNP command to encrypt the VMSA */
-		data.address = __sme_pa(svm->sev_es.vmsa);
+		data.address = __sme_pa(vmpl_vmsa(svm, SVM_SEV_VMPL0));
 		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
 				      &data, &argp->error);
 		if (ret) {
@@ -3178,16 +3178,16 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 	 * releasing it back to the system.
 	 */
 	if (sev_snp_guest(vcpu->kvm)) {
-		u64 pfn = __pa(svm->sev_es.vmsa) >> PAGE_SHIFT;
+		u64 pfn = __pa(vmpl_vmsa(svm, SVM_SEV_VMPL0)) >> PAGE_SHIFT;
 
 		if (kvm_rmp_make_shared(vcpu->kvm, pfn, PG_LEVEL_4K))
 			goto skip_vmsa_free;
 	}
 
 	if (vcpu->arch.guest_state_protected)
-		sev_flush_encrypted_page(vcpu, svm->sev_es.vmsa);
+		sev_flush_encrypted_page(vcpu, vmpl_vmsa(svm, SVM_SEV_VMPL0));
 
-	__free_page(virt_to_page(svm->sev_es.vmsa));
+	__free_page(virt_to_page(vmpl_vmsa(svm, SVM_SEV_VMPL0)));
 
 skip_vmsa_free:
 	if (svm->sev_es.ghcb_sa_free)
@@ -3385,13 +3385,19 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!kvm_ghcb_sw_scratch_is_valid(svm))
 			goto vmgexit_err;
 		break;
-	case SVM_VMGEXIT_AP_CREATION:
+	case SVM_VMGEXIT_AP_CREATION: {
+		unsigned int request;
+
 		if (!sev_snp_guest(vcpu->kvm))
 			goto vmgexit_err;
-		if (lower_32_bits(control->exit_info_1) != SVM_VMGEXIT_AP_DESTROY)
+
+		request = lower_32_bits(control->exit_info_1);
+		request &= ~SVM_VMGEXIT_AP_VMPL_MASK;
+		if (request != SVM_VMGEXIT_AP_DESTROY)
 			if (!kvm_ghcb_rax_is_valid(svm))
 				goto vmgexit_err;
 		break;
+	}
 	case SVM_VMGEXIT_GET_APIC_IDS:
 		if (!kvm_ghcb_rax_is_valid(svm))
 			goto vmgexit_err;
@@ -3850,9 +3856,10 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 
 	/* Clear use of the VMSA */
 	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
+	tgt_vmpl_vmsa_hpa(svm) = INVALID_PAGE;
 
-	if (VALID_PAGE(svm->sev_es.snp_vmsa_gpa)) {
-		gfn_t gfn = gpa_to_gfn(svm->sev_es.snp_vmsa_gpa);
+	if (VALID_PAGE(tgt_vmpl_vmsa_gpa(svm))) {
+		gfn_t gfn = gpa_to_gfn(tgt_vmpl_vmsa_gpa(svm));
 		struct kvm_memory_slot *slot;
 		kvm_pfn_t pfn;
 
@@ -3870,32 +3877,54 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 		/*
 		 * From this point forward, the VMSA will always be a
 		 * guest-mapped page rather than the initial one allocated
-		 * by KVM in svm->sev_es.vmsa. In theory, svm->sev_es.vmsa
-		 * could be free'd and cleaned up here, but that involves
-		 * cleanups like wbinvd_on_all_cpus() which would ideally
-		 * be handled during teardown rather than guest boot.
-		 * Deferring that also allows the existing logic for SEV-ES
-		 * VMSAs to be re-used with minimal SNP-specific changes.
+		 * by KVM in svm->sev_es.vmsa_info[vmpl].vmsa. In theory,
+		 * svm->sev_es.vmsa_info[vmpl].vmsa could be free'd and cleaned
+		 * up here, but that involves cleanups like wbinvd_on_all_cpus()
+		 * which would ideally be handled during teardown rather than
+		 * guest boot. Deferring that also allows the existing logic for
+		 * SEV-ES VMSAs to be re-used with minimal SNP-specific changes.
 		 */
-		svm->sev_es.snp_has_guest_vmsa = true;
+		tgt_vmpl_has_guest_vmsa(svm) = true;
 
 		/* Use the new VMSA */
 		svm->vmcb->control.vmsa_pa = pfn_to_hpa(pfn);
+		tgt_vmpl_vmsa_hpa(svm) = pfn_to_hpa(pfn);
+
+		/*
+		 * Since the vCPU may not have gone through the LAUNCH_UPDATE_VMSA path,
+		 * be sure to mark the guest state as protected and enable LBR virtualization.
+		 */
+		vcpu->arch.guest_state_protected = true;
+		svm_enable_lbrv(vcpu);
 
 		/* Mark the vCPU as runnable */
 		vcpu->arch.pv.pv_unhalted = false;
 		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 
-		svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
+		tgt_vmpl_vmsa_gpa(svm) = INVALID_PAGE;
 
 		/*
 		 * gmem pages aren't currently migratable, but if this ever
 		 * changes then care should be taken to ensure
-		 * svm->sev_es.vmsa is pinned through some other means.
+		 * svm->sev_es.vmsa_info[vmpl].vmsa is pinned through some other
+		 * means.
 		 */
 		kvm_release_pfn_clean(pfn);
 	}
 
+	if (cur_vmpl(svm) != tgt_vmpl(svm)) {
+		/* Unmap the current GHCB */
+		sev_es_unmap_ghcb(svm);
+
+		/* Save the GHCB GPA of the current VMPL */
+		svm->sev_es.ghcb_gpa[cur_vmpl(svm)] = svm->vmcb->control.ghcb_gpa;
+
+		/* Set the GHCB_GPA for the target VMPL and make it the current VMPL */
+		svm->vmcb->control.ghcb_gpa = svm->sev_es.ghcb_gpa[tgt_vmpl(svm)];
+
+		cur_vmpl(svm) = tgt_vmpl(svm);
+	}
+
 	/*
 	 * When replacing the VMSA during SEV-SNP AP creation,
 	 * mark the VMCB dirty so that full state is always reloaded.
@@ -3918,10 +3947,10 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 
 	mutex_lock(&svm->sev_es.snp_vmsa_mutex);
 
-	if (!svm->sev_es.snp_ap_waiting_for_reset)
+	if (!tgt_vmpl_ap_waiting_for_reset(svm))
 		goto unlock;
 
-	svm->sev_es.snp_ap_waiting_for_reset = false;
+	tgt_vmpl_ap_waiting_for_reset(svm) = false;
 
 	ret = __sev_snp_update_protected_guest_state(vcpu);
 	if (ret)
@@ -3939,12 +3968,24 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	struct vcpu_svm *target_svm;
 	unsigned int request;
 	unsigned int apic_id;
+	unsigned int vmpl;
 	bool kick;
 	int ret;
 
 	request = lower_32_bits(svm->vmcb->control.exit_info_1);
 	apic_id = upper_32_bits(svm->vmcb->control.exit_info_1);
 
+	vmpl = (request & SVM_VMGEXIT_AP_VMPL_MASK) >> SVM_VMGEXIT_AP_VMPL_SHIFT;
+	request &= ~SVM_VMGEXIT_AP_VMPL_MASK;
+
+	/* Validate the requested VMPL level */
+	if (vmpl >= SVM_SEV_VMPL_MAX) {
+		vcpu_unimpl(vcpu, "vmgexit: invalid VMPL level [%u] from guest\n",
+			    vmpl);
+		return -EINVAL;
+	}
+	vmpl = array_index_nospec(vmpl, SVM_SEV_VMPL_MAX);
+
 	/* Validate the APIC ID */
 	target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, apic_id);
 	if (!target_vcpu) {
@@ -3966,13 +4007,22 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 
 	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
 
-	target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
-	target_svm->sev_es.snp_ap_waiting_for_reset = true;
+	vmpl_vmsa_gpa(target_svm, vmpl) = INVALID_PAGE;
+	vmpl_ap_waiting_for_reset(target_svm, vmpl) = true;
 
-	/* Interrupt injection mode shouldn't change for AP creation */
+	/* VMPL0 can only be replaced by another vCPU running VMPL0 */
+	if (vmpl == SVM_SEV_VMPL0 &&
+	    (vcpu == target_vcpu ||
+	     vmpl_vmsa_hpa(svm, SVM_SEV_VMPL0) != svm->vmcb->control.vmsa_pa)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Perform common AP creation validation */
 	if (request < SVM_VMGEXIT_AP_DESTROY) {
 		u64 sev_features;
 
+		/* Interrupt injection mode shouldn't change for AP creation */
 		sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
 		sev_features ^= sev->vmsa_features;
 
@@ -3982,13 +4032,8 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 			ret = -EINVAL;
 			goto out;
 		}
-	}
 
-	switch (request) {
-	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
-		kick = false;
-		fallthrough;
-	case SVM_VMGEXIT_AP_CREATE:
+		/* Validate the input VMSA page */
 		if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
 			vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\n",
 				    svm->vmcb->control.exit_info_2);
@@ -4010,8 +4055,17 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 			ret = -EINVAL;
 			goto out;
 		}
+	}
 
-		target_svm->sev_es.snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
+	switch (request) {
+	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
+		/* Delay switching to the new VMSA */
+		kick = false;
+		fallthrough;
+	case SVM_VMGEXIT_AP_CREATE:
+		/* Switch to new VMSA on the next VMRUN */
+		target_svm->sev_es.snp_target_vmpl = vmpl;
+		vmpl_vmsa_gpa(target_svm, vmpl) = svm->vmcb->control.exit_info_2 & PAGE_MASK;
 		break;
 	case SVM_VMGEXIT_AP_DESTROY:
 		break;
@@ -4298,7 +4352,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
 					GHCB_MSR_GPA_VALUE_POS);
 
-		svm->sev_es.ghcb_registered_gpa = gfn_to_gpa(gfn);
+		svm->sev_es.ghcb_registered_gpa[cur_vmpl(svm)] = gfn_to_gpa(gfn);
 
 		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_VALUE_MASK,
 				  GHCB_MSR_GPA_VALUE_POS);
@@ -4579,8 +4633,8 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	 * the VMSA will be NULL if this vCPU is the destination for intrahost
 	 * migration, and will be copied later.
 	 */
-	if (svm->sev_es.vmsa && !svm->sev_es.snp_has_guest_vmsa)
-		svm->vmcb->control.vmsa_pa = __pa(svm->sev_es.vmsa);
+	if (cur_vmpl_vmsa(svm) && !cur_vmpl_has_guest_vmsa(svm))
+		svm->vmcb->control.vmsa_pa = __pa(cur_vmpl_vmsa(svm));
 
 	/* Can't intercept CR register access, HV can't modify CR registers */
 	svm_clr_intercept(svm, INTERCEPT_CR0_READ);
@@ -4643,16 +4697,30 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+	unsigned int i;
+	u64 sev_info;
 
 	/*
 	 * Set the GHCB MSR value as per the GHCB specification when emulating
 	 * vCPU RESET for an SEV-ES guest.
 	 */
-	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO((__u64)sev->ghcb_version,
-					    GHCB_VERSION_MIN,
-					    sev_enc_bit));
+	sev_info = GHCB_MSR_SEV_INFO((__u64)sev->ghcb_version, GHCB_VERSION_MIN,
+				     sev_enc_bit);
+	set_ghcb_msr(svm, sev_info);
+	svm->sev_es.ghcb_gpa[SVM_SEV_VMPL0] = sev_info;
 
 	mutex_init(&svm->sev_es.snp_vmsa_mutex);
+
+	/*
+	 * When not running under SNP, the "current VMPL" tracking for a guest
+	 * is always 0 and the base tracking of GPAs and SPAs will be as before
+	 * multiple VMPL support. However, under SNP, multiple VMPL levels can
+	 * be run, so initialize these values appropriately.
+	 */
+	for (i = 1; i < SVM_SEV_VMPL_MAX; i++) {
+		svm->sev_es.vmsa_info[i].hpa = INVALID_PAGE;
+		svm->sev_es.ghcb_gpa[i] = sev_info;
+	}
 }
 
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d6f252555ab3..ca4bc53fb14a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1463,8 +1463,10 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
-	if (vmsa_page)
-		svm->sev_es.vmsa = page_address(vmsa_page);
+	if (vmsa_page) {
+		vmpl_vmsa(svm, SVM_SEV_VMPL0) = page_address(vmsa_page);
+		vmpl_vmsa_hpa(svm, SVM_SEV_VMPL0) = __pa(page_address(vmsa_page));
+	}
 
 	svm->guest_state_loaded = false;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 76107c7d0595..45a37d16b6f7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -198,9 +198,39 @@ struct svm_nested_state {
 	bool force_msr_bitmap_recalc;
 };
 
-struct vcpu_sev_es_state {
-	/* SEV-ES support */
+#define vmpl_vmsa(s, v)				((s)->sev_es.vmsa_info[(v)].vmsa)
+#define vmpl_vmsa_gpa(s, v)			((s)->sev_es.vmsa_info[(v)].gpa)
+#define vmpl_vmsa_hpa(s, v)			((s)->sev_es.vmsa_info[(v)].hpa)
+#define vmpl_ap_waiting_for_reset(s, v)		((s)->sev_es.vmsa_info[(v)].ap_waiting_for_reset)
+#define vmpl_has_guest_vmsa(s, v)		((s)->sev_es.vmsa_info[(v)].has_guest_vmsa)
+
+#define cur_vmpl(s)				((s)->sev_es.snp_current_vmpl)
+#define cur_vmpl_vmsa(s)			vmpl_vmsa((s), cur_vmpl(s))
+#define cur_vmpl_vmsa_gpa(s)			vmpl_vmsa_gpa((s), cur_vmpl(s))
+#define cur_vmpl_vmsa_hpa(s)			vmpl_vmsa_hpa((s), cur_vmpl(s))
+#define cur_vmpl_ap_waiting_for_reset(s)	vmpl_ap_waiting_for_reset((s), cur_vmpl(s))
+#define cur_vmpl_has_guest_vmsa(s)		vmpl_has_guest_vmsa((s), cur_vmpl(s))
+
+#define tgt_vmpl(s)				((s)->sev_es.snp_target_vmpl)
+#define tgt_vmpl_vmsa(s)			vmpl_vmsa((s), tgt_vmpl(s))
+#define tgt_vmpl_vmsa_gpa(s)			vmpl_vmsa_gpa((s), tgt_vmpl(s))
+#define tgt_vmpl_vmsa_hpa(s)			vmpl_vmsa_hpa((s), tgt_vmpl(s))
+#define tgt_vmpl_ap_waiting_for_reset(s)	vmpl_ap_waiting_for_reset((s), tgt_vmpl(s))
+#define tgt_vmpl_has_guest_vmsa(s)		vmpl_has_guest_vmsa((s), tgt_vmpl(s))
+
+struct sev_vmsa_info {
+	/* SEV-ES and SEV-SNP */
 	struct sev_es_save_area *vmsa;
+
+	/* SEV-SNP for multi VMPL support */
+	gpa_t gpa;
+	hpa_t hpa;
+	bool  ap_waiting_for_reset;
+	bool  has_guest_vmsa;
+};
+
+struct vcpu_sev_es_state {
+	/* SEV-ES/SEV-SNP support */
 	struct ghcb *ghcb;
 	u8 valid_bitmap[16];
 	struct kvm_host_map ghcb_map;
@@ -219,12 +249,13 @@ struct vcpu_sev_es_state {
 	u16 psc_inflight;
 	bool psc_2m;
 
-	u64 ghcb_registered_gpa;
+	gpa_t ghcb_gpa[SVM_SEV_VMPL_MAX];
+	u64 ghcb_registered_gpa[SVM_SEV_VMPL_MAX];
+	struct sev_vmsa_info vmsa_info[SVM_SEV_VMPL_MAX];
 
 	struct mutex snp_vmsa_mutex; /* Used to handle concurrent updates of VMSA. */
-	gpa_t snp_vmsa_gpa;
-	bool snp_ap_waiting_for_reset;
-	bool snp_has_guest_vmsa;
+	unsigned int snp_current_vmpl;
+	unsigned int snp_target_vmpl;
 };
 
 struct vcpu_svm {
@@ -380,7 +411,7 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
 
 static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
 {
-	return svm->sev_es.ghcb_registered_gpa == val;
+	return svm->sev_es.ghcb_registered_gpa[cur_vmpl(svm)] == val;
 }
 
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ef3d3511e4af..3efc3a89499c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11469,6 +11469,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		kvm_vcpu_block(vcpu);
 		kvm_vcpu_srcu_read_lock(vcpu);
 
+		/*
+		 * It is possible that the vCPU has never run before. If the
+		 * request is to update the protected guest state (AP Create),
+		 * then ensure that the vCPU can now run.
+		 */
+		if (kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu) &&
+		    vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)
+			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+
 		if (kvm_apic_accept_events(vcpu) < 0) {
 			r = 0;
 			goto out;
-- 
2.43.2


