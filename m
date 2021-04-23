Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AA6369684
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 17:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243167AbhDWQAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 12:00:13 -0400
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:48865
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243153AbhDWQAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 12:00:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JS2N72z4KJQC7vZNCns6tZIL5vLM5RMuibXRTNt2GqgqdyG0FrbygOS9kfAtjQ0rHhwVfOuEMH6lr0donL9VS32FIhbSS4v2k8QmZF54q6mRfBxZ6X3B110FnjDC/nrjh3PZAgE9vWpk8G/PeqkWCMDwQTSSbK7VifUcGoU1f5KP6FlSXk1QBzbPSy0LllgDRKkyE3IMFWCff6I7fxGJoWJW5hSGx9qrRBuSOFEFtS7uZeBDfcQYIAuH2RBy2FmbTtXy5uEYp4U+COR4FWDnflHuJRe5MVYhVhw1dboLAbvETQUSF2zoviNnzoCg12ZwJ5/lRbIhy6o9TUZIcHjCcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jvi4OGI1XLHC7vWpuBcyMSPQNkyfc3ZCnuTNsVbWZnE=;
 b=cBiqLxDmofi22NavNeXnIaRJ7Xc3pQH/gv5WTHvfF6Ggr2Bsj1w5TQqhQ7V9j/0ONE4uK4DIozX92h89ce7yMruxTQNC8hZOXJMnOzYZUhNBTRQKoz6uNRbmBz0YCfPqYcUfkpQGIKulAV7bjsPmYyzKUH6L5lPR7oToYGcPMHui6uk1tueeTEdoDnsiYodcP/hiW171dYYf5nFFhJRQprwFi6t0suEhtwoe4n9zgNFubrQtUtvfl65qqkQ/N2u6YMjQTHqwJynUR7oIaKnDf0keRcBpNyambjhDoj3IYB6xhxhPAmBOb4KCjayUfandVWr6VRckVXF1Bsh9MAJ34A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jvi4OGI1XLHC7vWpuBcyMSPQNkyfc3ZCnuTNsVbWZnE=;
 b=QbDSs5vGQLuwtY9tEdS3GdxfdbZa5WZ8qlru2TQ0yvIF3ukMeUpVXceXDP0szaJUY6BgFFxenML0HemuYWsr9Fh3jwYta8FegU917RVAUykHDJ7xWy8T0fIP2dgTEy1pxN5aFwtu18VLqIDSd1M35qOKfXCQwd79hYFfWGV0iGM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2717.namprd12.prod.outlook.com (2603:10b6:805:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 23 Apr
 2021 15:59:29 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%7]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 15:59:29 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: [PATCH v2 4/4] x86/kvm: Add guest support for detecting and enabling SEV Live Migration feature.
Date:   Fri, 23 Apr 2021 15:59:19 +0000
Message-Id: <09a5d8a6fe69d65a2418799848dd037d24b8ba95.1619193043.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1619193043.git.ashish.kalra@amd.com>
References: <cover.1619193043.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0023.namprd05.prod.outlook.com
 (2603:10b6:803:40::36) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0501CA0023.namprd05.prod.outlook.com (2603:10b6:803:40::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Fri, 23 Apr 2021 15:59:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6711535-c6d7-47e8-bd5f-08d90670c71f
X-MS-TrafficTypeDiagnostic: SN6PR12MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2717AA1599A884C5A50F26CD8E459@SN6PR12MB2717.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:305;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VkNDiOR1VyOb1dxQt2hKuqdLjwQcT52irdTCa8BtRASVg8lyeemt54dQUe2FIe5oPJ9ywPnAF6Z8/i/usKrmoKigQScxTg0sMHAEoIzzup7xZ9hsSMm5B1civMrEhVdfluYMA3SjI+xDeRpTilI6RnXYgw735JFO352a6qFwHlGEMz04WdFeoocqMjHzP9bEXPlzkOWbPE8h8zo6S0WQ9ZbOI+ohlVsjrCZBlZOmvlmY49ApmRpXAmBjzdcrVkfP5wHg2uWLYfv6QUFyiax5WlaZm1dhXK6AHudQ36zWtpl8m00RyIs+F/aBUKsOmQ2T4kTS5i+CkjI7f6YI37DB8tXkAweJ0gGEUFEhk/PyFZDs31wH3m77WitzY2s6JW0n3T4GNqqSpVc+h4kEMWan8ajZwvvda0kbJUkVEZMduGkK2W6UiU+Ai/o0QVbhWv3VOJUpI9G8MEVnw8moYFATfyrpmeOD71f2efgd15kMSTNnFSE3GKmce8qaXabijrLJWzAQXiwu4ux4gY1Y4iGu1KCcFJ5qiRVQ05vsoVPme2Kn5JJaqi6v/9JCqhk7UDK7zfHP4ZHplYL3gEdcmF7hNQxTrF1Ezz9R9GuhIQbEn85scLPluRmBSdr4qQpHV6pbj5BQZ+Kfm7quKp+xPEgoOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(83380400001)(66946007)(186003)(956004)(6486002)(38100700002)(5660300002)(316002)(6666004)(2906002)(66556008)(66476007)(16526019)(26005)(36756003)(2616005)(8676002)(478600001)(7416002)(86362001)(38350700002)(6916009)(7696005)(4326008)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TZagx3Iqaf4hkPaJmMi/T8iL3MxEXfP12J4ZqKnLEvIfrcJmMuN2Al64yND6?=
 =?us-ascii?Q?46JrYiH/QQPSJeANoXu7ZeaqQ4QeW/j52TKYchLKIe61ZIfoIhLH83eHC00I?=
 =?us-ascii?Q?DoIZifB5Zt5XTfxHSQIvX7ltcuC4uPoEwW+kJEqtpOORGRmO4riA02jhxGGd?=
 =?us-ascii?Q?MWkmCieEtA2W+R01PzYtTAKRhTcMI8x0EeQ25nfpZ2AR2EpuF9Yw5DemY6IM?=
 =?us-ascii?Q?hrVKQaboaEH1eWsASxkdb4SJefKvALU4OqByNuVXC3+EtvNsVjMtzg1fB5HS?=
 =?us-ascii?Q?9oxpB/90hrBs6e/OPAAkVTypRogszIIAcnoZOwA/djBwVEXQFNbdflUrgjXz?=
 =?us-ascii?Q?mDTJzJ/fkTSgUzQFGE+eAweeKQlBf43a4VuziRnYjYCgGPUBCfSULM7EV5m6?=
 =?us-ascii?Q?uRen+sVHymLUNVuFwB53tFYLcFEG+kKd7yIh43Ll5+BS83QM/uq8jwDsbiuL?=
 =?us-ascii?Q?YqpxDIraV20RvdcvcTUgSYonVR72ebJZoZpMuO3DZCmV5O9cn+3mKy4W5DcL?=
 =?us-ascii?Q?g+wEsaPSIajoUpU/1DpKZx/iYlxt3kfrzx0GSWBcVwAAVTzDopycBdVpey20?=
 =?us-ascii?Q?JHUJRMrPUQ/RdfE9tKUT5VWzu1LM/EjM05TPdz+zPwFrf1LrS6GqejmLQokW?=
 =?us-ascii?Q?ukY4xPiO9MqvQwO0hJ69Qyx1/FV1DV/IAgjrAG0Oid+x5Wo7QHZ8cvq7yIqQ?=
 =?us-ascii?Q?F4rUBxwpAV0J7WaQvWZpjs73c3HU/fkGYw+0xrDrIjt55vw6yA4JA9cjdukX?=
 =?us-ascii?Q?avt+mw6vqrY/wNbUAr7N2l6hjhHCg+XixV3hdP+O7GOsaGGgfwwVWGXe7avK?=
 =?us-ascii?Q?6NjEfY7kpqJQTAKblch043KuuMrfISUCFZBw7suljUeF7Lxv/uVjA5WSfMQk?=
 =?us-ascii?Q?pMg7GDpYrwq1o0LUkfzBGq847HdRlAswFOeZZS+V7IsO3AynMhyA7dS2JdDm?=
 =?us-ascii?Q?fUngIBQOcHhEQ/AJ++pBDQGl/9ZOoKocY/YTl8je4z+/B14aqsUmZ/st56tB?=
 =?us-ascii?Q?roQ9hWuDWeqrmoswe1S3sLlb9o6Msc08wS4nJd1s2mDDxb8iPjf/Z29jZT+0?=
 =?us-ascii?Q?e635qv6h/TrWrshOJFeXVli5ACltcubP6745IhW2LNcYNpZJyj16lQp6NZsC?=
 =?us-ascii?Q?id0soLmQ5AE21UTJ0flT1Gfxxw1HxQjeAOIO+3r0yb4Xa5Njzshr66FLOoih?=
 =?us-ascii?Q?ZXzLdHz22wltUy1IT8IXfwvnNKWECKvDj5/eXQLKWwO3IFBg/a0OSsDIzwH7?=
 =?us-ascii?Q?C37/3NHwaOuhmkOiykuK+LKrNcOUn3SBDXyp/XA1Tzm3Fslpg79J8+9zjs3B?=
 =?us-ascii?Q?JqzNNWrRtjdorjH5L48uxNie?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6711535-c6d7-47e8-bd5f-08d90670c71f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 15:59:29.7994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J0fM9mnF01IpuCvChVyXc+ZQBaWMyCWr6Dy2nhj3YjwqJpaETFEx9u/ktlW9id997//Zwl1VTKK3opsN5KFKtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2717
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
index 224a7a1ed6c3..1844b200f6d4 100644
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
+	kvm_hypercall3(KVM_HC_PAGE_ENC_STATUS, pfn << PAGE_SHIFT, npages,
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
+			kvm_hypercall3(KVM_HC_PAGE_ENC_STATUS, entry->addr,
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

