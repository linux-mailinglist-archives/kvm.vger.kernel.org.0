Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63E5663391
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 22:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237670AbjAIVy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 16:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237795AbjAIVyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 16:54:21 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8276E3631A
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 13:54:13 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id g11-20020a056e021a2b00b0030da3e7916fso3434701ile.18
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 13:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QnWQSYtdYbIpMuZp6LkKgpjLfcHlUZmLQRKHyPWiT+U=;
        b=SoQHKoORituEmv9rUcL664DtdyreklZiFGEKpPbMIqEEDHQRWBI7SRr3f7cEoqCsvZ
         1e7IZZ836ejawXXum/N1EwK5B4IqD2gR6GsFJWCf92qXR9lLgyBN3G4c5l9JL/DOIgzd
         5SoZlkxgAJogZrpvMLXlxuFB6zLuebhc5CnJ3Lvd6tWm5FooSJa7Awa5clf+HtqEP2aG
         eQESQnMpMQOrH2ch9tyF4Sn5bZVnHYL9cgG5M0HGBrBLO1SgEiQFRQ0FQspsxC0pC7hs
         ur+0YtUUCtgQF8i/Lg4Oe9SZDzJBgNK97UxeExA2fo2dWsRWc7G5+liOox0x9OsztI9W
         /J9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QnWQSYtdYbIpMuZp6LkKgpjLfcHlUZmLQRKHyPWiT+U=;
        b=MPpAjXziZRgErvc4JlPd8KzFglIKe6r66gm/vRO3GmsFG2F/8OWfQSwKBYE1ilNTvo
         8HZ4JFBtwmKPsylCoL1h8pTaKPEAGF2SO7WPAYmCtrz/fAohVAMEAM79FVNcQSidb38q
         86cxPDNm/V2Gg0XQE+8oQvb+WnihVa58CaIv3IH+Y8WiAZKeXTZGOa1Hz6SWA6MlXJgV
         5zFEtXEgEmsW8UOQmErFqRYOZFd/Z5+YQQRWay+laqmmYXLJ+F3m7W/87oORYeHbwc6Z
         uovWAZ7i7ImZ4aRpvSAsTIXqMJOE494aWn/Usr32MCtAv/rB23Q/9LAPrCab+/xqWKfx
         66uQ==
X-Gm-Message-State: AFqh2koy3i0BKbLcKqeb3VcphSX+D0bLzSjkoj+3lJJWMetW+zo2Dq6m
        FNvFfu9lSWD1QFRema2CQiQU2c/Uh8oy
X-Google-Smtp-Source: AMrXdXuEKpemaG/E8lRrZNDz8BRpwdnTj1XFG2QPwNU3UfWi6vqI2Uo/p3n228o5g0euwm8Gw3DaqOUCn3p1
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a92:4a11:0:b0:300:e879:8094 with SMTP id
 m17-20020a924a11000000b00300e8798094mr6116771ilf.153.1673301252929; Mon, 09
 Jan 2023 13:54:12 -0800 (PST)
Date:   Mon,  9 Jan 2023 21:53:47 +0000
In-Reply-To: <20230109215347.3119271-1-rananta@google.com>
Mime-Version: 1.0
References: <20230109215347.3119271-1-rananta@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109215347.3119271-7-rananta@google.com>
Subject: [RFC PATCH 6/6] KVM: arm64: Create a fast stage-2 unmap path
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current implementation of the stage-2 unmap walker
traverses the entire page-table to clear and flush the TLBs
for each entry. This could be very expensive if the VM
is not backed by hugepages. The unmap operation could be
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
index 099032bb01bce..7bcd898de2805 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1021,6 +1021,49 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
+/*
+ * The fast walker executes only if the unmap size is exactly equal to the
+ * largest block mapping supported (i.e. at KVM_PGTABLE_MIN_BLOCK_LEVEL),
+ * such that the underneath hierarchy at KVM_PGTABLE_MIN_BLOCK_LEVEL can
+ * be disconnected from the rest of the page-table without the need to
+ * traverse all the PTEs, at all the levels, and unmap each and every one
+ * of them. The disconnected table can be freed using free_removed_table().
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
+	if (!stage2_try_break_pte(ctx, mmu, 0))
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
@@ -1029,6 +1072,7 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
+	kvm_pgtable_try_fast_stage2_unmap(pgt, addr, size);
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
-- 
2.39.0.314.g84b9a713c41-goog

