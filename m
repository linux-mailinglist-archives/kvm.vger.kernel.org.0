Return-Path: <kvm+bounces-66836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CF429CE9689
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 11:33:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C3C2C315C401
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 10:28:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 808DD2EC571;
	Tue, 30 Dec 2025 10:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GG1e92xf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VPE/dp7E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A215C2E6CAB
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 10:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089784; cv=none; b=oJ4OCb95QUlkIHLU9cxVVKx2FWzzMRMVfKEmVuHvsWvNSzS3i2L/OM3VsD+NyqupHFTlGyfMn4YA+kAqsA2fJr3XxPlKU81bCerIKb/zwpR9lCyI5MC2d41VOiSCwPHljfedS/RDC9BkTBSvl41IpA5t4l8N56hxNB7sp8jnlic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089784; c=relaxed/simple;
	bh=RzxSFhz+bpkLtGdr/5qvrDQOf7DHug0oDxHEj4NfN04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQAW/G0DHo7l0dopvoP4P+BJ9CexxB7amhkB/Ny/H3PPYlYJGOxrYYVf+aiNeOypIwlieLhI1sUUNcJEyLtsR+ZoT6qtOimE+LYDfuQR0uvC6PjUOyn84NXZN7w4No3yiW9aYZbfl6pSefVitgm12DOAJw6DO064wODnaoHl0Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GG1e92xf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VPE/dp7E; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qjCbMizY1BaJF5yBWOLXV7DyUl9vbunxYIEFqfWmhYA=;
	b=GG1e92xfXwhdCfXUvWy8J123z+Vg7kCtHuNr/m3hKaNvn9RGC4OKv0ohda0Zxj4wQREy1p
	xe3xJ6sid7rHsX0+C6Pm/J5LoNli5rVoinLSSXriVcYFI7GrbodDENgbELVi+Zy+NJcMRI
	0sNj8PIu0WwXd5jsawV79NcWpsa05Kg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-UWA0MnwqPmyzcm8EgfLCbQ-1; Tue, 30 Dec 2025 05:16:19 -0500
X-MC-Unique: UWA0MnwqPmyzcm8EgfLCbQ-1
X-Mimecast-MFC-AGG-ID: UWA0MnwqPmyzcm8EgfLCbQ_1767089779
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-477964c22e0so70032845e9.0
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 02:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089779; x=1767694579; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qjCbMizY1BaJF5yBWOLXV7DyUl9vbunxYIEFqfWmhYA=;
        b=VPE/dp7EiLdV7Zd4+7q0LB6HkY0Dm7ay5Zf2PQw9wOoG4M70mB4zef1xVoJ8OcF5di
         9DycO/ppjRTvKJ2s4Rxl7DlzcmVynApx9nEE9Vb0yDrHpQzGTmSZlVMXTOxwgAXYqhEA
         LpIUzXeekbRKdVrnA3gLm9iAWUwcDHZyJ592nL3IWXrrlToH0Uswqa2WQ+KB5zhyGXnd
         dVQsn7dSSdnPovLKxAjIkxFXsbhSvzQHhF1/arVybtPswx/xuHSLxxiYjd9kYrEBHHVK
         M2gSZSdf5wENx4VPi3wyMOh8S4LovIHB5Lw8kvlo6EEjCh2/YwZo1jYnhS/Dkesg+noP
         80xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089779; x=1767694579;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qjCbMizY1BaJF5yBWOLXV7DyUl9vbunxYIEFqfWmhYA=;
        b=pXDCSuFWIWwNcptdQ1iL/KXDjSif4o0pV1zluBB6E1Vyqv3SE/NNs2AOFkcjtu9vBZ
         C3oe0GE1lDqc3PxEWy4qx5/xoLjHw8CZ+2e3SjxpxCsnxBVIe+g15LpEJPMKYa3OaPC2
         fGJmepzrmic461nZWLdgE4FPlgGW8HuhcSG7z31/K8opmaW+D7E3lId26c9MPRmWNcIc
         UsvsRZF/E+J4320rtOamSQzgnNm93BeXg+OjFz29l/dV/DfISBDhTtEZ8mFJhAfM5zMd
         9cxNXbGDxUgqTvCw50MxMJW5gtDTUwrIntILrOSQoYRmKqeHvqYWq9MhLhn8UZrYJJ5M
         akcA==
X-Forwarded-Encrypted: i=1; AJvYcCVrMqGerPrxn2k5cs3oiW1LuM3YVXEvbepRquV1q2EvD18tKr9T9RxJXMC6o00npW2MJGk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzllxgjsT2qwhog6rOhAx+DmM/TqSmpX+PHXdFaV/NkUR2BaM/w
	QkCHxlVygtgN5Hg6CuetI8w5+i7C9aa8VH6LVe2VQJlmW0agF35yGXooOwrzSxCS6P3ElJ6rpJG
	F7leLk4LduNSSggZH2fThLmBQDw+eOtZyALJ4e9mHVvI9xia3z1g/ag==
X-Gm-Gg: AY/fxX5ViXTfTWWUVB6aNPMJeaJXFJn0SOEg5fSaAoZZgOVVyaSr/44QqkXU4f190ab
	/TMJbg196a1/cGUxHoW0Y8NtquIaXrnYI/sm1SynLPcSuF/B0BWk/nh3LOp+lrmkNjpMBoh4amr
	WjyxfrYjzTjGBSHfDbD5g2P2zyfBd2kFgtHhqSbtPyIF0+Kvs9Hezro3uOzdnpohUMSS3kmlt8x
	Weu7+4BU6boI91/Yb27Ci5Z2Js8FNTyD9lUVVJeippybMai2sUohWJ5USNPDIfNpj0tDUvrzz0X
	x+EsOxaNHqcUmdUhWBFZ2mp2TbL9R+v4DE1RvlJpB0+xWDAzDUYzyAOwfU9kRg+OZVV/eqzhfPK
	hhQ0Z4FejuR9Xdo3ULFT4Z2uPYD7DWQ8QoA==
X-Received: by 2002:a05:600c:c04b:10b0:47d:333d:99c with SMTP id 5b1f17b1804b1-47d333d09b9mr218755095e9.18.1767089778560;
        Tue, 30 Dec 2025 02:16:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFT+g6nqLgyQkQdYiav+FpD+RF51wbupLPftlD1j+tQDbY3ul4LGHX6uIhkOPdx1xlKUXo8aA==
X-Received: by 2002:a05:600c:c04b:10b0:47d:333d:99c with SMTP id 5b1f17b1804b1-47d333d09b9mr218754935e9.18.1767089778175;
        Tue, 30 Dec 2025 02:16:18 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be3aea77bsm247750305e9.17.2025.12.30.02.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:17 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:14 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Petr Tesarik <ptesarik@suse.com>,
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH RFC 09/13] virtio_input: fix DMA alignment for evts
Message-ID: <5f57d7dc13920517b3ed3e56d815ad1ba4cf36ce.1767089672.git.mst@redhat.com>
References: <cover.1767089672.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767089672.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

On non-cache-coherent platforms, when a structure contains a buffer
used for DMA alongside fields that the CPU writes to, cacheline sharing
can cause data corruption.

The evts array is used for DMA_FROM_DEVICE operations via
virtqueue_add_inbuf(). The adjacent lock and ready fields are written
by the CPU during normal operation. If these share cachelines with evts,
CPU writes can corrupt DMA data.

Add __dma_from_device_aligned_begin/end annotations to ensure evts is
isolated in its own cachelines.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
index d0728285b6ce..774494754a99 100644
--- a/drivers/virtio/virtio_input.c
+++ b/drivers/virtio/virtio_input.c
@@ -4,6 +4,7 @@
 #include <linux/virtio_config.h>
 #include <linux/input.h>
 #include <linux/slab.h>
+#include <linux/dma-mapping.h>
 
 #include <uapi/linux/virtio_ids.h>
 #include <uapi/linux/virtio_input.h>
@@ -16,7 +17,9 @@ struct virtio_input {
 	char                       serial[64];
 	char                       phys[64];
 	struct virtqueue           *evt, *sts;
+	__dma_from_device_aligned_begin
 	struct virtio_input_event  evts[64];
+	__dma_from_device_aligned_end
 	spinlock_t                 lock;
 	bool                       ready;
 };
-- 
MST


