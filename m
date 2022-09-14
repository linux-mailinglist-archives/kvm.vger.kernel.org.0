Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449CF5B82F0
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 10:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiINIfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 04:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiINIfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 04:35:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4501B79B
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 01:35:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76B94B81677
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 08:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20475C433D7;
        Wed, 14 Sep 2022 08:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663144513;
        bh=wU55wKAQiWOPw2GVwEciR9xyeam6blJip5bVSN4bKYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIF2/7G5V6tl9zZ+lZardjx0o2onsy42Z+OoeFPtVgsc3Hxlg7fGSanPcJSxTQh51
         DbSJHw8flNhWqe4HLJDzOd4igxOCzj1odnD9tkh5S3LM4gZoR1Gtsk6I6IFRjP4I0e
         wlkJP3YAgwONmvZRPIYsEYM4jN6pzG6n+QzkiLln9dudniwAAKHWn+w0E7Fsw5ktWy
         KoSavgaTImwqMbTsnoBWJzaEeHlzNb2Q5WHL9jZ1LmFZK9W2/WbVtOqoAS3VmKQpTY
         rXselAKl3bBqJpkjRWgWRRpZdWpIkBVboqNnCd2FZRVkenYLJg8VNRVXk9pE60X8Bb
         ujyWCWYxaUXTg==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
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
Subject: [PATCH v3 01/25] KVM: arm64: Move hyp refcount manipulation helpers to common header file
Date:   Wed, 14 Sep 2022 09:34:36 +0100
Message-Id: <20220914083500.5118-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Quentin Perret <qperret@google.com>

We will soon need to manipulate 'struct hyp_page' refcounts from outside
page_alloc.c, so move the helpers to a common header file to allow them
to be reused easily.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/memory.h | 18 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 19 -------------------
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 592b7edb3edb..418b66a82a50 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -45,4 +45,22 @@ static inline int hyp_page_count(void *addr)
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
2.37.2.789.g6183377224-goog

