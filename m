Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5025351C14
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235888AbhDASMp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:12:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235678AbhDASHO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:07:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617300433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zkg94QyxQt7WMn8LSwxDdV3WDpQrOTmKUNrPCeN0IKY=;
        b=T5e9nbRrXVj9QZvze8kS0GS4cPVrcY/GHuMte7yDQtbY1WhrC+B67jJXSnmMzjrzbwbyOy
        0n/snpuAHHL5CO2RxTscYejr4Ha0O2Y+Ot/YzV0U9sYn8mwoaZG+JWVOfGyxrfIM18ywk7
        9icSwRI8dYvk0P/nVWreN3J07VrvNk4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-rRL8fXYJMhKNaeUgfbVMOw-1; Thu, 01 Apr 2021 09:04:57 -0400
X-MC-Unique: rRL8fXYJMhKNaeUgfbVMOw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49DF48030A1;
        Thu,  1 Apr 2021 13:04:55 +0000 (UTC)
Received: from gondolin (ovpn-113-119.ams2.redhat.com [10.36.113.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 694265D9CA;
        Thu,  1 Apr 2021 13:04:48 +0000 (UTC)
Date:   Thu, 1 Apr 2021 15:04:45 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, liranl@nvidia.com, oren@nvidia.com,
        tzahio@nvidia.com, leonro@nvidia.com, yarong@nvidia.com,
        aviadye@nvidia.com, shahafs@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, mjrosato@linux.ibm.com
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210401150445.70dc025f.cohuck@redhat.com>
In-Reply-To: <20210329171053.7a2ebce3@omen.home.shazbot.org>
References: <20210319162033.GA18218@lst.de>
        <20210319162848.GZ2356281@nvidia.com>
        <20210319163449.GA19186@lst.de>
        <20210319113642.4a9b0be1@omen.home.shazbot.org>
        <20210319200749.GB2356281@nvidia.com>
        <20210319150809.31bcd292@omen.home.shazbot.org>
        <20210319225943.GH2356281@nvidia.com>
        <20210319224028.51b01435@x1.home.shazbot.org>
        <20210321125818.GM2356281@nvidia.com>
        <20210322104016.36eb3c1f@omen.home.shazbot.org>
        <20210323193213.GM2356281@nvidia.com>
        <20210329171053.7a2ebce3@omen.home.shazbot.org>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 29 Mar 2021 17:10:53 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 23 Mar 2021 16:32:13 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Mar 22, 2021 at 10:40:16AM -0600, Alex Williamson wrote:

> > > So unless you want to do some bitkeeper archaeology, we've always
> > > allowed driver probes to fail and fall through to the next one, not
> > > even complaining with -ENODEV.  In practice it hasn't been an issue
> > > because how many drivers do you expect to have that would even try to
> > > claim a device.      
> > 
> > Do you know of anything using this ability? It might be helpful  
> 
> I don't.

I've been trying to remember why I added that patch to ignore all
errors (rather than only -ENODEV), but I suspect it might have been
related to the concurrent probing stuff I tried to implement back then.
The one instance of drivers matching to the same id I recall (s390
ctc/lcs) is actually not handled on the individual device level, but in
the meta ccwgroup driver; I don't remember anything else in the s390
case.

> 
> > > Ordering is only important when there's a catch-all so we need to
> > > figure out how to make that last among a class of drivers that will
> > > attempt to claim a device.  The softdep is a bit of a hack to do
> > > that, I'll admit, but I don't see how the alternate driver flavor
> > > universe solves having a catch-all either.    
> > 
> > Haven't entirely got there yet, but I think the catch all probably has
> > to be handled by userspace udev/kmod in some way, as it is the only
> > thing that knows if there is a more specific module to load. This is
> > the biggest problem..
> > 
> > And again, I feel this is all a big tangent, especially now that HCH
> > wants to delete the nvlink stuff we should just leave igd alone.  
> 
> Determining which things stay in vfio-pci-core and which things are
> split to variant drivers and how those variant drivers can match the
> devices they intend to support seems very inline with this series.  If
> igd stays as part of vfio-pci-core then I think we're drawing a
> parallel to z-pci support, where a significant part of that support is
> a set of extra data structures exposed through capabilities to support
> userspace use of the device.  Therefore extra regions or data
> structures through capabilities, where we're not changing device
> access, except as required for the platform (not the device) seem to be
> things that fit within the core, right?  Thanks,
> 
> Alex

As we are only talking about extra data governed by a capability, I
don't really see a problem with keeping it in the vfio core.

For those devices that need more specialized treatment, maybe we need
some kind of priority-based matching? I.e., if we match a device with
drivers, start with the one with highest priority (the specialized
one), and have the generic driver at the lowest priority. A
higher-priority driver added later one should not affect already bound
devices (and would need manual intervention again.)

[I think this has come up in other places in the past as well, but I
don't have any concrete pointers handy.]

