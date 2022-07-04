Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C2C564C30
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 05:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbiGDDr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Jul 2022 23:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiGDDrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Jul 2022 23:47:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18E0F6333
        for <kvm@vger.kernel.org>; Sun,  3 Jul 2022 20:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656906466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L2gDTuBKuZK9BdBvTV1z4CFK8vS6yKvfUsO3/KE/ibo=;
        b=GRYG2qoHVXZ5x2jOtcR8QmagI0fSwyymmlrBaiXIc37qpSJ+hFFAl9VfpYRMJGDjXssq8M
        GPXE8hXIwXjcTJqnqDKHqmvTuyKczjwCNnY1ZLzQzUNWblV9uwNZDRgjV8e/pbc/OMGbTL
        Z6bbpNDe+Ji1P1QTgg3uNT8uPh/oR4s=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-9j3irDP8Pymc3FSafoiS1w-1; Sun, 03 Jul 2022 23:47:45 -0400
X-MC-Unique: 9j3irDP8Pymc3FSafoiS1w-1
Received: by mail-pf1-f197.google.com with SMTP id by4-20020a056a00400400b005251029fd97so225769pfb.9
        for <kvm@vger.kernel.org>; Sun, 03 Jul 2022 20:47:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=L2gDTuBKuZK9BdBvTV1z4CFK8vS6yKvfUsO3/KE/ibo=;
        b=zm9QUoBHRADdo1jCclnvTEylvXIyD8beSqfhdlKK1VYdzDafXm2jbvdEf3k2e2T5gO
         KBugZ9xFRxGqdM7NiSzW/aENkDyTCcMTFcj5gwfsBd81/wMsSCnJwLyiPQ9ZeH5+AWn9
         vTbG+3kG7f4cvxHah5fQbRudE3p30ZDptw7uQtpbsH1OufCIGnKBBJ+MUnkhN9xkuAHE
         Yc2rD5b0eEfR1gId2Z4IdNJbD5Bl7t7lkIa0+lb6BntqNVR6cQpxeajftvUX9RBr5AZO
         b3WSZbqYzD6S/4X0VKGOoF5yzG1/uPZ+7phfE1L0VNkhZlUJU9cbygN6kAKesoDmflmk
         SavQ==
X-Gm-Message-State: AJIora+uesKVOg+h2Qnl3KAGt65t8qTSlzDZOj3H377MPzciDkch5PxR
        RriHsezdHiii7WlJ8sVvbjhn5eAzK48tVuw2gYNEXPFoPakxXOdvZgOvXO+5ICJ6NlmwCWiSeOi
        QWA80l+sfFPE/
X-Received: by 2002:a17:902:8b87:b0:169:5e5:43de with SMTP id ay7-20020a1709028b8700b0016905e543demr33751336plb.8.1656906461955;
        Sun, 03 Jul 2022 20:47:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1urar+tEFxn2OYR0nSzN1qR/6pFNL30ksJWbHZrPH1ZYknebpnFXj10hmhcTKfVqx002oRx8A==
X-Received: by 2002:a17:902:8b87:b0:169:5e5:43de with SMTP id ay7-20020a1709028b8700b0016905e543demr33751314plb.8.1656906461703;
        Sun, 03 Jul 2022 20:47:41 -0700 (PDT)
Received: from [10.72.13.251] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e11-20020a17090a7c4b00b001eee8998f2esm8701227pjl.17.2022.07.03.20.47.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jul 2022 20:47:41 -0700 (PDT)
Message-ID: <2fdff856-cddf-1235-8078-312de94600c7@redhat.com>
Date:   Mon, 4 Jul 2022 11:47:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v11 25/40] virtio: allow to unbreak/break virtqueue
 individually
Content-Language: en-US
From:   Jason Wang <jasowang@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
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
 <20220629065656.54420-26-xuanzhuo@linux.alibaba.com>
 <20220701022950-mutt-send-email-mst@kernel.org>
 <79e519ec-0129-6a21-11da-44eaff1429fa@redhat.com>
In-Reply-To: <79e519ec-0129-6a21-11da-44eaff1429fa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/7/1 17:36, Jason Wang 写道:
>
> 在 2022/7/1 14:31, Michael S. Tsirkin 写道:
>> On Wed, Jun 29, 2022 at 02:56:41PM +0800, Xuan Zhuo wrote:
>>> This patch allows the new introduced
>>> __virtqueue_break()/__virtqueue_unbreak() to break/unbreak the
>>> virtqueue.
>>>
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> I wonder how this interacts with the hardening patches.
>> Jason?
>
>
> Consider we've marked it as broken, I think we don't need to care 
> about the hardening in this series. Just make it work without hardening.
>
> And I will handle vq reset when rework the IRQ hardening.
>
> Thanks


Rethink of this, I think Xuan's code should be fine. We know we will 
have another rework.

Thanks


>
>
>>
>>> ---
>>>   drivers/virtio/virtio_ring.c | 24 ++++++++++++++++++++++++
>>>   include/linux/virtio.h       |  3 +++
>>>   2 files changed, 27 insertions(+)
>>>
>>> diff --git a/drivers/virtio/virtio_ring.c 
>>> b/drivers/virtio/virtio_ring.c
>>> index 5ec43607cc15..7b02be7fce67 100644
>>> --- a/drivers/virtio/virtio_ring.c
>>> +++ b/drivers/virtio/virtio_ring.c
>>> @@ -2744,6 +2744,30 @@ unsigned int virtqueue_get_vring_size(struct 
>>> virtqueue *_vq)
>>>   }
>>>   EXPORT_SYMBOL_GPL(virtqueue_get_vring_size);
>>>   +/*
>>> + * This function should only be called by the core, not directly by 
>>> the driver.
>>> + */
>>> +void __virtqueue_break(struct virtqueue *_vq)
>>> +{
>>> +    struct vring_virtqueue *vq = to_vvq(_vq);
>>> +
>>> +    /* Pairs with READ_ONCE() in virtqueue_is_broken(). */
>>> +    WRITE_ONCE(vq->broken, true);
>>> +}
>>> +EXPORT_SYMBOL_GPL(__virtqueue_break);
>>> +
>>> +/*
>>> + * This function should only be called by the core, not directly by 
>>> the driver.
>>> + */
>>> +void __virtqueue_unbreak(struct virtqueue *_vq)
>>> +{
>>> +    struct vring_virtqueue *vq = to_vvq(_vq);
>>> +
>>> +    /* Pairs with READ_ONCE() in virtqueue_is_broken(). */
>>> +    WRITE_ONCE(vq->broken, false);
>>> +}
>> I don't think these "Pairs" comments have any value.
>>
>>
>>> +EXPORT_SYMBOL_GPL(__virtqueue_unbreak);
>>> +
>>>   bool virtqueue_is_broken(struct virtqueue *_vq)
>>>   {
>>>       struct vring_virtqueue *vq = to_vvq(_vq);
>>> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
>>> index 1272566adec6..dc474a0d48d1 100644
>>> --- a/include/linux/virtio.h
>>> +++ b/include/linux/virtio.h
>>> @@ -138,6 +138,9 @@ bool is_virtio_device(struct device *dev);
>>>   void virtio_break_device(struct virtio_device *dev);
>>>   void __virtio_unbreak_device(struct virtio_device *dev);
>>>   +void __virtqueue_break(struct virtqueue *_vq);
>>> +void __virtqueue_unbreak(struct virtqueue *_vq);
>>> +
>>>   void virtio_config_changed(struct virtio_device *dev);
>>>   #ifdef CONFIG_PM_SLEEP
>>>   int virtio_device_freeze(struct virtio_device *dev);
>>> -- 
>>> 2.31.0

