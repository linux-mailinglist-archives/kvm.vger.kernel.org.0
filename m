Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB0517C59
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbfEHOuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:50:23 -0400
Received: from mga07.intel.com ([134.134.136.100]:33094 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728424AbfEHOou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:50 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 08 May 2019 07:44:45 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 19F92F6E; Wed,  8 May 2019 17:44:31 +0300 (EEST)
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
Subject: [PATCH, RFC 47/62] mm: Restrict MKTME memory encryption to anonymous VMAs
Date:   Wed,  8 May 2019 17:44:07 +0300
Message-Id: <20190508144422.13171-48-kirill.shutemov@linux.intel.com>
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

Memory encryption is only supported for mappings that are ANONYMOUS.
Test the VMA's in an encrypt_mprotect() request to make sure they all
meet that requirement before encrypting any.

The encrypt_mprotect syscall will return -EINVAL and will not encrypt
any VMA's if this check fails.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/mprotect.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 38d766b5cc20..53bd41f99a67 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -346,6 +346,24 @@ static int prot_none_walk(struct vm_area_struct *vma, unsigned long start,
 	return walk_page_range(start, end, &prot_none_walk);
 }
 
+/*
+ * Encrypted mprotect is only supported on anonymous mappings.
+ * If this test fails on any single VMA, the entire mprotect
+ * request fails.
+ */
+static bool mem_supports_encryption(struct vm_area_struct *vma, unsigned long end)
+{
+	struct vm_area_struct *test_vma = vma;
+
+	do {
+		if (!vma_is_anonymous(test_vma))
+			return false;
+
+		test_vma = test_vma->vm_next;
+	} while (test_vma && test_vma->vm_start < end);
+	return true;
+}
+
 int
 mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
 	       unsigned long start, unsigned long end, unsigned long newflags,
@@ -532,6 +550,12 @@ static int do_mprotect_ext(unsigned long start, size_t len,
 				goto out;
 		}
 	}
+
+	if (keyid > 0 && !mem_supports_encryption(vma, end)) {
+		error = -EINVAL;
+		goto out;
+	}
+
 	if (start > vma->vm_start)
 		prev = vma;
 
-- 
2.20.1

