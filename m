Return-Path: <kvm+bounces-16307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D7C98B8719
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:03:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2DC61B218DD
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2B16502A8;
	Wed,  1 May 2024 09:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HSVTE4z8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A29351005;
	Wed,  1 May 2024 09:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554162; cv=fail; b=gwTXc7v/rnjduZdgOgbx6ShldXT6dhz3sBT/Jwru3T4ghAqpXfpGLPkAI6z/RGePWDB2s1s8Fiw+d96UNkok91DNDUQ9DcLSXM/lX6tPymvvyJsVhM40DSnnQAWakGmc2FgOtIssI7aY+7TLADgV2IkkRZh+yJ3h0dxasBnHzF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554162; c=relaxed/simple;
	bh=GLoCMJ2rRmvXLV+BJdDBF+Wy3eNsOQgzDw7g2sb7xS0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ilr4DV3Z4CdZUAx4jvZyW1HPipA9Zoeiu+zlq9oZCZxARQdY6cyKm2KjIbvVt/SmGjidLz6MW+2IQY3+BNa7ARLcvjoOQ9l0FsHRfFqfwuiJ5pfHe9OZBcCdjWoysIWrzDh3WRWPXgcLZF2lmfbYSGBhYdF+gA33BQXdFWf4QBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HSVTE4z8; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsjMTqLzqljwKTS7+PmG3KpcLO0j2VbcNtBL3LBS3iTipx3/dynHOzvbrWsurVyTRI3O3i0q0bZZyMk24eHNkKVoeAAklAe61aQz03KgjkmtjTNUAVS7UsWm1NtlLFanGxvqGNr0Cumzgz7ZswOesq4MqagpIsgyxMkaGsEXX3Iqwi69hG3wHqZRiPwRLoqIgtmnhlRPS9RYdlXTErW0HO+3l3JkghTxSez9eDXGYsUeazVZWPq6XiIDmFKcd4EJZ+77mVFAdVG+kq+XZnV8J0r/5rUeuaT5E5dWKWGJ07G+wj3DNcNAXPU4Soo8kME0CXg5qn0xIApEY5CUmqTSqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K95Qu3jRNV8CCBZ1X77fAEHfdK/7g4/JrIihX0urDA0=;
 b=n+PXtz8xsXRqEww8Iaq7kv4cf2n0+IsJL/wTFsLBi5XGXbm2SphPmp9O48c+RsGUHeUWepP/w/XD4K61xwo4rNSKtVtdeq5Z11L+A4twfxz+ckzfa9sWg9LuVosE70cAb7N59ZCWED4W6ugMs6ZZfsuQdcA+qYBSu2MS4RZTikaPONL13sfkeoDXs8YMO+g1UPItPWu9zlQtxJBULshlK8qsjC3Pa0vpwhV5KK7yHM84N8qtRTf3EOEPIBxK2HBJ4ADUx5/9i3Gwhn1R249z3EoPn/ZesRzE+8eEMrL1yupD2+SjsWkyjuRZ0Ba5QLexDpWp+iBGXAGNdsNQgoQyyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K95Qu3jRNV8CCBZ1X77fAEHfdK/7g4/JrIihX0urDA0=;
 b=HSVTE4z8znmqY9/TeTIDNK6NfqMV5zpunGfXqEbNH6IcTr4kkPJJpZxiNrsy21I2u9tLJq7d3EjpV7hoOW/SYUKEjewjyxoUgtJgpPJdm7TYSMbfhyoUmvMOPASPtO4F//JvPmjOMPzd1BAH3qpXrkCtfVEDxor9c8SeoQv8svY=
Received: from SJ0PR13CA0023.namprd13.prod.outlook.com (2603:10b6:a03:2c0::28)
 by MN6PR12MB8568.namprd12.prod.outlook.com (2603:10b6:208:471::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.36; Wed, 1 May
 2024 09:02:37 +0000
Received: from CO1PEPF000044F2.namprd05.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::d) by SJ0PR13CA0023.outlook.office365.com
 (2603:10b6:a03:2c0::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28 via Frontend
 Transport; Wed, 1 May 2024 09:02:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F2.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:02:36 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:02:35 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v15 10/20] KVM: SEV: Add support to handle Page State Change VMGEXIT
Date: Wed, 1 May 2024 03:52:00 -0500
Message-ID: <20240501085210.2213060-11-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501085210.2213060-1-michael.roth@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F2:EE_|MN6PR12MB8568:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f8a0130-3da8-4886-3204-08dc69bd7220
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400014|7416005|1800799015|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jHeYFUHX9Q5LWq4VI0747vy3KNHPf2V001po1lcU9Z7gQhv6JdHAkfoSz6ry?=
 =?us-ascii?Q?Uv/u9Q4ShQQwhYvSjAWCIZm2rtm/DIEqkykJAKTZFQDqJj/J0Wfmf1U/GSYf?=
 =?us-ascii?Q?Jx2DwHYrD5K7oDvIACaeIUTLObR3bhvTdzx+oC1ifwneZSv05Iyf4vlxX6S8?=
 =?us-ascii?Q?/69sAfEvl9FLh19sX/nHS1Fx9OCUXtvT/lVx2/uwAnQq4Yayp/aA/+whKy8o?=
 =?us-ascii?Q?t5yH/frBaGbS+Wg8NWp0lbe8thCNYncFW1dXsoR9/d99csaGvm1RbJ65t11A?=
 =?us-ascii?Q?uRYQEsbGhwtvtLaG9UcVThHZbuF97Eee0b48D0vV6IP0VY8JOngDyOWxF40n?=
 =?us-ascii?Q?tMxW0NcBnAsJ2eh1z1sRGdyPgdvP+yjb8BP9FOsLGqTNOq4JcwdwE3deBvoQ?=
 =?us-ascii?Q?cSzyKh8W9ToCJsP9s7HeJcBS5yx11gfbp//RlB8xY5JgSmaH/pz1JgGG0+q1?=
 =?us-ascii?Q?9WTSIhCi56RqONwXiyBZ9d2UuOPvN7lelsZqGAXR4hYhmBfWxKFffPsSC1RC?=
 =?us-ascii?Q?dxE2JsjGc/XTUvVKJh+y82ZoQaDHlJGEFWKqTRSHecCsXHAhRh2tOP7GFiQ9?=
 =?us-ascii?Q?Xv7pKZTZJk6Lj8IOtkJkNogX+7BJPGlB196IMKstoL5sLt8KBCumPSre1gzJ?=
 =?us-ascii?Q?OGWAnjoIAYjYTlZLtzz6M0H4YZM8bcsGW7YX32nV5mENpeYZVGSVeLYZrzhi?=
 =?us-ascii?Q?80tZKQsuo/u2IWxliad8gI7KPbprLixhqmuhxOwWdztRK6HiRJ9RmDlExdQM?=
 =?us-ascii?Q?EEDYVvDuQUWhfXV3bb1IwD7fxqThf2W3wfCsbPDsvM794Si/gnnGM4QXllL6?=
 =?us-ascii?Q?klFGSHIwE9BvJoDxrXF/MfAgEmSugHFimgljydhVX4j2dkHv9+5Szk5ji31g?=
 =?us-ascii?Q?X1gOGpgBTjAdPv0CiAjQfvEqN08ZTjViMM1XaQhLdTYevR+RTocT4yfS3k1v?=
 =?us-ascii?Q?5Uxz2BQXYcvVdlpWYxKNpVKjqrIpnXKhE/yAujTGbvkyBD1e4VySXPblc8uj?=
 =?us-ascii?Q?FoA1H4x8zyFBAfZc8ovGeaUzPT0dl3jn0DYXlpTEsrj+ln6n9FDLEAV8KdYy?=
 =?us-ascii?Q?/eOjyQ82RUm2HOBCwNRtH5Yxj61gBl39b8P6bQAR3InI3SqZvuoefN1iwMT5?=
 =?us-ascii?Q?hahmfCIEaLnD8neipgSWb10FOA/2cXAPQD7TV5SyxqlKAFGf86NdR0V4tSrF?=
 =?us-ascii?Q?cofVznk++zZ1C23E7fhHRORmxeZGAHg9NjN9A+uc07+25aTzX8wxW0mpWMu9?=
 =?us-ascii?Q?bLZ3mQLP2mTikFQmhIYtOMhxILf4YbNdR734aMQm+4sxwBfO4qwNBZj9CRWl?=
 =?us-ascii?Q?DOnr+0+MtJd85BSZhFHvPgyE4qqVjrYeU/s8dO2eohhnkpZWQuXZGMmqtPts?=
 =?us-ascii?Q?+n2KMtA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(7416005)(1800799015)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:02:36.2497
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f8a0130-3da8-4886-3204-08dc69bd7220
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8568

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
---
 arch/x86/include/asm/sev-common.h |  11 ++
 arch/x86/kvm/svm/sev.c            | 180 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h            |   5 +
 3 files changed, 196 insertions(+)

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
index 720775c9d0b8..70b8f4cd1b03 100644
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
@@ -3503,6 +3507,175 @@ static int snp_begin_psc_msr(struct vcpu_svm *svm, u64 ghcb_msr)
 	return 0; /* forward request to userspace */
 }
 
+struct psc_buffer {
+	struct psc_hdr hdr;
+	struct psc_entry entries[];
+} __packed;
+
+static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc);
+
+static int snp_complete_psc(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct psc_buffer *psc = svm->sev_es.ghcb_sa;
+	struct psc_entry *entries = psc->entries;
+	struct psc_hdr *hdr = &psc->hdr;
+	__u64 psc_ret;
+	__u16 idx;
+
+	if (vcpu->run->hypercall.ret) {
+		psc_ret = VMGEXIT_PSC_ERROR_GENERIC;
+		goto out_resume;
+	}
+
+	/*
+	 * Everything in-flight has been processed successfully. Update the
+	 * corresponding entries in the guest's PSC buffer.
+	 */
+	for (idx = svm->sev_es.psc_idx; svm->sev_es.psc_inflight;
+	     svm->sev_es.psc_inflight--, idx++) {
+		struct psc_entry *entry = &entries[idx];
+
+		entry->cur_page = svm->sev_es.psc_2m ? 512 : 1;
+	}
+
+	hdr->cur_entry = idx;
+
+	/* Handle the next range (if any). */
+	return snp_begin_psc(svm, psc);
+
+out_resume:
+	svm->sev_es.psc_idx = 0;
+	svm->sev_es.psc_inflight = 0;
+	svm->sev_es.psc_2m = false;
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
+
+	return 1; /* resume guest */
+}
+
+static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
+{
+	struct psc_entry *entries = psc->entries;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct psc_hdr *hdr = &psc->hdr;
+	struct psc_entry entry_start;
+	u16 idx, idx_start, idx_end;
+	__u64 psc_ret, gpa;
+	int npages;
+
+	/* There should be no other PSCs in-flight at this point. */
+	if (WARN_ON_ONCE(svm->sev_es.psc_inflight)) {
+		psc_ret = VMGEXIT_PSC_ERROR_GENERIC;
+		goto out_resume;
+	}
+
+	if (!(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_MAP_GPA_RANGE))) {
+		psc_ret = VMGEXIT_PSC_ERROR_GENERIC;
+		goto out_resume;
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
+		psc_ret = VMGEXIT_PSC_ERROR_INVALID_HDR;
+		goto out_resume;
+	}
+
+	/* Nothing more to process. */
+	if (idx_start > idx_end) {
+		psc_ret = 0;
+		goto out_resume;
+	}
+
+	/* Find the start of the next range which needs processing. */
+	for (idx = idx_start; idx <= idx_end; idx++, hdr->cur_entry++) {
+		__u16 cur_page;
+		gfn_t gfn;
+		bool huge;
+
+		entry_start = entries[idx];
+
+		/* Only private/shared conversions are currently supported. */
+		if (entry_start.operation != VMGEXIT_PSC_OP_PRIVATE &&
+		    entry_start.operation != VMGEXIT_PSC_OP_SHARED)
+			continue;
+
+		gfn = entry_start.gfn;
+		cur_page = entry_start.cur_page;
+		huge = entry_start.pagesize;
+
+		if ((huge && (cur_page > 512 || !IS_ALIGNED(gfn, 512))) ||
+		    (!huge && cur_page > 1)) {
+			psc_ret = VMGEXIT_PSC_ERROR_INVALID_ENTRY;
+			goto out_resume;
+		}
+
+		/* All sub-pages already processed. */
+		if ((huge && cur_page == 512) || (!huge && cur_page == 1))
+			continue;
+
+		/*
+		 * If this is a partially-completed 2M range, force 4K handling
+		 * for the remaining pages since they're effectively split at
+		 * this point. Subsequent code should ensure this doesn't get
+		 * combined with adjacent PSC entries where 2M handling is still
+		 * possible.
+		 */
+		svm->sev_es.psc_2m = cur_page ? false : huge;
+		svm->sev_es.psc_idx = idx;
+		svm->sev_es.psc_inflight = 1;
+
+		gpa = gfn_to_gpa(gfn + cur_page);
+		npages = huge ? 512 - cur_page : 1;
+		break;
+	}
+
+	/*
+	 * Find all subsequent PSC entries that contain adjacent GPA
+	 * ranges/operations and can be combined into a single
+	 * KVM_HC_MAP_GPA_RANGE exit.
+	 */
+	for (idx = svm->sev_es.psc_idx + 1; idx <= idx_end; idx++) {
+		struct psc_entry entry = entries[idx];
+
+		if (entry.operation != entry_start.operation ||
+		    entry.gfn != entry_start.gfn + npages ||
+		    !!entry.pagesize != svm->sev_es.psc_2m)
+			break;
+
+		svm->sev_es.psc_inflight++;
+		npages += entry_start.pagesize ? 512 : 1;
+	}
+
+	vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
+	vcpu->run->hypercall.nr = KVM_HC_MAP_GPA_RANGE;
+	vcpu->run->hypercall.args[0] = gpa;
+	vcpu->run->hypercall.args[1] = npages;
+	vcpu->run->hypercall.args[2] = entry_start.operation == VMGEXIT_PSC_OP_PRIVATE
+				       ? KVM_MAP_GPA_RANGE_ENCRYPTED
+				       : KVM_MAP_GPA_RANGE_DECRYPTED;
+	vcpu->run->hypercall.args[2] |= entry_start.pagesize
+					? KVM_MAP_GPA_RANGE_PAGE_SZ_2M
+					: KVM_MAP_GPA_RANGE_PAGE_SZ_4K;
+	vcpu->arch.complete_userspace_io = snp_complete_psc;
+
+	return 0; /* forward request to userspace */
+
+out_resume:
+	svm->sev_es.psc_idx = 0;
+	svm->sev_es.psc_inflight = 0;
+	svm->sev_es.psc_2m = false;
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, psc_ret);
+
+	return 1; /* resume guest */
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3761,6 +3934,13 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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
index bbfbeed4c676..438cad6c9421 100644
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


