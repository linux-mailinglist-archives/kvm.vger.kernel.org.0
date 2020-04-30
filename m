Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B731BF35B
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgD3Iq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:46:58 -0400
Received: from mail-co1nam11on2068.outbound.protection.outlook.com ([40.107.220.68]:20319
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726531AbgD3Iq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:46:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpyhZhbN/sReW7APNfNMNgHCfShIXZR31r/3nVKCsJ4qXNaAMbfnE5UiU+ZU317jfnnx4xX/r5biN4C8BJaDysqzmDtiudQGRcZV5e4HJOIP6pHlnx+w332lfgPDbueP1c7GZVGTfQTCJenJMf8ZY97Hukq3LkHyDfFUkHf/ANJx6+2bvGGryoOR8w1ikuCfm4beJSSMlLH+xBYZ6W3Lk7re33LYO73EvEWE7bhtt0tzijzKF6BOVm9SVbMZrPPawUGFVt8OIzFRBp66GJtaRRDQYDD4PBCbghq6niKDYDGHOrKyRScSmTERDBBAo2rWCGq84xXhR7LjV8+Vm1uBTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1aLjTSYiHLZkDpAoiK+ds5AKq9cbyq79KY5RaSvjxQ=;
 b=cx0nBXfTVU2Ll9uBWZxZ5pkxsV1T1oKwoTWXoTdTHCrtxj2nNjCP786g/Cl/PPaIeQ7uDj+LGNuue+n6n/TnsOO/cJkk8aNrcl6CuqITVJCMyK2OW/ysrvvJ6PzgpfcIw9wruSaBdDV35nVSC8RXwRWyXi7EliDXSd1rLS+lgD9LN0i0LQqFDS6OIOb+B9EZOmyxN+e5mW3xpyWERq7ibzyajeAg5MY6zSD7CxkIBLffJG5waIhAJHtEoe5obBZMWdFcQ3qgQqKFxdhceEq/I8ze98tm+kDndAXEnEGN/IhiCnpE0A8VuosiRZzKWcYpngkEGAbfh3Hq601sY8IuDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1aLjTSYiHLZkDpAoiK+ds5AKq9cbyq79KY5RaSvjxQ=;
 b=4HLEpFJ++KPTtLRH/dNfEKU/nq/Jhxnls4XDdE+yMPHhv94UqVIBzJz2FEMUvHfaBV28sjl5SyyTLiTP+w9Y4s+yt/CLGd5rci4vO3uR7ZfgpQzBQ+Y60Eeq2CYR2ogCzWdL3X3HPTRU3c1SyOzTaZxHNz96JhWreqUl+HfB9y8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1465.namprd12.prod.outlook.com (2603:10b6:4:7::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Thu, 30 Apr 2020 08:46:54 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:46:54 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v7 16/18] KVM: x86: Add guest support for detecting and enabling SEV Live Migration feature.
Date:   Thu, 30 Apr 2020 08:46:45 +0000
Message-Id: <42947fc3dc7a01c73677560c84dfd87498d381e0.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN6PR2101CA0025.namprd21.prod.outlook.com
 (2603:10b6:805:106::35) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR2101CA0025.namprd21.prod.outlook.com (2603:10b6:805:106::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.2 via Frontend Transport; Thu, 30 Apr 2020 08:46:53 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2d13ee51-2c35-4333-9caa-08d7ece308ab
X-MS-TrafficTypeDiagnostic: DM5PR12MB1465:|DM5PR12MB1465:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1465D74BB9352538637468DE8EAA0@DM5PR12MB1465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(376002)(136003)(346002)(7416002)(66946007)(26005)(36756003)(86362001)(66556008)(66476007)(5660300002)(478600001)(186003)(8936002)(2906002)(8676002)(16526019)(6916009)(7696005)(956004)(2616005)(52116002)(316002)(4326008)(6666004)(6486002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tIqkBRGUEJLOQuN0b8OJPgnk3NcgXxNZ9e59ZTXKeOSQ14Sb8wN0hFvj8MByoXlChW+QSRF0jhpggTDLbyREP7hvFHj18xEhLDIrG2sdWUe9q4A8t7gJ+pGeCtMKwvDdcq/U5gRYhgBSewBlFJp8Tb5OXzoPP/eyTacRC1snEJmmHhUzj8aVPwgjR+ol0HPJCJ1AdWDQAgn8MV8NgbzuFsbha3eJzNI8ZXERJbf/LvAys4JLhDQKlQ3vElR+1+0D2E9yeIoUkoiawbdM3BEn1Ce3Ch+tHwnyY75GTXUU4OjqBzOn44oH/sc6qhoZ+ZHS+kL7XYl4R2+DGzhGdgT2/pvWhoXyavl/ewppAkLCLSryNBdiL4AEE9RJxTtBdGJOlaToLXm3gQvVJZtw3szjjpsl9dQVD1KlyW43wA/UVg7tXX4kPV3vYku3w+fKCNapC4RLyQMZBmnQODCppuldY2M+bVkGFA0M0sRpYYDQWxbFyP2jfHftp6n5sGPOyrI/
X-MS-Exchange-AntiSpam-MessageData: xKvklJk5e56s97igKE50DP0w3+2IzLYrFMz6uRhtaU2eLjYPHyTaZvgW5TTYVRkDZ4n/stQHIe7rOV2ZTk49Jc25N9dy87Ig55JII7I3nOKAmSqCDlz4darSdSrI3wdFTKyYMT0wFNa2vh/IuG8uHXzsZhisLjP2kAp6qzJQB3L4FlkCo5Fmm7YAea32HNEBOg2qwnjXAM2X7dtG2bplFMgRwYCfDdBOoGlcKRroDGj+2O3IOoTgH4a3Mv6Ju99qW2+jzkqQuL4LUbzh1z5WpYhwQMVbPi3nYooz5q+5JpWSSYGEEfGO3DLb+wDa/GJDS5qVpdiHwGQVfFTsRUG6M7M/QCjkDDe0hJrN/pEfclJ6xDH/ZRRyXMRYTwIIO7N9dWgJKzo4qm7Z7HpqUfuqJIU9x28Gr3YvKulLmCms0cEeWQ6X2Vzku+G8lCOx09V40PkAG/kFv1ku2TTJv0IR7ClaoRB46rYa2qz8pWG1Xrm2YJZvRE8ApAbUSGCaKssx8egufICCJoS8zobW8CTDcgxDfQ8T5nTLkdqKU6mYBKBahYSvD8wYDlLDUFXNTKlEgc766CwTuQbnI8cMni69BEyksMcBKFMw7dtrZ490dxgyucrUhocxVYV6dExmZkQl+B47yaWqCK6SPZDjI8Ghf1dzssuMiw3ai0pGuHqF4LcQ5wRZUZmGhX+cxoLpSORvMnI6CF2O4dLjbSnNxbNYESQT7rrgtQ95TJl9H4wgxyc7YRqY9Xb/eqknIEvfRZZkRjXxYQWOIcMarY2HlHWfSokzFeTTFApMvHYQFWqYTE0=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d13ee51-2c35-4333-9caa-08d7ece308ab
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:46:54.5309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I5YcWq0OTTropECMlhr3/JT81jVcFtVU7p11wb9ORlmmMY8Eqx9BZWIAMicwQV/aEMK6XLbF4/h9hK2txVg2gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1465
Sender: kvm-owner@vger.kernel.org
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
index 848ce43b9040..d10e92ae5ca1 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -20,6 +20,7 @@
 
 extern u64 sme_me_mask;
 extern bool sev_enabled;
+extern bool sev_live_mig_enabled;
 
 void sme_encrypt_execute(unsigned long encrypted_kernel_vaddr,
 			 unsigned long decrypted_kernel_vaddr,
@@ -42,6 +43,8 @@ void __init sme_enable(struct boot_params *bp);
 
 int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
 int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
+					    bool enc);
 
 /* Architecture __weak replacement functions */
 void __init mem_encrypt_init(void);
@@ -55,6 +58,7 @@ bool sev_active(void);
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 #define sme_me_mask	0ULL
+#define sev_live_mig_enabled	false
 
 static inline void __init sme_early_encrypt(resource_size_t paddr,
 					    unsigned long size) { }
@@ -76,6 +80,8 @@ static inline int __init
 early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
 static inline int __init
 early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
+static inline void __init
+early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
 
 #define __bss_decrypted
 
@@ -102,6 +108,11 @@ static inline u64 sme_get_me_mask(void)
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
index 928ddb8a8cfc..8b8cc87a3461 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -24,6 +24,7 @@
 #include <linux/debugfs.h>
 #include <linux/nmi.h>
 #include <linux/swait.h>
+#include <linux/efi.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -403,6 +404,53 @@ static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
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
@@ -725,6 +773,20 @@ static void __init kvm_apic_init(void)
 
 static void __init kvm_init_platform(void)
 {
+	if (sev_active() &&
+	    kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
+
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
+
 	kvmclock_init();
 	x86_platform.apic_post_init = kvm_apic_init;
 }
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 603f5abf8a78..3964f5de058c 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -46,6 +46,8 @@ EXPORT_SYMBOL_GPL(sev_enable_key);
 
 bool sev_enabled __section(.data);
 
+bool sev_live_mig_enabled __section(.data);
+
 /* Buffer used for early in-place encryption by BSP, no locking needed */
 static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
 
@@ -204,6 +206,9 @@ static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
 	unsigned long sz = npages << PAGE_SHIFT;
 	unsigned long vaddr_end, vaddr_next;
 
+	if (!sev_live_migration_enabled())
+		return;
+
 	vaddr_end = vaddr + sz;
 
 	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
@@ -375,6 +380,12 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
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

