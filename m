Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC683AA3B2
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 21:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhFPTDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 15:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhFPTDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 15:03:39 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04211C061574;
        Wed, 16 Jun 2021 12:01:33 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 5BDFA387; Wed, 16 Jun 2021 21:01:31 +0200 (CEST)
Date:   Wed, 16 Jun 2021 21:01:30 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Peter Zijlstra <peterz@infradead.org>
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v5 3/6] x86/sev-es: Split up runtime #VC handler for
 correct state tracking
Message-ID: <YMpKim/3Dc41xvF7@8bytes.org>
References: <20210614135327.9921-1-joro@8bytes.org>
 <20210614135327.9921-4-joro@8bytes.org>
 <YMohCkW/mChNpkqi@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMohCkW/mChNpkqi@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

sorry, missed this email before sending out v6.

On Wed, Jun 16, 2021 at 06:04:26PM +0200, Peter Zijlstra wrote:
> On Mon, Jun 14, 2021 at 03:53:24PM +0200, Joerg Roedel wrote:
> >  _ASM_NOKPROBE(\asmsym)
> >  SYM_CODE_END(\asmsym)
> 
> Consistency with idtentry_mce_db would seem to suggest using \cfunc and
> noist_\cfunc.
> 
> amluto, tglx: do we have strong feelings on consistency?

Yeah, but this distinction does not make sense here, as none of the #VC
handlers C functions run on the actual #VC IST stack. The from-kernel
function might run on the fall-back stack (not really possible today
unless the hypervisor does something nasty). And the difference between
the fall-back stack and the actual IST stack is, that on the fall-back
stack nesting #VC exceptions is still supported.

> > +	vc_handle_trap_db(regs);
> 
> It's a bit sad this does user_mode(regs) again.

Okay, I will change this according your comments.

Thanks,

	Joerg

