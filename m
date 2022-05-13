Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC872525E57
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 11:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbiEMJLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378907AbiEMJK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:10:58 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045B9D83;
        Fri, 13 May 2022 02:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9wPbBgfhyB15p9fMVpN0HXj8ubcOCLHwB5quRLaukZI=; b=F/yk5KFtp1tUsX1DuERzFcdod8
        PAxCxEEXD7MyneyMeUr0otrxqSZbZli18/ximq1SuKtHtciGcHRx0mShVuHSznYW8ykyv73kk+7wP
        51DWO+9yhPvdmXxyWz4aW0yE1aD8qGRw58BBTFnHh9nb9VJrceA+dZ5TBGMNb00r+ut/6YX3Zi8j2
        M8qa4Xt0Tqfa4n7imDOQIICgkyEg9oc3AmAKQWO4x7MCRbT56J9AG+Qlx3lTvHQUl5oJQq7jQAQxh
        8yEvYiuSrlgld5UVo1tB5M13MKTruEaM0OfARARfK/daNjnFwJJ82aaDf7FP2kv3rgGhKQe2ycWmp
        0k72CeOg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1npRJk-00DkcX-T7; Fri, 13 May 2022 09:10:37 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1A8A6980F9A; Fri, 13 May 2022 11:10:35 +0200 (CEST)
Date:   Fri, 13 May 2022 11:10:34 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Uros Bizjak <ubizjak@gmail.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Marco Elver <elver@google.com>
Subject: Re: [PATCH] locking/atomic/x86: Introduce try_cmpxchg64
Message-ID: <20220513091034.GH76023@worktop.programming.kicks-ass.net>
References: <20220510154217.5216-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510154217.5216-1-ubizjak@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 05:42:17PM +0200, Uros Bizjak wrote:

For the Changelog I would focus on the 64bit improvement and leave 32bit
as a side-note.

> ---
>  arch/x86/include/asm/cmpxchg_32.h          | 43 ++++++++++++++++++++++
>  arch/x86/include/asm/cmpxchg_64.h          |  6 +++
>  include/linux/atomic/atomic-instrumented.h | 40 +++++++++++++++++++-
>  scripts/atomic/gen-atomic-instrumented.sh  |  2 +-
>  4 files changed, 89 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
> index 0a7fe0321613..e874ff7f7529 100644
> --- a/arch/x86/include/asm/cmpxchg_32.h
> +++ b/arch/x86/include/asm/cmpxchg_32.h
> @@ -42,6 +42,9 @@ static inline void set_64bit(volatile u64 *ptr, u64 value)
>  #define arch_cmpxchg64_local(ptr, o, n)					\
>  	((__typeof__(*(ptr)))__cmpxchg64_local((ptr), (unsigned long long)(o), \
>  					       (unsigned long long)(n)))
> +#define arch_try_cmpxchg64(ptr, po, n)					\
> +	((__typeof__(*(ptr)))__try_cmpxchg64((ptr), (unsigned long long *)(po), \
> +					     (unsigned long long)(n)))
>  #endif
>  
>  static inline u64 __cmpxchg64(volatile u64 *ptr, u64 old, u64 new)
> @@ -70,6 +73,25 @@ static inline u64 __cmpxchg64_local(volatile u64 *ptr, u64 old, u64 new)
>  	return prev;
>  }
>  
> +static inline bool __try_cmpxchg64(volatile u64 *ptr, u64 *pold, u64 new)
> +{
> +	bool success;
> +	u64 prev;
> +	asm volatile(LOCK_PREFIX "cmpxchg8b %2"
> +		     CC_SET(z)
> +		     : CC_OUT(z) (success),
> +		       "=A" (prev),
> +		       "+m" (*ptr)
> +		     : "b" ((u32)new),
> +		       "c" ((u32)(new >> 32)),
> +		       "1" (*pold)
> +		     : "memory");
> +
> +	if (unlikely(!success))
> +		*pold = prev;

I would prefer this be more like the existing try_cmpxchg code,
perhaps:

	u64 old = *pold;

	asm volatile (LOCK_PREFIX "cmpxchg8b %[ptr]"
		      CC_SET(z)
		      : CC_OUT(z) (success),
		        [ptr] "+m" (*ptr)
		        "+A" (old)
		      : "b" ((u32)new)
		        "c" ((u32)(new >> 32))
		      : "memory");

	if (unlikely(!success))
		*pold = old;

The existing 32bit cmpxchg code is a 'bit' crusty.

> +	return success;
> +}
> +
>  #ifndef CONFIG_X86_CMPXCHG64
>  /*
>   * Building a kernel capable running on 80386 and 80486. It may be necessary
> @@ -108,6 +130,27 @@ static inline u64 __cmpxchg64_local(volatile u64 *ptr, u64 old, u64 new)
>  		       : "memory");				\
>  	__ret; })
>  
> +#define arch_try_cmpxchg64(ptr, po, n)				\
> +({								\
> +	bool success;						\
> +	__typeof__(*(ptr)) __prev;				\
> +	__typeof__(ptr) _old = (__typeof__(ptr))(po);		\
> +	__typeof__(*(ptr)) __old = *_old;			\
> +	__typeof__(*(ptr)) __new = (n);				\
> +	alternative_io(LOCK_PREFIX_HERE				\
> +			"call cmpxchg8b_emu",			\
> +			"lock; cmpxchg8b (%%esi)" ,		\
> +		       X86_FEATURE_CX8,				\
> +		       "=A" (__prev),				\
> +		       "S" ((ptr)), "0" (__old),		\
> +		       "b" ((unsigned int)__new),		\
> +		       "c" ((unsigned int)(__new>>32))		\
> +		       : "memory");				\
> +	success = (__prev == __old);				\
> +	if (unlikely(!success))					\
> +		*_old = __prev;					\
> +	likely(success);					\
> +})

Wouldn't this be better written like the normal fallback wrapper?

static __always_inline bool
arch_try_cmpxchg64(u64 *v, u64 *old, u64 new)
{
	u64 r, o = *old;
	r = arch_cmpxchg64(v, o, new);
	if (unlikely(r != o))
		*old = r;
	return likely(r == o);
}

Less magical, same exact code.
