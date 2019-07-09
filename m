Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2902563485
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 12:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfGIKtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 06:49:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60728 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbfGIKtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 06:49:33 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8AC7C369CC;
        Tue,  9 Jul 2019 10:49:32 +0000 (UTC)
Received: from gondolin (unknown [10.40.205.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B8118441C;
        Tue,  9 Jul 2019 10:49:23 +0000 (UTC)
Date:   Tue, 9 Jul 2019 12:49:20 +0200
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
Message-ID: <20190709124920.3a910dca.cohuck@redhat.com>
In-Reply-To: <c771961d-f840-fe8a-09b7-a11b39a74d4c@linux.ibm.com>
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
        <1560454780-20359-4-git-send-email-akrowiak@linux.ibm.com>
        <20190618182558.7d7e025a.cohuck@redhat.com>
        <2366c6b6-fd9e-0c32-0e9d-018cd601a0ad@linux.ibm.com>
        <20190701212643.0dd7d4ab.cohuck@redhat.com>
        <c771961d-f840-fe8a-09b7-a11b39a74d4c@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 09 Jul 2019 10:49:32 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 8 Jul 2019 10:27:11 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 7/1/19 3:26 PM, Cornelia Huck wrote:
> > On Wed, 19 Jun 2019 09:04:18 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >> Allow me to first address your fear that a bad actor can hog
> >> resources that can't be removed by root. With this enhancement,
> >> there is nothing preventing a root user from taking resources
> >> from a matrix mdev, it simply forces him/her to follow the
> >> proper procedure. The resources to be removed must first be
> >> unassigned from the matrix mdev to which they are assigned.
> >> The AP bus's /sys/bus/ap/apmask and /sys/bus/ap/aqmask
> >> sysfs attributes can then be edited to transfer ownership
> >> of the resources to zcrypt.  
> > 
> > What is the suggested procedure when root wants to unbind a queue
> > device? Find the mdev using the queue (is that easy enough?), unassign
> > it, then unbind? Failing to unbind is a bit unexpected; can we point
> > the admin to the correct mdev from which the queue has to be removed
> > first?  
> 
> The proper procedure is to first unassign the adapter, domain, or both
> from the mdev to which the APQN is assigned. The difficulty in finding
> the queue depends upon how many mdevs have been created. I would expect
> that an admin would keep records of who owns what, but in the case he or
> she doesn't, it would be a matter of printing out the matrix attribute
> of each mdev until you find the mdev to which the APQN is assigned.

Ok, so the information is basically available, if needed.

> The only means I know of for informing the admin to which mdev a given
> APQN is assigned is to log the error when it occurs. 

That might be helpful, if it's easy to do.

> I think Matt is
> also looking to provide query functions in the management tool on which
> he is currently working.

That also sounds helpful.

(...)

> >> * It forces the use of the proper procedure to change ownership of AP
> >>     queues.  
> > 
> > This needs to be properly documented, and the admin needs to have a
> > chance to find out why unbinding didn't work and what needs to be done
> > (see my comments above).  
> 
> I will create a section in the vfio-ap.txt document that comes with this
> patch set describing the proper procedure for unbinding queues. Of
> course, we'll make sure the official IBM doc also more thoroughly
> describes this.

+1 for good documentation.

With that, I don't really object to this change.
