Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231BC6CF86B
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 02:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjC3A72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 20:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjC3A71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 20:59:27 -0400
Received: from out-20.mta0.migadu.com (out-20.mta0.migadu.com [IPv6:2001:41d0:1004:224b::14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BFA4ED5
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 17:59:25 -0700 (PDT)
Date:   Thu, 30 Mar 2023 00:59:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680137963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uD+IOimJMh4cbgBXvoWINW8nXWmtJftvBab7aOw95tI=;
        b=ez9OovHtElrk9mpTqRlKDSUBByry79ZcLt2ztwAqwvMnSaA0r1G7D8uK3tAJubXhbtFmca
        DF1+JuqSKmSIMa0ZLnT2zvarL5YVKf05DY1ZptP2AdRohW3XQF9qMRa6pVvNcKxjUiqapn
        vwTSr3LAu91vqLeboljZg4JoT2bxpCw=
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
Subject: Re: [PATCH v2 3/7] KVM: arm64: Implement
  __kvm_tlb_flush_range_vmid_ipa()
Message-ID: <ZCTe5koj8fOgbrYO@linux.dev>
References: <20230206172340.2639971-1-rananta@google.com>
 <20230206172340.2639971-4-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206172340.2639971-4-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023 at 05:23:36PM +0000, Raghavendra Rao Ananta wrote:
> Define  __kvm_tlb_flush_range_vmid_ipa() (for VHE and nVHE)

bikeshed: Personally, I find that range implies it takes an address as an
argument already. Maybe just call it __kvm_tlb_flush_vmid_range()

> to flush a range of stage-2 page-tables using IPA in one go.
> If the system supports FEAT_TLBIRANGE, the following patches
> would conviniently replace global TLBI such as vmalls12e1is
> in the map, unmap, and dirty-logging paths with ripas2e1is
> instead.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h   |  3 +++
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 12 ++++++++++++
>  arch/arm64/kvm/hyp/nvhe/tlb.c      | 28 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/vhe/tlb.c       | 24 ++++++++++++++++++++++++
>  4 files changed, 67 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 995ff048e8851..80a8ea85e84f8 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -79,6 +79,7 @@ enum __kvm_host_smccc_func {
>  	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
>  	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
> +	__KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_range_vmid_ipa,
>  };
>  
>  #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
> @@ -243,6 +244,8 @@ extern void __kvm_flush_vm_context(void);
>  extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
>  extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
>  				     int level);
> +extern void __kvm_tlb_flush_range_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t start,
> +						phys_addr_t end, int level, int tlb_level);
>  extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
>  
>  extern void __kvm_timer_set_cntvoff(u64 cntvoff);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 728e01d4536b0..5787eee4c9fe4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -125,6 +125,17 @@ static void handle___kvm_tlb_flush_vmid_ipa(struct kvm_cpu_context *host_ctxt)
>  	__kvm_tlb_flush_vmid_ipa(kern_hyp_va(mmu), ipa, level);
>  }
>  
> +static void handle___kvm_tlb_flush_range_vmid_ipa(struct kvm_cpu_context *host_ctxt)
> +{
> +	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> +	DECLARE_REG(phys_addr_t, start, host_ctxt, 2);
> +	DECLARE_REG(phys_addr_t, end, host_ctxt, 3);
> +	DECLARE_REG(int, level, host_ctxt, 4);
> +	DECLARE_REG(int, tlb_level, host_ctxt, 5);
> +
> +	__kvm_tlb_flush_range_vmid_ipa(kern_hyp_va(mmu), start, end, level, tlb_level);
> +}
> +
>  static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
>  {
>  	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
> @@ -315,6 +326,7 @@ static const hcall_t host_hcall[] = {
>  	HANDLE_FUNC(__kvm_vcpu_run),
>  	HANDLE_FUNC(__kvm_flush_vm_context),
>  	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
> +	HANDLE_FUNC(__kvm_tlb_flush_range_vmid_ipa),
>  	HANDLE_FUNC(__kvm_tlb_flush_vmid),
>  	HANDLE_FUNC(__kvm_flush_cpu_context),
>  	HANDLE_FUNC(__kvm_timer_set_cntvoff),
> diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
> index d296d617f5896..7398dd00445e7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> @@ -109,6 +109,34 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
>  	__tlb_switch_to_host(&cxt);
>  }
>  
> +void __kvm_tlb_flush_range_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t start,
> +					phys_addr_t end, int level, int tlb_level)
> +{
> +	struct tlb_inv_context cxt;
> +
> +	dsb(ishst);
> +
> +	/* Switch to requested VMID */
> +	__tlb_switch_to_guest(mmu, &cxt);
> +
> +	__kvm_tlb_flush_range(ipas2e1is, mmu, start, end, level, tlb_level);
> +
> +	/*
> +	 * Range-based ipas2e1is flushes only Stage-2 entries, and since the
> +	 * VA isn't available for Stage-1 entries, flush the entire stage-1.
> +	 */

nit: if we are going to preserve some of the commentary over in
__kvm_tlb_flush_vmid_ipa(), I would prefer just an exact copy/paste.
But, FWIW, I think you can just elide the clarifying comments altogether
since the relationship between stage-1 and stage-2 invalidations is
already documented.

> +	dsb(ish);
> +	__tlbi(vmalle1is);
> +	dsb(ish);
> +	isb();
> +
> +	/* See the comment below in __kvm_tlb_flush_vmid_ipa() */

Same comment as above.

-- 
Thanks,
Oliver
