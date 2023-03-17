Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC7F6BE58A
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 10:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjCQJ1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 05:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjCQJ1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 05:27:03 -0400
Received: from out-57.mta1.migadu.com (out-57.mta1.migadu.com [IPv6:2001:41d0:203:375::39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC05B857C
        for <kvm@vger.kernel.org>; Fri, 17 Mar 2023 02:27:01 -0700 (PDT)
Date:   Fri, 17 Mar 2023 10:26:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679045219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/RpwkAYXI01md8pQyDC8qagYEY7w9xDUXRlWvjCFW/E=;
        b=OUMCwLSYZj1a+oPVlMC3Hujb4v8sCb6iqSwBrE5P7UDit1M2lozLDfF4EEhlQF1n08Nf3q
        U701nmfPwNfjzv+Plpl85TRyRyn5kBzYeuONjrHa/2abGOUwI2UtaOUfLp1IPicgega5EE
        1DK0ioXskaMA7M3Y7fC88jlYxVRgx5k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Marc Zyngier <maz@kernel.org>, Ben Gardon <bgardon@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: selftests: Provide generic way to read
 system counter
Message-ID: <20230317092657.ldtxs3povjhbciq7@orel>
References: <20230316222752.1911001-1-coltonlewis@google.com>
 <20230316222752.1911001-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316222752.1911001-2-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 10:27:51PM +0000, Colton Lewis wrote:
> Provide a generic function to read the system counter from the guest
> for timing purposes. A common and important way to measure guest
> performance is to measure the amount of time different actions take in
> the guest. Provide also a mathematical conversion from cycles to
> nanoseconds and a macro for timing individual statements.
> 
> Substitute the previous custom implementation of a similar function in
> system_counter_offset_test with this new implementation.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  | 15 ++++++++++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 30 +++++++++++++++++++
>  .../kvm/system_counter_offset_test.c          | 10 ++-----
>  3 files changed, 47 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index c9286811a4cb..8b478eabee4c 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -10,4 +10,19 @@
>  #include "kvm_util_base.h"
>  #include "ucall_common.h"
> 
> +#if defined(__aarch64__) || defined(__x86_64__)
> +
> +uint64_t cycles_read(void);
> +double cycles_to_ns(struct kvm_vcpu *vcpu, double cycles);
> +
> +#define MEASURE_CYCLES(x)			\
> +	({					\
> +		uint64_t start;			\
> +		start = cycles_read();		\
> +		x;				\
> +		cycles_read() - start;		\
> +	})
> +
> +#endif
> +
>  #endif /* SELFTEST_KVM_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 3ea24a5f4c43..780481a92efe 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2135,3 +2135,34 @@ void __attribute((constructor)) kvm_selftest_init(void)
> 
>  	kvm_selftest_arch_init();
>  }
> +
> +#if defined(__aarch64__)
> +
> +#include "arch_timer.h"
> +
> +uint64_t cycles_read(void)
> +{
> +	return timer_get_cntct(VIRTUAL);
> +}
> +
> +double cycles_to_ns(struct kvm_vcpu *vcpu, double cycles)
> +{
> +	return cycles * (1e9 / timer_get_cntfrq());
> +}
> +
> +#elif defined(__x86_64__)
> +
> +#include "processor.h"
> +
> +uint64_t cycles_read(void)
> +{
> +	return rdtsc();
> +}
> +
> +double cycles_to_ns(struct kvm_vcpu *vcpu, double cycles)
> +{
> +	uint64_t tsc_khz = __vcpu_ioctl(vcpu, KVM_GET_TSC_KHZ, NULL);
> +
> +	return cycles * (1e9 / (tsc_khz * 1000));
> +}
> +#endif

Instead of the #ifdef's why not must put these functions in
lib/ARCH/processor.c?

Thanks,
drew
