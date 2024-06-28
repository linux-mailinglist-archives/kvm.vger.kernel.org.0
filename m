Return-Path: <kvm+bounces-20693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 149C491C65F
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 21:08:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96B8B1F22951
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 19:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 359C16F30F;
	Fri, 28 Jun 2024 19:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DOBm89el"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2083.outbound.protection.outlook.com [40.107.236.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C650B78281;
	Fri, 28 Jun 2024 19:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719601655; cv=fail; b=gxLPoSOSqsP+tytSWQiBSxzPy/B3cQeyUJHh3cQKSuiVNABlwyQp5GzJf9mt2cKH+oJUNNV7a/vW58isSsqmgZxevXRxfWjdb+MuucGqBa32yADmXcEirqcsdnKk1mL1RkhpWKOPkSYn45luhHUOsaNmx5xJhFE3f6KcWkwTi8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719601655; c=relaxed/simple;
	bh=Eeqceq0SeJ37f4GPhUhjTSkCYVo6kcvTjyOHFuPullU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LRt2EqOG3Xg6HnOhbg7tOJzTn9Ac9NvVqSwQVWO1s3ksrA2tTGXkYEkYbgjLsDBfO/jSOGZlnm/VndcfKboU/8qfJW6UvgRYaUy61TVYRcLv5V2elBnDpHYdwNYafxs/hEPg03TcoqjlhnBEoi/BruNO7d/dbXF0qTtsfiCHGV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DOBm89el; arc=fail smtp.client-ip=40.107.236.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrgNtGMALoPgmaod04t6tvk0Ju54RDiKL2iFX223k7fOCo/QpiayDPe2FjftUV0uKypMMlffwMfKP/H5HI4sSGZ4UQeoOZx49BD/LqNzXGexaS5ataUqqRjuSOCxjEMpdTaCp/4QL3YjThWRiGRvdJ0TxOSNsbpzqasYK42I5PG39Unl5N31BtDEQ1hF0vo21/wbtoD+329bl0/9bWQAUbmfWfsSdkP526JPWW6NBPZKxc2CJehV3DwPvWgaFUI9AZmCZRoMkk1w9Y36kM790NLpUjje2+m28VfbEEbBYaTizwORUXc9sRmo67RQESgQ8ZXaILTFlsw9Fe9Iqa6Dyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+bSey/cRyS7o7nBgiSv/YY3s90CKv+EBiQH1FQvUk8Y=;
 b=mW/fzs2Jkfi+zVmldIiWm3DW5gr9bifoIvlEojU8/y8/dRXVLyDOyXChdC+YkQwDoXMTyDQn1b5jVYkBu/OH5Eswwn0MjwVCiowbz+LKApnGin6Jza9TSBRHfPaK/TrtchO4QNaGzbjlYhjiRe/A5ycdp0CDBNSi8lABBtm8TlxDrlsP9fB6s7ydAvOlEmtl4NRhxQxiozmTW/rRJUdJn10VSS/x8jXtbPhPD5TEMbQwgIyHEq4Bu9oECd2Cc643A76vlcfFnknyEdjITyD5TTkyZHVYcXRG3QrMqYHv5nQSOE9NfXrpNlVDSSTXa81stROcHP8M+rggiS1lPnh1ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bSey/cRyS7o7nBgiSv/YY3s90CKv+EBiQH1FQvUk8Y=;
 b=DOBm89elqwM0GjW+3+7jwhNz+4SMLZnEbVJq20shlzH0bwNjsDu9HuzluQ/2dA5nVMy+uXJIZ5/yiqtzBp9bMMTdPqUXCcOpN6xabUum7bxmTvUlnC5vaoDSsghTPObyZ+BhzZfDeUdf2rnL+NqLi1p4y68vy0Gn+eDSfJ7Fq6w=
Received: from CH0P221CA0031.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11d::13)
 by SJ2PR12MB8690.namprd12.prod.outlook.com (2603:10b6:a03:540::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Fri, 28 Jun
 2024 19:07:30 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:11d:cafe::6d) by CH0P221CA0031.outlook.office365.com
 (2603:10b6:610:11d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.28 via Frontend
 Transport; Fri, 28 Jun 2024 19:07:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 28 Jun 2024 19:07:29 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Jun
 2024 14:07:29 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>, Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
Subject: [PATCH v2 3/3] KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
Date: Fri, 28 Jun 2024 13:52:44 -0500
Message-ID: <20240628185244.3615928-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240628185244.3615928-1-michael.roth@amd.com>
References: <20240628185244.3615928-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|SJ2PR12MB8690:EE_
X-MS-Office365-Filtering-Correlation-Id: 413a08bb-6dc9-49da-61f7-08dc97a58ea2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h9WGSrx8EYcZ26tmp6T/i3zEq6bZkbgfasD0BKXWS9/ADrS+uCGxqxz2N+uG?=
 =?us-ascii?Q?PvxxS5ArOXukyJQkVDAmf6nvkc+MXcgu9HGDDNLf7A2dMneXL7rpWEBuDwjJ?=
 =?us-ascii?Q?4l3WjbibFyOs1TjSfrdIJK4WwoWfhqzyj0l3sqBBHmRr0v9XhY/NFfAIsJG7?=
 =?us-ascii?Q?aGvAXtIOBmZ68UjXdiNUNq8xXpYpmnmhgno7VFTRtcsWmggmQS5yG4CKXo4x?=
 =?us-ascii?Q?sI+Ym8Z0XCYAV3CmxGGOzoL0sJcaJWkOOBkRPwev7UM5iZ434SerVLjQlXw8?=
 =?us-ascii?Q?tV7lxE+hWSKC+szYZ8TwF+O/DbiQA2j+q2ak+jAFRJVRN6LFJQcyIb8n/4wD?=
 =?us-ascii?Q?vVbGDXjl/heNjgRjaHYYpXUtOqarguAdCNC8FE7RQBYI6zT0rSIQv7XUaskz?=
 =?us-ascii?Q?NZQjM3+1JKj2LaqH6Zr+nnsDnyTOXXE/97DYJ8Pu5NbmqbBmF8tqWuBXyBP4?=
 =?us-ascii?Q?oSJWfk9Uurg9SCWvbU6RyupyCUHeD+GK1ry67Oz35Ng8D28COtBA4Zktp8XF?=
 =?us-ascii?Q?dd4FgfZC6HKDBOL0bzU5xRPjKy7kycuaDz1IDTUgQX5WcudQ09xnOwpqGc94?=
 =?us-ascii?Q?GplNjMb01OQYWIKXGKO5m59Fla6fCuIpHrIBPSEf/TCZDlj3/0gv8w97TTbe?=
 =?us-ascii?Q?PVlIhWnxEZ9zJAyYQNzhbaaYj7bbPtcxVaJzcs7E4aFo+55rTSOSgZNe6Rbl?=
 =?us-ascii?Q?oJATaxy6oZIsKGzlHJ8NDh5siffDGwHcdD+rpp5+fiLrxBv1LItrjnTlfndi?=
 =?us-ascii?Q?HCYDKa6DDEqxysRm3/ordgDOhzYpqHohdFzWFYwRBwd69j6BnDuwMJFyd/SD?=
 =?us-ascii?Q?e9lcywf/c47dOUgZ4OA5qz8+dJshFfhQJLv5SRpC0SiftDduGp9hvgVkJr/s?=
 =?us-ascii?Q?lyCpgmWshaZp5eIVLNAW8nwdTpSfDv5aZQzXL1BIfaRHyL6hlhU6Fbiamgld?=
 =?us-ascii?Q?6cK7iIsLs+Oc8ahD1ac7WVX9txs7tL0XSn+mOVFr45XOk/Wl/aQcqE4a5YBF?=
 =?us-ascii?Q?vaOeN4/bOFM4BEeRc3EGuwTHplt+fkWpZ06myxE990lSUZ404T/p9pkclq7I?=
 =?us-ascii?Q?WbRPcLoHgHbSbah1yGT/j1idxkwFtEor9vbCzqrrHKpT5Aq3JtXXpoxVl5fg?=
 =?us-ascii?Q?qpt6Ib5To49GBRxiFi5trxfLDTSmbhwB/xu/5jiuBiqcvwU+DUtTUyjpxdlE?=
 =?us-ascii?Q?U3bhU7yyyjAvYIwTaP3VxZUDb1C5evzA7LADzBWI9VS/dNGb2S3nDJdKt7t9?=
 =?us-ascii?Q?OPX+cxnoPyirChC3nDK7UOfKfVaAIjmVBFg66jpY5v+fYmSuzm4eBTM1QmE9?=
 =?us-ascii?Q?e7SShY4FmfNX1q8X6gsCUkxiszJKUUlaKcnLv8jpoM3QgB3nc7Blpx+The6H?=
 =?us-ascii?Q?KM54TGUw4mqnroUTNmfm8Enm8A4yHj4xIbHi949ZBUiPSVIOmatze+jkI8+f?=
 =?us-ascii?Q?XYbVCn4ZB2+diymAX//qMF3YPRfkEcu4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 19:07:29.7234
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 413a08bb-6dc9-49da-61f7-08dc97a58ea2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8690

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
index e7f5225293ae..a26e5b191d4a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3401,6 +3401,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 			goto vmgexit_err;
 		break;
 	case SVM_VMGEXIT_GUEST_REQUEST:
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		if (!sev_snp_guest(vcpu->kvm))
 			goto vmgexit_err;
 		break;
@@ -4067,6 +4068,58 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
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
@@ -4344,6 +4397,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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


