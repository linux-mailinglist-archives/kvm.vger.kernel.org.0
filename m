Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879912D6324
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403820AbgLJRK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:10:56 -0500
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:38097
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392495AbgLJRJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:09:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxrPyJ4mSADB7T5L4nsbrQoO2VaYo94vXnN6ksiTp30kQoU327i4jqMqLX2GLnduBsnMvKsbX0x4DBbkKxVTMcVtAKyQvrs8vyYOZ3+wQZDdAGyShARSUk9MTkc/3A++NiHG1iUbYvj4RNbLDqF3aAsuJaCHtVAJClbLOqHQVE5QE+6kAB0x4Qzhj4GaxyomnT1pgCWyBSI0BVZVUBot+2KaWbcjwRmfSp9RpD7Gx95ZaLYZxQi2EDg2jD5K3HJ3Penpuiby3/bflAZq/nqVhuZkCxPnKZ6O3cm7vLbqeS+ie7hQ/HaBYIxvMlhvEAueS994H2LAjaUOD1GZTLv6YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEu7KmoSe2wsLRyaIXnIQhWobneKjtSr6mvX8Tyf+V4=;
 b=WMff2aedm/fcCJoJx6E5Xq//EfXDB2woE5ozqe1eKz6bJICBCj9uG+Z3ScXHtEMhz3AihEScP+CEInX4eG6cXCLkn1BR/202GavZXfDx13/8ZRF0cdhWu5IaFW0GgLwB+cc4VzmZp3NP32st4fGJ3kqi3/R3P3is1jm/WNMIMEoQRNgodQgsDqJ4y0fYhAN3leV/FTSpelV3R000f4h1lMnPzqUwtZAxDnMsMOQTbTpO8B+sahwOYfmx2h0gtYDopuzqV7Jjyk6pD/pXuaWHYu3F1tigRavlV66xSxswI2ilqU43ZRjMAOG8dxBH6LhG9q3ZsQ3rWgoc4XlAoaR0/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEu7KmoSe2wsLRyaIXnIQhWobneKjtSr6mvX8Tyf+V4=;
 b=tMUeSe0emQ8eLT81ZTNr5JlvJtGjs0FwdZTJFXRXvEF3JsS+JLj7hVDU2HfH9NTIniRouuMtbbzcaCQUSgdBHLzN0UvXN5tO1eNUJoMvDQ+dj+8CADeUzi5ufU09YTK1os6hq/lTSJwWEc77ijTcnH5A6ZB875IcFtCxSc2BIOo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1493.namprd12.prod.outlook.com (2603:10b6:910:11::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:08:01 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:08:00 +0000
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
Subject: [PATCH v5 03/34] KVM: SVM: Add support for SEV-ES capability in KVM
Date:   Thu, 10 Dec 2020 11:06:47 -0600
Message-Id: <e66792323982c822350e40c7a1cf67ea2978a70b.1607620037.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620037.git.thomas.lendacky@amd.com>
References: <cover.1607620037.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:610:59::35) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR03CA0025.namprd03.prod.outlook.com (2603:10b6:610:59::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:07:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8c20e564-74cb-4811-2836-08d89d2e264f
X-MS-TrafficTypeDiagnostic: CY4PR12MB1493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1493D504BA553F8EC57C04A0ECCB0@CY4PR12MB1493.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k/l7DFBSB4o13E1r35LCt60j3YO6MeBrHYhi/LxWCesV12Ly2tGXoR5BcLtnxbXhgA8OJBK3OBLOCS14l1+Z5C755JsO8Z6iFXD5Tp5QHgEOTdDJvn5hLBe4DnbDCaJgEa4ZIQCDLbsk/xGSFmqirhGfalArG9nwf9Ah0iS89VaOLlU4STIJIJsfv9liggON96qobCl4PRmTI5sbh3yiuPYBQvIBBvG7PImmeEGfaSiA8Z39bsBiiWbhocc5fTLgXm6gkPAVGW88rpKvqHd4EiUIAeTzXrSPngFrNID+g4eIpswcilVqQHJv2SyQx2vH5jkHIUcN8DX4H+khDtU4g9c9e/CyBbxC/S4KCmjVFHDiVgTg+UzaD4nVgK/1tEz7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(5660300002)(66476007)(186003)(52116002)(8676002)(36756003)(8936002)(4326008)(86362001)(2906002)(66946007)(6666004)(66556008)(26005)(508600001)(34490700003)(7416002)(2616005)(16526019)(54906003)(7696005)(83380400001)(956004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rvilIUvV6rUUCuN2pDbT4U/TqvVDmVJEtRxm31VnJwM4+dRJ9oladYiKc24u?=
 =?us-ascii?Q?CSdmo8z/1Npmb8Ysa6ajDxvGtp2DRH2gXgm1FjywngyCh90+eyLX8PFRNiLf?=
 =?us-ascii?Q?546qs7DtK7KQEZ8FuVdrKDCOkwyiR0YvqOmf55ijbUloozQXXP1iJY5YmySk?=
 =?us-ascii?Q?baGj0HaUO1hQ/hLCzGJtcSMgNDNadviX9+zvxioLwqll1P05DCS3AG4orfbB?=
 =?us-ascii?Q?9HKylDIawJgqoc/btLSmTf1SEJyOBhJgQ5UMTKrztZafmb5diz66gCmlwRd/?=
 =?us-ascii?Q?ME36D5KCVUmLmCbi6SCKeRUyNmx9T6boks8kuHUe94FW78NQrznpIakd3heQ?=
 =?us-ascii?Q?5ff/FXKlOX6O/X5JN/gj5AD5B9+dH0qFRaLXmo4I5yBuSSMaQItPgcduwqf3?=
 =?us-ascii?Q?8xKWkSi40iEvhD5KzSovdewpbPpp8+qvLnIRiyhLB9Wpiu4+Ob/gDoH8Jbgt?=
 =?us-ascii?Q?qWk+jjflKMmR8DF0Webgmi+4LX7kALHDtjNY5E2Drz8Ght+gXAeWs0LIjr/C?=
 =?us-ascii?Q?jfvj954zDfGUAHQ+I4jlTbnYn4SzGYh4m9nNgSSsZNRnskgeCpyMYiMb/wiO?=
 =?us-ascii?Q?5XLn2be1uf4W5Z7wKqkYdPZ+d6VA8zSoQVPO7rVzs3M4PMFNB2vhVm4ECiIi?=
 =?us-ascii?Q?zVqbqXykN82qL+XhnaVLq5jTQQ72b2pv4Vkr2Mrd4fXWadkO6e2FPkix1P3h?=
 =?us-ascii?Q?2JMRlr1QrlfaGbZnHcRRVYXCR3e0q+OtWCUHSyuFBR18PBG82tCoVwz0GRAB?=
 =?us-ascii?Q?SvT+hZ9W5w0LfMmH0X8IdU5bGRyd969m4xb238/dWQ5IDdxNAPG1A1jTee6v?=
 =?us-ascii?Q?pWcKjUWG12mD1CUpAK2av6oFIBni3ShDcRS7T60E7HNl+WlgxU8fdksW2DSB?=
 =?us-ascii?Q?pGacM6p0fjZP6CkNHh/BWTyf5GeGRF+XqCBT3ZWMs4dioAVJ8OU1SWX1V21G?=
 =?us-ascii?Q?+zeupF/btCdMB++UI20OnsHlv1HrkZpuXAECdAwZ1JASFheySOEezm2j1QvT?=
 =?us-ascii?Q?5GDf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:08:00.8663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c20e564-74cb-4811-2836-08d89d2e264f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vCllvE3tY2kFwgxPfvxCxe5lXUUrT7MbUApHdphgmOdCDXkRyMKCzHY1veatYePVuBqgXkLHN2CfFWL11JRuDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1493
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
index 6dc337b9c231..a1ea30c98629 100644
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
index fdff76eb6ceb..56d950df82e5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -61,6 +61,7 @@ enum {
 
 struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
+	bool es_active;		/* SEV-ES enabled guest */
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
@@ -352,6 +353,9 @@ static inline bool gif_set(struct vcpu_svm *svm)
 #define MSR_CR3_LONG_MBZ_MASK			0xfff0000000000000U
 #define MSR_INVALID				0xffffffffU
 
+extern int sev;
+extern int sev_es;
+
 u32 svm_msrpm_offset(u32 msr);
 u32 *svm_vcpu_alloc_msrpm(void);
 void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm);
@@ -484,6 +488,17 @@ static inline bool sev_guest(struct kvm *kvm)
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
@@ -496,7 +511,7 @@ int svm_register_enc_region(struct kvm *kvm,
 int svm_unregister_enc_region(struct kvm *kvm,
 			      struct kvm_enc_region *range);
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
-int __init sev_hardware_setup(void);
+void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
 
 #endif
-- 
2.28.0

