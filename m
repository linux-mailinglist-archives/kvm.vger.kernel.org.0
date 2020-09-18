Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3678D26F8D7
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 11:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgIRJCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 05:02:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:53670 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbgIRJCj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 05:02:39 -0400
IronPort-SDR: jyocElTw0HWGHtrB4bHyUCNa23O6RIpC/xYQMveF7dCucCTuhYz+5wOhMe0hEwHVcJ47B1yTf4
 dTWfK7HpVdFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="159948290"
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="159948290"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 02:02:36 -0700
IronPort-SDR: oyWY9isB8TBrZh4ZlgH+lGhicGlrhOAlu1EnXrp577rcZOj/S+JlmkTMPZxzAWIv3dmKGo28Yc
 pKZpBmJf6H0g==
X-IronPort-AV: E=Sophos;i="5.77,274,1596524400"; 
   d="scan'208";a="484121407"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.252.42.33])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 02:02:33 -0700
Date:   Fri, 18 Sep 2020 11:02:29 +0200
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
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v7 3/3] vhost: add an RPMsg API
Message-ID: <20200918090229.GC19246@ubuntu>
References: <20200910111351.20526-1-guennadi.liakhovetski@linux.intel.com>
 <20200910111351.20526-4-guennadi.liakhovetski@linux.intel.com>
 <20200917220138.GA97950@xps15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917220138.GA97950@xps15>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mathieu,

On Thu, Sep 17, 2020 at 04:01:38PM -0600, Mathieu Poirier wrote:
> On Thu, Sep 10, 2020 at 01:13:51PM +0200, Guennadi Liakhovetski wrote:
> > Linux supports running the RPMsg protocol over the VirtIO transport
> > protocol, but currently there is only support for VirtIO clients and
> > no support for VirtIO servers. This patch adds a vhost-based RPMsg
> > server implementation, which makes it possible to use RPMsg over
> > VirtIO between guest VMs and the host.
> 
> I now get the client/server concept you are describing above but that happened
> only after a lot of mental gymnastics.  If you drop the whole client/server
> concept and concentrate on what this patch does, things will go better.  I would
> personally go with what you have in the Kconfig: 
> 
> > +	  Vhost RPMsg API allows vhost drivers to communicate with VirtIO
> > +	  drivers on guest VMs, using the RPMsg over VirtIO protocol.
> 
> It is concise but describes exactly what this patch provide.

Ok, thanks, will try to improve.

> > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > ---
> >  drivers/vhost/Kconfig       |   7 +
> >  drivers/vhost/Makefile      |   3 +
> >  drivers/vhost/rpmsg.c       | 370 ++++++++++++++++++++++++++++++++++++
> >  drivers/vhost/vhost_rpmsg.h |  74 ++++++++
> >  4 files changed, 454 insertions(+)
> >  create mode 100644 drivers/vhost/rpmsg.c
> >  create mode 100644 drivers/vhost/vhost_rpmsg.h
> > 
> > diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> > index 587fbae06182..ee1a19b7ab3d 100644
> > --- a/drivers/vhost/Kconfig
> > +++ b/drivers/vhost/Kconfig
> > @@ -38,6 +38,13 @@ config VHOST_NET
> >  	  To compile this driver as a module, choose M here: the module will
> >  	  be called vhost_net.
> >  
> > +config VHOST_RPMSG
> > +	tristate
> > +	select VHOST
> > +	help
> > +	  Vhost RPMsg API allows vhost drivers to communicate with VirtIO
> > +	  drivers on guest VMs, using the RPMsg over VirtIO protocol.
> > +
> 
> I suppose you intend this to be selectable from another config option?

yes.

> >  config VHOST_SCSI
> >  	tristate "VHOST_SCSI TCM fabric driver"
> >  	depends on TARGET_CORE && EVENTFD
> > diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> > index f3e1897cce85..9cf459d59f97 100644
> > --- a/drivers/vhost/Makefile
> > +++ b/drivers/vhost/Makefile
> > @@ -2,6 +2,9 @@
> >  obj-$(CONFIG_VHOST_NET) += vhost_net.o
> >  vhost_net-y := net.o
> >  
> > +obj-$(CONFIG_VHOST_RPMSG) += vhost_rpmsg.o
> > +vhost_rpmsg-y := rpmsg.o
> > +
> >  obj-$(CONFIG_VHOST_SCSI) += vhost_scsi.o
> >  vhost_scsi-y := scsi.o
> >  
> > diff --git a/drivers/vhost/rpmsg.c b/drivers/vhost/rpmsg.c
> > new file mode 100644
> > index 000000000000..0ddee5b5f017
> > --- /dev/null
> > +++ b/drivers/vhost/rpmsg.c
> > @@ -0,0 +1,370 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright(c) 2020 Intel Corporation. All rights reserved.
> > + *
> > + * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > + *
> > + * Vhost RPMsg VirtIO interface provides a set of functions to be used on the
> > + * host side as a counterpart to the guest side RPMsg VirtIO API, provided by
> > + * drivers/rpmsg/virtio_rpmsg_bus.c. This API can be used by any vhost driver to
> > + * handle RPMsg specific virtqueue processing.
> > + * Vhost drivers, using this API will use their own VirtIO device IDs, that
> > + * should then also be added to the ID table in virtio_rpmsg_bus.c
> > + */
> > +
> > +#include <linux/compat.h>
> > +#include <linux/file.h>
> > +#include <linux/miscdevice.h>
> 
> As far as I can tell the above two are not needed.

Look like left-over, will remove.

> > +#include <linux/module.h>
> > +#include <linux/mutex.h>
> > +#include <linux/rpmsg/virtio.h>
> > +#include <linux/vhost.h>
> > +#include <uapi/linux/rpmsg.h>
> > +
> > +#include "vhost.h"
> > +#include "vhost_rpmsg.h"
> > +
> > +/*
> > + * All virtio-rpmsg virtual queue kicks always come with just one buffer -
> > + * either input or output, but we can also handle split messages
> > + */
> > +static int vhost_rpmsg_get_msg(struct vhost_virtqueue *vq, unsigned int *cnt)
> > +{
> > +	struct vhost_rpmsg *vr = container_of(vq->dev, struct vhost_rpmsg, dev);
> > +	unsigned int out, in;
> > +	int head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov), &out, &in,
> > +				     NULL, NULL);
> > +	if (head < 0) {
> > +		vq_err(vq, "%s(): error %d getting buffer\n",
> > +		       __func__, head);
> > +		return head;
> > +	}
> > +
> > +	/* Nothing new? */
> > +	if (head == vq->num)
> > +		return head;
> > +
> > +	if (vq == &vr->vq[VIRTIO_RPMSG_RESPONSE]) {
> > +		if (out) {
> > +			vq_err(vq, "%s(): invalid %d output in response queue\n",
> > +			       __func__, out);
> > +			goto return_buf;
> > +		}
> > +
> > +		*cnt = in;
> > +	}
> > +
> > +	if (vq == &vr->vq[VIRTIO_RPMSG_REQUEST]) {
> > +		if (in) {
> > +			vq_err(vq, "%s(): invalid %d input in request queue\n",
> > +		       __func__, in);
> > +			goto return_buf;
> > +		}
> > +
> > +		*cnt = out;
> > +	}
> > +
> > +	return head;
> > +
> > +return_buf:
> > +	vhost_add_used(vq, head, 0);
> > +
> > +	return -EINVAL;
> > +}
> > +
> > +static const struct vhost_rpmsg_ept *vhost_rpmsg_ept_find(struct vhost_rpmsg *vr, int addr)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < vr->n_epts; i++)
> > +		if (vr->ept[i].addr == addr)
> > +			return vr->ept + i;
> > +
> > +	return NULL;
> > +}
> > +
> > +/*
> > + * if len < 0, then for reading a request, the complete virtual queue buffer
> > + * size is prepared, for sending a response, the length in the iterator is used
> > + */
> > +int vhost_rpmsg_start_lock(struct vhost_rpmsg *vr, struct vhost_rpmsg_iter *iter,
> > +			   unsigned int qid, ssize_t len)
> > +	__acquires(vq->mutex)
> > +{
> > +	struct vhost_virtqueue *vq = vr->vq + qid;
> > +	unsigned int cnt;
> > +	ssize_t ret;
> > +	size_t tmp;
> > +
> > +	if (qid >= VIRTIO_RPMSG_NUM_OF_VQS)
> > +		return -EINVAL;
> > +
> > +	iter->vq = vq;
> > +
> > +	mutex_lock(&vq->mutex);
> > +	vhost_disable_notify(&vr->dev, vq);
> > +
> > +	iter->head = vhost_rpmsg_get_msg(vq, &cnt);
> > +	if (iter->head == vq->num)
> > +		iter->head = -EAGAIN;
> > +
> > +	if (iter->head < 0) {
> > +		ret = iter->head;
> > +		goto unlock;
> > +	}
> > +
> > +	tmp = iov_length(vq->iov, cnt);
> > +	if (tmp < sizeof(iter->rhdr)) {
> > +		vq_err(vq, "%s(): size %zu too small\n", __func__, tmp);
> > +		ret = -ENOBUFS;
> > +		goto return_buf;
> > +	}
> > +
> > +	switch (qid) {
> > +	case VIRTIO_RPMSG_REQUEST:
> > +		if (len >= 0) {
> > +			if (tmp < sizeof(iter->rhdr) + len) {
> > +				ret = -ENOBUFS;
> > +				goto return_buf;
> > +			}
> > +
> > +			tmp = len + sizeof(iter->rhdr);
> > +		}
> > +
> > +		/* len is now the size of the payload */
> > +		iov_iter_init(&iter->iov_iter, WRITE, vq->iov, cnt, tmp);
> > +
> > +		/* Read the RPMSG header with endpoint addresses */
> > +		tmp = copy_from_iter(&iter->rhdr, sizeof(iter->rhdr), &iter->iov_iter);
> > +		if (tmp != sizeof(iter->rhdr)) {
> > +			vq_err(vq, "%s(): got %zu instead of %zu\n", __func__,
> > +			       tmp, sizeof(iter->rhdr));
> > +			ret = -EIO;
> > +			goto return_buf;
> > +		}
> > +
> > +		iter->ept = vhost_rpmsg_ept_find(vr, vhost32_to_cpu(vq, iter->rhdr.dst));
> > +		if (!iter->ept) {
> > +			vq_err(vq, "%s(): no endpoint with address %d\n",
> > +			       __func__, vhost32_to_cpu(vq, iter->rhdr.dst));
> > +			ret = -ENOENT;
> > +			goto return_buf;
> > +		}
> > +
> > +		/* Let the endpoint read the payload */
> > +		if (iter->ept->read) {
> > +			ret = iter->ept->read(vr, iter);
> > +			if (ret < 0)
> > +				goto return_buf;
> > +
> > +			iter->rhdr.len = cpu_to_vhost16(vq, ret);
> > +		} else {
> > +			iter->rhdr.len = 0;
> > +		}
> > +
> > +		/* Prepare for the response phase */
> > +		iter->rhdr.dst = iter->rhdr.src;
> > +		iter->rhdr.src = cpu_to_vhost32(vq, iter->ept->addr);
> 
> I'm a little puzzled here - what will the response look like?  And why is it
> prepared here?  From what I can see doing so introduces coupling with function
> handle_rpmsg_req_single().  I think confirmation of reception should be handled
> by endpoints rather than in the core. 

RPMsg always contain a header, so we keep the header in the iterator. If the 
caller wants to reply to the request, the easiest way to do that is to reuse the 
iterator. In that case obviously you have to swap source and destination 
addresses. This can be done either in the request handler of the API, or by the 
caller, or in the API response handler. It would be silly to have the user do 
that, that would be repeated code. But I agree, it's a bit unclean to modify the 
header before returning it to the user, without knowing, whether the user will 
use it, in which case it might be surprised to see most fields from the request 
unchanged and only addresses swapped. I'll move this to response with a check 
for a reused iterator.

> > +
> > +		break;
> > +	case VIRTIO_RPMSG_RESPONSE:
> > +		if (!iter->ept && iter->rhdr.dst != cpu_to_vhost32(vq, RPMSG_NS_ADDR)) {
> > +			/*
> > +			 * Usually the iterator is configured when processing a
> > +			 * message on the request queue, but it's also possible
> > +			 * to send a message on the response queue without a
> > +			 * preceding request, in that case the iterator must
> > +			 * contain source and destination addresses.
> > +			 */
> > +			iter->ept = vhost_rpmsg_ept_find(vr, vhost32_to_cpu(vq, iter->rhdr.src));
> > +			if (!iter->ept) {
> > +				ret = -ENOENT;
> > +				goto return_buf;
> > +			}
> > +		}
> > +
> > +		if (len >= 0) {
> > +			if (tmp < sizeof(iter->rhdr) + len) {
> > +				ret = -ENOBUFS;
> > +				goto return_buf;
> > +			}
> > +
> > +			iter->rhdr.len = cpu_to_vhost16(vq, len);
> > +			tmp = len + sizeof(iter->rhdr);
> > +		}
> > +
> > +		/* len is now the size of the payload */
> > +		iov_iter_init(&iter->iov_iter, READ, vq->iov, cnt, tmp);
> > +
> > +		/* Write the RPMSG header with endpoint addresses */
> > +		tmp = copy_to_iter(&iter->rhdr, sizeof(iter->rhdr), &iter->iov_iter);
> > +		if (tmp != sizeof(iter->rhdr)) {
> > +			ret = -EIO;
> > +			goto return_buf;
> > +		}
> > +
> > +		/* Let the endpoint write the payload */
> 
> I would specifically mention that namespace payloads are taken care of by
> vhost_rpmsg_ns_announce().  That makes it easier for people to connect the dots. 

Ok

> > +		if (iter->ept && iter->ept->write) {
> > +			ret = iter->ept->write(vr, iter);
> > +			if (ret < 0)
> > +				goto return_buf;
> > +		}
> > +
> > +		break;
> > +	}
> > +
> > +	return 0;
> > +
> > +return_buf:
> > +	vhost_add_used(vq, iter->head, 0);
> > +unlock:
> > +	vhost_enable_notify(&vr->dev, vq);
> > +	mutex_unlock(&vq->mutex);
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(vhost_rpmsg_start_lock);
> > +
> > +size_t vhost_rpmsg_copy(struct vhost_rpmsg *vr, struct vhost_rpmsg_iter *iter,
> > +			void *data, size_t size)
> > +{
> > +	/*
> > +	 * We could check for excess data, but copy_{to,from}_iter() don't do
> > +	 * that either
> > +	 */
> > +	if (iter->vq == vr->vq + VIRTIO_RPMSG_RESPONSE)
> > +		return copy_to_iter(data, size, &iter->iov_iter);
> > +
> > +	return copy_from_iter(data, size, &iter->iov_iter);
> > +}
> > +EXPORT_SYMBOL_GPL(vhost_rpmsg_copy);
> > +
> > +int vhost_rpmsg_finish_unlock(struct vhost_rpmsg *vr,
> > +			      struct vhost_rpmsg_iter *iter)
> > +	__releases(vq->mutex)
> > +{
> > +	if (iter->head >= 0)
> > +		vhost_add_used_and_signal(iter->vq->dev, iter->vq, iter->head,
> > +					  vhost16_to_cpu(iter->vq, iter->rhdr.len) +
> > +					  sizeof(iter->rhdr));
> > +
> > +	vhost_enable_notify(&vr->dev, iter->vq);
> > +	mutex_unlock(&iter->vq->mutex);
> > +
> > +	return iter->head;
> > +}
> > +EXPORT_SYMBOL_GPL(vhost_rpmsg_finish_unlock);
> > +
> > +/*
> > + * Return false to terminate the external loop only if we fail to obtain either
> > + * a request or a response buffer
> > + */
> > +static bool handle_rpmsg_req_single(struct vhost_rpmsg *vr,
> > +				    struct vhost_virtqueue *vq)
> > +{
> > +	struct vhost_rpmsg_iter iter;
> > +	int ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_REQUEST, -EINVAL);
> > +	if (!ret)
> > +		ret = vhost_rpmsg_finish_unlock(vr, &iter);
> > +	if (ret < 0) {
> > +		if (ret != -EAGAIN)
> > +			vq_err(vq, "%s(): RPMSG processing failed %d\n",
> > +			       __func__, ret);
> > +		return false;
> > +	}
> > +
> > +	if (!iter.ept->write)
> > +		return true;
> > +
> > +	ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_RESPONSE, -EINVAL);
> > +	if (!ret)
> > +		ret = vhost_rpmsg_finish_unlock(vr, &iter);
> > +	if (ret < 0) {
> > +		vq_err(vq, "%s(): RPMSG finalising failed %d\n", __func__, ret);
> > +		return false;
> > +	}
> 
> As I said before dealing with the "response" queue here seems to be introducing
> coupling with vhost_rpmsg_start_lock()...  Endpoints should be doing that.

Sorry, could you elaborate a bit, what do you mean by coupling?

> > +
> > +	return true;
> > +}
> > +
> > +static void handle_rpmsg_req_kick(struct vhost_work *work)
> > +{
> > +	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
> > +						  poll.work);
> > +	struct vhost_rpmsg *vr = container_of(vq->dev, struct vhost_rpmsg, dev);
> > +
> > +	while (handle_rpmsg_req_single(vr, vq))
> > +		;
> > +}
> > +
> > +/*
> > + * initialise two virtqueues with an array of endpoints,
> > + * request and response callbacks
> > + */
> > +void vhost_rpmsg_init(struct vhost_rpmsg *vr, const struct vhost_rpmsg_ept *ept,
> > +		      unsigned int n_epts)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(vr->vq); i++)
> > +		vr->vq_p[i] = &vr->vq[i];
> > +
> > +	/* vq[0]: host -> guest, vq[1]: host <- guest */
> > +	vr->vq[VIRTIO_RPMSG_REQUEST].handle_kick = handle_rpmsg_req_kick;
> > +	vr->vq[VIRTIO_RPMSG_RESPONSE].handle_kick = NULL;
> 
> The comment depicts vq[0] followed by vq[1] but the code initialise vq[1] before
> vq[0], which is wildly confusing.  At the very least this should be: 

Nobody should care which of those is 0 and which is 1 :-) But indeed you have a point, 
that the protocol isn't strictly request-response based, the host can also send 
messages to the guest without preceding requests. So, TX / RX should be a better fit.

> 
> 	vr->vq[VIRTIO_RPMSG_RESPONSE].handle_kick = NULL;
> 	vr->vq[VIRTIO_RPMSG_REQUEST].handle_kick = handle_rpmsg_req_kick;
> 
> And even better:
> 
>         /* See configuration of *vq_cbs[] in rpmsg_probe()  */
> 	vr->vq[VIRTIO_RPMSG_TX].handle_kick = NULL;
> 	vr->vq[VIRTIO_RPMSG_RX].handle_kick = handle_rpmsg_req_kick;
> 
> > +
> > +	vr->ept = ept;
> > +	vr->n_epts = n_epts;
> > +
> > +	vhost_dev_init(&vr->dev, vr->vq_p, VIRTIO_RPMSG_NUM_OF_VQS,
> > +		       UIO_MAXIOV, 0, 0, true, NULL);
> > +}
> > +EXPORT_SYMBOL_GPL(vhost_rpmsg_init);
> > +
> > +void vhost_rpmsg_destroy(struct vhost_rpmsg *vr)
> > +{
> > +	if (vhost_dev_has_owner(&vr->dev))
> > +		vhost_poll_flush(&vr->vq[VIRTIO_RPMSG_REQUEST].poll);
> > +
> > +	vhost_dev_cleanup(&vr->dev);
> > +}
> > +EXPORT_SYMBOL_GPL(vhost_rpmsg_destroy);
> > +
> > +/* send namespace */
> > +int vhost_rpmsg_ns_announce(struct vhost_rpmsg *vr, const char *name, unsigned int src)
> > +{
> > +	struct vhost_virtqueue *vq = &vr->vq[VIRTIO_RPMSG_RESPONSE];
> > +	struct vhost_rpmsg_iter iter = {
> > +		.rhdr = {
> > +			.src = 0,
> > +			.dst = cpu_to_vhost32(vq, RPMSG_NS_ADDR),
> > +		},
> > +	};
> > +	struct rpmsg_ns_msg ns = {
> > +		.addr = cpu_to_vhost32(vq, src),
> > +		.flags = cpu_to_vhost32(vq, RPMSG_NS_CREATE), /* for rpmsg_ns_cb() */
> > +	};
> 
> Here we have to assume the source can be found in the endpoints registered in
> vhost_rpmsg_init().  I would put a check to make sure that is the case and
> return an error otherwise. 

Ok, will do.

> > +	int ret = vhost_rpmsg_start_lock(vr, &iter, VIRTIO_RPMSG_RESPONSE, sizeof(ns));
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
> > index 000000000000..c020ea14cd16
> > --- /dev/null
> > +++ b/drivers/vhost/vhost_rpmsg.h
> > @@ -0,0 +1,74 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Copyright(c) 2020 Intel Corporation. All rights reserved.
> > + *
> > + * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > + */
> > +
> > +#ifndef VHOST_RPMSG_H
> > +#define VHOST_RPMSG_H
> > +
> > +#include <linux/rpmsg/virtio.h>
> > +#include <linux/uio.h>
> > +
> > +#include "vhost.h"
> > +
> > +/* RPMsg uses two VirtQueues: one for each direction */
> > +enum {
> > +	VIRTIO_RPMSG_RESPONSE,	/* RPMsg response (host->guest) buffers */
> > +	VIRTIO_RPMSG_REQUEST,	/* RPMsg request (guest->host) buffers */
> 
> As I said above things would be much clearer if this was VIRTIO_RPMSG_TX and
> VIRTIO_RPMSG_RX.

Ack.

> I won't be commenting on the mechanic needed to access and send information on
> the virtqueues as it is completely foreign to me.  Other than the above I think
> this is going somewhere. 

I'll wait for your clarifications about "coupling" and send a v8.

Thanks for the comments so far
Guennadi

> Thanks,
> Mathieu
> 
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
> > +#define VHOST_RPMSG_ITER(_vq, _src, _dst) {			\
> > +	.rhdr = {						\
> > +			.src = cpu_to_vhost32(_vq, _src),	\
> > +			.dst = cpu_to_vhost32(_vq, _dst),	\
> > +		},						\
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
> > 2.28.0
> > 
