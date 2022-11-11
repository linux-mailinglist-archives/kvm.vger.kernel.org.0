Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62689625464
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 08:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbiKKHZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 02:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKKHZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 02:25:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69F2657F2
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 23:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668151462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mGF1hqUyS/IuY67TmrVD3p9aLrEy04dzHTj0jnkQqlo=;
        b=h3uMjLKY66fHNLQX64HhyVe8ttpe9zPgBAXf+iYkQNMioKgbryNknP/wwI6YtjgsCktTx6
        6CX2fPIGtOahl1u3A3mNXysr9mx8ouI7UuPLLY1Zl2yQpkzG3utE31576VLfMB9uj2UvcJ
        OIIv9+DsSVeNZdhyKN2tM6jIv8xyGzA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-587-wu6WeqrbPkOfC5ukwa8juw-1; Fri, 11 Nov 2022 02:24:21 -0500
X-MC-Unique: wu6WeqrbPkOfC5ukwa8juw-1
Received: by mail-pl1-f199.google.com with SMTP id q6-20020a170902dac600b001873ef77938so3039542plx.18
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 23:24:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mGF1hqUyS/IuY67TmrVD3p9aLrEy04dzHTj0jnkQqlo=;
        b=1czalti1k6wEkQYZ2D7XMfAs0dlu5amiJ09gn9qAPyV6McgYqARDeeowHxt+B1fR2r
         OhZ9e24ltnfyP5MUTt4lUjmBhLvCYVlzUbumWCxfCVOh2EcT/dJdxtRgqF/zCbIyXp18
         fsYOwCMvd/LIRYKzN9qyMHu5rjcZe8PlBvmP5/dQHMvhiZ59bW3bPOti8KFkxxQayYvy
         GkIuaPUJR0jXlTDzbV8pL096M4+hKZiO+mCdwQlNgtzAAXxAZc/ajTvg0OyktF96i9fx
         3669myjiURVYIF5s2N9gxhjIHY59eFTNP2h/yDKb32HJs5XeTAzGnw8SHouw+qvJlue5
         cG/Q==
X-Gm-Message-State: ANoB5pki/olCuXF+jDhwdONDsaG0sHrjQdXb4eDHyPQNabuU++ERpu0F
        QAwcmFQVy2pUBZmTh3Dq4DqGEADOYro1sNXnj/QuXP7rzC01dyyU0vnvWMtMv1UYVCPMI/73B9f
        909EBMwEa4Bvt
X-Received: by 2002:a17:90a:8c82:b0:210:c745:2a22 with SMTP id b2-20020a17090a8c8200b00210c7452a22mr611655pjo.36.1668151460356;
        Thu, 10 Nov 2022 23:24:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5cQGHmxl3EySgMqHg52aLNTbRSBXk2KymTU9czlvB/0wUg1mXUFWP5ReINRE3uyIggmPX1bA==
X-Received: by 2002:a17:90a:8c82:b0:210:c745:2a22 with SMTP id b2-20020a17090a8c8200b00210c7452a22mr611628pjo.36.1668151460062;
        Thu, 10 Nov 2022 23:24:20 -0800 (PST)
Received: from [10.72.13.217] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x10-20020aa7940a000000b0053b723a74f7sm891523pfo.90.2022.11.10.23.24.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 23:24:18 -0800 (PST)
Message-ID: <259e543e-2ede-e84c-3f3a-1542e072bbb5@redhat.com>
Date:   Fri, 11 Nov 2022 15:24:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v6 01/10] vdpa: Use v->shadow_vqs_enabled in
 vhost_vdpa_svqs_start & stop
Content-Language: en-US
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     qemu-devel@nongnu.org, Parav Pandit <parav@mellanox.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Cindy Lu <lulu@redhat.com>, Eli Cohen <eli@mellanox.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, kvm@vger.kernel.org,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221108170755.92768-1-eperezma@redhat.com>
 <20221108170755.92768-2-eperezma@redhat.com>
 <CACGkMEtvbSbsNZQV5RB1yyNzpam4QezdJ-f75nh4ToMJU=KYQQ@mail.gmail.com>
 <CAJaqyWdf-A8xEDVyX9f6y3FZhyp9bYMnuFU2jWFStCCvVNkDTA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <CAJaqyWdf-A8xEDVyX9f6y3FZhyp9bYMnuFU2jWFStCCvVNkDTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2022/11/10 20:54, Eugenio Perez Martin 写道:
> On Thu, Nov 10, 2022 at 6:22 AM Jason Wang <jasowang@redhat.com> wrote:
>> On Wed, Nov 9, 2022 at 1:08 AM Eugenio Pérez <eperezma@redhat.com> wrote:
>>> This function used to trust in v->shadow_vqs != NULL to know if it must
>>> start svq or not.
>>>
>>> This is not going to be valid anymore, as qemu is going to allocate svq
>>> unconditionally (but it will only start them conditionally).
>> It might be a waste of memory if we did this. Any reason for this?
>>
> Well, it's modelled after vhost_vdpa notifier member [1].


Right, this could be optimized in the future as well.


>
> But sure we can reduce the memory usage if SVQ is not used. The first
> function that needs it is vhost_set_vring_kick. But I think it is not
> a good function to place the delayed allocation.
>
> Would it work to move the allocation to vhost_set_features vhost op?
> It seems unlikely to me to call callbacks that can affect SVQ earlier
> than that one. Or maybe to create a new one and call it the first on
> vhost.c:vhost_dev_start?


Rethink about this, so I think we can leave this in the future.

Thanks


>
> Thanks!
>
> [1] The notifier member already allocates VIRTIO_QUEUE_MAX
> VhostVDPAHostNotifier for each vhost_vdpa, It is easy to reduce at
> least to the number of virtqueues on a vhost_vdpa. Should I send a
> patch for this one?
>
>
>> Thanks
>>
>>> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>>> ---
>>>   hw/virtio/vhost-vdpa.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/hw/virtio/vhost-vdpa.c b/hw/virtio/vhost-vdpa.c
>>> index 7468e44b87..7f0ff4df5b 100644
>>> --- a/hw/virtio/vhost-vdpa.c
>>> +++ b/hw/virtio/vhost-vdpa.c
>>> @@ -1029,7 +1029,7 @@ static bool vhost_vdpa_svqs_start(struct vhost_dev *dev)
>>>       Error *err = NULL;
>>>       unsigned i;
>>>
>>> -    if (!v->shadow_vqs) {
>>> +    if (!v->shadow_vqs_enabled) {
>>>           return true;
>>>       }
>>>
>>> @@ -1082,7 +1082,7 @@ static void vhost_vdpa_svqs_stop(struct vhost_dev *dev)
>>>   {
>>>       struct vhost_vdpa *v = dev->opaque;
>>>
>>> -    if (!v->shadow_vqs) {
>>> +    if (!v->shadow_vqs_enabled) {
>>>           return;
>>>       }
>>>
>>> --
>>> 2.31.1
>>>

