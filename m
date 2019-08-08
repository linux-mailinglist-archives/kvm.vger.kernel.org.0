Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC5F186D8C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 01:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390303AbfHHXCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 19:02:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45758 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731914AbfHHXCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 19:02:49 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9871930EF4A0;
        Thu,  8 Aug 2019 23:02:48 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CA205D772;
        Thu,  8 Aug 2019 23:02:48 +0000 (UTC)
Date:   Thu, 8 Aug 2019 17:02:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     kvm@vger.kernel.org, kwankhede@nvidia.com,
        linux-kernel@vger.kernel.org, cohuck@redhat.com, cjia@nvidia.com
Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
Message-ID: <20190808170247.1fc2c4c4@x1.home>
In-Reply-To: <20190808141255.45236-1-parav@mellanox.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 08 Aug 2019 23:02:48 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  8 Aug 2019 09:12:53 -0500
Parav Pandit <parav@mellanox.com> wrote:

> Currently mtty sample driver uses mdev state and UUID in convoluated way to
> generate an interrupt.
> It uses several translations from mdev_state to mdev_device to mdev uuid.
> After which it does linear search of long uuid comparision to
> find out mdev_state in mtty_trigger_interrupt().
> mdev_state is already available while generating interrupt from which all
> such translations are done to reach back to mdev_state.
> 
> This translations are done during interrupt generation path.
> This is unnecessary and reduandant.

Is the interrupt handling efficiency of this particular sample driver
really relevant, or is its purpose more to illustrate the API and
provide a proof of concept?  If we go to the trouble to optimize the
sample driver and remove this interface from the API, what do we lose?

This interface was added via commit:

99e3123e3d72 vfio-mdev: Make mdev_device private and abstract interfaces

Where the goal was to create a more formal interface and abstract
driver access to the struct mdev_device.  In part this served to make
out-of-tree mdev vendor drivers more supportable; the object is
considered opaque and access is provided via an API rather than through
direct structure fields.

I believe that the NVIDIA GRID mdev driver does make use of this
interface and it's likely included in the sample driver specifically so
that there is an in-kernel user for it (ie. specifically to avoid it
being removed so casually).  An interesting feature of the NVIDIA mdev
driver is that I believe it has portions that run in userspace.  As we
know, mdevs are named with a UUID, so I can imagine there are some
efficiencies to be gained in having direct access to the UUID for a
device when interacting with userspace, rather than repeatedly parsing
it from a device name.  Is that really something we want to make more
difficult in order to optimize a sample driver?  Knowing that an mdev
device uses a UUID for it's name, as tools like libvirt and mdevctl
expect, is it really worthwhile to remove such a trivial API?

> Hence,
> Patch-1 simplifies mtty sample driver to directly use mdev_state.
> 
> Patch-2, Since no production driver uses mdev_uuid(), simplifies and
> removes redandant mdev_uuid() exported symbol.

s/no production driver/no in-kernel production driver/

I'd be interested to hear how the NVIDIA folks make use of this API
interface.  Thanks,

Alex

> ---
> Changelog:
> v1->v2:
>  - Corrected email of Kirti
>  - Updated cover letter commit log to address comment from Cornelia
>  - Added Reviewed-by tag
> v0->v1:
>  - Updated commit log
> 
> Parav Pandit (2):
>   vfio-mdev/mtty: Simplify interrupt generation
>   vfio/mdev: Removed unused and redundant API for mdev UUID
> 
>  drivers/vfio/mdev/mdev_core.c |  6 ------
>  include/linux/mdev.h          |  1 -
>  samples/vfio-mdev/mtty.c      | 39 +++++++----------------------------
>  3 files changed, 8 insertions(+), 38 deletions(-)
> 

