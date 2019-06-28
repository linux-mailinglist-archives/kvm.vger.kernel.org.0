Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7D85A1C4
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 19:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfF1RF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 13:05:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57270 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbfF1RF4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jun 2019 13:05:56 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 64DA780F91;
        Fri, 28 Jun 2019 17:05:55 +0000 (UTC)
Received: from x1.home (ovpn-117-35.phx2.redhat.com [10.3.117.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7538F6012D;
        Fri, 28 Jun 2019 17:05:49 +0000 (UTC)
Date:   Fri, 28 Jun 2019 11:05:46 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: mdevctl: A shoestring mediated device management and
 persistence utility
Message-ID: <20190628110546.4d3ce595@x1.home>
In-Reply-To: <20190628110648.40e0607d.cohuck@redhat.com>
References: <20190523172001.41f386d8@x1.home>
        <20190625165251.609f6266@x1.home>
        <20190626115806.3435c45c.cohuck@redhat.com>
        <20190626083720.42a2b5d4@x1.home>
        <20190626195350.2e9c81d3@x1.home>
        <20190627142626.415138da.cohuck@redhat.com>
        <06114b39-69c2-3fa0-d0b3-aa96a44ae2ce@linux.ibm.com>
        <20190627093832.064a346f@x1.home>
        <20190627151502.2ae5314f@x1.home>
        <20190627195704.66be88c8@x1.home>
        <20190628110648.40e0607d.cohuck@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 28 Jun 2019 17:05:55 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 Jun 2019 11:06:48 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Thu, 27 Jun 2019 19:57:04 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > On Thu, 27 Jun 2019 15:15:02 -0600
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> >   
> > > On Thu, 27 Jun 2019 09:38:32 -0600
> > > Alex Williamson <alex.williamson@redhat.com> wrote:    
> > > > > On 6/27/19 8:26 AM, Cornelia Huck wrote:        
> > > > > > 
> > > > > > {
> > > > > >   "foo": "1",
> > > > > >   "bar": "42",
> > > > > >   "baz": {
> > > > > >     "depends": ["foo", "bar"],
> > > > > >     "value": "plahh"
> > > > > >   }
> > > > > > }
> > > > > > 
> > > > > > Something like that?        
> > > > 
> > > > I'm not sure yet.  I think we need to look at what's feasible (and
> > > > easy) with jq.  Thanks,      
> > > 
> > > I think it's not too much trouble to remove and insert into arrays, so
> > > what if we were to define the config as:
> > > 
> > > {
> > >   "mdev_type":"vendor-type",
> > >   "start":"auto",
> > >   "attrs": [
> > >       {"attrX":["Xvalue1","Xvalue2"]},
> > >       {"dir/attrY": "Yvalue1"},
> > >       {"attrX": "Xvalue3"}
> > >     ]
> > > }
> > > 
> > > "attr" here would define sysfs attributes under the device.  The array
> > > would be processed in order, so in the above example we'd do the
> > > following:
> > > 
> > >  1. echo Xvalue1 > attrX
> > >  2. echo Xvalue2 > attrX
> > >  3. echo Yvalue1 > dir/attrY
> > >  4. echo Xvalue3 > attrX
> > > 
> > > When starting the device mdevctl would simply walk the array, if the
> > > attribute key exists write the value(s).  If a write fails or the
> > > attribute doesn't exist, remove the device and report error.  
> 
> Yes, I think it makes sense to fail the startup of a device where we
> cannot set all attributes to the requested values.
> 
> > > 
> > > I think it's easiest with jq to manipulate arrays by removing and
> > > inserting by index.  Also if we end up with something like above, it's
> > > ambiguous if we reference the "attrX" key.  So perhaps we add the
> > > following options to the modify command:
> > > 
> > > --addattr=ATTRIBUTE --delattr --index=INDEX --value=VALUE1[,VALUE2]
> > > 
> > > We could handle it like a stack, so if --index is not supplied, add to
> > > the end or remove from the end.  If --index is provided, delete that
> > > index or add the attribute at that index.  So if you had the above and
> > > wanted to remove Xvalue1 but keep the ordering, you'd do:
> > > 
> > > --delattr --index=0
> > > --addattr --index=0 --value=Xvalue2
> > > 
> > > Which should results in:
> > > 
> > >   "attrs": [
> > >       {"attrX": "Xvalue2"},
> > >       {"dir/attrY": "Yvalue1"},
> > >       {"attrX": "Xvalue3"}
> > >     ]  
> 
> Modifying by index looks reasonable; I just sent a pull request to
> print the index of an attribute out as well, so it is easier to specify
> the right attribute to modify.

Pulled, I had initially separated the per line and interpreted them,
but it felt too verbose, so I went the full other direction or putting
them on a single line and using the compact json representation.  Maybe
this is a reasonable compromise.

> > > If we want to modify a running device, I'm thinking we probably want a
> > > new command and options --attr=ATTRIBUTE --value=VALUE might suffice.
> > > 
> > > Do we need to support something like this for the 'start' command or
> > > should we leave that for simple devices and require a sequence of:
> > > 
> > > # mdevctl define ...
> > > # mdevctl modify --addattr...
> > > ...
> > > # mdevctl start
> > > # mdevctl undefine
> > > 
> > > This is effectively the long way to get a transient device.  Otherwise
> > > we'd need to figure out how to have --attr --value appear multiple
> > > times on the start command line.  Thanks,    
> 
> What do you think of a way to specify JSON for the attributes directly
> on the command line? Or would it be better to just edit the config
> files directly?

Supplying json on the command like seems difficult, even doing so with
with jq requires escaping quotes.  It's not a very friendly
experience.  Maybe something more like how virsh allows snippets of xml
to be included, we could use jq to validate a json snippet provided
as a file and add it to the attributes... of course if we need to allow
libvirt to modify the json config files directly, the user could do
that as well.  Is there a use case you're thinking of?  Maybe we could
augment the 'list' command to take a --uuid and --dumpjson option and
the 'define' command to accept a --jsonfile.  Maybe the 'start' command
could accept the same, so a transient device could define attributes
w/o excessive command line options.  Thanks,

Alex

> > This is now implemented, and yes you can specify '--addattr remove
> > --value 1' and mdevctl will immediately remove the device after it's
> > created (more power to the admin).  Listing defined devices also lists  
> 
> Fun ;)
> 
> > any attributes defined for easy inspection.  It is also possible to
> > override the conversion of comma separated values into an array by
> > encoding and escaping the comma.  It's a little cumbersome, but
> > possible in case a driver isn't fully on board with the one attribute,
> > one value rule of sysfs.  Does this work for vfio-ap?  I also still  
> 
> I do not have ap devices to actually test this with; but defining a
> device and adding attributes seems to work.
> 
> > need to check if this allows an NVIDIA vGPU mdev to be configured such
> > that the framerate limiter can be automatically controlled.  Thanks,
> > 
> > Alex  
> 

