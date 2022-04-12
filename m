Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83CD4FD45B
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 12:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbiDLJ4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 05:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357155AbiDLHjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 03:39:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4550512AA1
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 00:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649747580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mRq1WN/7xC1cXSlUswWcAEZrziB8GVLK8yncCszg3n4=;
        b=JD484GVTbyTaBWXBS9fNj9OjsXL5AaiYTZMXh+RHGyOOlYkNMD3OsQBsl4+wXGCnIoKnkN
        xbRFhvbqZSJhVzuooRRFzRllYeQyBqjdhHDBjTChxCdQi/ZYi7KcztaZqi6+mJBI9d1OM9
        wyNHhninuala02K/90GR8no0pUStxMA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-Ah5nHP9gNIOk9J_Rcg60Ag-1; Tue, 12 Apr 2022 03:12:58 -0400
X-MC-Unique: Ah5nHP9gNIOk9J_Rcg60Ag-1
Received: by mail-pj1-f71.google.com with SMTP id p14-20020a17090a348e00b001cbc57fedc1so791575pjb.3
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 00:12:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mRq1WN/7xC1cXSlUswWcAEZrziB8GVLK8yncCszg3n4=;
        b=PBBeXo69PPeYGnp3agBwF1Wym0M+zlSBRz3aPU83mldgGJtk1lmSY3MwBMHmQpf2bE
         JO1U4Jp2l3A6wwDVsVSMY5pb5SnGkYR92TOfLCWQq08jTlSEFoceD6+C1ssZh+dtc1xR
         66R1Ap729OBj0W7c6+2UIlMoMoZhOvh34E7mhFbaPTB5Mz9vVcHiWiV5iHXjWK9LhuEL
         O7i4WMDXgJfXVnn4rogoZdDytfsdjFL/YWD3M1RCPXjzogCUu0b71WudSgKjpy3Dj/PL
         HBe8EhMavFo8On1xjNATEAK+Yp0svjFWQtjdPjTtxWEXgtMyr9H8Pq7yunuT6cegODDe
         LpUg==
X-Gm-Message-State: AOAM531hP2GidihbxcG6CpWv06jZKNs8x+ZBArAna8eQ0jtwUx/PH8Nw
        g4pY2isJDeadXHYY2kZP7KNthqgWivJP5t1PpnXxNi/yXEVZO/MPtFTD+jkbmfuQx/vU4K8OBJ3
        pRx3zlxDGoKqQ
X-Received: by 2002:a63:b55d:0:b0:398:5eeb:e637 with SMTP id u29-20020a63b55d000000b003985eebe637mr28844764pgo.314.1649747577724;
        Tue, 12 Apr 2022 00:12:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzcjF+z5aN8qIIJojhgLD6Ajm0j4nHXpFBPakfSKEyLfv8FWNaht+5QkKkqPRUpFlILOqb8Q==
X-Received: by 2002:a63:b55d:0:b0:398:5eeb:e637 with SMTP id u29-20020a63b55d000000b003985eebe637mr28844743pgo.314.1649747577325;
        Tue, 12 Apr 2022 00:12:57 -0700 (PDT)
Received: from [10.72.14.5] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f70d5e92basm37773293pfx.34.2022.04.12.00.12.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 00:12:56 -0700 (PDT)
Message-ID: <b1f14156-a0b0-4933-072e-1ca33921fc8b@redhat.com>
Date:   Tue, 12 Apr 2022 15:12:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v9 25/32] virtio_pci: support the arg sizes of find_vqs()
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
 <20220406034346.74409-26-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220406034346.74409-26-xuanzhuo@linux.alibaba.com>
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
> Virtio PCI supports new parameter sizes of find_vqs().
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/virtio/virtio_pci_common.c | 18 ++++++++++--------
>   drivers/virtio/virtio_pci_common.h |  1 +
>   drivers/virtio/virtio_pci_legacy.c |  6 +++++-
>   drivers/virtio/virtio_pci_modern.c | 10 +++++++---
>   4 files changed, 23 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index 826ea2e35d54..23976c61583f 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -208,6 +208,7 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
>   static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
>   				     void (*callback)(struct virtqueue *vq),
>   				     const char *name,
> +				     u32 size,
>   				     bool ctx,
>   				     u16 msix_vec)
>   {
> @@ -220,7 +221,7 @@ static struct virtqueue *vp_setup_vq(struct virtio_device *vdev, unsigned index,
>   	if (!info)
>   		return ERR_PTR(-ENOMEM);
>   
> -	vq = vp_dev->setup_vq(vp_dev, info, index, callback, name, ctx,
> +	vq = vp_dev->setup_vq(vp_dev, info, index, callback, name, size, ctx,
>   			      msix_vec);
>   	if (IS_ERR(vq))
>   		goto out_info;
> @@ -314,7 +315,7 @@ void vp_del_vqs(struct virtio_device *vdev)
>   
>   static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned nvqs,
>   		struct virtqueue *vqs[], vq_callback_t *callbacks[],
> -		const char * const names[], bool per_vq_vectors,
> +		const char * const names[], u32 sizes[], bool per_vq_vectors,
>   		const bool *ctx,
>   		struct irq_affinity *desc)
>   {
> @@ -357,8 +358,8 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned nvqs,
>   		else
>   			msix_vec = VP_MSIX_VQ_VECTOR;
>   		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
> -				     ctx ? ctx[i] : false,
> -				     msix_vec);
> +				     sizes ? sizes[i] : 0,
> +				     ctx ? ctx[i] : false, msix_vec);
>   		if (IS_ERR(vqs[i])) {
>   			err = PTR_ERR(vqs[i]);
>   			goto error_find;
> @@ -388,7 +389,7 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned nvqs,
>   
>   static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned nvqs,
>   		struct virtqueue *vqs[], vq_callback_t *callbacks[],
> -		const char * const names[], const bool *ctx)
> +		const char * const names[], u32 sizes[], const bool *ctx)
>   {
>   	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
>   	int i, err, queue_idx = 0;
> @@ -410,6 +411,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned nvqs,
>   			continue;
>   		}
>   		vqs[i] = vp_setup_vq(vdev, queue_idx++, callbacks[i], names[i],
> +				     sizes ? sizes[i] : 0,
>   				     ctx ? ctx[i] : false,
>   				     VIRTIO_MSI_NO_VECTOR);
>   		if (IS_ERR(vqs[i])) {
> @@ -433,15 +435,15 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>   	int err;
>   
>   	/* Try MSI-X with one vector per queue. */
> -	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, true, ctx, desc);
> +	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, sizes, true, ctx, desc);
>   	if (!err)
>   		return 0;
>   	/* Fallback: MSI-X with one vector for config, one shared for queues. */
> -	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, false, ctx, desc);
> +	err = vp_find_vqs_msix(vdev, nvqs, vqs, callbacks, names, sizes, false, ctx, desc);
>   	if (!err)
>   		return 0;
>   	/* Finally fall back to regular interrupts. */
> -	return vp_find_vqs_intx(vdev, nvqs, vqs, callbacks, names, ctx);
> +	return vp_find_vqs_intx(vdev, nvqs, vqs, callbacks, names, sizes, ctx);
>   }
>   
>   const char *vp_bus_name(struct virtio_device *vdev)
> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
> index 859eed559e10..fbf5a6d4b164 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -81,6 +81,7 @@ struct virtio_pci_device {
>   				      unsigned idx,
>   				      void (*callback)(struct virtqueue *vq),
>   				      const char *name,
> +				      u32 size,
>   				      bool ctx,
>   				      u16 msix_vec);
>   	void (*del_vq)(struct virtio_pci_vq_info *info);
> diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
> index b68934fe6b5d..2c4ade5fb420 100644
> --- a/drivers/virtio/virtio_pci_legacy.c
> +++ b/drivers/virtio/virtio_pci_legacy.c
> @@ -112,6 +112,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>   				  unsigned index,
>   				  void (*callback)(struct virtqueue *vq),
>   				  const char *name,
> +				  u32 size,
>   				  bool ctx,
>   				  u16 msix_vec)
>   {
> @@ -125,10 +126,13 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>   	if (!num || vp_legacy_get_queue_enable(&vp_dev->ldev, index))
>   		return ERR_PTR(-ENOENT);
>   
> +	if (!size || size > num)
> +		size = num;
> +
>   	info->msix_vector = msix_vec;
>   
>   	/* create the vring */
> -	vq = vring_create_virtqueue(index, num,
> +	vq = vring_create_virtqueue(index, size,
>   				    VIRTIO_PCI_VRING_ALIGN, &vp_dev->vdev,
>   				    true, false, ctx,
>   				    vp_notify, callback, name);
> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
> index 3b35e5056165..a17c47d4435a 100644
> --- a/drivers/virtio/virtio_pci_modern.c
> +++ b/drivers/virtio/virtio_pci_modern.c
> @@ -289,6 +289,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>   				  unsigned index,
>   				  void (*callback)(struct virtqueue *vq),
>   				  const char *name,
> +				  u32 size,
>   				  bool ctx,
>   				  u16 msix_vec)
>   {
> @@ -306,15 +307,18 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
>   	if (!num || vp_modern_get_queue_enable(mdev, index))
>   		return ERR_PTR(-ENOENT);
>   
> -	if (num & (num - 1)) {
> -		dev_warn(&vp_dev->pci_dev->dev, "bad queue size %u", num);
> +	if (!size || size > num)
> +		size = num;
> +
> +	if (size & (size - 1)) {
> +		dev_warn(&vp_dev->pci_dev->dev, "bad queue size %u", size);
>   		return ERR_PTR(-EINVAL);
>   	}
>   
>   	info->msix_vector = msix_vec;
>   
>   	/* create the vring */
> -	vq = vring_create_virtqueue(index, num,
> +	vq = vring_create_virtqueue(index, size,
>   				    SMP_CACHE_BYTES, &vp_dev->vdev,
>   				    true, true, ctx,
>   				    vp_notify, callback, name);

