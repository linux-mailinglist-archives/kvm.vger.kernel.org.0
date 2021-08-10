Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D093E7B8A
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 17:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239443AbhHJPBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 11:01:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30036 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242024AbhHJPBb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 11:01:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628607669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RTXz3ikSpV209MnT5rDr3f83EI1kiMwH0E1+MqiJoiI=;
        b=JxS6L892YV+I9zdIgJ8U+vG/KIWoZAl9hHw7O9lavbvMMd5Q1rKTyuF308enXUC26k36/I
        lABiktx3Ycuaynk3npcrX8lmJuijzfZeZR42xHYSztVJFYl6oSsUOIPIOuIGicchBdqD5w
        xgoL0p+jRYQPs7MrVoeccafZb/YzZYo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-gwEukTkBMOKq4Ilmjc8DwQ-1; Tue, 10 Aug 2021 11:01:04 -0400
X-MC-Unique: gwEukTkBMOKq4Ilmjc8DwQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1424801B3C;
        Tue, 10 Aug 2021 15:01:00 +0000 (UTC)
Received: from localhost (unknown [10.39.192.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5243219CBA;
        Tue, 10 Aug 2021 15:01:00 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Vineeth Vijayan <vneethv@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: s390 common I/O layer locking
In-Reply-To: <7d751173-09b2-f49e-13ac-a72129f36f74@linux.ibm.com>
Organization: Red Hat GmbH
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428190949.4360afb7.cohuck@redhat.com>
 <20210428172008.GV1370958@nvidia.com>
 <20210429135855.443b7a1b.cohuck@redhat.com>
 <20210429181347.GA3414759@nvidia.com>
 <20210430143140.378904bf.cohuck@redhat.com>
 <20210430171908.GD1370958@nvidia.com>
 <20210503125440.0acd7c1f.cohuck@redhat.com>
 <292442e8-3b1a-56c4-b974-05e8b358ba64@linux.ibm.com>
 <20210724132400.GA19006@lst.de>
 <7d751173-09b2-f49e-13ac-a72129f36f74@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 10 Aug 2021 17:00:58 +0200
Message-ID: <878s19wdhx.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 03 2021, Vineeth Vijayan <vneethv@linux.ibm.com> wrote:

> On 7/24/21 3:24 PM, Christoph Hellwig wrote:
>> On Tue, May 04, 2021 at 05:10:42PM +0200, Vineeth Vijayan wrote:
> ...snip...
>>> I just had a quick glance on the CIO layer drivers. And at first=20
>>> look, you
>>> are right.
>>> It looks likewe need modifications in the event callbacks (referring css
>>> here)
>>> Let me go thoughthis thoroughly and update.
>> Did this go anywhere?
> Hello Christoph,
>
> Thank you for this reminder. Also, my apologies for the slow reply; This=
=20
> was one of those item which really needed this reminder :-)
>
> Coming to the point, The event-callbacks=C2=A0 are under sch->lock, which=
 i=20
> think is the right thing to do. But i also agree on your feedback about=20
> the sch->driver accesses in the css_evaluate_known_subchannel() call. My=
=20
> first impression was to add them under device_lock(). As Conny=20
> mentioned, most of the drivers on the css-bus remained-stable during the=
=20
> lifetime of the devices, and we never got this racy scenario.=C2=A0 And t=
hen=20
> having this change with device_lock(), as you mentioned,this code-base=20
> would need significant change in the sch_event callbacks. I am not sure=20
> if there is a straight forward solution for this locking-issue
> scenario.

Hm, I may have lost my way in the code, but I think ->sch_event is
called _without_ the subchannel lock being held? It is only taken in
e.g. io_subchannel_sch_event.

->chp_event is called with the subchannel lock held, though.

>
> Currently, i am trying to see the "minimal" change i can work on on the=20
> event-callbacks and the css_evaluate_known_subchannel() call, to make=20
> sure that, this racy condition can never occur.
>
> Conny,
>
> Please do let me know if you think i am missing something here. I would=20
> like to concentrate more on the sch->driver() access scenario first and=20
> would like to see how it can have minimal impact on the event-callbacks.=
=20
> especially io_subchannel_sch_event.

Given that the code changing sch->driver holds the device lock, but not
the subchannel lock, you probably need to make sure that the device lock
is held? It has been some time since I've done more complicated work in
the common I/O layer, though, and I might be missing something.

