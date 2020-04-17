Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171081ADD98
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 14:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbgDQMuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 08:50:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727877AbgDQMuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 08:50:07 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E52042083E;
        Fri, 17 Apr 2020 12:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587127806;
        bh=1Kssa3G/QCo5jRCKyBkgrgk7TiSh1kwDD4fBjcBMC70=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2SHu1HjYaq+TUUvOFDh4rRrPGE6erjABlIPm/oYjVffmYc3Po6EJLX6WpPqoJLKFB
         x8U/cj4n5jria1Y1NHVeXCy8i714yrYSGRhb/Pctx6gILbNZMLN0L6RoLRqN3y4kR3
         cY2VKGNJFQZzlfQ6mXT+bDZNQlh5C3ufeAzFZ6ZM=
Date:   Fri, 17 Apr 2020 21:50:00 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Borislav Petkov <bp@alien8.de>, Joerg Roedel <jroedel@suse.de>,
        x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 05/70] x86/insn: Make inat-tables.c suitable for
 pre-decompression code
Message-Id: <20200417215000.47141001f80005f41153d22e@kernel.org>
In-Reply-To: <20200416152406.GB4290@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
        <20200319091407.1481-6-joro@8bytes.org>
        <20200325153945.GD27261@zn.tnic>
        <20200327120232.c8e455ca100dc0d96e4ddc43@kernel.org>
        <20200416152406.GB4290@8bytes.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Apr 2020 17:24:06 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> Hi Masami,
> 
> On Fri, Mar 27, 2020 at 12:02:32PM +0900, Masami Hiramatsu wrote:
> > On Wed, 25 Mar 2020 16:39:45 +0100
> > Borislav Petkov <bp@alien8.de> wrote:
> > 
> > > + Masami.
> > > 
> > > On Thu, Mar 19, 2020 at 10:13:02AM +0100, Joerg Roedel wrote:
> > > > From: Joerg Roedel <jroedel@suse.de>
> > > > 
> > > > The inat-tables.c file has some arrays in it that contain pointers to
> > > > other arrays. These pointers need to be relocated when the kernel
> > > > image is moved to a different location.
> > > > 
> > > > The pre-decompression boot-code has no support for applying ELF
> > > > relocations, so initialize these arrays at runtime in the
> > > > pre-decompression code to make sure all pointers are correctly
> > > > initialized.
> > 
> > I need to check the whole series, but as far as I can understand from
> > this patch, this seems not allowing to store the address value in
> > static pointers. It may break more things, for example _kprobe_blacklist
> > records the NOKPROBE_SYMBOL() symbol addresses at the build time.
> 
> The runtime-initialization function is only used in the
> pre-decompression boot code (arch/x86/boot/compressed/) which is not
> part of the running kernel image. At that stage of booting there is no
> support for kprobe or tracing or any other neat features that might
> break things here.

Ah, I got it. So you intended to port the instruction decoder to
pre-decompression boot code, correct?

> > > > +	print "#ifndef __BOOT_COMPRESSED\n"
> > > > +
> > > >  	# print escape opcode map's array
> > > >  	print "/* Escape opcode map array */"
> > > >  	print "const insn_attr_t * const inat_escape_tables[INAT_ESC_MAX + 1]" \
> > > > @@ -388,6 +391,51 @@ END {
> > > >  		for (j = 0; j < max_lprefix; j++)
> > > >  			if (atable[i,j])
> > > >  				print "	["i"]["j"] = "atable[i,j]","
> > > > -	print "};"
> > > > +	print "};\n"
> > > > +
> > > > +	print "#else /* !__BOOT_COMPRESSED */\n"
> > 
> > I think the definitions of inat_*_tables can be shared in both case.
> > If __BOOT_COMPRESSED is set, we can define inat_init_tables() as a
> > initialize function, and if not, it will be just a dummy "do {} while (0)".
> 
> The inat_*_tables are all declared const, so this way it is not possible
> to change them at runtime.

Indeed.

> For the running kernel image this is fine, as
> there are ELF relocations which fix things up, but at the
> pre-decompression boot stage there are no ELF relocations which can fix
> the tables, so the pointers in there need to be initialized at runtime.

OK.

> 
> > BTW, where is the __BOOT_COMPRESSED defined?
> 
> It is defined in arch/x86/boot/compressed/sev-es.c by patch
> 
> 	x86/boot/compressed/64: Setup GHCB Based VC Exception handler
> 
> which also includes parts of the instruction decoder into the
> pre-decompression boot code and adds the only call-site for
> inat_init_tables().

Thanks, I understand it.

> 
> > > > +	print "static void inat_init_tables(void)"
> > 
> > This functions should be "inline".
> > And I can not see the call-site of inat_init_tables() in this patch.
> 
> The call-site is added with the patch that includes the
> instruction decoder into the pre-decompression code. If possible I'd
> like to keep those things separate, as both patches are already pretty
> big by themselfes (and they do different things, in different parts of
> the code).

OK, if you will send v2, please CC both to me.

> 
> > If possible, please include call-site with definition (especially
> > new init function) so that I can check the init call timing too.
> 
> The function is called at the first #VC exception after a GHCB has been
> set up. Call-path is: boot_vc_handler -> sev_es_setup_ghcb ->
> inat_init_tables.

sound good to me. 

Thank you,

> 
> See
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/joro/linux.git/tree/arch/x86/boot/compressed/sev-es.c?h=sev-es-client-v5.6-rc6
> 
> for the full code there.
> 
> Thanks,
> 
> 	Joerg


-- 
Masami Hiramatsu <mhiramat@kernel.org>
