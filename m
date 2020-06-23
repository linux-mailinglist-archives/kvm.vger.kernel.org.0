Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A942050AC
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 13:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732332AbgFWLaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 07:30:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:44866 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732191AbgFWLaL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 07:30:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9EE4AAF83;
        Tue, 23 Jun 2020 11:30:09 +0000 (UTC)
Date:   Tue, 23 Jun 2020 13:30:07 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <20200623113007.GH31822@suse.de>
References: <20200425191032.GK21900@8bytes.org>
 <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
 <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200428075512.GP30814@suse.de>
 <20200623110706.GB4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623110706.GB4817@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 01:07:06PM +0200, Peter Zijlstra wrote:
> On Tue, Apr 28, 2020 at 09:55:12AM +0200, Joerg Roedel wrote:

> So what happens if this #VC triggers on the first access to the #VC
> stack, because the malicious host has craftily mucked with only the #VC
> IST stack page?
> 
> Or on the NMI IST stack, then we get #VC in NMI before the NMI can fix
> you up.
> 
> AFAICT all of that is non-recoverable.

I am not 100% sure, but I think if the #VC stack page is not validated,
the #VC should be promoted to a #DF.

Note that this is an issue only with secure nested paging (SNP), which
is not enabled yet with this patch-set. When it gets enabled a stack
recursion check in the #VC handler is needed which panics the VM. That
also fixes the #VC-in-early-NMI problem.

Regards,

	Joerg
