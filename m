Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447771C722A
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 15:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgEFNxH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 09:53:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34720 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725966AbgEFNxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 09:53:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588773186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jch60/8K2tSA67AtwLBrzD6Tb8I7e5RgTzc+4TjfepU=;
        b=gnWe6HhAJAAZDlN2eKFMV7GVFR1+xQpMGmWeUmqGBPz/CtIhgZ93bMXGUdIs0PZnQ0dBTj
        Y0r6vSd18ChuEcHF4Xudu3qnchupN6zM9b2MduqbtPvk7Cw6UIwOJtA8rSRPpH9iJ217jK
        SDa/1HxL2mKnU6ioDImucsE3N2bs8+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-QqblW9vcP16c8c1L94vUeA-1; Wed, 06 May 2020 09:53:04 -0400
X-MC-Unique: QqblW9vcP16c8c1L94vUeA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46DAE18FE863;
        Wed,  6 May 2020 13:53:03 +0000 (UTC)
Received: from gondolin (ovpn-112-211.ams2.redhat.com [10.36.112.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB73010013D9;
        Wed,  6 May 2020 13:53:01 +0000 (UTC)
Date:   Wed, 6 May 2020 15:52:59 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [PATCH v4 7/8] vfio-ccw: Wire up the CRW irq and CRW region
Message-ID: <20200506155259.4ec538e2.cohuck@redhat.com>
In-Reply-To: <20200505122745.53208-8-farman@linux.ibm.com>
References: <20200505122745.53208-1-farman@linux.ibm.com>
        <20200505122745.53208-8-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 May 2020 14:27:44 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> From: Farhan Ali <alifm@linux.ibm.com>
> 
> Use the IRQ to notify userspace that there is a CRW
> pending in the region, related to path-availability
> changes on the passthrough subchannel.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
> 
> Notes:
>     v3->v4:
>      - s/vfio_ccw_alloc_crw()/vfio_ccw_queue_crw()/ [CH]
>      - Remove cssid from crw that is built [CH]
>     
>     v2->v3:
>      - Refactor vfio_ccw_alloc_crw() to accept rsc, erc, and rsid fields
>        of a CRW as input [CH]
>      - Copy the right amount of CRWs to the crw_region [EF]
>      - Use sizeof(target) for the memcpy, rather than sizeof(source) [EF]
>      - Ensure the CRW region is empty if no CRW is present [EF/CH]
>      - Refactor how data goes from private-to-region-to-user [CH]
>      - Reduce the number of CRWs from two to one [CH]
>      - s/vc_crw/crw/ [EF]
>     
>     v1->v2:
>      - Remove extraneous 0x0 in crw.rsid assignment [CH]
>      - Refactor the building/queueing of a crw into its own routine [EF]
>     
>     v0->v1: [EF]
>      - Place the non-refactoring changes from the previous patch here
>      - Clean up checkpatch (whitespace) errors
>      - s/chp_crw/crw/
>      - Move acquire/release of io_mutex in vfio_ccw_crw_region_read()
>        into patch that introduces that region
>      - Remove duplicate include from vfio_ccw_drv.c
>      - Reorder include in vfio_ccw_private.h
> 
>  drivers/s390/cio/vfio_ccw_chp.c     | 17 ++++++++++
>  drivers/s390/cio/vfio_ccw_drv.c     | 49 +++++++++++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_private.h |  8 +++++
>  3 files changed, 74 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

