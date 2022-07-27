Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE50C581EF7
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 06:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240311AbiG0EfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 00:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240226AbiG0Eex (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 00:34:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DED8E3DF1B
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 21:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658896490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ccV224xkXshDy5Rfnr1IHUz5X0tm4nlYhk3kCg3nne0=;
        b=dQovFIVrcD79kzlYunBHdhgzcVGGdM9sxwEfDmYcgv9fMHaAaO8qvacLsKpZN6dA61mowk
        ItbLGZ0DOlDbucQooa7Dh8Y6mCXu/Iu6qAOWe4INc4AUtxRotJjlydbCqXHTY0Wl1Ilfgm
        h3olyG3I7gPOr2EQyrDfRnCgNUua0GM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-fPbxJeb5MPuuOQ1xn47TOw-1; Wed, 27 Jul 2022 00:34:48 -0400
X-MC-Unique: fPbxJeb5MPuuOQ1xn47TOw-1
Received: by mail-pl1-f200.google.com with SMTP id n15-20020a170902d2cf00b0016d68b4fcc0so5312663plc.8
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 21:34:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ccV224xkXshDy5Rfnr1IHUz5X0tm4nlYhk3kCg3nne0=;
        b=2yDmgLcc9wXPjs0tJ1+bJWjo8M+yVhTvmrWiatL/PTfdt1ZMBIFw/mc48AnphLaEgh
         Gxm54kR0jCBwXxN/CSJfbWPzAlpU2iW2RFlEs4cHMfRlJ4TmW+U4O9G41+tG5avnDMLG
         mSsbKw9RSGXvXUGAyegitWrGY2D7SGQrm1IXveElBkdhX/7njLWcjgc48sfPRfPrZ0zY
         vju90UIJEwar7syWrSCkq8cUwHqW4nSpRa1veAQ8BhKdAsq3k42rR3KR5/aEhM8faFyi
         a4oEHZ2s05X92NuXOWIKoT++vBmcTUGo7LFUYgYDPIwx1M6pfSW8TSY9AFsGIoj8urY2
         tWPQ==
X-Gm-Message-State: AJIora+nSC/GlmlFDuUvsKnHrH/ir7gq/q6WqjAOdIDQy/5A63GXF7QD
        c4r5+bPg7KCtHWwxwfEnfI0s1uPlSHPc6enrye5T31ILEZMpsBmFH/wA4nyHsZzQDbXPfxk+sPs
        XqER6w1j7d9/V
X-Received: by 2002:a63:d64e:0:b0:41a:b83d:1b2a with SMTP id d14-20020a63d64e000000b0041ab83d1b2amr15478521pgj.122.1658896487307;
        Tue, 26 Jul 2022 21:34:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t/FJ74Zcl7b0UCclD3iCK7AwYJZlRdXpyiM8TPXcthnYH8m/z4m9rgQ1C6aXiOk5BimF8JNw==
X-Received: by 2002:a63:d64e:0:b0:41a:b83d:1b2a with SMTP id d14-20020a63d64e000000b0041ab83d1b2amr15478481pgj.122.1658896487011;
        Tue, 26 Jul 2022 21:34:47 -0700 (PDT)
Received: from [10.72.12.96] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w2-20020a1709026f0200b0016be24e3668sm12363324plk.291.2022.07.26.21.34.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 21:34:45 -0700 (PDT)
Message-ID: <055a1aa0-756a-778d-3039-6eb452ccd390@redhat.com>
Date:   Wed, 27 Jul 2022 12:34:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v13 21/42] virtio_ring: packed: extract the logic of
 attach vring
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
References: <20220726072225.19884-1-xuanzhuo@linux.alibaba.com>
 <20220726072225.19884-22-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220726072225.19884-22-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/7/26 15:22, Xuan Zhuo 写道:
> Separate the logic of attach vring, the subsequent patch will call it
> separately.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/virtio/virtio_ring.c | 19 +++++++------------
>   1 file changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index fc4e3db9f93b..00b18cf3b4d9 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -1951,6 +1951,12 @@ static void virtqueue_vring_init_packed(struct vring_virtqueue_packed *vring_pac
>   	}
>   }
>   
> +static void virtqueue_vring_attach_packed(struct vring_virtqueue *vq,
> +					  struct vring_virtqueue_packed *vring_packed)
> +{
> +	vq->packed = *vring_packed;
> +}
> +
>   static struct virtqueue *vring_create_virtqueue_packed(
>   	unsigned int index,
>   	unsigned int num,
> @@ -1991,25 +1997,14 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
>   		!context;
>   
> -	vq->packed.ring_dma_addr = vring_packed.ring_dma_addr;
> -	vq->packed.driver_event_dma_addr = vring_packed.driver_event_dma_addr;
> -	vq->packed.device_event_dma_addr = vring_packed.device_event_dma_addr;
> -
> -	vq->packed.ring_size_in_bytes = vring_packed.ring_size_in_bytes;
> -	vq->packed.event_size_in_bytes = vring_packed.event_size_in_bytes;
> -
> -	vq->packed.vring = vring_packed.vring;
> -
>   	err = vring_alloc_state_extra_packed(&vring_packed);
>   	if (err)
>   		goto err_state_extra;
>   
> -	vq->packed.desc_state = vring_packed.desc_state;
> -	vq->packed.desc_extra = vring_packed.desc_extra;
> -
>   	virtqueue_vring_init_packed(&vring_packed, !!callback);
>   
>   	virtqueue_init(vq, num);
> +	virtqueue_vring_attach_packed(vq, &vring_packed);
>   
>   	spin_lock(&vdev->vqs_list_lock);
>   	list_add_tail(&vq->vq.list, &vdev->vqs);

