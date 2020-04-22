Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CE51B4F48
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 23:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgDVVXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 17:23:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:42234 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbgDVVXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 17:23:53 -0400
IronPort-SDR: esLUHnzWsISZovPsf8p8khKwqlRJu+e6HRVULo1eXsBnXLjTwJSh4wi28BFa6AEeFGEpiHxNEI
 pd0SKs4w9bQw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 14:23:53 -0700
IronPort-SDR: AbvNQrSxD5N/sGBDom6xfAJwsM1JdXyU9XA1oodrKpMmCJBBv/hZDmR3wfXfxmAdfLmCOc2ZY4
 MLn73vbN+uUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,304,1583222400"; 
   d="scan'208";a="334753249"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 22 Apr 2020 14:23:52 -0700
Date:   Wed, 22 Apr 2020 14:23:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 1/2] kvm: nVMX: Pending debug exceptions trump expired
 VMX-preemption timer
Message-ID: <20200422212352.GB5823@linux.intel.com>
References: <20200414000946.47396-1-jmattson@google.com>
 <20200422210649.GA5823@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422210649.GA5823@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 02:06:49PM -0700, Sean Christopherson wrote:
> On Mon, Apr 13, 2020 at 05:09:45PM -0700, Jim Mattson wrote:
> > Fixes: f4124500c2c13 ("KVM: nVMX: Fully emulate preemption timer")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> 
> ...
> 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 83050977490c..aae01253bfba 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -4682,7 +4682,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
> >  			if (is_icebp(intr_info))
> >  				WARN_ON(!skip_emulated_instruction(vcpu));
> >  
> > -			kvm_queue_exception(vcpu, DB_VECTOR);
> > +			kvm_requeue_exception(vcpu, DB_VECTOR);
> 
> This isn't wrong per se, but it's effectively papering over an underlying
> bug, e.g. the same missed preemption timer bug can manifest if the timer
> expires while in KVM context (because the hr timer is left running) and KVM
> queues an exception for _any_ reason.

I just reread your changelog and realized this patch was intended to fix a
different symptom than what I observed, i.e. the above probably doesn't
make a whole lot of sense.  I just so happened that this change also
resolved my "missing timer" bug because directly injecting the #DB would
cause vmx_check_nested_events() to return -EBUSY on the preemption timer.

That being said, I'm 99% certain that the behavior you observed is fixed by
correctly handling priority of non-exiting events vs. exiting events, i.e.
slightly different justification, same net result.
