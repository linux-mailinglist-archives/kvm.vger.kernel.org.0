Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10ECFC92B5
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 21:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728654AbfJBT4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 15:56:43 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38821 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbfJBT4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 15:56:42 -0400
Received: by mail-io1-f66.google.com with SMTP id u8so156914iom.5
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2019 12:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dk1xiojtdSxbPGVXOgkiOKlECGbF1OR24opXqDPKZxw=;
        b=UHPrEXbFQrG0siwewfg75PiGVJckTDFJGuIFc7BRtiCWnhRu7nMnAhwIcV/3QvpmNi
         zcer5zsYAVVv8CzO9Aipmv7PzerrS0WlSawFvoOY1Py8/CHUKwoPYqYr+k9J/uwZu1rl
         /+Y/O/WAV3PpFVbT4PdpYtHHCAesZYHsEWMdpw6nUU1FpfgK48zpyYxVdqmAj0fqLq7r
         NY6YGf+uWBEGF+IB2b8R5gCMLGhtqt0hcK1L3OYqBymxcq9IFPDOcSDdaiy4ZVhRD60E
         XKpSqkh4EiAwndm3lyGqfmsK4FMiQ2Lrc+zVgaLOo6rW7OAFPgYklgRkIFHmRzFp8mz0
         3rtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dk1xiojtdSxbPGVXOgkiOKlECGbF1OR24opXqDPKZxw=;
        b=RlemiuRTkhJfVu6Cl05QdHEb2KLdf0FuwluFoHzgOplqLy8YjJDs2N2z/Tun0sM8Ol
         2QJrTBIPiEhL4gLBAe6A6/Ab1p0L/NOcYm1CWSYpvfddEX6ecG4s6t1QwwpjST7j/P2v
         ZAL5NuC0kdpXgxhRsR9ShRRVfNwrhE01OmXDf1rGHGrzqb+y4hQQdtV34+7D+Y9ukZaD
         ogSPhORBVg0ic/wgSRjFN3boDcM0svloW62C0Wv462cYG7uMcFXkTW+B1nrUqE8BjPdB
         rQl34jFbz0ICnQW7fiet0Z3UpU8QTuBCRrnebDiJGPNqqAE9GwFmsr8XZCezylnfEnX6
         8gaA==
X-Gm-Message-State: APjAAAXHCTF3eke2f/WoMT4D77qrD1BDjjOuzu8pyq7dX10zXmaiUPWH
        rcP/kqKt2HxXWM5E8PM9BilT2rb/chxwM/tMnqOf0g==
X-Google-Smtp-Source: APXvYqzpCMAUM0lWb0fNaqUjO6Ds3dQt38NZVJvOQUhcm7ricfA/gS7sIorLBcvFx0a/X97pDGUE2EJMWy+KF8x6Eog=
X-Received: by 2002:a5e:8a43:: with SMTP id o3mr5067318iom.296.1570046201654;
 Wed, 02 Oct 2019 12:56:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190927021927.23057-1-weijiang.yang@intel.com> <20190927021927.23057-7-weijiang.yang@intel.com>
In-Reply-To: <20190927021927.23057-7-weijiang.yang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 2 Oct 2019 12:56:30 -0700
Message-ID: <CALMp9eRouyhkKeadM_w80bisWB-VSBCf3NSei5hZXcDsRR7GJg@mail.gmail.com>
Subject: Re: [PATCH v7 6/7] KVM: x86: Load Guest fpu state when accessing MSRs
 managed by XSAVES
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
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> A handful of CET MSRs are not context switched through "traditional"
> methods, e.g. VMCS or manual switching, but rather are passed through
> to the guest and are saved and restored by XSAVES/XRSTORS, i.e. the
> guest's FPU state.
>
> Load the guest's FPU state if userspace is accessing MSRs whose values
> are managed by XSAVES so that the MSR helper, e.g. vmx_{get,set}_msr(),
> can simply do {RD,WR}MSR to access the guest's value.
>
> Note that guest_cpuid_has() is not queried as host userspace is allowed
> to access MSRs that have not been exposed to the guest, e.g. it might do
> KVM_SET_MSRS prior to KVM_SET_CPUID2.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/x86.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 290c3c3efb87..5b8116028a59 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -104,6 +104,8 @@ static void enter_smm(struct kvm_vcpu *vcpu);
>  static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
>  static void store_regs(struct kvm_vcpu *vcpu);
>  static int sync_regs(struct kvm_vcpu *vcpu);
> +static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
> +static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
>
>  struct kvm_x86_ops *kvm_x86_ops __read_mostly;
>  EXPORT_SYMBOL_GPL(kvm_x86_ops);
> @@ -2999,6 +3001,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  }
>  EXPORT_SYMBOL_GPL(kvm_get_msr_common);
>
> +static bool is_xsaves_msr(u32 index)
> +{
> +       return index == MSR_IA32_U_CET ||
> +              (index >= MSR_IA32_PL0_SSP && index <= MSR_IA32_PL3_SSP);
> +}
> +
>  /*
>   * Read or write a bunch of msrs. All parameters are kernel addresses.
>   *
> @@ -3009,11 +3017,23 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
>                     int (*do_msr)(struct kvm_vcpu *vcpu,
>                                   unsigned index, u64 *data))
>  {
> +       bool fpu_loaded = false;
>         int i;
> +       const u64 cet_bits = XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL;
> +       bool cet_xss = kvm_x86_ops->xsaves_supported() &&
> +                      (kvm_supported_xss() & cet_bits);

It seems like I've seen a lot of checks like this. Can this be
simplified (throughout this series) by sinking the
kvm_x86_ops->xsaves_supported() check into kvm_supported_xss()? That
is, shouldn't kvm_supported_xss() return 0 if
kvm_x86_ops->xsaves_supported() is false?

> -       for (i = 0; i < msrs->nmsrs; ++i)
> +       for (i = 0; i < msrs->nmsrs; ++i) {
> +               if (!fpu_loaded && cet_xss &&
> +                   is_xsaves_msr(entries[i].index)) {
> +                       kvm_load_guest_fpu(vcpu);
> +                       fpu_loaded = true;
> +               }
>                 if (do_msr(vcpu, entries[i].index, &entries[i].data))
>                         break;
> +       }
> +       if (fpu_loaded)
> +               kvm_put_guest_fpu(vcpu);
>
>         return i;
>  }
> --
> 2.17.2
>
