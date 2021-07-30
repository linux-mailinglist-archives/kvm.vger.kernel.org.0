Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFC33DC125
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 00:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbhG3WhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbhG3WhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 18:37:23 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB801C06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:37:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j9-20020a2581490000b02905897d81c63fso6553844ybm.8
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Fo9NvED0lpMkXN/JaIKCFquwO1thPwina4O0gbID30c=;
        b=Ayf8xXcekBEC/WtWhsL8b0fELKIo/kWYg2fpL1gfO/i1K1fxcCofieXaNyLbIv4zpq
         BmM4OVMuLdKosyOSvKtiXcYK2U8mkscxyMiANttRwiax8h0KX9/pc7l1hxfRV6CEBVwk
         0IwRBzGz1b3Pjb5gC+rmzjmWV8pzix7HcOp5xRJ1KxJf/btpUiG03GNyXX6SCzONglJG
         dWQTu2DVrCzUPmDSt3MB4L1V0N7+BHfNxEmlVE6q3YK+tPDOaJAheQ1nxHvXmbEqc66A
         lvgGbUjNxCx2H00uFvDBSt5BXLXpEiSuRdJ/CYuJVoGAd+uOeBWnOm1o5+xcw+CHJeBP
         VYag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Fo9NvED0lpMkXN/JaIKCFquwO1thPwina4O0gbID30c=;
        b=o+sOXZDFDx+PPlzhwx8fcZ+N+1SGV3uG1FldcjDtamp9uMU8Cskba6uEoIdjMWVLVa
         BzcyXqSlZm9gwDc02wubWY91wECEX1J4wOg6Jk/m07OxCTRvQI8Y218+8Kt2YCOsyT0Q
         kOKezr8Bb7GCmkgODuGwW5XqWJyDTHb396s5aJJTRQg9MgE0iNJIyKKIz8TXWtGAc7rf
         x5vapovC3PK4ZAlAluAJjZG/ffdvIu2/CRgMgOSe/lRJY8x23krdmJHiTiXwOV9fJMnI
         POn/XtCbdvKzo8dNB6wvFqtt/bnMQhfDfhGeFP0qWlQkDOCG3H2iFIci3P7z/ak0P3q0
         gvyQ==
X-Gm-Message-State: AOAM532CrZundFM6/bbIhW8BuCbwW/NiDHP9re5+X2jpN+cJVu/seVTt
        EddKZPddsHtNO5P9S0UnXo+rs4TRuG/xLr2mJ0pMDmjqmcfYmjNFZvbqQfva67AknRqbaKI5HOc
        yFGBFzfd3UlbYLiG5NdDTRPQGayNAFJcCcMV8BFY9GZzbM7aLeIkXev4li0QNrRU=
X-Google-Smtp-Source: ABdhPJwMnskhDblL6E8qFgZaYyvNXA8wYcJUVlWu79Mi0Q3msbXcQaS3Uf4RpviCGRUDy+BKatABfYafDH7KkQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a25:b810:: with SMTP id
 v16mr6539371ybj.357.1627684636816; Fri, 30 Jul 2021 15:37:16 -0700 (PDT)
Date:   Fri, 30 Jul 2021 22:37:03 +0000
In-Reply-To: <20210730223707.4083785-1-dmatlack@google.com>
Message-Id: <20210730223707.4083785-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20210730223707.4083785-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH 2/6] KVM: Avoid VM-wide lru_slot lookup in kvm_vcpu_gfn_to_memslot
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that vCPUs keep track of their own LRU slot, there's no good reason
to have them check and update the VM-wide LRU slot. There's no
performance data to motivate this change however there are two
rationals:

1. Now that vCPUs have their own LRU slot, there's a potential for a
   double miss (miss the vCPU LRU slot and then miss the VM-wide LRU slot).
   By avoiding the VM-wide LRU slot check we keep the worst case to a
   single miss.

2. Large VMs are likely to have multiple memslots and vCPUs accessing
   different slots. Intuitively, vCPUs will end up thrashing the VM-wide
   LRU slot, decreasing the LRU hit rate for VM-wide operations such as
   mmu notifiers and VM ioctls.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/kvm_host.h | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 320090d5a124..870e1e6fb771 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1220,17 +1220,13 @@ static inline bool slot_contains_gfn(struct kvm_memslots *slots, int slot_index,
 static inline int __search_memslots(struct kvm_memslots *slots, gfn_t gfn)
 {
 	int start = 0, end = slots->used_slots;
-	int slot = atomic_read(&slots->lru_slot);
 	struct kvm_memory_slot *memslots = slots->memslots;
 
 	if (unlikely(!slots->used_slots))
 		return -1;
 
-	if (slot_contains_gfn(slots, slot, gfn))
-		return slot;
-
 	while (start < end) {
-		slot = start + (end - start) / 2;
+		int slot = start + (end - start) / 2;
 
 		if (gfn >= memslots[slot].base_gfn)
 			end = slot;
@@ -1238,10 +1234,8 @@ static inline int __search_memslots(struct kvm_memslots *slots, gfn_t gfn)
 			start = slot + 1;
 	}
 
-	if (slot_contains_gfn(slots, start, gfn)) {
-		atomic_set(&slots->lru_slot, start);
+	if (slot_contains_gfn(slots, start, gfn))
 		return start;
-	}
 
 	return -1;
 }
@@ -1255,8 +1249,16 @@ static inline int __search_memslots(struct kvm_memslots *slots, gfn_t gfn)
 static inline struct kvm_memory_slot *
 search_memslots(struct kvm_memslots *slots, gfn_t gfn)
 {
-	int slot_index = __search_memslots(slots, gfn);
+	int slot_index = atomic_read(&slots->lru_slot);
+
+	if (slot_contains_gfn(slots, slot_index, gfn))
+		return get_slot(slots, slot_index);
+
+	slot_index = __search_memslots(slots, gfn);
+	if (slot_index < 0)
+		return NULL;
 
+	atomic_set(&slots->lru_slot, slot_index);
 	return get_slot(slots, slot_index);
 }
 
-- 
2.32.0.554.ge1b32706d8-goog

