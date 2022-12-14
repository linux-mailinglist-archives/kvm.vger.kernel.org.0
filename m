Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9AF64D0CF
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiLNUMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiLNULv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:11:51 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1C02DA96;
        Wed, 14 Dec 2022 12:03:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M98Y7AplrkZsHnvB91hWD4a39RnwvUI5bkuYq/Jb9t3fATclMxTI5zB/Ura3/0EACMjQm7UEFsdm3dfthEWOso2/WNxrAKYPp5IdubW9Tu8AWlly1ZmiSmLsE12VPOmcOVzcQ6BwU8T/rHXj2WeowYA9rIocmacZy0P0WLGwDspAIdoxJ5fmRQ9Q5MuFcmpRMz7uSPidZg5VeA4p0yiw+TBf4/rkxmsoeLT2K2k35EiGZOewXRiqc853OSZguUytZo89iLF9WjlMphfw8C2RFFIL6PSX65CKbRrgA7U+Zo6ro6hF1nq5K5uFweezG2syecySw5BZekEgU7qJwwcxdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kcHgxzjqYwjC063icms3jxvHup+Y3pTqF5BVDiK80f4=;
 b=ONy9dZnF3z2gbJWrnDAO63LTbV0JOhyZxNTz8YEIHGLiaQb3kTwl43cTfub6SUueRomxk2NFz2ISZg48S+QV7uYrN7CB/xcmqM0RDmL1ZoCFv7rvgJU6iZzBGT7BH7ZDqx2ip6lkQQ/lVtydB+sA3PNG6GHVfsuPFS/hAMu1rVjCXJW6RD0kdviz0yy4JK6hzj2z5t/YIAaP/OisMmelBxoLO5QvPMc4dKjYrioccw2mO1oyeAARbe/00iHZKXFI+aeolakUhcwoFE8Gj45UPPiLTeLX9ATqptUYT76mKwvAVexCLWM9/PerhD2kryqdbvGXafM1VN6c21azbv7eBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcHgxzjqYwjC063icms3jxvHup+Y3pTqF5BVDiK80f4=;
 b=bcF89XXaLqwBkeCKZKHeTLgbhMdQU8MQUHUsbXibTGLnS2GM/BdxIL9NgDutibh+2DgND9Q97rQCUUiY2+i5aAy/PJ1/eoayZJJsYvIEG2DcXRRNwvIeh2K/Jx0ZZCwDSOh+hTUhOuiuDzDF2nAJWX2bcNzOHB0XAXNk3v0gTaY=
Received: from CY5PR22CA0074.namprd22.prod.outlook.com (2603:10b6:930:80::22)
 by PH7PR12MB6612.namprd12.prod.outlook.com (2603:10b6:510:210::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:03:32 +0000
Received: from CY4PEPF0000C96E.namprd02.prod.outlook.com
 (2603:10b6:930:80:cafe::a5) by CY5PR22CA0074.outlook.office365.com
 (2603:10b6:930:80::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 20:03:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C96E.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.10 via Frontend Transport; Wed, 14 Dec 2022 20:03:32 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 14:03:31 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v7 52/64] KVM: SVM: Provide support for SNP_GUEST_REQUEST NAE event
Date:   Wed, 14 Dec 2022 13:40:44 -0600
Message-ID: <20221214194056.161492-53-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214194056.161492-1-michael.roth@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C96E:EE_|PH7PR12MB6612:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f3ba924-27fd-4211-d22c-08dade0e46d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tllGmG84N4CHJw+DCzJko1kxNWqO20XTAgqJukrcMJPbs4xUsQvrD/1kgZUuvdaSgcoSQp8lIwSlU1iWL6cyNaS4QxvK64eSNRJXnAhgTUTJyVKoEIjN99wsFNathQhGE0IMBcwKsGeiYTCE8z5JDNyFC3EnDIu0N1ynXdh2hqu20PTN/0BpCDzLpqTrZXTX5xb6uVpydKgPIK9aUy1t194HOFnG2x44Jadx9y5mzmISAhkHJ92GLA10QanDlaQMJsc9fs066joR4RMDN8eWMHVIb6+Qsq+LrVPJKxDsLWZzdGL7vPt7BdU34HLp2TRE1tOMGuGGB7kGDf8drQYEQEVIEn5svugbHnCBOO1wjz9YZ3nIA0ZWv8nffdV7mwDTCvBg3GIRIRWvh5tnfUJd+pzPrmWBDXYDOwMS6L4H+lnHOEK0vz9LkPNfalucBIQrGpUvRQO9j9bbQ7s4G0UUvJiIvo5VSbp9ZETqm4I569+8+G1vAuL5EkyEVM/BtcKjyaP3tdkwZvxz/XyoLmfFIDR4LLPjpB9Tz5+agyC6z06/hrfXBClr/AURezz1V4cNXbjuoD/7PZ9XLjOQk/uDY5oRr2jXr2QcEJ1zYzoTnl+sz+URycisO018J1/yp3xY/EulBkBgMFOh3qizLlV33yMr7QI73cPBIbTW8SF1czJ/sbIuLESlWYst5I78kN3vknsREzY9+IZYnNuYus53tY+TknQfYWHqYlWj+pDVU2g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199015)(36840700001)(40470700004)(46966006)(316002)(2616005)(426003)(6916009)(70586007)(4326008)(47076005)(26005)(36756003)(8936002)(54906003)(70206006)(478600001)(356005)(6666004)(36860700001)(336012)(1076003)(83380400001)(82740400003)(81166007)(186003)(8676002)(82310400005)(40480700001)(16526019)(40460700003)(86362001)(41300700001)(44832011)(2906002)(7416002)(5660300002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:03:32.4004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f3ba924-27fd-4211-d22c-08dade0e46d1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C96E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6612
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 5f2b2092cdae..18efa70553c2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -331,6 +331,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		if (ret)
 			goto e_free;
 
+		mutex_init(&sev->guest_req_lock);
 		ret = sev_snp_init(&argp->error, false);
 	} else {
 		ret = sev_platform_init(&argp->error);
@@ -2051,23 +2052,34 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
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
@@ -2653,6 +2665,8 @@ static int snp_decommission_context(struct kvm *kvm)
 	snp_free_firmware_page(sev->snp_context);
 	sev->snp_context = NULL;
 
+	kfree(sev->snp_certs_data);
+
 	return 0;
 }
 
@@ -3174,6 +3188,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
+	case SVM_VMGEXIT_GUEST_REQUEST:
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3396,6 +3412,149 @@ static int snp_complete_psc(struct kvm_vcpu *vcpu)
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
+	svm_set_ghcb_sw_exit_info_2(vcpu, rc);
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
+	svm_set_ghcb_sw_exit_info_2(vcpu, rc);
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3629,6 +3788,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
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
index 12b9f4d539fb..7c0f9d00950f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -101,6 +101,8 @@ struct kvm_sev_info {
 	u64 snp_init_flags;
 	void *snp_context;      /* SNP guest context page */
 	spinlock_t psc_lock;
+	void *snp_certs_data;
+	struct mutex guest_req_lock;
 };
 
 struct kvm_svm {
-- 
2.25.1

