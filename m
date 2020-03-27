Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 952FD194FDB
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 04:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgC0D4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 23:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbgC0D4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 23:56:39 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8275F206F6;
        Fri, 27 Mar 2020 03:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585281399;
        bh=GqjGknKW+LWtyRnJLS/2mtOhqmCZ/NesFPuEQ6k+BGo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q3Uimh3yFVlrdf5OeeLNPcb/2GyZLAO8GIJ2YlEQ7+qOFE+1yZDEqB6bPD3F4oJRd
         FUwao2D+NnXSYYob8oRoFVFY32vm3DWRfUFEkYW7DDHoAjgRaFC0sVB1apAvaLVqwB
         zWRLOceLtK8QdqvJAbDFj72Yi6xjlC1pID0FrthU=
Date:   Fri, 27 Mar 2020 12:56:33 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
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
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 09/70] x86/insn: Add insn_rep_prefix() helper
Message-Id: <20200327125633.ff660b1f4b14ca941fd1c799@kernel.org>
In-Reply-To: <20200319091407.1481-10-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
        <20200319091407.1481-10-joro@8bytes.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Mar 2020 10:13:06 +0100
Joerg Roedel <joro@8bytes.org> wrote:

> From: Joerg Roedel <jroedel@suse.de>
> 
> Add a function to check whether an instruction has a REP prefix.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/insn-eval.h |  1 +
>  arch/x86/lib/insn-eval.c         | 24 ++++++++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/arch/x86/include/asm/insn-eval.h b/arch/x86/include/asm/insn-eval.h
> index 1e343010129e..41dee0faae97 100644
> --- a/arch/x86/include/asm/insn-eval.h
> +++ b/arch/x86/include/asm/insn-eval.h
> @@ -15,6 +15,7 @@
>  #define INSN_CODE_SEG_OPND_SZ(params) (params & 0xf)
>  #define INSN_CODE_SEG_PARAMS(oper_sz, addr_sz) (oper_sz | (addr_sz << 4))
>  
> +bool insn_rep_prefix(struct insn *insn);

Can you make it "insn_has_rep_prefix()"?

Thank you,

>  void __user *insn_get_addr_ref(struct insn *insn, struct pt_regs *regs);
>  int insn_get_modrm_rm_off(struct insn *insn, struct pt_regs *regs);
>  int insn_get_modrm_reg_off(struct insn *insn, struct pt_regs *regs);
> diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
> index f18260a19960..5d98dff5a2d7 100644
> --- a/arch/x86/lib/insn-eval.c
> +++ b/arch/x86/lib/insn-eval.c
> @@ -53,6 +53,30 @@ static bool is_string_insn(struct insn *insn)
>  	}
>  }
>  
> +/**
> + * insn_rep_prefix() - Determine if instruction has a REP prefix
> + * @insn:	Instruction containing the prefix to inspect
> + *
> + * Returns:
> + *
> + * true if the instruction has a REP prefix, false if not.
> + */
> +bool insn_rep_prefix(struct insn *insn)
> +{
> +	int i;
> +
> +	insn_get_prefixes(insn);
> +
> +	for (i = 0; i < insn->prefixes.nbytes; i++) {
> +		insn_byte_t p = insn->prefixes.bytes[i];
> +
> +		if (p == 0xf2 || p == 0xf3)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  /**
>   * get_seg_reg_override_idx() - obtain segment register override index
>   * @insn:	Valid instruction with segment override prefixes
> -- 
> 2.17.1
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
