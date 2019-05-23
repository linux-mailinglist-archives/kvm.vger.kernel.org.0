Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA8F28041
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 16:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730933AbfEWOxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 10:53:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:4283 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730672AbfEWOxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 10:53:13 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP; 23 May 2019 07:53:12 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga008.fm.intel.com with ESMTP; 23 May 2019 07:53:12 -0700
Date:   Thu, 23 May 2019 07:53:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     kvm@vger.kernel.org
Subject: Re: Interaction between host-side mprotect() and KVM MMU
Message-ID: <20190523145312.GB12078@linux.intel.com>
References: <20190521072434.p4rtnbkerk5jqwh4@nodbug.lucina.net>
 <20190521140238.GA22089@linux.intel.com>
 <20190523092703.ddze6zcfsm2cj6kc@nodbug.lucina.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190523092703.ddze6zcfsm2cj6kc@nodbug.lucina.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 23, 2019 at 11:27:03AM +0200, Martin Lucina wrote:
> On Tuesday, 21.05.2019 at 07:02, Sean Christopherson wrote:
> > > Questions:
> > > 
> > > a. Is this the intended behaviour, and can it be relied on? Note that
> > > KVM/aarch64 behaves the same for me.
> > > 
> > > b. Why does case (1) fail but case (2) succeed? I spent a day reading
> > > through the KVM MMU code, but failed to understand how this is implemented.
> > 
> > Case (1) fails because KVM explicitly grabs WRITE permissions when
> > retrieving the HPA.  See __gfn_to_pfn_memslot() and hva_to_pfn().
> > Note, KVM also allows userspace to set a guest memslot as RO
> > independent of mprotect().
> 
> Thanks for the pointers. I'm aware of the ability to set a memslot as RO,
> but currently we use a single memslot + mprotect() as it suits our loader
> architecture better (see below).
> 
> > Case (2) doesn't fault because KVM doesn't support execute protection,
> > i.e. all pages are executable in the guest (at least on x86).  My guess
> > is that execute protection isn't supported because there isn't a strong
> > use case for traditional virtualization and so no one has gone through
> > the effort to add NX support.  E.g. the vast majority of system memory
> > can be dynamically allocated (for userspace code), which practically
> > speaking leaves only the guest kernel's data sections, and marking those
> > NX requires at a minimum:
> > 
> >   - knowing exactly what kernel will be loaded
> >   - no ASLR in the physical domain
> >   - no transient execution, e.g. in vBIOS or trampoline code
> 
> In the Solo5 case we're using hardware virtualization in a non-traditional
> sense, as an isolation layer for a static guest (i.e. no changes to
> physical memory layout or page protections after "boot"). The guest is
> considered untrusted and all [*] the setup is performed by the loader/VMM
> ("tender" in our terminology), which has all the knowledge of what gets
> loaded into the VM available up front. So your points above are not an
> issue.

I assumed as much, I was simply pointing out why KVM historically has not
supported NX.

> [*] well, almost all, the guest sets up its own IDT in order to report
> exceptions and abort
> 
> > 
> > > c. In order to enforce W^X both ways I'd like to have case (2) also fail
> > > with EFAULT, is this possible?
> > 
> > Not without modifying KVM and the kernel (if you want to do it through
> > mprotect()).
> 
> Hooking up the full EPT protection bits available to KVM via mprotect()
> would be the best solution for us, and could also give us the ability to
> have execute-only pages on x86, which is a nice defence against ROP attacks
> in the guest. However, I can see now that this is not a trivial
> undertaking, especially across the various MMU models (tdp, softmmu) and
> architectures dealt with by the core KVM code.
> 
> N.B. We also have tender implementations for bhyve and OpenBSD vmm, and at
> least in the OpenBSD case some community contributors are looking into
> developing an "ept_mprotect" for precisely this use-case, though their vmm
> code is much simpler (and does less) compared to KVM.
> 
> I take it there's no other way to mark a range of pages as NX by the guest
> from the host side, so if we want this without modifying KVM and the
> kernel, the only way to get it would be to set up "real" page tables inside
> the guest ...?

Correct, KVM does currently support marking pages NX from the host.  But
note that when EPT is enabled, KVM does not intercept writes to CR3, i.e.
the guest can configure and load its own page page tables to bypass the
restrictions of the tender, which may or may not be an issue.

On the other hand, modifying KVM to support NX via mprotect() in a limited
capacity might be a relatively low effort option, e.g. support it as a
per-module opt-in feature only when using TDP (EPT or NPT).
