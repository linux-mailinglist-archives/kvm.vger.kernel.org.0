Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B5971011E
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 00:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237688AbjEXWrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 18:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233206AbjEXWrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 18:47:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A01A9
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 15:47:50 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba81b37d9d2so2921992276.3
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 15:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684968469; x=1687560469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nbe6OtVcUPxczQM57C3LpNJd555KRAb+CyeDnNjTKfI=;
        b=C2+GLFSvfvUY+ogqFZ9w3cMWaPFjffYN8oJkpbRr0rrG1wSejtn3y6ymL+POQ8r6Es
         fxqtnIZigznkvAEf2a5ZBHssQfHZbHEdxeWZszreq94nQJfOzDaZ4BwV1JMSr4f7+lEN
         Le+/amZm8mjbpwBc7Jrghq2lpX3vGx8OTwgc26lvj/8i3G0EfEKiwWU31dBmSIJKBMX9
         OJgLgBo5ibycJ5avTz6AHzaEAiauwaLMfZcQ4QoD5CAjXx2JTEX9wfmgEIUtS40EEIqG
         HtNUlQRGDCpdraaGuNJi6qh8bnwIOTTE/TlTrykjrA4yb6Y++YeUnesKuZ2IktZ/2E60
         4eeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684968469; x=1687560469;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nbe6OtVcUPxczQM57C3LpNJd555KRAb+CyeDnNjTKfI=;
        b=WIlH3QLWka3Jjnz+lzxgkPSRf+AFvowdnUidtYhlFm/DsC63FbP7zu/U+0LYIyiwdi
         h8oOq05Lpfl6//0MQR5Swob5ftOQF4Vzh0fPGlsvm6MIoLSYHRdXGaUBaOXWkXgHuum5
         cRjkrjEk/oPniSDQDPROEM8FcuXrI5Q38hfW6Xe2M2WMUHx4SNhqjgClyezgCVUvSWTU
         6FZq/BreOkEiaTu8w8/zK3vv/sI/8tjMJe1lDvQKv15OWlXs9YuBQyDuc/4UqrGeC8bf
         h/t2eglUvyWSdPN+U2HDN+30yen56DzCrp1zwwJXDFniKkHfdoy+w2tGqpRgqhirZ2f3
         eTpA==
X-Gm-Message-State: AC+VfDyZkucuVGnKH+FIY/4ie1UoIO5uvV49VX6LG+PFcH41yK1+cJFq
        I7xIFAZCZGOfNkkyIrjWJKmOz1a3FmU=
X-Google-Smtp-Source: ACHHUZ69rT0NeUIYswasJvAj9nqXrzqfndnKw1Cnbcg5hue8HAciQeC+6iYj/RorZn2zT3XLh8QnnSHLFwk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9388:0:b0:ba8:6dc0:cacf with SMTP id
 a8-20020a259388000000b00ba86dc0cacfmr617554ybm.12.1684968469589; Wed, 24 May
 2023 15:47:49 -0700 (PDT)
Date:   Wed, 24 May 2023 15:47:47 -0700
In-Reply-To: <20230323072714.82289-5-likexu@tencent.com>
Mime-Version: 1.0
References: <20230323072714.82289-1-likexu@tencent.com> <20230323072714.82289-5-likexu@tencent.com>
Message-ID: <ZG6UE2vAGAhJIIkq@google.com>
Subject: Re: [PATCH 4/7] KVM: selftests: Test consistency of CPUID with num of
 Fixed counters
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023, Like Xu wrote:
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
>  .../selftests/kvm/x86_64/pmu_cpuid_test.c     | 68 +++++++++++++++++++
>  1 file changed, 68 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
> index 50902187d2c9..c934144be287 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
> @@ -74,6 +74,22 @@ static uint8_t kvm_gp_ctrs_num(void)
>  	return (kvm_entry->eax & GP_CTR_NUM_MASK) >> GP_CTR_NUM_OFS_BIT;
>  }
>  
> +static uint8_t kvm_fixed_ctrs_num(void)
> +{
> +	const struct kvm_cpuid_entry2 *kvm_entry;
> +
> +	kvm_entry = get_cpuid_entry(kvm_get_supported_cpuid(), 0xa, 0);
> +	return kvm_entry->edx & FIXED_CTR_NUM_MASK;
> +}
> +
> +static uint32_t kvm_fixed_ctrs_bitmask(void)
> +{
> +	const struct kvm_cpuid_entry2 *kvm_entry;
> +
> +	kvm_entry = get_cpuid_entry(kvm_get_supported_cpuid(), 0xa, 0);
> +	return kvm_entry->ecx;
> +}

KVM_X86_CPU_PROPERTY

>  static struct kvm_vcpu *new_vcpu(void *guest_code)
>  {
>  	struct kvm_vm *vm;
> @@ -230,6 +246,39 @@ static void test_oob_gp_counter_setup(struct kvm_vcpu *vcpu, uint8_t eax_gp_num,
>  	vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_gp_handler);
>  }
>  
> +static uint64_t test_oob_fixed_counter_setup(struct kvm_vcpu *vcpu,
> +					     uint8_t edx_fix_num,
> +					     uint32_t fixed_bitmask)
> +{
> +	struct kvm_cpuid_entry2 *entry;
> +	uint32_t ctr_msr = MSR_CORE_PERF_FIXED_CTR0;
> +	uint8_t idx = edx_fix_num;
> +	bool is_supported = true;

No need to initialize "true", it's explicitly set below.

> +	uint64_t ret = 0xffffULL;
> +
> +	entry = vcpu_get_cpuid_entry(vcpu, 0xa);
> +	entry->ecx = fixed_bitmask;
> +	entry->edx = (entry->edx & ~FIXED_CTR_NUM_MASK) | edx_fix_num;
> +	vcpu_set_cpuid(vcpu);
> +
> +	/* Per Intel SDM, FixCtr[i]_is_supported := ECX[i] || (EDX[4:0] > i). */
> +	is_supported = (entry->ecx & BIT_ULL(idx) ||
> +			((entry->edx & FIXED_CTR_NUM_MASK) > idx));
> +
> +	/* KVM doesn't emulate more fixed counters than it can support. */
> +	if (idx >= kvm_fixed_ctrs_num())
> +		is_supported = false;

Why not this?

	is_supported = idx < kvm_fixed_ctrs_num() &&
		       <CPUID entry stuff>;
> +
> +	if (!is_supported) {
> +		vm_install_exception_handler(vcpu->vm, GP_VECTOR, guest_gp_handler);
> +		ret = GP_VECTOR;
> +	}

Same comments as the previous patch(es).
