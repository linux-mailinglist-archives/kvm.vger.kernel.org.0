Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEFC415A82D
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 12:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgBLLpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 06:45:06 -0500
Received: from 8bytes.org ([81.169.241.247]:53690 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728386AbgBLLpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 06:45:05 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 01EBF4A6; Wed, 12 Feb 2020 12:45:03 +0100 (CET)
Date:   Wed, 12 Feb 2020 12:44:51 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 18/62] x86/boot/compressed/64: Setup GHCB Based VC
 Exception handler
Message-ID: <20200212114451.GC20066@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
 <20200211135256.24617-19-joro@8bytes.org>
 <CALCETrVWoG7ugfE_FJgNKyyWYCmZh1162kfceJ2bs+O7Qyf-8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVWoG7ugfE_FJgNKyyWYCmZh1162kfceJ2bs+O7Qyf-8A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 02:25:49PM -0800, Andy Lutomirski wrote:
> On Tue, Feb 11, 2020 at 5:53 AM Joerg Roedel <joro@8bytes.org> wrote:
> >
> > From: Joerg Roedel <jroedel@suse.de>
> >
> > Install an exception handler for #VC exception that uses a GHCB. Also
> > add the infrastructure for handling different exit-codes by decoding
> > the instruction that caused the exception and error handling.
> >
> 
> > diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
> > index 8d13121a8cf2..02fb6f57128b 100644
> > --- a/arch/x86/boot/compressed/sev-es.c
> > +++ b/arch/x86/boot/compressed/sev-es.c
> > @@ -8,12 +8,16 @@
> >  #include <linux/kernel.h>
> >
> >  #include <asm/sev-es.h>
> > +#include <asm/trap_defs.h>
> >  #include <asm/msr-index.h>
> >  #include <asm/ptrace.h>
> >  #include <asm/svm.h>
> >
> >  #include "misc.h"
> >
> > +struct ghcb boot_ghcb_page __aligned(PAGE_SIZE);
> > +struct ghcb *boot_ghcb;
> > +
> >  static inline u64 read_ghcb_msr(void)
> >  {
> >         unsigned long low, high;
> > @@ -35,8 +39,95 @@ static inline void write_ghcb_msr(u64 val)
> >                         "a"(low), "d" (high) : "memory");
> >  }
> >
> > +static enum es_result es_fetch_insn_byte(struct es_em_ctxt *ctxt,
> > +                                        unsigned int offset,
> > +                                        char *buffer)
> > +{
> > +       char *rip = (char *)ctxt->regs->ip;
> > +
> > +       buffer[offset] = rip[offset];
> > +
> > +       return ES_OK;
> > +}
> > +
> > +static enum es_result es_write_mem(struct es_em_ctxt *ctxt,
> > +                                  void *dst, char *buf, size_t size)
> > +{
> > +       memcpy(dst, buf, size);
> > +
> > +       return ES_OK;
> > +}
> > +
> > +static enum es_result es_read_mem(struct es_em_ctxt *ctxt,
> > +                                 void *src, char *buf, size_t size)
> > +{
> > +       memcpy(buf, src, size);
> > +
> > +       return ES_OK;
> > +}
> 
> 
> What are all these abstractions for?

They are needed for the code in arch/x86/kernel/sev-es-shared.c. This
file is used in the pre-decompression boot code and in the running
kernels SEV-ES support.

The running kernel needs these abstraction because it will get #VC
exceptions from user-space and MMIO exits touching user-space addresses.
These functions will implement the necessary security checks.

Regards,

	Joerg
