Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68F73542D5
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 16:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241409AbhDEObZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 10:31:25 -0400
Received: from mail-eopbgr750054.outbound.protection.outlook.com ([40.107.75.54]:54087
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235915AbhDEObY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 10:31:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEN2jKQgRgIckWKq6/ZMFKLJV386QF/QyRRkabo/qP+Zgc/A7WbYw1OGPoGZSxV2PlduIMlX4uAAbI9HFHHNptwxxZdzcpyEjycwLvAvxGCzZEX0tjQSCDoAgtY8/+uRjYYPQKk/pK33GJLtR9yzHHRx+cwaiopp2/191Fh8/Ir+Z4zG2d5QEptUSitxY4CA8kbLw08HKEd6EkmMzJa7g0/GgHATJoX+4EcQ4E+k8gWbW7oVVAeg2MEvThS0RRnUZQEiI5yt33S2n+/uQRzD0VMUF+lJsvtYyTMaiOyZ55vXqflJlcFbE3yoqIjzJf6K1BsauL4EZS3kfTKaLfwLxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvcQs5qLrU5in+oRyqaqqedPuuiSJAyZl7IgwhgRMKA=;
 b=RGLvRdFhKHbMQsKHoZHIP1X7Xyct/y6DXK2IwC35euh75dRB4oXva1+Q8ASfKOr+FauDQDAFuu8jFM3n1zwuyYVxBP/tmU0lncg6vQ3HkJct/Mq2MLf+mCr2WOereRhJa5/f/nZwh8mXG1H6H9sHQuaEyDA+wOyIY6tE80GU2tPN3nONHp8GISK3/Ie0peVVIDnxD3fpLivxTGsUG/pYUuXsD3wyx+7m0/mj8o9J46tGRV/BeIyEssIT4OvCPrK4EJHP2qv+vw3JDyM5/OOapU1cJcN+xtTNL6prMYUnOu2fpV9b0WVZ47mHwDlK/aatjO8Gki9vOZ2LB5P9ROhctA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvcQs5qLrU5in+oRyqaqqedPuuiSJAyZl7IgwhgRMKA=;
 b=4VigqtqrOqWfN1I/nh84kIibbvWBTYanNYO/snCMHwnUfkejZ+/FL/U78cbxCHR3YY5zChyVH6E5CpQ/GUP+n7H4RAZvZ/EyDZTFZShzozrt+9s1BtMk6FWPVT7kAMkWMKKXW8c5pQgc3B0WnH9LcgU891HZtAPTfzERmbRtifM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2512.namprd12.prod.outlook.com (2603:10b6:802:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Mon, 5 Apr
 2021 14:31:14 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 14:31:14 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v11 12/13] x86/kvm: Add guest support for detecting and enabling SEV Live Migration feature.
Date:   Mon,  5 Apr 2021 14:31:04 +0000
Message-Id: <1acd3e6796b0ffcda880e92baccae4f148d38ce6.1617302792.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617302792.git.ashish.kalra@amd.com>
References: <cover.1617302792.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:806:20::10) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR03CA0005.namprd03.prod.outlook.com (2603:10b6:806:20::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Mon, 5 Apr 2021 14:31:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6df493da-7bb1-43f4-eeae-08d8f83f7749
X-MS-TrafficTypeDiagnostic: SN1PR12MB2512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2512B51FE8E0CD578E65C8908E779@SN1PR12MB2512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:257;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NJ8P02F2KQaXkCyN3XaWG3ArDkPUndTdZjX//NaVqJ7z9aHU7XTwumLLGt6NgEMo43K8xTi0vwb5TVqZkCMrGOsY4vI94vTTRB0XgmmHXy2JfYQdzGJz575jBhQu0hJaE2tzl5Aamxw7T5KXD/eTykuk6yPvtAlAKq7UXGiKCgI2tsXx5j/OYpuDQwxM+My8MHHvt5Bib5e95bxaa6q3spNXY2Ty2UBN45am05lffivCppGE5kLUZs0gqCQ7cXqUfxYrgI50n1Aa62ZNALb/yIDrayiTKWQ9cnwBPZH8Hp7SZ9hfeLt0Y7NAIsK3R1Xnx1aeeitOYdIWOc7zbO11QqsiqhvI847EyggFpQ7LNGtZknbwSmUZkgAe+Emfa/pCLw4oKQgHjhNdPWBlB/Awf+N9sW8m4d9WzeEBjitQHBIrvITsm+YjwTB+WSd/0KA/C1pisIXANVG+D9ds2Cc46+XvOIku8QVLv4Z5exzhtl3BbcRQwusceb8G8A9MYR9esT0R1m2ajYB/XGevSTZz4SrWrrNDMC+TT61wdXoKXbayALBcGZ8Py69vQx2p/Fdkmw8hm3gmZbYFCahporT1diFWp6dQCD3cgtPTDPtz1d53bP15HJAPvIs6x/nT6iXx9mhyODcJ3iJ57WE2Yq39RA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(396003)(136003)(376002)(38100700001)(8936002)(2616005)(36756003)(7696005)(52116002)(66476007)(66556008)(6486002)(7416002)(86362001)(6916009)(66946007)(6666004)(16526019)(186003)(5660300002)(83380400001)(2906002)(316002)(4326008)(8676002)(26005)(956004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?P2fH2FS9IzwoQe0zTu6PZUZQIVt1+txG50odZGVhyw9bnyVz7MJGOb8vJdWv?=
 =?us-ascii?Q?VwySaSQGPp2V+pBmYrdUi8itg0zAg2HYplJuhSfPNqtLnj5ylDBP0+M7g2HT?=
 =?us-ascii?Q?HYBekkUUAbfhwMYX9ldf+lndMV0LgI6xjWhDsHfHFihlN8QYSjuaKHGnV41B?=
 =?us-ascii?Q?xbOPlljFTEC1J2bBYe+jJqWz7AtgAiLCuIrmdLS/jL1DMnuZNPeYgH/faTT4?=
 =?us-ascii?Q?Spk7pLcGn+kuY/1DltGwjvBKdyqfFKbgK+M55YnD0M+0XI5vkY7BlQ/8Rvfb?=
 =?us-ascii?Q?dwhsNKXhjeMshNcEjFeZbEcz+kMJF85wnpAuKIk9E1rXWVKBchZLD+Qyu6AK?=
 =?us-ascii?Q?4CEnoit0pVorHm31IZz1IgnD7mKxkgRrW4oDjbtrA7TQuD2zcRS2/hpxjNFc?=
 =?us-ascii?Q?gn93SkwZE+yy/VR12LAyl1Uz7W7aQQhivtPIx7CR5jXH5b7RwWwuNCLvYw1J?=
 =?us-ascii?Q?8egSffceUfbjsKHBaMRjjoNbq6uIIn8+P/YdV3Ek4vUx8zIhNU/JRbYuOcZx?=
 =?us-ascii?Q?M78Zs+2uGZWWKLzTHB5xPkURnmUlDQxJgGCrHcoc4/liOjVjiVxhsRBPdZ7f?=
 =?us-ascii?Q?r/UvfRN9AVwU1UBEHJv9UZq/a3YwGKMJ5Pq6QZcNML36GIVLkTqwwSdxSCPl?=
 =?us-ascii?Q?pMOBO3xQLvUdEJkxENlghdfrxyW3TqYzjeDridfMzRchzxFbajtmOijjFezi?=
 =?us-ascii?Q?nPA11peFJk5bWjsHy7eGAjCYKTtbmml4HtXqDxM2EXIRq+Prf2N2Tb7DVQex?=
 =?us-ascii?Q?IgzVl5d6luF+pYM0OXh96UrOXT3p+NX4hVgx/vcviPuB29YNkW3OCzAY7Diw?=
 =?us-ascii?Q?ASnRPMrZifzi9zaJwHHPFxGK0jf1xZ8QjswZNhQRupuwXBPlpj8OzR35wwrN?=
 =?us-ascii?Q?wdV/X1MwRiGAfc/59Z5+hXM57lAdgtdPXaSfvMS0R2NMHPzkwfnN0ukH5qmN?=
 =?us-ascii?Q?sokg4RKilabj+eQ/2l8xow3KUWZQdbboepN4seWWhO1KOpaWDLacY6NVJ/O+?=
 =?us-ascii?Q?4jo3kff5A5XlszA/g42i9MqCGDoVeK/LNdCHJC5GX4wp3q2Dutju9LBcyoMN?=
 =?us-ascii?Q?QAtWtBRTGe8ccP36gRd61lpZdDUxUN5QJRpTYroNxI0Ky3is6tKldWrIpHef?=
 =?us-ascii?Q?kXlXxgsSHMSvwfZrcOFE70ZYb2woZGIIY0J0mVGNKGAZ7XbJs+0TKWsCThRn?=
 =?us-ascii?Q?qjgFSl6AoSkuXBx50PbAN2HsKn90uifcrcdpMoXYZdSWD0f3UeUB8KtnYTX9?=
 =?us-ascii?Q?j74C1T3FoCAzlx01Rz6jLOuiEK97RjyfrYe8jEGF4sCrbp/eaXSQ5zpLilei?=
 =?us-ascii?Q?TvSEE7Ht1BQ0SP2xAZZRk8Sp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6df493da-7bb1-43f4-eeae-08d8f83f7749
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 14:31:14.2396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yx8B/kpAyRjE0qlZTp4OuJqQ8zfpXepIJVE6sqnAoAYJv+vUomhARqWWGJm/Bg5xtm7yaiTsfegUoMT8gDgmMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2512
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

