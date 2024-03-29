Return-Path: <kvm+bounces-13131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37639892795
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 00:06:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFB75283273
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 23:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A50E13F421;
	Fri, 29 Mar 2024 23:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zeCqVAyj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2070.outbound.protection.outlook.com [40.107.100.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E9C13E6B9;
	Fri, 29 Mar 2024 23:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753544; cv=fail; b=BlqqvbGwutAw8URHIgMH30kvA5QpTzs/EidijFPe0fjFy5pMt6gU3Of58WmRgtLC5HdAFWEnpY91icLlr7eYlVXCT6T10fN7aOeDR+taYs5wJQZoRJMsxCRbI3XvUrIl79N5OhELjsPxchrIPeXAKecY7/mL+08bVpQeDnTw0Tg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753544; c=relaxed/simple;
	bh=WgjSuePq/wBpCSmmzUyRKNJcA65Zw60gyFDJt37grOw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tadVHjYp3xUeM32EvMaNxfyZwQQAKHmOqhQQ1XMBg9kHp+gJAurvOy+zAHBwq9zTbGuP/KUoD7IDeUX0jGzYICO/4kQRtEwkvcoBPNOkgirp3exZt3Mu9Ku4Nua7UCArN/3crAiO/9CE+CnJguzPNZzA3jmWHwQHpZ5TSvlUC9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zeCqVAyj; arc=fail smtp.client-ip=40.107.100.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTdfnSa1VhLOPKJevSaKvpUEM+ibK4JR/D4A9skjpRANTv9ZzuAloP8//3oASD3IdNwrh+OSRxi+9Iwq7hxH6bm72GCC8DmsKuP2rDNCei5s/4ioa7Mt0Rgv1Y/9zANhJ5bTNBTPlIJK6vKpaQdARBJ53qfdQwGiJ48PzqDufYciLrHxwSuTMItPHCXugbz1V3S9i0NMupUEJi2oKI/eevatNkz7jMPkOWb7myAeNRT+nOWgFlh4B1G5PybIF2KIVcmpb5vavCiFv2nXckLeBWe3CjlMqZJgIR/2tMwEHDDQjFAfKr1bkg0JIiZoKD5UYARcmLysUNDUnBW6ZIkQcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBu38l4H29f7TDioCJxMHGn5H0K24coARDh1fYxp94g=;
 b=Tm4mgAX85xml0c02ymLsi9tk5C41IzMLRHOGWwLnQtBjp1JDzL/nwJeVbnGSnlpvk1POZGeLGRF7uiH/vidV2sDKC96d1S85+P55F8F6RGYjLbU4K7b/V5SjUD5EXMBtRAVnjp0PDyxJrRMJyeAM6BYi8RyT7/DfjMT8G35q9tTlJjCWFv6owwahTlfvcX2HoILzjyrKqGAeDieGHKbYsmZOPTPErMVnPAJ8B7I8++OtLIDDvWXeDmrmLRbHlIemWx0QFJKcVf8k3aQiK3tidiyMuCzDuSs0Ua3O7Upae61Gh50WMtQDWQCbIiKYt0jiqt4Exm8sSBJz6uwIWduLZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBu38l4H29f7TDioCJxMHGn5H0K24coARDh1fYxp94g=;
 b=zeCqVAyjfRxDQher1AZ5EaOKxM5xY4BftFJ208BZWqiiAjXdof/d4iUhbP36IlOA01+A1BhxmrUQU0P14395af+BJG1LpGQu/iQfEYn8iwN6tfjzVCRINDzlsxLRvhiEfBgRdVKJmno9WURcApRABBx4LkwYntw5GkcQBk5RGlA=
Received: from DS0PR17CA0021.namprd17.prod.outlook.com (2603:10b6:8:191::16)
 by DS7PR12MB8346.namprd12.prod.outlook.com (2603:10b6:8:e5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Fri, 29 Mar
 2024 23:05:39 +0000
Received: from DS1PEPF00017091.namprd03.prod.outlook.com
 (2603:10b6:8:191:cafe::70) by DS0PR17CA0021.outlook.office365.com
 (2603:10b6:8:191::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41 via Frontend
 Transport; Fri, 29 Mar 2024 23:05:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017091.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:05:39 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 Mar
 2024 18:05:39 -0500
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
Subject: [PATCH v12 26/29] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
Date: Fri, 29 Mar 2024 17:58:32 -0500
Message-ID: <20240329225835.400662-27-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017091:EE_|DS7PR12MB8346:EE_
X-MS-Office365-Filtering-Correlation-Id: 29793531-e2ca-491c-1a60-08dc5044c08d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wFSuaKTvRQfOtdiiZggI/1E9juK+oJc2TRSGXFVjNQH6K1wlm9lAuRi2AABfWovQilmwMVXe1l6T4YxvGuuFifLSCpmtPQOHKjm6x+FajgbzHsEgtMX93cx5A0nttMe/qTI13yLMvcscLwhbPBIdodHYHhzKupmGusDKEUfIkuXqgoS46ONELQ8DpRVI7AvlT51VRqxW6w6SmGYUURqbArpcwis5lJT+cTvGNv8CqPtGPlIy7qfPPfuhv1nCIO9qPPfvEGlgl/Ec+LypJxBtqOEfg2pBgc02cbfF15t+YO5/ue5hwWk2QeyLY/PtzpC6Bue+8ZYMaLgW7iEG237ohWzAvDkoO5JuB0YjPr9df90ZKqzIesdCLnSdeqdDO9BO09jMyX5hg+vOmQmDRLp5MGJZ0CLEXxryinRjW60G57b7aoliHs448u+dW9OMhumg4geX6Ys+dNVlqiUHttX7q1i79Zld8UWIVQxAemTDG5c93reIn0O1bo2r+FTQzyNA60sU19YLtjGrE2CeHrS8UBmvPCHb+dNs/bwEdkpHaysGHJoMSSvphTWHY/GTjqyl61EyVKEXMAdKGOoJEKagRrWl4eg4UKhIYmIVTQyAvx7i9Y2qCbTYlvo+hUPDKlFswU7rnoRM5q0SJo084BAULraS65dFTt/wwZaFs/sG/Pn1sk4sqy3xCY8HS+L4Ka6jAqFvX2LdWGEJVaix3MvIE7CGKTb/0UI+9e3423/5muTUjwuXnqr/9ldh5/UD03xC
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:05:39.7301
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29793531-e2ca-491c-1a60-08dc5044c08d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017091.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8346

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

Co-developed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: ensure FW command failures are indicated to guest, drop extended
 request handling to be re-written as separate patch, massage commit]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c         | 83 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/sev-guest.h |  9 ++++
 2 files changed, 92 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 658116537f3f..f56f04553e81 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
+#include <uapi/linux/sev-guest.h>
 
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
@@ -3223,6 +3224,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
 	case SVM_VMGEXIT_TERM_REQUEST:
+	case SVM_VMGEXIT_GUEST_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3646,6 +3648,83 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	return ret;
 }
 
+static bool snp_setup_guest_buf(struct kvm *kvm, struct sev_data_snp_guest_request *data,
+				gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	kvm_pfn_t req_pfn, resp_pfn;
+
+	if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, PAGE_SIZE))
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
@@ -3906,6 +3985,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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


