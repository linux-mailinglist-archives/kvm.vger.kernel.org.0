Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6844417BFB
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbfEHOqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:46:40 -0400
Received: from mga06.intel.com ([134.134.136.31]:57687 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728541AbfEHOoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:54 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 08 May 2019 07:44:49 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id BCB7F11CF; Wed,  8 May 2019 17:44:31 +0300 (EEST)
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
Subject: [PATCH, RFC 61/62] x86/mktme: Document the MKTME API for anonymous memory encryption
Date:   Wed,  8 May 2019 17:44:21 +0300
Message-Id: <20190508144422.13171-62-kirill.shutemov@linux.intel.com>
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

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 Documentation/x86/mktme/index.rst         |  1 +
 Documentation/x86/mktme/mktme_encrypt.rst | 57 +++++++++++++++++++++++
 2 files changed, 58 insertions(+)
 create mode 100644 Documentation/x86/mktme/mktme_encrypt.rst

diff --git a/Documentation/x86/mktme/index.rst b/Documentation/x86/mktme/index.rst
index 8cf2b7d62091..ca3c76adc596 100644
--- a/Documentation/x86/mktme/index.rst
+++ b/Documentation/x86/mktme/index.rst
@@ -9,3 +9,4 @@ Multi-Key Total Memory Encryption (MKTME)
    mktme_mitigations
    mktme_configuration
    mktme_keys
+   mktme_encrypt
diff --git a/Documentation/x86/mktme/mktme_encrypt.rst b/Documentation/x86/mktme/mktme_encrypt.rst
new file mode 100644
index 000000000000..5cdffabc610f
--- /dev/null
+++ b/Documentation/x86/mktme/mktme_encrypt.rst
@@ -0,0 +1,57 @@
+MKTME API: system call encrypt_mprotect()
+=========================================
+
+Synopsis
+--------
+int encrypt_mprotect(void \*addr, size_t len, int prot, key_serial_t serial);
+
+Where *key_serial_t serial* is the serial number of a key allocated
+using the MKTME Key Service.
+
+Description
+-----------
+    encrypt_mprotect() encrypts the memory pages containing any part
+    of the address range in the interval specified by addr and len.
+
+    encrypt_mprotect() supports the legacy mprotect() behavior plus
+    the enabling of memory encryption. That means that in addition
+    to encrypting the memory, the protection flags will be updated
+    as requested in the call.
+
+    The *addr* and *len* must be aligned to a page boundary.
+
+    The caller must have *KEY_NEED_VIEW* permission on the key.
+
+    The range of memory that is to be protected must be mapped as
+    *ANONYMOUS*.
+
+Errors
+------
+    In addition to the Errors returned from legacy mprotect()
+    encrypt_mprotect will return:
+
+    ENOKEY *serial* parameter does not represent a valid key.
+
+    EINVAL *len* parameter is not page aligned.
+
+    EACCES Caller does not have *KEY_NEED_VIEW* permission on the key.
+
+EXAMPLE
+--------
+  Allocate an MKTME Key::
+        serial = add_key("mktme", "name", "type=cpu algorithm=aes-xts-128" @u
+
+  Map ANONYMOUS memory::
+        ptr = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
+
+  Protect memory::
+        ret = syscall(SYS_encrypt_mprotect, ptr, size, PROT_READ|PROT_WRITE,
+                      serial);
+
+  Use the encrypted memory
+
+  Free memory::
+        ret = munmap(ptr, size);
+
+  Free the key resource::
+        ret = keyctl(KEYCTL_INVALIDATE, serial);
-- 
2.20.1

