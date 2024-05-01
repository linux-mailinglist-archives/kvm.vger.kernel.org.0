Return-Path: <kvm+bounces-16316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B9518B8737
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:06:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC8B61F22719
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A284502B7;
	Wed,  1 May 2024 09:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SZ1fMWAK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7888A4F881;
	Wed,  1 May 2024 09:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714554356; cv=fail; b=QqI8Rtg3IexSBf+dcdXhj4gQnSf116J8UxO667mn9A6QlsbfXMJ+GMo9pp+dnNgXQWt17j23cpNxo5x4AJWK1mMin4JxIGRxJyjFlNL3XFI/ZyZ4lURJFtTgJrbUcdcV+IomAqkMOXgh5Mu/2rsKEpsCC6Mk5Q69Oudnhgqwnz4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714554356; c=relaxed/simple;
	bh=sy2cOt+9o3XO29YvToEzahURb57X50jViXf/puyBieo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eWUKzh97um6y5OWQ/fR5RzQOSwnhvRnlWfM90xjOCa0JnE2PPuk+3UMxZwa/fIBbrEGEdLJcW4HQk0TbY9EGsowSCezSB8y9HGdUzmLgODLqBO4q0cgcN4uhDJ6Til2EZoqmZjx3gOOE4Ni4Ns4Qqpj5dpyiS3XEjBId5rkWUHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SZ1fMWAK; arc=fail smtp.client-ip=40.107.100.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XfYrVl9/goC4brzg/QQOXl518Yd0Wj7Um13k3hXNXRBFVw8rf7oWuSTpmbil7S2gV+CBWQuZ+xdu+1ny8wwNuHEz01RjTm2OtA3uWfdB2XI2bGXuKrGE7PtKqByVq/TvkmfzwqpCde23U+wB7c+Fl1CWhEJNsKUC6h0JjmNTC28UWW/NgFE5bAnfHOAk2Np80f3Jw5UvllAOla3kITtU06YAnRdALEJZTQHQn9y+1Xpi4Dkasc64Vqp+RuUXG3hBrW4hJEnkIVumILamLEf3amqhlEP4xbEv4rt56U5hwJ6B0uZVMn92bQIjlWc/XIB+shL4ybZN7apkpce/EXGoSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQbyuPzaOb+gGVc90x/XMaLFc7sXGq7Y/GylR/tiuKQ=;
 b=UwZiqTgEgUjZj7Zg3EVWAj4GcS6yEZP/kvFUKgLrWb1rqS+OL2wadXKCLBPZEDtNowLAU4UAdItCa6lnLLE5Qt0qtGFyZ3Ptht1q3+XAiTXaKxhXRs+o/jShfdt9TqElp+SRlK9f4ZfBKXYahA01rtgo30l/+mMDQghieYwVi64mGQTRCcBIu2r+CgXc5lfckLdxCAAtbPZQd7DKKCSaqtAdaaCZyEL09V/g0gMgeuEVsg3Xa7nm3f7pzC10uqJslKFAzVAUNNp2lkyAElLeXXoLTuiKObq2rwp5QKylleda/H600HHME2wAN5iHxgfzB4QMgE2pW0aPUYIxa/ZWcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQbyuPzaOb+gGVc90x/XMaLFc7sXGq7Y/GylR/tiuKQ=;
 b=SZ1fMWAKh8MSElpF4nZOf0aUZXby/B8TftVqawT40zBqyKXGiVq7Jc2Io/d60jDhpBkdKjGbVUaYQkCqLl3RIdDTZxjRrLSx2jt6NNxzhEYZbDudN9LdgC3YYze7M25MFLZkjcqCG8Bf4PeaKwJ6ZfhCNYr/OT42wbHpRN2NO/M=
Received: from BN8PR12CA0016.namprd12.prod.outlook.com (2603:10b6:408:60::29)
 by MW6PR12MB9019.namprd12.prod.outlook.com (2603:10b6:303:23f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Wed, 1 May
 2024 09:05:51 +0000
Received: from BN2PEPF000044A3.namprd02.prod.outlook.com
 (2603:10b6:408:60:cafe::a6) by BN8PR12CA0016.outlook.office365.com
 (2603:10b6:408:60::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.28 via Frontend
 Transport; Wed, 1 May 2024 09:05:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A3.mail.protection.outlook.com (10.167.243.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 09:05:50 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 04:05:49 -0500
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
	<brijesh.singh@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH v15 18/20] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
Date: Wed, 1 May 2024 03:52:08 -0500
Message-ID: <20240501085210.2213060-19-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A3:EE_|MW6PR12MB9019:EE_
X-MS-Office365-Filtering-Correlation-Id: 63416b37-e41f-4ce1-001d-08dc69bde5ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|1800799015|82310400014|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aAZEMNnskWWxV4GkMLp/qWPUuSVQ5DYSGpHj/GDIRiw4KuIUZogB2uB0OLdb?=
 =?us-ascii?Q?oEpX/qGOEQ7qGcPHIOAzuFLpkgqDsRaImvkM9Rc9X1XKzfwmVkCSE3z2/snu?=
 =?us-ascii?Q?arzu58ynAKFG8j6jlTjSP0rZjs5bNQ8QUeSMS+5cbSTIBMvIqZf8yHChg2Dv?=
 =?us-ascii?Q?PWWwbQYRIAyC+gUMxTWXAPNEayb7b5wRO5Mvg1Y/RWYSEfL88KoUYiZvbNW8?=
 =?us-ascii?Q?cHY1nXIrHLawvrNNXEOLCb22MdTHDi6WnTB76AEMPWwzl6FeFEsXzZFQ9/Hg?=
 =?us-ascii?Q?sfyIc1nZ8HSoZGLNpXm3VtKvhMEN4NQs2G5dsJAoN3XqfvQGINPPsUXir4Tw?=
 =?us-ascii?Q?6P6JhD1WZbaRPXTvVGBs9q92MA5FVgV7h5c/nTGI84tiF4a4kMVSu9RpgIYg?=
 =?us-ascii?Q?aP/CERPadN2eDXoiPiUDZTHVwPHrH2Ci7PJ8O/bJbmAs8is7ss+XWOUu8ED3?=
 =?us-ascii?Q?PGNY9atx9sB9u06MmUFVxJZdqeHfL9LGxLiP1NpOaYZNhENK4CiSuIWfJaEB?=
 =?us-ascii?Q?6YI9djfyqNf7WmxYQRNvaP5SmkfcaNsSZ2igcF0s0rmU0uPv5xLZv2UkmRXt?=
 =?us-ascii?Q?QsgzigV4P51fHY4azGHBG2TRHQzQEF5A2/rQWRtYOMLnYJXE1rAC44hKbDt8?=
 =?us-ascii?Q?kJ04ixvwwCt+7k1dZ464DjndFvTwriA8Clri7VcQ25IGW1IonD0ZXI+W8Alf?=
 =?us-ascii?Q?v6ccLb+9pTRYshC0Qk1Z81WYIBc3co+7zi1+Zxb37eUuqnY1u2EQCyLBrHqr?=
 =?us-ascii?Q?fIsWfJiTqRlsUh+box+XIj2ugPgGDY6f05BVL/VZCC3aH0K6VMs1nNV/2b/i?=
 =?us-ascii?Q?pti1Q21ZjDGlfssry3crtfaKePdOiDSVRegEtZsc7ZAaLZe1QtW+4N9X3LW5?=
 =?us-ascii?Q?sJOz+Vwb6/AfKM1D5uOoZap5wK9X877e7ull0+5QC2OfemNtbkJXsSlKlhBC?=
 =?us-ascii?Q?k3A4cp6kGWMWQSRuJtj1FzmUFVtC08tQC08Qn4Rx8vLEPD9/MGmPe9ZU9Mpu?=
 =?us-ascii?Q?mVItJIerXkGiC5gNixVf5m7NUN3BCyp9NJozMjiX1ftacDVq/opPkdaCyOKY?=
 =?us-ascii?Q?5X6jfEnA9g+VmFvwsJHopH/2HfaqJ2OASIAAqzoy1zHK/FmHKfuQZtPj+3c7?=
 =?us-ascii?Q?pE6aSuRg5ZyTsmKpioy48NeMMlBiAkVmI6mCnBTZl+NRMh9sPQhcMPeuh1pb?=
 =?us-ascii?Q?z6N+AVaywFzTJyyltLsaMzflDrjLYdMtzj0oHl70upZEASr3n4GGKYbkvQb+?=
 =?us-ascii?Q?p3D8QpLI/v+qx7/R8b866kR59WpjtlP4QR2V5EDAmZjWQbnBPzlj0VQy20g6?=
 =?us-ascii?Q?ZvW9Sr1DFZkuKJOAh4njI90HJ4xEv/ESH+CJxDYtzlmmwCY3olX86G7EOSZz?=
 =?us-ascii?Q?F/tJm6LGNG3AfHuYw4py1adtZqYL?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(82310400014)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 09:05:50.6327
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63416b37-e41f-4ce1-001d-08dc69bde5ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB9019

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
---
 arch/x86/kvm/svm/sev.c         | 86 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/sev-guest.h |  9 ++++
 2 files changed, 95 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 112041ee55e9..5c6262f3232f 100644
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
@@ -3906,6 +3911,83 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
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
@@ -4178,6 +4260,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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


