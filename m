Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266A7205658
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 17:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733036AbgFWPwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 11:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732942AbgFWPwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 11:52:35 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4804BC061573;
        Tue, 23 Jun 2020 08:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=V+I5M6T0vX0U3AsFDgchL+f1L6gn7BSv3aERPVrjnPY=; b=P+jdsz0ucfshSY+SPQ8CRHAJD+
        x4g4UkTqpdDwyLW7IHndErlpvnUEKSuBos0fi391zScfBZg4cN3Tj56VCg4zTawV5zzyskojPa2Ns
        70wOMACbqtQ9ryX6O0y7oKh9zeN9KjCY0Ub914IGNKVUaC+FMR7ZXF+PAlT+Fwbre1YSz+Bb5Cw1e
        kOddoPFwBkU7dqyg0y8k0Oo4m/QPWh+rK3TG9b+jLQt4W6zcbukO7JWa0QB/SH1iYn/GP3FlmQmt6
        Wq3nNq/PmV/3mUlKi5YRLVU3pI5DK8KiKa0eVG8IPKGe3gsc21N+y/wnvkRZnTqpp9StJibYoU2Sd
        8cWEhqJg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnlDS-0001Ra-Ti; Tue, 23 Jun 2020 15:52:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id F0C27306E5C;
        Tue, 23 Jun 2020 17:52:04 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DF0EA234EBA5D; Tue, 23 Jun 2020 17:52:04 +0200 (CEST)
Date:   Tue, 23 Jun 2020 17:52:04 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Joerg Roedel <jroedel@suse.de>, Andy Lutomirski <luto@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
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
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: Should SEV-ES #VC use IST? (Re: [PATCH] Allow RDTSC and RDTSCP
 from userspace)
Message-ID: <20200623155204.GO4817@hirez.programming.kicks-ass.net>
References: <20200623113007.GH31822@suse.de>
 <20200623114818.GD4817@hirez.programming.kicks-ass.net>
 <20200623120433.GB14101@suse.de>
 <20200623125201.GG4817@hirez.programming.kicks-ass.net>
 <20200623134003.GD14101@suse.de>
 <20200623135916.GI4817@hirez.programming.kicks-ass.net>
 <20200623145344.GA117543@hirez.programming.kicks-ass.net>
 <20200623145914.GF14101@suse.de>
 <20200623152326.GL4817@hirez.programming.kicks-ass.net>
 <56af2f70-a1c6-aa64-006e-23f2f3880887@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56af2f70-a1c6-aa64-006e-23f2f3880887@citrix.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 04:39:26PM +0100, Andrew Cooper wrote:
> On 23/06/2020 16:23, Peter Zijlstra wrote:
> > On Tue, Jun 23, 2020 at 04:59:14PM +0200, Joerg Roedel wrote:

> >> Yes, this is a start, it doesn't cover the case where the NMI stack is
> >> in-between, so I think you need to walk down regs->sp too.
> > That shouldn't be possible with the current code, I think.
> 
> NMI; #MC; Anything which IRET but isn't fatal - #DB, or #BP from
> patching, #GP from *_safe(), etc; NMI
> 
> Sure its a corner case, but did you hear that IST is evil?

Isn't current #MC unconditionally fatal from kernel? But yes, I was
sorta aware people want that changed.

And yes, NMI can recurse, mostly on #BP and #PF. Like I wrote, its
broken vs #MC.

But Joerg was talking about IST recursion with NMI in the middle,
something like: #DB, NMI, #DB, and not already being fatal. This one in
particular is ruled out by #DB itself clearing DR7 (but NMI would also
do that).

> P.S. did you also hear that with Rowhammer, userspace has a nonzero
> quantity of control over generating #MC, depending on how ECC is
> configured on the platform.

Yes, excellent stuff.
