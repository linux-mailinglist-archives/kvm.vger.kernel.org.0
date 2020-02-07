Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 388BB155EEE
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 20:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgBGTxD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 14:53:03 -0500
Received: from mga04.intel.com ([192.55.52.120]:65025 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbgBGTxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 14:53:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 11:53:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; 
   d="scan'208";a="220892330"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 07 Feb 2020 11:53:01 -0800
Date:   Fri, 7 Feb 2020 11:53:01 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 02/61] KVM: x86: Refactor loop around do_cpuid_func() to
 separate helper
Message-ID: <20200207195301.GM2401@linux.intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-3-sean.j.christopherson@intel.com>
 <87sgjng3ru.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sgjng3ru.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 06, 2020 at 03:59:49PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Move the guts of kvm_dev_ioctl_get_cpuid()'s CPUID func loop to a
> > separate helper to improve code readability and pave the way for future
> > cleanup.
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 45 ++++++++++++++++++++++++++------------------
> >  1 file changed, 27 insertions(+), 18 deletions(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 47ce04762c20..f49fdd06f511 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -839,6 +839,29 @@ static bool is_centaur_cpu(const struct kvm_cpuid_param *param)
> >  	return boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR;
> >  }
> >  
> > +static int get_cpuid_func(struct kvm_cpuid_entry2 *entries, u32 func,
> > +			  int *nent, int maxnent, unsigned int type)
> > +{
> > +	u32 limit;
> > +	int r;
> > +
> > +	r = do_cpuid_func(&entries[*nent], func, nent, maxnent, type);
> > +	if (r)
> > +		return r;
> > +
> > +	limit = entries[*nent - 1].eax;
> > +	for (func = func + 1; func <= limit; ++func) {
> > +		if (*nent >= maxnent)
> > +			return -E2BIG;
> > +
> > +		r = do_cpuid_func(&entries[*nent], func, nent, maxnent, type);
> > +		if (r)
> > +			break;
> > +	}
> > +
> > +	return r;
> > +}
> > +
> >  static bool sanity_check_entries(struct kvm_cpuid_entry2 __user *entries,
> >  				 __u32 num_entries, unsigned int ioctl_type)
> >  {
> > @@ -871,8 +894,8 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
> >  			    unsigned int type)
> >  {
> >  	struct kvm_cpuid_entry2 *cpuid_entries;
> > -	int limit, nent = 0, r = -E2BIG, i;
> > -	u32 func;
> > +	int nent = 0, r = -E2BIG, i;
> 
> Not this patches fault, but I just noticed that '-E2BIG' initializer
> here is only being used for 
> 
>  'if (cpuid->nent < 1)'
> 
> case so I have two suggestion:
> 1) Return directly without the 'goto' , drop the initializer.

Great minds think alike ;-)

> 2) Return -EINVAL instead.

I agree that it _should_ be -EINVAL, but I just don't think it's worth
the possibility of breaking (stupid) userspace that was doing something
like:

	for (i = 0; i < max_cpuid_size; i++) {
		cpuid.nent = i;

		r = ioctl(fd, KVM_GET_SUPPORTED_CPUID, &cpuid);
		if (!r || r != -E2BIG)
			break;
	}
