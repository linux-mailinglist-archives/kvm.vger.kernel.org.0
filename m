Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948C2360FA7
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 18:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbhDOQBw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 12:01:52 -0400
Received: from mail-co1nam11on2062.outbound.protection.outlook.com ([40.107.220.62]:11987
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231726AbhDOQBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 12:01:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZiXjUQSgXvuq2sq6olpi25CigZ0Lr8pLkynpVdD91lmBwIshfktncgu8FR42KMl6RHE3W2c5hT37gQahY8DpSPtESNbqFBx4ukA/z6lAg/SxZQlIiBJELtRwXtok0YACVewhpkxNbENh+eHDmPOTGRR/f2OPnv5JCRnQij42l+u81dFdBQsczZW4+1ygsMdmRO0uDHVAQ9EDdpcMbs6YblbhctxmjelFxpAdTEbFsU5YzRgMNnR49MOnhpyiM0dU0RyLfg1fEHGg1ogOgWLGooS+uyhLdwjzFQarhpFC5hWFZjaQCKAqEOslpXGDN6jak54P198zPdohJfkKHFn9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLF70FUMovikKo8IBygF7beVKFc18vJMfTzLHEG+vVc=;
 b=GPHfMgao9axBGUf0KJ+nVs6kFTdb4P42Ay4/f06zMvc9hGtUiUtSQ4ojC0mWo3wqcNpd7t0XQbPRyS4vHz6HzrMXAA/ne3wlNfFeDcgM2M8pQ6ueJTTcS3BtzNjfninRBGiKv8TK82AP+u/RdjK53ClE0dmESU8KqGjCF/vraZ5oabF+3vP8S+V/KRPsSEfxpDCGCqR/yurC5LXamEHpmgnYvy7zb/RuSdQlyHxN4GctYJJSV1zZvXOR3PGBYFTWldHUbpXUvWxbFGkc1DkeGk09SdQ6Nr+DGi2qxN6uJQzyTvkh8PrtuoCDbkwjvqAw+78gnHqnTAMdG5HYJ50Dvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLF70FUMovikKo8IBygF7beVKFc18vJMfTzLHEG+vVc=;
 b=1hphpmb0uBZVYPYYOMfnmFX2o/mwU82tbAcI3rrwu6ihP6OV3LH+LRQylxX57U3QRvGeYETfNkRHPp18YhyxAXgY1tjbUS4qbPq5/F98oue8Kq5sTpSNvm2YEtpH4yYGymkM43Y5JvuTriBF9/c5zNzNldV2SU0edN25/gK71K8=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4415.namprd12.prod.outlook.com (2603:10b6:806:70::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 16:01:26 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 16:01:26 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com,
        kexec@lists.infradead.org
Subject: [PATCH v13 12/12] x86/kvm: Add guest support for detecting and enabling SEV Live Migration feature.
Date:   Thu, 15 Apr 2021 16:01:16 +0000
Message-Id: <ffd67dbc1ae6d3505d844e65928a7248ebaebdcc.1618498113.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1618498113.git.ashish.kalra@amd.com>
References: <cover.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0187.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::12) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA0PR11CA0187.namprd11.prod.outlook.com (2603:10b6:806:1bc::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 16:01:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90f20e35-6b85-4e9a-b1e3-08d90027b94d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44159D3CF1DCCA4150A278528E4D9@SA0PR12MB4415.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c7OaLCqVQzfQJ8Yj/wuS7iimES+6mbFznkg9yDSR4Utip8Y5ULHORaFYAUXVqldDJuLs7bY6rYeHyQW15E1bR2z2cZwv5Tc8mTJj3juOTnZ8hvbYMtluXoiB+LTymRnpCRpS38KAmWwjwBh69bflpsWeD2+HFpcuGkf1YWASmeVc606q1sWtzikl99HxmFxIQN0T4ZgFvyrS/R8BGu41ARl0WCYC/eD9Ld3MeJfjxr8LvN1dXrGGkrcSosqjgnXpjkfaC22kgVUlom/UU13JA8P1WZSpIEOeBv70PZ7v8HJia5mHRykb9lC6L3JZkXfhFGdCKXYMrxCW97Q83r8GIaiWKzVvqcThTGKf4+j/YfQKE2sLslFCOSf73Y4PZjhqKGvNwRHsZFVx/5BJLSCtjcE/sk9gNKV5F8hUP/Ucsjj6W5j9X4MRz7+bpY12YwYIvT1L2wKMnQoIOhNQFTcFfnYk0Pss5vOuG7CFMwK/IVwVuIPOvXJkD+1qVa9b2D9LZ71se/M6xfnTz8VXRgg+6GJg6EV12czGTEM/TGLpPpE4LqBL0b90pJtZV5m4uAc230EE1KkWaEal8o7R1/1EnAywW1aKqyTF8JxZiKCiN/vQ7G9h2eYeykClhkP4Vciw62CARPFGfD6sCY86QrcZMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(366004)(136003)(7416002)(16526019)(8676002)(186003)(8936002)(5660300002)(83380400001)(66476007)(36756003)(38350700002)(66946007)(956004)(66556008)(4326008)(6666004)(2616005)(316002)(38100700002)(7696005)(6916009)(52116002)(2906002)(6486002)(26005)(86362001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qvxKANlCqAx/1M8UFJMUJZIAKTginIJfwPcVFav+j/q6Fk0/uCW8TgMxSciI?=
 =?us-ascii?Q?N+Jv/xypb66NqQl5hqTQFqFGzs3fYRYhMa93KUjm6RSAeuQ1RWiav/woKiEY?=
 =?us-ascii?Q?ZeKOc2U0GOFW+XtxQmR8ecDZX7PrlWcC6CvYM5zwCMJCU1ZbI1fG9UcJPHTD?=
 =?us-ascii?Q?JlL0/7E4i5TcgEA+tAOIN+/oyMNdAZUrHlUy7IzGD2eDYH4gNnxwpNNNLCVf?=
 =?us-ascii?Q?MA1Qjoz3LF0J4+SQTD08Z4I7bbAfZwNt6E+oPJ5d5BL5SQEERbolAWv6QvP+?=
 =?us-ascii?Q?atVXFbMdWPbh1huMHBeaySO76kh/sJwDTL6p3cbPrKnmyykse3ewK3adGpiU?=
 =?us-ascii?Q?u4/IWO/MJSz0eQRInHVJ1VhjwJNsC2Oawpj5y/j4cnEoRIGhknfyiN8kJhCl?=
 =?us-ascii?Q?xGbBxQ0KD/bwI9lJ4wH6zWk0VijT7wHiGZBm4lqxFSJvNXgPt9J/GU7mFF1/?=
 =?us-ascii?Q?kN0VS03OIlGnt1KyvMV1PZ+8O1Dbmi5eVDm52baRvj86U14EX9Fn0x1jXGbf?=
 =?us-ascii?Q?2sgt4ahORhE/FsXt731nVpYEzTMW9JJxhspQrmq0Nb7uRtX4wPpwVaBHIQTv?=
 =?us-ascii?Q?jV+28CwH4WFmfcBfrmj2JtZmCgqg9Lwq2OtLKvI7P2iuZiq/oWiBcwTfz8nr?=
 =?us-ascii?Q?nOOPXHFG4bqNxBmbT6bpk/B5KAvugtGneR1E4wA6Rz1AEW5wU2QX5CLAC+0t?=
 =?us-ascii?Q?NkGkrt5KONG8LJfBHYWaHQVYirpw73D+FmakHMWgUBiM42kyYW72kmbIJv3w?=
 =?us-ascii?Q?F6sCXgFPfPWn0J+x9Ec6guIqh4FirnPxMTk6kigM2FWvBdMUc33BVUAWieAO?=
 =?us-ascii?Q?oBpAxZG0ClL6BEJtOfNbew97FVoRCRp7+U1njiFn9N58mLMjFFywuNI6lVF9?=
 =?us-ascii?Q?+j4AKElrBg1ZHcK5Us0iQbkp3RIW45WTq0wSqoGhl8q4mmFt5cWJRGtUMYkj?=
 =?us-ascii?Q?qTkSIPE8ak5tiKfhrCODwYvJkra3yYPz/ve6c+Bey10CB/NE2jqVNz8tDv3x?=
 =?us-ascii?Q?rI/miG2bjQuD6L53ri2NHqicIq576vpLvbhYWfa2msDmXwZ+L0CVZZafVNYc?=
 =?us-ascii?Q?IbiIhjFilyV5cuA73q2NgQyG0GfKMB5PAiL/SrM54+M3JfXRsfYlq2j0EbGQ?=
 =?us-ascii?Q?Q0O+Xn9LJ5/zWwIkYmcAMqSlXUEe0uBzPbD9blaEVWUPVnwM8qJz3Yb4+bqT?=
 =?us-ascii?Q?FumVATU0ETm+vYKnrdAeKMaMxNWaYD8e/0U79DaM9KKNWu3EKUIiPhtFsolR?=
 =?us-ascii?Q?yYmXi3q4EvG0wBBF7dqc5z19armCT+N8q2d1jzh2XySbqQZdpJIVvgDnz7ZM?=
 =?us-ascii?Q?stp7j0jhIA29dWtCK7yufP8+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90f20e35-6b85-4e9a-b1e3-08d90027b94d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 16:01:26.3816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mgQDBZtxm3h8gvxES9AJs4SFLHUgdYTSdCEzhakAwEhf7yplFWebNEkkUAMMBTN4AM+kNxyBCLzOGQaBllFCgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4415
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
 arch/x86/include/asm/mem_encrypt.h |  8 ++++
 arch/x86/kernel/kvm.c              | 55 +++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt.c          | 64 ++++++++++++++++++++++++++++++
 3 files changed, 127 insertions(+)

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
index 78bb0fae3982..94ef16d263a7 100644
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
@@ -429,6 +430,59 @@ static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
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
@@ -747,6 +801,7 @@ static bool __init kvm_msi_ext_dest_id(void)
 
 static void __init kvm_init_platform(void)
 {
+	check_kvm_sev_migration();
 	kvmclock_init();
 	x86_platform.apic_post_init = kvm_apic_init;
 }
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index fae9ccbd0da7..382d1d4f00f5 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -20,6 +20,7 @@
 #include <linux/bitops.h>
 #include <linux/dma-mapping.h>
 #include <linux/kvm_para.h>
+#include <linux/efi.h>
 
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
@@ -31,6 +32,7 @@
 #include <asm/msr.h>
 #include <asm/cmdline.h>
 #include <asm/kvm_para.h>
+#include <asm/e820/api.h>
 
 #include "mm_internal.h"
 
@@ -48,6 +50,8 @@ EXPORT_SYMBOL_GPL(sev_enable_key);
 
 bool sev_enabled __section(".data");
 
+bool sev_live_migration_enabled __section(".data");
+
 /* Buffer used for early in-place encryption by BSP, no locking needed */
 static char sme_early_buffer[PAGE_SIZE] __initdata __aligned(PAGE_SIZE);
 
@@ -237,6 +241,9 @@ static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
 	unsigned long sz = npages << PAGE_SHIFT;
 	unsigned long vaddr_end, vaddr_next;
 
+	if (!sev_live_migration_enabled)
+		return;
+
 	vaddr_end = vaddr + sz;
 
 	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
@@ -407,6 +414,12 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size)
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
@@ -462,6 +475,57 @@ bool force_dma_unencrypted(struct device *dev)
 	return false;
 }
 
+void __init check_kvm_sev_migration(void)
+{
+	if (sev_active() &&
+	    kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION)) {
+		unsigned long nr_pages;
+		int i;
+
+		pr_info("KVM enable live migration\n");
+		WRITE_ONCE(sev_live_migration_enabled, true);
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
+			wrmsrl(MSR_KVM_SEV_LIVE_MIGRATION,
+			       KVM_SEV_LIVE_MIGRATION_ENABLED);
+	}
+}
+
 void __init mem_encrypt_free_decrypted_mem(void)
 {
 	unsigned long vaddr, vaddr_end, npages;
-- 
2.17.1

