Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419E43607AB
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 12:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhDOKwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 06:52:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232723AbhDOKwC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 15 Apr 2021 06:52:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618483899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YFOmbA884XrZZ5oHMkf1ZocMXy0qGfh+XrMYDn7cx7s=;
        b=VVRSROpENLxVQ5kQBDSy1sljc/0bq8NH4wn0CFEU284mXu4Cn+mHak4hzZS8m5S2DdFY6Q
        ux8aUYTPyr8o9+llvFnyzVZXKWB2Zp72olERS2iqtRuSwG50k1dyFaALQ2TMSGHo0Z5y86
        abjk0iaUtXD+TuBK4dCM87ZzCvkkSKs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-dB_vnz5tOuW8PNwqsE-1KA-1; Thu, 15 Apr 2021 06:51:37 -0400
X-MC-Unique: dB_vnz5tOuW8PNwqsE-1KA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 644466D581;
        Thu, 15 Apr 2021 10:51:35 +0000 (UTC)
Received: from gondolin (ovpn-113-158.ams2.redhat.com [10.36.113.158])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15F475C290;
        Thu, 15 Apr 2021 10:51:33 +0000 (UTC)
Date:   Thu, 15 Apr 2021 12:51:31 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v4 2/4] vfio-ccw: Check workqueue before doing START
Message-ID: <20210415125131.33065221.cohuck@redhat.com>
In-Reply-To: <20210413182410.1396170-3-farman@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
        <20210413182410.1396170-3-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Apr 2021 20:24:08 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> When an interrupt is received via the IRQ, the bulk of the work
> is stacked on a workqueue for later processing. Which means that
> a concurrent START or HALT/CLEAR operation (via the async_region)
> will race with this process and require some serialization.
> 
> Once we have all our locks acquired, let's just look to see if we're
> in a window where the process has been started from the IRQ, but not
> yet picked up by vfio-ccw to clean up an I/O. If there is, mark the
> request as BUSY so it can be redriven.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_fsm.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
> index 23e61aa638e4..92d638f10b27 100644
> --- a/drivers/s390/cio/vfio_ccw_fsm.c
> +++ b/drivers/s390/cio/vfio_ccw_fsm.c
> @@ -28,6 +28,11 @@ static int fsm_io_helper(struct vfio_ccw_private *private)
>  
>  	spin_lock_irqsave(sch->lock, flags);
>  
> +	if (work_pending(&private->io_work)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
>  	orb = cp_get_orb(&private->cp, (u32)(addr_t)sch, sch->lpm);
>  	if (!orb) {
>  		ret = -EIO;

I'm wondering what condition we can consider this situation equivalent
to. I'd say that the virtual version of the subchannel is basically
status pending already, even though userspace may not have retrieved
that information yet; so probably cc 1?

Following the code path further along, it seems we return -EBUSY both
for cc 1 and cc 2 conditions we receive from the device (i.e. they are
not distinguishable from userspace). I don't think we can change that,
as it is an existing API (QEMU maps -EBUSY to cc 2.) So this change
looks fine so far.

I'm wondering what we should do for hsch. We probably want to return
-EBUSY for a pending condition as well, if I read the PoP correctly...
the only problem is that QEMU seems to match everything to 0; but that
is arguably not the kernel's problem.

For clear, we obviously don't have busy conditions. Should we clean up
any pending conditions?

[It feels like we have discussed this before, but any information has
vanished from my cache :/]

