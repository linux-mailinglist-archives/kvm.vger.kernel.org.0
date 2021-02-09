Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DE13158EB
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 22:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbhBIVqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 16:46:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:23382 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233361AbhBIVF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 16:05:58 -0500
IronPort-SDR: xeb8DKJH97gOMbP02x3EdWVi6HwSe7xglVS0TLEUxhm5JEoxQwlhyjdq2QK/A9citk/2CMy7oE
 hHH+rO6DH5pQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9890"; a="182103815"
X-IronPort-AV: E=Sophos;i="5.81,166,1610438400"; 
   d="scan'208";a="182103815"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 13:03:08 -0800
IronPort-SDR: CbQpsbuKsiguYldWjtRlI4ODucsEKPSH22XX5c8TCF7nABjZSvURmOTrPoqdxnU7hyDPtF3qZE
 5MGTHGLeDqMw==
X-IronPort-AV: E=Sophos;i="5.81,166,1610438400"; 
   d="scan'208";a="396391669"
Received: from aellsw1-mobl.amr.corp.intel.com ([10.251.22.237])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 13:03:05 -0800
Message-ID: <ddc22787d6d4abf51c47b28ec6fe6df85d0fea3e.camel@intel.com>
Subject: Re: [RFC PATCH v4 04/26] x86/sgx: Add SGX_CHILD_PRESENT hardware
 error code
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        jarkko@kernel.org, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Date:   Wed, 10 Feb 2021 10:03:02 +1300
In-Reply-To: <YCLBQYq2HaA7MFKH@google.com>
References: <cover.1612777752.git.kai.huang@intel.com>
         <3c1edb38e95843eb9bf3fcbbec6cf9bdd9b3e7b1.1612777752.git.kai.huang@intel.com>
         <b9e8a9a0-6a53-6523-4ea8-347c67e7ba86@intel.com>
         <YCK81Zcz++PfGPnw@google.com>
         <af80db88-9097-0947-e05d-9508daee18df@intel.com>
         <YCLBQYq2HaA7MFKH@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-02-09 at 17:07 +0000, Sean Christopherson wrote:
> On Tue, Feb 09, 2021, Dave Hansen wrote:
> > On 2/9/21 8:48 AM, Sean Christopherson wrote:
> > > On Tue, Feb 09, 2021, Dave Hansen wrote:
> > > > On 2/8/21 2:54 AM, Kai Huang wrote:
> > > > ...
> > > > > Add SGX_CHILD_PRESENT for use by SGX virtualization to assert EREMOVE
> > > > > failures are expected, but only due to SGX_CHILD_PRESENT.
> > > > This paragraph broke my brain when I read it.  How about:
> > > > 
> > > > 	Add a definition of SGX_CHILD_PRESENT.  It will be used
> > > > 	exclusively by the SGX virtualization driver to suppress EREMOVE
> > > > 	warnings.
> > > Maybe worth clarifying that the driver isn't suppressing warnings willy-nilly?
> > > And the error code isn't about suppressing warnings, it's about identifying the
> > > expected EREMOVE failure scenario.  The patch that creates the separate helper
> > > for doing EREMOVE without the WARN is what provides the suppression mechanism.
> > > 
> > > Something like this?
> > > 
> > >   Add a definition of SGX_CHILD_PRESENT.  It will be used exclusively by
> > >   the SGX virtualization driver to handle recoverable EREMOVE errors when
> > >   saniziting EPC pages after they are reclaimed from a guest.
> > 
> > Looks great to me.  One nit: to a me, "reclaim" is different than
> > "free".  Reclaim is a specific operation where a page is taken from one
> > user and reclaimed for other use.  "Free" is the more general case
> > (which includes reclaim) when a physical page is no longer being used
> > (because the user is done *or* had the page reclaimed) and may be either
> > used by someone else or put in a free pool.
> > 
> > I *think* this is actually a "free" operation, rather than a "reclaim".
> >  IIRC, this code gets used at munmap().
> 
> It does.  I used reclaim because userspace, which does the freeing from this
> code's perspective, never touches the EPC pages.  The SGX_CHILD_PRESENT case is
> handling the scenario where userspace has for all intents and purposed reclaimed
> the EPC from a guest.  If the guest cleanly tears down its enclaves, EREMOVE
> will not fail.
> 
> "free" is probably better though, the above is far from obvious and still not
> guaranteed to be a true reclaim scenario.  If using "freed", drop the "from a
> guest" part.

Thanks for feedback. I'll use below:

  Add a definition of SGX_CHILD_PRESENT.  It will be used exclusively by
  the SGX virtualization driver to handle recoverable EREMOVE errors when
  saniziting EPC pages after they are freed.

