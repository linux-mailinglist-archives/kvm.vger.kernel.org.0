Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 391A31EE42F
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 14:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgFDMHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 08:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbgFDMHw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 08:07:52 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6806AC03E96D;
        Thu,  4 Jun 2020 05:07:52 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id F3ED126F; Thu,  4 Jun 2020 14:07:50 +0200 (CEST)
Date:   Thu, 4 Jun 2020 14:07:49 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
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
Subject: Re: [PATCH v3 42/75] x86/sev-es: Setup GHCB based boot #VC handler
Message-ID: <20200604120749.GC30945@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-43-joro@8bytes.org>
 <20200520192230.GK1457@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520192230.GK1457@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 20, 2020 at 09:22:30PM +0200, Borislav Petkov wrote:
> On Tue, Apr 28, 2020 at 05:16:52PM +0200, Joerg Roedel wrote:
> > diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
> > index b2cbcd40b52e..e1ed963a57ec 100644
> > --- a/arch/x86/include/asm/sev-es.h
> > +++ b/arch/x86/include/asm/sev-es.h
> > @@ -74,5 +74,6 @@ static inline u64 lower_bits(u64 val, unsigned int bits)
> >  }
> >  
> >  extern void vc_no_ghcb(void);
> > +extern bool vc_boot_ghcb(struct pt_regs *regs);
> 
> Those function names need verbs:
> 
> 	handle_vc_no_ghcb
> 	handle_vc_boot_ghcb

This are IDT entry points and the names above follow the convention for
them, like e.g. 'page_fault', 'nmi' or 'general_protection'. Should I
still add the verbs or just add a comment explaining what those symbols
are?

> There's already another sev_es_setup_ghcb() in compressed/. All those
> functions with the same name are just confusion waiting to happen. Let's
> prepend the ones in compressed/ with "early_" or so, so that their names
> are at least different even if they're in two different files with the
> same name.
> 
> This way you know at least which function is used in which boot stages.

Okay, will see what can be changed. Some functions are part of the
interface for sev-es-shared.c and need to have the same names, but
sev_es_setup_ghcb() can be named differently.

> > +static void __init vc_early_vc_forward_exception(struct es_em_ctxt *ctxt)
> 
> That second "vc" looks redundant.

Heh, search and replace artifact :) Fixed now.


	Joerg
