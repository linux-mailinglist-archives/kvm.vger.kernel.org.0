Return-Path: <kvm+bounces-67015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D6ECDCF25F1
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 09:23:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AD38B300F1B3
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 08:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E03FE314A86;
	Mon,  5 Jan 2026 08:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WqVz3irm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QPkFrgpu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB761313E39
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 08:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601383; cv=none; b=ibRY9e8QuPL9Sz/ZPnlmSi9hhky7eG5T70quRbpt0G8pwnV5zvDOfT5NQJ3kUtd689VcG+dT6U3nDn4R0A8r9mLX9I4VWMI/m8fdgCi9PrDtmxITTQUxOWcAwRAY022CBtsYESL4borYaltZV1CCjD3S/5osemKwobjPOF0z9ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601383; c=relaxed/simple;
	bh=OKICx5FGcs8IaWdKqJAnv5nr30MUEvkMmLH/rtLJg90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g9Ihj8rqop/xS9/weDBSsIvOYVsZNfSplm3++NaHPP8nKske+MX4Jc6sYtchk7ZX3WJCb3vDE7RNoKuLLzEag7jW4KV2eh/Ox14jmk9VPG7NLDRvZtwx7ATjCtPgSGjsyNPASxoQBVw9gZKsGOqVGZlqz2nKDhjcZo84sHk6bBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WqVz3irm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QPkFrgpu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=flvV58rpfI6B2CbimOq4yKlcklsexX+NampJykNGX78=;
	b=WqVz3irmgl/1ZpP+3Mg4itom3mhS8h0Rbrdtt95M6DwQFX+h30kcTMJGJZHFGGTXx46C9n
	k7QD5ZNc1cE4PvrTUNGjMkSJ8cUXCc4UItybwSIPOawmPH1Lus9RXtQaNSe6Q6nmbZntyM
	9kSdOgbhWt0yWZ60HwGundSiE5kWm3A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-H1XjOhROPcuXnw_zfHAGOA-1; Mon, 05 Jan 2026 03:22:59 -0500
X-MC-Unique: H1XjOhROPcuXnw_zfHAGOA-1
X-Mimecast-MFC-AGG-ID: H1XjOhROPcuXnw_zfHAGOA_1767601378
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47d62cc05daso23264685e9.3
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 00:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601378; x=1768206178; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=flvV58rpfI6B2CbimOq4yKlcklsexX+NampJykNGX78=;
        b=QPkFrgpuiBMMFofOQ4jAdxxN6c2Vp4oV1Gg7feN7Brwk3IoZE8tlZBtMewNHdCTmcX
         J89iiXHO8XulT7mvkAYigvNB21HwVkC4UaJh+6qLFH044MYI/AJhC1rir05k3E4D5zAC
         l2oMwTUjnPVcCbl4v5p9sk+ENJbiTovejKy4d238LehbX5oug0hjfbk+5CP0WUf7R0W5
         oAt5vX0zoXLVkMJ/lerxu000WlCDJKWa5kUX14ARIXqnfSsN5oTfZjrjrbgv3FTzfJ+d
         ohL+mLUyGVtzNS0/P3hyS1HSdrurjG/swvLj6tE2/lIvMl2g9uBukt4A5C+bA3B/QfIq
         nkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601378; x=1768206178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=flvV58rpfI6B2CbimOq4yKlcklsexX+NampJykNGX78=;
        b=MY1hx6hAqXExoDdC5iaNi5cvaIMih/K2LnCWUpKkAw68VK2BNq6yjPkL3fPw7MGbOT
         /yivjJ2pVvo/hdtU2AjfZL08y++fhapbAD/nVYP+skK6oLJyu5cQyLbyd4h+UXnD/saS
         7B6EUDTllgYFyTFItgwYCmkJ5VXKBbkPhPCtFT4pdoOCMhdTf5CM60vn3W4TCJqbQaRs
         txyATmlingLhoRJs4p+FJetCm5HjjvD/1bGDrsTkeUgJ+F70ZXDhgYQSCLW5JWmudhw1
         GxN7MVhs+3lvaqBXu00QL+TMLxUgOpRqV+SoFM3b9fLiGEEGMRn4YCez03S/8ToCX8D2
         MQNw==
X-Forwarded-Encrypted: i=1; AJvYcCVdNpkxVyMOpnPpaUX1f6Ud0td5hWIqtlrqA1qK4/tqY1UZb9rp+nlJpmd0shzhiECr4dM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsZjl4coS3PeCok6rMjfSWLMmZZAQrBSNdkoCNdjNsgmtlQJ6m
	R5TJrvMlzmVgASjYtm+jnSqr2+z9zmDRJrFvHtXITcrP5nYuo8+U8CTEXOOGE3qCQTW4Sm3Bq74
	oXionU1Bh0lPMBJSfaSPxNZZGwnku5W8xh6R1m3SYsCGfrqBenjZXOg==
X-Gm-Gg: AY/fxX499IJTJAX6ic2EMry90G3YR4JKDTFwOYj/BnUSKhE1X2OS0ttquosd0N3bcbx
	34KdT1vH1aFcbXhrz7ZoHz8fGWdmLZS1kxa5NcNCgf4IxBsJyvP7Dnd+LUpq97GCOZhyeRzenOf
	k4sbCe2iYrFJaEQ3z+nM6MwVQTBDnP++iXyk56SSu/2ucUVpArt2K/r0NEffFa07bWcdPCW8fDQ
	ut7nAxE86rhEfmCa+x6eKDd8FFCojzmwnAQmF1wuPDvFi6I96XD1XZlOZm+cZSDScfamzTyQjkM
	p1jsGqMk4rrh0g3v4xrnSqH7hTgIFwIpE2Ox6bUnh2g04pHBcwwUqwGN1autxR0AFOJYBltEUm8
	/qKz0+3wqEBuLRy5BEhYgi2Cej8QwjWS6Yg==
X-Received: by 2002:a05:600c:a31a:b0:477:b48d:ba7a with SMTP id 5b1f17b1804b1-47d1afcd9e2mr472221755e9.32.1767601378036;
        Mon, 05 Jan 2026 00:22:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEuXSIOihQGqTUh73UD1lwUxn/oQlvSzbaEszKjq8q7pmaQg9MTKbAK1XIofFksKZVCqoImYw==
X-Received: by 2002:a05:600c:a31a:b0:477:b48d:ba7a with SMTP id 5b1f17b1804b1-47d1afcd9e2mr472221315e9.32.1767601377489;
        Mon, 05 Jan 2026 00:22:57 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6d13ed0asm147684535e9.3.2026.01.05.00.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:22:57 -0800 (PST)
Date: Mon, 5 Jan 2026 03:22:54 -0500
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
Subject: [PATCH v2 01/15] dma-mapping: add
 __dma_from_device_group_begin()/end()
Message-ID: <19163086d5e4704c316f18f6da06bc1c72968904.1767601130.git.mst@redhat.com>
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

When a structure contains a buffer that DMA writes to alongside fields
that the CPU writes to, cache line sharing between the DMA buffer and
CPU-written fields can cause data corruption on non-cache-coherent
platforms.

Add __dma_from_device_group_begin()/end() annotations to ensure proper
alignment to prevent this:

struct my_device {
	spinlock_t lock1;
	__dma_from_device_group_begin();
	char dma_buffer1[16];
	char dma_buffer2[16];
	__dma_from_device_group_end();
	spinlock_t lock2;
};

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/dma-mapping.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index aa36a0d1d9df..29ad2ce700f0 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -7,6 +7,7 @@
 #include <linux/dma-direction.h>
 #include <linux/scatterlist.h>
 #include <linux/bug.h>
+#include <linux/cache.h>
 
 /**
  * List of possible attributes associated with a DMA mapping. The semantics
@@ -703,6 +704,18 @@ static inline int dma_get_cache_alignment(void)
 }
 #endif
 
+#ifdef ARCH_HAS_DMA_MINALIGN
+#define ____dma_from_device_aligned __aligned(ARCH_DMA_MINALIGN)
+#else
+#define ____dma_from_device_aligned
+#endif
+/* Mark start of DMA buffer */
+#define __dma_from_device_group_begin(GROUP)			\
+	__cacheline_group_begin(GROUP) ____dma_from_device_aligned
+/* Mark end of DMA buffer */
+#define __dma_from_device_group_end(GROUP)			\
+	__cacheline_group_end(GROUP) ____dma_from_device_aligned
+
 static inline void *dmam_alloc_coherent(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp)
 {
-- 
MST


