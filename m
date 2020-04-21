Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575FD1B2310
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 11:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728503AbgDUJl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 05:41:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40143 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728505AbgDUJl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 05:41:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587462084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lEXlke9LB42eG4wVKK1EcgMLhNao0p4p3nF8zOBMar4=;
        b=Uk7qPzte6AKkok79mqH+SXJcBEdXGkLWjZ9DQxc/oFghbmby/q5IWMCplpTnz8LP0hBnzB
        Ur3t5uTm9UH6DCOXNMAUqfOldWGXSCBgja9GYnPbKi5XanNhWKuG8Z0R0tqJm/0BFFELsR
        VRwX5PFBdc7+Y+Bi67qMVBfndrGFxVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-TZtJOQXoM2GOlP8zGsqPgQ-1; Tue, 21 Apr 2020 05:41:19 -0400
X-MC-Unique: TZtJOQXoM2GOlP8zGsqPgQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0901DB60;
        Tue, 21 Apr 2020 09:41:18 +0000 (UTC)
Received: from gondolin (ovpn-112-226.ams2.redhat.com [10.36.112.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38BDEA0988;
        Tue, 21 Apr 2020 09:41:17 +0000 (UTC)
Date:   Tue, 21 Apr 2020 11:41:14 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [PATCH v3 5/8] vfio-ccw: Introduce a new CRW region
Message-ID: <20200421114114.672f35a4.cohuck@redhat.com>
In-Reply-To: <20200417023001.65006-6-farman@linux.ibm.com>
References: <20200417023001.65006-1-farman@linux.ibm.com>
        <20200417023001.65006-6-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Apr 2020 04:29:58 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> From: Farhan Ali <alifm@linux.ibm.com>
> 
> This region provides a mechanism to pass Channel Report Word(s)
> that affect vfio-ccw devices, and need to be passed to the guest
> for its awareness and/or processing.
> 
> The base driver (see crw_collect_info()) provides space for two
> CRWs, as a subchannel event may have two CRWs chained together
> (one for the ssid, one for the subcahnnel).  All other CRWs will
> only occupy the first one.  Even though this support will also
> only utilize the first one, we'll provide space for two also.

This is no longer true?

> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
> 
> Notes:
>     v2->v3:
>      - Remove "if list-empty" check, since there's no list yet [EF]
>      - Reduce the CRW region to one fullword, instead of two [CH]
>     
>     v1->v2:
>      - Add new region info to Documentation/s390/vfio-ccw.rst [CH]
>      - Add a block comment to struct ccw_crw_region [CH]
>     
>     v0->v1: [EF]
>      - Clean up checkpatch (whitespace) errors
>      - Add ret=-ENOMEM in error path for new region
>      - Add io_mutex for region read (originally in last patch)
>      - Change crw1/crw2 to crw0/crw1
>      - Reorder cleanup of regions
> 
>  Documentation/s390/vfio-ccw.rst     | 16 +++++++++
>  drivers/s390/cio/vfio_ccw_chp.c     | 53 +++++++++++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_drv.c     | 20 +++++++++++
>  drivers/s390/cio/vfio_ccw_ops.c     |  4 +++
>  drivers/s390/cio/vfio_ccw_private.h |  3 ++
>  include/uapi/linux/vfio.h           |  1 +
>  include/uapi/linux/vfio_ccw.h       |  8 +++++
>  7 files changed, 105 insertions(+)
> 
> diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
> index 98832d95f395..3338551ef642 100644
> --- a/Documentation/s390/vfio-ccw.rst
> +++ b/Documentation/s390/vfio-ccw.rst
> @@ -247,6 +247,22 @@ This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_SCHIB.
>  Reading this region triggers a STORE SUBCHANNEL to be issued to the
>  associated hardware.
>  
> +vfio-ccw crw region
> +---------------------
> +
> +The vfio-ccw crw region is used to return Channel Report Word (CRW)
> +data to userspace::
> +
> +  struct ccw_crw_region {
> +         __u32 crw;
> +  } __packed;
> +
> +This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_CRW.
> +
> +Currently, space is provided for a single CRW. Handling of chained
> +CRWs (not implemented in vfio-ccw) can be accomplished by re-reading
> +the region for additional CRW data.

What about the following instead:

"Reading this region returns a CRW if one that is relevant for this
subchannel (e.g. one reporting changes in channel path state) is
pending, or all zeroes if not. If multiple CRWs are pending (including
possibly chained CRWs), reading this region again will return the next
one, until no more CRWs are pending and zeroes are returned. This is
similar to how STORE CHANNEL REPORT WORD works."

> +
>  vfio-ccw operation details
>  --------------------------
>  
> diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
> index 18f3b3e873a9..c1362aae61f5 100644
> --- a/drivers/s390/cio/vfio_ccw_chp.c
> +++ b/drivers/s390/cio/vfio_ccw_chp.c
> @@ -74,3 +74,56 @@ int vfio_ccw_register_schib_dev_regions(struct vfio_ccw_private *private)
>  					    VFIO_REGION_INFO_FLAG_READ,
>  					    private->schib_region);
>  }
> +
> +static ssize_t vfio_ccw_crw_region_read(struct vfio_ccw_private *private,
> +					char __user *buf, size_t count,
> +					loff_t *ppos)
> +{
> +	unsigned int i = VFIO_CCW_OFFSET_TO_INDEX(*ppos) - VFIO_CCW_NUM_REGIONS;
> +	loff_t pos = *ppos & VFIO_CCW_OFFSET_MASK;
> +	struct ccw_crw_region *region;
> +	int ret;
> +
> +	if (pos + count > sizeof(*region))
> +		return -EINVAL;
> +
> +	mutex_lock(&private->io_mutex);
> +	region = private->region[i].data;
> +
> +	if (copy_to_user(buf, (void *)region + pos, count))
> +		ret = -EFAULT;
> +	else
> +		ret = count;

I see that you implemented it a bit differently in patch 7, but I think
resetting crw to 0 immediately after the copy_to_user() is cleaner. It
also can be done in this patch already :)

> +
> +	mutex_unlock(&private->io_mutex);
> +	return ret;
> +}

(...)

> diff --git a/include/uapi/linux/vfio_ccw.h b/include/uapi/linux/vfio_ccw.h
> index 758bf214898d..faf57e691d4a 100644
> --- a/include/uapi/linux/vfio_ccw.h
> +++ b/include/uapi/linux/vfio_ccw.h
> @@ -44,4 +44,12 @@ struct ccw_schib_region {
>  	__u8 schib_area[SCHIB_AREA_SIZE];
>  } __packed;
>  
> +/*
> + * Used for returning Channel Report Word(s) to userspace.

s/Channel Report Word(s)/a Channel Report Word/ ?

> + * Note: this is controlled by a capability
> + */
> +struct ccw_crw_region {
> +	__u32 crw;
> +} __packed;
> +
>  #endif

