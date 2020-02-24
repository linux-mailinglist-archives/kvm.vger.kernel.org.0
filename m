Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7098716B554
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 00:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgBXXXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 18:23:08 -0500
Received: from mga05.intel.com ([192.55.52.43]:28122 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727081AbgBXXXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 18:23:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 15:23:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,481,1574150400"; 
   d="scan'208";a="350025802"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 24 Feb 2020 15:23:07 -0800
Date:   Mon, 24 Feb 2020 15:23:07 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 43/61] KVM: x86: Use KVM cpu caps to mark CR4.LA57 as
 not-reserved
Message-ID: <20200224232307.GQ29865@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-44-sean.j.christopherson@intel.com>
 <8736azocyp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8736azocyp.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 24, 2020 at 11:08:30PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Add accessor(s) for KVM cpu caps and use said accessor to detect
> > hardware support for LA57 instead of manually querying CPUID.
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/cpuid.h | 13 +++++++++++++
> >  arch/x86/kvm/x86.c   |  2 +-
> >  2 files changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> > index 7b71ae0ca05e..5ce4219d465f 100644
> > --- a/arch/x86/kvm/cpuid.h
> > +++ b/arch/x86/kvm/cpuid.h
> > @@ -274,6 +274,19 @@ static __always_inline void kvm_cpu_cap_set(unsigned x86_feature)
> >  	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
> >  }
> >  
> > +static __always_inline u32 kvm_cpu_cap_get(unsigned x86_feature)
> > +{
> > +	unsigned x86_leaf = x86_feature / 32;
> > +
> > +	reverse_cpuid_check(x86_leaf);
> > +	return kvm_cpu_caps[x86_leaf] & __feature_bit(x86_feature);
> > +}
> > +
> > +static __always_inline bool kvm_cpu_cap_has(unsigned x86_feature)
> > +{
> > +	return kvm_cpu_cap_get(x86_feature);
> > +}
> 
> I know this works (and I even checked C99 to make sure that it works not
> by accident) but I have to admit that explicit '!!' conversion to bool
> always makes me feel safer :-)

Eh, the flip side of blasting it everywhere is that people then forget why
the pattern exists in the first place and don't understand when it's truly
necessary.

> > +
> >  static __always_inline void kvm_cpu_cap_check_and_set(unsigned x86_feature)
> >  {
> >  	if (boot_cpu_has(x86_feature))
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index c5ed199d6cd9..cb40737187a1 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -912,7 +912,7 @@ static u64 kvm_host_cr4_reserved_bits(struct cpuinfo_x86 *c)
> >  {
> >  	u64 reserved_bits = __cr4_reserved_bits(cpu_has, c);
> >  
> > -	if (cpuid_ecx(0x7) & feature_bit(LA57))
> > +	if (kvm_cpu_cap_has(X86_FEATURE_LA57))
> >  		reserved_bits &= ~X86_CR4_LA57;
> >  
> >  	if (kvm_x86_ops->umip_emulated())
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
> 
