Return-Path: <kvm+bounces-5377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8768207B8
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 18:27:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE90A1F21F40
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B1A1C2FE;
	Sat, 30 Dec 2023 17:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ghD/ytMb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8DCBA34;
	Sat, 30 Dec 2023 17:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOOQBoSDaS2i9M/e0MmJJc6geprrKt0CAXVE9m/csAxYyvfSk6a5qLmUTGcplCgvV3q8aAsxyKif7Rg/Ijxj9hdx975SNkvCDjn4WSgDwdVkljyKWekYF6J1iZp5UUPv2jD5kjhDFf3MjDK/13K2AbVIwzY35btjWNZfkEu5DNyEyvuo2IWkHzUabjjobO76J+b9AY9xdD9Xu+PpfBvO0w5DYSjIYn8KRaH69m0K14B8a8yl+RZ1UM9PmOWLxpFLijS88g+9Osgb59OYOhbPNVXcJ7tPw6xR/YX9K4yh9cGDWJ9Tbc9PQ8ONIdwM1pLbucknJ/mpIzr/sKn2fVcHdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NvaO1Gf3fjP+sj6QpMn7AJa5hldQPwteKxYTA1dD8gs=;
 b=KJ0zxmVdSyr0Sol5TIBBJKc3P8mYnvVcZJnBVTN3JPlsSZYq+FAZ3aPDbelBX+XLhmb8k4OkvDbghMCvDOwqtwhA4R8y+VreHhgT6UeUYCOWbOQtDzBDdLX7p5q2kQEM8GLfs93dXmNB3QfIpTuiHJ/+8KMaxwqRC8qM9a+kzrFXZgdaGmSIWrNWnrcXPP8Cr7bOQgbcz9/hkOWWePGCXoyZ149LlrBwIRwT9pa1lYc39dMZE3jol1SqHhdcmJAoqLNuxYuonOLUnuz/Cs3EucIQ2Z4OhLLSkqIEC7CWwK7NwTvpDJDPUj9kadeIcyuHLnU4F1mj8edOUmg9B9dAVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvaO1Gf3fjP+sj6QpMn7AJa5hldQPwteKxYTA1dD8gs=;
 b=ghD/ytMbYDgNGvtX4Gxh8gkkG5cfIwF9qz91+yQFg+YivayYftCiJ9c+B0ODV7iT+iujzOrDkqfUDKWiMLfn4L21eBgdniU/rJ2eZvi+1DcNuHeWZD39jzA1cNmNeev21g9ujtkQ/C+HoiLnxxYUmyiIX8zDWt3kPtN+pUqR3rc=
Received: from BLAPR03CA0178.namprd03.prod.outlook.com (2603:10b6:208:32f::32)
 by LV8PR12MB9333.namprd12.prod.outlook.com (2603:10b6:408:1fa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.22; Sat, 30 Dec
 2023 17:26:47 +0000
Received: from MN1PEPF0000ECD6.namprd02.prod.outlook.com
 (2603:10b6:208:32f:cafe::24) by BLAPR03CA0178.outlook.office365.com
 (2603:10b6:208:32f::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.20 via Frontend
 Transport; Sat, 30 Dec 2023 17:26:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000ECD6.mail.protection.outlook.com (10.167.242.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 17:26:47 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 11:26:46 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>
Subject: [PATCH v11 15/35] KVM: SEV: Add KVM_SNP_INIT command
Date: Sat, 30 Dec 2023 11:23:31 -0600
Message-ID: <20231230172351.574091-16-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231230172351.574091-1-michael.roth@amd.com>
References: <20231230172351.574091-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD6:EE_|LV8PR12MB9333:EE_
X-MS-Office365-Filtering-Correlation-Id: 87b25a2e-5618-45eb-651e-08dc095c8036
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CSkg04oOoKxMzMw+bohGzZ6b2sG8YMXN2ClWKGht6gTc6Q77ID0JfYU6LAcuKpBcdYvySOeXZc5nyK5ctFWH/EZj8t3n6H1t2wFYrtZ/svhg+OW3vuNUl37+iD6s8riRz8p6TS1FuJrLVzqYEO5J9ga/GY1uwnahmaJQMkhDGfg19YvFObDlc+DGOY0krFNaz+pzAKqie3d9TPv7x2BVMquzvRQtQhPjmBuy0tjASS5w+lMltACghoKFY6hieYHFBjVhxWPti7sgRVi7Ftcu2rIfxU1WWmbvcU+U4Tqpyz//6jRvX3EdJ3T/HHn0w+bPYn3LkGWNLq0iFvlXaOv5FI3KY//LwPx/4NRixp/WlLMSf+bYbAXe0GqwD25eLn1rIaFshi6d1Za36si7+mBMmIXclAwDdfmsUVqOH5RAQ4vS3i135nMwImjktlFcmpff56BKlSOojCNFmBd0K7pQKQwC45IVFZ5zrkZSYZUv6Np2DQHJ9QRKbBqvD0okgUAL35/Xzh8PSXQBqFdWLWtcCIoYIN2KDS4cvMG2bLZMomytJlvEOKFC43Gsc4lscT8rkwVEDwsYNtuHsWnj96EJpjov7KwLbGUQMtlfViAmgJMBw6V+cVHX6b1M3THrp/5ajEDte1mEX8z/DMgM3UBvBqR+dt0OWfMUCAtdQwCHdQ8R3SBAFEauW8iDYeY2Twf2IIqBE7rf1ZtTKsh3IzFxV2oVg2/yT0utcfDEFkGDzT0GLkrDKyjpKEKz5o++SXOp65C/vRHgYO424NH4JuMCiw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(39860400002)(396003)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(82310400011)(186009)(40470700004)(36840700001)(46966006)(40480700001)(40460700003)(336012)(426003)(16526019)(2616005)(26005)(83380400001)(1076003)(86362001)(81166007)(36756003)(82740400003)(356005)(47076005)(4326008)(44832011)(5660300002)(7416002)(7406005)(6666004)(36860700001)(54906003)(8936002)(8676002)(70586007)(70206006)(316002)(6916009)(2906002)(41300700001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 17:26:47.1988
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b25a2e-5618-45eb-651e-08dc095c8036
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9333

From: Brijesh Singh <brijesh.singh@amd.com>

The KVM_SNP_INIT command is used by the hypervisor to initialize the
SEV-SNP platform context. In a typical workflow, this command should be
the first command issued. When creating SEV-SNP guest, the VMM must use
this command instead of the KVM_SEV_INIT or KVM_SEV_ES_INIT.

The flags value must be zero, it will be extended in future SNP support
to communicate the optional features (such as restricted INT injection
etc).

Co-developed-by: Pavan Kumar Paluri <papaluri@amd.com>
Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    | 27 +++++++++++++
 arch/x86/include/asm/svm.h                    |  1 +
 arch/x86/kvm/svm/sev.c                        | 39 ++++++++++++++++++-
 arch/x86/kvm/svm/svm.h                        |  4 ++
 include/uapi/linux/kvm.h                      | 13 +++++++
 5 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 995780088eb2..b1a19c9a577a 100644
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
index 87a7b917d30e..ba8ce15b27d7 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -286,6 +286,7 @@ static_assert((X2AVIC_MAX_PHYSICAL_ID & AVIC_PHYSICAL_MAX_INDEX_MASK) == X2AVIC_
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 
 #define SVM_SEV_FEAT_DEBUG_SWAP                        BIT(5)
+#define SVM_SEV_FEAT_SNP_ACTIVE                        BIT(0)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 18c09863377b..43b8ae7b74f8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -250,6 +250,25 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
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
@@ -264,12 +283,19 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return ret;
 
 	sev->active = true;
-	sev->es_active = argp->id == KVM_SEV_ES_INIT;
+	sev->es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
+	sev->snp_active = argp->id == KVM_SEV_SNP_INIT;
 	asid = sev_asid_new(sev);
 	if (asid < 0)
 		goto e_no_asid;
 	sev->asid = asid;
 
+	if (sev->snp_active) {
+		ret = verify_snp_init_flags(kvm, argp);
+		if (ret)
+			goto e_free;
+	}
+
 	init_args.probe = false;
 	ret = sev_platform_init(&init_args);
 	if (ret)
@@ -287,6 +313,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	sev_asid_free(sev);
 	sev->asid = 0;
 e_no_asid:
+	sev->snp_active = false;
 	sev->es_active = false;
 	sev->active = false;
 	return ret;
@@ -625,6 +652,10 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	if (sev_es_debug_swap_enabled)
 		save->sev_features |= SVM_SEV_FEAT_DEBUG_SWAP;
 
+	/* Enable the SEV-SNP feature */
+	if (sev_snp_guest(svm->vcpu.kvm))
+		save->sev_features |= SVM_SEV_FEAT_SNP_ACTIVE;
+
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
 
@@ -1883,6 +1914,12 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
index a3e27c82866b..07a9eb5b6ce5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -76,6 +76,9 @@ enum {
 /* TPR and CR2 are always written before VMRUN */
 #define VMCB_ALWAYS_DIRTY_MASK	((1U << VMCB_INTR) | (1U << VMCB_CR2))
 
+/* Supported init feature flags */
+#define SEV_SNP_SUPPORTED_FLAGS		0x0
+
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
@@ -91,6 +94,7 @@ struct kvm_sev_info {
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
+	u64 snp_init_flags;
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c3308536482b..73702e9b9d76 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1869,6 +1869,9 @@ enum sev_cmd_id {
 	/* Guest Migration Extension */
 	KVM_SEV_SEND_CANCEL,
 
+	/* SNP specific commands */
+	KVM_SEV_SNP_INIT,
+
 	KVM_SEV_NR_MAX,
 };
 
@@ -1965,6 +1968,16 @@ struct kvm_sev_receive_update_data {
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


