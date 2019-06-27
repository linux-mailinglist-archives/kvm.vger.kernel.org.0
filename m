Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B733A57D18
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 09:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfF0HZ3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 27 Jun 2019 03:25:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbfF0HZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 03:25:28 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AB95430820DD;
        Thu, 27 Jun 2019 07:25:27 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEB3B60856;
        Thu, 27 Jun 2019 07:25:20 +0000 (UTC)
Date:   Thu, 27 Jun 2019 09:25:18 +0200
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
Message-ID: <20190627092518.1f8d7d48.cohuck@redhat.com>
In-Reply-To: <44f13e89-2fb4-bf8c-7849-641aae8d08cc@linux.ibm.com>
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
        <1560454780-20359-4-git-send-email-akrowiak@linux.ibm.com>
        <20190618182558.7d7e025a.cohuck@redhat.com>
        <2366c6b6-fd9e-0c32-0e9d-018cd601a0ad@linux.ibm.com>
        <44f13e89-2fb4-bf8c-7849-641aae8d08cc@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 27 Jun 2019 07:25:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Jun 2019 17:13:50 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 6/19/19 9:04 AM, Tony Krowiak wrote:
> > On 6/18/19 12:25 PM, Cornelia Huck wrote:  
> >> On Thu, 13 Jun 2019 15:39:36 -0400
> >> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >>  
> >>> Introduces a new driver callback to prevent a root user from unbinding
> >>> an AP queue from its device driver if the queue is in use. This prevents
> >>> a root user from inadvertently taking a queue away from a guest and
> >>> giving it to the host, or vice versa. The callback will be invoked
> >>> whenever a change to the AP bus's apmask or aqmask sysfs interfaces may
> >>> result in one or more AP queues being removed from its driver. If the
> >>> callback responds in the affirmative for any driver queried, the change
> >>> to the apmask or aqmask will be rejected with a device in use error.
> >>>
> >>> For this patch, only non-default drivers will be queried. Currently,
> >>> there is only one non-default driver, the vfio_ap device driver. The
> >>> vfio_ap device driver manages AP queues passed through to one or more
> >>> guests and we don't want to unexpectedly take AP resources away from
> >>> guests which are most likely independently administered.
> >>>
> >>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >>> ---
> >>>   drivers/s390/crypto/ap_bus.c | 138 
> >>> +++++++++++++++++++++++++++++++++++++++++--
> >>>   drivers/s390/crypto/ap_bus.h |   3 +
> >>>   2 files changed, 135 insertions(+), 6 deletions(-)  
> >>
> >> Hm... I recall objecting to this patch before, fearing that it makes it
> >> possible for a bad actor to hog resources that can't be removed by
> >> root, even forcefully. (I have not had time to look at the intervening
> >> versions, so I might be missing something.)
> >>
> >> Is there a way for root to forcefully override this?  
> > 
> > You recall correctly; however, after many internal crypto team
> > discussions, it was decided that this feature was important
> > and should be kept.
> > 
> > Allow me to first address your fear that a bad actor can hog
> > resources that can't be removed by root. With this enhancement,
> > there is nothing preventing a root user from taking resources
> > from a matrix mdev, it simply forces him/her to follow the
> > proper procedure. The resources to be removed must first be
> > unassigned from the matrix mdev to which they are assigned.
> > The AP bus's /sys/bus/ap/apmask and /sys/bus/ap/aqmask
> > sysfs attributes can then be edited to transfer ownership
> > of the resources to zcrypt.
> > 
> > The rationale for keeping this feature is:
> > 
> > * It is a bad idea to steal an adapter in use from a guest. In the worst
> >    case, the guest could end up without access to any crypto adapters
> >    without knowing why. This could lead to performance issues on guests
> >    that rely heavily on crypto such as guests used for blockchain
> >    transactions.
> > 
> > * There are plenty of examples in linux of the kernel preventing a root
> >    user from performing a task. For example, a module can't be removed
> >    if references are still held for it. Another example would be trying
> >    to bind a CEX4 adapter to a device driver not registered for CEX4;
> >    this action will also be rejected.
> > 
> > * The semantics are much cleaner and the logic is far less complicated.
> > 
> > * It forces the use of the proper procedure to change ownership of AP
> >    queues.
> >  
> 
> Any feedback on this?

Had not yet time to look at this, sorry.


> 
> Tony K
> 
> >   
> >>  
> >   
> 

