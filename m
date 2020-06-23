Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D43205130
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 13:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732552AbgFWLsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 07:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732393AbgFWLsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 07:48:52 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E567C061573;
        Tue, 23 Jun 2020 04:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jDPd8VkI8efCBcrOsnIHTnPuv2t1otNb8V/eq4wKFwo=; b=YZPRv33A9sygKFDGs9Y3X0oRsV
        vmYCaQC9/Kvjb6UQCZbskfYgSjkfL5ugrXGLpOXC+8OUdEV+XucaC3EHCUJ3BFUItgxiMgd+WaYso
        n10PDALn2CiVFgXkQ29oaZeXF9QqcC2ueTT/fPIitlLBsf8EITO9OTrIZgnx8koACzNASxCLk2aF5
        4agvl2fBbWKp/npms27JBSbSUpCEqLE5XhWYsGO+7kTvz2VB/3Tvgf8Rr7K+0gggkPNlkxmiw8AOf
        F05IE/gKqYYe62LnniblDoyzqm0phobGbKZNM3Fp09sWJxuJXMf2asDF2J7Dq/Zdvof8nFPNflCJ+
        ievLNt7g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnhPY-00082L-3n; Tue, 23 Jun 2020 11:48:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E2E77303DA0;
        Tue, 23 Jun 2020 13:48:18 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D65CB2370FA3D; Tue, 23 Jun 2020 13:48:18 +0200 (CEST)
Date:   Tue, 23 Jun 2020 13:48:18 +0200
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
Message-ID: <20200623114818.GD4817@hirez.programming.kicks-ass.net>
References: <20200425191032.GK21900@8bytes.org>
 <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
 <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200428075512.GP30814@suse.de>
 <20200623110706.GB4817@hirez.programming.kicks-ass.net>
 <20200623113007.GH31822@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623113007.GH31822@suse.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 01:30:07PM +0200, Joerg Roedel wrote:
> Note that this is an issue only with secure nested paging (SNP), which
> is not enabled yet with this patch-set. When it gets enabled a stack
> recursion check in the #VC handler is needed which panics the VM. That
> also fixes the #VC-in-early-NMI problem.

But you cannot do a recursion check in #VC, because the NMI can happen
on the first instruction of #VC, before we can increment our counter,
and then the #VC can happen on NMI because the IST stack is a goner, and
we're fscked again (or on a per-cpu variable we touch in our elaborate
NMI setup, etc..).

There is no way I can see SNP-#VC 'work'. The best I can come up with is
'mostly', but do you like your bridges/dikes/etc.. to be mostly ok? Or
do you want a guarantee they'll actually work?

I'll keep repeating this, x86_64 exceptions are a trainwreck, and IST in
specific is utter crap.
