Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 896C2DB810
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 21:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389123AbfJQT4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 15:56:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:54060 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727383AbfJQT4o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 15:56:44 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 12:56:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,308,1566889200"; 
   d="scan'208";a="226287773"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga002.fm.intel.com with ESMTP; 17 Oct 2019 12:56:41 -0700
Date:   Thu, 17 Oct 2019 12:56:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v7 5/7] kvm: x86: Add CET CR4 bit and XSS support
Message-ID: <20191017195642.GJ20903@linux.intel.com>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
 <20190927021927.23057-6-weijiang.yang@intel.com>
 <CALMp9eStz-VCv5G60KFtumQ8W1Jqf9bOcK_=KwL1P3LLjgajnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eStz-VCv5G60KFtumQ8W1Jqf9bOcK_=KwL1P3LLjgajnQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 02, 2019 at 12:05:23PM -0700, Jim Mattson wrote:
> On Thu, Sep 26, 2019 at 7:17 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
> >
> > CR4.CET(bit 23) is master enable bit for CET feature.
> > Previously, KVM did not support setting any bits in XSS
> > so it's hardcoded to check and inject a #GP if Guest
> > attempted to write a non-zero value to XSS, now it supports
> > CET related bits setting.
> >
> > Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  4 +++-
> >  arch/x86/kvm/cpuid.c            | 11 +++++++++--
> >  arch/x86/kvm/vmx/vmx.c          |  6 +-----
> >  3 files changed, 13 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index d018df8c5f32..8f97269d6d9f 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -90,7 +90,8 @@
> >                           | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_PCIDE \
> >                           | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
> >                           | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
> > -                         | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP))
> > +                         | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
> > +                         | X86_CR4_CET))
> >
> >  #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
> >
> > @@ -623,6 +624,7 @@ struct kvm_vcpu_arch {
> >
> >         u64 xcr0;
> >         u64 guest_supported_xcr0;
> > +       u64 guest_supported_xss;
> >         u32 guest_xstate_size;
> >
> >         struct kvm_pio_request pio;
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 0a47b9e565be..dd3ddc6daa58 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -120,8 +120,15 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> >         }
> >
> >         best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
> > -       if (best && (best->eax & (F(XSAVES) | F(XSAVEC))))
> > -               best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> > +       if (best && (best->eax & (F(XSAVES) | F(XSAVEC)))) {
> 
> Is XSAVEC alone sufficient? Don't we explicitly need XSAVES to
> save/restore the extended state components enumerated by IA32_XSS?

Hmm, I think the check would be ok as-is if vcpu->arch.ia32_xss is used
below, as ia32_xss is guaranteed to be zero if XSAVES isn't supported.

> > +               u64 kvm_xss = kvm_supported_xss();
> > +
> > +               best->ebx =
> > +                       xstate_required_size(vcpu->arch.xcr0 | kvm_xss, true);
> 
> Shouldn't this size be based on the *current* IA32_XSS value, rather
> than the supported IA32_XSS bits? (i.e.
> s/kvm_xss/vcpu->arch.ia32_xss/)

Ya.

> > +               vcpu->arch.guest_supported_xss = best->ecx & kvm_xss;
> 
> Shouldn't unsupported bits in best->ecx be masked off, so that the
> guest CPUID doesn't mis-report the capabilities of the vCPU?

I thought KVM liked to let userspace blow off their foot whenever possible?
KVM already enumerated what features are supported, it's a userspace bug
if it ignores the enumeration.

> > +       } else {
> > +               vcpu->arch.guest_supported_xss = 0;
> > +       }
> >
> >         /*
