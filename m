Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A97C6CF8A4
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 03:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjC3BTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 21:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjC3BTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 21:19:16 -0400
Received: from out-34.mta1.migadu.com (out-34.mta1.migadu.com [95.215.58.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D9C3C11
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 18:19:14 -0700 (PDT)
Date:   Thu, 30 Mar 2023 01:19:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680139152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ieJMdM29DRBiOqszQV7TS65QczUNcFjEDp7KMm1vo3M=;
        b=K99/mO6ZmX+9Z0SOnOzW1yNj0BHgL3UOGUt5LDv4XF9H4nY2Cg0HyI0qsjQUQNx7YLeIe0
        uom4b/i4ad0aQ5i458f25KJCmhDQSZwecGkcQn5VkL+En/wHNQ+m4NVLwnEMwFh8yvPosG
        I4QEkthBz0FE0FQ9g1HCfE7t7CgQvbk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/7] KVM: arm64: Add FEAT_TLBIRANGE support
Message-ID: <ZCTjirkCgBkT65eP@linux.dev>
References: <20230206172340.2639971-1-rananta@google.com>
 <20230206172340.2639971-3-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206172340.2639971-3-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023 at 05:23:35PM +0000, Raghavendra Rao Ananta wrote:
> Define a generic function __kvm_tlb_flush_range() to
> invalidate the TLBs over a range of addresses. The
> implementation accepts 'op' as a generic TLBI operation.
> Upcoming patches will use this to implement IPA based
> TLB invalidations (ipas2e1is).
> 
> If the system doesn't support FEAT_TLBIRANGE, the
> implementation falls back to flushing the pages one by one
> for the range supplied.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 43c3bc0f9544d..995ff048e8851 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -221,6 +221,24 @@ DECLARE_KVM_NVHE_SYM(__per_cpu_end);
>  DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs);
>  #define __bp_harden_hyp_vecs	CHOOSE_HYP_SYM(__bp_harden_hyp_vecs)
>  
> +#define __kvm_tlb_flush_range(op, mmu, start, end, level, tlb_level) do {	\
> +	unsigned long pages, stride;						\
> +										\
> +	stride = kvm_granule_size(level);					\

Hmm... There's a rather subtle and annoying complication here that I
don't believe is handled.

Similar to what I said in the last spin of the series, there is no
guarantee that a range of IPAs is mapped at the exact same level
throughout. Dirty logging and memslots that aren't hugepage aligned
could lead to a mix of mapping levels being used within a range of the
IPA space.

> +	start = round_down(start, stride);					\
> +	end = round_up(end, stride);						\
> +	pages = (end - start) >> PAGE_SHIFT;					\
> +										\
> +	if ((!system_supports_tlb_range() &&					\
> +	     (end - start) >= (MAX_TLBI_OPS * stride)) ||			\

Doesn't checking for TLBIRANGE above eliminate the need to test against
MAX_TLBI_OPS?

> +	    pages >= MAX_TLBI_RANGE_PAGES) {					\
> +		__kvm_tlb_flush_vmid(mmu);					\
> +		break;								\
> +	}									\
> +										\
> +	__flush_tlb_range_op(op, start, pages, stride, 0, tlb_level, false);	\
> +} while (0)
> +
>  extern void __kvm_flush_vm_context(void);
>  extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
>  extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
> -- 
> 2.39.1.519.gcb327c4b5f-goog
> 
> 

-- 
Thanks,
Oliver
