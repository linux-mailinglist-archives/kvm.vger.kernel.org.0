Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219917D1617
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 21:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjJTTHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 15:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbjJTTG4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 15:06:56 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B65FD63
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 12:06:54 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7aa161b2fso15147557b3.2
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 12:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697828813; x=1698433613; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WJMiGrIhknpVYB+lLA3TXzIajTqOeaWLMLUUQN9BbMk=;
        b=Wmj6A+bLcsIAm1sAyB9SiKTyAe/xF4yGTsuzgHhla78U+m78X9HLczAgVW9fdt1hz4
         eUP/Ed9vn77cDvPwBq3mIS9g9tDknUcXszNrxz55l/hfRIE7/Ho6H2MVvgeZMqnp8Hu7
         VUgFPcJwPA+v4HwRgt3f7YKej1k4zvL+CncCqGHJwEvc4qgkEAUhm9Ad9iKgfng7GHzh
         0NT5gLdiEeLXMYNmxZi5TOrMBPwLMsYVNWt36c+s5UPIa9TBBxfUBNPrYt3QaWaYVM+p
         kOCzH7QUvDm0jL82WgX/3W+cGsu3FuHrfFY69jfoWX77YjnW5phMe/oYTHjEQabilxN0
         w10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697828813; x=1698433613;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WJMiGrIhknpVYB+lLA3TXzIajTqOeaWLMLUUQN9BbMk=;
        b=vXmnrBDu0eQW2Ec6/jUBgIB/SGXqHc8mLmEFDTJNj1tXzfT5FFXoU4mNfcU/q9y4Mg
         ZgFiM2mBkYw+qYcGgvIEqhGd+oQkahVvaPTl8FU0sT6AhADCLvMgbugazS9UWIz+g6Kw
         zy4g9bLD7U7GpjfchesAv2JVuvua0W5amN//qPh2h+7sq2VxSuvDLVP6OZeKPAhpU/D/
         dyaY4cH83hC9Q2SElBiVzYwRiS5vr6VS5Tpvg2cKii8fhmp7wwPD0meuvkcMGgSeHhRn
         B3LO4zhhV+eumNYpM4gBGdrmcvL18p8Tf7jVyE2txCgsputsTjS/GBmMia67+UsfZWz+
         mneQ==
X-Gm-Message-State: AOJu0Yw/zZRDNzKaLqNKJV8H6M+5w9xImhBQ5kBo+bgDi5IFnGN+ThGZ
        5DxHwFuJQmanONuKneoaQwlucBjTQms=
X-Google-Smtp-Source: AGHT+IGIgsmKl9/EeQe6qAywriK9UwbK/k300V7nBKfGTSYuUwbuxCBVs3ZRc3wOXbeQIlmP3vxDbl1J5EU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d05:0:b0:d9a:5b63:a682 with SMTP id
 5-20020a250d05000000b00d9a5b63a682mr51644ybn.13.1697828813642; Fri, 20 Oct
 2023 12:06:53 -0700 (PDT)
Date:   Fri, 20 Oct 2023 12:06:51 -0700
In-Reply-To: <20230911114347.85882-9-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230911114347.85882-1-cloudliang@tencent.com> <20230911114347.85882-9-cloudliang@tencent.com>
Message-ID: <ZTLPy9SYzJmgMxw9@google.com>
Subject: Re: [PATCH v4 8/9] KVM: selftests: Test Intel supported fixed
 counters bit mask
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Like Xu <likexu@tencent.com>,
        David Matlack <dmatlack@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 11, 2023, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> Add a test to check that fixed counters enabled via guest
> CPUID.0xA.ECX (instead of EDX[04:00]) work as normal as usual.
> 
> Co-developed-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>  .../selftests/kvm/x86_64/pmu_counters_test.c  | 54 +++++++++++++++++++
>  1 file changed, 54 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> index df76f0f2bfd0..12c00bf94683 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -301,6 +301,59 @@ static void test_intel_counters_num(void)
>  	test_oob_fixed_ctr(nr_fixed_counters + 1);
>  }
>  
> +static void fixed_counters_guest_code(void)
> +{
> +	uint64_t supported_bitmask = this_cpu_property(X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK);
> +	uint32_t nr_fixed_counter = this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
> +	uint64_t msr_val;
> +	unsigned int i;
> +	bool expected;
> +
> +	for (i = 0; i < nr_fixed_counter; i++) {
> +		expected = supported_bitmask & BIT_ULL(i) || i < nr_fixed_counter;
> +
> +		wrmsr_safe(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
> +		wrmsr_safe(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
> +		wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(PMC_IDX_FIXED + i));
> +		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
> +		wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> +		rdmsr_safe(MSR_CORE_PERF_FIXED_CTR0 + i, &msr_val);

Y'all are making this way harder than it needs to be.  The previous patch already
created a testcase to verify fixed counters, just use that!  Then test case verify
that trying to enable unsupported fixed counters results in #GP, as opposed to the
above which doesn't do any actual checking, e.g. KVM could completely botch the
{RD,WR}MSR emulation but pass the test by not programming up a counter in perf.

I.e. rather than have a separate test for the supported bitmask goofiness, have
the fixed counters test iterate over the bitmask.  And then add a patch to verify
the counters can be enabled and actually count.

And peeking ahead at the vPMU version test, it's the exact same story there.
Instead of hardcoding one-off tests, iterate on the version.  The end result is
that the test provides _more_ coverage with _less_ code.  And without any of the
hardcoded magic that takes a crystal ball to understand.

*sigh* 

And even more importantly, this test is complete garbage.  The SDM clearly states
that 

  With Architectural Performance Monitoring Version 5, register CPUID.0AH.ECX
  indicates Fixed Counter enumeration. It is a bit mask which enumerates the
  supported Fixed Counters in a processor. If bit 'i' is set, it implies that
  Fixed Counter 'i' is supported.

*sigh*

The test passes because it only iterates over counters < nr_fixed_counter.  So
as written, the test worse than useless.  It provides no meaningful value and is
actively misleading.

	for (i = 0; i < nr_fixed_counter; i++) {

Maybe I haven't been explicit enough: the point of writing tests is to find and
prevent bugs, not to get the tests passing.  That isn't to say we don't want a
clean testgrid, but writing a "test" that doesn't actually test anything is a
waste of everyone's time.

I appreciate that the PMU is subtle and complex (understatement), but things like
this, where observing that the result of "supported_bitmask & BIT_ULL(i)" doesn't
actually affect anything, doesn't require PMU knowledge.

	for (i = 0; i < nr_fixed_counter; i++) {                                
		expected = supported_bitmask & BIT_ULL(i) || i < nr_fixed_counter;

A concrete suggestion for writing tests: introduce bugs in what you're testing
and verify that the test actually detects the bugs.  If you tried to do that for
the above bitmask test you would have discovered you can't break KVM because KVM
doesn't support this!  And if your test doesn't detect the bugs, that should also
be a big clue that something isn't quite right.
