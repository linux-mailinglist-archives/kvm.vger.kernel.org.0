Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18D964D096
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiLNUC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiLNUBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:01:53 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73B42B274;
        Wed, 14 Dec 2022 11:57:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avyqhqcVe7+7HNwtEW7KC95g5ohvWhbLLtnfwDv7cC5hjQqpsCV5m7yMAxUwL+DoSxVfdA8QmZIdvsVCcJlbquEe8qno7XudLMLsQ1rYEE9r2NJdIFrQ/hv31UqAlRyjZwt3b1kx0GEcFbToGg8ZcoX6vMn7TjwHw6L6BzM2KL4qHDw5mJsMkR6WnJPssRbN94QgUtpmeJpIHOA2/+26Uwvo+k7ax/hal7IZ8qpikVqxhjU4cqeuqhBkr0XfC7GdIoYrcroFajfxfGT7WXylpsGz/L2wZ3AIM2MzoKVGD9rI6IkTM+upfKij8sitOmB28YL16kj8Ey5wF29dM7A9Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D60tz+ftdXdZiCmZ7XbBtHBe2fPSUEmTcsDkq2v56QU=;
 b=kwtMpCc+OXnJu0LQ97Hqmb7hVl16ZSUvzOwfAJtl6LW6GT0VzqC2UzWzys1u27QL1w+dyV1ia4vy3eixFeG3ReZatch26171REcbSajUuOmove76jQhLyJjNQlvBa15fMEWlbVE2GEwQepD3Zv4C3B1ngt/5fYvA8qMzNwiwt69c0E17NbEZpYtuSWgzkZi6I0u3aZ5QoVAmTMmjKwcFtst+qfc9ZxL3D/S3NSRV+9dHYw01oyjLpFZfAlWulnvwxkuQf1d/zEt9hkhm2XHTt4UM/YzTy7OpXJ8pGsyL8GDmo09NvD8JeiAYR1Hl/pumhymUP8FSslScTudTe16BxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D60tz+ftdXdZiCmZ7XbBtHBe2fPSUEmTcsDkq2v56QU=;
 b=lBBP4kjvASSYRgzmIPbCB1Jh/ZPRZqHLyxTEuIGwR7yiSzHm3zY2K0jH2f1ZckB6Fc/63JotuSUxFv8ZSGJ6YnS5p/VxFEP49lBTbC73gUz4geimkvUJq/4bK7Ioj0FSC+VyMWZSKxqK6PWYVrl3/Y4mMn7PSBT12mGkas2nEx0=
Received: from MW4PR03CA0273.namprd03.prod.outlook.com (2603:10b6:303:b5::8)
 by SA3PR12MB7860.namprd12.prod.outlook.com (2603:10b6:806:307::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 19:57:37 +0000
Received: from CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::3f) by MW4PR03CA0273.outlook.office365.com
 (2603:10b6:303:b5::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 19:57:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT114.mail.protection.outlook.com (10.13.174.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.11 via Frontend Transport; Wed, 14 Dec 2022 19:57:35 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 13:57:34 -0600
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
        Brijesh Singh <brijesh.singh@amd.com>,
        Pavan Kumar Paluri <papaluri@amd.com>
Subject: [PATCH RFC v7 37/64] KVM: SVM: Add KVM_SNP_INIT command
Date:   Wed, 14 Dec 2022 13:40:29 -0600
Message-ID: <20221214194056.161492-38-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT114:EE_|SA3PR12MB7860:EE_
X-MS-Office365-Filtering-Correlation-Id: f66660e0-9955-4cb8-d5e5-08dade0d7246
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hAPO3W+/GASilihmenEdCtr//6r4ylCYSuXyL804DuSg6KNozv4FNu7Y12gn/F3rcj9qrxWHC9j+9oPAJlU7yoGYIyOdFj5J9juh/58g0hUz0cvNCHHI5sjVsBgOiCPS56zu/Ax0UYOAL01vz760RHNP5hW4aAEMAWFxVVk2EhGiYJqq+vWvpsBUgKzzKIXwyrBK4HB8yJJEPDJndvmFnusXuWo+rXRf1yk3+nA2QzJehx5xxs/eijAf0MVhy0I9Gb+TfDqutiInJt+ljnkCjnJkTMdJyjrEF6oWqIfuq6qHDMF7EqLj/LLzJtltebI/+etR9wo/PNOSWjuai1vgQaSTAQYtCAoQLGHIqB/83UmE3RTUOO59GGO4zIIrDotRhGHO9+M6bkKPH5U78M7arwCswidaemheNui8EbaPGkGHn165QhV4IjlxcOctUxawg3uxu73jlExkAUOJZRerzlFd3TMdyVBeYoCV6iL2Erh8QOXLMerWJpe2WMP2m6/Ly3c2icgAliY/DPwc1OPXmmCkqGYNGFYfFy0/00I2oK2UEgNavApycNqzS6vSnLcTo+xsJYUveFDz3W7nJmqhQ8LPVLBLtsKIfda4JsdlreNgmVfkg4IAoy3swmIg+UI5geyhHg0lDTDjMGjJO+IaDlvsNcNEFbZzgXk07sJ10k2uL7Yg3mB5MNZfrHw4cV250llBrCwQHXHdWHF1UfzqwMcOUOE4VK6rc/W71k+PdwI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199015)(46966006)(36840700001)(40470700004)(40460700003)(70586007)(2616005)(2906002)(186003)(426003)(36756003)(47076005)(36860700001)(86362001)(336012)(16526019)(44832011)(54906003)(83380400001)(1076003)(6916009)(6666004)(356005)(478600001)(81166007)(82310400005)(82740400003)(41300700001)(8936002)(8676002)(40480700001)(5660300002)(4326008)(70206006)(316002)(7416002)(7406005)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 19:57:35.8126
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f66660e0-9955-4cb8-d5e5-08dade0d7246
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7860
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

The KVM_SNP_INIT command is used by the hypervisor to initialize the
SEV-SNP platform context. In a typical workflow, this command should be the
first command issued. When creating SEV-SNP guest, the VMM must use this
command instead of the KVM_SEV_INIT or KVM_SEV_ES_INIT.

The flags value must be zero, it will be extended in future SNP support to
communicate the optional features (such as restricted INT injection etc).

Co-developed-by: Pavan Kumar Paluri <papaluri@amd.com>
Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 27 ++++++++++++
 arch/x86/include/asm/svm.h                    |  1 +
 arch/x86/kvm/svm/sev.c                        | 44 ++++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |  4 ++
 include/uapi/linux/kvm.h                      | 13 ++++++
 5 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 935aaeb97fe6..2432213bd0ea 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -434,6 +434,33 @@ issued by the hypervisor to make the guest ready for execution.
 
 Returns: 0 on success, -negative on error
 
+18. KVM_SNP_INIT
+----------------
+
+The KVM_SNP_INIT command can be used by the hypervisor to initialize SEV-SNP
+context. In a typical workflow, this command should be the first command issued.
+
+Parameters (in/out): struct kvm_snp_init
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_snp_init {
+                __u64 flags;
+        };
+
+The flags bitmap is defined as::
+
+   /* enable the restricted injection */
+   #define KVM_SEV_SNP_RESTRICTED_INJET   (1<<0)
+
+   /* enable the restricted injection timer */
+   #define KVM_SEV_SNP_RESTRICTED_TIMER_INJET   (1<<1)
+
+If the specified flags is not supported then return -EOPNOTSUPP, and the supported
+flags are returned.
+
 References
 ==========
 
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index cb1ee53ad3b1..c18d78d5e505 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -278,6 +278,7 @@ enum avic_ipi_failure_cause {
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
+#define SVM_SEV_FEAT_SNP_ACTIVE		BIT(0)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f34da1203e09..e3f857cde8c0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -247,6 +247,25 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 	sev_decommission(handle);
 }
 
+static int verify_snp_init_flags(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_snp_init params;
+	int ret = 0;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
+		return -EFAULT;
+
+	if (params.flags & ~SEV_SNP_SUPPORTED_FLAGS)
+		ret = -EOPNOTSUPP;
+
+	params.flags = SEV_SNP_SUPPORTED_FLAGS;
+
+	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params, sizeof(params)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
@@ -260,13 +279,23 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return ret;
 
 	sev->active = true;
-	sev->es_active = argp->id == KVM_SEV_ES_INIT;
+	sev->es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
+	sev->snp_active = argp->id == KVM_SEV_SNP_INIT;
 	asid = sev_asid_new(sev);
 	if (asid < 0)
 		goto e_no_asid;
 	sev->asid = asid;
 
-	ret = sev_platform_init(&argp->error);
+	if (sev->snp_active) {
+		ret = verify_snp_init_flags(kvm, argp);
+		if (ret)
+			goto e_free;
+
+		ret = sev_snp_init(&argp->error, false);
+	} else {
+		ret = sev_platform_init(&argp->error);
+	}
+
 	if (ret)
 		goto e_free;
 
@@ -281,6 +310,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	sev_asid_free(sev);
 	sev->asid = 0;
 e_no_asid:
+	sev->snp_active = false;
 	sev->es_active = false;
 	sev->active = false;
 	return ret;
@@ -741,6 +771,10 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
+	/* Enable the SEV-SNP feature */
+	if (sev_snp_guest(svm->vcpu.kvm))
+		save->sev_features |= SVM_SEV_FEAT_SNP_ACTIVE;
+
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
 
@@ -1993,6 +2027,12 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	}
 
 	switch (sev_cmd.id) {
+	case KVM_SEV_SNP_INIT:
+		if (!sev_snp_enabled) {
+			r = -ENOTTY;
+			goto out;
+		}
+		fallthrough;
 	case KVM_SEV_ES_INIT:
 		if (!sev_es_enabled) {
 			r = -ENOTTY;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a48fe5d2bea5..379b253d2464 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -80,6 +80,9 @@ enum {
 /* TPR and CR2 are always written before VMRUN */
 #define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
 
+/* Supported init feature flags */
+#define SEV_SNP_SUPPORTED_FLAGS		0x0
+
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
@@ -95,6 +98,7 @@ struct kvm_sev_info {
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
+	u64 snp_init_flags;
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index cc9424ccf9b2..a6c73297a62d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1938,6 +1938,9 @@ enum sev_cmd_id {
 	/* Guest Migration Extension */
 	KVM_SEV_SEND_CANCEL,
 
+	/* SNP specific commands */
+	KVM_SEV_SNP_INIT,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -2034,6 +2037,16 @@ struct kvm_sev_receive_update_data {
 	__u32 trans_len;
 };
 
+/* enable the restricted injection */
+#define KVM_SEV_SNP_RESTRICTED_INJET   (1 << 0)
+
+/* enable the restricted injection timer */
+#define KVM_SEV_SNP_RESTRICTED_TIMER_INJET   (1 << 1)
+
+struct kvm_snp_init {
+	__u64 flags;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.25.1

