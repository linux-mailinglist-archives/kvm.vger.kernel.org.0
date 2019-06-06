Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795723753E
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 15:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfFFNbp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 09:31:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfFFNbo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 09:31:44 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D7BA7B2DE8;
        Thu,  6 Jun 2019 13:31:43 +0000 (UTC)
Received: from work-vm (ovpn-116-119.ams2.redhat.com [10.36.116.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CF2C8473C3;
        Thu,  6 Jun 2019 13:31:41 +0000 (UTC)
Date:   Thu, 6 Jun 2019 14:31:39 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: QEMU/KVM migration backwards compatibility broken?
Message-ID: <20190606133138.GM2788@work-vm>
References: <38B8F53B-F993-45C3-9A82-796A0D4A55EC@oracle.com>
 <20190606084222.GA2788@work-vm>
 <862DD946-EB3C-405A-BE88-4B22E0B9709C@oracle.com>
 <20190606092358.GE2788@work-vm>
 <8F3FD038-12DB-44BC-A262-3F1B55079753@oracle.com>
 <20190606103958.GJ2788@work-vm>
 <B7A9A778-9BD5-449E-A8F3-5D8E3471F4A6@oracle.com>
 <20190606110737.GK2788@work-vm>
 <3F6B41CD-C7E2-4A61-875C-F61AE45F2A58@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3F6B41CD-C7E2-4A61-875C-F61AE45F2A58@oracle.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 06 Jun 2019 13:31:43 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Liran Alon (liran.alon@oracle.com) wrote:
> 
> 
> > On 6 Jun 2019, at 14:07, Dr. David Alan Gilbert <dgilbert@redhat.com> wrote:

<snip>

> > It's tricky; for distro-based users, hitting 'update' and getting both
> > makes a lot of sense; but as you say you ened to let them do stuff
> > individually if they want to, so they can track down problems.
> > There's also a newer problem which is people want to run the QEMU in
> > containers on hosts that have separate update schedules - the kernel
> > version relationship is then much more fluid.
> > 
> >> Compiling all above very useful discussion (thanks for this!), I may have a better suggestion that doesn’t require any additional flags:
> >> 1) Source QEMU will always send all all VMState subsections that is deemed by source QEMU as required to not break guest semantic behaviour.
> >> This is done by .needed() methods that examine guest runtime state to understand if this state is required to be sent or not.
> > 
> > So that's as we already do.
> 
> Besides the fact that today we also expect to add a flag tied to machine-type for every new VMState subsection we add that didn’t exist on previous QEMU versions...
> 
> > 
> >> 2) Destination QEMU will provide a generic QMP command which allows to set names of VMState subsections that if accepted on migration stream
> >> and failed to be loaded (because either subsection name is not implemented or because .post_load() method failed) then the failure should be ignored
> >> and migration should continue as usual. By default, the list of this names will be empty.
> > 
> > The format of the migration stream means that you can't skip an unknown
> > subsection; it's not possible to resume parsing the stream without
> > knowing what was supposed to be there. [This is pretty awful
> > but my last attempts to rework it hit a dead end]
> 
> Wow… That is indeed pretty awful.
> I thought every VMState subsection have a header with a length field… :(

No, no length - it's just a header saying it's a subsection with the
name, then just unformatted data (that had better match what you
expect!).

> Why did your last attempts to add such a length field to migration stream protocol failed?

There's a lot of stuff that's open coded rather than going through
VMState's, so you don't know how much data they'll end up generating.
So the only way to do that is to write to a buffer and then get the
length and dump the buffer.  Actually all that's rare in subsections
but does happen elsewhere.  I got some of some of those nasty cases
but I got stuck trying to get rid of some of the other opencoding
(and still keep it compatible).

> > 
> > So we still need to tie subsections to machine types; that way
> > you don't send them to old qemu's and there for you don't have the
> > problem of the qemu receiving something it doesn't know.
> 
> I agree that if there is no way to skip a VMState subsection in the stream, then we must
> have a way to specify to source QEMU to prevent sending this subsection to destination…
> 
> I would suggest though that instead of having a flag tied to machine-type, we will have a QMP command
> that can specify names of subsections we explicitly wish to be skipped sending to destination even if their .needed() method returns true.

I don't like the thought of generically going behind the devices back;
it's pretty rare to have to do this, so adding a qmp command to tweak
properties that we've already got seems to make more sense to me.

> This seems like a more explicit approach and doesn’t come with the down-side of forever not migrating this VMState subsection
Dave

> for the entire lifetime of guest.
> 
> > 
> > Still, you could skip things where the destination kernel doesn't know
> > about it.
> > 
> >> 3) Destination QEMU will implement .post_load() method for all these VMState subsections that depend on kernel capability to be restored properly
> >> such that it will fail subsection load in case kernel capability is not present. (Note that this load failure will be ignored if subsection name is specified in (2)).
> >> 
> >> Above suggestion have the following properties:
> >> 1) Doesn’t require any flag to be added to QEMU.
> > 
> > There's no logical difference between 'flags' and 'names of subsections'
> > - they're got the same problem in someone somewhere knowing which are
> >  safe.
> 
> I agree. But creating additional flags does come with a development and testing overhead and makes code less intuitive.
> I would have prefer to use subsection names.
> 
> > 
> >> 2) Moves all control on whether to fail migration because of failure to load VMState subsection to receiver side. Sender always attempts to send max state he believes is required.
> >> 3) We remove coupling of migration compatibility from machine-type.
> >> 
> >> What do you think?
> > 
> > Sorry, can't do (3) - we need to keep the binding for subsections to
> > machine types for qemu compatibility;  I'm open for something for
> > kernel compat, but not when it's breaking the qemu subsection
> > checks.
> > 
> > Dave
> 
> Agree. I have proposed now above how to not break qemu subsection checks while still not tie this to machine-type.
> Please tell me what you think on that approach. :)
> 
> We can combine that approach together with implementing the mentioned .post_load() methods and maybe it solves the discussion at hand here.
> 
> -Liran
> 
> > 
> >> 
> >> -Liran
> >> 
> >>> 
> >>>> -Liran
> >>>> 
> >>>>> 
> >>>>>> -Liran
> >>>>>> 
> >>>>>>> 
> >>>>>>>> Thanks,
> >>>>>>>> -Liran
> >>>>>>> --
> >>>>>>> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> >>>>>> 
> >>>>> --
> >>>>> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> >>>> 
> >>> --
> >>> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> >> 
> > --
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
