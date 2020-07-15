Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EC5221270
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 18:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgGOQev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 12:34:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:42622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbgGOQev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 12:34:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 89EA3AF83;
        Wed, 15 Jul 2020 16:34:52 +0000 (UTC)
Date:   Wed, 15 Jul 2020 18:34:47 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Kees Cook <keescook@chromium.org>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 34/75] x86/head/64: Build k/head64.c with
 -fno-stack-protector
Message-ID: <20200715163446.GB24822@suse.de>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-35-joro@8bytes.org>
 <202007141831.F3165F22@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202007141831.F3165F22@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 14, 2020 at 06:34:24PM -0700, Kees Cook wrote:
> On Tue, Jul 14, 2020 at 02:08:36PM +0200, Joerg Roedel wrote:
> > +# make sure head64.c is built without stack protector
> > +nostackp := $(call cc-option, -fno-stack-protector)
> > +CFLAGS_head64.o		:= $(nostackp)
> 
> Recent refactoring[1] for stack protector suggests this should just
> unconditionally be:
> 
> CFLAGS_head64.o			+= -fno-stack-protector
> 
> But otherwise, yeah, this should be fine here -- it's all early init
> stuff.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks, I am not sure this patch will be needed in the next version, as
I am currently rebasing to tip/master, which also made idt_descr static
in kernel/idt.c.

So with that I think I have to move the early IDT init functions to
kernel/idt.c too and setup %gs earlier in head_64.S to make
stack-protector happy.

The %gs setup actually needs to happen two times, one time when the
kernel still runs identity mapped and then again when it switched to
virtual addresses.

Regards,

	Joerg
