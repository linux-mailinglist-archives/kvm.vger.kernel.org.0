Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B7B5527C4
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346664AbiFTXJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346833AbiFTXIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:08:34 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2041.outbound.protection.outlook.com [40.107.95.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748971E1;
        Mon, 20 Jun 2022 16:07:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TpleZEUhqCfXi8AFe3p0Lcej8EQiHPCKcYiNV/GTYj8Rlv/XLti+TQ9v7S4izZe//5O0mA/7np+ryggclDZmvrykNGS4YROUD++26/bT1J5UTHJJEnZRrMpQb10FqmAaqyguDwBFnwQVMNdasFvL8leHwbTZsV0ZEJx1Xvuu/qwiR0gGuFzwnlG06EcHBFn6Svgqyykh/FnL541zkoTOIHOm6MxbYD7TP0XR/4K2Ax4bLKgq/ldoe5Wck11liL+pDJUGsm9ePpqzyCISIGH5e556aQ918HkGREbbGMxzw1bId2NZuEkOZCXVUJpqED2WfueLnuWK4O/J+V3EomtC7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ru40gwA2hMvkqt6QUkevHQDAp5QmGsy4qcH0u5fXdU8=;
 b=nvoS8AhH1zxS4GZGm35+Rsz0kK37zWECSuHEyRIymuqq8M6BT6vOTTkD6liJuMaoBZK7vKlkAvAGqKUU5aR8QIfujRi5zkzctpu5XWirjEGX+RLnMYjgSd9POS6S1DsHUArD6fnW0dtSMKOHZy5nATAShVJlqyZo9ZDagq0s+lBD7LTq0otaavKrHsOf5gn8c7uN+uGWmv3LL8EzChSjBBoYyS7Zp7mus88olRNBlDb5JmuIdIfXISFvXcyBlNURyAqlG31E4l0Oe6Tcb8SR3IOBI3brIW1IlqVuyS81vRT45PaoQR1xJrRHdC3ACuJqfu5SINsORZryQLI4uy38vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ru40gwA2hMvkqt6QUkevHQDAp5QmGsy4qcH0u5fXdU8=;
 b=ImDKE5wccrxxQPJ32yd0V0CXiHjyKGpOvqs76ks+itv7VeIDoJS9T9+c7KBeWbUqDgpSHOXx9O0jZaKgABnTGk0iKMC2ayK4MGk0ed3NSm5x9llq3SLRcgLSogqbSPJygoMr6fkki3+8VTDMbLampMgwe+XPHsHiDZg42hm2cG8=
Received: from DM5PR07CA0148.namprd07.prod.outlook.com (2603:10b6:3:ee::14) by
 CH2PR12MB4923.namprd12.prod.outlook.com (2603:10b6:610:6a::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.18; Mon, 20 Jun 2022 23:07:47 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ee:cafe::4c) by DM5PR07CA0148.outlook.office365.com
 (2603:10b6:3:ee::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16 via Frontend
 Transport; Mon, 20 Jun 2022 23:07:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:07:46 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:07:44 -0500
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
Subject: [PATCH Part2 v6 24/49] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START command
Date:   Mon, 20 Jun 2022 23:07:35 +0000
Message-ID: <6d5c899030b113755e6c093e8bb9ad123280edc6.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1400a3c2-8384-418a-c76e-08da5311b0b6
X-MS-TrafficTypeDiagnostic: CH2PR12MB4923:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4923C84D8118F12546F67FC78EB09@CH2PR12MB4923.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YQifSHjp+dPs48g2FY01DVmptCN3pFMt7K7RUsxWLezn6W7cY3JxMV+iJN0htAQTY6sYACYbPFiq8XTYQCllW4NGH53GUSFxU9tx8PQ8htJnpSSUiWQ7jNzbP7ZnC7YvQZrftITvK47SSBrgaRiYB9MM5MHT4s0m2fwTKR50XSjY7GZk9EZn+dvN9XcgxSkxHmD6Gz0tpepTMHbUvQkTsao9miVtGc2/sgXHQGJr+ZjdI3m8xKq29kL9BAnDA+4QR8jIM7fisZJP7s9i7NJK7FHQx3c1cWqHSjimKzap7J/11jDrqvvlb12dG1m45dymV0ET9+bsUxNVVFgidsmUf/SxARxgXOS3xrtbd2uH34elmWGQ+LHxVTqI9Czr/iftSRgYT301IY3n+dxICnfA0R8HO81ajmHgGaw0FF9mBxNnUNMseL0hhjNJNqdWJsqAp68ygXDzSzOKuZjvEZHR3tdBS7HqGBwS88b3lopaDmeUdv4aZlgkdP0BlLjQ+ReT/3T3I6A4d5kZB3S5h7OADyqhVDed4zhky0RkXz+MlreRoZvzhd57rz8p0Y42rvuWFKtiBrBfA36o1O5kV3/q6MjMdYRoRWhk4xDnLWy57CZ/N76CpTYryfltEFccJORwR3djp478c5HFODO8AoN5nvrwCns2EswOh+wIa4BDoY9v54lj4pdNHx71e3x2C4ytnhH9aTKgkZKOrTYSkUAF+YBzNzoPiVkZujrtffD4PkChSynvkC56li3aBNIm+jUtZwn6qgLT23bdgA5qtQqMAw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(396003)(346002)(40470700004)(46966006)(36840700001)(186003)(8936002)(16526019)(41300700001)(70586007)(426003)(83380400001)(336012)(356005)(70206006)(4326008)(26005)(82310400005)(8676002)(6666004)(36756003)(5660300002)(40460700003)(7416002)(36860700001)(47076005)(7696005)(2616005)(86362001)(316002)(478600001)(40480700001)(81166007)(2906002)(110136005)(54906003)(7406005)(82740400003)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:07:46.9570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1400a3c2-8384-418a-c76e-08da5311b0b6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4923
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

KVM_SEV_SNP_LAUNCH_START begins the launch process for an SEV-SNP guest.
The command initializes a cryptographic digest context used to construct
the measurement of the guest. If the guest is expected to be migrated,
the command also binds a migration agent (MA) to the guest.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  24 ++++
 arch/x86/kvm/svm/sev.c                        | 115 +++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 include/uapi/linux/kvm.h                      |  10 ++
 4 files changed, 147 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 903023f524af..878711f2dca6 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -462,6 +462,30 @@ The flags bitmap is defined as::
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
+                __u8 ma_en;             /* 1 if the migtation agent is enabled */
+                __u8 imi_en;            /* set IMI to 1. */
+                __u8 gosvw[16];         /* guest OS visible workarounds */
+        };
+
+See the SEV-SNP specification for further detail on the launch input.
+
 References
 ==========
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 813bda7f7b55..9e6fc7a94ed7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -21,6 +21,7 @@
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
+#include <asm/sev.h>
 
 #include "x86.h"
 #include "svm.h"
@@ -73,6 +74,8 @@ static unsigned int nr_asids;
 static unsigned long *sev_asid_bitmap;
 static unsigned long *sev_reclaim_asid_bitmap;
 
+static int snp_decommission_context(struct kvm *kvm);
+
 struct enc_region {
 	struct list_head list;
 	unsigned long npages;
@@ -98,12 +101,17 @@ static int sev_flush_asids(int min_asid, int max_asid)
 	down_write(&sev_deactivate_lock);
 
 	wbinvd_on_all_cpus();
-	ret = sev_guest_df_flush(&error);
+
+	if (sev_snp_enabled)
+		ret = snp_guest_df_flush(&error);
+	else
+		ret = sev_guest_df_flush(&error);
 
 	up_write(&sev_deactivate_lock);
 
 	if (ret)
-		pr_err("SEV: DF_FLUSH failed, ret=%d, error=%#x\n", ret, error);
+		pr_err("SEV%s: DF_FLUSH failed, ret=%d, error=%#x\n",
+			sev_snp_enabled ? "-SNP" : "", ret, error);
 
 	return ret;
 }
@@ -1825,6 +1833,74 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	return ret;
 }
 
+static void *snp_context_create(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct sev_data_snp_gctx_create data = {};
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
@@ -1915,6 +1991,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_RECEIVE_FINISH:
 		r = sev_receive_finish(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_START:
+		r = snp_launch_start(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -2106,6 +2185,28 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	return ret;
 }
 
+static int snp_decommission_context(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_decommission data = {};
+	int ret;
+
+	/* If context is not created then do nothing */
+	if (!sev->snp_context)
+		return 0;
+
+	data.gctx_paddr = __sme_pa(sev->snp_context);
+	ret = snp_guest_decommission(&data, NULL);
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
@@ -2147,7 +2248,15 @@ void sev_vm_destroy(struct kvm *kvm)
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
index 2f45589ee596..71c011af098e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -91,6 +91,7 @@ struct kvm_sev_info {
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
 	u64 snp_init_flags;
+	void *snp_context;      /* SNP guest context page */
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0f912cefc544..0cb119d66ae5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1812,6 +1812,7 @@ enum sev_cmd_id {
 
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT,
+	KVM_SEV_SNP_LAUNCH_START,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1919,6 +1920,15 @@ struct kvm_snp_init {
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

