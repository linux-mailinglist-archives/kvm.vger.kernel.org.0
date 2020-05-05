Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4B91C62EE
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbgEEVUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:20:45 -0400
Received: from mail-bn8nam12on2084.outbound.protection.outlook.com ([40.107.237.84]:6247
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728135AbgEEVUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:20:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdS3cMRwWFeoFT9fp1MjtBdtg1JHb/MTTS3A/q4MSEeRh2buHTpvCHniwIpXgFUIRIicq4EwUsKoawaTXZxe3aVrDKfNcgo2GXXvcjqU2/H/6gYogfbK3noUCoiecOlrbF5cks1Is9c4tXP76BDB15F0yd8dwnvAY0DOkcYAIfcC3ukPUCALhuMK+uvY9yG6D/d2dBxTifZ5u5cqJCSVD81fwh7mq117ddYq8HfxKyoDBLjI3SghPTJvo2MIPd190mTABFHTw7svyhc3i5QMRZYYpjipshUNjISBNCUjgNMtWwDJ82t4pJTF/d4XcHc8bxtkqgxVtDf+AEr4flWmMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6M75aJ86EErmULkq3AISRtesIH5UXicdvxN1tkBGDs=;
 b=Z9bb3546wBUnqSJv57RSzifbzUm72GaFQFS05h77oEDS2ct23hFxIywKIZHQyQL9u3YLXo3do+3FO0A2ycM4V3oyW6Omfhd6dwdc/YeU4DRxnYTDzMBhFwXfEisrwsTNTce1obb2nzhoDvt56X5/bpJb7OuKTer62GbozIESYHDSvgeAz2u9sHIIKcDDGtN8JORhxaayWP4M4bFj2MyAwn7hR6B7nsJkKPjQJXgIJ++vq+oJNFi3AB+8QOWfe8iAg+GmBFHW1jR774ggs/eAPPcKQqRYJgxHWkih1Q0tqgZaO0acKl+plL2NYlCD66z54waZEiZK3GqXJNP7qkXVWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6M75aJ86EErmULkq3AISRtesIH5UXicdvxN1tkBGDs=;
 b=MMjWJGPa/RYV+vNzkuZhLofd+qWflUu8KtWHsS58+Xx++BA77O79flxbhMhcj9mAdNXxmr2viaMAaZI2wC0hrX2Gz233WzSDzMGgeSphmpH1gFIrSgxa8iydw9wSGSWy7pYBEVdWQkesu99zmXYGkBZdOpos/1OQleME03dm1V8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:20:39 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:20:39 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v8 15/18] KVM: x86: Add guest support for detecting and enabling SEV Live Migration feature.
Date:   Tue,  5 May 2020 21:20:30 +0000
Message-Id: <939af9274e47bb106f49b0154fd4222dd23e7f6d.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN6PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:805:66::36) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR08CA0023.namprd08.prod.outlook.com (2603:10b6:805:66::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 5 May 2020 21:20:38 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b82027a6-4795-4a34-29cb-08d7f13a28f7
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB251872FD09DE1C197C1970ED8EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GwfynD9ZxxFFsPZNaQIttXFc2CXsBtAqlHIr0H4+wXOLyyR3gbbaN8taJ4DmBxCCdnff2xzvNvzVV2K3ndpx3E6fROdI3qmAmLyT1MAfP0BZtGwaCxNwF7UvvA9QB9+zUaV0VUcVDvRhwwGWJUucj/XRwXtfCmxUR5RT922OizKlHoQGXWaZIVxlkBy26MXDOz6n95VRFeI2QrrFn+c/kqk4Vmtcg7zjFV49lcT4LrcyAfcsUDHjklc2tNPTwAe4wfaAw3KNrW6NOM33oEPsCo8kgnRtP7D7ruKrslo1GOoEUXMxvtooFSHxA9R6LGkLJTlTUtnGo+D2oUZbS2N1rZygMEUH4eLVWqaGr/5/owF5RwfsoF9+WHlwNkRiPzaiPwtsulTDsrtFwYNR3oZYvdamaMwITDiJCD8SNJg1ljwcvKIjqmcv5Zlf5ljU0DQ2F6ySkoYEnyjbAeumS/x6Nr4bxKYgfr6wiMKqil7oKMePwajfV75i/no1KOiUoTUgkvEnOMQtSlN7VoinGGti/eQ+3JofiBFEnaL2YUoVc4YO81w1Ocf1ioMXzaOpPLvy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(33430700001)(86362001)(8676002)(66556008)(7696005)(66476007)(52116002)(8936002)(7416002)(4326008)(33440700001)(316002)(66946007)(16526019)(478600001)(6486002)(6916009)(26005)(36756003)(956004)(5660300002)(2906002)(6666004)(186003)(2616005)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uECiuVQgKZaTuDoSnZwyxp1ldpTShRBnnaS1QUIUAYnUYZ1x0rOWQVOTeFyfTotxh+pH0lFc1T+NDLKqfVSTKl2fP1klzP0PBsAmX0Ngd6SpD+BXhxDqKFkRNRuqoZRB/Ia1nGitAbMdIErc0HmY/Zk0kKDYOP+HotYUrwotC5Rt0PzZl8J2B2mL7sWz6FpTKlCt0myL/11XWu+YvxMeY95yymblgvKIBHaCykrX+43ODhrVoWws0JRbaRO5TDep6l+G6xoueLtWpsT+lwWHR+JNUg9ChSasU9s1uh2OjxcGECziYj7NYmwyCNkm82qaDBGXPS6jb8wll8qKWwZvUjiYEb5Br9VMV1KDhkwPxaF8qpMA6nHoqSok6TOpkPkD3vCcqTkB1udhiyrh/JgQkngDiXfzXhYFToygYejX4i/pNe1u8ZGuKZK/FXpHakin++JNgWl7YXvruZDOEXS0WfSS0Lw9ZgLr1C9I8a7KWX7+DvjMa6Yjh0F98pTCr7iTUdjTt5PvJy18f9vEbhyZ5CpXaJdCVjbxMNpfwm/znoboshAF8pFJn5kzGmTFgu8vq9R2ZKkMFQcMGoq3FSCiu3Tv6ZTZe3ISxJ/Qk1/HwCTMEhUL6CE/pjPhqGFkVFDhLQb0T7DcI8HERN1oHOda8bN1Q56yC1AWje5ajzlwgwONsU0lC9kDhMsEV147abVaHnLb00ZdLwYGYEU0DdAbCWq8L9dn5qoitsbLSXfcPF/vivZclYcVL9+MI7QfzY1/CnwupYjxsCNqr7FSRf9wnBEFHS0wN5Q3Gztup3mVuxA=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b82027a6-4795-4a34-29cb-08d7f13a28f7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:20:39.6017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HS5uepFN0whSzchPKLYB1r+tsQ9OvzjvBhu6jBF+QBkxdRldETiQYW2mlX/v2RRoi6nua2GNOHWSeyo5kdbBBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
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
index 6efe0410fb72..4b29815de873 100644
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
index c9800fa811f6..f54be71bc75f 100644
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
@@ -374,6 +379,12 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
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

