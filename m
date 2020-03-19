Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF03618C03E
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 20:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgCST07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 15:26:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:47832 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgCST07 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 15:26:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B4686AD03;
        Thu, 19 Mar 2020 19:26:56 +0000 (UTC)
Date:   Thu, 19 Mar 2020 20:26:54 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 70/70] x86/sev-es: Add NMI state tracking
Message-ID: <20200319192654.GD611@suse.de>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-71-joro@8bytes.org>
 <CALCETrUOQneBHjoZkP-7T5PDijb=WOyv7xF7TD0GLR2Aw77vyA@mail.gmail.com>
 <20200319160749.GC5122@8bytes.org>
 <CALCETrXY5M87C1Fc3QvTkc6MdbQ_3gAuOPUeWJktAzK4T60QNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXY5M87C1Fc3QvTkc6MdbQ_3gAuOPUeWJktAzK4T60QNQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 11:40:39AM -0700, Andy Lutomirski wrote:
 
> Nope.  A nested NMI will reset the interrupted NMI's return frame to
> cause it to run again when it's done.  I don't think this will have
> any real interaction with #VC.  There's no longjmp() here.

Ahh, so I misunderstood that part, in this case your proposal of sending
the NMI-complete message right at the beginning of do_nmi() should work
just fine. I will test this and see how it works out.

> I certainly *like* preventing nesting, but I don't think we really
> want a whole alternate NMI path just for a couple of messed-up AMD
> generations.  And the TF trick is not so pretty either.

Indeed, if it could be avoided, it should.

> 
> > > This causes us to pop the NMI frame off the stack.  Assuming the NMI
> > > restart logic is invoked (which is maybe impossible?), we get #DB,
> > > which presumably is actually delivered.  And we end up on the #DB
> > > stack, which might already have been in use, so we have a potential
> > > increase in nesting.  Also, #DB may be called from an unexpected
> > > context.
> >
> > An SEV-ES hypervisor is required to intercept #DB, which means that the
> > #DB exception actually ends up being a #VC exception. So it will not end
> > up on the #DB stack.
> 
> With your patch set, #DB doesn't seem to end up on the #DB stack either.

Right, it does not use the #DB stack or shift-ist stuff. Maybe it
should, is this needed for anything else than making entry code
debugable by kgdb?

Regards,

	Joerg
