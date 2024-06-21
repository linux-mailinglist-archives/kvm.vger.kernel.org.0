Return-Path: <kvm+bounces-20282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DE34F9126F4
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 15:46:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B487B27BF5
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 13:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 792F217BD9;
	Fri, 21 Jun 2024 13:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dKoI40pu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C71EAE1;
	Fri, 21 Jun 2024 13:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718977526; cv=fail; b=SyDCFO5d12BZJJLRJRw1Z0ceAPCIopXN93w6v9lEfs7Mm0+tK9udQ/S48j5KbLPwfwsrttFVDBJl0Rf3ycBQwQPTnaYr3AyXoTNMd0p2ecu/i6iSacSQW75rXxla9u5njQv3OXGmivEadXjT5C4viSnJCEyYq62jbjGgw4mYTxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718977526; c=relaxed/simple;
	bh=3ZrbkPvGoaRf+9JcCXtfdmnAY5rncolct6Jkv60rgQE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QYgAu7lfITAodn8SbUZpusf5NQGbd8Yvj9nm9lz4lgARbBVsdVvRo3klJpmDJnqDAGzpMtRZKwjbrmm8FT63n5kLVU813M+9ziqYQHFC4Dl+Z6Mvwm1827JiEf78b6xxEj6D1A+pGDujdsd82ZEGiUMzqbpMZUYcGLGMwWnv2Aw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dKoI40pu; arc=fail smtp.client-ip=40.107.102.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaF6XDt5oXK+vYQAwlIUfN6JHuVueRfVoBdbMKidpvZheS3v95xJSjH8hNpA8qHQfjkdlKaxJpQH5QA9jm3qGS247kZOhVFPnDuDkXwQk+kd/0KMAuo10RPFak0u+H0+a9gfad5R17N7nYZDyjWmBmQqdV9gs1vsaSS5sg0RE9yGlpXiTSbwx7H0CuGBJLPv/tBPMYbZJtmh6MFeDbMgKSJZq1Ne4U3G7O+t1RwabovU/LrDulI1owylioNEvkG19sxoYoIA//vGskEpYozfRebUe8OsiyGkdknoW7Ggv4aXNl6JSu5qvKZ5DBH38q8Ix/9J/tJR/sK8FDTSeabHhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZWqFxH32eMGp7ZZHQKb2AtZwawQdd2H5mkR806QZQWE=;
 b=OXuc4zjZUm3v2yVkddmFQgjRryIhML012KNRsllnyRbJcKGSeTw74bHOnY8oAp6o9BI30gwe62NWzMyeU6b1VCraWyEAGGtWR8hzEclzhOABV4fo7WfHF5y2j6kRjVyx9RPB/aiPehkoT3kqnYOPIu2t58OUT8GcYOk2Vb6gWa/l3251RIamLM045XiXoCxvTagwy5vR/is4za8fXnbBbUXU5pqEf6UXohhDXJZwn7JxZx8/RDIzpoLOU5atUCR29q0BWPsyEw46erRn0KXYYZyl5dqTOToM6TyRqJiwJmPCxIbcYH0/NK4tNbR/0BE9glckj1ODSVEsLLjzUk+dMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWqFxH32eMGp7ZZHQKb2AtZwawQdd2H5mkR806QZQWE=;
 b=dKoI40puBJdmt4HT+VrUuOMRGAdA58bjUgC4hP/xsyyQORMlw3qadbT7HgLp4dit1EwBKFDGgrkJ+ej6eMBptXOYlaY3ZKTdmyh0muWgMp81HmhfINDnt5Xa7lhIyXh6qM6D7kW4nqqQf9QXTf8OMqyEPJkI04IAH/V/B6EQa2U=
Received: from PH8PR21CA0004.namprd21.prod.outlook.com (2603:10b6:510:2ce::11)
 by DS7PR12MB6069.namprd12.prod.outlook.com (2603:10b6:8:9f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.22; Fri, 21 Jun
 2024 13:45:19 +0000
Received: from CY4PEPF0000EE3D.namprd03.prod.outlook.com
 (2603:10b6:510:2ce:cafe::e1) by PH8PR21CA0004.outlook.office365.com
 (2603:10b6:510:2ce::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.14 via Frontend
 Transport; Fri, 21 Jun 2024 13:45:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3D.mail.protection.outlook.com (10.167.242.15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 13:45:18 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 08:45:17 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>
Subject: [PATCH v1 5/5] KVM: SEV: Add certificate support for SNP_EXTENDED_GUEST_REQUEST events
Date: Fri, 21 Jun 2024 08:40:41 -0500
Message-ID: <20240621134041.3170480-6-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3D:EE_|DS7PR12MB6069:EE_
X-MS-Office365-Filtering-Correlation-Id: 33a74383-3b02-448c-83ce-08dc91f86363
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|7416011|36860700010|376011|82310400023|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pNJ9YuxAQYy3pByXeOIYeUTRLUqJmyLMlS8XL83FiQ3hnQE9UcVVwnWl0pHI?=
 =?us-ascii?Q?mwbTGSaWA8bKTEj2sRS72GhQXq5/tli0cVb08E6ZaReLi4iE+BZpsqQeC4aD?=
 =?us-ascii?Q?20dETrAEx05sUSeLCQXRhco4N0UoIqE5KP9BtON6KkNShE/rqSLz4LQYv16Z?=
 =?us-ascii?Q?W6FFnztfwPpCIdWuqgFuTfkPB9imblppo73nVYOydeBuMMYTRL2mS85vvVxn?=
 =?us-ascii?Q?Sdy6EKacYyhI7OKz9EOIAYP8JACHhpLRw6eif9Y/31lLxeOBMxFejCTvUxXg?=
 =?us-ascii?Q?Tz7kRWoG3KcFVVsjgMsPlm7JQ/t8cT89oFji9hlKkEkaXDvgLQ3JTRPAr748?=
 =?us-ascii?Q?ze+ugNl8llTKVLA3UIzPmr8F8kIdM/CyT3382Uw7oUTYHNUfwr6TrabfTiBI?=
 =?us-ascii?Q?pYSmoWCcBG+EQAp/l+bCCzR0958IOBkyWrWSj0pIu+3zUu850HimFFmvWsI8?=
 =?us-ascii?Q?an+jO2iuE/6byaSIYMMk/bQMqj8yJElfMqAcCiHudXPuxQFXzkOevTMDySoH?=
 =?us-ascii?Q?mvN+H6moq/HZOg3R++xHgXBw0HwZkXr41vzemXrXF/b9PqOosKpF21IO6D6X?=
 =?us-ascii?Q?Ow+D6B4wncFMOYHfJsKkexPgbqgzawnrspzCqZSga+fioIhtcESFj7D/Ay72?=
 =?us-ascii?Q?i/G3awvrQNDCwft2hXOM5Pv5yD0H3z+U04Ha4StfFwn34dGCRtWXEU87kV71?=
 =?us-ascii?Q?AcKShh+kVQT5QMC5AsjapB7rW0VcEI+kgnIEM2qyZwNkfDx33+e5Ll8zSyP1?=
 =?us-ascii?Q?tBdd+5HkIq6Tec69TrQNK/cRAIwpT8kSY8CEOm93wgSPsRcKLXr/LFhdn8ik?=
 =?us-ascii?Q?1xq4Pnqihpay6Bn1m9CqXe3leEbD/G9PeKz9/GEfexPLD1+SK9bV+YFh4XXJ?=
 =?us-ascii?Q?Fu5Bz0xN7v4V0IOil0tmlZvuvtdbb7cjBjVPnY8AiPymvVaHjawGsH+EE08l?=
 =?us-ascii?Q?SZ6YJpGNdgjEu5PluF52O55AqMeNtfplUjf3/blzHf+tOKCfDYkiRzBzooVA?=
 =?us-ascii?Q?uDP+NUOL16gJKWLZgLysRIA16DlMzMx0xOuv3EGnb4uu0lH3YoW++JkU44Ht?=
 =?us-ascii?Q?QJdFtZEuBJA6/Tf3Lk+KH/GWpuIiHworwxvBL2+jAkczErXhO6EJLLcnkzXo?=
 =?us-ascii?Q?wGOgL0nsI/p/5jEWW7Ls00JeBWpCpSaSQccchsKNWBiL5j5wLiK8Gv35HV7r?=
 =?us-ascii?Q?E7Dw9sAWpl5RJLsQC4fNa9h6T0vTq6aaiuAgRD7ZCErGLjEmgepEuFcSfujD?=
 =?us-ascii?Q?4H+l35fKILHjopDP9fTe5EyYzxZNTScFK7VGuNkdR9R9PGtigp9GsXOPOz8L?=
 =?us-ascii?Q?iONdQqcXCyHvftbhUou50O2E2YQNMO/j0piveQP8i8FWuX19+s+XIWTQHC+6?=
 =?us-ascii?Q?30jSsuDAlJiOB/2TvWVSwcDXFuGSRRNRPDOuJj5k/ce/OqHqNw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(7416011)(36860700010)(376011)(82310400023)(1800799021);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 13:45:18.4525
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a74383-3b02-448c-83ce-08dc91f86363
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6069

Currently KVM implements a stub version of SNP Extended Guest Requests
that always supplies NULL certificate data alongside the attestation
report. Make use of the newly-defined KVM_EXIT_COCO_REQ_CERTS event to
provide a way for userspace to optionally supply this certificate data.

This implements the actual handling for KVM_EXIT_COCO_REQ_CERTS, so
allow it to be enabled via KVM_CAP_EXIT_COCO.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 41 +++++++++++++++++++++++++++++++++++------
 arch/x86/kvm/x86.c     |  2 +-
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b5dcf36b50f5..8af56a4544d1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4006,6 +4006,27 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
 	return ret;
 }
 
+static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control = &svm->vmcb->control;
+
+	if (vcpu->run->coco.req_certs.ret) {
+		if (vcpu->run->coco.req_certs.ret == KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN) {
+			vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->coco.req_certs.npages;
+			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
+						SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN, 0));
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
 /*
  * As per GHCB spec (see "SNP Extended Guest Request"), the certificate table
  * is terminated by 24-bytes of zeroes.
@@ -4027,12 +4048,10 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
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
@@ -4048,6 +4067,16 @@ static int snp_handle_ext_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t r
 		if (!PAGE_ALIGNED(data_gpa))
 			goto abort_request;
 
+		if ((vcpu->kvm->arch.coco_exit_enabled & BIT_ULL(KVM_EXIT_COCO_REQ_CERTS))) {
+			vcpu->run->exit_reason = KVM_EXIT_COCO;
+			vcpu->run->coco.nr = KVM_EXIT_COCO_REQ_CERTS;
+			vcpu->run->coco.req_certs.gfn = gpa_to_gfn(data_gpa);
+			vcpu->run->coco.req_certs.npages = data_npages;
+			vcpu->run->coco.req_certs.ret = 0;
+			vcpu->arch.complete_userspace_io = snp_complete_req_certs;
+			return 0; /* fetch certs from userspace */
+		}
+
 		if (data_npages &&
 		    kvm_write_guest(kvm, data_gpa, empty_certs_table,
 				    sizeof(empty_certs_table)))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 94c3a82b02c7..1a0087af1714 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -125,7 +125,7 @@ static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
 #define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
                                     KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 
-#define KVM_EXIT_COCO_VALID_MASK 0
+#define KVM_EXIT_COCO_VALID_MASK BIT_ULL(KVM_EXIT_COCO_REQ_CERTS)
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
-- 
2.25.1


