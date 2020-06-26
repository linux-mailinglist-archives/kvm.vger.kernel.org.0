Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B443220B570
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 17:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbgFZP46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 11:56:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:24803 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbgFZP46 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 11:56:58 -0400
IronPort-SDR: uZQOJbZQHU7FIEjatT2pAbXG+e0xawdGTY1SLzdpGToUcjg487EUGVs4cM9QXBTmRBrAqz3Mu1
 g3AvZvTQCkHQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="230146587"
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="230146587"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 08:56:57 -0700
IronPort-SDR: j+HuT071Nr3F3FGpKOZF8ToqB4YfiJFxn9esIc79m4HAcTKwxP/nrGkykJA7rdjQjkHYdehxx2
 Pe6gTsaglh7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="276400676"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 26 Jun 2020 08:56:57 -0700
Date:   Fri, 26 Jun 2020 08:56:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Message-ID: <20200626155657.GC6583@linux.intel.com>
References: <20200622220442.21998-1-peterx@redhat.com>
 <20200622220442.21998-2-peterx@redhat.com>
 <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com>
 <df859fb0-a665-a82a-0cf1-8db95179cb74@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df859fb0-a665-a82a-0cf1-8db95179cb74@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 25, 2020 at 08:44:16PM +0200, Paolo Bonzini wrote:
> On 25/06/20 18:25, Sean Christopherson wrote:
> > I get the "what" of the change, and even the "why" to some extent, but I
> > dislike the idea of supporting/encouraging blind reads/writes to MSRs.
> > Blind writes are just asking for problems, and suppressing warnings on reads
> > is almost guaranteed to be suppressing a KVM bug.
> 
> Right, that's why this patch does not just suppress warnings: it adds a
> different return value to detect the case.
> 
> > TSC_CTRL aside, if we insist on pointing a gun at our foot at some point,
> > this should be a dedicated flavor of MSR access, e.g. msr_data.kvm_initiated,
> > so that it at least requires intentionally loading the gun.
> 
> With this patch, __kvm_get_msr does not know about ignore_msrs at all,
> that seems to be strictly an improvement; do you agree with that?

Not really?  It's solving a problem that doesn't exist in the current code
base (assuming TSC_CTRL is fixed), and IMO solving it in an ugly fashion.

I would much prefer that, _if_ we want to support blind KVM-internal MSR
accesses, we end up with code like:

	if (msr_info->kvm_internal) {
		return 1;
	} else if (!ignore_msrs) {
		vcpu_debug_ratelimited(vcpu, "unhandled wrmsr: 0x%x data 0x%llx\n",
			    msr, data);
		return 1;
	} else {
		if (report_ignored_msrs)
			vcpu_unimpl(vcpu,
				"ignored wrmsr: 0x%x data 0x%llx\n",
				msr, data);
		break;
	}

But I'm still not convinced that there is a legimiate scenario for setting
kvm_internal=true.

> What would you think about adding warn_unused_result to __kvm_get_msr?

I guess I wouldn't object to it, but that seems like an orthogonal issue.
