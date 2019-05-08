Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD0BE17C79
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfEHOof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:48394 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728004AbfEHOof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:34 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 08 May 2019 07:44:29 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id A94D92DA; Wed,  8 May 2019 17:44:28 +0300 (EEST)
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
Subject: [PATCH, RFC 03/62] mm/ksm: Do not merge pages with different KeyIDs
Date:   Wed,  8 May 2019 17:43:23 +0300
Message-Id: <20190508144422.13171-4-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KeyID indicates what key to use to encrypt and decrypt page's content.
Depending on the implementation a cipher text may be tied to physical
address of the page. It means that pages with an identical plain text
would appear different if KSM would look at a cipher text. It effectively
disables KSM for encrypted pages.

In addition, some implementations may not allow to read cipher text at all.

KSM compares plain text instead (transparently to KSM code).

But we still need to make sure that pages with identical plain text will
not be merged together if they are encrypted with different keys.

To make it work kernel only allows merging pages with the same KeyID.
The approach guarantees that the merged page can be read by all users.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm.h |  7 +++++++
 mm/ksm.c           | 17 +++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 13c40c43ce00..07c36f4673f6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1606,6 +1606,13 @@ static inline int vma_keyid(struct vm_area_struct *vma)
 }
 #endif
 
+#ifndef page_keyid
+static inline int page_keyid(struct page *page)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_SHMEM
 /*
  * The vma_is_shmem is not inline because it is used only by slow
diff --git a/mm/ksm.c b/mm/ksm.c
index fc64874dc6f4..91bce4799c45 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1227,6 +1227,23 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
 	if (!PageAnon(page))
 		goto out;
 
+	/*
+	 * KeyID indicates what key to use to encrypt and decrypt page's
+	 * content.
+	 *
+	 * KSM compares plain text instead (transparently to KSM code).
+	 *
+	 * But we still need to make sure that pages with identical plain
+	 * text will not be merged together if they are encrypted with
+	 * different keys.
+	 *
+	 * To make it work kernel only allows merging pages with the same KeyID.
+	 * The approach guarantees that the merged page can be read by all
+	 * users.
+	 */
+	if (kpage && page_keyid(page) != page_keyid(kpage))
+		goto out;
+
 	/*
 	 * We need the page lock to read a stable PageSwapCache in
 	 * write_protect_page().  We use trylock_page() instead of
-- 
2.20.1

