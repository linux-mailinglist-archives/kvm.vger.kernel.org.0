Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1576581EE9
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 06:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240357AbiG0Ed2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 00:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiG0Ed0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 00:33:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D7DF3B960
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 21:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658896404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ODRM0zSUIZaPgOR8/bpOMiGz6jK2MmkN3FU9v6SxAsc=;
        b=FGige+LVOZIkTHanCRIho/4zTu1A/evbgvSke0NIVoFPLu2hwkBoh9K++RuPJQF9FBy6QV
        lUBSTWLTP+TubZ55m12zkweaKzQHoDcI5x0KplTXt5ZsxfXSvz1xNIJ7VUJr4MCHZvDfm9
        P2xROKOd7r0KFdCF9GpZoK9CwUy66r8=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-j41FTJHaO1imzgeDOS2PzQ-1; Wed, 27 Jul 2022 00:33:19 -0400
X-MC-Unique: j41FTJHaO1imzgeDOS2PzQ-1
Received: by mail-pf1-f200.google.com with SMTP id a16-20020a056a001d1000b0052b39ee38c4so5511665pfx.15
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 21:33:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ODRM0zSUIZaPgOR8/bpOMiGz6jK2MmkN3FU9v6SxAsc=;
        b=tHyo1aqLszFJZ4k2jOm8hogU3bRs/Ft0Uyj3s6MaFmghk+sHVhFltml3UtfNft6/zW
         5yMj34Dm0QgT2TZS7HlPdn8TX2xgWItE+2eByanF1z6cL/KISkqTUwl78cznL/mSV3sK
         xKrZ3wWMCvLmpFCniH2LjWyUnw4vvdbNkWzKv3sDlcgeat7eklk/bjP4680wA2DQ/Tl+
         25nvVPUXS07utvwItpHVahxxD8AmzwVHfzYMYEPLczsHquLYqcnlaYu0sZ5OzRU0EtTI
         BNimzWYSmWa0R1y8IqsHsRoQAdiPtb7YtLDQtx3imUmEIPdWGaOWgCBDR6GBnW5Oj5rT
         +RXw==
X-Gm-Message-State: AJIora87UuwX0/qdmmbjL3Nkit4fYbi0MsEw54WQCEAsSqWDAu3kCxl8
        p1+1OWqBdN6hR43LcTNLUrA20eia3Vp49kal6cWpNydsiI9Vq1YopmOKuIpfmnFvjAybr1miF5v
        8iFpb4mJv/+wo
X-Received: by 2002:a63:20e:0:b0:41a:f82c:daef with SMTP id 14-20020a63020e000000b0041af82cdaefmr10287828pgc.165.1658896397835;
        Tue, 26 Jul 2022 21:33:17 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tIGltlGmjqdvnQ8FUe2CBzMPphXcR7MEQHTWNTxKvA35C4DAmnE0tnwBMKdB4Yu1yuPE5jjw==
X-Received: by 2002:a63:20e:0:b0:41a:f82c:daef with SMTP id 14-20020a63020e000000b0041af82cdaefmr10287789pgc.165.1658896397576;
        Tue, 26 Jul 2022 21:33:17 -0700 (PDT)
Received: from [10.72.12.96] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w184-20020a6230c1000000b0052b84ca900csm12590905pfw.62.2022.07.26.21.33.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 21:33:16 -0700 (PDT)
Message-ID: <d290e282-1a9d-b339-73e6-c66740f00b89@redhat.com>
Date:   Wed, 27 Jul 2022 12:33:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v13 19/42] virtio_ring: packed: extract the logic of alloc
 state and extra
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
 <20220726072225.19884-20-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220726072225.19884-20-xuanzhuo@linux.alibaba.com>
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


在 2022/7/26 15:22, Xuan Zhuo 写道:
> Separate the logic for alloc desc_state and desc_extra, which will
> be called separately by subsequent patches.
>
> Use struct vring_packed to pass desc_state, desc_extra.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/virtio/virtio_ring.c | 48 +++++++++++++++++++++++++-----------
>   1 file changed, 34 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 10cc2b7e3588..32590d763c3b 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -1908,6 +1908,33 @@ static int vring_alloc_queue_packed(struct vring_virtqueue_packed *vring_packed,
>   	return -ENOMEM;
>   }
>   
> +static int vring_alloc_state_extra_packed(struct vring_virtqueue_packed *vring_packed)
> +{
> +	struct vring_desc_state_packed *state;
> +	struct vring_desc_extra *extra;
> +	u32 num = vring_packed->vring.num;
> +
> +	state = kmalloc_array(num, sizeof(struct vring_desc_state_packed), GFP_KERNEL);
> +	if (!state)
> +		goto err_desc_state;
> +
> +	memset(state, 0, num * sizeof(struct vring_desc_state_packed));
> +
> +	extra = vring_alloc_desc_extra(num);
> +	if (!extra)
> +		goto err_desc_extra;
> +
> +	vring_packed->desc_state = state;
> +	vring_packed->desc_extra = extra;
> +
> +	return 0;
> +
> +err_desc_extra:
> +	kfree(state);
> +err_desc_state:
> +	return -ENOMEM;
> +}
> +
>   static struct virtqueue *vring_create_virtqueue_packed(
>   	unsigned int index,
>   	unsigned int num,
> @@ -1922,6 +1949,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   {
>   	struct vring_virtqueue_packed vring_packed = {};
>   	struct vring_virtqueue *vq;
> +	int err;
>   
>   	if (vring_alloc_queue_packed(&vring_packed, vdev, num))
>   		goto err_ring;
> @@ -1961,18 +1989,12 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   	vq->packed.event_flags_shadow = 0;
>   	vq->packed.avail_used_flags = 1 << VRING_PACKED_DESC_F_AVAIL;
>   
> -	vq->packed.desc_state = kmalloc_array(num,
> -			sizeof(struct vring_desc_state_packed),
> -			GFP_KERNEL);
> -	if (!vq->packed.desc_state)
> -		goto err_desc_state;
> -
> -	memset(vq->packed.desc_state, 0,
> -		num * sizeof(struct vring_desc_state_packed));
> +	err = vring_alloc_state_extra_packed(&vring_packed);
> +	if (err)
> +		goto err_state_extra;
>   
> -	vq->packed.desc_extra = vring_alloc_desc_extra(num);
> -	if (!vq->packed.desc_extra)
> -		goto err_desc_extra;
> +	vq->packed.desc_state = vring_packed.desc_state;
> +	vq->packed.desc_extra = vring_packed.desc_extra;
>   
>   	/* No callback?  Tell other side not to bother us. */
>   	if (!callback) {
> @@ -1988,9 +2010,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
>   	spin_unlock(&vdev->vqs_list_lock);
>   	return &vq->vq;
>   
> -err_desc_extra:
> -	kfree(vq->packed.desc_state);
> -err_desc_state:
> +err_state_extra:
>   	kfree(vq);
>   err_vq:
>   	vring_free_packed(&vring_packed, vdev);

