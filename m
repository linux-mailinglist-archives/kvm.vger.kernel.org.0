Return-Path: <kvm+bounces-66838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 499AFCE9662
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 11:32:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 86B543031A27
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 10:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 646542F0C48;
	Tue, 30 Dec 2025 10:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pu28dPwL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dFhz12Ug"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567DA2ED161
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 10:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089793; cv=none; b=XCd9OI0pG76oZA6ZUlJ117wwPj1YRlGEySY/aPJOevBiGShGkOPEfQVI6cF7vJf6DyG85wiu8WgSc2SUobP43PLJ0wxUSKDsKagAvVBwPgGu1iJQF6GAfzm87HrcONQgPCNE6bVWDhuPH05PWLJSZLT7zFOPF6A2QFEr0P4rbx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089793; c=relaxed/simple;
	bh=7vYhvTa0EsKkdKbYw4kgKH5spensmAuucNSR/pooHKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+bKQ9PVtbl/YSRpFLWtzexSnGbvMesZPUMQatw182RumnD8kjwtHppXStqwcMV1l6M8jQRb0kkzBFWTJA1OJP+o2mK49xLk3lM4RXVD4LLl6CIUtXSd7a/xOqwPBNAoq4on7J+095fX91f2ttj9EWWI4Pv6dw6CHpujMk4x4SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pu28dPwL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dFhz12Ug; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OZZOSut1u/TDBTxePQLgpeDsLzuX17NVLcEs6Y0hRck=;
	b=Pu28dPwLkQyY/fepeq/6f6wV1tJXIt27CyXrQL6+T/OQd/dYPessCswlz0urtroh7qqR/L
	NTa4KlhUaL7eLRa5AtliUTs9uPU7YYV+xKbfDqTOqz/yrNOg4NICR2A7r6Re7y/tp2lUxU
	fjxkLbBlGWetPmFtwlegjkf0jDDShqY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-FI1tLA8aM-qoAtFd-XfRAw-1; Tue, 30 Dec 2025 05:16:26 -0500
X-MC-Unique: FI1tLA8aM-qoAtFd-XfRAw-1
X-Mimecast-MFC-AGG-ID: FI1tLA8aM-qoAtFd-XfRAw_1767089786
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4792bd2c290so94170665e9.1
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 02:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089785; x=1767694585; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OZZOSut1u/TDBTxePQLgpeDsLzuX17NVLcEs6Y0hRck=;
        b=dFhz12Ug/OWVkYDk0VgCwy+wOITX5FT740qMSI7RgR9EDDCDueU2BMbotXr76H1Jij
         jaUbxvXGn1awYNvA8QnVEQAANvjZ2V5o8zkkCBOUVD5MM6z5F92//KMTs8S7HhWefoGU
         HABYKtlPOZsKWJy2pUH3NPNpUbSIY7YCdV2loIcw3+YOtSlFA5OSYOJp6O9Uz86BDn6v
         9A3suQnWG6Ag7SgKD22SXeKFErEYhrxikN+BBb8gtsAD2Mht4DtESRNd+w5H+DgdboKJ
         4BiNpcBTs3cJ79bHylP7GxhNP0UE6igCwVAjF5ViY5kdQg84abWlqtl0pO2a5GTdFkbg
         QbQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089785; x=1767694585;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OZZOSut1u/TDBTxePQLgpeDsLzuX17NVLcEs6Y0hRck=;
        b=vu0C3TWCY++GXMg+VZ/rbEYWPbKRWB5JFFmv+gmZPCmh26QsB+0Z4QZAAwmBKLQs29
         6+3seTSdNLbwGsarVBZmUAM90sF9IXhx7+eZQOh9gGAmSlG3MkFfjOd1AWKEW2lDEcEw
         BwFfG9EsfwnfrbA/vCkuZ9TLDyIbQuXv6bZ/RF8O7QUqDWcniUsmfWer2Gi4iDBdMZpX
         FwbHMTOdZp+7ltTYZ2hAi6eTc/+Y2i20Xwz7SUG1eSDSkNe/u0vpwqQhhWPkANZ6e/mC
         LVHswPGYc67SenSvqCDw/nlTm4q4fJN8sPjfbc/vBg72Tuy/eF+FDYtuhzdhtLr1STzg
         vI+g==
X-Forwarded-Encrypted: i=1; AJvYcCW9sJpQ3vWWCv/LDowH5+ys6PMYnb5ezvilBIlqK+gNbxfTqedKgWD9WUImuQc25spQldM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/zaJmC5ROMqAi7Bce3PbFeqTftmd8a+jLAJjvNSLQWU9kPtuu
	WhQHz2ooTvy0GOTsdDsZk9Rjp00VJnDsPZ7YLdWPbPxtVBgziL29O3uQOwH1ECuB6V8TUm+gFdm
	jUOPNUPB4b/e1jA9KlLbLgHW7RxBXIb81XJbkX+l7c8mw7SViCpe2Pw==
X-Gm-Gg: AY/fxX5I9UVZsIYzoLcGsVk7lekg9krrgMA8wj687BByQI/zGBt+0KrxcDP0PjQcah2
	S0+UNkG252H7zane0tGfn9+MyxWmNDxSKqkcCoYCumUjkdfosIzqXpVp/TKPu9R0mY/d0Oju36b
	vmAmEbrua8QqZJUu0L67lMHn8Qgd/Z7gY/xIGqbyqFP0e2nift/Ac44hqfuEQQdGOkptp9LC1Tn
	VfIHaOgtGHq/Ru+iSqhnde960osuwkNaFTo1TlbX1Da0UnLgp6Sd04RrrE58NfkgF5oDis2Zffa
	PcapbekZIhhrHKtiEBjvnYpOzxVXTznPxRTLprIcbTwpPbGbVHFmJHXJ8O2XldRIw+F0B/EFLOP
	uema7CMrwEruOrm00kH5H7BFI64QgaV7Rug==
X-Received: by 2002:a05:600c:608d:b0:477:93f7:bbc5 with SMTP id 5b1f17b1804b1-47d195667d6mr373409335e9.10.1767089785442;
        Tue, 30 Dec 2025 02:16:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG01+uSPzH44CAd+66VyYkAwuPn/pb8j51wL1G42pmMr4duS4CHLId/Zv5CUmzKtGwuKnJahg==
X-Received: by 2002:a05:600c:608d:b0:477:93f7:bbc5 with SMTP id 5b1f17b1804b1-47d195667d6mr373408995e9.10.1767089785008;
        Tue, 30 Dec 2025 02:16:25 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be27b0d5asm646323275e9.13.2025.12.30.02.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:16:24 -0800 (PST)
Date: Tue, 30 Dec 2025 05:16:21 -0500
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
Subject: [PATCH RFC 11/13] virtio-rng: fix DMA alignment for data buffer
Message-ID: <318c48915a52f1739c23d46b2b99e3a51c7139de.1767089672.git.mst@redhat.com>
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

The data buffer in struct virtrng_info is used for DMA_FROM_DEVICE via
virtqueue_add_inbuf() and shares cachelines with the adjacent
CPU-written fields (data_avail, data_idx).

The device writing to the DMA buffer and the CPU writing to adjacent
fields could corrupt each other's data on non-cache-coherent platforms.

Add __dma_from_device_aligned_begin annotation to place these
in distinct cache lines.

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


