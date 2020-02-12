Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD6D15AA7B
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 14:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgBLNyt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 08:54:49 -0500
Received: from 8bytes.org ([81.169.241.247]:53890 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgBLNyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 08:54:49 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id E433020E; Wed, 12 Feb 2020 14:54:47 +0100 (CET)
Date:   Wed, 12 Feb 2020 14:54:36 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [RFC PATCH 00/62] Linux as SEV-ES Guest Support
Message-ID: <20200212135436.GJ20066@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
 <20200211145008.GT14914@hirez.programming.kicks-ass.net>
 <20200211154321.GB22063@8bytes.org>
 <CALCETrUtvd0OuLoo=ZBRmaJRFxgFWV9hSZyHBwmWCs2+b4J-sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUtvd0OuLoo=ZBRmaJRFxgFWV9hSZyHBwmWCs2+b4J-sg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 02:12:04PM -0800, Andy Lutomirski wrote:
> On Tue, Feb 11, 2020 at 7:43 AM Joerg Roedel <joro@8bytes.org> wrote:
> >
> > On Tue, Feb 11, 2020 at 03:50:08PM +0100, Peter Zijlstra wrote:
> >
> > > Oh gawd; so instead of improving the whole NMI situation, AMD went and
> > > made it worse still ?!?
> >
> > Well, depends on how you want to see it. Under SEV-ES an IRET will not
> > re-open the NMI window, but the guest has to tell the hypervisor
> > explicitly when it is ready to receive new NMIs via the NMI_COMPLETE
> > message.  NMIs stay blocked even when an exception happens in the
> > handler, so this could also be seen as a (slight) improvement.
> >
> 
> I don't get it.  VT-x has a VMCS bit "Interruptibility
> state"."Blocking by NMI" that tracks the NMI masking state.  Would it
> have killed AMD to solve the problem they same way to retain
> architectural behavior inside a SEV-ES VM?

No, but it wouldn't solve the problem. Inside an NMI handler there could
be #VC exceptions, which do an IRET on their own. Hardware NMI state
tracking would re-enable NMIs when the #VC exception returns to the NMI
handler, which is not what every OS is comfortable with.

Yes, there are many ways to hack around this. The GHCB spec mentions the
single-stepping-over-IRET idea, which I also prototyped in a previous
version of this patch-set. I gave up on it when I discovered that NMIs
that happen when executing in kernel-mode but on entry stack will cause
the #VC handler to call into C code while on entry stack, because
neither paranoid_entry nor error_entry handle the
from-kernel-with-entry-strack case. This could of course also be fixed,
but further complicates things already complicated enough by the PTI
changes and nested-NMI support.

My patch for using the NMI_COMPLETE message is certainly not perfect and
needs changes, but having the message specified in the protocol gives
the guest the best flexibility in deciding when it is ready to receive
new NMIs, imho.

Regards,

	Joerg
