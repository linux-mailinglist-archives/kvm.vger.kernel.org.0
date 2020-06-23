Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45743205551
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 16:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732945AbgFWO7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 10:59:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:44396 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732738AbgFWO7S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 10:59:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5C1D4ADC9;
        Tue, 23 Jun 2020 14:59:16 +0000 (UTC)
Date:   Tue, 23 Jun 2020 16:59:14 +0200
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
Message-ID: <20200623145914.GF14101@suse.de>
References: <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200428075512.GP30814@suse.de>
 <20200623110706.GB4817@hirez.programming.kicks-ass.net>
 <20200623113007.GH31822@suse.de>
 <20200623114818.GD4817@hirez.programming.kicks-ass.net>
 <20200623120433.GB14101@suse.de>
 <20200623125201.GG4817@hirez.programming.kicks-ass.net>
 <20200623134003.GD14101@suse.de>
 <20200623135916.GI4817@hirez.programming.kicks-ass.net>
 <20200623145344.GA117543@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623145344.GA117543@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 04:53:44PM +0200, Peter Zijlstra wrote:
> +noinstr void idtentry_validate_ist(struct pt_regs *regs)
> +{
> +	if ((regs->sp & ~(EXCEPTION_STKSZ-1)) ==
> +	    (_RET_IP_ & ~(EXCEPTION_STKSZ-1)))
> +		die("IST stack recursion", regs, 0);
> +}

Yes, this is a start, it doesn't cover the case where the NMI stack is
in-between, so I think you need to walk down regs->sp too. The dumpstack
code already has some logic for this.


	Joerg

