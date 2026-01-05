Return-Path: <kvm+bounces-67027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A871CF2789
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 09:39:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 72F3930021D7
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 08:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A66F532C928;
	Mon,  5 Jan 2026 08:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Io/btUN1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qtt1gD9p"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C6932ABCF
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 08:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601434; cv=none; b=pmP95dzKh8Y4LelRSgxnN6tj7CRvShCnVJd3XEPn5sTlqoDPkwveQVqRLkB3ydVJrZLgDw5VQD9e16qGA1Pp/Yo1Z5lDYiW2gQaGGVu08+lHbg9FrAAsCx7YxoIco5nnKMJvCYzR98BIDDpaMSAGRiSvj7ffb9sd5XnNkM57+4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601434; c=relaxed/simple;
	bh=SZ7yoG8PLS6oSz/uClprybkzflRSWBjZBPmgt2pUyWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sgDuS5y4nCkQUB//YK2aujDU39rHAppyXTK0Yc84+itM6TAoMAl6DlpbADzZ/6V8PGQja/1LVpypaoeTByGBhLDsIRVfQk2cUe3UZVQeDvcOKsudtnQ04Lyv1mta/6FecIfnvagaadea+VbHa1ECRkzKhLhaqVwnqccxK4rVW/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Io/btUN1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qtt1gD9p; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UCCLeq+lwQP+R3LKzuvNuhkNhAmceABICngBBmDYRE8=;
	b=Io/btUN14Pz93JGjiSMLn8JU4k3jep6SAudvCUMDNbgMvcAm2YiJl2peavOlnsbE3tNs9W
	RS3bNAH4RsEwQR5x43TvQxfxwUrHlRmlJ0bniPMQ/RN82e8xmwbFtqQH9OiNWkEoxz9iEz
	H9Bb+vvTkYL05LQ8Dy1BccJ7DxXDg78=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-nSoRb1LEMDSRziVNxmBQ3g-1; Mon, 05 Jan 2026 03:23:47 -0500
X-MC-Unique: nSoRb1LEMDSRziVNxmBQ3g-1
X-Mimecast-MFC-AGG-ID: nSoRb1LEMDSRziVNxmBQ3g_1767601426
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso58311965e9.2
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 00:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601426; x=1768206226; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UCCLeq+lwQP+R3LKzuvNuhkNhAmceABICngBBmDYRE8=;
        b=qtt1gD9poIHpzjauiXtVKb1u88sTn7Wwbfi00HKlGMPnuFWOhzi+vYbAQiA6E+/QOy
         KHA1rws1YgxHL3D+ZGXGlsplhJBj1Xcxi0JKkOJ4sFAjpsHNb9ZS08H9jbEmcnM7vZnl
         RK7P3fTatZ/EWpjeFzLDDJoZL+87zOa90w7aj72Had0j0ntALOHFkMwbzOKcchnCq0Av
         wmwv/ZZjPGhAvvLs19IXb29uwOB3Tm5qZvnBmugl+i6s4BeM6sHQCR5u7Czf5RCGzkYR
         jHYq07piUzqY53pdXGmmnXX4TXosiZaYUteYthXVUIuM2Fec/06gqy85cfBDx3zAqzHe
         jckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601426; x=1768206226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UCCLeq+lwQP+R3LKzuvNuhkNhAmceABICngBBmDYRE8=;
        b=c9whQPzWLeUl/BvZnwDGi7OTlH+Xgs0jsUEd4Ns1wTdeKA1FPUzWDvbYib11MjDfCy
         5U3YQQpSogBH0n/WMgTiv243SK5G0ZazwfN+ssxnPCvuTZwuGOZy9rTH0XGQVQdy6ibL
         I/fP5GEF8wVKFWbYc22ZKmcQHo9toA6ngTotVlg92GWdCeSduB+AkhB1yizWhOuxizrn
         8+wBFM0Kq57RRXwKI2Yix4b4WVWjemkEXQGFaKe0Z8v2C2a8ozRnZRjYFPciqZ70Uago
         2oh83BuhjKS/fKrRcPFvjo05lumx4yOblrRHD5kLpRKThp/trDGdS/ybwFezWs0e+ghY
         7iBA==
X-Forwarded-Encrypted: i=1; AJvYcCWtxuxWdzpRiP1UDDD6C+2RXH3/f9/B1ZBL17HJCZ/p6e3Gipqq/eHixHNw+qhrMtPibPo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRR5Pnk9io/iqEw46AKUYus7hvVDLPerxFCp4wtqbigtsXg6Pb
	jKz3OBIYq/X1KdXZ/iS+lQ//6I7uLTDG5e7bug3B4uilLkj8m0dhmdTetLNUvR6YGUZ2vbo8BQu
	0NF/ngShuSEPtikNCPmVRuXVkiegZOnjk8lWDLMP+1p6FkWi98N5BTQ==
X-Gm-Gg: AY/fxX6cuPAOt+b8XPbXcFhqD+u+T1EQ5zFbGqyTsIlOVnc3CjbDoN1mxB+RzGZSTLc
	Gxxfv+0nNmDDEZZLXBZRH39wpc13llvU8nGvJNJGcqehWTr+iOvll875soya8nwf6pvYzYn11A0
	h0UouQjTiPP3PWCQ7jVP4FR9P3DTi82Np0Z3HKbjdLAs1QivKoSijqsoF53QS2+wdFNe/r22KbL
	817uwuBmK4Rxxy1wrshnQ2XcwlNXIykQHhktUddALpgIg7shHrPLgpaBkAAyjv1nBKp+VHe0eAt
	i4tq5jDlmuDrV14CCUbXyhOMq4qzYhqA7moMqajWnnMpetwZrirRG1eGFEElU2x339jDI/36+h5
	bathLSj7gkJ4DMFpxkovp4CELn4q4nuaONw==
X-Received: by 2002:a05:600c:6287:b0:47d:5dae:73b1 with SMTP id 5b1f17b1804b1-47d5dae7628mr228845985e9.23.1767601425892;
        Mon, 05 Jan 2026 00:23:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF11RG7JP48/6nhX1x0r6bivcNnxiVBPQ+hub/0+kajaGoE0Knx7g5Xjp0dkxgQjwSwKtknIQ==
X-Received: by 2002:a05:600c:6287:b0:47d:5dae:73b1 with SMTP id 5b1f17b1804b1-47d5dae7628mr228845285e9.23.1767601425245;
        Mon, 05 Jan 2026 00:23:45 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea830fesm100331450f8f.20.2026.01.05.00.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:44 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:41 -0500
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
Subject: [PATCH v2 13/15] vsock/virtio: reorder fields to reduce padding
Message-ID: <fdc1da263186274b37cdf7660c0d1e8793f8fe40.1767601130.git.mst@redhat.com>
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

Reorder struct virtio_vsock fields to place the DMA buffer (event_list)
last. This eliminates the padding from aligning the struct size on
ARCH_DMA_MINALIGN.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index ef983c36cb66..964d25e11858 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -60,9 +60,7 @@ struct virtio_vsock {
 	 */
 	struct mutex event_lock;
 	bool event_run;
-	__dma_from_device_group_begin();
-	struct virtio_vsock_event event_list[8];
-	__dma_from_device_group_end();
+
 	u32 guest_cid;
 	bool seqpacket_allow;
 
@@ -76,6 +74,10 @@ struct virtio_vsock {
 	 */
 	struct scatterlist *out_sgs[MAX_SKB_FRAGS + 1];
 	struct scatterlist out_bufs[MAX_SKB_FRAGS + 1];
+
+	__dma_from_device_group_begin();
+	struct virtio_vsock_event event_list[8];
+	__dma_from_device_group_end();
 };
 
 static u32 virtio_transport_get_local_cid(void)
-- 
MST


