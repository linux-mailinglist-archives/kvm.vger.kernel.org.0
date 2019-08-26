Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6129C940
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbfHZGVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45665 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729617AbfHZGVp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id o13so9936377pgp.12;
        Sun, 25 Aug 2019 23:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EeGFhunBEQ6wrFXezwCcF5TbrUUhBrl1zRkWTPEJQS4=;
        b=E8C+w8HXa74gulX9++ST4/gu+P7KDmlYwXFPzXy4aFTXSDFcmbCD2Fa0fEa0tqeV73
         aKKa1Wrowt+D7SCBg75clk64A1RXN66iHm4edMAYU8V7RzDnWMoE7mOJvZSSskTzzx44
         IJSDsE7Qz7epz/UM+pwQ80Wmd/skMT5pIHqQZKrCJY805XIaIFCfCfCTvkOtv1ILK+a5
         Ejyc98DguwpqJ21JzUX8krbXeD5ue9jcHqhEZSzchrv+7d+iZkps5gyZKSZH46Vz410w
         5XjOJBtUHV0weFXf/ohDYN7tlsObnJtyb6q+/EplfABrFN+b2MKpsO4Zs0KMfUijbWYZ
         lj5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EeGFhunBEQ6wrFXezwCcF5TbrUUhBrl1zRkWTPEJQS4=;
        b=LBpG6Vd07m3DRm9XXm2YtXsRexhkMIKqL1CXg1iZ0ruI/qR+3COzUNwNVndOlp/HPa
         hgNFResoxVES7DbZqaE02KdhAdgPqnM1oiXeyhn2jT+5tWJPKsoyNmhtbJutSl+X+oO3
         khHmF278ae2U+fDCsQUJ2nNgpRX6Ewiigyv1DlCvoZckiOYxjJMXElc+utMsAExFEbBX
         FhazKnU+3Fo5Rrpxx5RLRGqaMik6kkzKrtzeeBrN0u4wxIdS/QcteifHeQiiqN+dgN7d
         7Zletd0HjtFaHCOuywmwYkVtIISJzk2kNsuYFWcgiDRRDnkZ/49wRiBkv/rLxsv87L7q
         Nn0Q==
X-Gm-Message-State: APjAAAX+kLJxFnjoohVEnwloKHPRlc6cRanZOLVr226Sxvp7tdkPre21
        X0xVItgbsa6YFf0wYo/CCK63Q0BiUPU=
X-Google-Smtp-Source: APXvYqyJS3LtdZAH73RZ+DU0rV6Owk0tKWLjyVqBKM2dFfYDtge3xmbfuXLT4orAUXVytfNcoqp2PA==
X-Received: by 2002:a65:4189:: with SMTP id a9mr14572110pgq.399.1566800504809;
        Sun, 25 Aug 2019 23:21:44 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:44 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 12/23] KVM: PPC: Book3S HV: Nested: add kvmhv_remove_all_nested_rmap_lpid()
Date:   Mon, 26 Aug 2019 16:20:58 +1000
Message-Id: <20190826062109.7573-13-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nested rmap entries are used to store a reverse mapping from a L1 guest
page in a kvm memslot to a nested guest pte.

Implement a function to remove all nest rmap entries of a given lpid
from all of the memslots for a given guest.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/kvm/book3s_hv_nested.c | 47 +++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index c76e499437ee..58a5de2aa2af 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -819,6 +819,53 @@ void kvmhv_insert_nest_rmap(unsigned long *rmapp, struct rmap_nested **n_rmap)
 	*n_rmap = NULL;
 }
 
+/* called with kvm->mmu_lock held */
+static void kvmhv_remove_nested_rmap_lpid(unsigned long *rmapp, int l1_lpid)
+{
+	struct llist_node **next = &(((struct llist_head *) rmapp)->first);
+	u64 match = lpid_to_n_rmap(l1_lpid);
+
+	while (*next) {
+		struct llist_node *entry = (*next);
+		struct rmap_nested *n_rmap = llist_entry(entry, typeof(*n_rmap),
+							 list);
+
+		if (kvmhv_n_rmap_is_equal(match, n_rmap->rmap,
+					  RMAP_NESTED_LPID_MASK)) {
+			*next = entry->next;
+			kfree(n_rmap);
+		} else {
+			next = &(entry->next);
+		}
+	}
+}
+
+/*
+ * caller must hold gp->tlb_lock
+ * For a given nested lpid, remove all of the rmap entries which match that
+ * nest lpid. Note that no invalidation/tlbie is done for the entries, it is
+ * assumed that the caller will perform an lpid wide invalidation after calling
+ * this function.
+ */
+static void kvmhv_remove_all_nested_rmap_lpid(struct kvm *kvm, int l1_lpid)
+{
+	struct kvm_memory_slot *memslot;
+
+	kvm_for_each_memslot(memslot, kvm_memslots(kvm)) {
+		unsigned long page;
+
+		for (page = 0; page < memslot->npages; page++) {
+			unsigned long *rmapp;
+
+			spin_lock(&kvm->mmu_lock);
+			rmapp = &memslot->arch.rmap[page];
+			if (*rmapp) /* Are there any rmap entries? */
+				kvmhv_remove_nested_rmap_lpid(rmapp, l1_lpid);
+			spin_unlock(&kvm->mmu_lock);
+		}
+	}
+}
+
 /*
  * called with kvm->mmu_lock held
  * Given a single rmap entry, update the rc bits in the corresponding shadow
-- 
2.13.6

