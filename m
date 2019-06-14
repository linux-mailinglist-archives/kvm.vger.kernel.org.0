Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D88746094
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 16:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbfFNOXc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 14 Jun 2019 10:23:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727729AbfFNOXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 10:23:31 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 357753DE10;
        Fri, 14 Jun 2019 14:23:31 +0000 (UTC)
Received: from x1.home (ovpn-116-190.phx2.redhat.com [10.3.116.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D51C608A4;
        Fri, 14 Jun 2019 14:23:27 +0000 (UTC)
Date:   Fri, 14 Jun 2019 08:23:28 -0600
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
Message-ID: <20190614082328.540a04ea@x1.home>
In-Reply-To: <4C4B64A0-E017-436C-B13E-E60EABC6F5F1@redhat.com>
References: <20190523172001.41f386d8@x1.home>
        <0358F503-E2C7-42DC-8186-34D1DA31F6D7@redhat.com>
        <20190613103555.3923e078@x1.home>
        <4C4B64A0-E017-436C-B13E-E60EABC6F5F1@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 14 Jun 2019 14:23:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jun 2019 11:54:42 +0200
Christophe de Dinechin <cdupontd@redhat.com> wrote:

> > On 13 Jun 2019, at 18:35, Alex Williamson <alex.williamson@redhat.com> wrote:
> > 
> > On Thu, 13 Jun 2019 18:17:53 +0200
> > Christophe de Dinechin <cdupontd@redhat.com> wrote:
> >   
> >>> On 24 May 2019, at 01:20, Alex Williamson <alex.williamson@redhat.com> wrote:
> >>> 
> >>> Hi,
> >>> 
> >>> Currently mediated device management, much like SR-IOV VF management,
> >>> is largely left as an exercise for the user.  This is an attempt to
> >>> provide something and see where it goes.  I doubt we'll solve
> >>> everyone's needs on the first pass, but maybe we'll solve enough and
> >>> provide helpers for the rest.  Without further ado, I'll point to what
> >>> I have so far:
> >>> 
> >>> https://github.com/awilliam/mdevctl    
> >> 
> >> While it’s still early, what about :
> >> 
> >> 	mdevctl create-mdev <parent-device> <mdev-type> [<mdev-uuid>]
> >> 
> >> where if the mdev-uuid is missing, you just run uuidgen within the script?
> >> 
> >> I sent a small PR in case you think it makes sense.  
> > 
> > It sounds racy.  If the user doesn't provide the UUID then they need to
> > guess that an mdev device with the same parent and type is theirs.  
> 
> That is true irrespective of the usage, isn’t it? In other words, when you
> invoke `mdevctl create-mdev`, you assert “I own that specific parent/type”.
> At least, that’s how I read the way the script behaves today. Whether you
> invoke uuidgen inside or outside the script does not change that assertion
> (at least with today’s code).

What gives you this impression?  Where is the parent/type ownership
implied?  The intended semantics are "try to create this type of device
under this parent".
 
> >  How do you resolve two instances of this happening in parallel and both
> > coming to the same conclusion which is their device.  If a user wants
> > this sort of headache they can call mdevctl with `uuidgen` but I don't
> > think we should encourage it further.  
> 
> I agree there is a race, but if anything, having a usage where you don’t
> pass the UUID on the command line is a step in the right direction.
> It leaves the door open for the create-mdev script to do smarter things,
> like deferring the allocation of the mdevs to an entity that has slightly
> more knowledge of the global system state than uuidgen.

A user might (likely) require a specific uuid to match their VM
configuration.  I can only think of very niche use cases where a user
doesn't care what uuid they get.

> In other words, in my mind, `mdevctl create-mdev parent type` does not
> imply “this will use uuidgen” but rather, if anything, implies “this will do the
> right thing to prevent the race in the future, even if that’s more complex
> than just calling uuidgen”.

What race are you trying to prevent, uuid collision?

> However, I believe that this means we should reorder the args further.
> I would suggest something like:
> 
> 	mdevctl create-mdev <mdev-type> [<parent-device> [<mdev-uuid>]]
> 
> where

Absolutely not, now you've required mdevctl to implement policy in mdev
placement.  mdevctl follows the unix standard, do one thing and do it
well.  If someone wants to layer placement policy on top of mdevctl,
great, but let's not impose that within mdevctl.

> 1 arg means you let mdevctl choose the parent device for you (future)
>    (e.g. I want a VGPU of this type, I don’t really care where it comes from)
> 2 args mean you want that specific type/parent combination
> 3 args mean you assert you own that device
> 
> That also implies that mdevctl create-mdev should output what it allocated
> so that some higher-level software can tell “OK, that’s the instance I got”.

I don't think we're aligned on what mdevctl is attempting to provide.
Maybe you're describing a layer you'd like to see above mdevctl?
Thanks,

Alex

> > BTW, I've moved the project to https://github.com/mdevctl/mdevctl, the
> > latest commit in the tree above makes that change, I've also updated
> > the description on my repo to point to the new location.  Thanks,  
> 
> Done.
> 
> > 
> > Alex
> > 
> > --
> > libvir-list mailing list
> > libvir-list@redhat.com
> > https://www.redhat.com/mailman/listinfo/libvir-list  
> 

