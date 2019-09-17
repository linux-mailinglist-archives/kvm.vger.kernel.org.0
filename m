Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E6DB4D6F
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 14:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfIQMHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 08:07:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbfIQMHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 08:07:36 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 20D9A30820C9;
        Tue, 17 Sep 2019 12:07:36 +0000 (UTC)
Received: from gondolin (dhcp-192-230.str.redhat.com [10.33.192.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F455100197A;
        Tue, 17 Sep 2019 12:07:22 +0000 (UTC)
Date:   Tue, 17 Sep 2019 14:07:20 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        pmorel@linux.ibm.com, freude@linux.ibm.com, tiwei.bie@intel.com,
        virtualization@lists.linux-foundation.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com, idos@mellanox.com,
        xiao.w.wang@intel.com, lingshan.zhu@intel.com
Subject: Re: [RFC PATCH 1/2] mdev: device id support
Message-ID: <20190917140720.3686e0cc.cohuck@redhat.com>
In-Reply-To: <20190912094012.29653-2-jasowang@redhat.com>
References: <20190912094012.29653-1-jasowang@redhat.com>
        <20190912094012.29653-2-jasowang@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 17 Sep 2019 12:07:36 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Sep 2019 17:40:11 +0800
Jason Wang <jasowang@redhat.com> wrote:

> Mdev bus only support vfio driver right now, so it doesn't implement
> match method. But in the future, we may add drivers other than vfio,
> one example is virtio-mdev[1] driver. This means we need to add device
> id support in bus match method to pair the mdev device and mdev driver
> correctly.

Sounds reasonable.

> 
> So this patch add id_table to mdev_driver and id for mdev parent, and
> implement the match method for mdev bus.
> 
> [1] https://lkml.org/lkml/2019/9/10/135
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c  |  2 +-
>  drivers/s390/cio/vfio_ccw_ops.c   |  2 +-
>  drivers/s390/crypto/vfio_ap_ops.c |  3 ++-
>  drivers/vfio/mdev/mdev_core.c     | 14 ++++++++++++--
>  drivers/vfio/mdev/mdev_driver.c   | 14 ++++++++++++++
>  drivers/vfio/mdev/mdev_private.h  |  1 +
>  drivers/vfio/mdev/vfio_mdev.c     |  6 ++++++
>  include/linux/mdev.h              |  6 +++++-
>  include/linux/mod_devicetable.h   |  6 ++++++
>  samples/vfio-mdev/mbochs.c        |  2 +-
>  samples/vfio-mdev/mdpy.c          |  2 +-
>  samples/vfio-mdev/mtty.c          |  2 +-
>  12 files changed, 51 insertions(+), 9 deletions(-)

(...)

The transformations of the vendor drivers and the new interface look
sane.

(...)

> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 5714fd35a83c..f1fc143df042 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -821,4 +821,10 @@ struct wmi_device_id {
>  	const void *context;
>  };
>  
> +/* MDEV */
> +

Maybe add some kerneldoc and give vfio as an example of what we're
matching here?

> +struct mdev_device_id {
> +	__u8 id;

I agree with the suggestion to rename this to 'class_id'.

> +};
> +
>  #endif /* LINUX_MOD_DEVICETABLE_H */
