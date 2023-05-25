Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455E2711A32
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 00:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242125AbjEYWfY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 18:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbjEYWfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 18:35:22 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4519E
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 15:35:21 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-64d67a12befso149487b3a.3
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 15:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685054121; x=1687646121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UBYS8ENSnn2Pk5z6V6aHzGUw+NHG0kpOMl4KIfPcjCA=;
        b=qRKy8uPoPoJf4UTgWjlBFVe+Kldw2phWnFhd/KCWSU/tnlqfypZQWvGAHPS1IkLG/h
         1eVfqdI2Q0mxB5D+wITWYyivkSn9x8W+PeuTadI0Ed1k44jDInf97OukhgnlKparlGct
         3Hgl9+k3LlgUEf1DwFf72dr1zXMEVwcp+b0BbC1e2bvD/GUOJBanuzI7oNo2BnvfLanD
         2b7YV5pzoVcxu6VGZhAhWg3TljEFWH4r5Axt+zFfxSYrdNO67h2qPwJLBR8ltRLiiuNU
         yXC/vLOuet/6BttO6VR0MsETFnvsee/nljeA7/JXktFc6sprlumVIZi0GmAKInfSIwll
         v8Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685054121; x=1687646121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UBYS8ENSnn2Pk5z6V6aHzGUw+NHG0kpOMl4KIfPcjCA=;
        b=kR9kOBviCkz+zM5olxYxperBdtyrAd1q+kQoPSgwDGKpOORwYdDzaiLGFhC/w1c6MU
         bbLeeVVTFs1zHVRQ69oz4WuGM7HuUEUDfNbzI79b+6jmItlYfaycUl5H3Yu6txlT145q
         Nq8o3W/A7zFkGm40A6IToPKSqvAcOy/P8h48fq8MqRyoNRIdv30mIdc7Fp7InbRGGCDC
         ig8vYRgnjN7+uhktZm/qfw+xdYmBaOdVHTczuDdtHPWKV5CWHfTB4gq7YVHEE+mdJ4TO
         sxQoVQfuw+maf1nTbcCi9m99Q68vQan9LXuRWL8OFEb64m9HSZnIiP3ajpbud4CWCqlp
         n5ZA==
X-Gm-Message-State: AC+VfDzXoWYUxmgBw9yguSUfUaZPvtudi5zEJciM7pfmVsnNgQuD8U2A
        v0PGdNurEhrwsdKeCZJtoIuHSZDocuA=
X-Google-Smtp-Source: ACHHUZ41JJ99F6PWhhuUkgjNESDV8KtBsDzemlOOvLCtjANxGhBTq8P1XhsgkCd1TVe8BXUtMcfwM+Q5BCk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d94:b0:643:a260:a5d2 with SMTP id
 fb20-20020a056a002d9400b00643a260a5d2mr119659pfb.0.1685054120984; Thu, 25 May
 2023 15:35:20 -0700 (PDT)
Date:   Thu, 25 May 2023 15:35:19 -0700
In-Reply-To: <20230427095333.35038-2-abusse@amazon.com>
Mime-Version: 1.0
References: <20230427095333.35038-1-abusse@amazon.com> <20230427095333.35038-2-abusse@amazon.com>
Message-ID: <ZG/h2kW8cTY5CuFN@google.com>
Subject: Re: [PATCH 1/2] KVM: vmx/pmu: Indicate available fixed function PMCs
 through a bitmap
From:   Sean Christopherson <seanjc@google.com>
To:     Anselm Busse <abusse@amazon.com>
Cc:     dwmw@amazon.co.uk, hborghor@amazon.de, sironi@amazon.de,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
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

On Thu, Apr 27, 2023, Anselm Busse wrote:
> This commit changes the tracking of available fixed function counters
> from a number to a bitmap.
> 
> Starting with Intel PMU v5, the available fixed function counters cannot
> only be advertised through a number, but also through a bitmap in
> CPUID.0AH.ECX. However, the current KVM implementation determines if a
> fixed function PMC is available to a guest purely based on the number
> of exposed fixed function PMCs. This makes it impossible to use this
> new feature of the Intel PMU v5. Therefore, this change serves as a
> preparation to seamlessly enable the virtualization of Intel PMU v5 in
> the future.
> 
> No functional change intended.
> 
> Signed-off-by: Anselm Busse <abusse@amazon.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/pmu.h              |  6 +++---
>  arch/x86/kvm/svm/pmu.c          |  2 +-
>  arch/x86/kvm/vmx/pmu_intel.c    | 33 ++++++++++++++++++---------------
>  4 files changed, 23 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 808c292ad3f4..ea4859554678 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -516,7 +516,7 @@ struct kvm_pmc {
>  #define KVM_AMD_PMC_MAX_GENERIC	6
>  struct kvm_pmu {
>  	unsigned nr_arch_gp_counters;
> -	unsigned nr_arch_fixed_counters;
> +	DECLARE_BITMAP(mask_arch_fixed_counters, INTEL_PMC_MAX_FIXED);

Please see the feedback I gave to Like[*].  Unless I'm missing something, there's
no need for another bitmap. 

[*] https://lore.kernel.org/kvm/ZB4oUhmIKPF2lAzN@google.com
