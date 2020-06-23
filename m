Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419AC205145
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 13:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732579AbgFWLuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 07:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732225AbgFWLuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 07:50:50 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B441CC061573;
        Tue, 23 Jun 2020 04:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aiVkeicD79xrHH2MDVHjdOtjMnN8FcgFYepOS8k0muE=; b=EDvXpjRwRiWz5VfLeVl7JzHg3f
        x4dHtqMUkLsONa0nUGU8wT3Ft9ryJmQ5THUfSCggkT3OzDNJlDqGXdOUBd+TRGH85/sOLi5lDHl9G
        lOV1OE1pxKcRl3T92sVXNqPNFTB7t3KsMUo98+uLsk+SlcUpsCQxejCEMg40knl3T2IkFX2bzXPeZ
        xnJ5wgAWm9Z7m2KkkmdtZJVdJOhzLBBBlYoCOoR3z4BH8prfDBy/FdcOzSpostBvsjevokivifqnF
        V32Tzv5H/+7uSj+u0LdpX8PXd9vugeJH8ciDz2WAGJbRGbYz2FDxDn1Ddqrf8P0/ml1+v+KoOoQKM
        QKuRBYlA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnhRQ-0002Cb-IP; Tue, 23 Jun 2020 11:50:16 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A0F95300F28;
        Tue, 23 Jun 2020 13:50:14 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 860502370F7D2; Tue, 23 Jun 2020 13:50:14 +0200 (CEST)
Date:   Tue, 23 Jun 2020 13:50:14 +0200
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
Message-ID: <20200623115014.GE4817@hirez.programming.kicks-ass.net>
References: <20200425191032.GK21900@8bytes.org>
 <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
 <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200623094519.GF31822@suse.de>
 <20200623104559.GA4817@hirez.programming.kicks-ass.net>
 <20200623111107.GG31822@suse.de>
 <20200623111443.GC4817@hirez.programming.kicks-ass.net>
 <20200623114324.GA14101@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623114324.GA14101@suse.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 01:43:24PM +0200, Joerg Roedel wrote:
> On Tue, Jun 23, 2020 at 01:14:43PM +0200, Peter Zijlstra wrote:
> > On Tue, Jun 23, 2020 at 01:11:07PM +0200, Joerg Roedel wrote:
> 
> > > The v3 patchset implements an unconditional shift of the #VC IST entry
> > > in the NMI handler, before it can trigger a #VC exception.
> > 
> > Going by that other thread -- where you said that any memory access can
> > trigger a #VC, there just isn't such a guarantee.
> 
> As I wrote in the other mail, this can only happen when SNP gets enabled
> (which is follow-on work to this) and is handled by a stack recursion
> check in the #VC handler.
> 
> The reason I mentioned the #VC-anywhere case is to make it more clear
> why #VC needs an IST handler.

If SNP is the sole reason #VC needs to be IST, then I'd strongly urge
you to only make it IST if/when you try and make SNP happen, not before.
