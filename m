Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD22D259D0B
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 19:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgIARXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 13:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729429AbgIARX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 13:23:26 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98603C061245
        for <kvm@vger.kernel.org>; Tue,  1 Sep 2020 10:23:24 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 17so1176924pfw.9
        for <kvm@vger.kernel.org>; Tue, 01 Sep 2020 10:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BA7VyT9D2g57+Dcuw8cvEhh4rPTEMKU4wo81oxUGNrw=;
        b=OvOn4u1TJ9XxBQ3PYp7dmHRrqJz4+fpuqiMyyn8pXdcJ8aod2wuK2zZlnMJLFU1Mn9
         rhmv1EzNWGVxCGP0vU6zwGXj6SXUUg7GL7sbTDuxWDELzmewnrhv63N6993QtCVFRbgb
         mftWm3IEK0CXt/C9gpRx+wv/lLWh1AqE5KIVhV+T9e3iar+A/e7X1u5ASBC4m0pA4uTe
         eGRA/aeO/uXpmEmW9lJyaki9fY6d27bhBKEZ2V6nZMTrgAlfWAgQvn4GTqlGpvNW1AxF
         BR2Vy38HufFlolKA8F3cFtxoS3J6QouzrKMTDgDnYR2qNxSsRpZJ/6cFsZ/dsvL1sYDI
         vRMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BA7VyT9D2g57+Dcuw8cvEhh4rPTEMKU4wo81oxUGNrw=;
        b=SExPv8HbIDmcrTHk9VhvuHh/xonuqsWkKFS6Jfta/kJEWHXev9Rm14aUXpoG8BsVR0
         EAsAKu9YidwgOR1w3EM4tJPeInA32s6aBPrgSrE6SJSsOX3eoz5qoH5rL4Jmgg5mAFVn
         ecW8YyVj4p/fjvcd9Dm4Qkvh9L1RC9uc6oV3thX6/sb/aR0diRBIFBmi8Oka005HDfbN
         G31HrB50Q3BgLlzu1ncVBPpxKiR9P1zt76QLlrgaQVploqAOab8isD2rzL/+60Lm4vD6
         LCrHVHA+oduNXuDCy/Vi5p+RmiKyru4FVQMujuYDFePIpeX5Ey7vyiiUJabTotZg68Eq
         rPHA==
X-Gm-Message-State: AOAM5307JvOX1LCRIX5LOEh+j010sRydgXqTqcERyQKYygWjb7McvDhu
        VoTHdh1RqKhAaj+MeBCBG+3r2w==
X-Google-Smtp-Source: ABdhPJxUAVGeCOMo4byNQ79M0LPSNBvS9XO0DGrI9UK+kRY6p14NCFRr59olfsl+GpPeAEitDNmQuA==
X-Received: by 2002:aa7:8e86:0:b029:138:8ec9:6d05 with SMTP id a6-20020aa78e860000b02901388ec96d05mr2774996pfr.3.1598981004007;
        Tue, 01 Sep 2020 10:23:24 -0700 (PDT)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id u3sm2077107pjn.29.2020.09.01.10.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 10:23:23 -0700 (PDT)
Date:   Tue, 1 Sep 2020 11:23:21 -0600
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v6 2/4] rpmsg: move common structures and defines to
 headers
Message-ID: <20200901172321.GC236120@xps15>
References: <20200901151153.28111-1-guennadi.liakhovetski@linux.intel.com>
 <20200901151153.28111-3-guennadi.liakhovetski@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901151153.28111-3-guennadi.liakhovetski@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 01, 2020 at 05:11:51PM +0200, Guennadi Liakhovetski wrote:
> virtio_rpmsg_bus.c keeps RPMsg protocol structure declarations and
> common defines like the ones, needed for name-space announcements,
> internal. Move them to common headers instead.
> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>

I already reviewed this patch and added my RB to it.  Please carry it in your
next revision.

Thanks,
Mathieu

> ---
>  drivers/rpmsg/virtio_rpmsg_bus.c | 78 +-----------------------------
>  include/linux/rpmsg/virtio.h     | 83 ++++++++++++++++++++++++++++++++
>  include/uapi/linux/rpmsg.h       |  3 ++
>  3 files changed, 88 insertions(+), 76 deletions(-)
>  create mode 100644 include/linux/rpmsg/virtio.h
> 
> diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
> index 9006fc7f73d0..f39c426f9c5e 100644
> --- a/drivers/rpmsg/virtio_rpmsg_bus.c
> +++ b/drivers/rpmsg/virtio_rpmsg_bus.c
> @@ -19,6 +19,7 @@
>  #include <linux/mutex.h>
>  #include <linux/of_device.h>
>  #include <linux/rpmsg.h>
> +#include <linux/rpmsg/virtio.h>
>  #include <linux/scatterlist.h>
>  #include <linux/slab.h>
>  #include <linux/sched.h>
> @@ -27,6 +28,7 @@
>  #include <linux/virtio_ids.h>
>  #include <linux/virtio_config.h>
>  #include <linux/wait.h>
> +#include <uapi/linux/rpmsg.h>
>  
>  #include "rpmsg_internal.h"
>  
> @@ -70,58 +72,6 @@ struct virtproc_info {
>  	struct rpmsg_endpoint *ns_ept;
>  };
>  
> -/* The feature bitmap for virtio rpmsg */
> -#define VIRTIO_RPMSG_F_NS	0 /* RP supports name service notifications */
> -
> -/**
> - * struct rpmsg_hdr - common header for all rpmsg messages
> - * @src: source address
> - * @dst: destination address
> - * @reserved: reserved for future use
> - * @len: length of payload (in bytes)
> - * @flags: message flags
> - * @data: @len bytes of message payload data
> - *
> - * Every message sent(/received) on the rpmsg bus begins with this header.
> - */
> -struct rpmsg_hdr {
> -	__virtio32 src;
> -	__virtio32 dst;
> -	__virtio32 reserved;
> -	__virtio16 len;
> -	__virtio16 flags;
> -	u8 data[];
> -} __packed;
> -
> -/**
> - * struct rpmsg_ns_msg - dynamic name service announcement message
> - * @name: name of remote service that is published
> - * @addr: address of remote service that is published
> - * @flags: indicates whether service is created or destroyed
> - *
> - * This message is sent across to publish a new service, or announce
> - * about its removal. When we receive these messages, an appropriate
> - * rpmsg channel (i.e device) is created/destroyed. In turn, the ->probe()
> - * or ->remove() handler of the appropriate rpmsg driver will be invoked
> - * (if/as-soon-as one is registered).
> - */
> -struct rpmsg_ns_msg {
> -	char name[RPMSG_NAME_SIZE];
> -	__virtio32 addr;
> -	__virtio32 flags;
> -} __packed;
> -
> -/**
> - * enum rpmsg_ns_flags - dynamic name service announcement flags
> - *
> - * @RPMSG_NS_CREATE: a new remote service was just created
> - * @RPMSG_NS_DESTROY: a known remote service was just destroyed
> - */
> -enum rpmsg_ns_flags {
> -	RPMSG_NS_CREATE		= 0,
> -	RPMSG_NS_DESTROY	= 1,
> -};
> -
>  /**
>   * @vrp: the remote processor this channel belongs to
>   */
> @@ -134,27 +84,6 @@ struct virtio_rpmsg_channel {
>  #define to_virtio_rpmsg_channel(_rpdev) \
>  	container_of(_rpdev, struct virtio_rpmsg_channel, rpdev)
>  
> -/*
> - * We're allocating buffers of 512 bytes each for communications. The
> - * number of buffers will be computed from the number of buffers supported
> - * by the vring, upto a maximum of 512 buffers (256 in each direction).
> - *
> - * Each buffer will have 16 bytes for the msg header and 496 bytes for
> - * the payload.
> - *
> - * This will utilize a maximum total space of 256KB for the buffers.
> - *
> - * We might also want to add support for user-provided buffers in time.
> - * This will allow bigger buffer size flexibility, and can also be used
> - * to achieve zero-copy messaging.
> - *
> - * Note that these numbers are purely a decision of this driver - we
> - * can change this without changing anything in the firmware of the remote
> - * processor.
> - */
> -#define MAX_RPMSG_NUM_BUFS	(512)
> -#define MAX_RPMSG_BUF_SIZE	(512)
> -
>  /*
>   * Local addresses are dynamically allocated on-demand.
>   * We do not dynamically assign addresses from the low 1024 range,
> @@ -162,9 +91,6 @@ struct virtio_rpmsg_channel {
>   */
>  #define RPMSG_RESERVED_ADDRESSES	(1024)
>  
> -/* Address 53 is reserved for advertising remote services */
> -#define RPMSG_NS_ADDR			(53)
> -
>  static void virtio_rpmsg_destroy_ept(struct rpmsg_endpoint *ept);
>  static int virtio_rpmsg_send(struct rpmsg_endpoint *ept, void *data, int len);
>  static int virtio_rpmsg_sendto(struct rpmsg_endpoint *ept, void *data, int len,
> diff --git a/include/linux/rpmsg/virtio.h b/include/linux/rpmsg/virtio.h
> new file mode 100644
> index 000000000000..3ede1a4a68a3
> --- /dev/null
> +++ b/include/linux/rpmsg/virtio.h
> @@ -0,0 +1,83 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _LINUX_RPMSG_VIRTIO_H
> +#define _LINUX_RPMSG_VIRTIO_H
> +
> +#include <linux/mod_devicetable.h>
> +#include <linux/types.h>
> +#include <linux/virtio_types.h>
> +
> +/**
> + * struct rpmsg_hdr - common header for all rpmsg messages
> + * @src: source address
> + * @dst: destination address
> + * @reserved: reserved for future use
> + * @len: length of payload (in bytes)
> + * @flags: message flags
> + * @data: @len bytes of message payload data
> + *
> + * Every message sent(/received) on the rpmsg bus begins with this header.
> + */
> +struct rpmsg_hdr {
> +	__virtio32 src;
> +	__virtio32 dst;
> +	__virtio32 reserved;
> +	__virtio16 len;
> +	__virtio16 flags;
> +	u8 data[];
> +} __packed;
> +
> +/**
> + * struct rpmsg_ns_msg - dynamic name service announcement message
> + * @name: name of remote service that is published
> + * @addr: address of remote service that is published
> + * @flags: indicates whether service is created or destroyed
> + *
> + * This message is sent across to publish a new service, or announce
> + * about its removal. When we receive these messages, an appropriate
> + * rpmsg channel (i.e device) is created/destroyed. In turn, the ->probe()
> + * or ->remove() handler of the appropriate rpmsg driver will be invoked
> + * (if/as-soon-as one is registered).
> + */
> +struct rpmsg_ns_msg {
> +	char name[RPMSG_NAME_SIZE];
> +	__virtio32 addr;
> +	__virtio32 flags;
> +} __packed;
> +
> +/**
> + * enum rpmsg_ns_flags - dynamic name service announcement flags
> + *
> + * @RPMSG_NS_CREATE: a new remote service was just created
> + * @RPMSG_NS_DESTROY: a known remote service was just destroyed
> + */
> +enum rpmsg_ns_flags {
> +	RPMSG_NS_CREATE		= 0,
> +	RPMSG_NS_DESTROY	= 1,
> +};
> +
> +/*
> + * We're allocating buffers of 512 bytes each for communications. The
> + * number of buffers will be computed from the number of buffers supported
> + * by the vring, upto a maximum of 512 buffers (256 in each direction).
> + *
> + * Each buffer will have 16 bytes for the msg header and 496 bytes for
> + * the payload.
> + *
> + * This will utilize a maximum total space of 256KB for the buffers.
> + *
> + * We might also want to add support for user-provided buffers in time.
> + * This will allow bigger buffer size flexibility, and can also be used
> + * to achieve zero-copy messaging.
> + *
> + * Note that these numbers are purely a decision of this driver - we
> + * can change this without changing anything in the firmware of the remote
> + * processor.
> + */
> +#define MAX_RPMSG_NUM_BUFS	512
> +#define MAX_RPMSG_BUF_SIZE	512
> +
> +/* Address 53 is reserved for advertising remote services */
> +#define RPMSG_NS_ADDR		53
> +
> +#endif
> diff --git a/include/uapi/linux/rpmsg.h b/include/uapi/linux/rpmsg.h
> index e14c6dab4223..d669c04ef289 100644
> --- a/include/uapi/linux/rpmsg.h
> +++ b/include/uapi/linux/rpmsg.h
> @@ -24,4 +24,7 @@ struct rpmsg_endpoint_info {
>  #define RPMSG_CREATE_EPT_IOCTL	_IOW(0xb5, 0x1, struct rpmsg_endpoint_info)
>  #define RPMSG_DESTROY_EPT_IOCTL	_IO(0xb5, 0x2)
>  
> +/* The feature bitmap for virtio rpmsg */
> +#define VIRTIO_RPMSG_F_NS	0 /* RP supports name service notifications */
> +
>  #endif
> -- 
> 2.28.0
> 
