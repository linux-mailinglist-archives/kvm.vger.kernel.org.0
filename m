Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B556F17BE9
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbfEHOo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:33094 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728518AbfEHOoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:51 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 08 May 2019 07:44:46 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 5D8901124; Wed,  8 May 2019 17:44:31 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
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
Subject: [PATCH, RFC 53/62] x86/mm: Use common code for DMA memory encryption
Date:   Wed,  8 May 2019 17:44:13 +0300
Message-Id: <20190508144422.13171-54-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

Replace sme_ code with x86 memory encryption common code such that
Intel MKTME can be supported underneath generic DMA code.
dma_to_phys() & phys_to_dma() results will be runtime modified by
memory encryption code.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/mem_encrypt.h | 29 +++++++++++++++++++++++++++++
 arch/x86/mm/mem_encrypt_common.c   |  2 +-
 include/linux/dma-direct.h         |  4 ++--
 include/linux/mem_encrypt.h        | 23 ++++++++++-------------
 4 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 616f8e637bc3..a2b69cbb0e41 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -55,8 +55,19 @@ bool sev_active(void);
 
 #define __bss_decrypted __attribute__((__section__(".bss..decrypted")))
 
+/*
+ * The __sme_set() and __sme_clr() macros are useful for adding or removing
+ * the encryption mask from a value (e.g. when dealing with pagetable
+ * entries).
+ */
+#define __sme_set(x)		((x) | sme_me_mask)
+#define __sme_clr(x)		((x) & ~sme_me_mask)
+
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
+#define __sme_set(x)		(x)
+#define __sme_clr(x)		(x)
+
 #define sme_me_mask	0ULL
 
 static inline void __init sme_early_encrypt(resource_size_t paddr,
@@ -97,4 +108,22 @@ extern char __start_bss_decrypted[], __end_bss_decrypted[], __start_bss_decrypte
 
 #endif	/* __ASSEMBLY__ */
 
+#ifdef CONFIG_X86_MEM_ENCRYPT_COMMON
+
+extern dma_addr_t __mem_encrypt_dma_set(dma_addr_t daddr, phys_addr_t paddr);
+extern phys_addr_t __mem_encrypt_dma_clear(phys_addr_t paddr);
+
+#else
+static inline dma_addr_t __mem_encrypt_dma_set(dma_addr_t daddr, phys_addr_t paddr)
+{
+	return daddr;
+}
+
+static inline phys_addr_t __mem_encrypt_dma_clear(phys_addr_t paddr)
+{
+	return paddr;
+}
+#endif /* CONFIG_X86_MEM_ENCRYPT_COMMON */
+
+
 #endif	/* __X86_MEM_ENCRYPT_H__ */
diff --git a/arch/x86/mm/mem_encrypt_common.c b/arch/x86/mm/mem_encrypt_common.c
index 2adee65eec46..dcc5c710a235 100644
--- a/arch/x86/mm/mem_encrypt_common.c
+++ b/arch/x86/mm/mem_encrypt_common.c
@@ -1,5 +1,5 @@
 #include <linux/mm.h>
-#include <linux/mem_encrypt.h>
+#include <asm/mem_encrypt.h>
 #include <asm/mktme.h>
 
 /*
diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index b7338702592a..a949adeb6558 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -40,12 +40,12 @@ static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size)
  */
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
 {
-	return __sme_set(__phys_to_dma(dev, paddr));
+	return __mem_encrypt_dma_set(__phys_to_dma(dev, paddr), paddr);
 }
 
 static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
 {
-	return __sme_clr(__dma_to_phys(dev, daddr));
+	return __mem_encrypt_dma_clear(__dma_to_phys(dev, daddr));
 }
 
 u64 dma_direct_get_required_mask(struct device *dev);
diff --git a/include/linux/mem_encrypt.h b/include/linux/mem_encrypt.h
index b310a9c18113..ce8ff0ead16c 100644
--- a/include/linux/mem_encrypt.h
+++ b/include/linux/mem_encrypt.h
@@ -26,6 +26,16 @@
 static inline bool sme_active(void) { return false; }
 static inline bool sev_active(void) { return false; }
 
+static inline dma_addr_t __mem_encrypt_dma_set(dma_addr_t daddr, phys_addr_t paddr)
+{
+	return daddr;
+}
+
+static inline phys_addr_t __mem_encrypt_dma_clear(phys_addr_t paddr)
+{
+	return paddr;
+}
+
 #endif	/* CONFIG_ARCH_HAS_MEM_ENCRYPT */
 
 static inline bool mem_encrypt_active(void)
@@ -38,19 +48,6 @@ static inline u64 sme_get_me_mask(void)
 	return sme_me_mask;
 }
 
-#ifdef CONFIG_AMD_MEM_ENCRYPT
-/*
- * The __sme_set() and __sme_clr() macros are useful for adding or removing
- * the encryption mask from a value (e.g. when dealing with pagetable
- * entries).
- */
-#define __sme_set(x)		((x) | sme_me_mask)
-#define __sme_clr(x)		((x) & ~sme_me_mask)
-#else
-#define __sme_set(x)		(x)
-#define __sme_clr(x)		(x)
-#endif
-
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* __MEM_ENCRYPT_H__ */
-- 
2.20.1

