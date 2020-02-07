Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2334155B41
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 16:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbgBGP46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 10:56:58 -0500
Received: from mga06.intel.com ([134.134.136.31]:46283 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgBGP46 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 10:56:58 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 07:56:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,413,1574150400"; 
   d="scan'208";a="225415707"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 07 Feb 2020 07:56:57 -0800
Date:   Fri, 7 Feb 2020 07:56:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 08/61] KVM: x86: Warn on zero-size save state for valid
 CPUID 0xD.N sub-leaf
Message-ID: <20200207155657.GD2401@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-9-sean.j.christopherson@intel.com>
 <87blqaqtnw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87blqaqtnw.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 04:54:59PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > WARN if the save state size for a valid XCR0-managed sub-leaf is zero,
> > which would indicate a KVM or CPU bug.  Add a comment to explain why KVM
> > WARNs so the reader doesn't have to tease out the relevant bits from
> > Intel's SDM and KVM's XCR0/XSS code.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index fd9b29aa7abc..424dde41cb5d 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -677,10 +677,17 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
> >  				goto out;
> >  
> >  			do_host_cpuid(&entry[i], function, idx);
> > -			if (entry[i].eax == 0)
> > -				continue;
> > -			if (WARN_ON_ONCE(entry[i].ecx & 1))
> > +
> > +			/*
> > +			 * The @supported check above should have filtered out
> > +			 * invalid sub-leafs as well as sub-leafs managed by
> 
> Is it 'sub-leafs' or 'sub-leaves' actually? :-)

Yes.  :-D
