Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E625F155451
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 10:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgBGJMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 04:12:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29546 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726417AbgBGJMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 04:12:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581066750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5TyuWNZKysSSJUR/G19ReAR/3QYXehjLVxwZbgY9U6Y=;
        b=iTj+z13HyuriGopOnS0PGn+aqrbdhBTQzJFsbmBYsfRUzdRlDzxueC9vP0O3H+SRL+qHIo
        gIP83ren+vM5rp1JTGgIdVoIowhws9t+8ceaWUzggZU72fN5FTUmuoMeQH9U7FqD+rj7zQ
        IPGIxLokQsaP4MvOHou/kVbF9JlchdQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-LfKIYUCjP1ya2sl70pfFig-1; Fri, 07 Feb 2020 04:12:26 -0500
X-MC-Unique: LfKIYUCjP1ya2sl70pfFig-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBA6D8018A5;
        Fri,  7 Feb 2020 09:12:24 +0000 (UTC)
Received: from gondolin (ovpn-117-112.ams2.redhat.com [10.36.117.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F8AE60BF7;
        Fri,  7 Feb 2020 09:12:23 +0000 (UTC)
Date:   Fri, 7 Feb 2020 10:12:20 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/9] s390x/vfio-ccw: Channel Path Handling
Message-ID: <20200207101220.2d057f18.cohuck@redhat.com>
In-Reply-To: <20200206213825.11444-1-farman@linux.ibm.com>
References: <20200206213825.11444-1-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Feb 2020 22:38:16 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> Here is a new pass at the channel-path handling code for vfio-ccw.
> This was initially developed by Farhan Ali this past summer, and
> picked up by me.  For my own benefit/sanity, I made a small changelog
> in the commit message for each patch, describing the changes I've
> made to his original code beyond just rebasing to master, rather than
> a giant list appended here.
> 
> I had been encountering a host crash which I think was triggered by
> this code rather than existing within it.  I'd sent a potential fix
> for that separately, but need more diagnosis.  So while that is
> outstanding, I think I've gotten most (but probably not all) comments
> from v1 addressed within.
> 
> With this, and the corresponding QEMU series (to be posted momentarily),
> applied I am able to configure off/on a CHPID (for example, by issuing
> "chchp -c 0/1 xx" on the host), and the guest is able to see both the
> events and reflect the updated path masks in its structures.
> 
> For reasons that are hopefully obvious, issuing chchp within the guest
> only works for the logical vary.  Configuring it off/on does not work,
> which I think is fine.

Before I delve into this: While the basic architecture here (and in the
QEMU part) is still similar, you changed things like handling multiple
CRWs? That's at least the impression I got from a very high-level skim.

> 
> v1: https://lore.kernel.org/kvm/20191115025620.19593-1-farman@linux.ibm.com/
> 
> Eric Farman (4):
>   vfio-ccw: Refactor the unregister of the async regions
>   vfio-ccw: Refactor IRQ handlers
>   vfio-ccw: Add trace for CRW event
>   vfio-ccw: Remove inline get_schid() routine
> 
> Farhan Ali (5):
>   vfio-ccw: Introduce new helper functions to free/destroy regions
>   vfio-ccw: Register a chp_event callback for vfio-ccw
>   vfio-ccw: Introduce a new schib region
>   vfio-ccw: Introduce a new CRW region
>   vfio-ccw: Wire up the CRW irq and CRW region
> 
>  Documentation/s390/vfio-ccw.rst     |  31 ++++-
>  drivers/s390/cio/Makefile           |   2 +-
>  drivers/s390/cio/vfio_ccw_chp.c     | 136 ++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_drv.c     | 186 ++++++++++++++++++++++++++--
>  drivers/s390/cio/vfio_ccw_fsm.c     |   8 +-
>  drivers/s390/cio/vfio_ccw_ops.c     |  65 +++++++---
>  drivers/s390/cio/vfio_ccw_private.h |  16 +++
>  drivers/s390/cio/vfio_ccw_trace.c   |   1 +
>  drivers/s390/cio/vfio_ccw_trace.h   |  30 +++++
>  include/uapi/linux/vfio.h           |   3 +
>  include/uapi/linux/vfio_ccw.h       |  19 +++
>  11 files changed, 463 insertions(+), 34 deletions(-)
>  create mode 100644 drivers/s390/cio/vfio_ccw_chp.c
> 

