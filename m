Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FA72B6B20
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgKQRIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:08:21 -0500
Received: from mail-dm6nam12on2080.outbound.protection.outlook.com ([40.107.243.80]:32640
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726196AbgKQRIV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:08:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdzAgio92YoIfQL5JCpP9i/3wioEPlNUhaxOxRhotwiKk/UYUDbG4fLRsP9NlMNbn6XYpEHL2OBpCgY6bxzHyLIA6KKkeYgeD4fBTm6gIH551CQcipW5h6sVyvI9LUHbCi56fwlrJGWjcqaElFP1cB9dokwA9QnGvJrZkxHmZlqquF7a/i/5XHuO/JhcDBIDyLZBRYcVWjdAbCamV4xFoPINhHpQb3sOt1KMoG0bYeS03wF5RFr3jCqDcaYaADTcMVnNQrz3J8O81FHrdKgxp2TtDL70mT/WO1mh6ajWIDLkKI+FfJ7Awff3ojr22drr/tcTurLrWDAq6ZLpJwWosA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8/XXGp8GPG0NCypmst5UHYMdJrRQzuAfnGIvQLwv6c=;
 b=P2V9oEMeIOBMlXz60FShb7W2oQ9rk1TthhmmtT1Wcx0p07ztZbPaVWD1cRvUBVm+fA8nBJadGqc/BLGltp2WS8SmzW2IBiiQlL9Gj5KnbBoeRgDhOP8wyyo+JtW0xntpL6fbIEnBT51eF2XDDw6eblwpX0VpgE0Q+6KB2gUkA+dmQiEvOKM5Aus7aa0ElxjKywrrO70oFirSUCXqkXqD4ANql60s5cX0MuNXwEwtwpLfNQfoZz3vVFqLnPIDF2/oGHNMmDVTuKhMYOmQ5y0fokWV5ZmQEjIVsA4+8rlJTOvoDYaiJ2hJ+H1OW5LLwOhoRioxxWlO5iqQfFgtG5mNqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8/XXGp8GPG0NCypmst5UHYMdJrRQzuAfnGIvQLwv6c=;
 b=lkTdJJcEljBPDA4j3JGegjjDOR197HoZdnZrOrvz/FXQUI+GTCg6K+5ShbWgWRJhuQOBuhtzF+6vbjaxmgfgJcVBXguX9nwmRCK4RyaIG8ZYouejyW2ZvfMv5BRYjF2XDaToAyufteryqc4uNZx1odW8rWgJRgDJngIJdYKrNO0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:08:13 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:08:13 +0000
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
Subject: [PATCH v4 03/34] KVM: SVM: Add support for SEV-ES capability in KVM
Date:   Tue, 17 Nov 2020 11:07:06 -0600
Message-Id: <e54979d5681df61a2a8852b84b9d0912edd41bdb.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR18CA0076.namprd18.prod.outlook.com (2603:10b6:3:3::14)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR18CA0076.namprd18.prod.outlook.com (2603:10b6:3:3::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Tue, 17 Nov 2020 17:08:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0f757081-d688-41e4-7dec-08d88b1b5df7
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB17721EDD2C1F6689B57C279EECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9kqyu8j/FAM1sXWfqtjYY4PDR1aIuV6YMOucfw8Jy3/Vnzl1J8Q6vIngKrI8E5LnfzUrRxoiiy7jOkVboXsP6487g/f9s5O2lvSaYRtNvUzk6EGmGpsuacZOGTQ558sYX7FuxdUVIZtPcwXGdfsr+QO+rEy1C8aEe2ePDFpH532soawnDGjOqw0/v8Io7aBWLqhqxfg/nbMtCGZTwcSCrpluY3qHrg6K6Msd2DydnDfCjYv+Dgz4AnlimA6IdqQF328MhQCgOeJWw/gWwd858xfTtYfXWmFUb1YfG+uJbZLMzBt0HA65UNSZ5+bOt61w8sAtE9nKxcFTwA3HygNThg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Uf5g8ifcPAOGvBaNX3NHCoNr1NSr6WzsB1mIRenrajQ+q6VwpLGefnJ8J+KUDVXQn3vsImkU5DIbQM2OoD/++0qcwH51hzJGS+LdI816bMfKGmGo6RElNQJWvU8gAJBDzww84tlFyAT9lD1oLrJk6k0+LCxWReUi0j2ntSUDj7dxBMw1LeaQLFlDU5mb82WIKAl79+ON9acx3koEIXdUd19q3oF3JXKmMdhUw/pJjXLmGDwOtVxv7zVc4CucnLlD7MsJlXy1cj0BvTwDS1pbKsYl8f5mMumjRWhxe/7cwRFNUz+cWyRMmF8tTrGmmlnomPZEUn6jNHhtsFnQZu8j9FKL6FEBig1krA0p/TEpf0GaLakgKxhv0LZFyFWsE3+ONloRVoObV2K8rh5LeKLfmkor5G6RjSQg1H1GJxMCBLvReet9ml9EXus/wObuGceycIXdp3N2RurubasbZDmBO0++PX6VpNeWKdKsT/atNktJzokpQX4EcaA72kWY/SrLDvlHqw4NmetpHt8soPxp4i1s2PWxIQbPnED3tbn/njbBIvuVsvZ857TkEzhvE75cBa/grW2djM2DXyknt1WULUdVC/kLcIibl6rVZjA/n/urVWClfyRyUVsir3UmWvP7mDGvjk2fSwTjPhSomeQhHQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f757081-d688-41e4-7dec-08d88b1b5df7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:08:13.1902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KhHZ8Myp7l3q16X9Nz3wR781FYUTNP2vxZE4b/1o+MQ4lKDC96WuqMsXmA3rEG2iGHGfzjx1eziBzwNYErbNjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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

