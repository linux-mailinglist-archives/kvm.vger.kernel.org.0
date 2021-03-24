Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A789034767F
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 11:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbhCXKtO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 06:49:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:33877 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232638AbhCXKs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 06:48:58 -0400
IronPort-SDR: YDqo2DvHRmT2vgGTE038U8L5cfP/FRe0xtusWLusvXbKFrcGmTBFVce1fC8DZc4CutoKDGKqTC
 v5NQygHra1Gg==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="190706457"
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="190706457"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 03:48:45 -0700
IronPort-SDR: HV51CtFG+0F/5pSRqtRZykAoU6tnLkRyJxTZQZho5OfX675XvLaIgDEYbg6O3lkAfLvqKH4f9S
 mPvRNV/i5Uiw==
X-IronPort-AV: E=Sophos;i="5.81,274,1610438400"; 
   d="scan'208";a="391256415"
Received: from akhajan-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.245])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 03:48:41 -0700
Date:   Wed, 24 Mar 2021 23:48:39 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-Id: <20210324234839.bf5bef54fd7a84030cf1bcf8@intel.com>
In-Reply-To: <236c0aa9-92f2-97c8-ab11-d55b9a98c931@redhat.com>
References: <YFjoZQwB7e3oQW8l@google.com>
        <20210322191540.GH6481@zn.tnic>
        <YFjx3vixDURClgcb@google.com>
        <20210322210645.GI6481@zn.tnic>
        <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
        <20210322223726.GJ6481@zn.tnic>
        <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
        <YFoNCvBYS2lIYjjc@google.com>
        <20210323160604.GB4729@zn.tnic>
        <YFoVmxIFjGpqM6Bk@google.com>
        <20210323163258.GC4729@zn.tnic>
        <b35f66a10ecc07a1eecb829912d5664886ca169b.camel@intel.com>
        <236c0aa9-92f2-97c8-ab11-d55b9a98c931@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 Mar 2021 11:09:20 +0100 Paolo Bonzini wrote:
> On 24/03/21 10:38, Kai Huang wrote:
> > Hi Sean, Boris, Paolo,
> > 
> > Thanks for the discussion. I tried to digest all your conversations and
> > hopefully I have understood you correctly. I pasted the new patch here
> > (not full patch, but relevant part only). I modified the error msg, added
> > some writeup to Documentation/x86/sgx.rst, and put Sean's explanation of this
> > bug to the commit msg (per Paolo). I am terrible Documentation writer, so
> > please help to check and give comments. Thanks!
> 
> I have some phrasing suggestions below but that was actually pretty good.
> 
> > ---
> > commit 1e297a535bcb4f51a08343c40207520017d85efe (HEAD)
> > Author: Kai Huang <kai.huang@intel.com>
> > Date:   Wed Jan 20 03:40:53 2021 +0200
> > 
> >      x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
> >      
> >      EREMOVE takes a page and removes any association between that page and
> >      an enclave.  It must be run on a page before it can be added into
> >      another enclave.  Currently, EREMOVE is run as part of pages being freed
> >      into the SGX page allocator.  It is not expected to fail.
> >      
> >      KVM does not track how guest pages are used, which means that SGX
> >      virtualization use of EREMOVE might fail.  Specifically, it is
> >      legitimate that EREMOVE returns SGX_CHILD_PRESENT for EPC assigned to
> >      KVM guest, because KVM/kernel doesn't track SECS pages.
> >
> >      Break out the EREMOVE call from the SGX page allocator.  This will allow
> >      the SGX virtualization code to use the allocator directly.  (SGX/KVM
> >      will also introduce a more permissive EREMOVE helper).
> 
> Ok, I think I got the source of my confusion.  The part in parentheses
> is the key.  It was not clear that KVM can deal with EREMOVE failures
> *without printing the error*.  Good!

Yes the "will also introduce a more premissive EREMOVE helper" is done in patch
5 (x86/sgx: Introduce virtual EPC for use by KVM guests).

> 
> >      Implement original sgx_free_epc_page() as sgx_encl_free_epc_page() to be
> >      more specific that it is used to free EPC page assigned host enclave.
> >      Replace sgx_free_epc_page() with sgx_encl_free_epc_page() in all call
> >      sites so there's no functional change.
> >      
> >      Improve error message when EREMOVE fails, and kernel is about to leak
> >      EPC page, which is likely a kernel bug.  This is effectively a kernel
> >      use-after-free of EPC, and due to the way SGX works, the bug is detected
> >      at freeing.  Rather than add the page back to the pool of available EPC,
> >      the kernel intentionally leaks the page to avoid additional errors in
> >      the future.
> >      
> >      Also add documentation to explain to user what is the bug and suggest
> >      user what to do when this bug happens, although extremely unlikely.
> 
> Rewritten:
> 
> EREMOVE takes a page and removes any association between that page and
> an enclave.  It must be run on a page before it can be added into
> another enclave.  Currently, EREMOVE is run as part of pages being freed
> into the SGX page allocator.  It is not expected to fail, as it would
> indicate a use-after-free of EPC.  Rather than add the page back to the
> pool of available EPC, the kernel intentionally leaks the page to avoid
> additional errors in the future.
> 
> However, KVM does not track how guest pages are used, which means that SGX
> virtualization use of EREMOVE might fail.  Specifically, it is
> legitimate that EREMOVE returns SGX_CHILD_PRESENT for EPC assigned to
> KVM guest, because KVM/kernel doesn't track SECS pages.
> 
> To allow SGX/KVM to introduce a more permissive EREMOVE helper and to
> let the SGX virtualization code use the allocator directly,
> break out the EREMOVE call from the SGX page allocator.  Rename the
> original sgx_free_epc_page() to sgx_encl_free_epc_page(),
> indicating that it is used to free EPC page assigned host enclave.
> Replace sgx_free_epc_page() with sgx_encl_free_epc_page() in all call
> sites so there's no functional change.
> 
> At the same time improve error message when EREMOVE fails, and add
> documentation to explain to user what is the bug and suggest user what
> to do when this bug happens, although extremely unlikely.

Thanks :)

> 
> > +Although extremely unlikely, EPC leaks can happen if kernel SGX bug happens,
> > +when a WARNING with below message is shown in dmesg:
> 
> Remove "Although extremely unlikely".

Will do.

> 
> > +"...EREMOVE returned ..., kernel bug likely.  EPC page leaked, SGX may become
> > +unusuable.  Please refer to Documentation/x86/sgx.rst for more information."
> > +
> > +This is effectively a kernel use-after-free of EPC, and due to the way SGX
> > +works, the bug is detected at freeing. Rather than add the page back to the pool
> > +of available EPC, the kernel intentionally leaks the page to avoid additional
> > +errors in the future.
> > +
> > +When this happens, kernel will likely soon leak majority of EPC pages, and SGX
> > +will likely become unusable. However while this may be fatal to SGX, other
> > +kernel functionalities are unlikely to be impacted, and should continue to work.
> > +
> > +As a result, when this happpens, user should stop running any new SGX workloads,
> > +(or just any new workloads), and migrate all valuable workloads, for instance,
> > +virtual machines, to other places.
> 
> Remove everything starting with "for instance".

Will do.

> 
>   Although a machine reboot can recover all
> > +EPC, debugging and fixing this bug is appreciated.
> 
> Replace the second part with "the bug should be reported to the Linux developers".
> The poor user is not expected to debug SGX. ;)

Hmm.. Makes sense :)

> 
> > +/* Error message for EREMOVE failure, when kernel is about to leak EPC page */
> > +#define EREMOVE_ERROR_MESSAGE \
> > +       "EREMOVE returned %d (0x%x), kernel bug likely.  EPC page leaked, SGX may become
> > unusuable.  Please refer to Documentation/x86/sgx.rst for more information."
> 
> Rewritten:
> 
> EREMOVE returned %d and an EPC page was leaked; SGX may become unusable.
> This is a kernel bug, refer to Documentation/x86/sgx.rst for more information.

Fine to me, although this would have %d (0x%x) -> %d change in the code.

> 
> Also please split it across multiple lines.
> 
> Paolo
> 
