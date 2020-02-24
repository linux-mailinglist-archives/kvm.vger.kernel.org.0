Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4B216B478
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 23:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbgBXWqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 17:46:14 -0500
Received: from mga12.intel.com ([192.55.52.136]:37123 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727459AbgBXWqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 17:46:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 14:46:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,481,1574150400"; 
   d="scan'208";a="284488539"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Feb 2020 14:46:11 -0800
Date:   Mon, 24 Feb 2020 14:46:13 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 29/61] KVM: x86: Add Kconfig-controlled auditing of
 reverse CPUID lookups
Message-ID: <20200224224613.GO29865@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-30-sean.j.christopherson@intel.com>
 <87a758oztt.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a758oztt.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 24, 2020 at 02:54:38PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Add WARNs in the low level __cpuid_entry_get_reg() to assert that the
> > function and index of the CPUID entry and reverse CPUID entry match.
> > Wrap the WARNs in a new Kconfig, KVM_CPUID_AUDIT, as the checks add
> > almost no value in a production environment, i.e. will only detect
> > blatant KVM bugs and fatal hardware errors.  Add a Kconfig instead of
> > simply wrapping the WARNs with an off-by-default #ifdef so that syzbot
> > and other automated testing can enable the auditing.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/Kconfig | 10 ++++++++++
> >  arch/x86/kvm/cpuid.h |  5 +++++
> >  2 files changed, 15 insertions(+)
> >
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index 840e12583b85..bbbc3258358e 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -96,6 +96,16 @@ config KVM_MMU_AUDIT
> >  	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
> >  	 auditing of KVM MMU events at runtime.
> >  
> > +config KVM_CPUID_AUDIT
> > +	bool "Audit KVM reverse CPUID lookups"
> > +	depends on KVM
> > +	help
> > +	 This option enables runtime checking of reverse CPUID lookups in KVM
> > +	 to verify the function and index of the referenced X86_FEATURE_* match
> > +	 the function and index of the CPUID entry being accessed.
> > +
> > +	 If unsure, say N.
> > +
> >  # OK, it's a little counter-intuitive to do this, but it puts it neatly under
> >  # the virtualization menu.
> >  source "drivers/vhost/Kconfig"
> > diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> > index 51f19eade5a0..41ff94a7d3e0 100644
> > --- a/arch/x86/kvm/cpuid.h
> > +++ b/arch/x86/kvm/cpuid.h
> > @@ -98,6 +98,11 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
> >  static __always_inline u32 *__cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
> >  						  const struct cpuid_reg *cpuid)
> >  {
> > +#ifdef CONFIG_KVM_CPUID_AUDIT
> > +	WARN_ON_ONCE(entry->function != cpuid->function);
> > +	WARN_ON_ONCE(entry->index != cpuid->index);
> > +#endif
> > +
> >  	switch (cpuid->reg) {
> >  	case CPUID_EAX:
> >  		return &entry->eax;
> 
> Honestly, I was thinking we should BUG_ON() and even in production builds
> but not everyone around is so rebellious I guess, so

LOL.  It's a waste of cycles for something that will "never" be hit, i.e.
we _really_ dropped the ball if a bug of this natures makes it into a
kernel release.
 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
> 
