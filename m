Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4861A2055BF
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 17:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732969AbgFWPXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 11:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732781AbgFWPXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 11:23:54 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA48AC061573;
        Tue, 23 Jun 2020 08:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=67GmQHoj5zNuUwz09OSjiIC4O8VKYFdYpYZwr4wExTc=; b=HKSxQszno971bP/TsveUX1OfYN
        w+iddIX3Sb92BzDuh9mM+TMd424oct3epZCyddn8xYMXBq2wYT92dhpKJLqXjKVgS3b3qyGyC7HE1
        jdNWFF+LsxwRamTTgoCMYmptuxP9dIkgdc/piRBGfC0z2EXgQMlfYqjVz6SF9uCFAa+PNY0Q7pUpD
        y8qIHKn8jwZGsl/4ZFkT95KFdxCd8HuPbP+IODLDl0y6amInT0EYw1+XAoCGUScP3zwAF8GJHOsTG
        H4vzhX9bOmnERkNENcGq2LrO6Sv/s7921BB80kd93Wfg931RZpLLOKf5q/hf20joXKq/9UM9Q4ebC
        2UsjCpJg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnklk-00037n-BU; Tue, 23 Jun 2020 15:23:28 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id AC38A303DA0;
        Tue, 23 Jun 2020 17:23:26 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9AB3C234EBA53; Tue, 23 Jun 2020 17:23:26 +0200 (CEST)
Date:   Tue, 23 Jun 2020 17:23:26 +0200
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
Message-ID: <20200623152326.GL4817@hirez.programming.kicks-ass.net>
References: <20200428075512.GP30814@suse.de>
 <20200623110706.GB4817@hirez.programming.kicks-ass.net>
 <20200623113007.GH31822@suse.de>
 <20200623114818.GD4817@hirez.programming.kicks-ass.net>
 <20200623120433.GB14101@suse.de>
 <20200623125201.GG4817@hirez.programming.kicks-ass.net>
 <20200623134003.GD14101@suse.de>
 <20200623135916.GI4817@hirez.programming.kicks-ass.net>
 <20200623145344.GA117543@hirez.programming.kicks-ass.net>
 <20200623145914.GF14101@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623145914.GF14101@suse.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 04:59:14PM +0200, Joerg Roedel wrote:
> On Tue, Jun 23, 2020 at 04:53:44PM +0200, Peter Zijlstra wrote:
> > +noinstr void idtentry_validate_ist(struct pt_regs *regs)
> > +{
> > +	if ((regs->sp & ~(EXCEPTION_STKSZ-1)) ==
> > +	    (_RET_IP_ & ~(EXCEPTION_STKSZ-1)))
> > +		die("IST stack recursion", regs, 0);
> > +}
> 
> Yes, this is a start, it doesn't cover the case where the NMI stack is
> in-between, so I think you need to walk down regs->sp too.

That shouldn't be possible with the current code, I think.

> The dumpstack code already has some logic for this.

Reliability of that depends on the unwinder, I wouldn't want the guess
uwinder to OOPS me by accident.
