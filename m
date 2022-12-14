Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4AB64D099
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiLNUDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiLNUC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:02:56 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8712DA8B;
        Wed, 14 Dec 2022 11:57:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSRh0p1/9l8oexpPyskKG57hYEIC6TPZ/I1eLHlXFEwAMNiOqdifSxvFF6BOwLROpEpyWBqOoXzlS1s96/HhczgiYZDwegAoYgSNtpn+7U0cHPK1LEWosQr6GLhYfaUvr0qFrOTxxLJt1i33TwDcYMhtn1wb1oSC15sBAkYOgrWYuH3KR8npy9+61HLnIgMuNtkVwo87cIDMbYWS9u5xhA0T4QVNvk5LDlLfl3FryXxRyjWkAct2fKN+9ru19FXisv0eeix3wkxEyB3PGOzAj6+U3xWLyNtSEOT87dOBrVSkj5wzxSTqtHQxu6iaN+Utrq7j1wofjiu/7f3Zguma8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FzBw1ZxlfRv0VZ1/467rS9sM/N4vuXpCESj/AlJzwR8=;
 b=GTK99xLVDl+S4fnXOOov7T0E1mZkOMiRzXqS1+X0zWiJbUl/SRSc8bGrdwXah+jkLFou6CIkWVfPFUQArKUUPTsIyKNt2Ecx/ZYwdysUcHlp/IU4jnAQ55FZHLCYstOM29Wjs0g1BIL69xqoubYHsNKfkPzG7om0pixM2BjWF5Hfkw5ta2/b9s06a2GezOdn6bvg5bpUiHN/ht12l/r6zqzGEDhnGNGnxHPuIcgB7XAngjpsqyhV6AO0CWZlKHv7oTYZbjgfuyxqVPc6eCqjAziJev2y7WK+vV+rk3zOFsCUwRdia7w4HirjO2TvNzuZAbsAFFRA329+NvqB1e4YWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FzBw1ZxlfRv0VZ1/467rS9sM/N4vuXpCESj/AlJzwR8=;
 b=G3MWOjYx3YGL4IA3Y/3SOPcaio0XPEipKhIUIW7174vEYvhLV4cPxSfocVTrCe3vNofdDieINvsVa4ct/rsAIJ5v0YfKTyKC3PcBKJ5qp/R0irB0RciIpOcqgrnyswVt3UlRLwsnfFqs98l6YfkxIlMDfE2b4uikceuClVAmvBs=
Received: from MW4PR03CA0337.namprd03.prod.outlook.com (2603:10b6:303:dc::12)
 by CH2PR12MB5018.namprd12.prod.outlook.com (2603:10b6:610:6e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:57:57 +0000
Received: from CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::76) by MW4PR03CA0337.outlook.office365.com
 (2603:10b6:303:dc::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:57:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT077.mail.protection.outlook.com (10.13.175.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 19:57:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:57:55 -0600
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
Subject: [PATCH RFC v7 38/64] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START command
Date:   Wed, 14 Dec 2022 13:40:30 -0600
Message-ID: <20221214194056.161492-39-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT077:EE_|CH2PR12MB5018:EE_
X-MS-Office365-Filtering-Correlation-Id: c18de988-126a-4a01-c955-08dade0d7ebb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WJqoKST9Mu88VEzimgfBDYtgqY6MZNnL7fXXI0NohOr7g8TTlrw5L1EJck+pVqlsLpJdYGDKZ0HWF2liqEqGGpunyiC1URC94ibo5rGBsfYggE5mIbFyRU2mP+B81H9FCXfPhEMpo0j9G0e9qNpL1AinGTwZG5vEiHtonmLVrO/iHMtkwoAUFcpv7FiYC9sAz4FGZlZIwz/y1bGFarIWIkxVg1Ak/AJqJD853HNo6qAKD9UrPBdiXou+I9NSM2enEL0ddN7ukDmlff9/MTJkohpaLHKAx6ABSZXobVzoXAdoDEDiLLqZD27WvIIiGjHuc164gTcQE/iX/wy4tcYm6qgJzRg3GBCw9DmOBoENpFbPqgba9vQDBYKNMGmO2SyA/7KuPDmDRfVjw3ZFMTWKmTHuDvQg07N+uw7nPeJZNlW8+/TBTCPpjbIvflFUrNrp2Q9OZb9J+Dmwy+MPfZ3RaqFDRINkv8zFuonqvp6HLPa8yLltHJPQHffe8vEkXP9y0FlJM3hrdfCtMbukOytFrf5G2zXujkrmej+ceaIFURMHSqBW78iBBmhmSeoLkrZFHWgFgelCVSZynnCE+nb1q6bLpYh2oki1ZPl6jpGYdzGz6vLNDV8NwLMDEeU8LMkzHrb8CXQ02VRrq/nA0CUGuBpjes0Nggrs9iOeZNrZWzN8k4KHnRq3IJtStGsPpvUWulT9gcGoe8kFYXqjRfYobN4JnH0d/ynYaAODLe3sIHA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(346002)(396003)(451199015)(36840700001)(46966006)(40470700004)(478600001)(26005)(6666004)(186003)(82310400005)(7416002)(426003)(316002)(1076003)(336012)(40480700001)(5660300002)(7406005)(16526019)(2906002)(54906003)(83380400001)(70206006)(36756003)(70586007)(36860700001)(4326008)(47076005)(8676002)(2616005)(356005)(81166007)(6916009)(86362001)(44832011)(8936002)(41300700001)(40460700003)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:57:56.7117
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c18de988-126a-4a01-c955-08dade0d7ebb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5018
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

KVM_SEV_SNP_LAUNCH_START begins the launch process for an SEV-SNP guest.
The command initializes a cryptographic digest context used to construct
the measurement of the guest. If the guest is expected to be migrated,
the command also binds a migration agent (MA) to the guest.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  24 ++++
 arch/x86/kvm/svm/sev.c                        | 121 +++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 include/uapi/linux/kvm.h                      |  10 ++
 4 files changed, 153 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 2432213bd0ea..58971fc02a15 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -461,6 +461,30 @@ The flags bitmap is defined as::
 If the specified flags is not supported then return -EOPNOTSUPP, and the supported
 flags are returned.
 
+19. KVM_SNP_LAUNCH_START
+------------------------
+
+The KVM_SNP_LAUNCH_START command is used for creating the memory encryption
+context for the SEV-SNP guest. To create the encryption context, user must
+provide a guest policy, migration agent (if any) and guest OS visible
+workarounds value as defined SEV-SNP specification.
+
+Parameters (in): struct  kvm_snp_launch_start
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_start {
+                __u64 policy;           /* Guest policy to use. */
+                __u64 ma_uaddr;         /* userspace address of migration agent */
+                __u8 ma_en;             /* 1 if the migration agent is enabled */
+                __u8 imi_en;            /* set IMI to 1. */
+                __u8 gosvw[16];         /* guest OS visible workarounds */
+        };
+
+See the SEV-SNP specification for further detail on the launch input.
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e3f857cde8c0..6d1d0e424f76 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -21,6 +21,7 @@
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
+#include <asm/sev.h>
 
 #include "mmu.h"
 #include "x86.h"
@@ -74,6 +75,8 @@ static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
+static int snp_decommission_context(struct kvm *kvm);
+
 struct enc_region {
 	struct list_head list;
 	unsigned long npages;
@@ -99,12 +102,17 @@ static int sev_flush_asids(int min_asid, int max_asid)
 	down_write(&sev_deactivate_lock);
 
 	wbinvd_on_all_cpus();
-	ret = sev_guest_df_flush(&error);
+
+	if (sev_snp_enabled)
+		ret = sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, &error);
+	else
+		ret = sev_guest_df_flush(&error);
 
 	up_write(&sev_deactivate_lock);
 
 	if (ret)
-		pr_err("SEV: DF_FLUSH failed, ret=%d, error=%#x\n", ret, error);
+		pr_err("SEV%s: DF_FLUSH failed, ret=%d, error=%#x\n",
+		       sev_snp_enabled ? "-SNP" : "", ret, error);
 
 	return ret;
 }
@@ -2003,6 +2011,80 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	return ret;
 }
 
+/*
+ * The guest context contains all the information, keys and metadata
+ * associated with the guest that the firmware tracks to implement SEV
+ * and SNP features. The firmware stores the guest context in hypervisor
+ * provide page via the SNP_GCTX_CREATE command.
+ */
+static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct sev_data_snp_addr data = {};
+	void *context;
+	int rc;
+
+	/* Allocate memory for context page */
+	context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
+	if (!context)
+		return NULL;
+
+	data.gctx_paddr = __psp_pa(context);
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
+	if (rc) {
+		snp_free_firmware_page(context);
+		return NULL;
+	}
+
+	return context;
+}
+
+static int snp_bind_asid(struct kvm *kvm, int *error)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_activate data = {0};
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+	data.asid   = sev_get_asid(kvm);
+	return sev_issue_cmd(kvm, SEV_CMD_SNP_ACTIVATE, &data, error);
+}
+
+static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_start start = {0};
+	struct kvm_sev_snp_launch_start params;
+	int rc;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
+		return -EFAULT;
+
+	sev->snp_context = snp_context_create(kvm, argp);
+	if (!sev->snp_context)
+		return -ENOTTY;
+
+	start.gctx_paddr = __psp_pa(sev->snp_context);
+	start.policy = params.policy;
+	memcpy(start.gosvw, params.gosvw, sizeof(params.gosvw));
+	rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_START, &start, &argp->error);
+	if (rc)
+		goto e_free_context;
+
+	sev->fd = argp->sev_fd;
+	rc = snp_bind_asid(kvm, &argp->error);
+	if (rc)
+		goto e_free_context;
+
+	return 0;
+
+e_free_context:
+	snp_decommission_context(kvm);
+
+	return rc;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2093,6 +2175,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_FINISH:
 		r = sev_receive_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_START:
+		r = snp_launch_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2284,6 +2369,28 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	return ret;
 }
 
+static int snp_decommission_context(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_addr data = {};
+	int ret;
+
+	/* If context is not created then do nothing */
+	if (!sev->snp_context)
+		return 0;
+
+	data.gctx_paddr = __sme_pa(sev->snp_context);
+	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
+	if (WARN_ONCE(ret, "failed to release guest context"))
+		return ret;
+
+	/* free the context page now */
+	snp_free_firmware_page(sev->snp_context);
+	sev->snp_context = NULL;
+
+	return 0;
+}
+
 void sev_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -2325,7 +2432,15 @@ void sev_vm_destroy(struct kvm *kvm)
 		}
 	}
 
-	sev_unbind_asid(kvm, sev->handle);
+	if (sev_snp_guest(kvm)) {
+		if (snp_decommission_context(kvm)) {
+			WARN_ONCE(1, "Failed to free SNP guest context, leaking asid!\n");
+			return;
+		}
+	} else {
+		sev_unbind_asid(kvm, sev->handle);
+	}
+
 	sev_asid_free(sev);
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 379b253d2464..17200c1ad20e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -99,6 +99,7 @@ struct kvm_sev_info {
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
 	u64 snp_init_flags;
+	void *snp_context;      /* SNP guest context page */
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index a6c73297a62d..b2311e0abeef 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1940,6 +1940,7 @@ enum sev_cmd_id {
 
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT,
+	KVM_SEV_SNP_LAUNCH_START,
 
 	KVM_SEV_NR_MAX,
 };
@@ -2047,6 +2048,15 @@ struct kvm_snp_init {
 	__u64 flags;
 };
 
+struct kvm_sev_snp_launch_start {
+	__u64 policy;
+	__u64 ma_uaddr;
+	__u8 ma_en;
+	__u8 imi_en;
+	__u8 gosvw[16];
+	__u8 pad[6];
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.25.1

