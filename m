Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE64B7618F2
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 14:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjGYMyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 08:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232326AbjGYMyg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 08:54:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC17FDA
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 05:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690289630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MmWb5Pp2aBYvWbRypNFuJKIythziPszATpLaSdkin2c=;
        b=JSQk9NkrhQkmeTHXsLpFuL08hj7Q9kNX9E9Na89GeLXkyEo7TuM4Nc+nUiYHNMPrwWlUYz
        N4MHYg54/8MwBo87SbWp7zD8CqAq2h1hm+lW8JD/jFJZ/ANdUywMUoddmQoMWLibVcvtfy
        U7H0pM9EJOtdOSDsbfQAoNXU85K2610=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-laptNxK2PveZHPmC-WF9OA-1; Tue, 25 Jul 2023 08:53:48 -0400
X-MC-Unique: laptNxK2PveZHPmC-WF9OA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-993eeb3a950so322592966b.2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 05:53:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690289627; x=1690894427;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MmWb5Pp2aBYvWbRypNFuJKIythziPszATpLaSdkin2c=;
        b=kF6nh4LaSD5IzV8TKAs5eByvqfsRCA5i9AciBX2+5BPCiC3atz98sLHdssIBMYfbHb
         5mxpvLb+7D9XWWqZW08U8WNdUCihnQv15gQZ4MHobZYljBWDVZydH0Onr8/9KejIM8BM
         CWRRXIbjpkTi1ixV36YfpCWeLEGty2d2ezPzty22JyWOWsLM3HFHDEkHL/JgkhmeIizX
         LucG/4ks3iSViBTvpWiTDPpBd80dsuNpOZqJMJRDxNicv0RaddoIHFIGk3TT+0T7Cqy8
         eisxRJvyM0z/+kMsbTgIx31TEaxFP+xRFuvLO/5JG12cdlzyPo+/ltzlDsdYTyF0JecH
         mkHw==
X-Gm-Message-State: ABy/qLZHHNwvuBEhaBsPd+2QIaTSqguIrbLHSWsZq6hVuw7wNpcBIViX
        09U/oI6HmiRXr0yv/KSI6J2NNGCpvbOKZls5qhA7TFarak7j0hon2YE88toMcLgF593kQitbopX
        OVoTa5IOoodv7
X-Received: by 2002:a17:906:cc0e:b0:99b:465c:fb9f with SMTP id ml14-20020a170906cc0e00b0099b465cfb9fmr13115191ejb.8.1690289627615;
        Tue, 25 Jul 2023 05:53:47 -0700 (PDT)
X-Google-Smtp-Source: APBJJlF9hEHB3XaanGeFXLlb0Jn/NAtH89iN4Hg6Yl6csk9/a/jJZiyBsAjb7NfBBPnVzhucf2/x/Q==
X-Received: by 2002:a17:906:cc0e:b0:99b:465c:fb9f with SMTP id ml14-20020a170906cc0e00b0099b465cfb9fmr13115160ejb.8.1690289627167;
        Tue, 25 Jul 2023 05:53:47 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.201.198])
        by smtp.gmail.com with ESMTPSA id k9-20020a1709062a4900b0098748422178sm8162511eje.56.2023.07.25.05.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 05:53:46 -0700 (PDT)
Date:   Tue, 25 Jul 2023 14:53:39 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Arseniy Krasnov <avkrasnov@sberdevices.ru>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v3 4/4] vsock/virtio: MSG_ZEROCOPY flag support
Message-ID: <mul7yiwl2pspfegeanqyezhmw6ol4cxsdshch7ln6w3i2b54bw@7na6bf5kfxwy>
References: <20230720214245.457298-1-AVKrasnov@sberdevices.ru>
 <20230720214245.457298-5-AVKrasnov@sberdevices.ru>
 <091c067b-43a0-da7f-265f-30c8c7e62977@sberdevices.ru>
 <20230725042544-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230725042544-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023 at 07:50:53AM -0400, Michael S. Tsirkin wrote:
>On Fri, Jul 21, 2023 at 08:09:03AM +0300, Arseniy Krasnov wrote:
>>
>>
>> On 21.07.2023 00:42, Arseniy Krasnov wrote:
>> > This adds handling of MSG_ZEROCOPY flag on transmission path: if this
>> > flag is set and zerocopy transmission is possible (enabled in socket
>> > options and transport allows zerocopy), then non-linear skb will be
>> > created and filled with the pages of user's buffer. Pages of user's
>> > buffer are locked in memory by 'get_user_pages()'. Second thing that
>> > this patch does is replace type of skb owning: instead of calling
>> > 'skb_set_owner_sk_safe()' it calls 'skb_set_owner_w()'. Reason of this
>> > change is that '__zerocopy_sg_from_iter()' increments 'sk_wmem_alloc'
>> > of socket, so to decrease this field correctly proper skb destructor is
>> > needed: 'sock_wfree()'. This destructor is set by 'skb_set_owner_w()'.
>> >
>> > Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>> > ---
>> >  Changelog:
>> >  v5(big patchset) -> v1:
>> >   * Refactorings of 'if' conditions.
>> >   * Remove extra blank line.
>> >   * Remove 'frag_off' field unneeded init.
>> >   * Add function 'virtio_transport_fill_skb()' which fills both linear
>> >     and non-linear skb with provided data.
>> >  v1 -> v2:
>> >   * Use original order of last four arguments in 'virtio_transport_alloc_skb()'.
>> >  v2 -> v3:
>> >   * Add new transport callback: 'msgzerocopy_check_iov'. It checks that
>> >     provided 'iov_iter' with data could be sent in a zerocopy mode.
>> >     If this callback is not set in transport - transport allows to send
>> >     any 'iov_iter' in zerocopy mode. Otherwise - if callback returns 'true'
>> >     then zerocopy is allowed. Reason of this callback is that in case of
>> >     G2H transmission we insert whole skb to the tx virtio queue and such
>> >     skb must fit to the size of the virtio queue to be sent in a single
>> >     iteration (may be tx logic in 'virtio_transport.c' could be reworked
>> >     as in vhost to support partial send of current skb). This callback
>> >     will be enabled only for G2H path. For details pls see comment
>> >     'Check that tx queue...' below.
>> >
>> >  include/net/af_vsock.h                  |   3 +
>> >  net/vmw_vsock/virtio_transport.c        |  39 ++++
>> >  net/vmw_vsock/virtio_transport_common.c | 257 ++++++++++++++++++------
>> >  3 files changed, 241 insertions(+), 58 deletions(-)
>> >
>> > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>> > index 0e7504a42925..a6b346eeeb8e 100644
>> > --- a/include/net/af_vsock.h
>> > +++ b/include/net/af_vsock.h
>> > @@ -177,6 +177,9 @@ struct vsock_transport {
>> >
>> >  	/* Read a single skb */
>> >  	int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
>> > +
>> > +	/* Zero-copy. */
>> > +	bool (*msgzerocopy_check_iov)(const struct iov_iter *);
>> >  };
>> >
>> >  /**** CORE ****/
>> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> > index 7bbcc8093e51..23cb8ed638c4 100644
>> > --- a/net/vmw_vsock/virtio_transport.c
>> > +++ b/net/vmw_vsock/virtio_transport.c
>> > @@ -442,6 +442,43 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
>> >  	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
>> >  }
>> >
>> > +static bool virtio_transport_msgzerocopy_check_iov(const struct iov_iter *iov)
>> > +{
>> > +	struct virtio_vsock *vsock;
>> > +	bool res = false;
>> > +
>> > +	rcu_read_lock();
>> > +
>> > +	vsock = rcu_dereference(the_virtio_vsock);
>> > +	if (vsock) {
>> > +		struct virtqueue *vq;
>> > +		int iov_pages;
>> > +
>> > +		vq = vsock->vqs[VSOCK_VQ_TX];
>> > +
>> > +		iov_pages = round_up(iov->count, PAGE_SIZE) / PAGE_SIZE;
>> > +
>> > +		/* Check that tx queue is large enough to keep whole
>> > +		 * data to send. This is needed, because when there is
>> > +		 * not enough free space in the queue, current skb to
>> > +		 * send will be reinserted to the head of tx list of
>> > +		 * the socket to retry transmission later, so if skb
>> > +		 * is bigger than whole queue, it will be reinserted
>> > +		 * again and again, thus blocking other skbs to be sent.
>> > +		 * Each page of the user provided buffer will be added
>> > +		 * as a single buffer to the tx virtqueue, so compare
>> > +		 * number of pages against maximum capacity of the queue.
>> > +		 * +1 means buffer for the packet header.
>> > +		 */
>> > +		if (iov_pages + 1 <= vq->num_max)
>>
>> I think this check is actual only for case one we don't have indirect buffer feature.
>> With indirect mode whole data to send will be packed into one indirect buffer.
>>
>> Thanks, Arseniy
>
>Actually the reverse. With indirect you are limited to num_max.
>Without you are limited to whatever space is left in the
>queue (which you did not check here, so you should).
>
>
>> > +			res = true;
>> > +	}
>> > +
>> > +	rcu_read_unlock();
>
>Just curious:
>is the point of all this RCU dance to allow vsock
>to change from under us? then why is it ok to
>have it change? the virtio_transport_msgzerocopy_check_iov
>will then refer to the old vsock ...

IIRC we introduced the RCU to handle hot-unplug issues:
commit 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on
the_virtio_vsock")

When we remove the device, we flush all the works, etc. so we should
not be in this case (referring the old vsock), except for an irrelevant
transient as the device is disappearing.

Stefano

