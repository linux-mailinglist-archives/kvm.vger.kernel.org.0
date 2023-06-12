Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C249272B6F6
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbjFLE6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235767AbjFLE5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:57:53 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2064.outbound.protection.outlook.com [40.107.100.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C30F3C1B;
        Sun, 11 Jun 2023 21:56:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5ybTzg6orqF1L1+74qH7RXySg/JqLZ9uQrEzI2egNB/A7BpiUKI0oEZf2QDXD7Go0fZjWlI/FBTn7CFeVixVZH/VzBa5trRgchB6fsGaio8BFGgH0wpU90iFN5xCv2Hw2YViAM/E1JpiT4ECD0cSugKnlNNoITQ4y0iM1nxleo/1Y8KY4Npzk2SQ3yA7ghQOne0HcVvFOp5mzEwAxiOYThFcOmgo1WUsvUAqC8INMtQ5jOp8UBkPv2a8PHiJuoJW62b+zJHJLjbugZjzEKLKEtEui0kwPuPYJYwOXVjrug7WLFIrkhBC70aCW440P/9bJf71FDOyUK2jGNG2oK4Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MOjQ9OR6FXBKvOm3ej71JfND9jQgatXW3QKky35AJQE=;
 b=QmnmY17XM0+Iv+D5RYndHp9UL7cJjFK0wGdcSuNP+qrtoepM/NZ/n5uA8FqMBRJcRg8IgCjaKfNBo+fNjFLtMxBy8VxMfNK4owVsAQ6o1HE+9GBQrm5JfD2rQX+PPX4Cw+J7Usi/5VDkU1E9VlnOsLXYIGlVzvg4gjiiR0hTlI4cL+qaG9qM3YXGfUGak/X15h111DqhKweXSf7kfO9OjN9jCW65GWkxKHhFpO44pblsK+K8EaJcuvAqXwlIvC3ekRRTwuwLLuYOVsVwClzJHCkboBEYj+td53NFb87hm/tDABs7C/zSqAwEbWRVcFVmdK3xrPuOwFyKxrAxKfQYPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOjQ9OR6FXBKvOm3ej71JfND9jQgatXW3QKky35AJQE=;
 b=LLGvTi+qj7M3SOC8/I9lZ1zOVzIAWlwMggN7gZ3F1UesWm9Ub8njHdEMcxvj0TXJwz4zolVaoniyScV5G1sS3K7rxF+LMt95yeRMdnhfc+uBHa0PVHhtIAptUEj9P1q1Yy4p/n/X1rV/5jjABHUv3icHmZcSPsiRg54dkhZrkbg=
Received: from CYXPR03CA0092.namprd03.prod.outlook.com (2603:10b6:930:d3::18)
 by DM4PR12MB6040.namprd12.prod.outlook.com (2603:10b6:8:af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 04:56:45 +0000
Received: from CY4PEPF0000E9D6.namprd05.prod.outlook.com
 (2603:10b6:930:d3:cafe::1d) by CYXPR03CA0092.outlook.office365.com
 (2603:10b6:930:d3::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:56:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D6.mail.protection.outlook.com (10.167.241.80) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:56:45 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:56:14 -0500
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
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH RFC v9 50/51] KVM: SVM: Provide support for SNP_GUEST_REQUEST NAE event
Date:   Sun, 11 Jun 2023 23:25:58 -0500
Message-ID: <20230612042559.375660-51-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230612042559.375660-1-michael.roth@amd.com>
References: <20230612042559.375660-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D6:EE_|DM4PR12MB6040:EE_
X-MS-Office365-Filtering-Correlation-Id: 39def5c7-7280-43f6-5017-08db6b016c08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 55sn1+nspxoKvDHHysY6nbWoCVhkRUsJLiUDe7i9mZ8MHZHGw0i2IE17i+h2XTXI2Cd9mJtz/K1UZvBp7NR2EdGfbZqJ7Z19a/raelWFguWJbJGJ3B1VYSc2saWjlQtoL8zxziX5i+4t7PE7fB6MBeLtJCzuz9TMTjBBkcyJYaEX+ZKoVXvAFM0W1cddWWjQd1Q8yRD3SSptLaxH7nsx3yu5poLcfOOtqFz2M3lPdmW16v+XgfzXa16R1L3iaQbWeR/rzhuW/+2z2WfD+QtnRnjoFq+zVHAkGozZqPG5AQuSCaAn23zh2oE/iI+I5z0EOoQp31z/Svtg5imwETInzOGAmg/uaMNypBTyw7mI3uVnUgqkwuT3F/UzrxK43vbt3HOayFuZTwqlfClTl/SAbzC3bpoFTou86uOowBydU+QOWVBSJNmbCM2v5tG5JUxNuHabtgMgWIY6OkWNHQv9zm7gjadZ2B1dHveiPl4zLbXh6BWEsheWk2Y3us6iNoJiKDqfLhhakdTH2f3x7KW1tgilam1+xGaMFRmzey9wHeZeU1wM58kdWiHlBhhYBR/NV/Vlk6jfRiuzkdnU9Tu0XJb5C6Pk/x0HAEHRmFBdXZ5v+xHGqAmZYA6cuVDqoT41llq3QnLcxXVxy/tZlyKdmRPRuUgmL8ftBfKFO5gLXYwS4lPKgVyVgJhgUq1YLKjU5WrEc/ADxF3VRwrKG896VtC1cdCfM2CRpdkSu5xU5dSnNNRB9vXQbQtSNFRf0E2i6cjMeL6oHUwrEQdMarrx/w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199021)(36840700001)(40470700004)(46966006)(186003)(8676002)(8936002)(54906003)(478600001)(6666004)(5660300002)(41300700001)(316002)(16526019)(26005)(44832011)(1076003)(7416002)(7406005)(70586007)(70206006)(6916009)(4326008)(2616005)(83380400001)(40460700003)(2906002)(426003)(336012)(47076005)(82740400003)(81166007)(40480700001)(356005)(36860700001)(86362001)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:56:45.3274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39def5c7-7280-43f6-5017-08db6b016c08
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6040
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

Co-developed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: ensure FW command failures are indicated to guest]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c       | 175 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h       |   1 +
 drivers/crypto/ccp/sev-dev.c |  15 +++
 include/linux/psp-sev.h      |   1 +
 4 files changed, 192 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index bdf32aa971d8..9f7defce1988 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -328,6 +328,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		ret = verify_snp_init_flags(kvm, argp);
 		if (ret)
 			goto e_free;
+
+		mutex_init(&sev->guest_req_lock);
 	}
 
 	ret = sev_platform_init(&argp->error);
@@ -2321,8 +2323,10 @@ static int snp_get_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static void snp_replace_certs(struct kvm_sev_info *sev, struct sev_snp_certs *snp_certs)
 {
+	mutex_lock(&sev->guest_req_lock);
 	sev_snp_certs_put(sev->snp_certs);
 	sev->snp_certs = snp_certs;
+	mutex_unlock(&sev->guest_req_lock);
 }
 
 static int snp_set_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
@@ -3171,6 +3175,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
+	case SVM_VMGEXIT_GUEST_REQUEST:
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3604,6 +3610,163 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
 	return ret;
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
+		/* Ensure an error value is returned to guest. */
+		rc = err ? err : SEV_RET_INVALID_ADDRESS;
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
+	struct sev_snp_certs *snp_certs = NULL;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm *kvm = vcpu->kvm;
+	unsigned long data_npages;
+	struct kvm_sev_info *sev;
+	unsigned long exitcode = 0;
+	u64 data_gpa;
+	int err, rc;
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
+		exitcode = SEV_RET_INVALID_ADDRESS;
+		goto e_fail;
+	}
+
+	mutex_lock(&sev->guest_req_lock);
+
+	rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
+	if (rc)
+		goto unlock;
+
+	/*
+	 * If a VMM-specific certificate blob hasn't been provided, grab the
+	 * host-wide one.
+	 */
+	snp_certs = sev_snp_certs_get(sev->snp_certs);
+	if (!snp_certs)
+		snp_certs = sev_snp_global_certs_get();
+
+	/*
+	 * If there is a host-wide or VMM-specific certificate blob available,
+	 * make sure the guest has allocated enough space to store it.
+	 * Otherwise, inform the guest how much space is needed.
+	 */
+	if (snp_certs && (data_npages << PAGE_SHIFT) < snp_certs->len) {
+		vcpu->arch.regs[VCPU_REGS_RBX] = snp_certs->len >> PAGE_SHIFT;
+		exitcode = SNP_GUEST_REQ_INVALID_LEN;
+		goto cleanup;
+	}
+
+	rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &req, &err);
+	if (rc) {
+		/* pass the firmware error code */
+		exitcode = err;
+		goto cleanup;
+	}
+
+	/* Copy the certificate blob in the guest memory */
+	if (sev->snp_certs &&
+	    kvm_write_guest(kvm, data_gpa, sev->snp_certs->data, sev->snp_certs->len))
+		exitcode = SEV_RET_INVALID_ADDRESS;
+
+cleanup:
+	sev_snp_certs_put(snp_certs);
+	snp_cleanup_guest_buf(&req, &exitcode);
+
+unlock:
+	mutex_unlock(&sev->guest_req_lock);
+
+e_fail:
+	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, exitcode);
+}
+
 static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -3863,6 +4026,18 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 						SVM_EVTINJ_VALID);
 		}
 
+		ret = 1;
+		break;
+	case SVM_VMGEXIT_GUEST_REQUEST:
+		snp_handle_guest_request(svm, control->exit_info_1, control->exit_info_2);
+
+		ret = 1;
+		break;
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
+		snp_handle_ext_guest_request(svm,
+					     control->exit_info_1,
+					     control->exit_info_2);
+
 		ret = 1;
 		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 72be0c440b16..31cd8b3e6877 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -96,6 +96,7 @@ struct kvm_sev_info {
 	void *snp_context;      /* SNP guest context page */
 	u64 sev_features;	/* Features set at VMSA creation */
 	struct sev_snp_certs *snp_certs;
+	struct mutex guest_req_lock; /* Lock for guest request handling */
 };
 
 struct kvm_svm {
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 175c24163ba0..096ba15d0740 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2109,6 +2109,21 @@ void sev_snp_certs_put(struct sev_snp_certs *certs)
 }
 EXPORT_SYMBOL_GPL(sev_snp_certs_put);
 
+struct sev_snp_certs *sev_snp_global_certs_get(void)
+{
+	struct sev_device *sev;
+
+	if (!psp_master || !psp_master->sev_data)
+		return NULL;
+
+	sev = psp_master->sev_data;
+	if (!sev->snp_initialized)
+		return NULL;
+
+	return sev_snp_certs_get(sev->snp_certs);
+}
+EXPORT_SYMBOL_GPL(sev_snp_global_certs_get);
+
 static void sev_exit(struct kref *ref)
 {
 	misc_deregister(&misc_dev->misc);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 7b65dd5808a1..1235eb3110cb 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -33,6 +33,7 @@ struct sev_snp_certs {
 struct sev_snp_certs *sev_snp_certs_new(void *data, u32 len);
 struct sev_snp_certs *sev_snp_certs_get(struct sev_snp_certs *certs);
 void sev_snp_certs_put(struct sev_snp_certs *certs);
+struct sev_snp_certs *sev_snp_global_certs_get(void);
 
 /**
  * SEV platform state
-- 
2.25.1

