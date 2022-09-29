Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D785E5EF0D6
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 10:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbiI2ItI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 04:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235183AbiI2ItH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 04:49:07 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25BC133CBD;
        Thu, 29 Sep 2022 01:49:05 -0700 (PDT)
Date:   Thu, 29 Sep 2022 10:48:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664441343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zM5eWlusI4fZeTPCTlJzvY2vl0b4z7Eo9YuNDNRRBfg=;
        b=w8KL9UJaiGZ6rWz/TPpHN7naUgaciFFyEvmIwoltT/LPc4XLtYjE/MblKXB0gTKuZ/kegP
        FZSLeSczifEN3rrwRG7tjjJqCldwsBokBeJru5d+KO0EayDeNbz69prIp4xan1MZSRDUx4
        738oa4Rn1gipk1Mu49eLl0kpAKi0uOg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 1/7] KVM: selftests: Implement memcmp(), memcpy(), and
 memset() for guest use
Message-ID: <20220929084855.26t6r6aaurm2caum@kamzik>
References: <20220928233652.783504-1-seanjc@google.com>
 <20220928233652.783504-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928233652.783504-2-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 28, 2022 at 11:36:46PM +0000, Sean Christopherson wrote:
> Implement memcmp(), memcpy(), and memset() to override the compiler's
> built-in versions in order to guarantee that the compiler won't generate
> out-of-line calls to external functions via the PLT.  This allows the
> helpers to be safely used in guest code, as KVM selftests don't support
> dynamic loading of guest code.
> 
> Steal the implementations from the kernel's generic versions, sans the
> optimizations in memcmp() for unaligned accesses.
> 
> Put the utilities in a separate compilation unit and build with
> -ffreestanding to fudge around a gcc "feature" where it will optimize
> memset(), memcpy(), etc... by generating a recursive call.  I.e. the
> compiler optimizes itself into infinite recursion.  Alternatively, the
> individual functions could be tagged with
> optimize("no-tree-loop-distribute-patterns"), but using "optimize" for
> anything but debug is discouraged, and Linus NAK'd the use of the flag
> in the kernel proper[*].
> 
> https://lore.kernel.org/lkml/CAHk-=wik-oXnUpfZ6Hw37uLykc-_P0Apyn2XuX-odh-3Nzop8w@mail.gmail.com
> 
> Cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: Anup Patel <anup@brainfault.org>
> Cc: Atish Patra <atishp@atishpatra.org>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          | 11 +++++-
>  .../selftests/kvm/lib/string_override.c       | 39 +++++++++++++++++++
>  2 files changed, 49 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/lib/string_override.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 8b1b32628ac8..681816df69cc 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -48,6 +48,8 @@ LIBKVM += lib/rbtree.c
>  LIBKVM += lib/sparsebit.c
>  LIBKVM += lib/test_util.c
>  
> +LIBKVM_STRING += lib/string_override.c
> +
>  LIBKVM_x86_64 += lib/x86_64/apic.c
>  LIBKVM_x86_64 += lib/x86_64/handlers.S
>  LIBKVM_x86_64 += lib/x86_64/perf_test_util.c
> @@ -221,7 +223,8 @@ LIBKVM_C := $(filter %.c,$(LIBKVM))
>  LIBKVM_S := $(filter %.S,$(LIBKVM))
>  LIBKVM_C_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_C))
>  LIBKVM_S_OBJ := $(patsubst %.S, $(OUTPUT)/%.o, $(LIBKVM_S))
> -LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ)
> +LIBKVM_STRING_OBJ := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBKVM_STRING))
> +LIBKVM_OBJS = $(LIBKVM_C_OBJ) $(LIBKVM_S_OBJ) $(LIBKVM_STRING_OBJ)
>  
>  EXTRA_CLEAN += $(LIBKVM_OBJS) cscope.*
>  
> @@ -232,6 +235,12 @@ $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
>  $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
>  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
>  
> +# Compile the string overrides as freestanding to prevent the compiler from
> +# generating self-referential code, e.g. with "freestanding" the compiler may
                                            ^ without

> +# "optimize" memcmp() by invoking memcmp(), thus causing infinite recursion.
> +$(LIBKVM_STRING_OBJ): $(OUTPUT)/%.o: %.c
> +	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c -ffreestanding $< -o $@
> +
>  x := $(shell mkdir -p $(sort $(dir $(TEST_GEN_PROGS))))
>  $(TEST_GEN_PROGS): $(LIBKVM_OBJS)
>  $(TEST_GEN_PROGS_EXTENDED): $(LIBKVM_OBJS)
> diff --git a/tools/testing/selftests/kvm/lib/string_override.c b/tools/testing/selftests/kvm/lib/string_override.c
> new file mode 100644
> index 000000000000..632398adc229
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/string_override.c
> @@ -0,0 +1,39 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <stddef.h>
> +
> +/*
> + * Override the "basic" built-in string helpers so that they can be used in
> + * guest code.  KVM selftests don't support dynamic loading in guest code and
> + * will jump into the weeds if the compiler decides to insert an out-of-line
> + * call via the PLT.
> + */
> +int memcmp(const void *cs, const void *ct, size_t count)
> +{
> +	const unsigned char *su1, *su2;
> +	int res = 0;
> +
> +	for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--) {
> +		if ((res = *su1 - *su2) != 0)
> +			break;
> +	}
> +	return res;
> +}
> +
> +void *memcpy(void *dest, const void *src, size_t count)
> +{
> +	char *tmp = dest;
> +	const char *s = src;
> +
> +	while (count--)
> +		*tmp++ = *s++;
> +	return dest;
> +}
> +
> +void *memset(void *s, int c, size_t count)
> +{
> +	char *xs = s;
> +
> +	while (count--)
> +		*xs++ = c;
> +	return s;
> +}
> -- 
> 2.37.3.998.g577e59143f-goog
> 

Otherwise

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
