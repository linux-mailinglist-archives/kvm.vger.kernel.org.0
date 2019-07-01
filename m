Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45345C1CD
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 19:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbfGARN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 13:13:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728591AbfGARN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 13:13:27 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4FB6030C3183;
        Mon,  1 Jul 2019 17:13:27 +0000 (UTC)
Received: from gondolin (ovpn-117-220.ams2.redhat.com [10.36.117.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52C971001B20;
        Mon,  1 Jul 2019 17:13:17 +0000 (UTC)
Date:   Mon, 1 Jul 2019 19:13:14 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
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
Message-ID: <20190701191314.2ad25782.cohuck@redhat.com>
In-Reply-To: <20190701084051.7f2bbc24@x1.home>
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
        <20190628110546.4d3ce595@x1.home>
        <20190701102043.61afa0da.cohuck@redhat.com>
        <20190701084051.7f2bbc24@x1.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 01 Jul 2019 17:13:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 1 Jul 2019 08:40:51 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Mon, 1 Jul 2019 10:20:43 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Fri, 28 Jun 2019 11:05:46 -0600
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> >   
> > > On Fri, 28 Jun 2019 11:06:48 +0200
> > > Cornelia Huck <cohuck@redhat.com> wrote:    
> >   
> > > > What do you think of a way to specify JSON for the attributes directly
> > > > on the command line? Or would it be better to just edit the config
> > > > files directly?      
> > > 
> > > Supplying json on the command like seems difficult, even doing so with
> > > with jq requires escaping quotes.  It's not a very friendly
> > > experience.  Maybe something more like how virsh allows snippets of xml
> > > to be included, we could use jq to validate a json snippet provided
> > > as a file and add it to the attributes... of course if we need to allow
> > > libvirt to modify the json config files directly, the user could do
> > > that as well.  Is there a use case you're thinking of?  Maybe we could
> > > augment the 'list' command to take a --uuid and --dumpjson option and
> > > the 'define' command to accept a --jsonfile.  Maybe the 'start' command
> > > could accept the same, so a transient device could define attributes
> > > w/o excessive command line options.  Thanks,
> > > 
> > > Alex    
> > 
> > I was mostly thinking about complex configurations where writing a JSON
> > config would be simpler than adding a lot of command line options.
> > Something like dumping a JSON file and allowing to refer to a JSON file
> > as you suggested could be useful; but then, those very complex use
> > cases are probably already covered by editing the config file directly.
> > Not sure if it is worth the effort; maybe just leave it as it is for
> > now.  
> 
> Well, I already did it.  It seems useful for creating transient devices
> with attribute specifications.  If it's too ugly we can drop it.

I should probably look at the repository before I reply :)

Anyway, this doesn't look too ugly to me; but I think it would benefit
from some usage examples (which I just sent you a pull request for :)

> Thanks,
> 
> Alex

