Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4D5BFBD8
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbfIZXTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:19:11 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:49651 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbfIZXTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:19:11 -0400
Received: by mail-pf1-f201.google.com with SMTP id i28so486179pfq.16
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ydNs+dGf9qH5fCzvJX67P4i4jDJmbvKjCUwxSiEESq0=;
        b=LlBwOHHwLzBiYwqRvte9RURUBOoy58oicZAPFN1wWHQ5tsOQCEXpQn+i5ctu0S6vbA
         6qmg2NxKxYX6PsCa+5+zg+yXDvolOL1fhhqGS0MXjm1lBJ/Val/kaeRIcF+4dHb+MdrS
         BdcOaBJLKJDaKUtD5RHT9iwtyIRkuSBQQ859Av5oVoukzj7KWwUtibuXbDx24hpWL6+c
         0YyZE9vuMvnktNw3mxUHuCsAEAfJKH0n3rCsWIKQ/mSeHDLuf45MrRkaK2CSL/e/bTiw
         BaglwqxiqZk9FT831KNBCgTjgxjw95nmf17IDsc2inDSset2thj7YS0H4Xyeiv5wrBVc
         FwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ydNs+dGf9qH5fCzvJX67P4i4jDJmbvKjCUwxSiEESq0=;
        b=k8Ul0vpxPt5JpQtAIZHEpOyTKxSTGqBGbdDpj7z7nnEBKdfa319EWm6Mi27rwBfFBC
         RniqaflzEWLBdYjXHWUP411xuAt744wWPixqTX1A9sZcmTN/GGOoP0nHpnY75niml9sw
         KeJZuwjIUE/Ih7R8Mj0yg4IYArDlbllVSfudJ1Yx1YssLoeYcTI6SLovH2rr1P61kAsv
         8a4JFsPzxkNNWIek3v4doNXvptS1FcVQGTE059zyjrvt8ixOuDIsQCDaonOUvdqPeU5T
         ktLSVVsJYQ9yJdbOyAmHX851Co46LkYr86r3n3v+Ek7xLyAo3uf4B7l06f7OjrSGFDcR
         vT7w==
X-Gm-Message-State: APjAAAXUvAwMDwXKtXPAB8e2niSe+Mh35+Z64m5Qvi+ZzvmrjHEzaX+9
        OxG6eBr4P1DwRMKkWezfaiJXF1PgfZmR6oPPr+SkJu/Pi55NxTkia+kHYwZqMWhs12SnrU5TcdI
        Ffdq3kHgHhSPCd5Al8/XAbmoJUvlGqUexEXMQbuhXyIxouQSKDA5J/aioPNcP
X-Google-Smtp-Source: APXvYqyAlEecQbVjGiS3Xcto6KF+YkoUGm+S/RkP3N+1VO0UF5KDPE/OSm0pGqVIwmN+Nu72wdHuYw89yN2S
X-Received: by 2002:a63:3585:: with SMTP id c127mr5805957pga.93.1569539948500;
 Thu, 26 Sep 2019 16:19:08 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:14 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-19-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 18/28] kvm: mmu: Add an hva range iterator for memslot GFNs
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factors out a utility for iterating over host virtual address ranges to
get the gfn ranges they map from kvm_handle_hva_range. This moves the
rmap-reliant HVA iterator approach used for shadow paging to a wrapper
around an HVA range to GFN range iterator. Since the direct MMU only
maps each GFN to one physical address, and does not use the rmap, it
can use the GFN ranges directly.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 96 +++++++++++++++++++++++++++++++---------------
 1 file changed, 66 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3d4a78f2461a9..32426536723c6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2701,27 +2701,14 @@ static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
 	rmap_walk_init_level(iterator, iterator->level);
 }
 
-#define for_each_slot_rmap_range(_slot_, _start_level_, _end_level_,	\
-	   _start_gfn, _end_gfn, _iter_)				\
-	for (slot_rmap_walk_init(_iter_, _slot_, _start_level_,		\
-				 _end_level_, _start_gfn, _end_gfn);	\
-	     slot_rmap_walk_okay(_iter_);				\
-	     slot_rmap_walk_next(_iter_))
-
-static int kvm_handle_hva_range(struct kvm *kvm,
-				unsigned long start,
-				unsigned long end,
-				unsigned long data,
-				int (*handler)(struct kvm *kvm,
-					       struct kvm_rmap_head *rmap_head,
-					       struct kvm_memory_slot *slot,
-					       gfn_t gfn,
-					       int level,
-					       unsigned long data))
+static int kvm_handle_direct_hva_range(struct kvm *kvm, unsigned long start,
+		unsigned long end, unsigned long data,
+		int (*handler)(struct kvm *kvm, struct kvm_memory_slot *memslot,
+			       gfn_t gfn_start, gfn_t gfn_end,
+			       unsigned long data))
 {
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
-	struct slot_rmap_walk_iterator iterator;
 	int ret = 0;
 	int i;
 
@@ -2736,25 +2723,74 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 				      (memslot->npages << PAGE_SHIFT));
 			if (hva_start >= hva_end)
 				continue;
-			/*
-			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
-			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
-			 */
 			gfn_start = hva_to_gfn_memslot(hva_start, memslot);
-			gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
-
-			for_each_slot_rmap_range(memslot, PT_PAGE_TABLE_LEVEL,
-						 PT_MAX_HUGEPAGE_LEVEL,
-						 gfn_start, gfn_end - 1,
-						 &iterator)
-				ret |= handler(kvm, iterator.rmap, memslot,
-					       iterator.gfn, iterator.level, data);
+			gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1,
+						     memslot);
+
+			ret |= handler(kvm, memslot, gfn_start, gfn_end, data);
 		}
 	}
 
 	return ret;
 }
 
+#define for_each_slot_rmap_range(_slot_, _start_level_, _end_level_,	\
+	   _start_gfn, _end_gfn, _iter_)				\
+	for (slot_rmap_walk_init(_iter_, _slot_, _start_level_,		\
+				 _end_level_, _start_gfn, _end_gfn);	\
+	     slot_rmap_walk_okay(_iter_);				\
+	     slot_rmap_walk_next(_iter_))
+
+
+struct handle_hva_range_shadow_data {
+	unsigned long data;
+	int (*handler)(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+		       struct kvm_memory_slot *slot, gfn_t gfn, int level,
+		       unsigned long data);
+};
+
+static int handle_hva_range_shadow_handler(struct kvm *kvm,
+					   struct kvm_memory_slot *memslot,
+					   gfn_t gfn_start, gfn_t gfn_end,
+					   unsigned long data)
+{
+	int ret = 0;
+	struct slot_rmap_walk_iterator iterator;
+	struct handle_hva_range_shadow_data *shadow_data =
+		(struct handle_hva_range_shadow_data *)data;
+
+	for_each_slot_rmap_range(memslot, PT_PAGE_TABLE_LEVEL,
+				 PT_MAX_HUGEPAGE_LEVEL,
+				 gfn_start, gfn_end - 1, &iterator) {
+		BUG_ON(!iterator.rmap);
+		ret |= shadow_data->handler(kvm, iterator.rmap, memslot,
+			       iterator.gfn, iterator.level, shadow_data->data);
+	}
+
+	return ret;
+}
+
+static int kvm_handle_hva_range(struct kvm *kvm,
+				unsigned long start,
+				unsigned long end,
+				unsigned long data,
+				int (*handler)(struct kvm *kvm,
+					       struct kvm_rmap_head *rmap_head,
+					       struct kvm_memory_slot *slot,
+					       gfn_t gfn,
+					       int level,
+					       unsigned long data))
+{
+	struct handle_hva_range_shadow_data shadow_data;
+
+	shadow_data.data = data;
+	shadow_data.handler = handler;
+
+	return kvm_handle_direct_hva_range(kvm, start, end,
+					   (unsigned long)&shadow_data,
+					   handle_hva_range_shadow_handler);
+}
+
 /*
  * Marks the range of gfns, [start, end), non-present.
  */
-- 
2.23.0.444.g18eeb5a265-goog

