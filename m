Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FED8368850
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 22:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239400AbhDVU5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 16:57:46 -0400
Received: from mail-eopbgr680056.outbound.protection.outlook.com ([40.107.68.56]:4846
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236851AbhDVU5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 16:57:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5nWpWHry7HyDa7mLjXaKsqXySnnn+Y9XfwAqcDT9JoNRg8mDU5Ja1NhKu60ri/7Sim7l9Rv12IMmGYi7x8ouEWVxVO1mPaE6Y4sDapTpN0nAVU4TXocBoRBtSZGPSGJ4suXqxbhq16UZVlTN45o25OUCphXA/yBHpN5mhmVae0eJSlNi9ZgpHjkPu/54PiVu80Px14TNXN3xRYCFAhqH8YWRIxycmDep4Z2hDuLMwzU81pTkeRmHljs6hzBE0GEpUR0rONEbDB3KnaccGiE8phe2J3NF+d4MztojjfgU7Xp0PtGq4P9yfXDCT2bgSF2XXGmrg26+l5Kg1z9clDK9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T43XMQxcjTRanl7RjRTeaaoKed3PlEQ8eSjDbix8YVM=;
 b=Bh9aECHpgOHeDFjBA11ysd8+xyBq1ll9Dd6ixE5JfpuMECU9yPTJ5GgPVhk7/pyMw5rAAmkMcT9vBYBCxN6MMM84tY/JyCk1vP6X4k2bOOJAeT7ngkooEBEQ/NNqhy3hSTLCi4ZqzmKVaABQBfALm4mGNnOjORzJSXB4LQxVo5SoVZ5SXF83XdzfukRH/eruna31erlK3oF1ACDR1zw3VP4OgKS+LwyHa/WOTku0tQttwa8x5h9jHZyb8saIZ1nScojfkQsfFnL3cZ5A1wdoVntSxbS1GeeToSWIw/wjCKQpsH7snGoqmq2e9nnferjzVLGMYxKJcYFGyj3CmpYr1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T43XMQxcjTRanl7RjRTeaaoKed3PlEQ8eSjDbix8YVM=;
 b=cSykLrt+bwDNc9Rmr9W7YKAzztXKYg7bbzIIB7Rfsahz67l8FormubxRzscCvKLgV9WDaIQ1QfPRMvOksbrgsP1HtC5ckOevrXbZK/xopLrPclzE624H5Y5fIc27Bk/FfLVSj84o4wcK/33U7M5oI3MCQnrtK4vCs+Asyku2Duo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 22 Apr
 2021 20:57:07 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%7]) with mapi id 15.20.4065.021; Thu, 22 Apr 2021
 20:57:07 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH 4/4] x86/kvm: Add guest support for detecting and enabling SEV Live Migration feature.
Date:   Thu, 22 Apr 2021 20:56:57 +0000
Message-Id: <8c69ca218ab223916dfac7e773d0329030e16f95.1619124613.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1619124613.git.ashish.kalra@amd.com>
References: <cover.1619124613.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR01CA0024.prod.exchangelabs.com (2603:10b6:805:b6::37)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR01CA0024.prod.exchangelabs.com (2603:10b6:805:b6::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Thu, 22 Apr 2021 20:57:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2e0708c-3b2f-4d10-9b03-08d905d130da
X-MS-TrafficTypeDiagnostic: SA0PR12MB4510:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45105BD6049A8F19C8AEB30D8E469@SA0PR12MB4510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:305;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OchIQLZlPfQYtxnREynBsU7UMwznz5PT8Ol/FPLm8JlQJ5IxPrSha3o1/W1oNYwRr+G3K7hZJR18Tt2Wi95X5nHbgagqmE+F991dMeFXvxxltuswiA5/Czy43wkF+x003oEMH7res+TjIjcYE+UoIP04BjNYa+wEHFWhH65/0bVUvSJzbQIwZ6YgVI08bKtk418GTEIAOfmLNckoIHwOhAE9JReFTSsuWuI4c9keOSVXCQygPj1Xft7EKGkkXoidwQqfc6ygWGPsqYZx59AOACSWLBmKuEE0TUBCP+dE4w+gx6PswVKJwxJrmaZF4/HTBrEdxwvKjsUbPnY2mFzDo3mE3JDP8SxEo/zRBuqD5DZkkOxdNY1GOjHcrhb7nJ9u8Geb/29xXfM5Nlo/hsleaPLCZXQnaAP5tgxE/xxTgvmCZ8eiXECKzSYyMKoOsyuqJ65yZRn2iDKuMF3XAk74rmqKfvdXckqZyeOcUJQT9i2KgpZCUYvGzb5Yg7m1jW6CNBJj/JfIVuGY3aCQ4lUqqr/PFBAUdXxwM9Q8IcgqXfksBz6vm+eCAQGa+9bvVwU1vF8BCxuV9vXyZ7RHjQYO76yA8SWwOtYPJqVkUJ9TUaTGMGzirwt8fNg6nQLrVvAYhXLG+uq2MtKFmw+PxoaGEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(316002)(7696005)(6666004)(86362001)(2906002)(52116002)(66946007)(66556008)(956004)(8936002)(38350700002)(4326008)(6486002)(5660300002)(66476007)(36756003)(6916009)(38100700002)(186003)(7416002)(2616005)(26005)(16526019)(478600001)(83380400001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mphqHatjEG56tmUo5gRqLwvJHgq6euZ5/tXPR1AVYw3NqNuCVw+59kVW56Ee?=
 =?us-ascii?Q?RcQyBs+kYVGYH4uwAFjWX5IFwodgog4iDkMf7n9lP0068+k4RrRKnnNY7Sye?=
 =?us-ascii?Q?1Ko/4/eLmuz77HPWgtD4OBGtyfQH/hyerHhSoQ12tVQ6vY5io3ks9ey2ldlA?=
 =?us-ascii?Q?DLx501zyYYqFZ7uwmmCmDm5Ajczgf0IH/y4zThsTg9AifA9SneFUBi31in37?=
 =?us-ascii?Q?f4AY6o+yhQqlgH8tkEG/rAfWIhtFcirW973ze6XxzwQQdw3xdLzsa3AbbE7t?=
 =?us-ascii?Q?fjmtUvfhoNwDcvu7mRFESCUJpplaHqxA3CiI21ng6zC9gwQAjBzocegWyz6t?=
 =?us-ascii?Q?6vWd+Q1ijFwtbPDtM6eGf6ThWoBosas8kBXgbwM9wALFPqnTHEQrk3TIvfgY?=
 =?us-ascii?Q?jZuFjvHWhExhQN6kLAu24zTl/JxCNTu6H0XhrBdw7nIIpTYUhSQOef60Hq2J?=
 =?us-ascii?Q?6cjwMCRHGApqG6aFdDSkC67XrI6ExyL1rjPu58TE8Oap9ZSsrp8qTRmjlJ01?=
 =?us-ascii?Q?lAXCxjPvc7WpnPvoCM9iqAIltKoYGtQYldnCb9UvIn2pfP0107X5ZO0qS45G?=
 =?us-ascii?Q?Z3Om3OWWD5FMGTNb2JwsI+f8AznFH5Ow01nHpwZcfWSVQx2HkcVcoQb5dIE1?=
 =?us-ascii?Q?AhodlMH/7MAoSGCF5qYcztHTuNxCSMvRz7M11JjfSXCUMyjyfuzhERIidFe1?=
 =?us-ascii?Q?IYU8+mYtc3BP38SVw4i1/BOL8EGHzOF1py+gSFKv8aSCZBH6z3tNH9t2zen2?=
 =?us-ascii?Q?e17nWJut9z8UWUZ+AnR2xhst4Zt+sEyhrtvJ7MtI2NLTmIi3fUn+Qmd2AuY2?=
 =?us-ascii?Q?+FWbbpAvdHY3D8Cruup4iKx5JELqwWLbWomlwW0jPmTtQdaXesTwz++JvIX8?=
 =?us-ascii?Q?Ux3gU5d8sNT59XKCdLtBRLy8nJwb9ej4rJc9dkbhn+2XdgaaeB5jod50pU3I?=
 =?us-ascii?Q?mU5MsgUZwqjGI8xMxJrTWJstQpc+zsRu45Zmi8qvxdpFOXI84w0/gYLVhPWQ?=
 =?us-ascii?Q?0Wocd5y/iY/uuaVSmGUHVEDcSVemvADqjsxpZhYeRpdH+4ta1pYkKo66PO0I?=
 =?us-ascii?Q?B+7AX2zPIgXgvO4Qt+FtzTmXVAY3iN3HQncwUY2eEv1rKye5g95wBWl4KcAS?=
 =?us-ascii?Q?SSTt4w466EuU9Hy2RovTYTdZkVpKYhB0upJ+HkJDFJ/B3CkMYO7818iUG0gl?=
 =?us-ascii?Q?qpB+za32Un7p6IhAyE3Oj4iuJdC/6GvQcZrVjN4RAHRGAPZlVxkuE7VtBZkU?=
 =?us-ascii?Q?8S1M6eaPuh2HMapxFWrKj8BzAfOicdQetipg3JKtmYKzKbc47jP9fa06rfUr?=
 =?us-ascii?Q?H8JOkytatXwceQFca5shVBhg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2e0708c-3b2f-4d10-9b03-08d905d130da
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 20:57:07.6501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MPT5z1Zvm0+qz64kBjmQHiU+abzn64QHw2t1XNkZKA5PzsCgYKF/x53e/yAS9sWKoo+6zFQ4n9FF50jfEJneRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4510
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

The guest support for detecting and enabling SEV Live migration
feature uses the following logic :

 - kvm_init_plaform() checks if its booted under the EFI

   - If not EFI,

     i) if kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL), issue a wrmsrl()
         to enable the SEV live migration support

   - If EFI,

     i) If kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL), read
        the UEFI variable which indicates OVMF support for live migration

     ii) the variable indicates live migration is supported, issue a wrmsrl() to
          enable the SEV live migration support

The EFI live migration check is done using a late_initcall() callback.

Also, ensure that _bss_decrypted section is marked as decrypted in the
shared pages list.

Also adds kexec support for SEV Live Migration.

Reset the host's shared pages list related to kernel
specific page encryption status settings before we load a
new kernel by kexec. We cannot reset the complete
shared pages list here as we need to retain the
UEFI/OVMF firmware specific settings.

The host's shared pages list is maintained for the
guest to keep track of all unencrypted guest memory regions,
therefore we need to explicitly mark all shared pages as
encrypted again before rebooting into the new guest kernel.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/mem_encrypt.h |   4 ++
 arch/x86/kernel/kvm.c              | 106 +++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c          |   6 ++
 3 files changed, 116 insertions(+)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 31c4df123aa0..776e3378a782 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -44,6 +44,8 @@ void __init sme_enable(struct boot_params *bp);
 
 int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
 int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
+					    bool enc);
 
 void __init mem_encrypt_free_decrypted_mem(void);
 
@@ -84,6 +86,8 @@ static inline int __init
 early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
 static inline int __init
 early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
+static inline void __init
+early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
 
 static inline void mem_encrypt_free_decrypted_mem(void) { }
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 224a7a1ed6c3..85f991135daa 100644
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
@@ -38,6 +39,7 @@
 #include <asm/cpuidle_haltpoll.h>
 #include <asm/ptrace.h>
 #include <asm/svm.h>
+#include <asm/e820/api.h>
 
 DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
 
@@ -383,6 +385,8 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
 	 */
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
 		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
+	if (kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL))
+		wrmsrl(MSR_KVM_MIGRATION_CONTROL, 0);
 	kvm_pv_disable_apf();
 	kvm_disable_steal_time();
 }
@@ -429,6 +433,55 @@ static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
 	early_set_memory_decrypted((unsigned long) ptr, size);
 }
 
+static int __init setup_efi_kvm_sev_migration(void)
+{
+	efi_char16_t efi_sev_live_migration_enabled[] = L"SevLiveMigrationEnabled";
+	efi_guid_t efi_variable_guid = MEM_ENCRYPT_GUID;
+	efi_status_t status;
+	unsigned long size;
+	bool enabled;
+
+	if (!sev_active() ||
+	    !kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL))
+		return 0;
+
+	if (!efi_enabled(EFI_BOOT))
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
+	wrmsrl(MSR_KVM_MIGRATION_CONTROL, KVM_PAGE_ENC_STATUS_UPTODATE);
+
+	return true;
+}
+
+late_initcall(setup_efi_kvm_sev_migration);
+
 /*
  * Iterate through all possible CPUs and map the memory region pointed
  * by apf_reason, steal_time and kvm_apic_eoi as decrypted at once.
@@ -763,8 +816,61 @@ static bool __init kvm_msi_ext_dest_id(void)
 	return kvm_para_has_feature(KVM_FEATURE_MSI_EXT_DEST_ID);
 }
 
+static void kvm_sev_hc_page_enc_status(unsigned long pfn, int npages, bool enc)
+{
+	kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS, pfn << PAGE_SHIFT, npages,
+			   enc);
+}
+
 static void __init kvm_init_platform(void)
 {
+	if (sev_active() &&
+	    kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL)) {
+		unsigned long nr_pages;
+		int i;
+
+		pv_ops.mmu.notify_page_enc_status_changed =
+			kvm_sev_hc_page_enc_status;
+
+		/*
+		 * Reset the host's shared pages list related to kernel
+		 * specific page encryption status settings before we load a
+		 * new kernel by kexec. Reset the page encryption status
+		 * during early boot intead of just before kexec to avoid SMP
+		 * races during kvm_pv_guest_cpu_reboot().
+		 * NOTE: We cannot reset the complete shared pages list
+		 * here as we need to retain the UEFI/OVMF firmware
+		 * specific settings.
+		 */
+
+		for (i = 0; i < e820_table->nr_entries; i++) {
+			struct e820_entry *entry = &e820_table->entries[i];
+
+			if (entry->type != E820_TYPE_RAM)
+				continue;
+
+			nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
+
+			kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS, entry->addr,
+					   nr_pages, 1);
+		}
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
+			wrmsrl(MSR_KVM_MIGRATION_CONTROL,
+			       KVM_PAGE_ENC_STATUS_UPTODATE);
+	}
 	kvmclock_init();
 	x86_platform.apic_post_init = kvm_apic_init;
 }
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index e4b94099645b..5294e7057ce1 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -409,6 +409,12 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
 	return early_set_memory_enc_dec(vaddr, size, true);
 }
 
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
+					bool enc)
+{
+	notify_addr_enc_status_changed(vaddr, npages, enc);
+}
+
 /*
  * SME and SEV are very similar but they are not the same, so there are
  * times that the kernel will need to distinguish between SME and SEV. The
-- 
2.17.1

