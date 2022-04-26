Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABF3510CA8
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 01:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356102AbiDZXc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 19:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240844AbiDZXcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 19:32:55 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78893E5E7;
        Tue, 26 Apr 2022 16:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651015786; x=1682551786;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Jg6MtdXlvFgENt7ZsabQaNTY1fdrl0LJB7EK7BdY6Q8=;
  b=JuKbdpcTU+L/+my+COGNJbshMbGxVZrUhT1nxXXDodKa+lFpXjaJNS4i
   CFLGGoAsEZ3f3zIDgIyvN1jFZN/i8bTpauRoivKelhjRZWyzjtRzDpxCb
   lgm5nKY8g9/ToE5G50YMk6EFOSpqnpYEuZApSgAtS9xTpnRQP9k2ogFi3
   3MTFAZ8o9BzxWieLkbm5mdktL/ZdctisKv5WhPFjN11nd0yixJ8AL4UcB
   SyPR1aNWbifEPuLUsLi1p8btK8cpfmKDjh/Qf4Qg03aLKYdciVO7b3Sej
   fSrDbKwcgRiVxIXU156wKT4369X+luitMZGIlCxFcxTjyqX/1VK55rb/c
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="328695778"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="328695778"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 16:29:45 -0700
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="532913579"
Received: from ssaride-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.0.221])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 16:29:41 -0700
Message-ID: <de53b1ddea591e2a6fc8ac0510e3ab59f5f58512.camel@intel.com>
Subject: Re: [PATCH v3 03/21] x86/virt/tdx: Implement the SEAMCALL base
 function
From:   Kai Huang <kai.huang@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
Date:   Wed, 27 Apr 2022 11:29:39 +1200
In-Reply-To: <56f368c6-4a60-ea78-2cc7-cd2d57823e3a@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
         <1c3f555934c73301a9cbf10232500f3d15efe3cc.1649219184.git.kai.huang@intel.com>
         <56f368c6-4a60-ea78-2cc7-cd2d57823e3a@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-26 at 13:37 -0700, Dave Hansen wrote:
> On 4/5/22 21:49, Kai Huang wrote:
> > Secure Arbitration Mode (SEAM) is an extension of VMX architecture.  It
> > defines a new VMX root operation (SEAM VMX root) and a new VMX non-root
> > operation (SEAM VMX non-root) which are isolated from legacy VMX root
> > and VMX non-root mode.
> 
> I feel like this is too much detail for an opening paragraph.
> 
> > A CPU-attested software module (called the 'TDX module') runs in SEAM
> > VMX root to manage the crypto-protected VMs running in SEAM VMX non-root.
> > SEAM VMX root is also used to host another CPU-attested software module
> > (called the 'P-SEAMLDR') to load and update the TDX module.
> > > Host kernel transits to either the P-SEAMLDR or the TDX module via the
> > new SEAMCALL instruction.  SEAMCALL leaf functions are host-side
> > interface functions defined by the P-SEAMLDR and the TDX module around
> > the new SEAMCALL instruction.  They are similar to a hypercall, except
> > they are made by host kernel to the SEAM software.
> 
> I think you can get rid of about half of this changelog so farand make
> it more clear in the process with this:
> 
> 	TDX introduces a new CPU mode: Secure Arbitration Mode (SEAM).
> 	This mode runs only the TDX module itself or other code needed
> 	to load the TDX module.
> 
> 	The host kernel communicates with SEAM software via a new
> 	SEAMCALL instruction.  This is conceptually similar to
> 	a guest->host hypercall, except it is made from the host to SEAM
> 	software instead.

Thank you!

> 
> This is a technical document, but you're writing too technically for my
> taste and focusing on the low-level details rather than the high-level
> concepts.  What do I care that SEAM is two modes and what their names
> are at this juncture?  Are those details necesarry to get me to
> understand what a SEAMCALL is or what this patch implements?

Thanks for the point. I'll revisit this series based on this in next version.

> 
> > SEAMCALL leaf functions use an ABI different from the x86-64 system-v
> > ABI.  Instead, they share the same ABI with the TDCALL leaf functions.
> > %rax is used to carry both the SEAMCALL leaf function number (input) and
> > the completion status code (output).  Additional GPRs (%rcx, %rdx,
> > %r8->%r11) may be further used as both input and output operands in
> > individual leaf functions.
> > 
> > Implement a C function __seamcall()
> 
> Your "C function" looks a bit like assembly to me.

Will change to (I saw TDX guest patch used similar way):

	Add a generic interface to do SEAMCALL leaf functions, using the
	assembly macro used by __tdx_module_call().

> 
> > to do SEAMCALL leaf functions using
> > the assembly macro used by __tdx_module_call() (the implementation of
> > TDCALL leaf functions).  The only exception not covered here is TDENTER
> > leaf function which takes all GPRs and XMM0-XMM15 as both input and
> > output.  The caller of TDENTER should implement its own logic to call
> > TDENTER directly instead of using this function.
> 
> I have no idea why this paragraph is here or what it is trying to tell me.

Will get rid of the rest staff.

> 
> > SEAMCALL instruction is essentially a VMExit from VMX root to SEAM VMX
> > root, and it can fail with VMfailInvalid, for instance, when the SEAM
> > software module is not loaded.  The C function __seamcall() returns
> > TDX_SEAMCALL_VMFAILINVALID, which doesn't conflict with any actual error
> > code of SEAMCALLs, to uniquely represent this case.
> 
> Again, I'm lost.  Why is this detail here?  I don't even see
> TDX_SEAMCALL_VMFAILINVALID in the patch.

Will remove.

> 
> > diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
> > index 1bd688684716..fd577619620e 100644
> > --- a/arch/x86/virt/vmx/tdx/Makefile
> > +++ b/arch/x86/virt/vmx/tdx/Makefile
> > @@ -1,2 +1,2 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> > -obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx.o
> > +obj-$(CONFIG_INTEL_TDX_HOST)	+= tdx.o seamcall.o
> > diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
> > new file mode 100644
> > index 000000000000..327961b2dd5a
> > --- /dev/null
> > +++ b/arch/x86/virt/vmx/tdx/seamcall.S
> > @@ -0,0 +1,52 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#include <linux/linkage.h>
> > +#include <asm/frame.h>
> > +
> > +#include "tdxcall.S"
> > +
> > +/*
> > + * __seamcall()  - Host-side interface functions to SEAM software module
> > + *		   (the P-SEAMLDR or the TDX module)
> > + *
> > + * Transform function call register arguments into the SEAMCALL register
> > + * ABI.  Return TDX_SEAMCALL_VMFAILINVALID, or the completion status of
> > + * the SEAMCALL.  Additional output operands are saved in @out (if it is
> > + * provided by caller).
> 
> This needs to say:
> 
> 	Returns TDX_SEAMCALL_VMFAILINVALID if the SEAMCALL itself fails.

OK.


-- 
Thanks,
-Kai


