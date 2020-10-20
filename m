Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63742940B7
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 18:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394793AbgJTQoz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 12:44:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:20163 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394778AbgJTQoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 12:44:55 -0400
IronPort-SDR: hsvXLRQTt8BiAJpN3IP9alCdJCyLXk1cTRldyNLuCN00da7hbi8z+NKk2xOGUoKN5/3MqaJ4VL
 2a/D/KPbfJJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="184875546"
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="184875546"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 09:44:54 -0700
IronPort-SDR: TuKjR3MtzejCLcy3+zJuaHR2i4+QTwZmYMoQkY0c2sb3/SPUvZQoa1Tp+CjNCye5GdvzC/Qz0i
 VcRDAALVrF5w==
X-IronPort-AV: E=Sophos;i="5.77,397,1596524400"; 
   d="scan'208";a="332311820"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 09:44:52 -0700
Date:   Tue, 20 Oct 2020 09:44:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, xiaoyao.li@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, robert.hu@intel.com
Subject: Re: [RFC PATCH 1/9] KVM:x86: Abstract sub functions from
 kvm_update_cpuid_runtime() and kvm_vcpu_after_set_cpuid()
Message-ID: <20201020164450.GC28909@linux.intel.com>
References: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
 <1596163347-18574-2-git-send-email-robert.hu@linux.intel.com>
 <20200929045649.GM31514@linux.intel.com>
 <364312b2e7effbf50d4327c06c61d6157bc08386.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <364312b2e7effbf50d4327c06c61d6157bc08386.camel@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 20, 2020 at 01:38:32PM +0800, Robert Hoo wrote:
> On Mon, 2020-09-28 at 21:56 -0700, Sean Christopherson wrote:
> > > +
> > > +	best = kvm_find_cpuid_entry(vcpu, 1, 0);
> > > +
> > > +	if (best && boot_cpu_has(X86_FEATURE_XSAVE)) {
> > 
> > Braces not needed. We should also check boot_cpu_has() first, it's constant
> > time and maybe even in the cache, whereas finding CPUID entries is linear
> > time and outright slow.
> > 
> > Actually, can you add a helper to handle this?  With tht boot_cpu_has()
> > check outside of the helper?  That'll allow the helper to be used for more
> > features, and will force checking boot_cpu_has() first.  Hmm, and not all
> > of the callers will need the boot_cpu_has() check, e.g. toggling PKE from
> > kvm_set_cr4() doesn't need to be guarded because KVM disallows setting PKE
> > if it's not supported by the host.
> 
> Do you mean because in kvm_set_cr4(), it has kvm_valid_cr4(vcpu, cr4)
> check first?

Yes.

> Then how about the other 2 callers of kvm_pke_update_cpuid()?
> enter_smm() -- I think it can ommit boot_cpu_has() check as well.
> because it unconditionally cleared all CR4 bit before calls
> kvm_set_cr4().
> __set_sregs() -- looks like it doesn't valid host PKE status before
> call kvm_pke_update_cpuid(). Can I ommit boot_cpu_has() as well?
> 
> So, I don't think kvm_pke_update_cpuid() can leverage the helper. Am I
> right?

It can leverage the guest_cpuid_change() helper below, no?
 
> > static inline void guest_cpuid_change(struct kvm_vcpu *vcpu, u32
> > function,
> > 				      u32 index, unsigned int feature,
> > bool set)
> > {
> > 	struct kvm_cpuid_entry2 *e =  kvm_find_cpuid_entry(vcpu,
> > function, index);
> > 
> > 	if (e)
> > 		cpuid_entry_change(best, X86_FEATURE_OSXSAVE, set);
> > }
> 
> Thanks Sean, I'm going to have this helper in v2 and have your signed-
> off-by.

Eh, no need to give me credit, it's just a snippet in feedback.  It's
not even correct :-)  E.g. s/X86_FEATURE_OSXSAVE/feature below.

> > 
> > > +		cpuid_entry_change(best, X86_FEATURE_OSXSAVE, set);
> > > +	}
> > > +}
