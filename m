Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7DDD69D35E
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 19:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbjBTSyT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 13:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbjBTSyR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 13:54:17 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20604.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::604])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FB41D90B;
        Mon, 20 Feb 2023 10:53:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQ7BxpfBSKFJ+jskdVYkUFChbpmyB4dkd2ToJHlZ0FhigJwx2n+izYoU1ius1Zx/lnTW8eazA8k2cFV3tTP8MoGengY9qzRj3UDhhjzRUJefcjfb3nMtH7jkhd2WdmIOHNFQJxjygydycPr3ad7n9XXIC8j/kazVj/lJEDeEg4ysn7uhon/xm065ojxJJGRbnevs2gnH6aFJ+k9VdYlBnDnEu7rNbsUsl3HENfcJWSD/t1Aha7HXNbR4OLVh2lQJn6eMI4PG1wP2TYMFDVJhTB0avCdngvOZSindC2EG2DisiqKXXzHQ/KiWv/67bXnrGTuAiudd4DEN0Go5Kok+Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lzZtYSsYtaJMwvMB8+nYvnXncTA2MsPdhi/xqq416ss=;
 b=PmOuJDHwccDnftVUF2gG9bAVjZbDJtV4/O0Qm6wYdRIoxxbJNYi7/WW8rHx+HVeT0Y7aKziKNIvLOY4ZTMeEBYqTtBZcszV4s7DPVE4qko+J98+PkB2DJ9ZKW3eM8F97EPGNX1tfacS63aA2A1ThazcXqFnrZQSYAb2kVwbShuVpUYaiUsqlNHfauIbIsJk2MpL/t3pdErZoE2I/UN13FbvwIrHn4iXe6v57ONTVxbAFbczRXJg2Y9DL93WA/G7VanBx3h3ps++2pIg3mdwACzrsjeJM7NCmz58oeAChFOE6eQiteUhX4m0vz3fGSmpCFZuMlE5X+88wf7pZ5Pp1Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lzZtYSsYtaJMwvMB8+nYvnXncTA2MsPdhi/xqq416ss=;
 b=BvDayb++Yyi1QP5M0y4E3Xnshfvq1yk6E6X6GoLQi2QHvIocRsjyOe7ujovmCQqfC/XiFaEqTipLpNtwDua3Xe7gSePS3I2S7TYInK18V9oXvjT2FHyKMDe8oYdZAcYFacE+fp9QaHz0nu4jvgqajF5yJfOHo2NIuSr3vOvhhrk=
Received: from DS7PR03CA0299.namprd03.prod.outlook.com (2603:10b6:5:3ad::34)
 by SN7PR12MB6790.namprd12.prod.outlook.com (2603:10b6:806:269::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 18:52:38 +0000
Received: from DM6NAM11FT102.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::97) by DS7PR03CA0299.outlook.office365.com
 (2603:10b6:5:3ad::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19 via Frontend
 Transport; Mon, 20 Feb 2023 18:52:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT102.mail.protection.outlook.com (10.13.173.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.21 via Frontend Transport; Mon, 20 Feb 2023 18:52:38 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Feb
 2023 12:52:37 -0600
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
        Brijesh Singh <brijesh.singh@amd.com>,
        "Pavan Kumar Paluri" <papaluri@amd.com>
Subject: [PATCH RFC v8 33/56] KVM: SVM: Add KVM_SNP_INIT command
Date:   Mon, 20 Feb 2023 12:38:24 -0600
Message-ID: <20230220183847.59159-34-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT102:EE_|SN7PR12MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: a03bb785-94b5-4cd6-ddf6-08db1373a330
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FQIHKNEX5pmo00zCrEUktzboyf+dX77Y2yI09CUgwGkOo9FN7YfTuUq6OTusI1IFsY5LXg6UNbixiOdLhX/qHgbhix88lV93pF5NJqz7uahHQHcxhjzooj4FbUoN9jNjiaxGHLmECbUhFFSoKuOQPgpuFRABiqZu7vBOxd5nAu9jKdE3JjJ9AxIIm45CSWHo1ow9FkAngi4+UrTeaMZUUGfr39KkuASjsAaLdW1z7WXSMA1ZLedGYsfAbtCzg9o50BWtQYfndKPGI/AIzLRIjbGYhyj+qP/HZIm/r1uZ5YUJBjzAVI+HbESaGOt0rsZJJkLkRnk17rZbUNUyYrgkCPmkq/TWFsPak8C882ovyLul+iMfw2hLzRROlA/2jP28zyOz/TLwEN9tNwnIVCl/p4vKKG239F94gxplmuh3mSW0Th5fiQ9iv+S/sAyBEwSNmzHPoGxE2jsNpMoQTKeDwVdcaGYC8VX4/yg1qtjNiCbzUgaj7YEcLzNBGrGa6AxkLr2ekN0I8lykAkcojr/ear1HA9e52gUbeXmrTjq8kSF0q6sGqC3XRrgD6o5h+4F1NYFmfuD/3f05X3jFJn2afukQbUxDM6c1FlPkRU8Xg5Dfjh6HeSClGvt/u38X7v9QNIVIpVEbl+tStvSN8oPDHD14Yf5Spc+5iQMHI9s0TUylIBngrzT7niJnQ0YGNJuG7Kg+2whzFmlgpL5GIEAssgUACyOjzvGf5fkjVkJd9K0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(136003)(396003)(451199018)(46966006)(36840700001)(40470700004)(47076005)(40460700003)(478600001)(426003)(54906003)(336012)(81166007)(82310400005)(82740400003)(86362001)(44832011)(2906002)(36860700001)(356005)(316002)(41300700001)(5660300002)(7416002)(7406005)(83380400001)(70586007)(40480700001)(8676002)(6916009)(4326008)(70206006)(8936002)(36756003)(2616005)(186003)(16526019)(1076003)(6666004)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 18:52:38.2331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a03bb785-94b5-4cd6-ddf6-08db1373a330
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT102.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6790
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
index 51db01b282eb..a8efe1f6bf77 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -243,6 +243,25 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
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
@@ -256,13 +275,23 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
 
@@ -277,6 +306,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	sev_asid_free(sev);
 	sev->asid = 0;
 e_no_asid:
+	sev->snp_active = false;
 	sev->es_active = false;
 	sev->active = false;
 	return ret;
@@ -749,6 +779,10 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
+	/* Enable the SEV-SNP feature */
+	if (sev_snp_guest(svm->vcpu.kvm))
+		save->sev_features |= SVM_SEV_FEAT_SNP_ACTIVE;
+
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
 
@@ -2001,6 +2035,12 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
index 8eb1b51e92f5..56a5c96d8a36 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -73,6 +73,9 @@ enum {
 /* TPR and CR2 are always written before VMRUN */
 #define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
 
+/* Supported init feature flags */
+#define SEV_SNP_SUPPORTED_FLAGS		0x0
+
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
@@ -88,6 +91,7 @@ struct kvm_sev_info {
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
+	u64 snp_init_flags;
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2fba29125ec2..499cc323f793 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1917,6 +1917,9 @@ enum sev_cmd_id {
 	/* Guest Migration Extension */
 	KVM_SEV_SEND_CANCEL,
 
+	/* SNP specific commands */
+	KVM_SEV_SNP_INIT,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -2013,6 +2016,16 @@ struct kvm_sev_receive_update_data {
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

