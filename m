Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5806C580E8F
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 10:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiGZIH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 04:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbiGZIH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 04:07:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53FA22ED78
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 01:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658822875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v2FS+wcLS276CjyoJxXnom+ZC/VQJoGiBzM4C9YEjwQ=;
        b=SSp+QyiqkSttUts/HwOElJtUn3VlpPbcdZMOVYuozx4MA/hHsvYlj3iui3rzxv721tWin6
        fpa8j/QZ6zzdOB8xLuUXrlD2he8hYx9d8td1rBKThwv1bOIrX6njzrI4Bt2W3trUXsVqYw
        /q+1ASVvo0SMnSPPgYmrohSNYXGQ3vk=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-uihfvlgWPryCf99c_31DZQ-1; Tue, 26 Jul 2022 04:07:53 -0400
X-MC-Unique: uihfvlgWPryCf99c_31DZQ-1
Received: by mail-pf1-f197.google.com with SMTP id x34-20020a056a000be200b0052b7f102681so4516088pfu.5
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 01:07:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v2FS+wcLS276CjyoJxXnom+ZC/VQJoGiBzM4C9YEjwQ=;
        b=z90z1Lpa33UV7eSVt5G0raKINJRZI1SgmemqpQPVtjDEzDWKUET4ZSG+nTJo5ZNxYr
         fuDpoyYlyYF9XcinKABczI5kAXBA8d4bEAd4FEjwqrmpvtQoWEixdVwk5G6QWjUUU1gt
         54dj8oiN/kkqJ9Hi9WzW+9D5enQzg2igfOJepsJ9g9CIzBMVwSD3rWVZfC4kb6q1/+/i
         CH7ukhZTTsuieTNShqPdHIGWwu4NwUiolneLQA18QRWanQNztW0nkJlD/fheogMwdMCx
         DowpSES+lnPi+3H+bweyooCI4AhL6yBh3MiZ7zOynABBSIsBGLP2b8NFmHHE6CaOCTZs
         KkKA==
X-Gm-Message-State: AJIora/aBLVPRHQg2/LYNFYPL4t3fxmRbkt34l9tUqpjiAad+HjeJ1sk
        IL0xfIl79Q615Ucv4I6JucR1ixzNoJsIy2C8VYfeEvbnFA43unbJQYpw+DKbv8FSfQiryi/gbPL
        RxZ+GDW1oN/aw
X-Received: by 2002:a17:90b:3ece:b0:1f0:6b2e:6fbf with SMTP id rm14-20020a17090b3ece00b001f06b2e6fbfmr35013943pjb.203.1658822872181;
        Tue, 26 Jul 2022 01:07:52 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t6pDFB5xcS97km93rf91OBUoaDmySnwXucaOEG95lnhcHdHOmDqsphKxM28DLJ13n4R8FnIg==
X-Received: by 2002:a17:90b:3ece:b0:1f0:6b2e:6fbf with SMTP id rm14-20020a17090b3ece00b001f06b2e6fbfmr35013922pjb.203.1658822871777;
        Tue, 26 Jul 2022 01:07:51 -0700 (PDT)
Received: from [10.72.12.201] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o9-20020a62cd09000000b0052abfc4b4a4sm11290893pfg.12.2022.07.26.01.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 01:07:51 -0700 (PDT)
Message-ID: <9d4c24de-f2cc-16a0-818a-16695946f3a3@redhat.com>
Date:   Tue, 26 Jul 2022 16:07:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [RFC 4/5] virtio: get desc id in order
Content-Language: en-US
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>, eperezma@redhat.com,
        sgarzare@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
 <20220721084341.24183-5-qtxuning1999@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220721084341.24183-5-qtxuning1999@sjtu.edu.cn>
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


在 2022/7/21 16:43, Guo Zhi 写道:
> If in order feature negotiated, we can skip the used ring to get
> buffer's desc id sequentially.


Let's rename the patch to something like "in order support for virtio_ring"


>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>   drivers/virtio/virtio_ring.c | 37 ++++++++++++++++++++++++++++--------
>   1 file changed, 29 insertions(+), 8 deletions(-)


I don't see packed support in this patch, we need to implement that.


>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index a5ec724c0..4d57a4edc 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -144,6 +144,9 @@ struct vring_virtqueue {
>   			/* DMA address and size information */
>   			dma_addr_t queue_dma_addr;
>   			size_t queue_size_in_bytes;
> +
> +			/* In order feature batch begin here */
> +			u16 next_batch_desc_begin;
>   		} split;
>   
>   		/* Available for packed ring */
> @@ -700,8 +703,10 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
>   	}
>   
>   	vring_unmap_one_split(vq, i);
> -	vq->split.desc_extra[i].next = vq->free_head;
> -	vq->free_head = head;
> +	if (!virtio_has_feature(vq->vq.vdev, VIRTIO_F_IN_ORDER)) {
> +		vq->split.desc_extra[i].next = vq->free_head;
> +		vq->free_head = head;
> +	}


Let's add a comment to explain why we don't need anything if in order is 
neogitated.


>   
>   	/* Plus final descriptor */
>   	vq->vq.num_free++;
> @@ -743,7 +748,8 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue *_vq,
>   {
>   	struct vring_virtqueue *vq = to_vvq(_vq);
>   	void *ret;
> -	unsigned int i;
> +	__virtio16 nextflag = cpu_to_virtio16(vq->vq.vdev, VRING_DESC_F_NEXT);
> +	unsigned int i, j;
>   	u16 last_used;
>   
>   	START_USE(vq);
> @@ -762,11 +768,24 @@ static void *virtqueue_get_buf_ctx_split(struct virtqueue *_vq,
>   	/* Only get used array entries after they have been exposed by host. */
>   	virtio_rmb(vq->weak_barriers);
>   
> -	last_used = (vq->last_used_idx & (vq->split.vring.num - 1));
> -	i = virtio32_to_cpu(_vq->vdev,
> -			vq->split.vring.used->ring[last_used].id);
> -	*len = virtio32_to_cpu(_vq->vdev,
> -			vq->split.vring.used->ring[last_used].len);
> +	if (virtio_has_feature(_vq->vdev, VIRTIO_F_IN_ORDER)) {
> +		/* Skip used ring and get used desc in order*/
> +		i = vq->split.next_batch_desc_begin;
> +		j = i;
> +		while (vq->split.vring.desc[j].flags & nextflag)


Let's don't depend on the descriptor ring which is under the control of 
the malicious hypervisor.

Let's use desc_extra that is not visible by the hypervisor. More can be 
seen in this commit:

72b5e8958738 ("virtio-ring: store DMA metadata in desc_extra for split 
virtqueue")


> +			j = (j + 1) % vq->split.vring.num;
> +		/* move to next */
> +		j = (j + 1) % vq->split.vring.num;
> +		vq->split.next_batch_desc_begin = j;


I'm not sure I get the logic here, basically I think we should check 
buffer instead of descriptor here.

So if vring.used->ring[last_used].id != last_used, we know all 
[last_used, vring.used->ring[last_used].id] have been used in a batch?


> +
> +		/* TODO: len of buffer */


So spec said:

"

The skipped buffers (for which no used ring entry was written) are 
assumed to have been used (read or written) by the device completely.


"

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
> @@ -2234,6 +2253,8 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
>   	vq->split.avail_flags_shadow = 0;
>   	vq->split.avail_idx_shadow = 0;
>   
> +	vq->split.next_batch_desc_begin = 0;
> +
>   	/* No callback?  Tell other side not to bother us. */
>   	if (!callback) {
>   		vq->split.avail_flags_shadow |= VRING_AVAIL_F_NO_INTERRUPT;

