Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96348223D7E
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 15:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgGQN6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 09:58:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726221AbgGQN6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 09:58:34 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 944A220734;
        Fri, 17 Jul 2020 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594994313;
        bh=Plz5TltdSn/IewUzgCiC3cN/jylVnKWqSCAhHiSo6lM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EctyEe6PrPzJ4u1JkQtW/nGvUCrpipoDf0/CPUxwhU2PXlKI4xD9lEEkG5EVwhyqw
         k+ybzyL/f09T9OTjUTy+ndrnXIcO7yuf67ZS/TESVH+D5O+d/Qj2VAxvbsQ0oSFlW4
         R6c3AHkVNVgFv0m/g/P3iQMRVWBpM6TPaa+qmyXQ=
Date:   Fri, 17 Jul 2020 22:58:26 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 06/75] x86/insn: Make inat-tables.c suitable for
 pre-decompression code
Message-Id: <20200717225826.3b16e168de2a1573150e7952@kernel.org>
In-Reply-To: <20200714120917.11253-7-joro@8bytes.org>
References: <20200714120917.11253-1-joro@8bytes.org>
        <20200714120917.11253-7-joro@8bytes.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jul 2020 14:08:08 +0200
Joerg Roedel <joro@8bytes.org> wrote:

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

OK, This looks good to me.

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you,

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
> 2.27.0
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
