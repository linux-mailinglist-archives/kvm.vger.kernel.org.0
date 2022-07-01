Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421DC562FFF
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 11:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiGAJ21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 05:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbiGAJ2G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 05:28:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EAA9D222
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 02:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656667684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZBQdYZv/rBFNAXGUnNhg85FJcoNaGILlYzbcDNSwkmw=;
        b=cHId9CfxY2njisSmYmfwKhReeNPfxpyDTfaA3pP6FW8vphJiE4rWB182GpXHwsWYon7Fon
        +1cAJoSvolE0ckSmZp8oxpJe40srLqJLCDzIVa+rftWsF6R14AsC9Ye/LnoQbUeFpueOwD
        2q89Z+F+gsEbgcBTqB4mMlWRF8HPmhc=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-R--0D7doMwKxwbfMWtKwLA-1; Fri, 01 Jul 2022 05:28:03 -0400
X-MC-Unique: R--0D7doMwKxwbfMWtKwLA-1
Received: by mail-pf1-f198.google.com with SMTP id b18-20020aa78ed2000000b0052541d34055so760502pfr.23
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 02:28:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZBQdYZv/rBFNAXGUnNhg85FJcoNaGILlYzbcDNSwkmw=;
        b=18xPOr6UNOsvTJHD2MQwTwrtKbqHUXks6YWY3dGnhsw/b0gWimnIULWiTPlHj87sKB
         xRQGJEVXn7ZOVVFDp7ALg/plc20viX7b8v2+5JvkRR/ew0kp5wDm8QRmxPNDYqbejVcX
         yVQgioF+tY7sCiijJC7TA1VZrPm7k47OJ9/U3mS5x28cenyPjQaoNJ0qQRLla8Br69/A
         JAhrHgVKBLMP/4qkbbKsBdIq4k6LY/0Jsr03iymkbZtjrFRXy5tYBvjlUXrnmFqW4wz9
         3V38AfcSv/EpwXlaab2F/6dEF4Y+AaK8Pz/g0UmxTJZoetudGLVaAxhWfB1XKBmm2u+R
         7YDg==
X-Gm-Message-State: AJIora8i1nmrKnhjoWPOPGAqKGpP4Itk813PJkKblWw2jxvK7eCbXFpv
        PzZ+jPYU/dAjeIzvYc1CmQUPEOMAMPStWi3XPwGLFYGCvbBRCVkKTedo19a1qBONkcHZ7Y8Zd+U
        L68IyQrF6lrLN
X-Received: by 2002:a17:90b:3141:b0:1ed:4ffb:f911 with SMTP id ip1-20020a17090b314100b001ed4ffbf911mr17631415pjb.80.1656667679989;
        Fri, 01 Jul 2022 02:27:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v7wu5Pr52fEWhoICBbqVrBx5u9VuzueVx4HVEs9nrjbr1aixGJWRwEIuEt0pnr6Hnq0W2LoA==
X-Received: by 2002:a17:90b:3141:b0:1ed:4ffb:f911 with SMTP id ip1-20020a17090b314100b001ed4ffbf911mr17631389pjb.80.1656667679758;
        Fri, 01 Jul 2022 02:27:59 -0700 (PDT)
Received: from [10.72.13.237] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a9-20020aa79709000000b00528208d3056sm1775809pfg.64.2022.07.01.02.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 02:27:59 -0700 (PDT)
Message-ID: <de7cf56d-acbd-1a2b-2226-a9fdd89afb78@redhat.com>
Date:   Fri, 1 Jul 2022 17:27:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v11 21/40] virtio_ring: packed: introduce
 virtqueue_resize_packed()
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
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-22-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220629065656.54420-22-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/6/29 14:56, Xuan Zhuo 写道:
> virtio ring packed supports resize.
>
> Only after the new vring is successfully allocated based on the new num,
> we will release the old vring. In any case, an error is returned,
> indicating that the vring still points to the old vring.
>
> In the case of an error, re-initialize(by virtqueue_reinit_packed()) the
> virtqueue to ensure that the vring can be used.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/virtio/virtio_ring.c | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 650f701a5480..4860787286db 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2042,6 +2042,35 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   	return NULL;
>   }
>   
> +static int virtqueue_resize_packed(struct virtqueue *_vq, u32 num)
> +{
> +	struct vring_virtqueue_packed vring = {};
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +	struct virtio_device *vdev = _vq->vdev;
> +	int err;
> +
> +	if (vring_alloc_queue_packed(&vring, vdev, num))
> +		goto err_ring;
> +
> +	err = vring_alloc_state_extra_packed(&vring);
> +	if (err)
> +		goto err_state_extra;
> +
> +	vring_free(&vq->vq);
> +
> +	virtqueue_init(vq, vring.vring.num);
> +	virtqueue_vring_attach_packed(vq, &vring);
> +	virtqueue_vring_init_packed(vq);
> +
> +	return 0;
> +
> +err_state_extra:
> +	vring_free_packed(&vring, vdev);
> +err_ring:
> +	virtqueue_reinit_packed(vq);


So desc_state and desc_extra has been freed vring_free_packed() when 
vring_alloc_state_extra_packed() fails. We might get use-after-free here?

Actually, I think for resize we need

1) detach old
2) allocate new
3) if 2) succeed, attach new otherwise attach old

This seems more clearer than the current logic?

Thanks


> +	return -ENOMEM;
> +}
> +
>   
>   /*
>    * Generic functions and exported symbols.

