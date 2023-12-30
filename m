Return-Path: <kvm+bounces-5397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F5238207F5
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:35:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51FFD1C2151D
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCB7414A98;
	Sat, 30 Dec 2023 17:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eJowD5NC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2051.outbound.protection.outlook.com [40.107.101.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5A4125DA;
	Sat, 30 Dec 2023 17:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8M9fvP9oCeT3ICPPsb2b1o3/5Nb7QfuIzjFP+qiO09d7zDl2sMBIdFtA6zr5tALFOOgv/s7cQCLenGWqn7mKxZlzJIZAQ0idTAWP6C8AnFmHss1MNaWJVJXjyTFeUJh4o2KfzhPyicqpFkGB7Uh2UiBTM7socADOnK7EDjFpoV+YGPRb5sIxjReIxhB+OgFxG2kfl70eoGhW2xlS3r3/kzs6pCCfYrFcZQDWdwh93D5IdyNMgpw/lUyp6QSGg9hzPAUCDDESKOzLQRW8ZnyhRFdTrAboZKSbDbBWqerj7jSaQaMninQOkGqvFUdd3eCazihDSGXEEO5u8gy7r2Xmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c83HM5braGtmsmOQhGi/rs5ShU/4UgIj0xjH/xtMows=;
 b=LPwg+wX731pwUhXhNF/SFjKh06vSJBZuBrPGRnLv49YA1nK2DSYHZN9F08Uct1FJWvUpVBfj0h/C7ldtp02xQiS4zeB+dIKDS/9zFfM4h2MLdGoSH7XFDLmAy6LUCcbHOw04ZEeBN4xzaxsj+z7Iqp28n/iQplUVw4Vm3BQklnnGkplfH5lQtaYCpsV8VWGx7Tj5e/fMFLRUxgj1DOJNsVcYXT506c98GLP8RKk/MlZyvfrxof0bB4AIVjxjtEvh+UTQcY6WFHReuDWda5RRjoTbh6Y7uk6WuWtbeFB/8uOZz1Y4Ag6oyvOaelfe3yQ+nyuz/4NdJKi+z6bt6jN9Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c83HM5braGtmsmOQhGi/rs5ShU/4UgIj0xjH/xtMows=;
 b=eJowD5NCC68zJsdfPmA/hVzlONYlxBMJhQ6NE3zsh4HOOiGwseFN52NFxC9PJfMuehZiTohSeY57KdlESTqh2N0sqdxK7zm7YG0vdow/tqQboohICGKJJbOk/FHGxErQrVK5pUpTk02XWg93knNJm7UOrSZlSpZyMFQ8ev/Jc6g=
Received: from MW4PR03CA0042.namprd03.prod.outlook.com (2603:10b6:303:8e::17)
 by MW5PR12MB5650.namprd12.prod.outlook.com (2603:10b6:303:19e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:33:44 +0000
Received: from CO1PEPF000044EE.namprd05.prod.outlook.com
 (2603:10b6:303:8e:cafe::4d) by MW4PR03CA0042.outlook.office365.com
 (2603:10b6:303:8e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 17:33:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044EE.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:33:44 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:33:43 -0600
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH v11 33/35] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
Date: Sat, 30 Dec 2023 11:23:49 -0600
Message-ID: <20231230172351.574091-34-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EE:EE_|MW5PR12MB5650:EE_
X-MS-Office365-Filtering-Correlation-Id: 06977612-de3a-4a6c-0b6a-08dc095d78bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XkssRwmS9CbE2bdAyGu63/Q6W9BrH8ZgAeu3mPlXMl8jhVkdQ7/qBCWNgJyLXazpEMgE8nE8CJ2bIaxuzhMziQK1E26wqMyeVl12c5oEcxAdn/dXlER22KG317UpbJm0F2dgqXqTvJY9ZI4oJGdzgGjhFPapHpeR1a6DP3C8DL2JwNIsLRR3x22F4fcP3yxYB2z9g17GE2DZ3TcJ+S1b3yiYKmfnqZYDcJO5wGJPV6TEfIGyZz6W78xVZ8LLS8SdNFp1kUd3Zwh14va8xwU+nYHaGIj8ZgKs51Pq5z2LHJouCVeHVa09jPBGyCYYoTjN4Z8ByLxXlX5aZMDJMrjDYLlk/h0yn6eUfE41DJpAC9v385h+JpFWAg4rUZM1S4Rja29RX8/7qQpPH84UISjUTFM0P+9XcowuYER7hCZjUkmhlpPFm9zlfgYRndMQWB5/ech4CdkaGiwSN5U9U5mex1/yDItNSoS5I7hmp7qLnM4dRlaNV1dhnKA7K3pCsyPmxv5EZSJKYb6lepF6H7d98zcOdr+EufA/4S9LaXTaYBt16vWd01W8GL3zJnswL1V3m4+b+RZNqmgiwZx79vusR7dYrstAOYiAFQ4m/0yELWNqXCdxJU9tQ8UegyGZQYZY5/iS0PWz6G787r+iNwcRmV/biBcSrhHE6bUE6D8phCtXpJiyPJqkyUiPk78zSVDI9mhU/AGIMqfey9x/XltmihMA7qIiEYdeGcYriCsWmuFFZs/5jKR24n9I+h+eIpim9ZhrTl4rKq3SP4msAGX5Ug==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(346002)(376002)(136003)(230922051799003)(82310400011)(186009)(64100799003)(451199024)(1800799012)(40470700004)(46966006)(36840700001)(40480700001)(40460700003)(41300700001)(2906002)(7416002)(7406005)(5660300002)(44832011)(8676002)(4326008)(316002)(6916009)(54906003)(70206006)(70586007)(8936002)(36756003)(86362001)(82740400003)(81166007)(356005)(478600001)(47076005)(83380400001)(36860700001)(1076003)(26005)(2616005)(426003)(16526019)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:33:44.0403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06977612-de3a-4a6c-0b6a-08dc095d78bc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5650

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
index 30a2e75fd94f..05051e36926d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
+#include <uapi/linux/sev-guest.h>
 
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
@@ -3109,6 +3110,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
 	case SVM_VMGEXIT_TERM_REQUEST:
+	case SVM_VMGEXIT_GUEST_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3539,6 +3541,83 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
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
@@ -3799,6 +3878,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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


