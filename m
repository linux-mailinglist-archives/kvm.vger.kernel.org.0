Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3CCC7C591
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388665AbfGaPIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:08:35 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33647 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388644AbfGaPIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:34 -0400
Received: by mail-ed1-f67.google.com with SMTP id i11so2525063edq.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WXT2KCVQy2E86WIHV388gpcH/h/cqapkcTgzB8ITRTY=;
        b=gbgwfZZpKF7Zw4y/Cy0+El8MhN5OgIgEsj0rN2nkj9PakelkWIC/N62lsNpt78P51H
         jvP8xx7Juipvx0RgC4SB4vNCw1P4PSVg2b2+doiEir7dfWiW3vsGXqpbQGM6KNexQSTP
         r3fNkw3L7doZwwJenk62AM3aDDoLUPKu0t7NkU1I3mRXbo3XJ9NXobg93l8rusAKYuRo
         dypVLFF2TyUrUJhBYMTvoExAgOrk1M4x1MfzcZx90KOF0LZV+HC3Q1R85RN5+Yd5tXFt
         ULtpKhZLGf3u8jhLzjctfNyP1AJ1tjB1U+mn3PJugnraGtaxozLw2DlDsbKDrENsFSdN
         bcCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WXT2KCVQy2E86WIHV388gpcH/h/cqapkcTgzB8ITRTY=;
        b=o8yik4tXKKWG/s8JlLBCSTTzmUOF8dQL3/7YlKrnqOezAW0h9dZeNEol51qubdOkeU
         Ms+06MnGoQE7Hn9Be2iwsjTTbnMot/op7bHZ+2XRjqGSBi8DXswt6501byTqoGuO5TbQ
         DbVQkx+NV6O+fxQDfTqVc0sBpYktvpIzP1MJ4AClp7/ZLkAiGkZErL9M5s0Gd+0XHaTT
         e7yc5RzYovBseJSfPw/X913LbyK+74DT7X8YQPtryVqgPlGVT68BdV6mmlFzE0nd8uNy
         kGRaPbaucJ3/SrQxKelwdUbV/PpO5GQvgDfRLveRVZeuvlXjltDoqDjAEBqnPQpspWDM
         /Mlw==
X-Gm-Message-State: APjAAAWGJwIW6nR9/PA8z05nl2NAwWikp7nxiltYncRkaDk8GuE2/en8
        ejbSIc/KLU31SnC7mWj6GNQ=
X-Google-Smtp-Source: APXvYqwiaqlBMCu7NWbE38q/iVndeTnZvf7qpo+nZ6NbB+Pm6uXYyVJ+okRcWjQSuw2bxKJtzce2+A==
X-Received: by 2002:a50:f70c:: with SMTP id g12mr108973248edn.139.1564585712069;
        Wed, 31 Jul 2019 08:08:32 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id b15sm5578799ejj.5.2019.07.31.08.08.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:30 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 2C437104602; Wed, 31 Jul 2019 18:08:17 +0300 (+03)
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
Subject: [PATCHv2 44/59] mm: Add the encrypt_mprotect() system call for MKTME
Date:   Wed, 31 Jul 2019 18:07:58 +0300
Message-Id: <20190731150813.26289-45-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
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
index c71cbfe6826a..261e81b7e3a4 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -756,8 +756,8 @@ int setup_arg_pages(struct linux_binprm *bprm,
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
index 98a6d2bd66a6..8551b5ebdedf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1660,7 +1660,8 @@ extern unsigned long change_protection(struct vm_area_struct *vma, unsigned long
 			      int dirty_accountable, int prot_numa);
 extern int mprotect_fixup(struct vm_area_struct *vma,
 			  struct vm_area_struct **pprev, unsigned long start,
-			  unsigned long end, unsigned long newflags);
+			  unsigned long end, unsigned long newflags,
+			  int newkeyid);
 
 /*
  * doesn't attempt to fault and will return short.
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 4d55725228e3..518d75582e7b 100644
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
@@ -348,7 +349,8 @@ static int prot_none_walk(struct vm_area_struct *vma, unsigned long start,
 
 int
 mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
-	unsigned long start, unsigned long end, unsigned long newflags)
+	       unsigned long start, unsigned long end, unsigned long newflags,
+	       int newkeyid)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long oldflags = vma->vm_flags;
@@ -358,7 +360,14 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
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
@@ -424,6 +433,8 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
 	}
 
 success:
+	if (newkeyid != NO_KEY)
+		mprotect_set_encrypt(vma, newkeyid, start, end);
 	/*
 	 * vm_flags and vm_page_prot are protected by the mmap_sem
 	 * held in write mode.
@@ -455,10 +466,15 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
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
@@ -556,7 +572,8 @@ static int do_mprotect_ext(unsigned long start, size_t len,
 		tmp = vma->vm_end;
 		if (tmp > end)
 			tmp = end;
-		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
+		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags,
+				       keyid);
 		if (error)
 			goto out;
 		nstart = tmp;
@@ -581,7 +598,7 @@ static int do_mprotect_ext(unsigned long start, size_t len,
 SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
 		unsigned long, prot)
 {
-	return do_mprotect_ext(start, len, prot, NO_KEY);
+	return do_mprotect_ext(start, len, prot, NO_KEY, NO_KEY);
 }
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
@@ -589,7 +606,7 @@ SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
 SYSCALL_DEFINE4(pkey_mprotect, unsigned long, start, size_t, len,
 		unsigned long, prot, int, pkey)
 {
-	return do_mprotect_ext(start, len, prot, pkey);
+	return do_mprotect_ext(start, len, prot, pkey, NO_KEY);
 }
 
 SYSCALL_DEFINE2(pkey_alloc, unsigned long, flags, unsigned long, init_val)
@@ -638,3 +655,40 @@ SYSCALL_DEFINE1(pkey_free, int, pkey)
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
2.21.0

