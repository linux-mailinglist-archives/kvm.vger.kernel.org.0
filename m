Return-Path: <kvm+bounces-51021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D4D0AEBD5B
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 18:30:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A42B18835A6
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B0842EB5D3;
	Fri, 27 Jun 2025 16:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GYJHWJOj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DC52EA470;
	Fri, 27 Jun 2025 16:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041618; cv=fail; b=i/kg4PtygZZxcIXdy/J8814IHHijh23skjb/shAeKP6BFNuStxfp1RfTutByI4c8iw0ixYwbLWb7LcF3eRaFMY9rLwBb4JwuJaDDDWMIOb5/5Qq7zZYT37F6ggzBSlcGgCc2HvB1EQ4eS608RG26pZWHpBojqLq6xSEaSaglnH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041618; c=relaxed/simple;
	bh=zurdBQT4rcMlfW4bRtIaYoyZaYyUBt49+bkLFDEksC4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RyB6flNHIIy8IOK5H3Fy55dGUFETfEAGDSk6qESFeLxDdnvUysCrCd9B5xzbELTd4M/Ysy42u+m5d5rYM2m2m75nN5ev5BWa3+zLIN54JqF89qctHBVDhzTGZRCsQ5RoXmzqQKTpBvTnAOAjcqJSixDPkrH+q5o5Db8U6nCyUaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GYJHWJOj; arc=fail smtp.client-ip=40.107.244.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U7/ZWep1O1BQFtUTq+AxrDeLfvwmuBukCu20lrgAhEvczgg7Qz3aPdLYLaxc6uVcqppQvUwmTJdaWUWMBYIXPlkB4nSj4ihGUMM8FQEd5bghfmJ1oqPUFPeee2h33J+usJ7+xmFOgT/zBFnsHmIWE9e1ptsSz3qoyarBcRLrh8J+tjFmRvr3Nay1z8p2sLCPHodzZDp6jNhDK48kb+nyDIUaZZ+ZVs7yxPQPqYg8ByzQqyCNpZRi1hvUEGbwLPtSiDWRpxP1owoq9mp7UgQKf9AihSgGTmFw4akeZiSrJplbi8wCh3HimDwDegohdqmVrwoXXtHGjNduCYZXCNOP5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PpaO2lZA2b5Re9ORySZFTtSTOeLVnYSktduK4Djjt+s=;
 b=XgJ/dRIPvyB104A/0F2SakuwoVx6RtOHqdmeVGJE3qiqMThMn1wibRkBYvVjPjqU3uMQnaJFxgUd1dwG/zthrVWdlAx2rOboFUTlqt0E41gTC9GvS975JrdVj4i3eAXTK8NLpCHl7TrJrZhDEMmozzXg7crb+7ZusrES1znAwlyuTfW1MmJ7r1q9Ik9YbJxHNmL68n6cbOhTdFhSV9DBp+3kckZpn5v6IWJJJRGtZsDym+sPIAB5Su1CjC0zFsCDH5WHOXmq03jE4JKEACU8Iaxk1FAaa9E3QEuTIYoWxSYMpl9RRt7zSrkZLXzZC6gSku6/kQrFPutucu+7GPS9HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PpaO2lZA2b5Re9ORySZFTtSTOeLVnYSktduK4Djjt+s=;
 b=GYJHWJOj4H8Gckq8lat0xGq4ifouOtuu8pIrNAmThrsW8ghKJHC+F9Vh74nMb2xtKwfoLxltfdW/BSvWQILdqWCLtO0ZJs8S2LQ1zqrTe/MpQIW1avgVw8mVUHgs+Q1iRp5k8J6z1YLOFtFIGcYdfSHqOKVOOFXzLnm9Jri2c6I=
Received: from SN4PR0501CA0003.namprd05.prod.outlook.com
 (2603:10b6:803:40::16) by IA0PR12MB7774.namprd12.prod.outlook.com
 (2603:10b6:208:430::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.32; Fri, 27 Jun
 2025 16:26:53 +0000
Received: from SN1PEPF000397B5.namprd05.prod.outlook.com
 (2603:10b6:803:40:cafe::28) by SN4PR0501CA0003.outlook.office365.com
 (2603:10b6:803:40::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.11 via Frontend Transport; Fri,
 27 Jun 2025 16:26:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B5.mail.protection.outlook.com (10.167.248.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8880.14 via Frontend Transport; Fri, 27 Jun 2025 16:26:52 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 27 Jun
 2025 11:26:48 -0500
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v1 09/11] KVM: SVM: Add support for IBS Virtualization
Date: Fri, 27 Jun 2025 16:25:37 +0000
Message-ID: <20250627162550.14197-10-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250627162550.14197-1-manali.shukla@amd.com>
References: <20250627162550.14197-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B5:EE_|IA0PR12MB7774:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ca264ee-b0dd-411e-e921-08ddb5976ce5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmNlK1Q0SERjOU5YNjc1cHc5Skl4MmxWc0k3bUljelhVV0VJUFpPNGpIWW1X?=
 =?utf-8?B?UHZOdmlkd2tJTVVFZHYwTkRjQTdwOGM5bW5uT0t5SEt1QmNKdy9WQXZ3ZG5X?=
 =?utf-8?B?alhjU3lSVGNTbHFRL1R3TEh5T0JYNUZNNVBiVis2Ky9aSllEdklkU2dDblMr?=
 =?utf-8?B?UHlaQmg4Vi8rSnpZaVNBMEwvdVFpaEI4YVhIUjFhSDJRRnF2SHBPc2ZYeFZa?=
 =?utf-8?B?aXJiMTZPc1pORnU3dEE2VmRraVJ0b29vaGNCVE01R2Y3ZW5HVEM0U2FjdzVh?=
 =?utf-8?B?b0UvZ0tGeUVEQUcya3B5SUZnZzcwYWlWTFJpb3FMa2J5MVo5UmZKd29kcHFP?=
 =?utf-8?B?Y0pza2E5Uk9WZXJ4WGZtdzBjbFRBeG9na1hLOG1iYWZtWVpFcWFObXdtUURF?=
 =?utf-8?B?OC9YUFRIaGxYaW92SURBV3A0Ri9oSnlGak9RYmsxZ0FOK0JlWDRHZXpHTStD?=
 =?utf-8?B?c25ESUZpenh6N01tZXNKQzZ2Z0N1T1hwZW50WWxQSHJyQVRTbktqUk5sVWcv?=
 =?utf-8?B?YVhyUlhCZzBYOVU0ZER3b0x6bVJyWFd0RWRTT0FoNi9ReDNwMzczcW0rSXZw?=
 =?utf-8?B?cDZQc1NyS1psZGdZdTQ4U3l0dE01TElnSE5yd1NMTUxaOEpvSTNYSWpIOFhQ?=
 =?utf-8?B?VzNFWnpobUh0QW1naFNUWkxIRVdaUVZBYlVPV1NrMTlHQW8vcmNjVWlRWTRM?=
 =?utf-8?B?cXY0WkkyU24yN3VObU1yd1phdnhpTmkxSzYrMDlSbXZRWW1acWFHcG9oazBQ?=
 =?utf-8?B?d0lSc2VUMG9TZkhuRVFKNk43MURXeFdMWVh4Z0puY2QwYUhvanRrdmlJdEFZ?=
 =?utf-8?B?K2thMDZTWmNVQm5ZbWJJM2hwTWpmZUFaS3hWdHlzcGxDdFFxNk9QbnVmVXNF?=
 =?utf-8?B?NVZQY2wwZDloQUxDR1A1U2M3aC9ZY25laDFETGpVQ1Zib24zOXh0V3VmRUVZ?=
 =?utf-8?B?YmJsSFNCamM0TnBlQUthQVFMMkY2Vi9EZmdVTXBsa1R3ZzcwSVhxa1QxaWZS?=
 =?utf-8?B?bmNRL0drZWhLaHdtMjVJSC9WSE9RUkE0QjNJeEJUY0VKaHNTQ2Y1dzIvQTF5?=
 =?utf-8?B?MVlzYk1NOEhmSVFhQkt2bGdreWp0NUtGeERTR01kMzJXeGxmcC9rMGRWNjgr?=
 =?utf-8?B?WEpMUFA3UGNKRXM4TmwrTmplSnlqcW1qc0hWVXdMbG96ekF5YXBpVW96a21m?=
 =?utf-8?B?U2cweXg1aytGS1BtWmY2dU40RXQyYXNHYzVsWEZiYzc0NjRJVk0zL3VoaFFw?=
 =?utf-8?B?ZlhnYWhTOVRKODU5OGc2VlQxMUdPVEJqSVhVaDlZZnZ1NDZteFBPSWdocFor?=
 =?utf-8?B?QW1ZbFZQdHczcXMwL3JJaGp3YWtMOG5yN2l0cENncktRREZJZnRJMDlZd0Jj?=
 =?utf-8?B?a294d1JzYkp0RTJBdnYwOXl1TkttTE1MVUVndHJ1dFBEN3RrNitNMTRjcE5P?=
 =?utf-8?B?cE4wSkQwQndOR2dsaEh6aERQTEV5TjUwUlkvSHRMbVV4SnFKenBnc2hoVmlr?=
 =?utf-8?B?VmdlUS9QaDJaY2xBblVQMUZkell2RGpzYkZqRTVPWXgvWE1CdGxvbGkwMmRw?=
 =?utf-8?B?NU9RQ3dsWHMwRXFBc2tobFBRckFhT3BTemJBRVc1NUNTSnF6UTRmVmQ0SFRa?=
 =?utf-8?B?VnVjU1NpK3NXbGhyeStMQkVmTllPdjU0WU9XZGRIamY3UmtkM3YvVDhVVzdj?=
 =?utf-8?B?V1piMWlYbVJkMUN3akpxZ0ZuUWdRcGJmYjFVcEdWRFFCRkF1THUyTGh3MjdP?=
 =?utf-8?B?SEhRaVZPNkdqSVlNK0NVMUdtc1dyOUxXb3VCd09GdjExYS9OY2dCWkhvbGMv?=
 =?utf-8?B?VUFxK2Z3RFZFYVdrYlNldXYvYUtlbzJ1QktQWHJ3MWZvZ04zTE52OE5OUHFy?=
 =?utf-8?B?dmY2T0tVVmFjOWVKdDhOOExVMVZNVlFyMFlkU1J3OHJZSUkvdTJUbFZ5bW5z?=
 =?utf-8?B?S0dIOHhaLzZIOE0yQUkvUlRxR1VwWGoyUU5XaUsrMGFxVk1tcGkwS3VMVGZa?=
 =?utf-8?B?YnBaVm5zcndPYStLeXAwd1RtMFRWeFhKNHVhcHRLR1ZKNnB2UndPViszZzcv?=
 =?utf-8?B?b1VTRjlvcGcybkFSNEYwZVRZZmVJVkhaMHFVQT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 16:26:52.7526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ca264ee-b0dd-411e-e921-08ddb5976ce5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7774

From: Santosh Shukla <santosh.shukla@amd.com>

IBS virtualization (VIBS) allows a guest to collect Instruction-Based
Sampling (IBS) data using hardware-assisted virtualization. With VIBS
enabled, the hardware automatically saves and restores guest IBS state
during VM-Entry and VM-Exit via the VMCB State Save Area.

IBS-generated interrupts are delivered directly to the guest without
causing a VMEXIT.

VIBS depends on mediated PMU mode and requires either AVIC or NMI
virtualization for interrupt delivery. However, since AVIC can be
dynamically inhibited, VIBS requires VNMI to be enabled to ensure
reliable interrupt delivery. If AVIC is inhibited and VNMI is
disabled, the guest can encounter a VMEXIT_INVALID when IBS
virtualization is enabled for the guest.

Because IBS state is classified as swap type C, the hypervisor must
save its own IBS state before VMRUN and restore it after VMEXIT. It
must also disable IBS before VMRUN and re-enable it afterward. This
will be handled using mediated PMU support in subsequent patches by
enabling mediated PMU capability for IBS PMUs.

More details about IBS virtualization can be found at [1].

[1]: https://bugzilla.kernel.org/attachment.cgi?id=306250
     AMD64 Architecture Programmer’s Manual, Vol 2, Section 15.38
     Instruction-Based Sampling Virtualization.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Co-developed-by: Manali Shukla <manali.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/svm.h |  2 +
 arch/x86/kvm/svm/svm.c     | 94 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index b62049b51ebb..1df51cf19ba9 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -222,6 +222,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
 #define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
 
+#define VIRTUAL_IBS_ENABLE_MASK BIT_ULL(2)
+
 #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
 #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f9a7ff37ea10..9340d3d3d1fe 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -154,6 +154,10 @@ module_param(vgif, int, 0444);
 int lbrv = true;
 module_param(lbrv, int, 0444);
 
+/* enable/disable IBS virtualization */
+static int vibs = true;
+module_param(vibs, int, 0444);
+
 static int tsc_scaling = true;
 module_param(tsc_scaling, int, 0444);
 
@@ -954,6 +958,20 @@ void disable_nmi_singlestep(struct vcpu_svm *svm)
 	}
 }
 
+static void svm_ibs_msr_interception(struct vcpu_svm *svm, bool intercept)
+{
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSFETCHCTL, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSFETCHLINAD, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSOPCTL, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSOPRIP, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSOPDATA, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSOPDATA2, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSOPDATA3, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSDCLINAD, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_IBSBRTARGET, MSR_TYPE_RW, intercept);
+	svm_set_intercept_for_msr(&svm->vcpu, MSR_AMD64_ICIBSEXTDCTL, MSR_TYPE_RW, intercept);
+}
+
 static void grow_ple_window(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1095,6 +1113,20 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
 			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 		}
+
+		/*
+		 * If hardware supports VIBS then no need to intercept IBS MSRs
+		 * when VIBS is enabled in guest.
+		 *
+		 * Enable VIBS by setting bit 2 at offset 0xb8 in VMCB.
+		 */
+		if (vibs) {
+			if (guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_IBS) &&
+			    kvm_mediated_pmu_enabled(vcpu)) {
+				svm_ibs_msr_interception(svm, false);
+				svm->vmcb->control.virt_ext |= VIRTUAL_IBS_ENABLE_MASK;
+			}
+		}
 	}
 }
 
@@ -2871,6 +2903,27 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_AMD64_DE_CFG:
 		msr_info->data = svm->msr_decfg;
 		break;
+
+	case MSR_AMD64_IBSCTL:
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_IBS))
+			msr_info->data = IBSCTL_LVT_OFFSET_VALID;
+		else
+			msr_info->data = 0;
+		break;
+
+
+	/*
+	 * When IBS virtualization is enabled, guest reads from
+	 * MSR_AMD64_IBSFETCHPHYSAD and MSR_AMD64_IBSDCPHYSAD must return 0.
+	 * This is done for security reasons, as guests should not be allowed to
+	 * access or infer any information about the system's physical
+	 * addresses.
+	 */
+	case MSR_AMD64_IBSDCPHYSAD:
+	case MSR_AMD64_IBSFETCHPHYSAD:
+		msr_info->data = 0;
+		break;
+
 	default:
 		return kvm_get_msr_common(vcpu, msr_info);
 	}
@@ -3115,6 +3168,16 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->msr_decfg = data;
 		break;
 	}
+	/*
+	 * When IBS virtualization is enabled, guest writes to
+	 * MSR_AMD64_IBSFETCHPHYSAD and MSR_AMD64_IBSDCPHYSAD must be ignored.
+	 * This is done for security reasons, as guests should not be allowed to
+	 * access or infer any information about the system's physical
+	 * addresses.
+	 */
+	case MSR_AMD64_IBSDCPHYSAD:
+	case MSR_AMD64_IBSFETCHPHYSAD:
+		return 1;
 	default:
 		return kvm_set_msr_common(vcpu, msr);
 	}
@@ -5248,6 +5311,28 @@ static __init void svm_adjust_mmio_mask(void)
 	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
 }
 
+static void svm_ibs_set_cpu_caps(void)
+{
+	kvm_cpu_cap_check_and_set(X86_FEATURE_IBS);
+	kvm_cpu_cap_check_and_set(X86_FEATURE_EXTLVT);
+	kvm_cpu_cap_check_and_set(X86_FEATURE_EXTAPIC);
+	if (kvm_cpu_cap_has(X86_FEATURE_IBS)) {
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_AVAIL);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_FETCHSAM);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_OPSAM);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_RDWROPCNT);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_OPCNT);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_BRNTRGT);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_OPCNTEXT);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_RIPINVALIDCHK);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_OPBRNFUSE);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_FETCHCTLEXTD);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_ZEN4_EXT);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_LOADLATFIL);
+		kvm_cpu_cap_check_and_set(X86_FEATURE_IBS_DTLBSTAT);
+	}
+}
+
 static __init void svm_set_cpu_caps(void)
 {
 	kvm_set_cpu_caps();
@@ -5300,6 +5385,9 @@ static __init void svm_set_cpu_caps(void)
 	if (cpu_feature_enabled(X86_FEATURE_BUS_LOCK_THRESHOLD))
 		kvm_caps.has_bus_lock_exit = true;
 
+	if (vibs)
+		svm_ibs_set_cpu_caps();
+
 	/* CPUID 0x80000008 */
 	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
 	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
@@ -5472,6 +5560,12 @@ static __init int svm_hardware_setup(void)
 		svm_x86_ops.set_vnmi_pending = NULL;
 	}
 
+	vibs = enable_mediated_pmu && vnmi && vibs
+		&& boot_cpu_has(X86_FEATURE_VIBS);
+
+	if (vibs)
+		pr_info("IBS virtualization supported\n");
+
 	if (!enable_pmu)
 		pr_info("PMU virtualization is disabled\n");
 
-- 
2.43.0


