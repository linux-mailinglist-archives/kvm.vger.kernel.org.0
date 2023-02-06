Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F6E68C493
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 18:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjBFRYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 12:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjBFRYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 12:24:05 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6398C44BF
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 09:23:55 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id n139-20020a25da91000000b0086a113d139aso9174723ybf.3
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 09:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xe2d5VCHL8knVkIvOOdANfJnEofFJGQpmqgs9ZySRtc=;
        b=sbrP00/Yk9tKJfGQc4FLq70ucmYmbgy5/lzyIAHSS74GMLHYKuVcEW7frbq41WNd7X
         O3J9Iifetr3zZa/9AgWSpTNIta3332QfCY58JHRG52qqRnCLTofCIe7Vvk+6CD5vy0tH
         q/pPLvD9In0+0piPhUnB5gPX5M8nCI1OkVYBDfXwFXyySn2nGpsn3y+Qxe9jDa2s576B
         tzcD+5DLiJSCgawG0L6rfscpHPOIDdvEB96UGjKAqynaNJju6eHOT/CFpjW8mVqdatcC
         BNHbAP6Fv21oQE4k9kPEXfVZmc3lrDgDAehHqXKLQ4X1k8i7N1i+CheT9X0b3tSlsNRX
         3N9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xe2d5VCHL8knVkIvOOdANfJnEofFJGQpmqgs9ZySRtc=;
        b=b58lPYXww0qL9aG6BnRi8QkOark2mGhRItJHOdg3FQIuztfcJop5gHjxMDRqr8RJzf
         jX/GkWL56VnLB5lrP1v90dgnda3HA3NVAACywPXCS8lz7UB5pcJ9zwLdtKvkWsEHqoJ9
         uE7ld7/FhqIq7mrQyLbvC+KDmuvLF260HTLHKyGOT7EPe+9+IvVyw9cnDwRqPvNoObZd
         sCjjeoJC4WRs0qWlL3S3FIYwo0yLgAzZjtYo9gaaJVNCuOsFHrN3PY0iB96fT0i5kNsU
         OHis75cVSB+8Qs6kqtO/l+HoJ5tvxzUs3IRsXoo6A1vkFUIjnnSxANd0iLWxDc01vhA5
         L44w==
X-Gm-Message-State: AO0yUKV/Ay9kzvFExeBRalr4N6jVPQzJPwJgLPCk9D0uRatL9ElYvvE9
        iNfg431/n6ivbdO+r9PyB1K4lIZls5AH
X-Google-Smtp-Source: AK7set/7ERS8QZmp236U3VvlNKmAF4kQJ8IiQT3dBm5M8Gtg+WXeMrtq2ewrkogC8KUiVC864iRmNaPt/E6o
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a05:690c:29d:b0:521:db02:1011 with SMTP id
 bf29-20020a05690c029d00b00521db021011mr0ywb.1.1675704234298; Mon, 06 Feb 2023
 09:23:54 -0800 (PST)
Date:   Mon,  6 Feb 2023 17:23:40 +0000
In-Reply-To: <20230206172340.2639971-1-rananta@google.com>
Mime-Version: 1.0
References: <20230206172340.2639971-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206172340.2639971-8-rananta@google.com>
Subject: [PATCH v2 7/7] KVM: arm64: Create a fast stage-2 unmap path
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current implementation of the stage-2 unmap walker
traverses the entire page-table to clear and flush the TLBs
for each entry. This could be very expensive, especially if
the VM is not backed by hugepages. The unmap operation could be
made efficient by disconnecting the table at the very
top (level at which the largest block mapping can be hosted)
and do the rest of the unmapping using free_removed_table().
If the system supports FEAT_TLBIRANGE, flush the entire range
that has been disconnected from the rest of the page-table.

Suggested-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 44 ++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0858d1fa85d6b..af3729d0971f2 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1017,6 +1017,49 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
+/*
+ * The fast walker executes only if the unmap size is exactly equal to the
+ * largest block mapping supported (i.e. at KVM_PGTABLE_MIN_BLOCK_LEVEL),
+ * such that the underneath hierarchy at KVM_PGTABLE_MIN_BLOCK_LEVEL can
+ * be disconnected from the rest of the page-table without the need to
+ * traverse all the PTEs, at all the levels, and unmap each and every one
+ * of them. The disconnected table is freed using free_removed_table().
+ */
+static int fast_stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
+			       enum kvm_pgtable_walk_flags visit)
+{
+	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+	kvm_pte_t *childp = kvm_pte_follow(ctx->old, mm_ops);
+	struct kvm_s2_mmu *mmu = ctx->arg;
+
+	if (!kvm_pte_valid(ctx->old) || ctx->level != KVM_PGTABLE_MIN_BLOCK_LEVEL)
+		return 0;
+
+	if (!stage2_try_break_pte(ctx, mmu))
+		return -EAGAIN;
+
+	/*
+	 * Gain back a reference for stage2_unmap_walker() to free
+	 * this table entry from KVM_PGTABLE_MIN_BLOCK_LEVEL - 1.
+	 */
+	mm_ops->get_page(ctx->ptep);
+
+	mm_ops->free_removed_table(childp, ctx->level);
+	return 0;
+}
+
+static void kvm_pgtable_try_fast_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
+{
+	struct kvm_pgtable_walker walker = {
+		.cb	= fast_stage2_unmap_walker,
+		.arg	= pgt->mmu,
+		.flags	= KVM_PGTABLE_WALK_TABLE_PRE,
+	};
+
+	if (size == kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL))
+		kvm_pgtable_walk(pgt, addr, size, &walker);
+}
+
 int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	struct kvm_pgtable_walker walker = {
@@ -1025,6 +1068,7 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
+	kvm_pgtable_try_fast_stage2_unmap(pgt, addr, size);
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
-- 
2.39.1.519.gcb327c4b5f-goog

