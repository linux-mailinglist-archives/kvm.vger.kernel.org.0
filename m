Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2174C205625
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 17:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733049AbgFWPjO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 11:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732821AbgFWPjN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 11:39:13 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCBDC061573;
        Tue, 23 Jun 2020 08:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MAuMHFTHX8XSOrS+3WRKmxA3YZs5uM2D2sS+hm8j/xA=; b=Q2V8keP0FVZG/TkiTzzDC4vKCj
        nyT6JjEu5SmZ8Er8y26AZbbgkMF9mKPNSmAFN9XQBQQqP4264ILIB06TlmxfjBabBTG6Y2NicjupJ
        BAvy12H7mmAKvaxjdM8ad7SRMIhiRvyFTnekaSC+rwLSzAbCO1mQIsrZv0+9Lhu5j6zkp2Z5mFONc
        80XN5GSP4bOB4TvlyRq0sWNQUFDHDDjo1FOAWItkimokCQlBzt2XZQqjItjtwZfxGzNt7fhwRQnH7
        WH9UsqHANKhP4VJ4ph07S4gcfxEvJIq24QXBhv7MbZI5g9K9eYwub4yRvwGPfCxi9NkA21uyFQjzH
        ocw5FYSg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnl0X-0008BI-L3; Tue, 23 Jun 2020 15:38:45 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8B35730477A;
        Tue, 23 Jun 2020 17:38:44 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 79859234EBA52; Tue, 23 Jun 2020 17:38:44 +0200 (CEST)
Date:   Tue, 23 Jun 2020 17:38:44 +0200
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
Message-ID: <20200623153844.GN4817@hirez.programming.kicks-ass.net>
References: <20200623110706.GB4817@hirez.programming.kicks-ass.net>
 <20200623113007.GH31822@suse.de>
 <20200623114818.GD4817@hirez.programming.kicks-ass.net>
 <20200623120433.GB14101@suse.de>
 <20200623125201.GG4817@hirez.programming.kicks-ass.net>
 <20200623134003.GD14101@suse.de>
 <20200623135916.GI4817@hirez.programming.kicks-ass.net>
 <20200623145344.GA117543@hirez.programming.kicks-ass.net>
 <20200623145914.GF14101@suse.de>
 <20200623152326.GL4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623152326.GL4817@hirez.programming.kicks-ass.net>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 05:23:26PM +0200, Peter Zijlstra wrote:
> On Tue, Jun 23, 2020 at 04:59:14PM +0200, Joerg Roedel wrote:
> > On Tue, Jun 23, 2020 at 04:53:44PM +0200, Peter Zijlstra wrote:
> > > +noinstr void idtentry_validate_ist(struct pt_regs *regs)
> > > +{
> > > +	if ((regs->sp & ~(EXCEPTION_STKSZ-1)) ==
> > > +	    (_RET_IP_ & ~(EXCEPTION_STKSZ-1)))
> > > +		die("IST stack recursion", regs, 0);
> > > +}
> > 
> > Yes, this is a start, it doesn't cover the case where the NMI stack is
> > in-between, so I think you need to walk down regs->sp too.
> 
> That shouldn't be possible with the current code, I think.

To clarify, we have: NMI, MCE, DB and DF.

DF (with the exception of ESPFIX) is fatal.
MCE from kernel is fatal (which is what makes the MCE in NMI 'work')
NMI and DB clear DR7, which avoids DB in NMI.

So that leaves: NMI in DB, and that works.
