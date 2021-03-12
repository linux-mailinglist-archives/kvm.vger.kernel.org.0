Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1194339091
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 16:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbhCLPAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 10:00:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45766 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231601AbhCLO76 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 09:59:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615561197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rjGcZs7Vy2maRevaHJ9Zv8LK1uzd9Lhozx0sgGCsnz8=;
        b=jHZ36SaI91dtcgPQFFvJN/jO7yknZ7sKqUvkUiaLFxwHP8OrTGpORi6bQbchQHcrEe9EXS
        84Vii5si1T5FK2fRrpqRw+YFt2QFXoAlNCmlu907WAE/mcw7XjYukUQW63SrqN0JlHzGpY
        jhC7JKh5s3Hji1jDGM4k6n78OvZEYow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-JB7uhuwoOqSXK344pdd6bg-1; Fri, 12 Mar 2021 09:59:56 -0500
X-MC-Unique: JB7uhuwoOqSXK344pdd6bg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C37FA81746C;
        Fri, 12 Mar 2021 14:59:54 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C4A255D6D7;
        Fri, 12 Mar 2021 14:59:53 +0000 (UTC)
Date:   Fri, 12 Mar 2021 15:59:50 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 3/6] arm/arm64: Remove unnecessary ISB
 when doing dcache maintenance
Message-ID: <20210312145950.whq7ofrhbklwhprx@kamzik.brq.redhat.com>
References: <20210227104201.14403-1-alexandru.elisei@arm.com>
 <20210227104201.14403-4-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210227104201.14403-4-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 27, 2021 at 10:41:58AM +0000, Alexandru Elisei wrote:
> The dcache_by_line_op macro executes a DSB to complete the cache
> maintenance operations. According to ARM DDI 0487G.a, page B2-150:
> 
> "In addition, no instruction that appears in program order after the DSB
> instruction can alter any state of the system or perform any part of its
> functionality until the DSB completes other than:
> 
> - Being fetched from memory and decoded.
> - Reading the general-purpose, SIMD and floating-point, Special-purpose, or
>   System registers that are directly or indirectly read without causing
>   side-effects."
> 
> Similar definition for ARM in ARM DDI 0406C.d, page A3-150:
> 
> "In addition, no instruction that appears in program order after the DSB
> instruction can execute until the DSB completes."
> 
> This means that we don't need the ISB to prevent reordering of the cache
> maintenance instructions.
> 
> We are also not doing icache maintenance, where an ISB would be required
> for the PE to discard instructions speculated before the invalidation.
> 
> In conclusion, the ISB is unnecessary, so remove it.

Hi Alexandru,

We can go ahead and take this patch, since you've written quite a
convincing commit message, but in general I'd prefer we be overly cautious
in our common code. We'd like to ensure we don't introduce difficult to
debug issues there, and we don't care about optimizations, let alone
micro-optimizations. Testing barrier needs to the letter of the spec is a
good idea, but it's probably better to do that in the test cases.

Thanks,
drew

> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/cstart.S   | 1 -
>  arm/cstart64.S | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 954748b00f64..2d62c1e6d40d 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -212,7 +212,6 @@ asm_mmu_disable:
>  	ldr	r1, [r1]
>  	sub	r1, r1, r0
>  	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
> -	isb
>  
>  	mov     pc, lr
>  
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 046bd3914098..c1deff842f03 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -219,7 +219,6 @@ asm_mmu_disable:
>  	ldr	x1, [x1, :lo12:__phys_end]
>  	sub	x1, x1, x0
>  	dcache_by_line_op civac, sy, x0, x1, x2, x3
> -	isb
>  
>  	ret
>  
> -- 
> 2.30.1
> 

