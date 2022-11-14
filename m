Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63381628283
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 15:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbiKNO31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 09:29:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236762AbiKNO3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 09:29:23 -0500
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BC528E18
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 06:29:18 -0800 (PST)
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20221114142915euoutp0228b39f2d16b71c032897deb0e65e0031~nedgN-55c1202312023euoutp02K
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 14:29:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20221114142915euoutp0228b39f2d16b71c032897deb0e65e0031~nedgN-55c1202312023euoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668436155;
        bh=tH7IvdpIRni8xd8mM+dKwkwd+lFrflP2wBRHEgT3wJc=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=BrzQkGfeLACul2lUmFt9c4BJ7/IxGcp/unQxzgG207NLWpgGKGfYGz3CTQ/6VNrAn
         j+P5rXoPpQKodlYfFgDOq0FxgfyGRqghIu3wSuxAg50FQFuFAfGC2rR2MTK2egW3CX
         i9avjRJDcwXPWvlkEXrMvQ2GJXTRQZxBxWVyJH4c=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221114142915eucas1p19dbfd418578d2c55d92133788422a21b~nedf3wAAz2164621646eucas1p1q;
        Mon, 14 Nov 2022 14:29:15 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id AC.B3.09561.BB052736; Mon, 14
        Nov 2022 14:29:15 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20221114142915eucas1p258f3ca2c536bde712c068e96851468fd~nedffZu6s1272912729eucas1p2d;
        Mon, 14 Nov 2022 14:29:15 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221114142915eusmtrp2eb2cd8603adfc2795efcc4618842ba77~nedfeZvH42331123311eusmtrp2W;
        Mon, 14 Nov 2022 14:29:15 +0000 (GMT)
X-AuditID: cbfec7f2-0b3ff70000002559-b2-637250bbe67a
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 08.6A.08916.AB052736; Mon, 14
        Nov 2022 14:29:14 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221114142914eusmtip150f1cfb9b1e92f0c95d56aa3760fc365~nedepCj391861518615eusmtip1i;
        Mon, 14 Nov 2022 14:29:14 +0000 (GMT)
Message-ID: <d9854277-0411-8169-9e8b-68d15e4c0248@samsung.com>
Date:   Mon, 14 Nov 2022 15:29:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0)
        Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20221107215644.1895162-9-oliver.upton@linux.dev>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsWy7djP87q7A4qSDW7NFLeYvvIym8WyC/IW
        kxubWSxe7trGZHF/33ImizlTCy0+njrObvFqy2EWi02Pr7Fa7JxzktVi6s83bBZb9n9jtziz
        aRuLxd6GGWwWe9c8Z7E4ev4Wk0XLHVMHQY8189YweizYVOqxaVUnm8fChqnMHuc3rWH22Lyk
        3uPF5pmMHu/3XWXz+LxJLoAzissmJTUnsyy1SN8ugSvj5vdbjAV91hX3eyexNzCuM+hi5OSQ
        EDCReNSygK2LkYtDSGAFo8Ta+9OZIJwvjBJTf7SwQDifGSWOdn9lg2n5OP8DK0RiOaPEhWON
        zCAJIYGPjBK/PgiD2LwCdhI9B/+DxVkEVCUunp/EAhEXlDg58wmYLSqQIrFwyw0mEFtYwEei
        /9YfMJtZQFzi1pP5YGeICMxhlLg68QnYNmaBncwSjzr6wKrYBAwlut52gZ3ECbTtxtKFrBDd
        8hLNW2czgzRICBzmlPj8ZgLU3S4SF3bcY4ewhSVeHd8CZctI/N8JsU5CoJ1RYsHv+1DOBEaJ
        hue3GCGqrCXunPsFNIkDaIWmxPpd+hBhR4mJP6exgIQlBPgkbrwVhDiCT2LStunMEGFeiY42
        IYhqNYlZx9fBrT144RLzBEalWUgBMwspAGYheWcWwt4FjCyrGMVTS4tz01OLDfNSy/WKE3OL
        S/PS9ZLzczcxAlPh6X/HP+1gnPvqo94hRiYOxkOMEhzMSiK882Tyk4V4UxIrq1KL8uOLSnNS
        iw8xSnOwKInzss3QShYSSE8sSc1OTS1ILYLJMnFwSjUw9XkWhoWIL69oNuOSkTe8HPSnrfHp
        Qk5OBc5dd7/X/xJwO8YgudaRabuG/445IU/Tlc0ZXfdZmQf0nwxve+b6hC9ewqn/01Xpj+4T
        s5ivLQ/9tI3zjkFmhdqt6+6srELXFW14rsfcn3r20r+53/9ptCyatCKD9W2z47YXRX8d1v/d
        vz32tPAf07u3mKPnWeauX3IhaW7apoLpD01XLywuW5Fi3+W2r4TlpubOnsXrBOWPGWzJm/Zx
        zdT6DV+3rCp9bXapVqi94fKOF1ua5b2VFeNm3vnFqCRz//kRzT3BF17feMK17OqflIjAm3ss
        fSacTnd4aTDVr1mEMfSEfFLxmvKl6Tafnl/S2uucE1SooMRSnJFoqMVcVJwIAMbVT2n0AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t/xu7q7AoqSDVYdM7eYvvIym8WyC/IW
        kxubWSxe7trGZHF/33ImizlTCy0+njrObvFqy2EWi02Pr7Fa7JxzktVi6s83bBZb9n9jtziz
        aRuLxd6GGWwWe9c8Z7E4ev4Wk0XLHVMHQY8189YweizYVOqxaVUnm8fChqnMHuc3rWH22Lyk
        3uPF5pmMHu/3XWXz+LxJLoAzSs+mKL+0JFUhI7+4xFYp2tDCSM/Q0kLPyMRSz9DYPNbKyFRJ
        384mJTUnsyy1SN8uQS/j5vdbjAV91hX3eyexNzCuM+hi5OSQEDCR+Dj/A2sXIxeHkMBSRonT
        s+YzQyRkJE5Oa2CFsIUl/lzrYoMoes8oMXfiC0aQBK+AnUTPwf9gDSwCqhIXz09igYgLSpyc
        +QTI5uAQFUiRWHckCiQsLOAj0X/rDxOIzSwgLnHryXwmkJkiAnMYJTbfmskI4jAL7GSW2HTi
        NTtIlZBAocTuu6vBFrAJGEp0vQW5gpODE2jxjaULWSEmmUl0be1ihLDlJZq3zmaewCg0C8kd
        s5AsnIWkZRaSlgWMLKsYRVJLi3PTc4sN9YoTc4tL89L1kvNzNzECI3/bsZ+bdzDOe/VR7xAj
        EwfjIUYJDmYlEd55MvnJQrwpiZVVqUX58UWlOanFhxhNgYExkVlKNDkfmHrySuINzQxMDU3M
        LA1MLc2MlcR5PQs6EoUE0hNLUrNTUwtSi2D6mDg4pRqYYi+dXblJyi09uyFtTn5uEItr5R23
        jLnF+eyJ/7Kny1w/95lP+kDW117Opp3P111I5rvpn7XW037iT0urnw45n1ctM989eepu5hm8
        N/mkqi1PMlbKvlvYKcYmIsBzbVWV1NmoaasCVvjO4XedFCbi93RNjlJJHk/At3c3k33e7Hu3
        LP3gLW7TG475vAtq7Yx2nem5zPxE6PGvRuk7c07lXjsreFG8PL3vOY/OsV89JhnyyQfaexQV
        /S7IOKsmsZ/zE72izal/8Pmn3i4tq7f7w1uXMGmWr7ylto7b89i1WzK3Xpqs/+jQ4Wj2t07A
        4sy/PVVlAkt2yZw4ULKH1T7uetbLSTfuGX4T3uX1pyRCiaU4I9FQi7moOBEAdwTikYUDAAA=
X-CMS-MailID: 20221114142915eucas1p258f3ca2c536bde712c068e96851468fd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20221114142915eucas1p258f3ca2c536bde712c068e96851468fd
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20221114142915eucas1p258f3ca2c536bde712c068e96851468fd
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
        <20221107215644.1895162-9-oliver.upton@linux.dev>
        <CGME20221114142915eucas1p258f3ca2c536bde712c068e96851468fd@eucas1p2.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On 07.11.2022 22:56, Oliver Upton wrote:
> Use RCU to safely walk the stage-2 page tables in parallel. Acquire and
> release the RCU read lock when traversing the page tables. Defer the
> freeing of table memory to an RCU callback. Indirect the calls into RCU
> and provide stubs for hypervisor code, as RCU is not available in such a
> context.
>
> The RCU protection doesn't amount to much at the moment, as readers are
> already protected by the read-write lock (all walkers that free table
> memory take the write lock). Nonetheless, a subsequent change will
> futher relax the locking requirements around the stage-2 MMU, thereby
> depending on RCU.
>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

This patch landed in today's linux-next (20221114) as commit 
c3119ae45dfb ("KVM: arm64: Protect stage-2 traversal with RCU"). 
Unfortunately it introduces a following warning:

--->8---

kvm [1]: IPA Size Limit: 40 bits
BUG: sleeping function called from invalid context at 
include/linux/sched/mm.h:274
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
2 locks held by swapper/0/1:
  #0: ffff80000a8a44d0 (kvm_hyp_pgd_mutex){+.+.}-{3:3}, at: 
__create_hyp_mappings+0x80/0xc4
  #1: ffff80000a927720 (rcu_read_lock){....}-{1:2}, at: 
kvm_pgtable_walk+0x0/0x1f4
CPU: 2 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc3+ #5918
Hardware name: Raspberry Pi 3 Model B (DT)
Call trace:
  dump_backtrace.part.0+0xe4/0xf0
  show_stack+0x18/0x40
  dump_stack_lvl+0x8c/0xb8
  dump_stack+0x18/0x34
  __might_resched+0x178/0x220
  __might_sleep+0x48/0xa0
  prepare_alloc_pages+0x178/0x1a0
  __alloc_pages+0x9c/0x109c
  alloc_page_interleave+0x1c/0xc4
  alloc_pages+0xec/0x160
  get_zeroed_page+0x1c/0x44
  kvm_hyp_zalloc_page+0x14/0x20
  hyp_map_walker+0xd4/0x134
  kvm_pgtable_visitor_cb.isra.0+0x38/0x5c
  __kvm_pgtable_walk+0x1a4/0x220
  kvm_pgtable_walk+0x104/0x1f4
  kvm_pgtable_hyp_map+0x80/0xc4
  __create_hyp_mappings+0x9c/0xc4
  kvm_mmu_init+0x144/0x1cc
  kvm_arch_init+0xe4/0xef4
  kvm_init+0x3c/0x3d0
  arm_init+0x20/0x30
  do_one_initcall+0x74/0x400
  kernel_init_freeable+0x2e0/0x350
  kernel_init+0x24/0x130
  ret_from_fork+0x10/0x20
kvm [1]: Hyp mode initialized successfully

--->8----

I looks that more changes in the KVM code are needed to use RCU for that 
code.

> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 49 ++++++++++++++++++++++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 10 +++++-
>   arch/arm64/kvm/mmu.c                 | 14 +++++++-
>   3 files changed, 71 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index e70cf57b719e..7634b6964779 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -37,6 +37,13 @@ static inline u64 kvm_get_parange(u64 mmfr0)
>   
>   typedef u64 kvm_pte_t;
>   
> +/*
> + * RCU cannot be used in a non-kernel context such as the hyp. As such, page
> + * table walkers used in hyp do not call into RCU and instead use other
> + * synchronization mechanisms (such as a spinlock).
> + */
> +#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
> +
>   typedef kvm_pte_t *kvm_pteref_t;
>   
>   static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
> @@ -44,6 +51,40 @@ static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared
>   	return pteref;
>   }
>   
> +static inline void kvm_pgtable_walk_begin(void) {}
> +static inline void kvm_pgtable_walk_end(void) {}
> +
> +static inline bool kvm_pgtable_walk_lock_held(void)
> +{
> +	return true;
> +}
> +
> +#else
> +
> +typedef kvm_pte_t __rcu *kvm_pteref_t;
> +
> +static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
> +{
> +	return rcu_dereference_check(pteref, !shared);
> +}
> +
> +static inline void kvm_pgtable_walk_begin(void)
> +{
> +	rcu_read_lock();
> +}
> +
> +static inline void kvm_pgtable_walk_end(void)
> +{
> +	rcu_read_unlock();
> +}
> +
> +static inline bool kvm_pgtable_walk_lock_held(void)
> +{
> +	return rcu_read_lock_held();
> +}
> +
> +#endif
> +
>   #define KVM_PTE_VALID			BIT(0)
>   
>   #define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
> @@ -202,11 +243,14 @@ struct kvm_pgtable {
>    *					children.
>    * @KVM_PGTABLE_WALK_TABLE_POST:	Visit table entries after their
>    *					children.
> + * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
> + *					with other software walkers.
>    */
>   enum kvm_pgtable_walk_flags {
>   	KVM_PGTABLE_WALK_LEAF			= BIT(0),
>   	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
>   	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
> +	KVM_PGTABLE_WALK_SHARED			= BIT(3),
>   };
>   
>   struct kvm_pgtable_visit_ctx {
> @@ -223,6 +267,11 @@ struct kvm_pgtable_visit_ctx {
>   typedef int (*kvm_pgtable_visitor_fn_t)(const struct kvm_pgtable_visit_ctx *ctx,
>   					enum kvm_pgtable_walk_flags visit);
>   
> +static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *ctx)
> +{
> +	return ctx->flags & KVM_PGTABLE_WALK_SHARED;
> +}
> +
>   /**
>    * struct kvm_pgtable_walker - Hook into a page-table walk.
>    * @cb:		Callback function to invoke during the walk.
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 7c9782347570..d8d963521d4e 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -171,6 +171,9 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
>   				  enum kvm_pgtable_walk_flags visit)
>   {
>   	struct kvm_pgtable_walker *walker = data->walker;
> +
> +	/* Ensure the appropriate lock is held (e.g. RCU lock for stage-2 MMU) */
> +	WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx) && !kvm_pgtable_walk_lock_held());
>   	return walker->cb(ctx, visit);
>   }
>   
> @@ -281,8 +284,13 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>   		.end	= PAGE_ALIGN(walk_data.addr + size),
>   		.walker	= walker,
>   	};
> +	int r;
> +
> +	kvm_pgtable_walk_begin();
> +	r = _kvm_pgtable_walk(pgt, &walk_data);
> +	kvm_pgtable_walk_end();
>   
> -	return _kvm_pgtable_walk(pgt, &walk_data);
> +	return r;
>   }
>   
>   struct leaf_walk_data {
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 73ae908eb5d9..52e042399ba5 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -130,9 +130,21 @@ static void kvm_s2_free_pages_exact(void *virt, size_t size)
>   
>   static struct kvm_pgtable_mm_ops kvm_s2_mm_ops;
>   
> +static void stage2_free_removed_table_rcu_cb(struct rcu_head *head)
> +{
> +	struct page *page = container_of(head, struct page, rcu_head);
> +	void *pgtable = page_to_virt(page);
> +	u32 level = page_private(page);
> +
> +	kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, pgtable, level);
> +}
> +
>   static void stage2_free_removed_table(void *addr, u32 level)
>   {
> -	kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, addr, level);
> +	struct page *page = virt_to_page(addr);
> +
> +	set_page_private(page, (unsigned long)level);
> +	call_rcu(&page->rcu_head, stage2_free_removed_table_rcu_cb);
>   }
>   
>   static void kvm_host_get_page(void *addr)

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

