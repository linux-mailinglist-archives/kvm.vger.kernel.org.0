Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DAA42E5C4
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbhJOBQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:16:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:23823 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhJOBQ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:16:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="214988210"
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="214988210"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 18:14:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="660202696"
Received: from michael-optiplex-9020.sh.intel.com (HELO localhost) ([10.239.159.182])
  by orsmga005.jf.intel.com with ESMTP; 14 Oct 2021 18:14:20 -0700
Date:   Fri, 15 Oct 2021 09:28:21 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        jmattson@google.com, like.xu.linux@gmail.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 15/15] KVM: x86/cpuid: Advise Arch LBR feature in CPUID
Message-ID: <20211015012821.GA29942@intel.com>
References: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
 <1629791777-16430-16-git-send-email-weijiang.yang@intel.com>
 <YWjE0iQ6fDdJpDfT@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWjE0iQ6fDdJpDfT@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021 at 12:01:22AM +0000, Sean Christopherson wrote:
> s/Advise/Advertise
> 
> On Tue, Aug 24, 2021, Yang Weijiang wrote:
> > Add Arch LBR feature bit in CPU cap-mask to expose the feature.
> > Only max LBR depth is supported for guest, and it's consistent
> > with host Arch LBR settings.
> > 
> > Co-developed-by: Like Xu <like.xu@linux.intel.com>
> > Signed-off-by: Like Xu <like.xu@linux.intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 33 ++++++++++++++++++++++++++++++++-
> >  1 file changed, 32 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 03025eea1524..d98ebefd5d72 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -88,6 +88,16 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
> >  		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
> >  			return -EINVAL;
> >  	}
> > +	best = cpuid_entry2_find(entries, nent, 0x1c, 0);
> > +	if (best) {
> > +		unsigned int eax, ebx, ecx, edx;
> > +
> > +		/* Reject user-space CPUID if depth is different from host's.*/
> 
> Why disallow this?  I don't see why it would be illegal for userspace to specify
> fewer LBRs, and KVM should darn well verify that any MSRs it's exposing to the
> guest actually exist.
Hi, Sean,
Thanks for the comments!
The treatment for LBR depth is a bit special, only the host value can be
supported now, i.e., 32. If userspace set the value other that 32, would like
to notify it as early as possible.
Do you want to remove the check here and correct the invalid setting silently when
guest is querying CPUID?

> 
> > +		cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx);
> > +
> > +		if ((best->eax & 0xff) != BIT(fls(eax & 0xff) - 1))
> > +			return -EINVAL;
> > +	}
> >  
> >  	return 0;
> >  }
