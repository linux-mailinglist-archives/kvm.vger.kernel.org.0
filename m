Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6D833C9CB
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 00:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbhCOXMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 19:12:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233597AbhCOXMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 19:12:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A90864F5F;
        Mon, 15 Mar 2021 23:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615849919;
        bh=abzZVSkTzdpC08WLb2c2fDosMgxwdN1K2LUNPPtj9/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oc7wo2EFRjY5MvWB7E539pJ0lsH7n/tF6H+K622BRQNHIKdnSFdmi/34L/Yid70uf
         LnG2ceNNsWfaD8xuGx6XoRkIPSSyMjv6QangvUhDnMmrLmuCIbrm+LcVdbxjTt9kyd
         r63G/Z7bPP+IXYm+VQSQPxlyfV2Ogk5QeB8c/AMi1OlG8cQLjfMznaNYLzSZQ1Up2C
         XNR8qub2N3CAQZJ5raTvYMVg9ETNav8ockMn0g1uYX2p3+kpS7oLVzYqPS8jeVRb1A
         3YMCxS+F25cAni1dLc70M81E0TuwmjjIkYnTU2yMjP38cmQg00cjMgIZ7I2XjXO/Op
         UA4LNLkUevwaQ==
Date:   Tue, 16 Mar 2021 01:11:34 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YE/ppohYu9AC68L+@kernel.org>
References: <e1ca4131bc9f98cf50a1200efcf46080d6512fe7.1615250634.git.kai.huang@intel.com>
 <20210311020142.125722-1-kai.huang@intel.com>
 <YEvbcrTZyiUAxZAu@google.com>
 <YEyX4V7BcS3MZNzp@kernel.org>
 <20210315201236.de3cd9389f853a418ec53e86@intel.com>
 <YE9elQfTZHo/9TJI@kernel.org>
 <YE9e5JAP3agUByXr@kernel.org>
 <20210316092934.d4dd7f2e65f507c3856341bc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316092934.d4dd7f2e65f507c3856341bc@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 09:29:34AM +1300, Kai Huang wrote:
> On Mon, 15 Mar 2021 15:19:32 +0200 Jarkko Sakkinen wrote:
> > On Mon, Mar 15, 2021 at 03:18:16PM +0200, Jarkko Sakkinen wrote:
> > > On Mon, Mar 15, 2021 at 08:12:36PM +1300, Kai Huang wrote:
> > > > On Sat, 13 Mar 2021 12:45:53 +0200 Jarkko Sakkinen wrote:
> > > > > On Fri, Mar 12, 2021 at 01:21:54PM -0800, Sean Christopherson wrote:
> > > > > > On Thu, Mar 11, 2021, Kai Huang wrote:
> > > > > > > From: Jarkko Sakkinen <jarkko@kernel.org>
> > > > > > > 
> > > > > > > EREMOVE takes a page and removes any association between that page and
> > > > > > > an enclave.  It must be run on a page before it can be added into
> > > > > > > another enclave.  Currently, EREMOVE is run as part of pages being freed
> > > > > > > into the SGX page allocator.  It is not expected to fail.
> > > > > > > 
> > > > > > > KVM does not track how guest pages are used, which means that SGX
> > > > > > > virtualization use of EREMOVE might fail.
> > > > > > > 
> > > > > > > Break out the EREMOVE call from the SGX page allocator.  This will allow
> > > > > > > the SGX virtualization code to use the allocator directly.  (SGX/KVM
> > > > > > > will also introduce a more permissive EREMOVE helper).
> > > > > > > 
> > > > > > > Implement original sgx_free_epc_page() as sgx_encl_free_epc_page() to be
> > > > > > > more specific that it is used to free EPC page assigned to one enclave.
> > > > > > > Print an error message when EREMOVE fails to explicitly call out EPC
> > > > > > > page is leaked, and requires machine reboot to get leaked pages back.
> > > > > > > 
> > > > > > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > > > > > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > > > > > > Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > > > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > > > > > ---
> > > > > > > v2->v3:
> > > > > > > 
> > > > > > >  - Fixed bug during copy/paste which results in SECS page and va pages are not
> > > > > > >    correctly freed in sgx_encl_release() (sorry for the mistake).
> > > > > > >  - Added Jarkko's Acked-by.
> > > > > > 
> > > > > > That Acked-by should either be dropped or moved above Co-developed-by to make
> > > > > > checkpatch happy.
> > > > > > 
> > > > > > Reviewed-by: Sean Christopherson <seanjc@google.com>
> > > > > 
> > > > > Oops, my bad. Yup, ack should be removed.
> > > > > 
> > > > > /Jarkko
> > > > 
> > > > Hi Jarkko,
> > > > 
> > > > Your reply of your concern of this patch to the cover-letter
> > > > 
> > > > https://lore.kernel.org/lkml/YEkJXu262YDa8ZaK@kernel.org/
> > > > 
> > > > reminds me to do more sanity check of whether removing EREMOVE in
> > > > sgx_free_epc_page() will impact other code path or not, and I think
> > > > sgx_encl_release() is not the only place should be changed:
> > > > 
> > > > - sgx_encl_shrink() needs to call sgx_encl_free_epc_page(), since when this is
> > > > called, the VA page can be already valid -- there are other failures can
> > > > trigger sgx_encl_shrink().
> > > 
> > > You right about this, good catch.
> > > 
> > > Shrink needs to always do EREMOVE as grow has done EPA, which changes
> > > EPC page state.
> > > 
> > > > - sgx_encl_add_page() should call sgx_encl_free_epc_page() in "err_out_free:"
> > > > label, since the EPC page can be already valid when error happened, i.e. when
> > > > EEXTEND fails.
> > > 
> > > Yes, correct, good work!
> > > 
> > > > Other places should be OK per my check, but I'd prefer to just replacing all
> > > > sgx_free_epc_page() call sites in driver with sgx_encl_free_epc_page(), with
> > > > one exception: sgx_alloc_va_page(), which calls sgx_free_epc_page() when EPA
> > > > fails, in which case EREMOVE is not required for sure.
> > > 
> > > I would not unless they require it.
> > > 
> > > > Your idea, please?
> > > > 
> > > > Btw, introducing a driver wrapper of sgx_free_epc_page() does make sense to me,
> > > > because virtualization has a counterpart in sgx/virt.c too.
> > > 
> > > It does make sense to use sgx_free_epc_page() everywhere where it's
> > > the right thing to call and here's why.
> > > 
> > > If there is some unrelated regression that causes EPC page not get
> > > uninitialized when it actually should, doing extra EREMOVE could mask
> > > those bugs. I.e. it can postpone a failure, which can make a bug harder
> > > to backtrace.
> > > 
> > 
> > I.e. even though it is true that for correctly working code extra EREMOVE
> > is nil functionality, it could change semantics for buggy code.
> 
> Thanks for feedback. Sorry I am not sure if I understand you. So if we don't
> want to bring functionality change, we need to replace sgx_free_epc_page() in
> all call sites with sgx_encl_free_epc_page(). To me for this patch only, it's
> better not to bring any functional change, so I intend to replace all (I now
> consider even leaving sgx_alloc_va_page() out is not good idea in *this*
> patch). 
> 
> Or do you just want to replace sgx_free_epc_page() with
> sgx_encl_free_epc_page() in sgx_encl_shrink() and sgx_encl_add_page(), as I
> pointed above? In this way there will be functional change in this patch, and
> we need to explicitly explain  why leaving others out is OK in commit message.
> 
> To me I prefer the former.

But yes, I'm cool with your preference and I do get your argument, I just
need to review it, and do not consider it as my patch :-)

/Jarkko
