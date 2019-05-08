Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7BB17BD0
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbfEHOot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:49 -0400
Received: from mga07.intel.com ([134.134.136.100]:33085 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728349AbfEHOor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:45 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 08 May 2019 07:44:40 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id CED38A79; Wed,  8 May 2019 17:44:29 +0300 (EEST)
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
Subject: [PATCH, RFC 23/62] keys/mktme: Introduce a Kernel Key Service for MKTME
Date:   Wed,  8 May 2019 17:43:43 +0300
Message-Id: <20190508144422.13171-24-kirill.shutemov@linux.intel.com>
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

MKTME (Multi-Key Total Memory Encryption) is a technology that allows
transparent memory encryption in upcoming Intel platforms. MKTME will
support multiple encryption domains, each having their own key.

The MKTME key service will manage the hardware encryption keys. It
will map Userspace Keys to Hardware KeyIDs and program the hardware
with the user requested encryption options.

Here the mapping structure and associated helpers are introduced,
as well as the key service initialization and registration.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/Makefile     |  1 +
 security/keys/mktme_keys.c | 98 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 99 insertions(+)
 create mode 100644 security/keys/mktme_keys.c

diff --git a/security/keys/Makefile b/security/keys/Makefile
index 9cef54064f60..28799be801a9 100644
--- a/security/keys/Makefile
+++ b/security/keys/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_ASYMMETRIC_KEY_TYPE) += keyctl_pkey.o
 obj-$(CONFIG_BIG_KEYS) += big_key.o
 obj-$(CONFIG_TRUSTED_KEYS) += trusted.o
 obj-$(CONFIG_ENCRYPTED_KEYS) += encrypted-keys/
+obj-$(CONFIG_X86_INTEL_MKTME) += mktme_keys.o
diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
new file mode 100644
index 000000000000..b5e8289f041b
--- /dev/null
+++ b/security/keys/mktme_keys.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-3.0
+
+/* Documentation/x86/mktme_keys.rst */
+
+#include <linux/init.h>
+#include <linux/key.h>
+#include <linux/key-type.h>
+#include <linux/mm.h>
+#include <keys/user-type.h>
+
+#include "internal.h"
+
+/* 1:1 Mapping between Userspace Keys (struct key) and Hardware KeyIDs */
+struct mktme_mapping {
+	unsigned int	mapped_keyids;
+	struct key	*key[];
+};
+
+struct mktme_mapping *mktme_map;
+
+static inline long mktme_map_size(void)
+{
+	long size = 0;
+
+	size += sizeof(*mktme_map);
+	size += sizeof(mktme_map->key[0]) * (mktme_nr_keyids + 1);
+	return size;
+}
+
+int mktme_map_alloc(void)
+{
+	mktme_map = kvzalloc(mktme_map_size(), GFP_KERNEL);
+	if (!mktme_map)
+		return -ENOMEM;
+	return 0;
+}
+
+int mktme_reserve_keyid(struct key *key)
+{
+	int i;
+
+	if (mktme_map->mapped_keyids == mktme_nr_keyids)
+		return 0;
+
+	for (i = 1; i <= mktme_nr_keyids; i++) {
+		if (mktme_map->key[i] == 0) {
+			mktme_map->key[i] = key;
+			mktme_map->mapped_keyids++;
+			return i;
+		}
+	}
+	return 0;
+}
+
+void mktme_release_keyid(int keyid)
+{
+	mktme_map->key[keyid] = 0;
+	mktme_map->mapped_keyids--;
+}
+
+int mktme_keyid_from_key(struct key *key)
+{
+	int i;
+
+	for (i = 1; i <= mktme_nr_keyids; i++) {
+		if (mktme_map->key[i] == key)
+			return i;
+	}
+	return 0;
+}
+
+struct key_type key_type_mktme = {
+	.name		= "mktme",
+	.describe	= user_describe,
+};
+
+static int __init init_mktme(void)
+{
+	int ret;
+
+	/* Verify keys are present */
+	if (mktme_nr_keyids < 1)
+		return 0;
+
+	/* Mapping of Userspace Keys to Hardware KeyIDs */
+	if (mktme_map_alloc())
+		return -ENOMEM;
+
+	ret = register_key_type(&key_type_mktme);
+	if (!ret)
+		return ret;			/* SUCCESS */
+
+	kvfree(mktme_map);
+
+	return -ENOMEM;
+}
+
+late_initcall(init_mktme);
-- 
2.20.1

