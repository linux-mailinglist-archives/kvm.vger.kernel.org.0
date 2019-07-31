Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F1A7C599
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388701AbfGaPIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:08:55 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41242 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388650AbfGaPIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:34 -0400
Received: by mail-ed1-f65.google.com with SMTP id p15so65977928eds.8
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bKIWoBO1Ox9foRE7zQy0IoCXQXSDJQsZ/wpbYRrt7O8=;
        b=PbSjR/3YSpT3z0VTol0zIBTaptMjGhUYM3HUndjM3neCQkCTkww5qEep158FrhMPDB
         lOja6cV3oSHoyK5HuysL26jeiqkfqfvW5YCcm+LVastLopDh0evznn9Jq/ft27Nk0yls
         rnC1AKEeGTuwcFgRdFljMrIygrLWBDFyhvLXjbwshxlOfCLSeM8F5NTRRHEv0Ie5JSY0
         b1aiesbbVNHw4aazLYgwIMzT8ab5pWkVI/0jSeHw4sNpg9XZaJV+IqQWo3AWpb2CYE/1
         0iRZiF3T3Y4zZUpFAx0MzBe/Qihdixe290PHhrcx6T5Kzu6+jBCiV+w7prbZ/t0zig7E
         KLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bKIWoBO1Ox9foRE7zQy0IoCXQXSDJQsZ/wpbYRrt7O8=;
        b=m4EaXSttML5FCIUuMGPe4IFzMjji7FbJLPbGFdMxGMrIgyMXiQBLlMyjBiMQn9u/fS
         s/riEBD9JNgE8ISyCONigOE+9PiWpmTXnk+oOF1pHr8pwBMWIAxYuC4EciJ7cMgxYROT
         TBcKZSWwuAcrPIlkwy8/YOJZOBPft4Ck4SelhsxERw7X/vRhmg41M1a7jj31tmapirBo
         CCneiKlEc0k8jqSzfm9bvCpUYoS+Pu1ya8Ghavfb513uUjiDOSw4OtuVjhvA15klS2lv
         7qYzcGaIbLdRokPVMjGvA68LRc3ivMX2rEaCi95sFVsc/4/SQCnACCe2zE9XaYxh0lvh
         iVMQ==
X-Gm-Message-State: APjAAAVjAYjoy/+Yw3XHziZyjp1bjS/Y1QE/MCtivieuPNqZ8YTQq3LD
        e1iuj8PlQdOlxOL1Mh0G3Ok=
X-Google-Smtp-Source: APXvYqxPGPCNvE23xibIXe+57N4H71XsaK3wWKF6xCUN274arFhtKnpkEJtXRg5udE0RuJ4iEKcGYA==
X-Received: by 2002:a05:6402:145a:: with SMTP id d26mr107237799edx.10.1564585712394;
        Wed, 31 Jul 2019 08:08:32 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id g7sm16942446eda.52.2019.07.31.08.08.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:30 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 57277104836; Wed, 31 Jul 2019 18:08:17 +0300 (+03)
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
Subject: [PATCHv2 50/59] x86/mm: Use common code for DMA memory encryption
Date:   Wed, 31 Jul 2019 18:08:04 +0300
Message-Id: <20190731150813.26289-51-kirill.shutemov@linux.intel.com>
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
index 0c196c47d621..62a1493f389c 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -52,8 +52,19 @@ bool sev_active(void);
 
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
@@ -94,4 +105,22 @@ extern char __start_bss_decrypted[], __end_bss_decrypted[], __start_bss_decrypte
 
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
index c11d70151735..588d6ea45624 100644
--- a/arch/x86/mm/mem_encrypt_common.c
+++ b/arch/x86/mm/mem_encrypt_common.c
@@ -1,6 +1,6 @@
 #include <linux/mm.h>
-#include <linux/mem_encrypt.h>
 #include <linux/dma-mapping.h>
+#include <asm/mem_encrypt.h>
 #include <asm/mktme.h>
 
 /*
diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index adf993a3bd58..6ce96b06c440 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -49,12 +49,12 @@ static inline bool force_dma_unencrypted(struct device *dev)
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
index 470bd53a89df..88724aa7c065 100644
--- a/include/linux/mem_encrypt.h
+++ b/include/linux/mem_encrypt.h
@@ -23,6 +23,16 @@
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
@@ -35,19 +45,6 @@ static inline u64 sme_get_me_mask(void)
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
2.21.0

