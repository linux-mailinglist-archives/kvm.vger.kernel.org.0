Return-Path: <kvm+bounces-67029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BB30CF27DA
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 09:42:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B3D42307E260
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 08:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26FFD32D7F0;
	Mon,  5 Jan 2026 08:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U0EJGw52";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jhuW0fAF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6703128D9
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 08:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601444; cv=none; b=h5ik0hH+SnrpUAutqCsaT9mPZDruyA9nsP1ScQPxmpB5tXvYEtUVTXmV9dQDDeoSBoo+RaC/rtP56mB1TXs4f9HpsSrBdGioA6sllcQ1Zffeyzh5V3MLmM3RZ+Q9eD4xz489OJV1CuPGiVsB6wlmAu+XJshtLgfm33KE89SioZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601444; c=relaxed/simple;
	bh=jIFi+Zvcrqx5KM1Tn7Vx/X/Ro5vONbP7sNW0Mf3F+ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rTRkDz9+SosMrjn0z+/UbhHSFhRJl9qNU5vv5V0eoNCimlGnF6GwxCP/BKPmBleH9LUNcehjsNwGY9C7n3CYQNsIBDs6NpxkjvSSDK/Zor0oLYsmDyF5/MNIEyefXJZZrn78szHgKQBc6ZW1IgA3dieaCy3MpBxGNXkFcLHkUrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U0EJGw52; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jhuW0fAF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Ko5SEulg/0toBKRpZAMNGsguRweEFK2Nvy+yQ/ftdE=;
	b=U0EJGw525N36TsoWhwIOnHH1npKLZARnTZguj2NX/3prDCcmeRPQbwt+hNfC0WXAQ3xUXf
	72jxF5QIZDsJqNjXDrw/4uv/LyZg03zEUPojJb9o56hhsYdQgPliO9LIbaDzxu0dd7svGC
	fhwmZSYop0+2nnDzQJGqmS6QbD+QSn0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-W4MLbJ1gN8-B21Q36h-OlQ-1; Mon, 05 Jan 2026 03:23:55 -0500
X-MC-Unique: W4MLbJ1gN8-B21Q36h-OlQ-1
X-Mimecast-MFC-AGG-ID: W4MLbJ1gN8-B21Q36h-OlQ_1767601434
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47d3ffa98fcso56798445e9.3
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 00:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601434; x=1768206234; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Ko5SEulg/0toBKRpZAMNGsguRweEFK2Nvy+yQ/ftdE=;
        b=jhuW0fAFKWout8NvzOE75lr0thW/Bvte4Ikr3Ds2O8GTD5vrsS8ZXy/VT74UzpbAlc
         SkwWcLIGG2nOn2hJ3IOcZWexU19Ly66MFoocUxD3oz4K3yQnN35L6SydRy6k/+YyXyBd
         yPebtVj0mQhCIVAxVWRptftBXMGxBrm45coShq6icSkrazqS6YFoU488FT0ix7EZbdU0
         Tgt3MkO+ClKdAAuJSso08c1qe6N9IhusEsMZYkwbRWP4dwNmx37rNJr4j76KliGNlmwr
         zxVVw3FkCTqRZ/sC1v8j5gVlPYVLiP9gScBNQgEJyJqfnGaU0TgCBqXdJGQXno4Ef1MY
         fWAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601434; x=1768206234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Ko5SEulg/0toBKRpZAMNGsguRweEFK2Nvy+yQ/ftdE=;
        b=iJwLLK9XMvwzwu6StepCxBIDIEjv3X+OMHg8X4mP63z0ng1f5qHwcS6kCgenFyHO/t
         bu7xVJu87dilWf9pWkzw05PF3/WP3lr+mL+yvKTJxzMoDS6u/ZL4nkbqi6sYeqeoQcFX
         OGmi4bClyPXDtt333y/I3F3jm5vcaupK2fFTv3UkzP/7Q6eFI5dlFp9hb2GkxqBJEZM8
         U8bbJu3NoWrR214/olhL41EjYH4R5d7AZ1K6twpxZzT5weWFZNJSjHcwsmTGwdpox7tM
         59TiyLAWWUb+sx688223FD0R7WZZcImRiP+z7QfGBUtcYA5kT/RFFNRlGcaLuNbZIus2
         sn/A==
X-Forwarded-Encrypted: i=1; AJvYcCXbrfVfx6uZseNfz61OCw+6T1lZo69lN0XQfaNb5EIDq5uTJ8T3B39cuihyyzVclfqksfE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwW/5iwCKYdj3Jjom0Pzj4A1AoEMFUPgOIkxGmdvpP8B3L6tdlV
	sQwjBBLiMw4ic04hbEHD6SSKY1oee7fYUE8wSRD+y9KTClFMPXOfQ/Crfa56e7OQFfhL4jHGJOV
	KEANdDFH9g491LEoRD2yERVt6AvCQ0ks7+dF3YClxjNZ9vE7z175XLQ==
X-Gm-Gg: AY/fxX4drLWNSsWgbzAIB5RHoxOCygfKP2wxu+hpipT9yiQUZ+2dhNY5vbOZkYssRtY
	vHSbXmEQMn2KwyLHqstN9LbDHwlFy4BueMdeTA7F7B9XCs3H6ZNLZ1NCiYZADgJrydMuF418qv9
	1Dih8V4YIEPR9TsF3nmZ7rxhJj5PJkymFHb7mhgVNWq/AZ8jQ1s3IgrorRq0yzcFqZa1Ck1R4cL
	t8OXbADXymCqxWUNXm3bgGWnvibNMNxFH6eerroi2blgUI6hptz9DfJvPZqLo/fZ+z9pOhVUt2p
	32kcp2t3rFqGp1GCF/6XQKkPIQwSI+ounSTSco7GQlwQqExRn8akpLNgjpdg3hCyp74PyCJwDqG
	Mb/B1UflT8iJVoANSsdhA+uJtJuirrWMTUw==
X-Received: by 2002:a05:600c:4fd4:b0:477:9cdb:e336 with SMTP id 5b1f17b1804b1-47d1957afd8mr619221905e9.21.1767601433842;
        Mon, 05 Jan 2026 00:23:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGMqr5RF3PmeKLntFlggNTcPo2ZIBIezL7tE6/J3AdeaKkIeEvwYa+UmsMabaObW/38gLAvfg==
X-Received: by 2002:a05:600c:4fd4:b0:477:9cdb:e336 with SMTP id 5b1f17b1804b1-47d1957afd8mr619221495e9.21.1767601433387;
        Mon, 05 Jan 2026 00:23:53 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eab2721sm99141541f8f.39.2026.01.05.00.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:52 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:49 -0500
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
	kvm@vger.kernel.org, netdev@vger.kernel.org,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Enrico Weigelt, metux IT consult" <info@metux.net>,
	Viresh Kumar <vireshk@kernel.org>,
	Linus Walleij <linusw@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH v2 15/15] gpio: virtio: reorder fields to reduce struct
 padding
Message-ID: <f1221bbc120df6adaba9006710a517f1e84a10b2.1767601130.git.mst@redhat.com>
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

Reorder struct virtio_gpio_line fields to place the DMA buffers
(req/res) last.

This eliminates the padding from aligning struct size on
ARCH_DMA_MINALIGN.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/gpio/gpio-virtio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-virtio.c b/drivers/gpio/gpio-virtio.c
index b70294626770..ed6e0e90fa8a 100644
--- a/drivers/gpio/gpio-virtio.c
+++ b/drivers/gpio/gpio-virtio.c
@@ -26,11 +26,12 @@ struct virtio_gpio_line {
 	struct mutex lock; /* Protects line operation */
 	struct completion completion;
 
+	unsigned int rxlen;
+
 	__dma_from_device_group_begin();
 	struct virtio_gpio_request req;
 	struct virtio_gpio_response res;
 	__dma_from_device_group_end();
-	unsigned int rxlen;
 };
 
 struct vgpio_irq_line {
-- 
MST


