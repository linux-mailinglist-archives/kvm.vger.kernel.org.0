Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7ACC90A6
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 20:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbfJBSSq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 14:18:46 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36701 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728486AbfJBSSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 14:18:46 -0400
Received: by mail-io1-f68.google.com with SMTP id b136so59142122iof.3
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2019 11:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sE4hIPJblfldPa9zZyykYwpbgFP0hJyev1rPxUtG4KU=;
        b=Mt8Hq+v9ToEnDoCvIp6M0wjAgGNEwNOPReg2epy6vYbvl/pMZPfTqzbi+pk6693Jwo
         b8M6cYYmjK1ZA9JIQXLHOwAtFvG/hfoywsmkqz4dn+9VfYL+RW0Z4vzptkiFMlh/WvTV
         4n3+9gPw8qxd3sMf2A3oEYcnTjtREneF0GiH6EQS4nxh/jBAjNsvGxMry+tnPKU97zq7
         kpliKL2gMwMzMOLsTucnIC6kfAP/hCLX2iIoe+Iec4J8CBzhbWYHLrvwfkaOXLhxobVf
         21c5xnNTrKj2SdD58SwnMGLOec0RuNnO/eGjNbHIUjTWG2WNNQK4jdsPklpRux3YMHXO
         GbKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sE4hIPJblfldPa9zZyykYwpbgFP0hJyev1rPxUtG4KU=;
        b=oB2aKx7wBLw1hgqlivePCkVkYW9dvAbW5z/k5mck/HQMa9Z9VdzuSK7XB+RsRzswBn
         vv/lOe7rGF2a8InCFbuMqPwKv8c9F4+aAnlbi5fF6KryDB715Moupy89oNYU3PUNp67H
         MiGzjynjuA0SATYW18XxNdRHviZtSf3BmU1PTVktS2zhRK+3pI82c4JGORktai4e6ULA
         3Qkk690MiBctEqXClwFk44QLxaLk7nZYG4Y4nImgbpITfmp5Z3yJ9v9aXZvJfWAhY9FB
         JeoquaUaO2/X12DY8TrNg3j2NOoNlHBek7HizveYCUhHmJMX/EYQ623TITxu/yNWrAN7
         gHLw==
X-Gm-Message-State: APjAAAXhAJ0vpXJYIe9MqSc2EMZQP+P7qJ95Ln4UCQsC2uwykBv2X+dE
        wYk5yWMldPTJyckM761aTdc27D3V3R1BabEQRwoYNQ==
X-Google-Smtp-Source: APXvYqwLHrC3Z9URNH0104suwg+CjvRZfUUk7UJDrxyz3QC44afn5OStLQHrqzc3UxYA3K+ftuCXSLBAk1kB7I5s4yw=
X-Received: by 2002:a92:b09:: with SMTP id b9mr1924153ilf.26.1570040323223;
 Wed, 02 Oct 2019 11:18:43 -0700 (PDT)
MIME-Version: 1.0
References: <20190927021927.23057-1-weijiang.yang@intel.com> <20190927021927.23057-4-weijiang.yang@intel.com>
In-Reply-To: <20190927021927.23057-4-weijiang.yang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 2 Oct 2019 11:18:32 -0700
Message-ID: <CALMp9eT3HJ3S6Mzzntje2Kb4m-y86GvkhaNXun-mLJukEy6wbA@mail.gmail.com>
Subject: Re: [PATCH v7 3/7] KVM: VMX: Pass through CET related MSRs to Guest
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 7:17 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
>
> CET MSRs pass through Guest directly to enhance performance.
> CET runtime control settings are stored in MSR_IA32_{U,S}_CET,
> Shadow Stack Pointer(SSP) are stored in MSR_IA32_PL{0,1,2,3}_SSP,
> SSP table base address is stored in MSR_IA32_INT_SSP_TAB,
> these MSRs are defined in kernel and re-used here.

All of these new guest MSRs will have to be enumerated by
KVM_GET_MSR_INDEX_LIST.

> MSR_IA32_U_CET and MSR_IA32_PL3_SSP are used for user mode protection,
> the contents could differ from process to process, therefore,
> kernel needs to save/restore them during context switch, it makes
> sense to pass through them so that the guest kernel can
> use xsaves/xrstors to operate them efficiently. Other MSRs are used
> for non-user mode protection. See CET spec for detailed info.

I assume that XSAVES & XRSTORS bypass the MSR permission bitmap, like
other instructions that manipulate MSRs (e.g. SWAPGS, RDTSCP, etc.).
Is the guest OS likely to use RDMSR/WRMSR to access these MSRs?

> The difference between CET VMCS state fields and xsave components is that,
> the former used for CET state storage during VMEnter/VMExit,
> whereas the latter used for state retention between Guest task/process
> switch.
>
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/cpuid.c   |  1 +
>  arch/x86/kvm/cpuid.h   |  2 ++
>  arch/x86/kvm/vmx/vmx.c | 39 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 42 insertions(+)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 1aa86b87b6ab..0a47b9e565be 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -66,6 +66,7 @@ u64 kvm_supported_xss(void)
>  {
>         return KVM_SUPPORTED_XSS & kvm_x86_ops->supported_xss();
>  }
> +EXPORT_SYMBOL_GPL(kvm_supported_xss);
>
>  #define F(x) bit(X86_FEATURE_##x)
>
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index d78a61408243..1d77b880084d 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -27,6 +27,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>
>  int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu);
>
> +u64 kvm_supported_xss(void);
> +
>  static inline int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
>  {
>         return vcpu->arch.maxphyaddr;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a84198cff397..f720baa7a9ba 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7001,6 +7001,43 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
>                 vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
>  }
>
> +static void vmx_intercept_cet_msrs(struct kvm_vcpu *vcpu)

Nit: It seems like this function adjusts the MSR permission bitmap so
as *not* to intercept the CET MSRs.

> +{
> +       struct vcpu_vmx *vmx = to_vmx(vcpu);
> +       unsigned long *msr_bitmap;
> +       u64 kvm_xss;
> +       bool cet_en;
> +
> +       msr_bitmap = vmx->vmcs01.msr_bitmap;

What about nested guests? (i.e. vmcs02).

> +       kvm_xss = kvm_supported_xss();
> +       cet_en = guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> +                guest_cpuid_has(vcpu, X86_FEATURE_IBT);
> +       /*
> +        * U_CET is a must for USER CET, per CET spec., U_CET and PL3_SPP are
> +        * a bundle for USER CET xsaves.
> +        */
> +       if (cet_en && (kvm_xss & XFEATURE_MASK_CET_USER)) {
> +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW);
> +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW);
> +       }

Since this is called from vmx_cpuid_update, what happens if cet_en was
previously true and now it's false?

> +       /*
> +        * S_CET is a must for KERNEL CET, PL0_SSP ... PL2_SSP are a bundle
> +        * for CET KERNEL xsaves.
> +        */
> +       if (cet_en && (kvm_xss & XFEATURE_MASK_CET_KERNEL)) {
> +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW);
> +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW);
> +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW);
> +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW);
> +
> +               /* SSP_TAB only available for KERNEL SHSTK.*/
> +               if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> +                       vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB,
> +                                                     MSR_TYPE_RW);
> +       }
> +}
> +
>  static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -7025,6 +7062,8 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>         if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
>                         guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
>                 update_intel_pt_cfg(vcpu);
> +
> +       vmx_intercept_cet_msrs(vcpu);
>  }
>
>  static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> --
> 2.17.2
>
