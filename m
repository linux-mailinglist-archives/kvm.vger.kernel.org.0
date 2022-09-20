Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5295BE0FA
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 10:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiITI7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 04:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbiITI7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 04:59:02 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5386C779
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 01:58:18 -0700 (PDT)
Date:   Tue, 20 Sep 2022 10:58:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663664296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FMTI7Vym7tvrr+o//WSBAOlcOiuOVV2FS/Ur/sM72JM=;
        b=iA1DkgSiXxTM/TN3GGsM4c/ByzvyeCMycBcn4h6DlEXtoZ8QhHyr+5nhfLFptP0NS7NIzj
        2d3V8gdlsH4qYCh1R4amY02+FgLJLftf5naX3+GGGEtzDji+mB47rGjbGUc5QmT7l6S5YB
        66v4dHtnIeyBk2NipmZ9NzwTVFIGSvM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 07/19] arm/arm64: Mark the phys_end
 parameter as unused in setup_mmu()
Message-ID: <20220920085815.qk6js67qjvken2kt@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-8-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-8-alexandru.elisei@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 09, 2022 at 10:15:46AM +0100, Alexandru Elisei wrote:
> phys_end was used to cap the linearly mapped memory to 3G to allow 1G of
> room for the vmalloc area to grown down. This was made useless in commit
> c1cd1a2bed69 ("arm/arm64: mmu: Remove memory layout assumptions"), when
> setup_mmu() was changed to map all the detected memory regions without
> changing their limits.

c1cd1a2bed69 was a start, but as that commit says, the 3G-4G region was
still necessary due to assumptions in the virtual memory allocator. This
patch needs to point out a vmalloc commit which removes that assumption
as well for its justification.

Thanks,
drew

> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/mmu.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index e1a72fe4941f..8f936acafe8b 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -153,14 +153,10 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>  	}
>  }
>  
> -void *setup_mmu(phys_addr_t phys_end, void *unused)
> +void *setup_mmu(phys_addr_t unused0, void *unused1)
>  {
>  	struct mem_region *r;
>  
> -	/* 3G-4G region is reserved for vmalloc, cap phys_end at 3G */
> -	if (phys_end > (3ul << 30))
> -		phys_end = 3ul << 30;
> -
>  #ifdef __aarch64__
>  	init_alloc_vpage((void*)(4ul << 30));
>  
> -- 
> 2.37.1
> 
