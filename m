Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C7B57924
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 03:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfF0Bx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 21:53:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35594 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbfF0Bx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 21:53:57 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BAE8258E5C;
        Thu, 27 Jun 2019 01:53:56 +0000 (UTC)
Received: from x1.home (ovpn-117-35.phx2.redhat.com [10.3.117.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82AF360BE5;
        Thu, 27 Jun 2019 01:53:51 +0000 (UTC)
Date:   Wed, 26 Jun 2019 19:53:50 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: mdevctl: A shoestring mediated device management and
 persistence utility
Message-ID: <20190626195350.2e9c81d3@x1.home>
In-Reply-To: <20190626083720.42a2b5d4@x1.home>
References: <20190523172001.41f386d8@x1.home>
        <20190625165251.609f6266@x1.home>
        <20190626115806.3435c45c.cohuck@redhat.com>
        <20190626083720.42a2b5d4@x1.home>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 27 Jun 2019 01:53:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Jun 2019 08:37:20 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Wed, 26 Jun 2019 11:58:06 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Tue, 25 Jun 2019 16:52:51 -0600
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> >   
> > > Hi,
> > > 
> > > Based on the discussions we've had, I've rewritten the bulk of
> > > mdevctl.  I think it largely does everything we want now, modulo
> > > devices that will need some sort of 1:N values per key for
> > > configuration in the config file versus the 1:1 key:value setup we
> > > currently have (so don't consider the format final just yet).    
> > 
> > We might want to factor out that config format handling while we're
> > trying to finalize it.
> > 
> > cc:ing Matt for his awareness. I'm currently not quite sure how to
> > handle those vfio-ap "write several values to an attribute one at a
> > time" requirements. Maybe 1:N key:value is the way to go; maybe we
> > need/want JSON or something like that.  
> 
> Maybe we should just do JSON for future flexibility.  I assume there
> are lots of helpers that should make it easy even from a bash script.
> I'll look at that next.

Done.  Throw away any old mdev config files, we use JSON now.  The per
mdev config now looks like this:

{
  "mdev_type": "i915-GVTg_V4_8",
  "start": "auto"
}

My expectation, and what I've already pre-enabled support in set_key
and get_key functions, is that we'd use arrays for values, so we might
have:

  "new_key": ["value1", "value2"]

set_key will automatically convert a comma separated list of values
into such an array, so I'm thinking this would be specified by the user
as:

# mdevctl modify -u UUID --key=new_key --value=value1,value2

We should think about whether ordering is important and maybe
incorporate that into key naming conventions or come up with some
syntax for specifying startup blocks.  Thanks,

Alex
