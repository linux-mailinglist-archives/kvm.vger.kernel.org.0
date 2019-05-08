Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1610E17BF6
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbfEHOow (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:48407 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728420AbfEHOou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP; 08 May 2019 07:44:49 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 08 May 2019 07:44:44 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id F254AF65; Wed,  8 May 2019 17:44:30 +0300 (EEST)
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
Subject: [PATCH, RFC 45/62] mm: Add the encrypt_mprotect() system call for MKTME
Date:   Wed,  8 May 2019 17:44:05 +0300
Message-Id: <20190508144422.13171-46-kirill.shutemov@linux.intel.com>
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

Implement memory encryption for MKTME (Multi-Key Total Memory
Encryption) with a new system call that is an extension of the
legacy mprotect() system call.

In encrypt_mprotect the caller must pass a handle to a previously
allocated and programmed MKTME encryption key. The key can be
obtained through the kernel key service type "mktme". The caller
must have KEY_NEED_VIEW permission on the key.

MKTME places an additional restriction on the protected data:
The length of the data must be page aligned. This is in addition
to the existing mprotect restriction that the addr must be page
aligned.

encrypt_mprotect() will lookup the hardware keyid for the given
userspace key. It will use previously defined helpers to insert
that keyid in the VMAs during legacy mprotect() execution.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/exec.c          |  4 +--
 include/linux/mm.h |  3 +-
 mm/mprotect.c      | 68 +++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 65 insertions(+), 10 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 2e0033348d8e..695c121b34b3 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -755,8 +755,8 @@ int setup_arg_pages(struct linux_binprm *bprm,
 	vm_flags |= mm->def_flags;
 	vm_flags |= VM_STACK_INCOMPLETE_SETUP;
 
-	ret = mprotect_fixup(vma, &prev, vma->vm_start, vma->vm_end,
-			vm_flags);
+	ret = mprotect_fixup(vma, &prev, vma->vm_start, vma->vm_end, vm_flags,
+			     -1);
 	if (ret)
 		goto out_unlock;
 	BUG_ON(prev != vma);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c027044de9bf..a7f52d053826 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1634,7 +1634,8 @@ extern unsigned long change_protection(struct vm_area_struct *vma, unsigned long
 			      int dirty_accountable, int prot_numa);
 extern int mprotect_fixup(struct vm_area_struct *vma,
 			  struct vm_area_struct **pprev, unsigned long start,
-			  unsigned long end, unsigned long newflags);
+			  unsigned long end, unsigned long newflags,
+			  int newkeyid);
 
 /*
  * doesn't attempt to fault and will return short.
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 23e680f4b1d5..38d766b5cc20 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -28,6 +28,7 @@
 #include <linux/ksm.h>
 #include <linux/uaccess.h>
 #include <linux/mm_inline.h>
+#include <linux/key.h>
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
@@ -347,7 +348,8 @@ static int prot_none_walk(struct vm_area_struct *vma, unsigned long start,
 
 int
 mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
-	unsigned long start, unsigned long end, unsigned long newflags)
+	       unsigned long start, unsigned long end, unsigned long newflags,
+	       int newkeyid)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long oldflags = vma->vm_flags;
@@ -357,7 +359,14 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
 	int error;
 	int dirty_accountable = 0;
 
-	if (newflags == oldflags) {
+	/*
+	 * Flags match and Keyids match or we have NO_KEY.
+	 * This _fixup is usually called from do_mprotect_ext() except
+	 * for one special case: caller fs/exec.c/setup_arg_pages()
+	 * In that case, newkeyid is passed as -1 (NO_KEY).
+	 */
+	if (newflags == oldflags &&
+	    (newkeyid == vma_keyid(vma) || newkeyid == NO_KEY)) {
 		*pprev = vma;
 		return 0;
 	}
@@ -423,6 +432,8 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
 	}
 
 success:
+	if (newkeyid != NO_KEY)
+		mprotect_set_encrypt(vma, newkeyid, start, end);
 	/*
 	 * vm_flags and vm_page_prot are protected by the mmap_sem
 	 * held in write mode.
@@ -454,10 +465,15 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
 }
 
 /*
- * When pkey==NO_KEY we get legacy mprotect behavior here.
+ * do_mprotect_ext() supports the legacy mprotect behavior plus extensions
+ * for Protection Keys and Memory Encryption Keys. These extensions are
+ * mutually exclusive and the behavior is:
+ *	(pkey==NO_KEY && keyid==NO_KEY) ==> legacy mprotect
+ *	(pkey is valid)  ==> legacy mprotect plus Protection Key extensions
+ *	(keyid is valid) ==> legacy mprotect plus Encryption Key extensions
  */
 static int do_mprotect_ext(unsigned long start, size_t len,
-		unsigned long prot, int pkey)
+			   unsigned long prot, int pkey, int keyid)
 {
 	unsigned long nstart, end, tmp, reqprot;
 	struct vm_area_struct *vma, *prev;
@@ -555,7 +571,8 @@ static int do_mprotect_ext(unsigned long start, size_t len,
 		tmp = vma->vm_end;
 		if (tmp > end)
 			tmp = end;
-		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
+		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags,
+				       keyid);
 		if (error)
 			goto out;
 		nstart = tmp;
@@ -580,7 +597,7 @@ static int do_mprotect_ext(unsigned long start, size_t len,
 SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
 		unsigned long, prot)
 {
-	return do_mprotect_ext(start, len, prot, NO_KEY);
+	return do_mprotect_ext(start, len, prot, NO_KEY, NO_KEY);
 }
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
@@ -588,7 +605,7 @@ SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
 SYSCALL_DEFINE4(pkey_mprotect, unsigned long, start, size_t, len,
 		unsigned long, prot, int, pkey)
 {
-	return do_mprotect_ext(start, len, prot, pkey);
+	return do_mprotect_ext(start, len, prot, pkey, NO_KEY);
 }
 
 SYSCALL_DEFINE2(pkey_alloc, unsigned long, flags, unsigned long, init_val)
@@ -637,3 +654,40 @@ SYSCALL_DEFINE1(pkey_free, int, pkey)
 }
 
 #endif /* CONFIG_ARCH_HAS_PKEYS */
+
+#ifdef CONFIG_X86_INTEL_MKTME
+
+extern int mktme_keyid_from_key(struct key *key);
+
+SYSCALL_DEFINE4(encrypt_mprotect, unsigned long, start, size_t, len,
+		unsigned long, prot, key_serial_t, serial)
+{
+	key_ref_t key_ref;
+	struct key *key;
+	int ret, keyid;
+
+	/* MKTME restriction */
+	if (!PAGE_ALIGNED(len))
+		return -EINVAL;
+
+	/*
+	 * key_ref prevents the destruction of the key
+	 * while the memory encryption is being set up.
+	 */
+
+	key_ref = lookup_user_key(serial, 0, KEY_NEED_VIEW);
+	if (IS_ERR(key_ref))
+		return PTR_ERR(key_ref);
+
+	key = key_ref_to_ptr(key_ref);
+	keyid = mktme_keyid_from_key(key);
+	if (!keyid) {
+		key_ref_put(key_ref);
+		return -EINVAL;
+	}
+	ret = do_mprotect_ext(start, len, prot, NO_KEY, keyid);
+	key_ref_put(key_ref);
+	return ret;
+}
+
+#endif /* CONFIG_X86_INTEL_MKTME */
-- 
2.20.1

