Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5D317C85
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbfEHOve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:51:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:48394 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728153AbfEHOok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:39 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 08 May 2019 07:44:34 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id DC7154AB; Wed,  8 May 2019 17:44:28 +0300 (EEST)
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
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH, RFC 06/62] mm/khugepaged: Handle encrypted pages
Date:   Wed,  8 May 2019 17:43:26 +0300
Message-Id: <20190508144422.13171-7-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For !NUMA khugepaged allocates page in advance, before we found a VMA
for collapse. We don't yet know which KeyID to use for the allocation.

The page is allocated with KeyID-0. Once we know that the VMA is
suitable for collapsing, we prepare the page for KeyID we need, based on
vma_keyid().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/khugepaged.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 449044378782..96326a7e9d61 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1055,6 +1055,16 @@ static void collapse_huge_page(struct mm_struct *mm,
 	 */
 	anon_vma_unlock_write(vma->anon_vma);
 
+	/*
+	 * At this point new_page is allocated as non-encrypted.
+	 * If VMA's KeyID is non-zero, we need to prepare it to be encrypted
+	 * before coping data.
+	 */
+	if (vma_keyid(vma)) {
+		prep_encrypted_page(new_page, HPAGE_PMD_ORDER,
+				vma_keyid(vma), false);
+	}
+
 	__collapse_huge_page_copy(pte, new_page, vma, address, pte_ptl);
 	pte_unmap(pte);
 	__SetPageUptodate(new_page);
-- 
2.20.1

