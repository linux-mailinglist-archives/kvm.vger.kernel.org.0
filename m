Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23043192CDA
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 16:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgCYPjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 11:39:54 -0400
Received: from mail.skyhub.de ([5.9.137.197]:52226 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728016AbgCYPjx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 11:39:53 -0400
Received: from zn.tnic (p200300EC2F0B0600F597EAD9BBACC1F1.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:600:f597:ead9:bbac:c1f1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8D21B1EC0CED;
        Wed, 25 Mar 2020 16:39:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1585150791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=YLgTI2CpRGQHZGrpCofrJEh8+eMyo8By5x3TJ6MG1PY=;
        b=YKro6Bqi33g4OHFZ5pL3ZedugLCCMsqNc56KydrYYPmTZwI5yzA29xDRUlbxZ71yRHbxhJ
        O8WCiyRUuE7ZmsnnidZSJYCLqpT1bK659/zS0D4NGl8ZKvcUgKbNbKczkekYXN5birVDUi
        /hoEo8RwhFmXVb2/Y8AGlyzFItQ9C1M=
Date:   Wed, 25 Mar 2020 16:39:45 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
Message-ID: <20200325153945.GD27261@zn.tnic>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-6-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200319091407.1481-6-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+ Masami.

On Thu, Mar 19, 2020 at 10:13:02AM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The inat-tables.c file has some arrays in it that contain pointers to
> other arrays. These pointers need to be relocated when the kernel
> image is moved to a different location.
> 
> The pre-decompression boot-code has no support for applying ELF
> relocations, so initialize these arrays at runtime in the
> pre-decompression code to make sure all pointers are correctly
> initialized.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/tools/gen-insn-attr-x86.awk       | 50 +++++++++++++++++++++-
>  tools/arch/x86/tools/gen-insn-attr-x86.awk | 50 +++++++++++++++++++++-
>  2 files changed, 98 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
> index a42015b305f4..af38469afd14 100644
> --- a/arch/x86/tools/gen-insn-attr-x86.awk
> +++ b/arch/x86/tools/gen-insn-attr-x86.awk
> @@ -362,6 +362,9 @@ function convert_operands(count,opnd,       i,j,imm,mod)
>  END {
>  	if (awkchecked != "")
>  		exit 1
> +
> +	print "#ifndef __BOOT_COMPRESSED\n"
> +
>  	# print escape opcode map's array
>  	print "/* Escape opcode map array */"
>  	print "const insn_attr_t * const inat_escape_tables[INAT_ESC_MAX + 1]" \
> @@ -388,6 +391,51 @@ END {
>  		for (j = 0; j < max_lprefix; j++)
>  			if (atable[i,j])
>  				print "	["i"]["j"] = "atable[i,j]","
> -	print "};"
> +	print "};\n"
> +
> +	print "#else /* !__BOOT_COMPRESSED */\n"
> +
> +	print "/* Escape opcode map array */"
> +	print "static const insn_attr_t *inat_escape_tables[INAT_ESC_MAX + 1]" \
> +	      "[INAT_LSTPFX_MAX + 1];"
> +	print ""
> +
> +	print "/* Group opcode map array */"
> +	print "static const insn_attr_t *inat_group_tables[INAT_GRP_MAX + 1]"\
> +	      "[INAT_LSTPFX_MAX + 1];"
> +	print ""
> +
> +	print "/* AVX opcode map array */"
> +	print "static const insn_attr_t *inat_avx_tables[X86_VEX_M_MAX + 1]"\
> +	      "[INAT_LSTPFX_MAX + 1];"
> +	print ""
> +
> +	print "static void inat_init_tables(void)"
> +	print "{"
> +
> +	# print escape opcode map's array
> +	print "\t/* Print Escape opcode map array */"
> +	for (i = 0; i < geid; i++)
> +		for (j = 0; j < max_lprefix; j++)
> +			if (etable[i,j])
> +				print "\tinat_escape_tables["i"]["j"] = "etable[i,j]";"
> +	print ""
> +
> +	# print group opcode map's array
> +	print "\t/* Print Group opcode map array */"
> +	for (i = 0; i < ggid; i++)
> +		for (j = 0; j < max_lprefix; j++)
> +			if (gtable[i,j])
> +				print "\tinat_group_tables["i"]["j"] = "gtable[i,j]";"
> +	print ""
> +	# print AVX opcode map's array
> +	print "\t/* Print AVX opcode map array */"
> +	for (i = 0; i < gaid; i++)
> +		for (j = 0; j < max_lprefix; j++)
> +			if (atable[i,j])
> +				print "\tinat_avx_tables["i"]["j"] = "atable[i,j]";"
> +
> +	print "}"
> +	print "#endif"
>  }
>  
> diff --git a/tools/arch/x86/tools/gen-insn-attr-x86.awk b/tools/arch/x86/tools/gen-insn-attr-x86.awk
> index a42015b305f4..af38469afd14 100644
> --- a/tools/arch/x86/tools/gen-insn-attr-x86.awk
> +++ b/tools/arch/x86/tools/gen-insn-attr-x86.awk
> @@ -362,6 +362,9 @@ function convert_operands(count,opnd,       i,j,imm,mod)
>  END {
>  	if (awkchecked != "")
>  		exit 1
> +
> +	print "#ifndef __BOOT_COMPRESSED\n"
> +
>  	# print escape opcode map's array
>  	print "/* Escape opcode map array */"
>  	print "const insn_attr_t * const inat_escape_tables[INAT_ESC_MAX + 1]" \
> @@ -388,6 +391,51 @@ END {
>  		for (j = 0; j < max_lprefix; j++)
>  			if (atable[i,j])
>  				print "	["i"]["j"] = "atable[i,j]","
> -	print "};"
> +	print "};\n"
> +
> +	print "#else /* !__BOOT_COMPRESSED */\n"
> +
> +	print "/* Escape opcode map array */"
> +	print "static const insn_attr_t *inat_escape_tables[INAT_ESC_MAX + 1]" \
> +	      "[INAT_LSTPFX_MAX + 1];"
> +	print ""
> +
> +	print "/* Group opcode map array */"
> +	print "static const insn_attr_t *inat_group_tables[INAT_GRP_MAX + 1]"\
> +	      "[INAT_LSTPFX_MAX + 1];"
> +	print ""
> +
> +	print "/* AVX opcode map array */"
> +	print "static const insn_attr_t *inat_avx_tables[X86_VEX_M_MAX + 1]"\
> +	      "[INAT_LSTPFX_MAX + 1];"
> +	print ""
> +
> +	print "static void inat_init_tables(void)"
> +	print "{"
> +
> +	# print escape opcode map's array
> +	print "\t/* Print Escape opcode map array */"
> +	for (i = 0; i < geid; i++)
> +		for (j = 0; j < max_lprefix; j++)
> +			if (etable[i,j])
> +				print "\tinat_escape_tables["i"]["j"] = "etable[i,j]";"
> +	print ""
> +
> +	# print group opcode map's array
> +	print "\t/* Print Group opcode map array */"
> +	for (i = 0; i < ggid; i++)
> +		for (j = 0; j < max_lprefix; j++)
> +			if (gtable[i,j])
> +				print "\tinat_group_tables["i"]["j"] = "gtable[i,j]";"
> +	print ""
> +	# print AVX opcode map's array
> +	print "\t/* Print AVX opcode map array */"
> +	for (i = 0; i < gaid; i++)
> +		for (j = 0; j < max_lprefix; j++)
> +			if (atable[i,j])
> +				print "\tinat_avx_tables["i"]["j"] = "atable[i,j]";"
> +
> +	print "}"
> +	print "#endif"
>  }
>  
> -- 
> 2.17.1
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
