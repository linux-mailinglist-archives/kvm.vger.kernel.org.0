Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B2335D168
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 21:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238633AbhDLTrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 15:47:02 -0400
Received: from mail-mw2nam12on2050.outbound.protection.outlook.com ([40.107.244.50]:63232
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237760AbhDLTrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 15:47:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNCKQRGtuD4nxfN+3a3iQ1ZkjyUqY/YfooTFPFvUeiFzzvPPejFZgg99QpSxJ7l/YNe+lmh8UnYid/uGJxVLuCz1nrk2J4EmxTW5EYm8eCbmg7pHFwx4sglaajGsN+/2S+kp0Ub3dmLbUAG8nF5UzsVEukVe7LOK76dnH/FS+zOBYy5zx6ErJus3UwHeftANhYLZDrck4snPGuIwqI1lNSa67AiRCU6UnSO5/5ZxmEoXrV5cjzTfnw5SN5SUsaJ/ZyrQkbF3JPnGFWEf4L5Sj7icqg/8e5opQFobWT+QxVW3cmBekVUFV7yAQg5EyP4q4CnQ0MaDrSfw8ivh9ciV9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvcQs5qLrU5in+oRyqaqqedPuuiSJAyZl7IgwhgRMKA=;
 b=YUILK7NMV+H3wJsufA/Z9CAH+wHJSzbNdN6W2y8Km1u0Mf+rS30vf5efjZF4Uos5OwwQsVJz3k/klSbeZP6P1rMUIzw+ikyVtiTWPV47+o7goGR5wlFEjpIwos5MsM0Nvep/4sJn1rIbVPRvUEQatwgSW4IIIXr0VpzE75xIo3YkgxWblmd4v/b5fzGaX2tPTwDj1YZwQm51174hRfLxJn2kmgjbDcdDVlnUUuk6DMe4W5ZoFCwaSEh3/40TjtSkCdZvUsYYerWlnMkSPrPWuzOB8SKR4VO0M6hjVMcaIDoShS1vtx3BitkZ/qP30dHqwCu9hVDHW5wsOB59wKQ9vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvcQs5qLrU5in+oRyqaqqedPuuiSJAyZl7IgwhgRMKA=;
 b=jIch4kp3MliMqLsOQAq/LgtfiCcQYpcE1LNDH8ZWaGiz0RQqZpSBDSycbfdAYYzz8vFAiRlgLVlDhyo1oeaLI33NPPLNU5tkkwZ/f1r4AfiyynlhYglJxKtVvTXgdJS6JnecCmS+TSc/uoIjRQ/FXkKz+Ra0YwhusN3uA+RxBy4=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4432.namprd12.prod.outlook.com (2603:10b6:806:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Mon, 12 Apr
 2021 19:46:41 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 19:46:41 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v12 12/13] x86/kvm: Add guest support for detecting and enabling SEV Live Migration feature.
Date:   Mon, 12 Apr 2021 19:46:31 +0000
Message-Id: <4ca573363fb8fcd970add90fad4b51d43f1c5d84.1618254007.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618254007.git.ashish.kalra@amd.com>
References: <cover.1618254007.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0701CA0030.namprd07.prod.outlook.com
 (2603:10b6:803:2d::23) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0701CA0030.namprd07.prod.outlook.com (2603:10b6:803:2d::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 19:46:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c01d153e-f5eb-417b-eb87-08d8fdebb18d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4432D609AFC84095961872688E709@SA0PR12MB4432.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:257;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hGvBebs3VqyLpYo77wmLRwW+K5FGy8JdEP3XAYRiZD2TZWxk9wfpHZdJ3oFrpT9xuRR/9CpUmM3pA/m5xaAxCGoVABlWUDdvt8U5GfuG/8WHh+WtFMV71PEibiJhIZtX6s9ofNY+MzH0goRSI4WOA35dFDFfP+ZFjDofPivn/sJNgHjBahIrY828RqIgah+1crsKG/2lUl4PH1B8A7wDeC/CNEdh/P2t5d0r9Bla5W3+ZMUuCwXZhkHmF1A93Gce+fc3wKXH7VMsTkvpr6fNPUTqqI8B6Lj1sMoiczIH5dbIlmredGZbv6bAyKsYz0UtCrndHIDhjKdNduBEaT+gEMyTT9oa+GfAwNm0WYEFMXI5x8zxEkgeBuVxr6pdXsvj/GJy+m9d4IP0u0V9RAa66NrEKwtL/om5/Z0Xs32mNmgcDhTnDUGWOxnBQSvMBSmlsCTwToHl/yTpS7ObIzNjzfpuQIyNV32Al9J3PXQQbafupS+ZiED8MRhyeygM7fpMwZ7yO2VZ0OX/KoeZIfORkX7Sk5NDb/82Lxbf2AqVcKnfMMvF8LOl0HObb6wOWswcXI3ITE3cZJZYlG2v17TOd4esEVlhFVNJEUQCoZCxLbgHuCbThpvXmvg8kck5J1dvy6U9mwjCO7kTZofe+FOZlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(38100700002)(478600001)(86362001)(38350700002)(66556008)(8936002)(6666004)(7416002)(316002)(956004)(16526019)(52116002)(6486002)(2616005)(66946007)(36756003)(4326008)(186003)(26005)(8676002)(2906002)(83380400001)(66476007)(6916009)(5660300002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?u36Qb1e2tiGbAJB4+WD6175U8VFGgQIHj5JIBD9AZ/SukqRxJ5DC0RkdK4GG?=
 =?us-ascii?Q?zamWob5D1AcGMe6T4fRoyWIUOy3Ac6NHbQ3s7Gc1hC9ACthOC9AmB1hdXBLL?=
 =?us-ascii?Q?RzFWdHmxq/+FSJjLbxYa6BAdNQtme+rByCnl0fzlH40Lhhgv8dol00tcchzA?=
 =?us-ascii?Q?0aGBvhvMs/0PFvv4YB6OJceJyXHqxk8TPiRZ6V7kFAgci5E+WACMR/wVKiEG?=
 =?us-ascii?Q?h7KG5zL0s2gt+M+qHi5bII30R5iFkLSWuX2tBwgcf4GDpZrEV+wLwDS3gb2X?=
 =?us-ascii?Q?e/Bpg0Hy46Sf2dT8qfDbWGyH6oaJgvm4CiIoWMgxTVeusCbYrOuBIcEwHTCq?=
 =?us-ascii?Q?NH/Co/kHndk3moyU53tv1Whe5a2raDVoq7X03pHTIUiNcMosbRTtvojqUXan?=
 =?us-ascii?Q?60s4l4VVEHxjetgCi9oCzGBkUkY+bOYszVpLEjil7AWEtR4YnlZZkpZuEKEl?=
 =?us-ascii?Q?C2LM9jnppENJ1iXsQnKBpTHwDwmgXNxjRRpo/UnwdmhWuOxzq9vQRyNzi8La?=
 =?us-ascii?Q?rCrF8p/ntQL7V0R/iKrZ2jhyZ2mJqHQtEYsf7p1Kx4uVaC/JZcDbSnQQR0qz?=
 =?us-ascii?Q?yEdUU6fIZKRrJw17RLgiKX/dFU+xDLVKqxHv5n+9ManjaFxMsr+Y3hdt8sg/?=
 =?us-ascii?Q?26MnOfN5of6RkEIrqSdOb4j0aM69kafW5j4y1MOuCIQw6OGdE0JOXX/skyu+?=
 =?us-ascii?Q?+3vyIsgODSH0S2VH8qzdGD8EUh2X0oNTZw3qxr2ukrVzQtGB/SPCGP2fSUxJ?=
 =?us-ascii?Q?cYLoCfgP0wT7Ey9MmvUXVb+AX3ZMvkouFzn6GFufoaBqS1hr6x59ZAkTa039?=
 =?us-ascii?Q?CcdGuydUSCo2kg9L17HzFw3P5IB/4jFSjOZ1tzEjphJFWKMNABfjXSbYuyiG?=
 =?us-ascii?Q?M5KjYFxgilgCQzWTwEuiGaVh6eU4n6RSgkQGpQppTymH8XPNgPo1w4oAOnYI?=
 =?us-ascii?Q?YNDLoH/e6aE4GN9Ji6EJRHp8fup2HLj/VBK975qitOXyshtNnLdqERSddaoL?=
 =?us-ascii?Q?oK+KQZ04BVuAJtodSkwXUxaVX0oCjh3VbQ6EtvZ5QS1csrQAae6qwZLp9oIc?=
 =?us-ascii?Q?LbPlo8gf3VC1iGbzyhE+IkqIRAL6E0zQdObQ1omeNWgiqgCj7qeIXp8B1a5A?=
 =?us-ascii?Q?hGnGz2DPKvH62DYtnrOOR3ken372kJArux3e8bBOJ5ibPypmoCLWJdc6v49H?=
 =?us-ascii?Q?Yc7fQbmrH/1Au4wt02JYhAiTNraqjQjK+oXB/OdoXuohAZzC8gCLTxvNJI+O?=
 =?us-ascii?Q?7h883T2oqMXtpTXsAyfiT3oe8fKqlx0nIWzZpdUbaSikbsmp+1gpKUwl0tGL?=
 =?us-ascii?Q?u6iqraCxMgYai2YfP+1VpxcA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c01d153e-f5eb-417b-eb87-08d8fdebb18d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 19:46:41.2054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4D4YFE82cmykLSPPTn7cJH/HcRbPfC+uWUzmWExOyw+15aErt+y9ezfI2BnObgPRuvvBvQiDd6+2/A1ATr2h1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4432
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

The guest support for detecting and enabling SEV Live migration
feature uses the following logic :

 - kvm_init_plaform() invokes check_kvm_sev_migration() which
   checks if its booted under the EFI

   - If not EFI,

     i) check for the KVM_FEATURE_CPUID

     ii) if CPUID reports that migration is supported, issue a wrmsrl()
         to enable the SEV live migration support

   - If EFI,

     i) check for the KVM_FEATURE_CPUID

     ii) If CPUID reports that migration is supported, read the UEFI variable which
         indicates OVMF support for live migration

     iii) the variable indicates live migration is supported, issue a wrmsrl() to
          enable the SEV live migration support

The EFI live migration check is done using a late_initcall() callback.

Also, ensure that _bss_decrypted section is marked as decrypted in the
shared pages list.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/mem_encrypt.h |  8 +++++
 arch/x86/kernel/kvm.c              | 52 ++++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c          | 41 +++++++++++++++++++++++
 3 files changed, 101 insertions(+)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 31c4df123aa0..19b77f3a62dc 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -21,6 +21,7 @@
 extern u64 sme_me_mask;
 extern u64 sev_status;
 extern bool sev_enabled;
+extern bool sev_live_migration_enabled;
 
 void sme_encrypt_execute(unsigned long encrypted_kernel_vaddr,
 			 unsigned long decrypted_kernel_vaddr,
@@ -44,8 +45,11 @@ void __init sme_enable(struct boot_params *bp);
 
 int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
 int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
+					    bool enc);
 
 void __init mem_encrypt_free_decrypted_mem(void);
+void __init check_kvm_sev_migration(void);
 
 /* Architecture __weak replacement functions */
 void __init mem_encrypt_init(void);
@@ -60,6 +64,7 @@ bool sev_es_active(void);
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 #define sme_me_mask	0ULL
+#define sev_live_migration_enabled	false
 
 static inline void __init sme_early_encrypt(resource_size_t paddr,
 					    unsigned long size) { }
@@ -84,8 +89,11 @@ static inline int __init
 early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
 static inline int __init
 early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
+static inline void __init
+early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
 
 static inline void mem_encrypt_free_decrypted_mem(void) { }
+static inline void check_kvm_sev_migration(void) { }
 
 #define __bss_decrypted
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 78bb0fae3982..bcc82e0c9779 100644
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
@@ -429,6 +430,56 @@ static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
 	early_set_memory_decrypted((unsigned long) ptr, size);
 }
 
+static int __init setup_kvm_sev_migration(void)
+{
+	efi_char16_t efi_sev_live_migration_enabled[] = L"SevLiveMigrationEnabled";
+	efi_guid_t efi_variable_guid = MEM_ENCRYPT_GUID;
+	efi_status_t status;
+	unsigned long size;
+	bool enabled;
+
+	/*
+	 * check_kvm_sev_migration() invoked via kvm_init_platform() before
+	 * this callback would have setup the indicator that live migration
+	 * feature is supported/enabled.
+	 */
+	if (!sev_live_migration_enabled)
+		return 0;
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES)) {
+		pr_info("%s : EFI runtime services are not enabled\n", __func__);
+		return 0;
+	}
+
+	size = sizeof(enabled);
+
+	/* Get variable contents into buffer */
+	status = efi.get_variable(efi_sev_live_migration_enabled,
+				  &efi_variable_guid, NULL, &size, &enabled);
+
+	if (status == EFI_NOT_FOUND) {
+		pr_info("%s : EFI live migration variable not found\n", __func__);
+		return 0;
+	}
+
+	if (status != EFI_SUCCESS) {
+		pr_info("%s : EFI variable retrieval failed\n", __func__);
+		return 0;
+	}
+
+	if (enabled == 0) {
+		pr_info("%s: live migration disabled in EFI\n", __func__);
+		return 0;
+	}
+
+	pr_info("%s : live migration enabled in EFI\n", __func__);
+	wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION, KVM_SEV_LIVE_MIGRATION_ENABLED);
+
+	return true;
+}
+
+late_initcall(setup_kvm_sev_migration);
+
 /*
  * Iterate through all possible CPUs and map the memory region pointed
  * by apf_reason, steal_time and kvm_apic_eoi as decrypted at once.
@@ -747,6 +798,7 @@ static bool __init kvm_msi_ext_dest_id(void)
 
 static void __init kvm_init_platform(void)
 {
+	check_kvm_sev_migration();
 	kvmclock_init();
 	x86_platform.apic_post_init = kvm_apic_init;
 }
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index fae9ccbd0da7..4de417333c09 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -20,6 +20,7 @@
 #include <linux/bitops.h>
 #include <linux/dma-mapping.h>
 #include <linux/kvm_para.h>
+#include <linux/efi.h>
 
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
@@ -48,6 +49,8 @@ EXPORT_SYMBOL_GPL(sev_enable_key);
 
 bool sev_enabled __section(".data");
 
+bool sev_live_migration_enabled __section(".data");
+
 /* Buffer used for early in-place encryption by BSP, no locking needed */
 static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
 
@@ -237,6 +240,9 @@ static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
 	unsigned long sz = npages << PAGE_SHIFT;
 	unsigned long vaddr_end, vaddr_next;
 
+	if (!sev_live_migration_enabled)
+		return;
+
 	vaddr_end = vaddr + sz;
 
 	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
@@ -407,6 +413,12 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
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
@@ -462,6 +474,35 @@ bool force_dma_unencrypted(struct device *dev)
 	return false;
 }
 
+void __init check_kvm_sev_migration(void)
+{
+	if (sev_active() &&
+	    kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
+		unsigned long nr_pages;
+
+		pr_info("KVM enable live migration\n");
+		sev_live_migration_enabled = true;
+
+		/*
+		 * Ensure that _bss_decrypted section is marked as decrypted in the
+		 * shared pages list.
+		 */
+		nr_pages = DIV_ROUND_UP(__end_bss_decrypted - __start_bss_decrypted,
+					PAGE_SIZE);
+		early_set_mem_enc_dec_hypercall((unsigned long)__start_bss_decrypted,
+						nr_pages, 0);
+
+		/*
+		 * If not booted using EFI, enable Live migration support.
+		 */
+		if (!efi_enabled(EFI_BOOT))
+			wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION,
+			       KVM_SEV_LIVE_MIGRATION_ENABLED);
+		} else {
+			pr_info("KVM enable live migration feature unsupported\n");
+		}
+}
+
 void __init mem_encrypt_free_decrypted_mem(void)
 {
 	unsigned long vaddr, vaddr_end, npages;
-- 
2.17.1

