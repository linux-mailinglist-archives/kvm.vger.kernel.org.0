Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA93917BEB
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbfEHOo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:59551 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728573AbfEHOo5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:57 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:53 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 08 May 2019 07:44:49 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id CA21811F7; Wed,  8 May 2019 17:44:31 +0300 (EEST)
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
Subject: [PATCH, RFC 62/62] x86/mktme: Demonstration program using the MKTME APIs
Date:   Wed,  8 May 2019 17:44:22 +0300
Message-Id: <20190508144422.13171-63-kirill.shutemov@linux.intel.com>
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
 Documentation/x86/mktme/index.rst      |  1 +
 Documentation/x86/mktme/mktme_demo.rst | 53 ++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)
 create mode 100644 Documentation/x86/mktme/mktme_demo.rst

diff --git a/Documentation/x86/mktme/index.rst b/Documentation/x86/mktme/index.rst
index ca3c76adc596..3af322d13225 100644
--- a/Documentation/x86/mktme/index.rst
+++ b/Documentation/x86/mktme/index.rst
@@ -10,3 +10,4 @@ Multi-Key Total Memory Encryption (MKTME)
    mktme_configuration
    mktme_keys
    mktme_encrypt
+   mktme_demo
diff --git a/Documentation/x86/mktme/mktme_demo.rst b/Documentation/x86/mktme/mktme_demo.rst
new file mode 100644
index 000000000000..49377ad648e7
--- /dev/null
+++ b/Documentation/x86/mktme/mktme_demo.rst
@@ -0,0 +1,53 @@
+Demonstration Program using MKTME API's
+=======================================
+
+/* Compile with the keyutils library: cc -o mdemo mdemo.c -lkeyutils */
+
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <keyutils.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+
+#define PAGE_SIZE sysconf(_SC_PAGE_SIZE)
+#define sys_encrypt_mprotect 428
+
+void main(void)
+{
+	char *options_CPU = "algorithm=aes-xts-128 type=cpu";
+	long size = PAGE_SIZE;
+        key_serial_t key;
+	void *ptra;
+	int ret;
+
+        /* Allocate an MKTME Key */
+	key = add_key("mktme", "testkey", options_CPU, strlen(options_CPU),
+                      KEY_SPEC_THREAD_KEYRING);
+
+	if (key == -1) {
+		printf("addkey FAILED\n");
+		return;
+	}
+        /* Map a page of ANONYMOUS memory */
+	ptra = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
+	if (!ptra) {
+		printf("failed to mmap");
+		goto inval_key;
+	}
+        /* Encrypt that page of memory with the MKTME Key */
+	ret = syscall(sys_encrypt_mprotect, ptra, size, PROT_NONE, key);
+	if (ret)
+		printf("mprotect error [%d]\n", ret);
+
+        /* Enjoy that page of encrypted memory */
+
+        /* Free the memory */
+	ret = munmap(ptra, size);
+
+inval_key:
+        /* Free the Key */
+	if (keyctl(KEYCTL_INVALIDATE, key) == -1)
+		printf("invalidate failed on key [%d]\n", key);
+}
-- 
2.20.1

