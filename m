Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00CCE7C5C3
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388061AbfGaPJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:09:45 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41222 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388551AbfGaPI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:28 -0400
Received: by mail-ed1-f67.google.com with SMTP id p15so65977582eds.8
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lUZ5o3KyzJhrWdCGYLPb2yVyWjyFss5E3sxw1k1xFj4=;
        b=f87cDXaJ8tGVJamu+eP2PyzCUG+ZqKOVZGcAGMCXDWHjkJRyvJrzvQl3kbA74mRwxX
         OqfZG5qQ+bo+nU4FmQUQEfW8xtRk3mQqCOhXO4ONCK2ETh94d3kePxhHQni0xuu74lB4
         Y20jFqWjk03QJHsbAjUW4+PFAHLmrv0r6qgsbOO6Jd3/C5xW3cbTj34qRDlJTmRtO5jx
         RWRM2zh83FmKCv2tiLddj/gDtFIbBkm3P+F0EW4xaKzZM7lJSg8hSxUFcFFMufgrsNgt
         eaUf+JW89LkyPwaNnhVGpOMNBErtkA5zeIGuiR/MLONHF6hagKmRxYvFL5eQn9P8H2G7
         0/oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lUZ5o3KyzJhrWdCGYLPb2yVyWjyFss5E3sxw1k1xFj4=;
        b=n8G5QqJuqAZGxcWtWNowkDqu4WQdiXSDjqdEs6q5J0vz2+tG8ncX3HclwWXeN5AdSQ
         vCCwYkJEGz4ssqd8egqxwknjPpkILGgZ3WyLqgQmMELs7JOnQX2wlE3QV6kg8lkKbWjf
         RKaZM84c9dpWQLD0Apz9AofzI5J0kUQ+3roNXaVOF5q9K1P8XoZ6dh3157GV5CjYhS2a
         2CaF4ty1ep07mPWL4ANqqwPRacdrl1QOWJ+pqTwRa1S9oHFGQ2XY/Wp/fpYZRA6mRu8J
         xalBwSPFGh8ABcfxifTJ5CutBLj6yMvmUO1bVZnl4IdMKuA0W65dLcTRoobCwMFW3JwT
         6XHg==
X-Gm-Message-State: APjAAAVk8YDJRzWwxZKvU/ZCMz0ocNxTff3oaL665RLVuZPhM70oDWME
        LwnOUS0/fqcaewxbwVJ5V+c=
X-Google-Smtp-Source: APXvYqwFfmfqoKDjr35+pHqpLUwSHQdO/AlnABQJgMuN58XW0JuVzWoIJ2kNgFPcROx7eyZq64QKqA==
X-Received: by 2002:a17:906:489a:: with SMTP id v26mr95592305ejq.234.1564585706213;
        Wed, 31 Jul 2019 08:08:26 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id b53sm17306948edd.45.2019.07.31.08.08.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:22 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 6BDC6102993; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 18/59] x86/mm: Calculate direct mapping size
Date:   Wed, 31 Jul 2019 18:07:32 +0300
Message-Id: <20190731150813.26289-19-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kernel needs to have a way to access encrypted memory. We have two
option on how approach it:

 - Create temporary mappings every time kernel needs access to encrypted
   memory. That's basically brings highmem and its overhead back.

 - Create multiple direct mappings, one per-KeyID. In this setup we
   don't need to create temporary mappings on the fly -- encrypted
   memory is permanently available in kernel address space.

We take the second approach as it has lower overhead.

It's worth noting that with per-KeyID direct mappings compromised kernel
would give access to decrypted data right away without additional tricks
to get memory mapped with the correct KeyID.

Per-KeyID mappings require a lot more virtual address space. On 4-level
machine with 64 KeyIDs we max out 46-bit virtual address space dedicated
for direct mapping with 1TiB of RAM. Given that we round up any
calculation on direct mapping size to 1TiB, we effectively claim all
46-bit address space for direct mapping on such machine regardless of
RAM size.

Increased usage of virtual address space has implications for KASLR:
we have less space for randomization. With 64 TiB claimed for direct
mapping with 4-level we left with 27 TiB of entropy to place
page_offset_base, vmalloc_base and vmemmap_base.

5-level paging provides much wider virtual address space and KASLR
doesn't suffer significantly from per-KeyID direct mappings.

It's preferred to run MKTME with 5-level paging.

A direct mapping for each KeyID will be put next to each other in the
virtual address space. We need to have a way to find boundaries of
direct mapping for particular KeyID.

The new variable direct_mapping_size specifies the size of direct
mapping. With the value, it's trivial to find direct mapping for
KeyID-N: PAGE_OFFSET + N * direct_mapping_size.

Size of direct mapping is calculated during KASLR setup. If KALSR is
disabled it happens during MKTME initialization.

With MKTME size of direct mapping has to be power-of-2. It makes
implementation of __pa() efficient.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 Documentation/x86/x86_64/mm.rst |  4 +++
 arch/x86/include/asm/page_32.h  |  1 +
 arch/x86/include/asm/page_64.h  |  2 ++
 arch/x86/include/asm/setup.h    |  6 ++++
 arch/x86/kernel/head64.c        |  4 +++
 arch/x86/kernel/setup.c         |  3 ++
 arch/x86/mm/init_64.c           | 58 +++++++++++++++++++++++++++++++++
 arch/x86/mm/kaslr.c             | 11 +++++--
 8 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/x86_64/mm.rst b/Documentation/x86/x86_64/mm.rst
index 267fc4808945..7978afe6c396 100644
--- a/Documentation/x86/x86_64/mm.rst
+++ b/Documentation/x86/x86_64/mm.rst
@@ -140,6 +140,10 @@ The direct mapping covers all memory in the system up to the highest
 memory address (this means in some cases it can also include PCI memory
 holes).
 
+With MKTME, we have multiple direct mappings. One per-KeyID. They are put
+next to each other. PAGE_OFFSET + N * direct_mapping_size can be used to
+find direct mapping for KeyID-N.
+
 vmalloc space is lazily synchronized into the different PML4/PML5 pages of
 the processes using the page fault handler, with init_top_pgt as
 reference.
diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index 94dbd51df58f..8bce788f9ca9 100644
--- a/arch/x86/include/asm/page_32.h
+++ b/arch/x86/include/asm/page_32.h
@@ -6,6 +6,7 @@
 
 #ifndef __ASSEMBLY__
 
+#define direct_mapping_size 0
 #define __phys_addr_nodebug(x)	((x) - PAGE_OFFSET)
 #ifdef CONFIG_DEBUG_VIRTUAL
 extern unsigned long __phys_addr(unsigned long);
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 939b1cff4a7b..f57fc3cc2246 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -14,6 +14,8 @@ extern unsigned long phys_base;
 extern unsigned long page_offset_base;
 extern unsigned long vmalloc_base;
 extern unsigned long vmemmap_base;
+extern unsigned long direct_mapping_size;
+extern unsigned long direct_mapping_mask;
 
 static inline unsigned long __phys_addr_nodebug(unsigned long x)
 {
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index ed8ec011a9fd..d2861074cf83 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -62,6 +62,12 @@ extern void x86_ce4100_early_setup(void);
 static inline void x86_ce4100_early_setup(void) { }
 #endif
 
+#ifdef CONFIG_MEMORY_PHYSICAL_PADDING
+void calculate_direct_mapping_size(void);
+#else
+static inline void calculate_direct_mapping_size(void) { }
+#endif
+
 #ifndef _SETUP
 
 #include <asm/espfix.h>
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 29ffa495bd1c..006d3ff46afe 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -60,6 +60,10 @@ EXPORT_SYMBOL(vmalloc_base);
 unsigned long vmemmap_base __ro_after_init = __VMEMMAP_BASE_L4;
 EXPORT_SYMBOL(vmemmap_base);
 #endif
+unsigned long direct_mapping_size __ro_after_init = -1UL;
+EXPORT_SYMBOL(direct_mapping_size);
+unsigned long direct_mapping_mask __ro_after_init = -1UL;
+EXPORT_SYMBOL(direct_mapping_mask);
 
 #define __head	__section(.head.text)
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index bbe35bf879f5..d12431e20876 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1077,6 +1077,9 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	init_cache_modes();
 
+	 /* direct_mapping_size has to be initialized before KASLR and MKTME */
+	calculate_direct_mapping_size();
+
 	/*
 	 * Define random base addresses for memory sections after max_pfn is
 	 * defined and before each memory section base is used.
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index a6b5c653727b..4c1f93df47a5 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1440,6 +1440,64 @@ unsigned long memory_block_size_bytes(void)
 	return memory_block_size_probed;
 }
 
+#ifdef CONFIG_MEMORY_PHYSICAL_PADDING
+void __init calculate_direct_mapping_size(void)
+{
+	unsigned long available_va;
+
+	/* 1/4 of virtual address space is didicated for direct mapping */
+	available_va = 1UL << (__VIRTUAL_MASK_SHIFT - 1);
+
+	/* How much memory the system has? */
+	direct_mapping_size = max_pfn << PAGE_SHIFT;
+	direct_mapping_size = round_up(direct_mapping_size, 1UL << 40);
+
+	if (!mktme_nr_keyids())
+		goto out;
+
+	/*
+	 * For MKTME we need direct_mapping_size to be power-of-2.
+	 * It makes __pa() implementation efficient.
+	 */
+	direct_mapping_size = roundup_pow_of_two(direct_mapping_size);
+
+	/*
+	 * Not enough virtual address space to address all physical memory with
+	 * MKTME enabled. Even without padding.
+	 *
+	 * Disable MKTME instead.
+	 */
+	if (direct_mapping_size > available_va / (mktme_nr_keyids() + 1)) {
+		pr_err("x86/mktme: Disabled. Not enough virtual address space\n");
+		pr_err("x86/mktme: Consider switching to 5-level paging\n");
+		mktme_disable();
+		goto out;
+	}
+
+	/*
+	 * Virtual address space is divided between per-KeyID direct mappings.
+	 */
+	available_va /= mktme_nr_keyids() + 1;
+out:
+	/* Add padding, if there's enough virtual address space */
+	direct_mapping_size += (1UL << 40) * CONFIG_MEMORY_PHYSICAL_PADDING;
+	if (mktme_nr_keyids())
+		direct_mapping_size = roundup_pow_of_two(direct_mapping_size);
+
+	if (direct_mapping_size > available_va)
+		direct_mapping_size = available_va;
+
+	/*
+	 * For MKTME, make sure direct_mapping_size is still power-of-2
+	 * after adding padding and calculate mask that is used in __pa().
+	 */
+	if (mktme_nr_keyids()) {
+		direct_mapping_size = rounddown_pow_of_two(direct_mapping_size);
+		direct_mapping_mask = direct_mapping_size - 1;
+	}
+}
+#endif
+
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 /*
  * Initialise the sparsemem vmemmap using huge-pages at the PMD level.
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 580b82c2621b..83af41d289ed 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -103,10 +103,15 @@ void __init kernel_randomize_memory(void)
 	 * add padding if needed (especially for memory hotplug support).
 	 */
 	BUG_ON(kaslr_regions[0].base != &page_offset_base);
-	memory_tb = DIV_ROUND_UP(max_pfn << PAGE_SHIFT, 1UL << TB_SHIFT) +
-		CONFIG_MEMORY_PHYSICAL_PADDING;
 
-	/* Adapt phyiscal memory region size based on available memory */
+	/*
+	 * Calculate space required to map all physical memory.
+	 * In case of MKTME, we map physical memory multiple times, one for
+	 * each KeyID. If MKTME is disabled mktme_nr_keyids() is 0.
+	 */
+	memory_tb = (direct_mapping_size * (mktme_nr_keyids() + 1)) >> TB_SHIFT;
+
+	/* Adapt physical memory region size based on available memory */
 	if (memory_tb < kaslr_regions[0].size_tb)
 		kaslr_regions[0].size_tb = memory_tb;
 
-- 
2.21.0

