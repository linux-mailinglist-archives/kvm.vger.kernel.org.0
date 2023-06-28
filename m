Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD157419F9
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 23:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbjF1VCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 17:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbjF1VBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 17:01:54 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB61E195
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 14:01:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bfe702f99b8so140777276.1
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 14:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687986113; x=1690578113;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zAdU4qXPSUkOZjySjJgyPMDSkwNgAW9dwq8obwhFF/E=;
        b=pyVELHnWd+/RblILdNwfILju2YBbjtM18OHPwCsDW0+ne4lrWD/ThAjecXrI/QuyNJ
         p4t2BoQUD/sPFmA3DRGODaHLu/ufFEuc11P+duNwBtpjAOedje2yqH9pmSRXFXlVSYQu
         HhirY+9XukPAGtwiNN37dBui3xsmpezX183zo1m1L2ZTG+eGXenzj3WQEMla5RfaJ4Dc
         6ClcEBPtz2yFDdjD6RDqwMlYI8DhoS60xkQL/kxAvJNFvWWUu56C5sj8A/2qvlhpFWuM
         FSvd5tCGaKz54EiUehYk2BF9mfgNfpiejvH/lf1Ud+yVNtV2TlPGFv1GcB/RB88uN+f+
         /lPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687986113; x=1690578113;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zAdU4qXPSUkOZjySjJgyPMDSkwNgAW9dwq8obwhFF/E=;
        b=Z0FUlPgMof36AONk5jruYkzauf6i2WB4oYDH3AqROfZwfueN7qoAcI0GKjRqTpKwR2
         lI03Hs1hq6HO3e+jWVmkmIV3IX1JbkR7/8KBRTJQaRnIA6VU7nPomHsWdlU0Msdb0n5m
         Hu+JFR9Z5TZiG3PuwjYb1mlnEOQ1/EsyM6X4WlIUb1zsNF+g3b4iR+loLH2GGnBuwO31
         eAyLmErNBbilvGLguzewT6aifOD+ce4f4zup865AZFbnBvO7HcbQgc7lc7ruxHXZUoUs
         ttKTTgL5Exi567c9UHsSX/AYr2GBr5/OoimUGTjXjm62LXc1nOgZ3iALwOAMdogOKtAv
         nUjg==
X-Gm-Message-State: AC+VfDz5dbbO3PL0D0jAkSsJ/3QkTJW/govPBFKM50jxLuHsOdDNvQwP
        UaWhzvZxkSzc0CgHwP9/SQapkndrVcg=
X-Google-Smtp-Source: ACHHUZ4yhY/CGZwUbA5ja/LiKlFUteS+fedo4a1ySqmTMe6ZqhcSkqg6JlDBiIW5EjkYfmEnMdCWBPXaniU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4f1:b0:c15:cbd1:60d6 with SMTP id
 w17-20020a05690204f100b00c15cbd160d6mr3625214ybs.5.1687986112965; Wed, 28 Jun
 2023 14:01:52 -0700 (PDT)
Date:   Wed, 28 Jun 2023 14:01:51 -0700
In-Reply-To: <20230530134248.23998-7-cloudliang@tencent.com>
Mime-Version: 1.0
References: <20230530134248.23998-1-cloudliang@tencent.com> <20230530134248.23998-7-cloudliang@tencent.com>
Message-ID: <ZJyfv+9eQXqdxlOP@google.com>
Subject: Re: [PATCH v2 6/8] KVM: selftests: Test consistency of CPUID with num
 of fixed counters
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> Add test to check if non-existent counters can be accessed in guest after
> determining the number of Intel generic performance counters by CPUID.
> Per SDM, fixed-function performance counter 'i' is supported if ECX[i] ||
> (EDX[4:0] > i). KVM doesn't emulate more counters than it can support.
> 
> Co-developed-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---
>  .../kvm/x86_64/pmu_basic_functionality_test.c | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
> index 116437ac2095..e19f8c2774c5 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_basic_functionality_test.c
> @@ -228,10 +228,46 @@ static void test_oob_gp_counter(uint8_t eax_gp_num, uint8_t offset,
>  	kvm_vm_free(vm);
>  }
>  
> +static void intel_test_oob_fixed_ctr(uint8_t edx_fix_num,
> +				     uint32_t fixed_bitmask, uint64_t expected)
> +{
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_cpuid_entry2 *entry;
> +	uint8_t idx = edx_fix_num;
> +	bool visible;
> +	uint64_t msr_val;
> +
> +	vm = pmu_vm_create_with_one_vcpu(&vcpu, guest_wr_and_rd_msrs);
> +
> +	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
> +	entry->ecx = fixed_bitmask;
> +	entry->edx = (entry->edx & ~FIXED_CTR_NUM_MASK) | edx_fix_num;
> +	vcpu_set_cpuid(vcpu);
> +
> +	/* Per Intel SDM, FxCtr[i]_is_supported := ECX[i] || (EDX[4:0] > i). */
> +	visible = (entry->ecx & BIT_ULL(idx) ||
> +			((entry->edx & FIXED_CTR_NUM_MASK) > idx));

Add a helper (in pmu.h) for this one too.

> +	/* KVM doesn't emulate more fixed counters than it can support. */
> +	if (idx >= X86_INTEL_MAX_FIXED_CTR_NUM)
> +		visible = false;
> +
> +	vcpu_args_set(vcpu, 4, MSR_CORE_PERF_FIXED_CTR0, 0xffff, idx, 1);
> +	if (!visible)

Curly braces need around a multi-line statement.

> +		while (run_vcpu(vcpu, &msr_val) != UCALL_DONE)
> +			TEST_ASSERT(msr_val == expected,
> +				    "Unexpected when testing fixed counter num.");

ASSERT_EQ() will print the expected versus actually for you.
