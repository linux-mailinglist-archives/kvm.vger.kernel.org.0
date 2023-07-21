Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660CB75D15B
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 20:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbjGUSZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 14:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjGUSZp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 14:25:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413E935A1;
        Fri, 21 Jul 2023 11:25:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6F5961D90;
        Fri, 21 Jul 2023 18:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502ECC433CA;
        Fri, 21 Jul 2023 18:25:39 +0000 (UTC)
Date:   Fri, 21 Jul 2023 19:25:38 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     akpm@linux-foundation.org, ajd@linux.ibm.com,
        fbarrat@linux.ibm.com, iommu@lists.linux.dev, jgg@ziepe.ca,
        jhubbard@nvidia.com, kevin.tian@intel.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, nicolinc@nvidia.com, npiggin@gmail.com,
        robin.murphy@arm.com, seanjc@google.com, will@kernel.org,
        x86@kernel.org, zhi.wang.linux@gmail.com, sj@kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v3 5/5] mmu_notifiers: Rename invalidate_range notifier
Message-ID: <ZLrNotPTZSnmtz7b@arm.com>
References: <cover.b24362332ec6099bc8db4e8e06a67545c653291d.1689842332.git-series.apopple@nvidia.com>
 <3cbd2a644d56d503b47cfc35868d547f924f880e.1689842332.git-series.apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cbd2a644d56d503b47cfc35868d547f924f880e.1689842332.git-series.apopple@nvidia.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023 at 06:39:27PM +1000, Alistair Popple wrote:
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index a99349d..84a05a0 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -253,7 +253,7 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
>  	__tlbi(aside1is, asid);
>  	__tlbi_user(aside1is, asid);
>  	dsb(ish);
> -	mmu_notifier_invalidate_range(mm, 0, -1UL);
> +	mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
>  }
>  
>  static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
> @@ -265,7 +265,7 @@ static inline void __flush_tlb_page_nosync(struct mm_struct *mm,
>  	addr = __TLBI_VADDR(uaddr, ASID(mm));
>  	__tlbi(vale1is, addr);
>  	__tlbi_user(vale1is, addr);
> -	mmu_notifier_invalidate_range(mm, uaddr & PAGE_MASK,
> +	mmu_notifier_arch_invalidate_secondary_tlbs(mm, uaddr & PAGE_MASK,
>  						(uaddr & PAGE_MASK) + PAGE_SIZE);
>  }
>  
> @@ -400,7 +400,7 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
>  		scale++;
>  	}
>  	dsb(ish);
> -	mmu_notifier_invalidate_range(vma->vm_mm, start, end);
> +	mmu_notifier_arch_invalidate_secondary_tlbs(vma->vm_mm, start, end);
>  }

For arm64:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
