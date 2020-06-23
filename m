Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373542056B7
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 18:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733007AbgFWQCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 12:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731723AbgFWQCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 12:02:41 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CFFC061573;
        Tue, 23 Jun 2020 09:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=inEENWPOzGzfsRSt470zS1Lo3/U6Y1WgM8bPuF0BE3s=; b=vklOthUx90OknmglN/7t1NkgIU
        79j+4BcR4TJlT6iVzTfl5fAzvw8vz6lmSM2iod8IG5T98bck5m/zrnJA5eoC9p9/WZOoBkl8UX9cs
        DCzlQrHW8ITqu9LbaQFujnXWFILM8OFw7X/Ss1id9S84yal9wiD/3Ixl9boAyaORr3j9v8qFA+nN9
        0ypvnZ+iJRvDZImoDygYw1SfKurZMzMTFtI7D11hXqDjhzvoGWbs1/jHW50SEU007OH3xepHIh8HI
        ecYAdfH3gwNp/D7FqX01M/3UVAgGjLytHd3q93sLHONiDntvqXvyCvG+EWmhHdYlcMwJd7jhGIEx6
        Jk/2RsgQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnlNJ-0003gH-8n; Tue, 23 Jun 2020 16:02:17 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 77B34300F28;
        Tue, 23 Jun 2020 18:02:15 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 652D6234EBA53; Tue, 23 Jun 2020 18:02:15 +0200 (CEST)
Date:   Tue, 23 Jun 2020 18:02:15 +0200
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
Message-ID: <20200623160215.GP4817@hirez.programming.kicks-ass.net>
References: <20200623113007.GH31822@suse.de>
 <20200623114818.GD4817@hirez.programming.kicks-ass.net>
 <20200623120433.GB14101@suse.de>
 <20200623125201.GG4817@hirez.programming.kicks-ass.net>
 <20200623134003.GD14101@suse.de>
 <20200623135916.GI4817@hirez.programming.kicks-ass.net>
 <20200623145344.GA117543@hirez.programming.kicks-ass.net>
 <20200623145914.GF14101@suse.de>
 <20200623152326.GL4817@hirez.programming.kicks-ass.net>
 <20200623153855.GM14101@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623153855.GM14101@suse.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 05:38:55PM +0200, Joerg Roedel wrote:
> On Tue, Jun 23, 2020 at 05:23:26PM +0200, Peter Zijlstra wrote:

> > Reliability of that depends on the unwinder, I wouldn't want the guess
> > uwinder to OOPS me by accident.
> 
> It doesn't use the full unwinder, it just assumes that there is a
> pt_regs struct at the top of every kernel stack and walks through them
> until SP points to a user-space stack.
> 
> As long as the assumption that there is a pt_regs struct on top of every
> stack holds, this should be safe. The assumption might be wrong when an
> exception happens during SYSCALL/SYSENTER entry, when the return frame
> is not written by hardware.

The IRQ and SoftIRQ stacks don't have that I think. Only the task and
exception stacks.
