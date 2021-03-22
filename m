Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEC63450E8
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 21:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhCVUhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 16:37:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:5907 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230377AbhCVUgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 16:36:41 -0400
IronPort-SDR: ibNIwSsbspFH1iPvKTuwUNJUBBMaMqaLTWwavn+eE9zEtVNiJN0R49zRRQCKoo7s/Dj+vWcm3b
 hvSEHB2Sxwxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190439014"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="190439014"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:36:40 -0700
IronPort-SDR: rOZpcDKI3oiul92YMn2nxHGRPWc3XlT69MWQXpG9uWhL9reehm4G4gLDKYRIIazjspqRAjvJIr
 Be+VwuP271Vw==
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="442262636"
Received: from zssigmon-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.92.253])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:36:36 -0700
Date:   Tue, 23 Mar 2021 09:36:33 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-Id: <20210323093633.d496ba502cc68aa496636fd5@intel.com>
In-Reply-To: <YFjx3vixDURClgcb@google.com>
References: <cover.1616136307.git.kai.huang@intel.com>
        <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
        <20210322181646.GG6481@zn.tnic>
        <YFjoZQwB7e3oQW8l@google.com>
        <20210322191540.GH6481@zn.tnic>
        <YFjx3vixDURClgcb@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Mar 2021 12:37:02 -0700 Sean Christopherson wrote:
> On Mon, Mar 22, 2021, Borislav Petkov wrote:
> > On Mon, Mar 22, 2021 at 11:56:37AM -0700, Sean Christopherson wrote:
> > > Not necessarily.  This can only trigger in the host, and thus require a host
> > > reboot, if the host is also running enclaves.  If the CSP is not running
> > > enclaves, or is running its enclaves in a separate VM, then this path cannot be
> > > reached.
> > 
> > That's what I meant. Rebooting guests is a lot easier, ofc.
> > 
> > Or are you saying, this can trigger *only* when they're running enclaves
> > on the *host* too?
> 
> Yes.  Note, it's still true if you strike out the "too", KVM support is completely
> orthogonal to this code.  The purpose of this patch is to separate out the EREMOVE
> path used for host enclaves (/dev/sgx_enclave), because EPC virtualization for
> KVM will have non-buggy scenarios where EREMOVE can fail.  But the virt EPC code
> is designed to handle that gracefully.
> 
> > > EREMOVE can only fail if there's a kernel or hardware bug (or a VMM bug if
> > > running as a guest). 
> > 
> > We get those on a daily basis.
> > 
> > > IME, nearly every kernel/KVM bug that I introduced that led to EREMOVE
> > > failure was also quite fatal to SGX, i.e. this is just the canary in
> > > the coal mine.
> > >
> > > It's certainly possible to add more sophisticated error handling, e.g. through
> > > the pages onto a list and periodically try to recover them.  But, since the vast
> > > majority of bugs that cause EREMOVE failure are fatal to SGX, implementing
> > > sophisticated handling is quite low on the list of priorities.
> > > 
> > > Dave wanted the "page leaked" error message so that it's abundantly clear that
> > > the kernel is leaking pages on EREMOVE failure and that the WARN isn't "benign".
> > 
> > So this sounds to me like this should BUG too eventually.
> > 
> > Or is this one of those "this should never happen" things so no one
> > should worry?
> 
> Hmm.  I don't think it warrants BUG.  At worst, leaking EPC pages is fatal only
> to SGX.  If the underlying bug caused other fallout, e.g. didn't release a lock,
> then obviously that could be fatal to the kernel.  But I don't think there's
> ever a case where SGX being unusuable would prevent the kernel from functioning.
>  
> > Whatever it is, if an admin sees this message in dmesg and doesn't get a
> > lengthy explanation what she/he is supposed to do, I don't think she/he
> > will be as relaxed.
> > 
> > Hell, people open bugs for correctable ECCs and are asking whether they
> > need to replace their hardware.
> 
> LOL.
> 
> > So let's play this out: put yourself in an admin's shoes and tell me how
> > should an admin react when she/he sees that?
> > 
> > Should the kernel probably also say: "Don't worry, you have enough
> > memory and what's a 4K, who cares? You'll reboot eventually."
>  
> > Or should the kernel say "You need to reboot ASAP."
> > 
> > And so on...
> > 
> > So what is the scenario here and what kind of reaction is that message
> > supposed to cause, recovery action, blabla, the whole spiel?
> 
> Probably something in between.  Odds are good SGX will eventually become
> unusuable, e.g. either kernel SGX support is completely hosted, or it will soon
> leak the majority of EPC pages.  Something like this?
> 
>   "EREMOVE returned %d (0x%x), kernel bug likely.  EPC page leaked, SGX may become unusuable.  Reboot recommended to continue using SGX."

Or perhaps just stick to old behavior in original sgx_free_epc_page()?

	ret = __eremove(sgx_get_epc_virt_addr(page));
	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
		return;

This code path is only used by host SGX driver, but not KVM. And this patch's
*main* intention is to break EREMOVE out of sgx_free_epc_page() so virtual EPC
code can use sgx_free_epc_page(). 

Improving the error msg can be a separate discussion and separate patch which
can be done in the future, and this has nothing to do with SGX virtualization
support.
