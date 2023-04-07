Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6486DAFC5
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 17:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbjDGPhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 11:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbjDGPhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 11:37:09 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292D5A5E1
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 08:37:04 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id e14-20020a056a00162e00b0062804a7a79bso19043811pfc.23
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 08:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680881823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dtRo2WFL21oaAHbFrfR4Ddw4J5LButNKMmHMmvec6E8=;
        b=fQ525XCgqO4r0Jd2ckX2rwmiwgXMlDh7YnhmFOVXtAmjvVC6fFfBt8giGMo2oJsOoD
         d/dXG2J+bNOwxczTF84vIYIDodoZ6ZbrIV8pv6Q/eHP24Q8xDZNf1ATkqZLiYK0zxGlC
         RxvpvRq0hljcpfrsWQsuUCTuMzt7ICLtbt6ndrL/Vxroft6EmGwcsosMxebxN1fWG2Zc
         ifYPZAIEBsOBjVAT8wB1vAYk53XyRpsDASnET4K12S632fLTX8F5M8N7P7GoCjGaHMto
         CTZ11jIMuZn5mBtj1in2moL/unXbqv7A6gHbDc5jrgyzxbQVZDxwLZK0jWpPri0HxPHj
         4zNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680881823;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dtRo2WFL21oaAHbFrfR4Ddw4J5LButNKMmHMmvec6E8=;
        b=Xlg3JWpXT6ky2aulLJrzwj6Bh92h7Qf8B8dpupb/TA1vJr0bRK4DTPa7V6E8dfs/0G
         MLg1GiT9wWQCoNKTGNrlXYWmDl1eJ77djclyNB5ti3MGD9LEeAzUUbyQ39zyh5hB2wXG
         3h5A86SklSeOTw/dZqLIeeqcS+sGfORP1CcWC/4Fb4CqE4Obh/IJjRtLzUEfPRdXyZU9
         D95Qe6ifKjFHjNZbiU6vaneQI+Z5JBmfh9GeQQokeMRCP7FoN+sEkW2gDmrwuOa5AM5A
         yt3DPEa6up+0CqzClVeiVpSJRb/oOPaatUevQjyKgF+m/g1Hohx9ycbqg0NZgL7Iwl4F
         braw==
X-Gm-Message-State: AAQBX9cYBUqgrOMSZwXPw5bTM+5DlOFhzS1KurIJlf9beK025TFwcGuG
        SLC1kvZ78XjQJNbE0ejav3Bdx7gENtk=
X-Google-Smtp-Source: AKy350Z3PPXr0IyjDAwL0vaSoIYe+f/X8hPe0wn9swtrsKv8G52cCL84ZV69CuXp5ijMAgL0OjYQmsSkEwU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7787:b0:1a1:b3bb:cd5e with SMTP id
 o7-20020a170902778700b001a1b3bbcd5emr917936pll.9.1680881823661; Fri, 07 Apr
 2023 08:37:03 -0700 (PDT)
Date:   Fri, 7 Apr 2023 08:37:02 -0700
In-Reply-To: <20230407085646.24809-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230407085646.24809-1-likexu@tencent.com>
Message-ID: <ZDA4nsyAku9B2/58@google.com>
Subject: Re: [PATCH V2] KVM: x86/pmu: Disable vPMU if EVENTSEL_GUESTONLY bit
 doesn't exist
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ravi Bangoria <ravi.bangoria@amd.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 07, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Unlike Intel's MSR atomic_switch mechanism, AMD supports guest pmu
> basic counter feature by setting the GUESTONLY bit on the host, so the
> presence or absence of this bit determines whether vPMU is emulatable
> (e.g. in nested virtualization). Since on AMD, writing reserved bits of
> EVENTSEL register does not bring #GP, KVM needs to update the global
> enable_pmu value by checking the persistence of this GUESTONLY bit.

This is looking more and more like a bug fix, i.e. needs a Fixes:, no?

> Cc: Ravi Bangoria <ravi.bangoria@amd.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
> V1:
> https://lore.kernel.org/kvm/20230307113819.34089-1-likexu@tencent.com
> V1 -> V2 Changelog:
> - Preemption needs to be disabled to ensure a stable CPU; (Sean)
> - KVM should be restoring the original value too; (Sean)
> - Disable vPMU once guest_only mode is not supported; (Sean)

Please respond to my questions, don't just send a new version.  When I asked

 : Why does lack of AMD64_EVENTSEL_GUESTONLY disable the PMU, but if and only if
 : X86_FEATURE_PERFCTR_CORE?  E.g. why does the behavior not also apply to legacy
 : perfmon support?

I wanted an actual answer because I genuinely do not know what the correct
behavior is.

> - Appreciate any better way to probe for GUESTONLY support;

Again, wait for discussion in previous versions to resolve before posting a new
version.  If your answer is "not as far as I know", that's totally fine, but
sending a new version without responding makes it unnecessarily difficult to
track down your "answer".  E.g. instead of seeing a very direct "I don't know",
I had to discover that answer by finding a hint buried in the ignored section of
a new patch.

>  arch/x86/kvm/svm/svm.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7584eb85410b..1ab885596510 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4884,6 +4884,20 @@ static __init void svm_adjust_mmio_mask(void)
>  	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
>  }
>  
> +static __init bool pmu_has_guestonly_mode(void)
> +{
> +	u64 original, value;
> +
> +	preempt_disable();
> +	rdmsrl(MSR_F15H_PERF_CTL0, original);

What guarantees this MSR actually exists?  In v1, it was guarded by enable_pmu=%true,
but that's longer the case.  And KVM does

	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
		if (!guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
			return NULL;

which very strongly suggests this MSR doesn't exist if the CPU supports only the
"legacy" PMU.

> +	wrmsrl(MSR_F15H_PERF_CTL0, AMD64_EVENTSEL_GUESTONLY);
> +	rdmsrl(MSR_F15H_PERF_CTL0, value);
> +	wrmsrl(MSR_F15H_PERF_CTL0, original);
> +	preempt_enable();
> +
> +	return value == AMD64_EVENTSEL_GUESTONLY;
> +}
> +
>  static __init void svm_set_cpu_caps(void)
>  {
>  	kvm_set_cpu_caps();
> @@ -4928,6 +4942,9 @@ static __init void svm_set_cpu_caps(void)
>  	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>  
> +	/* Probe for AMD64_EVENTSEL_GUESTONLY support */

I've said this several times recently: use comments to explain _why_ and to call
out subtleties.  The code quite obviously is probing for guest-only support, what's
not obvious is why guest-only support is mandatory for vPMU support.  It may be
obvious to you, but pease try to view all of this code from the perspective of
someone who has only passing knowledge of the various components, i.e. doesn't
know the gory details of exactly what KVM supports.

Poking around, I see that pmc_reprogram_counter() unconditionally does

	.exclude_host = 1,

and amd_core_hw_config()

	if (event->attr.exclude_host && event->attr.exclude_guest)
		/*
		 * When HO == GO == 1 the hardware treats that as GO == HO == 0
		 * and will count in both modes. We don't want to count in that
		 * case so we emulate no-counting by setting US = OS = 0.
		 */
		event->hw.config &= ~(ARCH_PERFMON_EVENTSEL_USR |
				      ARCH_PERFMON_EVENTSEL_OS);
	else if (event->attr.exclude_host)
		event->hw.config |= AMD64_EVENTSEL_GUESTONLY;
	else if (event->attr.exclude_guest)
		event->hw.config |= AMD64_EVENTSEL_HOSTONLY;

and so something like this seems appropriate

	/*
	 * KVM requires guest-only event support in order to isolate guest PMCs
	 * from host PMCs.  SVM doesn't provide a way to atomically load MSRs
	 * on VMRUN, and manually adjusting counts before/after VMRUN is not
	 * accurate enough to properly virtualize a PMU.
	 */

But now I'm really confused, because if I'm reading the code correctly, perf
invokes amd_core_hw_config() for legacy PMUs, i.e. even if PERFCTR_CORE isn't
supported.  And the APM documents the host/guest bits only for "Core Performance
Event-Select Registers".

So either (a) GUESTONLY isn't supported on legacy CPUs and perf is relying on AMD
CPUs ignoring reserved bits or (b) GUESTONLY _is_ supported on legacy PMUs and
pmu_has_guestonly_mode() is checking the wrong MSR when running on older CPUs.

And if (a) is true, then how on earth does KVM support vPMU when running on a
legacy PMU?  Is vPMU on AMD just wildly broken?  Am I missing something?
