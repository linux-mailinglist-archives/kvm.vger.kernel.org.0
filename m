Return-Path: <kvm+bounces-68182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6806BD24B96
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 14:26:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A0537309C380
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 13:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52BF739A7E0;
	Thu, 15 Jan 2026 13:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="seQ2F3VZ"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010010.outbound.protection.outlook.com [52.101.201.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A80E339A8
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 13:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768483298; cv=fail; b=JbHEDjluz02mwvQEmlzwA36A41qDMpbwVcVLpqj9pRhOGKjfgaBLBtkW64stx2B8yPhTyYhVFG0RuK3cwUwhnqTfMinuBcxy+dfgYE4DTubUs8fxxTUx0+uWkmGnYRWNbANQSG6gRaqrfpH5wTfpxEayi7b3RFX5WrnJJDEpAWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768483298; c=relaxed/simple;
	bh=NAW/C78VHq2tGSDNV/bijShLSZrZt1bgMOSySeAWgRQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZGdO5S+AlYYxP6rL3xPU7g188z6Ko2qy3NjD7+V6P5l2F8NgIZAfTg42frf/XyG/7k1//GhLWNKl69V9pDSzpWf5BQh/NGwqn6UYnZTxaXV/X4VXpHVAVgGL2Yks/yHVd9QgeqCQl8ukZHZhVboDYQ20Ctp1amr7plEwgr5a8z8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=seQ2F3VZ; arc=fail smtp.client-ip=52.101.201.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VNujDuEt7ttQ54dKrrc0aumnFOHvlL9iyj+F2x00jnJPFEv5yMl7/XdDuYUxHlWBUNvsxS1RWz2Qc4S+EH+67+K7FgSextbtqBBFUeXVXk/BCT8BdWNbkzZ/8nUFJ6+Lp4cPpgGM1Lcb4BAfQoj//raRThr5Z8RRpXIVqtgmxdMxqcYG2q9mnY1QWb+SPNRzjIt3387BlPhESeuxy5jOSE+MQK+NGEEPv2Xthw1QPoM1gDyjEWit6WNGIf53prjLKZsw/nbRN8WSSTks/95ZZUU6/qne7Bb8eu007vnlxvfwHJjEJz0V2GxG6tMZxP5DL5yjPphvrTZir811k5B0LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S446KWqe6kQmitMqO0/sVKo/dn/kGMxf1H7xJsKbqc8=;
 b=J31gfCPY6H1iJRtyJvB2C/sEcLC9g1hj60gpxphn3QTQXQ2BbJS6n/ySRVictIV+vfsEeG5KLIb/Axj4P9fPMgi+SbvyyJGT+MhVrgNNJ30Iu7X0h6YwdZHHuna3teVJwQrx35Z8kviwaNpx4pUXoHtp/SLXxXKSRK+IX6czcY7YSEto9l1JtivKySmbJ1boVPmvLgko0x/MEjsCb6k3kAnDAcDwZZaLNlWrO0Ae5/HLSxXvPKD6By1SH076SimtBAcySSR3A+2a6JO4HPBiiC/l1+WrsRHJa8ERdqMVeTpzMTkwr3iFgiKir8eU6z7hYL8RNKt+NiQ/5qLDQrbh1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S446KWqe6kQmitMqO0/sVKo/dn/kGMxf1H7xJsKbqc8=;
 b=seQ2F3VZTMKcNY2rNtrcEXdz/pG9bwFvAYDWGmhrokgWhSG/3JhC2mNFpY4Qhk1q+0nuaVkyP0oL/CrfxYLO5A8IgA5UYveFjI6BxRe87HrVH18u6nx4BUCyvOloCL0ZejOaFh3nMt9jel988hiHVDsGjdGrR+qZXYVcaCyVRaw=
Received: from SN7PR04CA0196.namprd04.prod.outlook.com (2603:10b6:806:126::21)
 by PH0PR12MB7886.namprd12.prod.outlook.com (2603:10b6:510:26e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Thu, 15 Jan
 2026 13:21:32 +0000
Received: from SA2PEPF000015CA.namprd03.prod.outlook.com
 (2603:10b6:806:126:cafe::8e) by SN7PR04CA0196.outlook.office365.com
 (2603:10b6:806:126::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.6 via Frontend Transport; Thu,
 15 Jan 2026 13:21:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF000015CA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Thu, 15 Jan 2026 13:21:31 +0000
Received: from xcbagarciav01.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 15 Jan
 2026 07:21:30 -0600
From: Alejandro Vallejo <alejandro.garciavallejo@amd.com>
To: <kvm@vger.kernel.org>
CC: Alejandro Vallejo <alejandro.garciavallejo@amd.com>, Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: nSVM: Expose SVM DecodeAssists to guest hypervisors
Date: Thu, 15 Jan 2026 14:17:37 +0100
Message-ID: <20260115131739.25362-1-alejandro.garciavallejo@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CA:EE_|PH0PR12MB7886:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fc1d660-ec85-4b90-8b43-08de5438ffc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZdSrk1J6tDtVohGA95/X3PdODmtAJuD7dupU8StjiVnoZHLFAD9kar5DRM+T?=
 =?us-ascii?Q?4zrOorHeCq5HULtgbah/iS/9aGdoc+POS4fFYmm6FGAOtFwZ1GZt5l0/bNfH?=
 =?us-ascii?Q?LeiJCgXuxyQBtZDWfQfSWWJi+L3zERMxecoZfhrdIWZZ6pL8hoBlYlwC9d+2?=
 =?us-ascii?Q?jw9r/b9RoocKtbQKplWI1Z+jMCLxKg3RdsAwiKLkYJULNrWm05cBmzML5R0V?=
 =?us-ascii?Q?8+VHSzEjtKXjuXeMwX8pwgPe1BiwpXqcvSqX7erJboBl+jDDlp4iXLTSOX2Y?=
 =?us-ascii?Q?4ohXnsDDcrByNcv/ZcPEGk8XydwhZn/CH7XMXazSRvKENXjfJqHxlfzoL3bh?=
 =?us-ascii?Q?7lp7g+i7itqf8avrBrFxIjyvvS3kKKK1kJAgl38QmhWvbY3O8uKcx/UT4ika?=
 =?us-ascii?Q?v0z1ME9hpwj722CJky0ltXL1ydvW9y0WMwVnB0skT83Z3qsLncTlPiMU9h1g?=
 =?us-ascii?Q?A/Yd+/by4Gzzy4z8bN3fW8fLXMDeSKQoS2jOYZIyazJH+B5OBrMm34buZ8zO?=
 =?us-ascii?Q?HtOPh+7FtLFfJH4SPv+rfhG/FKCs29hW3v+QVID8qAzNr8EndoKrQz0B3LBV?=
 =?us-ascii?Q?YYDb47FypPrfgfuzQ078IWTmCyk6yVvmjN40fkJDR5MFo111MFBNzznT11d6?=
 =?us-ascii?Q?ZaoHAaqkuxEYWmF6tumfhSH3j/RJ1BgsJ2+f74ljZKXFBkjDFgFXe6Ox1+pB?=
 =?us-ascii?Q?esV6pKQ44KM3soor4xcnwl27VHNlORLdPNiLFs5UpLd8IJnaB2rHVkTlRThy?=
 =?us-ascii?Q?g9BZxtadOKuYlAR1s3CGXeDyrFcaxtcO2gTccuePsrX0X4f7ahWFJyVVywh2?=
 =?us-ascii?Q?u9dVKFShNcQJuPJTSzR9jbEU4ePJyacn830x3QJXDrQnQ4D1dZsHSgCrINQe?=
 =?us-ascii?Q?o2hNtEDr9tB+wiu/WWHUT5PsO7VlJ7shQ8yu9ReAPVIT0ileY3aYXsaR8wtP?=
 =?us-ascii?Q?ar+gWxZzN/63gFr1XX9zaO5fTLS1lG2df1sl0PrJojcOAOTw0njDPP06ZwKP?=
 =?us-ascii?Q?IIMPH+L2haPJfQMIl4mBzzEHKDAZNfeLAA0Hmi5G9JWFDTg97ypmmK8HNCo2?=
 =?us-ascii?Q?RdaRLfJ+r1GbcqBEJSTSQ09qACdCR+fqfSHGqKdBkNlT12NSCDhAjUbEhebQ?=
 =?us-ascii?Q?krP8TYI47Bj32gPmTQDRe+TDC3XB+dDobq6s5mJ7p8/duzwzMpBwvCej8Ruc?=
 =?us-ascii?Q?uHrMT66yoBddZZI+E1cCa9mfPemPcsfWU1R87Uw2gGJ5k2/efeJ2aeirWfQc?=
 =?us-ascii?Q?qmlEC+mJO7KQ8uuTE4xn5eB+nc2NIJdIXUlkLuTqmle7u5jpFu2b0p7dBCki?=
 =?us-ascii?Q?00fp46NueJHcBZYa/p7ni7w2vSd1L67G6ItqZ3ahQXRu63HeNTPzWXKVCGiH?=
 =?us-ascii?Q?0RmQ0IZstbDuqEbLQYcsrDSG8p6cUFbrvdRwqVS/ETT9GaPADXndLls9pukX?=
 =?us-ascii?Q?IWS7CrhBzw7LvbpvIhjm0Ecnbh56l3BaeQXc1X/nbJEsgj8FRdGdqh76mZuY?=
 =?us-ascii?Q?kz/gyuejFX9+XmZsDtUwcd5Wc021l6WskxvXnwWB27x7nWgDAcyCsGpMVcC+?=
 =?us-ascii?Q?UG3fuP7bnzH4ycDpNDMssqe7RChu1Jn1ENZxDijLQGYac+j0Is3zLKyyN13G?=
 =?us-ascii?Q?zoiS2MdzTYupMCSJnO0lp+sUj4EPHFy1gMKGAMxPsl+D5dIYXecvkT9TE8rm?=
 =?us-ascii?Q?ugDrPw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 13:21:31.8821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fc1d660-ec85-4b90-8b43-08de5438ffc9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7886

Enable exposing DecodeAssists to guests. Performs a copyout of
the insn_len and insn_bytes fields of the VMCB when the vCPU has
the feature enabled.

Signed-off-by: Alejandro Vallejo <alejandro.garciavallejo@amd.com>
---
I wrote a little smoke test for kvm-unit-tests too. I'll send it shortly in
reply to this email.
---
 arch/x86/kvm/cpuid.c      | 1 +
 arch/x86/kvm/svm/nested.c | 6 ++++++
 arch/x86/kvm/svm/svm.c    | 3 +++
 3 files changed, 10 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 88a5426674a10..da9a63c8289e5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1181,6 +1181,7 @@ void kvm_set_cpu_caps(void)
 		VENDOR_F(FLUSHBYASID),
 		VENDOR_F(NRIPS),
 		VENDOR_F(TSCRATEMSR),
+		VENDOR_F(DECODEASSISTS),
 		VENDOR_F(V_VMSAVE_VMLOAD),
 		VENDOR_F(LBRV),
 		VENDOR_F(PAUSEFILTER),
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ba0f11c68372b..dc8a8e67a22c2 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1128,6 +1128,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		vmcb12->save.ssp	= vmcb02->save.ssp;
 	}
 
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_DECODEASSISTS)) {
+		memcpy(vmcb12->control.insn_bytes, vmcb02->control.insn_bytes,
+		       ARRAY_SIZE(vmcb12->control.insn_bytes));
+		vmcb12->control.insn_len = vmcb02->control.insn_len;
+	}
+
 	vmcb12->control.int_state         = vmcb02->control.int_state;
 	vmcb12->control.exit_code         = vmcb02->control.exit_code;
 	vmcb12->control.exit_code_hi      = vmcb02->control.exit_code_hi;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 24d59ccfa40d9..8cf6d7904030e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5223,6 +5223,9 @@ static __init void svm_set_cpu_caps(void)
 		if (nrips)
 			kvm_cpu_cap_set(X86_FEATURE_NRIPS);
 
+		if (boot_cpu_has(X86_FEATURE_DECODEASSISTS))
+			kvm_cpu_cap_set(X86_FEATURE_DECODEASSISTS);
+
 		if (npt_enabled)
 			kvm_cpu_cap_set(X86_FEATURE_NPT);
 

base-commit: 0499add8efd72456514c6218c062911ccc922a99
-- 
2.43.0


