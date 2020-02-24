Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC0916B595
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 00:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgBXXbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 18:31:20 -0500
Received: from mga17.intel.com ([192.55.52.151]:27849 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgBXXbT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 18:31:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 15:31:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,481,1574150400"; 
   d="scan'208";a="284499484"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Feb 2020 15:31:19 -0800
Date:   Mon, 24 Feb 2020 15:31:19 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 48/61] KVM: x86: Do host CPUID at load time to mask KVM
 cpu caps
Message-ID: <20200224233119.GS29865@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-49-sean.j.christopherson@intel.com>
 <87o8tnmwni.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8tnmwni.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 24, 2020 at 11:46:09PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Mask kvm_cpu_caps based on host CPUID in preparation for overriding the
> > CPUID results during KVM_GET_SUPPORTED_CPUID instead of doing the
> > masking at runtime.
> >
> > Note, masking may or may not be necessary, e.g. the kernel rarely, if
> > ever, sets real CPUID bits that are not supported by hardware.  But, the
> > code is cheap and only runs once at load, so an abundance of caution is
> > warranted.
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index ab2a34337588..4416f2422321 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -272,8 +272,22 @@ static __always_inline void cpuid_entry_mask(struct kvm_cpuid_entry2 *entry,
> >  
> >  static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
> >  {
> > +	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
> > +	struct kvm_cpuid_entry2 entry;
> > +
> >  	reverse_cpuid_check(leaf);
> >  	kvm_cpu_caps[leaf] &= mask;
> > +
> > +#ifdef CONFIG_KVM_CPUID_AUDIT
> > +	/* Entry needs to be fully populated when auditing is enabled. */
> > +	entry.function = cpuid.function;
> > +	entry.index = cpuid.index;
> > +#endif
> > +
> > +	cpuid_count(cpuid.function, cpuid.index,
> > +		    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
> > +
> > +	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, &cpuid);
> >  }
> >  
> >  void kvm_set_cpu_caps(void)
> 
> If we don't really believe that masking will actually mask anything,
> maybe we should move it under '#ifdef CONFIG_KVM_CPUID_AUDIT'? And/or 
> add a WARN_ON()?

I'm not opposed to trying that, but I'd definitely want to do it as a
separate patch, or maybe even let it stew separately in kvm/queue for a
few cycles.

> The patch itself looks good, so:
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
> 
