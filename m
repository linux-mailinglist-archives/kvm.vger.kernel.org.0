Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D577A7C621
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbfGaPUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:20:54 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46168 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfGaPUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:20:53 -0400
Received: by mail-ed1-f66.google.com with SMTP id d4so66098369edr.13
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bD/5ZInA5DBfNF/OoolUD2uLCIaOC1DGsUwSCxp+njs=;
        b=nvqdVZ7hy8prTTJcbUZBwkmbx2dG13l4tJOjU/HGiWPNPCIzhkiP7BT5p8Q5xWDndr
         7DeAzS8uAbr6+O45Oq+aNxw5yIDCtTUXGB0id3g7Z8mpUiISvVh8+Qdpp6w9Mrz78JiC
         0VezF9Twz7YfGrVqrIO2CaQOxV5IahFa9jvmh6yBk00rx18AqNPPp2V83WMw5/RHJxZK
         V7Ij2TTHXT4PuakKHcAQZMB0LBshUp7ZbQOCUWMzIrguS1msbfDi5NilYa6XZJJc6A82
         xAVNYZPhVRKGVGB4dKsMF59lYW4aPwm4ovfr9mL7D2xAkl0s4z/mmm5UiL+UO1fObzyu
         5wPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bD/5ZInA5DBfNF/OoolUD2uLCIaOC1DGsUwSCxp+njs=;
        b=naTenLs3HkwhaJPeI6R8vanmQP+XerIv5lgLBr0DJUiWUiuvxgubtlQWSxAQUftrqK
         AR13TeP73ypFUp0h+o4quF5hZ2K1x9eb+NdRBMDcV0DU9VWkTGy6zs5jWt5FxfE+llk1
         YBcsB6VnqT4m2qUhHb67BkLRuiyMo/jvH1lkotT/84//AE2cahuE/WpGeTTDj0KQsLqk
         zIHFgCqYP+G5Vt+getUbDdomp361XM9avc+nMJTcOzj9lTC/ziT6Ieaw30X9jEcn6kCa
         ggssyzxWQ8NZ7Z+wgu4gw8eA9JVPo2wKGMPC03WLaouNhJT/+3GBedrNAgP79O+67RPG
         QMdg==
X-Gm-Message-State: APjAAAUHOOrnSrbRcm5vw3PvglDl/RoUSRMLU5TJ/V8lu4H2eXrKlmTy
        Wqe7Ah+DZ2/XpH22UYfuPmw=
X-Google-Smtp-Source: APXvYqxJIvkHF7kejGb362uxw7wEOxIDocRJ4jXYfh9K6XIBqdmcEBR8hDmMszbdv7iLHfJZFlKGzw==
X-Received: by 2002:a05:6402:6d0:: with SMTP id n16mr25572624edy.168.1564586037300;
        Wed, 31 Jul 2019 08:13:57 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id t2sm17397627eda.95.2019.07.31.08.13.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:54 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id C65041044A6; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 31/59] keys/mktme: Set up a percpu_ref_count for MKTME keys
Date:   Wed, 31 Jul 2019 18:07:45 +0300
Message-Id: <20190731150813.26289-32-kirill.shutemov@linux.intel.com>
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

The MKTME key service needs to keep usage counts on the encryption
keys in order to know when it is safe to free a key for reuse.

percpu_ref_count applies well here because the key service will
take the initial reference and typically hold that reference while
the intermediary references are get/put. The intermediaries in this
case will be encrypted VMA's,

Align the percpu_ref_init and percpu_ref_kill with the key service
instantiate and destroy methods respectively.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 39 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index 3c641f3ee794..18cb57be5193 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -8,6 +8,7 @@
 #include <linux/key-type.h>
 #include <linux/mm.h>
 #include <linux/parser.h>
+#include <linux/percpu-refcount.h>
 #include <linux/string.h>
 #include <asm/intel_pconfig.h>
 #include <keys/mktme-type.h>
@@ -71,6 +72,26 @@ int mktme_keyid_from_key(struct key *key)
 	return 0;
 }
 
+struct percpu_ref *encrypt_count;
+void mktme_percpu_ref_release(struct percpu_ref *ref)
+{
+	unsigned long flags;
+	int keyid;
+
+	for (keyid = 1; keyid <= mktme_nr_keyids(); keyid++) {
+		if (&encrypt_count[keyid] == ref)
+			break;
+	}
+	if (&encrypt_count[keyid] != ref) {
+		pr_debug("%s: invalid ref counter\n", __func__);
+		return;
+	}
+	percpu_ref_exit(ref);
+	spin_lock_irqsave(&mktme_lock, flags);
+	mktme_release_keyid(keyid);
+	spin_unlock_irqrestore(&mktme_lock, flags);
+}
+
 enum mktme_opt_id {
 	OPT_ERROR,
 	OPT_TYPE,
@@ -199,8 +220,10 @@ static void mktme_destroy_key(struct key *key)
 	unsigned long flags;
 
 	spin_lock_irqsave(&mktme_lock, flags);
-	mktme_release_keyid(keyid);
+	mktme_map[keyid].key = NULL;
+	mktme_map[keyid].state = KEYID_REF_KILLED;
 	spin_unlock_irqrestore(&mktme_lock, flags);
+	percpu_ref_kill(&encrypt_count[keyid]);
 }
 
 /* Key Service Method to create a new key. Payload is preparsed. */
@@ -216,9 +239,15 @@ int mktme_instantiate_key(struct key *key, struct key_preparsed_payload *prep)
 	if (!keyid)
 		return -ENOKEY;
 
+	if (percpu_ref_init(&encrypt_count[keyid], mktme_percpu_ref_release,
+			    0, GFP_KERNEL))
+		goto err_out;
+
 	if (!mktme_program_keyid(keyid, *payload))
 		return MKTME_PROG_SUCCESS;
 
+	percpu_ref_exit(&encrypt_count[keyid]);
+err_out:
 	spin_lock_irqsave(&mktme_lock, flags);
 	mktme_release_keyid(keyid);
 	spin_unlock_irqrestore(&mktme_lock, flags);
@@ -405,10 +434,18 @@ static int __init init_mktme(void)
 	/* Initialize first programming targets */
 	mktme_update_pconfig_targets();
 
+	/* Reference counters to protect in use KeyIDs */
+	encrypt_count = kvcalloc(mktme_nr_keyids() + 1, sizeof(encrypt_count[0]),
+				 GFP_KERNEL);
+	if (!encrypt_count)
+		goto free_targets;
+
 	ret = register_key_type(&key_type_mktme);
 	if (!ret)
 		return ret;			/* SUCCESS */
 
+	kvfree(encrypt_count);
+free_targets:
 	free_cpumask_var(mktme_leadcpus);
 	bitmap_free(mktme_target_map);
 free_cache:
-- 
2.21.0

