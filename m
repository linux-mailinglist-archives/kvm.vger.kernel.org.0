Return-Path: <kvm+bounces-17231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 522C58C2BCE
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:24:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06A4C28237D
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0421213BAFF;
	Fri, 10 May 2024 21:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="By3jjYh4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7FC47F73;
	Fri, 10 May 2024 21:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715376220; cv=fail; b=jMUszuBqUnvT45V4kY3Gf8sdSGB2kUYg95NIXFLC1VXKr0RLK5cf4++uhwlXiKkw48yHAFksobEe8B6rihfUXzI967EolvPWxKJKwwfCe7vUbcVYB5+tXcEhvOZe0UbdlJzYuXfyhj5LxHPSI6FDyQ59G6s4lx7SjJSNsrCuZCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715376220; c=relaxed/simple;
	bh=/Y+yuhBB4Lu35FxJwguWauoRHm4z+zPgmLPfYJFqTXw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m1llX0BXf6eU34bTr3N4Y7QuuDUoz9IUgjFdPAamA7ECqyP38C3Gp6geEkMf/QB8KgvLPodF5sGWwtMIjKFhaXlA7GJdEaCUzANANdPIRy08ObaNaXcrwdqWr2qKXsYsgJz3b36GGxvvz6oSV5+oMymMO85suCGZscMteyNQmCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=By3jjYh4; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IMOdz7r76reahdeUu+/M2f0GvolEA5H8Tx1Z61qmkyRgJDk3DnisXRt76cV8jX7J/9wqq8psAENP52Ga9xUaWgKb7JkgcbU85AO/9frpCAsHkAPeUgDc+AnGwCj0JCXuphXyh5Rqd5hldG0s7u1qJH7Gfasyq5BGSOLvE/v4bWGDZMx4ORJuj7iLUEJrceirimhDOjfBnxw4r0dYXERwubtwLcyDuAKkwTYx6pLYIJDjmlZ/jkIBMLJ07Y7AUvpO/epp/LHYrqegBKHThvBjT+f3zVwh6jAVlF9uAl7JbeSfDH4tQh2j+Brd41a0jKoPeTU6IjQrXb8CmO2k6KzvkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5D+oWe6D6ngXvlw2NKp1v0+rio+C79MB1L6SRyqdx0c=;
 b=n/CXSuQ+J5xmjR1ev/i6F/Xz6BC6OREMWi/Dl6t8TWEjzu75mFqiN+nssOJkaCXOXu7OHgRqMZ5c4v5NaFOqnxiPPipfe/NjMo2CvF8oR06izONzDe3MRwf08eGtBV2ZHlAs5n3tlTmkckoQ97pbDDQ64uV3RBvaO48MZj5OsQYnd2j+hHoyrty2djocw6vfIsNA43/rAwKRMtajMhxU5IiioHpxa3r9VHzh71i9oKBGiqzZ6PNlOCPa0SBh/dy3ImCjYgYFePsbDIhBb3/lPvRrb3UVOppRteFfDtWhBrrfJuPF5/W27FvFrx09E1jqD6nRu0Myrm8ljmMq1EcsnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5D+oWe6D6ngXvlw2NKp1v0+rio+C79MB1L6SRyqdx0c=;
 b=By3jjYh4o0s2i0v81IsB8gCv4mHKK++dr3YtG+eP2/LTMPMNffuy1vGQPjQlcvRlthMw5LK/Z/bkn1vcXIeW5iEfCoZpiyPhQPBXuct1LbkhwkG0n1EhSOX0xiHCkc9NyodyehDX5guA9o0fLcdeJOrToynkKbVZ6CwMt0M2CU4=
Received: from BN9P223CA0029.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::34)
 by PH8PR12MB6794.namprd12.prod.outlook.com (2603:10b6:510:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49; Fri, 10 May
 2024 21:23:32 +0000
Received: from BN2PEPF0000449E.namprd02.prod.outlook.com
 (2603:10b6:408:10b:cafe::49) by BN9P223CA0029.outlook.office365.com
 (2603:10b6:408:10b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.48 via Frontend
 Transport; Fri, 10 May 2024 21:23:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF0000449E.mail.protection.outlook.com (10.167.243.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:23:31 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:23:31 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, Brijesh Singh <brijesh.singh@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>
Subject: [PULL 08/19] KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
Date: Fri, 10 May 2024 16:10:13 -0500
Message-ID: <20240510211024.556136-9-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240510211024.556136-1-michael.roth@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449E:EE_|PH8PR12MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: dc58ce26-4428-4294-0989-08dc7137715a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|1800799015|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pOYScWR00cIW+iDNAFzeXRnNP9usBTLmnyYdau3x3j5oE3oz5QxTafHk3st+?=
 =?us-ascii?Q?HtxMKxLtKlkPb2K3mZ/VIZaRi12fl7qjDgo0E+LXdP34bNMxKile35Ap48Mu?=
 =?us-ascii?Q?UMvgSyzfCnQ6gGkDeCjhcS2BkP8YzBcQrQgf+vlcpBd/f7ekV3xhtSKvplJm?=
 =?us-ascii?Q?SxvMtlRBL2kXPcmHUC2I3WQ7IkI6i842zteoJD2dXzB0FQ+zGV9XnzEUIsep?=
 =?us-ascii?Q?iGxGCDdroqDypNwm5oZ6Y8skzYFkFyuuGrwUtbAxX84Vy/8ir/2HDYQ+NBp5?=
 =?us-ascii?Q?Wy7TT18YfSRF/mLshYNjP8nNxQQ8VL1jfGTwBLKYYIOTBrdCa+OxQRfNvjPS?=
 =?us-ascii?Q?WQBnKjp4c1GUACFLERIKYDpOE81H3ra/BTKgHZ/oIV4bMeLV/XaSk2p/pkZk?=
 =?us-ascii?Q?5HZWK96FHyEvz1BssqXYzW4tlsaSkB+67FZEmqva+/AxrT9x6jNSlR21WuGe?=
 =?us-ascii?Q?Im1B1Nx6mqgheblxxo39DFvNR9t17OW1vqbRuss/BXILSKOFOLMrujeFagdI?=
 =?us-ascii?Q?XLP6GjMZ1MKb3Ttkc8zkcTn6e6ncGPuDR3OptO2OeM0Gg3kGYW1b0mphpUFH?=
 =?us-ascii?Q?RgTTqe/s8oS5DQg9qKbBqEsojdsuCVrNncFIgQVqUNWjXzeHxGDDEmf4gktZ?=
 =?us-ascii?Q?/dVDpu5tYoCOQExx+LDTjNjt5WFrawtQ9FEZ2zqC+ssvBalFILmso+LPTdy4?=
 =?us-ascii?Q?bxupe0EsxHCrbzZ/u6OcxWhGDEcVaTUSx6qoOjcQVkj3tLjb4TeUPkgzThi8?=
 =?us-ascii?Q?nGXfikUyLzPVXFjTvEDhJ1cCRdnVF5hyh1mMrZhDQETPytOdi44MHoXdgSO8?=
 =?us-ascii?Q?eOsEwNbc+qZqB4WTMnbpuyikOxOWPoqfQW1JeFsY8k4OPdZ79cDCT54mLrwZ?=
 =?us-ascii?Q?9e7w6HZGD0qNGowtVog5yeJQRaq6kstQgKEFe8sXQ872muKZcCK26fpU9tRl?=
 =?us-ascii?Q?JPD2szfQWzYk+QIgwdDupvj7Df7PeRJXTFfQoRw514Z5fl+htW9YbhERibKz?=
 =?us-ascii?Q?mEYo+llsZPlaFXi4DzEOvbA6hUe+iqDZ+h18hW11Knb7A3GAy05j/5GF0Vio?=
 =?us-ascii?Q?kCGCLRWMsmg8bDuH2eGPvOIBLJ9tOLQsGYC6pPJtIDs2vMLzceFlHXjonJLB?=
 =?us-ascii?Q?ntGmUXxZswo/Tr4NNZCCZg8b6O5u5Pb0LPECsY9jRpPVstllPU8oRgewc4Y/?=
 =?us-ascii?Q?rs5YM5kKGWiFhhYIpdhHxHG/IRrlVV9412WTRb7e73L3Upzn6bl7SvdYszMQ?=
 =?us-ascii?Q?HTEJge0t4Byw3Tw87vec4QCU03U2TKF8QWVzCOU5zlwxIblL+25si3+u5/Rn?=
 =?us-ascii?Q?Q2cR/OPyGk4FCsp78Ud0mOL8kf3/cebXCCqneQ1ebBjQ2+Nfd6nDCQSCPf3T?=
 =?us-ascii?Q?v5LZKZLeJ4CZ1bmVcvii+7Dbajc1?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:23:31.8165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc58ce26-4428-4294-0989-08dc7137715a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6794

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change MSR protocol
as defined in the GHCB specification.

When using gmem, private/shared memory is allocated through separate
pools, and KVM relies on userspace issuing a KVM_SET_MEMORY_ATTRIBUTES
KVM ioctl to tell the KVM MMU whether or not a particular GFN should be
backed by private memory or not.

Forward these page state change requests to userspace so that it can
issue the expected KVM ioctls. The KVM MMU will handle updating the RMP
entries when it is ready to map a private page into a guest.

Use the existing KVM_HC_MAP_GPA_RANGE hypercall format to deliver these
requests to userspace via KVM_EXIT_HYPERCALL.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Co-developed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Message-ID: <20240501085210.2213060-10-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/sev-common.h |  6 ++++
 arch/x86/kvm/svm/sev.c            | 48 +++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 1006bfffe07a..6d68db812de1 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -101,11 +101,17 @@ enum psc_op {
 	/* GHCBData[11:0] */				\
 	GHCB_MSR_PSC_REQ)
 
+#define GHCB_MSR_PSC_REQ_TO_GFN(msr) (((msr) & GENMASK_ULL(51, 12)) >> 12)
+#define GHCB_MSR_PSC_REQ_TO_OP(msr) (((msr) & GENMASK_ULL(55, 52)) >> 52)
+
 #define GHCB_MSR_PSC_RESP		0x015
 #define GHCB_MSR_PSC_RESP_VAL(val)			\
 	/* GHCBData[63:32] */				\
 	(((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
 
+/* Set highest bit as a generic error response */
+#define GHCB_MSR_PSC_RESP_ERROR (BIT_ULL(63) | GHCB_MSR_PSC_RESP)
+
 /* GHCB Hypervisor Feature Request/Response */
 #define GHCB_MSR_HV_FT_REQ		0x080
 #define GHCB_MSR_HV_FT_RESP		0x081
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 557f462fde04..438f2e8b8152 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3461,6 +3461,48 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
 	svm->vmcb->control.ghcb_gpa = value;
 }
 
+static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (vcpu->run->hypercall.ret)
+		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
+	else
+		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP);
+
+	return 1; /* resume guest */
+}
+
+static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
+{
+	u64 gpa = gfn_to_gpa(GHCB_MSR_PSC_REQ_TO_GFN(ghcb_msr));
+	u8 op = GHCB_MSR_PSC_REQ_TO_OP(ghcb_msr);
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+
+	if (op != SNP_PAGE_STATE_PRIVATE && op != SNP_PAGE_STATE_SHARED) {
+		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
+		return 1; /* resume guest */
+	}
+
+	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
+		set_ghcb_msr(svm, GHCB_MSR_PSC_RESP_ERROR);
+		return 1; /* resume guest */
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
+	vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
+	vcpu->run->hypercall.args[0] = gpa;
+	vcpu->run->hypercall.args[1] = 1;
+	vcpu->run->hypercall.args[2] = (op == SNP_PAGE_STATE_PRIVATE)
+				       ? KVM_MAP_GPA_RANGE_ENCRYPTED
+				       : KVM_MAP_GPA_RANGE_DECRYPTED;
+	vcpu->run->hypercall.args[2] |= KVM_MAP_GPA_RANGE_PAGE_SZ_4K;
+
+	vcpu->arch.complete_userspace_io = snp_complete_psc_msr;
+
+	return 0; /* forward request to userspace */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3566,6 +3608,12 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_PSC_REQ:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto out_terminate;
+
+		ret = snp_begin_psc_msr(svm, control->ghcb_gpa);
+		break;
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
-- 
2.25.1


