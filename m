Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCEB346496
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbhCWQLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:11:48 -0400
Received: from foss.arm.com ([217.140.110.172]:48736 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233182AbhCWQLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:11:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 546EDD6E;
        Tue, 23 Mar 2021 09:11:24 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 382483F718;
        Tue, 23 Mar 2021 09:11:23 -0700 (PDT)
Date:   Tue, 23 Mar 2021 16:11:13 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, alexandru.elisei@arm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] lib/string: Add strnlen, strrchr
 and strtoul
Message-ID: <20210323161113.3f4efe7b@slackpad.fritz.box>
In-Reply-To: <20210323134121.h4pybwqqwruhomrr@kamzik.brq.redhat.com>
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
        <20210318180727.116004-2-nikos.nikoleris@arm.com>
        <20210322083523.r7bu7ledgasqjduy@kamzik.brq.redhat.com>
        <20210323121415.rss3evguqb3b7vvz@kamzik.brq.redhat.com>
        <20210323130001.7f160eaa@slackpad.fritz.box>
        <20210323134121.h4pybwqqwruhomrr@kamzik.brq.redhat.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 Mar 2021 14:41:21 +0100
Andrew Jones <drjones@redhat.com> wrote:

Hi,

> On Tue, Mar 23, 2021 at 01:00:01PM +0000, Andre Przywara wrote:
> > On Tue, 23 Mar 2021 13:14:15 +0100
> > Andrew Jones <drjones@redhat.com> wrote:
> > 
> > Hi,
> >   
> > > On Mon, Mar 22, 2021 at 09:35:23AM +0100, Andrew Jones wrote:  
> > > > @@ -208,23 +209,46 @@ unsigned long int strtoul(const char *nptr, char **endptr, int base)
> > > >              c = *s - 'A' + 10;
> > > >          else
> > > >              break;
> > > > -        acc = acc * base + c;
> > > > +
> > > > +        if (is_signed) {
> > > > +            long __acc = (long)acc;
> > > > +            overflow = __builtin_smull_overflow(__acc, base, &__acc);
> > > > +            assert(!overflow);
> > > > +            overflow = __builtin_saddl_overflow(__acc, c, &__acc);
> > > > +            assert(!overflow);
> > > > +            acc = (unsigned long)__acc;
> > > > +        } else {
> > > > +            overflow = __builtin_umull_overflow(acc, base, &acc);
> > > > +            assert(!overflow);
> > > > +            overflow = __builtin_uaddl_overflow(acc, c, &acc);
> > > > +            assert(!overflow);
> > > > +        }
> > > > +    
> > > 
> > > Unfortunately my use of these builtins isn't loved by older compilers,
> > > like the one used by the build-centos7 pipeline in our gitlab CI. I
> > > could wrap them in an #if GCC_VERSION >= 50100 and just have the old
> > > 'acc = acc * base + c' as the fallback, but that's not pretty and
> > > would also mean that clang would use the fallback too. Maybe we can
> > > try and make our compiler.h more fancy in order to provide a
> > > COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW define like linux does for
> > > both gcc and clang. Or, we could just forgot the overflow checking.  
> > 
> > In line with my email from yesterday:
> > Before we go down the path of all evil (premature optimisation!), can't
> > we just copy
> > https://git.kernel.org/pub/scm/libs/klibc/klibc.git/tree/usr/klibc/strntoumax.c
> > and have a tested version that works everywhere? This is BSD/GPL dual
> > licensed, IIUC.
> > I don't really see the reason to performance optimise strtol in the
> > context of kvm-unit-tests.
> >  
> 
> Using the builtin isn't to optimize, it's to simplify. Checking for
> overflow on multiplication is ugly business. As I said yesterday,
> klibc doesn't do any error checking.

Argh, sorry, I missed your reply yesterday in a bunch of other emails!

> We could choose to go that
> way too, but I'd prefer we give a best effort to making the test
> framework robust.

I agree, klibc was just some example, I didn't look too closely into
it. If it lacks, we should indeed not use it.

I just felt we are going through all the special cases of those
functions again, when people elsewhere checked all of them already. I
had some unpleasant experience with implementing a seemingly simple
memcpy() last year, with some surprising corner cases, so grew a bit
wary about re-implementing standard stuff and hoping it's all good.

Cheers,
Andre

> I quick pulled together the diff below. This gives us the overflow
> checking when not using old compilers, but just falls back to the
> simple math otherwise. Unless people have strong opinions about
> that, then I'm inclined to go with it.
> 
> Thanks,
> drew
> 
> 
> diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
> index 2d72f18c36e5..311da9807932 100644
> --- a/lib/linux/compiler.h
> +++ b/lib/linux/compiler.h
> @@ -8,6 +8,20 @@
>  
>  #ifndef __ASSEMBLY__
>  
> +#define GCC_VERSION (__GNUC__ * 10000           \
> +                    + __GNUC_MINOR__ * 100     \
> +                    + __GNUC_PATCHLEVEL__)
> +
> +#ifdef __clang__
> +#if __has_builtin(__builtin_mul_overflow) && \
> +    __has_builtin(__builtin_add_overflow) && \
> +    __has_builtin(__builtin_sub_overflow)
> +#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
> +#endif
> +#elif GCC_VERSION >= 50100
> +#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
> +#endif
> +
>  #include <stdint.h>
>  
>  #define barrier()      asm volatile("" : : : "memory")
> diff --git a/lib/string.c b/lib/string.c
> index b684271bb18f..e323908fe24e 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -7,6 +7,7 @@
>  
>  #include "libcflat.h"
>  #include "stdlib.h"
> +#include "linux/compiler.h"
>  
>  size_t strlen(const char *buf)
>  {
> @@ -171,7 +172,6 @@ static unsigned long __strtol(const char *nptr, char **endptr,
>                                int base, bool is_signed) {
>      unsigned long acc = 0;
>      const char *s = nptr;
> -    bool overflow;
>      int neg, c;
>  
>      assert(base == 0 || (base >= 2 && base <= 36));
> @@ -210,19 +210,23 @@ static unsigned long __strtol(const char *nptr, char **endptr,
>          else
>              break;
>  
> +#ifdef COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
>          if (is_signed) {
>              long __acc = (long)acc;
> -            overflow = __builtin_smull_overflow(__acc, base, &__acc);
> +            bool overflow = __builtin_smull_overflow(__acc, base, &__acc);
>              assert(!overflow);
>              overflow = __builtin_saddl_overflow(__acc, c, &__acc);
>              assert(!overflow);
>              acc = (unsigned long)__acc;
>          } else {
> -            overflow = __builtin_umull_overflow(acc, base, &acc);
> +            bool overflow = __builtin_umull_overflow(acc, base, &acc);
>              assert(!overflow);
>              overflow = __builtin_uaddl_overflow(acc, c, &acc);
>              assert(!overflow);
>          }
> +#else
> +        acc = acc * base + c;
> +#endif
>  
>          s++;
>      }
> 

