Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2EE9600E25
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 13:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiJQLw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 07:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiJQLw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 07:52:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1AE15812
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 04:52:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D33B610A2
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5B4C4347C;
        Mon, 17 Oct 2022 11:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666007546;
        bh=+fQLKdCRMyVXv9zLE1eBeiQI5NRaL8bTwzFAc5SEhgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVyzoKkgxXVLlKW+5D+YXWMw+eO+YwNFEq7bybQ7FVGUq2S/jHJs665RCaw9C+QgX
         r4+DbDzpZjjl2HhbMAybZMG65B+CUDVXyoSkNNgmfxWGS4lBHa5lccnxJAb0kkkhOa
         y8VHQHGYnX6xcJpxPCk2+andsIWNmOMa/FJalQ8y6vs31J8CuUNTU7hanuXSRXjV1z
         085HAXdIo6MGb/GsV05ARQVSanCmitQAHSEiMGYZ80MC0bMboFdw+p++B2JLJbTItj
         ptaT5o52dhY/FrYbvVfYdrWYg/4UXiFydICg6B7IVNLS8nNFCMeGBewh6MNxyT7QBt
         wbB8swDwtyhyA==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.linux.dev
Cc:     Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v4 01/25] KVM: arm64: Move hyp refcount manipulation helpers to common header file
Date:   Mon, 17 Oct 2022 12:51:45 +0100
Message-Id: <20221017115209.2099-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20221017115209.2099-1-will@kernel.org>
References: <20221017115209.2099-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

We will soon need to manipulate 'struct hyp_page' refcounts from outside
page_alloc.c, so move the helpers to a common header file to allow them
to be reused easily.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 22 ++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 19 -------------------
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 592b7edb3edb..9422900e5c6a 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -38,6 +38,10 @@ static inline phys_addr_t hyp_virt_to_phys(void *addr)
 #define hyp_page_to_virt(page)	__hyp_va(hyp_page_to_phys(page))
 #define hyp_page_to_pool(page)	(((struct hyp_page *)page)->pool)
 
+/*
+ * Refcounting for 'struct hyp_page'.
+ * hyp_pool::lock must be held if atomic access to the refcount is required.
+ */
 static inline int hyp_page_count(void *addr)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
@@ -45,4 +49,22 @@ static inline int hyp_page_count(void *addr)
 	return p->refcount;
 }
 
+static inline void hyp_page_ref_inc(struct hyp_page *p)
+{
+	BUG_ON(p->refcount == USHRT_MAX);
+	p->refcount++;
+}
+
+static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
+{
+	BUG_ON(!p->refcount);
+	p->refcount--;
+	return (p->refcount == 0);
+}
+
+static inline void hyp_set_page_refcounted(struct hyp_page *p)
+{
+	BUG_ON(p->refcount);
+	p->refcount = 1;
+}
 #endif /* __KVM_HYP_MEMORY_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index d40f0b30b534..1ded09fc9b10 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -144,25 +144,6 @@ static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
 	return p;
 }
 
-static inline void hyp_page_ref_inc(struct hyp_page *p)
-{
-	BUG_ON(p->refcount == USHRT_MAX);
-	p->refcount++;
-}
-
-static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
-{
-	BUG_ON(!p->refcount);
-	p->refcount--;
-	return (p->refcount == 0);
-}
-
-static inline void hyp_set_page_refcounted(struct hyp_page *p)
-{
-	BUG_ON(p->refcount);
-	p->refcount = 1;
-}
-
 static void __hyp_put_page(struct hyp_pool *pool, struct hyp_page *p)
 {
 	if (hyp_page_ref_dec_and_test(p))
-- 
2.38.0.413.g74048e4d9e-goog

