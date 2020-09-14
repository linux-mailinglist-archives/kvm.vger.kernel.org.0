Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E7526962B
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgINUQe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:16:34 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:36897
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbgINUQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:16:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRLVxRU/fJ+ytH/QY5kkd3k5x0GdxHofngmbM8qNnKOoylLtnRwE2Au+h6AELtJhjWcGWcG6WQdTyfl0g03VR4hVG5kNiC4go+W2NqZhTdIcx4GeR+1gbSfKN7G+6vNfCAhdC2WrakxNsXEh65UEt7cGk58yVKqJHEtL1wvhZmpPZ0dsIgYjBVtB+xlOkeCjF9WbL0VPoB9C0amARAfy3F+SxLwr+SPLrQe7wd1+j+4VYbkMILQ1jJsyPNjz4pCO0pNrqT2OpZ62zJNVp8xJC1LtHsFkS+d6M1fb6FYLEO7Rvr8fn9L45ld/1LsfNVBM6gwMUOiaMi7yqWD+OMtTfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gmq+mpXqk0HGSWqUpipOJTbuNJZJEm7PwIIOMoMXHoE=;
 b=l1O84dKBYj1u0XGGFBfXCQCp1yN3OzpPrzwnOwBnbOB5b9XePcEbZk3c7kxI8TpgqykY519r8Ancxix25GU7oxIK1zUm2+UsIyHNKKUPOAwUoDcpLTW1PcVIPRif/bZWrYSRF5z9GCjw2rpzP5idOiCAzRqjICNWDvu1XEaumSrAJrS80hqeGJGXgtP4iO43EvHIQkqLfNYnB7p5sVXw11CVG/BCJYX/F7YyIQp3iojc7KQQT6Jw0wxGIZEOYaGzUzpgq/twFIZV89/Aw7PbsDKDy5YxlToD4VH5SuRHQHzxfSVLZXt4DGelyNn81Cn7mox4QfJchlL6XCYIw/SWwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gmq+mpXqk0HGSWqUpipOJTbuNJZJEm7PwIIOMoMXHoE=;
 b=jkH6cBGeVWH35eIcf4klcxvdX16qPxQd71D9onIsXJ0wKVT5fIyG/sNyZv1zBJySMs6ddagiqbs4groAg3HwMWecYylHCWjaM+eEZdpC6BE2tgf/rCtwl8D+ATKIIxBQeCK/fKJ8byOtkjI2r1xWw1JaWZyi2Q0kqvPZHvobqbo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:16:15 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:16:15 +0000
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
Subject: [RFC PATCH 02/35] KVM: SVM: Add support for SEV-ES capability in KVM
Date:   Mon, 14 Sep 2020 15:15:16 -0500
Message-Id: <9a8eab4f685abe3544bb73128ab068b18bc6c454.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR20CA0032.namprd20.prod.outlook.com
 (2603:10b6:3:13d::18) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR20CA0032.namprd20.prod.outlook.com (2603:10b6:3:13d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:16:14 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 05c7b9ec-8597-4c19-af7b-08d858eb0858
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB116312192AE601A1FFAA4FBBEC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZwAIDjcmyc4SDCwTSPQMd17GdgshSpFITsIKps9e1feD7w4sLw2Ld9KoJTECQW/mwT/KV6vJmBVcdrjkL4qmQUxerMeqNdwtpF8HmT8dwNEldsQ1n9PZqqvPlKNcPKTGVzFA8JtMwa9HHT0jjI193n4RsTqg64SWDFJSIitDrI0t7LEoz7roEJaUB4gSD7wnRXKAgaOYexPP71EhOtokLwk1fOCZK00mPR6VC2PUxneoEf64pV0THyzNa9qX4KGTQF12Tz89vhWTBlnpAtCHUQQnhKP2T2DDLA3Otx/qfTrtzVoCrtdSSQ+2FUEHatBiW1eSm0WXqEtbanxnraJc6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uYtebeG7ab7xQfpzj5oR4HQWl9qEhD0m1/nwf21p86rQYFtoa0BTgrbTJGOGP1p/+PEcnWZ49d9oEiP5vyJATHa1xaflNIeTtNI06JyGG6ykCvcHYnZGtEvdaF6U0uhsUoLbQBqq+zZGfaXnvqJzyEW1lD6nvKVqVaV7B/O//Ld0i+ZFk8VyfHWLP6EEdcnm6S9tYhnL7qSFTj6w0FGAMxwjvrgXN3en3tfR1EPcidGIq224X9ouAFEW55SdU2pY0yPMUnbdJ8eUtcJO3FtOp7H7DddHFZRmiMV30cw9NdH63swambCzOhpJMReGhI6XX/g0ZZ6HoMjTiqXUR7S+PwzpzfVRFGeVp6+NzswECs+Dlx8m5xrizVjFAhY4MHG+gBBUgYaCVjH6ZQIifUngs1Mva+lPBbeP9ByOB6O/CQWAA0dNDvRqoPWE9KQ4bedSscD4+w8LKmdMPJJPAnlj7BQ9KpnZ6RcDcLVFHll3cwSQpqOW735OGCEB2yICW8cBtP/YBy/2b3SNyJOv4m5SDeGAe8dguoSeV/lTLT9I5nchcp2sUldHkpMvWXLddpBo4y0itdZnHESxRkjuRSOVgS0NjaBvwL1nsDpNYMv+zRI+rjRjdjRnpjILz0zLvHo12eHn5wBg+jg8aGpRmmBRPw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05c7b9ec-8597-4c19-af7b-08d858eb0858
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:16:15.5323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OrjthO15fMEKZ/e26XiHyID3oZ8+flNMqp4yvGydEE01Hk0rz8kkxW+EX33ycxhuKMyWX+Z1tKacxl6V87Dihg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
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
index fab382e2dad2..48379e21ed43 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -923,7 +923,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	struct kvm_sev_cmd sev_cmd;
 	int r;
 
-	if (!svm_sev_enabled())
+	if (!svm_sev_enabled() || !sev)
 		return -ENOTTY;
 
 	if (!argp)
@@ -1115,29 +1115,58 @@ void sev_vm_destroy(struct kvm *kvm)
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
index 4368b66615c1..83292fc44b4e 100644
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
 
@@ -860,15 +864,11 @@ static __init int svm_hardware_setup(void)
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
index a798e1731709..2692ddf30c8d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -60,6 +60,7 @@ enum {
 
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
+	bool es_active;		/* SEV-ES enabled guest */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
@@ -348,6 +349,9 @@ static inline bool gif_set(struct vcpu_svm *svm)
 #define MSR_CR3_LONG_RESERVED_MASK		0xfff0000000000fe7U
 #define MSR_INVALID				0xffffffffU
 
+extern int sev;
+extern int sev_es;
+
 u32 svm_msrpm_offset(u32 msr);
 void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
@@ -474,6 +478,17 @@ static inline bool sev_guest(struct kvm *kvm)
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
@@ -486,7 +501,7 @@ int svm_register_enc_region(struct kvm *kvm,
 int svm_unregister_enc_region(struct kvm *kvm,
 			      struct kvm_enc_region *range);
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
-int __init sev_hardware_setup(void);
+void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
 
 #endif
-- 
2.28.0

