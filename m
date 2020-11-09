Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359672AC859
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731589AbgKIW0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:26:44 -0500
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:61435
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731496AbgKIW0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:26:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GceK3slXrExh0gTBmEdFD8B/rfqU7kWM7gePNAGmMfGKpj40zuOSNP+ZD7Dzwu5bvnXjS2RoF1rhSjbQxU8DIOkpNOAWciWLAcOieDmaPY4sm3IIpsm+KE/hrPjHikR6u/cfvpP9V2Nk4LJ0gyfqcqLuQ8wrWAz6lPjC37Ni2w3ZzHNjIBsTdUZio3rl04eYePtmehfKuxkdv5uK+h2cemKag0BFlAtf7/Jz15UZvI2XAuFQyIjj+eaqy0MuVdDQqHuQj9UWi/eQtOud3/MgzHy7A9tejL/ZO8y6J2FHy0XjNGMax/eTqgsaKBdkylQk/KAy8gG+GibcbhZgKo36Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8/XXGp8GPG0NCypmst5UHYMdJrRQzuAfnGIvQLwv6c=;
 b=AOFDW1itB8L13qqT/QKW9YRcIUd3bB4pTBlYaaVPtpGAlBwi1en5JiSE83mH0NQA6EWi1OVj0DEnK3toYyILCKOTBtL1hmdI0ERjhuRASsJTaA9XdERMu6WSKXDPz3jHJbCcniRYFuJpnWaa3ZlxVm+m04z5h+P+HtWKtFsvy1UF/Ff45OtbmlA2N9EqUgyNb/uShi6Ytl5XGmB9NGLrn74s1mE/T9nv4dxgWW0LIKHZEkFQmfs4wstI7KnyG9NFMUMJJu4/jVF05hLpIAXLFlZTkye0xFULnnc9Z7/vYKlmTvdsInSh3g8419kTyV6xInFB+npsyfeaNi3RRg4M3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8/XXGp8GPG0NCypmst5UHYMdJrRQzuAfnGIvQLwv6c=;
 b=hnQRpAkNvL2/VI11CDboI3IB22yZtPVGmYSeAnUiMH/gzEYR5AakZHQEVeRZRjIzNU9YOhHGJ19ks8YkGN4BkPQMZSigQ4MB/LiLIubOaisBahCsDrq7EMUpfn7u7Er+O4qijcmkk+F4UhOPPCXZyJjSF8lsA69+aeuUZXKW7sk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:26:40 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:26:40 +0000
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
Subject: [PATCH v3 03/34] KVM: SVM: Add support for SEV-ES capability in KVM
Date:   Mon,  9 Nov 2020 16:25:29 -0600
Message-Id: <592dbc6c94ed377f21e53983f61860dd21838ed1.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0009.prod.exchangelabs.com (2603:10b6:804:2::19)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN2PR01CA0009.prod.exchangelabs.com (2603:10b6:804:2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:26:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f9f626df-edcc-4a83-d7b6-08d884fe873c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4058AA603E39956715FE37C9ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WVsmycoAo7iHCcX1mm5WDrYdoKbs8UYjx/7ywUPiLINuNTwK17g9mnLk/2Cc/AdtBBtlCXRJudW5BJJ574EqXv/aAyxyu5UN0+iyqtnIVQYfj3Coy/bxRtOGSqywnEeWvxQr1tgta2rbsAYyqzNKNN2DGGon9bpxlTh/1gnW3EX90mSrVZQnYzvHbGLV9R6yXkghyCjSlT/hVMlMTytGzZ4jCfgpoBSDNClOBnPihbmfTnEcZpRV8xmrgmy9TyJUE4cz4RUzKFdxjubeNSNaN02cE2wn3UAPUBsYt1cnemLOqlAurz3L7rRhb1Qbic1sVXVAnYQ0UDLNgfWHlP1sJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(6666004)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rxRESEiVDrIn8XzqGVLJMjtd8uiJ5+ipbDZ0vFFufhKS+QmHgYCvZmh/G9KVmo6pem38ohUoIuCVH/yavlPgnSRTv/TpaAx6vBQ0CotN+X6mjYlhehWLPQ2gmguAXX6tEx3V+PwFTTIEK57g4bdPeKksXLTu9U0awR47JDUWlZzRs/xwvQwjZWamG3teFPMpATN0rBQV7KtAtsnLmLe/ePOWLHUUUWpZny26yqge9Wla2XCf4mIPkM4KFv7p6MKVHQpQa5V+dXCTRRXJWviTUiDMAVLrL+R7oCgIqu/8opVqdBfW/Mf5AxZ7k9eZ25xWXN4FI68JBHH3danPMtduaiZwH8T3VmxZDVULdkytVbxra8lwRsx3IUJLAt3mgWp7B3OUxbG/MC7IzI+56YKT8s/Jz2QzRIa2gNp7cZGxx+xDuWeFH2jwtF/zTFR/pgySwkcar15liJISPb2TzHcT6rDefdnqw/Huv1WngV/v5CqkX2iOqedCIDdxZ+BzKf7jZ+FDb+u0A1t3v738/AJs7d6OWpSeBKOzcTTJ2nbztitUtaJYIYLrAYLXJEVrUrYwWDz5AFVxj/XoxoMPEMq5bxkKxOj3wwIB/mTj8hy015IPHhDBpC0y7/7CYsH2ArCgNb8sKvKUji65tQ8E5SyBkg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9f626df-edcc-4a83-d7b6-08d884fe873c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:26:40.0875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s6n/OkxmIfWsXThumq6qxo7kLM9oLEeurUPieN4Zo1fM8gttYf3pIT0rWtZisHAoSCfraMMC6yOzTqkG4xZDcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
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
index f92dfd8ef10d..7ac592664c52 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -100,7 +100,8 @@ config KVM_AMD_SEV
 	depends on KVM_AMD && X86_64
 	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
 	help
-	Provides support for launching Encrypted VMs on AMD processors.
+	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
+	  with Encrypted State (SEV-ES) on AMD processors.
 
 config KVM_MMU_AUDIT
 	bool "Audit KVM MMU"
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a4ba5476bf42..9bf5e9dadff5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -932,7 +932,7 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	struct kvm_sev_cmd sev_cmd;
 	int r;
 
-	if (!svm_sev_enabled())
+	if (!svm_sev_enabled() || !sev)
 		return -ENOTTY;
 
 	if (!argp)
@@ -1125,29 +1125,58 @@ void sev_vm_destroy(struct kvm *kvm)
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
index 2f32fd09e259..a3198b65f431 100644
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
 
@@ -959,15 +963,11 @@ static __init int svm_hardware_setup(void)
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
index 1d853fe4c778..af9e5910817c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -61,6 +61,7 @@ enum {
 
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
+	bool es_active;		/* SEV-ES enabled guest */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
@@ -351,6 +352,9 @@ static inline bool gif_set(struct vcpu_svm *svm)
 #define MSR_CR3_LONG_MBZ_MASK			0xfff0000000000000U
 #define MSR_INVALID				0xffffffffU
 
+extern int sev;
+extern int sev_es;
+
 u32 svm_msrpm_offset(u32 msr);
 u32 *svm_vcpu_alloc_msrpm(void);
 void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm);
@@ -483,6 +487,17 @@ static inline bool sev_guest(struct kvm *kvm)
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
@@ -495,7 +510,7 @@ int svm_register_enc_region(struct kvm *kvm,
 int svm_unregister_enc_region(struct kvm *kvm,
 			      struct kvm_enc_region *range);
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
-int __init sev_hardware_setup(void);
+void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
 
 #endif
-- 
2.28.0

