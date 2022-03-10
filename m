Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E26D4D4236
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 09:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237999AbiCJIKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 03:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235113AbiCJIKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 03:10:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A56A512E148
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 00:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646899741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yRpMEh74e32SIT/TkO5Zw7Rbh4zfBahzdc81D+s7Zww=;
        b=CgPDS3G1wCl22Tq3uuzJzRBzxivYUiOI1ayojMTdvYY8KBXflK9PpTnBrUB0m9B6Mh8iz3
        ISz7DACuy1TZcNBMXBwmV8Sjc/vzmHuQ20fbT2UcvIo9KN0f0aYhcBIMMyYr8ijTdwsx6J
        U+CxfZysc6ZBY3yxWsNrbVSpYLAlXII=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-33-rTv4MmnUOwuyIX8pP2wnmg-1; Thu, 10 Mar 2022 03:07:34 -0500
X-MC-Unique: rTv4MmnUOwuyIX8pP2wnmg-1
Received: by mail-ej1-f72.google.com with SMTP id m12-20020a1709062acc00b006cfc98179e2so2688351eje.6
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 00:07:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yRpMEh74e32SIT/TkO5Zw7Rbh4zfBahzdc81D+s7Zww=;
        b=JhINB29ElkhDUNiMpYZK/tcHVLzozvsBZ03vyBQ9xJs6RxbyCIpS9x3+I/uXELyVjs
         92M6d1L7H5uNxOEm+1bGEWVDxOy7cXkHduyRhF2Dmahk24/ckNBlxseM5taA16Gnq2BZ
         1UqNfsFd361wgDT0GrYiYuefkknmBeAad4VAVvlhJQCbR8gREJLF1ZT0lK5VupBfppWf
         joJjSGPNz3ySfml1LjR1KIUn3j75K5t3EusnvF/JNKOP4OpTuRpvgewzgtzL0S9kP9/4
         /0GnHwsplrmc+3Nc3nxlrOwlm1MgNfwxGfkoD3jyIif+eBeHJTAGrGHRqb4zJGvVOoV5
         8eEA==
X-Gm-Message-State: AOAM531JnpS/K5A2/1Io7MeeyaUBmWnQAYZChLiIGJtMMdFtB8o9nET2
        rqkDau9xsuO0mRBSYIln+QOELiLffgY/xqTZNKa56WK61zBapyOyl4MEF5Ngk52/Je4HAo5RdgR
        PqGrXFQyWe/mm
X-Received: by 2002:a17:906:c145:b0:6da:aaaf:770c with SMTP id dp5-20020a170906c14500b006daaaaf770cmr3086965ejc.504.1646899650932;
        Thu, 10 Mar 2022 00:07:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjCOk11nnaysxH/jvRJr/h2/JIQ0AxPwVxjLf6gltsJ4McHWkIRVnI17cBBlkYFxggkuQF/Q==
X-Received: by 2002:a17:906:c145:b0:6da:aaaf:770c with SMTP id dp5-20020a170906c14500b006daaaaf770cmr3086933ejc.504.1646899650662;
        Thu, 10 Mar 2022 00:07:30 -0800 (PST)
Received: from redhat.com ([2.55.46.250])
        by smtp.gmail.com with ESMTPSA id gr14-20020a170906e2ce00b006da9ea6377bsm1529778ejb.116.2022.03.10.00.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 00:07:30 -0800 (PST)
Date:   Thu, 10 Mar 2022 03:07:22 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v7 09/26] virtio_ring: split: implement
 virtqueue_reset_vring_split()
Message-ID: <20220310025930-mutt-send-email-mst@kernel.org>
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
 <20220308123518.33800-10-xuanzhuo@linux.alibaba.com>
 <20220310015418-mutt-send-email-mst@kernel.org>
 <1646896623.3794115-2-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1646896623.3794115-2-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 10, 2022 at 03:17:03PM +0800, Xuan Zhuo wrote:
> On Thu, 10 Mar 2022 02:00:39 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Tue, Mar 08, 2022 at 08:35:01PM +0800, Xuan Zhuo wrote:
> > > virtio ring supports reset.
> > >
> > > Queue reset is divided into several stages.
> > >
> > > 1. notify device queue reset
> > > 2. vring release
> > > 3. attach new vring
> > > 4. notify device queue re-enable
> > >
> > > After the first step is completed, the vring reset operation can be
> > > performed. If the newly set vring num does not change, then just reset
> > > the vq related value.
> > >
> > > Otherwise, the vring will be released and the vring will be reallocated.
> > > And the vring will be attached to the vq. If this process fails, the
> > > function will exit, and the state of the vq will be the vring release
> > > state. You can call this function again to reallocate the vring.
> > >
> > > In addition, vring_align, may_reduce_num are necessary for reallocating
> > > vring, so they are retained when creating vq.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > ---
> > >  drivers/virtio/virtio_ring.c | 69 ++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 69 insertions(+)
> > >
> > > diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> > > index e0422c04c903..148fb1fd3d5a 100644
> > > --- a/drivers/virtio/virtio_ring.c
> > > +++ b/drivers/virtio/virtio_ring.c
> > > @@ -158,6 +158,12 @@ struct vring_virtqueue {
> > >  			/* DMA address and size information */
> > >  			dma_addr_t queue_dma_addr;
> > >  			size_t queue_size_in_bytes;
> > > +
> > > +			/* The parameters for creating vrings are reserved for
> > > +			 * creating new vrings when enabling reset queue.
> > > +			 */
> > > +			u32 vring_align;
> > > +			bool may_reduce_num;
> > >  		} split;
> > >
> > >  		/* Available for packed ring */
> > > @@ -217,6 +223,12 @@ struct vring_virtqueue {
> > >  #endif
> > >  };
> > >
> > > +static void vring_free(struct virtqueue *vq);
> > > +static void __vring_virtqueue_init_split(struct vring_virtqueue *vq,
> > > +					 struct virtio_device *vdev);
> > > +static int __vring_virtqueue_attach_split(struct vring_virtqueue *vq,
> > > +					  struct virtio_device *vdev,
> > > +					  struct vring vring);
> > >
> > >  /*
> > >   * Helpers.
> > > @@ -1012,6 +1024,8 @@ static struct virtqueue *vring_create_virtqueue_split(
> > >  		return NULL;
> > >  	}
> > >
> > > +	to_vvq(vq)->split.vring_align = vring_align;
> > > +	to_vvq(vq)->split.may_reduce_num = may_reduce_num;
> > >  	to_vvq(vq)->split.queue_dma_addr = vring.dma_addr;
> > >  	to_vvq(vq)->split.queue_size_in_bytes = vring.queue_size_in_bytes;
> > >  	to_vvq(vq)->we_own_ring = true;
> > > @@ -1019,6 +1033,59 @@ static struct virtqueue *vring_create_virtqueue_split(
> > >  	return vq;
> > >  }
> > >
> > > +static int virtqueue_reset_vring_split(struct virtqueue *_vq, u32 num)
> > > +{
> > > +	struct vring_virtqueue *vq = to_vvq(_vq);
> > > +	struct virtio_device *vdev = _vq->vdev;
> > > +	struct vring_split vring;
> > > +	int err;
> > > +
> > > +	if (num > _vq->num_max)
> > > +		return -E2BIG;
> > > +
> > > +	switch (vq->vq.reset) {
> > > +	case VIRTIO_VQ_RESET_STEP_NONE:
> > > +		return -ENOENT;
> > > +
> > > +	case VIRTIO_VQ_RESET_STEP_VRING_ATTACH:
> > > +	case VIRTIO_VQ_RESET_STEP_DEVICE:
> > > +		if (vq->split.vring.num == num || !num)
> > > +			break;
> > > +
> > > +		vring_free(_vq);
> > > +
> > > +		fallthrough;
> > > +
> > > +	case VIRTIO_VQ_RESET_STEP_VRING_RELEASE:
> > > +		if (!num)
> > > +			num = vq->split.vring.num;
> > > +
> > > +		err = vring_create_vring_split(&vring, vdev,
> > > +					       vq->split.vring_align,
> > > +					       vq->weak_barriers,
> > > +					       vq->split.may_reduce_num, num);
> > > +		if (err)
> > > +			return -ENOMEM;
> > > +
> > > +		err = __vring_virtqueue_attach_split(vq, vdev, vring.vring);
> > > +		if (err) {
> > > +			vring_free_queue(vdev, vring.queue_size_in_bytes,
> > > +					 vring.queue,
> > > +					 vring.dma_addr);
> > > +			return -ENOMEM;
> > > +		}
> > > +
> > > +		vq->split.queue_dma_addr = vring.dma_addr;
> > > +		vq->split.queue_size_in_bytes = vring.queue_size_in_bytes;
> > > +	}
> > > +
> > > +	__vring_virtqueue_init_split(vq, vdev);
> > > +	vq->we_own_ring = true;
> > > +	vq->vq.reset = VIRTIO_VQ_RESET_STEP_VRING_ATTACH;
> > > +
> > > +	return 0;
> > > +}
> > > +
> >
> > I kind of dislike this state machine.
> >
> > Hacks like special-casing num = 0 to mean "reset" are especially
> > confusing.
> 
> I'm removing it. I'll say in the function description that this function is
> currently only called when vq has been reset. I'm no longer checking it based on
> state.
> 
> >
> > And as Jason points out, when we want a resize then yes this currently
> > implies reset but that is an implementation detail.
> >
> > There should be a way to just make these cases separate functions
> > and then use them to compose consistent external APIs.
> 
> Yes, virtqueue_resize_split() is fine for ethtool -G.
> 
> But in the case of AF_XDP, just execute reset to free the buffer. The name
> virtqueue_reset_vring_split() I think can cover both cases. Or we use two apis
> to handle both scenarios?
> 
> Or can anyone think of a better name. ^_^
> 
> Thanks.


I'd say resize should be called resize and reset should be called reset.

The big issue is a sane API for resize. Ideally it would resubmit
buffers which did not get used. Question is what to do
about buffers which don't fit (if ring has been downsized)?
Maybe a callback that will handle them?
And then what? Queue them up and readd later? Drop?
If we drop we should drop from the head not the tail ...


> >
> > If we additionally want to track state for debugging then bool flags
> > seem more appropriate for this, though from experience that is
> > not always worth the extra code.
> >
> >
> >
> > >  /*
> > >   * Packed ring specific functions - *_packed().
> > > @@ -2317,6 +2384,8 @@ static int __vring_virtqueue_attach_split(struct vring_virtqueue *vq,
> > >  static void __vring_virtqueue_init_split(struct vring_virtqueue *vq,
> > >  					 struct virtio_device *vdev)
> > >  {
> > > +	vq->vq.reset = VIRTIO_VQ_RESET_STEP_NONE;
> > > +
> > >  	vq->packed_ring = false;
> > >  	vq->we_own_ring = false;
> > >  	vq->broken = false;
> > > --
> > > 2.31.0
> >

