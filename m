Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44193700D59
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 18:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237438AbjELQuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 12:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjELQuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 12:50:22 -0400
Received: from out-32.mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E476F35B8
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 09:50:20 -0700 (PDT)
Date:   Fri, 12 May 2023 16:50:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683910218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4PTfi/CRVlLihpd7NcDHa6MiGARrs9Gf4ZlSXwZztBQ=;
        b=ckABoCJOeT0cC23Vyy/T4xUiN0xAN6xQgiRXdD6yuo+EBlCRorITYgG/ly/qJ18Yy0GQOM
        GrCipZfeifTYjPmrN3BL6rW5I6uQt7PCrHtPoD0n5q9KQ8oSo1TnUK/8j5sWv7fE8qDgGP
        m6Fn/pjyPHTYKARNHPZP6QgODuzooAc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/7] KVM: arm64: Implement
  __kvm_tlb_flush_vmid_range()
Message-ID: <ZF5uRWtvhhqZSQCa@linux.dev>
References: <20230414172922.812640-1-rananta@google.com>
 <20230414172922.812640-3-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414172922.812640-3-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

On Fri, Apr 14, 2023 at 05:29:17PM +0000, Raghavendra Rao Ananta wrote:
> Define  __kvm_tlb_flush_vmid_range() (for VHE and nVHE)
> to flush a range of stage-2 page-tables using IPA in one go.
> If the system supports FEAT_TLBIRANGE, the following patches
> would conviniently replace global TLBI such as vmalls12e1is
> in the map, unmap, and dirty-logging paths with ripas2e1is
> instead.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h   |  3 +++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 11 +++++++++
>  arch/arm64/kvm/hyp/nvhe/tlb.c      | 39 ++++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/vhe/tlb.c       | 35 +++++++++++++++++++++++++++
>  4 files changed, 88 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 43c3bc0f9544d..33352d9399e32 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -79,6 +79,7 @@ enum __kvm_host_smccc_func {
>  	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
> +	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_range,
>  };
>  
>  #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
> @@ -225,6 +226,8 @@ extern void __kvm_flush_vm_context(void);
>  extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
>  extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
>  				     int level);
> +extern void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> +					phys_addr_t start, phys_addr_t end);
>  extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
>  
>  extern void __kvm_timer_set_cntvoff(u64 cntvoff);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 728e01d4536b0..81d30737dc7c9 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -125,6 +125,16 @@ static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
>  	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
>  }
>  
> +static void
> +handle___kvm_tlb_flush_vmid_range(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> +	DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
> +	DECLARE_REG(phys_addr_t, end, host_ctxt, 3);
> +
> +	__kvm_tlb_flush_vmid_range(kern_hyp_va(mmu), start, end);
> +}
> +
>  static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
>  {
>  	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> @@ -315,6 +325,7 @@ static const hcall_t host_hcall[] = {
>  	HANDLE_FUNC(__kvm_vcpu_run),
>  	HANDLE_FUNC(__kvm_flush_vm_context),
>  	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
> +	HANDLE_FUNC(__kvm_tlb_flush_vmid_range),
>  	HANDLE_FUNC(__kvm_tlb_flush_vmid),
>  	HANDLE_FUNC(__kvm_flush_cpu_context),
>  	HANDLE_FUNC(__kvm_timer_set_cntvoff),
> diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
> index d296d617f5896..d2504df9d38b6 100644
> --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> @@ -109,6 +109,45 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
>  	__tlb_switch_to_host(&cxt);
>  }
>  
> +void __kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> +				phys_addr_t start, phys_addr_t end)
> +{
> +	struct tlb_inv_context cxt;
> +	unsigned long pages, stride;
> +
> +	/*
> +	 * Since the range of addresses may not be mapped at
> +	 * the same level, assume the worst case as PAGE_SIZE
> +	 */
> +	stride = PAGE_SIZE;
> +	start = round_down(start, stride);
> +	end = round_up(end, stride);
> +	pages = (end - start) >> PAGE_SHIFT;
> +
> +	if (!system_supports_tlb_range() || pages >= MAX_TLBI_RANGE_PAGES) {
> +		__kvm_tlb_flush_vmid(mmu);
> +		return;
> +	}
> +
> +	dsb(ishst);

Due to some concerns w.r.t. the imprecision of the architecture for
synchronizing with the table walkers, these preamble barriers were
upgraded to dsb(ish) in commit 7e1b2329c205 ("KVM: arm64: nvhe:
Synchronise with page table walker on TLBI"). Good news is, the magic is
behind __tlb_switch_to_guest(), so just drop these barriers when you
rebase the series onto a 6.4 rc.

-- 
Thanks,
Oliver
