Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D45D97C5F2
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbfGaPTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:19:08 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37187 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfGaPTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:19:07 -0400
Received: by mail-ed1-f66.google.com with SMTP id w13so66093135eds.4
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qu4eqa88cl7hA3fQdb28KWqV5w4hCLiKuLbYR7iJuDE=;
        b=EapzB6nV2zuG3XXqORhtOg865rDFWXiiuUO8FpJLb/h1WDao3VpOzWeFDmaFbxm/XL
         47TBQ8nUUTf9qkmZiYlrYuMBsFG5TIn6RKRtGHhdoEi679Dd/WD/MF4HtnmQP59r+ZVS
         lWZPfIfuMFEgQo4Y3mbUEU6Vw4ZKVnL+c9FxScjZKMpMrPiR+cuZijKKGYKRXfElKJqa
         Xlf/ibW3jXNNJBvLlFTHpGgT5lOrKP+W2Zir2emFXNHQgTL1ugZEAXaNqYvDXjvvf1sY
         eVxqaYVdOcCPAQPOF9hrrzA0BOHPgcYf40DmCzESR4BUuRMyXnjNV9lnjdj/b1tOOPp+
         BzBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qu4eqa88cl7hA3fQdb28KWqV5w4hCLiKuLbYR7iJuDE=;
        b=bKOm8qZ3R6z/rZ7NOtqCb4KOZmLc4x6BjWxJ306MOxWAOp+fsI/ELShAfp7LgU3KkR
         4wQW8DPwG5mZoP0BspjrnYMD+sD52msYdObIUo2GNTPzGPX+opsvJU9O8vuVLLVvWX4a
         cSMOzA/yIv7a12fa4IRgDrpKgQDT24z5Zh0yKd3ykJYuudI9AzPwCd4RYrDcRE6x+RH+
         BHj0U2pept6aEJTs/xq7QDaMSaZqJijlwErkwP0+9Wkw/25g3Lsu7lPDIU4g5rPdyfBw
         uVv3YSxABPQtFuRWQb2MDshArXlYDbczkiUv841YkWF59i0MZHisEBJ83Humv1uJT3qB
         FxFg==
X-Gm-Message-State: APjAAAVw+T7ImGssBJ/PUoZ2esgiCnyYjkRW772hxSREYVEFDy9+31RD
        zK7UBZsTB2RTNqm3RFS1Fo0=
X-Google-Smtp-Source: APXvYqx2zTJL6YB+Gc6tZHir/y3NwypWB6AAdiaRHKrntm3SVSrSWzIlrCWGYk+WyVgbmkUaGcUHkg==
X-Received: by 2002:a50:acc6:: with SMTP id x64mr110288029edc.100.1564586034088;
        Wed, 31 Jul 2019 08:13:54 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id oe21sm11729742ejb.44.2019.07.31.08.13.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:52 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 172081045FF; Wed, 31 Jul 2019 18:08:17 +0300 (+03)
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
Subject: [PATCHv2 41/59] mm: Generalize the mprotect implementation to support extensions
Date:   Wed, 31 Jul 2019 18:07:55 +0300
Message-Id: <20190731150813.26289-42-kirill.shutemov@linux.intel.com>
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

Today mprotect is implemented to support legacy mprotect behavior
plus an extension for memory protection keys. Make it more generic
so that it can support additional extensions in the future.

This is done is preparation for adding a new system call for memory
encyption keys. The intent is that the new encrypted mprotect will be
another extension to legacy mprotect.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/mprotect.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 82d7b194a918..4d55725228e3 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -35,6 +35,8 @@
 
 #include "internal.h"
 
+#define NO_KEY	-1
+
 static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		int dirty_accountable, int prot_numa)
@@ -453,9 +455,9 @@ mprotect_fixup(struct vm_area_struct *vma, struct vm_area_struct **pprev,
 }
 
 /*
- * pkey==-1 when doing a legacy mprotect()
+ * When pkey==NO_KEY we get legacy mprotect behavior here.
  */
-static int do_mprotect_pkey(unsigned long start, size_t len,
+static int do_mprotect_ext(unsigned long start, size_t len,
 		unsigned long prot, int pkey)
 {
 	unsigned long nstart, end, tmp, reqprot;
@@ -579,7 +581,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
 		unsigned long, prot)
 {
-	return do_mprotect_pkey(start, len, prot, -1);
+	return do_mprotect_ext(start, len, prot, NO_KEY);
 }
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
@@ -587,7 +589,7 @@ SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
 SYSCALL_DEFINE4(pkey_mprotect, unsigned long, start, size_t, len,
 		unsigned long, prot, int, pkey)
 {
-	return do_mprotect_pkey(start, len, prot, pkey);
+	return do_mprotect_ext(start, len, prot, pkey);
 }
 
 SYSCALL_DEFINE2(pkey_alloc, unsigned long, flags, unsigned long, init_val)
-- 
2.21.0

