Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FCF22085D
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 11:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbgGOJNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 05:13:41 -0400
Received: from [195.135.220.15] ([195.135.220.15]:55238 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1728672AbgGOJNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 05:13:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1D30FAF69;
        Wed, 15 Jul 2020 09:13:43 +0000 (UTC)
Date:   Wed, 15 Jul 2020 11:13:37 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
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
Subject: Re: [PATCH v4 63/75] x86/sev-es: Handle #DB Events
Message-ID: <20200715091337.GI16200@suse.de>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-64-joro@8bytes.org>
 <20200715084752.GD10769@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715084752.GD10769@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 15, 2020 at 10:47:52AM +0200, Peter Zijlstra wrote:
> On Tue, Jul 14, 2020 at 02:09:05PM +0200, Joerg Roedel wrote:
> 
> > @@ -1028,6 +1036,16 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
> >  	struct ghcb *ghcb;
> >  
> >  	lockdep_assert_irqs_disabled();
> > +
> > +	/*
> > +	 * #DB is special and needs to be handled outside of the intrumentation_begin()/end().
> > +	 * Otherwise the #VC handler could be raised recursivly.
> > +	 */
> > +	if (error_code == SVM_EXIT_EXCP_BASE + X86_TRAP_DB) {
> > +		vc_handle_trap_db(regs);
> > +		return;
> > +	}
> > +
> >  	instrumentation_begin();
> 
> Wait what?! That makes no sense what so ever.

Then my understanding of intrumentation_begin/end() is wrong, I thought
that the kernel will forbid setting breakpoints before
instrumentation_begin(), which is necessary here because a break-point
in the #VC handler might cause recursive #VC-exceptions when #DB is
intercepted.
Maybe you can elaborate on why this makes no sense?

Regards,

	Joerg
