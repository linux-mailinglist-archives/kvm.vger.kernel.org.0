Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A38E220920
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 11:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730824AbgGOJrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 05:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730000AbgGOJrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 05:47:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07996C061755;
        Wed, 15 Jul 2020 02:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0elNuqYxcCo1hxsLEEQkxpnR+7H9VliZhBonNrxGt2Y=; b=rGy15IwTdosyqZKG9Fqu61aw8r
        EcZqWOQPfINy492XWxED50S8KJjaSk2xP068ox4WapjrUXn0tcqK85EqV4MyFmONN72dm0x4BFmsL
        obY7r6FuMNdeixQGVaOA8lsOHVH1WSfrgP8wMRvXhlrxAMk5wmMbJN72IlywZHIO8SLxOlVd8T5Xm
        t3qjIJHlibrn7hbOfDk1StAlw/Hgd83oGiTYkjBSF4Tkv34kCsYkgjos0J5jqaOKXuyirk4YKpgy1
        /IcvszPzckLNg5+AsNpyaCsU/coExmg8PiDbzLwsndF6ajo69ZfzGRko1WQojQClj99DuhyNBasrz
        t+oPuxPw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jve0G-00033K-3p; Wed, 15 Jul 2020 09:47:04 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B9F563028C8;
        Wed, 15 Jul 2020 11:47:02 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A202F20D27C63; Wed, 15 Jul 2020 11:47:02 +0200 (CEST)
Date:   Wed, 15 Jul 2020 11:47:02 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
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
Subject: Re: [PATCH v4 45/75] x86/sev-es: Adjust #VC IST Stack on entering
 NMI handler
Message-ID: <20200715094702.GF10769@hirez.programming.kicks-ass.net>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-46-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714120917.11253-46-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 02:08:47PM +0200, Joerg Roedel wrote:

> @@ -489,6 +490,9 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
>  	this_cpu_write(nmi_cr2, read_cr2());
>  nmi_restart:
>  
> +	/* Needs to happen before DR7 is accessed */
> +	sev_es_ist_enter(regs);
> +
>  	this_cpu_write(nmi_dr7, local_db_save());
>  
>  	nmi_enter();
> @@ -502,6 +506,8 @@ DEFINE_IDTENTRY_RAW(exc_nmi)
>  
>  	local_db_restore(this_cpu_read(nmi_dr7));
>  
> +	sev_es_ist_exit();
> +
>  	if (unlikely(this_cpu_read(nmi_cr2) != read_cr2()))
>  		write_cr2(this_cpu_read(nmi_cr2));
>  	if (this_cpu_dec_return(nmi_state))

I really hate all this #VC stuff :-(

So the above will make the NMI do 4 unconditional extra CALL+RET, a LOAD
(which will potentially miss) and a compare and branch.

How's that a win for normal people? Can we please turn all these
sev_es_*() hooks into something like:

DECLARE_STATIC_KEY_FALSE(sev_es_enabled_key);

static __always_inline void sev_es_foo()
{
	if (static_branch_unlikely(&sev_es_enabled_key))
		__sev_es_foo();
}

So that normal people will only see an extra NOP?

> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index d415368f16ec..2a7cc72db1d5 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -78,6 +78,67 @@ static void __init sev_es_setup_vc_stacks(int cpu)
>  	tss->x86_tss.ist[IST_INDEX_VC] = CEA_ESTACK_TOP(&cea->estacks, VC);
>  }
>  
> +static bool on_vc_stack(unsigned long sp)

noinstr or __always_inline

> +{
> +	return ((sp >= __this_cpu_ist_bot_va(VC)) && (sp < __this_cpu_ist_top_va(VC)));
> +}
> +
> +/*
> + * This function handles the case when an NMI or an NMI-like exception
> + * like #DB is raised in the #VC exception handler entry code. In this

I've yet to find you handle the NMI-like cases..

> + * case the IST entry for VC must be adjusted, so that any subsequent VC
> + * exception will not overwrite the stack contents of the interrupted VC
> + * handler.
> + *
> + * The IST entry is adjusted unconditionally so that it can be also be
> + * unconditionally back-adjusted in sev_es_nmi_exit(). Otherwise a
> + * nested nmi_exit() call (#VC->NMI->#DB) may back-adjust the IST entry
> + * too early.

Is this comment accurate, I cannot find the patch touching
nmi_enter/exit()?

> + */
> +void noinstr sev_es_ist_enter(struct pt_regs *regs)
> +{
> +	unsigned long old_ist, new_ist;
> +	unsigned long *p;
> +
> +	if (!sev_es_active())
> +		return;
> +
> +	/* Read old IST entry */
> +	old_ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
> +
> +	/* Make room on the IST stack */
> +	if (on_vc_stack(regs->sp))
> +		new_ist = ALIGN_DOWN(regs->sp, 8) - sizeof(old_ist);
> +	else
> +		new_ist = old_ist - sizeof(old_ist);
> +
> +	/* Store old IST entry */
> +	p       = (unsigned long *)new_ist;
> +	*p      = old_ist;
> +
> +	/* Set new IST entry */
> +	this_cpu_write(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC], new_ist);
> +}
> +
> +void noinstr sev_es_ist_exit(void)
> +{
> +	unsigned long ist;
> +	unsigned long *p;
> +
> +	if (!sev_es_active())
> +		return;
> +
> +	/* Read IST entry */
> +	ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
> +
> +	if (WARN_ON(ist == __this_cpu_ist_top_va(VC)))
> +		return;
> +
> +	/* Read back old IST entry and write it to the TSS */
> +	p = (unsigned long *)ist;
> +	this_cpu_write(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC], *p);
> +}

That's pretty disguisting :-(
