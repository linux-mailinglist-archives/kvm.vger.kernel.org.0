Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F483B246D
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 03:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFXBTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 21:19:37 -0400
Received: from mga14.intel.com ([192.55.52.115]:40314 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhFXBTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 21:19:37 -0400
IronPort-SDR: Iqz2jjuCPKNrnDXAJniKHmCEnESYRGUFj4x+6vL463WUHF+e93zm38VZqtFJmdk6xTVq48yB0G
 k4zpq2pBceCA==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="207190800"
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="207190800"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 18:17:18 -0700
IronPort-SDR: NR2Gye2FEa7sQSnQC5PG3Ds95YPz3GHN/2KXN/B2xht+EijZK05K2qEC9eUynuA4yZYjLIcBeL
 TGSuaWtk/aFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="490922753"
Received: from michael-optiplex-9020.sh.intel.com (HELO localhost) ([10.239.159.182])
  by fmsmga002.fm.intel.com with ESMTP; 23 Jun 2021 18:17:15 -0700
Date:   Thu, 24 Jun 2021 09:31:53 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH v4 03/10] KVM: vmx/pmu: Add MSR_ARCH_LBR_DEPTH
 emulation for Arch LBR
Message-ID: <20210624013153.GA15841@intel.com>
References: <20210510081535.94184-1-like.xu@linux.intel.com>
 <20210510081535.94184-4-like.xu@linux.intel.com>
 <CALMp9eT-KL-xDgV9p31NgnbW2tnwPes7r6GhJbMedim5e9Ab4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eT-KL-xDgV9p31NgnbW2tnwPes7r6GhJbMedim5e9Ab4g@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021 at 11:03:39AM -0700, Jim Mattson wrote:
> On Mon, May 10, 2021 at 1:16 AM Like Xu <like.xu@linux.intel.com> wrote:
> >
> > The number of Arch LBR entries available for recording operations
> > is dictated by the value in MSR_ARCH_LBR_DEPTH.DEPTH. The supported
> > LBR depth values can be found in CPUID.(EAX=01CH, ECX=0):EAX[7:0]
> > and for each bit "n" set in this field, the MSR_ARCH_LBR_DEPTH.DEPTH
> > value of "8*(n+1)" is supported.
> >
> > On a guest write to MSR_ARCH_LBR_DEPTH, all LBR entries are reset to 0.
> > KVM emulates the reset behavior by introducing lbr_desc->arch_lbr_reset.
> > KVM writes the guest requested value to the native ARCH_LBR_DEPTH MSR
> > (this is safe because the two values will be the same) when the Arch LBR
> > records MSRs are pass-through to the guest.
> >
> > Signed-off-by: Like Xu <like.xu@linux.intel.com>
> > ---
> >  arch/x86/kvm/vmx/pmu_intel.c | 43 ++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/vmx.h       |  3 +++
> >  2 files changed, 46 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > index 9efc1a6b8693..d9c9cb6c9a4b 100644
> > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > @@ -220,6 +220,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
> >         case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> >                 ret = pmu->version > 1;
> >                 break;
> > +       case MSR_ARCH_LBR_DEPTH:
> > +               ret = guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
> > +               break;
> 
> This doesn't seem like a very safe test, since userspace can provide
> whatever CPUID tables it likes. You should definitely think about
> hardening this code against a malicious userspace.
> 
> When you add a new guest MSR, it should be enumerated by
> KVM_GET_MSR_INDEX_LIST. Otherwise, userspace will not save/restore the
> MSR value on suspend/resume.

Thanks Jim! Will improve this part in next version.
