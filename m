Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60395713082
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 01:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238011AbjEZXpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 19:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237655AbjEZXou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 19:44:50 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB3A1B0
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:44:46 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5655d99da53so32319527b3.0
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685144686; x=1687736686;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9t4P2GvyPz5aecPxpWswvlll2je3r362Snycxj82bkU=;
        b=cWUN3P8rM/d3APcGkGsw1zxYbzC0SLP23YWYAHvNkl8en24zIhenJIzsgauwSrM86L
         GtpWgjW+9PaIY51P7YD5ERtfy398MWWnA2qbOrXT+m6cJHuvmS8It0VeeYLeOMql5pG+
         oF4R8PaA47tg1/M/GaUTjyQPHdY2Yt35bMOgs0yeO0A95+MuHExqrRIRhATT/aSAcAvS
         DuZIw+jQWwcC1PbwFYK5fVCc5aYJ2bcpXcCLA842C0fEFJDU8WE3MLQI6mTQVW9b35Gn
         iKpM9XslaKQGwLt7gqMS0LD/fBOZjhpB3/6lsoxW54UOFTglxZ15DmEhLn/Wm52Z8EKo
         74zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685144686; x=1687736686;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9t4P2GvyPz5aecPxpWswvlll2je3r362Snycxj82bkU=;
        b=dTNVA1rKzw0G4hQO6slUnsweTUwneksfeNGWtS332RkG2tFCN6CH7N1uj5pdthwa5x
         o+ypInAjJ3Lg72XebWOijTyEqMVJ2avU/xIbtnu1eW/7UTzKHlo7VM/60AEMOhEXJS2P
         uM2TIoCpYWM6WtW9DRfRTHahNrY8Ckn43Xw2TfjDFqRpQJpvP+kTnJONsxONXTB1XbuK
         omznydEGU68cCPkABmwfpTkieVEDHwhW9GPw0W7VOvzowcenaaypUO4Lp/PuZ85xcXFH
         EUlG4IEjSY6AdYPwlNOAZ3xD+dD917wdEbDnmoqYzjd62CAslmi+fT84Y195BTpoXW+E
         6V2A==
X-Gm-Message-State: AC+VfDz6yNLaEXrQ+HebiiZK5HuvGvKk59WRvVyLbpo1uukiDOcuAw1s
        9rS+oG3Mx3cIF7rRfvm1dH3bXRD/6bg=
X-Google-Smtp-Source: ACHHUZ671mv9b1WNngTqma0ZpDsFyu7jCdBVYj6cC/Q6bUpKz7y4SPqrDazly1Z4TuFOLliyXqQloqgktcM=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:200:910f:8a15:592b:2087])
 (user=yuzhao job=sendgmr) by 2002:a81:b627:0:b0:559:d859:d749 with SMTP id
 u39-20020a81b627000000b00559d859d749mr437593ywh.5.1685144686225; Fri, 26 May
 2023 16:44:46 -0700 (PDT)
Date:   Fri, 26 May 2023 17:44:29 -0600
In-Reply-To: <20230526234435.662652-1-yuzhao@google.com>
Message-Id: <20230526234435.662652-5-yuzhao@google.com>
Mime-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Subject: [PATCH mm-unstable v2 04/10] kvm/arm64: make stage2 page tables RCU safe
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

Stage2 page tables are currently not RCU safe against unmapping or VM
destruction. The previous mmu_notifier_ops members rely on
kvm->mmu_lock to synchronize with those operations.

However, the new mmu_notifier_ops member test_clear_young() provides
a fast path that does not take kvm->mmu_lock. To implement
kvm_arch_test_clear_young() for that path, unmapped page tables need
to be freed by RCU and kvm_free_stage2_pgd() needs to be after
mmu_notifier_unregister().

Remapping, specifically stage2_free_removed_table(), is already RCU
safe.

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  2 ++
 arch/arm64/kvm/arm.c                 |  1 +
 arch/arm64/kvm/hyp/pgtable.c         |  8 ++++++--
 arch/arm64/kvm/mmu.c                 | 17 ++++++++++++++++-
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index ff520598b62c..5cab52e3a35f 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -153,6 +153,7 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
  * @put_page:			Decrement the refcount on a page. When the
  *				refcount reaches 0 the page is automatically
  *				freed.
+ * @put_page_rcu:		RCU variant of the above.
  * @page_count:			Return the refcount of a page.
  * @phys_to_virt:		Convert a physical address into a virtual
  *				address	mapped in the current context.
@@ -170,6 +171,7 @@ struct kvm_pgtable_mm_ops {
 	void		(*free_removed_table)(void *addr, u32 level);
 	void		(*get_page)(void *addr);
 	void		(*put_page)(void *addr);
+	void		(*put_page_rcu)(void *addr);
 	int		(*page_count)(void *addr);
 	void*		(*phys_to_virt)(phys_addr_t phys);
 	phys_addr_t	(*virt_to_phys)(void *addr);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14391826241c..ee93271035d9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -191,6 +191,7 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
  */
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	kvm_free_stage2_pgd(&kvm->arch.mmu);
 	bitmap_free(kvm->arch.pmu_filter);
 	free_cpumask_var(kvm->arch.supported_cpus);
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 24678ccba76a..dbace4c6a841 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -988,8 +988,12 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
 					       kvm_granule_size(ctx->level));
 
-	if (childp)
-		mm_ops->put_page(childp);
+	if (childp) {
+		if (mm_ops->put_page_rcu)
+			mm_ops->put_page_rcu(childp);
+		else
+			mm_ops->put_page(childp);
+	}
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3b9d4d24c361..c3b3e2afe26f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -172,6 +172,21 @@ static int kvm_host_page_count(void *addr)
 	return page_count(virt_to_page(addr));
 }
 
+static void kvm_s2_rcu_put_page(struct rcu_head *head)
+{
+	put_page(container_of(head, struct page, rcu_head));
+}
+
+static void kvm_s2_put_page_rcu(void *addr)
+{
+	struct page *page = virt_to_page(addr);
+
+	if (kvm_host_page_count(addr) == 1)
+		kvm_account_pgtable_pages(addr, -1);
+
+	call_rcu(&page->rcu_head, kvm_s2_rcu_put_page);
+}
+
 static phys_addr_t kvm_host_pa(void *addr)
 {
 	return __pa(addr);
@@ -704,6 +719,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.free_removed_table	= stage2_free_removed_table,
 	.get_page		= kvm_host_get_page,
 	.put_page		= kvm_s2_put_page,
+	.put_page_rcu		= kvm_s2_put_page_rcu,
 	.page_count		= kvm_host_page_count,
 	.phys_to_virt		= kvm_host_va,
 	.virt_to_phys		= kvm_host_pa,
@@ -1877,7 +1893,6 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	kvm_free_stage2_pgd(&kvm->arch.mmu);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
2.41.0.rc0.172.g3f132b7071-goog

