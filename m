Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66F5517C07
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbfEHOov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:19918 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728395AbfEHOou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,446,1549958400"; 
   d="scan'208";a="169656563"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 08 May 2019 07:44:44 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id B16F3D2B; Wed,  8 May 2019 17:44:30 +0300 (EEST)
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
Subject: [PATCH, RFC 40/62] keys/mktme: Program new PCONFIG targets with MKTME keys
Date:   Wed,  8 May 2019 17:44:00 +0300
Message-Id: <20190508144422.13171-41-kirill.shutemov@linux.intel.com>
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

When a new PCONFIG target is added to an MKTME platform, its
key table needs to be programmed to match the key tables across
the entire platform. This type of newly added PCONFIG target
may appear during a memory hotplug event.

This key programming path will differ from the normal key
programming path in that it will only program a single PCONFIG
target, AND, it will only do that programming if allowed.

Allowed means that either user type keys are stored, or, no
user type keys are currently programmed.

So, after checking if programming is allowable, this helper
function will program the one new PCONFIG target, with all
the currently programmed keys.

This will be used in MKTME's memory notifier callback supporting
MEM_GOING_ONLINE events.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 44 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index 2c975c48fe44..489dddb8c623 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -582,6 +582,50 @@ static int mktme_get_new_pconfig_target(void)
 	return new_target;
 }
 
+static int mktme_program_new_pconfig_target(int new_pkg)
+{
+	struct mktme_payload *payload;
+	int cpu, keyid, ret;
+
+	/*
+	 * Only program new target when user type keys are stored or,
+	 * no user type keys are currently programmed.
+	 */
+	if (!mktme_storekeys &&
+	    (bitmap_weight(mktme_bitmap_user_type, mktme_nr_keyids)))
+		return -EPERM;
+
+	/* Set mktme_leadcpus to only include new target */
+	cpumask_clear(mktme_leadcpus);
+	for_each_online_cpu(cpu) {
+		if (topology_physical_package_id(cpu) == new_pkg) {
+			__cpumask_set_cpu(cpu, mktme_leadcpus);
+			break;
+		}
+	}
+	/* Program the stored keys into the new key table */
+	for (keyid = 1; keyid <= mktme_nr_keyids; keyid++) {
+		/*
+		 * When a KeyID slot is not in use, the corresponding key
+		 * pointer is 0. '-1' is an intermediate state where the
+		 * key is on it's way out, but not gone yet. Program '-1's.
+		 */
+		if (mktme_map->key[keyid] == 0)
+			continue;
+
+		payload = &mktme_key_store[keyid];
+		ret = mktme_program_keyid(keyid, payload);
+		if (ret != MKTME_PROG_SUCCESS) {
+			/* Quit on first failure to program key table */
+			pr_debug("mktme: %s\n", mktme_error[ret].msg);
+			ret = -ENOKEY;
+			break;
+		}
+	}
+	mktme_update_pconfig_targets();		/* Restore mktme_leadcpus */
+	return ret;
+}
+
 static int __init init_mktme(void)
 {
 	int ret, cpuhp;
-- 
2.20.1

