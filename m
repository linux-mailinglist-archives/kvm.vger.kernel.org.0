Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E405AFBCF
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 07:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiIGFiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 01:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiIGFiR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 01:38:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0606081B17
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 22:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662529094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z/ijoziX1JqP00j9yW5u7IZw3l7uhHHBn3IFfumff2g=;
        b=M2oSYAtLYc55YIZB/fqd17UJuxdEKFrKSmZGnOammzPBMj0SKdFtA8/xdKeI5t/oQqLJnY
        SXs/D58910xTY8Flyji5xTD4OU//Hqve9IFkJ+pJ5pf1HJ8wjGj9sAblTNI9mZWSU0WCZu
        Ha8jzG/51bOFiO6dezYWU8+q4n4TVc4=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-650-DpPC2iEVM1K53Le7JGi05Q-1; Wed, 07 Sep 2022 01:38:13 -0400
X-MC-Unique: DpPC2iEVM1K53Le7JGi05Q-1
Received: by mail-pg1-f197.google.com with SMTP id 15-20020a63020f000000b0041b578f43f9so6980670pgc.11
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 22:38:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=z/ijoziX1JqP00j9yW5u7IZw3l7uhHHBn3IFfumff2g=;
        b=ecpdluYg1nF+11Z0P9w6VErpPz2wyrwJJEBpmVI6zKuabUJ8VBTDDMVrVuTnysz5fW
         tNn+4q1+qWbvPxv2CxN0FYdjX3jCe9662zkFQIJtdg/j0Ve1CsNWHyGvAv6kx1Pp3TcF
         xprUMDyBAgpk2OFqwEK3jZ0/EGm9CUOsFqjdASkUrL4LoT0xV7S+2smh3hL0j75/zv6L
         JE/pEUq6eK+E7dCweatLp6YZ7rpXFQ/dGc0qcz+BqvhY5+06Yyuz5Kx2djwgqefrV5Cr
         DZJi3P1stEbzinnHuGHLr0NYdhuOSCNLPzUApmxIFYzpuSp+8pE4vEdg9NJs0jnC6a/L
         jCXw==
X-Gm-Message-State: ACgBeo3ls0sw/DJ1joA85hMxBGVUnczIDdw1Jwo/jdUhb2Jb9NIBb/7H
        e+u9USrHTW7AdUJ9DzqQA7zpmV4tegjAJeuY9x/p/pR7DiGp4WNYcMSEpDRWu/assLRLm1wHhU1
        jmGTlXJsmmDA/
X-Received: by 2002:a17:902:ef50:b0:171:516d:d2ce with SMTP id e16-20020a170902ef5000b00171516dd2cemr2150676plx.171.1662529092678;
        Tue, 06 Sep 2022 22:38:12 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5xHIuO0ckPVo1IAdDm+QtW6wb3fUCt/3CAknqurpy5/WVdwoP6vH+j2dzlabcwVg6m63ayGA==
X-Received: by 2002:a17:902:ef50:b0:171:516d:d2ce with SMTP id e16-20020a170902ef5000b00171516dd2cemr2150649plx.171.1662529092367;
        Tue, 06 Sep 2022 22:38:12 -0700 (PDT)
Received: from [10.72.13.171] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902654900b00172ba718ed4sm6142087pln.138.2022.09.06.22.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Sep 2022 22:38:11 -0700 (PDT)
Message-ID: <b1a7c454-860d-6a40-9da1-2a06f30ff1be@redhat.com>
Date:   Wed, 7 Sep 2022 13:38:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [RFC v3 6/7] virtio: in order support for virtio_ring
Content-Language: en-US
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>, eperezma@redhat.com,
        sgarzare@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn>
 <20220901055434.824-7-qtxuning1999@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220901055434.824-7-qtxuning1999@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/9/1 13:54, Guo Zhi 写道:
> If in order feature negotiated, we can skip the used ring to get
> buffer's desc id sequentially.  For skipped buffers in the batch, the
> used ring doesn't contain the buffer length, actually there is not need
> to get skipped buffers' length as they are tx buffer.
>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>   drivers/virtio/virtio_ring.c | 74 +++++++++++++++++++++++++++++++-----
>   1 file changed, 64 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 00aa4b7a49c2..d52624179b43 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -103,6 +103,9 @@ struct vring_virtqueue {
>   	/* Host supports indirect buffers */
>   	bool indirect;
>   
> +	/* Host supports in order feature */
> +	bool in_order;
> +
>   	/* Host publishes avail event idx */
>   	bool event;
>   
> @@ -144,6 +147,19 @@ struct vring_virtqueue {
>   			/* DMA address and size information */
>   			dma_addr_t queue_dma_addr;
>   			size_t queue_size_in_bytes;
> +
> +			/* If in_order feature is negotiated, here is the next head to consume */
> +			u16 next_desc_begin;
> +			/*
> +			 * If in_order feature is negotiated,
> +			 * here is the last descriptor's id in the batch
> +			 */
> +			u16 last_desc_in_batch;
> +			/*
> +			 * If in_order feature is negotiated,
> +			 * buffers except last buffer in the batch are skipped buffer
> +			 */
> +			bool is_skipped_buffer;
>   		} split;
>   
>   		/* Available for packed ring */
> @@ -584,8 +600,6 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>   					 total_sg * sizeof(struct vring_desc),
>   					 VRING_DESC_F_INDIRECT,
>   					 false);
> -		vq->split.desc_extra[head & (vq->split.vring.num - 1)].flags &=
> -			~VRING_DESC_F_NEXT;


This seems irrelevant.


>   	}
>   
>   	/* We're using some buffers from the free list. */
> @@ -701,8 +715,16 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
>   	}
>   
>   	vring_unmap_one_split(vq, i);
> -	vq->split.desc_extra[i].next = vq->free_head;
> -	vq->free_head = head;
> +	/*
> +	 * If in_order feature is negotiated,
> +	 * the descriptors are made available in order.
> +	 * Since the free_head is already a circular list,
> +	 * it must consume it sequentially.
> +	 */
> +	if (!vq->in_order) {
> +		vq->split.desc_extra[i].next = vq->free_head;
> +		vq->free_head = head;
> +	}
>   
>   	/* Plus final descriptor */
>   	vq->vq.num_free++;
> @@ -744,7 +766,7 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue *_vq,
>   {
>   	struct vring_virtqueue *vq = to_vvq(_vq);
>   	void *ret;
> -	unsigned int i;
> +	unsigned int i, j;
>   	u16 last_used;
>   
>   	START_USE(vq);
> @@ -763,11 +785,38 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue *_vq,
>   	/* Only get used array entries after they have been exposed by host. */
>   	virtio_rmb(vq->weak_barriers);
>   
> -	last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
> -	i = virtio32_to_cpu(_vq->vdev,
> -			vq->split.vring.used->ring[last_used].id);
> -	*len = virtio32_to_cpu(_vq->vdev,
> -			vq->split.vring.used->ring[last_used].len);
> +	if (vq->in_order) {
> +		last_used = (vq->last_used_idx & (vq->split.vring.num - 1));


Let's move this beyond the in_order check.


> +		if (!vq->split.is_skipped_buffer) {
> +			vq->split.last_desc_in_batch =
> +				virtio32_to_cpu(_vq->vdev,
> +						vq->split.vring.used->ring[last_used].id);
> +			vq->split.is_skipped_buffer = true;
> +		}
> +		/* For skipped buffers in batch, we can ignore the len info, simply set len as 0 */


This seems to break the caller that depends on a correct len.


> +		if (vq->split.next_desc_begin != vq->split.last_desc_in_batch) {
> +			*len = 0;
> +		} else {
> +			*len = virtio32_to_cpu(_vq->vdev,
> +					       vq->split.vring.used->ring[last_used].len);
> +			vq->split.is_skipped_buffer = false;
> +		}
> +		i = vq->split.next_desc_begin;
> +		j = i;
> +		/* Indirect only takes one descriptor in descriptor table */
> +		while (!vq->indirect && (vq->split.desc_extra[j].flags & VRING_DESC_F_NEXT))
> +			j = (j + 1) & (vq->split.vring.num - 1);


Any reason indirect descriptors can't be chained?


> +		/* move to next */
> +		j = (j + 1) % vq->split.vring.num;
> +		/* Next buffer will use this descriptor in order */
> +		vq->split.next_desc_begin = j;


Is it more efficient to poke the available ring?

Thanks


> +	} else {
> +		last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
> +		i = virtio32_to_cpu(_vq->vdev,
> +				    vq->split.vring.used->ring[last_used].id);
> +		*len = virtio32_to_cpu(_vq->vdev,
> +				       vq->split.vring.used->ring[last_used].len);
> +	}
>   
>   	if (unlikely(i >= vq->split.vring.num)) {
>   		BAD_RING(vq, "id %u out of range\n", i);
> @@ -2223,6 +2272,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   
>   	vq->indirect = virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC) &&
>   		!context;
> +	vq->in_order = virtio_has_feature(vdev, VIRTIO_F_IN_ORDER);
>   	vq->event = virtio_has_feature(vdev, VIRTIO_RING_F_EVENT_IDX);
>   
>   	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
> @@ -2235,6 +2285,10 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   	vq->split.avail_flags_shadow = 0;
>   	vq->split.avail_idx_shadow = 0;
>   
> +	vq->split.next_desc_begin = 0;
> +	vq->split.last_desc_in_batch = 0;
> +	vq->split.is_skipped_buffer = false;
> +
>   	/* No callback?  Tell other side not to bother us. */
>   	if (!callback) {
>   		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;

