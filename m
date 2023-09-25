Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80EDE7ACDCA
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 04:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbjIYCD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 22:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjIYCDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 22:03:54 -0400
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E87BD;
        Sun, 24 Sep 2023 19:03:45 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0VsjlAa9_1695607420;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VsjlAa9_1695607420)
          by smtp.aliyun-inc.com;
          Mon, 25 Sep 2023 10:03:41 +0800
Message-ID: <1695607353.8416731-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v14 30/42] virtio_pci: introduce helper to get/set queue reset
Date:   Mon, 25 Sep 2023 10:02:33 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
References: <20220801063902.129329-1-xuanzhuo@linux.alibaba.com>
 <20220801063902.129329-31-xuanzhuo@linux.alibaba.com>
 <20230921100112-mutt-send-email-mst@kernel.org>
 <1695347358.2770545-1-xuanzhuo@linux.alibaba.com>
 <20230922064550-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230922064550-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Sep 2023 06:46:39 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Fri, Sep 22, 2023 at 09:49:18AM +0800, Xuan Zhuo wrote:
> > On Thu, 21 Sep 2023 10:02:53 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > On Mon, Aug 01, 2022 at 02:38:50PM +0800, Xuan Zhuo wrote:
> > > > Introduce new helpers to implement queue reset and get queue reset
> > > > status.
> > > >
> > > >  https://github.com/oasis-tcs/virtio-spec/issues/124
> > > >  https://github.com/oasis-tcs/virtio-spec/issues/139
> > > >
> > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > ---
> > > >  drivers/virtio/virtio_pci_modern_dev.c | 39 ++++++++++++++++++++++++++
> > > >  include/linux/virtio_pci_modern.h      |  2 ++
> > > >  2 files changed, 41 insertions(+)
> > > >
> > > > diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
> > > > index fa2a9445bb18..869cb46bef96 100644
> > > > --- a/drivers/virtio/virtio_pci_modern_dev.c
> > > > +++ b/drivers/virtio/virtio_pci_modern_dev.c
> > > > @@ -3,6 +3,7 @@
> > > >  #include <linux/virtio_pci_modern.h>
> > > >  #include <linux/module.h>
> > > >  #include <linux/pci.h>
> > > > +#include <linux/delay.h>
> > > >
> > > >  /*
> > > >   * vp_modern_map_capability - map a part of virtio pci capability
> > > > @@ -474,6 +475,44 @@ void vp_modern_set_status(struct virtio_pci_modern_device *mdev,
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(vp_modern_set_status);
> > > >
> > > > +/*
> > > > + * vp_modern_get_queue_reset - get the queue reset status
> > > > + * @mdev: the modern virtio-pci device
> > > > + * @index: queue index
> > > > + */
> > > > +int vp_modern_get_queue_reset(struct virtio_pci_modern_device *mdev, u16 index)
> > > > +{
> > > > +	struct virtio_pci_modern_common_cfg __iomem *cfg;
> > > > +
> > > > +	cfg = (struct virtio_pci_modern_common_cfg __iomem *)mdev->common;
> > > > +
> > > > +	vp_iowrite16(index, &cfg->cfg.queue_select);
> > > > +	return vp_ioread16(&cfg->queue_reset);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(vp_modern_get_queue_reset);
> > > > +
> > >
> > > Actually, this does not validate that the config structure is big
> > > enough. So it can access some unrelated memory. Don't know whether
> > > that's exploitable e.g. for CoCo but not nice, anyway.
> > > Need to validate the size and disable reset if it's too small.
> >
> >
> > static int vp_modern_disable_vq_and_reset(struct virtqueue *vq)
> > {
> > 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
> > 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> > 	struct virtio_pci_vq_info *info;
> > 	unsigned long flags;
> >
> > ->	if (!virtio_has_feature(vq->vdev, VIRTIO_F_RING_RESET))
> > 		return -ENOENT;
> >
> > 	vp_modern_set_queue_reset(mdev, vq->index);
> >
> >
> > I checked VIRTIO_F_RING_RESET before call this.
>
> Yes but the point is that virtio is used with untrusted devices
> (e.g. for SEV/TDX), so you can't really assume config structures
> are in sync with feature bits.

I see.

I will post a patch to check the length of the common cfg.

Thanks.


>
>
> > Do you mean, we should put the check to this function.
> >
> >
> > Thanks.
> >
> >
> >
> > >
> > >
> > > > +/*
> > > > + * vp_modern_set_queue_reset - reset the queue
> > > > + * @mdev: the modern virtio-pci device
> > > > + * @index: queue index
> > > > + */
> > > > +void vp_modern_set_queue_reset(struct virtio_pci_modern_device *mdev, u16 index)
> > > > +{
> > > > +	struct virtio_pci_modern_common_cfg __iomem *cfg;
> > > > +
> > > > +	cfg = (struct virtio_pci_modern_common_cfg __iomem *)mdev->common;
> > > > +
> > > > +	vp_iowrite16(index, &cfg->cfg.queue_select);
> > > > +	vp_iowrite16(1, &cfg->queue_reset);
> > > > +
> > > > +	while (vp_ioread16(&cfg->queue_reset))
> > > > +		msleep(1);
> > > > +
> > > > +	while (vp_ioread16(&cfg->cfg.queue_enable))
> > > > +		msleep(1);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(vp_modern_set_queue_reset);
> > > > +
> > > >  /*
> > > >   * vp_modern_queue_vector - set the MSIX vector for a specific virtqueue
> > > >   * @mdev: the modern virtio-pci device
> > > > diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
> > > > index 05123b9a606f..c4eeb79b0139 100644
> > > > --- a/include/linux/virtio_pci_modern.h
> > > > +++ b/include/linux/virtio_pci_modern.h
> > > > @@ -113,4 +113,6 @@ void __iomem * vp_modern_map_vq_notify(struct virtio_pci_modern_device *mdev,
> > > >  				       u16 index, resource_size_t *pa);
> > > >  int vp_modern_probe(struct virtio_pci_modern_device *mdev);
> > > >  void vp_modern_remove(struct virtio_pci_modern_device *mdev);
> > > > +int vp_modern_get_queue_reset(struct virtio_pci_modern_device *mdev, u16 index);
> > > > +void vp_modern_set_queue_reset(struct virtio_pci_modern_device *mdev, u16 index);
> > > >  #endif
> > > > --
> > > > 2.31.0
> > >
>
