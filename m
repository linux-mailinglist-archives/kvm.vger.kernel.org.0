Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432971D1155
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 13:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbgEMLaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 07:30:16 -0400
Received: from 8bytes.org ([81.169.241.247]:42394 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgEMLaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 07:30:16 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 38D9522E; Wed, 13 May 2020 13:30:13 +0200 (CEST)
Date:   Wed, 13 May 2020 13:30:11 +0200
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
Subject: Re: [PATCH v3 24/75] x86/boot/compressed/64: Unmap GHCB page before
 booting the kernel
Message-ID: <20200513113011.GG18353@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-25-joro@8bytes.org>
 <20200513111340.GD4025@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513111340.GD4025@zn.tnic>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 13, 2020 at 01:13:40PM +0200, Borislav Petkov wrote:
> On Tue, Apr 28, 2020 at 05:16:34PM +0200, Joerg Roedel wrote:
> > @@ -302,9 +313,13 @@ void do_boot_page_fault(struct pt_regs *regs, unsigned long error_code)
> >  	 *	- User faults
> >  	 *	- Reserved bits set
> >  	 */
> > -	if (error_code & (X86_PF_PROT | X86_PF_USER | X86_PF_RSVD)) {
> > +	if (ghcb_fault ||
> > +	    error_code & (X86_PF_PROT | X86_PF_USER | X86_PF_RSVD)) {
> >  		/* Print some information for debugging */
> > -		error_putstr("Unexpected page-fault:");
> > +		if (ghcb_fault)
> > +			error_putstr("Page-fault on GHCB page:");
> > +		else
> > +			error_putstr("Unexpected page-fault:");
> 
> You could carve out the info dumping into a separate function to
> unclutter this if-statement (diff ontop):

Yeah, I had this this way in v2, but changed it upon you request[1] :)


	Joerg

[1] https://lore.kernel.org/lkml/20200402114941.GA9352@zn.tnic/
	
