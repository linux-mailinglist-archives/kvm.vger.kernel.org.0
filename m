Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D1A11A150
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 03:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbfLKC0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 21:26:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:15739 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727230AbfLKC0C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 21:26:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 18:26:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="387778864"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga005.jf.intel.com with ESMTP; 10 Dec 2019 18:25:59 -0800
Date:   Wed, 11 Dec 2019 10:27:22 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        yu-cheng.yu@intel.com
Subject: Re: [PATCH v8 3/7] KVM: VMX: Pass through CET related MSRs
Message-ID: <20191211022722.GA13190@local-michael-cet-test>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
 <20191101085222.27997-4-weijiang.yang@intel.com>
 <20191210211821.GL15758@linux.intel.com>
 <20191211013207.GA12845@local-michael-cet-test>
 <20191211015052.GF23765@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211015052.GF23765@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 10, 2019 at 05:50:52PM -0800, Sean Christopherson wrote:
> On Wed, Dec 11, 2019 at 09:32:07AM +0800, Yang Weijiang wrote:
> > On Tue, Dec 10, 2019 at 01:18:21PM -0800, Sean Christopherson wrote:
> > > On Fri, Nov 01, 2019 at 04:52:18PM +0800, Yang Weijiang wrote:
> > > > CET MSRs pass through Guest directly to enhance performance.
> > > > CET runtime control settings are stored in MSR_IA32_{U,S}_CET,
> > > > Shadow Stack Pointer(SSP) are stored in MSR_IA32_PL{0,1,2,3}_SSP,
> > > > SSP table base address is stored in MSR_IA32_INT_SSP_TAB,
> > > > these MSRs are defined in kernel and re-used here.
> > > > 
> > > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > > index dd387a785c1e..4166c4fcad1e 100644
> > > > --- a/arch/x86/kvm/cpuid.c
> > > > +++ b/arch/x86/kvm/cpuid.c
> > > > @@ -371,13 +371,13 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
> > > >  		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ |
> > > >  		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
> > > >  		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
> > > > -		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B);
> > > > +		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | F(SHSTK);
> > > >  
> > > >  	/* cpuid 7.0.edx*/
> > > >  	const u32 kvm_cpuid_7_0_edx_x86_features =
> > > >  		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
> > > >  		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> > > > -		F(MD_CLEAR);
> > > > +		F(MD_CLEAR) | F(IBT);
> > > 
> > > Advertising CET to userspace/guest needs to be done at the end of the
> > > series, or at least after CR4.CET is no longer reserved, e.g. KVM_SET_SREGS
> > > will fail and the guest will get a #GP when trying to set CR4.CET.
> > > 
> > > I'm pretty sure I've said this at least twice in previous versions of
> > > this series...
> > 
> > Thanks Sean for picking these up!
> > The reason is, starting from this patch, I'm using guest_cpuid_has(CET)
> > to check the availability of guest CET CPUID, so logically I would like to let
> > the readers understand CET related CPUID word is
> > defined as above. But no problem, I can move these definitions to a
> > latter patch as the patchset only meaningful as a whole. 
> 
> Adding usage of guest_cpuid_has(CET) without advertising CET is perfectly
> ok from a functionality perspective.  Having a user without a consumer
> isn't ideal, but it's better than having one gigantic patch.
> 
> The problem with advertising CET when it's not fully supported is that it
> will break bisection, e.g. trying to boot a CET-enabled guest would get a
> #GP during boot and likely crash.  Whether or not a series is useful when
> taken as a whole is orthogonal to the integrity of each invidiual patch.

Oh, I omitted case likes bisection, you're right, I'll change it, thanks
a lot!

