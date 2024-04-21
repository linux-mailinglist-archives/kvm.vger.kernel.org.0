Return-Path: <kvm+bounces-15437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B79208AC08B
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:07:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E691281199
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3313B185;
	Sun, 21 Apr 2024 18:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uflDKhja"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A542C3AC16;
	Sun, 21 Apr 2024 18:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722844; cv=fail; b=KEp42hxYDIy6zx/4Yf7vkstxag4ms5FNt9YMf++6UAdzjJGqyIG6AwLSnI+rC20psoelnsHi5ujhdgQdp4RgU9L6PLaQtulRNeF5clQxLCPRHO4ORFDbqDiPqZK3iaM3d5K/6NP9DaYcIDbe1eunPGGKJZ8ZoUzT54u+Ufr5VkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722844; c=relaxed/simple;
	bh=pWF0u2mpGDJtgifQogyt5y+fH+dXXArZ6mrOyLdvSfc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A7cKPdEIg+QfzVF8njuhOlzAZ5a49GqQ+LbAE4/QJ4sR36sxCY0INLVAyNLQEY7tN3SMPQ0hGPgCuevgQNo9E1rVnmtyYxvWEjdZd1saSuSV826HKfQ+wKzi7A9oeyLYJ7OF70UodQCSsQHDaPb34t5TADpRlVYKPFD5ZSXtEq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uflDKhja; arc=fail smtp.client-ip=40.107.92.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2DiXqKwXp5SHUvmgO4g7QDjkDxn2tacapMU7zlvDaar1+eqkIonR+WlgGsHB5xDq1yCFwSEG3zNVCvyS9xxYAUOHVCSnW18Xjbme1fxJC+rTJVNsODQHifPaD1UiMiaGdB5r7JIPuhU3FSMnFoQwalQp8VTmEKbLTQB+yOfUYY9lvjsb0FfZgbMn5ya36J0DIEJked1JNJCmb/qKMzNZRIA4ai1Sn8HPOCBQwuBUcauZClQgIY7cwveEh7iQAOCGdDtTQ05Alm6U1xKraps3jhk1zqoUp2TXFGs90yM3w5pjmDehSnMXiC4S1FRViXvqdqD7d8NQcDzD2sYMC3/xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bus4TEffan/BVjoh4Oajo39KRfhFAGiDquSIGK1ZPI0=;
 b=XXPD0qrvpI11XFwFWc59TiJe/4R0PmwhTuoz36d054dKVE+Z+Xt39QXmEdX9KSIsuw7AjMBLIFDe3xrbmGdisi0KdfbHP45ahd7w90OfXXtGbW5MSdtS25u8GaJfHIc1wHLx/9G4QQz8qEk+KLLkD+P6OUAEFdcPjZZpYS3EgeABEiqlU+WN3r+2F/9rQnbsWpoVzXq5G9/2IVL2a0xyrviRPxSdEz1YqQ3Aojan63s9Il3Sns/wuBk5WPSw0iw9E+XRADLHiOes3e+SQ7/XlyD20KSIPb8FPqBfvPDF01QyjrqsFwXt7XoaFb2l+2s36vAHLSO+cKYJ0clHXrM10w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bus4TEffan/BVjoh4Oajo39KRfhFAGiDquSIGK1ZPI0=;
 b=uflDKhjae0QSo5LCT472jzygfyQB6L0mZqAkIYv1AhsU6GuD1vO4PjaAJuHmTn+z3KyeCT2u1MPia/j7oRtKGNDn3ZtqKOBuGousE76jJC+jaJUTZda3FYI2wNB26TOwWEutXMvXf3tGBgyn/sjyZJDJNDZjdmqUXT0yRa7R/NQ=
Received: from BL1PR13CA0112.namprd13.prod.outlook.com (2603:10b6:208:2b9::27)
 by DM6PR12MB4171.namprd12.prod.outlook.com (2603:10b6:5:21f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:07:16 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:208:2b9:cafe::a7) by BL1PR13CA0112.outlook.office365.com
 (2603:10b6:208:2b9::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20 via Frontend
 Transport; Sun, 21 Apr 2024 18:07:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:07:16 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:07:16 -0500
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
Subject: [PATCH v14 19/22] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
Date: Sun, 21 Apr 2024 13:01:19 -0500
Message-ID: <20240421180122.1650812-20-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240421180122.1650812-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|DM6PR12MB4171:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d79f16c-498d-4a62-79a9-08dc622de0f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eCAG4AUg6Q6qW+/fzfhYTs3Ve+OfZUYy7xyWWHPiVB950i2vJOYwMnHL1KF8?=
 =?us-ascii?Q?7dx3qQMZTMmHQ9TStuZ+dgglm/MPAqXrG7mZfcn6JmHDblGy1Ew+M4ZA/9h/?=
 =?us-ascii?Q?aoz7a8TBxYE+svARcIHxU9gYbn7kj4tEXl8VF80UE7qX4+v3Fq+1/+AzgPxo?=
 =?us-ascii?Q?w4kn+vfvWgSotNbTVieFlFCWb79xn8BPCwQ0wefIdOOJJGAvNoIiPlFzFyZp?=
 =?us-ascii?Q?uHr/ZCo+wVe5bbFRMUVvr1B4utMxgtRqzlZkbmFLo/a4MhS1t51TQ/SHFaDe?=
 =?us-ascii?Q?gTbvzrBcrRnR8IxKoZhhIdVzXYtVfqRVKvPfXsRi+7BzYXcSnzS7WeRQV+vI?=
 =?us-ascii?Q?nf+xX1R5ek2Dmpjrh3GCrFBv1fXW+Qebk9TwiYVtanqGjxClm667YEdqpEd3?=
 =?us-ascii?Q?Py+yrWYdXe2WKQFJ7fdmkFyc6sLpevMCg1HdrS/E6+EFtDHzTvgWmqShsI5q?=
 =?us-ascii?Q?j75pOmlOY7F+tMUy9/Z4hvJRBhmwYGwzjNIJJn3mhDIJZiM5FxwY/T36x0LO?=
 =?us-ascii?Q?fIxPN91BEau7OAobro/jOSTioQtDABWDCWIX5cruzDTkvDDq/DManVh5y04N?=
 =?us-ascii?Q?ZFNEPpa3CV6v87JFLcmLaXnDLzO898sdncM/EylI3qmZlEyPN6p0uZzz0Yfn?=
 =?us-ascii?Q?8x6cf6qARLqHlDMoDZrCpjB6dK6zDvQz83XZEMKoJYCr5AcNaW4fdQxi/MaF?=
 =?us-ascii?Q?PMRSlWag6URx2oSzf36YTtHO7smMb2GzoNwjDuWX2N1ZLcypKzDe2Ir5pvSZ?=
 =?us-ascii?Q?Z85qxDTAiYkwbOanw6zAB6H9Mnu+UhIndb12ouVgbmS392OBLVw4GxLHXlXl?=
 =?us-ascii?Q?EBYt5y2pXAS33CH78aRJx6i6DurKnmeAecxFG6kNyEKFuG2SrF7+jP+R0yG1?=
 =?us-ascii?Q?o4t87PiBp/OhVPbCXOlvzOzGfuZEI1L/bCsjeiZVeRRZ4TAnAmRCpHBXb5q2?=
 =?us-ascii?Q?ZrGxmD4MgMNR7FUgGhvKdNoxSSEskdbOyH4LoMHcPZRUYsn6QLKqU+k4xAeT?=
 =?us-ascii?Q?qoVJXzR4lGIP91kRPtQQwwwnNo4yiUZWIKSxhpdiMq+T/nEGNxS63xoXgoBo?=
 =?us-ascii?Q?Sx5CL4sC8DFcULo7LRLASy7yzetSWvqSPEhFZ+Sb9thQtmtzllCOk2kuxtem?=
 =?us-ascii?Q?r+3DEoYXpCEUrYwob2CfmRdWlb+RV3bCzI0/hJwtIufNSTnnuZmwOpdrlUoy?=
 =?us-ascii?Q?X9UzG1h3VExG8M2kL65sHcjKAbRLrTn8CAcxlnGD5bBRUq+6d5XndGmkJ6AP?=
 =?us-ascii?Q?narOfu7o+K0C8ktJWuhsNz2CstHWNrBSYhRp4zzksioUhYmSCIdL4lRqnXnm?=
 =?us-ascii?Q?uZUDbFANtv2NhVMT8sj4etihekThoWdkOijTqa+aQ3zF/xpOLUqf3bqXzVqX?=
 =?us-ascii?Q?TAutWBQj8uxfKCRC8yydl7nHA77I?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(7416005)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:07:16.6114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d79f16c-498d-4a62-79a9-08dc622de0f1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4171

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
 arch/x86/kvm/svm/sev.c         | 83 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/sev-guest.h |  9 ++++
 2 files changed, 92 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c354aca721e5..68db390b19d0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
+#include <uapi/linux/sev-guest.h>
 
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
@@ -3290,6 +3291,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
 	case SVM_VMGEXIT_TERM_REQUEST:
+	case SVM_VMGEXIT_GUEST_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3733,6 +3735,83 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	return ret;
 }
 
+static bool snp_setup_guest_buf(struct kvm *kvm, struct sev_data_snp_guest_request *data,
+				gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	kvm_pfn_t req_pfn, resp_pfn;
+
+	if (!PAGE_ALIGNED(req_gpa) || !PAGE_ALIGNED(resp_gpa))
+		return false;
+
+	req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
+	if (is_error_noslot_pfn(req_pfn))
+		return false;
+
+	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
+	if (is_error_noslot_pfn(resp_pfn))
+		return false;
+
+	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
+		return false;
+
+	data->gctx_paddr = __psp_pa(sev->snp_context);
+	data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
+	data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
+
+	return true;
+}
+
+static bool snp_cleanup_guest_buf(struct sev_data_snp_guest_request *data)
+{
+	u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
+
+	if (snp_page_reclaim(pfn))
+		return false;
+
+	if (rmp_make_shared(pfn, PG_LEVEL_4K))
+		return false;
+
+	return true;
+}
+
+static bool __snp_handle_guest_req(struct kvm *kvm, gpa_t req_gpa, gpa_t resp_gpa,
+				   sev_ret_code *fw_err)
+{
+	struct sev_data_snp_guest_request data = {0};
+	struct kvm_sev_info *sev;
+	bool ret = true;
+
+	if (!sev_snp_guest(kvm))
+		return false;
+
+	sev = &to_kvm_svm(kvm)->sev_info;
+
+	if (!snp_setup_guest_buf(kvm, &data, req_gpa, resp_gpa))
+		return false;
+
+	if (sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, fw_err))
+		ret = false;
+
+	if (!snp_cleanup_guest_buf(&data))
+		ret = false;
+
+	return ret;
+}
+
+static void snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm *kvm = vcpu->kvm;
+	sev_ret_code fw_err = 0;
+	int vmm_ret = 0;
+
+	if (!__snp_handle_guest_req(kvm, req_gpa, resp_gpa, &fw_err))
+		vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
+
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3993,6 +4072,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		vcpu->run->system_event.ndata = 1;
 		vcpu->run->system_event.data[0] = control->ghcb_gpa;
 		break;
+	case SVM_VMGEXIT_GUEST_REQUEST:
+		snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
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


