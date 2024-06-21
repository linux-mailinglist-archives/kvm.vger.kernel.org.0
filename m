Return-Path: <kvm+bounces-20280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 221C09126E9
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 15:44:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C61DF1F248CF
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 13:44:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B00EC122;
	Fri, 21 Jun 2024 13:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="i/E02Icw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E256208C3;
	Fri, 21 Jun 2024 13:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718977482; cv=fail; b=PrHKlOSZwWzSzisZM9kPudhGQWmXZ3SQGuNRXHiKO9lTgHQ8K4EXHqQ+kWm7O/YcI0Rhl2Ru3Hd2NqLbNfvBJxYEoerPaWEfB/297TujtJb7an72Z4te5wNm8nuo7VSg/UATafP/3p80jaRgZQMUJajVOkV5g9WMx/iC+bxmdwE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718977482; c=relaxed/simple;
	bh=frz7C35SsL/9qz+5rPDyNWHpYjGZebcqCxbe5Il+JA8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T9wZN+sd6FApKtfBlRjYjuNYQvLJ3bgv6B1iTxQbG/DQhOQ9RjxYyZvyeoLPLfK7RNpg9o7FVASmQYcN8O+dM1uUcjbMZ8xYATyLl+VhTuf1l+NxSj/gPjxdNV2EbFb/OZFg7u0YNYn4R3uJ2Q4s6NLTTniMGfdsAmOZBATilV4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=i/E02Icw; arc=fail smtp.client-ip=40.107.243.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVrJuBvRAMvCQbOXizhIQKlk1j62uyoRvrAo3NZ+NIBMBk6SIrZxEMY+Ep5I4QVYSrzIlP1rXaj1rLaCU/dK5U10FkcQ9w6ZfYAz6Vag6JNgpsO6VEuTUOIyUikNNGfHiDrO7nwDvAcJJxcg83GynYsSrGiYu0rzuHUjwm9+qDuxhfTPQdzjXxdN1iIfF2gc0klfhV70ig+p7uH9qvprZ0E/gWSiOKpvcGmQUnY7e2J9bcTmMM+jfTCgJ+9sNGEYxgAhCy/3jXwUMf4wjOTrfJMODLw3q3iokW0gzxIt2ZP6+0RJeAK4sZn6+ZoXWMoC7/57uvN8M6S6In0DmZlU6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CssA1f2np/3Tc0sjD6PvMPlUe+dJxpdzAc6K4V37EE=;
 b=NFFzdLcY4HZpON+KAgcSOLYdO/4MC0aQWMq4VocQyurnucW5kWQIl0sMA9/QyPPNnyCwgYqpe4gsadT0Q+Xi2LhSqI2vyd3ctuwpRh/FZxSZ70EX6wldK1b8E57HKwaiNZpTmgg6WhKDY1Xp50e+iBEC0E5W5npq6InSpwdcTVOvVb21iAi/1tQ8XZAhkieJvKxSCimYHu7rPWCy4Yn6K0E+8rgrdza17N/IRXaMSWIVqGFz/m2mu45cYQ0++JkiHDmE5wPR11rpkuzj0ZoHfygM50EC6jXP2/gLMYTpqPLkX2EAAQOZ+daNftES8E1+y2o8/1t1WUBJxqbcr3S08Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CssA1f2np/3Tc0sjD6PvMPlUe+dJxpdzAc6K4V37EE=;
 b=i/E02IcwgpsmdXplmKV9AqvbTM28+BDDQeGAmjCTmKdsXHtJN01lIQLuMhNZaEUAmwlAiwwTYARaG/PrcQ/MFQSRGRL6SEH8t+EspoxB2QgjmgvOmF74+EWw6eYM4NQDwz7vlICNq1MEISuMtFO9YaCwixKX296HkF1m8doZDlQ=
Received: from DS0PR17CA0013.namprd17.prod.outlook.com (2603:10b6:8:191::11)
 by IA1PR12MB7735.namprd12.prod.outlook.com (2603:10b6:208:421::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Fri, 21 Jun
 2024 13:44:37 +0000
Received: from CY4PEPF0000EE38.namprd03.prod.outlook.com
 (2603:10b6:8:191:cafe::a1) by DS0PR17CA0013.outlook.office365.com
 (2603:10b6:8:191::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.36 via Frontend
 Transport; Fri, 21 Jun 2024 13:44:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE38.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 13:44:37 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 08:44:36 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>
Subject: [PATCH v1 3/5] KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
Date: Fri, 21 Jun 2024 08:40:39 -0500
Message-ID: <20240621134041.3170480-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240621134041.3170480-1-michael.roth@amd.com>
References: <20240621134041.3170480-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE38:EE_|IA1PR12MB7735:EE_
X-MS-Office365-Filtering-Correlation-Id: 1512c487-640a-485e-d666-08dc91f84af2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|376011|36860700010|7416011|1800799021|82310400023;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wU8PAY9Pju9CT+a0lne2cDEA1mMPmSBSeGXFfnqYrBp1Qqf0u2XabVW+9o+K?=
 =?us-ascii?Q?MZ3qlZ7ggaMrstcpE34+OUtDozOffnODmaktdidesO6z42jStpm6HrxHvCgT?=
 =?us-ascii?Q?itCJgG0hBkLgB2v9m4q8IhLuQVD5FMMiX/8FUxiyaGXcmyJT9YBHXElZtZsY?=
 =?us-ascii?Q?cOoZnlgrwUvzHYaaOHfvYaz9uN213fBf9+ubyJ2VauK8TPmMoZsgY65OsX58?=
 =?us-ascii?Q?Yk4wcVGtiGBdoZrAtFhMbg77X/WqURpJWwgy6tcxzoRZT++T1lW9SvU/geDn?=
 =?us-ascii?Q?OU8nyx51yvky7t045ZYCfI6OguLY1B0bw7XN/dxKuMnQeDbyOzNIGj36EjaR?=
 =?us-ascii?Q?Tk5nLmV0lio1Qml5Md5eNV+PQ7fqxzVHGbosjtLR70CMO+3cEkHkHrRwg7aQ?=
 =?us-ascii?Q?/bqDAydcQGuILXeKMt7nrDxI2At+gUNHOQYdzS6MU7NAzONVpzz/rcCRQmat?=
 =?us-ascii?Q?WiW210AzHvxxvBcekAfvdsCCzsd90Gf/w7i7ze50glofsqUBQ0v+7cmaJ0B2?=
 =?us-ascii?Q?Yv09iGi6vesa13SyOGDUT5RULUfsOul23EgF0cq0aupzeQG55CYG8xx/iweD?=
 =?us-ascii?Q?QSAMlEKQ/rR23fWPRAvqVLOpG6q0LWuBL0repijUmIpSCsK7fLEyMlRa+Cfm?=
 =?us-ascii?Q?fAeQAJIIMc8/rJnOmt8by6BJu+2MfzuLSzAvWtGQDZMLvzLV6JPP2OAEs32/?=
 =?us-ascii?Q?s1kFzXUXFKIGmH4toZHTYBA9i8g/Z7wSduUhOIVcOTdDG0MD0mZKrUaOmj6x?=
 =?us-ascii?Q?TS62ivEBXAREu/mWECXQ+Z69JMbPwd+GNx71avSdauMbNegc9F06qKR8DK45?=
 =?us-ascii?Q?fsrHQOvCppGh1av4H34mWhfdD9Msrs/4Wh2c4XDp29EtzdFwZCxxL6O/Tjws?=
 =?us-ascii?Q?LI1L/o7R8TStt2Kb+waXLxIuO9mT7qMwiGQEH80IFaKbgu1+srwNdzvzaUNQ?=
 =?us-ascii?Q?C/pVwnJ2Qp0b320saQ95SBb2Bl+AaUjUWgjlBcpN8ajERErP1/Kq3iBq2X4O?=
 =?us-ascii?Q?hT5J3q9QLa850MNMu3Vr8I59WOJSRSwsaLzHi6aLFWLUB4gVj6ZXrjdbgJks?=
 =?us-ascii?Q?VeGplprb4qakHrCM2r92Gb6DrJIUE6Du5f3KGzWmpGlLDUyMat5jPkI4iFjD?=
 =?us-ascii?Q?st4KQs9z8+eGxB2QlIXakzz5EV1iIWZzfFTGJShTjCoc1wgsQgYlOsctP8/N?=
 =?us-ascii?Q?2Mlx4Tc8ENB00Hfalzl55x6kRCyfZKe8/x8URPFyfJcBCJds48vRDPWgsg0m?=
 =?us-ascii?Q?RiNF6QK1fDo76xZPifVRxh1jfeKQMboDk3Ck1Cri5sDnpjaZeCOrupsgfHAS?=
 =?us-ascii?Q?By+/Nwh5HeHXx4s8F7IqEX6o/Eny4j7dqGbjpKP5V4vRZ/yqJ/31Y/uzHwtn?=
 =?us-ascii?Q?2QGpZr/lXq4d1JYRPVKSe+SNnDGfZjZy7/+psyTnBnPV2fcY8A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(376011)(36860700010)(7416011)(1800799021)(82310400023);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 13:44:37.3863
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1512c487-640a-485e-d666-08dc91f84af2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE38.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7735

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

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 60 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7338b987cadd..b5dcf36b50f5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3323,6 +3323,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 			goto vmgexit_err;
 		break;
 	case SVM_VMGEXIT_GUEST_REQUEST:
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		if (!sev_snp_guest(vcpu->kvm))
 			goto vmgexit_err;
 		break;
@@ -4005,6 +4006,62 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 	return ret;
 }
 
+/*
+ * As per GHCB spec (see "SNP Extended Guest Request"), the certificate table
+ * is terminated by 24-bytes of zeroes.
+ */
+static const u8 empty_certs_table[24];
+
+static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct kvm *kvm = svm->vcpu.kvm;
+	u8 msg_type;
+
+	if (!sev_snp_guest(kvm) || !PAGE_ALIGNED(req_gpa) || !PAGE_ALIGNED(resp_gpa))
+		return -EINVAL;
+
+	if (kvm_read_guest(kvm, req_gpa + offsetof(struct snp_guest_msg_hdr, msg_type),
+			   &msg_type, 1))
+		goto abort_request;
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
+			goto abort_request;
+
+		data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
+		data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
+
+		if (!PAGE_ALIGNED(data_gpa))
+			goto abort_request;
+
+		if (data_npages &&
+		    kvm_write_guest(kvm, data_gpa, empty_certs_table,
+				    sizeof(empty_certs_table)))
+			goto abort_request;
+	}
+
+	return snp_handle_guest_req(svm, req_gpa, resp_gpa);
+
+abort_request:
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
+				SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_GENERIC, 0));
+	return 1; /* resume guest */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -4282,6 +4339,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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


