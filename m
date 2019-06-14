Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F2B4639A
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 18:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbfFNQEW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 14 Jun 2019 12:04:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfFNQEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 12:04:21 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 208796378;
        Fri, 14 Jun 2019 16:04:21 +0000 (UTC)
Received: from x1.home (ovpn-116-190.phx2.redhat.com [10.3.116.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0AE4560BE0;
        Fri, 14 Jun 2019 16:04:17 +0000 (UTC)
Date:   Fri, 14 Jun 2019 10:04:18 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christophe de Dinechin <cdupontd@redhat.com>
Cc:     Sylvain Bauza <sbauza@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Skultety <eskultet@redhat.com>,
        Libvirt Devel <libvir-list@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [libvirt] mdevctl: A shoestring mediated device management and
 persistence utility
Message-ID: <20190614100418.61974597@x1.home>
In-Reply-To: <7CA32921-CEF3-4AE9-BA80-DD422C5F0E7F@redhat.com>
References: <20190523172001.41f386d8@x1.home>
        <0358F503-E2C7-42DC-8186-34D1DA31F6D7@redhat.com>
        <20190613103555.3923e078@x1.home>
        <4C4B64A0-E017-436C-B13E-E60EABC6F5F1@redhat.com>
        <20190614082328.540a04ea@x1.home>
        <7CA32921-CEF3-4AE9-BA80-DD422C5F0E7F@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 14 Jun 2019 16:04:21 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jun 2019 17:06:15 +0200
Christophe de Dinechin <cdupontd@redhat.com> wrote:

> > On 14 Jun 2019, at 16:23, Alex Williamson <alex.williamson@redhat.com> wrote:
> > 
> > On Fri, 14 Jun 2019 11:54:42 +0200
> > Christophe de Dinechin <cdupontd@redhat.com> wrote:
> >   
> >> That is true irrespective of the usage, isn’t it? In other words, when you
> >> invoke `mdevctl create-mdev`, you assert “I own that specific parent/type”.
> >> At least, that’s how I read the way the script behaves today. Whether you
> >> invoke uuidgen inside or outside the script does not change that assertion
> >> (at least with today’s code).  
> > 
> > What gives you this impression?  
> 
> That your code does nothing to avoid any race today?
> 
> Maybe I was confused with the existing `uuidgen` example in you README,
> but it looks to me like the usage model involves much more than just
> create-mdev, and that any race that might exist is not in create-mdev itself
> (or in uuidgen for that matter).

I believe I mentioned this was an early release, error handling is
lacking.  Still, I think the races are minimal, they largely involve
uuid collisions.  Separate users can create mdevs under the same parent
concurrently, they would need to have a uuid collision to conflict.
Otherwise there's the resource issue on the parent, but that's left of
the kernel to manage.  If an mdev fails to be created at the kernel,
mdevctl should unwind, but we're not going to pretend that we have a
lock on the parent's sysfs mdev interfaces.

> > Where is the parent/type ownership implied?  
> 
> I did not imply it, but I read some concern about ownership
> on your part in "they need to guess that an mdev device
> with the same parent and type is *theirs*.” (emphasis mine)
> 
> I personally see no change on the “need to guess” implied
> by the fact that you run uuidgen inside the script, so
> that’s why I tried to guess what you meant.

As I noted in the reply to the pull request, putting `uuidgen` inline
was probably a bad example.  However, the difference is that the user
has imposed the race on themselves if they invoke mdevctl like this,
they've provided a uuid but they didn't record what it is.  This is the
user's problem.  Pushing uuid selection into mdevctl makes it mdevctl's
problem because the interface is fundamentally broken.

> > The intended semantics are
> > "try to create this type of device under this parent”.  
> 
> Agreed. Which is why I don’t see why trying to create
> with some new UUID introduces any race (as long as
> the script prints out that UUID, which I admit my patch
> entirely failed to to)

And that's the piece that makes it fundamentally broken.  Beyond that,
it seems unnecessary.  I don't see this as the primary invocation of
mdevctl and the functionality it adds is trivially accomplished in a
wrapper, so what's the value?

> >>> How do you resolve two instances of this happening in parallel and both
> >>> coming to the same conclusion which is their device.  If a user wants
> >>> this sort of headache they can call mdevctl with `uuidgen` but I don't
> >>> think we should encourage it further.    
> >> 
> >> I agree there is a race, but if anything, having a usage where you don’t
> >> pass the UUID on the command line is a step in the right direction.
> >> It leaves the door open for the create-mdev script to do smarter things,
> >> like deferring the allocation of the mdevs to an entity that has slightly
> >> more knowledge of the global system state than uuidgen.  
> > 
> > A user might (likely) require a specific uuid to match their VM
> > configuration.  I can only think of very niche use cases where a user
> > doesn't care what uuid they get.  
> 
> They do care. But I typically copy-paste my UUIDs, and then
> 
> 1. copy-pasting at the end is always faster than between
> the command and other arguments (3-args case). 
> 
> 2. copy-pasting the output of the previous command is faster
> than having one extra step where I need to copy the same thing twice
> (2-args case).
> 
> So to me, if the script is intended to be used by humans, my
> proposal makes it slightly more comfortable to use. Nothing more.

This is your preference, but I wouldn't call it universal.  Specifying
the uuid last seems backwards to me, we're creating an object so let's
first name that object.  We then specify where that object should be
created and what type it has.  This seems very logical to me, besides,
it's also the exact same order we use when listing mdevs :P

Clearly there's personal preference here, so let's not arbitrarily pick
a different preference.  If copy/paste order is more important to you
then submit a patch to give mdevctl real argument processing so you can
specify --uuid, --parent, --type in whatever order you want.

> >> In other words, in my mind, `mdevctl create-mdev parent type` does not
> >> imply “this will use uuidgen” but rather, if anything, implies “this will do the
> >> right thing to prevent the race in the future, even if that’s more complex
> >> than just calling uuidgen”.  
> > 
> > What race are you trying to prevent, uuid collision?  
> 
> Of course not ;-)
> 
> I only added the part of the discussion below trying to figure out what
> race you were seeing that was present only with my proposed changes.
> 
> I (apparently incorrectly) supposed that you had some kind of mdev
> management within the script in mind. Obviously I misinterpreted.
> That will teach me to guess when I don’t understand instead of just
> ask…

The management mdevctl provides is persistence, interrogation, and
interaction with mdevs and parent devices.  Like every other tool, I'm
going to defer policy related decisions to someone else.  Picking a
uuid is policy.  Picking a parent device is policy.

> >> However, I believe that this means we should reorder the args further.
> >> I would suggest something like:
> >> 
> >> 	mdevctl create-mdev <mdev-type> [<parent-device> [<mdev-uuid>]]
> >> 
> >> where  
> > 
> > Absolutely not, now you've required mdevctl to implement policy in mdev
> > placement.  
> 
> No, I’m not requiring it. I’m leaving the door open if one day, say, we decide
> to have libvirt tell us about the placement. That usage needs not go in right away,
> I marked it as “(future)”.
> 
> Basically, all I’m saying is that since it’s early, we can reorder the
> arguments so that the one you are most likely to change when you reuse
> the command are the one that are last on the command-line, so that it
> makes editing or copy-pasting easier. There isn’t more to it, and that’s
> why I still do not see any new race introduced by that change.

This is just compounding a shortcut made for this initial version,
clearly the solution is to allow arbitrary option ordering, not to pick
a different ordering for a perceived copy/paste efficiency

> >  mdevctl follows the unix standard, do one thing and do it
> > well.  If someone wants to layer placement policy on top of mdevctl,
> > great, but let's not impose that within mdevctl.  
> 
> I’m not imposing anything (I believe). I was only trying to guess
> where you saw things going that would imply there was a race with
> my proposal that was not there without :-)
> 
> >   
> >> 1 arg means you let mdevctl choose the parent device for you (future)
> >>   (e.g. I want a VGPU of this type, I don’t really care where it comes from)
> >> 2 args mean you want that specific type/parent combination
> >> 3 args mean you assert you own that device
> >> 
> >> That also implies that mdevctl create-mdev should output what it allocated
> >> so that some higher-level software can tell “OK, that’s the instance I got”.  
> > 
> > I don't think we're aligned on what mdevctl is attempting to provide.
> > Maybe you're describing a layer you'd like to see above mdevctl?
> > Thanks,  
> 
> No, again, I’m just trying to understand where you see a race.
> 
> Maybe instead of guessing, I should just ask: where is the race in
> the two-args variant (assuming it prints the UUID it used) that does not
> exist with the three-args variant?

Currently users deterministically know the uuid of the mdev they
create, they specify it.  They're not racing other users that
potentially created the same type on the same parent to guess which
mdev might be theirs, potentially picking the wrong one, potentially
picking the same as their counterpart.  Returning the uuid solves this
race, but as you noted, implies a much broader uuid allocation scheme
and policy which I'm not interested in providing in mdevctl until you
can convince me otherwise.  Thanks,

Alex
