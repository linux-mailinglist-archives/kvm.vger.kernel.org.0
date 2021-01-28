Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF90307708
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 14:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbhA1N1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 08:27:38 -0500
Received: from 8bytes.org ([81.169.241.247]:53438 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229950AbhA1N1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 08:27:37 -0500
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jan 2021 08:27:36 EST
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 8407751D; Thu, 28 Jan 2021 14:18:19 +0100 (CET)
Date:   Thu, 28 Jan 2021 14:18:18 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Cc:     X86 ML <x86@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
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
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v7 45/72] x86/entry/64: Add entry code for #VC handler
Message-ID: <20210128131817.GP32671@8bytes.org>
References: <20200907131613.12703-1-joro@8bytes.org>
 <20200907131613.12703-46-joro@8bytes.org>
 <CAJhGHyCMMCY9bZauzrSeQr_62SpJgZQEQy9P7Rh28HXJtF5O5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhGHyCMMCY9bZauzrSeQr_62SpJgZQEQy9P7Rh28HXJtF5O5A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Lai,

On Sun, Jan 24, 2021 at 10:11:14PM +0800, Lai Jiangshan wrote:
> > +
> > +       /*
> > +        * No need to switch back to the IST stack. The current stack is either
> > +        * identical to the stack in the IRET frame or the VC fall-back stack,
> > +        * so it is definitly mapped even with PTI enabled.
> > +        */
> > +       jmp     paranoid_exit
> > +
> >
> 
> Hello
> 
> I know we don't enable PTI on AMD, but the above comment doesn't align to the
> next code.
> 
> We assume PTI is enabled as the comments said "even with PTI enabled".
> 
> When #VC happens after entry_SYSCALL_64 but before it switches to the
> kernel CR3.  vc_switch_off_ist() will switch the stack to the kernel stack
> and paranoid_exit can't work when it switches to user CR3 on the kernel stack.
> 
> The comment above lost information that the current stack is possible to be
> the kernel stack which is mapped not user CR3.
> 
> Maybe I missed something.

You are right, the scenario above would cause problems for the current
#VC entry code. With SEV-ES an #VC exception can't happen in the early
syscall entry code, so I think its the best to update the comment
reflecting this.

In the future this might change and then the #VC entry code needs to
take care of this case too. Thanks for pointing it out.

Regards,

	Joerg
