Return-Path: <kvm+bounces-17221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC0448C2BB4
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61A8D282C83
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 558DC13BAD7;
	Fri, 10 May 2024 21:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jHLT8x/R"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A864B1E50A;
	Fri, 10 May 2024 21:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715375996; cv=fail; b=a4ls7+DgxoYSALbLbtl23YcP13Dj0oPLxydDezuKLmh6FqRVd4sMmC3HUm+V+1On8Rk7/sFA/YmO/VbfXMYkk6n3BSGcn/WLIPPCSwEE0WxJEy6pQ22voIcAQqHBTm4tjTr1qT/GUcWEjKe8PQ+qKjcpEPHJ3pRcKauAf9+B9RA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715375996; c=relaxed/simple;
	bh=JixHu/uU3svMOWwF92FALmznoa5fkZ9Aw2T9/nNX3/4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PhI2Sq5Ox/8pk/RHAJnwpT65CqalU7L3baDHjOhoiPUtfv+W4ugZQo8nMiYYmcZBTJGrU+6C/WQg/7QoHGCTZ2N/xEAG50V9fVOntW6Q2yOmQaOHHGDAir4+fc+apYuekW0IXiEeP4zv+vXUafOxXwwj3+BkHGPFDwjO5WxAGro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jHLT8x/R; arc=fail smtp.client-ip=40.107.236.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AAEnGlx37briypQHLckVUt94+kMAh/V0HH0rUfLeJodeuAyLZOTNWKqoTVqCrSqHAoxdZnr2HgzhXrmO3uQXAp0MerNcL4msk218q3nfUdVRY2PpbPOMeIBS5QLziDugXZMLEs2xOP4CAnYzDiY1pbm7wTli9DOYaBTKbmpHlp8icbAGPNTZqj4/6Sqg24oVyqnqE2pXDlKF4eZAnwkitDFPWMB4ipMerMQA5KwpsasXwAZD7/tQVMHFoeGSVkJCLh4BqSWvBIjxp2SB6oGRzEuTCSc3aave4gsp7Xz7kSzDio73dg31/i7uGZ9++5GM8H7vCFsjBMN6rI4yW+teEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jmEjFmuunxX261Btm41kuX2m+2eXSfxymRpN4QvQzkQ=;
 b=bkcTLM06yvxyZFl/BYoTuxB6KswyY8zQu/dC7PeqRwgsM75nR3GW0zVxYzKntj6HqeHuX4CCU6X3SYiZQMzNmlxu1dDMT4ZM7v9xS4ejogZYd9x9HUjaL4XRJm0Fq7sebvulp6GxBSAJeOUff+JbZcAKHnNDtBZX2qiptU/ZX1augVUO48irq5u1R8bbe40DPtTFxjOBHKDAXyKeBii0WpX3IkURCKbGjBoznbH/YxJA3WCRIn33EyMrIwdD8+NwAQb/r4tglP5yX9iieKwp/HFkYlSfW6sQRVEsLqdeFlJYsaQ+nPbowEeKRvGvb8orSSF33K40ZxWnYlEJAAnO+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmEjFmuunxX261Btm41kuX2m+2eXSfxymRpN4QvQzkQ=;
 b=jHLT8x/RavyR+7Zp9yfGIcUKESr1d9FN+G0+cNA3EY35kIXphPWGvN12aGG4ARl/jDTSxS/ub+VHMdfZIQE6NG8k1EUL/XAoQXxrXR0rsODDWrKlhxgSZdiNUEAhPdzcH89fwsRUJz2nGH7Q/g8zo1nEWLybZ1Hp3SqW6VURj6I=
Received: from BN9P222CA0023.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::28)
 by PH7PR12MB6763.namprd12.prod.outlook.com (2603:10b6:510:1ad::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.47; Fri, 10 May
 2024 21:19:51 +0000
Received: from BN1PEPF00004683.namprd03.prod.outlook.com
 (2603:10b6:408:10c:cafe::e9) by BN9P222CA0023.outlook.office365.com
 (2603:10b6:408:10c::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.48 via Frontend
 Transport; Fri, 10 May 2024 21:19:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004683.mail.protection.outlook.com (10.167.243.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:19:51 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:19:50 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, Brijesh Singh <brijesh.singh@amd.com>, "Alexey
 Kardashevskiy" <aik@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>
Subject: [PULL 17/19] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
Date: Fri, 10 May 2024 16:10:22 -0500
Message-ID: <20240510211024.556136-18-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00004683:EE_|PH7PR12MB6763:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aa00738-61c0-42a0-637a-08dc7136edbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bSzWIYrLTV/7fUNlKc22lSUeh4/5hZfi+Mf9xQHzkT0OtAUR4q7THHFEO+8b?=
 =?us-ascii?Q?CqjtxKxGwxFw9h8FeUN5oeiQp3Vudbd82NUEaX2f020HieGkQhRiWP21GyKJ?=
 =?us-ascii?Q?sWA611Gpdr/UlGRY8Z2pKZ0doZFUCwCdIsRlLL6I8vXgyS2icsdiFA8jMiWg?=
 =?us-ascii?Q?20/malSpY/tzEvfRbexOyl7f/9FrxU18LcUv3MxHZavc0v/3yEI8HVx3KbUX?=
 =?us-ascii?Q?SR2fAjCgeeAO0O1it1K2rJWSJGuMM+4Wo4O7k/TH4lYDPc3p02sdjHk1O+cJ?=
 =?us-ascii?Q?ekMFSNzOiH5eQJMDoQ9+LYgm4f5TieyaAZncnDpxdtE18IGFAGB/owaIQwX3?=
 =?us-ascii?Q?CEaDiAMilNtDxO9pk7f9eGlDxBzU+5gBWw5ZfRpaJmdceXLu8empbBGqiB8Q?=
 =?us-ascii?Q?IVn0KgW/4pQEzUrD5f0+fb2U6nKTs6++Mn61AzH6zHKRBAgP/sUxK8sTsKMU?=
 =?us-ascii?Q?gCmfzK4BAIv+44JcyESB7oaeKhegejUxqhieVXJoXvrUJuAHEKJF1iBhH/RK?=
 =?us-ascii?Q?UOAHQMPHTZPoiwOgbucqrfC3ojGjKYyMy+bs7/6ajyxvsQSlf3NdeChvEEyt?=
 =?us-ascii?Q?cy+PR2Tw9K7K9Op/rAPS4v9RIE1m6eqjJaAs22wfap8OfVaBdJPAtu+Ft4pu?=
 =?us-ascii?Q?PIb5VeOmwrRmTp7ScfMrnWZllkC8k4pOq/x/k4bS1L+zFWnjxMY0N2dIxwpG?=
 =?us-ascii?Q?qlJg42kR+zCje8joNZJQm1i/yS3qflfRExK7aiRHg4SKyGYCFUaBRXg/E9NI?=
 =?us-ascii?Q?L/uk5S1hk6YSgo7md1eF/ZWvvtd5tF+5Kc+zF+vUA+30IjtndE9ekHtZeren?=
 =?us-ascii?Q?LGER01WIavKx31sqjpmZ49/I5wHapzYQYoVq0Hm+YdAJpSXxLoscYux7V/G8?=
 =?us-ascii?Q?1452BoM0MTOJR/3kM+xgva133OpVHArFpcj9RpWByoPf1zoFpBYu7MQIZ8lV?=
 =?us-ascii?Q?xbm+VTM97KaUZjHZXHqF+iiGxgZlBvkvbJpwGPVj/cWh3i8RLxt9Z+wi/eL8?=
 =?us-ascii?Q?gSOKSRciMp0/fYotnZXaO16bzQVg2Fyf51iS4osl7Mfms0VDqjUWJWjF86eP?=
 =?us-ascii?Q?jDFVwf0cCnAKXYGCFrX0tr1Iv/uog2B2HdgbxEThODEun3zkrRQg7I7fenc+?=
 =?us-ascii?Q?z8+bOeBgtlEEB0lquuXuGsPUTKabg9wvTW+dSN73xpkjP7N/d14yV92Dpovx?=
 =?us-ascii?Q?YiHnt67v+g/Es6aD1BigkfYrAEs8DTgCsNddnG8n3/ACkjJmY3h5C2k45dQj?=
 =?us-ascii?Q?/LCBQHuVlyGBQsi5ZFc39fEAFzJnznpg8uto4XzfEuZMudrIi2JvVeR3VDLA?=
 =?us-ascii?Q?JhmlcCyQpRKYeyi7gljc5CAnJ27Sw0y4GK+rZvQxNHMxQRHreDAg6QU010d1?=
 =?us-ascii?Q?xRx73cyBzQXVOBdw6/iTcgaBfRdq?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:19:51.0108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aa00738-61c0-42a0-637a-08dc7136edbb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004683.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6763

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of GHCB specification added support for the SNP Guest Request
Message NAE event. The event allows for an SEV-SNP guest to make
requests to the SEV-SNP firmware through hypervisor using the
SNP_GUEST_REQUEST API defined in the SEV-SNP firmware specification.

This is used by guests primarily to request attestation reports from
firmware. There are other request types are available as well, but the
specifics of what guest requests are being made are opaque to the
hypervisor, which only serves as a proxy for the guest requests and
firmware responses.

Implement handling for these events.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
[mdr: ensure FW command failures are indicated to guest, drop extended
 request handling to be re-written as separate patch, massage commit]
Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-ID: <20240501085210.2213060-19-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c         | 86 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/sev-guest.h |  9 ++++
 2 files changed, 95 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index eb397ec22a47..00d29d278f6e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
+#include <uapi/linux/sev-guest.h>
 
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
@@ -3292,6 +3293,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		if (!sev_snp_guest(vcpu->kvm) || !kvm_ghcb_sw_scratch_is_valid(svm))
 			goto vmgexit_err;
 		break;
+	case SVM_VMGEXIT_GUEST_REQUEST:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto vmgexit_err;
+		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
 		goto vmgexit_err;
@@ -3914,6 +3919,83 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	return ret;
 }
 
+static int snp_setup_guest_buf(struct kvm *kvm, struct sev_data_snp_guest_request *data,
+			       gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	kvm_pfn_t req_pfn, resp_pfn;
+
+	if (!PAGE_ALIGNED(req_gpa) || !PAGE_ALIGNED(resp_gpa))
+		return -EINVAL;
+
+	req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
+	if (is_error_noslot_pfn(req_pfn))
+		return -EINVAL;
+
+	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
+	if (is_error_noslot_pfn(resp_pfn))
+		return -EINVAL;
+
+	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
+		return -EINVAL;
+
+	data->gctx_paddr = __psp_pa(sev->snp_context);
+	data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
+	data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
+
+	return 0;
+}
+
+static int snp_cleanup_guest_buf(struct sev_data_snp_guest_request *data)
+{
+	u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
+
+	if (snp_page_reclaim(pfn) || rmp_make_shared(pfn, PG_LEVEL_4K))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int __snp_handle_guest_req(struct kvm *kvm, gpa_t req_gpa, gpa_t resp_gpa,
+				  sev_ret_code *fw_err)
+{
+	struct sev_data_snp_guest_request data = {0};
+	struct kvm_sev_info *sev;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -EINVAL;
+
+	sev = &to_kvm_svm(kvm)->sev_info;
+
+	ret = snp_setup_guest_buf(kvm, &data, req_gpa, resp_gpa);
+	if (ret)
+		return ret;
+
+	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, fw_err);
+	if (ret)
+		return ret;
+
+	ret = snp_cleanup_guest_buf(&data);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm *kvm = vcpu->kvm;
+	sev_ret_code fw_err = 0;
+	int vmm_ret = 0;
+
+	if (__snp_handle_guest_req(kvm, req_gpa, resp_gpa, &fw_err))
+		vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
+
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -4186,6 +4268,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 			ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, GHCB_ERR_INVALID_INPUT);
 		}
 
+		ret = 1;
+		break;
+	case SVM_VMGEXIT_GUEST_REQUEST:
+		snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
 		ret = 1;
 		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-guest.h
index 154a87a1eca9..7bd78e258569 100644
--- a/include/uapi/linux/sev-guest.h
+++ b/include/uapi/linux/sev-guest.h
@@ -89,8 +89,17 @@ struct snp_ext_report_req {
 #define SNP_GUEST_FW_ERR_MASK		GENMASK_ULL(31, 0)
 #define SNP_GUEST_VMM_ERR_SHIFT		32
 #define SNP_GUEST_VMM_ERR(x)		(((u64)x) << SNP_GUEST_VMM_ERR_SHIFT)
+#define SNP_GUEST_FW_ERR(x)		((x) & SNP_GUEST_FW_ERR_MASK)
+#define SNP_GUEST_ERR(vmm_err, fw_err)	(SNP_GUEST_VMM_ERR(vmm_err) | \
+					 SNP_GUEST_FW_ERR(fw_err))
 
+/*
+ * The GHCB spec only formally defines INVALID_LEN/BUSY VMM errors, but define
+ * a GENERIC error code such that it won't ever conflict with GHCB-defined
+ * errors if any get added in the future.
+ */
 #define SNP_GUEST_VMM_ERR_INVALID_LEN	1
 #define SNP_GUEST_VMM_ERR_BUSY		2
+#define SNP_GUEST_VMM_ERR_GENERIC	BIT(31)
 
 #endif /* __UAPI_LINUX_SEV_GUEST_H_ */
-- 
2.25.1


