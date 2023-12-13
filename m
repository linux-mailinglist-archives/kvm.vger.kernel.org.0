Return-Path: <kvm+bounces-4339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33531811315
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 14:38:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2A2628257A
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 13:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAC742D608;
	Wed, 13 Dec 2023 13:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DC0eJUCr"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B853FDD
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 05:38:38 -0800 (PST)
Date: Wed, 13 Dec 2023 14:38:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702474717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k2KabcvDu24T1/+RDnEEzXHQcrYL/MoAqaQFJlpJvLI=;
	b=DC0eJUCr0cAftytPYVnxVAH6Np3sdf6QKY67g0GbehyqaA3ktxshLwKov3rH+Yjn82XALi
	VjmQMKqOnfXw0a66Lo+36aeDWolPQMU9sqCa8NLkpOGLn852JLnlhdy0plu6Ayt0lVfz4g
	1CY/YQemVIcylJNWNq2/3pTMkCbK7Gw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, David Hildenbrand <david@redhat.com>, 
	Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 1/5] lib: Add pseudo random functions
Message-ID: <20231213-8407f7ddc3a972de2715db9c@orel>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
 <20231213124942.604109-2-nsg@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231213124942.604109-2-nsg@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Dec 13, 2023 at 01:49:38PM +0100, Nina Schoetterl-Glausch wrote:
> Add functions for generating pseudo random 32 and 64 bit values.
> The implementation is very simple and the randomness likely not
> of high quality.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>  Makefile       |  1 +
>  lib/libcflat.h |  7 +++++++
>  lib/rand.c     | 19 +++++++++++++++++++
>  3 files changed, 27 insertions(+)
>  create mode 100644 lib/rand.c
> 
> diff --git a/Makefile b/Makefile
> index 602910dd..7997e035 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -28,6 +28,7 @@ cflatobjs := \
>  	lib/printf.o \
>  	lib/string.o \
>  	lib/abort.o \
> +	lib/rand.o \
>  	lib/report.o \
>  	lib/stack.o
>  
> diff --git a/lib/libcflat.h b/lib/libcflat.h
> index 700f4352..ed947f98 100644
> --- a/lib/libcflat.h
> +++ b/lib/libcflat.h
> @@ -83,6 +83,13 @@ extern void abort(void) __attribute__((noreturn));
>  extern long atol(const char *ptr);
>  extern char *getenv(const char *name);
>  
> +typedef struct {
> +	uint32_t val;
> +} rand_state;
> +#define RAND_STATE_INIT(x) ((rand_state){ .val = (x) })
> +uint32_t rand32(rand_state *state);
> +uint64_t rand64(rand_state *state);
> +
>  extern int printf(const char *fmt, ...)
>  					__attribute__((format(printf, 1, 2)));
>  extern int snprintf(char *buf, int size, const char *fmt, ...)
> diff --git a/lib/rand.c b/lib/rand.c
> new file mode 100644
> index 00000000..658c4cbf
> --- /dev/null
> +++ b/lib/rand.c
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * pseudo random functions
> + *
> + * Copyright IBM Corp. 2023
> + */
> +
> +#include "libcflat.h"
> +
> +uint32_t rand32(rand_state *state)
> +{
> +	state->val = 0x915f77f5 * state->val + 1;
> +	return state->val ^ (state->val >> 16);
> +}
> +
> +uint64_t rand64(rand_state *state)
> +{
> +	return (uint64_t)rand32(state) << 32 | rand32(state);
> +}
> -- 
> 2.41.0
>

Alex Bennée posted a prng patch a long time ago that never got merged.

https://www.spinics.net/lists/kvm-arm/msg50921.html

would it be better to merge that?

Thanks,
drew

