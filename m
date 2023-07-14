Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDD37538EF
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 12:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235405AbjGNKzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 06:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236244AbjGNKzZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 06:55:25 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F008135AA
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 03:55:22 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C91B51570;
        Fri, 14 Jul 2023 03:56:04 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70BB83F67D;
        Fri, 14 Jul 2023 03:55:21 -0700 (PDT)
Date:   Fri, 14 Jul 2023 11:55:10 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Nadav Amit <namit@vmware.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] arm64: ensure tlbi is safe
Message-ID: <ZLEoL8NbvmRNysJF@monolith.localdoman>
References: <20230617013138.1823-1-namit@vmware.com>
 <20230617013138.1823-3-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230617013138.1823-3-namit@vmware.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Sat, Jun 17, 2023 at 01:31:38AM +0000, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> While no real problem was encountered, having an inline assembly without
> volatile keyword and output can allow the compiler to ignore it. And
> without a memory clobber, potentially reorder it.
> 
> Add volatile and memory clobber.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  lib/arm64/asm/mmu.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
> index 5c27edb..cf94403 100644
> --- a/lib/arm64/asm/mmu.h
> +++ b/lib/arm64/asm/mmu.h
> @@ -14,7 +14,7 @@
>  static inline void flush_tlb_all(void)
>  {
>  	dsb(ishst);
> -	asm("tlbi	vmalle1is");

From the gas manual [1]:

"asm statements that have no output operands and asm goto statements, are
implicitly volatile."

Looks to me like both TLBIs fall into this category.

And I think the "memory" clobber is not needed because the dsb macro before and
after the TLBI already have it.

[1] https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html#Volatile

Thanks,
Alex

> +	asm volatile("tlbi	vmalle1is" ::: "memory");
>  	dsb(ish);
>  	isb();
>  }
> @@ -23,7 +23,7 @@ static inline void flush_tlb_page(unsigned long vaddr)
>  {
>  	unsigned long page = vaddr >> 12;
>  	dsb(ishst);
> -	asm("tlbi	vaae1is, %0" :: "r" (page));
> +	asm volatile("tlbi	vaae1is, %0" :: "r" (page) : "memory");
>  	dsb(ish);
>  	isb();
>  }
> -- 
> 2.34.1
> 
> 
