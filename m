Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6836200800
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 13:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731794AbgFSLkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 07:40:17 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44278 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731501AbgFSLkP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 07:40:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592566814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z77TS/LJ6vJkiK4iQM9yFBovLkLZxtIwofZz9fNlivs=;
        b=HTGDjd7U13Jk1KIOi3/+qIYs7lSPr8REKYscFg+PugO5/yMpRZn8Ix8o4x+jboPA5nQ6a7
        82RxYT+iAdFKC4usym8Mci4LAYuLUYtgNUoUScEh+z1wEbGAz5scb4G3tL0IfsCppRe1iO
        ZTWRSbV2kmrMMRZWT4XM/X/XTC2jhJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-i93rwnIIOB6D-CxrGiSjww-1; Fri, 19 Jun 2020 07:40:10 -0400
X-MC-Unique: i93rwnIIOB6D-CxrGiSjww-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AD0991137;
        Fri, 19 Jun 2020 11:40:09 +0000 (UTC)
Received: from gondolin (ovpn-112-224.ams2.redhat.com [10.36.112.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CF74100238D;
        Fri, 19 Jun 2020 11:40:07 +0000 (UTC)
Date:   Fri, 19 Jun 2020 13:40:05 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Jared Rossi <jrossi@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v3 3/3] vfio-ccw: Check workqueue before doing START
Message-ID: <20200619134005.512fc54f.cohuck@redhat.com>
In-Reply-To: <20200616195053.99253-4-farman@linux.ibm.com>
References: <20200616195053.99253-1-farman@linux.ibm.com>
        <20200616195053.99253-4-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Jun 2020 21:50:53 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> When an interrupt is received via the IRQ, the bulk of the work is
> stacked on a workqueue for later processing. Which means that concurrent
> START or a HALT/CLEAR operation (via the async_region) will race with
> this process and require some serialization.
> 
> Once we have all our locks acquired, let's just look to see if we're
> in a window where the process has been started from the IRQ, but not
> yet picked up by vfio-ccw to clean up an I/O. If there is, mark the
> request as BUSY so it can be redriven after we have a chance to breathe.

This change looks reasonable to me. It would be even better if we could
send off I/O requests at any time; but if signaling to retry saves us
from some hairy code elsewhere, it is a good idea to do so.

> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_fsm.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_fsm.c b/drivers/s390/cio/vfio_ccw_fsm.c
> index f0952192480e..9dc5b4d549b3 100644
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

