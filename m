Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0AD17C14
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfEHOri (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:47:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:59536 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728453AbfEHOov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:51 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 08 May 2019 07:44:46 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 51F061123; Wed,  8 May 2019 17:44:31 +0300 (EEST)
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
Subject: [PATCH, RFC 52/62] x86/mm: introduce common code for mem encryption
Date:   Wed,  8 May 2019 17:44:12 +0300
Message-Id: <20190508144422.13171-53-kirill.shutemov@linux.intel.com>
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

Both Intel MKTME and AMD SME have needs to support DMA address
translation with encryption related bits. Common functions are
introduced in this patch to keep DMA generic code abstracted.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/Kconfig                 |  4 ++++
 arch/x86/mm/Makefile             |  1 +
 arch/x86/mm/mem_encrypt_common.c | 28 ++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+)
 create mode 100644 arch/x86/mm/mem_encrypt_common.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 62cfb381fee3..ce9642e2c31b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1505,11 +1505,15 @@ config X86_CPA_STATISTICS
 config ARCH_HAS_MEM_ENCRYPT
 	def_bool y
 
+config X86_MEM_ENCRYPT_COMMON
+	def_bool n
+
 config AMD_MEM_ENCRYPT
 	bool "AMD Secure Memory Encryption (SME) support"
 	depends on X86_64 && CPU_SUP_AMD
 	select DYNAMIC_PHYSICAL_MASK
 	select ARCH_USE_MEMREMAP_PROT
+	select X86_MEM_ENCRYPT_COMMON
 	---help---
 	  Say yes to enable support for the encryption of system memory.
 	  This requires an AMD processor that supports Secure Memory
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 4ebee899c363..89dddbc01b1b 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -55,3 +55,4 @@ obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_identity.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_boot.o
 
 obj-$(CONFIG_X86_INTEL_MKTME)	+= mktme.o
+obj-$(CONFIG_X86_MEM_ENCRYPT_COMMON)	+= mem_encrypt_common.o
diff --git a/arch/x86/mm/mem_encrypt_common.c b/arch/x86/mm/mem_encrypt_common.c
new file mode 100644
index 000000000000..2adee65eec46
--- /dev/null
+++ b/arch/x86/mm/mem_encrypt_common.c
@@ -0,0 +1,28 @@
+#include <linux/mm.h>
+#include <linux/mem_encrypt.h>
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
+	return (daddr & ~mktme_keyid_mask) | (keyid << mktme_keyid_shift);
+}
+EXPORT_SYMBOL_GPL(__mem_encrypt_dma_set);
+
+phys_addr_t __mem_encrypt_dma_clear(phys_addr_t paddr)
+{
+	if (sme_active())
+		return __sme_clr(paddr);
+
+	return paddr & ~mktme_keyid_mask;
+}
+EXPORT_SYMBOL_GPL(__mem_encrypt_dma_clear);
-- 
2.20.1

