Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED837C5AA
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388568AbfGaPI1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:08:27 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33626 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388539AbfGaPI0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:26 -0400
Received: by mail-ed1-f66.google.com with SMTP id i11so2524704edq.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q8h8DuVZ5xqSTX4iLf3cQ6iXDhp5mBASA+A6l/JBLBE=;
        b=xxeSkAF5F8BawgLqggNa1C7KQakAR8Gv8h1EsF9xRhmGHNoCGehH3y2hhSqsXfI5VJ
         3IilhUftK/xfQ1BnFLgLdvpKCmJ3WwNKEewuA5okNvH6OWLT4DheVpmjwRezMEp1EoLb
         cEOJRnsObjp7GY+LhQc917g8k4Smbt70KSqtn9oRD2tQKIfdLXGCKJvqAZsVJ9RWw2dO
         ThOpF2m3RrB6lsEasxt939gWNpmK3KvPm+ql5vM7ySNsmqzc+R1EUB7t2y4I3fIGrrXW
         rrTV6R88NJzTEBXXBTrSYqX77BfI78EbIRJPLpACwzuWGMppXW6XpW/8jy6s4yZRv03P
         xuRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q8h8DuVZ5xqSTX4iLf3cQ6iXDhp5mBASA+A6l/JBLBE=;
        b=rh/JKJEcqzjz6vSocmDcYj6hDSpMvPfXi/QzDm3BU4VTp9MZX8q10WcThksyqDs48f
         tTETJ9lRDoFzjiyFasWpzeeAXy3whClI1LAiwHqFq5X+J7vDts+xmVtkGDFeamOBXEVs
         OXxkz4ZyLvmSk9Z+5gbXxmcbqiogXf9Urn5l9Ho6GdXRt+b28OQwy7Fo23TBW3cgegb7
         jG4aI8o4WSUQkj1gXp35SjIuVjtj46tEIZEkbumY11p0qde6jEbt9ys5FKxKtwdInVBd
         Q2OB4SYH6Dwy39n9fxVhbP7PHhQiDJXbXARrQIRrqMCJGrWWHB/HfdgnA04+4b2cBmnO
         XDRQ==
X-Gm-Message-State: APjAAAV6LiN+K4Bs4rzaahB93XWtrJR/nzhSaaneC6REiVMHBGowyoy1
        Z2Q9Y0PlxeGLPf/TnbyMRTw=
X-Google-Smtp-Source: APXvYqykMoqa/jurqmu5qCOTL3FrslOXZsy/cIIViiTktYJvWElboFgFu3JaIVvQUCRpd7Slsk2q4Q==
X-Received: by 2002:aa7:ce91:: with SMTP id y17mr36108223edv.56.1564585705169;
        Wed, 31 Jul 2019 08:08:25 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id z40sm17288443edb.61.2019.07.31.08.08.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:22 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 41A93101323; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 12/59] x86/mm: Add a helper to retrieve KeyID for a page
Date:   Wed, 31 Jul 2019 18:07:26 +0300
Message-Id: <20190731150813.26289-13-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
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
 arch/x86/include/asm/mktme.h | 26 ++++++++++++++++++++++++++
 arch/x86/include/asm/page.h  |  1 +
 arch/x86/mm/mktme.c          | 21 +++++++++++++++++++++
 include/linux/mm.h           |  2 +-
 include/linux/page_ext.h     | 11 ++++++++++-
 mm/page_ext.c                |  3 +++
 6 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mktme.h b/arch/x86/include/asm/mktme.h
index 42a3b1b44669..46041075f617 100644
--- a/arch/x86/include/asm/mktme.h
+++ b/arch/x86/include/asm/mktme.h
@@ -2,6 +2,8 @@
 #define	_ASM_X86_MKTME_H
 
 #include <linux/types.h>
+#include <linux/page_ext.h>
+#include <linux/jump_label.h>
 
 #ifdef CONFIG_X86_INTEL_MKTME
 extern phys_addr_t __mktme_keyid_mask;
@@ -12,10 +14,34 @@ extern int __mktme_nr_keyids;
 extern int mktme_nr_keyids(void);
 extern unsigned int mktme_algs;
 
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
 #else
 #define mktme_keyid_mask()	((phys_addr_t)0)
 #define mktme_nr_keyids()	0
 #define mktme_keyid_shift()	0
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
index 755afc6935b5..48c2d4c97356 100644
--- a/arch/x86/mm/mktme.c
+++ b/arch/x86/mm/mktme.c
@@ -27,3 +27,24 @@ int mktme_nr_keyids(void)
 }
 
 unsigned int mktme_algs;
+
+DEFINE_STATIC_KEY_FALSE(mktme_enabled_key);
+EXPORT_SYMBOL_GPL(mktme_enabled_key);
+
+static bool need_page_mktme(void)
+{
+	/* Make sure keyid doesn't collide with extended page flags */
+	BUILD_BUG_ON(__NR_PAGE_EXT_FLAGS > 16);
+
+	return !!mktme_nr_keyids();
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
index af1a56ff6764..3f9640f388ac 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1645,7 +1645,7 @@ static inline int vma_keyid(struct vm_area_struct *vma)
 #endif
 
 #ifndef page_keyid
-static inline int page_keyid(struct page *page)
+static inline int page_keyid(const struct page *page)
 {
 	return 0;
 }
diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index 09592951725c..a9fa95ae9847 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -22,6 +22,7 @@ enum page_ext_flags {
 	PAGE_EXT_YOUNG,
 	PAGE_EXT_IDLE,
 #endif
+	__NR_PAGE_EXT_FLAGS
 };
 
 /*
@@ -32,7 +33,15 @@ enum page_ext_flags {
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
index 5f5769c7db3b..c52b77c13cd9 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -65,6 +65,9 @@ static struct page_ext_operations *page_ext_ops[] = {
 #if defined(CONFIG_IDLE_PAGE_TRACKING) && !defined(CONFIG_64BIT)
 	&page_idle_ops,
 #endif
+#ifdef CONFIG_X86_INTEL_MKTME
+	&page_mktme_ops,
+#endif
 };
 
 static unsigned long total_usage;
-- 
2.21.0

