Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA28C8FDF
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 19:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbfJBR0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 13:26:23 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41402 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbfJBR0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 13:26:23 -0400
Received: by mail-io1-f66.google.com with SMTP id n26so30261445ioj.8
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2019 10:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yV0GdOrzBWAd9NECvjXYLArGxgzRumL1DNSDIBe6DAk=;
        b=rgb+HKiDWczlsktQkTV0BOaR9cJB2oV52jGxONX36dqwQ8D1LBRoqbx84+1hVUvSqd
         BYG3nAd1eIhyu/Zi72d1v7C9C9wi4HCFux/NWJRJLypM/gVlGePDL2qADceP0FwlSsEk
         iMb7pfWvv75L4Hh5irCYGIc3YDKFbiDPNwqSrNA/g9rL/Nv0DvqsvK5fgS1YzWgJjEDd
         NXG+V4o0SmQGT9YHQLLAuamOI9JRRA1HzwgQ16c9AHdrL5kPRWhVAofFGwpeJCNktR/F
         zirn2585RxDo6Q4oZfsnc3qVkfnPMSRcNUMsjSwa76wNL43ZaOPFAQyn+FZDaPyBXUyr
         MRAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yV0GdOrzBWAd9NECvjXYLArGxgzRumL1DNSDIBe6DAk=;
        b=fext9WfqtZwmPWHZFeBYmnRFV8ADZaWyJSrWw9nHlbhHb7SVB8/OvsfGqZMIpmre76
         lylTLBTK2GO2db/lKApztM1b93DWtbobDK+ZUZyTpZZYCB7zi5R2u8SZVKGcLJEUeFCz
         YhiXprVojzO/43NcKxfJ9ZhmKkD2weBbOUlENfkL7OY1ffMX+JXRAVoNK6jYAZI61Nh0
         /bDx71OFBJcnbhJcEPUdxViVQupm1Picbw9XgOhJR/GHGn67UQ0c/KFhd6tU3TgU5w+1
         DG4mYtY9ALZaJVMoqRkoS6AHwxIUCXl/94/93HV5wvNHz2Yjj90Qds9zKpz3GgjYaCIJ
         RgUQ==
X-Gm-Message-State: APjAAAX3Kb42ELZ0R7GzR8iVAXIXaCK7JDGgT0tCZq8l4NXWxAeH0oTc
        6hZGe49WGtdG3Pz+E/baCAmwR4ddflbUlkR6JFVvxQ==
X-Google-Smtp-Source: APXvYqzXmaF63xYrTtWLQ6CebKm6Mq9AeZ1WzN7e37OKO8EYIyBr2BmMyN0KlnYzfmasU6+Hoc4mj6dh0kuViPyL9lE=
X-Received: by 2002:a92:4a0d:: with SMTP id m13mr4884117ilf.119.1570037181804;
 Wed, 02 Oct 2019 10:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190927021927.23057-1-weijiang.yang@intel.com> <20190927021927.23057-2-weijiang.yang@intel.com>
In-Reply-To: <20190927021927.23057-2-weijiang.yang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 2 Oct 2019 10:26:10 -0700
Message-ID: <CALMp9eRXoyoX6GHQgVTXemJjm69MwqN+VDN47X=5BN36rvrAgA@mail.gmail.com>
Subject: Re: [PATCH v7 1/7] KVM: CPUID: Fix IA32_XSS support in CPUID(0xd,i) enumeration
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
> The control bits in IA32_XSS MSR are being used for new features,
> but current CPUID(0xd,i) enumeration code doesn't support them, so
> fix existing code first.
>
> The supervisor states in IA32_XSS haven't been used in public
> KVM code, so set KVM_SUPPORTED_XSS to 0 now, anyone who's developing
> IA32_XSS related feature may expand the macro to add the CPUID support,
> otherwise, CPUID(0xd,i>1) always reports 0 of the subleaf to guest.
>
> Extracted old code into a new filter and keep it same flavor as others.
>
> This patch passed selftest on a few Intel platforms.
>
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/cpuid.c            | 94 +++++++++++++++++++++------------
>  arch/x86/kvm/svm.c              |  7 +++
>  arch/x86/kvm/vmx/vmx.c          |  6 +++
>  arch/x86/kvm/x86.h              |  7 +++
>  5 files changed, 82 insertions(+), 33 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 74e88e5edd9c..d018df8c5f32 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1209,6 +1209,7 @@ struct kvm_x86_ops {
>         uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
>
>         bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
> +       u64 (*supported_xss)(void);
>  };
>
>  struct kvm_arch_async_pf {
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 22c2720cd948..9d282fec0a62 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -62,6 +62,11 @@ u64 kvm_supported_xcr0(void)
>         return xcr0;
>  }
>
> +u64 kvm_supported_xss(void)
> +{
> +       return KVM_SUPPORTED_XSS & kvm_x86_ops->supported_xss();
> +}
> +
>  #define F(x) bit(X86_FEATURE_##x)
>
>  int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> @@ -414,6 +419,50 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
>         }
>  }
>
> +static inline void do_cpuid_0xd_mask(struct kvm_cpuid_entry2 *entry, int index)
> +{
> +       unsigned int f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;

Does Intel have CPUs that support XSAVES but don't support the "enable
XSAVES/XRSTORS" VM-execution control? If so, what is the behavior of
XSAVESXRSTORS on those CPUs in VMX non-root mode? If not, why is this
conditional F(XSAVES) here?

> +       /* cpuid 0xD.1.eax */
> +       const u32 kvm_cpuid_D_1_eax_x86_features =
> +               F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
> +       u64 u_supported = kvm_supported_xcr0();
> +       u64 s_supported = kvm_supported_xss();
> +       u64 supported;
> +
> +       switch (index) {
> +       case 0:
> +               entry->eax &= u_supported;
> +               entry->ebx = xstate_required_size(u_supported, false);

EBX could actually be zero, couldn't it? Since this output is
context-dependent, I'm not sure how to interpret it when returned from
KVM_GET_SUPPORTED_CPUID.

> +               entry->ecx = entry->ebx;
> +               entry->edx = 0;

Shouldn't this be: entry->edx &= u_supported >> 32?

> +               break;
> +       case 1:
> +               supported = u_supported | s_supported;
> +               entry->eax &= kvm_cpuid_D_1_eax_x86_features;
> +               cpuid_mask(&entry->eax, CPUID_D_1_EAX);
> +               entry->ebx = 0;
> +               entry->edx = 0;

Shouldn't this be: entry->edx &= s_supported >> 32?

> +               entry->ecx &= s_supported;
> +               if (entry->eax & (F(XSAVES) | F(XSAVEC)))
> +                       entry->ebx = xstate_required_size(supported, true);

As above, can't EBX just be zero, since it's context-dependent? What
is the context when processing KVM_GET_SUPPORTED_CPUID? And why do we
only fill this in when XSAVES or XSAVEC is supported?

> +               break;
> +       default:
> +               supported = (entry->ecx & 1) ? s_supported : u_supported;
> +               if (!(supported & ((u64)1 << index))) {

Nit: 1ULL << index.

> +                       entry->eax = 0;
> +                       entry->ebx = 0;
> +                       entry->ecx = 0;
> +                       entry->edx = 0;
> +                       return;
> +               }
> +               if (entry->ecx)
> +                       entry->ebx = 0;

This seems to back up my claims above regarding the EBX output for
cases 0 and 1, but aside from those subleaves, is this correct? For
subleaves > 1, ECX bit 1 can be set for extended state components that
need to be cache-line aligned. Such components could map to a valid
bit in XCR0 and have a non-zero offset from the beginning of the
non-compacted XSAVE area.

> +               entry->edx = 0;

This seems too aggressive. See my comments above regarding EDX outputs
for cases 0 and 1.

> +               break;
> +       }
> +}
> +
>  static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>                                   int *nent, int maxnent)
>  {
> @@ -428,7 +477,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>         unsigned f_lm = 0;
>  #endif
>         unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
> -       unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
>         unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
>
>         /* cpuid 1.edx */
> @@ -482,10 +530,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>                 F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
>                 F(PMM) | F(PMM_EN);
>
> -       /* cpuid 0xD.1.eax */
> -       const u32 kvm_cpuid_D_1_eax_x86_features =
> -               F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
> -
>         /* all calls to cpuid_count() should be made on the same cpu */
>         get_cpu();
>
> @@ -622,38 +666,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>                 break;
>         }
>         case 0xd: {
> -               int idx, i;
> -               u64 supported = kvm_supported_xcr0();
> -
> -               entry->eax &= supported;
> -               entry->ebx = xstate_required_size(supported, false);
> -               entry->ecx = entry->ebx;
> -               entry->edx &= supported >> 32;
> -               if (!supported)
> -                       break;
> +               int i, idx;
>
> -               for (idx = 1, i = 1; idx < 64; ++idx) {
> -                       u64 mask = ((u64)1 << idx);
> +               do_cpuid_0xd_mask(&entry[0], 0);
> +               for (i = 1, idx = 1; idx < 64; ++idx) {
>                         if (*nent >= maxnent)
>                                 goto out;
> -
>                         do_host_cpuid(&entry[i], function, idx);
> -                       if (idx == 1) {
> -                               entry[i].eax &= kvm_cpuid_D_1_eax_x86_features;
> -                               cpuid_mask(&entry[i].eax, CPUID_D_1_EAX);
> -                               entry[i].ebx = 0;
> -                               if (entry[i].eax & (F(XSAVES)|F(XSAVEC)))
> -                                       entry[i].ebx =
> -                                               xstate_required_size(supported,
> -                                                                    true);
> -                       } else {
> -                               if (entry[i].eax == 0 || !(supported & mask))
> -                                       continue;
> -                               if (WARN_ON_ONCE(entry[i].ecx & 1))
> -                                       continue;
> -                       }
> -                       entry[i].ecx = 0;
> -                       entry[i].edx = 0;
> +                       if (entry[i].eax == 0 && entry[i].ebx == 0 &&
> +                           entry[i].ecx == 0 && entry[i].edx == 0)
> +                               continue;
> +
> +                       do_cpuid_0xd_mask(&entry[i], idx);
> +                       if (entry[i].eax == 0 && entry[i].ebx == 0 &&
> +                           entry[i].ecx == 0 && entry[i].edx == 0)
> +                               continue;
> +
>                         ++*nent;
>                         ++i;
>                 }
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index e0368076a1ef..be967bf9a81d 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7193,6 +7193,11 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
>         return false;
>  }
>
> +static u64 svm_supported_xss(void)
> +{
> +       return 0;
> +}
> +
>  static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>         .cpu_has_kvm_support = has_svm,
>         .disabled_by_bios = is_disabled,
> @@ -7329,6 +7334,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>         .nested_get_evmcs_version = NULL,
>
>         .need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
> +
> +       .supported_xss = svm_supported_xss,
>  };
>
>  static int __init svm_init(void)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c6f6b05004d9..a84198cff397 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1651,6 +1651,11 @@ static inline bool vmx_feature_control_msr_valid(struct kvm_vcpu *vcpu,
>         return !(val & ~valid_bits);
>  }
>
> +static inline u64 vmx_supported_xss(void)
> +{
> +       return host_xss;
> +}

Do you really need vendor-specific code for this? Can't you just hoist
host_xss into common code (x86.c) and use that? [Note that Aaron Lewis
is currently working on a series that will include that hoisting, if
you want to wait.]


>  static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
>  {
>         switch (msr->index) {
> @@ -7799,6 +7804,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>         .nested_enable_evmcs = NULL,
>         .nested_get_evmcs_version = NULL,
>         .need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
> +       .supported_xss = vmx_supported_xss,
>  };
>
>  static void vmx_cleanup_l1d_flush(void)
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 6594020c0691..fbffabad0370 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -293,6 +293,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
>                                 | XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
>                                 | XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>                                 | XFEATURE_MASK_PKRU)
> +
> +/*
> + * Right now, no XSS states are used on x86 platform,
> + * expand the macro for new features.
> + */
> +#define KVM_SUPPORTED_XSS      (0)
> +

Nit: superfluous parentheses.

>  extern u64 host_xcr0;
>
>  extern u64 kvm_supported_xcr0(void);
> --
> 2.17.2
>
