Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718A86E0309
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 02:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjDMAJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 20:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDMAJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 20:09:27 -0400
Received: from out-13.mta1.migadu.com (out-13.mta1.migadu.com [95.215.58.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1BCB3
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 17:09:25 -0700 (PDT)
Date:   Thu, 13 Apr 2023 00:09:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681344563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DCn6p3gtYnYICVdSzR+qKJHebtZg5R+GcclGHNZLCB0=;
        b=kFseqNaqw+4Sg3icAGYEj9G5imYSoRleV7IsLojXnNuE/bjsijzCRkKyhfGVoJhuQ3+fHN
        UeSKrJgg1z8b4rOBFUNJk3JgVpT4nu4xOKaVGrSXBL3+WWEd6FIVkft0/EjuCyKUQtmiYj
        xRvv/VLznEKr8SWnYD4wbMYoDXwNAOM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 2/5] KVM: arm64: nvhe: Synchronise with page table
 walker on TLBI
Message-ID: <ZDdIMMv7jhmSqMNi@linux.dev>
References: <20230408160427.10672-1-maz@kernel.org>
 <20230408160427.10672-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230408160427.10672-3-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Sat, Apr 08, 2023 at 05:04:24PM +0100, Marc Zyngier wrote:
> A TLBI from EL2 impacting EL1 involves messing with the EL1&0
> translation regime, and the page table walker may still be
> performing speculative walks.
> 
> Piggyback on the existing DSBs to always have a DSB ISH that
> will synchronise all load/store operations that the PTW may
> still have.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/tlb.c | 24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
> index d296d617f589..e86dd04d49ff 100644
> --- a/arch/arm64/kvm/hyp/nvhe/tlb.c
> +++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
> @@ -17,6 +17,23 @@ struct tlb_inv_context {
>  static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
>  				  struct tlb_inv_context *cxt)
>  {
> +	/*
> +	 * We have two requirements:
> +	 *
> +	 * - ensure that the page table updates are visible to all
> +         *   CPUs, for which a dsb(ishst) is what we need
> +	 *
> +	 * - complete any speculative page table walk started before
> +         *   we trapped to EL2 so that we can mess with the MM
> +         *   registers out of context, for which dsb(nsh) is enough
> +	 *
> +	 * The composition of these two barriers is a dsb(ish). This
> +	 * might be slightly over the top for non-shareable TLBIs, but
> +	 * they are so vanishingly rare that it isn't worth the
> +	 * complexity.
> +	 */
> +	dsb(ish);
> +

Ricardo is carrying a patch for non-shareable TLBIs on permission
relaxation [*], and he's found that it produces some rather desirable
performance improvements. I appreciate the elegance of your approach,
but given what's coming does it make sense to have the TLBI handlers
continue to explicitly perform the appropriate DSB?

[*] https://lore.kernel.org/kvmarm/20230409063000.3559991-14-ricarkol@google.com/

>  	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
>  		u64 val;
>  
> @@ -60,8 +77,6 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
>  {
>  	struct tlb_inv_context cxt;
>  
> -	dsb(ishst);
> -
>  	/* Switch to requested VMID */
>  	__tlb_switch_to_guest(mmu, &cxt);
>  
> @@ -113,8 +128,6 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
>  {
>  	struct tlb_inv_context cxt;
>  
> -	dsb(ishst);
> -
>  	/* Switch to requested VMID */
>  	__tlb_switch_to_guest(mmu, &cxt);
>  
> @@ -142,7 +155,8 @@ void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
>  
>  void __kvm_flush_vm_context(void)
>  {
> -	dsb(ishst);
> +	/* Same remark as in __tblb_switch_to_guest() */

typo: __tlb_switch_to_guest()

> +	dsb(ish);
>  	__tlbi(alle1is);
>  
>  	/*
> -- 
> 2.34.1
> 
> 

-- 
Thanks,
Oliver
