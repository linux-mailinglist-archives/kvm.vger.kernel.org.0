Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A14137238
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 17:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgAJQEy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 11:04:54 -0500
Received: from mga05.intel.com ([192.55.52.43]:43158 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728480AbgAJQEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 11:04:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jan 2020 08:04:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,417,1571727600"; 
   d="scan'208";a="218699478"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 10 Jan 2020 08:04:53 -0800
Date:   Fri, 10 Jan 2020 08:04:53 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>,
        Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v2 2/2] KVM: x86/mmu: Micro-optimize nEPT's bad
 memptype/XWR checks
Message-ID: <20200110160453.GA21485@linux.intel.com>
References: <20200109230640.29927-1-sean.j.christopherson@intel.com>
 <20200109230640.29927-3-sean.j.christopherson@intel.com>
 <878smfr18i.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878smfr18i.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 10, 2020 at 12:37:33PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > @@ -128,6 +128,21 @@ static inline int FNAME(is_present_gpte)(unsigned long pte)
> >  #endif
> >  }
> >  
> > +static bool FNAME(is_bad_mt_xwr)(struct rsvd_bits_validate *rsvd_check, u64 gpte)
> > +{
> > +#if PTTYPE != PTTYPE_EPT
> > +	return false;
> > +#else
> > +	return __is_bad_mt_xwr(rsvd_check, gpte);
> > +#endif
> > +}
> > +
> > +static bool FNAME(is_rsvd_bits_set)(struct kvm_mmu *mmu, u64 gpte, int level)
> > +{
> > +	return __is_rsvd_bits_set(&mmu->guest_rsvd_check, gpte, level) ||
> > +	       FNAME(is_bad_mt_xwr)(&mmu->guest_rsvd_check, gpte);
> > +}
> > +
> 
> Not sure if it would make sense/difference (well, this is famous KVM
> MMU!) but as FNAME(is_bad_mt_xwr)
> 
> has only one call site we could've as well merged it, something like:
> 
> static bool FNAME(is_rsvd_bits_set)(struct kvm_mmu *mmu, u64 gpte, int level)
> {
> #if PTTYPE == PTTYPE_EPT
> 	bool res =  __is_bad_mt_xwr(&mmu->guest_rsvd_check, gpte);
> #else
> 	bool res = false;
> #endif
> 	return __is_rsvd_bits_set(&mmu->guest_rsvd_check, gpte, level) || res;
> }
> 
> but keeping it in-line with __is_rsvd_bits_set()/__is_bad_mt_xwr() in
> mmu.c likely has greater benefits.

Ya, I don't love the code, but it was the least awful of the options I
tried, in that it's the most readable without being too obnoxious.


Similar to your suggestion, but it avoids evaluating __is_bad_mt_xwr() if
reserved bits are set, which is admittedly rare.

	return __is_rsvd_bits_set(&mmu->guest_rsvd_check, gpte, level)
#if PTTYPE == PTTYPE_EPT
	       || __is_bad_mt_xwr(&mmu->guest_rsvd_check, gpte)
#endif
	       ;

Or macrofying the call to keep the call site clean, but IMO this obfuscates
things too much.

	return __is_rsvd_bits_set(&mmu->guest_rsvd_check, gpte, level) ||
	       IS_BAD_MT_XWR(&mmu->guest_rsvd_check, gpte);
