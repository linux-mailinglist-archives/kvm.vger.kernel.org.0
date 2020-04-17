Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0E91ADB0E
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 12:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbgDQK3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 06:29:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35585 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728830AbgDQK3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 06:29:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587119354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zK2YsvHjFIO0HB3Koh2wx+03KhpSw6aghm7b3C0ordc=;
        b=fQQ9sNv2o7NXfJdZMyK+zEjEgKydDXm3bi2F8vfBSdM5BE7BzZvsxwF27PwHfixBhDul1c
        nQJm2Ak8ZNnQtsaMnxBsVb9vhgfZ54baFHdsbWuOsKU7jSm5w58jUn8aTgovV/zCeeGJzJ
        5pHURmBVqIVlQiCQu/11JVOLMhBXAjk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-C93oK_54Py-p34FY_Y2ESA-1; Fri, 17 Apr 2020 06:29:13 -0400
X-MC-Unique: C93oK_54Py-p34FY_Y2ESA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E634E800D53;
        Fri, 17 Apr 2020 10:29:11 +0000 (UTC)
Received: from gondolin (ovpn-112-200.ams2.redhat.com [10.36.112.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76698289A3;
        Fri, 17 Apr 2020 10:29:10 +0000 (UTC)
Date:   Fri, 17 Apr 2020 12:29:07 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [PATCH v3 2/8] vfio-ccw: Register a chp_event callback for
 vfio-ccw
Message-ID: <20200417122907.034c8508.cohuck@redhat.com>
In-Reply-To: <20200417023001.65006-3-farman@linux.ibm.com>
References: <20200417023001.65006-1-farman@linux.ibm.com>
        <20200417023001.65006-3-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Apr 2020 04:29:55 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> From: Farhan Ali <alifm@linux.ibm.com>
> 
> Register the chp_event callback to receive channel path related
> events for the subchannels managed by vfio-ccw.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
> 
> Notes:
>     v2->v3:
>      - Add a call to cio_cancel_halt_clear() for CHP_VARY_OFF [CH]
>     
>     v1->v2:
>      - Move s390dbf before cio_update_schib() call [CH]
>     
>     v0->v1: [EF]
>      - Add s390dbf trace
> 
>  drivers/s390/cio/vfio_ccw_drv.c | 45 +++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 8715c1c2f1e1..e48967c475e7 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -19,6 +19,7 @@
>  
>  #include <asm/isc.h>
>  
> +#include "chp.h"
>  #include "ioasm.h"
>  #include "css.h"
>  #include "vfio_ccw_private.h"
> @@ -262,6 +263,49 @@ static int vfio_ccw_sch_event(struct subchannel *sch, int process)
>  	return rc;
>  }
>  
> +static int vfio_ccw_chp_event(struct subchannel *sch,
> +			      struct chp_link *link, int event)
> +{
> +	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
> +	int mask = chp_ssd_get_mask(&sch->ssd_info, link);
> +	int retry = 255;
> +
> +	if (!private || !mask)
> +		return 0;
> +
> +	VFIO_CCW_MSG_EVENT(2, "%pUl (%x.%x.%04x): mask=0x%x event=%d\n",
> +			   mdev_uuid(private->mdev), sch->schid.cssid,
> +			   sch->schid.ssid, sch->schid.sch_no,
> +			   mask, event);
> +
> +	if (cio_update_schib(sch))
> +		return -ENODEV;
> +
> +	switch (event) {
> +	case CHP_VARY_OFF:
> +		/* Path logically turned off */
> +		sch->opm &= ~mask;
> +		sch->lpm &= ~mask;
> +		cio_cancel_halt_clear(sch, &retry);
> +		break;
> +	case CHP_OFFLINE:
> +		/* Path is gone */
> +		cio_cancel_halt_clear(sch, &retry);

Looking at this again: While calling the same function for both
CHP_VARY_OFF and CHP_OFFLINE is the right thing to do,
cio_cancel_halt_clear() is probably not that function. I don't think we
want to terminate an I/O that does not use the affected path.

Looking at what the normal I/O subchannel driver does, it first checks
for the lpum and does not do anything if the affected path does not
show up there. Following down the git history rabbit hole, that basic
check (surviving several reworks) precedes the first git import, so
there's unfortunately no patch description explaining that. Looking at
the PoP, I cannot find a whole lot of details... I think some of the
path-handling stuff is explained in non-public documentation, and
whoever wrote the original code (probably me) relied on the information
there.

tl;dr: We probably should check the lpum here as well.

> +		break;
> +	case CHP_VARY_ON:
> +		/* Path logically turned on */
> +		sch->opm |= mask;
> +		sch->lpm |= mask;
> +		break;
> +	case CHP_ONLINE:
> +		/* Path became available */
> +		sch->lpm |= mask & sch->opm;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
>  static struct css_device_id vfio_ccw_sch_ids[] = {
>  	{ .match_flags = 0x1, .type = SUBCHANNEL_TYPE_IO, },
>  	{ /* end of list */ },
> @@ -279,6 +323,7 @@ static struct css_driver vfio_ccw_sch_driver = {
>  	.remove = vfio_ccw_sch_remove,
>  	.shutdown = vfio_ccw_sch_shutdown,
>  	.sch_event = vfio_ccw_sch_event,
> +	.chp_event = vfio_ccw_chp_event,
>  };
>  
>  static int __init vfio_ccw_debug_init(void)

