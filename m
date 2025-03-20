Return-Path: <kvm+bounces-41554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFE50A6A71F
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:28:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9843F3BA574
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 13:27:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC1D221F35;
	Thu, 20 Mar 2025 13:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oCJZUuR/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2078.outbound.protection.outlook.com [40.107.95.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8878521CC40;
	Thu, 20 Mar 2025 13:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742477248; cv=fail; b=iJ46rENwb0M77bvkV3o4h2ek+BdECnuc5mZ6BPKVLghP3Y+0REj5UfX33MuIM+Dr8jLtEF/iPysNtxdvalpE/PPL7bJO5WOOCmthEUSKu+KNEgCBESLhSE0AYQCj43b8zCToDilQMb59gR4bkdo1tAzVvqOay7bvsgDRfR3lAcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742477248; c=relaxed/simple;
	bh=rvnkbafmnbZwBimo2/e/KtCcQa88KdS2BKmRNWXe0Rg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ROUbqaqIv55IWRqkpwvblH8XqE4XZQ073wxGbDVm3UfY4SsRb574ynn4JDqgtQ9YY1fjXkhduSsSX8dDkAqwuBnCgfDp+i0SUmJc8C7tf77l0YqLzEhF03vrLaqVTHzvFdqFeDRj6SIRztjMRe1JzKXnbwv0nvXhugDtGBSuCHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oCJZUuR/; arc=fail smtp.client-ip=40.107.95.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hDhPU1zJP5pzzAMgY1AItke+U9c5f95xTQC2akycy0A5NMMiwl2LXL7RfXlK2yLtIAERkWQzYTczx8RQzaZnPgaXco7qOChG7vRKyLY1JZwynZV0y/QkM+1W5J8b3R78V/NPoLG79Hpubp7EE9xOsrJv6iGscrzs/zgrzKrTxipYx7HMfk8DoP6Iho0aTkMG93tNWBKDFEQfvEmwBZoHlKB7pxs47OGZnIzDth/KdNvLp1C8F65MN1gScrfUlj/XOGDDnRJ/rrqojDGo0Htqppu5oMjmfhSlXlDWK9PK3yaNpteURHOHBz3TdQjfHrcxtkGdI61KMLw5gTfQvmoS8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QY8tCuWyExRi4Nx3qxW/mYAeIndE4Y9afQ6ecJu049w=;
 b=zMbkKd4AZupqZdoPDdRTX8TaOcYJeNrlSO80nLRF20VM35IF4OGlQBIwzBxYM0Ra0WukwIkXoew8YiB3w1k84j1Iu24vleikD9twRRlgJhljE4YHZQMYHsQBgUZDKqGR+7bbW60t6AP88ky58MQp8JEcG4tK47de6SYmzDXYtqvcVmpyq3JDnAAJYc8FkSOLwqpSYsKwEGi9iecUXWyp6ENHNZBUxv1dZwyjglD1nX3j8CmwiaJmXq4G5Ew1g6SAEI5YMC5XcFTGt0fA99685/MaIvOAmGvKtbH564sd2FvZVDWLOabMSRuujsd4D3bQ7087X4nVDIHwuKts+L3MJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QY8tCuWyExRi4Nx3qxW/mYAeIndE4Y9afQ6ecJu049w=;
 b=oCJZUuR/8pN6oanViVXBzpu4s0kHH5P3jdJpQK4w0LStX+ZGnWvgDMuQGzTagVXcsITsCq7/Ki27E8SVBPxqtRBj17WuuHF9GSnlOeTC/GzP7es0GgUQWSiBKjgoVlbU2qVELeKTzzzcwfvasYf3Dr1vcLSo15v+IBwSZhxPPK8=
Received: from MN0PR05CA0015.namprd05.prod.outlook.com (2603:10b6:208:52c::28)
 by CH3PR12MB7738.namprd12.prod.outlook.com (2603:10b6:610:14e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Thu, 20 Mar
 2025 13:27:23 +0000
Received: from BL02EPF00021F6A.namprd02.prod.outlook.com
 (2603:10b6:208:52c:cafe::e1) by MN0PR05CA0015.outlook.office365.com
 (2603:10b6:208:52c::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.36 via Frontend Transport; Thu,
 20 Mar 2025 13:27:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6A.mail.protection.outlook.com (10.167.249.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Thu, 20 Mar 2025 13:27:22 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 20 Mar
 2025 08:27:21 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Subject: [PATCH 2/5] KVM: SVM: Dump guest register state in dump_vmcb()
Date: Thu, 20 Mar 2025 08:26:50 -0500
Message-ID: <a4131a10c082a93610cac12b35dca90292e50f50.1742477213.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6A:EE_|CH3PR12MB7738:EE_
X-MS-Office365-Filtering-Correlation-Id: 22aedff6-c490-4d5e-3616-08dd67b2f27c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z0PbIRIixBNxFogtlmnZgFncsWxbZAptoiloQY2J3EGN3fEqpWFG+CfTmcjY?=
 =?us-ascii?Q?B2QRo33yqHNLqRtjV93zgTnDypdPmRJS0EIdnGnYH3600fiRWahsopcu0sly?=
 =?us-ascii?Q?7HAzHvBUwtwTFJvmJS7QWyYsd7aOjVCB3O2oTScFYkCfURTWTzZN3FyN4IXN?=
 =?us-ascii?Q?2kaV+2/DF40t5chqBg1dlfeQRrLWrlGie+9hGtXv5zk2vsy+755Dh8sQnNlb?=
 =?us-ascii?Q?+uJ00m3SM2KyFcWbtsSCHXhKjsWsouRgTrgOFGgFIR4gkpVyePkOJItSVmAi?=
 =?us-ascii?Q?mNdo/BJeLfuzDRX8AwOiDfalkc+FWgUH/wty2aptBRJTRDf52GSzimHjZ0A7?=
 =?us-ascii?Q?lH8FN1roElWbcrXfU448YXlHqYtC+/NGTMjadobAkZPrpXuQoSgk9ZJFhtY8?=
 =?us-ascii?Q?nByAX3KN0UAz90FVDWg+mUv3Mj+nBARINvqAPbcK3H9gZDnsqSeW0N07mUOS?=
 =?us-ascii?Q?28qMbiA186/xU5WySLsrgLWNWMIhQ/mSqDSWzh9zdPG/1Mbt84sNzr+IBdDi?=
 =?us-ascii?Q?4LZWogSTvQKhhfjs488q2xNStdSPYelWNFWOdjGKAo1gqNu09lVz6L+hkZ9n?=
 =?us-ascii?Q?KFNEXRrXVuzrLSY/qBgUTLT/tiJejqYgLNhwS7shKzbVGfnZeGAm7dkNb4d6?=
 =?us-ascii?Q?QEbyx1GPnWVY8SxKcWMYwk62gBMUS2gCyZ6ucHDqFbOUf2Mt0wv2H0sfvx5a?=
 =?us-ascii?Q?Slgaxqy44H2E81wT+ueCMOSJ0VtXcsjFdBPo/LaGuev9o+zvvIOvKDCpR2uf?=
 =?us-ascii?Q?WBQvH7oUH7Et0G6DBoKwgkpHHREqq5hHODDEFJrK//a6PAXIXl8C8hn9MWD5?=
 =?us-ascii?Q?FirMaJNStdnTLEnMsonTWpkun3Q0Cbgz4+mk+Bfck1oxg6+pn2WU5wRuPOyx?=
 =?us-ascii?Q?pRYvln+dnh2JlGQfSgLe2RrTf05CnR//6KocfwZU56t6awSOgeHwRFZhpUAG?=
 =?us-ascii?Q?H1ci/iqSm6P4WdkAmDY6Kk1R89mV+EDY1ci/DcYKV9pHo7+SzuxmC4zlk4Bp?=
 =?us-ascii?Q?nggtDIXmcEcA1ioOebKq8dBu57J2JyD6oOaHdsm7D691nKCY4t3+oYnDbW3V?=
 =?us-ascii?Q?Y/T4mGr/BpkMLyxyv0lFFKxFGOZsZG8mwRED/ch/sKtBvazPnv2rVgGmQZdO?=
 =?us-ascii?Q?gf/hld3avASpXoOux/lij6k35fMnVIj3Bzdd2jqDoFZcCxb3RI8gp9vZ6uy/?=
 =?us-ascii?Q?Ae3jOKLW2hQ7c+0b2y2dGDwamKlfgib26JsohUxGuL3z6gslRFMgy1xsg3P0?=
 =?us-ascii?Q?kKrCcUisoyWjrScUc7aGYCmJ+EBLd+h4r4KbcpOcwH2euc9Vk9Ze2N2xck4k?=
 =?us-ascii?Q?r5U+7frRsBsIkxypfEKk5gVsEkJr1BQBspyCghDabO3+xRmfg6ItDqO3Lw4A?=
 =?us-ascii?Q?bbThworMsHU2Vwh2z9u40Br2xZjDT8omnPbKn2yxPUhlcjpR+azCGRTa0VbB?=
 =?us-ascii?Q?/j7y/eywWJFtc/C4CZz9kzGbdduGfAQ+mEVxPTBIaMwFBQAW94cAGQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 13:27:22.5763
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22aedff6-c490-4d5e-3616-08dd67b2f27c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7738

Guest register state can be useful when debugging, include it as part
of dump_vmcb().

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 53 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 21477871073c..5ed6009bcf69 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3503,6 +3503,59 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	       "excp_from:", save->last_excp_from,
 	       "excp_to:", save->last_excp_to);
 
+	if (sev_es_guest(vcpu->kvm)) {
+		struct sev_es_save_area *vmsa = (struct sev_es_save_area *)save;
+
+		pr_err("%-15s %016llx\n",
+		       "sev_features", vmsa->sev_features);
+
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "rax:", vmsa->rax, "rbx:", vmsa->rbx);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "rcx:", vmsa->rcx, "rdx:", vmsa->rdx);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "rsi:", vmsa->rsi, "rdi:", vmsa->rdi);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "rbp:", vmsa->rbp, "rsp:", vmsa->rsp);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "r8:", vmsa->r8, "r9:", vmsa->r9);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "r10:", vmsa->r10, "r11:", vmsa->r11);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "r12:", vmsa->r12, "r13:", vmsa->r13);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "r14:", vmsa->r14, "r15:", vmsa->r15);
+		pr_err("%-15s %016llx %-13s %016llx\n",
+		       "xcr0:", vmsa->xcr0, "xss:", vmsa->xss);
+	} else {
+		pr_err("%-15s %016llx %-13s %016lx\n",
+		       "rax:", save->rax, "rbx:",
+		       vcpu->arch.regs[VCPU_REGS_RBX]);
+		pr_err("%-15s %016lx %-13s %016lx\n",
+		       "rcx:", vcpu->arch.regs[VCPU_REGS_RCX],
+		       "rdx:", vcpu->arch.regs[VCPU_REGS_RDX]);
+		pr_err("%-15s %016lx %-13s %016lx\n",
+		       "rsi:", vcpu->arch.regs[VCPU_REGS_RSI],
+		       "rdi:", vcpu->arch.regs[VCPU_REGS_RDI]);
+		pr_err("%-15s %016lx %-13s %016llx\n",
+		       "rbp:", vcpu->arch.regs[VCPU_REGS_RBP],
+		       "rsp:", save->rsp);
+#ifdef CONFIG_X86_64
+		pr_err("%-15s %016lx %-13s %016lx\n",
+		       "r8:", vcpu->arch.regs[VCPU_REGS_R8],
+		       "r9:", vcpu->arch.regs[VCPU_REGS_R9]);
+		pr_err("%-15s %016lx %-13s %016lx\n",
+		       "r10:", vcpu->arch.regs[VCPU_REGS_R10],
+		       "r11:", vcpu->arch.regs[VCPU_REGS_R11]);
+		pr_err("%-15s %016lx %-13s %016lx\n",
+		       "r12:", vcpu->arch.regs[VCPU_REGS_R12],
+		       "r13:", vcpu->arch.regs[VCPU_REGS_R13]);
+		pr_err("%-15s %016lx %-13s %016lx\n",
+		       "r14:", vcpu->arch.regs[VCPU_REGS_R14],
+		       "r15:", vcpu->arch.regs[VCPU_REGS_R15]);
+#endif
+	}
+
 no_vmsa:
 	if (sev_es_guest(vcpu->kvm))
 		sev_free_decrypted_vmsa(vcpu, save);
-- 
2.46.2


