Return-Path: <kvm+bounces-25209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C94719619C4
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 00:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4ADAA1F24A6C
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D631D47D8;
	Tue, 27 Aug 2024 22:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TTrbU2JA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5159412F5B1;
	Tue, 27 Aug 2024 22:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724796034; cv=fail; b=t7tjFIf+iLeYyJWkiY86jRYKIUXqgrgUmMoCkKFVGgCqKHCdC0OzY73FZtq4HsM5ux93mI+Rr5h/MkuDxH+CogxvVtXHIPN1mcrfrTZ7JHrQBSiJjAw9Nx9sJmxkjwDvA30vbZ/40B6Os6LaYLWA4sa6W/7rqyVtQ4At/O2LqRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724796034; c=relaxed/simple;
	bh=NEmx+eA4vSYDlDH1xuX3tWpf1/Qy6BKYf+DMblRdp4c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NNEy2VzI46s3HiXgfVixSrq+1iR2e9MRdDU8KFsK/aJDTDyb7C0sl1qVe2v8kT1MntPADWNP/ddqWyECmIDYQyNKmlBQCWaSQhwU5clGRTJhkJhuTVirg+ejvrc8RZAKqsVvmusx4UUlIpYLmwLaw6B9keORYqpHWT83oeKKRcA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TTrbU2JA; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bFNCmarHAUSt4lm3Xdt1x9nV8GwvuxHgBGCJZZsh7Qym3ukoHOvfKWgecOqn53WdT5KIMNURoTkc1LoBWzBRlGk+G2uHwma8S80Ae2ogWReN2ZvgYfY7LOmRuEuTcu44lgoHPsMEH73KMKrZr5b134cneV7QDwra1f13gR6pIqliO3K4EztBfAP9IXQwutqrvgSew0db/nmjnOhyiDUEVjVZqJheJkJ6Z0OS6VzCrhOfvfqlwfy48jPjwkGyYL64hEXYQ8Ou33dwHNOPTjpuCN2HPBj9Oyjc6OXaMxVsktInuxIpWHwikW/tIyXoUJCoEIhDEOZJh5aemVgGfDLSMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JRW7pm5GAuZqbleBkXM4aygyFi6FbDFnuA3rOh+ivjE=;
 b=eUVlEgg/ymgHAJ5vY/lQ7ElUs9EdpIpAAxoUMU3NEl/iQGxiEfqnnW1ynYLRJjeAfjG9qWUVn1z2/jk8taYRwk/J/GVRIk5LoUfPjTgc3Bo4DnRztc0BTmpnJponsRSvASmw7t+0gmHZD/+h+F3KhnK+frm6tHuOzW2lCR2gt5spg4T9q6o8uT6quuksx5nvQGDqDPClnD4gfh3frE5C6udNgCTghJYt+p3JnNC/R2mfsekmSQOMBslfWOGC+nOKj2vKIyjeHqHeUm6cVbziyR2Q1iieydyjekIGoWlEFMcG7k40wtRbjgmY3KHrNawjxhpD+MJLHZVsYojQ/u9QUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JRW7pm5GAuZqbleBkXM4aygyFi6FbDFnuA3rOh+ivjE=;
 b=TTrbU2JAbvAIbB/7ztoI9KxejXDA4f+hgTTCmRtX3uu61Vv9iMJZLjd5RjSwpUyydqY0uR8S0u1NtVoE4h5OXBKTdFVYPZBsOUMRpdNk4EyXHlvHFRQpQyJ/Yd66XVYP42htOdzMwMOQPFGXi8PAwvasTUj7w6rH+BP37/vktVo=
Received: from MN0PR03CA0021.namprd03.prod.outlook.com (2603:10b6:208:52f::35)
 by SA1PR12MB7176.namprd12.prod.outlook.com (2603:10b6:806:2bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Tue, 27 Aug
 2024 22:00:26 +0000
Received: from BN3PEPF0000B06D.namprd21.prod.outlook.com
 (2603:10b6:208:52f:cafe::49) by MN0PR03CA0021.outlook.office365.com
 (2603:10b6:208:52f::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26 via Frontend
 Transport; Tue, 27 Aug 2024 22:00:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06D.mail.protection.outlook.com (10.167.243.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7939.2 via Frontend Transport; Tue, 27 Aug 2024 22:00:26 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 27 Aug
 2024 17:00:23 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Joerg Roedel <jroedel@suse.de>, Roy Hopkins
	<roy.hopkins@suse.com>
Subject: [RFC PATCH 5/7] KVM: SVM: Prevent injection when restricted injection is active
Date: Tue, 27 Aug 2024 16:59:29 -0500
Message-ID: <2e8bce9bf1b1f0a83e1afb78a61165f536c70cb4.1724795971.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06D:EE_|SA1PR12MB7176:EE_
X-MS-Office365-Filtering-Correlation-Id: 77894e91-a907-40e0-cac2-08dcc6e3a880
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3C5LFS5cucshf6IeuC8hUOKcR9qK+dk3yJR37xjuX3mIcfZHxhx6vOsGwGzK?=
 =?us-ascii?Q?VOuvIdUSDnOKG06WS06M5OTGBnDgrxnCwNSu3OuAzO3ilfP42CipZa9ZT+PK?=
 =?us-ascii?Q?CGH5P4ko+Z+qSYyHlx6ZZ51fidBt9tNSn4Z43SstKuwJ9zBFBbfLw6TFnUh+?=
 =?us-ascii?Q?im3zbkT1ff0/zYszgGRuDCiiFIKT4y5axnYaiztYVbLK4gNP4l1QmXk74lXa?=
 =?us-ascii?Q?+vyMMmGpeTr4esZkvFDohQdU2fmsBruMoy8NSxkXwBcvElIT2E0sOtfBGXh4?=
 =?us-ascii?Q?5iO4U8528UDajQumVrg2hyoQ2rDWi6NpBXiq2NkbM9butpZALwWw3tMYzLdg?=
 =?us-ascii?Q?o7BbRV6IkToku999mUCaKP0/8tvV8FzlDGhjqucTbdrq2PdOAaHWR0lXhMEA?=
 =?us-ascii?Q?UG5ICEc5cOtxu9Sw90ubaS9wAYYsAE4UapvmkwOnvKfWUJVFpbAANsHGsF0f?=
 =?us-ascii?Q?bXqsLo3Y0qmdPKM47bFWrK7y3Rytguvs4MZ2BXMvgx7EtDNJUwmxbHhZTO+G?=
 =?us-ascii?Q?3YKPgaEwksq6Qt8JbYUmrQg4+SpdPUR0yXJ18YTOVQJH6pmkEHNEdPXO9xIF?=
 =?us-ascii?Q?zHFLXUqQCiOm7teriKstJuIn0dyYPCSKc7td5FFKPwQJNF1zhs0epVYIeKZL?=
 =?us-ascii?Q?Omdu2sRTEPwwPH0U/uR8HhLdNH0QGqK9Qa3CFD2h5pbW0xohmB4J4RVfNlL2?=
 =?us-ascii?Q?juLUi2q/ucRQa9ZdQqSm+I1b8FDqCcPqnWj2EDKnfRP0fKV5H3qAvMUiyHpf?=
 =?us-ascii?Q?uSnlJpEGac/KC5Uo5e4OWcMUIANgrXfWIjffLuyhpDGs/FQbGL4oMa8tCPWY?=
 =?us-ascii?Q?LJJKyZ+v/McGzxp1d/rSpYxoHswyJpGy+fQs3sI9elA/nW3WD+JZ1yaiBdbh?=
 =?us-ascii?Q?pRH028aQhSo957D2Swls4NzJmY7h+yYvfjVpf4mex0N4RN2pePqbxEI6hREn?=
 =?us-ascii?Q?K59kSt+0mrWOGnzgN6j9Rnb0bFpUG0l0UQtXuGJVoMi1WyjBnJI/93ctUTW9?=
 =?us-ascii?Q?yDvcWq6+Sj9noeaAFFGl5PJV0J7deWiyPreyrlTXEArqlocn6oXv+PR7EPws?=
 =?us-ascii?Q?0Cm9knQ6N99eVeY2z9O43vJkOetFlOR0UuFLZOnZQaVKS/1ZEJZG9HBq4SFf?=
 =?us-ascii?Q?7EHcUUtwoFCC47JnKEp5ASQagK0gJETis74LUTwomMdFdWuk10QdiNwzRqna?=
 =?us-ascii?Q?gbWyCOpt3CgjLx+P1RcYmwJ6eT/0Qff+E+iX/Tat4MSo/Q8ZEh3KnOvUgsRn?=
 =?us-ascii?Q?VaLk4wfL69/4hBfEQklxZRDmAWEBPxXJsMVGEcEuPFdfAxeOXK6m5i4z15b2?=
 =?us-ascii?Q?rPiPlGdgpOpyCHVmKyFsepNwlj8vvuVwZeCR9YufRDRpKttY/l/scRrCCNDd?=
 =?us-ascii?Q?QsLiaDCs2nHUL0PnkSrJdxzyHo22hBmYiR2cpSO1GUvwgsYrwOGrDkh6lerf?=
 =?us-ascii?Q?vpmHw5ByOTUe2ebtojhfpegJIvSvboGY?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 22:00:26.5875
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77894e91-a907-40e0-cac2-08dcc6e3a880
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7176

Prevent injection of exceptions/interrupts when restricted injection is
active. This is not full support for restricted injection, but the SVSM
is not expecting any injections at all.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  6 ++++++
 arch/x86/kvm/svm/svm.h |  3 +++
 3 files changed, 39 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c6c9306c86ef..4324a72d35ea 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5227,3 +5227,33 @@ int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 
 	return level;
 }
+
+bool sev_snp_is_rinj_active(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sev_info *sev;
+	int vmpl;
+
+	if (!sev_snp_guest(vcpu->kvm))
+		return false;
+
+	sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+	vmpl = to_svm(vcpu)->sev_es.snp_current_vmpl;
+
+	return sev->vmsa_features[vmpl] & SVM_SEV_FEAT_RESTRICTED_INJECTION;
+}
+
+bool sev_snp_nmi_blocked(struct kvm_vcpu *vcpu)
+{
+	WARN_ON_ONCE(!sev_snp_is_rinj_active(vcpu));
+
+	/* NMIs are blocked when restricted injection is active */
+	return true;
+}
+
+bool sev_snp_interrupt_blocked(struct kvm_vcpu *vcpu)
+{
+	WARN_ON_ONCE(!sev_snp_is_rinj_active(vcpu));
+
+	/* Interrupts are blocked when restricted injection is active */
+	return true;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 586c26627bb1..632c74cb41f4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3780,6 +3780,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 	if (!gif_set(svm))
 		return true;
 
+	if (sev_snp_is_rinj_active(vcpu))
+		return sev_snp_nmi_blocked(vcpu);
+
 	if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
 		return false;
 
@@ -3812,6 +3815,9 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 	if (!gif_set(svm))
 		return true;
 
+	if (sev_snp_is_rinj_active(vcpu))
+		return sev_snp_interrupt_blocked(vcpu);
+
 	if (is_guest_mode(vcpu)) {
 		/* As long as interrupts are being delivered...  */
 		if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 55f1f6ffb871..029eb54a8472 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -761,6 +761,9 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
+bool sev_snp_is_rinj_active(struct kvm_vcpu *vcpu);
+bool sev_snp_nmi_blocked(struct kvm_vcpu *vcpu);
+bool sev_snp_interrupt_blocked(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_KVM_AMD_SEV
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp);
-- 
2.43.2


