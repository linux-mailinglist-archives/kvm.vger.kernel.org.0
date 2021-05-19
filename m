Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66933894D6
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 19:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhESR6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 13:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhESR6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 13:58:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6B2C06175F;
        Wed, 19 May 2021 10:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0VusAJZ3GsBzVSdLTEAGWr7rdRHdzn/JtH42moT3IVU=; b=RF8RFvqQuOtdFP/lCsk93yjuz9
        LTOSQBYY2k6m3umvaeS2K30f9je5U14s6FuCQezx+ml8LwzduT3682kYN72e7kAXxlFkaLpCEkALU
        u9NL1h1C4e/riHeHEUZfm16LDlc3uHlsIRFrZPWeixuho32kANI9e+dZzxJNM9siit0/n4Jmxmcli
        5kONPHTxaJ+tC/1VAo5uRnYbKWhHetXqeNRAzaShstYsNAvCqs+n7znoLP1qSotPo+nM0EN3S7Mgq
        Gz/lXNIqTq6iNQCjCe/BNG6yKXdM2Kr0aOI7y0Z+cWo2vI4JH67DZTB/1qxgdQ87QkyaDvmBMEUjR
        XP02rlpA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljQPD-00FB8B-O6; Wed, 19 May 2021 17:55:03 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 336EF986465; Wed, 19 May 2021 19:54:50 +0200 (CEST)
Date:   Wed, 19 May 2021 19:54:50 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Hyunwook Baek <baekhw@google.com>,
        Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 5/8] x86/sev-es: Leave NMI-mode before sending signals
Message-ID: <20210519175450.GF21560@worktop.programming.kicks-ass.net>
References: <20210519135251.30093-1-joro@8bytes.org>
 <20210519135251.30093-6-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519135251.30093-6-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 03:52:48PM +0200, Joerg Roedel wrote:
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -1343,9 +1343,10 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
>  		return;
>  	}
>  
> +	instrumentation_begin();
> +
>  	irq_state = irqentry_nmi_enter(regs);
>  	lockdep_assert_irqs_disabled();
> -	instrumentation_begin();
>  
>  	/*
>  	 * This is invoked through an interrupt gate, so IRQs are disabled. The

That's just plain wrong. No instrumentation is allowed before you enter
the exception context.

> @@ -1395,13 +1396,19 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
>  		BUG();
>  	}
>  
> -out:
> -	instrumentation_end();
>  	irqentry_nmi_exit(regs, irq_state);
> +	instrumentation_end();

And this can't be right either, same issue, no instrumentation is
allowed after you leave the exception context.

>  
>  	return;
>  
>  fail:
> +	/*
> +	 * Leave NMI mode - the GHCB is not busy anymore and depending on where
> +	 * the #VC came from this code is about to either kill the task (when in
> +	 * task context) or kill the machine.
> +	 */
> +	irqentry_nmi_exit(regs, irq_state);
> +

And this is wrong too; because at this point the handler doesn't run in
_any_ context anymore, certainly not one you can call regular C code
from.

>  	if (user_mode(regs)) {
>  		/*
>  		 * Do not kill the machine if user-space triggered the
> @@ -1423,7 +1430,9 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
>  		panic("Returned from Terminate-Request to Hypervisor\n");
>  	}
>  
> -	goto out;
> +	instrumentation_end();
> +
> +	return;
>  }


You either get to do what MCE does, or what MCE does. That is, either
use task_work or MCE_USER and have the _user() handler use
irqentry_enter_from_user_mode().

The above is an absolute no-go.
