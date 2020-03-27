Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE456194FDD
	for <lists+kvm@lfdr.de>; Fri, 27 Mar 2020 04:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgC0D6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 23:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727720AbgC0D6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 23:58:01 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89138206F6;
        Fri, 27 Mar 2020 03:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585281481;
        bh=jFUGAp1PeQqxd1JdRVAEytRDYWJuh7d1ipm/WEzxR5Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZPSTFUTimQoSCNBjHHFJunrRLWkxQx9uogTnpX+mmjmVcaJtn7kRVDvbDgGGe+0le
         CvPGTNbA91dIUI/GlsIXD2rROGYw/OEkZy/EB0X3mtEXOXDdi+0j07LbUl7gMuE2/Q
         y/x1x4ErYBpZumhFSy/iN8bpF7VqxXuzz0AxRN0Q=
Date:   Fri, 27 Mar 2020 12:57:51 +0900
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
Subject: Re: [PATCH 08/70] x86/insn: Add insn_get_modrm_reg_off()
Message-Id: <20200327125751.1b6cdf8e298fd0d2ce5f3d1f@kernel.org>
In-Reply-To: <20200319091407.1481-9-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
        <20200319091407.1481-9-joro@8bytes.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 19 Mar 2020 10:13:05 +0100
Joerg Roedel <joro@8bytes.org> wrote:

> From: Joerg Roedel <jroedel@suse.de>
> 
> Add a function to the instruction decoder which returns the pt_regs
> offset of the register specified in the reg field of the modrm byte.
> 

This looks good to me.

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you,

> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/insn-eval.h |  1 +
>  arch/x86/lib/insn-eval.c         | 23 +++++++++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/arch/x86/include/asm/insn-eval.h b/arch/x86/include/asm/insn-eval.h
> index b4ff3e3316d1..1e343010129e 100644
> --- a/arch/x86/include/asm/insn-eval.h
> +++ b/arch/x86/include/asm/insn-eval.h
> @@ -17,6 +17,7 @@
>  
>  void __user *insn_get_addr_ref(struct insn *insn, struct pt_regs *regs);
>  int insn_get_modrm_rm_off(struct insn *insn, struct pt_regs *regs);
> +int insn_get_modrm_reg_off(struct insn *insn, struct pt_regs *regs);
>  unsigned long insn_get_seg_base(struct pt_regs *regs, int seg_reg_idx);
>  int insn_get_code_seg_params(struct pt_regs *regs);
>  int insn_fetch_from_user(struct pt_regs *regs,
> diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
> index 1949f5258f9e..f18260a19960 100644
> --- a/arch/x86/lib/insn-eval.c
> +++ b/arch/x86/lib/insn-eval.c
> @@ -20,6 +20,7 @@
>  
>  enum reg_type {
>  	REG_TYPE_RM = 0,
> +	REG_TYPE_REG,
>  	REG_TYPE_INDEX,
>  	REG_TYPE_BASE,
>  };
> @@ -441,6 +442,13 @@ static int get_reg_offset(struct insn *insn, struct pt_regs *regs,
>  			regno += 8;
>  		break;
>  
> +	case REG_TYPE_REG:
> +		regno = X86_MODRM_REG(insn->modrm.value);
> +
> +		if (X86_REX_R(insn->rex_prefix.value))
> +			regno += 8;
> +		break;
> +
>  	case REG_TYPE_INDEX:
>  		regno = X86_SIB_INDEX(insn->sib.value);
>  		if (X86_REX_X(insn->rex_prefix.value))
> @@ -809,6 +817,21 @@ int insn_get_modrm_rm_off(struct insn *insn, struct pt_regs *regs)
>  	return get_reg_offset(insn, regs, REG_TYPE_RM);
>  }
>  
> +/**
> + * insn_get_modrm_reg_off() - Obtain register in reg part of the ModRM byte
> + * @insn:	Instruction containing the ModRM byte
> + * @regs:	Register values as seen when entering kernel mode
> + *
> + * Returns:
> + *
> + * The register indicated by the reg part of the ModRM byte. The
> + * register is obtained as an offset from the base of pt_regs.
> + */
> +int insn_get_modrm_reg_off(struct insn *insn, struct pt_regs *regs)
> +{
> +	return get_reg_offset(insn, regs, REG_TYPE_REG);
> +}
> +
>  /**
>   * get_seg_base_limit() - obtain base address and limit of a segment
>   * @insn:	Instruction. Must be valid.
> -- 
> 2.17.1
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
