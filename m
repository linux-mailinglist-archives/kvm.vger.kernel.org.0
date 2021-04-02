Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D381F352D68
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 18:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbhDBP1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 11:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235477AbhDBP1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 11:27:03 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD27C0613E6
        for <kvm@vger.kernel.org>; Fri,  2 Apr 2021 08:27:01 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id c6so4454126lji.8
        for <kvm@vger.kernel.org>; Fri, 02 Apr 2021 08:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l49+x9wha/OETvCMFi8m/d/uZbBJ4UwRqG9iOGtI1aM=;
        b=OuvK3SzQ6dQOhzxZUcyuQgdblcFLTBXZYao++de77CPnXGNcR10xHoWIXV714ZZa74
         zm96h3Cz2GA40FA54aDesXzmTrnZJF1HLc9EAULShBa27yLlOgl9iReCZ0QEHO+reMoF
         B4+of1sK2aUj5FmsnomD7aj4PkP4jDjeSB78UIvj368hJY+40pj3xhR4saWRxBReRivX
         nfu+VrY64R4QZf+jRHnrEq/I26vU5cle4esowVbrFYusNbiM0Y52RUVpFIwbGPuoDs47
         9Lmyb9ywzUINcVApb4zPN2tvnZpcGqEqv8BrJdW0vt1jTqKRXZvtOz7XLJ8Ph18W7ONK
         DcXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l49+x9wha/OETvCMFi8m/d/uZbBJ4UwRqG9iOGtI1aM=;
        b=HpRfWUa3owHzEv3PdY0MQUPe1WFd2wCQqa/fW7M7RwIVTzZgOHj+2HvZp4dltM5IHs
         9dTTDRLzzSazV/ZMbpIceYq7JBAyEM2b5f3V79XgyfgdwtuElyE6ZJ2Bl1OPXBxUjBUP
         iIQvvWaA0xVsRv1iO2g+CGE2MFFFzcjNgbZ3uHrsrSDReDID6+Z1mpQthJomnZA9UUe3
         o9LtUPmocb2z8aJ2JFwit3+dnbzSc2Kcpze5jt7HWp1S5W1MLEqTUQAmuOEffxVfWjpU
         MUW0/ej3jIRAesiE5kgRBrhrWUpQ1B9lN/MKo9A9bs2SGT25fWEAZ8ovHSsi4GuJK/1/
         +ksg==
X-Gm-Message-State: AOAM533PGyxAfvs6YfLOGULEIStIcE8J5GhlDW9TecH/fpZUegN3+kQk
        HaPrQYPcLOWoyQew+owEq5HnKQ==
X-Google-Smtp-Source: ABdhPJzssft7IoVOjuBqHnu5o2WtjJ8q2hIrHHkfmVBUMr0CRXudxVHzj/x/Sx3degpbvNmcq7wWxw==
X-Received: by 2002:a2e:8ed4:: with SMTP id e20mr8402684ljl.129.1617377219683;
        Fri, 02 Apr 2021 08:26:59 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id c2sm891480lfc.221.2021.04.02.08.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 08:26:57 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 3E0D3102675; Fri,  2 Apr 2021 18:26:59 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv1 4/7] x86/kvm: Use bounce buffers for KVM memory protection
Date:   Fri,  2 Apr 2021 18:26:42 +0300
Message-Id: <20210402152645.26680-5-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
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
index e6989e1b74eb..45aee29e4294 100644
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
@@ -766,6 +767,7 @@ static void __init kvm_init_platform(void)
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

