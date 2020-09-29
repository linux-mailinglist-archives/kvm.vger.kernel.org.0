Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1732B27BF8F
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 10:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgI2IdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 04:33:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:28183 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727861AbgI2Ic7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 04:32:59 -0400
IronPort-SDR: Bzm53Qv815IqFbYKkSqPJknws+FHB0QfUOZnuEpKlI16Ce3YWymc76Wg8HsCadCVr/q3qG5boP
 H39LM86/KQag==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="162208087"
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="162208087"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 01:32:55 -0700
IronPort-SDR: ffF4X8xUM90uT9z1sAE6xYa7icy/8e2mMQp7+7pFB7Lq7fHgztXFbYrcO526yzj7DQFDC795bg
 RqssajENttnA==
X-IronPort-AV: E=Sophos;i="5.77,317,1596524400"; 
   d="scan'208";a="338542200"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 01:32:54 -0700
Date:   Tue, 29 Sep 2020 01:32:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 1/2] kvm/x86: intercept guest changes to X86_CR4_LA57
Message-ID: <20200929083250.GM353@linux.intel.com>
References: <20200928083047.3349-1-jiangshanlai@gmail.com>
 <20200928162417.GA28825@linux.intel.com>
 <CAJhGHyAYXARENZ7OExenZO6tiWAaSQ=jzEG+7j0rjCsa9e5-dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyAYXARENZ7OExenZO6tiWAaSQ=jzEG+7j0rjCsa9e5-dA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 29, 2020 at 01:32:45PM +0800, Lai Jiangshan wrote:
> On Tue, Sep 29, 2020 at 12:24 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Mon, Sep 28, 2020 at 04:30:46PM +0800, Lai Jiangshan wrote:
> > > From: Lai Jiangshan <laijs@linux.alibaba.com>
> > >
> > > When shadowpaping is enabled, guest should not be allowed
> > > to toggle X86_CR4_LA57. And X86_CR4_LA57 is a rarely changed
> > > bit, so we can just intercept all the attempts to toggle it
> > > no matter shadowpaping is in used or not.
> > >
> > > Fixes: fd8cb433734ee ("KVM: MMU: Expose the LA57 feature to VM.")
> > > Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Cc: Yu Zhang <yu.c.zhang@linux.intel.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> > > ---
> > >   No test to toggle X86_CR4_LA57 in guest since I can't access to
> > >   any CPU supports it. Maybe it is not a real problem.
> >
> 
> 
> Hello
> 
> Thanks for reviewing.
> 
> > LA57 doesn't need to be intercepted.  It can't be toggled in 64-bit mode
> > (causes a #GP), and it's ignored in 32-bit mode.  That means LA57 can only
> > take effect when 64-bit mode is enabled, at which time KVM will update its
> > MMU context accordingly.
> >
> 
> Oh, I missed that part which is so obvious that the patch
> seems impertinent.
> 
> But X86_CR4_LA57 is so fundamental that it makes me afraid to
> give it over to guests. And it is rarely changed too. At least,
> there is no better reason to give it to the guest than
> intercepting it.
> 
> There might be another reason that this patch is still needed with
> an updated changelog.
> 
> When a user (via VMM such as qemu) launches a VM with LA57 disabled
> in its cpuid on a LA57 enabled host. The hypervisor, IMO, needs to
> intercept guest's changes to X86_CR4_LA57 even when the guest is still
> in the non-paging mode. Otherwise the hypervisor failed to detective
> such combination when the guest changes paging mode later.
> 
> Anyway, maybe it is still not a real problem.

Oof, the above is a KVM bug, though in a more generic manner.  All reserved
bits should be intercepted, not just LA57.  LA57 is the only affected bit at
the moment, but proper support is needed as the follow-on patch to let the
guest toggle FSGSBASE would introduce the same bug.

Sadly, fixing this is a bit of a mess.  Well, fixing LA57 is easy, e.g. this
patch will do the trick.  But actually refreshing the CR4 guest/host mask when
the guest's CPUID is updated is a pain, and that's what's needed for proper
FSGSBASE support.

I'll send a series, bookended by these two RFC patches, with patches to
intercept CR4 reserved bits smushed in between.  I agree there's no point in
letting the guest write LA57 directly, it's almost literally a once-per-boot
thing.  I wouldn't be surprised if intercepting it is a net win (but still
inconsequential), e.g. due to the MMU having to grab CR4 out of the VMCS.
