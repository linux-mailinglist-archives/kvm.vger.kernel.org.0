Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A5517C1C
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbfEHOrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:47:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:59540 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbfEHOov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:49 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 08 May 2019 07:44:45 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 0BEE5F6B; Wed,  8 May 2019 17:44:31 +0300 (EEST)
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
Subject: [PATCH, RFC 46/62] x86/mm: Keep reference counts on encrypted VMAs for MKTME
Date:   Wed,  8 May 2019 17:44:06 +0300
Message-Id: <20190508144422.13171-47-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alison Schofield <alison.schofield@intel.com>

The MKTME (Multi-Key Total Memory Encryption) Key Service needs
a reference count on encrypted VMAs. This reference count is used
to determine when a hardware encryption KeyID is no longer in use
and can be freed and reassigned to another Userspace Key.

The MKTME Key service does the percpu_ref_init and _kill, so
these gets/puts on encrypted VMA's can be considered the
intermediaries in the lifetime of the key.

Increment/decrement the reference count during encrypt_mprotect()
system call for initial or updated encryption on a VMA.

Piggy back on the vm_area_dup/free() helpers. If the VMAs being
duplicated, or freed are encrypted, adjust the reference count.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/mktme.h |  5 +++++
 arch/x86/mm/mktme.c          | 37 ++++++++++++++++++++++++++++++++++--
 include/linux/mm.h           |  2 ++
 kernel/fork.c                |  2 ++
 4 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mktme.h b/arch/x86/include/asm/mktme.h
index 0e6df07f1921..14da002d2e85 100644
--- a/arch/x86/include/asm/mktme.h
+++ b/arch/x86/include/asm/mktme.h
@@ -16,6 +16,11 @@ extern int mktme_keyid_shift;
 extern void mprotect_set_encrypt(struct vm_area_struct *vma, int newkeyid,
 				unsigned long start, unsigned long end);
 
+/* MTKME encrypt_count for VMAs */
+extern struct percpu_ref *encrypt_count;
+extern void vma_get_encrypt_ref(struct vm_area_struct *vma);
+extern void vma_put_encrypt_ref(struct vm_area_struct *vma);
+
 DECLARE_STATIC_KEY_FALSE(mktme_enabled_key);
 static inline bool mktme_enabled(void)
 {
diff --git a/arch/x86/mm/mktme.c b/arch/x86/mm/mktme.c
index 91b49e88ca3f..df70651816a1 100644
--- a/arch/x86/mm/mktme.c
+++ b/arch/x86/mm/mktme.c
@@ -66,11 +66,12 @@ void mprotect_set_encrypt(struct vm_area_struct *vma, int newkeyid,
 
 	if (oldkeyid == newkeyid)
 		return;
-
+	vma_put_encrypt_ref(vma);
 	newprot = pgprot_val(vma->vm_page_prot);
 	newprot &= ~mktme_keyid_mask;
 	newprot |= (unsigned long)newkeyid << mktme_keyid_shift;
 	vma->vm_page_prot = __pgprot(newprot);
+	vma_get_encrypt_ref(vma);
 
 	/*
 	 * The VMA doesn't have any inherited pages.
@@ -79,6 +80,18 @@ void mprotect_set_encrypt(struct vm_area_struct *vma, int newkeyid,
 	unlink_anon_vmas(vma);
 }
 
+void vma_get_encrypt_ref(struct vm_area_struct *vma)
+{
+	if (vma_keyid(vma))
+		percpu_ref_get(&encrypt_count[vma_keyid(vma)]);
+}
+
+void vma_put_encrypt_ref(struct vm_area_struct *vma)
+{
+	if (vma_keyid(vma))
+		percpu_ref_put(&encrypt_count[vma_keyid(vma)]);
+}
+
 /* Prepare page to be used for encryption. Called from page allocator. */
 void __prep_encrypted_page(struct page *page, int order, int keyid, bool zero)
 {
@@ -102,6 +115,22 @@ void __prep_encrypted_page(struct page *page, int order, int keyid, bool zero)
 
 		page++;
 	}
+
+	/*
+	 * Make sure the KeyID cannot be freed until the last page that
+	 * uses the KeyID is gone.
+	 *
+	 * This is required because the page may live longer than VMA it
+	 * is mapped into (i.e. in get_user_pages() case) and having
+	 * refcounting per-VMA is not enough.
+	 *
+	 * Taking a reference per-4K helps in case if the page will be
+	 * split after the allocation. free_encrypted_page() will balance
+	 * out the refcount even if the page was split and freed as bunch
+	 * of 4K pages.
+	 */
+
+	percpu_ref_get_many(&encrypt_count[keyid], 1 << order);
 }
 
 /*
@@ -110,7 +139,9 @@ void __prep_encrypted_page(struct page *page, int order, int keyid, bool zero)
  */
 void free_encrypted_page(struct page *page, int order)
 {
-	int i;
+	int i, keyid;
+
+	keyid = page_keyid(page);
 
 	/*
 	 * The hardware/CPU does not enforce coherency between mappings
@@ -125,6 +156,8 @@ void free_encrypted_page(struct page *page, int order)
 		lookup_page_ext(page)->keyid = 0;
 		page++;
 	}
+
+	percpu_ref_put_many(&encrypt_count[keyid], 1 << order);
 }
 
 static int sync_direct_mapping_pte(unsigned long keyid,
diff --git a/include/linux/mm.h b/include/linux/mm.h
index a7f52d053826..00c0fd70816b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2831,6 +2831,8 @@ static inline void mprotect_set_encrypt(struct vm_area_struct *vma,
 					int newkeyid,
 					unsigned long start,
 					unsigned long end) {}
+static inline void vma_get_encrypt_ref(struct vm_area_struct *vma) {}
+static inline void vma_put_encrypt_ref(struct vm_area_struct *vma) {}
 #endif /* CONFIG_X86_INTEL_MKTME */
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 9dcd18aa210b..f0e35ed76f5a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -342,12 +342,14 @@ struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig)
 	if (new) {
 		*new = *orig;
 		INIT_LIST_HEAD(&new->anon_vma_chain);
+		vma_get_encrypt_ref(new);
 	}
 	return new;
 }
 
 void vm_area_free(struct vm_area_struct *vma)
 {
+	vma_put_encrypt_ref(vma);
 	kmem_cache_free(vm_area_cachep, vma);
 }
 
-- 
2.20.1

