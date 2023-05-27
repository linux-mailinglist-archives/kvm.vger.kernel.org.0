Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD26713609
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 20:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjE0SIw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 May 2023 14:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjE0SIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 May 2023 14:08:51 -0400
Received: from out-14.mta0.migadu.com (out-14.mta0.migadu.com [IPv6:2001:41d0:1004:224b::e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C960D8
        for <kvm@vger.kernel.org>; Sat, 27 May 2023 11:08:48 -0700 (PDT)
Date:   Sat, 27 May 2023 18:08:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685210926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qro1ly8D0IN85bz01iVra27g5btF8pv3UlKO41a9+sM=;
        b=llE6IRkx/n91QHSJfUuz8Lvf36Zsdvbsda8s4+YDAphela0hHMrM+udZgnGOhdOMmdcMem
        6eMFZGQIhSrfmCXeAFxKmM8bvTDiACcfidzZol+st9/hDl3h5IknZGYlF6wWBlLroxmus0
        h5pa83O4YLhVJG62l7K1d5yuFK61noU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
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
        linux-mm@google.com
Subject: Re: [PATCH mm-unstable v2 04/10] kvm/arm64: make stage2 page tables
 RCU safe
Message-ID: <ZHJHJPBF6euzOFdw@linux.dev>
References: <20230526234435.662652-1-yuzhao@google.com>
 <20230526234435.662652-5-yuzhao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526234435.662652-5-yuzhao@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Yu,

On Fri, May 26, 2023 at 05:44:29PM -0600, Yu Zhao wrote:
> Stage2 page tables are currently not RCU safe against unmapping or VM
> destruction. The previous mmu_notifier_ops members rely on
> kvm->mmu_lock to synchronize with those operations.
> 
> However, the new mmu_notifier_ops member test_clear_young() provides
> a fast path that does not take kvm->mmu_lock. To implement
> kvm_arch_test_clear_young() for that path, unmapped page tables need
> to be freed by RCU and kvm_free_stage2_pgd() needs to be after
> mmu_notifier_unregister().
> 
> Remapping, specifically stage2_free_removed_table(), is already RCU
> safe.
> 
> Signed-off-by: Yu Zhao <yuzhao@google.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h |  2 ++
>  arch/arm64/kvm/arm.c                 |  1 +
>  arch/arm64/kvm/hyp/pgtable.c         |  8 ++++++--
>  arch/arm64/kvm/mmu.c                 | 17 ++++++++++++++++-
>  4 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index ff520598b62c..5cab52e3a35f 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -153,6 +153,7 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
>   * @put_page:			Decrement the refcount on a page. When the
>   *				refcount reaches 0 the page is automatically
>   *				freed.
> + * @put_page_rcu:		RCU variant of the above.

You don't need to add yet another hook to implement this. I was working
on lock-free walks in a separate context and arrived at the following:

commit f82d264a37745e07ee28e116c336f139f681fd7f
Author: Oliver Upton <oliver.upton@linux.dev>
Date:   Mon May 1 08:53:37 2023 +0000

    KVM: arm64: Consistently use free_removed_table() for stage-2
    
    free_removed_table() is essential to the RCU-protected parallel walking
    scheme, as behind the scenes the cleanup is deferred until an RCU grace
    period. Nonetheless, the stage-2 unmap path calls put_page() directly,
    which leads to table memory being freed inline with the table walk.
    
    This is safe for the time being, as the stage-2 unmap walker is called
    while holding the write lock. A future change to KVM will further relax
    the locking mechanics around the stage-2 page tables to allow lock-free
    walkers protected only by RCU. As such, switch to the RCU-safe mechanism
    for freeing table memory.
    
    Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3d61bd3e591d..bfbebdcb4ef0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1019,7 +1019,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 					       kvm_granule_size(ctx->level));
 
 	if (childp)
-		mm_ops->put_page(childp);
+		mm_ops->free_removed_table(childp, ctx->level);
 
 	return 0;
 }

-- 
Thanks,
Oliver
