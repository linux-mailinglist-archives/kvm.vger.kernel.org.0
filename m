Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1861E4C52
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 19:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391592AbgE0Rr0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 13:47:26 -0400
Received: from mga07.intel.com ([134.134.136.100]:43430 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391538AbgE0RrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 13:47:25 -0400
IronPort-SDR: siaeZtYU05vs7r/MS3AjfH0rZdZG6oJZcrfffxkrW+lsQL+phCW9mdxUV8UW2EBLMil9KZdVBn
 fqfT5p6hmbrA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 10:47:23 -0700
IronPort-SDR: cbARXuyMu88U02Fy3H2M/tcD0giSOJ6pFmBAG+1elt/OsAA3UlWF/LRVuP1RkN75VVoT32tuwJ
 NQVGQXNycHcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,442,1583222400"; 
   d="scan'208";a="414291584"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.252.42.249])
  by orsmga004.jf.intel.com with ESMTP; 27 May 2020 10:47:21 -0700
Date:   Wed, 27 May 2020 19:47:19 +0200
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH v2 5/5] vhost: add an RPMsg API
Message-ID: <20200527174719.GA4846@ubuntu>
References: <20200525144458.8413-1-guennadi.liakhovetski@linux.intel.com>
 <20200525144458.8413-6-guennadi.liakhovetski@linux.intel.com>
 <20200526205039.GA20104@xps15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526205039.GA20104@xps15>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mathieu,

On Tue, May 26, 2020 at 02:50:39PM -0600, Mathieu Poirier wrote:
> Hi Guennadi,
> 
> On Mon, May 25, 2020 at 04:44:58PM +0200, Guennadi Liakhovetski wrote:
> > Linux supports running the RPMsg protocol over the VirtIO transport
> > protocol, but currently there is only support for VirtIO clients and
> > no support for a VirtIO server. This patch adds a vhost-based RPMsg
> > server implementation.
> > 
> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > ---
> >  drivers/vhost/Kconfig       |   7 +
> >  drivers/vhost/Makefile      |   3 +
> >  drivers/vhost/rpmsg.c       | 372 ++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/vhost/vhost_rpmsg.h |  74 +++++++++
> >  4 files changed, 456 insertions(+)
> >  create mode 100644 drivers/vhost/rpmsg.c
> >  create mode 100644 drivers/vhost/vhost_rpmsg.h

[snip]

> > +/* send namespace */
> > +int vhost_rpmsg_ns_announce(struct vhost_rpmsg *vr, const char *name,
> > +			    unsigned int src)
> > +{
> > +	struct vhost_rpmsg_iter iter = {
> > +		.rhdr = {
> > +			.src = 0,
> > +			.dst = RPMSG_NS_ADDR,
> > +			.flags = RPMSG_NS_CREATE, /* rpmsg_recv_single() */
> > +		},
> > +	};
> > +	struct rpmsg_ns_msg ns = {
> > +		.addr = src,
> > +		.flags = RPMSG_NS_CREATE, /* for rpmsg_ns_cb() */
> > +	};
> 
> I think it would be worth mentioning that someone on the guest side needs to
> call register_virtio_device() with a vdev->id->device == VIRTIO_ID_RPMSG,
> something that will match that device to the virtio_ipc_driver.  Otherwise the
> connection between them is very difficult to establish.

In fact you don't want to use just one ID, as you add more drivers, using RPMsg 
over VirtIO, you'll add more IDs to the ID table in virtio_rpmsg_bus.c. I am 
adding a comment at the top of this file to explain that.

Thanks
Guennadi

> Aside from the checkpatch warning I already pointed out, I don't have much else.
> 
> Thanks,
> Mathieu
> 
> > +	int ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_RESPONSE,
> > +					 sizeof(ns));
> > +
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	strlcpy(ns.name, name, sizeof(ns.name));
> > +
> > +	ret = vhost_rpmsg_copy(vr, &iter, &ns, sizeof(ns));
> > +	if (ret != sizeof(ns))
> > +		vq_err(iter.vq, "%s(): added %d instead of %zu bytes\n",
> > +		       __func__, ret, sizeof(ns));
> > +
> > +	ret = vhost_rpmsg_finish_unlock(vr, &iter);
> > +	if (ret < 0)
> > +		vq_err(iter.vq, "%s(): namespace announcement failed: %d\n",
> > +		       __func__, ret);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(vhost_rpmsg_ns_announce);
> > +
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_AUTHOR("Intel, Inc.");
> > +MODULE_DESCRIPTION("Vhost RPMsg API");
> > diff --git a/drivers/vhost/vhost_rpmsg.h b/drivers/vhost/vhost_rpmsg.h
> > new file mode 100644
> > index 00000000..5248ac9
> > --- /dev/null
> > +++ b/drivers/vhost/vhost_rpmsg.h
> > @@ -0,0 +1,74 @@
> > +/* SPDX-License-Identifier: (GPL-2.0) */
> > +/*
> > + * Copyright(c) 2020 Intel Corporation. All rights reserved.
> > + *
> > + * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > + */
> > +
> > +#ifndef VHOST_RPMSG_H
> > +#define VHOST_RPMSG_H
> > +
> > +#include <linux/uio.h>
> > +#include <linux/virtio_rpmsg.h>
> > +
> > +#include "vhost.h"
> > +
> > +/* RPMsg uses two VirtQueues: one for each direction */
> > +enum {
> > +	VIRTIO_RPMSG_RESPONSE,	/* RPMsg response (host->guest) buffers */
> > +	VIRTIO_RPMSG_REQUEST,	/* RPMsg request (guest->host) buffers */
> > +	/* Keep last */
> > +	VIRTIO_RPMSG_NUM_OF_VQS,
> > +};
> > +
> > +struct vhost_rpmsg_ept;
> > +
> > +struct vhost_rpmsg_iter {
> > +	struct iov_iter iov_iter;
> > +	struct rpmsg_hdr rhdr;
> > +	struct vhost_virtqueue *vq;
> > +	const struct vhost_rpmsg_ept *ept;
> > +	int head;
> > +	void *priv;
> > +};
> > +
> > +struct vhost_rpmsg {
> > +	struct vhost_dev dev;
> > +	struct vhost_virtqueue vq[VIRTIO_RPMSG_NUM_OF_VQS];
> > +	struct vhost_virtqueue *vq_p[VIRTIO_RPMSG_NUM_OF_VQS];
> > +	const struct vhost_rpmsg_ept *ept;
> > +	unsigned int n_epts;
> > +};
> > +
> > +struct vhost_rpmsg_ept {
> > +	ssize_t (*read)(struct vhost_rpmsg *, struct vhost_rpmsg_iter *);
> > +	ssize_t (*write)(struct vhost_rpmsg *, struct vhost_rpmsg_iter *);
> > +	int addr;
> > +};
> > +
> > +static inline size_t vhost_rpmsg_iter_len(const struct vhost_rpmsg_iter *iter)
> > +{
> > +	return iter->rhdr.len;
> > +}
> > +
> > +#define VHOST_RPMSG_ITER(_src, _dst) {	\
> > +	.rhdr = {			\
> > +			.src = _src,	\
> > +			.dst = _dst,	\
> > +		},			\
> > +	}
> > +
> > +void vhost_rpmsg_init(struct vhost_rpmsg *vr, const struct vhost_rpmsg_ept *ept,
> > +		      unsigned int n_epts);
> > +void vhost_rpmsg_destroy(struct vhost_rpmsg *vr);
> > +int vhost_rpmsg_ns_announce(struct vhost_rpmsg *vr, const char *name,
> > +			    unsigned int src);
> > +int vhost_rpmsg_start_lock(struct vhost_rpmsg *vr,
> > +			   struct vhost_rpmsg_iter *iter,
> > +			   unsigned int qid, ssize_t len);
> > +size_t vhost_rpmsg_copy(struct vhost_rpmsg *vr, struct vhost_rpmsg_iter *iter,
> > +			void *data, size_t size);
> > +int vhost_rpmsg_finish_unlock(struct vhost_rpmsg *vr,
> > +			      struct vhost_rpmsg_iter *iter);
> > +
> > +#endif
> > -- 
> > 1.9.3
> > 
