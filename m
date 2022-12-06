Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6F1644551
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 15:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbiLFOIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 09:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiLFOIx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 09:08:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED72B02
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 06:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670335666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rZPmXJ12iNAD27cAnG002D5h4lD3s9/777tTNSc3XEo=;
        b=c2kjAWJDTpXmZI1fbM1T8zHypyZiXZffV824/3zXJwlQX2UcM9I+nsynQ7jzbp9QWqJdUf
        /i8JQHs4DbD+FzR++o/XO6MCAcS7K5yB30umV3nVqbXrxXNKkdPLO01ZVuIG7M+7HBS/Jm
        Z8mLVPiyKwOb6qNlZ8BQClY2deDNC1k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-70-ILTdzBJAMAiyUJnUeObWXA-1; Tue, 06 Dec 2022 09:07:42 -0500
X-MC-Unique: ILTdzBJAMAiyUJnUeObWXA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 756C0101A54E;
        Tue,  6 Dec 2022 14:07:42 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73446C15BA8;
        Tue,  6 Dec 2022 14:07:40 +0000 (UTC)
Message-ID: <f27f5791caaf01d379027c6802fdeb953bd59c22.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 11/27] lib: Add random number generator
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Date:   Tue, 06 Dec 2022 16:07:39 +0200
In-Reply-To: <20221123102850.08df4bd9@p-imbrenda>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
         <20221122161152.293072-12-mlevitsk@redhat.com>
         <20221123102850.08df4bd9@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-11-23 at 10:28 +0100, Claudio Imbrenda wrote:
> On Tue, 22 Nov 2022 18:11:36 +0200
> Maxim Levitsky <mlevitsk@redhat.com> wrote:
> 
> > Add a simple pseudo random number generator which can be used
> > in the tests to add randomeness in a controlled manner.
> 
> ahh, yes I have wanted something like this in the library for quite some
> time! thanks!
> 
> I have some comments regarding the interfaces (see below), and also a
> request, if you could split the x86 part in a different patch, so we
> can have a "pure" lib patch, and then you can have an x86-only patch
> that uses the new interface
> 
> > For x86 add a wrapper which initializes the PRNG with RDRAND,
> > unless RANDOM_SEED env variable is set, in which case it is used
> > instead.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  Makefile              |  3 ++-
> >  README.md             |  1 +
> >  lib/prng.c            | 41 +++++++++++++++++++++++++++++++++++++++++
> >  lib/prng.h            | 23 +++++++++++++++++++++++
> >  lib/x86/random.c      | 33 +++++++++++++++++++++++++++++++++
> >  lib/x86/random.h      | 17 +++++++++++++++++
> >  scripts/arch-run.bash |  2 +-
> >  x86/Makefile.common   |  1 +
> >  8 files changed, 119 insertions(+), 2 deletions(-)
> >  create mode 100644 lib/prng.c
> >  create mode 100644 lib/prng.h
> >  create mode 100644 lib/x86/random.c
> >  create mode 100644 lib/x86/random.h
> > 
> > diff --git a/Makefile b/Makefile
> > index 6ed5deac..384b5acf 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -29,7 +29,8 @@ cflatobjs := \
> >  	lib/string.o \
> >  	lib/abort.o \
> >  	lib/report.o \
> > -	lib/stack.o
> > +	lib/stack.o \
> > +	lib/prng.o
> >  
> >  # libfdt paths
> >  LIBFDT_objdir = lib/libfdt
> > diff --git a/README.md b/README.md
> > index 6e82dc22..5a677a03 100644
> > --- a/README.md
> > +++ b/README.md
> > @@ -91,6 +91,7 @@ the framework.  The list of reserved environment variables is below
> >      QEMU_ACCEL                   either kvm, hvf or tcg
> >      QEMU_VERSION_STRING          string of the form `qemu -h | head -1`
> >      KERNEL_VERSION_STRING        string of the form `uname -r`
> > +    TEST_SEED                    integer to force a fixed seed for the prng
> >  
> >  Additionally these self-explanatory variables are reserved
> >  
> > diff --git a/lib/prng.c b/lib/prng.c
> > new file mode 100644
> > index 00000000..d9342eb3
> > --- /dev/null
> > +++ b/lib/prng.c
> > @@ -0,0 +1,41 @@
> > +
> > +/*
> > + * Random number generator that is usable from guest code. This is the
> > + * Park-Miller LCG using standard constants.
> > + */
> > +
> > +#include "libcflat.h"
> > +#include "prng.h"
> > +
> > +struct random_state new_random_state(uint32_t seed)
> > +{
> > +	struct random_state s = {.seed = seed};
> > +	return s;
> > +}
> > +
> > +uint32_t random_u32(struct random_state *state)
> > +{
> > +	state->seed = (uint64_t)state->seed * 48271 % ((uint32_t)(1 << 31) - 1);
> 
> why not:
> 
> state->seed = state->seed * 48271ULL % (BIT_ULL(31) - 1);
> 
> I think it's more readable

I copied this code vertabium from a patch that was send to in-kernel selftests
as Sean suggested me to do.

I to be honest would have picked some more complex random generator like the
Mersenne Twister or something like that, since performance is not an issue here,
and this generator is I think geared toward beeing as fast as possible.

But againg I don't care much about this, any source of randomness is better
that nothing.

> 
> > +	return state->seed;
> > +}
> > +
> > +
> > +uint32_t random_range(struct random_state *state, uint32_t min, uint32_t max)
> > +{
> > +	uint32_t val = random_u32(state);
> > +
> > +	return val % (max - min + 1) + min;
> 
> what happens if max == UINT_MAX and min = 0 ?
> 
> maybe:
> 
> if (max - min == UINT_MAX)
> 	return val;

Makes sense.
> 
> > +}
> > +
> > +/*
> > + * Returns true randomly in 'percent_true' cases (e.g if percent_true = 70.0,
> > + * it will return true in 70.0% of cases)
> > + */
> > +bool random_decision(struct random_state *state, float percent_true)
> 
> I'm not a fan of floats in the lib...
> 
> > +{
> > +	if (percent_true == 0)
> > +		return 0;
> > +	if (percent_true == 100)
> > +		return 1;
> > +	return random_range(state, 1, 10000) < (uint32_t)(percent_true * 100);
> 
> ...especially when you are only using 2 decimal places anyway

I was thinking the same about this, there are pros and cons,
Using a fixed point integer is a bit less usable but overall I don't mind
using it.



> 
> can you rewrite it to take an unsigned int? 
> e.g. if percent_true = 7123, it will return true in 71.23% of the cases
> 
> then you can rewrite the last line like this:
> 
> return random_range(state, 1, 10000) < percent_true;
> 
> > +}
> > diff --git a/lib/prng.h b/lib/prng.h
> > new file mode 100644
> > index 00000000..61d3a48b
> > --- /dev/null
> > +++ b/lib/prng.h
> > @@ -0,0 +1,23 @@
> > +
> > +#ifndef SRC_LIB_PRNG_H_
> > +#define SRC_LIB_PRNG_H_
> > +
> > +struct random_state {
> > +	uint32_t seed;
> > +};
> > +
> > +struct random_state new_random_state(uint32_t seed);
> > +uint32_t random_u32(struct random_state *state);
> > +
> > +/*
> > + * return a random number from min to max (included)
> > + */
> > +uint32_t random_range(struct random_state *state, uint32_t min, uint32_t max);
> > +
> > +/*
> > + * Returns true randomly in 'percent_true' cases (e.g if percent_true = 70.0,
> > + * it will return true in 70.0% of cases)
> > + */
> > +bool random_decision(struct random_state *state, float percent_true);
> > +
> > +#endif /* SRC_LIB_PRNG_H_ */
> 
> and then put the rest below in a new patch

No problem. Note that x86 specific bits can be minimized
but that requires plumbing in several things that you would
take for granted, and in particular, env vars
are x86 specific, and apic id is x86 specific.

When a random number generator is wired to a new arch,
this can be fixed.

Best regards,
	Maxim Levitsky

> 
> > diff --git a/lib/x86/random.c b/lib/x86/random.c
> > new file mode 100644
> > index 00000000..fcdd5fe8
> > --- /dev/null
> > +++ b/lib/x86/random.c
> > @@ -0,0 +1,33 @@
> > +
> > +#include "libcflat.h"
> > +#include "processor.h"
> > +#include "prng.h"
> > +#include "smp.h"
> > +#include "asm/spinlock.h"
> > +#include "random.h"
> > +
> > +static u32 test_seed;
> > +static bool initialized;
> > +
> > +void init_prng(void)
> > +{
> > +	char *test_seed_str = getenv("TEST_SEED");
> > +
> > +	if (test_seed_str && strlen(test_seed_str))
> > +		test_seed = atol(test_seed_str);
> > +	else
> > +#ifdef __x86_64__
> > +		test_seed =  (u32)rdrand();
> > +#else
> > +		test_seed = (u32)(rdtsc() << 4);
> > +#endif
> > +	initialized = true;
> > +
> > +	printf("Test seed: %u\n", (unsigned int)test_seed);
> > +}
> > +
> > +struct random_state get_prng(void)
> > +{
> > +	assert(initialized);
> > +	return new_random_state(test_seed + this_cpu_read_smp_id());
> > +}
> > diff --git a/lib/x86/random.h b/lib/x86/random.h
> > new file mode 100644
> > index 00000000..795b450b
> > --- /dev/null
> > +++ b/lib/x86/random.h
> > @@ -0,0 +1,17 @@
> > +/*
> > + * prng.h
> > + *
> > + *  Created on: Nov 9, 2022
> > + *      Author: mlevitsk
> > + */
> > +
> > +#ifndef SRC_LIB_X86_RANDOM_H_
> > +#define SRC_LIB_X86_RANDOM_H_
> > +
> > +#include "libcflat.h"
> > +#include "prng.h"
> > +
> > +void init_prng(void);
> > +struct random_state get_prng(void);
> > +
> > +#endif /* SRC_LIB_X86_RANDOM_H_ */
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index 51e4b97b..238d19f8 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -298,7 +298,7 @@ env_params ()
> >  	KERNEL_EXTRAVERSION=${KERNEL_EXTRAVERSION%%[!0-9]*}
> >  	! [[ $KERNEL_SUBLEVEL =~ ^[0-9]+$ ]] && unset $KERNEL_SUBLEVEL
> >  	! [[ $KERNEL_EXTRAVERSION =~ ^[0-9]+$ ]] && unset $KERNEL_EXTRAVERSION
> > -	env_add_params KERNEL_VERSION_STRING KERNEL_VERSION KERNEL_PATCHLEVEL KERNEL_SUBLEVEL KERNEL_EXTRAVERSION
> > +	env_add_params KERNEL_VERSION_STRING KERNEL_VERSION KERNEL_PATCHLEVEL KERNEL_SUBLEVEL KERNEL_EXTRAVERSION TEST_SEED
> >  }
> >  
> >  env_file ()
> > diff --git a/x86/Makefile.common b/x86/Makefile.common
> > index 698a48ab..fa0a50e6 100644
> > --- a/x86/Makefile.common
> > +++ b/x86/Makefile.common
> > @@ -23,6 +23,7 @@ cflatobjs += lib/x86/stack.o
> >  cflatobjs += lib/x86/fault_test.o
> >  cflatobjs += lib/x86/delay.o
> >  cflatobjs += lib/x86/pmu.o
> > +cflatobjs += lib/x86/random.o
> >  ifeq ($(CONFIG_EFI),y)
> >  cflatobjs += lib/x86/amd_sev.o
> >  cflatobjs += lib/efi.o


