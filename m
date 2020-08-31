Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D28B2575ED
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 10:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgHaI6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 04:58:18 -0400
Received: from 8bytes.org ([81.169.241.247]:40058 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727810AbgHaI6S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 04:58:18 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 4F673310; Mon, 31 Aug 2020 10:58:13 +0200 (CEST)
Date:   Mon, 31 Aug 2020 10:58:10 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
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
Subject: Re: [PATCH v6 38/76] x86/head/64: Set CR4.FSGSBASE early
Message-ID: <20200831085810.GA13507@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-39-joro@8bytes.org>
 <20200829155525.GB29091@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200829155525.GB29091@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 29, 2020 at 05:55:25PM +0200, Borislav Petkov wrote:
> On Mon, Aug 24, 2020 at 10:54:33AM +0200, Joerg Roedel wrote:
> > From: Joerg Roedel <jroedel@suse.de>
> > 
> > Early exception handling will use rd/wrgsbase in paranoid_entry/exit.
> > Enable the feature to avoid #UD exceptions on boot APs.
> > 
> > Signed-off-by: Joerg Roedel <jroedel@suse.de>
> > Link: https://lore.kernel.org/r/20200724160336.5435-38-joro@8bytes.org
> > ---
> >  arch/x86/kernel/head_64.S | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> > index 08412f308de3..4622940134a5 100644
> > --- a/arch/x86/kernel/head_64.S
> > +++ b/arch/x86/kernel/head_64.S
> > @@ -153,6 +153,13 @@ SYM_CODE_START(secondary_startup_64)
> >  	orl	$X86_CR4_LA57, %ecx
> >  1:
> >  #endif
> > +
> > +	ALTERNATIVE "jmp .Lstartup_write_cr4", "", X86_FEATURE_FSGSBASE
> > +
> > +	/* Early exception handling uses FSGSBASE on APs */
> > +	orl	$X86_CR4_FSGSBASE, %ecx
> 
> How is this supposed to work?
> 
> Alternatives haven't run that early yet and that piece of code looks
> like this:
> 
> ffffffff81000067:       eb 06                   jmp    ffffffff8100006f <secondary_startup_64+0x1f>
> ffffffff81000069:       81 c9 00 00 01 00       or     $0x10000,%ecx
> ffffffff8100006f:       0f 22 e1                mov    %rcx,%cr4
> 
> so we'll never set X86_CR4_FSGSBASE during early boot.

This is not needed on the boot CPU, but only on secondary CPUs. When
those are brought up the alternatives have been patches already. The
commit message should probably be more clear about that, I will fix
that.

The CR4 bit also can't be set unconditionally here on the boot CPU,
because at that point the kernel does not know whether the CPU has
support for the fsgsbase instructions.


Regards,

	Joerg

