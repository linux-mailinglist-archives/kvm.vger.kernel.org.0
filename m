Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40CF3C59CA
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 13:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353346AbhGLJIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 05:08:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:2442 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345315AbhGLJGZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 05:06:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10042"; a="273781745"
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="273781745"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 02:03:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,232,1620716400"; 
   d="scan'208";a="491948858"
Received: from michael-optiplex-9020.sh.intel.com (HELO localhost) ([10.239.159.182])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Jul 2021 02:03:32 -0700
Date:   Mon, 12 Jul 2021 17:17:36 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        like.xu.linux@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v5 04/13] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for
 guest Arch LBR
Message-ID: <20210712091736.GB12162@intel.com>
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-5-git-send-email-weijiang.yang@intel.com>
 <CALMp9eQveWT=5fzRe_T6BaDbgpeP+kvxBfWmooEPscqcT8KvBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQveWT=5fzRe_T6BaDbgpeP+kvxBfWmooEPscqcT8KvBg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 09, 2021 at 01:35:34PM -0700, Jim Mattson wrote:
> On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> >
> > From: Like Xu <like.xu@linux.intel.com>
> >
> > The number of Arch LBR entries available is determined by the value
> > in host MSR_ARCH_LBR_DEPTH.DEPTH. The supported LBR depth values are
> > enumerated in CPUID.(EAX=01CH, ECX=0):EAX[7:0]. For each bit "n" set
> > in this field, the MSR_ARCH_LBR_DEPTH.DEPTH value of "8*(n+1)" is
> > supported.
> >
> > On a guest write to MSR_ARCH_LBR_DEPTH, all LBR entries are reset to 0.
> > KVM emulates the reset behavior by introducing lbr_desc->arch_lbr_reset.
> > KVM writes guest requested value to the native ARCH_LBR_DEPTH MSR
> > (this is safe because the two values will be the same) when the Arch LBR
> > records MSRs are pass-through to the guest.
> >
> > Signed-off-by: Like Xu <like.xu@linux.intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> 
> > @@ -393,6 +417,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  {
> >         struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> >         struct kvm_pmc *pmc;
> > +       struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> >         u32 msr = msr_info->index;
> >         u64 data = msr_info->data;
> >
> > @@ -427,6 +452,12 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >                         return 0;
> >                 }
> >                 break;
> > +       case MSR_ARCH_LBR_DEPTH:
> > +               if (!arch_lbr_depth_is_valid(vcpu, data))
> > +                       return 1;
> 
> Does this imply that, when restoring a vCPU, KVM_SET_CPUID2 must be
> called before KVM_SET_MSRS, so that arch_lbr_depth_is_valid() knows
> what to do? Is this documented anywhere?
There shoudn't be such kind of assumption :-D, I'll check and modify it.
Thanks for pointing it out!

> 
> > +               lbr_desc->records.nr = data;
> > +               lbr_desc->arch_lbr_reset = true;
> 
> Doesn't this make it impossible to restore vCPU state, since the LBRs
> will be reset on the next VM-entry? At the very least, you probably
> shouldn't set arch_lbr_reset when the MSR write is host-initiated.
Host/Guest operation should be identified, will change it.

> 
> However, there is another problem: arch_lbr_reset isn't serialized
> anywhere. If you fix the host-initiated issue, then you still have a
> problem if the last guest instruction prior to suspending the vCPU was
> a write to IA32_LBR_DEPTH. If there is no subsequent VM-entry prior to
> saving the vCPU state, then the LBRs will be saved/restored as part of
> the guest XSAVE state, and they will not get cleared on resuming the
> vCPU.
Yes, it's a problem, I'll replace the code with a on-spot MSR write to
reset it.

> 
> > +               return 0;
> >         default:
> >                 if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
> >                     (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> > @@ -566,6 +597,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
> >         lbr_desc->records.nr = 0;
> >         lbr_desc->event = NULL;
> >         lbr_desc->msr_passthrough = false;
> > +       lbr_desc->arch_lbr_reset = false;
> 
> I'm not sure this is entirely correct. If the last guest instruction
> prior to a warm reset was a write to IA32_LBR_DEPTH, then the LBRs
> should be cleared (and arch_lbr_reset will be true). However, if you
> clear that flag here, the LBRs will never get cleared.
I hope the on-spot reset can avoid above issue too.
Thanks!

> 
> >  }
> >
