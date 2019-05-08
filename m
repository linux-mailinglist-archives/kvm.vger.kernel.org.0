Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D8C17BF0
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfEHOq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:46:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:59551 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728176AbfEHOo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:53 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 08 May 2019 07:44:49 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id AF33E11CE; Wed,  8 May 2019 17:44:31 +0300 (EEST)
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
Subject: [PATCH, RFC 60/62] x86/mktme: Document the MKTME Key Service API
Date:   Wed,  8 May 2019 17:44:20 +0300
Message-Id: <20190508144422.13171-61-kirill.shutemov@linux.intel.com>
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
 Documentation/x86/mktme/mktme_keys.rst | 96 ++++++++++++++++++++++++++
 2 files changed, 97 insertions(+)
 create mode 100644 Documentation/x86/mktme/mktme_keys.rst

diff --git a/Documentation/x86/mktme/index.rst b/Documentation/x86/mktme/index.rst
index 0f021cc4a2db..8cf2b7d62091 100644
--- a/Documentation/x86/mktme/index.rst
+++ b/Documentation/x86/mktme/index.rst
@@ -8,3 +8,4 @@ Multi-Key Total Memory Encryption (MKTME)
    mktme_overview
    mktme_mitigations
    mktme_configuration
+   mktme_keys
diff --git a/Documentation/x86/mktme/mktme_keys.rst b/Documentation/x86/mktme/mktme_keys.rst
new file mode 100644
index 000000000000..161871dee0dc
--- /dev/null
+++ b/Documentation/x86/mktme/mktme_keys.rst
@@ -0,0 +1,96 @@
+MKTME Key Service API
+=====================
+MKTME is a new key service type added to the Linux Kernel Key Service.
+
+The MKTME Key Service type is available when CONFIG_X86_INTEL_MKTME is
+turned on in Intel platforms that support the MKTME feature.
+
+The MKTME Key Service type manages the allocation of hardware encryption
+keys. Users can request an MKTME type key and then use that key to
+encrypt memory with the encrypt_mprotect() system call.
+
+Usage
+-----
+    When using the Kernel Key Service to request an *mktme* key,
+    specify the *payload* as follows:
+
+    type=
+        *user*	User will supply the encryption key data. Use this
+                type to directly program a hardware encryption key.
+
+        *cpu*	User requests a CPU generated encryption key.
+                The CPU generates and assigns an ephemeral key.
+
+        *no-encrypt*
+                 User requests that hardware does not encrypt
+                 memory when this key is in use.
+
+    algorithm=
+        When type=user or type=cpu the algorithm field must be
+        *aes-xts-128*
+
+        When type=clear or type=no-encrypt the algorithm field
+        must not be present in the payload.
+
+    key=
+        When type=user the user must supply a 128 bit encryption
+        key as exactly 32 ASCII hexadecimal characters.
+
+	When type=cpu the user may optionally supply 128 bits of
+        entropy for the CPU generated encryption key in this field.
+        It must be exactly 32 ASCII hexadecimal characters.
+
+	When type=no-encrypt this key field must not be present
+        in the payload.
+
+    tweak=
+	When type=user the user must supply a 128 bit tweak key
+        as exactly 32 ASCII hexadecimal characters.
+
+	When type=cpu the user may optionally supply 128 bits of
+        entropy for the CPU generated tweak key in this field.
+        It must be exactly 32 ASCII hexadecimal characters.
+
+        When type=no-encrypt the tweak field must not be present
+        in the payload.
+
+ERRORS
+------
+    In addition to the Errors returned from the Kernel Key Service,
+    add_key(2) or keyctl(1) commands, the MKTME Key Service type may
+    return the following errors:
+
+    EINVAL for any payload specification that does not match the
+           MKTME type payload as defined above.
+
+    EACCES for access denied. The MKTME key type uses capabilities
+           to restrict the allocation of keys to privileged users.
+           CAP_SYS_RESOURCE is required, but it will accept the
+           broader capability of CAP_SYS_ADMIN. See capabilities(7).
+
+    ENOKEY if a hardware key cannot be allocated. Additional error
+           messages will describe the hardware programming errors.
+
+EXAMPLES
+--------
+    Add a 'user' type key::
+
+        char \*options_USER = "type=user
+                               algorithm=aes-xts-128
+                               key=12345678912345671234567891234567
+                               tweak=12345678912345671234567891234567";
+
+        key = add_key("mktme", "name", options_USER, strlen(options_USER),
+                      KEY_SPEC_THREAD_KEYRING);
+
+    Add a 'cpu' type key::
+
+        char \*options_USER = "type=cpu algorithm=aes-xts-128";
+
+        key = add_key("mktme", "name", options_CPU, strlen(options_CPU),
+                      KEY_SPEC_THREAD_KEYRING);
+
+    Add a "no-encrypt' type key::
+
+	key = add_key("mktme", "name", "no-encrypt", strlen(options_CPU),
+		      KEY_SPEC_THREAD_KEYRING);
-- 
2.20.1

