Return-Path: <kvm+bounces-36104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 58953A17D04
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 12:29:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E07A91884BAB
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 11:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC4C31F1505;
	Tue, 21 Jan 2025 11:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CDxobOKJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33921BBBEA;
	Tue, 21 Jan 2025 11:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737458942; cv=none; b=gb4ByQ23NmRUsMqZw4nj9zf2W+n1L1YF62IaEsVYDF+U1Cqad5EGO24KzkHmq6StRhR2dSDfI+HdukA4mK+m745fdTDG8YqQya0OqhDFQlkNRKl6FOgXAdLKe1MhFD0/Evhmh8K7zg+6QGNb/FLJ/0T/poQ9knJmJ4p63aNXFPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737458942; c=relaxed/simple;
	bh=Bo0v5aRaDzPqvoydQcrBJPn7q9FSqKp9DJF3+UnQwoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlgI6Bwb4fFJNi/C2iaRHIgw1WyPeI8iokLl8fJ3oSTa7xyoNn/mliW38q9AvEonFVD9AwVYtftoYcAgsRFxIxITbS6+KiuX1T8F5ROpM9cr7bBbH7LtMTW4+6ZEa0DjmQmd+T/h1/nyhOWbQe003qniidpAInqJDF4/HcosRys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CDxobOKJ; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-216634dd574so62665395ad.2;
        Tue, 21 Jan 2025 03:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737458940; x=1738063740; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g5a4wofP0E6vgMXtYk2R7pF6NDbjnXiV9YnBTUjkP3o=;
        b=CDxobOKJtfv4V+mCIBS3xqltUGeA1oCFT8hjrKCYKfcdwm0+NRJzDgycBdtI02S3a/
         9ZpWIFlqJwTjkXTfGP0TrKYaiP+TZSq0ihimQw+yiiG4CFM3By7+Jvsm3TpqimayxZPb
         ylt94KBt77c89PY2yoHyMN0T+3LH7viCbuf2vKU1AR+YRCjSVt+ZqHdCoG1RCr+0/Twe
         otAX7mtR+AmbMtNt+eG468C7no5yYoAj9p2o581kkNbe/rFkFYUhOUEI2P4qbii+O5ia
         malcbQkB5wGAeaOsanQnc/eQVesVyaakD5oEh+NbCVCVk5ZT2v8s+z51qmcCL1nccPRx
         sjTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737458940; x=1738063740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g5a4wofP0E6vgMXtYk2R7pF6NDbjnXiV9YnBTUjkP3o=;
        b=jHJgZCmazTVfuSywAkRLJ41LGyQM+p2oGYI3YS8deGZJCeKETO19JXXh/1c/5+lxad
         oFL/ukCsAIUQjYoigWVbs36qXZQhNrcK8xcs+atfNL9R7zFBOnQ+eeEmwHxsA81ZSCZ5
         qjoBCeKSiETmNAZD74uKQtzzGzYdI45CV0BS7l7c/z/zrIRZQ1x7lxeAHigM+8tcYPtn
         nNQJsUS3b28/0e3WPjFo13i8jkj/ZyguHKKjZPbtkxV1q+XoXKEblgOOyAHw1dL1L29Q
         I1vqICAplCpkO+J28/UxLXyEbKpBQqrFUuFhtQ4wv+tPoYARjmC0Qv0B01ZcneqUOMfP
         LZnw==
X-Forwarded-Encrypted: i=1; AJvYcCV+2NdTUneUy+feG6jTWz2gkXDof9jnUvopvi0WFBOUmOOiUkt0T9oieangkh8w5L7XUtg=@vger.kernel.org, AJvYcCXeJT32mDd/dcznku4f9U04ash1R2UdJGqbC8uN5RhsH22zgVGh8Zr9mFkgtyYMFzq8O+OTZcyGoqx2W+Es@vger.kernel.org
X-Gm-Message-State: AOJu0YyU/RxISh56lEum2fhbeGgXW6QQTfRstaHHoryAzLQDrnhk+QBg
	kVaSgaZz9L0B5tgMW2vkANwcO9tknwoL3LprL9j/BqAu6Ce6mGVSiV10nQj/ogY=
X-Gm-Gg: ASbGncvVxb2U+WBLrW4NoTaPL8QzSVniLqh8Uo9kDv+0d1PBo5DLjFaaxYiRtof/jlT
	iqEY7Tx17U9kxgNdetgEaSKqJz6lZAXsoQG80Cm0pE+IDQ+/bjuOK/A3qZ+g1jpXI92Xm7x6YOK
	z+k4Zcy2LUKYrXdIz4MAScjfQelPUd3Ww1/uSWFbhz0quirqoImLTstpytzSBrcHcRfCkLkwSoH
	VIey+eryXWrGBUxzHcLnG4sA7Ta3g879/e7gwmJbwssE8YUU30Hy3LDmNQIJorfio2gumXxf4+p
	+r+0C7/Q
X-Google-Smtp-Source: AGHT+IEnO0MUrq69t5u503b7yFJyykRzPXOMC4CCZR6vu5qS1x/UI2lZ7qnZuoxHX4BSZoPVYb0Xpg==
X-Received: by 2002:a17:903:8cb:b0:21a:874e:8adf with SMTP id d9443c01a7336-21c355dc4eemr248202715ad.45.1737458939824;
        Tue, 21 Jan 2025 03:28:59 -0800 (PST)
Received: from tiger.hygon.cn ([112.64.138.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21c2cea1fdesm75385965ad.26.2025.01.21.03.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 03:28:59 -0800 (PST)
From: Wencheng Yang <east.moutain.yang@gmail.com>
To: east.moutain.yang@gmail.com,
	alex.williamson@redhat.com,
	jgg@ziepe.ca
Cc: iommu@lists.linux.dev,
	joro@8bytes.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	robin.murphy@arm.com,
	suravee.suthikulpanit@amd.com,
	will@kernel.org
Subject: [PATCH v3 1/3] uapi/linux/vfio:Add VFIO_DMA_MAP_FLAG_MMIO flag
Date: Tue, 21 Jan 2025 19:28:34 +0800
Message-ID: <20250121112836.525046-1-east.moutain.yang@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CALrP2iW11zHNVWCz3JXjPHxyJ=j3FsVdTGetMoxQvmNZo2X_yQ@mail.gmail.com>
References: <CALrP2iW11zHNVWCz3JXjPHxyJ=j3FsVdTGetMoxQvmNZo2X_yQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The flag will be used by VFIO to map DMA for device MMIO on IOMMU page table.

Signed-off-by: Wencheng Yang <east.moutain.yang@gmail.com>
---
 include/uapi/linux/vfio.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index c8dbf8219c4f..68002c8f1157 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1560,6 +1560,7 @@ struct vfio_iommu_type1_dma_map {
 #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
 #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
 #define VFIO_DMA_MAP_FLAG_VADDR (1 << 2)
+#define VFIO_DMA_MAP_FLAG_MMIO (1 << 3)     /* map of mmio */
 	__u64	vaddr;				/* Process virtual address */
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
-- 
2.43.0


