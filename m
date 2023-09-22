Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363087AAF71
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 12:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbjIVKZo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 06:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbjIVKZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 06:25:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE3794
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 03:25:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A588C433C8;
        Fri, 22 Sep 2023 10:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695378337;
        bh=Wc3oGik2b3xC60zZ2thLAcrs3gO0rhT5suSF1Jz39N8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E9doIbNLN7pl6noXB9KJPXotrmbmEhfBvBfpv+hiH8U0Xe1IVHmm1s8QkpYLd+5A4
         YQay4xzPJ18XCibiYMMuTWgF1EzBRU+k8s9CJhlLc2O3By9L0f8z9oQO8E1rlMy2TO
         WuiAnw8tmGS7quhhzfNJDCbNhndvCMUzxYB5390OlKcTmWrvH5DUCZDWwuY1rBQJ6l
         8/pJw1ty32NOPYYdMD2n1T6/YI8dhXeg36lpMIl+1dfASaa2KhU8QALWc/a9Ce63am
         3Llrp9HzVo3v2TB5G0FH02quiThBee8Q/g4w8Ou1AUxa20f7HhFmDuNKs5fLDIZ1LG
         pWas8X7y9Q2fQ==
Date:   Fri, 22 Sep 2023 11:25:31 +0100
From:   Will Deacon <will@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 1/2] arm64: tlbflush: Rename MAX_TLBI_OPS
Message-ID: <20230922102531.GA22838@willie-the-truck>
References: <20230920080133.944717-1-oliver.upton@linux.dev>
 <20230920080133.944717-2-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920080133.944717-2-oliver.upton@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 20, 2023 at 08:01:32AM +0000, Oliver Upton wrote:
> Perhaps unsurprisingly, I-cache invalidations suffer from performance
> issues similar to TLB invalidations on certain systems. TLB and I-cache
> maintenance all result in DVM on the mesh, which is where the real
> bottleneck lies.
> 
> Rename the heuristic to point the finger at DVM, such that it may be
> reused for limiting I-cache invalidations.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/tlbflush.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index b149cf9f91bc..3431d37e5054 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -333,7 +333,7 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
>   * This is meant to avoid soft lock-ups on large TLB flushing ranges and not
>   * necessarily a performance improvement.
>   */
> -#define MAX_TLBI_OPS	PTRS_PER_PTE
> +#define MAX_DVM_OPS	PTRS_PER_PTE
>  
>  /*
>   * __flush_tlb_range_op - Perform TLBI operation upon a range
> @@ -413,12 +413,12 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
>  
>  	/*
>  	 * When not uses TLB range ops, we can handle up to
> -	 * (MAX_TLBI_OPS - 1) pages;
> +	 * (MAX_DVM_OPS - 1) pages;
>  	 * When uses TLB range ops, we can handle up to
>  	 * (MAX_TLBI_RANGE_PAGES - 1) pages.
>  	 */
>  	if ((!system_supports_tlb_range() &&
> -	     (end - start) >= (MAX_TLBI_OPS * stride)) ||
> +	     (end - start) >= (MAX_DVM_OPS * stride)) ||
>  	    pages >= MAX_TLBI_RANGE_PAGES) {
>  		flush_tlb_mm(vma->vm_mm);
>  		return;
> @@ -451,7 +451,7 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
>  {
>  	unsigned long addr;
>  
> -	if ((end - start) > (MAX_TLBI_OPS * PAGE_SIZE)) {
> +	if ((end - start) > (MAX_DVM_OPS * PAGE_SIZE)) {
>  		flush_tlb_all();
>  		return;
>  	}
> -- 
> 2.42.0.459.ge4e396fd5e-goog

Acked-by: Will Deacon <will@kernel.org>

Will
