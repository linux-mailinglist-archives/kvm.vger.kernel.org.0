Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72573610CEE
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 11:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiJ1JTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 05:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiJ1JTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 05:19:30 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19992C4
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 02:19:27 -0700 (PDT)
Date:   Fri, 28 Oct 2022 09:19:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666948765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1neScYfEnwSJ+NX5bJKyCKTwiZXUeEpGO+gHaDwAPPk=;
        b=sDxLyh93SB9mcl5De1HP2Yk7RB6c4UYvrsf9ar0vcv4D9NFlPce7E2c8C0Pq1i88TJMWAb
        VoJ3p+UmF98/Hw19Lvnxu0TZHvr5IbooniT3GN3MJVbZqPzF9p0TXucQMVY7o1LHTLewWO
        hc1CT6/5k7yPcxG+xZ/JjPpYYE2iZEE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 08/15] KVM: arm64: Protect stage-2 traversal with RCU
Message-ID: <Y1uek8RygHO+cXCF@google.com>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
 <20221027221752.1683510-9-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027221752.1683510-9-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022 at 10:17:45PM +0000, Oliver Upton wrote:
> The use of RCU is necessary to safely change the stage-2 page tables in
> parallel. Acquire and release the RCU read lock when traversing the page
> tables.
> 
> Use the _raw() flavor of rcu_dereference when changes to the page tables
> are otherwise protected from parallel software walkers (e.g. holding the
> write lock).
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 41 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/pgtable.c         | 10 ++++++-
>  2 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index e70cf57b719e..d1859e8550df 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -37,6 +37,13 @@ static inline u64 kvm_get_parange(u64 mmfr0)
>  
>  typedef u64 kvm_pte_t;
>  
> +/*
> + * RCU cannot be used in a non-kernel context such as the hyp. As such, page
> + * table walkers used in hyp do not call into RCU and instead use other
> + * synchronization mechanisms (such as a spinlock).
> + */
> +#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
> +
>  typedef kvm_pte_t *kvm_pteref_t;
>  
>  static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
> @@ -44,6 +51,40 @@ static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared
>  	return pteref;
>  }
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
> +	return rcu_dereference_check(pteref, shared);

I accidentally squashed the fix for !shared into 9/15, not this patch.
Fix ready for v4.

--
Thanks,
Oliver
