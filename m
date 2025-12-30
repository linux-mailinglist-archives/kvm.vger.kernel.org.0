Return-Path: <kvm+bounces-66831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9035FCE95A8
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 11:20:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 926793077999
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 10:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C0B2BF00B;
	Tue, 30 Dec 2025 10:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ig5ep5oQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z7FQ8isQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B7426B098
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 10:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767089766; cv=none; b=lWnXjzWx99Uvsn9LW+I+FCHvawIdaveQw3JzM4kfmNxescV0O7B/LCig05YXOPfbZhVPjozeRrw2Qi97aSaTYcqvRnW6paUefyRp0Xt4SeQ4VnI3hP3e9x1QjsVhymjKy950TqTAfmgIvlOJKSqcdNi73tdbXJ27Lt38Wj78M1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767089766; c=relaxed/simple;
	bh=3EF4beueqssYSrJr7jAiyWtRxi/ynmIi31SbgxtAbxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J3+TxGQ4LBTyHDx+1Pmdpctw2Jsnz2KLAej85dHTlodzdOPJfmxwzJPCamMy302pbr/VLixAxjFfdkV2/UkFY7zmREwc8fmpvYfNHnmfKAl/lYMikQEg2+3dG2FJH37O+cFoA+qFK7VRGSojzNSvehHVnd53L30R3ynDDeDnJSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ig5ep5oQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z7FQ8isQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767089763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
	b=Ig5ep5oQfWTSijshrhmphh1kZkOF0/D3T4IO0PkmzcUJ9LMbjzNp+u6jZ10CCW4QVl+zOX
	Tya5yn+N8eUQwS6+O8S7fVAFMqh66YiNsMIbM3BzPQPZVUlRDLR/1xsJMoY6lRsszddlWC
	jG9Ke2bvMqJsbN/EmJMgf0wOxMckYuI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-9-UuG6zGIUN3WZtkJ-qmQf1Q-1; Tue, 30 Dec 2025 05:16:01 -0500
X-MC-Unique: UuG6zGIUN3WZtkJ-qmQf1Q-1
X-Mimecast-MFC-AGG-ID: UuG6zGIUN3WZtkJ-qmQf1Q_1767089761
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43009df5ab3so5469991f8f.1
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 02:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767089760; x=1767694560; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
        b=Z7FQ8isQq14I1KaSH1zw/UXjxfl4vbX2ZEFt82yb0xF9HrF5cGDa24nsifnCDpFx+d
         ZJVEGcAaQcquK7ruSxLov+mmtNZm6Z1cY1l5h155mMjVQFrApi3LDOd28jAvqGiPFSet
         LdpFwLkIn/ZjyF4pQkW4zmY53q3amnxzSS9IUxJai+v6NViiTMCFUhYnCxRcxm5uZESt
         Aw1V9bQXYW7Fl52Vl/JGM8eclURT8majQKzcf5P/SfKE9+ou1xx5sGSTMLsUXNKdhfjL
         R5z2Dr7EADU/6enDMzGahCI5t7S/9eDh/HfytF8+YyTZ1fvM3mPQmNW/lQt+yUskX7rr
         0rRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767089760; x=1767694560;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jlkdUJvLxIuG9RkypEQ1odBgc8hsD/vyeqVzWJtThQg=;
        b=C7EZt+JnaXS9jZwnUYflZN7tmbiJT5RGnLh3OD6lXMibBBbog9OYqUjqEG8mhQaAEg
         dHi7CfJJ6EjMq/pVMIGVk6hBd3+/BflKedkJtN2VstYexxAx0POIzJqD4CwB/5rAo1c4
         tZLW1qZB69BZLNCy50FPJSPVLNklDEZ3Y8RTegtHaPVyEWMVoMER2QOmTWnM9WsE+eml
         i9gsOjXOe1x+BCr7mBZcE20LFrVlZ2LiplSaq3OBJ+lGWja5QbTtXrenWyNEOl3sHZQ+
         o2aDloFkZaGAfRUf7uyLteH4IT9oZ2fq1yCcudHwxcTDRCUi7/E5tE3Kq7AHyRBHR7d5
         N/Mw==
X-Forwarded-Encrypted: i=1; AJvYcCU5a4uJ8U9xA1fp9EGvLec/LWx4dLYsoOgEKjqLpD8hg+Jwm2UhIMf4yIzruU/vDXgH8zk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNxdj0duwyUAIXF0YFXZUO+eeFyADOPvfrhtLBpCoMXsGpW6p7
	wFs3sJHpeiRhmdfbPl3Pt708YZAtlM4cjvB1ZgbjpCtgOKUNyhi+btqKyCueOiHkJlFID6En9LI
	7vi84a/wPOfr4NA5hS1jGgwYNmdm4qHfsBX/OyCNGp2bC3A3nBkLZ8w==
X-Gm-Gg: AY/fxX6Cn620LLMMvMhaayN0sk6UF1KtIBTZ7uuC0hYd7jtqEPnCyMvpRHCgnt4DgRY
	d+swnBcIDx7HmvaLVz8fwqE/qFvu2AGGPmHHxHczi0magrqgs1hZ9nqMu9k3b/aH/vn6J2NRbmD
	Ban/yDc1AP3a4PzaEdQiyNAT9tsdDvgnN0WWdK3Mhy9gP0kqUXgVEc/Ro6XvlYvLnOoIqW07pAD
	DxMRvWugO4KCjyJLQbvioauC12l4tcyMM5D3vn3RTSYb0YDrpohJxi0OUXumg+QUe0ijIaJaACV
	hcu0D+DqY1ATi0x72TwlKyIzs3Z+lVluUaDhr1Tx9mgzT0/F1csdv28CTcpG05NEx66wE3ZirAf
	hhEPqme2iDNoP3C8sxFyRkew9IWh4A1H56w==
X-Received: by 2002:a05:6000:2906:b0:430:fd84:3171 with SMTP id ffacd0b85a97d-4324e4c9e98mr39750137f8f.22.1767089760450;
        Tue, 30 Dec 2025 02:16:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHondA4WovcXdLOT45Lj3uVr7rduhIOKgQxT45AJwE7sF5CS5LqWM7ii/WKiPGqmcKK8QLbHQ==
X-Received: by 2002:a05:6000:2906:b0:430:fd84:3171 with SMTP id ffacd0b85a97d-4324e4c9e98mr39750079f8f.22.1767089759925;
        Tue, 30 Dec 2025 02:15:59 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea830fesm68448837f8f.20.2025.12.30.02.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 02:15:59 -0800 (PST)
Date: Tue, 30 Dec 2025 05:15:56 -0500
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
Subject: [PATCH RFC 04/13] docs: dma-api: document DMA_ATTR_CPU_CACHE_CLEAN
Message-ID: <818c7ea78e43b93d1bb3995738a217e5e414e208.1767089672.git.mst@redhat.com>
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

Document DMA_ATTR_CPU_CACHE_CLEAN as implemented in the
previous patch.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 Documentation/core-api/dma-attributes.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/core-api/dma-attributes.rst b/Documentation/core-api/dma-attributes.rst
index 0bdc2be65e57..1d7bfad73b1c 100644
--- a/Documentation/core-api/dma-attributes.rst
+++ b/Documentation/core-api/dma-attributes.rst
@@ -148,3 +148,12 @@ DMA_ATTR_MMIO is appropriate.
 For architectures that require cache flushing for DMA coherence
 DMA_ATTR_MMIO will not perform any cache flushing. The address
 provided must never be mapped cacheable into the CPU.
+
+DMA_ATTR_CPU_CACHE_CLEAN
+------------------------
+
+This attribute indicates the CPU will not dirty any cacheline overlapping this
+DMA_FROM_DEVICE/DMA_BIDIRECTIONAL buffer while it is mapped. This allows
+multiple small buffers to safely share a cacheline without risk of data
+corruption, suppressing DMA debug warnings about overlapping mappings.
+All mappings sharing a cacheline should have this attribute.
-- 
MST


