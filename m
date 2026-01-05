Return-Path: <kvm+bounces-67026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DBD53CF27EC
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 09:43:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2BDA7304DB4E
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 08:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74F77329C69;
	Mon,  5 Jan 2026 08:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IJLOHygn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gzj8+3r1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6588232AAA0
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 08:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601427; cv=none; b=CvCtAoBmvqVMpftsLryw2MqsDOPWIAqlUrJyB7FCKMLM20sWC/XZJX7R8+qWCC0dbCOClxrC6QfuzoodeoLJPPhBMKA4oQSnYuhlc3VwGFF1ny1pKQir/SyBVeUJEiVdTQ5jzA9pnGui9VsFWKirazI41FTlvZwfoCPHnTqtD5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601427; c=relaxed/simple;
	bh=aG8SdrVHEUE18T+idL+tMCWXHe6vRndhmeQnti1MW2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q/ndXp6F0WufWTZM/iLyq2EezFN1U9w0yNVbAcod2IAtHvidoh7x50cb4+VUfhfoKWdJi4y8mSAcuW9GkR9UBTncYahDKvHhT5ntech1ApS5horx/Eyb+3RlTMJIr2cBtL5r+IFS2vM+NNLJZ2Umm/ehqdy30vJk4SIelpKNYmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IJLOHygn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gzj8+3r1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1WdygBrbpusefWmIaX+oAwz9bur1qkKHYd3aQzYNeN8=;
	b=IJLOHygn0jycrG+u+R2SxrrlpafXVcHrKb1JC2w8pPPPiq6z9M882Fus/umMrY5tKWf8A1
	c2c/0v7xocDq4o1d18R8L1W5IfUg5RCtcAsMWVq+xvCOQt5sSKnsHDvb9CJHHDCd0fqQtQ
	BPrSf5x8Yxr5NCkUB6i1nKgtt63QsTw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655--RRkcb7UMR-LN8dm33Fj6Q-1; Mon, 05 Jan 2026 03:23:43 -0500
X-MC-Unique: -RRkcb7UMR-LN8dm33Fj6Q-1
X-Mimecast-MFC-AGG-ID: -RRkcb7UMR-LN8dm33Fj6Q_1767601422
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477c49f273fso171311035e9.3
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 00:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601422; x=1768206222; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1WdygBrbpusefWmIaX+oAwz9bur1qkKHYd3aQzYNeN8=;
        b=gzj8+3r1o0cFHAQ7sZymVhJnTPnFxaw9A9PWo+1eUB+fITz0zBpkk7Gog1DH+Y5gTx
         C5oBNRPdIZE6l4XYxGBRtlc9ZkpeI1LFo0IuvtxLUbghkGjxP7rh+gg7pcgkbgvdp6h2
         F1omXaiTwUHKELEBL9PrWIMeYMvvswWmgiDBinTJUcViDLn5p8G7pkcphVbcHSjicmpL
         8U6UBQ2N24AVW3VZvP77apOaWZz5K4ARD/MprGTaZBEjiGGAAzXYZxj36rtIdBNj2qvV
         PutMvcbT5WoxEBVZJ8j2GRbCeunwhkr/Ywqk1TQpyBvwJZ9wIqfvJbKxsce0170fP9b7
         XIvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601422; x=1768206222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1WdygBrbpusefWmIaX+oAwz9bur1qkKHYd3aQzYNeN8=;
        b=kOmrdyZmizzLxgA5St2BP/woSiRJ09j6BbbAxidRmrt9vSv2DTk/OAf0f1xn/dMxuv
         u+BLY6PVSKuI796TjUPu1Y4EplOc4FH/DulKkUN/+Z6+ue0pJ+yb5JgpcXIFg+B1mA5W
         CNfj9OABrIxySgaje0Tnx4ggQ8F5JHQyWFVYFXrOHud5AbXuHPvTr7VcFe4USyPjxTg1
         MI8A4jjXcbmq4QdIB9gbQIduNP4eJLXsYQw7b+eSM2COoILYRU3zSpXPh7vdlcXVvhSr
         ihFnBomU1CpZCfAPuvEm6Xglhmj7Z5dxcc1QcLbv0gCCZuGlSSxaySj5/vPjh4+kWIxx
         cXVA==
X-Forwarded-Encrypted: i=1; AJvYcCVzXDippH+DiKJq+ZxXyEzH9xBhHhL+lG1X1wKcyhO4VXLk615WK9cE2uxoiLYkPlRc+Hc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwkGs2u8PZ+qF2A8vctEdhUXIn68ecijlIOBvemJeq4p2VI90g
	NGKsVLzphrFQtBMTGwB9aeyzpuNInhJLIUrcIBqDzmFuDF1bxW1L7B5hqQTCRARahZfcVTiUMft
	S9DsNPeKOUAuqRIP8TTH8v6xSJT4lrssjVTbUK3u+8iWH4V5jsWAMkQ==
X-Gm-Gg: AY/fxX6OVZZmzFD2gM0WrWqLTuIeHX6qiJPfeapT5Ma+zm3P6nm3tVon4dJOH6By0lz
	UW4tehpIMOXiiRYidG6S/RAKiOC2DuWdifuiDjev5NyyJ8Uo0Tv50kXXaDcTDjmoqWBVd+F4HWo
	VF12jMmZaab2zMuGNwvNHPj2gEaLmTwH4fwLDP8v9ABZgGY0wyE8wWktwGDDsq3IuykUX6ON1lb
	1Y0uJYislZI+CMq5fqFwBcDTU4JQGd1Fw/qD6lnPJxSKC5P2Z4t5cTZXvk6A8MOe+/mFrk7hZ6L
	F1vtGW0PF0R2RQMj9W4mJo3B/iDcI483Ng7+xhey/Dda4hviSU+68m3nBDClY6fFtEed+pF/KdP
	jUAO2CYqTvopWl1k5krXWuv2/sW80F3q49g==
X-Received: by 2002:a05:600c:1e1c:b0:47d:4047:f377 with SMTP id 5b1f17b1804b1-47d4047f3e5mr400615125e9.36.1767601421771;
        Mon, 05 Jan 2026 00:23:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG0AgOv9S8mcPvJ16vNEXPXT2v+oy4k5XMxl4opf9hSfJCRKVIgJxqAgfJFXStW11yISqh4Rw==
X-Received: by 2002:a05:600c:1e1c:b0:47d:4047:f377 with SMTP id 5b1f17b1804b1-47d4047f3e5mr400614705e9.36.1767601421303;
        Mon, 05 Jan 2026 00:23:41 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6d33eefesm137323605e9.12.2026.01.05.00.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:40 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:37 -0500
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
Subject: [PATCH v2 12/15] virtio_input: use virtqueue_add_inbuf_cache_clean
 for events
Message-ID: <4c885b4046323f68cf5cadc7fbfb00216b11dd20.1767601130.git.mst@redhat.com>
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

The evts array contains 64 small (8-byte) input events that share
cachelines with each other. When CONFIG_DMA_API_DEBUG is enabled,
this can trigger warnings about overlapping DMA mappings within
the same cacheline.

Previous patch isolated the array in its own cachelines,
so the warnings are now spurious.

Use virtqueue_add_inbuf_cache_clean() to indicate that the CPU does not
write into these cache lines, suppressing these warnings.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
index 9f13de1f1d77..74df16677da8 100644
--- a/drivers/virtio/virtio_input.c
+++ b/drivers/virtio/virtio_input.c
@@ -30,7 +30,7 @@ static void virtinput_queue_evtbuf(struct virtio_input *vi,
 	struct scatterlist sg[1];
 
 	sg_init_one(sg, evtbuf, sizeof(*evtbuf));
-	virtqueue_add_inbuf(vi->evt, sg, 1, evtbuf, GFP_ATOMIC);
+	virtqueue_add_inbuf_cache_clean(vi->evt, sg, 1, evtbuf, GFP_ATOMIC);
 }
 
 static void virtinput_recv_events(struct virtqueue *vq)
-- 
MST


