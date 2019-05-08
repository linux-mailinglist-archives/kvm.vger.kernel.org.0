Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F3917C3F
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbfEHOor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:44:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:7358 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728245AbfEHOoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:43 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 08 May 2019 07:44:39 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id B90ABA50; Wed,  8 May 2019 17:44:29 +0300 (EEST)
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
Subject: [PATCH, RFC 21/62] mm/rmap: Clear vma->anon_vma on unlink_anon_vmas()
Date:   Wed,  8 May 2019 17:43:41 +0300
Message-Id: <20190508144422.13171-22-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If all pages in the VMA got unmapped there's no reason to link it into
original anon VMA hierarchy: it cannot possibly share any pages with
other VMA.

Set vma->anon_vma to NULL on unlink_anon_vmas(). With the change VMA
can be reused. The new anon VMA will be allocated on the first fault.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/rmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index b30c7c71d1d9..4ec2aee7baa3 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -400,8 +400,10 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
-	if (vma->anon_vma)
+	if (vma->anon_vma) {
 		vma->anon_vma->degree--;
+		vma->anon_vma = NULL;
+	}
 	unlock_anon_vma_root(root);
 
 	/*
-- 
2.20.1

