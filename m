Return-Path: <kvm+bounces-41553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB963A6A71D
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:27:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E7FA3B6407
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 13:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFCB521638D;
	Thu, 20 Mar 2025 13:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4Gbm9vo9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323762AE99;
	Thu, 20 Mar 2025 13:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742477242; cv=fail; b=HcXhRcQx9FRT9hN5ZrYy6H3n6lvpCWnWwqXy8eY8Lsnkx+IyKdWV+xVk0jtvmOkSQ7fAu32VJ5cA5WwhZ/9c1whqxfDbcTWQrUpAo4GqHavPXEuDQ20apdcAgo9jz+lbXlS/vEOvJPEqO1jfjz9kmx3noJeaJkEA9R3HyH8fuOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742477242; c=relaxed/simple;
	bh=TQvUhGimDzrHYlWPp10clZ5e6ys03d7+lLcktVKT3OA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bw2eVxtOAiAkz8LYcOeFDOtf5Wvlo/p4Jl7xWiHmyNg5cBohKvrbVkUyCa/ENvMGX4FFS4uQV2JgOY8A5ew21J/EsH2tZVFPWTr0dYsEChPN3tYttfwvctHqMaTk6UKzNisfEh5JUedGgaya40ButGgCILB01thpW6jbu0fDNkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4Gbm9vo9; arc=fail smtp.client-ip=40.107.244.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PgMZM2vWhYTPNK2/jydxH8e9PT+63fq3QlaFdfqWmUlDEtIXTiAwGVsScyESRy2sPRCzk4j7DkLyZyhWV9IoBAay/iP8A8O5opvFRf8FjDxuPBD1ibHMZlfHWfqXPDEtA7dRu5ZyPlwQt1TGZN+3TbhYKSp31N4GR3nb89J2Rlco7RZtXHXKle75XJM5DkVf6KVHxvktlB+cdjBkl/A+vWXfhJxzeKdDPLN50LnA2chaf95O3Hwd2cOzdD6x43NqREzq4fGeXRJmedZ51zK6HyZjlynVcZ0Q3jQC0Rryw0Xo9dWDxxGWjCvcsar/AM6c8eStjhnAQ+HdFXqqgXvsog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ft1qCBMoC4lTI0SECHL6Jjc2V6kY8v3yKAOjgWnI+k4=;
 b=Nl9a7OhFUt3Ovn8p6HkP7hf19Q1vN8x036sES1FkoYylLXVhr9whjVwAw370MNwlRFDPHnDcHcUudO/BZlM2eg/B2cfUoTHzelzDFcb2p2lEK/ipbCZ2FolpQsqBq/2mb0K8k1BlnltfoJ/Wz+F5BA2AWK3wl2A67YO/CUTLd48z/nloyDTr8dpb0HqvqQD+uxgO5Vc5soszYIeTUexubnsUsH1Y7d2RBjaxLT4eamlhJPhXI8vv4CtfdUXZh31rMqrJrH8pqTZR//FrxKQsTMlVgOBfQbmBfChHIChniOzywK+63OI378Au5Nod1nsx40alVl2ZFL9CtRnItkHPhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ft1qCBMoC4lTI0SECHL6Jjc2V6kY8v3yKAOjgWnI+k4=;
 b=4Gbm9vo9CYt5P6a5sgbBO5ET7JdyFb1vJ84hj8oSlCqjjpuk24tmv0qvAKHgFKeqZXakPbfqmUdpziizlM9wKyiO1KwpR/U1424HXMk3tsNgC5ypBrEQz+vxlgXptNlOt+1OQ3BWvjMbZf2OQ4o9hzoFBXrf05NAyL7wU6IeAaQ=
Received: from MN2PR14CA0002.namprd14.prod.outlook.com (2603:10b6:208:23e::7)
 by CH3PR12MB8909.namprd12.prod.outlook.com (2603:10b6:610:179::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Thu, 20 Mar
 2025 13:27:16 +0000
Received: from BL02EPF00021F6C.namprd02.prod.outlook.com
 (2603:10b6:208:23e:cafe::2c) by MN2PR14CA0002.outlook.office365.com
 (2603:10b6:208:23e::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.34 via Frontend Transport; Thu,
 20 Mar 2025 13:27:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6C.mail.protection.outlook.com (10.167.249.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Thu, 20 Mar 2025 13:27:15 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 20 Mar
 2025 08:27:13 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Subject: [PATCH 1/5] KVM: SVM: Decrypt SEV VMSA in dump_vmcb() if debugging is enabled
Date: Thu, 20 Mar 2025 08:26:49 -0500
Message-ID: <ea3b852c295b6f4b200925ed6b6e2c90d9475e71.1742477213.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1742477213.git.thomas.lendacky@amd.com>
References: <cover.1742477213.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6C:EE_|CH3PR12MB8909:EE_
X-MS-Office365-Filtering-Correlation-Id: 4492edb9-7f08-4908-51be-08dd67b2ee73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fDI2Swm5aeNEgWMMz5vYsiDMm9LOuMqrgkOqZijhnT14Y5aJoLZ+Q60DTcCO?=
 =?us-ascii?Q?vHkczc241pswUvTmzwhaiEPkC73k07zPRs1KRn/L+l8FZKQ0yutIOJnKHUgH?=
 =?us-ascii?Q?annyeaarVJ46sC/k3R9+eeEBt9/xChyyqt1bmUjC+jPMG/9mdjK/VU7ukEZQ?=
 =?us-ascii?Q?rDAdZhetQLzWWW5G1FvCBZbNseHIE9J6bdhBmnokaLlu4OkjKZ5PIoQCrkdN?=
 =?us-ascii?Q?5H1lHDl11KZjha6HgfLYa8yQ/BSesLtiYhCSyuFSczWvb7pCAfe9r8//VAWx?=
 =?us-ascii?Q?h2kpdxy4dswc43D4SlG/OfMnmhT5p6+aFPK0RGICLueC4sAivSNyh8DSI8tI?=
 =?us-ascii?Q?PrYtpiBjQjV/ece4QcG7+7TfWWgf2rdM23TH5ZhQ+P1chaR8PuTCF1TFFNmh?=
 =?us-ascii?Q?suF+ZB7UFBpgsXN8F8V7awLGKYBvjirgNsr0af8O8Qy/9k/1LsEjiCIPMh80?=
 =?us-ascii?Q?Yxk8b1I1To5FVVmLP6dHDzPrEGh9hCN2YqUgL56oTuCrK/EPq7iNAPB8mdKR?=
 =?us-ascii?Q?bGjFO+f1k4ZMZG8HNhLObZ+F+KA5rTpyu/JwehATpI0ItAYtdhtjF3tlYJt9?=
 =?us-ascii?Q?P9eqHZFITa6FK1JDSXeieEMXwaUh8tHPJ/zyYgnO/lzoKY5RnRwSNC/zl6fO?=
 =?us-ascii?Q?vkYmJn88Rw7UuxEIlI/vBIpNvWbBTVcXiqnDR8LcuQcx+W5R4TIFYnkJqtcE?=
 =?us-ascii?Q?7YhSaJ1OokJf4my8ssPs8czSFhNX9QiJlZkYxXzlSwMaT4hTht0G+ikWibg4?=
 =?us-ascii?Q?N+1tf+C6pFP1sqUaVm6Pp/USCmUMSlGRYQd+DE9dFe2Jls+Ylv0RyQ77vCmC?=
 =?us-ascii?Q?tlzVa1QCd6m+Ieiem7ZImBM5GoJAhhJAXV+De84EgaH5dDnlJM9HNJ7XAfRl?=
 =?us-ascii?Q?eNk0Raq3+lmGQrAbqNDXb++48T2VeCFMRlQos8BTHKY5sVh1A6xFh3ZjBbGu?=
 =?us-ascii?Q?RhUJ7njIOW93+Sr3wYEXH32qCwpJSGkVKsl6NlcNXvrzFpRIDASgWf4agLKk?=
 =?us-ascii?Q?GtGF7v3GR4kEXY7i70A2LIS+qzKmZ0yn4ibBSQYL6wx2VjF7HC4bBt4R0coC?=
 =?us-ascii?Q?30zHpOI8rjycmYBFqBBsU+gZSGhn+Vw3bsuSX1wRxm3avDyiCzSnCoznY0Qw?=
 =?us-ascii?Q?BZLuWqVzOdJfn6FzXQyNZ0TovedSwJCAsxn8niIKsUiZ9K47wGKHcfQVAEhj?=
 =?us-ascii?Q?yxyAkWm6q+NAYR7+hq42VdXmYExjtSpDcMzslEFhYxo7UECNKr86/QE8vpF8?=
 =?us-ascii?Q?2wwIuz2oMQNcboYkCOn4WAn7T3UyRUUllC4IsVkFtX384zqnstgB1d+CcrKj?=
 =?us-ascii?Q?pRaL/e3BOli6K/GWpJidctlN3Z7Y6ghtWPXuZQYz1tNQ3+5HWl2AN5eN9OPA?=
 =?us-ascii?Q?dtxfQG1AZBW1DyHKrBXZpFkeG9mn+x8/m98lcvwElrikFD0/GgNENPUKE3zO?=
 =?us-ascii?Q?6cNZznUevI4JZQ7cNO3Uk3kYzyKHF+CIrHOcTI9LzKBpsIZJDVvaz5JKmCI7?=
 =?us-ascii?Q?+dDL1Vq80nILw78=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 13:27:15.8384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4492edb9-7f08-4908-51be-08dd67b2ee73
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8909

An SEV-ES/SEV-SNP VM save area (VMSA) can be decrypted if the guest
policy allows debugging. Update the dump_vmcb() routine to output
some of the SEV VMSA contents if possible. This can be useful for
debug purposes.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 98 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c | 13 ++++++
 arch/x86/kvm/svm/svm.h | 11 +++++
 3 files changed, 122 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 661108d65ee7..6e3f5042d9ce 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -563,6 +563,8 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
 		return -EFAULT;
 
+	sev->policy = params.policy;
+
 	memset(&start, 0, sizeof(start));
 
 	dh_blob = NULL;
@@ -2220,6 +2222,8 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (params.policy & SNP_POLICY_MASK_SINGLE_SOCKET)
 		return -EINVAL;
 
+	sev->policy = params.policy;
+
 	sev->snp_context = snp_context_create(kvm, argp);
 	if (!sev->snp_context)
 		return -ENOTTY;
@@ -4975,3 +4979,97 @@ int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 
 	return level;
 }
+
+struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_save_area *vmsa;
+	struct kvm_sev_info *sev;
+	int error = 0;
+	int ret;
+
+	if (!sev_es_guest(vcpu->kvm))
+		return NULL;
+
+	/*
+	 * If the VMSA has not yet been encrypted, return a pointer to the
+	 * current un-encrypted VMSA.
+	 */
+	if (!vcpu->arch.guest_state_protected)
+		return (struct vmcb_save_area *)svm->sev_es.vmsa;
+
+	sev = to_kvm_sev_info(vcpu->kvm);
+
+	/* Check if the SEV policy allows debugging */
+	if (sev_snp_guest(vcpu->kvm)) {
+		if (!(sev->policy & SNP_POLICY_DEBUG))
+			return NULL;
+	} else {
+		if (sev->policy & SEV_POLICY_NODBG)
+			return NULL;
+	}
+
+	if (sev_snp_guest(vcpu->kvm)) {
+		struct sev_data_snp_dbg dbg = {0};
+
+		vmsa = snp_alloc_firmware_page(__GFP_ZERO);
+		if (!vmsa)
+			return NULL;
+
+		dbg.gctx_paddr = __psp_pa(sev->snp_context);
+		dbg.src_addr = svm->vmcb->control.vmsa_pa;
+		dbg.dst_addr = __psp_pa(vmsa);
+
+		ret = sev_issue_cmd(vcpu->kvm, SEV_CMD_SNP_DBG_DECRYPT, &dbg, &error);
+
+		/*
+		 * Return the target page to a hypervisor page no matter what.
+		 * If this fails, the page can't be used, so leak it and don't
+		 * try to use it.
+		 */
+		if (snp_page_reclaim(vcpu->kvm, PHYS_PFN(__pa(vmsa))))
+			return NULL;
+
+		if (ret) {
+			pr_err("SEV: SNP_DBG_DECRYPT failed ret=%d, fw_error=%d (%#x)\n",
+			       ret, error, error);
+			free_page((unsigned long)vmsa);
+
+			return NULL;
+		}
+	} else {
+		struct sev_data_dbg dbg = {0};
+		struct page *vmsa_page;
+
+		vmsa_page = alloc_page(GFP_KERNEL);
+		if (!vmsa_page)
+			return NULL;
+
+		vmsa = page_address(vmsa_page);
+
+		dbg.handle = sev->handle;
+		dbg.src_addr = svm->vmcb->control.vmsa_pa;
+		dbg.dst_addr = __psp_pa(vmsa);
+		dbg.len = PAGE_SIZE;
+
+		ret = sev_issue_cmd(vcpu->kvm, SEV_CMD_DBG_DECRYPT, &dbg, &error);
+		if (ret) {
+			pr_err("SEV: SEV_CMD_DBG_DECRYPT failed ret=%d, fw_error=%d (0x%x)\n",
+			       ret, error, error);
+			__free_page(vmsa_page);
+
+			return NULL;
+		}
+	}
+
+	return vmsa;
+}
+
+void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa)
+{
+	/* If the VMSA has not yet been encrypted, nothing was allocated */
+	if (!vcpu->arch.guest_state_protected || !vmsa)
+		return;
+
+	free_page((unsigned long)vmsa);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e67de787fc71..21477871073c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3423,6 +3423,15 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "avic_logical_id:", control->avic_logical_id);
 	pr_err("%-20s%016llx\n", "avic_physical_id:", control->avic_physical_id);
 	pr_err("%-20s%016llx\n", "vmsa_pa:", control->vmsa_pa);
+
+	if (sev_es_guest(vcpu->kvm)) {
+		save = sev_decrypt_vmsa(vcpu);
+		if (!save)
+			goto no_vmsa;
+
+		save01 = save;
+	}
+
 	pr_err("VMCB State Save Area:\n");
 	pr_err("%-5s s: %04x a: %04x l: %08x b: %016llx\n",
 	       "es:",
@@ -3493,6 +3502,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-15s %016llx %-13s %016llx\n",
 	       "excp_from:", save->last_excp_from,
 	       "excp_to:", save->last_excp_to);
+
+no_vmsa:
+	if (sev_es_guest(vcpu->kvm))
+		sev_free_decrypted_vmsa(vcpu, save);
 }
 
 static bool svm_check_exit_valid(u64 exit_code)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ea44c1da5a7c..66979ddc3659 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -98,6 +98,7 @@ struct kvm_sev_info {
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
+	unsigned long policy;
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
@@ -114,6 +115,9 @@ struct kvm_sev_info {
 	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
 };
 
+#define SEV_POLICY_NODBG	BIT_ULL(0)
+#define SNP_POLICY_DEBUG	BIT_ULL(19)
+
 struct kvm_svm {
 	struct kvm kvm;
 
@@ -756,6 +760,8 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu);
+void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa);
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -787,6 +793,11 @@ static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 	return 0;
 }
 
+static inline struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
+{
+	return NULL;
+}
+static inline void sev_free_decrypted_vmsa(struct kvm_vcpu *vcpu, struct vmcb_save_area *vmsa) {}
 #endif
 
 /* vmenter.S */
-- 
2.46.2


