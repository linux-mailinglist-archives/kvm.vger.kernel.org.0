Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841AB20B784
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 19:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgFZRq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 13:46:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:36360 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgFZRq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 13:46:58 -0400
IronPort-SDR: fjVVEEmjpsaycc64h2hBVENdASby/JvVgeeqLUQ6rdmerqu35+yveRNKS+HeyNpxavrzVBDI+S
 sGOspIFVQR/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="230187434"
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="230187434"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 10:46:57 -0700
IronPort-SDR: dnPWY4aOQAmu8Y6pAJbPOH/Hk96PNW7P7QOcQa0yYdaa6APHNk53F15krq6a+lPzZyPMkZT+fG
 QTxKxYtipmfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="312385857"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2020 10:46:57 -0700
Date:   Fri, 26 Jun 2020 10:46:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Message-ID: <20200626174657.GF6583@linux.intel.com>
References: <20200622220442.21998-1-peterx@redhat.com>
 <20200622220442.21998-2-peterx@redhat.com>
 <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com>
 <df859fb0-a665-a82a-0cf1-8db95179cb74@redhat.com>
 <20200626155657.GC6583@linux.intel.com>
 <20200626173750.GA175520@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626173750.GA175520@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 26, 2020 at 01:37:50PM -0400, Peter Xu wrote:
> On Fri, Jun 26, 2020 at 08:56:57AM -0700, Sean Christopherson wrote:
> > Not really?  It's solving a problem that doesn't exist in the current code
> > base (assuming TSC_CTRL is fixed), and IMO solving it in an ugly fashion.
> > 
> > I would much prefer that, _if_ we want to support blind KVM-internal MSR
> > accesses, we end up with code like:
> > 
> > 	if (msr_info->kvm_internal) {
> > 		return 1;
> > 	} else if (!ignore_msrs) {
> > 		vcpu_debug_ratelimited(vcpu, "unhandled wrmsr: 0x%x data 0x%llx\n",
> > 			    msr, data);
> > 		return 1;
> > 	} else {
> > 		if (report_ignored_msrs)
> > 			vcpu_unimpl(vcpu,
> > 				"ignored wrmsr: 0x%x data 0x%llx\n",
> > 				msr, data);
> > 		break;
> > 	}
> > 
> > But I'm still not convinced that there is a legimiate scenario for setting
> > kvm_internal=true.
> 
> Actually this really looks like my initial version when I was discussing this
> with Paolo before this version, but Paolo suggested what I implemented last.  I
> think I agree with Paolo that it's an improvement to have a way to get/set real
> msr value so that we don't need to further think about effects being taken with
> the two tricky msr knobs (report_ignored_msrs, ignore_msrs).  These knobs are
> even trickier to me when they're hidden deep, because they are not easily
> expected when seeing the name of the functions (e.g. __kvm_set_msr, rather than
> __kvm_set_msr_retval_fixed).

My argument is that it's a KVM bug if we ever encounter do the wrong thing
based on a KVM-internal MSR access.  The proposed change would actually make
it _harder_ to find the bug that prompted this patch, as the bogus
__kvm_get_msr() in kvm_cpuid() would silently fail.

If anything, I would argue for something like:

	if (WARN_ON_ONCE(msr_info->kvm_internal)) {
		return 1;
	} else if (!ignore_msrs) {
		...
	} else {
		...
	}

I.e. KVM-internal accesses should always pre-validate the existence of the
MSR, if not the validity of the MSR from the guest's perspective.
