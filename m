Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509951B1DA2
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 06:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgDUElm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 00:41:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:35504 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbgDUElm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 00:41:42 -0400
IronPort-SDR: yOQrUmOaUCpHElOUtZyssJNh8aW6SenPq6PXtsmjulhr/rjDXx37mtqDaz/XN3Q/FfIEFua+zj
 VUp7Slbc5f1A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 21:41:41 -0700
IronPort-SDR: tm2G/P8tOt05yQhJ6J3r0Ej1edu5yIef89ZlDAqIcMrif5Z5Cf1+FWr4WAhswFS7LOLi9Jm4TL
 eSt81DfRth5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,409,1580803200"; 
   d="scan'208";a="290330414"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 20 Apr 2020 21:41:41 -0700
Date:   Mon, 20 Apr 2020 21:41:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 2/2] kvm: nVMX: Single-step traps trump expired
 VMX-preemption timer
Message-ID: <20200421044141.GE11134@linux.intel.com>
References: <20200414000946.47396-1-jmattson@google.com>
 <20200414000946.47396-2-jmattson@google.com>
 <20200414031705.GP21204@linux.intel.com>
 <CALMp9eT23AUTU3m_oADKw3O_NMpuX3crx7eqSB8Rbgh3k0s_Jw@mail.gmail.com>
 <20200415001212.GA12547@linux.intel.com>
 <CALMp9eS-s5doptTzVkE2o9jDYuGU3T=5azMhm3fCqLJPcABAOg@mail.gmail.com>
 <20200418042108.GF15609@linux.intel.com>
 <CALMp9eQpwnhD7H3a9wC=TnL3=OKmvHAmVFj=r9OBaWiBEGhR4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQpwnhD7H3a9wC=TnL3=OKmvHAmVFj=r9OBaWiBEGhR4Q@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 20, 2020 at 10:18:42AM -0700, Jim Mattson wrote:
> On Fri, Apr 17, 2020 at 9:21 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Wed, Apr 15, 2020 at 04:33:31PM -0700, Jim Mattson wrote:
> > > On Tue, Apr 14, 2020 at 5:12 PM Sean Christopherson
> > > <sean.j.christopherson@intel.com> wrote:
> > > >
> > > > On Tue, Apr 14, 2020 at 09:47:53AM -0700, Jim Mattson wrote:
> > > Yes, it's wrong in the abstract, but with respect to faults and the
> > > VMX-preemption timer expiration, is there any way for either L1 or L2
> > > to *know* that the virtual CPU has done something wrong?
> >
> > I don't think so?  But how is that relevant, i.e. if we can fix KVM instead
> > of fudging the result, why wouldn't we fix KVM?
> 
> I'm not sure that I can fix KVM. The missing #DB traps were relatively
> straightforward, but as for the rest of this mess...
> 
> Since you seem to have a handle on what needs to be done, I will defer to
> you.

I wouldn't go so far as to say I have a handle on it, more like I have an
idea of how to fix one part of the overall problem with a generic "rule"
change that also happens to (hopefully) resolve the #DB+MTF issue.

Anyways, I'll send a patch.  Worst case scenario it fails miserably and we
go with this patch :-)

> > > Isn't it generally true that if you have an exception queued when you
> > > transition from L2 to L1, then you've done something wrong? I wonder
> > > if the call to kvm_clear_exception_queue() in prepare_vmcs12() just
> > > serves to sweep a whole collection of problems under the rug.
> >
> > More than likely, yes.
> >
> > > > In general, interception of an event doesn't change the priority of events,
> > > > e.g. INTR shouldn't get priority over NMI just because if L1 wants to
> > > > intercept INTR but not NMI.
> > >
> > > Yes, but that's a different problem altogether.
> >
> > But isn't the fix the same?  Stop processing events if a higher priority
> > event is pending, regardless of whether the event exits to L1.
> 
> That depends on how you see the scope of the problem. One could argue
> that the fix for everything that is wrong with KVM is actually the
> same: properly emulate the physical CPU.

Heh, there is that.

What I'm arguing is that we shouldn't throw in a workaround knowing that
it's papering over the underlying issue.  Preserving event priority
irrespective of VM-Exit behavior is different, in that while it may not
resolve all issues that are being masked by kvm_clear_exception_queue(),
the change itself is correct when viewed in a vacuum.
