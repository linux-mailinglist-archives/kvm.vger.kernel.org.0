Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AC6D3118
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 21:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfJJTEx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 15:04:53 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39568 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbfJJTEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 15:04:52 -0400
Received: by mail-io1-f68.google.com with SMTP id a1so16176281ioc.6
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 12:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W6MyvVE0eBaDj0DuImlooBl1Swx9/iYzpr3ha7apj4Q=;
        b=Y2PnsLizNi10y0AQijqSryDRPc8hLvGIHO2wCV8Mnj7U+8ARZjBdonzqoBjIl0m7PB
         g31oP3wP8AxO7p/M9ldOuGap34mbJu2IWUr6cS0XFSkYaSTKrI9neMz1YsTRHi1N/+1O
         m8wMNXyV1gIqwIZXpFoiZ1+IOUPdcy/sICFCVlZ6xjn7YlJ0+BFOjpC/TUeROg22njQK
         FrSp74iLfSSZr4w4h7xctma4Rl3/n6/HPF0EPuW3yozzbsDw9Gkj/dX2KmEWZYKeiPtZ
         t9EYb+3lbJn34K0DMT42h90EOCvV+Vrs+wXuXtxaPIPkpWljvsYY7l5GX6+L46NqG9R2
         EJuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W6MyvVE0eBaDj0DuImlooBl1Swx9/iYzpr3ha7apj4Q=;
        b=p0N1rS7dnBCQ0E23/KoIpByW9AFnGCAcJ+rZfyycXhd/FjjgpLPnvCYqMkeiFdVvRH
         kyBKArfsvvQLwf3SWxnddqepL6yPK4xMCW71XYVUsCdTjv+Be/o1FkasjqgrzpxZMFu6
         D+P/NgOZCrWdYQy17WYuU2lVere7gW4tAY0u4cC9hraNyVIhv7bUl6w8QmZ0zpXZTrWz
         kzK1zbbehNHN8KrAncwqZcPKPzwIsIOxNSblkky0WSTHAXRiquKxVrKrs5dgt+p6AgCr
         CNLmMkvKiSmaNIkYozOSxDr70V0gpS+d1Uj+4SqrdxuwKH1hd9g+2nmLtK/SjYreMpx5
         N/LQ==
X-Gm-Message-State: APjAAAXO7UmvwsB51qPsbssRMY3JheospnxkkxYrt2JTRglLj/JlmfZf
        Xec4xgg+UVDWupCpiqzc4rYcjTiP0250nS50JVqUZWwd
X-Google-Smtp-Source: APXvYqyDapEPzr9nfKiT7XcVdqga4sq5RRhPysLdHLDjEhYcHw3eXS6QxZl5vGe6khsIa/ztyDX0HI+SeR1/f8mysKY=
X-Received: by 2002:a6b:7d4b:: with SMTP id d11mr12241184ioq.40.1570734291240;
 Thu, 10 Oct 2019 12:04:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190927021927.23057-1-weijiang.yang@intel.com>
 <20190927021927.23057-4-weijiang.yang@intel.com> <CALMp9eT3HJ3S6Mzzntje2Kb4m-y86GvkhaNXun-mLJukEy6wbA@mail.gmail.com>
 <20191009061509.GB27851@local-michael-cet-test>
In-Reply-To: <20191009061509.GB27851@local-michael-cet-test>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 10 Oct 2019 12:04:40 -0700
Message-ID: <CALMp9eT-6HGQSKpDGBD6poujSXc-KckaR__Re3RiiMuVse1t8Q@mail.gmail.com>
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

On Tue, Oct 8, 2019 at 11:13 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
>
> On Wed, Oct 02, 2019 at 11:18:32AM -0700, Jim Mattson wrote:
> > On Thu, Sep 26, 2019 at 7:17 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
> > >
> > > CET MSRs pass through Guest directly to enhance performance.
> > > CET runtime control settings are stored in MSR_IA32_{U,S}_CET,
> > > Shadow Stack Pointer(SSP) are stored in MSR_IA32_PL{0,1,2,3}_SSP,
> > > SSP table base address is stored in MSR_IA32_INT_SSP_TAB,
> > > these MSRs are defined in kernel and re-used here.
> >
> > All of these new guest MSRs will have to be enumerated by
> > KVM_GET_MSR_INDEX_LIST.
> >
> Since CET feature is Intel platform specific, but looks like KVM_GET_MSR_INDEX_LIST
> fetchs x86 common MSRs, I have patch in QEMU to support CET
> MSRs, the patch is here:
> https://patchwork.ozlabs.org/patch/1058265/

Qemu is not the only user of kvm. All possible guest MSRs for the
platform *must* be enumerated by KVM_GET_MSR_INDEX_LIST. A number of
Intel-specific MSRs are already enumerated.

> > > MSR_IA32_U_CET and MSR_IA32_PL3_SSP are used for user mode protection,
> > > the contents could differ from process to process, therefore,
> > > kernel needs to save/restore them during context switch, it makes
> > > sense to pass through them so that the guest kernel can
> > > use xsaves/xrstors to operate them efficiently. Other MSRs are used
> > > for non-user mode protection. See CET spec for detailed info.
> >
> > I assume that XSAVES & XRSTORS bypass the MSR permission bitmap, like
> > other instructions that manipulate MSRs (e.g. SWAPGS, RDTSCP, etc.).
> > Is the guest OS likely to use RDMSR/WRMSR to access these MSRs?
> >
> Yes, exactly, you may check the CET kernel code.
>
> > > The difference between CET VMCS state fields and xsave components is that,
> > > the former used for CET state storage during VMEnter/VMExit,
> > > whereas the latter used for state retention between Guest task/process
> > > switch.
> > >
> > > Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> > > Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > ---
> > >  arch/x86/kvm/cpuid.c   |  1 +
> > >  arch/x86/kvm/cpuid.h   |  2 ++
> > >  arch/x86/kvm/vmx/vmx.c | 39 +++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 42 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index 1aa86b87b6ab..0a47b9e565be 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -66,6 +66,7 @@ u64 kvm_supported_xss(void)
> > >  {
> > >         return KVM_SUPPORTED_XSS & kvm_x86_ops->supported_xss();
> > >  }
> > > +EXPORT_SYMBOL_GPL(kvm_supported_xss);
> > >
> > >  #define F(x) bit(X86_FEATURE_##x)
> > >
> > > diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> > > index d78a61408243..1d77b880084d 100644
> > > --- a/arch/x86/kvm/cpuid.h
> > > +++ b/arch/x86/kvm/cpuid.h
> > > @@ -27,6 +27,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
> > >
> > >  int cpuid_query_maxphyaddr(struct kvm_vcpu *vcpu);
> > >
> > > +u64 kvm_supported_xss(void);
> > > +
> > >  static inline int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
> > >  {
> > >         return vcpu->arch.maxphyaddr;
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index a84198cff397..f720baa7a9ba 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -7001,6 +7001,43 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
> > >                 vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
> > >  }
> > >
> > > +static void vmx_intercept_cet_msrs(struct kvm_vcpu *vcpu)
> >
> > Nit: It seems like this function adjusts the MSR permission bitmap so
> > as *not* to intercept the CET MSRs.
> >
> OK, will rename it.
> > > +{
> > > +       struct vcpu_vmx *vmx = to_vmx(vcpu);
> > > +       unsigned long *msr_bitmap;
> > > +       u64 kvm_xss;
> > > +       bool cet_en;
> > > +
> > > +       msr_bitmap = vmx->vmcs01.msr_bitmap;
> >
> > What about nested guests? (i.e. vmcs02).
> >
> Hmm, I need to check the nested case, thank you.
>
> > > +       kvm_xss = kvm_supported_xss();
> > > +       cet_en = guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > > +                guest_cpuid_has(vcpu, X86_FEATURE_IBT);
> > > +       /*
> > > +        * U_CET is a must for USER CET, per CET spec., U_CET and PL3_SPP are
> > > +        * a bundle for USER CET xsaves.
> > > +        */
> > > +       if (cet_en && (kvm_xss & XFEATURE_MASK_CET_USER)) {
> > > +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW);
> > > +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW);
> > > +       }
> >
> > Since this is called from vmx_cpuid_update, what happens if cet_en was
> > previously true and now it's false?
> >
> Yes, it's likely, but guest CPUID usually is fixed before
> guest is launched, do you have any suggestion?

How about an else clause?

> > > +       /*
> > > +        * S_CET is a must for KERNEL CET, PL0_SSP ... PL2_SSP are a bundle
> > > +        * for CET KERNEL xsaves.
> > > +        */
> > > +       if (cet_en && (kvm_xss & XFEATURE_MASK_CET_KERNEL)) {
> > > +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW);
> > > +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW);
> > > +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW);
> > > +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW);
> > > +
> > > +               /* SSP_TAB only available for KERNEL SHSTK.*/
> > > +               if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> > > +                       vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB,
> > > +                                                     MSR_TYPE_RW);
> > > +       }
> > > +}
> > > +
> > >  static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> > >  {
> > >         struct vcpu_vmx *vmx = to_vmx(vcpu);
> > > @@ -7025,6 +7062,8 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> > >         if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
> > >                         guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
> > >                 update_intel_pt_cfg(vcpu);
> > > +
> > > +       vmx_intercept_cet_msrs(vcpu);
> > >  }
> > >
> > >  static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> > > --
> > > 2.17.2
> > >
