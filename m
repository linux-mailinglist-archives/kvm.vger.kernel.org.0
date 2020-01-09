Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8E8136413
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 00:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbgAIX4X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 18:56:23 -0500
Received: from mga05.intel.com ([192.55.52.43]:55945 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729649AbgAIX4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 18:56:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 15:56:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="246828491"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 09 Jan 2020 15:56:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Andrew Honig <ahonig@google.com>,
        Barret Rhoden <brho@google.com>
Subject: [PATCH 3/3] KVM: Return immediately if __kvm_gfn_to_hva_cache_init() fails
Date:   Thu,  9 Jan 2020 15:56:20 -0800
Message-Id: <20200109235620.6536-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109235620.6536-1-sean.j.christopherson@intel.com>
References: <20200109235620.6536-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check the result of __kvm_gfn_to_hva_cache_init() and return immediately
instead of relying on the kvm_is_error_hva() check to detect errors so
that it's abundantly clear KVM intends to immediately bail on an error.

Note, the hva check is still mandatory to handle errors on subqeuesnt
calls with the same generation.  Similarly, always return -EFAULT on
error so that multiple (bad) calls for a given generation will get the
same result, e.g. on an illegal gfn wrap, propagating the return from
__kvm_gfn_to_hva_cache_init() would cause the initial call to return
-EINVAL and subsequent calls to return -EFAULT.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 virt/kvm/kvm_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e8d8fc1d72b4..4479dc9ba00a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2205,8 +2205,10 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 
 	BUG_ON(len + offset > ghc->len);
 
-	if (slots->generation != ghc->generation)
-		__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len);
+	if (slots->generation != ghc->generation) {
+		if (__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len))
+			return -EFAULT;
+	}
 
 	if (kvm_is_error_hva(ghc->hva))
 		return -EFAULT;
@@ -2238,8 +2240,10 @@ int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 
 	BUG_ON(len > ghc->len);
 
-	if (slots->generation != ghc->generation)
-		__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len);
+	if (slots->generation != ghc->generation) {
+		if (__kvm_gfn_to_hva_cache_init(slots, ghc, ghc->gpa, ghc->len))
+			return -EFAULT;
+	}
 
 	if (kvm_is_error_hva(ghc->hva))
 		return -EFAULT;
-- 
2.24.1

