Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADD07D0596
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 01:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346721AbjJSXzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 19:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbjJSXze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 19:55:34 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2902114
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 16:55:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d86766bba9fso250835276.1
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 16:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697759728; x=1698364528; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VT3/dh9UAKVu/RjZAMlDFfIDIF9ioyj3Z5qJzNl9A0E=;
        b=q7hX96F2Eba7a+r+lS2/QCVAGPaOaAVcCTFhOI6xzb0yRoO0Ci/pSATynAWpSZwqNZ
         AKuDG8uVfKmLYGmJ+VEQvmzgPP7xyIYTkgNNh+n8NUoOv41uYUMAiFOtafnVfuUE4eXF
         ro9h/4+6CpH1QER77q0j0eHmIHLhjjdOCeSDkwI7nV8CSA2qUPpXGcoIFk2tHRuq/Qyx
         g+geVjWfU56adJ/JgM93G0bb1uBepUG4rk3qAi44nW9JSbSGh/M6ByGRSCNxfD+CwgYl
         kNresMNT//hgv9Yg9PqLiSQ2YI7rUMS5mMzhtpz7q5IgomEToQw6DCvK0dv260kL/PL4
         ihUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697759728; x=1698364528;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VT3/dh9UAKVu/RjZAMlDFfIDIF9ioyj3Z5qJzNl9A0E=;
        b=LqajVJC+Yrb1Cqo5tj01BgquYvgF71xFmJqJ9WyHCP/5LqfMaoWgZ4zhNNn/QPOgQF
         eTlzl4ixKSmgUuLqb8mDQhgFcWvVAHNpNNQrNQDHU2095HWJC4naR51ZnoXa0YhIgK6u
         HEnx86Q6xgWqQdOorERZ0b90mY3T0K+t30iFEZwV4NIUwZQ9ZZyU/oZt30uxysyj/+uw
         VvgU+9d0kkvPcUnT/5pUV1IUM9/yZyaDjl9EVIcIEKAtMbo9ZsTbjsJePZTWlRbSQ3qp
         Kj/OaRxryD6o9eZFXNyolLc2m9RXaQs/9AweldGtJBqLjtl/S+cd7Ycpj7AIJvXfk2xw
         RzHw==
X-Gm-Message-State: AOJu0Yz27fBQHFcgfRAzuxqoDjkEIdOSmOS1aj9FQNAkkx7/hiBpA4CE
        NdcpXWkVIUfrnyq6C6tG6kXR2y55hHk=
X-Google-Smtp-Source: AGHT+IHZrJQjP9f5UAqT8B8i5/S+Wo6M6T0lWykyNkZvtfWkECs63EluSCkUjO3uzi/5x+WjjG7L2HusUKQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:134a:b0:d9a:c588:38a with SMTP id
 g10-20020a056902134a00b00d9ac588038amr7876ybu.4.1697759728085; Thu, 19 Oct
 2023 16:55:28 -0700 (PDT)
Date:   Thu, 19 Oct 2023 16:55:26 -0700
In-Reply-To: <20230911114347.85882-6-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230911114347.85882-1-cloudliang@tencent.com> <20230911114347.85882-6-cloudliang@tencent.com>
Message-ID: <ZTHB7sMqV1WlWpzf@google.com>
Subject: Re: [PATCH v4 5/9] KVM: selftests: Test Intel PMU architectural
 events on fixed counters
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 11, 2023, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> Update test to cover Intel PMU architectural events on fixed counters.
> Per Intel SDM, PMU users can also count architecture performance events
> on fixed counters (specifically, FIXED_CTR0 for the retired instructions
> and FIXED_CTR1 for cpu core cycles event). Therefore, if guest's CPUID
> indicates that an architecture event is not available, the corresponding
> fixed counter will also not count that event.
> 
> Co-developed-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>  .../selftests/kvm/x86_64/pmu_counters_test.c  | 22 +++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> index f47853f3ab84..fe9f38a3557e 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -106,6 +106,28 @@ static void guest_measure_loop(uint8_t idx)
>  		GUEST_ASSERT_EQ(expect, !!_rdpmc(i));
>  	}
>  
> +	if (this_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS) < 1)

The ENTIRE point of reworking this_pmu_has() to be able to query fixed counters
was to avoid having to open code checks like this.  And this has no basis in
reality, the fixed counters aren't all-or-nothing, e.g. if the number of fixed
counters is '1', then the below will explode because the test will try to write
a non-existent MSR.

> +		goto done;
> +
> +	if (idx == INTEL_ARCH_INSTRUCTIONS_RETIRED)
> +		i = 0;
> +	else if (idx == INTEL_ARCH_CPU_CYCLES)
> +		i = 1;
> +	else if (idx == PSEUDO_ARCH_REFERENCE_CYCLES)
> +		i = 2;
> +	else
> +		goto done;
> +
> +	wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
> +	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
> +
> +	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(PMC_IDX_FIXED + i));
> +	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
> +	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
> +
> +	GUEST_ASSERT_EQ(expect, !!_rdpmc(PMC_FIXED_RDPMC_BASE | i));

Pulling in context from the previous patch, "expect" is set based on the existence
of the architectural event in CPUID.0xA.EBX.  That is completely bogus, especially
for TSC reference cycles which has been incorrectly aliased to Topdown Slots.

	expect = this_pmu_has_arch_event(KVM_X86_PMU_FEATURE(UNUSED, idx));

Nothing in the SDM says that an event that's marked unavailable in CPUID.0xA.EBX
magically makes the fixed counter not work.  It's a rather bogus CPUID, e.g. I
can't imagine real hardware has any such setup, but silently not counting is most
definitely not correct.

Digging around in KVM, I see that KVM _deliberately_ provides this behavior.  That
is just bogus.  If the guest can enable a fixed counter, then it should count.
*If* the interpretation of the SDM is that the fixed counter isn't available when
the associated architectural event isn't available, then the most sane behavior
is to not allow the fixed counter to be enabled in the first place.  Silently
doing nothing is awful.  And again the whole Topdown Slots vs. TSC ref cycles
confusion means this is completely broken regardless of how one interprets the
SDM.

And the above on-demand creation of each KVM_X86_PMU_FEATURE() kinda defeats the
purpose of using well-known names.  Rather than smush everything into the general
purpose architectural events, which is definitely broken and arguably a straight
violation of the SDM, I think the best option is to loosely couple the GP vs.
fixed events so that we can reason about the high-level event type, e.g. to
determine which events are "stable" enough to assert on.

It's not the prettiest due to not being able to directly compare structs, but it
at least allows checking for architectural events vs. fixed counters independently,
without completely losing the common bits.

#define X86_PMU_FEATURE_NULL						\
({									\
	struct kvm_x86_pmu_feature feature = {};			\
									\
	feature;							\
})

static bool pmu_is_null_feature(struct kvm_x86_pmu_feature event)
{
	return !(*(u64 *)&event);
}

static void guest_measure_loop(uint8_t idx)
{
	const struct {
		struct kvm_x86_pmu_feature gp_event;
		struct kvm_x86_pmu_feature fixed_event;
	} intel_event_to_feature[] = {
		[INTEL_ARCH_CPU_CYCLES]		   = { X86_PMU_FEATURE_CPU_CYCLES, X86_PMU_FEATURE_CPU_CYCLES_FIXED },
		[INTEL_ARCH_INSTRUCTIONS_RETIRED]  = { X86_PMU_FEATURE_INSNS_RETIRED, X86_PMU_FEATURE_INSNS_RETIRED_FIXED },
		/*
		 * Note, the fixed counter for reference cycles is NOT the same
		 * as the general purpose architectural event (because the GP
		 * event is garbage).  The fixed counter explicitly counts at
		 * the same frequency as the TSC, whereas the GP event counts
		 * at a fixed, but uarch specific, frequency.  Bundle them here
		 * for simplicity.
		 */
		[INTEL_ARCH_REFERENCE_CYCLES]	   = { X86_PMU_FEATURE_REFERENCE_CYCLES, X86_PMU_FEATURE_REFERENCE_CYCLES_FIXED },
		[INTEL_ARCH_LLC_REFERENCES]	   = { X86_PMU_FEATURE_LLC_REFERENCES, X86_PMU_FEATURE_NULL },
		[INTEL_ARCH_LLC_MISSES]		   = { X86_PMU_FEATURE_LLC_MISSES, X86_PMU_FEATURE_NULL },
		[INTEL_ARCH_BRANCHES_RETIRED]	   = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED, X86_PMU_FEATURE_NULL },
		[INTEL_ARCH_BRANCHES_MISPREDICTED] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED, X86_PMU_FEATURE_NULL },
	};
