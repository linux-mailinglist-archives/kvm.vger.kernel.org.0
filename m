Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9621B4FD0E7
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 08:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350612AbiDLG4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 02:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351510AbiDLGxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 02:53:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F337437A82
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 23:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649745696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q0hJ1ezC0n70T2nueon8V1dFA7gdJyx9ipWOKSYhKjA=;
        b=UA9Y55jBqNBzd7K/zV6sVt9rXoPjFG/fIRaZDAv5KPKhFYLLKCp9l1F9/7/Gk8HAUfZNBx
        kNQcOC1UnjCdhSUZtyBlJwUUYGAWh4GEhWQO4buLvhiyvgeOGlKk9061im1v7lGFA7Z/NR
        38hNtPCdEzbxL0NYRZ0HHtYBG13JuyQ=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-4slqFNn1NsmFkMzsxKZ1pA-1; Tue, 12 Apr 2022 02:41:35 -0400
X-MC-Unique: 4slqFNn1NsmFkMzsxKZ1pA-1
Received: by mail-pl1-f199.google.com with SMTP id o16-20020a170902d4d000b00158504bca6fso2179293plg.13
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 23:41:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q0hJ1ezC0n70T2nueon8V1dFA7gdJyx9ipWOKSYhKjA=;
        b=ZSCmFRo0gpu5lVYMu7xUbIwtykqVT7lxZZDpx7ugZJg4t3VFkwQVhcwKPJqWv0TJxH
         8GRVWY0bFeq/oIGh9pERSyLB8Pe2hmSBnXDxHdbJHOov7i170y8vPh81e6M33a2OxnDy
         +qRIoWAFM/5/D29thJLtA5yKmfhGGEUnEnkzXsuSZYVLFcjrr07wdv8KbtIaMkYExsrT
         S7NOlGtxtuPBn5acYB7ODP4TBwGWX7E7urG4aH6SjMmYbIzpTOne+DHyxYaZOl2JzCMo
         8Xiq8yTInstnzYUcXbE68JA45QlBvEGcAJATaMHwiOh48Pr4teSi26vCdowOPZWlL0lb
         VjKA==
X-Gm-Message-State: AOAM532OPFob+AgnHKtWR8mIW4dzsHfkr2KrW1dgbG6d8uhda2gAEmgF
        7ckmWLDdvX1itlods9/0eomUfN+2uDN+S5XvIGzC6bNP2+ETG6aEr+sMoPucDwFmAVIKR3rfFh6
        X1FKpLgtWh9k1
X-Received: by 2002:aa7:9041:0:b0:4fe:3d6c:1739 with SMTP id n1-20020aa79041000000b004fe3d6c1739mr3123243pfo.13.1649745693940;
        Mon, 11 Apr 2022 23:41:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcN4j4exOoT+eN9+MrdAypldpi+vnmAZMQ+PJ/c+O0wbKWe6GyXiWgL61SrqAdNRlxVdSHkg==
X-Received: by 2002:aa7:9041:0:b0:4fe:3d6c:1739 with SMTP id n1-20020aa79041000000b004fe3d6c1739mr3123226pfo.13.1649745693656;
        Mon, 11 Apr 2022 23:41:33 -0700 (PDT)
Received: from [10.72.14.5] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y192-20020a6264c9000000b00505fa595c5asm1265152pfb.129.2022.04.11.23.41.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 23:41:33 -0700 (PDT)
Message-ID: <92622553-e02d-47bd-06f9-0ce24c22650c@redhat.com>
Date:   Tue, 12 Apr 2022 14:41:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v9 18/32] virtio_ring: introduce virtqueue_resize()
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220406034346.74409-19-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220406034346.74409-19-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/4/6 上午11:43, Xuan Zhuo 写道:
> Introduce virtqueue_resize() to implement the resize of vring.
> Based on these, the driver can dynamically adjust the size of the vring.
> For example: ethtool -G.
>
> virtqueue_resize() implements resize based on the vq reset function. In
> case of failure to allocate a new vring, it will give up resize and use
> the original vring.
>
> During this process, if the re-enable reset vq fails, the vq can no
> longer be used. Although the probability of this situation is not high.
>
> The parameter recycle is used to recycle the buffer that is no longer
> used.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/virtio/virtio_ring.c | 69 ++++++++++++++++++++++++++++++++++++
>   include/linux/virtio.h       |  3 ++
>   2 files changed, 72 insertions(+)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 06f66b15c86c..6250e19fc5bf 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -2554,6 +2554,75 @@ struct virtqueue *vring_create_virtqueue(
>   }
>   EXPORT_SYMBOL_GPL(vring_create_virtqueue);
>   
> +/**
> + * virtqueue_resize - resize the vring of vq
> + * @_vq: the struct virtqueue we're talking about.
> + * @num: new ring num
> + * @recycle: callback for recycle the useless buffer
> + *
> + * When it is really necessary to create a new vring, it will set the current vq
> + * into the reset state. Then call the passed callback to recycle the buffer
> + * that is no longer used. Only after the new vring is successfully created, the
> + * old vring will be released.
> + *
> + * Caller must ensure we don't call this with other virtqueue operations
> + * at the same time (except where noted).
> + *
> + * Returns zero or a negative error.


Should we document that the virtqueue is kept unchanged (still 
available) on (specific) failure?


> + */
> +int virtqueue_resize(struct virtqueue *_vq, u32 num,
> +		     void (*recycle)(struct virtqueue *vq, void *buf))
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +	struct virtio_device *vdev = vq->vq.vdev;
> +	bool packed;
> +	void *buf;
> +	int err;
> +
> +	if (!vq->we_own_ring)
> +		return -EINVAL;
> +
> +	if (num > vq->vq.num_max)
> +		return -E2BIG;
> +
> +	if (!num)
> +		return -EINVAL;
> +
> +	packed = virtio_has_feature(vdev, VIRTIO_F_RING_PACKED) ? true : false;
> +
> +	if ((packed ? vq->packed.vring.num : vq->split.vring.num) == num)
> +		return 0;
> +
> +	if (!vdev->config->reset_vq)
> +		return -ENOENT;
> +
> +	if (!vdev->config->enable_reset_vq)
> +		return -ENOENT;
> +
> +	err = vdev->config->reset_vq(_vq);
> +	if (err)
> +		return err;
> +
> +	while ((buf = virtqueue_detach_unused_buf(_vq)) != NULL)
> +		recycle(_vq, buf);
> +
> +	if (packed) {
> +		err = virtqueue_resize_packed(_vq, num);
> +		if (err)
> +			virtqueue_reinit_packed(vq);


Calling reinit here seems a little bit odd, it looks more like a reset 
of the virtqueue. Consider we may re-use virtqueue reset for more 
purpose, I wonder if we need a helper like:

virtqueue_resize() {
     vdev->config->reset_vq(_vq);
     if (packed)
         virtqueue_reinit_packed(_vq)
     else
         virtqueue_reinit_split(_vq)
}

Thanks


> +	} else {
> +		err = virtqueue_resize_split(_vq, num);
> +		if (err)
> +			virtqueue_reinit_split(vq);
> +	}
> +
> +	if (vdev->config->enable_reset_vq(_vq))
> +		return -EBUSY;
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(virtqueue_resize);
> +
>   /* Only available for split ring */
>   struct virtqueue *vring_new_virtqueue(unsigned int index,
>   				      unsigned int num,
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index d59adc4be068..c86ff02e0ca0 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -91,6 +91,9 @@ dma_addr_t virtqueue_get_desc_addr(struct virtqueue *vq);
>   dma_addr_t virtqueue_get_avail_addr(struct virtqueue *vq);
>   dma_addr_t virtqueue_get_used_addr(struct virtqueue *vq);
>   
> +int virtqueue_resize(struct virtqueue *vq, u32 num,
> +		     void (*recycle)(struct virtqueue *vq, void *buf));
> +
>   /**
>    * virtio_device - representation of a device using virtio
>    * @index: unique position on the virtio bus

