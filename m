Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F470731FEB
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 20:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjFOS04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 14:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjFOS0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 14:26:55 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32ADA10F7
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 11:26:53 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b4fe2d438bso16627225ad.1
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 11:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686853612; x=1689445612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v5j0wCZPnfsM4/SjEwwVDfexZdOw0uK6iqseA0HQUzE=;
        b=pVetr2jEMF5lF1mCTvADonXqP6bFE0nxsdmxOn0ASTw2/bFTnBCX3GM5/ND7idJYcK
         WLJ9v5Jtgv7YkQ2t1A7zr6BtWjGAUd3nGNd07s8rKjBzK87V1SPxXbBBFz/A0h4/TJ+6
         PGmBMXeXE9iwEFyxsQoXFCV8sBkm29Ah7+IBIGN34Rgv+Rsgl1RNt8i9bBt7KJ4b5QVP
         kObHHMIWjacSwTjfHlphojvQG6ZoJtxmutK76LuVb5zNph2otTKjSu6e9v7dG85CX5qp
         /ZUeWSJZa6+15VCNA95293lQnjitxNStYywqEhGfprGR2cMKGHH5r/UDSXD2EdD+dK2Z
         XA6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686853612; x=1689445612;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v5j0wCZPnfsM4/SjEwwVDfexZdOw0uK6iqseA0HQUzE=;
        b=ZburLNeiX90UCx3EWrtJWCykHkeafFFswkFwae4y3fvOXgxnMBfEArdf4KuQwqXlFq
         062zafGl8uNwewW0CtH1t3H5uOZq36nUTEgV8yKqZ9P0ZesZhWJ9LDLtAFXxLb7EFvnU
         J3zhydG/FNdi4V0eniBd5v8V6zoGWn5Ah5foDWNq3Y3CKdepGyZRwQjZn/LrwLEzT61I
         cAK46EzpvSjmOB+T1q+hwR6hd63THb2lBZy8JQhCq6BkKjFtv1Om8WAwdGfLG6+gCHRr
         QY9QzKjlStdOI6yqEX3ljGZG2rlmborTTyus9sagIc67hy1qB8OxiPYYbPDhoKS7gCeE
         Z/gQ==
X-Gm-Message-State: AC+VfDzHsYaKz29zuG8038VMQZjK7Jpa1mFmwIaBQXdEtJ2vhGtkGKMN
        TlfLqASAI/pvCPYN/+ZVog15dAQvxf8=
X-Google-Smtp-Source: ACHHUZ4XblfvtELYfPfTXYv/mZguDzYqVYK+D/wTZAy9MdyrQSECLLlB+UmOM8NMKOmXv6Fwf6a/c1+W5jI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:a70f:b0:1b5:64:1862 with SMTP id
 w15-20020a170902a70f00b001b500641862mr893196plq.9.1686853612603; Thu, 15 Jun
 2023 11:26:52 -0700 (PDT)
Date:   Thu, 15 Jun 2023 11:26:51 -0700
In-Reply-To: <20230526234435.662652-10-yuzhao@google.com>
Mime-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com> <20230526234435.662652-10-yuzhao@google.com>
Message-ID: <ZItX64Bbx5vdjo9M@google.com>
Subject: Re: [PATCH mm-unstable v2 09/10] kvm/x86: add kvm_arch_test_clear_young()
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alistair Popple <apopple@nvidia.com>,
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
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-trace-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 26, 2023, Yu Zhao wrote:
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 08340219c35a..6875a819e007 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1232,6 +1232,40 @@ bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>  	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
>  }
>  
> +bool kvm_arch_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *range)
> +{
> +	struct kvm_mmu_page *root;
> +	int offset = ffs(shadow_accessed_mask) - 1;
> +
> +	if (kvm_shadow_root_allocated(kvm))

This needs a comment.

> +		return true;
> +
> +	rcu_read_lock();
> +
> +	list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link) {

As requested in v1[1], please add a macro for a lockless walk.

[1] https://lkml.kernel.org/r/Y%2Fed0XYAPx%2B7pukA%40google.com

> +		struct tdp_iter iter;
> +
> +		if (kvm_mmu_page_as_id(root) != range->slot->as_id)
> +			continue;
> +
> +		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end) {
> +			u64 *sptep = rcu_dereference(iter.sptep);
> +
> +			VM_WARN_ON_ONCE(!page_count(virt_to_page(sptep)));

Hrm, I don't like adding this in KVM.  The primary MMU might guarantee that this
callback is invoked if and only if the SPTE is backed by struct page memory, but
there's no reason to assume that's true in KVM.  If we want the sanity check, then
this needs to use kvm_pfn_to_refcounted_page().

And it should use KVM's MMU_WARN_ON(), which is a mess and effectively dead code,
but I'm working on changing that[*], i.e. by the time this gets to Linus' tree,
the sanity check should have a much cleaner implementation.

[2] https://lore.kernel.org/all/20230511235917.639770-8-seanjc@google.com

> +
> +			if (!(iter.old_spte & shadow_accessed_mask))
> +				continue;
> +
> +			if (kvm_should_clear_young(range, iter.gfn))
> +				clear_bit(offset, (unsigned long *)sptep);

If/when you rebase on https://github.com/kvm-x86/linux/tree/next, can you pull
out the atomic bits of tdp_mmu_clear_spte_bits() and use that new helper? E.g.

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index fae559559a80..914c34518829 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -58,15 +58,18 @@ static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
        return old_spte;
 }
 
+static inline u64 tdp_mmu_clear_spte_bits_atomic(tdp_ptep_t sptep, u64 mask)
+{
+       atomic64_t *sptep_atomic = (atomic64_t *)rcu_dereference(sptep);
+
+       return (u64)atomic64_fetch_and(~mask, sptep_atomic);
+}
+
 static inline u64 tdp_mmu_clear_spte_bits(tdp_ptep_t sptep, u64 old_spte,
                                          u64 mask, int level)
 {
-       atomic64_t *sptep_atomic;
-
-       if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level)) {
-               sptep_atomic = (atomic64_t *)rcu_dereference(sptep);
-               return (u64)atomic64_fetch_and(~mask, sptep_atomic);
-       }
+       if (kvm_tdp_mmu_spte_need_atomic_write(old_spte, level))
+               return tdp_mmu_clear_spte_bits_atomic(sptep, mask);
 
        __kvm_tdp_mmu_write_spte(sptep, old_spte & ~mask);
        return old_spte;

