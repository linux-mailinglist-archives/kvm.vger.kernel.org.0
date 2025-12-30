Return-Path: <kvm+bounces-66850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DFEA9CEA327
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 17:41:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 80DBE3041A44
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 16:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E09A932143E;
	Tue, 30 Dec 2025 16:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FBO92N53";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="uABu4fGe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48126322A24
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 16:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767112839; cv=none; b=JjyPt5efMdm3AcLS/RvpJjOL58z24SJKW4XobVlt6tk8be7Xat3+x0S81nh8kOdeFI7JnHTdcvqeIF+jZWm7JSNqADRZBblUwH7C8CJlotMVJkLc3IHigyJ9NAeZISSzp2mBnFItOdnUzKIgD4XUIngxvYbINJh6yODzIZgfF8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767112839; c=relaxed/simple;
	bh=R3ssxNR/IfKvvzigNkiBKuIwzZmdFCE30Vek2VE5a/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IMBE9Wexaz9DEiH9YdrB+vmLT1Ex+H0lVkfR8/V65Hp0Wk6HlBeGK2BNyRGlZdhYzuoCuw+igQFwa/e1ASQvxs6mzj5bfFMYf7+6SgU9nEP2cuACmTmvagUhXWT9xmZJzvnzc5+7uZeqqOjX1onF59UgazB4vCglVkJPrIZtb+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FBO92N53; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=uABu4fGe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767112837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7J8z1fD7DSMGZ6iKBx0OqXIx7XfW+ZYePKweShXuH2A=;
	b=FBO92N53VqhhEsAoKDp0hCn3spCXwgIQWtQW6ZRto3gf+xD0J+wmbu1IpLvIwIp0GMwU+0
	CtjXhCac8SHkjJEYXal6cyXWxLH/a1X0bfkHekniDDqPcL0QsWkA8UChItDxFYvQ/hmkeL
	b1mRkM3cB5QLhwZZxgMct+X4+BY9OAk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-A1y5fEWZPuyrOTL-VyrjYA-1; Tue, 30 Dec 2025 11:40:36 -0500
X-MC-Unique: A1y5fEWZPuyrOTL-VyrjYA-1
X-Mimecast-MFC-AGG-ID: A1y5fEWZPuyrOTL-VyrjYA_1767112835
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-430fcf10287so7069994f8f.0
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 08:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767112835; x=1767717635; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7J8z1fD7DSMGZ6iKBx0OqXIx7XfW+ZYePKweShXuH2A=;
        b=uABu4fGe8cVshyqW/Xxe1KBX1O0iU6XSe0yXlrZPOXRqQ4BLwEZ0YTv1f//a3j9dZ/
         lnBZb4nybn1gAjN01yzasjMxPFVpIQcpXpXB8rZGQo1FVZAcjdI7JKG9fcSaBAf4Tpy6
         dG1MuGwf9iywKef9ecy1EGFv/Zhb9t9pR53slxH34em1hfpApminHfhyTx9fpA9Zne+2
         RmENuefG6jOJ+oKQ4rd0kvF1PkpokgciRI2rVBgaVP02ttj5PpX7lGKgP/i4K4L5gG9i
         1AOVnfElb/IvEfZP0g3T3MtBdpiWjbAjaWAtdhergp7YXdPAI4VR/NaUOKSEgu6bhVYn
         SP0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767112835; x=1767717635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7J8z1fD7DSMGZ6iKBx0OqXIx7XfW+ZYePKweShXuH2A=;
        b=k/KCT1OeiS6lskN1TrS/VLGW052tfGhGPNgRWpaRa5xr2r+ez+TsDTR1OJOm3NaeOh
         NrV1mZGBSvzjtPdt/8ijeB36vnoPdeQbrWBFE/YzWYFmB21adfl93E23iBTzWS2zCRTU
         dJGZxfSTPjmZENEKr4RtOXih0h/IJT2Y/hXotFSq8DaoRyrIAK8kCb374NWPDYl9em4w
         NrR+DF1e1cKXPbCo03nrFX50G3bxH/H1eLr9XpYCSr8yytRoVQ4TaR3i0NwbFSW3CCs5
         xpLKDwSRH9AKBA7iRnmgjGPpRFRQxLA3aEZzAECVdF+80jFy7eWvVNuy/dWpnBDO1VR0
         ZBdg==
X-Forwarded-Encrypted: i=1; AJvYcCUbOdSe39OvPQE8Vu+DLr4tdarxhdxdWYBd+fKeY9x+vk27vTt5RMjcg+feRQk7VjBCUS8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCMX8U51d4hr33aqfph98we90FwhZKo2tdWaI2D58GsSjEkuGe
	3M/Au4ZMeLJ+7cEilllPZJaeJV6xcC6tpGamG2/dYdck33AwHPyIvux4hieQtr/lUtK+BmAYh0e
	vBHLq+EG3yZvTzWPs1VzNkkpWqpUc66CaNz1lvd6FS2LVJeyQbfFs4Q==
X-Gm-Gg: AY/fxX7Bt0QCnMyt45mi33DvD8S7IDKdUo8rQN/dyt7gXnfKvCqVNVs7k9y6Faak6cb
	xUrkFG6BlrhcX0TKPbeYjb9uVMbPx0tiPsfLW0Yrr1qiBCIcYjH4BDYxg9XGATFaxdyfvYFO0WX
	rUWeXpUO6KH+eiIhSN+wfv2rQL0+CjrIjq9ML77pKk50gKnFTWirF9Wm/ClQBhPodsDH0KBubdj
	1eM+z2hQSKSPAWljKsuqZqhE8Rivr4O1ZXbuadnNExfinJAODtdms7AeNDiwpzgsHulpHWUZFzD
	SMyeHko7Um8E8vo8uBvahSYH3dAQqvk9GibLQ2EHkjABzs7knozIEXu2JIc3tTfv8qu+ej0X7LR
	CMt8InTOyltzsPHKH4aeoTCYSwuLmi39j/g==
X-Received: by 2002:adf:f144:0:b0:431:855:c791 with SMTP id ffacd0b85a97d-4324e4c1501mr32588423f8f.3.1767112833330;
        Tue, 30 Dec 2025 08:40:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IECVSdNBMTG9k8N96cOa931b+MOajxv263SWbXaTmkKbkTS3ub+IC9yjT+L/YMFbjvC3biqWw==
X-Received: by 2002:adf:f144:0:b0:431:855:c791 with SMTP id ffacd0b85a97d-4324e4c1501mr32588393f8f.3.1767112832791;
        Tue, 30 Dec 2025 08:40:32 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea1aef7sm69573295f8f.7.2025.12.30.08.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 08:40:32 -0800 (PST)
Date: Tue, 30 Dec 2025 11:40:28 -0500
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
Subject: [PATCH RFC 14/13] gpio: virtio: fix DMA alignment
Message-ID: <6f2f2a7a74141fa3ad92e001ee276c01ffe9ae49.1767112757.git.mst@redhat.com>
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

The res and ires buffers in struct virtio_gpio_line and struct
vgpio_irq_line respectively are used for DMA_FROM_DEVICE via virtqueue_add_sgs().
However, within these structs, even though these elements are tagged
as ____cacheline_aligned, adjacent struct elements
can share DMA cachelines on platforms where ARCH_DMA_MINALIGN >
L1_CACHE_BYTES (e.g., arm64 with 128-byte DMA alignment but 64-byte
cache lines).

The existing ____cacheline_aligned annotation aligns to L1_CACHE_BYTES
which is now always sufficient for DMA alignment. For example,
with L1_CACHE_BYTES = 32 and ARCH_DMA_MINALIGN = 128
  - irq_lines[0].ires at offset 128
  - irq_lines[1].type at offset 192
both in same 128-byte DMA cacheline [128-256)

When the device writes to irq_lines[0].ires and the CPU concurrently
modifies one of irq_lines[1].type/disabled/masked/queued flags,
corruption can occur on non-cache-coherent platform.

Fix by using __dma_from_device_aligned_begin/end annotations on the
DMA buffers. Drop ____cacheline_aligned - it's not required to isolate
request and response, and keeping them would increase the memory cost.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/gpio/gpio-virtio.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-virtio.c b/drivers/gpio/gpio-virtio.c
index 17e040991e46..32b578b46df8 100644
--- a/drivers/gpio/gpio-virtio.c
+++ b/drivers/gpio/gpio-virtio.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/completion.h>
+#include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/gpio/driver.h>
 #include <linux/io.h>
@@ -24,8 +25,12 @@
 struct virtio_gpio_line {
 	struct mutex lock; /* Protects line operation */
 	struct completion completion;
-	struct virtio_gpio_request req ____cacheline_aligned;
-	struct virtio_gpio_response res ____cacheline_aligned;
+
+	__dma_from_device_aligned_begin
+	struct virtio_gpio_request req;
+	struct virtio_gpio_response res;
+
+	__dma_from_device_aligned_end
 	unsigned int rxlen;
 };
 
@@ -37,8 +42,9 @@ struct vgpio_irq_line {
 	bool update_pending;
 	bool queue_pending;
 
-	struct virtio_gpio_irq_request ireq ____cacheline_aligned;
-	struct virtio_gpio_irq_response ires ____cacheline_aligned;
+	__dma_from_device_aligned_begin
+	struct virtio_gpio_irq_request ireq;
+	struct virtio_gpio_irq_response ires;
 };
 
 struct virtio_gpio {
-- 
MST


