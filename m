Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963B7345235
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 23:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhCVWHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 18:07:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:21632 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhCVWHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 18:07:05 -0400
IronPort-SDR: MBa/fnwj/R9Ro+XwxvmWIvqiuB4M4qAJ8QSpyjRumJerEr4N1ajjaIP0X6sTabGhyCPwmOtWR5
 4MDn/MKURz7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="177486874"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="177486874"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 15:06:49 -0700
IronPort-SDR: 0O387K07SglJTJUfWuh95FqGmi6hWmNU1qbcY2U7eSKyppciXJOo7n35QBIkOj83PZU3nvKGSB
 KdhlYBybaH5A==
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="414672964"
Received: from rmarinax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.143.198])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 15:06:45 -0700
Date:   Tue, 23 Mar 2021 11:06:43 +1300
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
Message-Id: <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
In-Reply-To: <20210322210645.GI6481@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
        <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
        <20210322181646.GG6481@zn.tnic>
        <YFjoZQwB7e3oQW8l@google.com>
        <20210322191540.GH6481@zn.tnic>
        <YFjx3vixDURClgcb@google.com>
        <20210322210645.GI6481@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Mar 2021 22:06:45 +0100 Borislav Petkov wrote:
> On Mon, Mar 22, 2021 at 12:37:02PM -0700, Sean Christopherson wrote:
> > Yes.  Note, it's still true if you strike out the "too", KVM support is completely
> > orthogonal to this code.  The purpose of this patch is to separate out the EREMOVE
> > path used for host enclaves (/dev/sgx_enclave), because EPC virtualization for
> > KVM will have non-buggy scenarios where EREMOVE can fail.  But the virt EPC code
> > is designed to handle that gracefully.
> 
> "gracefully" as it won't leak EPC pages which would require a host reboot? That
> leaking is done by host enclaves only?

This path is called by host SGX driver only, so yes this leaking is done by
host enclaves only.

This patch is purpose is to break EREMOVE out of sgx_free_epc_page() so virtual
EPC code can use sgx_free_epc_page(), and handle EREMOVE logic differently.
This patch doesn't have intention to bring functional change.  I changed the
error msg because Dave said it worth to give a message saying EPC page is
leaked, and I thought this minor change won't break anything.

Perpahps we can avoid changing error message but stick to existing SGX driver
behavior? 

> 
> > Hmm.  I don't think it warrants BUG.  At worst, leaking EPC pages is fatal only
> > to SGX.
> 
> Fatal how? If it keeps leaking, at some point it won't have any pages
> for EPC pages anymore?
> 
> Btw, I probably have seen this and forgotten again so pls remind me,
> is the amount of pages available for SGX use static and limited by,
> I believe BIOS, or can a leakage in EPC pages cause system memory
> shortage?
> 
> > If the underlying bug caused other fallout, e.g. didn't release a
> > lock, then obviously that could be fatal to the kernel. But I don't
> > think there's ever a case where SGX being unusuable would prevent the
> > kernel from functioning.
> 
> This kinda replies my question above but still...
> 
> > Probably something in between.  Odds are good SGX will eventually become
> > unusuable, e.g. either kernel SGX support is completely hosted, or it will soon
> > leak the majority of EPC pages.  Something like this?
> > 
> >   "EREMOVE returned %d (0x%x), kernel bug likely.  EPC page leaked, SGX may become unusuable.  Reboot recommended to continue using SGX."
> 
> So all this handwaving I'm doing is to provoke a proper response from
> you guys as to how a EPC page leaking is supposed to be handled by the
> users of the technology:
> 
> 1. Issue a warning message and forget about it, eventual reboot

This is the existing SGX driver behavior IMHO. It just gives a WARN() saying
EREMOVE failed with the error code printed.  The EPC page is leaked w/o any
message to user.  I can live with it, and it is existing code anyway.

btw, currently virtual EPC code (patch 5) handles in similar way: There's one
EREMOVE error is expected and virtual EPC code can handle, but for other
errors, it means kernel bug, and virtual EPC code gives a WARN(), and that EPC
page is leaked too:

+		WARN_ONCE(ret != SGX_CHILD_PRESENT,
+			  "EREMOVE (EPC page 0x%lx): unexpected error: %d\n",
+			  sgx_get_epc_phys_addr(epc_page), ret);
+		return ret;

So to me they are just WARN() to catch kernel bug.

> 
> 2. Really scary message to make users reboot sooner
> 
> 3. Detect when host enclaves are run while guest enclaves are running
> and issue a warning then.

This code path has nothing to do with guest enclaves.

> 
> 4. Fall on knees and pray to not get sued by customers because their
> enclaves are not working anymore.
> 
> ....
> 
> Btw, 4. needs to be considered properly so that people can cover asses.

If we are talking about CSPs being unable to provide correct services to
customers due to kernel bug, I think this is a bigger question but not
just related to SGX,  since other kernel bug can also cause similar problem, for
instance, VM or SGX process itself being killed.

> 
> Oh and whatever we end up deciding, we should document that in
> Documentation/... somewhere and point users to it in that warning
> message where a longer treatise is explaining the whole deal properly.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
