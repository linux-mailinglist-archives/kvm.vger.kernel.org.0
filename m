Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2C95BE288
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 11:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiITJ6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 05:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiITJ6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 05:58:12 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB6966104
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 02:58:11 -0700 (PDT)
Date:   Tue, 20 Sep 2022 11:58:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663667890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RmS0I1Pb7j64z1blqOBHHrMkL9AmD0loyLLUt+93dA8=;
        b=imihoh1CmDd9PkJJDeULBdto46X38rhWBTw8XTT0HLWUPXYMBQCFjDVSyz+isgCE0ybwi/
        dy1WBjEqG7om/BskvFAgpFA/zQNUmBt3DThPp323EQNFrM+OL/pkJyMsYZuK33gl+N3+Dc
        0wsH4zi0wfLr10B/d0EMoJTQeWdfxuQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 16/19] arm/arm64: Allocate
 secondaries' stack using the page allocator
Message-ID: <20220920095802.bukms5w2phaxyaao@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-17-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809091558.14379-17-alexandru.elisei@arm.com>
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

On Tue, Aug 09, 2022 at 10:15:55AM +0100, Alexandru Elisei wrote:
> The vmalloc allocator returns non-id mapped addresses, where the virtual
> address is different than the physical address. This makes it impossible
> to access the stack of the secondary CPUs while the MMU is disabled.
> 
> On arm, THREAD_SIZE is 16K and PAGE_SIZE is 4K, which makes THREAD_SIZE
> a power of two multiple of PAGE_SIZE. On arm64, THREAD_SIZE is 16 when
> PAGE_SIZE is 4K or 16K, and 64K when PAGE_SIZE is 64K. In all cases,
> THREAD_SIZE is a power of two multiple of PAGE_SIZE. As a result, using
> memalign_pages() for the stack won't lead to wasted memory.
> 
> memalign_pages() allocates memory in chunks of power of two number of
> pages, aligned to the allocation size, which makes it a drop-in
> replacement for vm_memalign (which is the value for alloc_ops->memalign
> when the stack is allocated).
> 
> Using memalign_pages() has two distinct benefits:
> 
> 1. The secondary CPUs' stack can be used with the MMU off.
> 
> 2. The secondary CPUs' stack is identify mapped similar to the stack for
> the primary CPU, which makes the configuration of the CPUs consistent.
> 
> memalign_pages_flags() has been used instead of memalign_pages() to
> instruct the allocator not to zero the stack, as it's already zeroed in the
> entry code.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/asm/thread_info.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/arm/asm/thread_info.h b/lib/arm/asm/thread_info.h
> index eaa72582af86..190e082cbba0 100644
> --- a/lib/arm/asm/thread_info.h
> +++ b/lib/arm/asm/thread_info.h
> @@ -25,6 +25,7 @@
>  #ifndef __ASSEMBLY__
>  #include <asm/processor.h>
>  #include <alloc.h>
> +#include <alloc_page.h>
>  
>  #ifdef __arm__
>  #include <asm/ptrace.h>
> @@ -40,7 +41,7 @@
>  
>  static inline void *thread_stack_alloc(void)
>  {
> -	void *sp = memalign(THREAD_ALIGNMENT, THREAD_SIZE);
> +	void *sp = memalign_pages_flags(THREAD_ALIGNMENT, THREAD_SIZE, FLAG_DONTZERO);
>  	return sp + THREAD_START_SP;
>  }
>  
> -- 
> 2.37.1
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
