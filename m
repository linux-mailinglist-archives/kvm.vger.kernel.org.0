Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D646DA77F
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 04:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240543AbjDGCIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 22:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240419AbjDGCIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 22:08:24 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F86EAD25
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 19:06:39 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g187-20020a2520c4000000b00b74680a7904so40684615ybg.15
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 19:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680833196;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wTyqhW8RWeLAixJpJjV1DL8fhOfJRXV99YLK1aO545A=;
        b=FdAuY5D0K6rGqt3dXuqWsJz+tshuYx9UMAFV0YN5TsN5o9S9MjyXS8MopeiGSxaeRp
         k4+a+PlnZv/GbxgufZRREhsi9iZ3WqfTr3U2tyHNNZzXL9A8OXHQjE7dA+Lbfwh4YZpa
         X3LlRAjAxKsEqMzpW4tF7pzFg1xnkHTHlaXBjv5nP2IRmXgIGaUkPwbWjsD/Vz7znOsV
         aLVYokzL3+LYmQRuNrHsATZDWxXXON7pkvynU5UTXiBvo4aJZ+f7OIVf8Hc1ueM6+yvr
         JBvf61ejrM6gE0nQlgE0z4HTJsOYjXmgTqEb+UDo5dbxitLbn3y0v/iYFWmaVGFvZQbh
         5pAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680833196;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wTyqhW8RWeLAixJpJjV1DL8fhOfJRXV99YLK1aO545A=;
        b=quSCaIYOdrnJrVKsZwiK/ndiaVVM2R5JOVHIBQwSICesLmBxCp8ZK8odIVV/1YOSUU
         68CJr03gUERyCZfDMzdXzZfLWvtE8/7gBnEgVtS79Zrssv3bEe90dSsnmfflCivnpGvt
         Ut5I1ntkAOqT4pO8eKeEl0nOK5+cAUyrm7+p2M5BUZvqOPduM3Sv0RIoxKrlf4sE3qz5
         uK37LvM5dgryRTDD9fzs0A125+MTYSzLMfbU/mOX1aLUxfId6AVrdFlZPhys8MF15nrc
         HCKboYZBJNphjon5Qtm60bptUQxExfBad00iPPgkNZ7n7pBNoMw7jwBgrlD1KSdbjIKi
         8jWg==
X-Gm-Message-State: AAQBX9cYAysUhjdM2Mz9D4oZrey7dxb29ul2QL04NBBsjtCXqQsZZw85
        5KgVvNt8Zy8g9jyqAWwEgy8y8GBGakY=
X-Google-Smtp-Source: AKy350aY3gStDXbuXOXQZq7mnfAib84JFsQtZRgICX3v3XmEECJJ+BRT+H6+5IhvQ40sE5U8r7OVonnf094=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c905:0:b0:b86:92c0:6433 with SMTP id
 z5-20020a25c905000000b00b8692c06433mr903796ybf.9.1680833196529; Thu, 06 Apr
 2023 19:06:36 -0700 (PDT)
Date:   Thu, 6 Apr 2023 19:06:35 -0700
In-Reply-To: <20230307113819.34089-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20230307113819.34089-1-likexu@tencent.com>
Message-ID: <ZC96qzXHyWyRy8I5@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Disable vPMU if EVENTSEL_GUESTONLY bit
 doesn't exist
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, Mar 07, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Unlike Intel's msr atomic_switch mechanism, AMD supports guest pmu
> basic counter feature by setting the GUESTONLY bit on the host, so the
> presence or absence of this bit determines whether vPMU is emulatable
> (e.g. in nested virtualization). Since on AMD, writing reserved bits of
> EVENTSEL register does not bring #GP, KVM needs to update the global
> enable_pmu value by checking the persistence of this GUESTONLY bit.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/svm/svm.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index dd21e8b1a259..f41d96e638ef 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4866,6 +4866,16 @@ static __init void svm_adjust_mmio_mask(void)
>  	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
>  }
>  
> +static __init bool pmu_has_guestonly_mode(void)
> +{
> +	u64 value;
> +
> +	wrmsrl(MSR_F15H_PERF_CTL0, AMD64_EVENTSEL_GUESTONLY);
> +	rdmsrl(MSR_F15H_PERF_CTL0, value);

Preemption needs to be disabled to ensure a stable CPU.  I gotta imagine KVM should
be restoring the original value too.

I'm guessing I'm not going to like the answer, but is there really no better way
to probe for GUESTONLY support?

> +
> +	return value == AMD64_EVENTSEL_GUESTONLY;
> +}
> +
>  static __init void svm_set_cpu_caps(void)
>  {
>  	kvm_set_cpu_caps();
> @@ -4911,8 +4921,11 @@ static __init void svm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>  
>  	/* AMD PMU PERFCTR_CORE CPUID */
> -	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
> +	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE) &&
> +	    pmu_has_guestonly_mode())
>  		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
> +	else
> +		enable_pmu = false;

Why does lack of AMD64_EVENTSEL_GUESTONLY disable the PMU, but if and only if
X86_FEATURE_PERFCTR_CORE?  E.g. why does the behavior not also apply to legacy
perfmon support?

>  
>  	/* CPUID 0x8000001F (SME/SEV features) */
>  	sev_set_cpu_caps();
> 
> base-commit: 13738a3647368f7f600b30d241779bcd2a3ebbfd
> -- 
> 2.39.2
> 
