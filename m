Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30F4592A49
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 09:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241656AbiHOHRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 03:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241761AbiHOHPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 03:15:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B96C1EAE9
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 00:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660547696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uunb/SmxieTcIyt41wPcw20H+0i6av2iZEDGKTJdPks=;
        b=FHhkMkGhrpiMcwpV5aTlAcv38SCwBWqbCp3PUUTPUVpgFSWyY+4hw2E7rGQ5CrT1nNVn1O
        X1SpQvpMJhLAOA7FCx6O166BcslyqjI/TrK5Ydu3/pRrqWPmAhtVKkJk+FdWd/HcT5mHBm
        gZahYTnvCJH06DN+x4TxpHykdEqM1DA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-524-7KQsQE0gNi655WrPtSKsHg-1; Mon, 15 Aug 2022 03:14:54 -0400
X-MC-Unique: 7KQsQE0gNi655WrPtSKsHg-1
Received: by mail-ed1-f72.google.com with SMTP id v19-20020a056402349300b0043d42b7ddefso4216622edc.13
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 00:14:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=uunb/SmxieTcIyt41wPcw20H+0i6av2iZEDGKTJdPks=;
        b=leCw4S47cUdUQTmF4FJ65e1qaqyqWfultpzTnwSJGscCl333x+esthDhkGkamsvBt9
         6gQQtZjeHMz7+m+WYY+rIaowvZ4YcnoejSqXsa96JfxodgRIWX5BWnUJb/b81p5BmTeQ
         eLjYgyOkV4C+G8VC129KEOTu576At5rNVA1vG6S903fe95zznrVUgY9xKy/jAXJwrr98
         gw7376HDGy/WU5CGKId1Ibuizr9LAY/to3xK8NZ0R+GIcsnvFUSAxG77MqaOaDjrcWaE
         6Q1/xIPpIPJJU8V+mInTupnuJ2Aup4syTSuIRTevoBlTfIHeug4Qe6W5+205cAi1pn05
         e5KQ==
X-Gm-Message-State: ACgBeo0KrR/O38Uov7d6E79ft8tk//Up+xMKIshqPO3wErGDZr5l2N3d
        +MjqG3W/9l/JP+XtjEev/K0HNaVxmgABOIRp4qAA2myOlDeliY5wKMJjGd15eEywdg/H41vR72A
        nLYxkRwg7Zlgg
X-Received: by 2002:a05:6402:a47:b0:43d:17a0:fdc9 with SMTP id bt7-20020a0564020a4700b0043d17a0fdc9mr13334564edb.41.1660547693091;
        Mon, 15 Aug 2022 00:14:53 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4YoHheG5W/eaV8BZh8HsvP1ibrkGNG7x2cY+yPrQSEoDviob3P1rxs8nDl9bBsoZz0emD9gQ==
X-Received: by 2002:a05:6402:a47:b0:43d:17a0:fdc9 with SMTP id bt7-20020a0564020a4700b0043d17a0fdc9mr13334553edb.41.1660547692848;
        Mon, 15 Aug 2022 00:14:52 -0700 (PDT)
Received: from redhat.com ([2.54.169.49])
        by smtp.gmail.com with ESMTPSA id f1-20020a1709067f8100b007310a9a65cbsm3880906ejr.16.2022.08.15.00.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 00:14:52 -0700 (PDT)
Date:   Mon, 15 Aug 2022 03:14:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
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
Subject: Re: [PATCH v14 37/42] virtio_net: set the default max ring size by
 find_vqs()
Message-ID: <20220815031022-mutt-send-email-mst@kernel.org>
References: <20220801063902.129329-1-xuanzhuo@linux.alibaba.com>
 <20220801063902.129329-38-xuanzhuo@linux.alibaba.com>
 <20220815015405-mutt-send-email-mst@kernel.org>
 <1660545303.436073-9-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1660545303.436073-9-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 15, 2022 at 02:35:03PM +0800, Xuan Zhuo wrote:
> On Mon, 15 Aug 2022 02:00:16 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Mon, Aug 01, 2022 at 02:38:57PM +0800, Xuan Zhuo wrote:
> > > Use virtio_find_vqs_ctx_size() to specify the maximum ring size of tx,
> > > rx at the same time.
> > >
> > >                          | rx/tx ring size
> > > -------------------------------------------
> > > speed == UNKNOWN or < 10G| 1024
> > > speed < 40G              | 4096
> > > speed >= 40G             | 8192
> > >
> > > Call virtnet_update_settings() once before calling init_vqs() to update
> > > speed.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > Acked-by: Jason Wang <jasowang@redhat.com>
> >
> > I've been looking at this patchset because of the resent
> > reported crashes, and I'm having second thoughts about this.
> >
> > Do we really want to second-guess the device supplied
> > max ring size? If yes why?
> >
> > Could you please share some performance data that motivated this
> > specific set of numbers?
> 
> 
> The impact of this value on performance is as follows. The larger the value, the
> throughput can be increased, but the delay will also increase accordingly. It is
> a maximum limit for the ring size under the corresponding speed. The purpose of
> this limitation is not to improve performance, but more to reduce memory usage.
> 
> These data come from many other network cards and some network optimization
> experience.
> 
> For example, in the case of speed = 20G, the impact of ring size greater
> than 4096 on performance has no meaning. At this time, if the device supports
> 8192, we limit it to 4096 through this, the real meaning is to reduce the memory
> usage.
> 
> 
> >
> > Also why do we intepret UNKNOWN as "very low"?
> > I'm thinking that should definitely be "don't change anything".
> >
> 
> Generally speaking, for a network card with a high speed, it will return a
> correct speed. But I think it is a good idea to do nothing.





> 
> > Finally if all this makes sense then shouldn't we react when
> > speed changes?
> 
> This is the feedback of the network card when it is started, and theoretically
> it should not change in the future.

Yes it should:
	Both \field{speed} and \field{duplex} can change, thus the driver
	is expected to re-read these values after receiving a
	configuration change notification.


Moreover, during probe link can quite reasonably be down.
If it is, then speed and duplex might not be correct.




> >
> > Could you try reverting this and showing performance results
> > before and after please? Thanks!
> 
> I hope the above reply can help you, if there is anything else you need me to
> cooperate with, I am very happy.
> 
> If you think it's ok, I can resubmit a commit with 'UNKNOW' set to unlimited. I
> can submit it with the issue of #30.
> 
> Thanks.
> 
> 
> >
> > > ---
> > >  drivers/net/virtio_net.c | 42 ++++++++++++++++++++++++++++++++++++----
> > >  1 file changed, 38 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 8a5810bcb839..40532ecbe7fc 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -3208,6 +3208,29 @@ static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqu
> > >  		   (unsigned int)GOOD_PACKET_LEN);
> > >  }
> > >
> > > +static void virtnet_config_sizes(struct virtnet_info *vi, u32 *sizes)
> > > +{
> > > +	u32 i, rx_size, tx_size;
> > > +
> > > +	if (vi->speed == SPEED_UNKNOWN || vi->speed < SPEED_10000) {
> > > +		rx_size = 1024;
> > > +		tx_size = 1024;
> > > +
> > > +	} else if (vi->speed < SPEED_40000) {
> > > +		rx_size = 1024 * 4;
> > > +		tx_size = 1024 * 4;
> > > +
> > > +	} else {
> > > +		rx_size = 1024 * 8;
> > > +		tx_size = 1024 * 8;
> > > +	}
> > > +
> > > +	for (i = 0; i < vi->max_queue_pairs; i++) {
> > > +		sizes[rxq2vq(i)] = rx_size;
> > > +		sizes[txq2vq(i)] = tx_size;
> > > +	}
> > > +}
> > > +
> > >  static int virtnet_find_vqs(struct virtnet_info *vi)
> > >  {
> > >  	vq_callback_t **callbacks;
> > > @@ -3215,6 +3238,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> > >  	int ret = -ENOMEM;
> > >  	int i, total_vqs;
> > >  	const char **names;
> > > +	u32 *sizes;
> > >  	bool *ctx;
> > >
> > >  	/* We expect 1 RX virtqueue followed by 1 TX virtqueue, followed by
> > > @@ -3242,10 +3266,15 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> > >  		ctx = NULL;
> > >  	}
> > >
> > > +	sizes = kmalloc_array(total_vqs, sizeof(*sizes), GFP_KERNEL);
> > > +	if (!sizes)
> > > +		goto err_sizes;
> > > +
> > >  	/* Parameters for control virtqueue, if any */
> > >  	if (vi->has_cvq) {
> > >  		callbacks[total_vqs - 1] = NULL;
> > >  		names[total_vqs - 1] = "control";
> > > +		sizes[total_vqs - 1] = 64;
> > >  	}
> > >
> > >  	/* Allocate/initialize parameters for send/receive virtqueues */
> > > @@ -3260,8 +3289,10 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> > >  			ctx[rxq2vq(i)] = true;
> > >  	}
> > >
> > > -	ret = virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, callbacks,
> > > -				  names, ctx, NULL);
> > > +	virtnet_config_sizes(vi, sizes);
> > > +
> > > +	ret = virtio_find_vqs_ctx_size(vi->vdev, total_vqs, vqs, callbacks,
> > > +				       names, sizes, ctx, NULL);
> > >  	if (ret)
> > >  		goto err_find;
> > >
> > > @@ -3281,6 +3312,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
> > >
> > >
> > >  err_find:
> > > +	kfree(sizes);
> > > +err_sizes:
> > >  	kfree(ctx);
> > >  err_ctx:
> > >  	kfree(names);
> > > @@ -3630,6 +3663,9 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >  		vi->curr_queue_pairs = num_online_cpus();
> > >  	vi->max_queue_pairs = max_queue_pairs;
> > >
> > > +	virtnet_init_settings(dev);
> > > +	virtnet_update_settings(vi);
> > > +
> > >  	/* Allocate/initialize the rx/tx queues, and invoke find_vqs */
> > >  	err = init_vqs(vi);
> > >  	if (err)
> > > @@ -3642,8 +3678,6 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >  	netif_set_real_num_tx_queues(dev, vi->curr_queue_pairs);
> > >  	netif_set_real_num_rx_queues(dev, vi->curr_queue_pairs);
> > >
> > > -	virtnet_init_settings(dev);
> > > -
> > >  	if (virtio_has_feature(vdev, VIRTIO_NET_F_STANDBY)) {
> > >  		vi->failover = net_failover_create(vi->dev);
> > >  		if (IS_ERR(vi->failover)) {
> > > --
> > > 2.31.0
> >

