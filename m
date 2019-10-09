Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF25FD075A
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 08:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbfJIGlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 02:41:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:63970 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfJIGlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 02:41:45 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 23:41:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="183975463"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 08 Oct 2019 23:41:41 -0700
Date:   Wed, 9 Oct 2019 14:43:39 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v7 4/7] KVM: VMX: Load Guest CET via VMCS when CET is
 enabled in Guest
Message-ID: <20191009064339.GC27851@local-michael-cet-test>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
 <20190927021927.23057-5-weijiang.yang@intel.com>
 <CALMp9eS1V2fRcwogcEkHonvVAgfc9dU=7A4V-D0Rcoc=v82VAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eS1V2fRcwogcEkHonvVAgfc9dU=7A4V-D0Rcoc=v82VAw@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 02, 2019 at 11:54:26AM -0700, Jim Mattson wrote:
> On Thu, Sep 26, 2019 at 7:17 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
> >
> > "Load Guest CET state" bit controls whether Guest CET states
> > will be loaded at Guest entry. Before doing that, KVM needs
> > to check if CPU CET feature is enabled on host and available
> > to Guest.
> >
> > Note: SHSTK and IBT features share one control MSR:
> > MSR_IA32_{U,S}_CET, which means it's difficult to hide
> > one feature from another in the case of SHSTK != IBT,
> > after discussed in community, it's agreed to allow Guest
> > control two features independently as it won't introduce
> > security hole.
> >
> > Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 35 +++++++++++++++++++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index f720baa7a9ba..ba1a83d11e69 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -44,6 +44,7 @@
> >  #include <asm/spec-ctrl.h>
> >  #include <asm/virtext.h>
> >  #include <asm/vmx.h>
> > +#include <asm/cet.h>
> >
> >  #include "capabilities.h"
> >  #include "cpuid.h"
> > @@ -2918,6 +2919,37 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> >         vmcs_writel(GUEST_CR3, guest_cr3);
> >  }
> >
> > +static int set_cet_bit(struct kvm_vcpu *vcpu, unsigned long cr4)
> 
> Nit: This function does not appear to set CR4.CET, as the name would imply.
>
OK, will change it, thank you!
> > +{
> > +       struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +       const u64 cet_bits = XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL;
> > +       bool cet_xss = vmx_xsaves_supported() &&
> > +                      (kvm_supported_xss() & cet_bits);
> > +       bool cet_cpuid = guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > +                        guest_cpuid_has(vcpu, X86_FEATURE_IBT);
> > +       bool cet_on = !!(cr4 & X86_CR4_CET);
> > +
> > +       if (cet_on && vmx->nested.vmxon)
> > +               return 1;
> 
> This constraint doesn't appear to be architected. Also, this prevents
> enabling CR4.CET when in VMX operation, but what about the other way
> around (i.e. entering VMX operation with CR4.CET enabled)?
> 
Yes, will think more for nested case in next release.

> > +       if (cet_on && !cpu_x86_cet_enabled())
> > +               return 1;
> 
> This seems odd. Why is kernel support for (SHSTK or IBT) required for
> the guest to use (SHSTK or IBT)? If there's a constraint, shouldn't it
> be 1:1? (i.e. kernel support for SHSTK is required for the guest to
> use SHSTK and kernel support for IBT is required for the guest to use
> IBT?) Either way, enforcement of this constraint seems late, here,
> when the guest is trying to set CR4 to a value that, per the guest
> CPUID information, should be legal. Shouldn't this constraint be
> applied when setting the guest CPUID information, disallowing the
> enumeration of SHSTK and/or IBT support on a platform where these
> features are unavailable or disabled in the kernel?
> 
In KVM do_cpuid_7_mask(), SHSTK/IBT flags are emulated with
cpuid(0x7,0), there in cpuid_mask(), it'll enforce the check against
host kernel CET status,
and host boot_cpu_data.x86_capability[X86_FEATURE_SHSTK/IBT] will be cleared
during host boot up if the feature is disabled or unavailable.

You may check the kernel CET patch.

Rgarding the 1:1 check, I'll add more strict check in next version,
thanks!

> > +       if (cet_on && !cet_xss)
> > +               return 1;
> 
> Again, this constraint seems like it's being applied too late.
> Returning 1 here will result in the guest's MOV-to-CR4 raising #GP,
> even though there is no architected reason for it to do so.
> 
see above.
> > +       if (cet_on && !cet_cpuid)
> > +               return 1;
> 
> What about the constraint that CR4.CET can't be set when CR0.WP is
> clear? (And the reverse needs to be handled in vmx_set_cr0).
> 
OK, will check this case, thank you!
> > +       if (cet_on)
> > +               vmcs_set_bits(VM_ENTRY_CONTROLS,
> > +                             VM_ENTRY_LOAD_GUEST_CET_STATE);
> 
> Have we ensured that this VM-entry control is supported on the platform?
> 
If all the checks pass, is it enought to ensure the control bit supported?
> > +       else
> > +               vmcs_clear_bits(VM_ENTRY_CONTROLS,
> > +                               VM_ENTRY_LOAD_GUEST_CET_STATE);
> > +       return 0;
> > +}
> > +
> >  int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> >  {
> >         struct vcpu_vmx *vmx = to_vmx(vcpu);
> > @@ -2958,6 +2990,9 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> >                         return 1;
> >         }
> >
> > +       if (set_cet_bit(vcpu, cr4))
> > +               return 1;
> > +
> >         if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
> >                 return 1;
> >
> > --
> > 2.17.2
> >
