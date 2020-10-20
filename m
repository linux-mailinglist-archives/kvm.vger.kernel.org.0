Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFA32934DC
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403943AbgJTGV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403846AbgJTGTJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 02:19:09 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA7EC061755
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:07 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id b1so645703lfp.11
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gw0cyONCYVO4XOfg8B3Kq+78eeAkNdUf+c9fS1LSrP0=;
        b=ZaPL1QB9kI9ElMTPNqOmGOLmic4Yaj0wvYPOX2hSKZhYJ6S6JOdvkbyRVMBgSA1ePH
         qOo/e7bIhHOzulxvaz6DHor4XhXlHsL5b7g5c09qtmluVioDR8vcoAyGjqCFoVC09MMW
         GuNcpOQzcaxyfJZunY6z+/ByvKC9FlCQWmIV4WiycPHzcFhvsOs/5C+BuYShVEdGRMri
         7OSVKYs0jmkMmgS7omvohDxhGLSz34Ql6fQ7jd47EHkBHeLwtkRMuOWgHTbOVl1NgB0b
         /2XFnbu+/jdrX5vywxVIT4SmeaBDOr0iF1arjlf9XcIHkiXzQJqcBu9f3jCIDoJD398Z
         eFdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gw0cyONCYVO4XOfg8B3Kq+78eeAkNdUf+c9fS1LSrP0=;
        b=uK4GzIYpvePeFkyevnpi38TEXF2jiE3e6ovb3A/1yfHfpvJIwJ+PkNFJX2Wjqh8s4F
         ocXLDJRfrGlOwM/Q/N67g5HX3M7nioJvmIvWKqT63KZd0MJulLfurAkudfvMeZxZEY3R
         fpPKGSlJDd9qVhb6xQFWaBy9DpOnWO3ky+BxUUKvhH2gSmgvojEE/TdUTx7xSX9KoLjB
         t4kd9c4A7b2NlMmzbnJ0l01eC/7TNmdry5LByn1Az8X0+hDvFUK2PTuzlBJS538srcay
         P/+QwnlvEVPyka/wp+VLuRP2V7bhi3B4zP23RrZRiTa/lekN1CY/XQaHCrC3CZz4IP45
         rXfQ==
X-Gm-Message-State: AOAM5334TJhmvb/sywszj495k6Gg78sP9xsVIAGbQhYg3D1H61HZ8kHG
        kghHS2ty4hOac3gU45FRpAXNcw==
X-Google-Smtp-Source: ABdhPJxgAcS39rh9YdwtTC/8H4DgRISiHr+0k6ljiQIlbDwDcfbprOE9I0s2eFZWV5EzSucg+VEbOg==
X-Received: by 2002:a19:64b:: with SMTP id 72mr395811lfg.47.1603174745124;
        Mon, 19 Oct 2020 23:19:05 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id t21sm137904lfl.64.2020.10.19.23.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:19:04 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id B7950102017; Tue, 20 Oct 2020 09:19:01 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 01/16] x86/mm: Move force_dma_unencrypted() to common code
Date:   Tue, 20 Oct 2020 09:18:44 +0300
Message-Id: <20201020061859.18385-2-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

force_dma_unencrypted() has to return true for KVM guest with the memory
protected enabled. Move it out of AMD SME code.

Introduce new config option X86_MEM_ENCRYPT_COMMON that has to be
selected by all x86 memory encryption features.

This is preparation for the following patches.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/Kconfig                 |  8 +++++--
 arch/x86/include/asm/io.h        |  4 +++-
 arch/x86/mm/Makefile             |  2 ++
 arch/x86/mm/mem_encrypt.c        | 30 -------------------------
 arch/x86/mm/mem_encrypt_common.c | 38 ++++++++++++++++++++++++++++++++
 5 files changed, 49 insertions(+), 33 deletions(-)
 create mode 100644 arch/x86/mm/mem_encrypt_common.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7101ac64bb20..619ebf40e457 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1514,13 +1514,17 @@ config X86_CPA_STATISTICS
 	  helps to determine the effectiveness of preserving large and huge
 	  page mappings when mapping protections are changed.
 
+config X86_MEM_ENCRYPT_COMMON
+	select ARCH_HAS_FORCE_DMA_UNENCRYPTED
+	select DYNAMIC_PHYSICAL_MASK
+	def_bool n
+
 config AMD_MEM_ENCRYPT
 	bool "AMD Secure Memory Encryption (SME) support"
 	depends on X86_64 && CPU_SUP_AMD
 	select DMA_COHERENT_POOL
-	select DYNAMIC_PHYSICAL_MASK
 	select ARCH_USE_MEMREMAP_PROT
-	select ARCH_HAS_FORCE_DMA_UNENCRYPTED
+	select X86_MEM_ENCRYPT_COMMON
 	help
 	  Say yes to enable support for the encryption of system memory.
 	  This requires an AMD processor that supports Secure Memory
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index e1aa17a468a8..c58d52fd7bf2 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -256,10 +256,12 @@ static inline void slow_down_io(void)
 
 #endif
 
-#ifdef CONFIG_AMD_MEM_ENCRYPT
 #include <linux/jump_label.h>
 
 extern struct static_key_false sev_enable_key;
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+
 static inline bool sev_key_active(void)
 {
 	return static_branch_unlikely(&sev_enable_key);
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 5864219221ca..b31cb52bf1bd 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -52,6 +52,8 @@ obj-$(CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS)	+= pkeys.o
 obj-$(CONFIG_RANDOMIZE_MEMORY)			+= kaslr.o
 obj-$(CONFIG_PAGE_TABLE_ISOLATION)		+= pti.o
 
+obj-$(CONFIG_X86_MEM_ENCRYPT_COMMON)	+= mem_encrypt_common.o
+
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_identity.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_boot.o
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 9f1177edc2e7..4dbdc9dac36b 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -15,10 +15,6 @@
 #include <linux/dma-direct.h>
 #include <linux/swiotlb.h>
 #include <linux/mem_encrypt.h>
-#include <linux/device.h>
-#include <linux/kernel.h>
-#include <linux/bitops.h>
-#include <linux/dma-mapping.h>
 
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
@@ -350,32 +346,6 @@ bool sev_active(void)
 	return sme_me_mask && sev_enabled;
 }
 
-/* Override for DMA direct allocation check - ARCH_HAS_FORCE_DMA_UNENCRYPTED */
-bool force_dma_unencrypted(struct device *dev)
-{
-	/*
-	 * For SEV, all DMA must be to unencrypted addresses.
-	 */
-	if (sev_active())
-		return true;
-
-	/*
-	 * For SME, all DMA must be to unencrypted addresses if the
-	 * device does not support DMA to addresses that include the
-	 * encryption mask.
-	 */
-	if (sme_active()) {
-		u64 dma_enc_mask = DMA_BIT_MASK(__ffs64(sme_me_mask));
-		u64 dma_dev_mask = min_not_zero(dev->coherent_dma_mask,
-						dev->bus_dma_limit);
-
-		if (dma_dev_mask <= dma_enc_mask)
-			return true;
-	}
-
-	return false;
-}
-
 void __init mem_encrypt_free_decrypted_mem(void)
 {
 	unsigned long vaddr, vaddr_end, npages;
diff --git a/arch/x86/mm/mem_encrypt_common.c b/arch/x86/mm/mem_encrypt_common.c
new file mode 100644
index 000000000000..964e04152417
--- /dev/null
+++ b/arch/x86/mm/mem_encrypt_common.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * AMD Memory Encryption Support
+ *
+ * Copyright (C) 2016 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ */
+
+#include <linux/mm.h>
+#include <linux/mem_encrypt.h>
+#include <linux/dma-mapping.h>
+
+/* Override for DMA direct allocation check - ARCH_HAS_FORCE_DMA_UNENCRYPTED */
+bool force_dma_unencrypted(struct device *dev)
+{
+	/*
+	 * For SEV, all DMA must be to unencrypted/shared addresses.
+	 */
+	if (sev_active())
+		return true;
+
+	/*
+	 * For SME, all DMA must be to unencrypted addresses if the
+	 * device does not support DMA to addresses that include the
+	 * encryption mask.
+	 */
+	if (sme_active()) {
+		u64 dma_enc_mask = DMA_BIT_MASK(__ffs64(sme_me_mask));
+		u64 dma_dev_mask = min_not_zero(dev->coherent_dma_mask,
+						dev->bus_dma_limit);
+
+		if (dma_dev_mask <= dma_enc_mask)
+			return true;
+	}
+
+	return false;
+}
-- 
2.26.2

