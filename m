Return-Path: <kvm+bounces-65733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CAF34CB502E
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 08:46:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8D6F8301A725
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F18622D8799;
	Thu, 11 Dec 2025 07:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JHBTkAsB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB9E2BD5BF
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 07:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765439156; cv=none; b=RF8RslKvaPMJEsrWfd+kYFBew3I/diVkBrkI2/d/NTPwjBKUtobuBIWllq3ajCA8wZ1+0S9B8u7uJyEZUvFGp1jfH2ADLPZ49HZjnpOC7QdmDpCK6YapohPoZb/6DO/orFcv7FIKNgaTBV0LJ+N6O+w09hgkPGesvvkwrgZZKWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765439156; c=relaxed/simple;
	bh=9mvg3H/c8i6Vw6drMjILUPrnDLVQ4fS3OBd1K9POmt0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=HaRxRupIhfjxEPxmaXKTA6qvcF4zXW1otJ9AgybtYdoL6uRgtW7/zRelQJw/0x/wmI4aF3pSAbUiRW02MfIleIv8bcFNAjPJ6b7cS5U0cRlXYhzoQUYb+TrzSsEncI7eTCqqPinSTiFy+gofMNXdh9Jm2wTptxQFGy3QDvxxWsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JHBTkAsB; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477632b0621so3456005e9.2
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 23:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765439152; x=1766043952; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X5PFu97mrs/j5hiZkT9fpEkRD8VCD4PVmKLSzKLxEz0=;
        b=JHBTkAsBs6CLKKp65u0MNvEQmof6eP7cSBEhmIip3P7oBLrJG+h1vgLgipmMeUP+0V
         M9QacK5AksgwkrNtQtewDCaL8GRYlMLEfsjLV1V/0av2J7Cd8KQXi0MpH2k8Qf7LIJrr
         3O49AYU6AN3jjpOMc/dbHnJ/UuW45obE2LES6DNA5A7q6tvJ69v96WSMh2Vwyxb2J+eu
         2UUG7mJ9x5rM5Tq/5K4YO4+B9cOI86whdebY7no8M5lUPJz1mvAE0DRlkmKQutfViEuc
         5Ngdt6aIJx2m0qZPepCPV+n1Il5alkzZxC7oAHe6IAdnmIITLNXMaNQcOS/661q1WYqg
         WJ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765439152; x=1766043952;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X5PFu97mrs/j5hiZkT9fpEkRD8VCD4PVmKLSzKLxEz0=;
        b=NRPx7qJCGRqPb7fdr896tCoS7lStLnhmniC21v0JrfYQr/R1ec2SXKnRk7MOcxYp1l
         u062ekWyE/CBtVeiCvgYtp5T1JQgqpc7+oXhv4qmQEMWKjgjkBBUAM7pKmDdJb/l0PW+
         xgP3Z6+amw+DotFhqwKLKUPYunJb8sIqbeFpP5PBjlXYY1+bYw6QdHD1Vm1VchETcBgO
         oOZqGCuy1zmF1n9y92ZG9GBNC9ez9YFSIPNMdqx00NDCz9rR+y2tMVviIP1YpsZLKHHY
         qOCLZpkg0bTNxQs+TwLUhEmgw8FJu+4Gk86EEtGWTgcLGHEIfqpJrtCwOUFCr3IZyYWp
         Tj4w==
X-Forwarded-Encrypted: i=1; AJvYcCVieggsDrHMAt03IEWw3soNpP7zb7WPYZk555D/lT404dcfe1C6C0VVm/LYpU6vyGUS4l8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx9ZxxyhB3wZm2AsVG7R3q98Pj3TL6dIKeroKyGJj5vB0XdLi/
	RyyVyu81nEGYsZw+FQsKC148KSF2y9R+rDRdIXIaX2PsN+q30OrQA2NTJ6IBuvbh9Jo=
X-Gm-Gg: AY/fxX5pplmrO8b9DnhATeqA1d470rwv5Q+8tS6VWiL6XI1tVPjU7soM+C8YMIp1GO5
	a+TO/D5oL3cmSeG8RtqU9Sk/gmH24CzsrixSQnTkhDH1+ev5RDA1H9qJ3MmNfEK2+YCsOXuddhR
	bjIeyzqqjbCBW8zHUqCl54UKvGRZ8Cv5dQtYtk6Y8yATJU1VsuEKnBLpyUsAJosYyvuCDA6KmuK
	blCvFS1OqfipI7asAHOs0qvemN0LL2UdF2vwwTsOyog/KnrxH0KSiwQZsaRQkyKvqe+jrKa7G73
	B0Tiy2VU+LhJrAnpuTotNgiiNUTvOZBsqQSqXQXYr3c6ByPRxsJ4xnIWSTCbBxOFjR/K3bEBuA+
	4NY37Y5c9yP99VmTFieAwzbGCZCAYpw6t9OP3rhwxDM9RL4kA7oQYyMM6/ueGIKSmF5OtT2Ki+Q
	b0b60VZzoI3oXU4i5H
X-Google-Smtp-Source: AGHT+IF7TmgbE+Uw5kfOPicBWaMZFFELImJD78GoXEDw+MdgM7iNhig2tJYwraCIhaxT+6NDNvyhbA==
X-Received: by 2002:a05:600c:630e:b0:477:ae31:1311 with SMTP id 5b1f17b1804b1-47a8375a1f6mr46323505e9.13.1765439151697;
        Wed, 10 Dec 2025 23:45:51 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a89f8c145sm19182315e9.14.2025.12.10.23.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 23:45:51 -0800 (PST)
Date: Thu, 11 Dec 2025 10:45:47 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] vsock/virtio: Fix error code in
 virtio_transport_recv_listen()
Message-ID: <aTp2q-K4xNwiDQSW@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

Return a negative error code if the transport doesn't match.  Don't
return success.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
From static analysis.  Not tested.

 net/vmw_vsock/virtio_transport_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index dcc8a1d5851e..77fbc6c541bf 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1550,7 +1550,7 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 		release_sock(child);
 		virtio_transport_reset_no_sock(t, skb);
 		sock_put(child);
-		return ret;
+		return ret ?: -EINVAL;
 	}
 
 	if (virtio_transport_space_update(child, skb))
-- 
2.51.0


