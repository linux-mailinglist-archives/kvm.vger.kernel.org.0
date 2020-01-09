Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B87136415
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 00:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbgAIX4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 18:56:23 -0500
Received: from mga05.intel.com ([192.55.52.43]:55945 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729730AbgAIX4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 18:56:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 15:56:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="246828487"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jan 2020 15:56:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Andrew Honig <ahonig@google.com>,
        Barret Rhoden <brho@google.com>
Subject: [PATCH 2/3] KVM: Clean up __kvm_gfn_to_hva_cache_init() and its callers
Date:   Thu,  9 Jan 2020 15:56:19 -0800
Message-Id: <20200109235620.6536-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109235620.6536-1-sean.j.christopherson@intel.com>
References: <20200109235620.6536-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Barret reported a (technically benign) bug where nr_pages_avail can be
accessed without being initialized if gfn_to_hva_many() fails.

  virt/kvm/kvm_main.c:2193:13: warning: 'nr_pages_avail' may be
  used uninitialized in this function [-Wmaybe-uninitialized]

Rather than simply squashing the warning by initializing nr_pages_avail,
fix the underlying issues by reworking __kvm_gfn_to_hva_cache_init() to
return immediately instead of continuing on.  Now that all callers check
the result and/or bail immediately on a bad hva, there's no need to
explicitly nullify the memslot on error.

Reported-by: Barret Rhoden <brho@google.com>
Fixes: f1b9dd5eb86c ("kvm: Disallow wraparound in kvm_gfn_to_hva_cache_init")
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c02c073b9d43..e8d8fc1d72b4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2155,33 +2155,36 @@ static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
 	gfn_t end_gfn = (gpa + len - 1) >> PAGE_SHIFT;
 	gfn_t nr_pages_needed = end_gfn - start_gfn + 1;
 	gfn_t nr_pages_avail;
-	int r = start_gfn <= end_gfn ? 0 : -EINVAL;
 
-	ghc->gpa = gpa;
+	/* Update ghc->generation before performing any error checks. */
 	ghc->generation = slots->generation;
-	ghc->len = len;
-	ghc->hva = KVM_HVA_ERR_BAD;
+
+	if (start_gfn > end_gfn) {
+		ghc->hva = KVM_HVA_ERR_BAD;
+		return -EINVAL;
+	}
 
 	/*
 	 * If the requested region crosses two memslots, we still
 	 * verify that the entire region is valid here.
 	 */
-	while (!r && start_gfn <= end_gfn) {
+	for ( ; start_gfn <= end_gfn; start_gfn += nr_pages_avail) {
 		ghc->memslot = __gfn_to_memslot(slots, start_gfn);
 		ghc->hva = gfn_to_hva_many(ghc->memslot, start_gfn,
 					   &nr_pages_avail);
 		if (kvm_is_error_hva(ghc->hva))
-			r = -EFAULT;
-		start_gfn += nr_pages_avail;
+			return -EFAULT;
 	}
 
 	/* Use the slow path for cross page reads and writes. */
-	if (!r && nr_pages_needed == 1)
+	if (nr_pages_needed == 1)
 		ghc->hva += offset;
 	else
 		ghc->memslot = NULL;
 
-	return r;
+	ghc->gpa = gpa;
+	ghc->len = len;
+	return 0;
 }
 
 int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
-- 
2.24.1

