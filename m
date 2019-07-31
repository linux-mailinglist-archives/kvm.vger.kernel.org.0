Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 011B57C64A
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbfGaPWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:22:20 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40802 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730170AbfGaPWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:22:13 -0400
Received: by mail-ed1-f65.google.com with SMTP id k8so66040102eds.7
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xZCrLs3XD8OGAT3ycWjyC35TQ10BuGZLp4dKCEJJsRg=;
        b=ZzxPi2vB6H9up8THEqzUbCNwa2E1YZmLUp1GoionKsfBr1KQUEhgprj6heyI63fXrw
         H+vh1QV4vFyU7pFE4ViKBgvENglga5fVeNfWMRPCrZCi98qsi+r5zk6N62pl/svz4DjD
         WnRM8TC+Pj61sbunfqi5fGW98WW6DAYki4QW6kO4N7z8wCx7WTMte/S7jP4fuei7n7eq
         Hftvw0iaa2a1kXT25K4D3+dXvLj2vwBC0o2P1NCeJjiYQsXP0Nqqds5A7BCA5ZOq7vv9
         366A7NPLtjGoulNRAC6+0JGz6sJc40LnEY1OPEQYpV1Yi42ZVQe4Pz+slBHXGt07SvXV
         N3yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xZCrLs3XD8OGAT3ycWjyC35TQ10BuGZLp4dKCEJJsRg=;
        b=QW4Zc7XgSfdwp3oOWZ9YPaZxg/ht0DxOg3qdgv6AhnGdAIiTVqJgooz2vWrfrudOoP
         tvnvVIp2/2qr2dMhVmZ4hMNyRgNU5iBlkIE6/y/ybrKf7Nrtc90twXTSk9c0+Yud9hRE
         6+B/8sasMPZypHelXGJVHlhvhfNyhziwgXtYee9qtzFk2U9N1HDXRDc9xzD5tpqiRNBg
         FzhY926TOAXgPRkNfmu9fkGieIFkoekDDT2H4BwEMurLbFNTs2sGzCYJRdeiZGiVA1xu
         0Duxddme59TxyjJRGhdDVEb1bPl+MqN4ND+iG7wrdtWDDiUyVY0isa8QZD/XQqM5Zgyz
         i8/g==
X-Gm-Message-State: APjAAAUN4BSDhKFt14NumFIvsOJuzM3/l0RXjmlFKgzaD2l8dWGddDJr
        FZhckPvrI6mFN+uLZS1/5K0=
X-Google-Smtp-Source: APXvYqzi+h2CEkJox27TxBwILuSunR6853S6mGlis2VdUPScZU2xczXssICyuyck991q2MnJokM4kQ==
X-Received: by 2002:a17:906:1dd5:: with SMTP id v21mr65219317ejh.112.1564586040695;
        Wed, 31 Jul 2019 08:14:00 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id h10sm16374181edn.86.2019.07.31.08.13.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:57 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 4FE39104831; Wed, 31 Jul 2019 18:08:17 +0300 (+03)
To:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 49/59] x86/mm: introduce common code for mem encryption
Date:   Wed, 31 Jul 2019 18:08:03 +0300
Message-Id: <20190731150813.26289-50-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

Both Intel MKTME and AMD SME have needs to support DMA address
translation with encryption related bits. Common functions are
introduced in this patch to keep DMA generic code abstracted.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/Kconfig                 |  8 +++--
 arch/x86/mm/Makefile             |  1 +
 arch/x86/mm/mem_encrypt.c        | 30 ------------------
 arch/x86/mm/mem_encrypt_common.c | 52 ++++++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+), 32 deletions(-)
 create mode 100644 arch/x86/mm/mem_encrypt_common.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2eb2867db5fa..f2cc88fe8ada 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1521,12 +1521,16 @@ config X86_CPA_STATISTICS
 config ARCH_HAS_MEM_ENCRYPT
 	def_bool y
 
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
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 600d18691876..608e57cda784 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -55,3 +55,4 @@ obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_identity.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_boot.o
 
 obj-$(CONFIG_X86_INTEL_MKTME)	+= mktme.o
+obj-$(CONFIG_X86_MEM_ENCRYPT_COMMON)	+= mem_encrypt_common.o
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index fece30ca8b0c..e94e0a62ba92 100644
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
@@ -352,32 +348,6 @@ bool sev_active(void)
 }
 EXPORT_SYMBOL(sev_active);
 
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
-						dev->bus_dma_mask);
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
index 000000000000..c11d70151735
--- /dev/null
+++ b/arch/x86/mm/mem_encrypt_common.c
@@ -0,0 +1,52 @@
+#include <linux/mm.h>
+#include <linux/mem_encrypt.h>
+#include <linux/dma-mapping.h>
+#include <asm/mktme.h>
+
+/*
+ * Encryption bits need to be set and cleared for both Intel MKTME and
+ * AMD SME when converting between DMA address and physical address.
+ */
+dma_addr_t __mem_encrypt_dma_set(dma_addr_t daddr, phys_addr_t paddr)
+{
+	unsigned long keyid;
+
+	if (sme_active())
+		return __sme_set(daddr);
+	keyid = page_keyid(pfn_to_page(__phys_to_pfn(paddr)));
+
+	return (daddr & ~mktme_keyid_mask()) | (keyid << mktme_keyid_shift());
+}
+
+phys_addr_t __mem_encrypt_dma_clear(phys_addr_t paddr)
+{
+	if (sme_active())
+		return __sme_clr(paddr);
+
+	return paddr & ~mktme_keyid_mask();
+}
+
+/* Override for DMA direct allocation check - ARCH_HAS_FORCE_DMA_UNENCRYPTED */
+bool force_dma_unencrypted(struct device *dev)
+{
+	u64 dma_enc_mask, dma_dev_mask;
+
+	/*
+	 * For SEV, all DMA must be to unencrypted addresses.
+	 */
+	if (sev_active())
+		return true;
+
+	/*
+	 * For SME and MKTME, all DMA must be to unencrypted addresses if the
+	 * device does not support DMA to addresses that include the encryption
+	 * mask.
+	 */
+	if (!sme_active() && !mktme_enabled())
+		return false;
+
+	dma_enc_mask = sme_me_mask | mktme_keyid_mask();
+	dma_dev_mask = min_not_zero(dev->coherent_dma_mask, dev->bus_dma_mask);
+
+	return (dma_dev_mask & dma_enc_mask) != dma_enc_mask;
+}
-- 
2.21.0

