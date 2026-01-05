Return-Path: <kvm+bounces-67025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B922CF274D
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 09:36:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D57A9300EF72
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 08:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE87332A3D7;
	Mon,  5 Jan 2026 08:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AG5sQUCG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="I5yswi6H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8D6329E67
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 08:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601424; cv=none; b=ldGOm+y4AtjLIXVCt4ehWQMW06oOGhPtsfXsr5YEq7cyGFnML0EZSKP0gPpIXOA/o4IQECkuXYN7879CAdQyPk+h4vhcoK4YvoA+3CFbjQjG4tM0xI6TZPJng8JlqrxPtz0h2cinhb7oMyUv64eK+fXF5WmBr86uYDOdam+Jf3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601424; c=relaxed/simple;
	bh=HzYnyY7SZLB21Zw4R22hNRsG3Q5nx5zt5Jv7qf1jNBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c/jhj6UkWBS8PPO6Ew+OmkpVOersRTaI+Pu6xceirs/B4nExD6fb2SKBo/sRQqlA/x/sl7V3NWxxGDN/7w164yCK5GNpfZlTup4kkNeHkjq3+H1ZM8/hzfoPYrG8yUKCelh0PViuhJ4SPV+60n9FqbfB2o8nOQijJvPyXL9zcnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AG5sQUCG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=I5yswi6H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/8txVkwqMRJjWWbc/atl6vQI7/U+u3Ckdz87v1ZTBF4=;
	b=AG5sQUCG7U5QWAr+Q46BSKAKSwAgf3KFF2ZYHdoWdSv3pwkK9HGoNnO23TLNBOBkHs+9rJ
	OQDsPzlL/G9CjYRWQnGflJ0CyuD1yz6mR9wUCiY4OxUXwaR551T0+hnW9m26yCR9PCP3hE
	79FQS+nw7tAx2MZ8+AMDdRX/qNkgYTo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-iBFF5Gy3OCi4-DQDTS8QeA-1; Mon, 05 Jan 2026 03:23:38 -0500
X-MC-Unique: iBFF5Gy3OCi4-DQDTS8QeA-1
X-Mimecast-MFC-AGG-ID: iBFF5Gy3OCi4-DQDTS8QeA_1767601417
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4792bd2c290so135924815e9.1
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 00:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601417; x=1768206217; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/8txVkwqMRJjWWbc/atl6vQI7/U+u3Ckdz87v1ZTBF4=;
        b=I5yswi6HKFYmnvSvPTgX5I5GufkEjc88XVQp3JUswvb1KOQoqFcAzdQNWr4rLb2KtD
         w6kIV8i8HddwgY5dtR/atqlL0npCMlNrnonS9ZdFWUmUsJNnipDt3dUq/RehUuzNtFKZ
         x5OW/C5dHDyI9O+FOhKrbHes3aKeeS7QkT69Z91lgPSyaHBGhFQGkpBw1W8/eSTGQ1Mg
         EDojgVrRxwjobAMfRWdQbWUyMx2jYCWo61MzPIA7KgyJT6RQuzNJiNMJln+XK11k36rs
         Qq9gn0iPDciYwO3esIO4tkuPZUbpAQyEqyFijEJ8x3C885jkQqOn0Q6CcbSXPpAJ9nhT
         X19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601417; x=1768206217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/8txVkwqMRJjWWbc/atl6vQI7/U+u3Ckdz87v1ZTBF4=;
        b=JPQwkAThkVMe8WxVgBK23QfQytUroxdKVE4/jUfO4R7ZgDWYs+o25N0uHgWwQ+9v0c
         5icEMKLvlC7MSaryI1A7Y8Okw3l3rrfJJ5EuUuVP1tVEf1NquFV/Pl/JdgYtltHM8OWZ
         l+39TucQ+3gqCag41J8CD5c1bzEJPVdSKu2dc8ub+b07hldEF3LMn5eZjdC2f3RXwDFk
         lAdbP1ZUXgVAMujTBlbVdjLQdtNIh+se3z0WtvZHoeIYZoPuIep15virYq+Lsr39fkhO
         amkjras+1vSy8YLNFGEqiuIJyHAAR26FIStJZA8GV6tNse2w/io7CKe6hxHt5FuERNo0
         sTQg==
X-Forwarded-Encrypted: i=1; AJvYcCVeQn5ttOUJ1wfn5Cyg9G5LhRVbIMOn58voSOcpZsYVsABnJTkz6yZIoYgjUCjGqpS80cc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx23LwIsVg/VNc9EqiEXS2yXInlUQR9PxxUQOrEJv+PGGFKjuaq
	GEBhcbwDIR1aqNFWcWK3lLZG5/BFcVM/4K9Xe1suSqlpLAyvU1kOzXQ6tWB4eEOeofU449eejft
	+CUxQncr3BbBqbPDJWcGRnyTFl77ZGQVsoZtd7Drp5XmQCUNvtVw1CQ==
X-Gm-Gg: AY/fxX6hfL71gUjjEHqNGzppEA0d1mpBTlMUo357RkStb9f8Sy2dgVADmx5ZI48GErF
	QhEz0IrEhTN7G7FDR+ENwbs8g51+fjESWhtSaL8zwCgn6xjMayZHPHTVHPWxPu3tLwsblGohRzX
	AVyLt+6jj1fc0j/sIc916By6ANwU8Q+bKBAZ7l5o50jpLVCSOnh3QAWDabv7LsC8Hjaumrblo8E
	74E0IcJM0PjJCLLFGivYeaW0cag9vIP9FW9VZrYfz+vrYwlBzsKEaxulpV6dTO9qn0wU1FNRMfS
	YHj9LNF48SuB23fg/O56auiJduPI95SZ94r72xaCLgOgFCFIjJA7uYtvs9SToLRs222YDHQ0yIV
	vgTrLl1NyocpruUrYPOC66JSMKDi+zTdQ/w==
X-Received: by 2002:a05:600c:858e:b0:46f:c55a:5a8d with SMTP id 5b1f17b1804b1-47d1c629902mr472043355e9.4.1767601417344;
        Mon, 05 Jan 2026 00:23:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHVSX2iBXTT4S7tXy0ZYHsUHRdZMVGE7PsYbGyf8OKqSDfiJqG7TGaTn+6DDGk03BIi3LI2pg==
X-Received: by 2002:a05:600c:858e:b0:46f:c55a:5a8d with SMTP id 5b1f17b1804b1-47d1c629902mr472043065e9.4.1767601416846;
        Mon, 05 Jan 2026 00:23:36 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6be6b202sm54210025e9.6.2026.01.05.00.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:36 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:33 -0500
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
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org,
	linux-crypto@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 11/15] virtio-rng: fix DMA alignment for data buffer
Message-ID: <157a63b6324d1f1307ddd4faa3b62a8b90a79423.1767601130.git.mst@redhat.com>
References: <cover.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767601130.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

The data buffer in struct virtrng_info is used for DMA_FROM_DEVICE via
virtqueue_add_inbuf() and shares cachelines with the adjacent
CPU-written fields (data_avail, data_idx).

The device writing to the DMA buffer and the CPU writing to adjacent
fields could corrupt each other's data on non-cache-coherent platforms.

Add __dma_from_device_group_begin()/end() annotations to place these
in distinct cache lines.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index dd998f4fe4f2..eb80a031c7be 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -11,6 +11,7 @@
 #include <linux/spinlock.h>
 #include <linux/virtio.h>
 #include <linux/virtio_rng.h>
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
@@ -28,11 +29,13 @@ struct virtrng_info {
 	unsigned int data_avail;
 	unsigned int data_idx;
 	/* minimal size returned by rng_buffer_size() */
+	__dma_from_device_group_begin();
 #if SMP_CACHE_BYTES < 32
 	u8 data[32];
 #else
 	u8 data[SMP_CACHE_BYTES];
 #endif
+	__dma_from_device_group_end();
 };
 
 static void random_recv_done(struct virtqueue *vq)
-- 
MST


