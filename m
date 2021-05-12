Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F8D37B3CF
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 03:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhELB7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 21:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhELB7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 21:59:48 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B1CC06174A
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 18:58:41 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso19218937otb.13
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 18:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=uT4uDQPhl0Mt9nIZvogG/i4OqNBAVKbl0dDaNitDe7o=;
        b=ohZRK2/rQTHNxe9lLS8mpbrsxUPHddjpjeL19IDZtz0r5ZrJWv1+xJn9zwFbQg+Z1b
         GH2r6SL5Dv304n+11Kg1wJ4rwMMHk8x9nv4m8El98NWMABtzOpUubk02B/WNj2pzufFP
         KjyLZnqQdm0Nh9qpBpTU5EBk/h6EF7c8Phb5k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=uT4uDQPhl0Mt9nIZvogG/i4OqNBAVKbl0dDaNitDe7o=;
        b=jrpbsETl66nCX3WhZoMztQlppiUuuV+IT+vwyaMJgpdt3xtdmuEMOipbwvBoF5E1qI
         Bg5SjyLQd6hNPmhjaRY45MMd+K4MvqOekuRMXiv/5122FFq9i++5YWOoJB3AuZy+NonE
         XKAsPFtxExsIohtueHUuGqUAVsmZsPsjffbjFuf9v31b8wMBHlogPHda+2LWrDx20SF+
         riojL41EC8mIwkKyoKa+T8qj7362Wby6j6HPedGIHsItMYTi8BcRduj2CDKGEbCllLew
         6mWdpbZfpkd/VG5g+kUJjevW1Bn5NzL15le+bh/BESRVWbnNWZzZut0GLR0zkE+fVT/e
         VGXg==
X-Gm-Message-State: AOAM533m8ezExXZ2MPLNUt0Dz4M+8XzXArUfpbcgwc/GcfGKra9v26sa
        u4DRtvRAnhPoCDYvBkAPpNDbxUIurVrHuW56fOImQg==
X-Google-Smtp-Source: ABdhPJwi7vxioAo8AFc5P3GIdvCUVve0tOmLHeJ/xY70ShrPO4Ic3qpw9vfYtA3oLPZtEeznts64iTLL0LI0iU8Uohg=
X-Received: by 2002:a9d:764f:: with SMTP id o15mr29165323otl.164.1620784720531;
 Tue, 11 May 2021 18:58:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:a05:0:0:0:0:0 with HTTP; Tue, 11 May 2021 18:58:39 -0700 (PDT)
In-Reply-To: <20210511024214.280733-5-like.xu@linux.intel.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com> <20210511024214.280733-5-like.xu@linux.intel.com>
From:   Venkatesh Srinivas <venkateshs@chromium.org>
Date:   Tue, 11 May 2021 18:58:39 -0700
Message-ID: <CAA0tLErUFPnZ=SL82bLe8Ddf5rFu2Pdv5xE0aq4A91mzn9=ABA@mail.gmail.com>
Subject: Re: [PATCH v6 04/16] KVM: x86/pmu: Set MSR_IA32_MISC_ENABLE_EMON bit
 when vPMU is enabled
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Yao Yuan <yuan.yao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/21, Like Xu <like.xu@linux.intel.com> wrote:
> On Intel platforms, the software can use the IA32_MISC_ENABLE[7] bit to
> detect whether the processor supports performance monitoring facility.
>
> It depends on the PMU is enabled for the guest, and a software write
> operation to this available bit will be ignored.

Is the behavior that writes to IA32_MISC_ENABLE[7] are ignored (rather than #GP)
documented someplace?

Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>

> Cc: Yao Yuan <yuan.yao@intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 1 +
>  arch/x86/kvm/x86.c           | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 9efc1a6b8693..d9dbebe03cae 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -488,6 +488,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  	if (!pmu->version)
>  		return;
>
> +	vcpu->arch.ia32_misc_enable_msr |= MSR_IA32_MISC_ENABLE_EMON;
>  	perf_get_x86_pmu_capability(&x86_pmu);
>
>  	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5bd550eaf683..abe3ea69078c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3211,6 +3211,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct
> msr_data *msr_info)
>  		}
>  		break;
>  	case MSR_IA32_MISC_ENABLE:
> +		data &= ~MSR_IA32_MISC_ENABLE_EMON;
>  		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)
> &&
>  		    ((vcpu->arch.ia32_misc_enable_msr ^ data) &
> MSR_IA32_MISC_ENABLE_MWAIT)) {
>  			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
> --
> 2.31.1
>
>
