Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A687370C1FD
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 17:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbjEVPKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 11:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbjEVPJy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 11:09:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43EFB9;
        Mon, 22 May 2023 08:09:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F5D161C36;
        Mon, 22 May 2023 15:09:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C414C433D2;
        Mon, 22 May 2023 15:09:50 +0000 (UTC)
Date:   Mon, 22 May 2023 16:09:47 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        will@kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, jgg@nvidia.com,
        John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH] mmu_notifiers: Notify on pte permission upgrades
Message-ID: <ZGuFu0VwRfZszABB@arm.com>
References: <20230522063725.284686-1-apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522063725.284686-1-apopple@nvidia.com>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023 at 04:37:25PM +1000, Alistair Popple wrote:
> diff --git a/mm/memory.c b/mm/memory.c
> index f526b9152bef..0ac78c6a232c 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2098,6 +2098,7 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  	struct mm_struct *mm = vma->vm_mm;
>  	pte_t *pte, entry;
>  	spinlock_t *ptl;
> +	bool changed = false;
>  
>  	pte = get_locked_pte(mm, addr, &ptl);
>  	if (!pte)
> @@ -2120,8 +2121,10 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  			}
>  			entry = pte_mkyoung(*pte);
>  			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
> -			if (ptep_set_access_flags(vma, addr, pte, entry, 1))
> +			if (ptep_set_access_flags(vma, addr, pte, entry, 1)) {
>  				update_mmu_cache(vma, addr, pte);
> +				changed = true;
> +			}
>  		}
>  		goto out_unlock;
>  	}

I haven't checked all the corner cases but can we not have a
ptep_set_access_flags_notify() that handles this (and the huge
equivalent)? It matches the other API like ptep_clear_flush_notify().

-- 
Catalin
