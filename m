Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B408741AD5
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 23:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbjF1V12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 17:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbjF1V1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 17:27:08 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C1A273C
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 14:26:58 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-666edb1f24aso149012b3a.2
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 14:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687987618; x=1690579618;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pyzXbOu2iHo4bNrZ84ZYxz33c7D4C6GktNZyfo3X6aM=;
        b=HpN1PYNdPY/TJZ5TToHhNzbXA2YDAIY/osWwoYAOlOTConcfCvAH569VZKY7zEiLAe
         /ySERi+RKYmBC3SBn/xHlZA4kNAaTZwBf5a5+ZN5mCUppgIjFOgv1YQzsOZVS1fxz9N7
         +rh6vpQNm7bwESJSeu3K7Nh5Ticg9+BZIyeQ8S7yjZTLkLaagA0/k9HbPyMqrn0oNnqe
         X2BkejxA/B5ymwZ/77OuRjIlB8BHu7RdfzjSItEdNWqe+CYSc7zKJIb9Fqb5zXH2VnFF
         uDd5C14abUgSjpswkjJElLTTypZDAi8T/cnFJ1SHk24M6T/VU5Br6a3MsGbX4LYYzKP1
         fLhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687987618; x=1690579618;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pyzXbOu2iHo4bNrZ84ZYxz33c7D4C6GktNZyfo3X6aM=;
        b=e4uNyF6KnVqUoCzIg01nEydDz4x3QSq6Opkofpp7CdTFJQUku49CG7G31afGC03rVa
         ULovnVHki3lpoc78UW/owocJLfYRZ4MFTDNRM6rm+P6Jdnap7fEnmEm6T0ygUge2mQBf
         B6tsEu3kwRGYgkfteNdFdqGcUdduFxPahfMD0Y2ZxBdFMy7Ifqf/7RAZ7EAH3JailU3W
         FOhBBEKmk5AGT521a55A1VT8VI2XEXVSqnYnzeFBG6EzJmagSbnk4vWNF9DRlHMzMj6v
         MGb7AfJOTnqVpLb4TNCPP5KxmYN3Mu1JVgbt0Ne+0sA+f/wnJt6haIPXAyX2aU0XX9pL
         LasQ==
X-Gm-Message-State: AC+VfDxwZcP4CFAAGYnPRbHi6O5T7AZw3lfH/I29ahNQzRtg1Mu/y2NL
        sWuSWEUxKbTjC7cdTDGM1RuUpq+KJAI=
X-Google-Smtp-Source: ACHHUZ6SqBjL8WLU9ntWLkbW4cpGib2B3eVMnwt9ME+cviZdHbostKZ1xY1Ctml2JfDgOmQAQWfPSzavRuE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:399b:b0:681:fccf:dd4d with SMTP id
 fi27-20020a056a00399b00b00681fccfdd4dmr454659pfb.3.1687987618246; Wed, 28 Jun
 2023 14:26:58 -0700 (PDT)
Date:   Wed, 28 Jun 2023 14:26:56 -0700
In-Reply-To: <20230607123700.40229-3-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230607123700.40229-1-cloudliang@tencent.com> <20230607123700.40229-3-cloudliang@tencent.com>
Message-ID: <ZJyloBGvASSXldCy@google.com>
Subject: Re: [PATCH v3 2/4] KVM: selftests: Test unavailable event filters are rejected
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 07, 2023, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> This commit adds test cases for unsupported input values in the

Avoid "this commit" and "this patch", simply state what the patch does as a
command, e.g. "Add test cases for ...".

> PMU event filter. The tests cover unsupported "action" values,
> unsupported "flags" values, and unsupported "nevents" values.
> All these cases should return an error, as they are currently
> not supported by the filter. Additionally, the patch tests setting
> non-exist fixed counters in the fixed bitmap doesn't fail.
> 
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>  .../kvm/x86_64/pmu_event_filter_test.c        | 48 +++++++++++++++++--
>  1 file changed, 45 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index 26f674c32cde..7555e0f4290c 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -11,9 +11,7 @@
>   */
>  
>  #define _GNU_SOURCE /* for program_invocation_short_name */
> -#include "test_util.h"
> -#include "kvm_util.h"
> -#include "processor.h"
> +#include "pmu.h"
>  
>  /*
>   * In lieu of copying perf_event.h into tools...
> @@ -32,6 +30,10 @@
>  #define MAX_FILTER_EVENTS	300
>  #define MAX_TEST_EVENTS	10
>  
> +#define PMU_EVENT_FILTER_INVALID_ACTION		(KVM_PMU_EVENT_DENY + 1)
> +#define PMU_EVENT_FILTER_INVALID_FLAGS			(KVM_PMU_EVENT_FLAG_MASKED_EVENTS + 1)
> +#define PMU_EVENT_FILTER_INVALID_NEVENTS		(MAX_FILTER_EVENTS + 1)
> +
>  /*
>   * This is how the event selector and unit mask are stored in an AMD
>   * core performance event-select register. Intel's format is similar,
> @@ -762,6 +764,7 @@ static void test_filter_ioctl(struct kvm_vcpu *vcpu)
>  {
>  	uint64_t e = ~0ul;
>  	int r;
> +	struct __kvm_pmu_event_filter f;

Reverse xmas tree.

>  
>  	/*
>  	 * Unfortunately having invalid bits set in event data is expected to
> @@ -780,6 +783,45 @@ static void test_filter_ioctl(struct kvm_vcpu *vcpu)
>  					KVM_PMU_EVENT_FLAG_MASKED_EVENTS,
>  					KVM_PMU_EVENT_ALLOW);
>  	TEST_ASSERT(r == 0, "Valid PMU Event Filter is failing");
> +
> +	/*
> +	 * Testing unsupported "action" input values should return an error.

Omit the "Testing", KVM's behavior isn't specific to "testing", any unsupported
action should fail.

	/* Unsupported actions should be rejected by KVM. */

Though honestly, I would forego the comments entirely, the macro name plus the
assert make it quite clear what's being tested.

> +	 * Currently, only values 0 or 1 are supported.

Drop this part of the comment, it will become stale if PMU_EVENT_FILTER_INVALID_ACTION
is modified, and readers can look at the definition of PMU_EVENT_FILTER_INVALID_ACTION
if they really care about the actual value.

> +	 */
> +	f = base_event_filter;
> +	f.action = PMU_EVENT_FILTER_INVALID_ACTION;
> +	r = do_vcpu_set_pmu_event_filter(vcpu, &f);
> +	TEST_ASSERT(r != 0, "Set invalid action is expected to fail.");

Ignore the bad precedent set by this test, the preferred way to check for 0 and
!0 is TEST_ASSERT(r, ...) and TEST_ASSERT(!r, ...);

And no punctuation in the assert, i.e. drop the period.

> +
> +	/*
> +	 * Testing unsupported "flags" input values should return an error.
> +	 * Currently, only values 0 or 1 are supported.
> +	 */

Same here.

> +	f = base_event_filter;
> +	f.flags = PMU_EVENT_FILTER_INVALID_FLAGS;
> +	r = do_vcpu_set_pmu_event_filter(vcpu, &f);
> +	TEST_ASSERT(r != 0, "Set invalid flags is expected to fail.");
> +
> +	/*
> +	 * Testing unsupported "nevents" input values should return an error.
> +	 * Currently, only values less than or equal to
> +	 * MAX_FILTER_EVENTS are supported.

And here.

> +	 */
> +	f = base_event_filter;
> +	f.nevents = PMU_EVENT_FILTER_INVALID_NEVENTS;
> +	r = do_vcpu_set_pmu_event_filter(vcpu, &f);
> +	TEST_ASSERT(r != 0,
> +		    "Setting PMU event filters that exceeds the maximum supported value should fail");

To avoid splitting lines,

	TEST_ASSERT(r, "Exceeding the max number of filter events should fail");
> +
> +	/*
> +	 * In this case, setting non-exist fixed counters in the fixed bitmap
> +	 * doesn't fail.
> +	 */

And here.

> +	f = base_event_filter;
> +	f.fixed_counter_bitmap = ~GENMASK_ULL(X86_INTEL_MAX_FIXED_CTR_NUM, 0);
> +	r = do_vcpu_set_pmu_event_filter(vcpu, &f);
> +	TEST_ASSERT(r == 0,
> +		    "Setting invalid or non-exist fixed cunters in the fixed bitmap fail.");

Something like so to avoid multiple lines.

	TEST_ASSERT(!r, "Masking non-existent fixed counters should be allowed");
