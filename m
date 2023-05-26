Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BADA713081
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 01:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237707AbjEZXo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 19:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237512AbjEZXos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 19:44:48 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F60D189
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:44:45 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5659c7dad06so31208097b3.0
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685144684; x=1687736684;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W5mqYLgSgL41U5MVABcpsNGg2VTYVhdnWBmYAGgA32M=;
        b=lFfC+K1prBwz+QWauf5t3Z5nGOG+XH3WsUV6BbAJbu8yEh9dwSmQ7iKcNTjxofo1xQ
         drv4Lmvn48X7bRRKv2GPWasyFIShdI23SCQ+h/TYUmoXc/hOnlnscK719N8Jpf3m7n6U
         mEaD6Epy7t6qJzvv/9f9Jp/JqQmnMe81faOyaQAqHTEXDufnGK7wY+Ey5ZFKaBi7dzJd
         6O8PEoHW6NsTzElKeYmJHsoCaRTvtaP/AkDf6+cRfXVKyOf9lMpoYxPIHrUwcDj+nl2+
         7q+JpYkRKelWoBaQmJuf7/axxLP6kaz1KnqZQAEmA4XWZSzVgynpinko26WGtZXkTjpp
         oXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685144684; x=1687736684;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W5mqYLgSgL41U5MVABcpsNGg2VTYVhdnWBmYAGgA32M=;
        b=RRFgWcUV8SMrn0ypuwD53JeMzgp92j3klGF8DCyCn+aFrFrs9M5PUNNttUuacprvWi
         bOGBcCQaAwrTwlBt2/eGdOZ1Ev9fEpN+GmCOCOfvJXfF6QMXFmQhVvZi5XwynLe5UZZ1
         5E9sCEtC8v36rh20VOMmJa6z5emXV0w7+9/B5lR2EMsAqm38ClCnmga/yVVzcHgy+eil
         Ch5mqM9OLYpMAdaUY9i2DHJDwU6DcLFni2o8ggZhGbpz6vC6cZsmYX+G0311oKCR60Sr
         QY5BRkH9qfXDTopFqAIgt90sRgQhgNS8+vdUv6Nz8M/2x4bJkmCByZxCD4iWx5S/dAyy
         HHPw==
X-Gm-Message-State: AC+VfDwmuR17nB3jfAJjkkax2IkAJNV2WfmonQkiQTzwDMagnHDopU+0
        2LapCvUHK4OL9kMWZYTQNdiPjXevoK8=
X-Google-Smtp-Source: ACHHUZ5aYhy2MBmaWD1q0FxpVfKGE+Nrskt2Z7iv2nNf760O+qZ11RhzmW2rToUdRrv6PXs76j2V3Kvga7o=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:200:910f:8a15:592b:2087])
 (user=yuzhao job=sendgmr) by 2002:a81:4421:0:b0:565:9f59:664f with SMTP id
 r33-20020a814421000000b005659f59664fmr2006806ywa.6.1685144684605; Fri, 26 May
 2023 16:44:44 -0700 (PDT)
Date:   Fri, 26 May 2023 17:44:28 -0600
In-Reply-To: <20230526234435.662652-1-yuzhao@google.com>
Message-Id: <20230526234435.662652-4-yuzhao@google.com>
Mime-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Subject: [PATCH mm-unstable v2 03/10] kvm/arm64: export stage2_try_set_pte()
 and macros
From:   Yu Zhao <yuzhao@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alistair Popple <apopple@nvidia.com>,
        Anup Patel <anup@brainfault.org>,
        Ben Gardon <bgardon@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Gavin Shan <gshan@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Larabel <michael@michaellarabel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paul Mackerras <paulus@ozlabs.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-trace-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@google.com, Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

stage2_try_set_pte() and KVM_PTE_LEAF_ATTR_LO_S2_AF are needed to
implement kvm_arch_test_clear_young().

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 53 ++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 53 ----------------------------
 2 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index dc3c072e862f..ff520598b62c 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -44,6 +44,49 @@ typedef u64 kvm_pte_t;
 
 #define KVM_PHYS_INVALID		(-1ULL)
 
+#define KVM_PTE_TYPE			BIT(1)
+#define KVM_PTE_TYPE_BLOCK		0
+#define KVM_PTE_TYPE_PAGE		1
+#define KVM_PTE_TYPE_TABLE		1
+
+#define KVM_PTE_LEAF_ATTR_LO		GENMASK(11, 2)
+
+#define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX	GENMASK(4, 2)
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP	GENMASK(7, 6)
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO	3
+#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW	1
+#define KVM_PTE_LEAF_ATTR_LO_S1_SH	GENMASK(9, 8)
+#define KVM_PTE_LEAF_ATTR_LO_S1_SH_IS	3
+#define KVM_PTE_LEAF_ATTR_LO_S1_AF	BIT(10)
+
+#define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR	GENMASK(5, 2)
+#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R	BIT(6)
+#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W	BIT(7)
+#define KVM_PTE_LEAF_ATTR_LO_S2_SH	GENMASK(9, 8)
+#define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS	3
+#define KVM_PTE_LEAF_ATTR_LO_S2_AF	BIT(10)
+
+#define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 51)
+
+#define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
+
+#define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
+
+#define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
+
+#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
+					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
+					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
+
+#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
+#define KVM_MAX_OWNER_ID		1
+
+/*
+ * Used to indicate a pte for which a 'break-before-make' sequence is in
+ * progress.
+ */
+#define KVM_INVALID_PTE_LOCKED		BIT(10)
+
 static inline bool kvm_pte_valid(kvm_pte_t pte)
 {
 	return pte & KVM_PTE_VALID;
@@ -224,6 +267,16 @@ static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *c
 	return ctx->flags & KVM_PGTABLE_WALK_SHARED;
 }
 
+static inline bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
+{
+	if (!kvm_pgtable_walk_shared(ctx)) {
+		WRITE_ONCE(*ctx->ptep, new);
+		return true;
+	}
+
+	return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
+}
+
 /**
  * struct kvm_pgtable_walker - Hook into a page-table walk.
  * @cb:		Callback function to invoke during the walk.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 5282cb9ca4cf..24678ccba76a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -12,49 +12,6 @@
 #include <asm/stage2_pgtable.h>
 
 
-#define KVM_PTE_TYPE			BIT(1)
-#define KVM_PTE_TYPE_BLOCK		0
-#define KVM_PTE_TYPE_PAGE		1
-#define KVM_PTE_TYPE_TABLE		1
-
-#define KVM_PTE_LEAF_ATTR_LO		GENMASK(11, 2)
-
-#define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX	GENMASK(4, 2)
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP	GENMASK(7, 6)
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RO	3
-#define KVM_PTE_LEAF_ATTR_LO_S1_AP_RW	1
-#define KVM_PTE_LEAF_ATTR_LO_S1_SH	GENMASK(9, 8)
-#define KVM_PTE_LEAF_ATTR_LO_S1_SH_IS	3
-#define KVM_PTE_LEAF_ATTR_LO_S1_AF	BIT(10)
-
-#define KVM_PTE_LEAF_ATTR_LO_S2_MEMATTR	GENMASK(5, 2)
-#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R	BIT(6)
-#define KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W	BIT(7)
-#define KVM_PTE_LEAF_ATTR_LO_S2_SH	GENMASK(9, 8)
-#define KVM_PTE_LEAF_ATTR_LO_S2_SH_IS	3
-#define KVM_PTE_LEAF_ATTR_LO_S2_AF	BIT(10)
-
-#define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 51)
-
-#define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
-
-#define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
-
-#define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
-
-#define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
-					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
-					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
-
-#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
-#define KVM_MAX_OWNER_ID		1
-
-/*
- * Used to indicate a pte for which a 'break-before-make' sequence is in
- * progress.
- */
-#define KVM_INVALID_PTE_LOCKED		BIT(10)
-
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable_walker	*walker;
 
@@ -702,16 +659,6 @@ static bool stage2_pte_is_locked(kvm_pte_t pte)
 	return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
 }
 
-static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
-{
-	if (!kvm_pgtable_walk_shared(ctx)) {
-		WRITE_ONCE(*ctx->ptep, new);
-		return true;
-	}
-
-	return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
-}
-
 /**
  * stage2_try_break_pte() - Invalidates a pte according to the
  *			    'break-before-make' requirements of the
-- 
2.41.0.rc0.172.g3f132b7071-goog

