Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27CE47CAA4A
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbjJPNsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbjJPNrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:47:36 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C4DE6;
        Mon, 16 Oct 2023 06:47:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZtnVYIkRKpklQIhXmFzOKzhYGwnBGBX66T2PvTid/5q+mEzwHM/gi5WWDZF0R/E2lYX00VneqJQZyPFkYKecBiO3ES9nB+FwIQfyADs4KjGpL5Z4ipOod/L0QU+RlqR4sR2B98wRcYirVvXSPcTuS+aPxCHEwxrQe9GpQ3DoDGzKYed58zgo3Ht9HD6QgKw2+5Le/hpm5cxMRSG6F/SlNE/H2OjHy2GJkvPNPyzumoQpnZ+Je3VsFaD4Bz2ttH3fiz+AdagBYYNpqaBN5YEt/1jBUGhgs+9TT5D8e4pkFLhNc9stEe4CXDwfwHZ6sjxtyFsrwW0C86GIyhblfTmag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O16UDz6bg6SnYcZCZVeleJclaR2rL+C/MJ+u7rMewKY=;
 b=A/27t0eVBPWpkXJy1LCqENcpt/KHjsEs00fAeAJ5/Yevu0Qt8vRpcPv6ZLNIPyOmQXwEayON/qeyuPNKTNB5LgoTW/6PWmPsEo4lhWqLzaR7CCD7wJkkary2uDk0iuP9x4OHFnvOqq+klS1PomiBtj6fC+cxuHQ4QNI/f4UWvdoT/yi3A9txjx/tviZTMQdTXVtUi/TuAMeZR67vYpor3P0YoG2Wqyk8D04nVDx0q1Bq0wlggsJ/iWY3Ns+7OjfgrfRkAOEBqIoZ7kenh1IvpdRk7EikRHSyC/Vey8I7MKqQUvry5VgCOtMy4nTFri92/l9jLt2L1udapDxkIUEiYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O16UDz6bg6SnYcZCZVeleJclaR2rL+C/MJ+u7rMewKY=;
 b=JP/yrh7VDpdzkVIFb4yRyvB5OFbElJatssH7QOQoUuT7ZfrCGEzV7jj5M/SV63zYfzi8ORJ5upgxAOGkdhI/lAlQUEnud7VHyw7Lym+IN8dQp+8C1v4NnBojAtgeerWKgC0C/QbQf+2f1HmMvGlrABQ2eSHwZOHI3ZeVZM7NCc8=
Received: from BL0PR05CA0008.namprd05.prod.outlook.com (2603:10b6:208:91::18)
 by LV8PR12MB9407.namprd12.prod.outlook.com (2603:10b6:408:1f9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 13:47:03 +0000
Received: from MN1PEPF0000F0DF.namprd04.prod.outlook.com
 (2603:10b6:208:91:cafe::d4) by BL0PR05CA0008.outlook.office365.com
 (2603:10b6:208:91::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.17 via Frontend
 Transport; Mon, 16 Oct 2023 13:47:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0DF.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:47:03 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:47:01 -0500
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
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH v10 48/50] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
Date:   Mon, 16 Oct 2023 08:28:17 -0500
Message-ID: <20231016132819.1002933-49-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DF:EE_|LV8PR12MB9407:EE_
X-MS-Office365-Filtering-Correlation-Id: 607a1e43-8e69-4273-02ea-08dbce4e6141
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U3Z/ElY34s2JHCJj1JhEWSsP+K/1GgJgFpqtlUvmELYzvXlYqnwZRu/oRObMD0UWwlQhqCpZD2JMq/3Zh6ivk9mEPTHzcPqp55jXmxJfLXI0xTueMWFhg4pD98sv+6NUSjXToAGNDX9IFESvvsSaGGvUzbGPEHguPz0tUiLiMsdZbEguNnOjFaVYDgaq7g/ID+AFozpLzGp1mTRSVBnFztJGUwoi3clvU1CIVAn8YP2R9RkHk2RrqLDvgK5zjSYH0cWPjyVS6od1YqnByx1ScgwpJ513u5B/p6j4Ft6DghVwqz8QZUJeSsdw0nSJ9CVTnJ+Z8qZw0myp275meXWNrTgNV8L9jrSF8Zy2I7e59nnxIZlRuPJx7mDqIO/TjktC5Nca8fOt1m35hXU1U5WRqC74YVU9s3PgBis2zeexrEHW0rx3CfXG/dzCcGAObK6WkAi743kvK2my0Feq8ySJcFBgb6pTUW9tPuyhhZFo7n66wizUSlEJpzDjsTgG2zxHY7XqXJaOfqZkWR0lzoUwlbNiM+HLKJ7fosnq3mQfGA86kuOgcmqW4eXB3RmFJVpKhmjPGhqbVtkwLg3+ifCMla0I/5AGsES750pavMflGOqpUDVsol4AzRocypKllyl3e1wEerguiSQm/vWBN4TfCKQK+79gN8FdxzqvjX/kJIEEqQSpTQObWcNsyfNBintmOZzcLUx+tFNNzxipteW0+L5IP+pBCOkaH79hvyumRW01wGEpuiu2vxspjq/y/GhvVqRLLsXoCfH3Dt0iPyRtCw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(396003)(136003)(230922051799003)(1800799009)(64100799003)(82310400011)(451199024)(186009)(36840700001)(46966006)(40470700004)(41300700001)(478600001)(54906003)(70206006)(70586007)(6666004)(6916009)(16526019)(26005)(1076003)(426003)(316002)(336012)(2616005)(7416002)(8936002)(7406005)(4326008)(8676002)(2906002)(5660300002)(36756003)(44832011)(81166007)(86362001)(356005)(47076005)(36860700001)(83380400001)(82740400003)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:47:03.6697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 607a1e43-8e69-4273-02ea-08dbce4e6141
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000F0DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9407
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 arch/x86/kvm/svm/sev.c       | 176 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h       |   1 +
 drivers/crypto/ccp/sev-dev.c |  15 +++
 include/linux/psp-sev.h      |   1 +
 4 files changed, 193 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 602aaf82eef3..d71ec257debb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -19,6 +19,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
+#include <uapi/linux/sev-guest.h>
 
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
@@ -339,6 +340,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		ret = verify_snp_init_flags(kvm, argp);
 		if (ret)
 			goto e_free;
+
+		mutex_init(&sev->guest_req_lock);
 	}
 
 	ret = sev_platform_init(&argp->error);
@@ -2345,8 +2348,10 @@ static int snp_get_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 static void snp_replace_certs(struct kvm_sev_info *sev, struct sev_snp_certs *snp_certs)
 {
+	mutex_lock(&sev->guest_req_lock);
 	sev_snp_certs_put(sev->snp_certs);
 	sev->snp_certs = snp_certs;
+	mutex_unlock(&sev->guest_req_lock);
 }
 
 static int snp_set_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
@@ -3218,6 +3223,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_HV_FEATURES:
 	case SVM_VMGEXIT_PSC:
 	case SVM_VMGEXIT_TERM_REQUEST:
+	case SVM_VMGEXIT_GUEST_REQUEST:
+	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3627,6 +3634,163 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
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
+		exitcode = SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN);
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
+	if (snp_certs &&
+	    kvm_write_guest(kvm, data_gpa, snp_certs->data, snp_certs->len))
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
@@ -3894,6 +4058,18 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		vcpu->run->system_event.ndata = 1;
 		vcpu->run->system_event.data[0] = control->ghcb_gpa;
 		break;
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
+		ret = 1;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index bdf792ba06e1..3673a6e4e22e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -98,6 +98,7 @@ struct kvm_sev_info {
 	void *snp_context;      /* SNP guest context page */
 	u64 sev_features;	/* Features set at VMSA creation */
 	struct sev_snp_certs *snp_certs;
+	struct mutex guest_req_lock; /* Lock for guest request handling */
 };
 
 struct kvm_svm {
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 4807ddd6ec52..f9c75c561c4e 100644
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
index 722e26d28d2f..3b294ccbbec9 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -25,6 +25,7 @@ struct sev_snp_certs {
 struct sev_snp_certs *sev_snp_certs_new(void *data, u32 len);
 struct sev_snp_certs *sev_snp_certs_get(struct sev_snp_certs *certs);
 void sev_snp_certs_put(struct sev_snp_certs *certs);
+struct sev_snp_certs *sev_snp_global_certs_get(void);
 
 /**
  * SEV platform state
-- 
2.25.1

