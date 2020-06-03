Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438C21ED202
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 16:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgFCOXa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 10:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgFCOX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 10:23:29 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1A3C08C5C0;
        Wed,  3 Jun 2020 07:23:29 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id B4EF728B; Wed,  3 Jun 2020 16:23:26 +0200 (CEST)
Date:   Wed, 3 Jun 2020 16:23:25 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 25/75] x86/sev-es: Add support for handling IOIO
 exceptions
Message-ID: <20200603142325.GB23071@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-26-joro@8bytes.org>
 <20200520062055.GA17090@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520062055.GA17090@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean,

On Tue, May 19, 2020 at 11:20:55PM -0700, Sean Christopherson wrote:
> On Tue, Apr 28, 2020 at 05:16:35PM +0200, Joerg Roedel wrote:
> > +		/*
> > +		 * For the string variants with rep prefix the amount of in/out
> > +		 * operations per #VC exception is limited so that the kernel
> > +		 * has a chance to take interrupts an re-schedule while the
> > +		 * instruction is emulated.
> 
> Doesn't this also suppress single-step #DBs?

Yes it does.

> 
> > +		 */
> > +		io_bytes   = (exit_info_1 >> 4) & 0x7;
> > +		ghcb_count = sizeof(ghcb->shared_buffer) / io_bytes;
> > +
> > +		op_count    = (exit_info_1 & IOIO_REP) ? regs->cx : 1;
> > +		exit_info_2 = min(op_count, ghcb_count);
> > +		exit_bytes  = exit_info_2 * io_bytes;
> > +
> > +		es_base = insn_get_seg_base(ctxt->regs, INAT_SEG_REG_ES);
> > +
> > +		if (!(exit_info_1 & IOIO_TYPE_IN)) {
> > +			ret = vc_insn_string_read(ctxt,
> > +					       (void *)(es_base + regs->si),
> 
> SEV(-ES) is 64-bit only, why bother with the es_base charade?

User-space can also cause IOIO #VC exceptions, and user-space can be
32-bit legacy code with segments, so es_base has to be taken into
account.


> 
> > +					       ghcb->shared_buffer, io_bytes,
> > +					       exit_info_2, df);
> 
> df handling is busted, it's aways non-zero.  Same goes for the SI/DI
> adjustments below.

Right, this is fixed now.

> Batching the memory accesses and I/O accesses separately is technically
> wrong, e.g. a #DB on a memory access will result in bogus data being shown
> in the debugger.  In practice it seems unlikely to matter, but I'm curious
> as to why string I/O is supported in the first place.  I didn't think there
> was that much string I/O in the kernel?

True, #DBs won't be correct anymore. Currently debugging is not
supported in SEV-ES guests anyway, but if it is supported the #DB
exception would happen in the #VC handler and not on the original
instruction.


Regards,

	Joerg
