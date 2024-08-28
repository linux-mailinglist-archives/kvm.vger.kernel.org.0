Return-Path: <kvm+bounces-25264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7467A962BF2
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 17:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 96069B259ED
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 15:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C481A4F03;
	Wed, 28 Aug 2024 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="YkZHTNbc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828021A3BAF
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 15:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724858222; cv=none; b=hmGfYQlM1c+WNMquMhuLhmvI/BHrfAi9QK+Lhxr5TUuViOtOs+fqgEHwiKw7BMWYy5+sL6hFOV412uk7zdrZsJLBj2Uz2bo3kyGt+c8WPx4OF9pkoFlWoMzspobJmyREodunba4YcMxBkff+CBL4/XiKQzf/ZyKvLBI8uqBd0EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724858222; c=relaxed/simple;
	bh=xPt1LWc7MsVJzs0jRtvJXkECKkEZFYHwZ0GlYLY3Xcs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LXnm4zWM7N/17NXoGYfIJ9jhTnsDc1c7hVifsX84x2qJFGXqUDbJgqYclo61Qn/737lNt6Yz5BxNSzswHECYXBjsPm9SeS72F1wNqb6rmmT4vU0xtmwEIxq4XQgrWlgT/5jlYEqjmJR8S3j2GXxXayKNwPklnBtnKihsWvTt8MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=digitalocean.com; spf=pass smtp.mailfrom=digitalocean.com; dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b=YkZHTNbc; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digitalocean.com
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-39e6a32ae15so5112605ab.3
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 08:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google; t=1724858219; x=1725463019; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mnIeLd/tf7wU3lqEopn2g1kQhYPWYwkn8SEaIQNr7jE=;
        b=YkZHTNbcxmbtoHs3t6f5/eCtGd9xHetp/mJMeJy1Dv2/Jarzy4Bq+3VLDkFkrMn8+j
         9kfexvzvxAeK78vPuciM4iw8pOKBnVJL/ekaLS2PD32aOgMvu4Y1pb/GC0P+dd8QRNyR
         dqCvaXWGziGdZZb6Ya4FnxjhOeBM69Xo6fo5o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724858219; x=1725463019;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mnIeLd/tf7wU3lqEopn2g1kQhYPWYwkn8SEaIQNr7jE=;
        b=c0UDNTSrKnlNnnThUeermnswC6xfpslkyOxWsFVYhuoXQiZRZEjwg4EQ7xDGHo2QqH
         2yiDMQ5nRJvWDzZGsGOY67sMoL93ZSLilxqkY0PmwaiPDO5OQDqNIECFTZhnszc73FKb
         RqXGh9GzqbgdbggNj25duLoOdhAZFCti068c2BJSw9FhRT02OG+3Qbl1R4DHEX7AQ1DI
         P4qDiJzP0jJ/8sbjTlFhIARCsrYWFvXfp93L7Cotn1J76K/VK1GpzXchc9COsqsm58q+
         fZFgBL03fiTwN9j1tKXV/Fq4+yCWIIm7WZcF6Rc5lP/T0FBXKODx967YFWsOH4pVfAFj
         hvYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeJ1540pjS7KtloMpkFttUF+3kJVjsljDz9WD00Zk6lEgv8G6bmXA+wt8I9M0lmHRrQUM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlGIeYgdTyTerqWrIMmm63qdy1MaDrXQ4JO6Rdefnl36bvJ+cb
	G+iIDBIc67+LyWmdStHAqS0ibnF0LnwJok/Eyt7kYT2b79mjjyPAftBlMlBWrOI=
X-Google-Smtp-Source: AGHT+IFFFJNAlhPS13AnIj/tW7iov+sjr7N3hsOtZHXwa49VtxjQjSEcnDwRwcE4+yC6ns7x3yYTxg==
X-Received: by 2002:a05:6e02:17cc:b0:39b:3c0c:c3a6 with SMTP id e9e14a558f8ab-39f3784c70dmr395835ab.22.1724858219330;
        Wed, 28 Aug 2024 08:16:59 -0700 (PDT)
Received: from ?IPV6:2603:8080:7400:36da:b4f6:16b8:9118:2c1a? ([2603:8080:7400:36da:b4f6:16b8:9118:2c1a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6c399cb53f6sm23830027b3.3.2024.08.28.08.16.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Aug 2024 08:16:58 -0700 (PDT)
Message-ID: <2b1ed697-ba3d-47d7-bda1-f4ef4790f11c@digitalocean.com>
Date: Wed, 28 Aug 2024 10:16:56 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Why is set_config not supported in mlx5_vnet?
To: Jason Wang <jasowang@redhat.com>
Cc: Dragos Tatulea <dtatulea@nvidia.com>, eli@mellanox.com, mst@redhat.com,
 xuanzhuo@linux.alibaba.com, virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 eperezma@redhat.com, sashal@kernel.org, yuehaibing@huawei.com,
 steven.sistare@oracle.com
References: <33feec1a-2c5d-46eb-8d66-baa802130d7f@digitalocean.com>
 <afcbf041-7613-48e6-8088-9d52edd907ff@nvidia.com>
 <8a15a46a-2744-4474-8add-7f6fb35552b3@digitalocean.com>
 <2a1a4dfb-aef1-47c1-81ce-b29ed302c923@nvidia.com>
 <1cb17652-3437-472e-b8d5-8078ba232d60@digitalocean.com>
 <CACGkMEvbc_4_KrnkZb-owH1moauntBmoKhHp1tsE5SL4RCMPog@mail.gmail.com>
Content-Language: en-US
From: Carlos Bilbao <cbilbao@digitalocean.com>
In-Reply-To: <CACGkMEvbc_4_KrnkZb-owH1moauntBmoKhHp1tsE5SL4RCMPog@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,

On 8/26/24 9:07 PM, Jason Wang wrote:
> On Tue, Aug 27, 2024 at 3:23 AM Carlos Bilbao <cbilbao@digitalocean.com> wrote:
>> Hello,
>>
>> On 8/26/24 10:53 AM, Dragos Tatulea wrote:
>>> On 26.08.24 16:26, Carlos Bilbao wrote:
>>>> Hello Dragos,
>>>>
>>>> On 8/26/24 4:06 AM, Dragos Tatulea wrote:
>>>>> On 23.08.24 18:54, Carlos Bilbao wrote:
>>>>>> Hello,
>>>>>>
>>>>>> I'm debugging my vDPA setup, and when using ioctl to retrieve the
>>>>>> configuration, I noticed that it's running in half duplex mode:
>>>>>>
>>>>>> Configuration data (24 bytes):
>>>>>>   MAC address: (Mac address)
>>>>>>   Status: 0x0001
>>>>>>   Max virtqueue pairs: 8
>>>>>>   MTU: 1500
>>>>>>   Speed: 0 Mb
>>>>>>   Duplex: Half Duplex
>>>>>>   RSS max key size: 0
>>>>>>   RSS max indirection table length: 0
>>>>>>   Supported hash types: 0x00000000
>>>>>>
>>>>>> I believe this might be contributing to the underperformance of vDPA.
>>>>> mlx5_vdpa vDPA devicess currently do not support the VIRTIO_NET_F_SPEED_DUPLEX
>>>>> feature which reports speed and duplex. You can check the state on the
>>>>> PF.
>>>> According to ethtool, all my devices are running at full duplex. I assume I
>>>> can disregard this configuration output from the module then.
>>>>
>>> Yep.
>>>
>>>>>> While looking into how to change this option for Mellanox, I read the following
>>>>>> kernel code in mlx5_vnet.c:
>>>>>>
>>>>>> static void mlx5_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset, const void *buf,
>>>>>>                  unsigned int len)
>>>>>> {
>>>>>>     /* not supported */
>>>>>> }
>>>>>>
>>>>>> I was wondering why this is the case.
>>>>> TBH, I don't know why it was not added. But in general, the control VQ is the
>>>>> better way as it's dynamic.
>>>>>
>>>>>> Is there another way for me to change
>>>>>> these configuration settings?
>>>>>>
>>>>> The configuration is done using control VQ for most things (MTU, MAC, VQs,
>>>>> etc). Make sure that you have the CTRL_VQ feature set (should be on by
>>>>> default). It should appear in `vdpa mgmtdev show` and `vdpa dev config
>>>>> show`.
>>>> I see that CTRL_VQ is indeed enabled. Is there any documentation on how to
>>>> use the control VQ to get/set vDPA configuration values?
>>>>
>>>>
>>> You are most likely using it already through through qemu. You can check
>>> if the CTR_VQ feature also shows up in the output of `vdpa dev config show`.
>>>
>>> What values are you trying to configure btw?
>>
>> Yes, CTRL_VQ also shows up in vdpa dev config show. There isn't a specific
>> value I want to configure ATM, but my vDPA isn't performing as expected, so
>> I'm investigating potential issues. Below is the code I used to retrieve
>> the configuration from the driver; I'd be happy to send it as a patch if
>> you or someone else reviews it.
>>
>>
>>> Thanks,
>>> Dragos
>>
>> Thanks,
>> Carlos
>>
>> ---
>>
>> From ab6ea66c926eaf1e95eb5d73bc23183e0021ee27 Mon Sep 17 00:00:00 2001
>> From: Carlos Bilbao <bilbao@vt.edu>
>> Date: Sat, 24 Aug 2024 00:24:56 +0000
>> Subject: [PATCH] mlx5: Add support to update the vDPA configuration
>>
>> This is needed for VHOST_VDPA_SET_CONFIG.
>>
>> Signed-off-by: Carlos Bilbao <cbilbao@digitalocean.com>
>> ---
>>  drivers/vdpa/mlx5/net/mlx5_vnet.c | 22 ++++++++++++++++++++--
>>  1 file changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> index b56aae3f7be3..da31c743b2b9 100644
>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> @@ -2909,14 +2909,32 @@ static void mlx5_vdpa_get_config(struct vdpa_device *vdev, unsigned int offset,
>>      struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>>      struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
>>
>> -    if (offset + len <= sizeof(struct virtio_net_config))
>> +    if (offset + len <= sizeof(struct virtio_net_config)) {
>>          memcpy(buf, (u8 *)&ndev->config + offset, len);
>> +        }
>> +        else
>> +        {
>> +            printk(KERN_ERR "%s: Offset and length out of bounds\n",
>> +            __func__);
>> +        }
>> +
>>  }
>>
>>  static void mlx5_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset, const void *buf,
>>                   unsigned int len)
>>  {
>> -    /* not supported */
>> +    struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>> +    struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
>> +
>> +    if (offset + len <= sizeof(struct virtio_net_config))
>> +    {
>> +        memcpy((u8 *)&ndev->config + offset, buf, len);
>> +    }
>> +    else
>> +    {
>> +        printk(KERN_ERR "%s: Offset and length out of bounds\n",
>> +        __func__);
>> +    }
>>  }
> This should follow the virtio-spec, for modern virtio-net devices,
> most of the fields are read only.


From mlx5_vnet.c function mlx5v_probe:

mgtdev->mgtdev.config_attr_mask = BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR) |
                    BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MAX_VQP) |
                    BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MTU) |
                    BIT_ULL(VDPA_ATTR_DEV_FEATURES);

Does this mean these are the fields that set_config can update? I'm a bit
confused because, according to the virtio spec, I thought only speed and
duplex were not read-only -- but I was also told updating them isn't
supported by vDPA devices.


> Thanks
>
>>  static u32 mlx5_vdpa_get_generation(struct vdpa_device *vdev)
>> --
>> 2.34.1
>>
>>

Thanks, Carlos


