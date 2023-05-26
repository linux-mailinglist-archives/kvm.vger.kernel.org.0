Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39322713076
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 01:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238073AbjEZXo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 19:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237754AbjEZXov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 19:44:51 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22C6E47
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:44:48 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-565a66a5d84so17872377b3.0
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685144687; x=1687736687;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gdtrmeQ7r8fSzyqqoeow0Oco6w18CVCYcKcBQXKvLk0=;
        b=A+5tnxly4jAziM7PCgC2JSUrvZIuWUL9UuTqWd7F/s/V7U9ZvBSUtbCMn4PDjXhEkh
         xPkXA8ijRXU8kfBAAJh45kvENT/cQ+0BqqVDKv4CzNn3FeibDZ4esB2AS5+kj2xWW1A/
         5f+rTWaRryOWr0eLpQP68cwlR3USUfp7Ely4h3ulPbhNc/8a6O9EbhRXY0Hc8yu56mx8
         LQMCwDasuefCJVI+rIDEYvr3/19bdInHAEUvVq6phC2Jc21wzdoWQlzM7WDhIq/i18eK
         BEwyErOKi0xkhmnwWH0N/n1UzNpwg5kRKa2pc24aeVs5XXh0p7GOcbD7gzDkKgQaeHXr
         C7IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685144687; x=1687736687;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gdtrmeQ7r8fSzyqqoeow0Oco6w18CVCYcKcBQXKvLk0=;
        b=j9FSmCVNPZoLsgfa7rNsfxkZUaXyjklB199nyVhXuPS9WWI+DC2AuO4n3GfsVfmNiP
         kMu3IelvFMedTlAjCFjL2QGTjNDkto+9qHez+japSgX4l6UJwvMXIivhw82KdOJ7IoBr
         2tvPnBzpPyTjIRl0NS1+ayNnyzblYooQuuU9uum4Aq/qEQlQ/Hy4IB26vc5/neXZbwIw
         wBQAC+2tjAVUkDYOlLFpmTPLOhYiurJcVSkUdC/ml6c2WHSil6oqP3cfts5ImkOKyfJW
         MsW8pJ/ThhZzIjF0JOnPFy3XJQBXT9Z0I691OhEQFLZcOcAGWCKtqujOaLgVG7SuXbgv
         Zghg==
X-Gm-Message-State: AC+VfDyZTtEAsNZFSXdE9KSHORCdPOhe+Vvoo285AiBLZHvVPcNvtcjY
        mCYsV8PS39h/OGc1e+nG4O4OuA5AiEU=
X-Google-Smtp-Source: ACHHUZ75roT4ZouTjM2lH4DZFyTBmS3QLSjPTFGxgUaEGtzpG1LtCtXvcTQXcsV4/+3guLPQ6FLc+WkYaOc=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:200:910f:8a15:592b:2087])
 (user=yuzhao job=sendgmr) by 2002:a25:b28d:0:b0:bad:155a:1004 with SMTP id
 k13-20020a25b28d000000b00bad155a1004mr1830575ybj.2.1685144687512; Fri, 26 May
 2023 16:44:47 -0700 (PDT)
Date:   Fri, 26 May 2023 17:44:30 -0600
In-Reply-To: <20230526234435.662652-1-yuzhao@google.com>
Message-Id: <20230526234435.662652-6-yuzhao@google.com>
Mime-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Subject: [PATCH mm-unstable v2 05/10] kvm/arm64: add kvm_arch_test_clear_young()
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

Implement kvm_arch_test_clear_young() to support the fast path in
mmu_notifier_ops->test_clear_young().

It focuses on a simple case, i.e., hardware sets the accessed bit in
KVM PTEs and VMs are not protected, where it can rely on RCU and
cmpxchg to safely clear the accessed bit without taking
kvm->mmu_lock. Complex cases fall back to the existing slow path
where kvm->mmu_lock is then taken.

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  6 ++++++
 arch/arm64/kvm/mmu.c              | 36 +++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7e7e19ef6993..da32b0890716 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1113,4 +1113,10 @@ static inline void kvm_hyp_reserve(void) { }
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
 bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 
+#define kvm_arch_has_test_clear_young kvm_arch_has_test_clear_young
+static inline bool kvm_arch_has_test_clear_young(void)
+{
+	return cpu_has_hw_af() && !is_protected_kvm_enabled();
+}
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c3b3e2afe26f..26a8d955b49c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1678,6 +1678,42 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 					   range->start << PAGE_SHIFT);
 }
 
+static int stage2_test_clear_young(const struct kvm_pgtable_visit_ctx *ctx,
+				   enum kvm_pgtable_walk_flags flags)
+{
+	kvm_pte_t new = ctx->old & ~KVM_PTE_LEAF_ATTR_LO_S2_AF;
+
+	VM_WARN_ON_ONCE(!page_count(virt_to_page(ctx->ptep)));
+
+	if (!kvm_pte_valid(new))
+		return 0;
+
+	if (new == ctx->old)
+		return 0;
+
+	if (kvm_should_clear_young(ctx->arg, ctx->addr / PAGE_SIZE))
+		stage2_try_set_pte(ctx, new);
+
+	return 0;
+}
+
+bool kvm_arch_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	u64 start = range->start * PAGE_SIZE;
+	u64 end = range->end * PAGE_SIZE;
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_test_clear_young,
+		.arg	= range,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_SHARED,
+	};
+
+	BUILD_BUG_ON(is_hyp_code());
+
+	kvm_pgtable_walk(kvm->arch.mmu.pgt, start, end - start, &walker);
+
+	return false;
+}
+
 phys_addr_t kvm_mmu_get_httbr(void)
 {
 	return __pa(hyp_pgtable->pgd);
-- 
2.41.0.rc0.172.g3f132b7071-goog

