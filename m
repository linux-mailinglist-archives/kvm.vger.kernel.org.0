Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6543E2D6464
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 19:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392597AbgLJSEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 13:04:53 -0500
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:37494
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404048AbgLJRMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:12:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BT8LldbC+4I+yQHnIABI/uLMMI4lweU/cYZhETrVppxgb0BKVEJ3/s7JeJkAB61i2kQB+ZQtsRCKtSXUDsQgfl9te8jQtMZxERqAolAveq9z+LUIcSOR68GJjSvwoFbFw0wHBEeBNXmTFGPVtrPRN0+YS2xk0FN1Q6Q3804mpG4wWEoF/Pd3TB44tCXwIK1S1HcmAPArR2sOFFPlZzGzw7pr3wiOhguIPJAR91VYjMJ22QmcwZ4XYi8BkQS7Luz54qW0Cy8Vl/h0C/fjHeyk53k4HqxYfCzKjBVGjhHRna205RV0TFyjlej4uODF0vl0XoZhrjx6Ux2Y2dcMl3grkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEu7KmoSe2wsLRyaIXnIQhWobneKjtSr6mvX8Tyf+V4=;
 b=LZWdnPnR2Yz3HmmoAMGOe593Ds+8fjM0WjPQ6mmbBXrkVoHoX6sFRJnbM4hNKOi01GXUnFiCSCuJZZ6NSGBjJm7L3dUY9IUQyrueu4aSPNtTU30cpU2M9XJi5ukZz6awuykF2mgS2+xJUMuBkU0TOTZKT1kSquywLEDfcFt+QZgR0j5vPCDIR98zS6Z37IqLoT/WMMLvBlxmLZLko6+dJBeDkfE1iI91+VKzu6O5qwyXEyumms6wTyK1ZOJ28HrhrDY7GLci2qftiRpAjw6VZVl52uN5gw9+Yw81CIP9/W/fIbKlb+MQ9pwJi4B21TbOrs6qaDvbVVjxKb1qDjCaUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEu7KmoSe2wsLRyaIXnIQhWobneKjtSr6mvX8Tyf+V4=;
 b=CmET4wmK9sZ+h1oR7u1pSyk5qllIuPZyjY3eMlnrnkytE7bsqBhgUDcSeim5s3wI7NIcE/6nclzIJ8HiMGCTCfd3lMrpwgi4FT8aFsUF9jMRQUUzptEe52M6xK5272oTsN2LCijYuWfxgB1gjuNQ9AR7nntaZoefSPip/HcAENU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0168.namprd12.prod.outlook.com (2603:10b6:910:1d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.22; Thu, 10 Dec
 2020 17:10:44 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:10:44 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 03/34] KVM: SVM: Add support for SEV-ES capability in KVM
Date:   Thu, 10 Dec 2020 11:09:38 -0600
Message-Id: <e66792323982c822350e40c7a1cf67ea2978a70b.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR10CA0025.namprd10.prod.outlook.com
 (2603:10b6:610:4c::35) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR10CA0025.namprd10.prod.outlook.com (2603:10b6:610:4c::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:10:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a727b69a-4f2a-424d-266b-08d89d2e87cf
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0168:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0168FA8A806E1F1BEA5CDEF9ECCB0@CY4PR1201MB0168.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BNDfnag89SoNoBvy6T8JL00Odj1UWe8Zu3//F8oIbfwbze7yEiSQITtknz/Ed64OIq21g+icn1XlO09cjJAveeWhH8cpDormOL2wUpU5W2JFQ1dpZtS5xhIijtsr1u2amMohcUPzgWaciyWjvi2AT/n7zHV0Zu+tssfle2fMl03EPuRddtdvoyoVBsrDSRdAFSOkzn3YikeBYIHKWPWp8LFVI3TdE8y1TPl7e1Kc9UxSV9YSn4RNgYNdHQpMh21DOUZXFzDYbI6AbX86VmijV6+6ZXx3aHJd2qRt1cPOU5e0hWEoXV1NR7hkpITOajqtjq+a8Ey8wfNabcEzkVRQDxWGAS4TiDqLcGKqe+Ri2qTCMvjgQmGToqpWw83xYF8e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(36756003)(8676002)(6486002)(4326008)(66476007)(86362001)(7416002)(66946007)(7696005)(54906003)(6666004)(26005)(16526019)(34490700003)(66556008)(8936002)(83380400001)(186003)(2906002)(2616005)(52116002)(956004)(508600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?74X2YJNOXhnOyqPQXoTvivpnnEN5pUoUG4VDVRgIfs6GUY7GDdV/EXmpdIxN?=
 =?us-ascii?Q?/3+IY3wyvfSJ4ugBaFfB+CDcJDDOmm4b+8id5nQgl+7az28RuibRJ+CUfeLd?=
 =?us-ascii?Q?DrgrumKTXyzbMN7MyiiWPeFDTVghmLvEF+7yGo3LijlCMeSv2kqFzAfatQ0Q?=
 =?us-ascii?Q?aVlLcd+Pr0meeZOXycs+kcggjJL3RBWZjz0kjqOAOzsOTcZwneUoDxsoAQhX?=
 =?us-ascii?Q?vEuudnptJynq3HRyImAP8PfKSAiYZ7Z1NyfDb6mEKMgv5WIB44fGfzZVSiKp?=
 =?us-ascii?Q?Zx3TG8idgRWCfJunC7OqZpiDd5FVDa05SQWu+L93J2LBagXoDl4WL/b152BR?=
 =?us-ascii?Q?SQRkd7XrR83NmVkown5847KYpu4RCc0MLv57SzS92rIvS4bp7pMpm6GRncpp?=
 =?us-ascii?Q?6DFTT7fFcRQnWDRSvZhG3XX3vt2AoOVuhfPQk4nfrWxU4JPzy5FpLttvK9Sh?=
 =?us-ascii?Q?N3LkIK3BXrjn1fyCtXpZwaABqZL/+245i7FbLgEarXJKzyZSsRdTk796FX46?=
 =?us-ascii?Q?erLDsfCsVocUfxTGYCEVD81L9Z++F4i4dzO4QH0hmj4OHW0eqrAuZalWb9ac?=
 =?us-ascii?Q?9b9GkD2Kiwx4ukFZBXLzkaF1cxSXJOHCUKcYKDxA9OKyyBcpHMg3yJsJTuCR?=
 =?us-ascii?Q?nt3SHl+3oPlD/WY9hKKQsREqvvM89X2BafriPkS0V1ASnOhC9JAP7EUhi64t?=
 =?us-ascii?Q?bdFN8/NZHtRLiqEXPNUqHRLL4XV8tWzzwRTm91DsajnZijyXZkOeFuViJP9a?=
 =?us-ascii?Q?SYg7qEGJhYSNd9txjg4nDWobXREBHgPZgEhbg2VFtIlDw3MRr+dEKcqgG4ZH?=
 =?us-ascii?Q?oMcCy2jiHpzavAzyyxCiNhY9ppjyQoC+Ii6DQoiDB0AkfpkhT5bOW670FZiO?=
 =?us-ascii?Q?w3WSckfqdIf+zsq+WxgdhJ4u0agPLDEtTVmNKUUlFrdwGbKFh3oaXOgQGhO1?=
 =?us-ascii?Q?m4+wcInnZKAHAPLtrqvLmtOVA5MY2/MBZdN3kB16Snhc3VyPLUGfRVkcHlWi?=
 =?us-ascii?Q?av4o?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:10:44.4861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: a727b69a-4f2a-424d-266b-08d89d2e87cf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Seu6TO/oRRl9MQAiZqSzcjh3MZ5mfpIe+yLTuHFbxaG+SyrZ005J9Lieo2niP2NH41CpJIab4HxJiruYomDP1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0168
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

