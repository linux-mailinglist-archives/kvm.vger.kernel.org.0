Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49604D5689
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 01:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345180AbiCKA0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 19:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345181AbiCKA0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 19:26:50 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5511A2707
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:47 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id b5-20020a17090a7ac500b001bfc1f48421so2640958pjl.4
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=V/b+716hREpGluS5au7SFvhvrZUH1mP5ZRBJUo2aKek=;
        b=NrOteM9lQZRLTvGjh7Vk2YOgkSJONBJ9EpO+Rh0e4cd73vulmGH+hFimtPt0gE+8Ho
         k8JVHCrbIF0zjGII7zgfaIT8k7/FKxKSqC1qy+gJKY1Fn2gJfg1PT4ql7x80T5MMdSaX
         bC9lIGSQ2dpF23XdAOIxEeUHf4ph7pFTmtW6mlo8a7I2IbuHRD/FW6U8cEQZUD+p+OvW
         NX7TXaXYU4um5GdK+Pbvp3NhR93SLOD1Grc7+fg58Gq5DdoJsaPOmjlVu9RAJc+vFAXt
         UqlKZqaxGUd8fVlMc0DOlFb8fnPCoA2kMW1cjgW7bS5hxnqYubmgtW/N6whS2ZNh3U3y
         2nmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V/b+716hREpGluS5au7SFvhvrZUH1mP5ZRBJUo2aKek=;
        b=UmCV6zFvjQpdPfc9GG0k4rP34y04MjM2iQge/NoQnpyquN3AKZb/FelfWF9F0kD6lb
         TTPCzj7a1hk6zTSaoWD42zYcGOy9TVdck+K1Xlylg9EkBZY2VbZY9PuwiZGa/QU//ptf
         ChaGQb/IuvLt3BoUuiqii9NcdUrKdK4yMfYg41UTt8XtP2isgGqpQDV0tOBeQbB/GHyz
         u4Gi9VCkwLmzr71IUaCqjrHnZtPD8aCTqIKzY0t0Ro/IeeHEUZoA1zAKOJgV7LHl6VPQ
         rVsrmsGPy5pLydb3k4lJVK1RQqGeYtPj0kfJql6WBYg+7PiyfrGY6Dk/cKLXHh4v1Fql
         MFRg==
X-Gm-Message-State: AOAM533maH/Oy6V4tTXMFq5SBZB8cy5mDwBhoAre4IZjHz+rJegGVqbR
        cxRRWWAopH0jq0HXcMixKMD4XEFys7Hz8A==
X-Google-Smtp-Source: ABdhPJwJMvWtF2+lcHehUS9eYrjqEwNfEYfhcTLqNJ3E9xEg/1eZ72BHS9KkgILyrBX8MA8OHqfLuhNcfwn1aQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4d81:b0:1bf:8ce4:4f51 with SMTP
 id oj1-20020a17090b4d8100b001bf8ce44f51mr322556pjb.0.1646958346675; Thu, 10
 Mar 2022 16:25:46 -0800 (PST)
Date:   Fri, 11 Mar 2022 00:25:11 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-10-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 09/26] KVM: x86/mmu: Move huge page split sp allocation
 code to mmu.c
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        David Matlack <dmatlack@google.com>
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

Move the code that allocates a new shadow page for splitting huge pages
into mmu.c. Currently this code is only used by the TDP MMU but it will
be reused in subsequent commits to also split huge pages mapped by the
shadow MMU.

While here, also shove the GFP complexity down into the allocation
function so that it does not have to be duplicated when the shadow MMU
needs to start allocating SPs for splitting.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 34 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/mmu_internal.h |  2 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 34 ++-------------------------------
 3 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e866e05c4ba5..c12d5016f6dc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1722,6 +1722,40 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	return sp;
 }
 
+/*
+ * Allocate a new shadow page, potentially while holding the MMU lock.
+ *
+ * Huge page splitting always uses direct shadow pages since the huge page is
+ * being mapped directly with a lower level page table. Thus there's no need to
+ * allocate the gfns array.
+ */
+struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(bool locked)
+{
+	struct kvm_mmu_page *sp;
+	gfp_t gfp;
+
+	/*
+	 * If under the MMU lock, use GFP_NOWAIT to avoid direct reclaim (which
+	 * is slow) and to avoid making any filesystem callbacks (which can end
+	 * up invoking KVM MMU notifiers, resulting in a deadlock).
+	 */
+	gfp = (locked ? GFP_NOWAIT : GFP_KERNEL) | __GFP_ACCOUNT | __GFP_ZERO;
+
+	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
+	if (!sp)
+		return NULL;
+
+	sp->spt = (void *)__get_free_page(gfp);
+	if (!sp->spt) {
+		kmem_cache_free(mmu_page_header_cache, sp);
+		return NULL;
+	}
+
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+
+	return sp;
+}
+
 static void mark_unsync(u64 *spte);
 static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
 {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1bff453f7cbe..a0648e7ddd33 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -171,4 +171,6 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(bool locked);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index eecb0215e636..1a43f908d508 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1393,43 +1393,13 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
-{
-	struct kvm_mmu_page *sp;
-
-	gfp |= __GFP_ZERO;
-
-	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
-	if (!sp)
-		return NULL;
-
-	sp->spt = (void *)__get_free_page(gfp);
-	if (!sp->spt) {
-		kmem_cache_free(mmu_page_header_cache, sp);
-		return NULL;
-	}
-
-	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
-
-	return sp;
-}
-
 static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 						       struct tdp_iter *iter,
 						       bool shared)
 {
 	struct kvm_mmu_page *sp;
 
-	/*
-	 * Since we are allocating while under the MMU lock we have to be
-	 * careful about GFP flags. Use GFP_NOWAIT to avoid blocking on direct
-	 * reclaim and to avoid making any filesystem callbacks (which can end
-	 * up invoking KVM MMU notifiers, resulting in a deadlock).
-	 *
-	 * If this allocation fails we drop the lock and retry with reclaim
-	 * allowed.
-	 */
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
+	sp = kvm_mmu_alloc_direct_sp_for_split(true);
 	if (sp)
 		return sp;
 
@@ -1441,7 +1411,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 
 	iter->yielded = true;
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
+	sp = kvm_mmu_alloc_direct_sp_for_split(false);
 
 	if (shared)
 		read_lock(&kvm->mmu_lock);
-- 
2.35.1.723.g4982287a31-goog

