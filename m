Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F76B3C5A15
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 13:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245435AbhGLJ0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 05:26:40 -0400
Received: from mga09.intel.com ([134.134.136.24]:54855 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1387166AbhGLJZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 05:25:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10042"; a="209923690"
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="209923690"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 02:22:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="502065850"
Received: from michael-optiplex-9020.sh.intel.com (HELO localhost) ([10.239.159.182])
  by fmsmga002.fm.intel.com with ESMTP; 12 Jul 2021 02:22:23 -0700
Date:   Mon, 12 Jul 2021 17:36:26 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        like.xu.linux@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v5 05/13] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_CTL for
 guest Arch LBR
Message-ID: <20210712093626.GC12162@intel.com>
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-6-git-send-email-weijiang.yang@intel.com>
 <CALMp9eR8mbVXS5E6sB7TwEocytpWcG_6w-ijmfxAd4ciHPtfmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eR8mbVXS5E6sB7TwEocytpWcG_6w-ijmfxAd4ciHPtfmw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 09, 2021 at 02:55:35PM -0700, Jim Mattson wrote:
> On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> >
> > From: Like Xu <like.xu@linux.intel.com>
> >
> > Arch LBRs are enabled by setting MSR_ARCH_LBR_CTL.LBREn to 1. A new guest
> > state field named "Guest IA32_LBR_CTL" is added to enhance guest LBR usage.
> > When guest Arch LBR is enabled, a guest LBR event will be created like the
> > model-specific LBR does. Clear guest LBR enable bit on host PMI handling so
> > guest can see expected config.
> >
> > On processors that support Arch LBR, MSR_IA32_DEBUGCTLMSR[bit 0] has no
> > meaning. It can be written to 0 or 1, but reads will always return 0.
> > Like IA32_DEBUGCTL, IA32_ARCH_LBR_CTL msr is also reserved on INIT.
> 
> I suspect you mean "preserved" rather than "reserved."
Yes, should be preserved.

> 
> > Signed-off-by: Like Xu <like.xu@linux.intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/events/intel/lbr.c      |  2 --
> >  arch/x86/include/asm/msr-index.h |  1 +
> >  arch/x86/include/asm/vmx.h       |  2 ++
> >  arch/x86/kvm/vmx/pmu_intel.c     | 31 ++++++++++++++++++++++++++-----
> >  arch/x86/kvm/vmx/vmx.c           |  9 +++++++++
> >  5 files changed, 38 insertions(+), 7 deletions(-)
> >
> 
> > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > index da68f0e74702..4500c564c63a 100644
> > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > @@ -19,6 +19,11 @@
> >  #include "pmu.h"
> >
> >  #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
> > +/*
> > + * Regardless of the Arch LBR or legacy LBR, when the LBR_EN bit 0 of the
> > + * corresponding control MSR is set to 1, LBR recording will be enabled.
> > + */
> 
> Is this comment misplaced? It doesn't seem to have anything to do with
> the macro being defined below.
Agree, will put this in commit message.
> 
> > @@ -458,6 +467,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >                 lbr_desc->records.nr = data;
> >                 lbr_desc->arch_lbr_reset = true;
> >                 return 0;
> > +       case MSR_ARCH_LBR_CTL:
> > +               if (data & ~KVM_ARCH_LBR_CTL_MASK)
> 
> Is a static mask sufficient? Per the Intel® Architecture Instruction
> Set Extensions and Future Features Programming Reference, some of
> these bits may not be supported on all microarchitectures. See Table
> 7-8. CPUID Leaf 01CH Enumeration of Architectural LBR Capabilities.
Yes, more sanity checks are required, thanks!

> 
> > +                       break;
> > +               vmcs_write64(GUEST_IA32_LBR_CTL, data);
> > +               if (intel_pmu_lbr_is_enabled(vcpu) && !lbr_desc->event &&
> > +                   (data & ARCH_LBR_CTL_LBREN))
> > +                       intel_pmu_create_guest_lbr_event(vcpu);
> 
> Nothing has to be done when the LBREN bit goes from 1 to 0?
Need to release the event and reset related flag when the bit goes from
1 to 0. Thanks!
> 
> > +               return 0;
> >         default:
> >                 if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
> >                     (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> 
> Per the Intel® Architecture Instruction Set Extensions and Future
> Features Programming Reference, "IA32_LBR_CTL.LBREn is saved and
> cleared on #SMI, and restored on RSM." I don't see that happening
> anywhere. That manual also says, "On a warm reset...IA32_LBR_CTL.LBREn
> is cleared to 0, disabling LBRs." I don't see that happening either.

Yes, I'll add related code to make it consistent with spec, thanks!
> 
> I have a question about section 7.1.4.4 in that manual. It says, "On a
> debug breakpoint event (#DB), IA32_LBR_CTL.LBREn is cleared." When,
> exactly, does that happen? In particular, if kvm synthesizes such an
> event (for example, in kvm_vcpu_do_singlestep), does
> IA32_LBR_CTL.LBREn automatically get cleared (after loading the guest
> IA32_LBR_CTL value from the VMCS)? Or does kvm need to explicitly
> clear that bit in the VMCS before injecting the #DB?
OK, I don't have answer now, will ask the Arch to get clear answer on this,
thanks for raising the question!

