Return-Path: <kvm+bounces-52571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B23B06D7B
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 07:56:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57BCC5602D1
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 05:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DF252E88BD;
	Wed, 16 Jul 2025 05:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="flU5ynQo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF61517D2;
	Wed, 16 Jul 2025 05:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752645404; cv=fail; b=JyRHt61bWvck5+Bt9K/Zy1NYBZf13p6a+NlhXJoUf114KplVIYSrRTO/3Fb2eqJoICbR+o02MbxOwxSRxlmB11fCvwmNVEa8jCZbkjKd5GOX2fDqxiBGgNvA1xCILin+v5HzUODilUcbEiX6yB2gJHV8lgFmnYAKCwJ/sFQ3mho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752645404; c=relaxed/simple;
	bh=vc0yB6Rhl+Bu4SNu72nM9M4XwfyDJX3i/oK9tmpfd5k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IqvXgV0evlqH94PTKq+lvWjiQeMP1Q/0FX6F1McJpa8bJwZgYlDv0rHYAj4SWzI/wzcAcc8iYv33hbTOHGo6ZbObQ9qNy5nyTse63kn4umKlMagSQDE8TfejCzFNPQO9jk/UJ8XC0O1yT9ZYPh54UqBZLXm5I7hJ/QPvybTAqos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=flU5ynQo; arc=fail smtp.client-ip=40.107.244.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IX00yY0WnLWlFaUiAcKNLcAq3pDWQIhcGbiwRDvS6+b6Azj01C+oqzO4n1jJmj3I+JuQXSy9b5kRX0ALpW58WiR4NArt0npMbBNxmFqyFbendUqYj1RPLMUJrjPZWLAB79GLH0W2Krel5ZXmFM+3LXz08T23CAhxGkbpFvzy0AqhglIzP3Fi4lUMQw2zN4k+6hKoafA6rjxF74brN1quyg6QnI+eHEBycZ/bTh+dHFG5QjR86U4KOLZ6RElqiVyEG8btMimPeNxnCO3GoRB+k+L4mhPpovSRiG7HCuVW40t+Jv23vRKJxLj87oqo43Vw9/goYbDviL0hTA5DPKdBWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RcDbgAJia7AuRLxDVxTl5+jNifKJnLmKIy1lEaXzqRw=;
 b=UC+EY6AkLEB/+yxeGc7q2Iq3QYIoNMOSZg7AkkJbhnqqGbvwaS/QR7vzq8iVtKuXRRbK8Rt/X3OA8cCdS2jBElx6upL1tkEMvB/w3bwehlTv+0WMzg8STu1nHsu56CT18m2w0tl+C11kVazuEBoBj2ma/vEVAKQcQCGf5gDSWocwTdsZ1hy7rV/mOpot7Mftf4xaOV+fbrthWNHyuObxhje4ALgFSpn7WIIkDVHX7NH1l+2NDSjoM36Gi5tw+ByVohnB6fhX6rRv/cX/lU9XjJXxQjL35JodIIkCvwvlzOVfExremGUzL92rOHqSAn2uUPBkdrt5CQZYXbhp6M6itQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcDbgAJia7AuRLxDVxTl5+jNifKJnLmKIy1lEaXzqRw=;
 b=flU5ynQocNRMMLJxlIcQ73mWDW5g0oKFpPmS6M2BJb3nGdV3szmcAjxOd4yF6W9TEVoyAQysmIH4Z1hGgLYdTLg6IUrYjnxJXuDuNl06GvZQa6OUCAcGU4rlfY8v8zSW/4F6lG1ZLHPoPrEMHoYHE6RLUcPNvdFk/YP1hySf1rk=
Received: from SJ0PR05CA0127.namprd05.prod.outlook.com (2603:10b6:a03:33d::12)
 by CH3PR12MB9170.namprd12.prod.outlook.com (2603:10b6:610:199::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Wed, 16 Jul
 2025 05:56:37 +0000
Received: from SJ1PEPF00002325.namprd03.prod.outlook.com
 (2603:10b6:a03:33d:cafe::19) by SJ0PR05CA0127.outlook.office365.com
 (2603:10b6:a03:33d::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.16 via Frontend Transport; Wed,
 16 Jul 2025 05:56:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002325.mail.protection.outlook.com (10.167.242.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 16 Jul 2025 05:56:37 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 16 Jul
 2025 00:56:33 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
	<stable@vger.kernel.org>
Subject: [PATCH v2] KVM: SEV: Enforce minimum GHCB version requirement for SEV-SNP guests
Date: Wed, 16 Jul 2025 11:26:04 +0530
Message-ID: <20250716055604.2229864-1-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002325:EE_|CH3PR12MB9170:EE_
X-MS-Office365-Filtering-Correlation-Id: 70770ffb-242e-4f3b-b752-08ddc42d86f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dEwcdnZlAWzm9Xbf8EBDnjJ2rXf7YDlVM2iZvTj+r1Ezz17fdPs4GkBWS0B6?=
 =?us-ascii?Q?4M6UAfAPRzxU+1PoYEbaw1T6zAYwntEq2J6G8oD2S7+hqLcZE+PGU4aVBFGr?=
 =?us-ascii?Q?h9eU1DyXfIzKY8lR9YbETyq73v/K6NF++bnxnVFS7O7Lpp7I+3nAN02FndSf?=
 =?us-ascii?Q?/cJYtQF/22dOdiIWxQjYMy8cAmSYsNaKhIzmXOFajTrb00kU9b1DMqk4Ps8w?=
 =?us-ascii?Q?JjLCHip+tlwQVpyqX7NIhiLRuDoR1pSUE+n0eX7l187JM4sR67C9d9R/rxIz?=
 =?us-ascii?Q?mlvprZmnwOffIEL81mX4sEl4WMN7q+4jNTIpwYE79OJzr0E3CbCwiWPEJsMF?=
 =?us-ascii?Q?RIzL25wteALZxHqBnwWHfZCSVWNljDUA1KYubae0aimI9C3ZJ45BtbwzkaU8?=
 =?us-ascii?Q?Is5CVew9dUnvOdyvX8FHRV4lRnk2hxSNzv1za3LChifjZlvker93g3/lES9N?=
 =?us-ascii?Q?7rtrnlbEOBdKIzCL0Ne/CSLhJwLVYV09TthQOoE8SWRHzUVjnHS0Kb7ew8Ys?=
 =?us-ascii?Q?kg9t/kpCbnbd+SOHvpXLgnQAfM1k94ASq60iZpw6DY83OdH+Ug5lb0y8YWvf?=
 =?us-ascii?Q?MEBNAPMyV1pg2K8b1hkRt+hs7+UzyO0OGynCo2HtCCcv2OuqTAusUtJrilFA?=
 =?us-ascii?Q?ecyx6c5tpOy/ioe8cmfSrYiSAAOOWeNrLaYrsRl2y6ohFt3/mbk5gg0Ea6RV?=
 =?us-ascii?Q?tU/RzOTPvljpXpzwYuIL5mVMaWzBdSqrchCd2SITY3EO2FJlH9lbdBEtuURA?=
 =?us-ascii?Q?diyNJpJ4Ohn72oCJuPV1yhXsLF8iAkBvvCyZArTa341+vdUzAjejRENQSWVc?=
 =?us-ascii?Q?bhxDYgpHjV3al+XP9CLkSY6oJfSIkNebELaQCet++QkLHTSElam9SiU5OQV5?=
 =?us-ascii?Q?ebOi2f+qgv1atJU4Ws5anxNt+54y2e1wjGjtzhAMUjl/mGlMxkejd04QDWbL?=
 =?us-ascii?Q?wUpcJs3edH4CgOaaXArKele1v22kdFf41mA16ZQVmiPIa06DvJbpwRsib4g1?=
 =?us-ascii?Q?9iZnAjMPT4Edq627XFvvHym7i2B5Ccl3lnQLeaBuezI8FyWYXi24otwsJ62w?=
 =?us-ascii?Q?jkT1Lz6mbRWjVuvlgEX0wn0gk/0Id3DJqPcvNEfRyu/CsVOTUP2EjEQPwUNf?=
 =?us-ascii?Q?so0qAXYYa8/J2mxBf2lroQ/aokpW7ECpN4EqBcpf+qsg6XqEyUd9Oi+QDJQ4?=
 =?us-ascii?Q?0ODjF+8pXWvYHaRmrYu7CgdcANnEXp0BBi3HDiwzF+NnsT9TkLXRxwXzrMc8?=
 =?us-ascii?Q?16tgWmf0JAgt8v0+MRUTbIBrhGh1qBKlu/i6VZg7ktju91x+SIrXeL7nBsrP?=
 =?us-ascii?Q?TM/XNklkfEjAh2GO8ZjuP5urwJo5fKGgsM26yI4xMey3NTZwvNol3TkNIHj8?=
 =?us-ascii?Q?IYHDjIC8HM+JqfsCS1sPTNw6hsOCOer6zIfixwxKPaJLps4F/fzKeYMd31Wx?=
 =?us-ascii?Q?iVIooAhuCVv7ncRtNEz+NWk668m6FLYhkTE1UD8kuWRB+Wq61mQdxnZwa52X?=
 =?us-ascii?Q?KTgn09+RBuMLIDvc6yJuNe9vEe+6qpZCWaTC?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 05:56:37.1897
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70770ffb-242e-4f3b-b752-08ddc42d86f4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002325.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9170

Require a minimum GHCB version of 2 when starting SEV-SNP guests through
KVM_SEV_INIT2. When a VMM attempts to start an SEV-SNP guest with an
incompatible GHCB version (less than 2), reject the request early rather
than allowing the guest kernel to start with an incorrect protocol version
and fail later with GHCB_SNP_UNSUPPORTED guest termination.

Hypervisor logs the guest termination with GHCB_SNP_UNSUPPORTED error code:

kvm_amd: SEV-ES guest requested termination: 0x0:0x2

SNP guest fails with the below error message:

KVM: unknown exit reason 24
EAX=00000000 EBX=00000000 ECX=00000000 EDX=00a00f11
ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
EIP=0000fff0 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 00000000 0000ffff 00009300
CS =f000 ffff0000 0000ffff 00009b00
SS =0000 00000000 0000ffff 00009300
DS =0000 00000000 0000ffff 00009300
FS =0000 00000000 0000ffff 00009300
GS =0000 00000000 0000ffff 00009300
LDT=0000 00000000 0000ffff 00008200
TR =0000 00000000 0000ffff 00008b00
GDT=     00000000 0000ffff
IDT=     00000000 0000ffff
CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000000
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000000

Fixes: 4af663c2f64a ("KVM: SEV: Allow per-guest configuration of GHCB protocol version")
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Michael Roth <michael.roth@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

---

Changes since v1:
* Add failure logs in the commit and drop @stable tag (Sean)
---
 arch/x86/kvm/svm/sev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 95668e84ab86..fdc1309c68cb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -406,6 +406,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
 	struct sev_platform_init_args init_args = {0};
 	bool es_active = vm_type != KVM_X86_SEV_VM;
+	bool snp_active = vm_type == KVM_X86_SNP_VM;
 	u64 valid_vmsa_features = es_active ? sev_supported_vmsa_features : 0;
 	int ret;
 
@@ -424,6 +425,9 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (unlikely(sev->active))
 		return -EINVAL;
 
+	if (snp_active && data->ghcb_version && data->ghcb_version < 2)
+		return -EINVAL;
+
 	sev->active = true;
 	sev->es_active = es_active;
 	sev->vmsa_features = data->vmsa_features;
@@ -437,7 +441,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	if (sev->es_active && !sev->ghcb_version)
 		sev->ghcb_version = GHCB_VERSION_DEFAULT;
 
-	if (vm_type == KVM_X86_SNP_VM)
+	if (snp_active)
 		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
 	ret = sev_asid_new(sev);
@@ -455,7 +459,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	}
 
 	/* This needs to happen after SEV/SNP firmware initialization. */
-	if (vm_type == KVM_X86_SNP_VM) {
+	if (snp_active) {
 		ret = snp_guest_req_init(kvm);
 		if (ret)
 			goto e_free;

base-commit: 772d50d9b87bec08b56ecee0a880d6b2ee5c7da5
-- 
2.43.0


