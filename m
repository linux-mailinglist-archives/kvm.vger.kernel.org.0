Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1747830A886
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 14:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbhBANUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 08:20:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52550 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231907AbhBANSs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 08:18:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612185441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=86zf3NE2wSQpzSpx9fkGWeypfvPmWZ5ookbkREpbY4A=;
        b=P04B9qjhtb+RcN/R4WfwR/gIhoTaU+/bFc8Wd4td+znKuZ0OsY6eDiLKof4ufToXA2zhnd
        Bk5hPKUXwZS9jPa1j78b4RpSOuN0MRpj/QAWrH8/pq+YCTiSbBXurww5LLQ6UoSbxe4Ott
        uk7M4LZRIIcF3HGzGImoOy1Wb/tXnrI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-Je11CXJ0NVOzvb6dzk6K0Q-1; Mon, 01 Feb 2021 08:17:20 -0500
X-MC-Unique: Je11CXJ0NVOzvb6dzk6K0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06C301005504;
        Mon,  1 Feb 2021 13:17:19 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34E0E5C1A3;
        Mon,  1 Feb 2021 13:17:15 +0000 (UTC)
Date:   Mon, 1 Feb 2021 14:17:12 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 7/9] vfio: iommu driver notify callback
Message-ID: <20210201141712.255725b7.cohuck@redhat.com>
In-Reply-To: <b7c5896d-d3f3-9dd2-15fa-a8137d56964c@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
        <1611939252-7240-8-git-send-email-steven.sistare@oracle.com>
        <20210129145719.1b6cbe9c@omen.home.shazbot.org>
        <b3260683-7c45-4648-3b4b-3c81fb5ff5f7@oracle.com>
        <20210201133440.001850f4.cohuck@redhat.com>
        <b7c5896d-d3f3-9dd2-15fa-a8137d56964c@oracle.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 1 Feb 2021 07:52:16 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 2/1/2021 7:34 AM, Cornelia Huck wrote:
> > On Sat, 30 Jan 2021 11:51:41 -0500
> > Steven Sistare <steven.sistare@oracle.com> wrote:
> >   
> >> On 1/29/2021 4:57 PM, Alex Williamson wrote:  
> >>> On Fri, 29 Jan 2021 08:54:10 -0800
> >>> Steve Sistare <steven.sistare@oracle.com> wrote:
> >>>     
> >>>> Define a vfio_iommu_driver_ops notify callback, for sending events to
> >>>> the driver.  Drivers are not required to provide the callback, and
> >>>> may ignore any events.  The handling of events is driver specific.
> >>>>
> >>>> Define the CONTAINER_CLOSE event, called when the container's file
> >>>> descriptor is closed.  This event signifies that no further state changes
> >>>> will occur via container ioctl's.
> >>>>
> >>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> >>>> ---
> >>>>  drivers/vfio/vfio.c  | 5 +++++
> >>>>  include/linux/vfio.h | 5 +++++
> >>>>  2 files changed, 10 insertions(+)

> >>>> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> >>>> index 38d3c6a..9642579 100644
> >>>> --- a/include/linux/vfio.h
> >>>> +++ b/include/linux/vfio.h
> >>>> @@ -57,6 +57,9 @@ extern int vfio_add_group_dev(struct device *dev,
> >>>>  extern void vfio_device_put(struct vfio_device *device);
> >>>>  extern void *vfio_device_data(struct vfio_device *device);
> >>>>  
> >>>> +/* events for the backend driver notify callback */
> >>>> +#define VFIO_DRIVER_NOTIFY_CONTAINER_CLOSE	1    
> >>>
> >>> We should use an enum for type checking.    
> >>
> >> Agreed.
> >> I see you changed the value to 0.  Do you want to reserve 0 for invalid-event?
> >> (I know, this is internal and can be changed).  Your call.  
> > 
> > I'm not sure what we would use an invalid-event event for... the type
> > checking provided by the enum should be enough?  
> 
> I should have described it as no-event or null-event.  It can be useful when
> initializing a struct member that stores an event, eg, last-event-received.

I think we could just use -1 for that. Anyway, easy to change if a need
comes up.

