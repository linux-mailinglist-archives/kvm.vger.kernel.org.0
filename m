Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA3077C582
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388449AbfGaPIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:08:20 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38774 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388437AbfGaPIT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:08:19 -0400
Received: by mail-ed1-f65.google.com with SMTP id r12so31220125edo.5
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=884ZxbzpLr443iBBzOV7VNSITHGDDguNP5NA41SiPjs=;
        b=uapI7QfQSFWrfufVSM7HiFX646OQeLiAul30+HPzHGLTEAyE1mlyQ4cfs8/lAJGW3W
         Tt7zm3MH7qjRyENcy8PkWhrnxtdtI8iaTGgI0/PL1v/DggmhR6NhObJkOFT00YyzaOrj
         Take1nVpfJ2NoPUc7KjzORoYT7UbY7JlN5HKiuzokOrb0OjCCFMEeDyXY9EOjEuhNnPf
         T/XVysxTCW8DaKpzjRLUEONeAMippaQbGF+ajea1j5fV5uemWPA4VqQFGgccNvC53hLa
         leX/D6UzbHLOHMfJMnrjKWDFygclW04/fSZvcc53kO9nqx0C1i5cnaESX8bXsXcjoUoD
         JtDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=884ZxbzpLr443iBBzOV7VNSITHGDDguNP5NA41SiPjs=;
        b=cHEzDPQPj502v06tF6oSJrDKJ1zppDm31upK2bAjiVxTM4eptFGXHYaqTaV742WnhQ
         xn+9Z5EyWqZ2HSLglfpINYat/gQR6mUvQwh6J5Tz1bPUgBdJ0xu+wpZt98Sf3vov8WVy
         UxSNXdIxvEx928h+IuPblKuyt6O9KXRjiM+yNrzGv+DhQu94qm6egrm+xctk1YKkqJhY
         bT0x4C9vORvnKYhtWEz2SAtfifrJVwMddk9wjIxRzAq4mHBIqR60+CZkuu7nWfktuCZ4
         TkZRTLV8Y4BjgHSqQQPDiUs2zieE9rSiv7foJBX5qjmBiYha9YlrPn+yvFqHh5uPTTcw
         6gEA==
X-Gm-Message-State: APjAAAUTJRrcgFPXewQz+dYtv+n+6mLQ2nrLO2buFpVgbQPrnAPyOE1f
        GACHw71z2MoMET63hsjEmyU=
X-Google-Smtp-Source: APXvYqzJuBbLlWsZbHVSwq33uygKwm+4dMWF6225mCqR1QI8GR+My+vRb8mmhCMTG8y6ZThSvSiS7A==
X-Received: by 2002:aa7:da14:: with SMTP id r20mr107153958eds.65.1564585698000;
        Wed, 31 Jul 2019 08:08:18 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id by12sm12375107ejb.37.2019.07.31.08.08.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:08:15 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 0B25210131B; Wed, 31 Jul 2019 18:08:16 +0300 (+03)
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
Subject: [PATCHv2 04/59] mm/page_alloc: Unify alloc_hugepage_vma()
Date:   Wed, 31 Jul 2019 18:07:18 +0300
Message-Id: <20190731150813.26289-5-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't need to have separate implementations of alloc_hugepage_vma()
for NUMA and non-NUMA. Using variant based on alloc_pages_vma() we would
cover both cases.

This is preparation patch for allocation encrypted pages.

alloc_pages_vma() will handle allocation of encrypted pages. With this
change we don' t need to cover alloc_hugepage_vma() separately.

The change makes typo in Alpha's implementation of
__alloc_zeroed_user_highpage() visible. Fix it too.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/alpha/include/asm/page.h | 2 +-
 include/linux/gfp.h           | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/include/asm/page.h b/arch/alpha/include/asm/page.h
index f3fb2848470a..9a6fbb5269f3 100644
--- a/arch/alpha/include/asm/page.h
+++ b/arch/alpha/include/asm/page.h
@@ -18,7 +18,7 @@ extern void clear_page(void *page);
 #define clear_user_page(page, vaddr, pg)	clear_page(page)
 
 #define __alloc_zeroed_user_highpage(movableflags, vma, vaddr) \
-	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vmaddr)
+	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
 
 extern void copy_page(void * _to, void * _from);
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index fb07b503dc45..3d4cb9fea417 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -511,21 +511,19 @@ alloc_pages(gfp_t gfp_mask, unsigned int order)
 extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
 			struct vm_area_struct *vma, unsigned long addr,
 			int node, bool hugepage);
-#define alloc_hugepage_vma(gfp_mask, vma, addr, order) \
-	alloc_pages_vma(gfp_mask, order, vma, addr, numa_node_id(), true)
 #else
 #define alloc_pages(gfp_mask, order) \
 		alloc_pages_node(numa_node_id(), gfp_mask, order)
 #define alloc_pages_vma(gfp_mask, order, vma, addr, node, false)\
 	alloc_pages(gfp_mask, order)
-#define alloc_hugepage_vma(gfp_mask, vma, addr, order) \
-	alloc_pages(gfp_mask, order)
 #endif
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 #define alloc_page_vma(gfp_mask, vma, addr)			\
 	alloc_pages_vma(gfp_mask, 0, vma, addr, numa_node_id(), false)
 #define alloc_page_vma_node(gfp_mask, vma, addr, node)		\
 	alloc_pages_vma(gfp_mask, 0, vma, addr, node, false)
+#define alloc_hugepage_vma(gfp_mask, vma, addr, order) \
+	alloc_pages_vma(gfp_mask, order, vma, addr, numa_node_id(), true)
 
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
-- 
2.21.0

