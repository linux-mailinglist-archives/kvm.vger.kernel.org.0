Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B324A17C74
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbfEHOom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:61868 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728136AbfEHOol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:40 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 08 May 2019 07:44:35 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 323C8739; Wed,  8 May 2019 17:44:29 +0300 (EEST)
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
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH, RFC 11/62] x86/mm: Add a helper to retrieve KeyID for a page
Date:   Wed,  8 May 2019 17:43:31 +0300
Message-Id: <20190508144422.13171-12-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

page_ext allows to store additional per-page information without growing
main struct page. The additional space can be requested at boot time.

Store KeyID in bits 31:16 of extended page flags. These bits are unused.

page_keyid() returns zero until page_ext is ready. page_ext initializer
enables a static branch to indicate that page_keyid() can use page_ext.
The same static branch will gate MKTME readiness in general.

We don't yet set KeyID for the page. It will come in the following
patch that implements prep_encrypted_page(). All pages have KeyID-0 for
now.

page_keyid() will be used by KVM which can be built as a module. We need
to export mktme_enabled_key to be able to inline page_keyid().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/mktme.h | 28 ++++++++++++++++++++++++++++
 arch/x86/include/asm/page.h  |  1 +
 arch/x86/mm/mktme.c          | 21 +++++++++++++++++++++
 include/linux/mm.h           |  2 +-
 include/linux/page_ext.h     | 11 ++++++++++-
 mm/page_ext.c                |  3 +++
 6 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mktme.h b/arch/x86/include/asm/mktme.h
index df31876ec48c..51f831b94179 100644
--- a/arch/x86/include/asm/mktme.h
+++ b/arch/x86/include/asm/mktme.h
@@ -2,15 +2,43 @@
 #define	_ASM_X86_MKTME_H
 
 #include <linux/types.h>
+#include <linux/page_ext.h>
+#include <linux/jump_label.h>
 
 #ifdef CONFIG_X86_INTEL_MKTME
 extern phys_addr_t mktme_keyid_mask;
 extern int mktme_nr_keyids;
 extern int mktme_keyid_shift;
+
+DECLARE_STATIC_KEY_FALSE(mktme_enabled_key);
+static inline bool mktme_enabled(void)
+{
+	return static_branch_unlikely(&mktme_enabled_key);
+}
+
+extern struct page_ext_operations page_mktme_ops;
+
+#define page_keyid page_keyid
+static inline int page_keyid(const struct page *page)
+{
+	if (!mktme_enabled())
+		return 0;
+
+	return lookup_page_ext(page)->keyid;
+}
+
+
 #else
 #define mktme_keyid_mask	((phys_addr_t)0)
 #define mktme_nr_keyids		0
 #define mktme_keyid_shift	0
+
+#define page_keyid(page) 0
+
+static inline bool mktme_enabled(void)
+{
+	return false;
+}
 #endif
 
 #endif
diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 7555b48803a8..39af59487d5f 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -19,6 +19,7 @@
 struct page;
 
 #include <linux/range.h>
+#include <asm/mktme.h>
 extern struct range pfn_mapped[];
 extern int nr_pfn_mapped;
 
diff --git a/arch/x86/mm/mktme.c b/arch/x86/mm/mktme.c
index 91a415612519..9dc256e3654b 100644
--- a/arch/x86/mm/mktme.c
+++ b/arch/x86/mm/mktme.c
@@ -9,3 +9,24 @@ phys_addr_t mktme_keyid_mask;
 int mktme_nr_keyids;
 /* Shift of KeyID within physical address. */
 int mktme_keyid_shift;
+
+DEFINE_STATIC_KEY_FALSE(mktme_enabled_key);
+EXPORT_SYMBOL_GPL(mktme_enabled_key);
+
+static bool need_page_mktme(void)
+{
+	/* Make sure keyid doesn't collide with extended page flags */
+	BUILD_BUG_ON(__NR_PAGE_EXT_FLAGS > 16);
+
+	return !!mktme_nr_keyids;
+}
+
+static void init_page_mktme(void)
+{
+	static_branch_enable(&mktme_enabled_key);
+}
+
+struct page_ext_operations page_mktme_ops = {
+	.need = need_page_mktme,
+	.init = init_page_mktme,
+};
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 07c36f4673f6..2684245f8503 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1607,7 +1607,7 @@ static inline int vma_keyid(struct vm_area_struct *vma)
 #endif
 
 #ifndef page_keyid
-static inline int page_keyid(struct page *page)
+static inline int page_keyid(const struct page *page)
 {
 	return 0;
 }
diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index f84f167ec04c..d9c5aae9523f 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -23,6 +23,7 @@ enum page_ext_flags {
 	PAGE_EXT_YOUNG,
 	PAGE_EXT_IDLE,
 #endif
+	__NR_PAGE_EXT_FLAGS
 };
 
 /*
@@ -33,7 +34,15 @@ enum page_ext_flags {
  * then the page_ext for pfn always exists.
  */
 struct page_ext {
-	unsigned long flags;
+	union {
+		unsigned long flags;
+#ifdef CONFIG_X86_INTEL_MKTME
+		struct {
+			unsigned short __pad;
+			unsigned short keyid;
+		};
+#endif
+	};
 };
 
 extern void pgdat_page_ext_init(struct pglist_data *pgdat);
diff --git a/mm/page_ext.c b/mm/page_ext.c
index d8f1aca4ad43..1af8b82087f2 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -68,6 +68,9 @@ static struct page_ext_operations *page_ext_ops[] = {
 #if defined(CONFIG_IDLE_PAGE_TRACKING) && !defined(CONFIG_64BIT)
 	&page_idle_ops,
 #endif
+#ifdef CONFIG_X86_INTEL_MKTME
+	&page_mktme_ops,
+#endif
 };
 
 static unsigned long total_usage;
-- 
2.20.1

