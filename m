Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E59F5860D
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 17:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfF0Pis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 11:38:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55672 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbfF0Pis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 11:38:48 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C343F8FAC9;
        Thu, 27 Jun 2019 15:38:47 +0000 (UTC)
Received: from x1.home (ovpn-117-35.phx2.redhat.com [10.3.117.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22098546E0;
        Thu, 27 Jun 2019 15:38:33 +0000 (UTC)
Date:   Thu, 27 Jun 2019 09:38:32 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
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
Message-ID: <20190627093832.064a346f@x1.home>
In-Reply-To: <06114b39-69c2-3fa0-d0b3-aa96a44ae2ce@linux.ibm.com>
References: <20190523172001.41f386d8@x1.home>
        <20190625165251.609f6266@x1.home>
        <20190626115806.3435c45c.cohuck@redhat.com>
        <20190626083720.42a2b5d4@x1.home>
        <20190626195350.2e9c81d3@x1.home>
        <20190627142626.415138da.cohuck@redhat.com>
        <06114b39-69c2-3fa0-d0b3-aa96a44ae2ce@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 27 Jun 2019 15:38:47 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Jun 2019 11:00:31 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 6/27/19 8:26 AM, Cornelia Huck wrote:
> > On Wed, 26 Jun 2019 19:53:50 -0600
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> >   
> >> On Wed, 26 Jun 2019 08:37:20 -0600
> >> Alex Williamson <alex.williamson@redhat.com> wrote:
> >>  
> >>> On Wed, 26 Jun 2019 11:58:06 +0200
> >>> Cornelia Huck <cohuck@redhat.com> wrote:
> >>>     
> >>>> On Tue, 25 Jun 2019 16:52:51 -0600
> >>>> Alex Williamson <alex.williamson@redhat.com> wrote:
> >>>>       
> >>>>> Hi,
> >>>>>
> >>>>> Based on the discussions we've had, I've rewritten the bulk of
> >>>>> mdevctl.  I think it largely does everything we want now, modulo
> >>>>> devices that will need some sort of 1:N values per key for
> >>>>> configuration in the config file versus the 1:1 key:value setup we
> >>>>> currently have (so don't consider the format final just yet).        
> >>>>
> >>>> We might want to factor out that config format handling while we're
> >>>> trying to finalize it.
> >>>>
> >>>> cc:ing Matt for his awareness. I'm currently not quite sure how to
> >>>> handle those vfio-ap "write several values to an attribute one at a
> >>>> time" requirements. Maybe 1:N key:value is the way to go; maybe we
> >>>> need/want JSON or something like that.      
> >>>
> >>> Maybe we should just do JSON for future flexibility.  I assume there
> >>> are lots of helpers that should make it easy even from a bash script.
> >>> I'll look at that next.    
> >>
> >> Done.  Throw away any old mdev config files, we use JSON now.   
> > 
> > The code changes look quite straightforward, thanks.
> >   
> >> The per
> >> mdev config now looks like this:
> >>
> >> {
> >>   "mdev_type": "i915-GVTg_V4_8",
> >>   "start": "auto"
> >> }
> >>
> >> My expectation, and what I've already pre-enabled support in set_key
> >> and get_key functions, is that we'd use arrays for values, so we might
> >> have:
> >>
> >>   "new_key": ["value1", "value2"]
> >>
> >> set_key will automatically convert a comma separated list of values
> >> into such an array, so I'm thinking this would be specified by the user
> >> as:
> >>
> >> # mdevctl modify -u UUID --key=new_key --value=value1,value2  
> > 
> > Looks sensible.
> > 
> > For vfio-ap, we'd probably end up with something like the following:
> > 
> > {
> >   "mdev_type": "vfio_ap-passthrough",
> >   "start": "auto",
> >   "assign_adapter": ["5", "6"],
> >   "assign_domain": ["4", "0xab"]
> > }
> > 
> > (following the Guest1 example in the kernel documentation)
> > 
> > <As an aside, what should happen if e.g "assign_adapter" is set to
> > ["6", "7"]? Remove 5, add 7? Remove all values, then set the new ones?  
> 
> IMO remove 5, add 7 would make the most sense.  I'm not sure that doing
> an unassign of all adapters (effectively removing all APQNs) followed by
> an assign of the new ones would work nicely with Tony's vfio-ap dynamic
> configuration patches.

Are we conflating operating on the config file versus operating on the
device?  I was thinking that setting a new key value replaces the
existing key, because anything else adds unnecessary complication to
the code and command line.  So in the above example, if the user
specified:

  mdevctl modify -u UUID --key=assign_adapter --value=6,7

The new value is simply ["6", "7"].  This would take effect the next
time the device is started.  We haven't yet considered how to change
running devices, but I think the semantics we have since the respin of
mdevctl separate saved config vs running devices in order to generalize
the support of transient devices.

> > Similar for deleting the "assign_adapter" key. We have an
> > "unassign_adapter" attribute, but this is not something we can infer
> > automatically; we need to know that we're dealing with an vfio-ap
> > matrix device...>
> >   
> >>
> >> We should think about whether ordering is important and maybe
> >> incorporate that into key naming conventions or come up with some
> >> syntax for specifying startup blocks.  Thanks,
> >>
> >> Alex  
> > 
> > Hm...
> > 
> > {
> >   "foo": "1",
> >   "bar": "42",
> >   "baz": {
> >     "depends": ["foo", "bar"],
> >     "value": "plahh"
> >   }
> > }
> > 
> > Something like that?

I'm not sure yet.  I think we need to look at what's feasible (and
easy) with jq.  Thanks,

Alex
