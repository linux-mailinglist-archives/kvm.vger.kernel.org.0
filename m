Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F0315D772
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 13:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgBNMc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 07:32:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36340 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726191AbgBNMc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 07:32:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581683547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LmDS4clyDJ/pZg4JqX8t00JuzFiC7SFMe0wQcKLR0qQ=;
        b=QiJSyM42dH2p508kVzQHv+g18BbJhR5KtcX7fnTcsqENAw8v7WqLcPOEwQbZWXYlRclWHj
        IgZf4TjpfAequ+q24ElyHKDFDWqH9JHakGfA/9eLlEIcbytJ9ZlbediNoQDZPITAnSLgiE
        Zz9s2fVnOV48YXm0XZQj+iEbgHV3AP8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-IvgBXc0_N_G8tVbvaWI0XQ-1; Fri, 14 Feb 2020 07:32:23 -0500
X-MC-Unique: IvgBXc0_N_G8tVbvaWI0XQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3163F8010E6;
        Fri, 14 Feb 2020 12:32:22 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CD8F5C1C3;
        Fri, 14 Feb 2020 12:32:20 +0000 (UTC)
Date:   Fri, 14 Feb 2020 13:32:18 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/9] vfio-ccw: Introduce a new schib region
Message-ID: <20200214133218.6841b81e.cohuck@redhat.com>
In-Reply-To: <20200206213825.11444-5-farman@linux.ibm.com>
References: <20200206213825.11444-1-farman@linux.ibm.com>
        <20200206213825.11444-5-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Feb 2020 22:38:20 +0100
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
>  Documentation/s390/vfio-ccw.rst     | 16 +++++-
>  drivers/s390/cio/Makefile           |  2 +-
>  drivers/s390/cio/vfio_ccw_chp.c     | 75 +++++++++++++++++++++++++++++
>  drivers/s390/cio/vfio_ccw_drv.c     | 20 ++++++++
>  drivers/s390/cio/vfio_ccw_ops.c     | 14 +++++-
>  drivers/s390/cio/vfio_ccw_private.h |  3 ++
>  include/uapi/linux/vfio.h           |  1 +
>  include/uapi/linux/vfio_ccw.h       | 10 ++++
>  8 files changed, 137 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/s390/cio/vfio_ccw_chp.c
> 
> diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
> index fca9c4f5bd9c..b805dc995fc8 100644
> --- a/Documentation/s390/vfio-ccw.rst
> +++ b/Documentation/s390/vfio-ccw.rst
> @@ -231,6 +231,19 @@ This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD.
>  
>  Currently, CLEAR SUBCHANNEL and HALT SUBCHANNEL use this region.
>  
> +vfio-ccw schib region
> +---------------------
> +
> +The vfio-ccw schib region is used to return Subchannel-Information
> +Block (SCHIB) data to userspace::
> +
> +  struct ccw_schib_region {
> +  #define SCHIB_AREA_SIZE 52
> +         __u8 schib_area[SCHIB_AREA_SIZE];
> +  } __packed;
> +
> +This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_SCHIB.

Also mention that reading this triggers a stsch() updating the schib?

> +
>  vfio-ccw operation details
>  --------------------------
>  

(...)

> diff --git a/drivers/s390/cio/vfio_ccw_chp.c b/drivers/s390/cio/vfio_ccw_chp.c
> new file mode 100644
> index 000000000000..826d08379fe3
> --- /dev/null
> +++ b/drivers/s390/cio/vfio_ccw_chp.c
> @@ -0,0 +1,75 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Channel path related status regions for vfio_ccw
> + *
> + * Copyright IBM Corp. 2019

Should the year be updated?

> + *
> + * Author(s): Farhan Ali <alifm@linux.ibm.com>
> + */

(...)

