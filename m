Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D935E7C626
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 17:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729815AbfGaPU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 11:20:59 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34209 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfGaPU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 11:20:58 -0400
Received: by mail-ed1-f68.google.com with SMTP id s49so31236123edb.1
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 08:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k+U6VIHmZ/fZHykv9hSZy3hTFPe14uQwWZPNGVQf9Wg=;
        b=bRpitEYFAw0iw9F4lWLWOaj8uAivovFwyv4AWNZf1NY1sGLxSiCLjNDzw6evzISUMa
         GHJXwwWF7WOifVXGeInd0STe8yx3ZYQIBXHrbJkyF+Rm71XJH0Uqn7KhiVn6RKSVi/NH
         GnIdsyLQWF+U1/Hz7RYNsNvOWkWTR+mduMkRXQK/n0AYcfSL5nkUiUeRr88V6rdddNZa
         NnYZWfhk4GFsXaFANiQNQQqJaMiCdDw2sC/yGDEkK8d34cXt5u306IrMfDI46uU39c0H
         ulh3gI4vz6iIiS8U4HduYh7aIdHho4vvV2rbd58qJxpeTNRRIu4peFugSAhril4FyF28
         DzHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k+U6VIHmZ/fZHykv9hSZy3hTFPe14uQwWZPNGVQf9Wg=;
        b=onRdpOlc/0ValaG/4OL6fQpfxctWfTZlf/Hz3IUMDzLmSHvvgpTIag2DZ8spIGZ8Aa
         YRnYnnK4/VoJhBvTDuwCkKPshhU23d7dCAg8bf324inHs/fXU0L6b7sYSur35YV2FDfG
         pf/uCI+rxzT/2Dsj5HKqUy4vW5t/dvFh+7uzclM6KsBtQUruZBEcbefar511lIgsqmtJ
         ayNOvnTNwfrvxkfYFs5VuvaZt8iFUl74GXtKa6StQzTFGsEh1iib6OM7UIerflxUgfUx
         44TO64qh7iX1KKL7B9RRS2r9wOlYyI9x+EMIp5+OS7TDOxlB03MCB4wzgQfXOevCTIbv
         h8/w==
X-Gm-Message-State: APjAAAWkF7S8sgzhu4+7xwtOxj8ASeDX5Pbolev2yWiDZ7Y0z8MLiXq0
        WLwHgXYLrgMcLfO8/ZbQp1A=
X-Google-Smtp-Source: APXvYqx+v4/Pbf2jShDF7c6rephC3qv4nn7vrbh6ErmrX7qhFi1sSZ2Ot8M2CUcvWdStTREYbHHJ+Q==
X-Received: by 2002:a50:9468:: with SMTP id q37mr106511363eda.163.1564586038381;
        Wed, 31 Jul 2019 08:13:58 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id e43sm17445027ede.62.2019.07.31.08.13.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 08:13:57 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id 41659104605; Wed, 31 Jul 2019 18:08:17 +0300 (+03)
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
Subject: [PATCHv2 47/59] kvm, x86, mmu: setup MKTME keyID to spte for given PFN
Date:   Wed, 31 Jul 2019 18:08:01 +0300
Message-Id: <20190731150813.26289-48-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
References: <20190731150813.26289-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kai Huang <kai.huang@linux.intel.com>

Setup keyID to SPTE, which will be eventually programmed to shadow MMU
or EPT table, according to page's associated keyID, so that guest is
able to use correct keyID to access guest memory.

Note current shadow_me_mask doesn't suit MKTME's needs, since for MKTME
there's no fixed memory encryption mask, but can vary from keyID 1 to
maximum keyID, therefore shadow_me_mask remains 0 for MKTME.

Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kvm/mmu.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8f72526e2f68..b8742e6219f6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2936,6 +2936,22 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 #define SET_SPTE_WRITE_PROTECTED_PT	BIT(0)
 #define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
 
+static u64 get_phys_encryption_mask(kvm_pfn_t pfn)
+{
+#ifdef CONFIG_X86_INTEL_MKTME
+	struct page *page;
+
+	if (!pfn_valid(pfn))
+		return 0;
+
+	page = pfn_to_page(pfn);
+
+	return ((u64)page_keyid(page)) << mktme_keyid_shift();
+#else
+	return shadow_me_mask;
+#endif
+}
+
 static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		    unsigned pte_access, int level,
 		    gfn_t gfn, kvm_pfn_t pfn, bool speculative,
@@ -2982,7 +2998,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		pte_access &= ~ACC_WRITE_MASK;
 
 	if (!kvm_is_mmio_pfn(pfn))
-		spte |= shadow_me_mask;
+		spte |= get_phys_encryption_mask(pfn);
 
 	spte |= (u64)pfn << PAGE_SHIFT;
 
-- 
2.21.0

