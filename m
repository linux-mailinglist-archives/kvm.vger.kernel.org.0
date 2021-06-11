Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763C23A4416
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 16:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhFKOcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 10:32:22 -0400
Received: from mail-mw2nam10on2079.outbound.protection.outlook.com ([40.107.94.79]:29568
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229722AbhFKOcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 10:32:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XY28NNk5l/YLtZrVpjGIa9vW6BYDDh3MuPB9okgsszeCl/9E18K/87rExlvsxpEmTnRBUqI9lb0xKJoyqAKcsO1r5IsNUIc3ewF0ao0Z190k+Nt+lJY0v4yX4sRPka2+/G5OmpVlen+e2WDBsbTZ1MupBeCOgT8ZUeze/IFz3KV1E69nJkxeyz0AxbHLtfvZpQ2RSGBsVu0Rb8ku4GjRc4YPGMDPCqpgMciWlkl+cmBXYXyw21MP405a2DLR5mTNMtUUEIwRe5v8MuDOp/jhqrYjiE2qJV9K+FzxvtgSYsvWrjPnJFDrHj/omZKHvJ+54Wkjl1cNgrx6QaIcbTtl0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vE4UZQZslmQgUTYowq8clRL/j9I5zIf8ptmTi1JEh38=;
 b=KiI577KfGReEPMlEA6u1G3AS/K4By6dpbhehTshexdNxyWVdpXmy8ZZ3QgETqnOTppgEXbr8loXHFv39wqEl0hGCh1F79gFh1hETYPx8BR9u2O7jyq2/lXCzXS8i1bZKxQsq60y/qvgJRSMKFecCn84LdunCWWQwsJTSlXpIHbuiF8jNu9DEKPYQQYQEEjcPTklDklreYr6IxQsN9caIfDozdqhL122ORlvrwUd/sDpKjfC2atRHSYbJIqHnblgX+A3ULp0EuSCiEKWSA4FK1dcrckpqJ4LL28vuMP9Nkj2kppgzOU298/UHO5AgeXD0pnUz/XQRBkkJ9poxFgiJAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vE4UZQZslmQgUTYowq8clRL/j9I5zIf8ptmTi1JEh38=;
 b=QfZEoPQGODNgT4/0uWJybPwaqXSsdhDj+FNDfqdUj4VSRBiiWpmMKse7Uutm+uG65nub4eSZBHSHFQf9AD0rZgKvgt3KxooRTBZ1TStXG0Z/0ik3ZAlI8uJm/sBVl8OnRUJlKYjbRpQOvcCvX78+fR65Z9DUyE4WQ8PVovs7X0E=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2687.namprd12.prod.outlook.com (2603:10b6:805:73::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 11 Jun
 2021 14:30:21 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::958d:2e44:518c:744c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::958d:2e44:518c:744c%7]) with mapi id 15.20.4219.024; Fri, 11 Jun 2021
 14:30:21 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        Thomas.Lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com
Subject: [PATCH v4 5/5] x86/kvm: Add guest support for detecting and enabling SEV Live Migration feature.
Date:   Fri, 11 Jun 2021 14:30:11 +0000
Message-Id: <8c581834c77284d5b9465b3388f07fa100f9fc4e.1623421410.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1623421410.git.ashish.kalra@amd.com>
References: <cover.1623421410.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN1PR12CA0076.namprd12.prod.outlook.com
 (2603:10b6:802:20::47) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN1PR12CA0076.namprd12.prod.outlook.com (2603:10b6:802:20::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Fri, 11 Jun 2021 14:30:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5072b8df-d18c-4d61-29eb-08d92ce5717e
X-MS-TrafficTypeDiagnostic: SN6PR12MB2687:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2687C4493C401E60F437EA048E349@SN6PR12MB2687.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:252;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: azZgKOfyKKt0EmDFPl98WTG3fIkfB+NPFrwPqdbZ43kr1W8DO6RLw0icCnLVZ3j5+dOFfVEqF4ZdmYBlQEgBu0qNeeeW+xvfpgAowEwoitReRD1Brpy81YBSbNtfHRwKv7IJr7sWE9hD+wbqkBplxuPboT4OATwerOES8cxRILHOt3CfzfIdeRtomhyXY8L6ZcBglumeFwdU7h4DoKk5zvjj0AvS7nMa72MSGyPE/rgXCGs5tHtnSuhxR3g27qnR14AEnUbR1rNxfHGgdntzb/mD786m1tTpb6cxTaSaR1OlSi9dQ5BmFTmTfzVd8URIKdYoIkzUsse3+3nxXuyeNT7XZ1j3EnV/g4ogCMpj7utrBzc+ACPjR9DhiT1gOT6sT1O6GECptIlwGgC4V+M00PELN5tdSdsXcS4pbs0Ki+0LSHoQHQU0kO73Hz8ybt+yDnwSbwX0DQ9hBeda6cYLgXOh1CRJ4a4YZddbuvjWBP7Z66pJWV4mWl00j2S+soPI+2dFM2mTZc8dR8bIehOMrgPavCBzGVAe70d1bkt6apE++3cw9THGBJnp2t5EOvHTtNR1t6cPEcAHfS8I19uzx8NUeBnTOWeLdgMQcB49d1Lzg8+hVisqOrt5x9hdiDhAz5G/IL8jwWiLjyNVpXJUYqnMR54u/FVVdDBuMGs3U9Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(8936002)(2906002)(66556008)(956004)(6486002)(186003)(66476007)(16526019)(6916009)(36756003)(316002)(66946007)(5660300002)(2616005)(26005)(7696005)(52116002)(6666004)(86362001)(8676002)(7416002)(83380400001)(4326008)(478600001)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0dDq3xgClnbj03UsE3iLEoGIO5CoBTZ4TwboXn5tM62DRQj4hWxfMcNaVfIi?=
 =?us-ascii?Q?cPrE5Awiu9PDjzFCNlPKb6WAR3alu4keT+xZ9WYD3s/aCiZJTPclzPl5182B?=
 =?us-ascii?Q?qfamTQeRgtyb4DMP8F9Rbz53V2CDzpMFFGwpT6/1hEOqXRZ0S1uITPnPGnoW?=
 =?us-ascii?Q?frEolEF5pQDn+Yb8HzoRKR9j4lqIKhyo8CHZ6rvJ9MDWPYwJXa/wDM2G+9TM?=
 =?us-ascii?Q?YLsiX5sZ1eKoub7G+Wl+QW7tmIluibfOINixMXGbdYq2jU4AOCQyTn4a603r?=
 =?us-ascii?Q?Ig8zPqfjilN2DtYvlonYq0FYkqXUFF1fba9ZuZpEtftSJ9rnxWTIMKMnctSY?=
 =?us-ascii?Q?equueArwodRtpcrBLay8nw4Tw5fmVNpfGttE9InFdmSN/0svELGvOrsDsS5W?=
 =?us-ascii?Q?pLy9xYT9mLFPYQVm9cs9tI4l9gMC6o+hbae3pbg8LFjD35YWjFeoE5+qev6j?=
 =?us-ascii?Q?n4wBAG5YrN+RKp9qVzPgvyKHWpdUbGbsrKrB+AVdiEp12NePwOWDLUQrVWfT?=
 =?us-ascii?Q?eSHP8SU4p8uGuGg9Fls0EQbb+RdYzrLF7HOfxuky1lgx8uoU9WhgZIABCUQv?=
 =?us-ascii?Q?iy0RGQf2X1nr9BEnoPb6Hs3DnE6yOQeQLiimVxxq4XlU1Fb4RyMhKHfBsuyR?=
 =?us-ascii?Q?1s9XE7PdK/5YCJL+QdlstbvgEJasPIW4FB7bpS9koWR1gsyfkglGxAs8Dmu0?=
 =?us-ascii?Q?e4I9+zjthHHVcxXvDwsqCIVI8Ldv7e2dVIy9Dtx4ae/eVfiL+PDKkB2hbPf+?=
 =?us-ascii?Q?5d9w/MNzXr4rTKrxG8fGle69h3EPhrbe8StRb/MoJ1hcplRAk9sZKFBXHIWf?=
 =?us-ascii?Q?26fzmGBd+GJRgLmJrHN0Cqwds5usfgxtKy6mM75wHrBwyuN1BeKBQzStkBpu?=
 =?us-ascii?Q?yRwb5f3PfemIjexWyVNyU7WjKu4rSHyw+uN25Vr5Li0zTsgG0d3aoDEUph7h?=
 =?us-ascii?Q?/omrOq+p5DmZkZZI0c5qHB8K50oufNsrwhocNzs39X3qGMyBHAxxEbNFjfaR?=
 =?us-ascii?Q?NyyYr4snzF61OdVd0hriFFTAfcFG3+Hw1IHQwM+OQOACiLFdwbCaTtQbA9gY?=
 =?us-ascii?Q?DjcyVktoEbn36JeZUl3fyvvbSPk8v3BFVN0hTWY9wGpCjhxsSNTx5NuQP4+Q?=
 =?us-ascii?Q?vA9J8uMrJt2gRc+G9EHkhRINWBeIABqsj/jXpYteh1ceGSsicWv07ji+grxE?=
 =?us-ascii?Q?68TctMAQyUZTheVAuxnanPgqJIqlPzAuVDd0XTfY7p6qsgw/XSnF61C0yFw+?=
 =?us-ascii?Q?C8wgokx9yh3nqQuIcwtjO701Qm43R36IUdDBw88Ga84MXhofzfYm8aHhDsni?=
 =?us-ascii?Q?/BWQW/X/3irRkdgMHHwj8J6d?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5072b8df-d18c-4d61-29eb-08d92ce5717e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2021 14:30:21.4211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XcI7CwZ3KBSbuR2pWCIf2CFGJ3bugkd58tqWqgCgtLDOpdrqgTfN992slTORuy8CKgqxIFJrsUadueWn4kRS9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2687
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
 arch/x86/kernel/kvm.c              | 107 +++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c          |   5 ++
 3 files changed, 116 insertions(+)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 9c80c68d75b5..8dd373cc8b66 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -43,6 +43,8 @@ void __init sme_enable(struct boot_params *bp);
 
 int __init early_set_memory_decrypted(unsigned long vaddr, unsigned long size);
 int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages,
+					    bool enc);
 
 void __init mem_encrypt_free_decrypted_mem(void);
 
@@ -83,6 +85,8 @@ static inline int __init
 early_set_memory_decrypted(unsigned long vaddr, unsigned long size) { return 0; }
 static inline int __init
 early_set_memory_encrypted(unsigned long vaddr, unsigned long size) { return 0; }
+static inline void __init
+early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc) {}
 
 static inline void mem_encrypt_free_decrypted_mem(void) { }
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a26643dc6bd6..80a81de4c470 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -27,6 +27,7 @@
 #include <linux/nmi.h>
 #include <linux/swait.h>
 #include <linux/syscore_ops.h>
+#include <linux/efi.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -40,6 +41,7 @@
 #include <asm/ptrace.h>
 #include <asm/reboot.h>
 #include <asm/svm.h>
+#include <asm/e820/api.h>
 
 DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
 
@@ -433,6 +435,8 @@ static void kvm_guest_cpu_offline(bool shutdown)
 	kvm_disable_steal_time();
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
 		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
+	if (kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL))
+		wrmsrl(MSR_KVM_MIGRATION_CONTROL, 0);
 	kvm_pv_disable_apf();
 	if (!shutdown)
 		apf_task_wake_all();
@@ -547,6 +551,55 @@ static void kvm_send_ipi_mask_allbutself(const struct cpumask *mask, int vector)
 	__send_ipi_mask(local_mask, vector);
 }
 
+static int __init setup_efi_kvm_sev_migration(void)
+{
+	efi_char16_t efi_sev_live_migration_enabled[] = L"SevLiveMigrationEnabled";
+	efi_guid_t efi_variable_guid = AMD_SEV_MEM_ENCRYPT_GUID;
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
+	wrmsrl(MSR_KVM_MIGRATION_CONTROL, KVM_MIGRATION_READY);
+
+	return true;
+}
+
+late_initcall(setup_efi_kvm_sev_migration);
+
 /*
  * Set the IPI entry points
  */
@@ -805,8 +858,62 @@ static bool __init kvm_msi_ext_dest_id(void)
 	return kvm_para_has_feature(KVM_FEATURE_MSI_EXT_DEST_ID);
 }
 
+static void kvm_sev_hc_page_enc_status(unsigned long pfn, int npages, bool enc)
+{
+	kvm_hypercall3(KVM_HC_MAP_GPA_RANGE, pfn << PAGE_SHIFT, npages,
+		       KVM_MAP_GPA_RANGE_ENC_STAT(enc) | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
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
+			kvm_hypercall3(KVM_HC_MAP_GPA_RANGE, entry->addr,
+				       nr_pages,
+				       KVM_MAP_GPA_RANGE_ENCRYPTED | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
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
+			       KVM_MIGRATION_READY);
+	}
 	kvmclock_init();
 	x86_platform.apic_post_init = kvm_apic_init;
 }
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 455ac487cb9d..2673a89d17d9 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -409,6 +409,11 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
 	return early_set_memory_enc_dec(vaddr, size, true);
 }
 
+void __init early_set_mem_enc_dec_hypercall(unsigned long vaddr, int npages, bool enc)
+{
+	notify_range_enc_status_changed(vaddr, npages, enc);
+}
+
 /*
  * SME and SEV are very similar but they are not the same, so there are
  * times that the kernel will need to distinguish between SME and SEV. The
-- 
2.17.1

