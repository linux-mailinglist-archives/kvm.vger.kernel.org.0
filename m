Return-Path: <kvm+bounces-58462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1062B9449D
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 07:07:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74BEB1684D9
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1284630EF6E;
	Tue, 23 Sep 2025 05:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="erO2fGlr"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013039.outbound.protection.outlook.com [40.93.196.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974B52E92B7;
	Tue, 23 Sep 2025 05:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758604018; cv=fail; b=MNPJf5dVRs/m1QD0ohBh/wOXWPFij/RDxryq2r3AFDkw9uJdJyLIeI2MbcHxatNDBaQ9t5sSxyaLiNNvAvKun1+GxM08uir3N0s5iQ2zJBIQWBODXZfaUX8haR+wnX5f0daQc9P0XGfS0HFT5jgLxwsbfYyug+cZ3OcKjVJFuhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758604018; c=relaxed/simple;
	bh=64kHogy/YABlqQwTI5grlwJemy/Za1wCMyFHoGNb/2k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=esZymjiGrb1w2LEWQQ1gNEbJl/vgsWGtrGYVes9XuF8+2JzYL2zKtfnFvjy6a69Pog//dWUEU07NXMv+7/UjMHGTRCf+DjUs+2IoaJPA8G8pJ2kgtnHFBwyj6tB74zshUjHKbK6heaRK0K2r55C10PBd4WJrCA/F0NsjTM4knVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=erO2fGlr; arc=fail smtp.client-ip=40.93.196.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Og/bPiUtco3i+aaiY3TwdutZEV3WH9CjQflHCe7b8vxgJpvOjVKMUDZFbnCjxFt5ozywQa60AOPLc/HXDiMnbXOgMPaZZtwncxXo4culq1reWCfIZiUsaVvITEd71kHv3rkkkzIn0zJCjYWdbCNyDP/oE0m6UVej9PDxu+W40o9O88doRSkUYjcYPHXJQc82VXDZZlgbU0suojOVOvoiG+w7KJtBY+w7hTDQKHgeImqTbeaMB385eFnQQBmwj8zc6rAzO2PIFzpxe0Yi6LEK3cp0ybiXKCouIuqwBTKWo23Kdtk6+qd6SvrpxdKRd33M138ioDhwp+hJStg8JSv/Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z6i5RBEz+0BF6uagM6tzXM8ZWojBa8cfZrv6rUABUEE=;
 b=VidtGiOoOqC7gBP+jzn+F4FQeyQ9OfJHMJG6EtaCuQdafCdLZMnhZcJSQGe35bFwCCjSjePoGYdH6p1H77HsRFMwCrrRLRCM9fYm8l0gSE09CeqPxcx+PHpW6M4jyFXvQUG1XO+ptRVVwIFWzvOtfqW6kowz1IcH+qUuJC+/M+oOUbdKeUBrghY7OfBI0ZMtdLxm569bf/xd8/18aNBdynquhNE38UkbX+cuCbeyOXxmIf6U1cFexcPqbnU1UZHfGKqRMEvln88cCXDfplE1/FB1qKvMrR2VZYpVnpNW4lhSgDWdU797dZ1HO7am9gc5GJdKsfkhK+EgBE8HV9tPGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6i5RBEz+0BF6uagM6tzXM8ZWojBa8cfZrv6rUABUEE=;
 b=erO2fGlrTpXIRn9Erz0A4f6Vzh/WLSPxWgOF23BFPsUbnI5QWZJTrCpP8soAab7s3/G3hYGSuQ+G1dpjFXqpCsV16SNuyTA5e0d3mOdj9twCPADgyItQKcp6KkTTvRzvxO1QAwP2KoVY4kNhencbjGsR44BZx58jidIREitynbA=
Received: from BY3PR03CA0029.namprd03.prod.outlook.com (2603:10b6:a03:39a::34)
 by IA1PR12MB8263.namprd12.prod.outlook.com (2603:10b6:208:3f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 05:06:54 +0000
Received: from MWH0EPF000971E2.namprd02.prod.outlook.com
 (2603:10b6:a03:39a:cafe::85) by BY3PR03CA0029.outlook.office365.com
 (2603:10b6:a03:39a::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.19 via Frontend Transport; Tue,
 23 Sep 2025 05:06:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E2.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 23 Sep 2025 05:06:53 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 22:06:49 -0700
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <Thomas.Lendacky@amd.com>,
	<nikunj@amd.com>, <Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>, <David.Kaplan@amd.com>,
	<huibo.wang@amd.com>, <naveen.rao@amd.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v2 12/17] KVM: SVM: Add VMGEXIT handler for Secure AVIC backing page
Date: Tue, 23 Sep 2025 10:33:12 +0530
Message-ID: <20250923050317.205482-13-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E2:EE_|IA1PR12MB8263:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c7cf22a-f3cf-4b0d-f294-08ddfa5f0322
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LdwqZ0dce2bR7/nh+6fwTHtqkZV2iBnfNuafOlHr5W1vYR8He1wgG66id9N9?=
 =?us-ascii?Q?TLZdxR8KMgbmoQs2W2bdZh3wymzj7r/UI4N9f1+PaCnrmmXeOnmKh1jm8/Fs?=
 =?us-ascii?Q?r1ao1vBanwCRMsgNtfDdE0QHRfW/02TPi/f22U8LlSa6sRCCN9zBJMAVuH1S?=
 =?us-ascii?Q?ZKL2MTe/fSUQ1nJZfb1aQRaUtOybbNl60G8/95P4NSq5uIBQEzktGNuaKSqB?=
 =?us-ascii?Q?QYad8P9IvYsxNJ6smORl4JfNFbDjDd1zE3Vgm7yresAf5m1d0i0z419/+tlP?=
 =?us-ascii?Q?a3VIb4EqK8ZExXThE4a1V3OrYfUYiFsm/Uk4L6f1ep0egHP+U0ihKY7PuWBo?=
 =?us-ascii?Q?3zdl+Nid0meUzCB2/A0SesXCASBrVTCYOxL7XY5EAge9YIJmkPWSXjyjkxeW?=
 =?us-ascii?Q?6/eiFdyrgUKSGztoMrxG/JX+d5/IlrHxvmT/YSLFJ6wJjeMKpLWZUqUYVCBP?=
 =?us-ascii?Q?a56jdk5bU3T76NV07KJnWcdE+rYh19yLQ2NDlaCNknljMQUwI8/k+VhjoIc5?=
 =?us-ascii?Q?+ksqV/b55BHJz1LDb9tNbtbnmNX931JRWUZMjLiv63SfD49OFTQdfmXwOVbx?=
 =?us-ascii?Q?K6+mpdxbO7oL2JMvb5NNz5OeIrIxMAn+bbci+C5xcxxJHONVgKUIMbha4IU6?=
 =?us-ascii?Q?X79DBY5KNboRmFxP2wBtUT4OEfXKPhDXvv+Wmiuo0FeMtLMtzh99edDLlsDw?=
 =?us-ascii?Q?eARp6+cQ+6E7rkxwEa663lSNNQ3KPI7E+ie98psx2iCSikCNPGNpdR2Bt1EN?=
 =?us-ascii?Q?dWbztLRSP6L7G2At50Dev8NYJBZSBL3RapbtIzi0P39m3abIY/IPLsEqmFJ9?=
 =?us-ascii?Q?lolZLWpWv//FT3C1OtSUSQsTJWfwnywhZhhJ/b9++nxdNAF7LtHFs28UgXRK?=
 =?us-ascii?Q?dwa+XU4AgnUrYWF1kqvABx1bzF+mQumCUJ1at8eFVi6CtBd/cQoy+ANxKqve?=
 =?us-ascii?Q?vmZ/OU5DPYik5elzdfYuiLP/NVxoRgE8K+SvPZ9d9kpXrSUnlG81sQqBZJRK?=
 =?us-ascii?Q?xoRpW1I0hhvJ45scLOxMTWXGaskYp/IRCzr6qvYS5TBIh8UHrFDZLjZLtOa0?=
 =?us-ascii?Q?JluOnnVE7ADnPHceD75KHf8emZ0Tameot2rshvJqA3lRi9JuDUf3L2H+tl4W?=
 =?us-ascii?Q?0nk+uI5cnC+ciNrmtBMNqf2MCa49VEu+ubu2VqPTJ9i+vlxy+pqX9hVdFkcQ?=
 =?us-ascii?Q?kjiTexHrvtZRQXioCH6Vki1Shc9bUlHh6XbMKyboDtk3kadAcfXtYAc6bhCJ?=
 =?us-ascii?Q?Af0nlJyrjlE3wWmexoyiw//zNEuFd/v2Wfsciu6pLKGQXiuGQP7rTWW3ZtKZ?=
 =?us-ascii?Q?KtYcuWqe0FG8hFFUiwpK4XzRmXHauzSkHtNbCh/88bBfHsswlQCyGWHzp3uU?=
 =?us-ascii?Q?7UuMYZtWf4P4ADRm4HSwpjprUAVV3cCcHYmD0Sp2nPuPGV8AkYyPEQwg1KPV?=
 =?us-ascii?Q?0EwvSzpWvKRhh8gEKhnTwvwmckMtGRuTaStcXuYCogE0WIThq0gqM7X3xM4n?=
 =?us-ascii?Q?APXBG8bdZtaAZFbToHPdZKVkScjkqEF7DczZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 05:06:53.6316
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c7cf22a-f3cf-4b0d-f294-08ddfa5f0322
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8263

The Secure AVIC hardware requires uninterrupted access to the guest's
APIC backing page. If this page is not present in the Nested Page Table
(NPT) during a hardware access, a non-recoverable nested page fault
occurs. This sets a BUSY flag in the VMSA and causes subsequent
VMRUNs to fail with an unrecoverable VMEXIT_BUSY, effectively
killing the vCPU.

This situation can arise if the backing page resides within a 2MB large
page in the NPT. If other parts of that large page are modified (e.g.,
memory state changes), KVM would split the 2MB NPT entry into 4KB
entries. This process can temporarily zap the PTE for the backing page,
creating a window for the fatal hardware access.

Introduce a new GHCB VMGEXIT protocol, SVM_VMGEXIT_SECURE_AVIC, to
allow the guest to explicitly inform KVM of the APIC backing page's
location, thereby enabling KVM to guarantee its presence in the NPT.

Implement two actions for this protocol:

- SVM_VMGEXIT_SAVIC_REGISTER_BACKING_PAGE:
  On this request, KVM receives the GPA of the backing page. To prevent
  the 2MB page-split issue, immediately perform a PSMASH on the GPA by
  calling sev_handle_rmp_fault(). This proactively breaks any
  containing 2MB NPT entry into 4KB pages, isolating the backing page's
  PTE and guaranteeing its presence. Store the GPA for future reference.

- SVM_VMGEXIT_SAVIC_UNREGISTER_BACKING_PAGE:
  On this request, clear the stored GPA, releasing KVM from its
  obligation to maintain the NPT entry. Return the previously
  registered GPA to the guest.

This mechanism ensures the stability of the APIC backing page mapping,
which is critical for the correct operation of Secure AVIC.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/include/uapi/asm/svm.h |  3 ++
 arch/x86/kvm/svm/sev.c          | 59 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h          |  1 +
 3 files changed, 63 insertions(+)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 9c640a521a67..f1ef52e0fab1 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -118,6 +118,9 @@
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
 #define SVM_VMGEXIT_SNP_RUN_VMPL		0x80000018
+#define SVM_VMGEXIT_SECURE_AVIC			0x8000001a
+#define SVM_VMGEXIT_SAVIC_REGISTER_BACKING_PAGE	0
+#define SVM_VMGEXIT_SAVIC_UNREGISTER_BACKING_PAGE	1
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffd
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffe
 #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7c66aefe428a..3e9cc50f2705 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3399,6 +3399,15 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		    !kvm_ghcb_rcx_is_valid(svm))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_SECURE_AVIC:
+		if (!sev_savic_active(vcpu->kvm))
+			goto vmgexit_err;
+		if (!kvm_ghcb_rax_is_valid(svm))
+			goto vmgexit_err;
+		if (svm->vmcb->control.exit_info_1 == SVM_VMGEXIT_SAVIC_REGISTER_BACKING_PAGE)
+			if (!kvm_ghcb_rbx_is_valid(svm))
+				goto vmgexit_err;
+		break;
 	case SVM_VMGEXIT_MMIO_READ:
 	case SVM_VMGEXIT_MMIO_WRITE:
 		if (!kvm_ghcb_sw_scratch_is_valid(svm))
@@ -4490,6 +4499,53 @@ static bool savic_handle_msr_exit(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static int sev_handle_savic_vmgexit(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = NULL;
+	u64 apic_id;
+
+	apic_id = kvm_rax_read(&svm->vcpu);
+
+	if (apic_id == -1ULL) {
+		vcpu = &svm->vcpu;
+	} else {
+		vcpu = kvm_get_vcpu_by_id(vcpu->kvm, apic_id);
+		if (!vcpu)
+			goto savic_request_invalid;
+	}
+
+	switch (svm->vmcb->control.exit_info_1) {
+	case SVM_VMGEXIT_SAVIC_REGISTER_BACKING_PAGE:
+		gpa_t gpa;
+
+		gpa = kvm_rbx_read(&svm->vcpu);
+		if (!PAGE_ALIGNED(gpa))
+			goto savic_request_invalid;
+
+		/*
+		 * sev_handle_rmp_fault() invocation would result in PSMASH if
+		 * NPTE size is 2M.
+		 */
+		sev_handle_rmp_fault(vcpu, gpa, 0);
+		to_svm(vcpu)->sev_savic_gpa = gpa;
+		break;
+	case SVM_VMGEXIT_SAVIC_UNREGISTER_BACKING_PAGE:
+		kvm_rbx_write(&svm->vcpu, to_svm(vcpu)->sev_savic_gpa);
+		to_svm(vcpu)->sev_savic_gpa = 0;
+		break;
+	default:
+		goto savic_request_invalid;
+	}
+
+	return 1;
+
+savic_request_invalid:
+	ghcb_set_sw_exit_info_1(svm->sev_es.ghcb, 2);
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
+
+	return 1;
+}
+
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4628,6 +4684,9 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 			    control->exit_info_1, control->exit_info_2);
 		ret = -EINVAL;
 		break;
+	case SVM_VMGEXIT_SECURE_AVIC:
+		ret = sev_handle_savic_vmgexit(svm);
+		break;
 	case SVM_EXIT_MSR:
 		if (sev_savic_active(vcpu->kvm) && savic_handle_msr_exit(vcpu))
 			return 1;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a3edb6e720cd..8043833a1a8c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -337,6 +337,7 @@ struct vcpu_svm {
 	bool guest_gif;
 
 	bool sev_savic_has_pending_ipi;
+	gpa_t sev_savic_gpa;
 };
 
 struct svm_cpu_data {
-- 
2.34.1


