Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA255281887
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 19:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388262AbgJBRDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 13:03:34 -0400
Received: from mail-bn8nam08on2081.outbound.protection.outlook.com ([40.107.100.81]:26976
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388054AbgJBRDe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Oct 2020 13:03:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brOYRDAOClH7eRS2bSKOCNLcnfvxhd1mdFQqmXJy7MFEliyjQEHnYCC3YsTsZn2y0Pl56OZzLoNJxlXaJEEbI+0x+Ty4OZ1Zr/t/Md9pxbH8VZeoxf47MP21V5pAm62peZ2dtjNiAUFfxQoexiNdreqo8X94iFn5PHps9IBahgVsEyT/KNMkEU6AX38Qw785fuFEiqPdQyCfn7tkfqG+abi4ocOPJZJW9RAS20F+iSt3TEGNoR63/43OPI0uXm8MKZRBqUtw3jc3pURmRAwUx/wev5ZphLcvRGEWuQgTb6aowEy5hszC0Zw69F2Y2hlNCiOQmDLSx90/WQUFTsi6nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3qAFroPMLhaR9xNVn1rOa+8Modw/ztx+XX7DtJzdDzc=;
 b=nKCsRgi0km0n/GhjnzERPNHTzf1y4lR5fBm4UQwsNSGwWB+238T7z8Olx9wwv3Xl+gKKSdV5XUZ1oT8YUtkJ3q7NnInNl+cGsc4dvAq6NH+l6fSL+xhajBFfsbhcUJkAfBzKOH2zqscGM4viIZxdk1FmgAObiSscrE/357tqRwmctQjNJZI6yEKSXKh58eAZspzA82NYD+Yrljq7iGDXvhH+Ka8Xw5sDW3tPMP3UkPPZrGDatf/50okR434LMCDXowMQm8r/yDMPDIRw8gV814gECs8keMam7VeyzlKGlcObz2BxpyCRC1QdS8gHcsUhWW5ieVlr4hanLse7vMkB2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3qAFroPMLhaR9xNVn1rOa+8Modw/ztx+XX7DtJzdDzc=;
 b=ZfXleyRAhQ1RYf+UWdiqtoPv9GiDfHWKdT6mXjDLTL20INqEV2Rf5Cho08qfoZx+EX456ZrMXWCOFbTPTDWuh081zNeNMiKzbmNVRCU33quQQbkycX0aD+GregWDJpwfwLsvM+zYONwEcOngISHiTJg+J2BCHV8k59sfheTW8fw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1706.namprd12.prod.outlook.com (2603:10b6:3:10f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.38; Fri, 2 Oct 2020 17:03:31 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4d88:9239:2419:7348%2]) with mapi id 15.20.3433.039; Fri, 2 Oct 2020
 17:03:31 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v2 02/33] KVM: SVM: Add support for SEV-ES capability in KVM
Date:   Fri,  2 Oct 2020 12:02:26 -0500
Message-Id: <53dcd5303deb0b0e415a3802f0e92cad7bece809.1601658176.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601658176.git.thomas.lendacky@amd.com>
References: <cover.1601658176.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0002.namprd04.prod.outlook.com
 (2603:10b6:803:21::12) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0401CA0002.namprd04.prod.outlook.com (2603:10b6:803:21::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Fri, 2 Oct 2020 17:03:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f79767fe-2b81-41c1-f8c9-08d866f516cc
X-MS-TrafficTypeDiagnostic: DM5PR12MB1706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB170677601DD2A998E50A0B38EC310@DM5PR12MB1706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UICxWIPrSYZGyo1h5c1pomaslQrn7bHleQnG+ioqsECQ3uw5OmQEpK+HbeNMxkDNUqyHbeEK50tT0twmnPo96SJfKW0J6fA6HnMRp6QkpYfKYrmIH8QPuuGySs+IQCyFaz/JG1M3zRFgfvrbBb7fBirx5f+a6jesUv+GlnrJBs7hseQx652v1IX+WlwhFc3sJHNtrmYd7L3v/Z6lknWR790knRdRimdC037wcUZQV7MVb6H9z1JwR4o3mG8pgY2bNI3+s5t++PMYZnlX70OFvST++YYRQ+fOCk7d44KKvjIS7/FgD/610KK1hZpPTZFZG47IzrVNgh1PaAxzKjsaKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(66556008)(4326008)(36756003)(66946007)(86362001)(2616005)(26005)(8676002)(5660300002)(83380400001)(6666004)(7696005)(8936002)(52116002)(2906002)(6486002)(478600001)(316002)(54906003)(66476007)(186003)(956004)(7416002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: W0fswwfmbCpUE2kzn3X/3oWqRTuIfB0S/Hxbn98LkXEhYFBBo49xVyOcFgQGMKztHf2sYMqoi5A3rhvb4GwTH9/E7H8hjcia57D+jo5i7qcvLF+STQZ7NJerKyx01YnDZbeYCL6R8ww3ZrEvEUoKXzFDzQNZRmLiymuvClZREDdq/iFQ327o8xFhJOnAabN2fqI9zF+8Ly1MQj7oc7jqVDM3KERIHRYkInHgVichPDkRHRzQT1LSehC3AWqsyBWZwiPtCnXItKFgtkkKXoSYcHuV91Wjc3pII51xsuyUFVyTuREAzb4etBZDGQzdtKU+Jz94xd/EWlwgeyk2qNE/obMPPQG75gbxPY1XzFc5JvycJTU0GTfqTZqv4gJg1A4XF6lXNqXjFPiWMbG9gvd1s0D+SkK+Zm1u3kXQdcDAzMLWqzCD94L8ianOc0Qf+MNCCoh37iWlnyxLfeht/Q1kcc0YW9mpe2FVWr9FYKDWYYxO5ROA735XXRUCsBa2KGv2sqwfFBqQ6c5xqAVbuBpz6hs+AAAH4j/ZYWaTwY1gFskdaTRK/Sj1BPfEYGZXjDum0o6Y12jC15Q9871Bjo7TqbDYlEDGMqHAgo9Ea4EQuq+GmRKv9k4lJlixIFDaaZALyOWXOCCub3FTxEcBEKVPYg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f79767fe-2b81-41c1-f8c9-08d866f516cc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 17:03:31.0326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x2di/f4hhfAb3vET+HQxRxcMWMx0sKsrUy+QT3lzyCB56ilQDCkLoNa0j20/LVjwzTVK7D5W3FOY75iEE7O4ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1706
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add support to KVM for determining if a system is capable of supporting
SEV-ES as well as determining if a guest is an SEV-ES guest.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/Kconfig   |  3 ++-
 arch/x86/kvm/svm/sev.c | 47 ++++++++++++++++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.c | 20 +++++++++---------
 arch/x86/kvm/svm/svm.h | 17 ++++++++++++++-
 4 files changed, 66 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index fbd5bd7a945a..4e8924aab05e 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -99,7 +99,8 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	help
-	Provides support for launching Encrypted VMs on AMD processors.
+	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
+	  with Encrypted State (SEV-ES) on AMD processors.
 
 config KVM_MMU_AUDIT
 	bool "Audit KVM MMU"
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2febbf916af2..9af8369450b2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -931,7 +931,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	struct kvm_sev_cmd sev_cmd;
 	int r;
 
-	if (!svm_sev_enabled())
+	if (!svm_sev_enabled() || !sev)
 		return -ENOTTY;
 
 	if (!argp)
@@ -1124,29 +1124,58 @@ void sev_vm_destroy(struct kvm *kvm)
 	sev_asid_free(sev->asid);
 }
 
-int __init sev_hardware_setup(void)
+void __init sev_hardware_setup(void)
 {
+	unsigned int eax, ebx, ecx, edx;
+	bool sev_es_supported = false;
+	bool sev_supported = false;
+
+	/* Does the CPU support SEV? */
+	if (!boot_cpu_has(X86_FEATURE_SEV))
+		goto out;
+
+	/* Retrieve SEV CPUID information */
+	cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
+
 	/* Maximum number of encrypted guests supported simultaneously */
-	max_sev_asid = cpuid_ecx(0x8000001F);
+	max_sev_asid = ecx;
 
 	if (!svm_sev_enabled())
-		return 1;
+		goto out;
 
 	/* Minimum ASID value that should be used for SEV guest */
-	min_sev_asid = cpuid_edx(0x8000001F);
+	min_sev_asid = edx;
 
 	/* Initialize SEV ASID bitmaps */
 	sev_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
 	if (!sev_asid_bitmap)
-		return 1;
+		goto out;
 
 	sev_reclaim_asid_bitmap = bitmap_zalloc(max_sev_asid, GFP_KERNEL);
 	if (!sev_reclaim_asid_bitmap)
-		return 1;
+		goto out;
 
-	pr_info("SEV supported\n");
+	pr_info("SEV supported: %u ASIDs\n", max_sev_asid - min_sev_asid + 1);
+	sev_supported = true;
 
-	return 0;
+	/* SEV-ES support requested? */
+	if (!sev_es)
+		goto out;
+
+	/* Does the CPU support SEV-ES? */
+	if (!boot_cpu_has(X86_FEATURE_SEV_ES))
+		goto out;
+
+	/* Has the system been allocated ASIDs for SEV-ES? */
+	if (min_sev_asid == 1)
+		goto out;
+
+	pr_info("SEV-ES supported: %u ASIDs\n", min_sev_asid - 1);
+	sev_es_supported = true;
+
+out:
+	sev = sev_supported;
+	sev_es = sev_es_supported;
 }
 
 void sev_hardware_teardown(void)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4f401fc6a05d..6c47e1655db3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -187,9 +187,13 @@ static int vgif = true;
 module_param(vgif, int, 0444);
 
 /* enable/disable SEV support */
-static int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
+int sev = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
 module_param(sev, int, 0444);
 
+/* enable/disable SEV-ES support */
+int sev_es = IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT);
+module_param(sev_es, int, 0444);
+
 static bool __read_mostly dump_invalid_vmcb = 0;
 module_param(dump_invalid_vmcb, bool, 0644);
 
@@ -938,15 +942,11 @@ static __init int svm_hardware_setup(void)
 		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
 	}
 
-	if (sev) {
-		if (boot_cpu_has(X86_FEATURE_SEV) &&
-		    IS_ENABLED(CONFIG_KVM_AMD_SEV)) {
-			r = sev_hardware_setup();
-			if (r)
-				sev = false;
-		} else {
-			sev = false;
-		}
+	if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev) {
+		sev_hardware_setup();
+	} else {
+		sev = false;
+		sev_es = false;
 	}
 
 	svm_adjust_mmio_mask();
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a7f997459b87..84a8e48e698a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -61,6 +61,7 @@ enum {
 
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
+	bool es_active;		/* SEV-ES enabled guest */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
@@ -349,6 +350,9 @@ static inline bool gif_set(struct vcpu_svm *svm)
 #define MSR_CR3_LONG_MBZ_MASK			0xfff0000000000000U
 #define MSR_INVALID				0xffffffffU
 
+extern int sev;
+extern int sev_es;
+
 u32 svm_msrpm_offset(u32 msr);
 void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
@@ -475,6 +479,17 @@ static inline bool sev_guest(struct kvm *kvm)
 #endif
 }
 
+static inline bool sev_es_guest(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_AMD_SEV
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	return sev_guest(kvm) && sev->es_active;
+#else
+	return false;
+#endif
+}
+
 static inline bool svm_sev_enabled(void)
 {
 	return IS_ENABLED(CONFIG_KVM_AMD_SEV) ? max_sev_asid : 0;
@@ -487,7 +502,7 @@ int svm_register_enc_region(struct kvm *kvm,
 int svm_unregister_enc_region(struct kvm *kvm,
 			      struct kvm_enc_region *range);
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
-int __init sev_hardware_setup(void);
+void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
 
 #endif
-- 
2.28.0

