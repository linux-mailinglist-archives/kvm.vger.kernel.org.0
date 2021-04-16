Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92104362432
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 17:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343950AbhDPPmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 11:42:06 -0400
Received: from mga03.intel.com ([134.134.136.65]:28316 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243404AbhDPPmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 11:42:02 -0400
IronPort-SDR: lFIqVKb0g4aDqdFCXfcwOYCOMmtxoXQDBNnBB5WdyzoDxRSM5R9pvdWkgu5fqvjVU7qhEFpJys
 xImq/apc3jyg==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="195082411"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="195082411"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 08:41:36 -0700
IronPort-SDR: +Fi9GL9MKK5YxKTt0mZh2nWd6EnMe3+HzzehYBQwwfQpzsyfJKfda3/Mo32rF7rxY0yk2+D0Ay
 pZL4if72nuGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="399940018"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 16 Apr 2021 08:41:32 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id E9C82202; Fri, 16 Apr 2021 18:41:49 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 04/13] x86/kvm: Use bounce buffers for KVM memory protection
Date:   Fri, 16 Apr 2021 18:40:57 +0300
Message-Id: <20210416154106.23721-5-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mirror SEV, use SWIOTLB always if KVM memory protection is enabled.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/Kconfig                   |  1 +
 arch/x86/include/asm/mem_encrypt.h |  7 +++--
 arch/x86/kernel/kvm.c              |  2 ++
 arch/x86/kernel/pci-swiotlb.c      |  3 +-
 arch/x86/mm/mem_encrypt.c          | 44 ---------------------------
 arch/x86/mm/mem_encrypt_common.c   | 48 ++++++++++++++++++++++++++++++
 6 files changed, 57 insertions(+), 48 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d197b3beb904..c51d14db5620 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -812,6 +812,7 @@ config KVM_GUEST
 	select ARCH_CPUIDLE_HALTPOLL
 	select X86_HV_CALLBACK_VECTOR
 	select X86_MEM_ENCRYPT_COMMON
+	select SWIOTLB
 	default y
 	help
 	  This option enables various optimizations for running under the KVM
diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 31c4df123aa0..a748b30c2f23 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -47,10 +47,8 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
 
 void __init mem_encrypt_free_decrypted_mem(void);
 
-/* Architecture __weak replacement functions */
-void __init mem_encrypt_init(void);
-
 void __init sev_es_init_vc_handling(void);
+
 bool sme_active(void);
 bool sev_active(void);
 bool sev_es_active(void);
@@ -91,6 +89,9 @@ static inline void mem_encrypt_free_decrypted_mem(void) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
+/* Architecture __weak replacement functions */
+void __init mem_encrypt_init(void);
+
 /*
  * The __sme_pa() and __sme_pa_nodebug() macros are meant for use when
  * writing to or comparing values from the cr3 register.  Having the
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index aed6034fcac1..ba179f5ca198 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -26,6 +26,7 @@
 #include <linux/kprobes.h>
 #include <linux/nmi.h>
 #include <linux/swait.h>
+#include <linux/swiotlb.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -765,6 +766,7 @@ static void __init kvm_init_platform(void)
 		pr_info("KVM memory protection enabled\n");
 		mem_protected = true;
 		setup_force_cpu_cap(X86_FEATURE_KVM_MEM_PROTECTED);
+		swiotlb_force = SWIOTLB_FORCE;
 	}
 }
 
diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index c2cfa5e7c152..814060a6ceb0 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -13,6 +13,7 @@
 #include <asm/dma.h>
 #include <asm/xen/swiotlb-xen.h>
 #include <asm/iommu_table.h>
+#include <asm/kvm_para.h>
 
 int swiotlb __read_mostly;
 
@@ -49,7 +50,7 @@ int __init pci_swiotlb_detect_4gb(void)
 	 * buffers are allocated and used for devices that do not support
 	 * the addressing range required for the encryption mask.
 	 */
-	if (sme_active())
+	if (sme_active() || kvm_mem_protected())
 		swiotlb = 1;
 
 	return swiotlb;
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 9ca477b9b8ba..3478f20fb46f 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -409,47 +409,3 @@ void __init mem_encrypt_free_decrypted_mem(void)
 
 	free_init_pages("unused decrypted", vaddr, vaddr_end);
 }
-
-static void print_mem_encrypt_feature_info(void)
-{
-	pr_info("AMD Memory Encryption Features active:");
-
-	/* Secure Memory Encryption */
-	if (sme_active()) {
-		/*
-		 * SME is mutually exclusive with any of the SEV
-		 * features below.
-		 */
-		pr_cont(" SME\n");
-		return;
-	}
-
-	/* Secure Encrypted Virtualization */
-	if (sev_active())
-		pr_cont(" SEV");
-
-	/* Encrypted Register State */
-	if (sev_es_active())
-		pr_cont(" SEV-ES");
-
-	pr_cont("\n");
-}
-
-/* Architecture __weak replacement functions */
-void __init mem_encrypt_init(void)
-{
-	if (!sme_me_mask)
-		return;
-
-	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
-	swiotlb_update_mem_attributes();
-
-	/*
-	 * With SEV, we need to unroll the rep string I/O instructions.
-	 */
-	if (sev_active())
-		static_branch_enable(&sev_enable_key);
-
-	print_mem_encrypt_feature_info();
-}
-
diff --git a/arch/x86/mm/mem_encrypt_common.c b/arch/x86/mm/mem_encrypt_common.c
index 6bf0718bb72a..351b77361a5d 100644
--- a/arch/x86/mm/mem_encrypt_common.c
+++ b/arch/x86/mm/mem_encrypt_common.c
@@ -11,6 +11,7 @@
 #include <linux/mem_encrypt.h>
 #include <linux/dma-direct.h>
 #include <asm/kvm_para.h>
+#include <asm/mem_encrypt.h>
 
 /* Override for DMA direct allocation check - ARCH_HAS_FORCE_DMA_UNENCRYPTED */
 bool force_dma_unencrypted(struct device *dev)
@@ -37,3 +38,50 @@ bool force_dma_unencrypted(struct device *dev)
 
 	return false;
 }
+
+static void print_mem_encrypt_feature_info(void)
+{
+	if (kvm_mem_protected()) {
+		pr_info("KVM memory protection enabled\n");
+		return;
+	}
+
+	pr_info("AMD Memory Encryption Features active:");
+
+	/* Secure Memory Encryption */
+	if (sme_active()) {
+		/*
+		 * SME is mutually exclusive with any of the SEV
+		 * features below.
+		 */
+		pr_cont(" SME\n");
+		return;
+	}
+
+	/* Secure Encrypted Virtualization */
+	if (sev_active())
+		pr_cont(" SEV");
+
+	/* Encrypted Register State */
+	if (sev_es_active())
+		pr_cont(" SEV-ES");
+
+	pr_cont("\n");
+}
+
+void __init mem_encrypt_init(void)
+{
+	if (!sme_me_mask && !kvm_mem_protected())
+		return;
+
+	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
+	swiotlb_update_mem_attributes();
+
+	/*
+	 * With SEV, we need to unroll the rep string I/O instructions.
+	 */
+	if (sev_active())
+		static_branch_enable(&sev_enable_key);
+
+	print_mem_encrypt_feature_info();
+}
-- 
2.26.3

