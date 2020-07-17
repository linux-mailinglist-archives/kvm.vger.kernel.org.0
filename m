Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EFB223DAE
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 16:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgGQOGb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 10:06:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727876AbgGQOGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 10:06:30 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22AFE2067D;
        Fri, 17 Jul 2020 14:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594994790;
        bh=idhd2mun2o3KTZfXKc7yxApyqOFeBVXhlYMrKvNie5U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KaQrFt+YhFkTXtEgafkFEb1WYvRfdZ4Kw0ki3VoubVwnrLGVDz8sU/1yskahu7eCy
         7gQmmSH6lOqgTLjYUK+DloD0v5HMyHQie7V+qLc+Edn8y8RmecTmQSPolQQwRh4bK3
         IUvtlU6lhpCZpunU3IsRYhQnTKqj0S8gGlEmwpSY=
Date:   Fri, 17 Jul 2020 23:06:22 +0900
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
Subject: Re: [PATCH v4 10/75] x86/insn: Add insn_has_rep_prefix() helper
Message-Id: <20200717230622.5be651b71711368acbfe6bb0@kernel.org>
In-Reply-To: <20200714120917.11253-11-joro@8bytes.org>
References: <20200714120917.11253-1-joro@8bytes.org>
        <20200714120917.11253-11-joro@8bytes.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jul 2020 14:08:12 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> From: Joerg Roedel <jroedel@suse.de>
> 
> Add a function to check whether an instruction has a REP prefix.

This looks good to me.

Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
 
Thank you,

> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/insn-eval.h |  1 +
>  arch/x86/lib/insn-eval.c         | 24 ++++++++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/arch/x86/include/asm/insn-eval.h b/arch/x86/include/asm/insn-eval.h
> index f748f57f1491..a0f839aa144d 100644
> --- a/arch/x86/include/asm/insn-eval.h
> +++ b/arch/x86/include/asm/insn-eval.h
> @@ -15,6 +15,7 @@
>  #define INSN_CODE_SEG_OPND_SZ(params) (params & 0xf)
>  #define INSN_CODE_SEG_PARAMS(oper_sz, addr_sz) (oper_sz | (addr_sz << 4))
>  
> +bool insn_has_rep_prefix(struct insn *insn);
>  void __user *insn_get_addr_ref(struct insn *insn, struct pt_regs *regs);
>  int insn_get_modrm_rm_off(struct insn *insn, struct pt_regs *regs);
>  int insn_get_modrm_reg_off(struct insn *insn, struct pt_regs *regs);
> diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
> index a8ac5c5e94f0..8ed9d645259c 100644
> --- a/arch/x86/lib/insn-eval.c
> +++ b/arch/x86/lib/insn-eval.c
> @@ -53,6 +53,30 @@ static bool is_string_insn(struct insn *insn)
>  	}
>  }
>  
> +/**
> + * insn_has_rep_prefix() - Determine if instruction has a REP prefix
> + * @insn:	Instruction containing the prefix to inspect
> + *
> + * Returns:
> + *
> + * true if the instruction has a REP prefix, false if not.
> + */
> +bool insn_has_rep_prefix(struct insn *insn)
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
> 2.27.0
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
