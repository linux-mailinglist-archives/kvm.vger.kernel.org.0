Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A38417BD2
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfEHOox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:53 -0400
Received: from mga03.intel.com ([134.134.136.65]:59536 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728433AbfEHOov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:48 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 08 May 2019 07:44:44 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 9F78EC1D; Wed,  8 May 2019 17:44:30 +0300 (EEST)
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
Subject: [PATCH, RFC 39/62] keys/mktme: Find new PCONFIG targets during memory hotplug
Date:   Wed,  8 May 2019 17:43:59 +0300
Message-Id: <20190508144422.13171-40-kirill.shutemov@linux.intel.com>
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

Introduce a helper function that detects a newly added PCONFIG
target. This will be used in the MKTME memory hotplug notifier
to determine if a new PCONFIG target has been added that needs
to have its Key Table programmed.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 39 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index 3dfc0647f1e5..2c975c48fe44 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -543,6 +543,45 @@ static int mktme_cpu_teardown(unsigned int cpu)
 	return ret;
 }
 
+static int mktme_get_new_pconfig_target(void)
+{
+	unsigned long *prev_map, *tmp_map;
+	int new_target;		/* New PCONFIG target to program */
+
+	/* Save the current mktme_target_map bitmap */
+	prev_map = bitmap_alloc(topology_max_packages(), GFP_KERNEL);
+	bitmap_copy(prev_map, mktme_target_map, sizeof(mktme_target_map));
+
+	/* Update the global targets - includes mktme_target_map */
+	mktme_update_pconfig_targets();
+
+	/* Nothing to do if the target bitmap is unchanged */
+	if (bitmap_equal(prev_map, mktme_target_map, sizeof(prev_map))) {
+		new_target = -1;
+		goto free_prev;
+	}
+
+	/* Find the change in the target bitmap */
+	tmp_map = bitmap_alloc(topology_max_packages(), GFP_KERNEL);
+	bitmap_andnot(tmp_map, prev_map, mktme_target_map,
+		      sizeof(prev_map));
+
+	/* There should only be one new target */
+	if (bitmap_weight(tmp_map, sizeof(tmp_map)) != 1) {
+		pr_err("%s: expected %d new target, got %d\n", __func__, 1,
+		       bitmap_weight(tmp_map, sizeof(tmp_map)));
+		new_target = -1;
+		goto free_tmp;
+	}
+	new_target = find_first_bit(tmp_map, sizeof(tmp_map));
+
+free_tmp:
+	bitmap_free(tmp_map);
+free_prev:
+	bitmap_free(prev_map);
+	return new_target;
+}
+
 static int __init init_mktme(void)
 {
 	int ret, cpuhp;
-- 
2.20.1

