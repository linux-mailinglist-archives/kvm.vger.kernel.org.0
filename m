Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC9616B35E
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 22:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgBXVzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 16:55:53 -0500
Received: from mga05.intel.com ([192.55.52.43]:22185 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727421AbgBXVzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 16:55:52 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 13:55:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,481,1574150400"; 
   d="scan'208";a="226127573"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 24 Feb 2020 13:55:51 -0800
Date:   Mon, 24 Feb 2020 13:55:51 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/61] KVM: x86: Encapsulate CPUID entries and metadata
 in struct
Message-ID: <20200224215551.GL29865@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-17-sean.j.christopherson@intel.com>
 <87y2swq95k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2swq95k.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 21, 2020 at 03:58:47PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > @@ -539,7 +549,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
> >  		entry->flags |= KVM_CPUID_FLAG_STATE_READ_NEXT;
> >  
> >  		for (i = 1, max_idx = entry->eax & 0xff; i < max_idx; ++i) {
> > -			if (!do_host_cpuid(&entry[i], nent, maxnent, function, 0))
> > +			entry = do_host_cpuid(array, 2, 0);
> 
> I'd change this to 
>                         entry = do_host_cpuid(array, function, 0);
> 
> to match other call sites.

Done.  That did look weird, no idea why I decided to hardcode only this one.

> > +			if (!entry)
> >  				goto out;
> >  		}
> >  		break;
> > @@ -802,22 +814,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
> >  	return r;
> >  }
> >  
> > -static int do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 func,
> > -			 int *nent, int maxnent, unsigned int type)
> > +static int do_cpuid_func(struct kvm_cpuid_array *array, u32 func,
> > +			 unsigned int type)
> >  {
> > -	if (*nent >= maxnent)
> > +	if (array->nent >= array->maxnent)
> >  		return -E2BIG;
> >  
> >  	if (type == KVM_GET_EMULATED_CPUID)
> > -		return __do_cpuid_func_emulated(entry, func, nent, maxnent);
> > +		return __do_cpuid_func_emulated(array, func);
> 
> Would it make sense to move 'if (array->nent >= array->maxnent)' check
> to __do_cpuid_func_emulated() to match do_host_cpuid()?

I considered doing exactly that.  IIRC, I opted not to because at this
point in the series, the initial call to do_host_cpuid() is something like
halfway down the massive __do_cpuid_func(), and eliminating the early check
didn't feel quite right, e.g. there is a fair amount of unnecessary code
that runs before hitting the first do_host_cpuid().

What if I add a patch towards the end of the series to move this check into
__do_cpuid_func_emulated(), i.e. after __do_cpuid_func() has been trimmed
down to size and the early check really is superfluous.
