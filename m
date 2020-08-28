Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09551255A3C
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 14:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbgH1MdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 08:33:15 -0400
Received: from 8bytes.org ([81.169.241.247]:39864 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729298AbgH1MdI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 08:33:08 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 1F45E2E1; Fri, 28 Aug 2020 14:33:07 +0200 (CEST)
Date:   Fri, 28 Aug 2020 14:33:04 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 27/76] x86/sev-es: Add CPUID handling to #VC handler
Message-ID: <20200828123304.GD13881@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-28-joro@8bytes.org>
 <20200827224810.GA986963@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827224810.GA986963@rani.riverdale.lan>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 27, 2020 at 06:48:10PM -0400, Arvind Sankar wrote:
> On Mon, Aug 24, 2020 at 10:54:22AM +0200, Joerg Roedel wrote:
> > From: Tom Lendacky <thomas.lendacky@amd.com>
> > 
> > Handle #VC exceptions caused by CPUID instructions. These happen in
> > early boot code when the KASLR code checks for RDTSC.
> > 
> > Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> > [ jroedel@suse.de: Adapt to #VC handling framework ]
> > Co-developed-by: Joerg Roedel <jroedel@suse.de>
> > Signed-off-by: Joerg Roedel <jroedel@suse.de>
> > Link: https://lore.kernel.org/r/20200724160336.5435-27-joro@8bytes.org
> > ---
> > +
> > +static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
> > +				      struct es_em_ctxt *ctxt)
> > +{
> > +	struct pt_regs *regs = ctxt->regs;
> > +	u32 cr4 = native_read_cr4();
> > +	enum es_result ret;
> > +
> > +	ghcb_set_rax(ghcb, regs->ax);
> > +	ghcb_set_rcx(ghcb, regs->cx);
> > +
> > +	if (cr4 & X86_CR4_OSXSAVE)
> 
> Will this ever happen? trampoline_32bit_src will clear CR4 except for
> PAE and possibly LA57, no?

This same code is later re-used in the runtime handler and there the
check is needed :)

Regards,

	Joerg

