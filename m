Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D254D5A49
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 06:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344410AbiCKFK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 00:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241284AbiCKFKy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 00:10:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 061FF1AC295
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 21:09:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646975390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9nBenv8s0AYm2+pJMUm/jGEPBjH6r3BWfbAB/qp2ZZE=;
        b=NWVQDmdOIHj3vLiw+Bp5Ehb5JIh06xg0j0yI7sVx0gU6MTKZ05CEj42gQgnv84aqLuiByn
        YoGrE76Ojge8fxc9L0V7heGAuy6RlE39h7OZ1WmWy9ob17who6TbE+e1DmmgW8ZRc11JyT
        avlFQpWlX+IFE8KhE9kVNtgcU8d/syM=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-tswQvjTzOViO724IYFshxA-1; Fri, 11 Mar 2022 00:09:48 -0500
X-MC-Unique: tswQvjTzOViO724IYFshxA-1
Received: by mail-pf1-f198.google.com with SMTP id a23-20020aa794b7000000b004f6a3ac7a87so4527955pfl.23
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 21:09:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9nBenv8s0AYm2+pJMUm/jGEPBjH6r3BWfbAB/qp2ZZE=;
        b=ssETj2i0UJFsZrze4bSp20H3mEAuGhDNO/09Zd7XkF3XdHBqhGyFZ9JpfB3p4BSYjz
         vzJpJnj6cm19wKVc53dgt5ZnXuF/SmCJnVZXj4n7cCcu7PMKyzSmSo3FMjvEuHIJfPGW
         lLfw4dnsBnQPrci1y/4Sm6E38nwSs0EUDXMQgApqZN0GnycqvTlSDcKl0/h69cKVKBJ/
         BadEHH3WvlJaUH0xfbHFYeWZw8CMW83zmO6lyyCQJu1aTnKbwn8iCKFLdVsVGhPoTFwh
         9cMd8773YeeNm+yXyaILzeOWuvwZUgL4UDUINml9o4tNBCaLim6Aft+h+LIx2RPgIy/R
         liRw==
X-Gm-Message-State: AOAM533Y1+pFlZStHw24aV3qoFeJkDzmoD1VA3YEXW+RtvDs/h0hIyx+
        aLz9BQVfMdOmbPsWgSBpce7PbOq+AmvDtDyoV2eVrvah4L6EC7I6Rf3ZzJ5l3CSA4hK6vRcFxYD
        gfk9D1mKZXWSQ
X-Received: by 2002:a17:90a:d3d0:b0:1bb:f5b3:2fbf with SMTP id d16-20020a17090ad3d000b001bbf5b32fbfmr8820741pjw.87.1646975387575;
        Thu, 10 Mar 2022 21:09:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx8JKZXffEodSfmEHpMRgYWBvpIlhcshqGZgVYLA+ugGNosDsbJfihtdbxn5vtUMGsfzlzXdw==
X-Received: by 2002:a17:90a:d3d0:b0:1bb:f5b3:2fbf with SMTP id d16-20020a17090ad3d000b001bbf5b32fbfmr8820693pjw.87.1646975387226;
        Thu, 10 Mar 2022 21:09:47 -0800 (PST)
Received: from [10.72.13.226] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z7-20020a056a00240700b004e1cde37bc1sm8792099pfh.84.2022.03.10.21.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 21:09:46 -0800 (PST)
Message-ID: <06b3adbb-6777-7022-00d2-beca2b166e10@redhat.com>
Date:   Fri, 11 Mar 2022 13:09:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v7 17/26] virtio_pci: queue_reset: support
 VIRTIO_F_RING_RESET
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
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
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
 <20220308123518.33800-18-xuanzhuo@linux.alibaba.com>
 <8b9d337d-71c2-07b4-8e65-6f83cf09bf7a@redhat.com>
 <1646900411.6481435-2-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <1646900411.6481435-2-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/3/10 下午4:20, Xuan Zhuo 写道:
> On Wed, 9 Mar 2022 16:54:10 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> 在 2022/3/8 下午8:35, Xuan Zhuo 写道:
>>> This patch implements virtio pci support for QUEUE RESET.
>>>
>>> Performing reset on a queue is divided into these steps:
>>>
>>>    1. virtio_reset_vq()              - notify the device to reset the queue
>>>    2. virtqueue_detach_unused_buf()  - recycle the buffer submitted
>>>    3. virtqueue_reset_vring()        - reset the vring (may re-alloc)
>>>    4. virtio_enable_resetq()         - mmap vring to device, and enable the queue
>>>
>>> This patch implements virtio_reset_vq(), virtio_enable_resetq() in the
>>> pci scenario.
>>>
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> ---
>>>    drivers/virtio/virtio_pci_common.c |  8 +--
>>>    drivers/virtio/virtio_pci_modern.c | 83 ++++++++++++++++++++++++++++++
>>>    2 files changed, 88 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
>>> index fdbde1db5ec5..863d3a8a0956 100644
>>> --- a/drivers/virtio/virtio_pci_common.c
>>> +++ b/drivers/virtio/virtio_pci_common.c
>>> @@ -248,9 +248,11 @@ static void vp_del_vq(struct virtqueue *vq)
>>>    	struct virtio_pci_vq_info *info = vp_dev->vqs[vq->index];
>>>    	unsigned long flags;
>>>
>>> -	spin_lock_irqsave(&vp_dev->lock, flags);
>>> -	list_del(&info->node);
>>> -	spin_unlock_irqrestore(&vp_dev->lock, flags);
>>> +	if (!vq->reset) {
>>> +		spin_lock_irqsave(&vp_dev->lock, flags);
>>> +		list_del(&info->node);
>>> +		spin_unlock_irqrestore(&vp_dev->lock, flags);
>>> +	}
>>>
>>>    	vp_dev->del_vq(info);
>>>    	kfree(info);
>>> diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
>>> index 49a4493732cf..3c67d3607802 100644
>>> --- a/drivers/virtio/virtio_pci_modern.c
>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>> @@ -34,6 +34,9 @@ static void vp_transport_features(struct virtio_device *vdev, u64 features)
>>>    	if ((features & BIT_ULL(VIRTIO_F_SR_IOV)) &&
>>>    			pci_find_ext_capability(pci_dev, PCI_EXT_CAP_ID_SRIOV))
>>>    		__virtio_set_bit(vdev, VIRTIO_F_SR_IOV);
>>> +
>>> +	if (features & BIT_ULL(VIRTIO_F_RING_RESET))
>>> +		__virtio_set_bit(vdev, VIRTIO_F_RING_RESET);
>>>    }
>>>
>>>    /* virtio config->finalize_features() implementation */
>>> @@ -199,6 +202,82 @@ static int vp_active_vq(struct virtqueue *vq, u16 msix_vec)
>>>    	return 0;
>>>    }
>>>
>>> +static int vp_modern_reset_vq(struct virtqueue *vq)
>>> +{
>>> +	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
>>> +	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
>>> +	struct virtio_pci_vq_info *info;
>>> +	unsigned long flags;
>>> +	unsigned int irq;
>>> +
>>> +	if (!virtio_has_feature(vq->vdev, VIRTIO_F_RING_RESET))
>>> +		return -ENOENT;
>>> +
>>> +	vp_modern_set_queue_reset(mdev, vq->index);
>>> +
>>> +	info = vp_dev->vqs[vq->index];
>>> +
>>> +	/* delete vq from irq handler */
>>> +	spin_lock_irqsave(&vp_dev->lock, flags);
>>> +	list_del(&info->node);
>>> +	spin_unlock_irqrestore(&vp_dev->lock, flags);
>>> +
>>> +	INIT_LIST_HEAD(&info->node);
>>> +
>>> +	vq->reset = VIRTIO_VQ_RESET_STEP_DEVICE;
>>> +
>>> +	/* sync irq callback. */
>>> +	if (vp_dev->intx_enabled) {
>>> +		irq = vp_dev->pci_dev->irq;
>>> +
>>> +	} else {
>>> +		if (info->msix_vector == VIRTIO_MSI_NO_VECTOR)
>>> +			return 0;
>>> +
>>> +		irq = pci_irq_vector(vp_dev->pci_dev, info->msix_vector);
>>> +	}
>>> +
>>> +	synchronize_irq(irq);
>>
>> Synchronize_irq() is not sufficient here since it breaks the effort of
>> the interrupt hardening which is done by commits:
>>
>> 080cd7c3ac87 virtio-pci: harden INTX interrupts
>> 9e35276a5344 virtio_pci: harden MSI-X interrupts
>>
>> Unfortunately  080cd7c3ac87 introduces an issue that disable_irq() were
>> used for the affinity managed irq but we're discussing a fix.
>>
>
> ok, I think disable_irq() is still used here.
>
> I want to determine the solution for this detail first. So I posted the code, I
> hope Jason can help confirm this point first.
>
> There are three situations in which vq corresponds to an interrupt
>
> 1. intx
> 2. msix: per vq vectors
> 2. msix: share irq
>
> Essentially can be divided into two categories: per vq vectors and share irq.
>
> For share irq is based on virtqueues to find vq, so I think it is safe as long
> as list_del() is executed under the protection of the lock.
>
> In the case of per vq vectors, disable_irq() is used.


See the discussion here[1], disable_irq() could be problematic for the 
block and scsi device that using affinity managed irq. We're waiting for 
the IRQ maintainer to comment on a solution. Other looks sane.

Thanks

[1] https://lkml.org/lkml/2022/3/8/743


>
> Thanks.
>
> +static int vp_modern_reset_vq(struct virtqueue *vq)
> +{
> +       struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
> +       struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> +       struct virtio_pci_vq_info *info;
> +       unsigned long flags;
> +       unsigned int irq;
> +
> +       if (!virtio_has_feature(vq->vdev, VIRTIO_F_RING_RESET))
> +               return -ENOENT;
> +
> +       vp_modern_set_queue_reset(mdev, vq->index);
> +
> +       info = vp_dev->vqs[vq->index];
> +
> +       /* delete vq from irq handler */
> +       spin_lock_irqsave(&vp_dev->lock, flags);
> +       list_del(&info->node);
> +       vp_modern_set_queue_reset(mdev, vq->index);
> +
> +       info = vp_dev->vqs[vq->index];
> +
> +       /* delete vq from irq handler */
> +       spin_lock_irqsave(&vp_dev->lock, flags);
> +       list_del(&info->node);
> +       spin_unlock_irqrestore(&vp_dev->lock, flags);
> +
> +       INIT_LIST_HEAD(&info->node);
> +
> +       /* For the case where vq has an exclusive irq, to prevent the irq from
> +        * being received again and the pending irq, call disable_irq().
> +        *
> +        * In the scenario based on shared interrupts, vq will be searched from
> +        * the queue virtqueues. Since the previous list_del() has been deleted
> +        * from the queue, it is impossible for vq to be called in this case.
> +        * There is no need to close the corresponding interrupt.
> +        */
> +       if (vp_dev->per_vq_vectors && msix_vec != VIRTIO_MSI_NO_VECTOR)
> +               disable_irq(pci_irq_vector(vp_dev->pci_dev, info->msix_vector));
> +
> +       vq->reset = true;
> +
> +       return 0;
> +}
> +
> +static int vp_modern_enable_reset_vq(struct virtqueue *vq)
> +{
> +       struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
> +       struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
> +       struct virtio_pci_vq_info *info;
> +       unsigned long flags, index;
> +       int err;
> +
> +       if (!vq->reset)
> +               return -EBUSY;
> +
> +       index = vq->index;
> +       info = vp_dev->vqs[index];
> +
> +       /* check queue reset status */
> +       if (vp_modern_get_queue_reset(mdev, index) != 1)
> +               return -EBUSY;
> +
> +       err = vp_active_vq(vq, info->msix_vector);
> +       if (err)
> +               return err;
> +
> +       if (vq->callback) {
> +               spin_lock_irqsave(&vp_dev->lock, flags);
> +               list_add(&info->node, &vp_dev->virtqueues);
> +               spin_unlock_irqrestore(&vp_dev->lock, flags);
> +       } else {
> +               INIT_LIST_HEAD(&info->node);
> +       }
> +
> +       vp_modern_set_queue_enable(&vp_dev->mdev, index, true);
> +       vq->reset = false;
> +
> +       if (vp_dev->per_vq_vectors && msix_vec != VIRTIO_MSI_NO_VECTOR)
> +               enable_irq(pci_irq_vector(vp_dev->pci_dev, info->msix_vector));
> +
> +       return 0;
> +}
>
>

