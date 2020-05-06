Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563F31C7705
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 18:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730606AbgEFQs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 12:48:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:56576 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730597AbgEFQs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 12:48:57 -0400
IronPort-SDR: 6dieWrb4oYcWOHIyr1uJ+SK6IA8SevS8fEsZ6Ua3LwCYWnEagenicAfM0cv+QyT3njXtxaAWSd
 DhhK+U1FeAMQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 09:48:56 -0700
IronPort-SDR: KnHuCAnmqGfXB0pKuEQdHQBYzCvEzb6N530gqtP7iz6jU6pLe2UgXNp5Lebzi8XpFaSOOF+RPy
 ICz3eVgkgb8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,360,1583222400"; 
   d="scan'208";a="249816238"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 06 May 2020 09:48:56 -0700
Date:   Wed, 6 May 2020 09:48:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH] kvm: x86: get vmcs12 pages before checking pending
 interrupts
Message-ID: <20200506164856.GE3329@linux.intel.com>
References: <20200505232201.923-1-oupton@google.com>
 <262881d0-cc24-99c2-2895-c5cbdc3487d0@redhat.com>
 <20200506152555.GA3329@linux.intel.com>
 <1f91d445-c3f3-fe35-3d65-0b7e0a6ff699@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f91d445-c3f3-fe35-3d65-0b7e0a6ff699@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 06:00:03PM +0200, Paolo Bonzini wrote:
> On 06/05/20 17:25, Sean Christopherson wrote:
> >>
> >> The patch is a bit ad hoc, I'd rather move the whole "if
> >> (kvm_request_pending(vcpu))" from vcpu_enter_guest to vcpu_run (via a
> >> new function).
> > It might make sense to go with an ad hoc patch to get the thing fixed, then
> > worry about cleaning up the pending request crud.  It'd be nice to get rid
> > of the extra nested_ops->check_events() call in kvm_vcpu_running(), as well
> > as all of the various request checks in (or triggered by) vcpu_block().
> 
> Yes, I agree that there are unnecessary tests in kvm_vcpu_running() if
> requests are handled before vcpu_block and that would be a nice cleanup,
> but I'm asking about something less ambitious.
> 
> Can you think of something that can go wrong if we just move all
> requests, except for KVM_REQ_EVENT, up from vcpu_enter_guest() to
> vcpu_run()?  That might be more or less as ad hoc as Oliver's patch, but
> without the code duplication at least.

I believe the kvm_hv_has_stimer_pending() check in kvm_vcpu_has_events()
will get messed up, e.g. handling KVM_REQ_HV_STIMER will clear the pending
bit.  No idea if that can interact with HLT though.

Everything else looks ok, but I didn't exactly do a thorough audit.

My big concern is that we'd break something and never notice because the
failure mode would be a delayed interrupt or poor performance in various
corner cases.  Don't get me wrong, I'll all for hoisting request handling
out of vcpu_enter_guest(), but if we're goint to risk breaking things I'd
prefer to commit to a complete cleanup.
