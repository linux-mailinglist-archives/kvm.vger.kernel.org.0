Return-Path: <kvm+bounces-25075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4865995F996
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 21:23:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DC591C2218C
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 19:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECAE3199234;
	Mon, 26 Aug 2024 19:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="QoLu3gs3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312DE1991AB
	for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 19:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724700182; cv=none; b=D8bLIfamHUjITdzxNrJ6M03SOY0R6Dmh5jOefujx7q6zHRkKZOvfiqf7qcAJ/1VsPgmFhPfLYhVPig8TB6Dh+Z2QZoCDMDAGPVCuYfOOR8Pdcq8LahYNzGxxLVQaGI9D043tq7A6JOltrG4VvC2WSHtPXwEwbEUgrtn/+B5B6BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724700182; c=relaxed/simple;
	bh=tDJNUr27zxTQ4SUunjdZ0ylIYlgXCyM8c00NYRgGDuw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j6Xa7xytuRgjBWxYzKZwxFahyffvrjvbfNPRNQh7VyEexT61nON7lL0r3n4A/9yE3u2E8XF0jcvQaUM/hqtGBPOFf+zCvlp/9Te+849NaiBv2wjoHOWeZ57A8T9LS4CC9+pAkyGLfpBLlNgKdyBJWJKn2cIyGlCQ5zAV/2CVqpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=digitalocean.com; spf=pass smtp.mailfrom=digitalocean.com; dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b=QoLu3gs3; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digitalocean.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-6b44dd520ceso45465637b3.0
        for <kvm@vger.kernel.org>; Mon, 26 Aug 2024 12:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google; t=1724700179; x=1725304979; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F6LqBt/cgf5saFNqougCditEz5JCrr5uJaPi0WKZXWo=;
        b=QoLu3gs3omZpy7j6KkBNyUm3+qvqE79ETW/WoWzgFM8DpjcC/stY01owVBqrrG06R/
         yazR1E8Rqfcixds5QsYgnvSLwJzTyPsIggAjENAfUqBaEGfrXmOOkqOzw5ZPsNAx64rL
         W6dHYp2+kE2q8Ax+/bEvzlIYDX27IUqWBJKkA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724700179; x=1725304979;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F6LqBt/cgf5saFNqougCditEz5JCrr5uJaPi0WKZXWo=;
        b=uxaC4DG9a/iY3hLfSsqQgoBuAWkNwOXzZ+0QVm37q81EN+OW5tsWodR3/orKUodGWW
         FAsoSsZSXkTC79Cc1KZNTRaPn36yMb+fbgTDwXlmID/QK2ba3dpwy7mjn88pINQ79i9o
         x94T56pPbIDJzOwoTlyvBJeiwEZNNKv+eUA/SZ2bOvst0YJ0YsEnlClFX7v+SAp6Pf89
         AfBJ5pPwSO4A5NfpD6Lgp7bRUodz5cP6ImMJAkSmW6WGN9eA9L1lsDbGmV3U50uplxzZ
         gq5POq0XDckWUyp1ydR99HAWaXchcVEfGha73j0UIK+GNSEi4ZL9xwDk2hno3Ri27+Oy
         reqg==
X-Forwarded-Encrypted: i=1; AJvYcCXzag4OmAKglQ9jHV/y9gFbD4yxVHOPdNGMWwvrXWCHzrexwwJkpugLZrdewGxOfAPW7Cs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCmUrqYEi/etkhYW//iC5oZsoc02KxsPled8yt3ysc590eI+3l
	zuL7sfWoicD9bX9Ks6PRhto0V9ef54iFzByv9lZi4FiwJ6GjjnO8YEzblKBXWY4=
X-Google-Smtp-Source: AGHT+IENvO39dZD8SM8XQUS6jkNMVVXZUu4Li0XJ01QpUNqrH5VA9EYbqM15qZGvjmYzMuTP3QTLBw==
X-Received: by 2002:a05:690c:1d:b0:664:5957:f7a with SMTP id 00721157ae682-6c624dca095mr146931867b3.15.1724700179081;
        Mon, 26 Aug 2024 12:22:59 -0700 (PDT)
Received: from ?IPV6:2603:8080:7400:36da:45f:f211:3a7c:9377? ([2603:8080:7400:36da:45f:f211:3a7c:9377])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6c39d3a9a93sm16400567b3.89.2024.08.26.12.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Aug 2024 12:22:58 -0700 (PDT)
Message-ID: <1cb17652-3437-472e-b8d5-8078ba232d60@digitalocean.com>
Date: Mon, 26 Aug 2024 14:22:57 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Why is set_config not supported in mlx5_vnet?
To: Dragos Tatulea <dtatulea@nvidia.com>, eli@mellanox.com, mst@redhat.com,
 jasowang@redhat.com, xuanzhuo@linux.alibaba.com
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, eperezma@redhat.com,
 sashal@kernel.org, yuehaibing@huawei.com, steven.sistare@oracle.com
References: <33feec1a-2c5d-46eb-8d66-baa802130d7f@digitalocean.com>
 <afcbf041-7613-48e6-8088-9d52edd907ff@nvidia.com>
 <8a15a46a-2744-4474-8add-7f6fb35552b3@digitalocean.com>
 <2a1a4dfb-aef1-47c1-81ce-b29ed302c923@nvidia.com>
Content-Language: en-US
From: Carlos Bilbao <cbilbao@digitalocean.com>
In-Reply-To: <2a1a4dfb-aef1-47c1-81ce-b29ed302c923@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello,

On 8/26/24 10:53 AM, Dragos Tatulea wrote:
>
> On 26.08.24 16:26, Carlos Bilbao wrote:
>> Hello Dragos,
>>
>> On 8/26/24 4:06 AM, Dragos Tatulea wrote:
>>> On 23.08.24 18:54, Carlos Bilbao wrote:
>>>> Hello,
>>>>
>>>> I'm debugging my vDPA setup, and when using ioctl to retrieve the
>>>> configuration, I noticed that it's running in half duplex mode:
>>>>
>>>> Configuration data (24 bytes):
>>>>   MAC address: (Mac address)
>>>>   Status: 0x0001
>>>>   Max virtqueue pairs: 8
>>>>   MTU: 1500
>>>>   Speed: 0 Mb
>>>>   Duplex: Half Duplex
>>>>   RSS max key size: 0
>>>>   RSS max indirection table length: 0
>>>>   Supported hash types: 0x00000000
>>>>
>>>> I believe this might be contributing to the underperformance of vDPA.
>>> mlx5_vdpa vDPA devicess currently do not support the VIRTIO_NET_F_SPEED_DUPLEX
>>> feature which reports speed and duplex. You can check the state on the
>>> PF.
>>
>> According to ethtool, all my devices are running at full duplex. I assume I
>> can disregard this configuration output from the module then.
>>
> Yep.
>
>>>> While looking into how to change this option for Mellanox, I read the following
>>>> kernel code in mlx5_vnet.c:
>>>>
>>>> static void mlx5_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset, const void *buf,
>>>>                  unsigned int len)
>>>> {
>>>>     /* not supported */
>>>> }
>>>>
>>>> I was wondering why this is the case.
>>> TBH, I don't know why it was not added. But in general, the control VQ is the
>>> better way as it's dynamic.
>>>
>>>> Is there another way for me to change
>>>> these configuration settings?
>>>>
>>> The configuration is done using control VQ for most things (MTU, MAC, VQs,
>>> etc). Make sure that you have the CTRL_VQ feature set (should be on by
>>> default). It should appear in `vdpa mgmtdev show` and `vdpa dev config
>>> show`.
>>
>> I see that CTRL_VQ is indeed enabled. Is there any documentation on how to
>> use the control VQ to get/set vDPA configuration values?
>>
>>
> You are most likely using it already through through qemu. You can check
> if the CTR_VQ feature also shows up in the output of `vdpa dev config show`.
>
> What values are you trying to configure btw?


Yes, CTRL_VQ also shows up in vdpa dev config show. There isn't a specific
value I want to configure ATM, but my vDPA isn't performing as expected, so
I'm investigating potential issues. Below is the code I used to retrieve
the configuration from the driver; I'd be happy to send it as a patch if
you or someone else reviews it.


>
> Thanks,
> Dragos


Thanks,
Carlos

---

From ab6ea66c926eaf1e95eb5d73bc23183e0021ee27 Mon Sep 17 00:00:00 2001
From: Carlos Bilbao <bilbao@vt.edu>
Date: Sat, 24 Aug 2024 00:24:56 +0000
Subject: [PATCH] mlx5: Add support to update the vDPA configuration

This is needed for VHOST_VDPA_SET_CONFIG.

Signed-off-by: Carlos Bilbao <cbilbao@digitalocean.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index b56aae3f7be3..da31c743b2b9 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2909,14 +2909,32 @@ static void mlx5_vdpa_get_config(struct vdpa_device *vdev, unsigned int offset,
     struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
     struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);

-    if (offset + len <= sizeof(struct virtio_net_config))
+    if (offset + len <= sizeof(struct virtio_net_config)) {
         memcpy(buf, (u8 *)&ndev->config + offset, len);
+        }
+        else
+        {
+            printk(KERN_ERR "%s: Offset and length out of bounds\n",
+            __func__);
+        }
+
 }

 static void mlx5_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset, const void *buf,
                  unsigned int len)
 {
-    /* not supported */
+    struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
+    struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
+
+    if (offset + len <= sizeof(struct virtio_net_config))
+    {
+        memcpy((u8 *)&ndev->config + offset, buf, len);
+    }
+    else
+    {
+        printk(KERN_ERR "%s: Offset and length out of bounds\n",
+        __func__);
+    }
 }

 static u32 mlx5_vdpa_get_generation(struct vdpa_device *vdev)
--
2.34.1



