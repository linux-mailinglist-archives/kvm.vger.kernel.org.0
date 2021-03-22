Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40853452E7
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 00:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhCVXRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 19:17:11 -0400
Received: from mga06.intel.com ([134.134.136.31]:20855 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhCVXQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 19:16:50 -0400
IronPort-SDR: fWTRcO6Qf6hdgFX6REFdnHRICh7UmZu9omvZaXbMWJn64CXkq7F4Rg8m586phPVc/oy7L+AY8X
 nv34lL+YbArQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="251719787"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="251719787"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 16:16:49 -0700
IronPort-SDR: I7UDdE7X3uLUmkkEj1gju/L3cDboU6/HlBwuNylH8RJ/obg75rLKDw0Xtx9j00017GNiqw95EK
 y29bMBN91acw==
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="513480903"
Received: from rmarinax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.143.198])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 16:16:45 -0700
Date:   Tue, 23 Mar 2021 12:16:43 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-Id: <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
In-Reply-To: <20210322223726.GJ6481@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
        <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
        <20210322181646.GG6481@zn.tnic>
        <YFjoZQwB7e3oQW8l@google.com>
        <20210322191540.GH6481@zn.tnic>
        <YFjx3vixDURClgcb@google.com>
        <20210322210645.GI6481@zn.tnic>
        <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
        <20210322223726.GJ6481@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Mar 2021 23:37:26 +0100 Borislav Petkov wrote:
> On Tue, Mar 23, 2021 at 11:06:43AM +1300, Kai Huang wrote:
> > This path is called by host SGX driver only, so yes this leaking is done by
> > host enclaves only.
> 
> Yes, so I was told.
> 
> > This patch is purpose is to break EREMOVE out of sgx_free_epc_page() so virtual
> > EPC code can use sgx_free_epc_page(), and handle EREMOVE logic differently.
> > This patch doesn't have intention to bring functional change.  I changed the
> > error msg because Dave said it worth to give a message saying EPC page is
> > leaked, and I thought this minor change won't break anything.
> 
> I read that already - you don't have to repeat it.
> 
> > btw, currently virtual EPC code (patch 5) handles in similar way: There's one
> > EREMOVE error is expected and virtual EPC code can handle, but for other
> > errors, it means kernel bug, and virtual EPC code gives a WARN(), and that EPC
> > page is leaked too:
> > 
> > +		WARN_ONCE(ret != SGX_CHILD_PRESENT,
> > +			  "EREMOVE (EPC page 0x%lx): unexpected error: %d\n",
> > +			  sgx_get_epc_phys_addr(epc_page), ret);
> > +		return ret;
> > 
> > So to me they are just WARN() to catch kernel bug.
> 
> You don't care about users, do you? Because when that error happens,
> they won't come crying to you to fix it.
> 
> Lemme save you some trouble: we don't take half-baked code into the
> kernel until stuff has been discussed and analyzed properly. So instead
> of trying to downplay this, try answering my questions.
> 
> Here's another one: when does EREMOVE fail?
> 
> /me goes and looks it up
> 
> "The instruction fails if the operand is not properly aligned or does
> not refer to an EPC page or the page is in use by another thread, or
> other threads are running in the enclave to which the page belongs. In
> addition the instruction fails if the operand refers to an SECS with
> associations."
> 
> And I guess those conditions will become more in the future.
> 
> Now, let's play. I'm the cloud admin and you're cloud OS customer
> support. I say:
> 
> "I got this scary error message while running enclaves on my server
> 
> "EREMOVE returned ... .  EPC page leaked.  Reboot required to retrieve leaked pages."
> 
> but I cannot reboot that machine because there are guests running on it
> and I'm getting paid for those guests and I might get sued if I do?"
> 
> Your turn, go wild.

I suppose admin can migrate those VMs, and then engineers can analyse the root
cause of such failure, and then fix it.
