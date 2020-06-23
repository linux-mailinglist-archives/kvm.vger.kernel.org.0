Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DD1205407
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 16:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732730AbgFWN7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 09:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732687AbgFWN7x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 09:59:53 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68041C061573;
        Tue, 23 Jun 2020 06:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vWFZnmE8muSdoNv/rlN/zg+D4ErnvxS0/K6mx8ubUo4=; b=QQqHr4IslmzJW09bxhv1Ibqy14
        exvYtd4xNdVggaYQ7J+3Ux3ltaf/4zgfPk5nlZA57lRVghngQDw3jFFH1qd4JvYdxS7Gzuffi/EXa
        pJCr6X0+J6sOE4R312V3eYLvvquor1WCpbl3LiqTvvZdXDG5QgUdiRucg2Mg1GfrE0aqshfm7iISX
        4vueqvSBN9VUfaOsOehNU2M6fjlHD+xQrwa7GWTRoizDBchrv0ovCNNMo+E0mT0CThS8FbkY+19V5
        PlUbml1JCC4gS4MGCLinM5pdDFLQRUkizCTYkXF/HLVQpJDKZXWrZLBOsC944fXDC+vkIXa/9RrRU
        GcD0Wmtw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnjSI-0004Rt-F5; Tue, 23 Jun 2020 13:59:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 73420300F28;
        Tue, 23 Jun 2020 15:59:16 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6467323CBF701; Tue, 23 Jun 2020 15:59:16 +0200 (CEST)
Date:   Tue, 23 Jun 2020 15:59:16 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Andy Lutomirski <luto@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Mike Stunes <mstunes@vmware.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <JGross@suse.com>,
        Jiri Slaby <jslaby@suse.cz>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: Should SEV-ES #VC use IST? (Re: [PATCH] Allow RDTSC and RDTSCP
 from userspace)
Message-ID: <20200623135916.GI4817@hirez.programming.kicks-ass.net>
References: <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200428075512.GP30814@suse.de>
 <20200623110706.GB4817@hirez.programming.kicks-ass.net>
 <20200623113007.GH31822@suse.de>
 <20200623114818.GD4817@hirez.programming.kicks-ass.net>
 <20200623120433.GB14101@suse.de>
 <20200623125201.GG4817@hirez.programming.kicks-ass.net>
 <20200623134003.GD14101@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623134003.GD14101@suse.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 03:40:03PM +0200, Joerg Roedel wrote:
> On Tue, Jun 23, 2020 at 02:52:01PM +0200, Peter Zijlstra wrote:

> > You only have that guarantee when any SNP #VC from kernel is an
> > automatic panic. But in that case, what's the point of having the
> > recursion count?
> 
> It is not a recursion count, it is a stack-recursion check. Basically
> walk down the stack and look if your current stack is already in use.
> Yes, this can be optimized, but that is what is needed.
> 
> IIRC the current prototype code for SNP just pre-validates all memory in
> the VM and doesn't support moving pages around on the host. So any #VC
> SNP exception would be fatal, yes.
> 
> In a scenario with on-demand validation of guest pages and support for
> guest-assisted page-moving on the HV side it would be more complicated.
> Basically all memory that is accessed during #VC exception handling must
> stay validated at all times, including the IST stack.
> 
> So saying this, I don't understand why _all_ SNP #VC exceptions from
> kernel space must be fatal?

Ah, because I hadn't thought of the stack-recursion check.

So basically when your exception frame points to your own IST, you die.
That sounds like something we should have in generic IST code.
