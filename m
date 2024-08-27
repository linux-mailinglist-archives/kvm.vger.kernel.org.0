Return-Path: <kvm+bounces-25206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A67349619B3
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 00:00:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5C051C20CF9
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6186019754D;
	Tue, 27 Aug 2024 22:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IOYvXtiU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2061.outbound.protection.outlook.com [40.107.212.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE8117A5BC;
	Tue, 27 Aug 2024 22:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724796015; cv=fail; b=g+iid6t0sE39/Nz8EZTr7TNGEYVmEPV0makPdijTJJPc0YMRJAjiavvPk9IgElJcuA0DwCdSGIA6NHeqxe4vXn2ASRhnRIF+Zl0KXAoqOEg5Vul5X8Y8rjktlUHxuLByiNiHP/fxrRW49H54M3hm/5H9bqwQ8yQWRrchho2cdZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724796015; c=relaxed/simple;
	bh=cXYGpBeIROCJzMmei+ycA/8cIOOkci/o4/A85ptRn+4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FcXoQ49oH6YqLE+KY3kxZh+Xc9pzQJOoNngoHWj/Gzoe64RW7Y8fQ+Et9XyZ7LeBQfaiYlqUghOiilUlxVZkSuOockya1+YH9RSYcGJCz+dDMdW50UxJV3BrmgKxloYdjwlLeJsZkl5MQOybnz213wSusDp/gj39U07mj/IvJ60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IOYvXtiU; arc=fail smtp.client-ip=40.107.212.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=foKs5mFRUjdffLYZSFnJwyhl+Frlyppjatq2Od8bzZv3J9lk4I+OjuqsbW3t6gEF60hbea+hBpGjm7hwjGz9MspOsZtVW4kcKy4d+l2SabcaIWhhhxa76TnTZvvw2l/+L2WieABhm9LRw4RJl/M7i0iMcB5lm7kSffTq5K+2Mw6nhcemQktKhbpOv313yE1d3X8uiSw1rbkPstTA7dxDw3SVwXGt5Q+uL7+FjKhKhCQj6qEZuuJshH+yAtTYbbfV3hCPjoAxb2xdbLkZZ9RY3angW/1/DlmV/YFFALGqXQMR9qO63KTdCz/ot913iuQs6Vuo+7KWVEuZWAk+Bqw8Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K2BHUJ5ycezIfyaBcj+ITPyrm5LAgqwX87HLn8HCgbA=;
 b=a+YOQrrWaV13eR3krCzsOAIljfenqnhyXKhltcw/hVdzS1rER9CBwFzKUYRT8W57qOByg0PWmAsOjry0U09VWleyeEhix3gGg477zNoxynbsHPHAZTaEpsTG9+QwdTDMbU+wKdCK6hasfdnYHbwNzB2MxChaNKSeHG4HR5WZX6CWyvg7hPxYMw6g1jKOMbI5VG3U4qiRc3Jmlw9OwIDJjlOTZBpd5/oQxEDqQg7tArOEOv0o2e87uXMXAKgYmEBH2gswFurw5S/LU4Ntg0qvx8HHJf3Nz88zApTaYr9GiqLGjJ0xGgJ6Zw7gtaffbfaUnpPlCyR5PkW9WW/0jlBPaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2BHUJ5ycezIfyaBcj+ITPyrm5LAgqwX87HLn8HCgbA=;
 b=IOYvXtiUl9IKkLwOf3JC1pjoXNMo2AFdxT7mJB88O7kIzm20B5tK+1NHK3Hk4qaCySuZKhRuUyCUGdHNfT87kMFcKHf0P04VhSZ3CMOl+rb7pvzre37V97/G6Mmn5jum+z381qG+yeyWki1P30+0B2qKFTsUTCGqFsj78t46I4c=
Received: from BN9PR03CA0567.namprd03.prod.outlook.com (2603:10b6:408:138::32)
 by IA1PR12MB8408.namprd12.prod.outlook.com (2603:10b6:208:3db::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Tue, 27 Aug
 2024 22:00:10 +0000
Received: from BN3PEPF0000B06A.namprd21.prod.outlook.com
 (2603:10b6:408:138:cafe::94) by BN9PR03CA0567.outlook.office365.com
 (2603:10b6:408:138::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25 via Frontend
 Transport; Tue, 27 Aug 2024 22:00:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06A.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7939.2 via Frontend Transport; Tue, 27 Aug 2024 22:00:09 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 27 Aug
 2024 17:00:08 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Joerg Roedel <jroedel@suse.de>, Roy Hopkins
	<roy.hopkins@suse.com>
Subject: [RFC PATCH 3/7] KVM: SVM: Invoke a specified VMPL level VMSA for the vCPU
Date: Tue, 27 Aug 2024 16:59:27 -0500
Message-ID: <840c1337a42525b755661cc6de83c4b4e0c2d152.1724795971.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06A:EE_|IA1PR12MB8408:EE_
X-MS-Office365-Filtering-Correlation-Id: e372f4e8-84a3-49d0-3a6e-08dcc6e39e8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HS8vlLwrbvU4m1QNFKUs7KQuwxvJbMgx/v198KLfa/YZ6tN+m5no+vCsoXJ+?=
 =?us-ascii?Q?ng4aKs9gxsFB9dYEMxtWZG9h32AdCZRrEtbLHtdadrag6K6N0x/TeRcDDmhG?=
 =?us-ascii?Q?DElNHHhBPI3bXpMvplnDCp0wraXuL/FlfRzWXVlMJxVu3wFrRkJaaaadC+PI?=
 =?us-ascii?Q?cK6h0HG175fwfRPl7b4q0vKsdSBF0g2/AsQ84JCvB39KjseuGO0NiZBKkSKC?=
 =?us-ascii?Q?ig5/tj/LprBn4FrN8D8TIISJgUdRbzrB5ow9h6A7GNQgLRv8FXVdgvXBzrdu?=
 =?us-ascii?Q?Zpnyj++HJOppVAHiRFM52GEtZqVTwKgEmT0UAz4FcztwZ/xFzuzmZ77Ee6tz?=
 =?us-ascii?Q?w+MgNzYeauPcRuZfwHgVMjfL5g0pPgu0zPhBz6FcpdS/hCA98gciv6EO9Wm9?=
 =?us-ascii?Q?o3brHLzqHO8iZl8qx0qqtRZN9NQl60Nq2aFSHLLUztU+RX0ZiJl1Ab5TbAhV?=
 =?us-ascii?Q?IGFJnPo39pCpXcBgrZk+mMiP1Vi8ZHuYPlFIhvyEWSN26KatHhrb0M/iNtWl?=
 =?us-ascii?Q?m4B1paXIfzrp9VZVGyBULsSaDIAwkKNn9ozTcxNsUjSnKTsACdO3QoFoSLZl?=
 =?us-ascii?Q?HrZFxBEKUHQcWXKW3MjgdV8Dm99iw2wz3eTsWsWDSgyTDN+QWMKh9od24/Rt?=
 =?us-ascii?Q?T0l49X6hTbkeU7qw2z5DqGQRXm5oEb+vpGUWQZpz3O67uJ8ce421A1oQw24A?=
 =?us-ascii?Q?z4KfMIokygx5DIU/gg3jVxH0izEVnh2N5K5t98Sg5vfGKwW604EThEsuVDXY?=
 =?us-ascii?Q?mqb6smhP9tzHTqss71EBH9iuDI5wq4+Ph7ISp5xBEac5hkhVotp6ntTxBQOw?=
 =?us-ascii?Q?p/RI27vq7aW3SeMF/PuG0AgZYe/smOKmBrpoMzSZOq4aW2tTKKixhaNKHttk?=
 =?us-ascii?Q?FDxpxZX0/nhvdmDml2ak0n0EydI6d60FrduCnJuvkNWqTXBAiChxenDU35q7?=
 =?us-ascii?Q?p00lzx6Yxlek9/UtUyfQUfsZKnu6BwuGbVQw3cc6wj0d95o024jSPkkPULDJ?=
 =?us-ascii?Q?oQ7zklo16A2N6FoFMUFC75NDmV9ngQCPawUEac1zGIg9GM2YmsH6WkhSjImC?=
 =?us-ascii?Q?1ULbe0N1FbuLPD5HH1dOntjefJFm8II5RTQvG+O3QHjM80YdkZTSBBNVx+YL?=
 =?us-ascii?Q?Y0fYAw1HndNj9UT4HmRlbONozxHHw3is707xGN0cMIKm9mQkqgNcWITTgZaK?=
 =?us-ascii?Q?YsuzhcjehYtaHiaZWj5XyLqZFqftzneG4KJnVDtA4LiAIVFBkyU1m09p3HIj?=
 =?us-ascii?Q?vDfYeVNlhGJMsEx5WkMDj1k/HGOoBVtNeAPzj6y/PMVA16sK4qRxs5Www07r?=
 =?us-ascii?Q?Y6IDImu8SPGWjSM4Vx6NTvCLJjTOiZ/llDsNs966dxzh1qOUGb8d3+M9AO9V?=
 =?us-ascii?Q?EJNyxX8c+LQcPvEWFgyzK2a63yEcNQ58V6CSp1vLPqw96oM4NEtNI+vhM7aA?=
 =?us-ascii?Q?9YU+vAQ28E+IiJ1H8QSdl1niRvvJeQni?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 22:00:09.8787
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e372f4e8-84a3-49d0-3a6e-08dcc6e39e8b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06A.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8408

Implement the SNP Run VMPL NAE event and MSR protocol to allow a guest to
request a different VMPL level VMSA be run for the vCPU. This allows the
guest to "call" an SVSM to process an SVSM request.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev-common.h |   6 ++
 arch/x86/kvm/svm/sev.c            | 126 +++++++++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c            |  13 +++
 arch/x86/kvm/svm/svm.h            |  18 ++++-
 4 files changed, 158 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index d63c861ef91f..6f7134aada83 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -114,6 +114,8 @@ enum psc_op {
 
 /* GHCB Run at VMPL Request/Response */
 #define GHCB_MSR_VMPL_REQ		0x016
+#define GHCB_MSR_VMPL_LEVEL_POS		32
+#define GHCB_MSR_VMPL_LEVEL_MASK	GENMASK_ULL(7, 0)
 #define GHCB_MSR_VMPL_REQ_LEVEL(v)			\
 	/* GHCBData[39:32] */				\
 	(((u64)(v) & GENMASK_ULL(7, 0) << 32) |		\
@@ -121,6 +123,10 @@ enum psc_op {
 	GHCB_MSR_VMPL_REQ)
 
 #define GHCB_MSR_VMPL_RESP		0x017
+#define GHCB_MSR_VMPL_ERROR_POS		32
+#define GHCB_MSR_VMPL_ERROR_MASK	GENMASK_ULL(31, 0)
+#define GHCB_MSR_VMPL_RSVD_POS		12
+#define GHCB_MSR_VMPL_RSVD_MASK		GENMASK_ULL(19, 0)
 #define GHCB_MSR_VMPL_RESP_VAL(v)			\
 	/* GHCBData[63:32] */				\
 	(((u64)(v) & GENMASK_ULL(63, 32)) >> 32)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c22b6f51ec81..e0f5122061e6 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3421,6 +3421,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		    control->exit_info_1 == control->exit_info_2)
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_SNP_RUN_VMPL:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto vmgexit_err;
+		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
 		goto vmgexit_err;
@@ -3935,21 +3939,25 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Invoked as part of svm_vcpu_reset() processing of an init event.
+ * Invoked as part of svm_vcpu_reset() processing of an init event
+ * or as part of switching to a new VMPL.
  */
-void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
+bool sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	bool init = false;
 	int ret;
 
 	if (!sev_snp_guest(vcpu->kvm))
-		return;
+		return false;
 
 	mutex_lock(&svm->sev_es.snp_vmsa_mutex);
 
 	if (!tgt_vmpl_ap_waiting_for_reset(svm))
 		goto unlock;
 
+	init = true;
+
 	tgt_vmpl_ap_waiting_for_reset(svm) = false;
 
 	ret = __sev_snp_update_protected_guest_state(vcpu);
@@ -3958,6 +3966,8 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
 
 unlock:
 	mutex_unlock(&svm->sev_es.snp_vmsa_mutex);
+
+	return init;
 }
 
 static int sev_snp_ap_creation(struct vcpu_svm *svm)
@@ -4255,6 +4265,92 @@ static void sev_get_apic_ids(struct vcpu_svm *svm)
 	kvfree(desc);
 }
 
+static int __sev_run_vmpl_vmsa(struct vcpu_svm *svm, unsigned int new_vmpl)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct vmpl_switch_sa *old_vmpl_sa;
+	struct vmpl_switch_sa *new_vmpl_sa;
+	unsigned int old_vmpl;
+
+	if (new_vmpl >= SVM_SEV_VMPL_MAX)
+		return -EINVAL;
+	new_vmpl = array_index_nospec(new_vmpl, SVM_SEV_VMPL_MAX);
+
+	old_vmpl = svm->sev_es.snp_current_vmpl;
+	svm->sev_es.snp_target_vmpl = new_vmpl;
+
+	if (svm->sev_es.snp_target_vmpl == svm->sev_es.snp_current_vmpl ||
+	    sev_snp_init_protected_guest_state(vcpu))
+		return 0;
+
+	/* If the VMSA is not valid, return an error */
+	if (!VALID_PAGE(vmpl_vmsa_hpa(svm, new_vmpl)))
+		return -EINVAL;
+
+	/* Unmap the current GHCB */
+	sev_es_unmap_ghcb(svm);
+
+	/* Save some current VMCB values */
+	svm->sev_es.ghcb_gpa[old_vmpl]		= svm->vmcb->control.ghcb_gpa;
+
+	old_vmpl_sa = &svm->sev_es.vssa[old_vmpl];
+	old_vmpl_sa->int_state			= svm->vmcb->control.int_state;
+	old_vmpl_sa->exit_int_info		= svm->vmcb->control.exit_int_info;
+	old_vmpl_sa->exit_int_info_err		= svm->vmcb->control.exit_int_info_err;
+	old_vmpl_sa->cr0			= vcpu->arch.cr0;
+	old_vmpl_sa->cr2			= vcpu->arch.cr2;
+	old_vmpl_sa->cr4			= vcpu->arch.cr4;
+	old_vmpl_sa->cr8			= vcpu->arch.cr8;
+	old_vmpl_sa->efer			= vcpu->arch.efer;
+
+	/* Restore some previous VMCB values */
+	svm->vmcb->control.vmsa_pa		= vmpl_vmsa_hpa(svm, new_vmpl);
+	svm->vmcb->control.ghcb_gpa		= svm->sev_es.ghcb_gpa[new_vmpl];
+
+	new_vmpl_sa = &svm->sev_es.vssa[new_vmpl];
+	svm->vmcb->control.int_state		= new_vmpl_sa->int_state;
+	svm->vmcb->control.exit_int_info	= new_vmpl_sa->exit_int_info;
+	svm->vmcb->control.exit_int_info_err	= new_vmpl_sa->exit_int_info_err;
+	vcpu->arch.cr0				= new_vmpl_sa->cr0;
+	vcpu->arch.cr2				= new_vmpl_sa->cr2;
+	vcpu->arch.cr4				= new_vmpl_sa->cr4;
+	vcpu->arch.cr8				= new_vmpl_sa->cr8;
+	vcpu->arch.efer				= new_vmpl_sa->efer;
+
+	svm->sev_es.snp_current_vmpl = new_vmpl;
+
+	vmcb_mark_all_dirty(svm->vmcb);
+
+	return 0;
+}
+
+static void sev_run_vmpl_vmsa(struct vcpu_svm *svm)
+{
+	struct ghcb *ghcb = svm->sev_es.ghcb;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	unsigned int vmpl;
+	int ret;
+
+	/* TODO: Does this need to be synced for original VMPL ... */
+	ghcb_set_sw_exit_info_1(ghcb, 0);
+	ghcb_set_sw_exit_info_2(ghcb, 0);
+
+	if (!sev_snp_guest(vcpu->kvm))
+		goto err;
+
+	vmpl = lower_32_bits(svm->vmcb->control.exit_info_1);
+
+	ret = __sev_run_vmpl_vmsa(svm, vmpl);
+	if (ret)
+		goto err;
+
+	return;
+
+err:
+	ghcb_set_sw_exit_info_1(ghcb, 2);
+	ghcb_set_sw_exit_info_2(ghcb, 0);
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -4366,6 +4462,25 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 		ret = snp_begin_psc_msr(svm, control->ghcb_gpa);
 		break;
+	case GHCB_MSR_VMPL_REQ: {
+		unsigned int vmpl;
+
+		vmpl = get_ghcb_msr_bits(svm, GHCB_MSR_VMPL_LEVEL_MASK, GHCB_MSR_VMPL_LEVEL_POS);
+
+		/*
+		 * Set as successful in advance, since this value will be saved
+		 * as part of the VMPL switch and then restored if switching
+		 * back to the calling VMPL level.
+		 */
+		set_ghcb_msr_bits(svm, 0, GHCB_MSR_VMPL_ERROR_MASK, GHCB_MSR_VMPL_ERROR_POS);
+		set_ghcb_msr_bits(svm, 0, GHCB_MSR_VMPL_RSVD_MASK, GHCB_MSR_VMPL_RSVD_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_VMPL_RESP, GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+
+		if (__sev_run_vmpl_vmsa(svm, vmpl))
+			set_ghcb_msr_bits(svm, 1, GHCB_MSR_VMPL_ERROR_MASK, GHCB_MSR_VMPL_ERROR_POS);
+
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -4538,6 +4653,11 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	case SVM_VMGEXIT_GET_APIC_IDS:
 		sev_get_apic_ids(svm);
 
+		ret = 1;
+		break;
+	case SVM_VMGEXIT_SNP_RUN_VMPL:
+		sev_run_vmpl_vmsa(svm);
+
 		ret = 1;
 		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ca4bc53fb14a..586c26627bb1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4253,6 +4253,19 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 	}
 	vcpu->arch.regs_dirty = 0;
 
+	if (sev_snp_is_rinj_active(vcpu)) {
+		/*
+		 * When SEV-SNP is running with restricted injection, the V_IRQ
+		 * bit may be cleared on exit because virtual interrupt support
+		 * is ignored. To support multiple VMPLs, some of which may not
+		 * be running with restricted injection, ensure to reset the
+		 * V_IRQ bit if a virtual interrupt is meant to be active (the
+		 * virtual interrupt priority mask is non-zero).
+		 */
+		if (svm->vmcb->control.int_ctl & V_INTR_PRIO_MASK)
+			svm->vmcb->control.int_ctl |= V_IRQ_MASK;
+	}
+
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 45a37d16b6f7..d1ef349556f7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -198,6 +198,18 @@ struct svm_nested_state {
 	bool force_msr_bitmap_recalc;
 };
 
+struct vmpl_switch_sa {
+	u32 int_state;
+	u32 exit_int_info;
+	u32 exit_int_info_err;
+
+	unsigned long cr0;
+	unsigned long cr2;
+	unsigned long cr4;
+	unsigned long cr8;
+	u64 efer;
+};
+
 #define vmpl_vmsa(s, v)				((s)->sev_es.vmsa_info[(v)].vmsa)
 #define vmpl_vmsa_gpa(s, v)			((s)->sev_es.vmsa_info[(v)].gpa)
 #define vmpl_vmsa_hpa(s, v)			((s)->sev_es.vmsa_info[(v)].hpa)
@@ -256,6 +268,8 @@ struct vcpu_sev_es_state {
 	struct mutex snp_vmsa_mutex; /* Used to handle concurrent updates of VMSA. */
 	unsigned int snp_current_vmpl;
 	unsigned int snp_target_vmpl;
+
+	struct vmpl_switch_sa vssa[SVM_SEV_VMPL_MAX];
 };
 
 struct vcpu_svm {
@@ -776,7 +790,7 @@ int sev_cpu_init(struct svm_cpu_data *sd);
 int sev_dev_get_attr(u32 group, u64 attr, u64 *val);
 extern unsigned int max_sev_asid;
 void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
-void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
+bool sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
@@ -800,7 +814,7 @@ static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
 static inline int sev_dev_get_attr(u32 group, u64 attr, u64 *val) { return -ENXIO; }
 #define max_sev_asid 0
 static inline void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code) {}
-static inline void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu) {}
+static inline bool sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu) { return false; }
 static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order)
 {
 	return 0;
-- 
2.43.2


