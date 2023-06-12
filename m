Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415FE72B6A7
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 06:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbjFLEkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 00:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234734AbjFLEjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 00:39:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A8510E4;
        Sun, 11 Jun 2023 21:38:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEpM1EOxCyk88+trB8HWjrvLcTORIYv+IcP06jJKjEUgFXu4FEgPMa2bgbCi8Co3p54G+20ZSaoU2i5yfLP19lG7zyGhiM/4sGTzw1DHhjzjBnlxIfIAUp16iGHjCIF9hTAcZ1/SvCTfSnY1bJFL/DeA53lJ5+esQbjZALzIzRdPG+7yf4Bby6dchR7Lp8GqBkpz1iSDBwZIj9GptpObDnr09v3PLWqxaCtT6ZOlX7j08yN8Vt9h4o38r46cQ62mVmodAnVb4eI8V0jgh4lraY55/G1zM9LmkIKVhmpBlocWMNxPalMQAK6kPNe6GmBnzORomRJzGpxB/5VFFCbaKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QK4QZkCIIAqJ+tunV1KOANKN1pjYrjaWRxkGX4t4nd0=;
 b=ASLk7X9syfErP8FD29sbFJFFnsCMSVR+08/vaD3ZcxD25IBf9tU9h1uqQAl25wtebXnI23MRvJRmoOgVfLtL5TyHHqKv8KU99+/KUDJ+hsESYUjN0jxmyPMZSRE7dFxkPlwYosADwX+FCYNL6ZKQKStvX0BOmZHD42M0brzlbr5v5BwQl/fRw7OdWUylve3gmFuvYg1NJU0t93JG+PxSeg2jmRQrxzJCTDvrarUjjEwUCmtSbtR7kigakfuaWXUGmr5aLZeMYgMLDQBa/6csAdH4hE3RS4v3kTwZFJPaDjwiwoatemC8pj51J1UBzLCj9WRpKIMTpk0cFwBJ9GdXTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QK4QZkCIIAqJ+tunV1KOANKN1pjYrjaWRxkGX4t4nd0=;
 b=afUNk6L31NJMbNfF6fYryZHs+mSM50U3Eok1IJvt56r9mIuCKzs36SKhz7VALt7syEmtIcTSdmMQwPTTBppTfGfEz+pvZlHagckJG3hLSGPIoP+PpmfEvAfvDWhctSXqcx5QpU5c3SdGllzEFmrgnRsYRiP/8xq0YP3/8xgkE3w=
Received: from MW4PR04CA0238.namprd04.prod.outlook.com (2603:10b6:303:87::33)
 by SJ1PR12MB6337.namprd12.prod.outlook.com (2603:10b6:a03:456::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.41; Mon, 12 Jun
 2023 04:38:45 +0000
Received: from CO1PEPF000042A7.namprd03.prod.outlook.com
 (2603:10b6:303:87:cafe::cf) by MW4PR04CA0238.outlook.office365.com
 (2603:10b6:303:87::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.33 via Frontend
 Transport; Mon, 12 Jun 2023 04:38:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042A7.mail.protection.outlook.com (10.167.243.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 04:38:45 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Sun, 11 Jun
 2023 23:38:40 -0500
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
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH RFC v9 29/51] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START command
Date:   Sun, 11 Jun 2023 23:25:37 -0500
Message-ID: <20230612042559.375660-30-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A7:EE_|SJ1PR12MB6337:EE_
X-MS-Office365-Filtering-Correlation-Id: 85b63579-e684-40b1-ee7d-08db6afee869
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0UHqzijJkBtN2Q3L393p5DofWlEQvqPkjdFfojVk4esCIMk4+jpl5FSbMTDcJgVha91KpugKqFcjCdDO0stpM53ATPVmo5xt2/kGJcAPgwLwAaupemD7Pqzf4/Yuz4FG/vBZm8SSGuTO/F+6qgLhxyFyK2HBtA1Q1vFHPMd878O7bJlfCIkmFaOroDByv0R+vWTLyT937u5wV7+gM6Y+RIpdNqWyMJiFfa+UeG7NcMXYiSG+vu11rqXtWsqN1zBoCJ2mPVMpeKreJ+oa4MzoYO5plO6fZFPTMCHs3wXgj+EAosK87cVOAXITlFh12LNyHfeAgL+kazn4HbG01OyRZU84fj+LqPT6p99f48Cp5yO/gTUOliNpatfmCVUJ1li0UlGR8whH6NEJ7opNZzJ4lXFhMtG2npEAPKRosJJxjwaOFhBfJHW0QZtZL1QboZwS6M2OiTH/K8V9fqchzcXTr5RQ+J0d63h1SnxIIrtvaGg5hxFDC6Xzm1w9jumCykEOAopNuD8bg5Wl+4XEQ8TPjq5rT7zXK9brK2ZtW0/Na+WyrlP3RGPYPrckaFVywVtgDnwaRtjCHfnc/vj03yXpM68/YpyKkX8fDa1lEoWopFpi5ierjnzhRp9vq0HoO//ZdEbWh3CmKPAAuBhXtyQjNixkiDLEmBVWCBgBbhkR+BRXS5o1W8FzvTkKJunm1M1QaZ3D4nbCfiIwPtaYcH9BGCsqC7esx17Y3o98SLXy3lxCdHfmCo+JDJSHB4d7S1cCy/ICR+h5BBDdk5jtOJBj3g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(2906002)(7406005)(7416002)(44832011)(8676002)(8936002)(5660300002)(41300700001)(6916009)(54906003)(70586007)(70206006)(316002)(4326008)(6666004)(36860700001)(82310400005)(478600001)(1076003)(36756003)(40460700003)(83380400001)(86362001)(2616005)(16526019)(26005)(47076005)(336012)(426003)(81166007)(186003)(356005)(40480700001)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 04:38:45.4832
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b63579-e684-40b1-ee7d-08db6afee869
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042A7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6337
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

KVM_SEV_SNP_LAUNCH_START begins the launch process for an SEV-SNP guest.
The command initializes a cryptographic digest context used to construct
the measurement of the guest. If the guest is expected to be migrated,
the command also binds a migration agent (MA) to the guest.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
[mdr: hold sev_deactivate_lock when calling SEV_CMD_SNP_DECOMMISSION]
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  24 ++++
 arch/x86/kvm/svm/sev.c                        | 126 +++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 include/uapi/linux/kvm.h                      |  10 ++
 4 files changed, 158 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1240d28badd6..3293e86f9b8a 100644
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
index 70e0576a32d0..e65f3be67c23 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -22,6 +22,7 @@
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
+#include <asm/sev-host.h>
 
 #include "mmu.h"
 #include "x86.h"
@@ -75,6 +76,8 @@ static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
+static int snp_decommission_context(struct kvm *kvm);
+
 struct enc_region {
 	struct list_head list;
 	unsigned long npages;
@@ -100,12 +103,17 @@ static int sev_flush_asids(int min_asid, int max_asid)
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
@@ -1871,6 +1879,80 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
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
@@ -1961,6 +2043,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_FINISH:
 		r = sev_receive_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_START:
+		r = snp_launch_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2152,6 +2237,33 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
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
+	down_write(&sev_deactivate_lock);
+	ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
+	if (WARN_ONCE(ret, "failed to release guest context")) {
+		up_write(&sev_deactivate_lock);
+		return ret;
+	}
+
+	up_write(&sev_deactivate_lock);
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
@@ -2193,7 +2305,15 @@ void sev_vm_destroy(struct kvm *kvm)
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
index 4360cf04f53a..9a7cafb018fe 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -93,6 +93,7 @@ struct kvm_sev_info {
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
 	u64 snp_init_flags;
+	void *snp_context;      /* SNP guest context page */
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 43b6291e3a80..b4c7ac9710d3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1928,6 +1928,7 @@ enum sev_cmd_id {
 
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT,
+	KVM_SEV_SNP_LAUNCH_START,
 
 	KVM_SEV_NR_MAX,
 };
@@ -2035,6 +2036,15 @@ struct kvm_snp_init {
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

