Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0832194F63
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 04:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgC0DDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 23:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgC0DDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 23:03:02 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CA9C20787;
        Fri, 27 Mar 2020 03:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585278181;
        bh=b2ccDeO/pD0R+Y+srohROcyVA9Q145YuMgSh8oAXLmM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rniJm74HvN/lsrQkGt9EY0ampwZGukQI1mGNUHZ+Y1qgVosyqSmxQh7Y/aB0kiHUd
         skjYGOhr0dmRm2/Rkd2IbLKBHC5ii1/ZdoWPnM2LYGCid8jJUA+iigEapBxQLUIJVy
         je1LuCvKfE6zYULbGOvvJ9u/UCVNUeI2v0ouqBgk=
Date:   Fri, 27 Mar 2020 12:02:32 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Borislav Petkov <bp@alien8.de>, Joerg Roedel <jroedel@suse.de>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH 05/70] x86/insn: Make inat-tables.c suitable for
 pre-decompression code
Message-Id: <20200327120232.c8e455ca100dc0d96e4ddc43@kernel.org>
In-Reply-To: <20200325153945.GD27261@zn.tnic>
References: <20200319091407.1481-1-joro@8bytes.org>
        <20200319091407.1481-6-joro@8bytes.org>
        <20200325153945.GD27261@zn.tnic>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, 25 Mar 2020 16:39:45 +0100
Borislav Petkov <bp@alien8.de> wrote:

> + Masami.
> 
> On Thu, Mar 19, 2020 at 10:13:02AM +0100, Joerg Roedel wrote:
> > From: Joerg Roedel <jroedel@suse.de>
> > 
> > The inat-tables.c file has some arrays in it that contain pointers to
> > other arrays. These pointers need to be relocated when the kernel
> > image is moved to a different location.
> > 
> > The pre-decompression boot-code has no support for applying ELF
> > relocations, so initialize these arrays at runtime in the
> > pre-decompression code to make sure all pointers are correctly
> > initialized.

I need to check the whole series, but as far as I can understand from
this patch, this seems not allowing to store the address value in
static pointers. It may break more things, for example _kprobe_blacklist
records the NOKPROBE_SYMBOL() symbol addresses at the build time.

I have some comments here.
 
> > Signed-off-by: Joerg Roedel <jroedel@suse.de>
> > ---
> >  arch/x86/tools/gen-insn-attr-x86.awk       | 50 +++++++++++++++++++++-
> >  tools/arch/x86/tools/gen-insn-attr-x86.awk | 50 +++++++++++++++++++++-
> >  2 files changed, 98 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
> > index a42015b305f4..af38469afd14 100644
> > --- a/arch/x86/tools/gen-insn-attr-x86.awk
> > +++ b/arch/x86/tools/gen-insn-attr-x86.awk
> > @@ -362,6 +362,9 @@ function convert_operands(count,opnd,       i,j,imm,mod)
> >  END {
> >  	if (awkchecked != "")
> >  		exit 1
> > +
> > +	print "#ifndef __BOOT_COMPRESSED\n"
> > +
> >  	# print escape opcode map's array
> >  	print "/* Escape opcode map array */"
> >  	print "const insn_attr_t * const inat_escape_tables[INAT_ESC_MAX + 1]" \
> > @@ -388,6 +391,51 @@ END {
> >  		for (j = 0; j < max_lprefix; j++)
> >  			if (atable[i,j])
> >  				print "	["i"]["j"] = "atable[i,j]","
> > -	print "};"
> > +	print "};\n"
> > +
> > +	print "#else /* !__BOOT_COMPRESSED */\n"

I think the definitions of inat_*_tables can be shared in both case.
If __BOOT_COMPRESSED is set, we can define inat_init_tables() as a
initialize function, and if not, it will be just a dummy "do {} while (0)".

BTW, where is the __BOOT_COMPRESSED defined?

> > +
> > +	print "/* Escape opcode map array */"
> > +	print "static const insn_attr_t *inat_escape_tables[INAT_ESC_MAX + 1]" \
> > +	      "[INAT_LSTPFX_MAX + 1];"
> > +	print ""
> > +
> > +	print "/* Group opcode map array */"
> > +	print "static const insn_attr_t *inat_group_tables[INAT_GRP_MAX + 1]"\
> > +	      "[INAT_LSTPFX_MAX + 1];"
> > +	print ""
> > +
> > +	print "/* AVX opcode map array */"
> > +	print "static const insn_attr_t *inat_avx_tables[X86_VEX_M_MAX + 1]"\
> > +	      "[INAT_LSTPFX_MAX + 1];"
> > +	print ""
> > +
> > +	print "static void inat_init_tables(void)"

This functions should be "inline".
And I can not see the call-site of inat_init_tables() in this patch.

If possible, please include call-site with definition (especially
new init function) so that I can check the init call timing too.

> > +	print "{"
> > +
> > +	# print escape opcode map's array
> > +	print "\t/* Print Escape opcode map array */"
> > +	for (i = 0; i < geid; i++)
> > +		for (j = 0; j < max_lprefix; j++)
> > +			if (etable[i,j])
> > +				print "\tinat_escape_tables["i"]["j"] = "etable[i,j]";"
> > +	print ""
> > +
> > +	# print group opcode map's array
> > +	print "\t/* Print Group opcode map array */"
> > +	for (i = 0; i < ggid; i++)
> > +		for (j = 0; j < max_lprefix; j++)
> > +			if (gtable[i,j])
> > +				print "\tinat_group_tables["i"]["j"] = "gtable[i,j]";"
> > +	print ""
> > +	# print AVX opcode map's array
> > +	print "\t/* Print AVX opcode map array */"
> > +	for (i = 0; i < gaid; i++)
> > +		for (j = 0; j < max_lprefix; j++)
> > +			if (atable[i,j])
> > +				print "\tinat_avx_tables["i"]["j"] = "atable[i,j]";"
> > +
> > +	print "}"
> > +	print "#endif"
> >  }

The code itself looks good to me.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
