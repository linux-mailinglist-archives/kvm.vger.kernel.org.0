Return-Path: <kvm+bounces-13117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A14F89275F
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:01:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 012601F25C09
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A00F13E6B9;
	Fri, 29 Mar 2024 23:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pOjtEGW9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF8D13E048;
	Fri, 29 Mar 2024 23:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753252; cv=fail; b=oTpN7PdEJ9jIspUxNioBOlLLcF6gzrnuC0L3riJfQ7nUsfL4QNoVwunMUVlptSptvbxOMApLqS1pt6A/PWO77bUtjZyw0SqEolJ5GWpiCdeoIjaHkOb2wgeWhODtGXom/3gq0/BFOh6FkrPXF6QE1Snmo+esqmXIauMuk9WfdOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753252; c=relaxed/simple;
	bh=fRe47pl494d1OFWUZ11O/mVIdyx956Cti3mXx9SL/40=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dJ5MMh8ioZKt/FZdKKyadx+msJsHY1CbQZ69izVUheIZzyChYuYpN+gUfLsILTypUuw2rDOGjty1IqOOdSpAWl3H3QNK8L3iR92pe//SOCvmnep9LHTTAcHFT1GorYPXzLJ2eoA4lJ1wtgzPb3w1MVAltEhI58Upuri1QXroDdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pOjtEGW9; arc=fail smtp.client-ip=40.107.93.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltxPzb4gC8CpZoT0mToE4xswkcDhnQWLRxkZQkARKc6uO6rmCINkuYyaHObH51zPODE6Z1l0EukNTsFrrMVoW5Do+xc8i+lunElm1VdacrzICPqGYcwAgeCcxwfwFQuqYFcVUQjiAJ4qiaWX/AA5y+d9Y3SD4Tf17CejubNk0nGjeJFwonDL3lKGmCWEpUTxr8AfsNCPrSGlhmltm7BmuOR8kDAsjuKvMh/+9FMn6YxlL3m+lMEWtJL5TjVjc/Vk+ywbDcGVBql2LkoWGlrxSDK5YkoAnDWSdjJEiSjnDCIvZJCJeu2H1obfRwuzvnN/EOXb0kEOel7QCK6HB49NzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/obp0nq9HpBfpSuTPA6s+n3JuXbuVzFzKzZUYOn/UVQ=;
 b=VMvhUTOQ2LFjZX5tQQ8jO627Se68WfKdj/PFQkVTb0p/JwxY6l514Q0ULuZuwZdWGfP+HP3z5VeDVFNFCqQGQeN8Aux7FdM0HQ8e1D2E9jkDB1dDs4DBcuSvHBBF90v4T/03uBrlgLy4VQZVWDWKpF1A2dcvht6vdALp9auGeGuxJ20lj/k1j3h4tbZ0lFqIkz/aWCyqVKNr+99GkZlqKvhtPSWkui8xKWwm1VJEN0zUiPKrQXOwlM0dQZvyKiahDLhWL3oZIQ7CAj9P6YScaO9+Zz0q9vaMzABl4coqFP6QXEWwwCLYUBGELAv3nSD9ExQIS08r0az/8KlgoA0DZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/obp0nq9HpBfpSuTPA6s+n3JuXbuVzFzKzZUYOn/UVQ=;
 b=pOjtEGW90KAdqaBSD5vBLGAQDENX/PrdSKwWhEu+ods4hZ40tPbULyRx3ml71Sy2QQdT0vKnFhxAiW9udjyUENct/EDHy9p9RYZeal7/Vc4iHnE1N2zsnhIagISLZXeUP6dj1+TxZ6YcY7zyz2/lDn7OBKmv0FVypT1UzsV57R0=
Received: from SJ0PR03CA0014.namprd03.prod.outlook.com (2603:10b6:a03:33a::19)
 by PH7PR12MB9224.namprd12.prod.outlook.com (2603:10b6:510:2e7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Fri, 29 Mar
 2024 23:00:46 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:a03:33a:cafe::88) by SJ0PR03CA0014.outlook.office365.com
 (2603:10b6:a03:33a::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Frontend
 Transport; Fri, 29 Mar 2024 23:00:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:00:46 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:00:45 -0500
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
Subject: [PATCH v12 13/29] KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
Date: Fri, 29 Mar 2024 17:58:19 -0500
Message-ID: <20240329225835.400662-14-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|PH7PR12MB9224:EE_
X-MS-Office365-Filtering-Correlation-Id: 194a5219-e203-4dc0-b9e3-08dc504411c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ycs7cffaR+L9MfxAEOyBdEsWMPoXz9kmxbblwgpKWIilVPU7CGtAhPCyq1vt/9c4Pd/M/CC3EGDTq01sbgh4akhO5kIDSzJ6lny7KwFac/rCZevlLfcjIrumooRLBXFxmkOs/40oJvYvIIQ+LFK9yCXkeoQtwHsqf3PKMHJxv6fpgKjfUdpssOnScs6mjla8PwVpEVosIFGCdI7r1JZNyDvxX3SlyZyZLg4lYCN1xPdCXnSnHSF5dhumiKgzMUKwhevLOUoaAOWcX24kbCt6uL9kGu91FeCP3JV1D6CLAM7VLU3QskfmYBJybMgNLkIdhEa2iyclFU1s3qkGzYiH4HBYXnUdKebcyOAefz/AaviBlwFihFlpiYJO+6ao3zMOLY+lA+R6lrVkVjDBhvcqaeXEFffySLIhLdnVJna2ldU5Ox2DCyxNCAxBd5yoo4iDi4WzrXbLPAAnxfj4eFn1STHmiaDhFLwA9qalQVIPpV5U7Q15uVg1ZFFtzvs3xqXFmT6RFiUISksUGAOocSFR0Q8clWMzffjF0cZCeb5/JX6aSZ5bYl7Q5FYjVUKbxN4RxMk2pyAJwMGTTyD7O8px+dG5ClEKYCBBKpfo9SMdBIqFEq7pRBrMc1zGTnaV/Y/r19BJ33Jq6oa+k5PaS3Jh1yrLnA+URxns4jBeuAqnCB7Y809tig4W4S8VIsy31b/VlspO1R/ttaAwuDFLYaYPS15DAB0I9ETJzF4kk8ttuHFPc/jgDXvpOGy8ZdM3L1Vq
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:00:46.4555
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 194a5219-e203-4dc0-b9e3-08dc504411c3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9224

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP guests are required to perform a GHCB GPA registration. Before
using a GHCB GPA for a vCPU the first time, a guest must register the
vCPU GHCB GPA. If hypervisor can work with the guest requested GPA then
it must respond back with the same GPA otherwise return -1.

On VMEXIT, verify that the GHCB GPA matches with the registered value.
If a mismatch is detected, then abort the guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/sev-common.h |  8 ++++++++
 arch/x86/kvm/svm/sev.c            | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h            |  7 +++++++
 3 files changed, 42 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 5a8246dd532f..1006bfffe07a 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -59,6 +59,14 @@
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
 
+/* Preferred GHCB GPA Request */
+#define GHCB_MSR_PREF_GPA_REQ		0x010
+#define GHCB_MSR_GPA_VALUE_POS		12
+#define GHCB_MSR_GPA_VALUE_MASK		GENMASK_ULL(51, 0)
+
+#define GHCB_MSR_PREF_GPA_RESP		0x011
+#define GHCB_MSR_PREF_GPA_NONE		0xfffffffffffff
+
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
 #define GHCB_MSR_REG_GPA_REQ_VAL(v)			\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 3d6c030091c2..b882f72a940a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3474,6 +3474,26 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
 				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_PREF_GPA_REQ:
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_NONE, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	case GHCB_MSR_REG_GPA_REQ: {
+		u64 gfn;
+
+		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
+					GHCB_MSR_GPA_VALUE_POS);
+
+		svm->sev_es.ghcb_registered_gpa = gfn_to_gpa(gfn);
+
+		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_REG_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -3537,6 +3557,13 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	trace_kvm_vmgexit_enter(vcpu->vcpu_id, svm->sev_es.ghcb);
 
 	sev_es_sync_from_ghcb(svm);
+
+	/* SEV-SNP guest requires that the GHCB GPA must be registered */
+	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa)) {
+		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n", ghcb_gpa);
+		return -EINVAL;
+	}
+
 	ret = sev_es_validate_vmgexit(svm);
 	if (ret)
 		return ret;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a3c190642c57..bb04d63012b4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -208,6 +208,8 @@ struct vcpu_sev_es_state {
 	u32 ghcb_sa_len;
 	bool ghcb_sa_sync;
 	bool ghcb_sa_free;
+
+	u64 ghcb_registered_gpa;
 };
 
 struct vcpu_svm {
@@ -361,6 +363,11 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
 #endif
 }
 
+static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
+{
+	return svm->sev_es.ghcb_registered_gpa == val;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
-- 
2.25.1


