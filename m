Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4269D17C60
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfEHOuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:50:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:19899 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728274AbfEHOoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:44 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 08 May 2019 07:44:40 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 06098AD9; Wed,  8 May 2019 17:44:30 +0300 (EEST)
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
Subject: [PATCH, RFC 27/62] keys/mktme: Strengthen the entropy of CPU generated MKTME keys
Date:   Wed,  8 May 2019 17:43:47 +0300
Message-Id: <20190508144422.13171-28-kirill.shutemov@linux.intel.com>
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

If users request CPU generated keys, mix additional entropy bits
from the kernel into the key programming fields used by the
hardware. This additional entropy may compensate for weak user
supplied, or CPU generated, entropy.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index a7ca32865a1c..9fdf482ea3e6 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -7,6 +7,7 @@
 #include <linux/key-type.h>
 #include <linux/mm.h>
 #include <linux/parser.h>
+#include <linux/random.h>
 #include <linux/string.h>
 #include <asm/intel_pconfig.h>
 #include <keys/mktme-type.h>
@@ -102,7 +103,8 @@ struct mktme_payload {
 static int mktme_program_keyid(int keyid, struct mktme_payload *payload)
 {
 	struct mktme_key_program *kprog = NULL;
-	int ret;
+	u8 kern_entropy[MKTME_AES_XTS_SIZE];
+	int ret, i;
 
 	kprog = kmem_cache_zalloc(mktme_prog_cache, GFP_ATOMIC);
 	if (!kprog)
@@ -114,6 +116,14 @@ static int mktme_program_keyid(int keyid, struct mktme_payload *payload)
 	memcpy(kprog->key_field_1, payload->data_key, MKTME_AES_XTS_SIZE);
 	memcpy(kprog->key_field_2, payload->tweak_key, MKTME_AES_XTS_SIZE);
 
+	/* Strengthen the entropy fields for CPU generated keys */
+	if ((payload->keyid_ctrl & 0xff) == MKTME_KEYID_SET_KEY_RANDOM) {
+		get_random_bytes(&kern_entropy, sizeof(kern_entropy));
+		for (i = 0; i < (MKTME_AES_XTS_SIZE); i++) {
+			kprog->key_field_1[i] ^= kern_entropy[i];
+			kprog->key_field_2[i] ^= kern_entropy[i];
+		}
+	}
 	ret = MKTME_PROG_SUCCESS;	/* Future programming call */
 	kmem_cache_free(mktme_prog_cache, kprog);
 	return ret;
-- 
2.20.1

