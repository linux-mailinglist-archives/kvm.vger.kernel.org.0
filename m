Return-Path: <kvm+bounces-32053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB02B9D2756
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 14:52:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABF48284F9B
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 13:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AEC01CF5E0;
	Tue, 19 Nov 2024 13:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vog1uFRo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEE81CCEF2;
	Tue, 19 Nov 2024 13:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732024300; cv=fail; b=R+1F8VX+rRgEDKZJzO4j0SDTWxVPMWJLIo48kj8JCtkjDfMeSKjYGIVVvLw87pm6DjMXhbKKZJBWdSMhN3KxxYjPIBk3tYo1mduqdkXy6PRBtmpC8wlKOJDiJIrhdgHdU+x2SOAHC+K+1VtIeRPnm+gpexdMeVK53GFKItS9480=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732024300; c=relaxed/simple;
	bh=aEI0ipd9vf44lCB4s7FZcDa6ewfxJLet7KmvwnYlbs8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CojghEYMnyIfA6PmayFCHES5+SPKBvenZ4M0eHajR5vP4Veu2JxFCnQGLLILDJdoeMVrR1dHj+njcZzv5cPUzG0wg7Ql2Wh4DXAjTabMTbhpAooWAwsLnxItFRfAv2HM2le0wa7OdRpAdhj20g407RSzWoxFpEGBpKOFPlgCOmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vog1uFRo; arc=fail smtp.client-ip=40.107.92.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KbF+B150ISisfeVbPOUCeJf80n6i80UNOMu9V3O9qNkntGtSFOqkVExAkqR5SR9f+Goz61IQpL661SA1zBAZ8EnOQqWJY0CiwYiO7a3vzH/+TzH64Utq5JmCUu3E7rVdZEYFfSehI2vnRKg4ypDE2Kd8VYrsUMuyvK4Ow91iJGKiql+6UUQ7TCZedTteSIrFWp1TtBITWwONtL+iqggs3QEEnAGf1Jrx1EnTg8g2PPX7uhCWLEKClqA+kdfTmub6sE0W5v/pp9VkLY8v9T8mm5Yn28fVMyR6AD8oBLf2okz6SjCvbN0K1r+G0DziGChDWJx+ocwK3NHVltiOCLCewg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CyNySbopBfUvz90ZS5/g4IIZqtz1AWK4QqjQtZyrxOM=;
 b=hu0w3z8Ih4+Fodvo+/2g3j+6zReJKXudQwK4LujucX9N1RTTxWvjxtDDnYanjljDHGFY9AKogS7PUhve2HGHeH5NblrhD05dV2Gyi2aNV2N22MmfvvuNi/7pmDUHQP9/zen1JxoCRK195uw3wCuQb9HIbcuzljSAumeuCy1KwS/daVdBOXSsqSrtGQMwZggqXtqFo76YobuGsqQkBdGL07Glej2ncE6dIRebUhLaTusAsuw8M8XmId3vB4sioCwhSxOxOCvEiC8Wd6wJ+H8iVTO7BatntFdmEQqCUX/8bx7W6mA0G/IoEz4R2qz6CKF7ypjfXyQ0dIEVlEudG4jl6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.12) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CyNySbopBfUvz90ZS5/g4IIZqtz1AWK4QqjQtZyrxOM=;
 b=vog1uFRow922WswYPdBfRcv6acsKs1IbwvOUKOqbIANkxY2WnjbLnq8azvYmJwuO5JIutXy+ebq3dqdD1haHyIh2HxCMWJIq84RJBLLQDgJuS6X1LsXYMOtkIQE91TdodQ3dpU9L6gMj77HX6bGAO6SwGOBOqsCqDPiHTr0srcI=
Received: from BL1PR13CA0249.namprd13.prod.outlook.com (2603:10b6:208:2ba::14)
 by CY8PR12MB7123.namprd12.prod.outlook.com (2603:10b6:930:60::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Tue, 19 Nov
 2024 13:51:31 +0000
Received: from BN3PEPF0000B074.namprd04.prod.outlook.com
 (2603:10b6:208:2ba:cafe::72) by BL1PR13CA0249.outlook.office365.com
 (2603:10b6:208:2ba::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.12 via Frontend
 Transport; Tue, 19 Nov 2024 13:51:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.12)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.12; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.12) by
 BN3PEPF0000B074.mail.protection.outlook.com (10.167.243.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8158.14 via Frontend Transport; Tue, 19 Nov 2024 13:51:31 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 19 Nov
 2024 07:51:30 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>, <dionnaglaze@google.com>
Subject: [PATCH v2 2/2] KVM: SEV: Add certificate support for SNP_EXTENDED_GUEST_REQUEST events
Date: Tue, 19 Nov 2024 07:35:13 -0600
Message-ID: <20241119133513.3612633-3-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241119133513.3612633-1-michael.roth@amd.com>
References: <20241119133513.3612633-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B074:EE_|CY8PR12MB7123:EE_
X-MS-Office365-Filtering-Correlation-Id: 948a2ef4-6fad-4cb2-7b37-08dd08a145e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A1OOnizJtRzqrIPspP4NVPZaA7Ayp4E349rH72o+7J4jy0hWginfiErIb6pB?=
 =?us-ascii?Q?RDU9G+vJ9suRBnuasb9XPVRtG1o+AC/0+6mPf27wFEDJC623lXGjwkj6Dbnt?=
 =?us-ascii?Q?piakNUrWBy40VKOJVHoFGc1C9UPXfpEzIDRBK+NjRDI41VW5vTS4ebZZOn23?=
 =?us-ascii?Q?MCdLQ/xkZf55r2rtou0/KmNEEykDE9UDuQ9xLj9JzeoH1HBBiGpIF5m9JgOh?=
 =?us-ascii?Q?nux2kyIojh1/m22aGzU2e2znCJbXKnW7Bg93qUUBV+kUXkkwd3y2bezzxO6X?=
 =?us-ascii?Q?gzHsDFELG3PG9RZgAhKyX8Nw3nIyKZFPX+Bo92wXzYfVrmSMtMpScbmxyzHp?=
 =?us-ascii?Q?MZ0sLUPAZl0aHBWyZ4xnWyA61nkrK6sdK0LBYtnUCcmXIqDKxiJCSC0fX1/n?=
 =?us-ascii?Q?bUPbApkDycGkmxbY5uFSlBXRGkD4X8MVA8RIEZ9Hs2itzGCJuQfULNeWdo/b?=
 =?us-ascii?Q?u96n+kLVlyqDF0ZravZdpsNAMXFodnk20ZjQSseYP1lnKyzQNAwze5WtZ2hV?=
 =?us-ascii?Q?SSQ8AIYSP+myUBkiVF4vPmYYjG88aKw9Zu0wuKxVRX6S4QlLV0ndWmekqgF2?=
 =?us-ascii?Q?gSoF2Ga9LJu7b81Lt1elAB+I0VinyaZSH/s+FgvxbNsxTrzZzrzQn3bOUJ5E?=
 =?us-ascii?Q?s+PReMm70YU+rHDVxsRrM2CNlTHQFs7k7tbqqwjqRVmwl1GdQvctoZ/lUMND?=
 =?us-ascii?Q?+nEXNCXubeyC6yNH2uhprvShzN6/6V7Z9AGEz3a+ieG95ZjJ8vZUr5fwXxeT?=
 =?us-ascii?Q?BlUMfq0H2HOTWGa/7ImQ4gFk1WM1TN/mXQUuH3UfVFgxE786A+465q+YiObG?=
 =?us-ascii?Q?ZMvxLuHXTSDyeOLCKYkpnrpEU7aDsonIFuhMnwltEO/dW4rkr2Im3umkKocX?=
 =?us-ascii?Q?ZUMd9eFE8m2kworzw5gbmjiZ3ehYPpRPscHdS7LJ/LR8EKpwidDodULrRfwe?=
 =?us-ascii?Q?WaTVcK7B6v/UJQ/2cydz3cYxIcZGWaEwoQ4dmfz8eC6kAK1rPxiB5xMP6UJn?=
 =?us-ascii?Q?f89tb6CT8PQ0d+9/MmvEaJGs6KQ4A1GVSWHvC9vgI3PZFNcO/KEZDgqdGVbi?=
 =?us-ascii?Q?SiNFgCLW0diP1Mv3JBRiotyhnC096fMLikmDSpz3h575QiUN6ee/EKs8ghOe?=
 =?us-ascii?Q?vSnj23N0nyIZJEhBghveIUlGNY+jtJk2XyYJEXDZn5cVMuqaMpc0ZomCK8u9?=
 =?us-ascii?Q?WVFlW6288kQaDc7W55xj+wnF+Y0XBJVJ+bmST7NeNA64Ta3OP02mTpfVwWpn?=
 =?us-ascii?Q?95MEwVU9CGvL4bDXwykBDqcO8Z8kEsqrA550eLJKYfaSFd9VhwcDqjQF0OeG?=
 =?us-ascii?Q?yQ1w/g/jAQue9zC4eDBcbRrB+PmvbDLS2hi8NP7ZezcJkh8YA7+w1gXb7/fF?=
 =?us-ascii?Q?IGpWLKZWP6zhFVI1BIipP0hJlodnrwbwdaJlRnQvkRWP+iG2lQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.12;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:atlvpn-bp.amd.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2024 13:51:31.1080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 948a2ef4-6fad-4cb2-7b37-08dd08a145e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.12];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7123

Currently KVM implements a stub version of SNP Extended Guest Requests
that always supplies NULL certificate data alongside the attestation
report. Make use of the newly-defined KVM_EXIT_COCO_REQ_CERTS event to
provide a way for userspace to optionally supply this certificate data.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c         | 44 +++++++++++++++++++++++++++++-----
 include/uapi/linux/sev-guest.h |  8 +++++++
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 72674b8825c4..4827a8ed4d16 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4077,6 +4077,30 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 	return ret;
 }
 
+static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control = &svm->vmcb->control;
+
+	if (vcpu->run->coco.ret) {
+		if (vcpu->run->coco.ret == ENOSPC) {
+			vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->coco.req_certs.npages;
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
+						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN, 0));
+		} else if (vcpu->run->coco.ret == EAGAIN) {
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
+						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_BUSY, 0));
+		} else {
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
+						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_GENERIC, 0));
+		}
+
+		return 1; /* resume guest */
+	}
+
+	return snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
+}
+
 static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
 {
 	struct kvm *kvm = svm->vcpu.kvm;
@@ -4092,12 +4116,10 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 	/*
 	 * As per GHCB spec, requests of type MSG_REPORT_REQ also allow for
 	 * additional certificate data to be provided alongside the attestation
-	 * report via the guest-provided data pages indicated by RAX/RBX. The
-	 * certificate data is optional and requires additional KVM enablement
-	 * to provide an interface for userspace to provide it, but KVM still
-	 * needs to be able to handle extended guest requests either way. So
-	 * provide a stub implementation that will always return an empty
-	 * certificate table in the guest-provided data pages.
+	 * report via the guest-provided data pages indicated by RAX/RBX. If
+	 * userspace enables KVM_EXIT_COCO_REQ_CERTS, then exit to userspace
+	 * to fetch the certificate data. Otherwise, return an empty certificate
+	 * table in the guest-provided data pages.
 	 */
 	if (msg_type == SNP_MSG_REPORT_REQ) {
 		struct kvm_vcpu *vcpu = &svm->vcpu;
@@ -4113,6 +4135,16 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 		if (!PAGE_ALIGNED(data_gpa))
 			goto request_invalid;
 
+		if ((vcpu->kvm->arch.coco_exit_enabled & BIT_ULL(KVM_EXIT_COCO_REQ_CERTS))) {
+			vcpu->run->exit_reason = KVM_EXIT_COCO;
+			vcpu->run->coco.nr = KVM_EXIT_COCO_REQ_CERTS;
+			vcpu->run->coco.req_certs.gfn = gpa_to_gfn(data_gpa);
+			vcpu->run->coco.req_certs.npages = data_npages;
+			vcpu->arch.complete_userspace_io = snp_complete_req_certs;
+			vcpu->run->coco.ret = 0;
+			return 0; /* fetch certs from userspace */
+		}
+
 		/*
 		 * As per GHCB spec (see "SNP Extended Guest Request"), the
 		 * certificate table is terminated by 24-bytes of zeroes.
diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-guest.h
index fcdfea767fca..4c4ed8bc71d7 100644
--- a/include/uapi/linux/sev-guest.h
+++ b/include/uapi/linux/sev-guest.h
@@ -95,5 +95,13 @@ struct snp_ext_report_req {
 
 #define SNP_GUEST_VMM_ERR_INVALID_LEN	1
 #define SNP_GUEST_VMM_ERR_BUSY		2
+/*
+ * The GHCB spec essentially states that all non-zero error codes other than
+ * those explicitly defined above should be treated as an error by the guest.
+ * Define a generic error to cover that case, and choose a value that is not
+ * likely to overlap with new explicit error codes should more be added to
+ * the GHCB spec later.
+ */
+#define SNP_GUEST_VMM_ERR_GENERIC       ((u32)~0U)
 
 #endif /* __UAPI_LINUX_SEV_GUEST_H_ */
-- 
2.25.1


