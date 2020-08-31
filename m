Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944BF257F47
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 19:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgHaRJn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 13:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgHaRJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 13:09:43 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B312EC061573;
        Mon, 31 Aug 2020 10:09:42 -0700 (PDT)
Received: from zn.tnic (p200300ec2f085000329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:5000:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 143D61EC0428;
        Mon, 31 Aug 2020 19:09:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598893781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=aMZ5RZS0u1emzQ3FTdi1Dugu3WlGF9pi+6qmkEnK8Rw=;
        b=ni5Nt2PkyGASdLM+wB6eGSOKHks/SlKYXYL7PxLqWA9CEjov0CKErJ+94GqUsJTGbjV6hL
        HQi66OT4bPcjktuYjPQtvsS5QzgszPY4oKoQCYQlOr+cxDUXkCYmTT/Scd30nURTokc54z
        QfGRFJpmgV69Er15hYQJbH7ppI/yx9A=
Date:   Mon, 31 Aug 2020 19:09:37 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
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
Subject: Re: [PATCH v6 69/76] x86/realmode: Setup AP jump table
Message-ID: <20200831170937.GK27517@zn.tnic>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-70-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824085511.7553-70-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 10:55:04AM +0200, Joerg Roedel wrote:
> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
> index 8f36ae021a7f..a19ce9681ec2 100644
> --- a/arch/x86/include/uapi/asm/svm.h
> +++ b/arch/x86/include/uapi/asm/svm.h
> @@ -84,6 +84,9 @@
>  /* SEV-ES software-defined VMGEXIT events */
>  #define SVM_VMGEXIT_MMIO_READ			0x80000001
>  #define SVM_VMGEXIT_MMIO_WRITE			0x80000002
> +#define SVM_VMGEXIT_AP_JUMP_TABLE		0x80000005
> +#define		SVM_VMGEXIT_SET_AP_JUMP_TABLE			0
> +#define		SVM_VMGEXIT_GET_AP_JUMP_TABLE			1
	  ^^^^^^^^^^^^

One tab too many here.

>  #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
>  
>  #define SVM_EXIT_ERR           -1
> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index 28fe95ecd508..09a45ccd6c1d 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -21,6 +21,8 @@
>  #include <linux/mm.h>
>  
>  #include <asm/cpu_entry_area.h>
> +#include <asm/stacktrace.h>
> +#include <asm/realmode.h>
>  #include <asm/sev-es.h>
>  #include <asm/insn-eval.h>
>  #include <asm/fpu/internal.h>
> @@ -219,6 +221,9 @@ static __always_inline void sev_es_put_ghcb(struct ghcb_state *state)
>  	}
>  }
>  
> +/* Needed in vc_early_vc_forward_exception */

vc_early_forward_exception()

> +void do_early_exception(struct pt_regs *regs, int trapnr);
> +
>  static inline u64 sev_es_rd_ghcb_msr(void)
>  {
>  	return native_read_msr(MSR_AMD64_SEV_ES_GHCB);
> @@ -407,6 +412,69 @@ static bool vc_slow_virt_to_phys(struct ghcb *ghcb, struct es_em_ctxt *ctxt,
>  /* Include code shared with pre-decompression boot stage */
>  #include "sev-es-shared.c"
>  
> +static u64 sev_es_get_jump_table_addr(void)

Static and used here only once - you can drop the previx "sev_es".

> +{
> +	struct ghcb_state state;
> +	unsigned long flags;
> +	struct ghcb *ghcb;
> +	u64 ret;
> +
> +	local_irq_save(flags);
> +
> +	ghcb = sev_es_get_ghcb(&state);
> +
> +	vc_ghcb_invalidate(ghcb);
> +	ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_AP_JUMP_TABLE);
> +	ghcb_set_sw_exit_info_1(ghcb, SVM_VMGEXIT_GET_AP_JUMP_TABLE);
> +	ghcb_set_sw_exit_info_2(ghcb, 0);
> +
> +	sev_es_wr_ghcb_msr(__pa(ghcb));
> +	VMGEXIT();
> +
> +	if (!ghcb_sw_exit_info_1_is_valid(ghcb) ||
> +	    !ghcb_sw_exit_info_2_is_valid(ghcb))
> +		ret = 0;
> +
> +	ret = ghcb->save.sw_exit_info_2;
> +
> +	sev_es_put_ghcb(&state);
> +
> +	local_irq_restore(flags);
> +
> +	return ret;
> +}
> +
> +int sev_es_setup_ap_jump_table(struct real_mode_header *rmh)
> +{
> +	u16 startup_cs, startup_ip;
> +	phys_addr_t jump_table_pa;
> +	u64 jump_table_addr;
> +	u16 __iomem *jump_table;
> +
> +	jump_table_addr = sev_es_get_jump_table_addr();
> +
> +	/* Check if AP Jump Table is non-zero and page-aligned */
> +	if (!jump_table_addr || jump_table_addr & ~PAGE_MASK)
> +		return 0;

I think you need to return !0 here so that the panic() below fires with
a modified message:

	panic("Failed to get/update SEV-ES AP Jump Table");

or are we gonna boot an UP guest still?

If not panic, at least a warning that at least some APs didn't come
up...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
