Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACF7552815
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347500AbiFTXR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347089AbiFTXRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:17:20 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2054.outbound.protection.outlook.com [40.107.236.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6534222288;
        Mon, 20 Jun 2022 16:13:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQ+ujSRXQu2rFH29fdQqecB7DVekNsHyaksxaLVp+psOuMnS7jMz2USjoSxdSRp+FTLcLIP8OM35X8cd9ME2s4dd0W7y2A4wQjv3StzdrGpHrfZjSmZqxINB68C+Tv05HotFUfiJRZRNbr5r6Gs3qdtKlwWT3avtjKBLdrZmmJTbADWqmiHEdqb2L/AtP9vHqEVPLN0kavsPMCsVFDY65e00j4Lxm3Tl2LKHvh+U/ENIN5h7EDD4wxsPqpPrsOe6pJaKphxP9qvgWFS0ktgz4tMtmlzJF2Bt+nIUErkhKOvq9ZTeM/zC4nsKo3rVUgNid6rZ/HKRTjely1OkhVmGlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N5vZAvruY8jk4ZHYx3zGXcb3kuWmSvzDLrp4giV6UxM=;
 b=S7X5sMgjFym7FG9mAbfhhQoG2x4VaNtzRlphCgNykFC2BG39C34inoSLcG87jXDQNvfxLys3Pv3VHVqqy6M54rTDRyCATkhAbEzoDIBtPHK75Q9Y0FQhm8GK9bErr3eHeHdlTQOKIyJJRG1eUgevMzTfCaixATtSFfzW9ymhU/eontNldkKWKoyT62TzrTcdp5WKsjYIoV9LuuYPzQzFvMXN3HR6VQqW/qNoB2jVOciSkeW+qpv9zasfl2t/iHdgYpDst9m3OauSOoR/N0IxOBImV9hOE+XSWggpoZ7ZL+fnYeaFbQhj+1oLdq4rpn7+/kCmaNjj66190Ie++cxdWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N5vZAvruY8jk4ZHYx3zGXcb3kuWmSvzDLrp4giV6UxM=;
 b=PpLwULpEaTpiDu3/QbIT7O6iuVSZ4Qvf3fwn/8W7dEr6UKh586yMqVjK7PYqFuv78S65ORzHF0jxUutUua7A7o8I5pgmDOCLs1tJu41Boe/IXRQQQ85KAH2GlufH2CEbfJVAHzcbj2c9/zWa6JZQi8Oy7uNpRMQ4NZzjMinnIaA=
Received: from RO2P152CA0071.LAMP152.PROD.OUTLOOK.COM (2603:10d6:10:29::16) by
 PH0PR12MB5648.namprd12.prod.outlook.com (2603:10b6:510:14b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.17; Mon, 20 Jun 2022 23:13:35 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10d6:10:29:cafe::46) by RO2P152CA0071.outlook.office365.com
 (2603:10d6:10:29::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:13:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:13:33 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:13:28 -0500
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>
CC:     <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <michael.roth@amd.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
        <ak@linux.intel.com>, <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>
Subject: [PATCH Part2 v6 42/49] KVM: SVM: Provide support for SNP_GUEST_REQUEST NAE event
Date:   Mon, 20 Jun 2022 23:13:18 +0000
Message-ID: <5d05799fc61994684aa2b2ddb8c5b326a3279e25.1655761627.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1655761627.git.ashish.kalra@amd.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9d1af9f-0143-4f65-43e0-08da53127f28
X-MS-TrafficTypeDiagnostic: PH0PR12MB5648:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB5648150EA667650CE4D9B2338EB09@PH0PR12MB5648.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J/JIt/JJ47nD1xk8sU1xIiT3C+d5YokxsJhdhrt3wMUV3PjqGQPLnxXgpoed0cYBKmvkBnGzpqioucytytCft8QNY7NGieqWJw1mgjGBNW/L2kP0XYNhmTGwg8YW3RD9fCl8oZfdN1wc/IGtbVxZOhCv3/ztwMDEugcPYNWlGwluZv7nPytXKYTd0OPMp5Pdy6/C8xAeZ4xaqt5uPpRK52tI7iWV1dM47KVueUmdukop9dEoEbyGjAos+2mG68qLd/R7VvjbsWXohvopBjAHRET/rXed/QkZwDRoAyS9sl+C7qT12/mHmQ16gf0/6RB5VpwauFxq1eUJrh4TD3drQqw3qVvQZRa0i226zBbBFZxpvOe/uaZBj5kHC1fcV2ybHHMMHUSx+71Fjl5/lEeXTOzowEMu/zFz+PYTSa4QCYyt03+lPAlBK73wgF/wfmRRMONF2mqumM5mVJ4Jl60nrEdgCGyb3Yiz/InMHElarZ/z7kUQAMdMd8hI1RC0Yx8Qdw/bxLKD1LbHOIwc7W71A0pbeoWBdEE6XI4IgFyn4wJSDlQhfkASsoqum/zpX0Un0hsAcIvVGGgNrLRiNDw9Wt4KP48rXZ7Jlx2rAw6w1AVu7UgLE9bT8oo4tJ8WKOA6NMdWEIPrve1wLJKnn7Q3lD+aWZ0STOuoUOGg1ivL1opJ7/PSo+S35/FXyAdadpL/dQQkBsyQQx37NlvdyLhGM9yBmZ+Sdotzsr++58py574TQXz3iNOdTJINeEOqhmve+JeNeEX5egvrLn0pfRb20g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(136003)(39860400002)(46966006)(36840700001)(40470700004)(26005)(7696005)(2906002)(6666004)(110136005)(54906003)(41300700001)(36756003)(2616005)(4326008)(8676002)(82310400005)(316002)(83380400001)(70586007)(70206006)(478600001)(40480700001)(47076005)(7406005)(16526019)(40460700003)(5660300002)(356005)(8936002)(7416002)(82740400003)(426003)(186003)(336012)(86362001)(81166007)(36860700001)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:13:33.3114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9d1af9f-0143-4f65-43e0-08da53127f28
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5648
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
---
 arch/x86/kvm/svm/sev.c | 196 +++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h |   2 +
 2 files changed, 192 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7fc0fad87054..089af21a4efe 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -343,6 +343,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 		spin_lock_init(&sev->psc_lock);
 		ret = sev_snp_init(&argp->error);
+		mutex_init(&sev->guest_req_lock);
 	} else {
 		ret = sev_platform_init(&argp->error);
 	}
@@ -1884,23 +1885,39 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 
 static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
+	void *context = NULL, *certs_data = NULL, *resp_page = NULL;
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_data_snp_gctx_create data = {};
-	void *context;
 	int rc;
 
+	/* Allocate memory used for the certs data in SNP guest request */
+	certs_data = kmalloc(SEV_FW_BLOB_MAX_SIZE, GFP_KERNEL_ACCOUNT);
+	if (!certs_data)
+		return NULL;
+
 	/* Allocate memory for context page */
 	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
 	if (!context)
-		return NULL;
+		goto e_free;
+
+	/* Allocate a firmware buffer used during the guest command handling. */
+	resp_page = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
+	if (!resp_page)
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
@@ -2565,6 +2582,8 @@ static int snp_decommission_context(struct kvm *kvm)
 	snp_free_firmware_page(sev->snp_context);
 	sev->snp_context = NULL;
 
+	kfree(sev->snp_certs_data);
+
 	return 0;
 }
 
@@ -3077,6 +3096,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
+	case SVM_VMGEXIT_GUEST_REQUEST:
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3502,6 +3523,155 @@ static unsigned long snp_handle_page_state_change(struct vcpu_svm *svm)
 	return rc ? map_to_psc_vmgexit_code(rc) : 0;
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
+	/* Verify that requested blob will fit in certificate buffer */
+	if ((data_npages << PAGE_SHIFT) > SEV_FW_BLOB_MAX_SIZE) {
+		rc = SEV_RET_INVALID_PARAM;
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
@@ -3753,6 +3923,20 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		svm_set_ghcb_sw_exit_info_2(vcpu, rc);
 		break;
 	}
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
index 3fd95193ed8d..3be24da1a743 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -98,6 +98,8 @@ struct kvm_sev_info {
 	u64 snp_init_flags;
 	void *snp_context;      /* SNP guest context page */
 	spinlock_t psc_lock;
+	void *snp_certs_data;
+	struct mutex guest_req_lock;
 };
 
 struct kvm_svm {
-- 
2.25.1

