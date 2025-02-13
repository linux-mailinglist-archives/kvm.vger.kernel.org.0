Return-Path: <kvm+bounces-38015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5BB6A33B30
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 10:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D5BF3A6C4C
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 09:26:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B76320FAA9;
	Thu, 13 Feb 2025 09:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KRfA+b3T"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC0E20E6F3
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 09:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739438741; cv=none; b=nlTYFEmmp/+0vcfsR7miGzhuL/8OH8R6wcxDh2pHepu/chTGt4ZyBrm0CVIBVP45aCyXZSxV3+NopJHyBBF4R1iHrApyohvYS8B0e6bQ68dipA1u+eKoTsO3OmbtEnixqiOHBRIo27oUBGnlQBX+Afk40HohpVNV/1O9ybX54/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739438741; c=relaxed/simple;
	bh=kNZDvEJf3qJnJsEpcSDOQdrXDI+7ntqzAaEqCJM8JY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2dWNiYh3h4VQmPVvQdJpwOTx3AwldR9fQOMIXvRhGV5phJACgZAMOdgP2URJhpYJQnH6KlnVhi6AzrUvKOk0vSdTNsHq/rH8IAVLUaq2u7ft7QKURau/erBIA0wFrMsNv3qblVDaXhNqVlRmfmsI0b6DCqyQQgYDA5eZqN6Se4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KRfA+b3T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739438737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gODipQT1RJ6DR0/GMvEisYcVEgWaoya2b4Hn/2vB8dw=;
	b=KRfA+b3TbDVOSqjnMIeit5ovLd9DfBQ9mGrZ7a8Iwvk8Hl/E+Ycvqjj09hMUITVM7JYk62
	laDoB+XMnH8nHpLGKftAU+sB+Zhc3kMk/NXLZ1E/SYYE70yG0d2vKKuiQnsqLGFZJjkg6h
	NK5GtMHsXeQq5q527IM2SE9y4xLb+3w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-fEqBJnegNN-WdnmCcOlLsg-1; Thu, 13 Feb 2025 04:25:35 -0500
X-MC-Unique: fEqBJnegNN-WdnmCcOlLsg-1
X-Mimecast-MFC-AGG-ID: fEqBJnegNN-WdnmCcOlLsg_1739438734
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38dce0d3d34so350920f8f.2
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 01:25:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739438734; x=1740043534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gODipQT1RJ6DR0/GMvEisYcVEgWaoya2b4Hn/2vB8dw=;
        b=NIG6OkSrHsDWpiGzakY9ELaSHvb6b8TY3c2ZHrw6LAnG2eTOuHUJUuEcUpehPWmfem
         0ub03/E5QuBUTwGf7nmh2WGwlx4Zt/3av5ZGsjq3AtFoqci9zrm3w6VLPDMMV7Vb64vP
         UMGlSUPyrUbR4u9sP8ACBtDWuXkXfsTFw6d0mDUlBriHzofg2kavMpOZ6uoaTGC6IWL6
         oGKgnEnDkN2exCw0pg62783wiBiyBrLg3KzFk4hcvJgDwQYKGDdnmYjlDYR5NRwmPKZ1
         yy/zvylRGJLWS62MFYpS11El8qL+yxMeJ7QesM4gEixhPFwPBHVW8dQg1cnspWwuYUh8
         DuQg==
X-Forwarded-Encrypted: i=1; AJvYcCWGoMh8hVWWGLRmpJpns/TVkGN46jxCnwUxjw9/g/uW4rTtXVO4xL0wvm7aPh6JtcBnGBA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa51QandtqThdgVHekCgFyEkkWgPmMFY8yTNpytKqyqGDP//J4
	Kp+fDHjAJL3of46X03m+ei7BGxGzrRxSzpbnjpRpyVVxoS8iT+b6FxVe33LK135Q1HKez7Esi75
	RfAwFaSqW/J1Po3OvJXahWZfrpEIcez4WYDzbZ+NpBkJndLlKxA==
X-Gm-Gg: ASbGnctkgDPo/SfLsWjtkinuHHC8mOiYHeBUBKjfk94kHXs5anUbTroD5+P1baTa4XZ
	gFLG9TtFCpSaa76vGqpWfhkhk1LGm/B9zTKo/YvsIzwV87b/Yo0toMOvn7zLVn9p9uybE2zdVQv
	+aox0TrbPXUp0dZz6Ya6khv2UIo6FmURKLv4VooSnAgNUfb3EwBwFEDSjeSaojHH8PrkUL/NWNF
	ZmmSFTiu8smb6UTiYD1DCAWE/+NKTjhEvdlP6WY8c0A+v82a1jGMhZhfdGDiFNV1SSDXvImANSz
	3d8Bsuq/0uOyv4JOspr30YvwaxpwjYR4oXwdBlLHvY8e326tkkTFdQ==
X-Received: by 2002:a5d:5984:0:b0:38f:2350:7f70 with SMTP id ffacd0b85a97d-38f235080e6mr2406581f8f.24.1739438733950;
        Thu, 13 Feb 2025 01:25:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEoCVYCjHVfohwpNNaQmSzmtARyIP61OU3BHF6Vls4lswHDEoUel/X9vFTBA8VTVIJQ/jGE9g==
X-Received: by 2002:a5d:5984:0:b0:38f:2350:7f70 with SMTP id ffacd0b85a97d-38f235080e6mr2406531f8f.24.1739438733293;
        Thu, 13 Feb 2025 01:25:33 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-29.retail.telecomitalia.it. [79.46.200.29])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f259f8273sm1280846f8f.89.2025.02.13.01.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 01:25:32 -0800 (PST)
Date: Thu, 13 Feb 2025 10:25:26 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Junnan Wu <junnan01.wu@samsung.com>
Cc: davem@davemloft.net, edumazet@google.com, eperezma@redhat.com, 
	horms@kernel.org, jasowang@redhat.com, kuba@kernel.org, kvm@vger.kernel.org, 
	lei19.wang@samsung.com, linux-kernel@vger.kernel.org, mst@redhat.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, q1.huang@samsung.com, stefanha@redhat.com, 
	virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com, ying01.gao@samsung.com, 
	ying123.xu@samsung.com
Subject: Re: [Patch net 1/2] vsock/virtio: initialize rx_buf_nr and
 rx_buf_max_nr when resuming
Message-ID: <4n2lobgp2wb7v5vywbkuxwyd5cxldd2g4lxb6ox3qomphra2gd@zhrnboczbrbw>
References: <gr5rqfwb4qgc23dadpfwe74jvsq37udpeqwhpokhnvvin6biv2@6v5npbxf6kbn>
 <CGME20250213012722epcas5p23e1c903b7ef0711441514c5efb635ee8@epcas5p2.samsung.com>
 <20250213012805.2379064-1-junnan01.wu@samsung.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250213012805.2379064-1-junnan01.wu@samsung.com>

On Thu, Feb 13, 2025 at 09:28:05AM +0800, Junnan Wu wrote:
>>You need to update the title now that you're moving also queued_replies.
>>
>
>Well, I will update the title in V3 version.
>
>>On Tue, Feb 11, 2025 at 03:19:21PM +0800, Junnan Wu wrote:
>>>When executing suspend to ram twice in a row,
>>>the `rx_buf_nr` and `rx_buf_max_nr` increase to three times vq->num_free.
>>>Then after virtqueue_get_buf and `rx_buf_nr` decreased
>>>in function virtio_transport_rx_work,
>>>the condition to fill rx buffer
>>>(rx_buf_nr < rx_buf_max_nr / 2) will never be met.
>>>
>>>It is because that `rx_buf_nr` and `rx_buf_max_nr`
>>>are initialized only in virtio_vsock_probe(),
>>>but they should be reset whenever virtqueues are recreated,
>>>like after a suspend/resume.
>>>
>>>Move the `rx_buf_nr` and `rx_buf_max_nr` initialization in
>>>virtio_vsock_vqs_init(), so we are sure that they are properly
>>>initialized, every time we initialize the virtqueues, either when we
>>>load the driver or after a suspend/resume.
>>>At the same time, also move `queued_replies`.
>>
>>Why?
>>
>>As I mentioned the commit description should explain why the changes are
>>being made for both reviewers and future references to this patch.
>>
>
>After your kindly remind, I have double checked all locations where `queued_replies`
>used, and we think for order to prevent erroneous atomic load operations
>on the `queued_replies` in the virtio_transport_send_pkt_work() function
>which may disrupt the scheduling of vsock->rx_work
>when transmitting reply-required socket packets,
>this atomic variable must undergo synchronized initialization
>alongside the preceding two variables after a suspend/resume.

Yes, that was my concern!

>
>If we reach agreement on it, I will add this description in V3 version.

Yes, please, I just wanted to point out that we need to add an 
explanation in the commit description.

And in the title, in this case though listing all the variables would 
get too long, so you can do something like that:

     vsock/virtio: fix variables initialization during resuming

Thanks,
Stefano

>
>BRs
>Junnan Wu
>
>>The rest LGTM.
>>
>>Stefano
>>
>>>
>>>Fixes: bd50c5dc182b ("vsock/virtio: add support for device suspend/resume")
>>>Co-developed-by: Ying Gao <ying01.gao@samsung.com>
>>>Signed-off-by: Ying Gao <ying01.gao@samsung.com>
>>>Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
>>>---
>>> net/vmw_vsock/virtio_transport.c | 10 +++++++---
>>> 1 file changed, 7 insertions(+), 3 deletions(-)
>>>
>>>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>>>index b58c3818f284..f0e48e6911fc 100644
>>>--- a/net/vmw_vsock/virtio_transport.c
>>>+++ b/net/vmw_vsock/virtio_transport.c
>>>@@ -670,6 +670,13 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
>>> 	};
>>> 	int ret;
>>>
>>>+	mutex_lock(&vsock->rx_lock);
>>>+	vsock->rx_buf_nr = 0;
>>>+	vsock->rx_buf_max_nr = 0;
>>>+	mutex_unlock(&vsock->rx_lock);
>>>+
>>>+	atomic_set(&vsock->queued_replies, 0);
>>>+
>>> 	ret = virtio_find_vqs(vdev, VSOCK_VQ_MAX, vsock->vqs, vqs_info, NULL);
>>> 	if (ret < 0)
>>> 		return ret;
>>>@@ -779,9 +786,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>>>
>>> 	vsock->vdev = vdev;
>>>
>>>-	vsock->rx_buf_nr = 0;
>>>-	vsock->rx_buf_max_nr = 0;
>>>-	atomic_set(&vsock->queued_replies, 0);
>>>
>>> 	mutex_init(&vsock->tx_lock);
>>> 	mutex_init(&vsock->rx_lock);
>>>--
>>>2.34.1
>>>
>


