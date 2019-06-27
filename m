Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B708A58CE2
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 23:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfF0VPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 17:15:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46256 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfF0VPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 17:15:18 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A384B308FED5;
        Thu, 27 Jun 2019 21:15:17 +0000 (UTC)
Received: from x1.home (ovpn-117-35.phx2.redhat.com [10.3.117.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA47D600CC;
        Thu, 27 Jun 2019 21:15:02 +0000 (UTC)
Date:   Thu, 27 Jun 2019 15:15:02 -0600
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
Message-ID: <20190627151502.2ae5314f@x1.home>
In-Reply-To: <20190627093832.064a346f@x1.home>
References: <20190523172001.41f386d8@x1.home>
        <20190625165251.609f6266@x1.home>
        <20190626115806.3435c45c.cohuck@redhat.com>
        <20190626083720.42a2b5d4@x1.home>
        <20190626195350.2e9c81d3@x1.home>
        <20190627142626.415138da.cohuck@redhat.com>
        <06114b39-69c2-3fa0-d0b3-aa96a44ae2ce@linux.ibm.com>
        <20190627093832.064a346f@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 27 Jun 2019 21:15:17 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Jun 2019 09:38:32 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:
> > On 6/27/19 8:26 AM, Cornelia Huck wrote:  
> > > 
> > > {
> > >   "foo": "1",
> > >   "bar": "42",
> > >   "baz": {
> > >     "depends": ["foo", "bar"],
> > >     "value": "plahh"
> > >   }
> > > }
> > > 
> > > Something like that?  
> 
> I'm not sure yet.  I think we need to look at what's feasible (and
> easy) with jq.  Thanks,

I think it's not too much trouble to remove and insert into arrays, so
what if we were to define the config as:

{
  "mdev_type":"vendor-type",
  "start":"auto",
  "attrs": [
      {"attrX":["Xvalue1","Xvalue2"]},
      {"dir/attrY": "Yvalue1"},
      {"attrX": "Xvalue3"}
    ]
}

"attr" here would define sysfs attributes under the device.  The array
would be processed in order, so in the above example we'd do the
following:

 1. echo Xvalue1 > attrX
 2. echo Xvalue2 > attrX
 3. echo Yvalue1 > dir/attrY
 4. echo Xvalue3 > attrX

When starting the device mdevctl would simply walk the array, if the
attribute key exists write the value(s).  If a write fails or the
attribute doesn't exist, remove the device and report error.

I think it's easiest with jq to manipulate arrays by removing and
inserting by index.  Also if we end up with something like above, it's
ambiguous if we reference the "attrX" key.  So perhaps we add the
following options to the modify command:

--addattr=ATTRIBUTE --delattr --index=INDEX --value=VALUE1[,VALUE2]

We could handle it like a stack, so if --index is not supplied, add to
the end or remove from the end.  If --index is provided, delete that
index or add the attribute at that index.  So if you had the above and
wanted to remove Xvalue1 but keep the ordering, you'd do:

--delattr --index=0
--addattr --index=0 --value=Xvalue2

Which should results in:

  "attrs": [
      {"attrX": "Xvalue2"},
      {"dir/attrY": "Yvalue1"},
      {"attrX": "Xvalue3"}
    ]

If we want to modify a running device, I'm thinking we probably want a
new command and options --attr=ATTRIBUTE --value=VALUE might suffice.

Do we need to support something like this for the 'start' command or
should we leave that for simple devices and require a sequence of:

# mdevctl define ...
# mdevctl modify --addattr...
...
# mdevctl start
# mdevctl undefine

This is effectively the long way to get a transient device.  Otherwise
we'd need to figure out how to have --attr --value appear multiple
times on the start command line.  Thanks,

Alex
