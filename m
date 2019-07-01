Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CD15C39D
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 21:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfGAT1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 15:27:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42734 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfGAT1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 15:27:00 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EA97BC1EB200;
        Mon,  1 Jul 2019 19:26:59 +0000 (UTC)
Received: from gondolin (ovpn-117-220.ams2.redhat.com [10.36.117.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B8BCE2C8E2;
        Mon,  1 Jul 2019 19:26:46 +0000 (UTC)
Date:   Mon, 1 Jul 2019 21:26:43 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, mjrosato@linux.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
Subject: Re: [PATCH v4 3/7] s390: zcrypt: driver callback to indicate
 resource in use
Message-ID: <20190701212643.0dd7d4ab.cohuck@redhat.com>
In-Reply-To: <2366c6b6-fd9e-0c32-0e9d-018cd601a0ad@linux.ibm.com>
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
        <1560454780-20359-4-git-send-email-akrowiak@linux.ibm.com>
        <20190618182558.7d7e025a.cohuck@redhat.com>
        <2366c6b6-fd9e-0c32-0e9d-018cd601a0ad@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 01 Jul 2019 19:27:00 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Jun 2019 09:04:18 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 6/18/19 12:25 PM, Cornelia Huck wrote:
> > On Thu, 13 Jun 2019 15:39:36 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >   
> >> Introduces a new driver callback to prevent a root user from unbinding
> >> an AP queue from its device driver if the queue is in use. This prevents
> >> a root user from inadvertently taking a queue away from a guest and
> >> giving it to the host, or vice versa. The callback will be invoked
> >> whenever a change to the AP bus's apmask or aqmask sysfs interfaces may
> >> result in one or more AP queues being removed from its driver. If the
> >> callback responds in the affirmative for any driver queried, the change
> >> to the apmask or aqmask will be rejected with a device in use error.
> >>
> >> For this patch, only non-default drivers will be queried. Currently,
> >> there is only one non-default driver, the vfio_ap device driver. The
> >> vfio_ap device driver manages AP queues passed through to one or more
> >> guests and we don't want to unexpectedly take AP resources away from
> >> guests which are most likely independently administered.
> >>
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >> ---
> >>   drivers/s390/crypto/ap_bus.c | 138 +++++++++++++++++++++++++++++++++++++++++--
> >>   drivers/s390/crypto/ap_bus.h |   3 +
> >>   2 files changed, 135 insertions(+), 6 deletions(-)  
> > 
> > Hm... I recall objecting to this patch before, fearing that it makes it
> > possible for a bad actor to hog resources that can't be removed by
> > root, even forcefully. (I have not had time to look at the intervening
> > versions, so I might be missing something.)
> > 
> > Is there a way for root to forcefully override this?  
> 
> You recall correctly; however, after many internal crypto team
> discussions, it was decided that this feature was important
> and should be kept.

That's the problem with internal discussions: they're internal :( Would
have been nice to have some summary of this in the changelog.

> 
> Allow me to first address your fear that a bad actor can hog
> resources that can't be removed by root. With this enhancement,
> there is nothing preventing a root user from taking resources
> from a matrix mdev, it simply forces him/her to follow the
> proper procedure. The resources to be removed must first be
> unassigned from the matrix mdev to which they are assigned.
> The AP bus's /sys/bus/ap/apmask and /sys/bus/ap/aqmask
> sysfs attributes can then be edited to transfer ownership
> of the resources to zcrypt.

What is the suggested procedure when root wants to unbind a queue
device? Find the mdev using the queue (is that easy enough?), unassign
it, then unbind? Failing to unbind is a bit unexpected; can we point
the admin to the correct mdev from which the queue has to be removed
first?

> 
> The rationale for keeping this feature is:
> 
> * It is a bad idea to steal an adapter in use from a guest. In the worst
>    case, the guest could end up without access to any crypto adapters
>    without knowing why. This could lead to performance issues on guests
>    that rely heavily on crypto such as guests used for blockchain
>    transactions.

Yanking adapters out from a running guest is not a good idea, yes; but
I see it more as a problem of the management layer. Performance issues
etc. are not something we want, obviously; but is removing access to
the adapter deadly, or can the guest keep limping along? (Does the
guest have any chance to find out that the adapter is gone? What
happens on an LPAR if an adapter is gone, maybe due to a hardware
failure?)

> 
> * There are plenty of examples in linux of the kernel preventing a root
>    user from performing a task. For example, a module can't be removed
>    if references are still held for it. 

In this case, removing the module would actively break/crash anything
relying on it; I'm not sure how analogous the situation is here (i.e.
can we limp on without the device?)

> Another example would be trying
>    to bind a CEX4 adapter to a device driver not registered for CEX4;
>    this action will also be rejected.

I don't think this one is analogous at all: The device driver can't
drive the device, so why should it be able to bind to it?

> 
> * The semantics are much cleaner and the logic is far less complicated.

This is actually the most convincing of the arguments, I think :) If we
need some really byzantine logic to allow unbinding, it's probably not
worth it.

> 
> * It forces the use of the proper procedure to change ownership of AP
>    queues.

This needs to be properly documented, and the admin needs to have a
chance to find out why unbinding didn't work and what needs to be done
(see my comments above).
