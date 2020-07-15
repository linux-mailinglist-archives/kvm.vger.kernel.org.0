Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E7822099E
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 12:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731040AbgGOKN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 06:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgGOKN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 06:13:26 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9C4C061755;
        Wed, 15 Jul 2020 03:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NxRs2Pm10c75mSdn1nbWIbzhX1JLNphOAFM5Lj4SR3I=; b=GROMyPHHWeTIOf3KDPDXNwa4WK
        R6jB4NQoMOAmc/Ypqc5rNl5Pduyjwh6S6W5xtWeB1GvVcDG7gBVHNrsHI07Fy10HjeGU1EqyxF+zI
        Z7L8hPzKZoU1b0QWe8WkKpAy6ZfvYtqAf3DyUQwQPZqm0uv9A1SGMWyXDeF+QNrUhxAIsFPw2Nh+o
        twcqqDM+ZmirX0VPrZzGJTUIikrkFR5aXJhLf+TIO5WLrmwYLK9BYjp6ehD9m9nQYLbJ7fVTwaBPo
        LRP06aNFPZzCjjGDsXB3PxXSBpJlBf7zUkc1XFb/bPNX44372SwUAz23oKL7tU2iPuwqYL2T/e7xC
        6T8FRkrA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvePY-0005R7-KE; Wed, 15 Jul 2020 10:13:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E910B300130;
        Wed, 15 Jul 2020 12:13:10 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D474020D27C63; Wed, 15 Jul 2020 12:13:10 +0200 (CEST)
Date:   Wed, 15 Jul 2020 12:13:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v4 63/75] x86/sev-es: Handle #DB Events
Message-ID: <20200715101310.GJ10769@hirez.programming.kicks-ass.net>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-64-joro@8bytes.org>
 <20200715084752.GD10769@hirez.programming.kicks-ass.net>
 <20200715091337.GI16200@suse.de>
 <20200715095136.GG10769@hirez.programming.kicks-ass.net>
 <20200715100808.GL16200@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715100808.GL16200@suse.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 15, 2020 at 12:08:08PM +0200, Joerg Roedel wrote:
> On Wed, Jul 15, 2020 at 11:51:36AM +0200, Peter Zijlstra wrote:
> > On Wed, Jul 15, 2020 at 11:13:37AM +0200, Joerg Roedel wrote:
> > > Then my understanding of intrumentation_begin/end() is wrong, I thought
> > > that the kernel will forbid setting breakpoints before
> > > instrumentation_begin(), which is necessary here because a break-point
> > > in the #VC handler might cause recursive #VC-exceptions when #DB is
> > > intercepted.
> > > Maybe you can elaborate on why this makes no sense?
> > 
> > Kernel avoids breakpoints in any noinstr text, irrespective of
> > instrumentation_begin().
> > 
> > instrumentation_begin() merely allows one to call !noinstr functions.
> 
> Right, but the handler calls into various other functions. I actually
> started to annotate them all with noinstr, but that was a can of worms
> when calling into generic kernel functions. And the only problem with
> intrumentation in the #VC handler is the #VC-for-#DB exit-code, so I
> decided to only handle this one with instrumentation forbidden and allow
> it for the rest of the handler.

OK, then maybe change the comment to something like:

 /*
  * Handle #DB before calling any !noinstr code to avoid
  * recursive #DB.
  */

?
