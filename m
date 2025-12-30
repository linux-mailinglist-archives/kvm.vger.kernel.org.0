Return-Path: <kvm+bounces-66851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D79CEA33C
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 17:42:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 686BB30590FC
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 16:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC5C26F46E;
	Tue, 30 Dec 2025 16:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JT3kvi7X";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QcCA+7eU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34368322B94
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 16:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767112844; cv=none; b=f7YiXxAthSdTA4Tl5bqUUVJ3vP7jqjmR9Jrf+e5OL0ywE28ALrxej/o1Q2iANTaTenlyOShOG7qCxEGPgZsFyrecJNzwDUJ4cCU0qH8ttSdKYn5W26LaHfv2FxvRw72pNpKXTSdhGoMi6ps+FFqITYVkrB5TRfQZ32JsvbFq27I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767112844; c=relaxed/simple;
	bh=rJvyv/DkZDnTdlk5mMz+iorYKgEElNGmDI1t8E4mVas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kmy7wYMQ7cc+/AgC2Pt3HOcp7pElB784ZI8zYUBd+3rFjlZ9lwqgjfVp4xM6d0EfiXnAKRbN2t0L3HMnbHunhMFy+vVIQR6114v2YFlSDyZTsLYnNOYKbDMTqBqkGuHbf5bX+tadqXVnBev4KHdP8s6gQ23b8cUoqCZSon73pzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JT3kvi7X; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QcCA+7eU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767112841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RGewFge/6sMWyfD/6+VNEsuf36DWmJ0Q3xqEbJz+f7M=;
	b=JT3kvi7Xp5JMP+LYzFax3+gjNQwR1qjWoiC7zUSD6SfvXAMQ8kz6vUjc+NBl9cK2HIh/BQ
	YtoXSARPFFylvfwmgJLoNmywKShSwNh66EXjMVQ4otkvqCM6g6hk20CZTfVw3DZsrjVulK
	YalLquJTlcVKcZpuwNaIBnxNg8IXPg0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-1ctKAalwPpSB4A4Cn31ByA-1; Tue, 30 Dec 2025 11:40:38 -0500
X-MC-Unique: 1ctKAalwPpSB4A4Cn31ByA-1
X-Mimecast-MFC-AGG-ID: 1ctKAalwPpSB4A4Cn31ByA_1767112837
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-430fe16b481so5269874f8f.3
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 08:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767112837; x=1767717637; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RGewFge/6sMWyfD/6+VNEsuf36DWmJ0Q3xqEbJz+f7M=;
        b=QcCA+7eUvHQSy2dgFoIzSSIP++kP8Av+SYabpYIOYZ7166/HrUbm8Wno+lYddS7XTp
         pu4owh2Z3XIEfihGTtHc0VouJz2I4u6P2oJK77qlOPqpIXGrJuKYJq45XfPN6ZT2q6KF
         7CpCcVP1lwHuwAdPm+yWlId1+YfXzkTXN+2e96HhbGEh8HNerWSrWqwLJAQ8lDLbCZ8I
         i7/KnnYBnZO/cxr1ICKKJvD1hjBvU1YnimyFfTST5YTCCJwLe7fBZrfij1ORvxy5Q3Tx
         srQFSAFtQaumOEHLJiA3iZKM9yr3kTeeG2hdS3jXfIqmNnmCszDLRXgTTDAidcDg4R6o
         yHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767112837; x=1767717637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RGewFge/6sMWyfD/6+VNEsuf36DWmJ0Q3xqEbJz+f7M=;
        b=xN+eG8DNXkvaa3TQRxNj/1s1rbrgmxkOWnz7WlsxCymOxXejPD62wnGHwmDhr4j880
         uziFXh67Cjehg/P03tu4aMqszdfz920IHq55nLiqLEuPEygnd7DFl4TDPa8Vb6+B9pBJ
         Y4krIMxHqqhi/qHJsQj+8NpLoobrvNFrgrTfhIByOy/rNiSeQnMOagOVT1tl+xeVKKUR
         GhDZunMzJq+6kXAHGAH8diqNAJIqhidbFyKATYjdq+pW5MjhrbaDjbL6BqzpAAKd5jG5
         rvxnmIpkD60cxkLpxO+68wajo+wZQoq9XO95aDrJ4IBonVIyhOqIjmfew6P0ATx6ocmO
         koEw==
X-Forwarded-Encrypted: i=1; AJvYcCWr27JJ0qC3KHQ3bPvnVRr4jdIpZzjPUUX/2I0aHOTUj0IfUvErSX0t2zPO2rcS6Tqoa9E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzQi12yF4qh3pDoqaN+hzjKmKPfUE09CgK/su0c/gYNG9C7OtI
	dJEKG8vkg754m+NPfmW7o6l52cOt/LX9fZD+uiR96FcrVNZAlSJiwvocvivOsT3xViSrB3Jm3EE
	favG3YMyKpXjgLfV1+gkZDv96sOx+qsVsJk0wuzPxw80VtYv8vcnKsQ==
X-Gm-Gg: AY/fxX67s4HOF/FuF7T7HN8V9kbb2QD3tupx7mW5lEZCu1YCeVnRPSyR2Gy/XO8mM0J
	ELkNRi2DatOZVUT2Dx8VFoTEaTpNFA3dPPCvUCmYtuG3d+Kb0Z52MyuHrd9avj8eKS22yOpCFsi
	5uaw0RKCHXj2Sr1Gr8kGcRKOoJOQumaeh5NAycHEjcOtN6I7p378LaasUdCpPCp2MUQaOxIrd1O
	Dd5nQ6eSpjpjTvYCxLzmzbRquZtxJYBK6GFaVAXxTTo+bG2UQwygB7OR8uagS8vjmDyZ8S0tnbd
	whPU35B8eCBcqVdQzFHx9ShIWM7NYVfwRwmXVpn4aib2qoHkkzkYEz2QHxbXMMJXjCz6NBuwwXD
	bSbnVY+p/nN0od6nDDb8fGkFZjE4N2VEjRQ==
X-Received: by 2002:a05:6000:1865:b0:42f:b9f6:f118 with SMTP id ffacd0b85a97d-4324e4cc03bmr47308972f8f.15.1767112837158;
        Tue, 30 Dec 2025 08:40:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHJgojb32FwsKVmHhWZwfLhjoCLU41JBrW58xQS8ik2FTwcPC3e2aYiOOV4nGFH+isXC/64yA==
X-Received: by 2002:a05:6000:1865:b0:42f:b9f6:f118 with SMTP id ffacd0b85a97d-4324e4cc03bmr47308928f8f.15.1767112836647;
        Tue, 30 Dec 2025 08:40:36 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea1af2bsm69151255f8f.1.2025.12.30.08.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 08:40:36 -0800 (PST)
Date: Tue, 30 Dec 2025 11:40:33 -0500
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
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org,
	"Enrico Weigelt, metux IT consult" <info@metux.net>,
	Viresh Kumar <vireshk@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH RFC 15/13] gpio: virtio: reorder fields to reduce struct
 padding
Message-ID: <55e9351282f530e2302e11497c6339c4a2e74471.1767112757.git.mst@redhat.com>
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

Reorder struct virtio_gpio_line fields to place the DMA buffers (req/res)
last. This eliminates the need for __dma_from_device_aligned_end padding
after the DMA buffer, since struct tail padding naturally protects it,
making the struct a bit smaller.

Size reduction estimation when ARCH_DMA_MINALIGN=128:
- request is 8 bytes
- response is 2 bytes
- removing _end saves up to 128-6=122 bytes padding to align rxlen field

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/gpio/gpio-virtio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-virtio.c b/drivers/gpio/gpio-virtio.c
index 32b578b46df8..8b30a94e4625 100644
--- a/drivers/gpio/gpio-virtio.c
+++ b/drivers/gpio/gpio-virtio.c
@@ -26,12 +26,11 @@ struct virtio_gpio_line {
 	struct mutex lock; /* Protects line operation */
 	struct completion completion;
 
+	unsigned int rxlen;
+
 	__dma_from_device_aligned_begin
 	struct virtio_gpio_request req;
 	struct virtio_gpio_response res;
-
-	__dma_from_device_aligned_end
-	unsigned int rxlen;
 };
 
 struct vgpio_irq_line {
-- 
MST


