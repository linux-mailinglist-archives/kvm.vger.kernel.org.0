Return-Path: <kvm+bounces-66842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AD21ACE9828
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 12:11:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 78CDB301A713
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 11:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1D22FFF9B;
	Tue, 30 Dec 2025 10:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q9U2zEPU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZO31RtaE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0C22FFF90
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 10:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089810; cv=none; b=lAbMDe09jlHy/rUDa/DQUY12lDVq+yn9EsH63TE81MP4oPM3lnsX5A1zwtShuGRedZFOch9447dh45PHqkhn493mDdlAhZ/FtQv7nLvEg7b5JVsZc2Q0t7uaOHwtBbs2TDE1v8K+W0CQR4wPfW+GfG6X/bD258BpetfUSHqcR4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089810; c=relaxed/simple;
	bh=t25qf9RPlFFNCOYEONgor27ZqKrRgzzuNghNz/03y7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TFNbDCtYq1vKeqUikN7ZCz8xsVFyqilGF72ZPJir4RuYYl+5sXK+SM12jPdfgNXxJLeK7//577eb93e//3ZI80AqOXNko6WgvBlROP7+xl+trHuAPtmeGfv7X3cp1Brran6R1iHoqFUbRrWgJdLEgXUSXxonlRTeUTdZrbg/gUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q9U2zEPU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZO31RtaE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BWhPgbCVUCKqyPHyev/7ivEXEOB+Fryu/YrpJpGLduY=;
	b=Q9U2zEPULaDpd0Q+BpKJZ9l9z/5jLwEjJn6Co5+nq2V6LoT+u5KH6/zBGnNotw/ksCsB0v
	Cm/gvA7EkW5BMeTqDy29bDbhYLKK1Ui+KwuwVPAh0bQJXFDVe+ihQVTsktSjaRiGwU4hJz
	mZZ57GgkweUS9hsIvTLBnGZm+72sdrM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-17x3uDc7M3mnZVjRyF4zNQ-1; Tue, 30 Dec 2025 05:16:42 -0500
X-MC-Unique: 17x3uDc7M3mnZVjRyF4zNQ-1
X-Mimecast-MFC-AGG-ID: 17x3uDc7M3mnZVjRyF4zNQ_1767089801
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47d28e7960fso42340155e9.0
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 02:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089801; x=1767694601; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BWhPgbCVUCKqyPHyev/7ivEXEOB+Fryu/YrpJpGLduY=;
        b=ZO31RtaEnbRwXI0pZvzk7MmrN6X1+J8FWRvLdtMprqkQxtlxzAaySEyLAPtuUG4ahV
         BBL2Cfzvzv5yMQ5FfEgrnrR1XMrzbiiLwHNSlU/RiA6N/JiLIVcUldUMPrE4veCkQEi/
         cOypKUHHdU9cRHuejX32Es47rs1z5YqfnBSAkipXOGs7Rz3Kddf5iIA6ZDHCKVNbBKQx
         7geuz1xOqix+CC4hB7szuvVNA2MOj6Z+CJe7yq5ya9yAiGvLFRYw05DzqI56EmKxcdmv
         g6umauV3bEm1g7SkR173wyFuK1+wh9H0DJzovyUrHoBeH31nGx6KsjzZaEcf12qsp+AX
         mWzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089801; x=1767694601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BWhPgbCVUCKqyPHyev/7ivEXEOB+Fryu/YrpJpGLduY=;
        b=Ae/5NOo1olwlOW+Hj46NIoezFd/YMPdTQQ7eiFqCPYpEDr7ql1mGrWeblXe9XTs9Bp
         CWEJikCUnAwxhXhqmnwBtjBAVwXQstIf3zknMWKR2dNfBlUoBjehrGzPty60Ehvna38m
         2aAQSrQvuBmOWqLh+OgvKjxEV0zM8Pl07a/KeKBzcUFlwf6N3BGfkviqQr7r7IVk3sSK
         5HgKseT7icb2FPJcJPqfG/TrVLsG5EkPahZgLUNMqrbwkEs2DgTQlFaDSJu2eWOLbNE8
         79NATzogrwMYhYeW1ePV2m1nXJT2cnhwifYpIay+Ul4dIWboZdQKIBJQZUGfd8YHN7Du
         cU8w==
X-Forwarded-Encrypted: i=1; AJvYcCVrghFSvxF119UmGZtdbAXkMrtk1NAH+iyYbmWXjfU2W228IrBCSsOIBtznGAiDvW6ODCI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQRUDnG2cCAhLkdxXhP7/1l4cLQZfveH4q5gJMPl5geTF3Us1V
	5YorzJBIdNKs12DhMk5rg4aEE26/fa7hXhPcqyeYamUlEbn9OdS9fZTqNH2LeA0q4s+52KO1QFE
	flOJ+F/qL0PDBFVN3H1tFXmiS2A77DSUjBg0ONsEOFSE0MKEFgMxEnA==
X-Gm-Gg: AY/fxX6aMMCvd70ck+fEBKlJ15jJpKYHNn/Rz8Ue+rXeuUX1BDHlOAQPypPq/qkSF3O
	Pe554D+XnIydv9sih9UcrmTQ70d+RFASMsD6MsBCxxKg52w6LnyTdGmnHn47Gj3yv7XQVDYmjs+
	OIPIrxwGTEQs1bHjpSfyzLhCtll60AB0mDAhrenTxT7LzG7bmS/kmloriKPMQNq7uKy1lWc3cM/
	pP0tBozoojRrZQqehKT4qskBTeIqdzAHMIAbDqkwkBGKvqxMWXovMV8gP7aNiFkj2SZVvb+E9Qv
	pNazhLStodewYiMDewWx4gdmd1suSvgoZgGpIG6CdkcGoOZoNgeLfidn3Me+5e+0qAwyagdkmaQ
	VU5s7SVIcvq4mDJuUSfAij23NxA3+n4g+qQ==
X-Received: by 2002:a05:600c:a413:b0:46e:53cb:9e7f with SMTP id 5b1f17b1804b1-47d1cec8f39mr297842095e9.18.1767089801363;
        Tue, 30 Dec 2025 02:16:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEf8BCC/QkGwDEfP5RddRZimNY2rmw3JwKmzFqtMOWIF8UhfXRlD/gfjFTVaD3LdsD6J0zJDw==
X-Received: by 2002:a05:600c:a413:b0:46e:53cb:9e7f with SMTP id 5b1f17b1804b1-47d1cec8f39mr297841845e9.18.1767089800959;
        Tue, 30 Dec 2025 02:16:40 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be279c5f8sm610553745e9.9.2025.12.30.02.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:40 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:37 -0500
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
Subject: [PATCH RFC 11/13] virtio-rng: fix DMA cacheline alignment for data
 buffer
Message-ID: <b2e350ee2542c5c372b2973fb68d4fee67929d5c.1767089257.git.mst@redhat.com>
References: <cover.1767089257.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1767089257.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

Add __dma_from_device_aligned_begin annotation before the data buffer
in struct virtrng_info to ensure proper cacheline alignment on
non-cache-coherent platforms.

The data buffer is used for DMA_FROM_DEVICE via virtqueue_add_inbuf()
and is adjacent to CPU-written fields (data_avail, data_idx). Without
proper alignment, the device writing to the DMA buffer and the CPU
writing to adjacent fields could corrupt each other's data on
platforms where DMA cache maintenance is at cacheline granularity.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index dd998f4fe4f2..fb3c57bee3b1 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -11,6 +11,7 @@
 #include <linux/spinlock.h>
 #include <linux/virtio.h>
 #include <linux/virtio_rng.h>
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 
@@ -28,6 +29,7 @@ struct virtrng_info {
 	unsigned int data_avail;
 	unsigned int data_idx;
 	/* minimal size returned by rng_buffer_size() */
+	__dma_from_device_aligned_begin
 #if SMP_CACHE_BYTES < 32
 	u8 data[32];
 #else
-- 
MST


