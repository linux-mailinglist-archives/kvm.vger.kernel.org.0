Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1935527C2
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 01:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346679AbiFTXJi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 19:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346757AbiFTXIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 19:08:31 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489C525582;
        Mon, 20 Jun 2022 16:07:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LuYKCjqdbjVoT+xI5FbW65Fz29VLJmVegyi4tj9jlXhXTdO+tCFfkxntcdCUuKqu5lwZ3pc7c8c5BY1lo06zo7/QmsIHIeiyOi47ec8RLjOKwUAVBv0Kj2/rcK8/fkQndHLmsA08SGRUth7su01soYB2jO8GK05cepZVdlxit4s1ijUwnaBXSAtuaZrBkU/44HbPESiYDhq1bhoyfAHAA0Ecvv7YVPoUIXJkGrHBJ7Xp6mLT+WqsSyDJI5jtsHDCmYbt9m/TDHPq0bwMMQ5hBDUoAL57XR7nlzAkbeezrcMU1KO8SFBXSykuVJZTjmuYEnlJZaQwl+a3VsHad07O0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Fmz6QrU99+Lb25womK0v9COfI6FoSAMFvC/fHrXuBc=;
 b=X6lp3V6/jAqDz5uRDpOFBUrzjZyqzT5jWzqGQDXqbq/z7Fa1mAIEWoz+7bukUNn+vLgbRS0KOg+TkMCNgZeX8eY8+9+OkMfUOXLNOSmuqzJGmP+70/gDimljY9MNW3JI2r7kUAv2UFRMD+sWqlsbAdaQjMvti907ClqdrAFChlOiIOiB+8Tdy7vyCW/pvTwK5jPJmO+OGTBAXxexSKaGfKW0hcA+5gVBV7pKW5y84rkAH1ZatwAJ2xgBydAICzx0mR1aWbEYRMO3KGT1DtPIbTjO8+Gi863y/F9Il6CPlk7NcwxxtaehDwaAMu/J+a1HvsxiLm/lqyAQ83+WRZ9ztQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Fmz6QrU99+Lb25womK0v9COfI6FoSAMFvC/fHrXuBc=;
 b=lxJhTQpGK18x6Llq7yHRcNFC1bYZs/poExliSs9XqIwx7+67rVNrmpUr1r9pKS0UH9gw5Rly42kSCqACOpcNVyJYl6faVpv/lMoJAv9TbhubLxzCyuQhkPYYIYZym4Ui9qqwUw03LVQy7ZIGgBbV10JyxuOOyk0INzFoeZ887q0=
Received: from SA1PR03CA0008.namprd03.prod.outlook.com (2603:10b6:806:2d3::7)
 by MW4PR12MB5644.namprd12.prod.outlook.com (2603:10b6:303:189::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Mon, 20 Jun
 2022 23:07:33 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:806:2d3:cafe::ea) by SA1PR03CA0008.outlook.office365.com
 (2603:10b6:806:2d3::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 23:07:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 23:07:32 +0000
Received: from ashkalraubuntuserver.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 20 Jun 2022 18:07:30 -0500
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
Subject: [PATCH Part2 v6 23/49] KVM: SVM: Add KVM_SNP_INIT command
Date:   Mon, 20 Jun 2022 23:07:20 +0000
Message-ID: <3d33a75f6df53b94557dcd48e2046d2243fa55e1.1655761627.git.ashish.kalra@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 86d25524-d04a-4bc7-4e0d-08da5311a81b
X-MS-TrafficTypeDiagnostic: MW4PR12MB5644:EE_
X-Microsoft-Antispam-PRVS: <MW4PR12MB56447FF9447B435127EDBD6C8EB09@MW4PR12MB5644.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FHslrcqdwPuk9LcLNq9KMB80QdczwTD1RyBqGrgHoJhsWkfLsJeLMHezT0575WPnfMEbCYiUlodjddMdTVPCY6EkG6caK1jdgpxuysvXmqyQYl8SLhmgzgYHZe0fbC5pjS2lAwz0ta5GA1cWKIbjvJySf1TtABkrBFkH6a4w0VXAZ1Rbaqb3Y5TIKxPX2HQVzFJht4zhc5i1ElyOoPe6+/b5WIoJt43th2MU0IFAxH2Z/a2fAyY7EBpCWCnzaKPR17fDAHFFFAghPfubNWRIPMU+A1gFjXl+vcuI0s5kSi5hQoIi3Pesv+pqBwoSvZQ/amEFWg4XnM+dTRlXMRh2RMxNjQQGSh6CLsDjEdnLLCIhtvxPSDmm+Puo/QhqzFZoKCvVsKGoJThIpbeaq5nwbNPVYqxu0/lc4fSN53bDC0Eu7qDOkAP3AZh3l6NQn7gejHXd/2EM1thqt119qAU/NBEk7K2N6gIGeAPtpcGz1I9tp/ez/j7GOF0tAiSh6gm9q0IbfYyzHqNS+ywcFr+l5N+Btqog1u4E8pS4tNUdLWoGcCyGiTCUor4rQt3XNTOarkm6pGKTRmrmbc9RpclAYWMjnmeSyfar8xP8foN98EtpKglXlURiiYi9BK+y0D4i3oakcGwmNSbaJ/hztNbblWlqsI9jSpTieVieC8lODYoKKH3p/B1fJ8s4b/u0x1ErYBbR98ah/Is2YoO52MMSNDsi8jclFJnXBcNkmIhy3evlJf3TATaf7rdUMQD1U4c4Q6vCjSweg3mY3FHo1vQOFg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(396003)(40470700004)(46966006)(36840700001)(478600001)(2906002)(26005)(40480700001)(40460700003)(81166007)(7696005)(426003)(7406005)(82740400003)(54906003)(5660300002)(8936002)(110136005)(186003)(16526019)(2616005)(7416002)(36860700001)(36756003)(83380400001)(70206006)(86362001)(6666004)(356005)(4326008)(8676002)(316002)(70586007)(82310400005)(41300700001)(47076005)(336012)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 23:07:32.5164
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86d25524-d04a-4bc7-4e0d-08da5311a81b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5644
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

The KVM_SNP_INIT command is used by the hypervisor to initialize the
SEV-SNP platform context. In a typical workflow, this command should be the
first command issued. When creating SEV-SNP guest, the VMM must use this
command instead of the KVM_SEV_INIT or KVM_SEV_ES_INIT.

The flags value must be zero, it will be extended in future SNP support to
communicate the optional features (such as restricted INT injection etc).

Co-developed-by: Pavan Kumar Paluri <papaluri@amd.com>
Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 27 ++++++++++++
 arch/x86/include/asm/svm.h                    |  1 +
 arch/x86/kvm/svm/sev.c                        | 44 ++++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |  4 ++
 include/uapi/linux/kvm.h                      | 13 ++++++
 5 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 2d307811978c..903023f524af 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -435,6 +435,33 @@ issued by the hypervisor to make the guest ready for execution.
 
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
index 1b07fba11704..284a8113227e 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -263,6 +263,7 @@ enum avic_ipi_failure_cause {
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
+#define SVM_SEV_FEAT_SNP_ACTIVE		BIT(0)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dc1f69a28aa7..813bda7f7b55 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -241,6 +241,25 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
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
@@ -254,13 +273,23 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
+		ret = sev_snp_init(&argp->error);
+	} else {
+		ret = sev_platform_init(&argp->error);
+	}
+
 	if (ret)
 		goto e_free;
 
@@ -275,6 +304,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	sev_asid_free(sev);
 	sev->asid = 0;
 e_no_asid:
+	sev->snp_active = false;
 	sev->es_active = false;
 	sev->active = false;
 	return ret;
@@ -610,6 +640,10 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
+	/* Enable the SEV-SNP feature */
+	if (sev_snp_guest(svm->vcpu.kvm))
+		save->sev_features |= SVM_SEV_FEAT_SNP_ACTIVE;
+
 	return 0;
 }
 
@@ -1815,6 +1849,12 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
index edecc5066517..2f45589ee596 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -72,6 +72,9 @@ enum {
 /* TPR and CR2 are always written before VMRUN */
 #define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
 
+/* Supported init feature flags */
+#define SEV_SNP_SUPPORTED_FLAGS		0x0
+
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
@@ -87,6 +90,7 @@ struct kvm_sev_info {
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
+	u64 snp_init_flags;
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 68ce07185f03..0f912cefc544 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1810,6 +1810,9 @@ enum sev_cmd_id {
 	/* Guest Migration Extension */
 	KVM_SEV_SEND_CANCEL,
 
+	/* SNP specific commands */
+	KVM_SEV_SNP_INIT,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -1906,6 +1909,16 @@ struct kvm_sev_receive_update_data {
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

