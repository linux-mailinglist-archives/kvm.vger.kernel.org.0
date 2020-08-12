Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81E724295E
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 14:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgHLMcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 08:32:52 -0400
Received: from mga03.intel.com ([134.134.136.65]:51214 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726804AbgHLMcv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 08:32:51 -0400
IronPort-SDR: xfM1Tm9T11saCvjDpYQrhlUWoNTqJ+sytjCWwpZ3P5fPS/rAnE55JWS4MH6uU8/bqgTewUlUbP
 N6jIt9Se3wiQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9710"; a="153907875"
X-IronPort-AV: E=Sophos;i="5.76,304,1592895600"; 
   d="scan'208";a="153907875"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 05:32:47 -0700
IronPort-SDR: /W7XD7ZS/6G2PpZZmIUqx8pB0QWtqug4zNBIm16cjFH9lXHAjKxyFY/YbSbZA0f4EetlxIAuDv
 7lY7s/x3d+Ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,304,1592895600"; 
   d="scan'208";a="295051168"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.249.45.3])
  by orsmga006.jf.intel.com with ESMTP; 12 Aug 2020 05:32:44 -0700
Date:   Wed, 12 Aug 2020 14:32:43 +0200
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH v4 4/4] vhost: add an RPMsg API
Message-ID: <20200812123243.GA10218@ubuntu>
References: <20200722150927.15587-1-guennadi.liakhovetski@linux.intel.com>
 <20200722150927.15587-5-guennadi.liakhovetski@linux.intel.com>
 <20200804102132-mutt-send-email-mst@kernel.org>
 <20200804151916.GC19025@ubuntu>
 <20200810094013-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810094013-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Michael,

Thanks for a review.

On Mon, Aug 10, 2020 at 09:44:15AM -0400, Michael S. Tsirkin wrote:
> On Tue, Aug 04, 2020 at 05:19:17PM +0200, Guennadi Liakhovetski wrote:
> > On Tue, Aug 04, 2020 at 10:27:08AM -0400, Michael S. Tsirkin wrote:
> > > On Wed, Jul 22, 2020 at 05:09:27PM +0200, Guennadi Liakhovetski wrote:
> > > > Linux supports running the RPMsg protocol over the VirtIO transport
> > > > protocol, but currently there is only support for VirtIO clients and
> > > > no support for a VirtIO server. This patch adds a vhost-based RPMsg
> > > > server implementation.
> > > > 
> > > > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > > ---
> > > >  drivers/vhost/Kconfig       |   7 +
> > > >  drivers/vhost/Makefile      |   3 +
> > > >  drivers/vhost/rpmsg.c       | 375 ++++++++++++++++++++++++++++++++++++
> > > >  drivers/vhost/vhost_rpmsg.h |  74 +++++++
> > > >  4 files changed, 459 insertions(+)
> > > >  create mode 100644 drivers/vhost/rpmsg.c
> > > >  create mode 100644 drivers/vhost/vhost_rpmsg.h
> > > > 
> > > > diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> > > > index d3688c6afb87..602421bf1d03 100644
> > > > --- a/drivers/vhost/Kconfig
> > > > +++ b/drivers/vhost/Kconfig
> > > > @@ -38,6 +38,13 @@ config VHOST_NET
> > > >  	  To compile this driver as a module, choose M here: the module will
> > > >  	  be called vhost_net.
> > > >  
> > > > +config VHOST_RPMSG
> > > > +	tristate
> > > 
> > > So this lacks a description line so it does not appear
> > > in menuconfig. How is user supposed to set it?
> > > I added a one-line description.
> > 
> > That was on purpose. I don't think there's any value in this API stand-alone, 
> > so I let users select it as needed. But we can change that too, id desired.
> 
> I guess the patches actually selecting this 
> are separate then?

Yes, I posted them here before for reference 
https://www.spinics.net/lists/linux-remoteproc/msg06355.html

> > > > +	depends on VHOST
> > > 
> > > Other drivers select VHOST instead. Any reason not to
> > > do it like this here?
> > 
> > I have
> > 
> > +	select VHOST
> > +	select VHOST_RPMSG
> > 
> > in my client driver patch.
> 
> Any issues selecting from here so others get it for free?
> If this is selected then dependencies are ignored ...

I wasn't sure whether "select" works recursively, but looks like it does,
can do then, sure.

> > > > +	help
> > > > +	  Vhost RPMsg API allows vhost drivers to communicate with VirtIO
> > > > +	  drivers, using the RPMsg over VirtIO protocol.
> > > > +
> > > 
> > > >  config VHOST_SCSI
> > > >  	tristate "VHOST_SCSI TCM fabric driver"
> > > >  	depends on TARGET_CORE && EVENTFD
> > > > diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> > > > index f3e1897cce85..9cf459d59f97 100644
> > > > --- a/drivers/vhost/Makefile
> > > > +++ b/drivers/vhost/Makefile
> > > > @@ -2,6 +2,9 @@
> > > >  obj-$(CONFIG_VHOST_NET) += vhost_net.o
> > > >  vhost_net-y := net.o
> > > >  
> > > > +obj-$(CONFIG_VHOST_RPMSG) += vhost_rpmsg.o
> > > > +vhost_rpmsg-y := rpmsg.o
> > > > +
> > > >  obj-$(CONFIG_VHOST_SCSI) += vhost_scsi.o
> > > >  vhost_scsi-y := scsi.o
> > > >  
> > > > diff --git a/drivers/vhost/rpmsg.c b/drivers/vhost/rpmsg.c
> > > > new file mode 100644
> > > > index 000000000000..d7ab48414224
> > > > --- /dev/null
> > > > +++ b/drivers/vhost/rpmsg.c
> > > > @@ -0,0 +1,375 @@
> > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > +/*
> > > > + * Copyright(c) 2020 Intel Corporation. All rights reserved.
> > > > + *
> > > > + * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > > + *
> > > > + * Vhost RPMsg VirtIO interface. It provides a set of functions to match the
> > > > + * guest side RPMsg VirtIO API, provided by drivers/rpmsg/virtio_rpmsg_bus.c
> > > > + * These functions handle creation of 2 virtual queues, handling of endpoint
> > > > + * addresses, sending a name-space announcement to the guest as well as any
> > > > + * user messages. This API can be used by any vhost driver to handle RPMsg
> > > > + * specific processing.
> > > > + * Specific vhost drivers, using this API will use their own VirtIO device
> > > > + * IDs, that should then also be added to the ID table in virtio_rpmsg_bus.c
> > > > + */
> > > > +
> > > > +#include <linux/compat.h>
> > > > +#include <linux/file.h>
> > > > +#include <linux/miscdevice.h>
> > > > +#include <linux/module.h>
> > > > +#include <linux/mutex.h>
> > > > +#include <linux/vhost.h>
> > > > +#include <linux/virtio_rpmsg.h>
> > > > +#include <uapi/linux/rpmsg.h>
> > > > +
> > > > +#include "vhost.h"
> > > > +#include "vhost_rpmsg.h"
> > > > +
> > > > +/*
> > > > + * All virtio-rpmsg virtual queue kicks always come with just one buffer -
> > > > + * either input or output
> > > > + */
> > > > +static int vhost_rpmsg_get_single(struct vhost_virtqueue *vq)
> > > > +{
> > > > +	struct vhost_rpmsg *vr = container_of(vq->dev, struct vhost_rpmsg, dev);
> > > > +	unsigned int out, in;
> > > > +	int head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov), &out, &in,
> > > > +				     NULL, NULL);
> > > > +	if (head < 0) {
> > > > +		vq_err(vq, "%s(): error %d getting buffer\n",
> > > > +		       __func__, head);
> > > > +		return head;
> > > > +	}
> > > > +
> > > > +	/* Nothing new? */
> > > > +	if (head == vq->num)
> > > > +		return head;
> > > > +
> > > > +	if (vq == &vr->vq[VIRTIO_RPMSG_RESPONSE] && (out || in != 1)) {
> > > 
> > > This in != 1 looks like a dependency on a specific message layout.
> > > virtio spec says to avoid these. Using iov iters it's not too hard to do
> > > ...
> > 
> > This is an RPMsg VirtIO implementation, and it has to match the virtio_rpmsg_bus.c 
> > driver, and that one has specific VirtIO queue and message usage patterns.
> 
> That could be fine for legacy virtio, but now you are claiming support
> for virtio 1, so need to fix these assumptions in the device.

I can just deop these checks without changing anything else, that still would work. 
I could also make this work with "any" layout - either ignoring any left-over 
buffers or maybe even getting them one by one. But I wouldn't even be able to test 
those modes without modifying / breaking the current virtio-rpmsg driver. What's 
the preferred solution?

Thanks
Guennadi

> > > > +		vq_err(vq,
> > > > +		       "%s(): invalid %d input and %d output in response queue\n",
> > > > +		       __func__, in, out);
> > > > +		goto return_buf;
> > > > +	}
> > > > +
> > > > +	if (vq == &vr->vq[VIRTIO_RPMSG_REQUEST] && (in || out != 1)) {
> > > > +		vq_err(vq,
> > > > +		       "%s(): invalid %d input and %d output in request queue\n",
> > > > +		       __func__, in, out);
> > > > +		goto return_buf;
> > > > +	}
> > > > +
> > > > +	return head;
> > > > +
> > > > +return_buf:
> > > > +	/*
> > > > +	 * FIXME: might need to return the buffer using vhost_add_used()
> > > > +	 * or vhost_discard_vq_desc(). vhost_discard_vq_desc() is
> > > > +	 * described as "being useful for error handling," but it makes
> > > > +	 * the thus discarded buffers "unseen," so next time we look we
> > > > +	 * retrieve them again?
> > > 
> > > 
> > > Yes. It's your decision what to do on error. if you also signal
> > > an eventfd using vq_err, then discarding will
> > > make it so userspace can poke at ring and hopefully fix it ...
> > 
> > I assume the user-space in this case is QEMU. Would it be the safest to use 
> > vhost_add_used() then?
> 
> Your call.
> 
> > > > +	 */
> > > > +	return -EINVAL;
> > > > +}
> > 
> > [snip]
> > 
> > > > +	return 0;
> > > > +
> > > > +return_buf:
> > > > +	/*
> > > > +	 * FIXME: vhost_discard_vq_desc() or vhost_add_used(), see comment in
> > > > +	 * vhost_rpmsg_get_single()
> > > > +	 */
> > > 
> > > What's to be done with this FIXME?
> > 
> > This is the same question as above - I just wasn't sure which error handling 
> > was appropriate here, don't think many vhost drivers do any od this...
