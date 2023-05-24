Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08501710114
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 00:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236126AbjEXWo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 18:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjEXWo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 18:44:27 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F64B3
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 15:44:26 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56552a72cfbso30182117b3.3
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 15:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684968265; x=1687560265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u/CXXBIdkc2EUWI9FdP+3T0l7JfPBl9qwpAD8Vm30VE=;
        b=rE3+GKdTj+oT0WZYTzb2ULdVN9NydNiHgadds2HDOan1rx47CPs/0ZdS6horBaXdNl
         xbgwYDLe/QC+xbi8bhq7RzcuJk37rjdMrIYYfKSuTli9+fqkDIMQXVRuLKSVNPv6g2FR
         cPQc8nOAgwrXh04dTAffxZuHnUinu+jESKPOjXpTVoITgQXYpMmlubcEwIvpohinRLkw
         Qh7rRKwvehB2Soj1bGEtiyeNUpYdevfZn142mlar2Wh8L/Hkc3QHUe5l23MHioRh7PUi
         QVvkiDK/+30y64BDripRorK5/XfMOHzResQDGr99eoVxJQnR2xPpi00nnC54CmISyGls
         oWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684968265; x=1687560265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u/CXXBIdkc2EUWI9FdP+3T0l7JfPBl9qwpAD8Vm30VE=;
        b=A6b3vr0sXipty3Hm/R85rgXkT5SyZpNV+f2bo12/3zNKsD8A2T5EIf8uZccInMc4z2
         s3gPOSbAJz4s+YE+jJuh4GzEtgvxq9Gy9rlHqnadzuwBl/gZn/umGUse5EAEDAeSp4yU
         8XnZw0qb3Kz21QAoZl80wWO8WVVzdrEMdPkFdx32/x2hCaZmjKiN9ulEm8peoc5m4YK0
         SlXMuDFka41/tGLLUljX3unLZXIkpW/tzPwSwxELLwDr3jyjSqw/uZ4XvKZ28I5DHH5V
         u3JCNe8qNkv/+188z+i+tsxRBCwYpm0OH59vbUsQ5Ki8VWS0tkZNeLKDpBCM7YouaO1D
         dlRg==
X-Gm-Message-State: AC+VfDzhsTNxk0Vu+A97a8rq4R8Ld3YrV53m+Orn2kI8ThTEwf2X/Y7R
        irhIbH4tw1bPN6P5U9yHH3nVSeiXBbA=
X-Google-Smtp-Source: ACHHUZ4yWRb7BF8eNmMVVQlZHijhfesRjL7ipd2nP/zwqKl87oWXykd3ULtWSkrgSO00z4RtB8o3sLDWkSs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:a848:0:b0:55d:9f32:6a12 with SMTP id
 f69-20020a81a848000000b0055d9f326a12mr11992023ywh.0.1684968265488; Wed, 24
 May 2023 15:44:25 -0700 (PDT)
Date:   Wed, 24 May 2023 15:44:23 -0700
In-Reply-To: <20230323072714.82289-4-likexu@tencent.com>
Mime-Version: 1.0
References: <20230323072714.82289-1-likexu@tencent.com> <20230323072714.82289-4-likexu@tencent.com>
Message-ID: <ZG6TR4dhcnsi9dNi@google.com>
Subject: Re: [PATCH 3/7] KVM: selftests: Test consistency of CPUID with num of
 GP counters
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

On Thu, Mar 23, 2023, Like Xu wrote:
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
> index 75434aa2a0ec..50902187d2c9 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_cpuid_test.c
> @@ -49,11 +49,31 @@ static const uint64_t arch_events[] = {
>  /* Association of Fixed Counters with Architectural Performance Events */
>  static int fixed_events[] = {1, 0, 7};
>  
> +static const uint64_t perf_caps[] = {
> +	0,
> +	PMU_CAP_FW_WRITES,
> +};
> +
> +/*
> + * KVM implements the first two non-existent counters (MSR_P6_PERFCTRx)
> + * via kvm_pr_unimpl_wrmsr() instead of #GP. It is acceptable here to test
> + * the third counter as there are usually more than 3 available gp counters.

Don't hedge, i.e. don't say things like "usually".  And why not test that KVM
drops writes to the first two counters?  Unlike KVM-Unit_tests, selftests can
test arbitrary KVM behavior without concern for breaking other use cases.

> +#define MSR_INTEL_ARCH_PMU_GPCTR (MSR_IA32_PERFCTR0 + 2)
> +
>  static uint64_t evt_code_for_fixed_ctr(uint8_t idx)
>  {
>  	return arch_events[fixed_events[idx]];
>  }
>  
> +static uint8_t kvm_gp_ctrs_num(void)
> +{
> +	const struct kvm_cpuid_entry2 *kvm_entry;
> +
> +	kvm_entry = get_cpuid_entry(kvm_get_supported_cpuid(), 0xa, 0);
> +	return (kvm_entry->eax & GP_CTR_NUM_MASK) >> GP_CTR_NUM_OFS_BIT;

This definitely can be defined as a KVM_X86_CPU_PROPERTY().  Ditto for most of
the helpers that are added in future patches.

>  static struct kvm_vcpu *new_vcpu(void *guest_code)
>  {
>  	struct kvm_vm *vm;
> @@ -98,6 +118,30 @@ static bool first_uc_arg_non_zero(struct ucall *uc, void *data)
>  	return uc->args[1];
>  }
>  
> +static bool first_uc_arg_equals(struct ucall *uc, void *data)
> +{
> +	return uc->args[1] == (uint64_t)data;
> +}
> +
> +static void guest_gp_handler(struct ex_regs *regs)
> +{
> +	GUEST_SYNC(GP_VECTOR);
> +	GUEST_DONE();
> +}
> +
> +static void guest_wr_and_rd_msrs(uint32_t base, uint64_t value,
> +				 uint8_t begin, uint8_t offset)
> +{
> +	unsigned int i;
> +
> +	for (i = begin; i < begin + offset; i++) {
> +		wrmsr(base + i, value);
> +		GUEST_SYNC(rdmsr(base + i));

Unless it won't work for something, use rdmsr_safe() and/oror wrmsr_safe() instead
of installing a dedicated handler.  And if I'm reading the code correctly, that will
fix a bug in the test where only the first MSR is tested in the #GP case since the
#GP handler goes straight to GUEST_DONE(), i.e. doesn't skip and continue the rest
of the guest code.  Maybe that isn't a bug in practice, e.g. each negative test only
tests a single MSR, but (a) that's not obvious and (b) it's an unnecessary limitation.


> +	}
> +
> +	GUEST_DONE();
> +}
