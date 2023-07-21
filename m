Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B86575D159
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 20:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjGUSZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 14:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbjGUSZf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 14:25:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B38E359C;
        Fri, 21 Jul 2023 11:25:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 675A961D7D;
        Fri, 21 Jul 2023 18:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C769C433C9;
        Fri, 21 Jul 2023 18:25:27 +0000 (UTC)
Date:   Fri, 21 Jul 2023 19:25:26 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     akpm@linux-foundation.org, ajd@linux.ibm.com,
        fbarrat@linux.ibm.com, iommu@lists.linux.dev, jgg@ziepe.ca,
        jhubbard@nvidia.com, kevin.tian@intel.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, nicolinc@nvidia.com, npiggin@gmail.com,
        robin.murphy@arm.com, seanjc@google.com, will@kernel.org,
        x86@kernel.org, zhi.wang.linux@gmail.com, sj@kernel.org
Subject: Re: [PATCH v3 3/5] mmu_notifiers: Call invalidate_range() when
 invalidating TLBs
Message-ID: <ZLrNlgLZvtubFTiy@arm.com>
References: <cover.b24362332ec6099bc8db4e8e06a67545c653291d.1689842332.git-series.apopple@nvidia.com>
 <86a0bf86394f1765fcbf9890bbabb154ba8dd980.1689842332.git-series.apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86a0bf86394f1765fcbf9890bbabb154ba8dd980.1689842332.git-series.apopple@nvidia.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023 at 06:39:25PM +1000, Alistair Popple wrote:
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index 3456866..a99349d 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -13,6 +13,7 @@
>  #include <linux/bitfield.h>
>  #include <linux/mm_types.h>
>  #include <linux/sched.h>
> +#include <linux/mmu_notifier.h>
>  #include <asm/cputype.h>
>  #include <asm/mmu.h>
>  
> @@ -252,6 +253,7 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
>  	__tlbi(aside1is, asid);
>  	__tlbi_user(aside1is, asid);
>  	dsb(ish);
> +	mmu_notifier_invalidate_range(mm, 0, -1UL);
>  }
>  
>  static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
> @@ -263,6 +265,8 @@ static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
>  	addr = __TLBI_VADDR(uaddr, ASID(mm));
>  	__tlbi(vale1is, addr);
>  	__tlbi_user(vale1is, addr);
> +	mmu_notifier_invalidate_range(mm, uaddr & PAGE_MASK,
> +						(uaddr & PAGE_MASK) + PAGE_SIZE);

Nitpick: we have PAGE_ALIGN() for this.

For arm64:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
