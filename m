Return-Path: <kvm+bounces-67016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ACE5CF2699
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 09:29:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 43BB43036597
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 08:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F6B314A95;
	Mon,  5 Jan 2026 08:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LS3uTdc+";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LlTKn6Vt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12308313542
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 08:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601389; cv=none; b=WTHGP3F4+/W2xNa12netk3DEyGkEUwMZAG8ApzD/V857FBM9vvpZ1agZFcveNqqlAR1g+0OuW3gC0NwxG/hBqCvu9qU0gjeMga0m/Zk7sDe0o9DgJxPfo3AGz0rCIQaEy/NHZtar9qdRMcuY29wWOO2IiCNP4Q+KjHoFJhJZ4Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601389; c=relaxed/simple;
	bh=prNYGYHAMpr2WjcHI5N+V/0OjaLMaL48hqD0tOu0jIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZEY4ogqxfRTJct27s1UcjHPEzIqZ9GgHMusXafGAQ6c7+ndAEM0miAifO5/fykhBAkAv/xVkGFMYliuMmLenISVVznQLiqwz3sHCN40HkZCUdqslau9TZozb0OvbFucPGnBE9xQxqVJ024GBAt604GS1IzMfe8+prLIDw9xwgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LS3uTdc+; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LlTKn6Vt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vW7mLQEFNX/sa5+JF2UQBkqoBaqIc5/VpH7fDXfLlqs=;
	b=LS3uTdc+FsttqHOfOw/HO7GM9NxeIOzRBH2kw/DWe+ws+Rr11TKPF6fDzwZu9w9Hq9EHdJ
	vCfDbLVf2yHeZChraF7wHGi1fWqRTVGd5TwviBVIkc0jqMhe0VSYhy4thw9Amx8yDypRMH
	tP8s3tojCidvhpDNofTpDPxBCNxuAF0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-2k6oY-ZTNBGfG_bLSLtwsA-1; Mon, 05 Jan 2026 03:23:03 -0500
X-MC-Unique: 2k6oY-ZTNBGfG_bLSLtwsA-1
X-Mimecast-MFC-AGG-ID: 2k6oY-ZTNBGfG_bLSLtwsA_1767601382
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4776079ada3so122518105e9.1
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 00:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601382; x=1768206182; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vW7mLQEFNX/sa5+JF2UQBkqoBaqIc5/VpH7fDXfLlqs=;
        b=LlTKn6Vt5VZSlWqvNo95rjH7QcjTqmevzhcFdafBlRMtrFsg393kNfHpLthMx0LnVV
         vNGY4I17PqR5/A1CYAvKuZUVDlnoAfWJ6svgNynzEFVm5+qdyMGprnko1uTM9RiNCUKN
         kF3u7GUAA5b8Gni6esWpiA/RBnDbdbZ5xN0w+G8IAu11M7uHdYjob5i81/H1T+JccJ0j
         qv5P03j7qTAyWBvd1jE7YK3jTOHSs3/jNRdOM7up8oT1SMJEl/1BY7vMBUDs4tZvsQwh
         AR3Tkh1LmBBr5VEQzaQkl7VBfvNUn0CJ3kQTSFprNCIEANiCKV0OhDtkGZcUrxuWh867
         jLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601382; x=1768206182;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vW7mLQEFNX/sa5+JF2UQBkqoBaqIc5/VpH7fDXfLlqs=;
        b=eBr64q+u3Yx8zsbxNOeQ2TnmB3JpG3LW2UiwnwvqXDkZUIU7JNQ8msmlB1ECresBjq
         WOq19Ndhq03vuk34M3ghEHeEd+LgBq1hlBuQP71jdTbDToW1hO6TlN93Zh73Ck8tim1e
         cu0PRlWars9GIDLxdw17VvYMGHRO5DMiO9UDpvXGW8F7XOmmkBjdq/hESHP+HutjS69Q
         7NOI5RuPV/oTwV/YFI0zB4Zv/YKFr6/Vbsavq0+Jw1So+HzaToE2Rzs2LQMPB4Dzp9Eq
         5IP1aWz3GSojJ/czDTmSPdMmX7OBbw9oIW54kuXLoaib3y7S0i5xCXI+mjLGJUF2JcxH
         MCZA==
X-Forwarded-Encrypted: i=1; AJvYcCUKkpiCbalSWrXh8JHYQ/jHoo9eAqNqsaD4CgYH8QBEddpgApTiPMEAE0l/XaIKz8/oNys=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpRh8T95enOKco41YAsQlkOyCguiHEzq+v/ts3QWku8GN8zHv7
	w4gXToUEOm6Zh7t3/HV5sWUDaSjBdcvjx+tdUJjw60K3COyJvUaB8n8V1XF3Yce7+EncbcysoeV
	4mKLH++S0m89PlIwORvniepjNL9QCu4tLpXFAdUgMi+ccB/6C3XVPww==
X-Gm-Gg: AY/fxX6G+zcMT6eNCyzGWhJsXfRj5f3tFp2C1//9BjcGl+u4ZH6P10qZx6fg/8jNVYT
	6TK6ioZzZSz9J5uxG9GzUga4ut6sMfaS1+Uw49/dcNaZW+t7A474uhe8S+Ws6jOGI9ihuc0rhGm
	HzTizQ5+lECL5q9bZouIvSzLfMZQVKSx7z7urDcGNsLRxxDM4uZmTd184Vrk7dae6Rz0m+ouupj
	z8jjQVk6bacAT4BBzD+pgj+HlCuPtmRAmNoCfkNO8RqUtfleZax+1OcSD7X7QJAKJJtTFfagCu3
	x+9MpZE3ZXBddAB+ar9/IjEsUMdmvxqgYQHiGanS7tL3oLStRfjuyhG9BXIaNbXsaiLbehzfXFH
	K5KTfHELQb04ilUbkiBcRv+AxlZUaNYsbiA==
X-Received: by 2002:a05:6000:2403:b0:431:35a:4a7d with SMTP id ffacd0b85a97d-4324e708fe3mr58459622f8f.58.1767601382033;
        Mon, 05 Jan 2026 00:23:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF+toNYrDF1foh7qEGgsaPaQu5EoHgXBV6IY+Dg2iZDwh/L3E0Nw+HN1rJa40DHNfa5Ktydrg==
X-Received: by 2002:a05:6000:2403:b0:431:35a:4a7d with SMTP id ffacd0b85a97d-4324e708fe3mr58459566f8f.58.1767601381336;
        Mon, 05 Jan 2026 00:23:01 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa08efsm99942627f8f.29.2026.01.05.00.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:00 -0800 (PST)
Date: Mon, 5 Jan 2026 03:22:57 -0500
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
Subject: [PATCH v2 02/15] docs: dma-api: document
 __dma_from_device_group_begin()/end()
Message-ID: <01ea88055ded4d70cac70ba557680fd5fa7d9ff5.1767601130.git.mst@redhat.com>
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

Document the __dma_from_device_group_begin()/end() annotations.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 Documentation/core-api/dma-api-howto.rst | 52 ++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/Documentation/core-api/dma-api-howto.rst b/Documentation/core-api/dma-api-howto.rst
index 96fce2a9aa90..e97743ab0f26 100644
--- a/Documentation/core-api/dma-api-howto.rst
+++ b/Documentation/core-api/dma-api-howto.rst
@@ -146,6 +146,58 @@ What about block I/O and networking buffers?  The block I/O and
 networking subsystems make sure that the buffers they use are valid
 for you to DMA from/to.
 
+__dma_from_device_group_begin/end annotations
+=============================================
+
+As explained previously, when a structure contains a DMA_FROM_DEVICE /
+DMA_BIDIRECTIONAL buffer (device writes to memory) alongside fields that the
+CPU writes to, cache line sharing between the DMA buffer and CPU-written fields
+can cause data corruption on CPUs with DMA-incoherent caches.
+
+The ``__dma_from_device_group_begin(GROUP)/__dma_from_device_group_end(GROUP)``
+macros ensure proper alignment to prevent this::
+
+	struct my_device {
+		spinlock_t lock1;
+		__dma_from_device_group_begin();
+		char dma_buffer1[16];
+		char dma_buffer2[16];
+		__dma_from_device_group_end();
+		spinlock_t lock2;
+	};
+
+To isolate a DMA buffer from adjacent fields, use
+``__dma_from_device_group_begin(GROUP)`` before the first DMA buffer
+field and ``__dma_from_device_group_end(GROUP)`` after the last DMA
+buffer field (with the same GROUP name). This protects both the head
+and tail of the buffer from cache line sharing.
+
+The GROUP parameter is an optional identifier that names the DMA buffer group
+(in case you have several in the same structure)::
+
+	struct my_device {
+		spinlock_t lock1;
+		__dma_from_device_group_begin(buffer1);
+		char dma_buffer1[16];
+		__dma_from_device_group_end(buffer1);
+		spinlock_t lock2;
+		__dma_from_device_group_begin(buffer2);
+		char dma_buffer2[16];
+		__dma_from_device_group_end(buffer2);
+	};
+
+On cache-coherent platforms these macros expand to zero-length array markers.
+On non-coherent platforms, they also ensure the minimal DMA alignment, which
+can be as large as 128 bytes.
+
+.. note::
+
+        It is allowed (though somewhat fragile) to include extra fields, not
+        intended for DMA from the device, within the group (in order to pack the
+        structure tightly) - but only as long as the CPU does not write these
+        fields while any fields in the group are mapped for DMA_FROM_DEVICE or
+        DMA_BIDIRECTIONAL.
+
 DMA addressing capabilities
 ===========================
 
-- 
MST


