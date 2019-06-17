Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF554882E
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 18:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbfFQQDo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 17 Jun 2019 12:03:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56484 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfFQQDn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 12:03:43 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 61A5A30C1214;
        Mon, 17 Jun 2019 16:03:43 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62DEF5F729;
        Mon, 17 Jun 2019 16:03:28 +0000 (UTC)
Date:   Mon, 17 Jun 2019 18:03:26 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christophe de Dinechin <cdupontd@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Skultety <eskultet@redhat.com>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [libvirt] mdevctl: A shoestring mediated device management and
 persistence utility
Message-ID: <20190617180326.00aa1707.cohuck@redhat.com>
In-Reply-To: <20190614100418.61974597@x1.home>
References: <20190523172001.41f386d8@x1.home>
        <0358F503-E2C7-42DC-8186-34D1DA31F6D7@redhat.com>
        <20190613103555.3923e078@x1.home>
        <4C4B64A0-E017-436C-B13E-E60EABC6F5F1@redhat.com>
        <20190614082328.540a04ea@x1.home>
        <7CA32921-CEF3-4AE9-BA80-DD422C5F0E7F@redhat.com>
        <20190614100418.61974597@x1.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 17 Jun 2019 16:03:43 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jun 2019 10:04:18 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Fri, 14 Jun 2019 17:06:15 +0200
> Christophe de Dinechin <cdupontd@redhat.com> wrote:
> 
> > > On 14 Jun 2019, at 16:23, Alex Williamson <alex.williamson@redhat.com> wrote:
> > > 
> > > On Fri, 14 Jun 2019 11:54:42 +0200
> > > Christophe de Dinechin <cdupontd@redhat.com> wrote:

> > > Where is the parent/type ownership implied?    
> > 
> > I did not imply it, but I read some concern about ownership
> > on your part in "they need to guess that an mdev device
> > with the same parent and type is *theirs*.” (emphasis mine)
> > 
> > I personally see no change on the “need to guess” implied
> > by the fact that you run uuidgen inside the script, so
> > that’s why I tried to guess what you meant.  
> 
> As I noted in the reply to the pull request, putting `uuidgen` inline
> was probably a bad example. 

FWIW, I just sent a pull req to get rid of that inline `uuidgen` in the
example.

> However, the difference is that the user
> has imposed the race on themselves if they invoke mdevctl like this,
> they've provided a uuid but they didn't record what it is.  This is the
> user's problem.  Pushing uuid selection into mdevctl makes it mdevctl's
> problem because the interface is fundamentally broken.
> 
> > > The intended semantics are
> > > "try to create this type of device under this parent”.    
> > 
> > Agreed. Which is why I don’t see why trying to create
> > with some new UUID introduces any race (as long as
> > the script prints out that UUID, which I admit my patch
> > entirely failed to to)  
> 
> And that's the piece that makes it fundamentally broken.  Beyond that,
> it seems unnecessary.  I don't see this as the primary invocation of
> mdevctl and the functionality it adds is trivially accomplished in a
> wrapper, so what's the value?
> 
> > >>> How do you resolve two instances of this happening in parallel and both
> > >>> coming to the same conclusion which is their device.  If a user wants
> > >>> this sort of headache they can call mdevctl with `uuidgen` but I don't
> > >>> think we should encourage it further.      
> > >> 
> > >> I agree there is a race, but if anything, having a usage where you don’t
> > >> pass the UUID on the command line is a step in the right direction.
> > >> It leaves the door open for the create-mdev script to do smarter things,
> > >> like deferring the allocation of the mdevs to an entity that has slightly
> > >> more knowledge of the global system state than uuidgen.    
> > > 
> > > A user might (likely) require a specific uuid to match their VM
> > > configuration.  I can only think of very niche use cases where a user
> > > doesn't care what uuid they get.    
> > 
> > They do care. But I typically copy-paste my UUIDs, and then
> > 
> > 1. copy-pasting at the end is always faster than between
> > the command and other arguments (3-args case). 
> > 
> > 2. copy-pasting the output of the previous command is faster
> > than having one extra step where I need to copy the same thing twice
> > (2-args case).
> > 
> > So to me, if the script is intended to be used by humans, my
> > proposal makes it slightly more comfortable to use. Nothing more.  
> 
> This is your preference, but I wouldn't call it universal.  Specifying
> the uuid last seems backwards to me, we're creating an object so let's
> first name that object.  We then specify where that object should be
> created and what type it has.  This seems very logical to me, besides,
> it's also the exact same order we use when listing mdevs :P
> 
> Clearly there's personal preference here, so let's not arbitrarily pick
> a different preference.  If copy/paste order is more important to you
> then submit a patch to give mdevctl real argument processing so you can
> specify --uuid, --parent, --type in whatever order you want.

I agree that these are personal preferences :) Real argument processing
makes sense, however.
