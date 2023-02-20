Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F0569D3C1
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 20:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbjBTTE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 14:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbjBTTE0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 14:04:26 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on20610.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8c::610])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F1A40DD;
        Mon, 20 Feb 2023 11:03:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgVTAgi+BvMjNS8x7+bNAsLn5LsX6cjQNXh+5hnm+Wa2fn8GKKuIFg+KsRvICrsi27+6IiB95RWsbp/Nf8Dn00ju0Sitq7VwbSwpGTwvzVPlr8iYF0vdjKnbal+c+UyeskpxU/7DYOTzMmNGUDIlCWwN0Sxy6aSr0onG+LVlKAVXKs7V7ujVyUQVvpIkn9C3gYqpTzo9L2S0Kkb18r2X0yNUfqPPejxYiX/PF9c0C5FDDDZUgJVLi9NDuM6be4k1eU4poKxCHQmFbqB+ws4n6SzzTrW2nNtDl+RDH81x2xDJjoRNSLQVT2jYcRwooNRhhBlL3HU4KxAPCPSR1yLeug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n1RRgjOiQpLZ01liN8EP3I2nWld/+bK90dZ8xsXbfg0=;
 b=TXx94yvyHe00XP83qM9vmdf069XK8xgKi3mu1T0X3c/6QQYJJ4dAqoFdVyp7HegKhlswaEJ92Pn5R9+0uMiE0JjKPpJUprUuKQxgM3tn+2TQbd/XSdxl9LVyvQnTWWcZEnSLDEvdl0bKEDQzQjdey1nFz9icYdfwj3f62KAxsX4+5ibQrEGx6Bvpl/5WnjCKi4j73SAyEvddzGpzu4Zkfjpxup8JNpr9L3q+LAZP9qewL8xalNUDrDIRJ1SYzUczMBXcfwQ2K1uUvSyND1pW9955ufj6VAM8P7rhs6jIVCiSFvQruZXoIS6Ue+3SmIi7AOgcL9AJ5hrFTrBSFoYQzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n1RRgjOiQpLZ01liN8EP3I2nWld/+bK90dZ8xsXbfg0=;
 b=ANa+rBtOjgJFCvgYhsNra63laCUt0BcdCUrUgm7cgdJg42hCv8pgJe+MU4wouA7hslGkEV4yUKNhCrlimR7jSaBYZBfgMcreK8Sa2rAA/RQlWgUVCbspWhhaDRoqlSIrd8RbRuw/Kh9zT9XeCIdM+ekdZHcFnWNbN+rXFpZpfv8=
Received: from BL0PR01CA0022.prod.exchangelabs.com (2603:10b6:208:71::35) by
 DS0PR12MB8269.namprd12.prod.outlook.com (2603:10b6:8:fd::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.19; Mon, 20 Feb 2023 18:57:11 +0000
Received: from BL02EPF000108EA.namprd05.prod.outlook.com
 (2603:10b6:208:71:cafe::d5) by BL0PR01CA0022.outlook.office365.com
 (2603:10b6:208:71::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19 via Frontend
 Transport; Mon, 20 Feb 2023 18:57:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000108EA.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6134.14 via Frontend Transport; Mon, 20 Feb 2023 18:57:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:57:10 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v8 45/56] KVM: SVM: Provide support for SNP_GUEST_REQUEST NAE event
Date:   Mon, 20 Feb 2023 12:38:36 -0600
Message-ID: <20230220183847.59159-46-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230220183847.59159-1-michael.roth@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108EA:EE_|DS0PR12MB8269:EE_
X-MS-Office365-Filtering-Correlation-Id: 54221cbc-b5c3-4812-b00c-08db137445e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gLmuCbEKzaTuth+0yRZxIwlvWr+NdutP/188OE1HqbeEZ6Vs33rM7IXyRxl/+75fTpA9U5A1sZXOjabmH/d9cNxM51O4E6qErXlt5jWhh4ZxKSaAjqIVWGJOvld5Fgiy95rbzymc4S93aQVi4Hd6vUMSRdJLZXNFEStmte9/YgWYbUOlarPnlrZZ4G76QZG4FkIGNH+jyoZ2RlUn8W0XsH3oI7MrVeUDMc6EBUuFWcRTRshbaa+biHoulSPPz3NokJVlmd5RCSUEfPbGt8/gW2o4yYJii78qek1pL2oYQwOf5IaK55Lr9xsx7jTS2ErTO9a9EjjAngFntFRaUWh4WlVT0EsCicok+z0zun2AhXm30OMGgT46BnsPIPFhxgOPZiNbDfyhDwHkXMgAIBT2klZx6jJ+k+Yul658c8C7qWFke1KVdMLXMTyVNhAxLuCLvCzVCwH9P0KoKral+7kQ7RpauNpN++9uEjeonh01zB5+8JkY4AbFmkHUpVaX0yiM84//4yDkns0gh+UEW+MK6NBk8QourTaz8yKUkqXM6X6QME+mmhlUTw35TUit7C+sunYRtH3NMKy+kTbUvwj5iWHagMW1b/vJnC7aOIL07aX9FXe5qWyA8uj028qliFMhpUVidhTNgO/495f3+aR8hh8SHSrz0USDPXGu56P9PACfwhjwiO3WFVH2ERJjoA7LxUdCUAm+qAlly6ykNdmUEI1wXTyPJnW+oNhmWL3p4ak=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199018)(46966006)(40470700004)(36840700001)(44832011)(81166007)(5660300002)(36860700001)(7406005)(7416002)(86362001)(82310400005)(2906002)(82740400003)(40460700003)(356005)(336012)(36756003)(478600001)(47076005)(186003)(426003)(16526019)(26005)(40480700001)(70206006)(54906003)(41300700001)(83380400001)(316002)(4326008)(70586007)(2616005)(1076003)(8676002)(6666004)(8936002)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:57:10.9540
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54221cbc-b5c3-4812-b00c-08db137445e9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108EA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8269
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

Version 2 of GHCB specification added the support for two SNP Guest
Request Message NAE events. The events allows for an SEV-SNP guest to
make request to the SEV-SNP firmware through hypervisor using the
SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.

The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
difference of an additional certificate blob that can be passed through
the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
provides snp_guest_ext_guest_request() that is used by the KVM to get
both the report and certificate data at once.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 185 +++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h |   2 +
 2 files changed, 181 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 197b1f904567..92179614102e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -327,6 +327,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		if (ret)
 			goto e_free;
 
+		mutex_init(&sev->guest_req_lock);
 		ret = sev_snp_init(&argp->error, false);
 	} else {
 		ret = sev_platform_init(&argp->error);
@@ -2059,23 +2060,34 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
  */
 static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_snp_addr data = {};
-	void *context;
+	void *context, *certs_data;
 	int rc;
 
+	/* Allocate memory used for the certs data in SNP guest request */
+	certs_data = kzalloc(SEV_FW_BLOB_MAX_SIZE, GFP_KERNEL_ACCOUNT);
+	if (!certs_data)
+		return NULL;
+
 	/* Allocate memory for context page */
 	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
 	if (!context)
-		return NULL;
+		goto e_free;
 
 	data.gctx_paddr = __psp_pa(context);
 	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
-	if (rc) {
-		snp_free_firmware_page(context);
-		return NULL;
-	}
+	if (rc)
+		goto e_free;
+
+	sev->snp_certs_data = certs_data;
 
 	return context;
+
+e_free:
+	snp_free_firmware_page(context);
+	kfree(certs_data);
+	return NULL;
 }
 
 static int snp_bind_asid(struct kvm *kvm, int *error)
@@ -2693,6 +2705,8 @@ static int snp_decommission_context(struct kvm *kvm)
 	snp_free_firmware_page(sev->snp_context);
 	sev->snp_context = NULL;
 
+	kfree(sev->snp_certs_data);
+
 	return 0;
 }
 
@@ -3153,6 +3167,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
+	case SVM_VMGEXIT_GUEST_REQUEST:
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3384,6 +3400,149 @@ static int snp_complete_psc(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static unsigned long snp_setup_guest_buf(struct vcpu_svm *svm,
+					 struct sev_data_snp_guest_request *data,
+					 gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm *kvm = vcpu->kvm;
+	kvm_pfn_t req_pfn, resp_pfn;
+	struct kvm_sev_info *sev;
+
+	sev = &to_kvm_svm(kvm)->sev_info;
+
+	if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, PAGE_SIZE))
+		return SEV_RET_INVALID_PARAM;
+
+	req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
+	if (is_error_noslot_pfn(req_pfn))
+		return SEV_RET_INVALID_ADDRESS;
+
+	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
+	if (is_error_noslot_pfn(resp_pfn))
+		return SEV_RET_INVALID_ADDRESS;
+
+	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
+		return SEV_RET_INVALID_ADDRESS;
+
+	data->gctx_paddr = __psp_pa(sev->snp_context);
+	data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
+	data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
+
+	return 0;
+}
+
+static void snp_cleanup_guest_buf(struct sev_data_snp_guest_request *data, unsigned long *rc)
+{
+	u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
+	int ret;
+
+	ret = snp_page_reclaim(pfn);
+	if (ret)
+		*rc = SEV_RET_INVALID_ADDRESS;
+
+	ret = rmp_make_shared(pfn, PG_LEVEL_4K);
+	if (ret)
+		*rc = SEV_RET_INVALID_ADDRESS;
+}
+
+static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct sev_data_snp_guest_request data = {0};
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_sev_info *sev;
+	unsigned long rc;
+	int err;
+
+	if (!sev_snp_guest(vcpu->kvm)) {
+		rc = SEV_RET_INVALID_GUEST;
+		goto e_fail;
+	}
+
+	sev = &to_kvm_svm(kvm)->sev_info;
+
+	mutex_lock(&sev->guest_req_lock);
+
+	rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
+	if (rc)
+		goto unlock;
+
+	rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
+	if (rc)
+		/* use the firmware error code */
+		rc = err;
+
+	snp_cleanup_guest_buf(&data, &rc);
+
+unlock:
+	mutex_unlock(&sev->guest_req_lock);
+
+e_fail:
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, rc);
+}
+
+static void snp_handle_ext_guest_request(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
+{
+	struct sev_data_snp_guest_request req = {0};
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm *kvm = vcpu->kvm;
+	unsigned long data_npages;
+	struct kvm_sev_info *sev;
+	unsigned long rc, err;
+	u64 data_gpa;
+
+	if (!sev_snp_guest(vcpu->kvm)) {
+		rc = SEV_RET_INVALID_GUEST;
+		goto e_fail;
+	}
+
+	sev = &to_kvm_svm(kvm)->sev_info;
+
+	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
+	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
+
+	if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
+		rc = SEV_RET_INVALID_ADDRESS;
+		goto e_fail;
+	}
+
+	mutex_lock(&sev->guest_req_lock);
+
+	rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
+	if (rc)
+		goto unlock;
+
+	rc = snp_guest_ext_guest_request(&req, (unsigned long)sev->snp_certs_data,
+					 &data_npages, &err);
+	if (rc) {
+		/*
+		 * If buffer length is small then return the expected
+		 * length in rbx.
+		 */
+		if (err == SNP_GUEST_REQ_INVALID_LEN)
+			vcpu->arch.regs[VCPU_REGS_RBX] = data_npages;
+
+		/* pass the firmware error code */
+		rc = err;
+		goto cleanup;
+	}
+
+	/* Copy the certificate blob in the guest memory */
+	if (data_npages &&
+	    kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, data_npages << PAGE_SHIFT))
+		rc = SEV_RET_INVALID_ADDRESS;
+
+cleanup:
+	snp_cleanup_guest_buf(&req, &rc);
+
+unlock:
+	mutex_unlock(&sev->guest_req_lock);
+
+e_fail:
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, rc);
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3633,6 +3792,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		vcpu->run->vmgexit.ghcb_msr = ghcb_gpa;
 		vcpu->arch.complete_userspace_io = snp_complete_psc;
 		break;
+	case SVM_VMGEXIT_GUEST_REQUEST: {
+		snp_handle_guest_request(svm, control->exit_info_1, control->exit_info_2);
+
+		ret = 1;
+		break;
+	}
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST: {
+		snp_handle_ext_guest_request(svm,
+					     control->exit_info_1,
+					     control->exit_info_2);
+
+		ret = 1;
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 13b00233b315..4a9ffb7e5139 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -93,6 +93,8 @@ struct kvm_sev_info {
 	atomic_t migration_in_progress;
 	u64 snp_init_flags;
 	void *snp_context;      /* SNP guest context page */
+	void *snp_certs_data;
+	struct mutex guest_req_lock; /* Lock for guest request handling */
 };
 
 struct kvm_svm {
-- 
2.25.1

