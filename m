Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7D73D5D17
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 17:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbhGZOz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 10:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234710AbhGZOz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 10:55:28 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E4ED60462;
        Mon, 26 Jul 2021 15:35:57 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m82e3-001511-Qz; Mon, 26 Jul 2021 16:35:55 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v2 1/6] KVM: arm64: Introduce helper to retrieve a PTE and its level
Date:   Mon, 26 Jul 2021 16:35:47 +0100
Message-Id: <20210726153552.1535838-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726153552.1535838-1-maz@kernel.org>
References: <20210726153552.1535838-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org, seanjc@google.com, willy@infradead.org, pbonzini@redhat.com, will@kernel.org, qperret@google.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is becoming a common need to fetch the PTE for a given address
together with its level. Add such a helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h | 19 ++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 39 ++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index f004c0115d89..082b9d65f40b 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -432,6 +432,25 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
 int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		     struct kvm_pgtable_walker *walker);
 
+/**
+ * kvm_pgtable_get_leaf() - Walk a page-table and retrieve the leaf entry
+ *			    with its level.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
+ * @addr:	Input address for the start of the walk.
+ * @ptep:	Pointer to storage for the retrieved PTE.
+ * @level:	Pointer to storage for the level of the retrieved PTE.
+ *
+ * The offset of @addr within a page is ignored.
+ *
+ * The walker will walk the page-table entries corresponding to the input
+ * address specified, retrieving the leaf corresponding to this address.
+ * Invalid entries are treated as leaf entries.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
+			 kvm_pte_t *ptep, u32 *level);
+
 /**
  * kvm_pgtable_stage2_find_range() - Find a range of Intermediate Physical
  *				     Addresses with compatible permission
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 05321f4165e3..78f36bd5df6c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -326,6 +326,45 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return _kvm_pgtable_walk(&walk_data);
 }
 
+struct leaf_walk_data {
+	kvm_pte_t	pte;
+	u32		level;
+};
+
+static int leaf_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+		       enum kvm_pgtable_walk_flags flag, void * const arg)
+{
+	struct leaf_walk_data *data = arg;
+
+	data->pte   = *ptep;
+	data->level = level;
+
+	return 0;
+}
+
+int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
+			 kvm_pte_t *ptep, u32 *level)
+{
+	struct leaf_walk_data data;
+	struct kvm_pgtable_walker walker = {
+		.cb	= leaf_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= &data,
+	};
+	int ret;
+
+	ret = kvm_pgtable_walk(pgt, ALIGN_DOWN(addr, PAGE_SIZE),
+			       PAGE_SIZE, &walker);
+	if (!ret) {
+		if (ptep)
+			*ptep  = data.pte;
+		if (level)
+			*level = data.level;
+	}
+
+	return ret;
+}
+
 struct hyp_map_data {
 	u64				phys;
 	kvm_pte_t			attr;
-- 
2.30.2

