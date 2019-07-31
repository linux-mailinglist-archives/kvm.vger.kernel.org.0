Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6905F7C61E
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbfGaPUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:20:49 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46160 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730061AbfGaPUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:20:49 -0400
Received: by mail-ed1-f68.google.com with SMTP id d4so66098203edr.13
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=giiClMAwHghspubxRJeU98UBj4kcy5uaSNNQ5yHBQr8=;
        b=YaTXMBHevd+rhxg7oKsHgnNx749IFnPZBGV8uL7sZwZst8GkM7+TgJ5hOEwl+8ch77
         0SnQ660ccq3nonm+oPVfiPClF1RSRdsFcsOmiSCMAee/860JmulRtpJu6ZVUPIXxPpab
         A4HPUmoMK+oL/ZYU5z/0aKIN4ZyJj82QmP1VUkYEBl9uw4vslQvBcp1bM5ghPUhjzxVC
         giBVV/0crRxnqKUVAJjYi7W4wag0HivWwFFhHGvLdDIRmm1PDwxpL1ZVySWrGgKoEpQY
         GhlGRvNmW51GC9GcIML/xNJIoQeLdRe0qiR4tweLB/NiOTOi4OWFj5nMUqbAYuKnK/j8
         MnLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=giiClMAwHghspubxRJeU98UBj4kcy5uaSNNQ5yHBQr8=;
        b=EpsL2yAFQnYSP1cFKFjVqQdWk/OdzgvVeGQ0m2hdC9qGQxUGvR1rhV5PBGPSIeGUEl
         sPMlGhFRzoJelpeMUqxTVVd+h0DghXz3WIk2qXeG3uejvwap++J2m4ZjLl5Fxo7Pqe9L
         4zozR+yOP9dH++c+rc5JgI7qrOHQLy7McE1Lj5FDQMmzbo6Q5s+qskXTcwanXv5ARth7
         fTAH5nNffcbCcIelleDk4+Hz04tXQyYr8YyBOzc9RvPcgniUqQlRLpByUfNM+UorUJFz
         whdmfFlG/ZFMd3OZi3jLkoP/naSxKWU8PRkEEHbv7coErIAIX0VRYsEqd8QIHt25lVVn
         toFQ==
X-Gm-Message-State: APjAAAX/+VzOQzjk+mFd7NGq36SKJtZj6alLuUi/4xrrupNuBYDVoCPQ
        +MNk7jxsUD9f7hpG/EB+hhk=
X-Google-Smtp-Source: APXvYqwa7uk1eoCfkAn/mJHFtQFBKd5911qUgdeykZm3YPTTj3MkDFh75r+Wsq0y3PI0U1ZEMWspDg==
X-Received: by 2002:aa7:dd09:: with SMTP id i9mr109849959edv.193.1564586036906;
        Wed, 31 Jul 2019 08:13:56 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id t13sm17047248edd.13.2019.07.31.08.13.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:53 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 8EA5E1048AA; Wed, 31 Jul 2019 18:08:17 +0300 (+03)
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
Subject: [PATCHv2 58/59] x86/mktme: Document the MKTME API for anonymous memory encryption
Date:   Wed, 31 Jul 2019 18:08:12 +0300
Message-Id: <20190731150813.26289-59-kirill.shutemov@linux.intel.com>
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

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 Documentation/x86/mktme/index.rst         |  1 +
 Documentation/x86/mktme/mktme_encrypt.rst | 56 +++++++++++++++++++++++
 2 files changed, 57 insertions(+)
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
index 000000000000..6dc8ae11f1cb
--- /dev/null
+++ b/Documentation/x86/mktme/mktme_encrypt.rst
@@ -0,0 +1,56 @@
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
+    The memory that is to be protected must be mapped *ANONYMOUS*.
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
2.21.0

