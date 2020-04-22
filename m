Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFC11B4914
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 17:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbgDVPtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 11:49:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:54517 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726547AbgDVPtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 11:49:18 -0400
IronPort-SDR: UdsBYjYQrnxepoDmwnanjv0i/RO2NM/MWC2mUvQ3aZN2nW2QO51Vjznx5ZNaDjNhNBlPJLhwSy
 rcLKvqOkfrMw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 08:48:55 -0700
IronPort-SDR: /yTj2gLkZ5TaN+R+SQlX3qxaihZyN/7wQ4CcYcRq+gWll2Yv/0HQkSmRMQmj+oTRh7ol3q7EpG
 uw4aDP2NXaPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,303,1583222400"; 
   d="scan'208";a="334664043"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 22 Apr 2020 08:48:55 -0700
Date:   Wed, 22 Apr 2020 08:48:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 2/2] kvm: nVMX: Single-step traps trump expired
 VMX-preemption timer
Message-ID: <20200422154855.GA4662@linux.intel.com>
References: <20200414000946.47396-1-jmattson@google.com>
 <20200414000946.47396-2-jmattson@google.com>
 <83426123-eca6-568d-ac3e-36c4e3ca3030@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83426123-eca6-568d-ac3e-36c4e3ca3030@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 10:30:28AM +0200, Paolo Bonzini wrote:
> On 14/04/20 02:09, Jim Mattson wrote:
> > Previously, if the hrtimer for the nested VMX-preemption timer fired
> > while L0 was emulating an L2 instruction with RFLAGS.TF set, the
> > synthesized single-step trap would be unceremoniously dropped when
> > synthesizing the "VMX-preemption timer expired" VM-exit from L2 to L1.
> > 
> > To fix this, don't synthesize a "VMX-preemption timer expired" VM-exit
> > from L2 to L1 when there is a pending debug trap, such as a
> > single-step trap.
> 
> Do you have a testcase for these bugs?

Just in case you're feeling trigger happy, I'm working on a set of patches
to fix this in a more generic fashion.  Well, fixing this specific issue
can be done in a single patch, but NMIs and interrupts technically suffer
from the same bug and fixing those requires a bit of extra elbow grease.

There are also (theoretical) bugs related to nested exceptions and
interrupt injection that I'm trying to address.  Unfortunately I don't have
testcases for any of this :-(.
