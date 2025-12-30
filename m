Return-Path: <kvm+bounces-66841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 299A9CE9632
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 11:28:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2AF1D300A6E7
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 10:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DCB72FE59C;
	Tue, 30 Dec 2025 10:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gp+/QrIb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="A/hkwEx4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1042F7444
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 10:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089803; cv=none; b=FqjQtOqSTI5mFrvYzOaDOj/9urFBEjs8k0KWwSrWvtwdpKOxUHZw5evg+oNRv4iVPyrZSFXaNOlyARDt5rpBAAUnpmHsp5rXSvd9cZamAuZNmYokqDAWnhH2uwDgSyyzvymaxEIKtpUDfpI/NI18KHYFaww4CqWE7XAtFxboS+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089803; c=relaxed/simple;
	bh=RzxSFhz+bpkLtGdr/5qvrDQOf7DHug0oDxHEj4NfN04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uZscYjrCgef2TxF435b8o9Q/Gp57nMc64gm1kk3dNDyUIXDK7hbrDMGU2DdzkxvnML9IPCG9ik+L/hPInJQMYWt0f4qyQq5ISmBH4E4EGCXbdrnriV4dZ6vXaKBECnmcuC08lFQwFxOm4aOE7KsuRuqymTiZd235iPwHpA+R2CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gp+/QrIb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=A/hkwEx4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qjCbMizY1BaJF5yBWOLXV7DyUl9vbunxYIEFqfWmhYA=;
	b=gp+/QrIbF1nc+WyvdgEXty3YI5FINourt6mIKYBAsBIlirZqD3Wv6GDJqWKr+sOkvIVh5s
	dxF4qPLzJl4rAKwYN2oF5C8IJzaUmBXxK7ZXJ8WfrH56+Q52ofgILo/Kz+PUAPW0lNSNS6
	ZdoLeuRp1ebeR+fGPTrAvbpiSTvmlhk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-LirxEN3WN0eSaA7szFIXcg-1; Tue, 30 Dec 2025 05:16:39 -0500
X-MC-Unique: LirxEN3WN0eSaA7szFIXcg-1
X-Mimecast-MFC-AGG-ID: LirxEN3WN0eSaA7szFIXcg_1767089798
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477a1e2b372so77926745e9.2
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 02:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089798; x=1767694598; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qjCbMizY1BaJF5yBWOLXV7DyUl9vbunxYIEFqfWmhYA=;
        b=A/hkwEx4WZZqbWGO/MKIo5PbfxAPOdcLiTbBHSaSP0SHg8S8cwWpKHuScFjvBz5LtZ
         dgnv05gLf1QD3b8feoewuk+ryDTDw8j6yHJeDklMZHC8r6zeYdjm81Ir1h7upjeGquqv
         QUrQerqcKtaD7jdpCwenPlnJLZ4Ca0/zGIsfxbs2cqoul+hR+lmjc8jXK/XKVsd5MdH1
         WX2jOAqrnFOZ2EK/DkhSM9CCYzK8dDDTjUha8Re4VFbih2TgwK4j5ZPARaR8idthYOiq
         YnmhyvNLtrrSxftR6dY5fGO3J/oV9LVG1+NYTKI+FwQtiZn88YIoywesqIICOHIBV1xb
         ZGdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089798; x=1767694598;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qjCbMizY1BaJF5yBWOLXV7DyUl9vbunxYIEFqfWmhYA=;
        b=gc0A8EFsfe93q/PlKYINACSV/cJalrdghuwaDSzMo+TvZCdZvFWumyS/xhWsy1SXC8
         vBAvwV/kE1RCkAJ++qp8YnUhEZBZbE/NrN+5GK/uoIQ1QqX3VRPSFhvwJLn5brxdCDC9
         Er9U3hWHfzxb5OGwCl+I5wTH/f/NROd92TakWQWOpqKc3qttr8v8M1GbQj2zScPMqARW
         kEhpbT4V6kmWHYg68K2/jNA35gm3dcoXKGjWtSFfcJckpBQCgPai7jeZywmzdOiFSymb
         ab0O9qPyf3Ev3HIzpHnUBmkLD9I65vkrPtO/gHIcB8/iFu06FseDUFqGUr+AURW981Lo
         Ob0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVhOCsvPlfJLlvbcSB7lK9d/rW7wM1ZJxkqu31Wqz4Y3V7hqDw9HYrdD2ctYQcPyyb6T58=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/OHAWHQT/PEKj3IBNa5+MTbc5d0GjpVf51D4twLJNE5DESv3d
	efVXlyXxOxAhHNY7pfojPktq8DXPfrmJ+WGje0D3bqgwGngkcAniMsanI1pQM+3gfsKIkqO9yxH
	uc8EawRYaBINshiqnnaKdRCalr6Md9xglCdOIsmDtlBLgu7yOY4o9fw==
X-Gm-Gg: AY/fxX7gFhmrKmIVeik/NOt6sMAaNgfBR2NY2UrLGfZqAN4r2lNqy5f3gNLEc3q6aMM
	vcoJ1URVUNmZmfk70RR/S4CCQmFf6wd4nCe5alKc0ehu/cDPptgiafU0Rpm0BsBB7ASdPQs1Aqj
	6d72Ch2TUQt4QeM6iZSiJSgJP3PMU7mQkleHivzdnXi8mqcqVuk6x/KIgOJoxnfZzX07+63IuLL
	KFO7Li6RMoVXiOFtP4H1XNPlEQf6ZWlspNtQUVF6QTUnFAD+dRii9+vIXcL7e6aA8wVwhgVyJt1
	R6wX+BrB+uNHvu4IulN6VzxCtiJ5VXwX5vCoXAIcg96B/kdPQpkIXjwSvpTA2DdIgdxJQh638lU
	JReTSiygzNcYepeYNF0LJbTVN42vvBVoDyg==
X-Received: by 2002:a05:600c:620d:b0:47b:da85:b9ef with SMTP id 5b1f17b1804b1-47d19569c23mr469752675e9.16.1767089797980;
        Tue, 30 Dec 2025 02:16:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHj3WKIKEzUGPKu3zdwQlyOBMeOTgJhitK/YOLHPeOIUg2zxiErnT0jngxXmWGMEmg7Rb+0jg==
X-Received: by 2002:a05:600c:620d:b0:47b:da85:b9ef with SMTP id 5b1f17b1804b1-47d19569c23mr469752175e9.16.1767089797499;
        Tue, 30 Dec 2025 02:16:37 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be279c5f8sm610551235e9.9.2025.12.30.02.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:37 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:33 -0500
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
Subject: [PATCH RFC 09/13] virtio_input: fix DMA cacheline alignment for evts
Message-ID: <ba80d103c159a9dc36b89705e00f91bcff8857c3.1767089257.git.mst@redhat.com>
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


