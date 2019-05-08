Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3331717C21
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfEHOsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:48:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:19899 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728423AbfEHOou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,446,1549958400"; 
   d="scan'208";a="169656569"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 08 May 2019 07:44:44 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id BF156D4A; Wed,  8 May 2019 17:44:30 +0300 (EEST)
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
Subject: [PATCH, RFC 41/62] keys/mktme: Support memory hotplug for MKTME keys
Date:   Wed,  8 May 2019 17:44:01 +0300
Message-Id: <20190508144422.13171-42-kirill.shutemov@linux.intel.com>
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

Newly added memory may mean that there is a newly added physical
package.  Intel platforms supporting MKTME need to know about the
new physical packages that may appear during MEM_GOING_ONLINE
events.

Add a memory notifier for MEM_GOING_ONLINE events where MKTME
can evaluate this new memory before it goes online.

MKTME will quickly NOTIFY_OK in MEM_GOING_ONLINE events if no MKTME
keys are currently programmed. If the newly added memory presents
an unsafe MKTME topology, that will be found and reported during the
next key creation attempt. (User can repair and retry.)

When MKTME keys are currently programmed, MKTME will evaluate the
platform topology, detect if a new PCONFIG target has been added,
and program that new pconfig target if allowable.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 57 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index 489dddb8c623..904748b540c6 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/key.h>
 #include <linux/key-type.h>
+#include <linux/memory.h>
 #include <linux/mm.h>
 #include <linux/parser.h>
 #include <linux/percpu-refcount.h>
@@ -626,6 +627,56 @@ static int mktme_program_new_pconfig_target(int new_pkg)
 	return ret;
 }
 
+static int mktme_memory_callback(struct notifier_block *nb,
+				 unsigned long action, void *arg)
+{
+	unsigned long flags;
+	int ret, new_target;
+
+	/* MEM_GOING_ONLINE is the only mem event of interest to MKTME */
+	if (action != MEM_GOING_ONLINE)
+		return NOTIFY_OK;
+
+	/* Do not allow key programming during hotplug event */
+	spin_lock_irqsave(&mktme_lock, flags);
+
+	/*
+	 * If no keys are actually programmed let this event proceed.
+	 * The topology will be checked on the next key creation attempt.
+	 */
+	if (!mktme_map->mapped_keyids) {
+		mktme_allow_keys = false;
+		ret = NOTIFY_OK;
+		goto out;
+	}
+	/* Do not allow this event if it creates an unsafe MKTME topology */
+	if (!mktme_hmat_evaluate()) {
+		ret = NOTIFY_BAD;
+		goto out;
+	}
+	/* Topology is safe. Is there a new pconfig target? */
+	new_target = mktme_get_new_pconfig_target();
+
+	/* No new target to program */
+	if (new_target < 0) {
+		ret = NOTIFY_OK;
+		goto out;
+	}
+	if (mktme_program_new_pconfig_target(new_target))
+		ret = NOTIFY_BAD;
+	else
+		ret = NOTIFY_OK;
+
+out:
+	spin_unlock_irqrestore(&mktme_lock, flags);
+	return ret;
+}
+
+static struct notifier_block mktme_memory_nb = {
+	.notifier_call = mktme_memory_callback,
+	.priority = 99,				/* priority ? */
+};
+
 static int __init init_mktme(void)
 {
 	int ret, cpuhp;
@@ -679,10 +730,16 @@ static int __init init_mktme(void)
 	if (cpuhp < 0)
 		goto free_store;
 
+	/* Memory hotplug */
+	if (register_memory_notifier(&mktme_memory_nb))
+		goto remove_cpuhp;
+
 	ret = register_key_type(&key_type_mktme);
 	if (!ret)
 		return ret;			/* SUCCESS */
 
+	unregister_memory_notifier(&mktme_memory_nb);
+remove_cpuhp:
 	cpuhp_remove_state_nocalls(cpuhp);
 free_store:
 	kfree(mktme_key_store);
-- 
2.20.1

