Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85DDC17C39
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbfEHOtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:49:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:19899 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbfEHOos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:47 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 08 May 2019 07:44:43 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 6B821BD1; Wed,  8 May 2019 17:44:30 +0300 (EEST)
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
Subject: [PATCH, RFC 35/62] keys/mktme: Require ACPI HMAT to register the MKTME Key Service
Date:   Wed,  8 May 2019 17:43:55 +0300
Message-Id: <20190508144422.13171-36-kirill.shutemov@linux.intel.com>
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

The ACPI HMAT will be used by the MKTME key service to identify
topologies that support the safe programming of encryption keys.
Those decisions will happen at key creation time and during
hotplug events.

To enable this, we at least need to have the ACPI HMAT present
at init time. If it's not present, do not register the type.

If the HMAT is not present, failure looks like this:
[ ] MKTME: Registration failed. ACPI HMAT not present.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 security/keys/mktme_keys.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/security/keys/mktme_keys.c b/security/keys/mktme_keys.c
index bcd68850048f..f5fc6cccc81b 100644
--- a/security/keys/mktme_keys.c
+++ b/security/keys/mktme_keys.c
@@ -2,6 +2,7 @@
 
 /* Documentation/x86/mktme_keys.rst */
 
+#include <linux/acpi.h>
 #include <linux/cred.h>
 #include <linux/cpu.h>
 #include <linux/init.h>
@@ -490,6 +491,12 @@ static int __init init_mktme(void)
 	if (mktme_nr_keyids < 1)
 		return 0;
 
+	/* Require an ACPI HMAT to identify MKTME safe topologies */
+	if (!acpi_hmat_present()) {
+		pr_warn("MKTME: Registration failed. ACPI HMAT not present.\n");
+		return -EINVAL;
+	}
+
 	/* Mapping of Userspace Keys to Hardware KeyIDs */
 	if (mktme_map_alloc())
 		return -ENOMEM;
-- 
2.20.1

