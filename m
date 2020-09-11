Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8737E2666D5
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 19:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgIKReD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 13:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgIKRdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 13:33:18 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECD7C061757
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 10:33:17 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x123so7897122pfc.7
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 10:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ea5vjOrykFeGz5aONnDp0tHjvmT7nZX71DKN8BXuOaI=;
        b=F6InEOkWMk18guLijhmGhKxmgOiT7avNX2q3u63vqCTnV53/6209gPMJFcSKyG5Mxy
         DQqWpX6lsSHK32gxGsz5E111+zTbbwcVsVB+Azd7gYXqCgJwCwZscuwYW7HnjjEsl7Cb
         mNwDINXbWGBEqA/194ecRDX5TL2yUA3cEajJ4wr8e9H1QNCTy4nmnizktGXmnvw6xKCV
         YU6qXsgrcrXJWOq/W2J9AGAVsJ2CHW9H4cCykp3N1uGIUIF9Bj8//x8XlPbwyOS3QajM
         qlZ/pFtwyxvQbdZzii7eCygUDhFsY2JZHPZptX+Av0pxQHhdgKOkdHyu5sI1YdOrXcR9
         fI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ea5vjOrykFeGz5aONnDp0tHjvmT7nZX71DKN8BXuOaI=;
        b=AufJ7rIv2nrbbglxwX4cj84zB4OTOKfzBBbAHQhWQsPIpqgYvbDHevn6pbJmwF66Rd
         rLxpZYx26lexZYzPTID1JNunhErFh5rc1tLI6+7e1A67ygD/+IRSXlRrbtaJ40oRFdkt
         ikBF/9ud1TaBnOJoXv0xQSRXqFUaUt6BznFTbhU9Pn9hGNytZ8YIf0o0c8A3Voe8jhaX
         YYWcQ3PgKPG7z0ZlOTo+5XD3VJOZDQUvJrl4opXz2IRev2CX7AytHd0U5IX6Q2J1jeRF
         9rgtnJHfbdpYyiCTXqQbqti6TqFSVn6VrKQDgTJkOIvbCOlpv+1sr5Ypvdgq4hMNUxl/
         Ha3A==
X-Gm-Message-State: AOAM531VKfpLcVFACq6eCXh27wXOXn/pBrt3oHg44wLMf6iUe+d5mU3O
        7eX0mO+5g9OZZxA1xLDpx/Ro1S4/Gjvk8A==
X-Google-Smtp-Source: ABdhPJy3nhEv087GDrsyogqsqRy0ib72rO6YnNIv6wwnrnuuzUuV65FDMTOCZ7uLtDAwKBs/mU7TDw==
X-Received: by 2002:a63:1e4e:: with SMTP id p14mr2362012pgm.73.1599845596404;
        Fri, 11 Sep 2020 10:33:16 -0700 (PDT)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id e2sm2354380pgl.38.2020.09.11.10.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 10:33:15 -0700 (PDT)
Date:   Fri, 11 Sep 2020 11:33:13 -0600
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
Subject: Re: [PATCH v5 4/4] vhost: add an RPMsg API
Message-ID: <20200911173313.GA613136@xps15>
References: <20200826174636.23873-1-guennadi.liakhovetski@linux.intel.com>
 <20200826174636.23873-5-guennadi.liakhovetski@linux.intel.com>
 <20200909223946.GA562265@xps15>
 <20200910083853.GB17698@ubuntu>
 <20200910172211.GB579940@xps15>
 <20200911074655.GA26801@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911074655.GA26801@ubuntu>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 11, 2020 at 09:46:56AM +0200, Guennadi Liakhovetski wrote:
> Hi Mathieu,
> 
> On Thu, Sep 10, 2020 at 11:22:11AM -0600, Mathieu Poirier wrote:
> > Good morning Guennadi,
> > 
> > On Thu, Sep 10, 2020 at 10:38:54AM +0200, Guennadi Liakhovetski wrote:
> > > Hi Mathieu,
> > > 
> > > On Wed, Sep 09, 2020 at 04:39:46PM -0600, Mathieu Poirier wrote:
> > > > Good afternoon,
> > > > 
> > > > On Wed, Aug 26, 2020 at 07:46:36PM +0200, Guennadi Liakhovetski wrote:
> > > > > Linux supports running the RPMsg protocol over the VirtIO transport
> > > > > protocol, but currently there is only support for VirtIO clients and
> > > > > no support for a VirtIO server. This patch adds a vhost-based RPMsg
> > > > > server implementation.
> > > > 
> > > > This changelog is very confusing...  At this time the name service in the
> > > > remoteproc space runs as a server on the application processor.  But from the
> > > > above the remoteproc usecase seems to be considered to be a client
> > > > configuration.
> > > 
> > > I agree that this isn't very obvious. But I think it is common to call the 
> > > host "a server" and guests "clients." E.g. in vhost.c in the top-of-thefile 
> > > comment:
> > 
> > Ok - that part we agree on.
> > 
> > > 
> > >  * Generic code for virtio server in host kernel.
> > > 
> > > I think the generic concept behind this notation is, that as guests boot, 
> > > they send their requests to the host, e.g. VirtIO device drivers on guests 
> > > send requests over VirtQueues to VirtIO servers on the host, which can run 
> > > either in the user- or in the kernel-space. And I think you can follow that 
> > 
> > I can see that process taking place.  After all virtIO devices on guests are
> > only stubs that need host support for access to HW.
> > 
> > > logic in case of devices or remote processors too: it's the main CPU(s) 
> > > that boot(s) and start talking to devices and remote processors, so in that 
> > > sence devices are servers and the CPUs are their clients.
> > 
> > In the remote processor case, the remoteproc core (application processor) sets up
> > the name service but does not initiate the communication with a remote
> > processor.  It simply waits there for a name space request to come in from the
> > remote processor.
> 
> Hm, I don't see that in two examples, that I looked at: mtk and virtio. In both 
> cases the announcement seems to be directly coming from the application processor 
> maybe after some initialisation.
>
 
Can you expand on that part - perhaps point me to the (virtio) code you are
referring to? 

> > > And yes, the name-space announcement use-case seems confusing to me too - it 
> > > reverts the relationship in a way: once a guest has booted and established 
> > > connections to any rpmsg "devices," those send their namespace announcements 
> > > back. But I think this can be regarded as server identification: you connect 
> > > to a server and it replies with its identification and capabilities.
> > 
> > Based on the above can I assume vhost_rpmsg_ns_announce() is sent from the
> > guest?
> 
> No, it's "vhost_..." so it's running on the host.

Ok, that's better and confirms the usage of the VIRTIO_RPMSG_RESPONSE queue.
When reading your explanation above, I thought the term "those" referred to the
guest.  In light of your explanation I now understand that "those" referred to
the rpmgs devices on the host.

In the above paragraph you write:

... "once a guest has booted and established connections to any rpmsg "devices",
those send their namespace announcements back".  

I'd like to unpack a few things about this sentence:

1) In this context, how is a "connection" established between a guest and a host?

2) How does the guest now about the rpmsg devices it has made a connection to?

3) Why is a namespace announcement needed at all when guests are aware of the
rpmsg devices instantiated on the host, and have already connected to them?
  

> The host (the server, an 
> analogue of the application processor, IIUC) sends NS announcements to guests.

I think we have just found the source of the confusion - in the remoteproc world
the application processor receives name announcements, it doesn't send them.

> 
> > I saw your V7, something I will look into.  In the mean time I need to bring
> > your attention to this set [1] from Arnaud.  Please have a look as it will
> > impact your work.
> > 
> > https://patchwork.kernel.org/project/linux-remoteproc/list/?series=338335
> 
> Yes, I've had a look at that series, thanks for forwarding it to me. TBH I 
> don't quite understand some choices there, e.g. creating a separate driver and 
> then having to register devices just for the namespace announcement. I don't 
> think creating virtual devices is taken easily in Linux. But either way I 
> don't think our series conflict a lot, but I do hope that I can merge my 
> series first, he'd just have to switch to using the header, that I'm adding. 
> Hardly too many changes otherwise.

It is not the conflicts between the series that I wanted to highlight but the
fact that name service is in the process of becoming a driver on its own, and
with no dependence on the transport mechanism.

> 
> > > > And I don't see a server implementation per se...  It is more like a client
> > > > implementation since vhost_rpmsg_announce() uses the RESPONSE queue, which sends
> > > > messages from host to guest.
> > > > 
> > > > Perhaps it is my lack of familiarity with vhost terminology.
> > > > 
> > > > > 
> > > > > Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > > > ---
> > > > >  drivers/vhost/Kconfig       |   7 +
> > > > >  drivers/vhost/Makefile      |   3 +
> > > > >  drivers/vhost/rpmsg.c       | 373 ++++++++++++++++++++++++++++++++++++
> > > > >  drivers/vhost/vhost_rpmsg.h |  74 +++++++
> > > > >  4 files changed, 457 insertions(+)
> > > > >  create mode 100644 drivers/vhost/rpmsg.c
> > > > >  create mode 100644 drivers/vhost/vhost_rpmsg.h
> > > > > 
> > > > > diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> > > > > index 587fbae06182..046b948fc411 100644
> > > > > --- a/drivers/vhost/Kconfig
> > > > > +++ b/drivers/vhost/Kconfig
> > > > > @@ -38,6 +38,13 @@ config VHOST_NET
> > > > >  	  To compile this driver as a module, choose M here: the module will
> > > > >  	  be called vhost_net.
> > > > >  
> > > > > +config VHOST_RPMSG
> > > > > +	tristate
> > > > > +	select VHOST
> > > > > +	help
> > > > > +	  Vhost RPMsg API allows vhost drivers to communicate with VirtIO
> > > > > +	  drivers, using the RPMsg over VirtIO protocol.
> > > > 
> > > > I had to assume vhost drivers are running on the host and virtIO drivers on the
> > > > guests.  This may be common knowledge for people familiar with vhosts but
> > > > certainly obscur for commoners  Having a help section that is clear on what is
> > > > happening would remove any ambiguity.
> > > 
> > > It is the terminology, yes, but you're right, the wording isn't very clear, will 
> > > improve.
> > > 
> > > > > +
> > > > >  config VHOST_SCSI
> > > > >  	tristate "VHOST_SCSI TCM fabric driver"
> > > > >  	depends on TARGET_CORE && EVENTFD
> > > > > diff --git a/drivers/vhost/Makefile b/drivers/vhost/Makefile
> > > > > index f3e1897cce85..9cf459d59f97 100644
> > > > > --- a/drivers/vhost/Makefile
> > > > > +++ b/drivers/vhost/Makefile
> > > > > @@ -2,6 +2,9 @@
> > > > >  obj-$(CONFIG_VHOST_NET) += vhost_net.o
> > > > >  vhost_net-y := net.o
> > > > >  
> > > > > +obj-$(CONFIG_VHOST_RPMSG) += vhost_rpmsg.o
> > > > > +vhost_rpmsg-y := rpmsg.o
> > > > > +
> > > > >  obj-$(CONFIG_VHOST_SCSI) += vhost_scsi.o
> > > > >  vhost_scsi-y := scsi.o
> > > > >  
> > > > > diff --git a/drivers/vhost/rpmsg.c b/drivers/vhost/rpmsg.c
> > > > > new file mode 100644
> > > > > index 000000000000..c26d7a4afc6d
> > > > > --- /dev/null
> > > > > +++ b/drivers/vhost/rpmsg.c
> > > > > @@ -0,0 +1,373 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > > +/*
> > > > > + * Copyright(c) 2020 Intel Corporation. All rights reserved.
> > > > > + *
> > > > > + * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > > > + *
> > > > > + * Vhost RPMsg VirtIO interface. It provides a set of functions to match the
> > > > > + * guest side RPMsg VirtIO API, provided by drivers/rpmsg/virtio_rpmsg_bus.c
> > > > 
> > > > Again, very confusing.  The changelog refers to a server implementation but to
> > > > me this refers to a client implementation, especially if rpmsg_recv_single() and
> > > > rpmsg_ns_cb() are used on the other side of the pipe.  
> > > 
> > > I think the above is correct. "Vhost" indicates, that this is running on the host. 
> > > "match the guest side" means, that you can use this API on the host and it is 
> > > designed to work together with the RPMsg VirtIO drivers running on guests, as 
> > > implemented *on guests* by virtio_rpmsg_bus.c. Would "to work together" be a better 
> > > description than "to match?"
> > 
> > Lets forget about this part now and concentrate on the above conversation.
> > Things will start to make sense at one point.
> 
> I've improved that description a bit, it was indeed rather clumsy.

Much appreciated - I'll take a look a V7 next week.

> 
> [snip]
> 
> > > > > diff --git a/drivers/vhost/vhost_rpmsg.h b/drivers/vhost/vhost_rpmsg.h
> > > > > new file mode 100644
> > > > > index 000000000000..30072cecb8a0
> > > > > --- /dev/null
> > > > > +++ b/drivers/vhost/vhost_rpmsg.h
> > > > > @@ -0,0 +1,74 @@
> > > > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > > > +/*
> > > > > + * Copyright(c) 2020 Intel Corporation. All rights reserved.
> > > > > + *
> > > > > + * Author: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> > > > > + */
> > > > > +
> > > > > +#ifndef VHOST_RPMSG_H
> > > > > +#define VHOST_RPMSG_H
> > > > > +
> > > > > +#include <linux/uio.h>
> > > > > +#include <linux/virtio_rpmsg.h>
> > > > > +
> > > > > +#include "vhost.h"
> > > > > +
> > > > > +/* RPMsg uses two VirtQueues: one for each direction */
> > > > > +enum {
> > > > > +	VIRTIO_RPMSG_RESPONSE,	/* RPMsg response (host->guest) buffers */
> > > > > +	VIRTIO_RPMSG_REQUEST,	/* RPMsg request (guest->host) buffers */
> > > > > +	/* Keep last */
> > > > > +	VIRTIO_RPMSG_NUM_OF_VQS,
> > > > > +};
> > > > > +
> > > > > +struct vhost_rpmsg_ept;
> > > > > +
> > > > > +struct vhost_rpmsg_iter {
> > > > > +	struct iov_iter iov_iter;
> > > > > +	struct rpmsg_hdr rhdr;
> > > > > +	struct vhost_virtqueue *vq;
> > > > > +	const struct vhost_rpmsg_ept *ept;
> > > > > +	int head;
> > > > > +	void *priv;
> > > > 
> > > > I don't see @priv being used anywhere.
> > > 
> > > That's logical: this is a field, private to the API users, so the core shouldn't 
> > > use it :-) It's used in later patches.
> > 
> > That is where structure documentation is useful.  I will let Michael decide what
> > he wants to do.
> 
> I can add some kerneldoc documentation there, no problem.
> 
> > Thanks for the feedback,
> 
> Thanks for your reviews! I'd very much like to close all the still open points 
> and merge the series ASAP.
> 
> Thanks
> Guennadi
> 
> > Mathieu
> > 
> > > 
> > > > 
> > > > > +};
> > > > > +
> > > > > +struct vhost_rpmsg {
> > > > > +	struct vhost_dev dev;
> > > > > +	struct vhost_virtqueue vq[VIRTIO_RPMSG_NUM_OF_VQS];
> > > > > +	struct vhost_virtqueue *vq_p[VIRTIO_RPMSG_NUM_OF_VQS];
> > > > > +	const struct vhost_rpmsg_ept *ept;
> > > > > +	unsigned int n_epts;
> > > > > +};
> > > > > +
> > > > > +struct vhost_rpmsg_ept {
> > > > > +	ssize_t (*read)(struct vhost_rpmsg *, struct vhost_rpmsg_iter *);
> > > > > +	ssize_t (*write)(struct vhost_rpmsg *, struct vhost_rpmsg_iter *);
> > > > > +	int addr;
> > > > > +};
> > > > > +
> > > > > +static inline size_t vhost_rpmsg_iter_len(const struct vhost_rpmsg_iter *iter)
> > > > > +{
> > > > > +	return iter->rhdr.len;
> > > > > +}
> > > > 
> > > > Again, I don't see where this is used.
> > > 
> > > This is exported API, it's used by users.
> > >
> > > > > +
> > > > > +#define VHOST_RPMSG_ITER(_vq, _src, _dst) {			\
> > > > > +	.rhdr = {						\
> > > > > +			.src = cpu_to_vhost32(_vq, _src),	\
> > > > > +			.dst = cpu_to_vhost32(_vq, _dst),	\
> > > > > +		},						\
> > > > > +	}
> > > > 
> > > > Same.
> > > 
> > > ditto.
> > > 
> > > Thanks
> > > Guennadi
> > > 
> > > > Thanks,
> > > > Mathieu
> > > > 
> > > > > +
> > > > > +void vhost_rpmsg_init(struct vhost_rpmsg *vr, const struct vhost_rpmsg_ept *ept,
> > > > > +		      unsigned int n_epts);
> > > > > +void vhost_rpmsg_destroy(struct vhost_rpmsg *vr);
> > > > > +int vhost_rpmsg_ns_announce(struct vhost_rpmsg *vr, const char *name,
> > > > > +			    unsigned int src);
> > > > > +int vhost_rpmsg_start_lock(struct vhost_rpmsg *vr,
> > > > > +			   struct vhost_rpmsg_iter *iter,
> > > > > +			   unsigned int qid, ssize_t len);
> > > > > +size_t vhost_rpmsg_copy(struct vhost_rpmsg *vr, struct vhost_rpmsg_iter *iter,
> > > > > +			void *data, size_t size);
> > > > > +int vhost_rpmsg_finish_unlock(struct vhost_rpmsg *vr,
> > > > > +			      struct vhost_rpmsg_iter *iter);
> > > > > +
> > > > > +#endif
> > > > > -- 
> > > > > 2.28.0
> > > > > 
