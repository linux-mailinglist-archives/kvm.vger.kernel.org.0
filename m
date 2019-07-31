Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D012D7C671
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730114AbfGaPYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:24:41 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39978 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbfGaPXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:23:49 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so66044715eds.7
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a18UOZt3FCDvDMvgP9zldJLt6lTKwFfHbu73YInWFn4=;
        b=NRoJL3bi5X5MHI+UHT7B1S62Fze3JOWhyFVaj3bzy32xghKUPsGgZO7GdGj/I+MGwQ
         IcszjXoHkHLCYl9E9+S0TVZkBMexB6yUan+V+lOdKu1ZTL//k329IuqiUOHsMZt8zobx
         DpyOBiRYKgBlkPN70qU0UyV4A9sw+9NOai6RD5k+KXVTchojnkBQ/9wvCG9xsOR3lQJH
         25Orq3JTmZBnhwFdJDSLbIjUUACw24Q/2V5Z/1iDJXDUwr6CPtjVVjX8EN+dRQ/iWt3F
         ajr2K45loyNYVlzJu2bXoVrUmjOiINR3+Zakf9U0MEFo74tWWpXOujPELeLbtPwG7Bf+
         4HTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a18UOZt3FCDvDMvgP9zldJLt6lTKwFfHbu73YInWFn4=;
        b=dD/fEmf0pq7van2g4+M0veGaNjnnJjBE+Abjn9qLJqpWhe2LwRWsdpjWiwLSC4Xabx
         NXtQVEOt7G+efENJ0JjG+8cWTVGe4aC0j6Qb/fVV3Jcrg12wTnq1BJkuJa+cLCLW3NFh
         RvGwhhIHtZxrUsN7+VCUci7fYg3jbFLEpcI5EjL7dbZEPp5aDbT7MQ8zR4H90Aqlzx9B
         n4oNEPgwTNfpO1lPZFWMxWbaVVD+WIjmAlEvPETYc0Up8r4gZh5Zhag1cLU91WNldGl8
         wj1dlQ7IVDcQUG0QyxUwcXtguUKIE0Rwy8jGHFKSIFB8Wa9FpAEURgH94C/O2+OQKxYN
         TdNw==
X-Gm-Message-State: APjAAAXDOeykivX2Rd+DjFtjGJf1G0M9Ia49VbfHJTnwVBpAJlrc5rBD
        gierlk6ggBnjYBxYzT+deWIIu+hS
X-Google-Smtp-Source: APXvYqz4eqsH2iJwU1tjXfKb0+/bNd+u2NkjVb8FXDZ8ZsSkbsVxoPTi6IlMDOoUIFCjKkMNnj7bMA==
X-Received: by 2002:a50:b87c:: with SMTP id k57mr105890483ede.226.1564586627977;
        Wed, 31 Jul 2019 08:23:47 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id f24sm17482856edf.30.2019.07.31.08.23.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:23:47 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 953461030BF; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 24/59] keys/mktme: Introduce a Kernel Key Service for MKTME
Date:   Wed, 31 Jul 2019 18:07:38 +0300
Message-Id: <20190731150813.26289-25-kirill.shutemov@linux.intel.com>
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

MKTME (Multi-Key Total Memory Encryption) is a technology that allows
transparent memory encryption in upcoming Intel platforms. MKTME will
support multiple encryption domains, each having their own key.

The MKTME key service will manage the hardware encryption keys. It
will map Userspace Keys to Hardware KeyIDs and program the hardware
with the user requested encryption options.

Here the mapping structure is introduced, as well as the key service
initialization and registration.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/Makefile     |  1 +
 security/keys/mktme_keys.c | 60 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)
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
index 000000000000..d262e0f348e4
--- /dev/null
+++ b/security/keys/mktme_keys.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-3.0
+
+/* Documentation/x86/mktme/ */
+
+#include <linux/init.h>
+#include <linux/key.h>
+#include <linux/key-type.h>
+#include <linux/mm.h>
+#include <keys/user-type.h>
+
+#include "internal.h"
+
+static unsigned int mktme_available_keyids;  /* Free Hardware KeyIDs */
+
+enum mktme_keyid_state {
+	KEYID_AVAILABLE,	/* Available to be assigned */
+	KEYID_ASSIGNED,		/* Assigned to a userspace key */
+	KEYID_REF_KILLED,	/* Userspace key has been destroyed */
+	KEYID_REF_RELEASED,	/* Last reference is released */
+};
+
+/* 1:1 Mapping between Userspace Keys (struct key) and Hardware KeyIDs */
+struct mktme_mapping {
+	struct key		*key;
+	enum mktme_keyid_state	state;
+};
+
+static struct mktme_mapping *mktme_map;
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
+	if (mktme_nr_keyids() < 1)
+		return 0;
+
+	mktme_available_keyids = mktme_nr_keyids();
+
+	/* Mapping of Userspace Keys to Hardware KeyIDs */
+	mktme_map = kvzalloc((sizeof(*mktme_map) * (mktme_nr_keyids() + 1)),
+			     GFP_KERNEL);
+	if (!mktme_map)
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
2.21.0

