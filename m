Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19FE3D6EAA
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 08:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbhG0GE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 02:04:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53091 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235512AbhG0GE0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 02:04:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627365867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M/b1lAkx30VoYdGCq4rZeKdpDBbSV2MTh3TK7cbWaIY=;
        b=Xe7MOXFkhKJj3M3hcVnXhOzL1lUS1iMlSR3CWYw3gMZvvtqT/Dz3zInyV98nrwIcOHgr0i
        kIMxvzK6mPMfJLnyZxOfclp3hKLCtGTnIXDa3loGFXzryAqVpr/qlrZzrgqkpAA15NVnVW
        WL4dlKjJd1/+zFi9qwATtfMZWwKk154=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-de9TROPlNBiBNCLvs915UQ-1; Tue, 27 Jul 2021 02:04:23 -0400
X-MC-Unique: de9TROPlNBiBNCLvs915UQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7D5B801AE7;
        Tue, 27 Jul 2021 06:04:21 +0000 (UTC)
Received: from localhost (unknown [10.39.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 91390687D5;
        Tue, 27 Jul 2021 06:04:17 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] vfio/mdev: don't warn if ->request is not set
In-Reply-To: <20210726172831.3a7978fd.alex.williamson@redhat.com>
Organization: Red Hat GmbH
References: <20210726143524.155779-1-hch@lst.de>
 <20210726143524.155779-3-hch@lst.de> <87zgu93sxz.fsf@redhat.com>
 <20210726230906.GD1721383@nvidia.com>
 <20210726172831.3a7978fd.alex.williamson@redhat.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 27 Jul 2021 08:04:16 +0200
Message-ID: <87wnpc47j3.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26 2021, Alex Williamson <alex.williamson@redhat.com> wrote:

> On Mon, 26 Jul 2021 20:09:06 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Mon, Jul 26, 2021 at 07:07:04PM +0200, Cornelia Huck wrote:
>> 
>> > But I wonder why nobody else implements this? Lack of surprise removal?  
>> 
>> The only implementation triggers an eventfd that seems to be the same
>> eventfd as the interrupt..
>> 
>> Do you know how this works in userspace? I'm surprised that the
>> interrupt eventfd can trigger an observation that the kernel driver
>> wants to be unplugged?
>
> I think we're talking about ccw, but I see QEMU registering separate
> eventfds for each of the 3 IRQ indexes and the mdev driver specifically
> triggering the req_trigger...?  Thanks,
>
> Alex

Exactly, ccw has a trigger for normal I/O interrupts, CRW (machine
checks), and this one.

