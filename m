Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22124FCF2B
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 07:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348543AbiDLF43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 01:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346495AbiDLF4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 01:56:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80E9ADFE
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 22:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649742845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=691Yo4tOxFREJuTeRonUH/gcyvI9lkMUJMdeyqkXSWQ=;
        b=VLRpx/y604ulpSnHd3oBgBryQ40YJV47hpgWmgMyhOka4OkTXOmdYl039yS9UbH5WW8vMr
        JQqbFsSZ5kawEQqCUqaptL4VTrq5vhk913MGoiaYk7WMI7ScN+j+9xyLpa89O6AuJ5tyGF
        Rd9a2H4W64zl+dIpveDfj4zkO3f8sbw=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-Hc_NacKFO1SyzyVoO6SHZQ-1; Tue, 12 Apr 2022 01:54:03 -0400
X-MC-Unique: Hc_NacKFO1SyzyVoO6SHZQ-1
Received: by mail-pg1-f197.google.com with SMTP id bf10-20020a656d0a000000b0039d4f854e22so2973170pgb.5
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 22:54:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=691Yo4tOxFREJuTeRonUH/gcyvI9lkMUJMdeyqkXSWQ=;
        b=eJYEnQns7MFDc3ZVujAIUnXSmq6a02cYPa+EpcB7XyvHNK2uPj6BexRyZRoDYCbVpY
         rv8ObU4/H00XFV9kmsbHTdLs/Ttj8QAdHTbh148bDM5K1isoOJTyVZM4pqzLuOImWh4K
         4VKx08knScP8KHmgOTKR9oNurSNfKAGTFXBIsBgJcVW8hXihO64uV/JlAcqU0Szl7Nqz
         M5Og+hOMruThqc4Q23SG4Rs5akhLy1wwPIVl/CRpzXdgKmmNdobFj4XxhoJ+xHupR63e
         1z1hWJUxohAu9b9R1M3fpfrg7+6y0ZwIxQCUB7UqCupucf/h65YQEFvVAwMTKMDqXpuO
         HaYQ==
X-Gm-Message-State: AOAM532SsX7W0aZ9Ke5qYkxNO5vBjyfZg+7ivQucnCAo+AtVZJEmy3I4
        4VRYzvgYq1JCqEMbhnNL09/pCTe9fzHjQx1EIezGmsWKx898yKwuajwZDvH+WPZq0VLqColic1g
        wq7zRaz2IZu0y
X-Received: by 2002:a17:902:f683:b0:158:8178:e7a0 with SMTP id l3-20020a170902f68300b001588178e7a0mr3510846plg.160.1649742841865;
        Mon, 11 Apr 2022 22:54:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOjt8nlerN6jXVH9ANx2m0/Qvxoufl1r0WhRPAfaTl2kJvP+NMMrr2TTbfemTY216uBaWV4Q==
X-Received: by 2002:a17:902:f683:b0:158:8178:e7a0 with SMTP id l3-20020a170902f68300b001588178e7a0mr3510808plg.160.1649742841583;
        Mon, 11 Apr 2022 22:54:01 -0700 (PDT)
Received: from [10.72.14.5] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g12-20020a056a001a0c00b004e1307b249csm37755988pfv.69.2022.04.11.22.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Apr 2022 22:54:01 -0700 (PDT)
Message-ID: <f79fc367-7ac5-961b-83c5-90f3d097c672@redhat.com>
Date:   Tue, 12 Apr 2022 13:53:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v9 11/32] virtio_ring: split: introduce
 virtqueue_resize_split()
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
 <20220406034346.74409-12-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220406034346.74409-12-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/4/6 上午11:43, Xuan Zhuo 写道:
> virtio ring split supports resize.
>
> Only after the new vring is successfully allocated based on the new num,
> we will release the old vring. In any case, an error is returned,
> indicating that the vring still points to the old vring.
>
> In the case of an error, the caller must
> re-initialize(virtqueue_reinit_split()) the virtqueue to ensure that the
> vring can be used.
>
> In addition, vring_align, may_reduce_num are necessary for reallocating
> vring, so they are retained for creating vq.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/virtio/virtio_ring.c | 47 ++++++++++++++++++++++++++++++++++++
>   1 file changed, 47 insertions(+)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 3dc6ace2ba7a..33864134a744 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -139,6 +139,12 @@ struct vring_virtqueue {
>   			/* DMA address and size information */
>   			dma_addr_t queue_dma_addr;
>   			size_t queue_size_in_bytes;
> +
> +			/* The parameters for creating vrings are reserved for
> +			 * creating new vring.
> +			 */
> +			u32 vring_align;
> +			bool may_reduce_num;
>   		} split;
>   
>   		/* Available for packed ring */
> @@ -199,6 +205,7 @@ struct vring_virtqueue {
>   };
>   
>   static struct vring_desc_extra *vring_alloc_desc_extra(unsigned int num);
> +static void vring_free(struct virtqueue *_vq);
>   
>   /*
>    * Helpers.
> @@ -1088,6 +1095,8 @@ static struct virtqueue *vring_create_virtqueue_split(
>   		return NULL;
>   	}
>   
> +	to_vvq(vq)->split.vring_align = vring_align;
> +	to_vvq(vq)->split.may_reduce_num = may_reduce_num;


It looks to me the above should belong to patch 6.


>   	to_vvq(vq)->split.queue_dma_addr = dma_addr;
>   	to_vvq(vq)->split.queue_size_in_bytes = queue_size_in_bytes;
>   	to_vvq(vq)->we_own_ring = true;
> @@ -1095,6 +1104,44 @@ static struct virtqueue *vring_create_virtqueue_split(
>   	return vq;
>   }
>   
> +static int virtqueue_resize_split(struct virtqueue *_vq, u32 num)
> +{
> +	struct vring_virtqueue *vq = to_vvq(_vq);
> +	struct virtio_device *vdev = _vq->vdev;
> +	struct vring_desc_state_split *state;
> +	struct vring_desc_extra *extra;
> +	size_t queue_size_in_bytes;
> +	dma_addr_t dma_addr;
> +	struct vring vring;
> +	int err = -ENOMEM;
> +	void *queue;
> +
> +	queue = vring_alloc_queue_split(vdev, &dma_addr, &num,
> +					vq->split.vring_align,
> +					vq->weak_barriers,
> +					vq->split.may_reduce_num);
> +	if (!queue)
> +		return -ENOMEM;
> +
> +	queue_size_in_bytes = vring_size(num, vq->split.vring_align);
> +
> +	err = vring_alloc_state_extra_split(num, &state, &extra);
> +	if (err) {
> +		vring_free_queue(vdev, queue_size_in_bytes, queue, dma_addr);
> +		return -ENOMEM;
> +	}
> +
> +	vring_free(&vq->vq);
> +
> +	vring_init(&vring, num, queue, vq->split.vring_align);
> +	vring_virtqueue_attach_split(vq, vring, state, extra);
> +	vq->split.queue_dma_addr = dma_addr;
> +	vq->split.queue_size_in_bytes = queue_size_in_bytes;


I wonder if it's better to move the above assignments to 
vring_virtqueue_attach_split().

Other looks good.

Thanks


> +
> +	vring_virtqueue_init_split(vq, vdev, true);
> +	return 0;
> +}
> +
>   
>   /*
>    * Packed ring specific functions - *_packed().

