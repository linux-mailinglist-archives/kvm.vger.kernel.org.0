Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630452559DA
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 14:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbgH1MMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 08:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729123AbgH1MMd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 08:12:33 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212F6C061264;
        Fri, 28 Aug 2020 05:12:31 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 45AC82E1; Fri, 28 Aug 2020 14:12:29 +0200 (CEST)
Date:   Fri, 28 Aug 2020 14:12:26 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Arvind Sankar <nivedita@alum.mit.edu>
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
Subject: Re: [PATCH v6 13/76] x86/boot/compressed/64: Add IDT Infrastructure
Message-ID: <20200828121226.GC13881@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-14-joro@8bytes.org>
 <20200827152657.GA669574@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200827152657.GA669574@rani.riverdale.lan>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Arvind,

On Thu, Aug 27, 2020 at 11:26:57AM -0400, Arvind Sankar wrote:
> On Mon, Aug 24, 2020 at 10:54:08AM +0200, Joerg Roedel wrote:
> > +	pushq	%rsi
> > +	call	load_stage1_idt
> > +	popq	%rsi
> > +
> 
> Do we need the functions later in the series or could this just use lidt
> directly?

The function also sets up the actual IDT entries in the table before
doing the lidt, so this needs to be a call to a C function. Setting up
IDT entries in assembly does not result in readable code.

> Is there any risk of exceptions getting triggered during the move of the
> compressed kernel, before the stage2 reload?

No, that would be a bug in either the UEFI BIOS or in the boot code.
When the kernel image is moved to the end of the decompression buffer it
still runs on the EFI page-table.

With the changes in this patch-set there will be page-faults when the
kernel is actually decompressed. But that happens after the stage2-idt
is loaded.

> > +SYM_DATA_START(boot_idt_desc)
> > +	.word	boot_idt_end - boot_idt
> 
> I think this should be boot_idt_end - boot_idt - 1, right?
>   The limit value is expressed in bytes and is added to the base address
>   to get the address of the last valid byte. A limit value of 0 results
>   in exactly 1 valid byte. Because IDT entries are always eight bytes
>   long, the limit should always be one less than an integral multiple of
>   eight (that is, 8N – 1).

You are right, I will fix that, thanks.

Regards,

	Joerg
