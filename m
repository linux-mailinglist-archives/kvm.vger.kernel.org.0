Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7AE2055A0
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 17:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732928AbgFWPQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 11:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732781AbgFWPQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 11:16:42 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE227C061755;
        Tue, 23 Jun 2020 08:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Id637uzu2oPJgbSFSrub5lvl6io8BJJDeJLsBbUH3no=; b=bi0ePU5G654k+t0TAm058MHXSd
        lCqyZOcX6Qodx8rJdBmSj5AAhpyDPz+bOg/LKlMIsTlUsu+PJHSPm5Mwmerm0dt8rhY73XDELOD7f
        d8s7S6cD8f5p7SHCUnRySBYP5y+C7I9jt3OS5qDNJ8bdyBie87xD3Iko98kPmp41cLlhSCJthd8St
        GOevS0VrCJIo1gPBKZjIRzYTt4Wv8PU24Svlrfeq2keb1a0vIWIZVi9UtKG2v/QFkvFUXhhY8oui/
        gNdfuq+INIKSQfVl6/C4GkEz+FrA9nGYvpJCcXM3WTqlwZYpOK0SiaYA2a5rM96hUuvkJikGeEmV4
        0Hksg6bQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnkeg-0001Bn-C8; Tue, 23 Jun 2020 15:16:10 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9979230477A;
        Tue, 23 Jun 2020 17:16:07 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8DE24234EBA61; Tue, 23 Jun 2020 17:16:07 +0200 (CEST)
Date:   Tue, 23 Jun 2020 17:16:07 +0200
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
Message-ID: <20200623151607.GJ4817@hirez.programming.kicks-ass.net>
References: <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200623094519.GF31822@suse.de>
 <20200623104559.GA4817@hirez.programming.kicks-ass.net>
 <20200623111107.GG31822@suse.de>
 <20200623111443.GC4817@hirez.programming.kicks-ass.net>
 <20200623114324.GA14101@suse.de>
 <20200623115014.GE4817@hirez.programming.kicks-ass.net>
 <20200623121237.GC14101@suse.de>
 <20200623130322.GH4817@hirez.programming.kicks-ass.net>
 <20200623144940.GE14101@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623144940.GE14101@suse.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 04:49:40PM +0200, Joerg Roedel wrote:
> > We're talking about the 3rd case where the only reason things 'work' is
> > because we'll have to panic():
> > 
> >  - #MC
> 
> Okay, #MC is special and can only be handled on a best-effort basis, as
> #MC could happen anytime, also while already executing the #MC handler.

I think the hardware has a MCE-mask bit somewhere. Flaky though because
clearing it isn't 'atomic' with IRET, so there's a 'funny' window.

It also interacts really bad with the NMI handler. If we get an #MC
early in the NMI, where we hard-rely on the NMI-mask being set to set-up
the recursion stack, then the #MC IRET will clear the NMI-mask, and
we're toast.

Andy has wild and crazy ideas, but I don't think we need more crazy
here.

#VC SNP has a similar problem vs NMI, that needs to die() irrespective
of the #VC IST recursion.

> >  - #DB with BUS LOCK DEBUG EXCEPTION
> 
> If I understand the problem correctly, this can be solved by moving off
> the IST stack to the current task stack in the #DB handler, like I plan
> to do for #VC, no?

Hmm, probably. Would take a bit of care, but should be doable.

> >  - #VC SNP
> 
> This has to panic for other reasons that can't be worked around. It
> boils down to detecting that the HV is doing something fishy and bail
> out to avoid further harm (like in the #MC handler).

Right, but it doesn't take away that IST-any-time vectors are
fundamentally screwy.

Both the MCE and NMI have masks that are, as per the above, differently
funny, but the other ISTs do not. Also, even if they had masks, the
interaction between them is still screwy.

#VC would've been so much better if it would've had a mask bit
somewhere, then at least we could've had the exception entry covered.
Another #VC with the mask set should probably result in #DF or Shutdown,
but that's all water under the bridge I suspect.



