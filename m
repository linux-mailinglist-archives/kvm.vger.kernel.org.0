Return-Path: <kvm+bounces-66839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D90ECCE9620
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 11:27:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A6AE9300A96B
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 10:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46112F362D;
	Tue, 30 Dec 2025 10:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VHCTfOQv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="uKQkDwKd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DAA2E8B71
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 10:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089794; cv=none; b=ZQ0Gpfuzw6uY3apPKuY+b9XVzfGG5XzgGUdstnoPjVn8nMwPrvm5Py5/rgtHCTl/gRxef9CFfZ7GzX3LBq4TaCNjKx9tj9ZSYmnMfTfDZjmDi+xxBQ0+OgPd47gHhL2rbc3w3OEurpQSR9N/iC5N7t7Xq+Z1T2ayz6yrkHBr1mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089794; c=relaxed/simple;
	bh=8AS5gGTh0N3CZpFV6rLA6D3VYpNHgRiCO3euR1uUYwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cy3Ek1Rz5wKvDBGEvLL0FeexPRFKKu3xNE9YCZ7DQSCPbXSvyrVVOagyZluh6ud5c2aGhbzMYaC+BAFvBEmelhzn3BZtLw/KTwji3DA/ACcIb+Uf2BdSQ7rmeDy7xzOK65XHOcN7FhA8Z2z2dpSBf/EGSrU/Hmx83XonfBO/sUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VHCTfOQv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=uKQkDwKd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U6HBtTZLBj4ioaYYzWmnMsK87TR+uoHLBYHR1C0qpbA=;
	b=VHCTfOQvrJ1iXazIEf5ji9mLXER0HppwvqCYgpvqLGdM4FW6H009wO/ADV5uoQzdJoeaqa
	A5L8DzaOC754QH8uqkxfDeqfMxi5fwATk0k68nCRN2KRvb3iDAeuI0va3nmODsHg6gVub1
	YONZXmNsdlQYbO2IvWIgoIBnfpm8/xE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-JanaM3_qPwyAYKP94N3IVQ-1; Tue, 30 Dec 2025 05:16:31 -0500
X-MC-Unique: JanaM3_qPwyAYKP94N3IVQ-1
X-Mimecast-MFC-AGG-ID: JanaM3_qPwyAYKP94N3IVQ_1767089790
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477b8a667bcso132385565e9.2
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 02:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089790; x=1767694590; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U6HBtTZLBj4ioaYYzWmnMsK87TR+uoHLBYHR1C0qpbA=;
        b=uKQkDwKdC42+BDlqYj8kw2d6SrC0zpcYUm2zzD8NxLpG/eKFb+2AlVDq1r6MXc/rOO
         jMy6zI2B3fp4nWS9KoSOt3qcj8Gqz0AJzCZWmoD/pwahI8q0nDBMb9byDQEJQPHVf9EM
         VUCtgBeORzWuDGKS2w4Cp4M872WrAtLfKPlkNlE1y/keAQM+RnwjNB9+8s71BSh0wfTM
         W6V+Hu10N+kQpS3U/PHlH13qyxrveUxjdy9TA+cRie4CN0KAQwIOR9qZWwN5t+T/lan/
         8h3GqRdzf4/E1cEnD/S4NWjfpC6byQRtJGeA6XrZqiElMu6/GLc7Wen90XUCnTcSnf/b
         gONw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089790; x=1767694590;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U6HBtTZLBj4ioaYYzWmnMsK87TR+uoHLBYHR1C0qpbA=;
        b=fXhJlvPcydotwSbeG4XYGXuQkA8mwUOyMZTLSjX1qNEzM4kuEghwacC/Cqx4qTBRsu
         XVAi1VO07emxPOaoPYxMmyDwUnodRQdU2Z4a8VU0CB11CQere2gvj2DLycDVspvsJm0Q
         Y4BpJtEcnjEXionPh1ZHp+11FcQfzq+TCf+YB+n01VACVOybDu+zmp5t62SMJCwNLTAH
         DgmyBPNasuo/eEAMSoWU+WZJvR7Tmhw5ekAiDuXL9XKEoggwyTjC2rdkzQ0+a01jVbXt
         wMISJLx4NY6oeQzy3CjPbdADjKjIaAD0NxcbqM4ITrp15QE1U1jIZEQIs/k7dgTR4gyK
         ZbWA==
X-Forwarded-Encrypted: i=1; AJvYcCW6bYBvNlEGHLMsbOC+FFYPcHauOOJr0WwMfUCddGux9pGYu5F37IuyNFnPrJqzhSQliUk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywaq82bmpQwnRCSntfNYgamCu4Gjy6/be/W31GzO/5yQQNGXdma
	7dFGfvuE6u3miHOQQPzmee8zdjqIXLJScEWVLia6dChvX3w5XcvRv3bdfQkle28GzyAKak1kSk2
	t1v4xUnESNZ3GNaYEIX2uPKTMAzrIBfrg3UmtD9+Hy65MWeGUgkl52A==
X-Gm-Gg: AY/fxX4TmnfjC1TGS8JKH1i7/jbQ8Dva8Ha65af29TkIcQH/RFOsILahxx4qiOGzF1M
	Daa1JKyWFwngvHslnrj/wtIEN4mLckxrmCdbikLqnm+/T9JB44oa1yN7W+/Gl8lQbuqAZ+YDCjL
	xX3d8JeoFoOzhO0zmHqjL2h9YXhRZI7GgOXFStR5wMXf7WlfMuhgNVZ/MDc9cceYX2mxfiZBwj5
	f0Ap60qHXO9i5hMwWQfi6hL8IObL+55AB7vglyK9eei4BHH1uruq6of2nR2s60bnzUZBImMoDLB
	WhW7QAeC157BYwTsSRG8Qv3Tfk6vdqEPzWIwKZwvQdcCMciVxi+KUY5H1K1XwLYYZRz1DLIBkyy
	6enaGkOjMipT3JKT8wx/xus3hsfVGPVguzg==
X-Received: by 2002:a05:600c:1988:b0:477:76c2:49c9 with SMTP id 5b1f17b1804b1-47d216f9b5cmr259854385e9.2.1767089789806;
        Tue, 30 Dec 2025 02:16:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFX2lgJn+l6zys486wjxZAQuCHTw6CP6YgP3vRl5nTR1Kl1YBeU1stpLcP1P+bgygg19A++Mw==
X-Received: by 2002:a05:600c:1988:b0:477:76c2:49c9 with SMTP id 5b1f17b1804b1-47d216f9b5cmr259853855e9.2.1767089789344;
        Tue, 30 Dec 2025 02:16:29 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d193cba81sm575858095e9.10.2025.12.30.02.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:28 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:25 -0500
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
Subject: [PATCH RFC 12/13] virtio_input: use virtqueue_add_inbuf_cache_clean
 for events
Message-ID: <797e9046d85137053c86012de026cd1aefcd02ad.1767089672.git.mst@redhat.com>
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
index 774494754a99..b26db7d6a49f 100644
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


