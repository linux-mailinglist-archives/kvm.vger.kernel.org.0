Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992DC73CA69
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 12:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233059AbjFXKOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Jun 2023 06:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbjFXKN7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Jun 2023 06:13:59 -0400
Received: from out-15.mta1.migadu.com (out-15.mta1.migadu.com [IPv6:2001:41d0:203:375::f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE02F19BF
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 03:13:57 -0700 (PDT)
Date:   Sat, 24 Jun 2023 12:13:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687601636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A59RX4Psfmsee73Wcj8FhDt8qoCuIv7XFaAntNF8qvA=;
        b=wV4aPLjEbnb/2zGkr70kL4y9/yLflRFsxrmRDwLDsVBDUEtDs0pfY3klrkBnfMeCqi7iAR
        N0/d4uR12CW0squAmfa2pu/hwKp3k+f1EyfossHhKzZ3gypEW+PXmGFjCRNnb5bt3iEitT
        wVA7CKn7ER613r4Whe0t7ayT+m0bnbg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Nadav Amit <namit@vmware.com>
Subject: Re: [kvm-unit-tests PATCH 3/6] arm64: enable frame pointer and
 support stack unwinding
Message-ID: <20230623-622ec2c26e09f951f42cce46@orel>
References: <20230617014930.2070-1-namit@vmware.com>
 <20230617014930.2070-4-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230617014930.2070-4-namit@vmware.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 17, 2023 at 01:49:27AM +0000, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Enable frame pointers for arm64 and perform stack unwinding based on
> arm64 convention.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  arm/Makefile.arm      |  3 ---
>  arm/Makefile.arm64    |  1 +
>  arm/Makefile.common   |  3 +++
>  lib/arm64/asm/stack.h |  3 +++
>  lib/arm64/stack.c     | 37 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 44 insertions(+), 3 deletions(-)
>  create mode 100644 lib/arm64/stack.c
> 
> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> index 2ce00f5..7fd39f3 100644
> --- a/arm/Makefile.arm
> +++ b/arm/Makefile.arm
> @@ -11,9 +11,6 @@ ifeq ($(CONFIG_EFI),y)
>  $(error Cannot build arm32 tests as EFI apps)
>  endif
>  
> -# stack.o relies on frame pointers.
> -KEEP_FRAME_POINTER := y
> -
>  CFLAGS += $(machine)
>  CFLAGS += -mcpu=$(PROCESSOR)
>  CFLAGS += -mno-unaligned-access
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index eada7f9..60385e2 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -21,6 +21,7 @@ define arch_elf_check =
>  endef
>  
>  cstart.o = $(TEST_DIR)/cstart64.o
> +cflatobjs += lib/arm64/stack.o
>  cflatobjs += lib/arm64/processor.o
>  cflatobjs += lib/arm64/spinlock.o
>  cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index f904702..7fecfb3 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -22,6 +22,9 @@ $(TEST_DIR)/sieve.elf: AUXFLAGS = 0x1
>  ##################################################################
>  AUXFLAGS ?= 0x0
>  
> +# stack.o relies on frame pointers.
> +KEEP_FRAME_POINTER := y
> +
>  CFLAGS += -std=gnu99
>  CFLAGS += -ffreestanding
>  CFLAGS += -O2
> diff --git a/lib/arm64/asm/stack.h b/lib/arm64/asm/stack.h
> index d000624..be486cf 100644
> --- a/lib/arm64/asm/stack.h
> +++ b/lib/arm64/asm/stack.h
> @@ -5,4 +5,7 @@
>  #error Do not directly include <asm/stack.h>. Just use <stack.h>.
>  #endif
>  
> +#define HAVE_ARCH_BACKTRACE_FRAME
> +#define HAVE_ARCH_BACKTRACE
> +
>  #endif
> diff --git a/lib/arm64/stack.c b/lib/arm64/stack.c
> new file mode 100644
> index 0000000..1e2568a
> --- /dev/null
> +++ b/lib/arm64/stack.c
> @@ -0,0 +1,37 @@
> +/*
> + * backtrace support (this is a modified lib/x86/stack.c)
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#include <libcflat.h>
> +#include <stack.h>
> +
> +extern char vector_stub_start, vector_stub_end;

These aren't used until the next patch.

> +
> +int backtrace_frame(const void *frame, const void **return_addrs, int max_depth) {

'{' should be on its own line. I usually try to run the kernel's
checkpatch since we use the same style (except we're even more forgiving
for long lines).

> +	const void *fp = frame;
> +	void *lr;
> +	int depth;
> +
> +	/*
> +	 * ARM64 stack grows down. fp points to the previous fp on the stack,
> +	 * and lr is just above it
> +	 */
> +	for (depth = 0; fp && depth < max_depth; ++depth) {
> +
> +		asm volatile ("ldp %0, %1, [%2]"
> +				  : "=r" (fp), "=r" (lr)
> +				  : "r" (fp)
> +				  : );
> +
> +		return_addrs[depth] = lr;
> +	}
> +
> +	return depth;
> +}
> +
> +int backtrace(const void **return_addrs, int max_depth)
> +{
> +	return backtrace_frame(__builtin_frame_address(0),
> +			       return_addrs, max_depth);
> +}
> -- 
> 2.34.1
> 

Thanks,
drew
