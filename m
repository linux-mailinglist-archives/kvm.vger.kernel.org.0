Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0CE17C32
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbfEHOs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:48:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:19899 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728402AbfEHOot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,446,1549958400"; 
   d="scan'208";a="169656560"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 08 May 2019 07:44:44 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 8506EBF5; Wed,  8 May 2019 17:44:30 +0300 (EEST)
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
Subject: [PATCH, RFC 37/62] keys/mktme: Do not allow key creation in unsafe topologies
Date:   Wed,  8 May 2019 17:43:57 +0300
Message-Id: <20190508144422.13171-38-kirill.shutemov@linux.intel.com>
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

MKTME feature depends upon at least one online CPU capable of
programming each memory controller in the platform.

An unsafe topology for MKTME is a memory only package or a package
with no online CPUs. Key creation with unsafe topologies will fail
with EINVAL and a warning will be logged one time.
For example:
	[ ] MKTME: no online CPU in proximity domain
	[ ] MKTME: topology does not support key creation

These are recoverable errors. CPUs may be brought online that are
capable of programming a previously unprogrammable memory controller,
or an unprogrammable memory controller may be removed from the
platform.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 39 ++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index f5fc6cccc81b..734e1d28eb24 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -26,6 +26,7 @@ cpumask_var_t mktme_leadcpus;		/* One lead CPU per pconfig target */
 static bool mktme_storekeys;		/* True if key payloads may be stored */
 unsigned long *mktme_bitmap_user_type;	/* Shows presence of user type keys */
 struct mktme_payload *mktme_key_store;	/* Payload storage if allowed */
+bool mktme_allow_keys;			/* True when topology supports keys */
 
 /* 1:1 Mapping between Userspace Keys (struct key) and Hardware KeyIDs */
 struct mktme_mapping {
@@ -278,33 +279,55 @@ static void mktme_destroy_key(struct key *key)
 	percpu_ref_kill(&encrypt_count[keyid]);
 }
 
+static void mktme_update_pconfig_targets(void);
 /* Key Service Method to create a new key. Payload is preparsed. */
 int mktme_instantiate_key(struct key *key, struct key_preparsed_payload *prep)
 {
 	struct mktme_payload *payload = prep->payload.data[0];
 	unsigned long flags;
+	int ret = -ENOKEY;
 	int keyid;
 
 	spin_lock_irqsave(&mktme_lock, flags);
+
+	/* Topology supports key creation */
+	if (mktme_allow_keys)
+		goto get_key;
+
+	/* Topology unknown, check it. */
+	if (!mktme_hmat_evaluate()) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/* Keys are now allowed. Update the programming targets. */
+	mktme_update_pconfig_targets();
+	mktme_allow_keys = true;
+
+get_key:
 	keyid = mktme_reserve_keyid(key);
 	spin_unlock_irqrestore(&mktme_lock, flags);
 	if (!keyid)
-		return -ENOKEY;
+		goto out;
 
 	if (percpu_ref_init(&encrypt_count[keyid], mktme_percpu_ref_release,
 			    0, GFP_KERNEL))
-		goto err_out;
+		goto out_free_key;
 
-	if (!mktme_program_keyid(keyid, payload)) {
-		mktme_store_payload(keyid, payload);
-		return MKTME_PROG_SUCCESS;
-	}
+	ret = mktme_program_keyid(keyid, payload);
+	if (ret == MKTME_PROG_SUCCESS)
+		goto out;
+
+	/* Key programming failed */
 	percpu_ref_exit(&encrypt_count[keyid]);
-err_out:
+
+out_free_key:
 	spin_lock_irqsave(&mktme_lock, flags);
 	mktme_release_keyid(keyid);
+out_unlock:
 	spin_unlock_irqrestore(&mktme_lock, flags);
-	return -ENOKEY;
+out:
+	return ret;
 }
 
 /* Make sure arguments are correct for the TYPE of key requested */
-- 
2.20.1

