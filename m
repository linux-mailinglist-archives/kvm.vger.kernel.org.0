Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17F630E8BC
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 01:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbhBDAmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 19:42:36 -0500
Received: from mail-bn7nam10on2071.outbound.protection.outlook.com ([40.107.92.71]:5024
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234299AbhBDAmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 19:42:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8mpQKaVHUVxQWSYORqm8nMgSAnbe6ww64/2mJdb7fUXRCG774wp4FQ+IqZVYi1N7YkNfNaLFakvs9Ama2nRXVWfkpEsg7H7DqjAybQYS28Te6oKgrJGUyeC1o2cN3jVDqpWiRxGqQK1Pwft8ZLqr9uuQR4JuIr1J0Y8JSJVHfKolGaN7L1DpoVGXVdO2C1TUTxNGHVx5mXhghxIkosECDsQNJn2x66UOTbKBuVw0MGC8zrmwa2gW2juvi2H5A4+bI2w6ETMHgiIlYlw2EvEDrx/gfUZ/nTBH4NbGwT18I4+se2s4OzE0gZcxJ1pvNovng8nj0QPmHSjM+0nItID+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+rF+xeXGr1/+CN9i2OFc7aIQLhAIM62nwSzrCJXsWo=;
 b=KFyZvfqwcUhuZm7ZpQMwTWXPgJIdSWFUv98djdWHuR1xnnMZciYJ8xCdNPWuiDxN8iVje6qdR6ptcYtzGz+N3cm7+gv8M8jGZDw/IUDiqvOSCy9Mqt5cFP9vjyFx9J5I6x0m7ohOTOmt76Q4kw/9Rfb7VNocjxjB/RSdB2jWYb12wjoRSPkpRBTeIDDbIVBXv3ve2vJVAkAqxY8WZmoat5VxBuQcnyHlMrk7/Wr0l4faWAcjqoZkOX8SD5pXbEVx399f+hLG+KX3kGurnI7G7y+DxtOBsiY5yzGxx8M/OULA8SRAI4/Bxctb09NfBf5K08hCELr8fyUdELat8C9vfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+rF+xeXGr1/+CN9i2OFc7aIQLhAIM62nwSzrCJXsWo=;
 b=QUvb0y6SsYpjM5fSP5KlfpNQv4NrOMlwfxeaNELyMUIOX2CkGifg7oyFHBtN3XYVmZtN62aurvEmtd2ZNWoSxstPvLCtZjBvsvgRS4HLzXpzH7CAK8eS0Zh6m1S6RFDi6OwIBmU+Eu3IDr69P5RnT4XR+uX4YeQq0uPsIWH2ARg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 4 Feb
 2021 00:40:27 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 00:40:27 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        seanjc@google.com, venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v10 14/16] KVM: x86: Add guest support for detecting and enabling SEV Live Migration feature.
Date:   Thu,  4 Feb 2021 00:40:18 +0000
Message-Id: <6daa898789dc8de02072b1ee6e6390088dbbc5a4.1612398155.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612398155.git.ashish.kalra@amd.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0174.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::29) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR11CA0174.namprd11.prod.outlook.com (2603:10b6:806:1bb::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 00:40:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c9f80e8e-92c2-411e-37cf-08d8c8a5777b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384F3BA8C3E347C0ACB2C618EB39@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:257;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2OECr+9fT4FMFU+CiHhc9eUMlBxJV/4UG+ogbA0OnnC53LKjcJPnfN3TCPwKOEI7pC86n6JTXjxmLyxvJbFu33+iDsWjS/1cMSMyvQ/9LHg2TcBGNRYPtwIeaH5YAotcyPsQ9I2XYVXggx+5zXQtkuLnmpHKP91M4e4CHW9ylvIFwgRRoBGnSo+/7O3RMXSg6QuzObeMGJ8T72dWSNyU039ESeKYt+0BTOzsVlK8CkCyQ/DcfkyHTlFXTnsXy/Lgd/OOg5h41hv4jfTsYsuokAmzGvrh8nOBFQwRdjRVjFJtiCAHUejvdOJwKAavk43RH9dDcksT0lPnMVjOTKoAcTK5VMCb7TTBI7sbZQ11y6PvxlztPOCAIfQ0lX5vWwL8ZxnZ+7NLFwNBtdQCHk7mLDL/335cux7S0U0wFBi+C8NedGujAkM6QuI2aZy2XucNiNebJTUinHUJASb13OEV1DpYnIwQ8VL+jXuqLRc3Quxy/kYwGqjBdh/rncn9NYJvxNO6dXAZgv1y64QiGtYPgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(346002)(376002)(396003)(8936002)(4326008)(66556008)(86362001)(6666004)(66476007)(2906002)(186003)(478600001)(26005)(6916009)(6486002)(5660300002)(52116002)(16526019)(36756003)(7696005)(7416002)(66946007)(83380400001)(8676002)(956004)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kHqTk7H6sEVrJWDCnCnLZgmwoaRG9mSM1MfQ9GUKxzGUaSPN54nyGmZJge+5?=
 =?us-ascii?Q?EZP1fdaha5Y/bwbRfOYeZNBp18ROnt4VSxOHsZw2TnkPeSDaiJGOdWMVsWIs?=
 =?us-ascii?Q?I4julPLzpeTnbs1UL8Ur8MyziUhW/XBwZ7cHUt9IswY30u7XSz4XprWq5U9Z?=
 =?us-ascii?Q?bVprK9PwMGneaCtKK27ptVXHvyxlH867/XukZkX1IiLwQcDvwj41ysnvZ7cB?=
 =?us-ascii?Q?slOqIFP5dOW2UUrWRA/mu2L9wjyTafcS0oIeDAEkIpztf04KZWkePJJBFcTp?=
 =?us-ascii?Q?pTznAuNerc8aOR3poNofu8+pzt877LCeeAoHAHnPBorXa/2c2XjBmuKZ8e/N?=
 =?us-ascii?Q?6LRvPUKmKpufpyltRvLbuZsBJGGgeIHAVmzuXEe6PcVfc8rcvUsneRmkomdw?=
 =?us-ascii?Q?s/P5JlkRZRq1TXWKlvEUq8f4jnYUW/oFMUqrWCd4l+aaF74akK8WcTCPOCwT?=
 =?us-ascii?Q?epM88R6peManI9RoUzu563JxeAp5O4wptfZ91vnERgxLaCLXBEK9yUg5hB/B?=
 =?us-ascii?Q?67lFGX5zg4xPYfAjr6ZvzRU0W/LlBcDRo1dsCfNb+y6ZZgNAZ3Pj0rX703De?=
 =?us-ascii?Q?4uUw6Kfo81TXA6Lfl87sehejlxxYp+zjWwip0NqsF6aXs6UwDcc1Ffjhs6GI?=
 =?us-ascii?Q?UYrEgKCOvIbseOSjyLOZ7S7OcDqseqMZCFn1jOkiOPKgfzo2jsVLq/cUsp1D?=
 =?us-ascii?Q?RhKXpj/9iW5V33ddzCuvgH77WMelLP+5y0vPjqb3mflmQn6xbNFglYDGFlWx?=
 =?us-ascii?Q?IimRPajSnp/4atya1el1qtIs1I20E2GRPgVY39HbYhWmoKwRFvoVB21BCbJo?=
 =?us-ascii?Q?baSFHI4193W44hBwEW0PF5kSLTV/s0qz5+0GNaOpsTwecgTVxBAto0eCVXyU?=
 =?us-ascii?Q?9V+zPBwTCra0qQkxjwmsxP2sBG+pjPDVq5iWqK8tD0Cqup8BAIaaMVrNUE0t?=
 =?us-ascii?Q?Qe/EVUn3JY7YQDGthYQ8KUwDCQl+3UaajP5EZFHLhTAXJYfivQ6rSrZmBr5z?=
 =?us-ascii?Q?uSVxiYs5hjaU2osB3hsI2AsJvaHJTqa4irnpQtoWmC97wxu/D6Im3V/8MWm2?=
 =?us-ascii?Q?Lyb8q0aOB1CRHOrtru9K1kvjhjR20tb+4ppR/D/fmzL4pW8bSvpaJEmKzT3y?=
 =?us-ascii?Q?bXGtA4Q61tz2EOLuMUaJFqadE11AJVjAlgEBwE3c0BKDL2Y34iUWsFSabbB2?=
 =?us-ascii?Q?j2yquBZElfl3i4RM4MAp2El5DEc/KeWwz1gl8EV8PB6mOCpcJ+RLEdr761uO?=
 =?us-ascii?Q?G+uEW/lU1n2Cceq5hCN8HpXKcqKkVnmY3ckRMntkgeaTI8x2eSxrOnPPsto5?=
 =?us-ascii?Q?ntiyoca6efBBtoKN+/QucW/I?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f80e8e-92c2-411e-37cf-08d8c8a5777b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 00:40:27.3917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vuqyDnvIlBuWiGKBQN0wX/S4nYEUjbDKmWnNRZ5CG4F68hcdrblepj8EW2oL1+HhL3pmfARnA/xp7IcQi5meZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
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
index 5e78e01ca3b4..c4b8029c1442 100644
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
index dc17d14f9bcd..f80d2aee3938 100644
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
@@ -461,6 +473,35 @@ bool force_dma_unencrypted(struct device *dev)
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

