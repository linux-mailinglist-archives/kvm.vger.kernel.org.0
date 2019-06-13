Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A15643CFF
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfFMPic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:38:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58171 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731951AbfFMKCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 06:02:48 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B3C5BB2DFE;
        Thu, 13 Jun 2019 10:02:47 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6FC31001947;
        Thu, 13 Jun 2019 10:02:41 +0000 (UTC)
Date:   Thu, 13 Jun 2019 12:02:39 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>
Subject: Re: mdevctl: A shoestring mediated device management and
 persistence utility
Message-ID: <20190613120239.3a78b076.cohuck@redhat.com>
In-Reply-To: <20190612175434.54e196e2.pasic@linux.ibm.com>
References: <20190523172001.41f386d8@x1.home>
        <20190524121106.16e08562.cohuck@redhat.com>
        <20190607180630.7e8e24d4.pasic@linux.ibm.com>
        <20190611214508.0a86aeb2.cohuck@redhat.com>
        <20190611142822.238ef424@x1.home>
        <20190612091439.3a33f17b.cohuck@redhat.com>
        <20190612175434.54e196e2.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 13 Jun 2019 10:02:47 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jun 2019 17:54:34 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Wed, 12 Jun 2019 09:14:39 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:

> > Ok, looked at driverctl. Extending this one for non-PCI seems like a
> > reasonable path. However, we would also need to extend any non-PCI
> > device type we want to support with a driver_override attribute like
> > you did for PCI in 782a985d7af26db39e86070d28f987cad2 -- so this is
> > only for newer kernels. Adding that attribute for subchannels looks
> > feasible at a glance, but I have not tried to actually do it :)
> > 
> > Halil, do you think that would make sense?  
> 
> Looks doable. Did not quite figure out the details yet, but it seems
> that for PCI driver_override has more benefits than for cio (compared
> to simple unbind/bind), as matching and probing seems to be more
> elaborate for PCI. The benefit I see are
> 1) the ability to exclude the device form driver binding, and
> 2) having the same mechanism and thus consistent experience for pci and
> cio.

Yes, we should provide the same mechanism, even if it is much simpler
for the css bus.

> 
> What we IMHO should not do is make driver_override the override the
> sch->st == id->type check.

Agreed. The number of possible ids is much lower on the css bus, and a
driver wanting to match to any device may simply specify all of them
(not that this looks very useful).

I'm currently playing with this change; will send out a patch when I
have it in reasonable shape.

> 
> Regards,
> Halil
> 
> > 
> > [This might also help with the lcs vs. ctc confusion on a certain 3088
> > cu model if this is added for ccw devices as well; but I'm not sure if
> > these are still out in the wild at all. Probably not worth the effort
> > for that.]  
> 

