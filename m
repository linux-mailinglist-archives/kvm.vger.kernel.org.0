Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB51136417
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 00:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbgAIX4d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 18:56:33 -0500
Received: from mga05.intel.com ([192.55.52.43]:55945 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729705AbgAIX4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 18:56:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 15:56:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="246828483"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jan 2020 15:56:21 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Andrew Honig <ahonig@google.com>,
        Barret Rhoden <brho@google.com>
Subject: [PATCH 1/3] KVM: Check for a bad hva before dropping into the ghc slow path
Date:   Thu,  9 Jan 2020 15:56:18 -0800
Message-Id: <20200109235620.6536-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109235620.6536-1-sean.j.christopherson@intel.com>
References: <20200109235620.6536-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When reading/writing using the guest/host cache, check for a bad hva
before checking for a NULL memslot, which triggers the slow path for
handing cross-page accesses.  Because the memslot is nullified on error
by __kvm_gfn_to_hva_cache_init(), if the bad hva is encountered after
crossing into a new page, then the kvm_{read,write}_guest() slow path
could potentially write/access the first chunk prior to detecting the
bad hva.

Arguably, performing a partial access is semantically correct from an
architectural perspective, but that behavior is certainly not intended.
In the original implementation, memslot was not explicitly nullified
and therefore the partial access behavior varied based on whether the
memslot itself was null, or if the hva was simply bad.  The current
behavior was introduced as a seemingly unintentional side effect in
commit f1b9dd5eb86c ("kvm: Disallow wraparound in
kvm_gfn_to_hva_cache_init"), which justified the change with "since some
callers don't check the return code from this function, it sit seems
prudent to clear ghc->memslot in the event of an error".

Regardless of intent, the partial access is dependent on _not_ checking
the result of the cache initialization, which is arguably a bug in its
own right, at best simply weird.

Fixes: 8f964525a121 ("KVM: Allow cross page reads and writes from cached translations.")
Cc: Jim Mattson <jmattson@google.com>
Cc: Andrew Honig <ahonig@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3aa21bec028d..c02c073b9d43 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2205,12 +2205,12 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	if (slots->generation != ghc->generation)
 		__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len);
 
+	if (kvm_is_error_hva(ghc->hva))
+		return -EFAULT;
+
 	if (unlikely(!ghc->memslot))
 		return kvm_write_guest(kvm, gpa, data, len);
 
-	if (kvm_is_error_hva(ghc->hva))
-		return -EFAULT;
-
 	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
 	if (r)
 		return -EFAULT;
@@ -2238,12 +2238,12 @@ int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 	if (slots->generation != ghc->generation)
 		__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len);
 
+	if (kvm_is_error_hva(ghc->hva))
+		return -EFAULT;
+
 	if (unlikely(!ghc->memslot))
 		return kvm_read_guest(kvm, ghc->gpa, data, len);
 
-	if (kvm_is_error_hva(ghc->hva))
-		return -EFAULT;
-
 	r = __copy_from_user(data, (void __user *)ghc->hva, len);
 	if (r)
 		return -EFAULT;
-- 
2.24.1

