Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4445B1B2297
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 11:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgDUJYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 05:24:41 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25226 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726120AbgDUJYl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 05:24:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587461079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qO6ssvqEBM5SQj4OVLjUUnzTm6CbFu0uFAR4ov6Q/74=;
        b=BDDFsOSTiaLD0oFf+gYGilXP6ruGgh6U8QHwkaFT51ieEW+malW0jcokIgY5mHfACJEk+5
        mAjE/Xk5c9qjA9l+9qIn0+6IcUCFuqE+5NG87YgXxatknPvjm4TOCYoFGkhEErXwE+v6JQ
        q5aXBpZTUf1cgPwl98XbDViQO0x4qoc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-YXjLnV3jO9m0jbJBQ0bi8g-1; Tue, 21 Apr 2020 05:24:37 -0400
X-MC-Unique: YXjLnV3jO9m0jbJBQ0bi8g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DFAFA107ACC9;
        Tue, 21 Apr 2020 09:24:35 +0000 (UTC)
Received: from gondolin (ovpn-112-226.ams2.redhat.com [10.36.112.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78ACA60C87;
        Tue, 21 Apr 2020 09:24:34 +0000 (UTC)
Date:   Tue, 21 Apr 2020 11:24:31 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>
Subject: Re: [PATCH v3 4/8] vfio-ccw: Introduce a new schib region
Message-ID: <20200421112431.01440c58.cohuck@redhat.com>
In-Reply-To: <20200417023001.65006-5-farman@linux.ibm.com>
References: <20200417023001.65006-1-farman@linux.ibm.com>
        <20200417023001.65006-5-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Apr 2020 04:29:57 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> From: Farhan Ali <alifm@linux.ibm.com>
> 
> The schib region can be used by userspace to get the subchannel-
> information block (SCHIB) for the passthrough subchannel.
> This can be useful to get information such as channel path
> information via the SCHIB.PMCW fields.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
> 
> Notes:
>     v2->v3:
>      - Updated Copyright year and Authors [CH]
>      - Mention that schib region triggers a STSCH [CH]
>     
>     v1->v2:
>      - Add new region info to Documentation/s390/vfio-ccw.rst [CH]
>      - Add a block comment to struct ccw_schib_region [CH]
>     
>     v0->v1: [EF]
>      - Clean up checkpatch (#include, whitespace) errors
>      - Remove unnecessary includes from vfio_ccw_chp.c
>      - Add ret=-ENOMEM in error path for new region
>      - Add call to vfio_ccw_unregister_dev_regions() during error exit
>        path of vfio_ccw_mdev_open()
>      - New info on the module prologue
>      - Reorder cleanup of regions
> 
>  Documentation/s390/vfio-ccw.rst     | 19 +++++++-
>  drivers/s390/cio/Makefile           |  2 +-
>  drivers/s390/cio/vfio_ccw_chp.c     | 76 +++++++++++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_drv.c     | 20 ++++++++
>  drivers/s390/cio/vfio_ccw_ops.c     | 14 +++++-
>  drivers/s390/cio/vfio_ccw_private.h |  3 ++
>  include/uapi/linux/vfio.h           |  1 +
>  include/uapi/linux/vfio_ccw.h       | 10 ++++
>  8 files changed, 141 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/s390/cio/vfio_ccw_chp.c
> 

(...)

> +static ssize_t vfio_ccw_schib_region_read(struct vfio_ccw_private *private,
> +					  char __user *buf, size_t count,
> +					  loff_t *ppos)
> +{
> +	unsigned int i = VFIO_CCW_OFFSET_TO_INDEX(*ppos) - VFIO_CCW_NUM_REGIONS;
> +	loff_t pos = *ppos & VFIO_CCW_OFFSET_MASK;
> +	struct ccw_schib_region *region;
> +	int ret;
> +
> +	if (pos + count > sizeof(*region))
> +		return -EINVAL;
> +
> +	mutex_lock(&private->io_mutex);
> +	region = private->region[i].data;
> +
> +	if (cio_update_schib(private->sch)) {
> +		ret = -ENODEV;
> +		goto out;
> +	}
> +
> +	memcpy(region, &private->sch->schib, sizeof(*region));
> +
> +	if (copy_to_user(buf, (void *)region + pos, count)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	ret = count;
> +
> +out:
> +	mutex_unlock(&private->io_mutex);
> +	return ret;
> +}
> +
> +static ssize_t vfio_ccw_schib_region_write(struct vfio_ccw_private *private,
> +					   const char __user *buf, size_t count,
> +					   loff_t *ppos)
> +{
> +	return -EINVAL;
> +}

I'm wondering if we should make this callback optional (not in this patch).

> +
> +
> +static void vfio_ccw_schib_region_release(struct vfio_ccw_private *private,
> +					  struct vfio_ccw_region *region)
> +{
> +
> +}

Same here.

> +
> +const struct vfio_ccw_regops vfio_ccw_schib_region_ops = {
> +	.read = vfio_ccw_schib_region_read,
> +	.write = vfio_ccw_schib_region_write,
> +	.release = vfio_ccw_schib_region_release,
> +};

(...)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

