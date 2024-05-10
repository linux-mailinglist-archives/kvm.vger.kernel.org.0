Return-Path: <kvm+bounces-17211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45DB98C2B9C
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:17:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 950AC284132
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1BC13B5A8;
	Fri, 10 May 2024 21:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BnmIX+dG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFB910965;
	Fri, 10 May 2024 21:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715375810; cv=fail; b=tADiOXrGtHIUJyuLayQ4MPC+cXhwwxbMDumwLGacR8bcbZlDbpPR39+WaucEXud2EcrFMnLhpgb4KGRP5tyzMgcA6zNitAhXvI+s7+V/KuRlGc/hQruiSGwJVhDff8+ARvEkEugUV0yZ8SOiVvf/ruX2tIyFmHH6uSpsZd3Xoco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715375810; c=relaxed/simple;
	bh=D5/zhkzTJtnrrlQQgGLNxhsdc8j+a8i8OasY8I3hFlI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PZGIQfg9jTfkZo2Hq6rIEWMYTOPZTBXdwiPaBUom0vk4Msummfkpy9UYtKiQj+8fT/3CyIwDhLl5Ulp9Aeqbc8WSi3dUI02yRdB7PNl6SCI+s+DVlP4wbReflkazLbUf8fl0db4eueYBFiw7o1JzSQgNH8WuKIhbqRODKYOg7wI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BnmIX+dG; arc=fail smtp.client-ip=40.107.237.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D93hesj+Xs73c+18Mv7G90Y88Vrfkhj8SGK+TqhIukhyeFjuot8GswIom0T752WCMbwBX1jD8r01MEKZ+CWWUFgmFOHAYxS56z8FMxs7F1MzUtMhC4SRYmRRJznFmyb0kQDv967ZKyXGjA6lyJDqliJJYoBtZQ4AN+aSe0YmiSkSPlVEvYzE3LSMrLMS2D7Eh2ruKQnRj2MugDe2XqLCZoaNNq7MVJQtMe0nxocwmXd4zW2AMHOLLjDsbQT1iddEYE0oxCszp20IfO4ZzpwXO+I8/6WPYO7/pyYtLTaGzbxGURGXrKN+C8j2gZbHXpQ4aHhX+P/wPz4zwjsAgnahBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UFEO5SmyF0oWrPZ7nUuIexGoqYZkyKvmdb92QQ4fnfQ=;
 b=lQWHKprjrg+2VB94wGl9ghGvUUCz0yLLnVsjypozJYdg29uX5cnVqkPUEwCseH/Ba6xEyJ2N3RAdQZyAGUly7GVSHe+iGLkZHrjXvDtLY4+Bh/KWhoGpaaKqfnSR2JZZXuRtrs0IwbJ+8X6YrGtB/DSgCEs0P7KYdkmxlP+idSZOLlRC3OhBtAJJfSptP3pWJ1mgA1PtuUR2CgfI7DHDzR5GhOAAQoXIGZHaHIxEcAWOOMmZpH9VPEdzHdwsjhk4RRlRq/Gt9VwbOKablJKLaz/EVma7iBAIO3U+E7s6yaBPlC3jC3XnMtT+SyHlKttFnnv4N2r/1bfGYaMXIFL7sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFEO5SmyF0oWrPZ7nUuIexGoqYZkyKvmdb92QQ4fnfQ=;
 b=BnmIX+dGqEKXpdxJHyy+PysrXTfUETn2PyuK/2InM4my0JF2ol//12gjZ9TSMRXg7nXh4eHLIJEnkmpFoV08UigNN1OBkbkC81T++GfzTQQuXVDm0D/viBn5Vx7RL3PLUw5NT///5wtOb4+NnnnJElM4jV2JSoQyZ9Z2gdj9y78=
Received: from BN8PR12CA0023.namprd12.prod.outlook.com (2603:10b6:408:60::36)
 by SA1PR12MB8598.namprd12.prod.outlook.com (2603:10b6:806:253::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.48; Fri, 10 May
 2024 21:16:42 +0000
Received: from BN1PEPF00004680.namprd03.prod.outlook.com
 (2603:10b6:408:60:cafe::61) by BN8PR12CA0023.outlook.office365.com
 (2603:10b6:408:60::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51 via Frontend
 Transport; Fri, 10 May 2024 21:16:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004680.mail.protection.outlook.com (10.167.243.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:16:41 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:16:41 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, Brijesh Singh <brijesh.singh@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>
Subject: [PULL 09/19] KVM: SEV: Add support to handle Page State Change VMGEXIT
Date: Fri, 10 May 2024 16:10:14 -0500
Message-ID: <20240510211024.556136-10-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004680:EE_|SA1PR12MB8598:EE_
X-MS-Office365-Filtering-Correlation-Id: e05c4757-553b-4eb7-d4bb-08dc71367cf4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nL/8m+dlrXevcz08fGkD7WwVmA5n3hKGAG8LVfzCB1jdcwaIRBzZzUpuacUT?=
 =?us-ascii?Q?jl1PXIdtJudymilyQFBTOxo0vt51YzKD0oZsb6thtiTzcEW8yPHdge3ajtvw?=
 =?us-ascii?Q?sfe1TiHLdA1ix6AkqNNjXT5iLzsYXLycZNfJXRWLzkcAUuQ5Mul1wBb98c7v?=
 =?us-ascii?Q?gV3TqXHD/M5Ju0BnUHnXDZ0Hd2j86I2mHWChAsnQ4jwITJKGrLqjuj8zNZmz?=
 =?us-ascii?Q?Cuo2SAYek5ptnEj8WkMbEo/FidYTMyWShRATW2ZGvjndNx+IUAqX9s282KIi?=
 =?us-ascii?Q?XC14SzS4lAw9J8WGbAq4Po3ntlPLTEJoEcUxHsZ1b4c643vKu/OAPiTnYVJV?=
 =?us-ascii?Q?5K9p6DziSxOZYKwnqPn1Wa/GHHKlxT5+wkGxraL5D15N+zbDSF3D3qSRp/Rg?=
 =?us-ascii?Q?CGB1FwyXWeloExTIzjsBWSVa+PgjXapdcReMYOrY0TmC7OrxM3lKH03HKKhJ?=
 =?us-ascii?Q?d6BBGYvA+OfWyw1eHRc/Xio/TS+T5+c36sDlDqVB9u6dhZ93WaP3ZTtYFl9F?=
 =?us-ascii?Q?dJacggn4mCD0R32MVdSjJDO3ByaRCzn3ZkbhOD9WeR9UhfnNFsH9nfQPdhEx?=
 =?us-ascii?Q?tW+KkHYSFlUY4bZu4HmlJQOyCj2T/Yznbn8viIXLk7wNA1/IGxKQbXiaPZMY?=
 =?us-ascii?Q?tRLPQY0Nve9XW8/MiFGxnl4X68vpa0PRI8Q9Vy4bU0paySh1MN3cVXUXsepo?=
 =?us-ascii?Q?BrjnjCn1X9oBxoKTQdDbbhbpb1uFEc8RBQb6DYDrjuof1Eg0X+SoyI4oJKwv?=
 =?us-ascii?Q?1s+khdHAg0zhTrdLKQcU+KW66uYvhW0W858wJTyffks39VtyQZhf/UPRLxdk?=
 =?us-ascii?Q?ErtCZxJKDLo+9VOUlE8jUBk1G3+vPZ+ngXf4Rvk8y8wcQY8eaU8myERmEoMH?=
 =?us-ascii?Q?bD0qePq2yZmRig+pR3/2xGXFqNfpkWcUg5pkBi/FclvWXWKGvQFbiqwZuTl4?=
 =?us-ascii?Q?8U8qvZQzRqeOwFOdNrjUIgSNAkvW/yXRccuWThBH1m5VFkMPJyCLYtYcpAtf?=
 =?us-ascii?Q?MnrXtJT4BuO9XK7qw4ix8hMDeeqdHkmXhaTtq+judA51g+PvHfGmv6xxVjhq?=
 =?us-ascii?Q?BGjWvlmjkmyYErpbZNFGNjij0Ac4eZbQgTMVboZWnDFU0Ioy/q69VpQBHPoL?=
 =?us-ascii?Q?a7E2RW7pfGd137H9CESFsUnFc2wVrv5RS+mH8jvV3d6BG4OgTyFv/3MFn592?=
 =?us-ascii?Q?p3EiCJI7mnq6BK1boVCAd+GKPHCM9PEsgCO7EWndfhNlEs2lXdFfGnVEcCtT?=
 =?us-ascii?Q?zBEi24q8s37OoYXV8PO0WYjidjtChsrgB0ff3YCjnOJfTDTk7wNBkr+fFIw0?=
 =?us-ascii?Q?T8VAVuwAaa02Qma8A/Bvx/oCS18RKQfNEai507bwSJC335yj4l4H5iui+070?=
 =?us-ascii?Q?M/N/9mc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:16:41.7891
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e05c4757-553b-4eb7-d4bb-08dc71367cf4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004680.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8598

SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
table to be private or shared using the Page State Change NAE event
as defined in the GHCB specification version 2.

Forward these requests to userspace as KVM_EXIT_VMGEXITs, similar to how
it is done for requests that don't use a GHCB page.

As with the MSR-based page-state changes, use the existing
KVM_HC_MAP_GPA_RANGE hypercall format to deliver these requests to
userspace via KVM_EXIT_HYPERCALL.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Co-developed-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Message-ID: <20240501085210.2213060-11-michael.roth@amd.com>
Co-developed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/sev-common.h |  11 ++
 arch/x86/kvm/svm/sev.c            | 188 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h            |   5 +
 3 files changed, 204 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 6d68db812de1..8647cc05e2f4 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -129,8 +129,19 @@ enum psc_op {
  *   The VMGEXIT_PSC_MAX_ENTRY determines the size of the PSC structure, which
  *   is a local stack variable in set_pages_state(). Do not increase this value
  *   without evaluating the impact to stack usage.
+ *
+ *   Use VMGEXIT_PSC_MAX_COUNT in cases where the actual GHCB-defined max value
+ *   is needed, such as when processing GHCB requests on the hypervisor side.
  */
 #define VMGEXIT_PSC_MAX_ENTRY		64
+#define VMGEXIT_PSC_MAX_COUNT		253
+
+#define VMGEXIT_PSC_ERROR_GENERIC	(0x100UL << 32)
+#define VMGEXIT_PSC_ERROR_INVALID_HDR	((1UL << 32) | 1)
+#define VMGEXIT_PSC_ERROR_INVALID_ENTRY	((1UL << 32) | 2)
+
+#define VMGEXIT_PSC_OP_PRIVATE		1
+#define VMGEXIT_PSC_OP_SHARED		2
 
 struct psc_hdr {
 	u16 cur_entry;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 438f2e8b8152..46669431b53d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3274,6 +3274,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_TERM_REQUEST:
 		break;
+	case SVM_VMGEXIT_PSC:
+		if (!sev_snp_guest(vcpu->kvm) || !kvm_ghcb_sw_scratch_is_valid(svm))
+			goto vmgexit_err;
+		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
 		goto vmgexit_err;
@@ -3503,6 +3507,183 @@ static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
 	return 0; /* forward request to userspace */
 }
 
+struct psc_buffer {
+	struct psc_hdr hdr;
+	struct psc_entry entries[];
+} __packed;
+
+static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc);
+
+static void snp_complete_psc(struct vcpu_svm *svm, u64 psc_ret)
+{
+	svm->sev_es.psc_inflight = 0;
+	svm->sev_es.psc_idx = 0;
+	svm->sev_es.psc_2m = false;
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, VMGEXIT_PSC_ERROR_GENERIC);
+}
+
+static void __snp_complete_one_psc(struct vcpu_svm *svm)
+{
+	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
+	struct psc_entry *entries = psc->entries;
+	struct psc_hdr *hdr = &psc->hdr;
+	__u16 idx;
+
+	/*
+	 * Everything in-flight has been processed successfully. Update the
+	 * corresponding entries in the guest's PSC buffer and zero out the
+	 * count of in-flight PSC entries.
+	 */
+	for (idx = svm->sev_es.psc_idx; svm->sev_es.psc_inflight;
+	     svm->sev_es.psc_inflight--, idx++) {
+		struct psc_entry *entry = &entries[idx];
+
+		entry->cur_page = entry->pagesize ? 512 : 1;
+	}
+
+	hdr->cur_entry = idx;
+}
+
+static int snp_complete_one_psc(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
+
+	if (vcpu->run->hypercall.ret) {
+		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
+		return 1; /* resume guest */
+	}
+
+	__snp_complete_one_psc(svm);
+
+	/* Handle the next range (if any). */
+	return snp_begin_psc(svm, psc);
+}
+
+static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
+{
+	struct psc_entry *entries = psc->entries;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct psc_hdr *hdr = &psc->hdr;
+	struct psc_entry entry_start;
+	u16 idx, idx_start, idx_end;
+	int npages;
+	bool huge;
+	u64 gfn;
+
+	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
+		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
+		return 1;
+	}
+
+next_range:
+	/* There should be no other PSCs in-flight at this point. */
+	if (WARN_ON_ONCE(svm->sev_es.psc_inflight)) {
+		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_GENERIC);
+		return 1;
+	}
+
+	/*
+	 * The PSC descriptor buffer can be modified by a misbehaved guest after
+	 * validation, so take care to only use validated copies of values used
+	 * for things like array indexing.
+	 */
+	idx_start = hdr->cur_entry;
+	idx_end = hdr->end_entry;
+
+	if (idx_end >= VMGEXIT_PSC_MAX_COUNT) {
+		snp_complete_psc(svm, VMGEXIT_PSC_ERROR_INVALID_HDR);
+		return 1;
+	}
+
+	/* Find the start of the next range which needs processing. */
+	for (idx = idx_start; idx <= idx_end; idx++, hdr->cur_entry++) {
+		entry_start = entries[idx];
+
+		gfn = entry_start.gfn;
+		huge = entry_start.pagesize;
+		npages = huge ? 512 : 1;
+
+		if (entry_start.cur_page > npages || !IS_ALIGNED(gfn, npages)) {
+			snp_complete_psc(svm, VMGEXIT_PSC_ERROR_INVALID_ENTRY);
+			return 1;
+		}
+
+		if (entry_start.cur_page) {
+			/*
+			 * If this is a partially-completed 2M range, force 4K handling
+			 * for the remaining pages since they're effectively split at
+			 * this point. Subsequent code should ensure this doesn't get
+			 * combined with adjacent PSC entries where 2M handling is still
+			 * possible.
+			 */
+			npages -= entry_start.cur_page;
+			gfn += entry_start.cur_page;
+			huge = false;
+		}
+
+		if (npages)
+			break;
+	}
+
+	if (idx > idx_end) {
+		/* Nothing more to process. */
+		snp_complete_psc(svm, 0);
+		return 1;
+	}
+
+	svm->sev_es.psc_2m = huge;
+	svm->sev_es.psc_idx = idx;
+	svm->sev_es.psc_inflight = 1;
+
+	/*
+	 * Find all subsequent PSC entries that contain adjacent GPA
+	 * ranges/operations and can be combined into a single
+	 * KVM_HC_MAP_GPA_RANGE exit.
+	 */
+	while (++idx <= idx_end) {
+		struct psc_entry entry = entries[idx];
+
+		if (entry.operation != entry_start.operation ||
+		    entry.gfn != entry_start.gfn + npages ||
+		    entry.cur_page || !!entry.pagesize != huge)
+			break;
+
+		svm->sev_es.psc_inflight++;
+		npages += huge ? 512 : 1;
+	}
+
+	switch (entry_start.operation) {
+	case VMGEXIT_PSC_OP_PRIVATE:
+	case VMGEXIT_PSC_OP_SHARED:
+		vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
+		vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
+		vcpu->run->hypercall.args[0] = gfn_to_gpa(gfn);
+		vcpu->run->hypercall.args[1] = npages;
+		vcpu->run->hypercall.args[2] = entry_start.operation == VMGEXIT_PSC_OP_PRIVATE
+					       ? KVM_MAP_GPA_RANGE_ENCRYPTED
+					       : KVM_MAP_GPA_RANGE_DECRYPTED;
+		vcpu->run->hypercall.args[2] |= entry_start.pagesize
+						? KVM_MAP_GPA_RANGE_PAGE_SZ_2M
+						: KVM_MAP_GPA_RANGE_PAGE_SZ_4K;
+		vcpu->arch.complete_userspace_io = snp_complete_one_psc;
+		return 0; /* forward request to userspace */
+	default:
+		/*
+		 * Only shared/private PSC operations are currently supported, so if the
+		 * entire range consists of unsupported operations (e.g. SMASH/UNSMASH),
+		 * then consider the entire range completed and avoid exiting to
+		 * userspace. In theory snp_complete_psc() can always be called directly
+		 * at this point to complete the current range and start the next one,
+		 * but that could lead to unexpected levels of recursion.
+		 */
+		__snp_complete_one_psc(svm);
+		goto next_range;
+	}
+
+	unreachable();
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3761,6 +3942,13 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		vcpu->run->system_event.ndata = 1;
 		vcpu->run->system_event.data[0] = control->ghcb_gpa;
 		break;
+	case SVM_VMGEXIT_PSC:
+		ret = setup_vmgexit_scratch(svm, true, control->exit_info_2);
+		if (ret)
+			break;
+
+		ret = snp_begin_psc(svm, svm->sev_es.ghcb_sa);
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 202ac5494c19..32d37ef5f580 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -210,6 +210,11 @@ struct vcpu_sev_es_state {
 	bool ghcb_sa_sync;
 	bool ghcb_sa_free;
 
+	/* SNP Page-State-Change buffer entries currently being processed */
+	u16 psc_idx;
+	u16 psc_inflight;
+	bool psc_2m;
+
 	u64 ghcb_registered_gpa;
 };
 
-- 
2.25.1


