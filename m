Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9593495B2
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 16:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhCYPfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 11:35:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230242AbhCYPfF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 11:35:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616686501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vhTWLwMZpTau4ebBhqBB0phVNevGrgC/VsyxT8jZk9o=;
        b=Yyt591G2P0MxcDypqgMasFEmNym7V9rE/vQ9/pFskPnrvxxENL8gaUJL05lJNOia/lUdTz
        TsQiBuQEJTfRp1y9hy3YwKj0/p7LVwef7x2RP97wYvv1Q9El05BsNoi0knAwCQ+QQY4lEx
        bIrFPAF6pTPo2eW640Jg3gS4EJCGr8Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-3i92uAjfOSeuf41cBc929Q-1; Thu, 25 Mar 2021 11:34:57 -0400
X-MC-Unique: 3i92uAjfOSeuf41cBc929Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAD8C1005589
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 15:34:30 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D83855C260;
        Thu, 25 Mar 2021 15:34:29 +0000 (UTC)
Date:   Thu, 25 Mar 2021 16:34:19 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [PATCH kvm-unit-tests v2] compiler: Add builtin overflow flag
 and predicate wrappers
Message-ID: <20210325153419.45bbbzgdilh7xd56@kamzik.brq.redhat.com>
References: <20210323175424.368223-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323175424.368223-1-drjones@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Applied to arm/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

but with another fixup. When the builins are not available and we want to
fallback to always false, we also need to ensure any parameters passed to
the check_* functions do not result in unused variable warnings. To do
that, those macros have been changed to

#define check_add_overflow(a, b) ({ (void)((int)(a) == (int)(b)); 0; })
#define check_sub_overflow(a, b) ({ (void)((int)(a) == (int)(b)); 0; })
#define check_mul_overflow(a, b) ({ (void)((int)(a) == (int)(b)); 0; })

Thanks,
drew

