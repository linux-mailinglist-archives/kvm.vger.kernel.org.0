Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241F417C11
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfEHOrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:47:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:33094 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728451AbfEHOow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 10:44:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 07:44:50 -0700
X-ExtLoop1: 1
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 08 May 2019 07:44:46 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 3BB8410AA; Wed,  8 May 2019 17:44:31 +0300 (EEST)
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
Subject: [PATCH, RFC 50/62] kvm, x86, mmu: setup MKTME keyID to spte for given PFN
Date:   Wed,  8 May 2019 17:44:10 +0300
Message-Id: <20190508144422.13171-51-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
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
index d9c7b45d231f..bfee0c194161 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2899,6 +2899,22 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
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
+	return ((u64)page_keyid(page)) << mktme_keyid_shift;
+#else
+	return shadow_me_mask;
+#endif
+}
+
 static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		    unsigned pte_access, int level,
 		    gfn_t gfn, kvm_pfn_t pfn, bool speculative,
@@ -2945,7 +2961,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		pte_access &= ~ACC_WRITE_MASK;
 
 	if (!kvm_is_mmio_pfn(pfn))
-		spte |= shadow_me_mask;
+		spte |= get_phys_encryption_mask(pfn);
 
 	spte |= (u64)pfn << PAGE_SHIFT;
 
-- 
2.20.1

