Return-Path: <kvm+bounces-67023-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ECE63CF26BE
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 09:31:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CA6E2306B789
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 08:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01305329373;
	Mon,  5 Jan 2026 08:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZGXcGOjm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RWZ1fXc2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A58328B70
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 08:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601415; cv=none; b=mtRDkuqHND2ITYzdZZ42cFkiFMIjrGvp9iMOYQ4mZ2Egz9D6E1QTJm/dsbj/DOPmP2PYcxApFhKkoch8cz7CKRWu1lHd8AHD0P+hiRTZ3Exr753KSKe5Rx1e/MONGsu25ULrDRGdPVhVohxUElu0MBKyqzsd9qotNYgAHfBl5GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601415; c=relaxed/simple;
	bh=yZFREYe+kB50ig8I4QfoDGYH7fn5mVvqsTw8oxG1/Z4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j0nmFxhPa+2zW7gjlkRudX7T+ezh0Rgk2bbLSOZKj6N4PxxTP51/TbSiQY/UTCGd7XNXJUQwwP+SvXou96NEL/mjVhXkYjCZBw4aK/6kKWPublkjqoHA8VbXMEFvOozw86yJ2ehhTiGwGkd+rL/a769IbYPExpe2+Uu7K06xXHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZGXcGOjm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RWZ1fXc2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767601412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WFAlf3bglsAJtkYzmv+ft5xqaztKYGlID1/+YOBMr0o=;
	b=ZGXcGOjmLeGWkx/FvHO8OG4Ix2VK+O/U+h6lTSg+bUIDJIqrYivt3bKmKOd78wkGT14jKq
	cJ+MU6jtIuvVOCQJ60me7U3zrveQ8w38odAw7T8//11WcJLnkd+M8QMUN1u2LMug7PmCAL
	2SHcXDsZ+3ve3JPQJLxFe+CgDnoUww4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-yx0o_xU_PQWMnW9rGBce7Q-1; Mon, 05 Jan 2026 03:23:30 -0500
X-MC-Unique: yx0o_xU_PQWMnW9rGBce7Q-1
X-Mimecast-MFC-AGG-ID: yx0o_xU_PQWMnW9rGBce7Q_1767601410
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47918084ac1so120298685e9.2
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 00:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767601409; x=1768206209; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WFAlf3bglsAJtkYzmv+ft5xqaztKYGlID1/+YOBMr0o=;
        b=RWZ1fXc20ZkPKj+99fWUwuXo/equGaNjQgbzREfCka0FOX2uIqLLuxl+O9HxLpwj2C
         iZG/W34/ARlm0hd3v9K7r6YnDdrsAN8qcmZQF+V951BjWru74fplmVNXqLEAqwpri6/5
         eIEsQP+XV9aMeQokdFniLjl4ugZGFQzJNHtIeVLtOroKt8HACZ3giLnI6AA3V26BdTwc
         0wEuTJ2ZwZvEblT1B0TAQUiq3V+oe+8PlUYmu92jVdhmn2z7nmZZPQ5C0IDA8vXGYP0y
         RPoKUQFVv/MZFhxuivyuaTJWNJ/Y1C2ie6leuq+9E9ZLMOlzC0G+RyGG2WDSJW41Zryt
         ki8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601409; x=1768206209;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WFAlf3bglsAJtkYzmv+ft5xqaztKYGlID1/+YOBMr0o=;
        b=i/yttZVxIZ1HwdiuHdtWYNABDxFdQbbnD20UWlxxRkQ+/ZpSND2kf0V4bI/GohKDOh
         nODYwf3EPdBOYm931oUSZWo3vYcbm673zhSPIP7y8fFJDlTedLyGpvCPx06zm3AB75DS
         KMCdFUd4W+t1OMMJpYArcJQcXmnoQ6k1vPrvIz3C2L+C09Mm9swWpAWExw7TIcOSCRLs
         rQGwy40gD2jVIaHFMxBPnneiFVS8evMsBhSpdw9mZuRCEW+hFrqq8JxUsVryGjCVlMyZ
         x5BNaGAL0Hw2PD+ecqqZ9lCduIeeYIVQah9u/0/EBwHUxfMMtlY1+CoQJwhw68SwWwBP
         vj9A==
X-Forwarded-Encrypted: i=1; AJvYcCW4CY1l/cNKHWTQqc6gQyI+LOoNiHgFHhNy7f1cuq/jzYiB3/48QqVlwV4MGYq8dxwmi5o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWBeYGvC5/8VGt84f7fA+kkjCQ/MZM9ilbEK/xaY6ktEtjzDwR
	kxyqoZUvwDCZ57EZA1+ZnYbQuv3UtJCGUg5m7Z0m7xsmLdpfZcEzA+JKQgCCFD3C8j/f9Lppou/
	UxEo1E3rMey1Wp5L/5biGhljYqMtDYUQAH0zLyveUHZzJNYCyhiMTPA==
X-Gm-Gg: AY/fxX73REOylX89irmDfD+mXsahinsGxPQ4UGv8gHfZQ+OJhjnGH/yQZaARN7Qz9Iv
	brCXyERGGpNni8yelR+AHpByWBvBiG4Zk7mALy5MfilymLcPTxXGbSfiPiPGTJq50twKXDV2vyl
	ge4nRTqUOEm9/LeyqwVVE1tyCC68h/RZXexCUO2jBmG8J8+hSdIHqMDqR8h7uV4BCQ+fccGCoJO
	0Ucqks3h+RgE3KPfRJ4KioU0ZfXGqUx10JfquifgWp3OvXr7t6x5C8ZQszvyMDh4pXlOmKXbtcI
	FGwL5eSTSEL60l202bk2VnaXOuvo8rGI19XvJACsIshpqUsf9kcxUQuKBWcH+o8grtbiYbTYLvZ
	YtBaMSjt41qnuRjeoPhNnZmZ70HTkKu/Qqw==
X-Received: by 2002:a05:600c:4fd4:b0:46e:4a13:e6c6 with SMTP id 5b1f17b1804b1-47d1958a43fmr573308365e9.19.1767601409527;
        Mon, 05 Jan 2026 00:23:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFwNUq77RyeyS0obHX/fGtVMqKrfm8Lk7lx8bL3zrRbRdvbJ0vPOnUhK5sFwtMU1HFVUtXhCA==
X-Received: by 2002:a05:600c:4fd4:b0:46e:4a13:e6c6 with SMTP id 5b1f17b1804b1-47d1958a43fmr573308005e9.19.1767601409047;
        Mon, 05 Jan 2026 00:23:29 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d6d145162sm142697615e9.4.2026.01.05.00.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 00:23:28 -0800 (PST)
Date: Mon, 5 Jan 2026 03:23:25 -0500
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
Subject: [PATCH v2 09/15] virtio_input: fix DMA alignment for evts
Message-ID: <cd328233198a76618809bb5cd9a6ddcaa603a8a1.1767601130.git.mst@redhat.com>
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

On non-cache-coherent platforms, when a structure contains a buffer
used for DMA alongside fields that the CPU writes to, cacheline sharing
can cause data corruption.

The evts array is used for DMA_FROM_DEVICE operations via
virtqueue_add_inbuf(). The adjacent lock and ready fields are written
by the CPU during normal operation. If these share cachelines with evts,
CPU writes can corrupt DMA data.

Add __dma_from_device_group_begin()/end() annotations to ensure evts is
isolated in its own cachelines.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
index d0728285b6ce..9f13de1f1d77 100644
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
+	__dma_from_device_group_begin();
 	struct virtio_input_event  evts[64];
+	__dma_from_device_group_end();
 	spinlock_t                 lock;
 	bool                       ready;
 };
-- 
MST


