Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF91D69D363
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbjBTSzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjBTSyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:54:47 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D76FA5E9;
        Mon, 20 Feb 2023 10:54:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bn0I8tRk74veKXoi+NS7P+CkSafrwCA2XaRi11ywb+SnDNqix4eGk4F2ywZm6gtME4/FnvBThtn+lp7eOjXhgbhZCKhstynzu0Ycgg6aqLNGlYgd/wPx3rVdv6UD+2LXj3KGaunsL9n3Q6i3o5pYWMj385PPJ8on1hYl6dbmYPyQPZX/nhwuqoJjRkj37fzBEcVXPAWZsk0P33+XzyHQsFBXXwHdOFHV+gZ6tEzOZRMT2H62zfpDEilGiCCPya8uOlMWSXv/N1+rr+3tRkFZwArIVpmCGnXjDDn3V20fM218XzGMgx6tT70+1LZ1qrqFWmX5dKBi+pivDB0ywnZsRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FB2N6JkgN/Cjkvv6VZ4HEN31LDCqlLOev6/9qU2o1SI=;
 b=bWXUgKZRDbxjKngBSfRT4scBV0OnIPLu2tGSjiMHG5HYD6ONnvEXAgsBFXkwktVHiL6S1Iy61svQVpI7BpqD0MHmnthuOynHfnmkDu+P8zFa+Tfdb+SDlNQmrQXOcPKcMe2WRg6OeOmau9AmpHCmFx3E6TsnW5NF419glNeXF6RH7BcLtzP4qphR9IC5Dax89XcSyhkALU6H39ipEcvxUthz0mToGmJ5NJzmz35+68KGL1rqUrxe7HweSwqsv3j78YaoSYQcvmbxCK3Mc/W5OJlGGxeso1UfNzSj4L4OZWOPQDHYH9yX4t4u7E6CE/y8JcLPQo/inVeTXblaTS0PWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FB2N6JkgN/Cjkvv6VZ4HEN31LDCqlLOev6/9qU2o1SI=;
 b=zY/3TP1PUkR8zHnjqGaKe3E3sE8nj8Cm9Mmc5LASblRG4RDEtxPUFfAhS9z5an3P7F36lM5jZpgdFbfscQXNVqYomIa/TGaH3kXcmjVwFlNpvTdVGHt+9pOKYjt+xgH599RnZ4vQ1HwoqCfgLZXr8yvXVCOsm/aCO4h8HnTvLvA=
Received: from DM6PR21CA0024.namprd21.prod.outlook.com (2603:10b6:5:174::34)
 by DS0PR12MB6557.namprd12.prod.outlook.com (2603:10b6:8:d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.19; Mon, 20 Feb 2023 18:52:59 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::72) by DM6PR21CA0024.outlook.office365.com
 (2603:10b6:5:174::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.6 via Frontend
 Transport; Mon, 20 Feb 2023 18:52:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.21 via Frontend Transport; Mon, 20 Feb 2023 18:52:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:52:58 -0600
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
Subject: [PATCH RFC v8 34/56] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START command
Date:   Mon, 20 Feb 2023 12:38:25 -0600
Message-ID: <20230220183847.59159-35-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT027:EE_|DS0PR12MB6557:EE_
X-MS-Office365-Filtering-Correlation-Id: b1cec592-d609-42e5-1671-08db1373afc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ntnxtuGE2g1MvPHDtIVgh2XrCH4n4HCQS8ioegSPzAf3+gVG3OTAW1foIsXXcAA+4mRVrQZGQ3tDIY3v1nhaDuaKn9I2Lj5Bez5iBKgV4ad0nrYKXz/RMVdwRdFeEpRMD9P1TdP1T3bD1uhVnwHnGWpC505Am/6AkAcsgp1utPaLwskoXNks2HAdSvqaCyYpABoWT9ytOztASNaZI10efnik2Zvm6wJbo2HomysJkCN6PexNprGbfkNWDUh2geUuKDFZ9u+iWp2ejNt9N9tp9yenjMq4dEK9aDMKhtx1AM80ZkriL7DINghcI7kJvai/pbbfCGGCQbBqTAhg1BYmBwrgClGJQUn0n/orD/PzYqYMre//x3YO2p0INvFim9CKNu4RRJ/3d6EHc0vfZUYCceJqKSL7Fb0orLeBaezmXnjgAQSjUUHa4ZAEJIe8LtkGad8ffn9wG7Uj7+hnARn24udXZJeRrrPgBjeus3a3Tr7m/ry3Z5h3vC9tTlPYM7dUitfdH5BnJ+hnPbdjdmGTrIf9lUJJnM+207sAI0cwrX1hF+UChxSLtPoyMpjljRZWcR4tzXNLRPdR1RAyqlCdgqXNJBvJfZfswCzmpI6yqx3EDerN/pWpoHKXCuchUnpiblkwPuC3xnF+XnwO5ovZCGzJbKjV/tALySFAqGkGtarh1SGFKFreOq0JUHD2dqURhJwcWx4c+XHl4h49LZrzEcobplfZvXdykQ9h10g6Zu8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(1076003)(41300700001)(4326008)(40480700001)(6916009)(8676002)(70586007)(70206006)(8936002)(5660300002)(7406005)(7416002)(83380400001)(2616005)(26005)(186003)(16526019)(6666004)(36756003)(54906003)(336012)(478600001)(47076005)(40460700003)(426003)(356005)(316002)(44832011)(86362001)(82740400003)(81166007)(82310400005)(36860700001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:52:59.2887
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1cec592-d609-42e5-1671-08db1373afc0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6557
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
index a8efe1f6bf77..097bb2138360 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -22,6 +22,7 @@
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
+#include <asm/sev.h>
 
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
@@ -2011,6 +2019,80 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
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
@@ -2101,6 +2183,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_FINISH:
 		r = sev_receive_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_START:
+		r = snp_launch_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2292,6 +2377,28 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
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
@@ -2333,7 +2440,15 @@ void sev_vm_destroy(struct kvm *kvm)
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
index 56a5c96d8a36..740969b57425 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -92,6 +92,7 @@ struct kvm_sev_info {
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
 	u64 snp_init_flags;
+	void *snp_context;      /* SNP guest context page */
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 499cc323f793..cf19799ca5ce 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1919,6 +1919,7 @@ enum sev_cmd_id {
 
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT,
+	KVM_SEV_SNP_LAUNCH_START,
 
 	KVM_SEV_NR_MAX,
 };
@@ -2026,6 +2027,15 @@ struct kvm_snp_init {
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

