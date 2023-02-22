Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B231169EF97
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 08:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbjBVHut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 02:50:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjBVHup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 02:50:45 -0500
Received: from out-28.mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54F635251
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 23:50:43 -0800 (PST)
Date:   Wed, 22 Feb 2023 07:50:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677052241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J/fk+MeIWW89zx2K/F0d+4r3Hj9qGcFVA+uUnWcayb8=;
        b=Wle8bqCgQ3OEjfcD5GDmQ3TfLmXPO/267A1N8oPQBT1IUVpadyyDKWbjj82KXcljKIBZdR
        pK9ruEGxhY4ct0ktCYUR0sXCe9pHCZTY9bibovpUNOTb3teHXuOHmSaMRtiyCxEC8NApSG
        vc+RR8gnKzV3sxRY8B2KzfhmjNcFFSE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        David Matlack <dmatlack@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Provide generic way to read system
 counter
Message-ID: <Y/XJTGydjLCGKqRz@linux.dev>
References: <20230221232740.387978-1-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221232740.387978-1-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Colton,

On Tue, Feb 21, 2023 at 11:27:40PM +0000, Colton Lewis wrote:
> Provide a generic function to read the system counter from the guest
> for timing purposes. An increasingly common and important way to
> measure guest performance is to measure the amount of time different
> actions take in the guest. Provide also a mathematical conversion from
> cycles to nanoseconds and a macro for timing individual statements.
> 
> Substitute the previous custom implementation of a similar function in
> system_counter_offset_test with this new implementation.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
> 
> These functions were originally part of my patch to introduce latency
> measurements into dirty_log_perf_test. [1] Sean Christopherson
> suggested lifting these functions into their own patch in generic code
> so they can be used by any test. [2] Ricardo Koller suggested the
> addition of the MEASURE macro to more easily time individual
> statements. [3]
> 
> [1] https://lore.kernel.org/kvm/20221115173258.2530923-1-coltonlewis@google.com/
> [2] https://lore.kernel.org/kvm/Y8gfOP5CMXK60AtH@google.com/
> [3] https://lore.kernel.org/kvm/Y8cIdxp5k8HivVAe@google.com/

This patch doesn't make a great deal of sense outside of [1]. Can you
send this as part of your larger series next time around?

>  .../testing/selftests/kvm/include/test_util.h |  3 ++
>  tools/testing/selftests/kvm/lib/test_util.c   | 37 +++++++++++++++++++
>  .../kvm/system_counter_offset_test.c          | 10 +----
>  3 files changed, 42 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index 80d6416f3012..290653b99035 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -84,6 +84,9 @@ struct guest_random_state {
>  struct guest_random_state new_guest_random_state(uint32_t seed);
>  uint32_t guest_random_u32(struct guest_random_state *state);
> 
> +uint64_t guest_cycles_read(void);
> +double guest_cycles_to_ns(double cycles);
>
>  enum vm_mem_backing_src_type {
>  	VM_MEM_SRC_ANONYMOUS,
>  	VM_MEM_SRC_ANONYMOUS_THP,
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index 5c22fa4c2825..6d88132a0131 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -15,6 +15,11 @@
>  #include <linux/mman.h>
>  #include "linux/kernel.h"
> 
> +#if defined(__aarch64__)
> +#include "aarch64/arch_timer.h"
> +#elif defined(__x86_64__)
> +#include "x86_64/processor.h"
> +#endif

I believe we place 'include/$(ARCH)/' on the include path, so the
'x86_64' can be dropped.

>  #include "test_util.h"
> 
>  /*
> @@ -34,6 +39,38 @@ uint32_t guest_random_u32(struct guest_random_state *state)
>  	return state->seed;
>  }
> 
> +uint64_t guest_cycles_read(void)

Do we need the 'guest_' prefix in here? At least for x86 and arm64 the
same instructions can be used in host userspace and guest kernel for
accessing the counter.

> +{
> +#if defined(__aarch64__)
> +	return timer_get_cntct(VIRTUAL);
> +#elif defined(__x86_64__)
> +	return rdtsc();
> +#else
> +#warn __func__ " is not implemented for this architecture, will return 0"
> +	return 0;
> +#endif
> +}

I think it would be cleaner if each architecture just provided its own
implementation of this function instead of ifdeffery here.

If an arch doesn't implement the requisite helper then it will become
painfully obvious at compile time.

> +double guest_cycles_to_ns(double cycles)
> +{
> +#if defined(__aarch64__)
> +	return cycles * (1e9 / timer_get_cntfrq());
> +#elif defined(__x86_64__)
> +	return cycles * (1e9 / (KVM_GET_TSC_KHZ * 1000));

The x86 implementation is wrong. KVM_GET_TSC_KHZ is the ioctl needed
to get at the guest's TSC frequency (from the perpsective of host
userspace).

So at the very least this needs to do an ioctl on the VM fd to work out
the frequency. This is expected to be called in host userspace, right?

> +#else
> +#warn __func__ " is not implemented for this architecture, will return 0"
> +	return 0.0;
> +#endif
> +}
> +
> +#define MEASURE_CYCLES(x)			\
> +	({					\
> +		uint64_t start;			\
> +		start = guest_cycles_read();	\
> +		x;				\
> +		guest_cycles_read() - start;	\
> +	})
> +
>  /*
>   * Parses "[0-9]+[kmgt]?".
>   */
> diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
> index 7f5b330b6a1b..39b1249c7404 100644
> --- a/tools/testing/selftests/kvm/system_counter_offset_test.c
> +++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
> @@ -39,14 +39,9 @@ static void setup_system_counter(struct kvm_vcpu *vcpu, struct test_case *test)
>  			     &test->tsc_offset);
>  }
> 
> -static uint64_t guest_read_system_counter(struct test_case *test)
> -{
> -	return rdtsc();
> -}
> -
>  static uint64_t host_read_guest_system_counter(struct test_case *test)
>  {
> -	return rdtsc() + test->tsc_offset;
> +	return guest_cycles_read() + test->tsc_offset;

The 'guest_' part is rather confusing here. What this function is really
trying to do is read the counter from host userspace and apply an offset
to construct the expected value for the test.

It all compiles down to the same thing, but as written is seemingly
wrong.

-- 
Thanks,
Oliver
