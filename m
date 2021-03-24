Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28211347BE5
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 16:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbhCXPPZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 11:15:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37872 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236413AbhCXPPI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Mar 2021 11:15:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616598908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eb8//3oSoa3M7nlblO0ZW5ye3nSSfJ2OdQOfZjj4GAw=;
        b=ChNqRKXl/GSZiDoPe0lpmPnc6wiHpLAE+AHX5w3tOJxxEJ6pta2I7EAxdZoHoVGga4kKUI
        IUEpFQp3juz/VrmB1cvN8bCrCih7wn4N01mYEWqmdwIDilyqmJ2zMP08kxEk5r0R25N+hS
        RfanVGGbdsTtP1/4XED8l2F/dBGNCfw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-O1Rmx6A-NbeNp0A6gqVntQ-1; Wed, 24 Mar 2021 11:15:05 -0400
X-MC-Unique: O1Rmx6A-NbeNp0A6gqVntQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF56783DD23
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 15:15:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 814A862677;
        Wed, 24 Mar 2021 15:14:59 +0000 (UTC)
Date:   Wed, 24 Mar 2021 16:14:55 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [PATCH kvm-unit-tests v2] compiler: Add builtin overflow flag
 and predicate wrappers
Message-ID: <20210324151455.7pfhn72bwnl7lrt2@kamzik.brq.redhat.com>
References: <20210323175424.368223-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323175424.368223-1-drjones@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 06:54:24PM +0100, Andrew Jones wrote:
> Checking for overflow can be difficult, but doing so may be a good
> idea to avoid difficult to debug problems. Compilers that provide
> builtins for overflow checking allow the checks to be simple
> enough that we can use them more liberally. The idea for this
> flag is to wrap a calculation that should have overflow checking,
> allowing compilers that support it to give us some extra robustness.
> For example,
> 
>   #ifdef COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
>       bool overflow = __builtin_mul_overflow(x, y, &z);
>       assert(!overflow);
>   #else
>       /* Older compiler, hopefully we don't overflow... */
>       z = x * y;
>   #endif
> 
> This is a bit ugly though, so when possible we can just use the
> predicate wrappers, which have an always-false fallback, e.g.
> 
>   /* Old compilers won't assert on overflow. Oh, well... */
>   assert(!check_mul_overflow(x, y));
>   z = x * y;
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
> 
> v2: Added predicate wrappers
> 
>  lib/linux/compiler.h | 33 +++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
> index 2d72f18c36e5..aa2e3710cf1d 100644
> --- a/lib/linux/compiler.h
> +++ b/lib/linux/compiler.h
> @@ -8,6 +8,39 @@
>  
>  #ifndef __ASSEMBLY__
>  
> +#define GCC_VERSION (__GNUC__ * 10000           \
> +		     + __GNUC_MINOR__ * 100     \
> +		     + __GNUC_PATCHLEVEL__)
> +
> +#ifdef __clang__
> +#if __has_builtin(__builtin_add_overflow) && \
> +    __has_builtin(__builtin_sub_overflow) && \
> +    __has_builtin(__builtin_mul_overflow)
> +#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
> +#define check_add_overflow(a, b) ({			\
> +	typeof((a) + (b)) __d;				\
> +	__builtin_add_overflow(a, b, &__d);		\
> +})
> +#define check_sub_overflow(a, b) ({			\
> +	typeof((a) - (b)) __d;				\
> +	__builtin_sub_overflow(a, b, &__d);		\
> +})
> +#define check_mul_overflow(a, b) ({			\
> +	typeof((a) * (b)) __d;				\
> +	__builtin_mul_overflow(a, b, &__d);		\
> +})
> +#endif
> +#elif GCC_VERSION >= 50100
> +#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
> +#define check_add_overflow(a, b) __builtin_add_overflow_p(a, b, (typeof((a) + (b)))0)
> +#define check_sub_overflow(a, b) __builtin_add_overflow_p(a, b, (typeof((a) - (b)))0)
> +#define check_mul_overflow(a, b) __builtin_add_overflow_p(a, b, (typeof((a) * (b)))0)
> +#else
> +#define check_add_overflow(a, b) (0)
> +#define check_sub_overflow(a, b) (0)
> +#define check_mul_overflow(a, b) (0)
> +#endif
> +
>  #include <stdint.h>
>  
>  #define barrier()	asm volatile("" : : : "memory")
> -- 
> 2.26.3
>

I just wanted to point out that with this patch the relevant part of
strtoul becomes

        if (is_signed) {
            long sacc = (long)acc;
            assert(!check_mul_overflow(sacc, base));
            assert(!check_add_overflow(sacc * base, c));
        } else {
            assert(!check_mul_overflow(acc, base));
            assert(!check_add_overflow(acc * base, c));
        }

        acc = acc * base + c;

which looks pretty good to me (if I do say so myself). Unless somebody
shouts I'll queue this patch in arm/queue tomorrow. I'll need to rebase
arm/queue to squash in the fixup to strtoul (I hope nobody thinks that
the arm/queue branch is stable, because it's not!)

I also plan to grab another series from Alexandru, do final testing,
and send Paolo an MR for the whole lot tomorrow.

Thanks,
drew

