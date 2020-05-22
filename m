Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43A51DE72E
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgEVMwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728898AbgEVMwU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:52:20 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC99C05BD43
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:20 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id o14so12528311ljp.4
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2K3PqYltBNxWX5unFFr/4jbZ1d4hZaPsIl+jySYYIzI=;
        b=RZmS5aGoxiEWf9GuUWonhlLEEnOL/5aU5nssz02nf/5SdXl7slR5EEYNs/4PSzvG7Z
         OIBZmyNLeNfUVd9CBS3x2JRsgMjUJtKmqgUg3/8kZfq6ZbRdgzt/ygHJlYwMEbP8ckSe
         Osr8w/5iuea4QUPKom2JgGBanIVuVe7v1DvGbNuZfXNy/NOHMFubiWQ7w+0xnU6DvkKM
         iBbwHSs+aX6zSPzMNbc8Vnvh+YhL2rZrjhyYC6ClzNUk0Gq5XJxPA9Ma4lZvu7HiCMS0
         hLLe5Ms5M7Abmcvn1C2ToiDEdgV904P22iOK27KYOA/X+C/xBlkBHwTkmOlNo6KAYruK
         6Nig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2K3PqYltBNxWX5unFFr/4jbZ1d4hZaPsIl+jySYYIzI=;
        b=XS1ZGtKqT3C+BVpBBQOEkJgUAUknCvupX6DjY5gAR9V6oU2ePiK3lMybsD2UnXDDCR
         XsqsTAkZ16netOKNKKV5QVbOQO9BzHQF93an14/+evxRRQK+BpSwAqHSx7FHqXv9ef3C
         H2m6pUWNHJGarO6aHZbWaCHD4tNBWAzKStKXrnOIL1ddvVgJtbjRcSpx4GZjb1HsnY5d
         XDPo7iGuN5nZJwEYK6/8iu76s66sWXCUIVyjZy1wZUHUI4eKfqyj5zq5PnYmvYQYJH/k
         mkwWdeQ5xsrwPw47Y6jiJ3C866TN/LDw6B/NZjMvxz6r1dWQr2lLR791zqwqSJ9O4Tq+
         z0eg==
X-Gm-Message-State: AOAM531jB0LBbSZQM2/kkmFAuMDnu1oWhG8IG0VmfUg5N4HHM9EQ3vnf
        6q+LV0+59abxAQ0aUQ2TqU6F0w==
X-Google-Smtp-Source: ABdhPJzQ6T1oKzjxH1v0MRdbIIoC0LWPz5Z4w0jhXU9Ef/krG9OSTf62OuiRiejZ7fPahTpNDSD5dA==
X-Received: by 2002:a2e:9196:: with SMTP id f22mr6908669ljg.21.1590151938451;
        Fri, 22 May 2020 05:52:18 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id z22sm2386655lfi.96.2020.05.22.05.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:52:17 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id A1076101EB3; Fri, 22 May 2020 15:52:19 +0300 (+03)
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
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC 01/16] x86/mm: Move force_dma_unencrypted() to common code
Date:   Fri, 22 May 2020 15:51:59 +0300
Message-Id: <20200522125214.31348-2-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 2d3f963fd6f1..bc72bfd89bcf 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1518,12 +1518,16 @@ config X86_CPA_STATISTICS
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
-	select DYNAMIC_PHYSICAL_MASK
 	select ARCH_USE_MEMREMAP_PROT
-	select ARCH_HAS_FORCE_DMA_UNENCRYPTED
+	select X86_MEM_ENCRYPT_COMMON
 	---help---
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
index 98f7c6fa2eaa..af8683c053a3 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -49,6 +49,8 @@ obj-$(CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS)	+= pkeys.o
 obj-$(CONFIG_RANDOMIZE_MEMORY)			+= kaslr.o
 obj-$(CONFIG_PAGE_TABLE_ISOLATION)		+= pti.o
 
+obj-$(CONFIG_X86_MEM_ENCRYPT_COMMON)	+= mem_encrypt_common.o
+
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_identity.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_boot.o
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index a03614bd3e1a..112304a706f3 100644
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
 /* Architecture __weak replacement functions */
 void __init mem_encrypt_free_decrypted_mem(void)
 {
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

