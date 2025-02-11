Return-Path: <kvm+bounces-37829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAB6FA30684
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 09:58:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9B6D162C8F
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 08:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 301761F12ED;
	Tue, 11 Feb 2025 08:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LyPA6XyV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2951F0E25
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 08:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739264272; cv=none; b=eLe7dOYdQ2EWDU9yDOZlwjNOGwSkc+4leSIb0wY5QTO6PQP6L9+x3Hjz7u1AaFgRrgG+xED6gLGRLbCKT1JhkiH1rw5BirCXwFyDNzRSMLihTRD2ndwMXGHsvb2rp4pcO2WDK7EiuD/2IbbX1a+pnZM6P3/GxWLHcHKWkufP6hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739264272; c=relaxed/simple;
	bh=HDnBlOyPw8QhBcGdjodP9zFRxyfM6MYgL5alIXcYcHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SWZ93VgdkoIFZF0KrNxgVv7qYCcu5dRy//lyouZS8nS7wu/+RT/aZhFYyKp77tBU21O06yNYq7ByRF0gXmljb3jSbFSQ62NvlllTRABvhumAYqvIIGiizYF7XuUskG1gkjcwo6dFQiMTyjsQZ6g/gL967OS2If7daSG7EH71vOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LyPA6XyV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739264269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zIQbPjiqwmwUxZhJUEjUvnEZCNp6KfZmxpyLl8jvIIY=;
	b=LyPA6XyVAdjwn8AdhpPcHzpjM+x8ib5qWeiEaK9HraQntPbi180TXgUUOZjujRhG0/Pjgh
	3WSPfFYbs0Xsdq6ydUi5gVD0nYTzkdZcxnmzrdx6e7nwkmkpdVQVH+vc8TthXy2uph/qcV
	aevO9HCzQ0MUsFSdeMh1fbq0NKGZcC0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-czHi2zcpMPCbKQ5lHzgUTw-1; Tue, 11 Feb 2025 03:57:48 -0500
X-MC-Unique: czHi2zcpMPCbKQ5lHzgUTw-1
X-Mimecast-MFC-AGG-ID: czHi2zcpMPCbKQ5lHzgUTw
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-38ddf4fa345so966007f8f.2
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 00:57:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739264267; x=1739869067;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zIQbPjiqwmwUxZhJUEjUvnEZCNp6KfZmxpyLl8jvIIY=;
        b=G15nscrhRVdSVeTernPyauECn3tSoNKJAyLGRXfPJSipAcrux81aLQKWqFBOyBBjKe
         tmj1MjSdpmFUUNscwPmVKdGnDpJlEbJKlOfNeHH/NDdTM5kLjt5E2+CSkO6DMVRXTQMk
         UTKSpzszOKl5BMAWp8/e/Ct+HI54PaMIa1AMY2tZjTQWZ2LRxYCzLAW3J6ibxNiUeycD
         TUT/JpvNvH4kGK6Y6PXc7kAgQmURo+szMgbLikAhoPquEUDHIm9zBo95iUBjp7CadN/j
         j7fNAvF+0JFjg59+Fh2oYoH4dZ+BcDeADVR5EXN2gtwXkrLG8FBoCGq3n8SzJoXJ7G5U
         ZN8A==
X-Forwarded-Encrypted: i=1; AJvYcCUABeL0lYpSTgW99CXFkPvznfYtweJdeEH+sRKsr/qFbq8Z/o+CgpCrYZGoNa+w0z54KiU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKo+ChAP+aXLQchPvSym1+ZhqdCWDctSgmjyr4QoqgUoK8NrRT
	HFyF4N8+Kgme0Bql76PDIFHmXAtwOnbn+5sTvXfgEyPtYYHrWzZm7zOAmMiJEZjv41g4ZxGUjgI
	ra8dVFEq7z5+voW2RayhovnSY7KUDJInzELhieG3nwCaK3s0XLQ==
X-Gm-Gg: ASbGncsnaqOM55XndwTlnWAYjnwj1L4/1oGpads0xIwRPLKwTLgwFpnch5LgHLegwcO
	aOBIOmfCodMT0HFh6KXfyGImMMos9LydBZQ36StK93fDf8o92HPNTb+vYnFO1DM6X1Dpu9tnd6u
	pCv0+wO5Z0hPvthvyeEHSPyAf45zMDBD4h6bwjsXkVAShlXBXjcrlhjjZZ3HN8N/j37qBD5L/Ph
	jrgkNKxuRn/x+oC5g70u9ti7wy0oVm8pRl8AkZDbAkzMJcbvg7REhk550VzQi2PN4kgHEjTo1Yc
	eFElpfPDjCFq/qGxDJv9Cyqo/eTgVlmVDkNVGcn2IJ2RtxdvSQJXXg==
X-Received: by 2002:a5d:438f:0:b0:386:3835:9fec with SMTP id ffacd0b85a97d-38dc935fba0mr13080913f8f.44.1739264266786;
        Tue, 11 Feb 2025 00:57:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG9gS/8oWxy2/+63oWaWVYrKsS8WPZEr2M1pgDTFIO4r0DJWvdJ3n9OPtCV6k/zDtewXv+XUA==
X-Received: by 2002:a5d:438f:0:b0:386:3835:9fec with SMTP id ffacd0b85a97d-38dc935fba0mr13080869f8f.44.1739264266036;
        Tue, 11 Feb 2025 00:57:46 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-29.retail.telecomitalia.it. [79.46.200.29])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4391da9652bsm173908095e9.2.2025.02.11.00.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 00:57:45 -0800 (PST)
Date: Tue, 11 Feb 2025 09:57:41 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Junnan Wu <junnan01.wu@samsung.com>
Cc: stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	xuanzhuo@linux.alibaba.com, eperezma@redhat.com, horms@kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	q1.huang@samsung.com, ying01.gao@samsung.com, ying123.xu@samsung.com, 
	lei19.wang@samsung.com
Subject: Re: [Patch net 1/2] vsock/virtio: initialize rx_buf_nr and
 rx_buf_max_nr when resuming
Message-ID: <gr5rqfwb4qgc23dadpfwe74jvsq37udpeqwhpokhnvvin6biv2@6v5npbxf6kbn>
References: <20250211071922.2311873-1-junnan01.wu@samsung.com>
 <CGME20250211071941epcas5p308a13898102cf851bc9988c0e2766c5e@epcas5p3.samsung.com>
 <20250211071922.2311873-2-junnan01.wu@samsung.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250211071922.2311873-2-junnan01.wu@samsung.com>


You need to update the title now that you're moving also queued_replies.

On Tue, Feb 11, 2025 at 03:19:21PM +0800, Junnan Wu wrote:
>When executing suspend to ram twice in a row,
>the `rx_buf_nr` and `rx_buf_max_nr` increase to three times vq->num_free.
>Then after virtqueue_get_buf and `rx_buf_nr` decreased
>in function virtio_transport_rx_work,
>the condition to fill rx buffer
>(rx_buf_nr < rx_buf_max_nr / 2) will never be met.
>
>It is because that `rx_buf_nr` and `rx_buf_max_nr`
>are initialized only in virtio_vsock_probe(),
>but they should be reset whenever virtqueues are recreated,
>like after a suspend/resume.
>
>Move the `rx_buf_nr` and `rx_buf_max_nr` initialization in
>virtio_vsock_vqs_init(), so we are sure that they are properly
>initialized, every time we initialize the virtqueues, either when we
>load the driver or after a suspend/resume.
>At the same time, also move `queued_replies`.

Why?

As I mentioned the commit description should explain why the changes are 
being made for both reviewers and future references to this patch.

The rest LGTM.

Stefano

>
>Fixes: bd50c5dc182b ("vsock/virtio: add support for device suspend/resume")
>Co-developed-by: Ying Gao <ying01.gao@samsung.com>
>Signed-off-by: Ying Gao <ying01.gao@samsung.com>
>Signed-off-by: Junnan Wu <junnan01.wu@samsung.com>
>---
> net/vmw_vsock/virtio_transport.c | 10 +++++++---
> 1 file changed, 7 insertions(+), 3 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index b58c3818f284..f0e48e6911fc 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -670,6 +670,13 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
> 	};
> 	int ret;
>
>+	mutex_lock(&vsock->rx_lock);
>+	vsock->rx_buf_nr = 0;
>+	vsock->rx_buf_max_nr = 0;
>+	mutex_unlock(&vsock->rx_lock);
>+
>+	atomic_set(&vsock->queued_replies, 0);
>+
> 	ret = virtio_find_vqs(vdev, VSOCK_VQ_MAX, vsock->vqs, vqs_info, NULL);
> 	if (ret < 0)
> 		return ret;
>@@ -779,9 +786,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>
> 	vsock->vdev = vdev;
>
>-	vsock->rx_buf_nr = 0;
>-	vsock->rx_buf_max_nr = 0;
>-	atomic_set(&vsock->queued_replies, 0);
>
> 	mutex_init(&vsock->tx_lock);
> 	mutex_init(&vsock->rx_lock);
>-- 
>2.34.1
>


