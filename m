Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A00581DCF
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 04:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240141AbiG0C6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 22:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240139AbiG0C6Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 22:58:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CD26371B4
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 19:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658890701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NwgcPcXk6z7kgNTCqH1DZ8dzrfHRERNfOmiystTGRCg=;
        b=eZydlh0X7GrW0nILFHvcYOiEACC1J63b31OTR4xtxiEDTwIZ6UDLsxq1UKBm1p9RP9V73T
        BtMw/P0x2Dmd8l6Qtf63igZtvYYYJwKB1HnBEbM5HVmUh6AQXjJlG2LIvHciKRALWw3JHt
        zZqdiYMpYxesLLXN0QqHfUqfhq9uTw8=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148--ajM2Rv-OPO4_ky5yw-XIA-1; Tue, 26 Jul 2022 22:58:20 -0400
X-MC-Unique: -ajM2Rv-OPO4_ky5yw-XIA-1
Received: by mail-pj1-f69.google.com with SMTP id ot17-20020a17090b3b5100b001f2c064b8b0so1408482pjb.1
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 19:58:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NwgcPcXk6z7kgNTCqH1DZ8dzrfHRERNfOmiystTGRCg=;
        b=gk20V8/LXAylgPPr5y+pCnBxNET+6OpwysD7K+6j42fwBeA/1Em/BawDSPZIU5T0EF
         vARdzoGo2pyL6/8nC9/F7dJKPOr5cwicBtDNNMLbR75hqdlCBgxFsrd8z2qaxWK9ngIU
         Vao9DyPu+ZU3NlH+6WhdjP2aucBLMuc4o4tUlqdFED+CJnicZpVPi+x1UQ5/T+c7aYxw
         HGn74d2z7uVU224lVbLszs+gXzYUoCjKdWZjyO0xKh5aepSZzotVXFUF2t34WrA0cjXj
         NL2//4mNxUe7STZ3UthJRZZ2gvoB1Qo9/iLnpS5f4sgkuUeUwOCTffRYu+dYrxx2G0RN
         333A==
X-Gm-Message-State: AJIora8a7yno7qZ6Dad+TVXBJbPLdljVKDm7fGMI+gYKjv0OwoC3WFCj
        mK5vOP5ANrY42tQ2n50wn1ssW/DamMaM2Ltn9n+M3cDnXADsS8u/HDZ8N1Pa4o7zZjy/P19KF0D
        m2O3GsyCZzqBO
X-Received: by 2002:a05:6a00:3498:b0:52a:f8f4:ca7c with SMTP id cp24-20020a056a00349800b0052af8f4ca7cmr20263309pfb.5.1658890699171;
        Tue, 26 Jul 2022 19:58:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uuhsCO0beWJTkbHykdBYq0Xbk9J6+h1S6RkU7roXWbxlzqfZMfKPxtL0BmhUqMmNTZjLJ/Gg==
X-Received: by 2002:a05:6a00:3498:b0:52a:f8f4:ca7c with SMTP id cp24-20020a056a00349800b0052af8f4ca7cmr20263286pfb.5.1658890698768;
        Tue, 26 Jul 2022 19:58:18 -0700 (PDT)
Received: from [10.72.13.38] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u8-20020a1709026e0800b0016c29dcf1f7sm12230642plk.122.2022.07.26.19.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 19:58:18 -0700 (PDT)
Message-ID: <a5449e49-ba38-9760-ac07-cfad048bc602@redhat.com>
Date:   Wed, 27 Jul 2022 10:58:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v13 07/42] virtio_ring: split: stop __vring_new_virtqueue
 as export symbol
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
 <20220726072225.19884-8-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220726072225.19884-8-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/7/26 15:21, Xuan Zhuo 写道:
> There is currently only one place to reference __vring_new_virtqueue()
> directly from the outside of virtio core. And here vring_new_virtqueue()
> can be used instead.
>
> Subsequent patches will modify __vring_new_virtqueue, so stop it as an
> export symbol for now.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/virtio/virtio_ring.c | 25 ++++++++++++++++---------
>   include/linux/virtio_ring.h  | 10 ----------
>   tools/virtio/virtio_test.c   |  4 ++--
>   3 files changed, 18 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 0ad35eca0d39..4e54ed7ee7fb 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -204,6 +204,14 @@ struct vring_virtqueue {
>   #endif
>   };
>   
> +static struct virtqueue *__vring_new_virtqueue(unsigned int index,
> +					       struct vring vring,
> +					       struct virtio_device *vdev,
> +					       bool weak_barriers,
> +					       bool context,
> +					       bool (*notify)(struct virtqueue *),
> +					       void (*callback)(struct virtqueue *),
> +					       const char *name);
>   
>   /*
>    * Helpers.
> @@ -2197,14 +2205,14 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
>   EXPORT_SYMBOL_GPL(vring_interrupt);
>   
>   /* Only available for split ring */
> -struct virtqueue *__vring_new_virtqueue(unsigned int index,
> -					struct vring vring,
> -					struct virtio_device *vdev,
> -					bool weak_barriers,
> -					bool context,
> -					bool (*notify)(struct virtqueue *),
> -					void (*callback)(struct virtqueue *),
> -					const char *name)
> +static struct virtqueue *__vring_new_virtqueue(unsigned int index,
> +					       struct vring vring,
> +					       struct virtio_device *vdev,
> +					       bool weak_barriers,
> +					       bool context,
> +					       bool (*notify)(struct virtqueue *),
> +					       void (*callback)(struct virtqueue *),
> +					       const char *name)
>   {
>   	struct vring_virtqueue *vq;
>   
> @@ -2272,7 +2280,6 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   	kfree(vq);
>   	return NULL;
>   }
> -EXPORT_SYMBOL_GPL(__vring_new_virtqueue);
>   
>   struct virtqueue *vring_create_virtqueue(
>   	unsigned int index,
> diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> index b485b13fa50b..8b8af1a38991 100644
> --- a/include/linux/virtio_ring.h
> +++ b/include/linux/virtio_ring.h
> @@ -76,16 +76,6 @@ struct virtqueue *vring_create_virtqueue(unsigned int index,
>   					 void (*callback)(struct virtqueue *vq),
>   					 const char *name);
>   
> -/* Creates a virtqueue with a custom layout. */
> -struct virtqueue *__vring_new_virtqueue(unsigned int index,
> -					struct vring vring,
> -					struct virtio_device *vdev,
> -					bool weak_barriers,
> -					bool ctx,
> -					bool (*notify)(struct virtqueue *),
> -					void (*callback)(struct virtqueue *),
> -					const char *name);
> -
>   /*
>    * Creates a virtqueue with a standard layout but a caller-allocated
>    * ring.
> diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
> index 23f142af544a..86a410ddcedd 100644
> --- a/tools/virtio/virtio_test.c
> +++ b/tools/virtio/virtio_test.c
> @@ -102,8 +102,8 @@ static void vq_reset(struct vq_info *info, int num, struct virtio_device *vdev)
>   
>   	memset(info->ring, 0, vring_size(num, 4096));
>   	vring_init(&info->vring, num, info->ring, 4096);


Let's remove the duplicated vring_init() here.

With this removed:

Acked-by: Jason Wang <jasowang@redhat.com>


> -	info->vq = __vring_new_virtqueue(info->idx, info->vring, vdev, true,
> -					 false, vq_notify, vq_callback, "test");
> +	info->vq = vring_new_virtqueue(info->idx, num, 4096, vdev, true, false,
> +				       info->ring, vq_notify, vq_callback, "test");
>   	assert(info->vq);
>   	info->vq->priv = info;
>   }

