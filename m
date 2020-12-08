Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0022D35F7
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731414AbgLHWJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:09:37 -0500
Received: from mail-dm6nam10on2068.outbound.protection.outlook.com ([40.107.93.68]:52065
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730419AbgLHWJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:09:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nek0qdivJnIcbY/YhyeM9Hc8u6Su4rwQQoIegYanONKq4wMXWGZjPw8k2kU8SXWrMpFfvVITMrCpvIyw+DJ4ay4AvLpF5ATP6uCEwKBMpXj4aeMTWGnY4veTl4L9QAu9gkRG+TJ8qX9dptrbdT3tGque0cyhrRnudwXh3hCOHUZ31UYrS9TvaJscwMGFsyXRE/VT6LkVLmFKHIUXWdkD9eQoCtlBZ83Oqd1KpXGfJda4jkInbe/iNXDGCv1xSahB1jZJV5ExsFqx9S3FMvrR1yVddkLVaXCFLB1+2y3v5M+JhCblZf6U8+FlBuHPWpeExBllOrPNL/nYe+UbjVPjgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2wRrNktCQvx/Hr6Ndr0y61lwW0pqOcX0iTItXVRCy5g=;
 b=ExvuhwZYO6PgWQdNXwx+Q0UvrrY6VrqJabwAaPGkhrbKqR4hzU3NPoUV1AEIfUObT/AzjxRQQw4xR7WifFJXnwuksvVQ+wRVh9obkug9dach1ON5SwjOpjdE7gCEeR1QcnWrvFFq7I1aKbKnbmN2djGGl7pzckJmES7XpCBakg/ML3lIBnwFM9y9dAzfDUQlF3+TBMJCfd+561u5ih1LD6R4cDvjdN2wR/SuWfj89U6EG1k+aQ0X5vVghkY+RDCMftK+m8avLSWLgEx0XZk8jZBZEHjQTaHYh/x93BWlmakps+ccGfyU6a1hYO3uKY5ydGMJcCw+Zyr0X4n61kKMHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2wRrNktCQvx/Hr6Ndr0y61lwW0pqOcX0iTItXVRCy5g=;
 b=YQKlKUtgxOTMhY6YMtyK+4h5c+Qaw2SMIbUSveNhUqXxA9FD98frnHPbrOALJymojn3n+vk1T8sMC3cI/8Uikfz6+gD9szk/wbndlCmqaejl0khnBf3FzDJzjsjOK2CJOijulBwnBuYtZ1vg1jU+NJF+5bvKA5n2z3uStFxuDaU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Tue, 8 Dec
 2020 22:08:39 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 22:08:39 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v9 15/18] KVM: x86: Add guest support for detecting and enabling SEV Live Migration feature.
Date:   Tue,  8 Dec 2020 22:08:30 +0000
Message-Id: <b0fa23ba503fa739db7dc3f9c97037cd5a05e70b.1607460588.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1607460588.git.ashish.kalra@amd.com>
References: <cover.1607460588.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN1PR12CA0043.namprd12.prod.outlook.com
 (2603:10b6:802:20::14) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN1PR12CA0043.namprd12.prod.outlook.com (2603:10b6:802:20::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 8 Dec 2020 22:08:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d3799fe5-c467-479b-8ca5-08d89bc5d138
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44152B5D92B70160F65787528ECD0@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FthA0Vz+wkouSKpJL3hO6BmDJ+QcJboDuA+4MWaDLDIfU2S18a9SmYIIWOZqvQMLcDRGmkRQs+jrfE5GTi/PQ1Vb+G8Ei7fwCAnSYNBKnSdXcxaYU0ZNBENs2+5Zenv6ksaoNzhN0cSE0QGH9R8HfGlxN0hi/N2K5OTP0fNQjX+Npr90hs0ebToP5BItrY4e/XvXyCQTsO0hW++rCluGamRZkxrnndfj/08mOXK/JxmKX6WTv+rbtqe1kZCvtU02sCwiq5KURCCchBQIXGOmWe42RlFDtednonsruVklZi3THWy7T+5/LAcDnL3wmgNKPFi5xz4YTfb9puZbWxk8/WjkT71+4h+fUQYS/ZbOxPiGnRF6MRdLfYkcSWY5XSxz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(34490700003)(83380400001)(186003)(4326008)(86362001)(6916009)(7416002)(16526019)(6486002)(5660300002)(66556008)(8676002)(8936002)(508600001)(7696005)(52116002)(66946007)(956004)(36756003)(2906002)(6666004)(26005)(66476007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EuSyWqv/NOheymI+rcJTfelf2n1iAMyGaj94zGhybg3kU5FVkrbo7+KGsr+x?=
 =?us-ascii?Q?OG3UaSx/0j7IxIi8xXtVnZyLwZANKkhMHUs/B04xyZMPyPJI4fEZqw4AFwJ4?=
 =?us-ascii?Q?0RGHhXP6yW7GmPprIOr/sqTCjkDb0ferY8T0UEOJbSyjdJlrBbQZwtrPBOj4?=
 =?us-ascii?Q?eTONLPUFnRqaX8lBa7z9ejkFbjhKaByRy70RzRGwPpTch4kV6ESj2CWQE1fJ?=
 =?us-ascii?Q?4VDNYguq9B+bEsSt1FNdryTcK1z8PsII7NnK62RDTxJe0/9z5wddMwMTmRHC?=
 =?us-ascii?Q?5vXbjtNRC49CGEYnZQQAyJ1aN8UVdmsO77gIsRDP44EktRj4tS/e0QCtKFGw?=
 =?us-ascii?Q?9uN0OhVJzuRIS1gW6Nu3Odo6izioU64pj1rH0NEdSKV9OWT7reQISSH1z64e?=
 =?us-ascii?Q?tfbufFSce18RJRXWHPNTMoeTsEkFiqzvCQ/Yzs6hLcTu3t6Caapf43mWFK/X?=
 =?us-ascii?Q?ETqqiU0JNbMvXH2kQ5VAayFVjyaAwgQh/dZp4k8DdV3zkJ+e8rwQsgdbhfQr?=
 =?us-ascii?Q?vkoXPbNx9GkUPdJ47Ioadl2sHLLkGNZxv96B6wh7byTEnrHSb7h9Qqce43HT?=
 =?us-ascii?Q?OuEdMGPFhC238znUtTG4uSYS9mx/KOGNkMcLUmOMZHqjOzSJP6XkA0kFcUCQ?=
 =?us-ascii?Q?kr6bSVsInA/3cb/WbijUtN35u/amfAXyElt8rOEhJa9jG85jEMmlt+L10QGZ?=
 =?us-ascii?Q?vbpfvo2/S44dXN6AO++sX7QwROPglBhh6ow2kSSp9TR99dhfs5eFcYowZz/E?=
 =?us-ascii?Q?lHnckxRQx2IXgOlhLAAlttR7EhyB3sGDvGTs7mtIFsc1dswYul4s0B7vnaZW?=
 =?us-ascii?Q?mgn9t89Va82dxeKtN3ExcyKEED/fC67RFY6DiLN6I62Ao35MpJgLeabtpqmc?=
 =?us-ascii?Q?9n0yWwLzw2H0g8eeFBfBVTtTs9f6QVdAD0yK8KEVxIu35CgDwKwyP1D2K9i+?=
 =?us-ascii?Q?0C2jlCuuqzxKVHafvytjPLc3aQ3Kie+E0hKclc+YdQBe/QFBJ0QB+U4/W5og?=
 =?us-ascii?Q?THRu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 22:08:39.3042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: d3799fe5-c467-479b-8ca5-08d89bc5d138
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j+Pcun4thhHxQqGymxwZpaDErln/uNZBt1NFHRPJfP6lc1UDxru7z0x/Dfexdj/ybLdvharJl8GA3uUBDg2/8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

The guest support for detecting and enabling SEV Live migration
feature uses the following logic :

 - kvm_init_plaform() checks if its booted under the EFI

   - If not EFI,

     i) check for the KVM_FEATURE_CPUID

     ii) if CPUID reports that migration is support then issue wrmsrl
         to enable the SEV migration support

   - If EFI,

     i) Check the KVM_FEATURE_CPUID.

     ii) If CPUID reports that migration is supported, then reads the UEFI enviroment variable which
         indicates OVMF support for live migration.

     iii) If variable is set then wrmsr to enable the SEV migration support.

The EFI live migration check is done using a late_initcall() callback.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/mem_encrypt.h | 11 ++++++
 arch/x86/kernel/kvm.c              | 62 ++++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c          | 11 ++++++
 3 files changed, 84 insertions(+)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 2f62bbdd9d12..83012af1660c 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -21,6 +21,7 @@
 extern u64 sme_me_mask;
 extern u64 sev_status;
 extern bool sev_enabled;
+extern bool sev_live_mig_enabled;
 
 void sme_encrypt_execute(unsigned long encrypted_kernel_vaddr,
 			 unsigned long decrypted_kernel_vaddr,
@@ -43,6 +44,8 @@ void __init sme_enable(struct boot_params *bp);
 
 int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
 int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
+					    bool enc);
 
 void __init mem_encrypt_free_decrypted_mem(void);
 
@@ -59,6 +62,7 @@ bool sev_es_active(void);
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 #define sme_me_mask	0ULL
+#define sev_live_mig_enabled	false
 
 static inline void __init sme_early_encrypt(resource_size_t paddr,
 					    unsigned long size) { }
@@ -82,6 +86,8 @@ static inline int __init
 early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
 static inline int __init
 early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
+static inline void __init
+early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
 
 static inline void mem_encrypt_free_decrypted_mem(void) { }
 
@@ -110,6 +116,11 @@ static inline u64 sme_get_me_mask(void)
 	return sme_me_mask;
 }
 
+static inline bool sev_live_migration_enabled(void)
+{
+	return sev_live_mig_enabled;
+}
+
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* __X86_MEM_ENCRYPT_H__ */
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 7f57ede3cb8e..7da8b6b3528c 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -26,6 +26,7 @@
 #include <linux/kprobes.h>
 #include <linux/nmi.h>
 #include <linux/swait.h>
+#include <linux/efi.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -429,6 +430,53 @@ static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
 	early_set_memory_decrypted((unsigned long) ptr, size);
 }
 
+#ifdef CONFIG_EFI
+static bool setup_kvm_sev_migration(void)
+{
+	efi_char16_t efi_Sev_Live_Mig_support_name[] = L"SevLiveMigrationEnabled";
+	efi_guid_t efi_variable_guid = MEM_ENCRYPT_GUID;
+	efi_status_t status;
+	unsigned long size;
+	bool enabled;
+
+	if (!sev_live_migration_enabled())
+		return false;
+
+	size = sizeof(enabled);
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+		pr_info("setup_kvm_sev_migration: no efi\n");
+		return false;
+	}
+
+	/* Get variable contents into buffer */
+	status = efi.get_variable(efi_Sev_Live_Mig_support_name,
+				  &efi_variable_guid, NULL, &size, &enabled);
+
+	if (status == EFI_NOT_FOUND) {
+		pr_info("setup_kvm_sev_migration: variable not found\n");
+		return false;
+	}
+
+	if (status != EFI_SUCCESS) {
+		pr_info("setup_kvm_sev_migration: get_variable fail\n");
+		return false;
+	}
+
+	if (enabled == 0) {
+		pr_info("setup_kvm_sev_migration: live migration disabled in OVMF\n");
+		return false;
+	}
+
+	pr_info("setup_kvm_sev_migration: live migration enabled in OVMF\n");
+	wrmsrl(MSR_KVM_SEV_LIVE_MIG_EN, KVM_SEV_LIVE_MIGRATION_ENABLED);
+
+	return true;
+}
+
+late_initcall(setup_kvm_sev_migration);
+#endif
+
 /*
  * Iterate through all possible CPUs and map the memory region pointed
  * by apf_reason, steal_time and kvm_apic_eoi as decrypted at once.
@@ -742,6 +790,20 @@ static void __init kvm_apic_init(void)
 
 static void __init kvm_init_platform(void)
 {
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	if (sev_active() &&
+	    kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
+		printk(KERN_INFO "KVM enable live migration\n");
+		sev_live_mig_enabled = true;
+		/*
+		 * If not booted using EFI, enable Live migration support.
+		 */
+		if (!efi_enabled(EFI_BOOT))
+			wrmsrl(MSR_KVM_SEV_LIVE_MIG_EN,
+			       KVM_SEV_LIVE_MIGRATION_ENABLED);
+	} else
+		printk(KERN_INFO "KVM enable live migration feature unsupported\n");
+#endif
 	kvmclock_init();
 	x86_platform.apic_post_init = kvm_apic_init;
 }
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 9d1ac65050d0..cc1a4c762149 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -48,6 +48,8 @@ EXPORT_SYMBOL_GPL(sev_enable_key);
 
 bool sev_enabled __section(".data");
 
+bool sev_live_mig_enabled __section(".data");
+
 /* Buffer used for early in-place encryption by BSP, no locking needed */
 static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
 
@@ -206,6 +208,9 @@ static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
 	unsigned long sz = npages << PAGE_SHIFT;
 	unsigned long vaddr_end, vaddr_next;
 
+	if (!sev_live_migration_enabled())
+		return;
+
 	vaddr_end = vaddr + sz;
 
 	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
@@ -376,6 +381,12 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
 	return early_set_memory_enc_dec(vaddr, size, true);
 }
 
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
+					bool enc)
+{
+	set_memory_enc_dec_hypercall(vaddr, npages, enc);
+}
+
 /*
  * SME and SEV are very similar but they are not the same, so there are
  * times that the kernel will need to distinguish between SME and SEV. The
-- 
2.17.1

