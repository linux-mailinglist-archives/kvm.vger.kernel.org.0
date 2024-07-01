Return-Path: <kvm+bounces-20812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B7C2D91EADA
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 00:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 272AEB20E3C
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 22:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0377E171676;
	Mon,  1 Jul 2024 22:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qneRMwLb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D3812C7FD;
	Mon,  1 Jul 2024 22:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719873279; cv=fail; b=QLZ3WZSim0WCaDiWJH346kO/4Xr9LiF6F1DwusRPV44K7ESEGMXcJYCanBaj0nlawF6vN4CS2NEtyG/HJT5peYulnnsPQnofYVGRCTgmyf2u5E/vjSyTAKG907ZDktYBn+/5VCaUxZ+Zucp1yX1DVz1B52KI7Do2wbbfgRIb9KE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719873279; c=relaxed/simple;
	bh=FSge3IxXRP2tUETEOVJ5Cpwcm6L72cMViHkUuOVapU0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Myvu9OwAi3JBPKzSAhFA4g7Uj+cR/gdJe0eXXBgs2ZDGT2OZbUyzZ0jhUgey4LTYvB0NWWYlXa6Spr24kkNXrCCvRE4i+jub3iXW8vYLk4czeU4QfsHi4i1g74JAwB9Zn0IVh3rIQmvYioSBoe8L6XeSm4NvktQhYann4Ihg+q4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qneRMwLb; arc=fail smtp.client-ip=40.107.237.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAio2V7s0EV/ZvV66/MtNB8w3WsTP/7N4y0wth3jOpmju+21Aiheh4PFTJab1fSOeJ6tojhHEqCcAkFvLkl+2YAJ8/K39bJOK17greyhNVukTTGkuCzsPy6TPU51G8890qqQdne0eKgZkS7jEJwDOHOsdV6MJaFdVQqUxLJeMiyQSb5R71Y0RxPoSHzMH1gJxNGq68lm5yYnCO0VhyxxiPISO3UWKXYn48Vz1RH4t/vUhta5sdufEqgypguZbdhooimmw7Ad/Kl0AmC13LDSGJkGrw6iPkZ8HMzJ/q6qEUTIctxp+6+Tin/HQkqUKQoC2DJ6ASQl8efJxYt1tMt2eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J4BnBFQgJ1XXc7UXeQkw/OAVrAgxVrDSCXkm8wIMhSQ=;
 b=fTe6XXWavH1sGqE3WN8cF5459HjDskVa4Rm9QOY0DdbVotiABOA3JHAjo/4p0NE4l5TnHd/td0Ka8eespjS545jQx9o/ObeTSfpuEkirij5zxaBQ6zVPFfqiiVAQHON82xNZJsLq+5zIVlL+WJ9YlGDPgpwI+t26iNHiKZa58Lo0XPT5Q+KxMQogJRdxi14OsTT9PZVobLUKZsBTIaFFO84t3UtdkUT1trF6qRjzsoC+kr/sRNjrf7kV1/cK+ZEzz8NrVdTYKpOcZRZyNVizsHAL1lcz3V40nUkGEpoPhYKOdBx7SBkhet+cbqgkuRnR74rogqfiO7wqwPy+0vGYbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J4BnBFQgJ1XXc7UXeQkw/OAVrAgxVrDSCXkm8wIMhSQ=;
 b=qneRMwLbwUAP6hR59WeCB/w75VRbWU81bENlbWWgFrl5E3WLCZuzJdbmbkMeWrLZt0hsWhjAB/6m4ax8m76Cuh5FTmbWJyUjrcIP8rsjuMagMJnzVDKFoYgmolwHUVh+6LVqB+g7jmRq3uyOKVJmia80DC15MnEF/a4RjbuAT9s=
Received: from CH0PR03CA0112.namprd03.prod.outlook.com (2603:10b6:610:cd::27)
 by PH0PR12MB7471.namprd12.prod.outlook.com (2603:10b6:510:1e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.28; Mon, 1 Jul
 2024 22:34:34 +0000
Received: from CH1PEPF0000AD75.namprd04.prod.outlook.com
 (2603:10b6:610:cd:cafe::65) by CH0PR03CA0112.outlook.office365.com
 (2603:10b6:610:cd::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.33 via Frontend
 Transport; Mon, 1 Jul 2024 22:34:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD75.mail.protection.outlook.com (10.167.244.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7741.18 via Frontend Transport; Mon, 1 Jul 2024 22:34:34 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Jul
 2024 17:34:33 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>, Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
Subject: [PATCH v3 3/3] KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
Date: Mon, 1 Jul 2024 17:31:48 -0500
Message-ID: <20240701223148.3798365-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240701223148.3798365-1-michael.roth@amd.com>
References: <20240701223148.3798365-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD75:EE_|PH0PR12MB7471:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c90c310-180d-4967-a82a-08dc9a1dfb4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9GofPwNoGzzY+dFZF/oYF87KllaNdomRoDmou76H25358XJ5ruDTw6zLoVzg?=
 =?us-ascii?Q?b2G1ShTG4o0W4gqHp5rkLKq4IROvu9vSMu7kDDzEmn1EVuz0AToZiDIQE3++?=
 =?us-ascii?Q?gLelD9Le6vNCXrY5M1ViMHZbH3WyNnMD/MBR5EminV9BuUUPOJIyT+39tc3Y?=
 =?us-ascii?Q?iX3FWSUDJcn2edT3xQrjTm0QFBVB1ddBzZZyl2LWQTCCAyKeRlBG3EL+GnZ6?=
 =?us-ascii?Q?+ntyKyAepc23JfeDhX3u1VvoX9zKYE/MxIDBtAsIxza46ioMd9OYsqp8wPjm?=
 =?us-ascii?Q?Rg4XGnVno3joUxXe5a6/uUG8Gjv26TRzNP9YW7qDR/U258bZXfnKFEk10wRb?=
 =?us-ascii?Q?zUNo+yaqNTD5PdQs6A+GqOeVgcTHam/AZZgoKdvI6bZBAmbnBlFcr0eAaX1C?=
 =?us-ascii?Q?Fab/TJaX6lAKiNaqV6Y0pxRNSFTrYaJ3ZwicBJa/3nYgWEmYnJthb6pGResw?=
 =?us-ascii?Q?mVnPb/F/+/p7Li3t9Dwe1CAbRTfaZzNmW8lJA4SLaOh5+JNgXUFQkzuwK4PW?=
 =?us-ascii?Q?vFewmCtP2tWgIFRNAWVaMJg8c/JXtzkm2r6YXbTfW80JZJFCQ1QWXoVRiTKl?=
 =?us-ascii?Q?0EEtffRKbFehQoRdkESTBer0MZtMbfZDnPnPufjleUNSNcTZHGUZYW9YkqjU?=
 =?us-ascii?Q?mW6ffMDJqZXOHON9cpZFaNfRpy6QH79CAtRh23IDNmibB7nE4Oq6M7JpoKcm?=
 =?us-ascii?Q?b5anBHXlgDQaSc3RXdQka0NX3IEMcUZb1y3YpzzDkris4CQ3QjyMKnjcMcc9?=
 =?us-ascii?Q?4lzSmmoPTINRt+plyqik6+bitSaTu9tGwHU8sVtaxN0neffCsk/WPUN459Lr?=
 =?us-ascii?Q?xN81PbxQMrp64be7GJyBeGG5KRwFyDC0ojIbdRZrXldT9mx/YPBCInVbD+nm?=
 =?us-ascii?Q?cFswmThrX/vKIHuaglaih+QXLErSBmar4tL+FN9nQ0a+6RZwmOMMr8ZYo/Yh?=
 =?us-ascii?Q?sSuCXmPDGNr+HjMmS+1kOxXfqo5aXg91vt+HJ1BiyD57IG82j/yt/U3PNVdy?=
 =?us-ascii?Q?O49NpxDnLHcdNabWafq0zwiGni491b9GCv3N5VsYz9q8HzBPDtXGYRm9MCtV?=
 =?us-ascii?Q?9arEsWTBH5zpvypPy6afNupd8jrr7uqqMP0l1mPRlBki78Lv1h77r2afMpDX?=
 =?us-ascii?Q?mz7PT7C12+zd02uYV73/b1spB32RmHr0ASHaZaMBioitYY88OpSDKoh6Q3Ub?=
 =?us-ascii?Q?ELZM0PXtoI8oluKjrdWgAGdy5WC51xgbYrK+85/z1WHtRy5TF49LO4ztr5A5?=
 =?us-ascii?Q?CCWUyDosPwtonVP0IWKbufzzf4bxbo9A6daO0PP5KIcImeno7z1U9+6NX28W?=
 =?us-ascii?Q?O+L9D/pJca9kucGWWxAO2P5RD1JjDsr8GzS8OjBtBPSkROl3vlHMgy134/24?=
 =?us-ascii?Q?4Zg8rqTJhZQJCLUqwTQoXWEZTnC2lPJ2ZUDZgRRwt9Wa7ekhpbhe7tmvdYsP?=
 =?us-ascii?Q?qBP2rLQ/ATpmeg4Bm9k+jclsVNXo9dUG?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2024 22:34:34.0017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c90c310-180d-4967-a82a-08dc9a1dfb4f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD75.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7471

Version 2 of GHCB specification added support for the SNP Extended Guest
Request Message NAE event. This event serves a nearly identical purpose
to the previously-added SNP_GUEST_REQUEST event, but for certain message
types it allows the guest to supply a buffer to be used for additional
information in some cases.

Currently the GHCB spec only defines extended handling of this sort in
the case of attestation requests, where the additional buffer is used to
supply a table of certificate data corresponding to the attestion
report's signing key. Support for this extended handling will require
additional KVM APIs to handle coordinating with userspace.

Whether or not the hypervisor opts to provide this certificate data is
optional. However, support for processing SNP_EXTENDED_GUEST_REQUEST
GHCB requests is required by the GHCB 2.0 specification for SNP guests,
so for now implement a stub implementation that provides an empty
certificate table to the guest if it supplies an additional buffer, but
otherwise behaves identically to SNP_GUEST_REQUEST.

Reviewed-by: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 56 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 190ee758dd6a..d85b724ce2ab 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3401,6 +3401,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 			goto vmgexit_err;
 		break;
 	case SVM_VMGEXIT_GUEST_REQUEST:
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		if (!sev_snp_guest(vcpu->kvm) ||
 		    !PAGE_ALIGNED(control->exit_info_1) ||
 		    !PAGE_ALIGNED(control->exit_info_2) ||
@@ -4070,6 +4071,58 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 	return ret;
 }
 
+static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct kvm *kvm = svm->vcpu.kvm;
+	u8 msg_type;
+
+	if (!sev_snp_guest(kvm))
+		return -EINVAL;
+
+	if (kvm_read_guest(kvm, req_gpa + offsetof(struct snp_guest_msg_hdr, msg_type),
+			   &msg_type, 1))
+		return -EIO;
+
+	/*
+	 * As per GHCB spec, requests of type MSG_REPORT_REQ also allow for
+	 * additional certificate data to be provided alongside the attestation
+	 * report via the guest-provided data pages indicated by RAX/RBX. The
+	 * certificate data is optional and requires additional KVM enablement
+	 * to provide an interface for userspace to provide it, but KVM still
+	 * needs to be able to handle extended guest requests either way. So
+	 * provide a stub implementation that will always return an empty
+	 * certificate table in the guest-provided data pages.
+	 */
+	if (msg_type == SNP_MSG_REPORT_REQ) {
+		struct kvm_vcpu *vcpu = &svm->vcpu;
+		u64 data_npages;
+		gpa_t data_gpa;
+
+		if (!kvm_ghcb_rax_is_valid(svm) || !kvm_ghcb_rbx_is_valid(svm))
+			goto request_invalid;
+
+		data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
+		data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
+
+		if (!PAGE_ALIGNED(data_gpa))
+			goto request_invalid;
+
+		/*
+		 * As per GHCB spec (see "SNP Extended Guest Request"), the
+		 * certificate table is terminated by 24-bytes of zeroes.
+		 */
+		if (data_npages && kvm_clear_guest(kvm, data_gpa, 24))
+			return -EIO;
+	}
+
+	return snp_handle_guest_req(svm, req_gpa, resp_gpa);
+
+request_invalid:
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+	return 1; /* resume guest */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -4347,6 +4400,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	case SVM_VMGEXIT_GUEST_REQUEST:
 		ret = snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
 		break;
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
+		ret = snp_handle_ext_guest_req(svm, control->exit_info_1, control->exit_info_2);
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.25.1


