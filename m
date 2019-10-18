Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2871ADBB4C
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2019 03:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409460AbfJRB2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 21:28:08 -0400
Received: from mga05.intel.com ([192.55.52.43]:13423 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407065AbfJRB2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 21:28:08 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Oct 2019 18:28:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,309,1566889200"; 
   d="scan'208";a="208809352"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga001.fm.intel.com with ESMTP; 17 Oct 2019 18:28:06 -0700
Date:   Fri, 18 Oct 2019 09:31:06 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v7 3/7] KVM: VMX: Pass through CET related MSRs to Guest
Message-ID: <20191018013106.GB2286@local-michael-cet-test>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
 <20190927021927.23057-4-weijiang.yang@intel.com>
 <CALMp9eT3HJ3S6Mzzntje2Kb4m-y86GvkhaNXun-mLJukEy6wbA@mail.gmail.com>
 <20191009061509.GB27851@local-michael-cet-test>
 <20191017200411.GL20903@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017200411.GL20903@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 17, 2019 at 01:04:11PM -0700, Sean Christopherson wrote:
> On Wed, Oct 09, 2019 at 02:15:09PM +0800, Yang Weijiang wrote:
> > On Wed, Oct 02, 2019 at 11:18:32AM -0700, Jim Mattson wrote:
> > > > +       kvm_xss = kvm_supported_xss();
> > > > +       cet_en = guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > > > +                guest_cpuid_has(vcpu, X86_FEATURE_IBT);
> > > > +       /*
> > > > +        * U_CET is a must for USER CET, per CET spec., U_CET and PL3_SPP are
> > > > +        * a bundle for USER CET xsaves.
> > > > +        */
> > > > +       if (cet_en && (kvm_xss & XFEATURE_MASK_CET_USER)) {
> > > > +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW);
> > > > +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW);
> > > > +       }
> > > 
> > > Since this is called from vmx_cpuid_update, what happens if cet_en was
> > > previously true and now it's false?
> > > 
> > Yes, it's likely, but guest CPUID usually is fixed before
> > guest is launched, do you have any suggestion?
> 
> Re-enable interception.  kvm_x86_ops->cpuid_update() is only called in
> the ioctl flow, i.e. it's not performance critical.
>
OK, will add a *else* clause to re-intercept the MSRs as Jim suggested.

> > > > +       /*
> > > > +        * S_CET is a must for KERNEL CET, PL0_SSP ... PL2_SSP are a bundle
> > > > +        * for CET KERNEL xsaves.
> > > > +        */
> > > > +       if (cet_en && (kvm_xss & XFEATURE_MASK_CET_KERNEL)) {
> > > > +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW);
> > > > +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW);
> > > > +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW);
> > > > +               vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW);
> > > > +
> > > > +               /* SSP_TAB only available for KERNEL SHSTK.*/
> > > > +               if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> > > > +                       vmx_disable_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB,
> > > > +                                                     MSR_TYPE_RW);
> > > > +       }
> > > > +}
> > > > +
> > > >  static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> > > >  {
> > > >         struct vcpu_vmx *vmx = to_vmx(vcpu);
> > > > @@ -7025,6 +7062,8 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> > > >         if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
> > > >                         guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
> > > >                 update_intel_pt_cfg(vcpu);
> > > > +
> > > > +       vmx_intercept_cet_msrs(vcpu);
> > > >  }
> > > >
> > > >  static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> > > > --
> > > > 2.17.2
> > > >
