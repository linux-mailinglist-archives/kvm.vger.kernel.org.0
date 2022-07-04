Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7EF564C4A
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 06:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiGDECz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 00:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiGDECy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 00:02:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 570406343
        for <kvm@vger.kernel.org>; Sun,  3 Jul 2022 21:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656907372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HDvcxMkTKOE3YDsEGpILSgl3XDOYTursfKJU9/dGAhI=;
        b=YGMPUSCY/oZturrisE4tzTzQW00JIdUqsrwbvp+Z5RqT0y/Xta9CDNjyj8do5o9WPaLo2X
        XHqUNjD30FUOEiGyajlCE7d6HWaJojNRRILlttotgI36n6u4fyGeuP+XkWfX3U0R8fnmvr
        bksd0uEwIuL9H1juHZwfI0GZlp6HRzI=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-Wnw1MCVDOJS7_7tYt41Gzw-1; Mon, 04 Jul 2022 00:02:49 -0400
X-MC-Unique: Wnw1MCVDOJS7_7tYt41Gzw-1
Received: by mail-pj1-f69.google.com with SMTP id u1-20020a17090a450100b001ef1c4c2844so4890265pjg.4
        for <kvm@vger.kernel.org>; Sun, 03 Jul 2022 21:02:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HDvcxMkTKOE3YDsEGpILSgl3XDOYTursfKJU9/dGAhI=;
        b=uK7mgqSJDr9oIQRuTdmUNrNdVAD2qzYHml+5nIsM7baVSA/MuxCGkH7kneGYJORlhO
         4AlCKS7FBqa0mt7b1cDmgV69hT/MvKbJ9V//pdk1jzBD4nPvCf+78AKiIb2xymfBgO+A
         9urynm1jBcWKziUcF6yNqNK9knOsybm6Xi6RSAHyNmeNH1idiwPCFJDLH0pfsovyM7OY
         BQuFXS71o2DtAep7rqqtOgLzL8L20hh0AJMs3z01w2uN3x9ilt0fgnq/Mn8maPaPSbV1
         4K18RCkVKxdYIRBFSCE9rZiBwdWZLncRaCGGraLCRWigWM6qfkbnbUaA3cYFNPzPwVFW
         7Hpw==
X-Gm-Message-State: AJIora9uYGxQKWZS6URpYibUyY15eOv2rqZ5osMKYFCbZaQ3BYNrkSha
        JO4AiTuOz2xkvzluKoVlATXrOoNDjAErZSfqo4gHHxy6skFppx9OMN9lVn5TjPmtc6/YeHF8wVi
        kkMoWED3CvZ9T
X-Received: by 2002:a17:902:7604:b0:16a:f36d:73f3 with SMTP id k4-20020a170902760400b0016af36d73f3mr33910488pll.170.1656907367250;
        Sun, 03 Jul 2022 21:02:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uxDno/Wbd/PRnmg2ukyIktZ4uuSCmlyYFX7x8EioNmBJfd4eulRHgxbl4Lai6a6wYdtHVs8g==
X-Received: by 2002:a17:902:7604:b0:16a:f36d:73f3 with SMTP id k4-20020a170902760400b0016af36d73f3mr33910464pll.170.1656907366984;
        Sun, 03 Jul 2022 21:02:46 -0700 (PDT)
Received: from [10.72.13.251] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w16-20020aa79a10000000b0051ba90d55acsm20008816pfj.207.2022.07.03.21.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jul 2022 21:02:46 -0700 (PDT)
Message-ID: <fd85439f-8c94-e4f9-8500-811b3cf4c9ed@redhat.com>
Date:   Mon, 4 Jul 2022 12:02:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v11 21/40] virtio_ring: packed: introduce
 virtqueue_resize_packed()
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
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
        kangjie.xu@linux.alibaba.com,
        virtualization@lists.linux-foundation.org
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-22-xuanzhuo@linux.alibaba.com>
 <de7cf56d-acbd-1a2b-2226-a9fdd89afb78@redhat.com>
 <1656900812.860175-2-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <1656900812.860175-2-xuanzhuo@linux.alibaba.com>
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


在 2022/7/4 10:13, Xuan Zhuo 写道:
> On Fri, 1 Jul 2022 17:27:48 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> 在 2022/6/29 14:56, Xuan Zhuo 写道:
>>> virtio ring packed supports resize.
>>>
>>> Only after the new vring is successfully allocated based on the new num,
>>> we will release the old vring. In any case, an error is returned,
>>> indicating that the vring still points to the old vring.
>>>
>>> In the case of an error, re-initialize(by virtqueue_reinit_packed()) the
>>> virtqueue to ensure that the vring can be used.
>>>
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> ---
>>>    drivers/virtio/virtio_ring.c | 29 +++++++++++++++++++++++++++++
>>>    1 file changed, 29 insertions(+)
>>>
>>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>>> index 650f701a5480..4860787286db 100644
>>> --- a/drivers/virtio/virtio_ring.c
>>> +++ b/drivers/virtio/virtio_ring.c
>>> @@ -2042,6 +2042,35 @@ static struct virtqueue *vring_create_virtqueue_packed(
>>>    	return NULL;
>>>    }
>>>
>>> +static int virtqueue_resize_packed(struct virtqueue *_vq, u32 num)
>>> +{
>>> +	struct vring_virtqueue_packed vring = {};
>>> +	struct vring_virtqueue *vq = to_vvq(_vq);
>>> +	struct virtio_device *vdev = _vq->vdev;
>>> +	int err;
>>> +
>>> +	if (vring_alloc_queue_packed(&vring, vdev, num))
>>> +		goto err_ring;
>>> +
>>> +	err = vring_alloc_state_extra_packed(&vring);
>>> +	if (err)
>>> +		goto err_state_extra;
>>> +
>>> +	vring_free(&vq->vq);
>>> +
>>> +	virtqueue_init(vq, vring.vring.num);
>>> +	virtqueue_vring_attach_packed(vq, &vring);
>>> +	virtqueue_vring_init_packed(vq);
>>> +
>>> +	return 0;
>>> +
>>> +err_state_extra:
>>> +	vring_free_packed(&vring, vdev);
>>> +err_ring:
>>> +	virtqueue_reinit_packed(vq);
>>
>> So desc_state and desc_extra has been freed vring_free_packed() when
>> vring_alloc_state_extra_packed() fails. We might get use-after-free here?
> vring_free_packed() frees the temporary structure vring. It does not affect
> desc_state and desc_extra of vq. So it is safe.


You are right.


>
>> Actually, I think for resize we need
>>
>> 1) detach old
>> 2) allocate new
>> 3) if 2) succeed, attach new otherwise attach old
>
> The implementation is now:
>
> 1. allocate new
> 2. free old (detach old)
> 3. attach new
>
> error:
> 1. free temporary
> 2. reinit old
>
> Do you think this is ok? We need to add a new variable to save the old vring in
> the process you mentioned, there is not much difference in other.


Yes, I think the code is fine. But I'd suggest to rename "vring" to 
"vring_packed", this simplify the reviewers.

Other than this, you can add:

Acked-by: Jason Wang <jasowang@redhat.com>


>
> Thanks.
>
>
>> This seems more clearer than the current logic?
>>
>> Thanks
>>
>>
>>> +	return -ENOMEM;
>>> +}
>>> +
>>>
>>>    /*
>>>     * Generic functions and exported symbols.

