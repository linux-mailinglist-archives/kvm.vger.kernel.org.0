Return-Path: <kvm+bounces-59040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC62BAA50B
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB5EF1922813
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:34:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDC4823C4F3;
	Mon, 29 Sep 2025 18:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jfPsH0hW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6620874C14
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170857; cv=none; b=NEZtM5Bd18UzSjnQDeZNfREqI3DVUu2NCiOrEkCn08egDv0qYg0qC1HIUme7LpcI3kabH+LhXQL3ywCzjNXUhItYCn+FTnso8UDv3+zJkkIRgmwV+5QZaoqLuflP6/Ipc2DElKb1Ajcw/rxT7rhruL0TxGfO3CRigi8IaHmzZoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170857; c=relaxed/simple;
	bh=rJBut976i3Ontg0yP5OFR3vymw9qTwDePmzxvo2YQCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QzQYadl5hVGa3vNyJuyYBbuG+uwuYGXAxzYnJcEmihuwRRk51AUjiKTFfwl5sy0zrb+vRInONO1O9mHF/hR+IfNiLg/ybP7cA2PGgxFDgBRiqkzJgNRcoaK9vyZQnBUdZcWLD87aX3JF6bFWoy8SFU23kp4cGMYvcBWU2tjBhPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jfPsH0hW; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4060b4b1200so4557841f8f.3
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170854; x=1759775654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MBpejQiq0e/vydo49FSQoIaJ0P/BjZpeA7dR40L/9NI=;
        b=jfPsH0hWje7QWHX6UzwgzLOtJIhamO5dkSzF+4i58ioJQNtFoWSrhifsKMjq7/NAwm
         LagqeuPjh4VeLQ9Mz6HDab/nG+XexSJtWiQhgJJWP0kVauvvXJkzB5aAvXJWmP0kAzsd
         JpYNWD7Vfrkjw+cdiXNg8DJaKYefBMaJdxyii9CfsBKckH/0h/FFcC6u8sAOJq+KGnL1
         u0PLPzc5VLK8MFmqwcczfFfbT7YyFBkXi0LUZGcg/wZMCp9Yd9jSA3ETkrMdB1T+rsXz
         obCAntX6qpC9alcriHpuNOH0fsDOAwo7nG70rZpwlQzxW+wtj4fJ2dmXeqK5x5Lsck5B
         nSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170854; x=1759775654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBpejQiq0e/vydo49FSQoIaJ0P/BjZpeA7dR40L/9NI=;
        b=Uq4g2IdXVMsUHCmPv+HG8YQcuFkOyN2sgUa3guEZLfoChy4Oig9VGPKmYaVKZQKMOI
         W1SbbDz1EeN76C2PLBL9PRwHJf4xXTJcScTOwRoYNyzBRzo6D79nabNPJKGhyokcn5mM
         dfaefYdTevIYoeeLPw61/Robhkd6ZM4q16oy1kfIdQmQr1n5ZTui9dVYSp8A17iAsOMy
         O0fo7PcDbZ+tJpzCJ9CYM3Vv5CzzYVM4BRd/dVht3lLiqveTAVxxnH9jU11AIz3sVhkr
         gKKt9W8gi7gs48HZLXA+iX1io0L8zT9RFXNQHjQb24gWQLOnfileTuk9afLpw+HFUcFj
         3DWw==
X-Forwarded-Encrypted: i=1; AJvYcCXN6qNOmz31rJQC1RPsm5AG6GD8O5xHM2K4R4/tMfKVDBz4s9ZQmOV8BhpfYfoKBY8swG4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyC2SXoZrIoFKTEUBKHdNOA1HvVghG/zddD3AU7ClPG8fdSaowf
	RpplXjBwEP+c4Vx4mpgonmPyUb4bUepPPZKZgvLfJJ968B/XcVZsvb5tvTWi9V0PGnk=
X-Gm-Gg: ASbGnctmA+zm824t1sJn0wJsaBPtLgVCx8yXSYWob9FaXk2GTB3wyaFS/kGxvME2sLV
	0f2gbNtk/d3fizDrxUXPY0ILdoan3EwJEOFGqtKnlr8RTKzQbuGVP/ySDkYpbtE/3xHqVzVeb9h
	rHrRwcexCfZfXNBvP6OWBERgBGS6Ei7Y57NCvKlbs7JJ3IPvvvRQsJ+kHqOgISjIFI1sHZbLZTO
	mUfRkrMYk1m47S3ZLe/OUMjRP0ohHafnm/tUPEkuBA31q5bBPYYJ4rFvHqpjJfp8ZY0xiLOTZ+1
	/k+WqIsZ0RppttzmjRsUXKx5etE6e0CI8EOsz+VPAuFufRUBFPcGqywOBA8pPxxPyQ1zND9/SHN
	XssqYl+FMhSJqrH53kf8ZbfRM1YCzsIqlrzqlskTjgCQ66J7Xiaffmv5GBLBnaT6akzBz+kNDag
	c85MoqMSc=
X-Google-Smtp-Source: AGHT+IGDdDVnNCTQHNmf7VOOiV8zymTG0ZaCom+HQXr9Sc1CkJ/8s/f399s7GfQrqulF9pKPADkmMg==
X-Received: by 2002:a05:6000:22c5:b0:3ec:d78d:8fde with SMTP id ffacd0b85a97d-40e4ce4bademr17302303f8f.44.1759170853668;
        Mon, 29 Sep 2025 11:34:13 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a7c8531sm237281965e9.0.2025.09.29.11.34.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:34:13 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Peter Maydell <peter.maydell@linaro.org>,
	qemu-devel@nongnu.org
Cc: Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	kvm@vger.kernel.org,
	Eric Farman <farman@linux.ibm.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	xen-devel@lists.xenproject.org,
	Paul Durrant <paul@xen.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Anthony PERARD <anthony@xenproject.org>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PATCH 14/15] hw/virtio/vhost: Replace legacy cpu_physical_memory_*map() calls
Date: Mon, 29 Sep 2025 20:32:53 +0200
Message-ID: <20250929183254.85478-15-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250929183254.85478-1-philmd@linaro.org>
References: <20250929183254.85478-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Use VirtIODevice::dma_as address space to convert the legacy
cpu_physical_memory_[un]map() calls to address_space_[un]map().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/virtio/vhost.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 6557c58d12a..890d2bac585 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -27,6 +27,7 @@
 #include "migration/blocker.h"
 #include "migration/qemu-file-types.h"
 #include "system/dma.h"
+#include "system/memory.h"
 #include "trace.h"
 
 /* enabled until disconnected backend stabilizes */
@@ -455,7 +456,8 @@ static void *vhost_memory_map(struct vhost_dev *dev, hwaddr addr,
                               hwaddr *plen, bool is_write)
 {
     if (!vhost_dev_has_iommu(dev)) {
-        return cpu_physical_memory_map(addr, plen, is_write);
+        return address_space_map(vdev->dma_as, addr, plen, is_write,
+                                 MEMTXATTRS_UNSPECIFIED);
     } else {
         return (void *)(uintptr_t)addr;
     }
@@ -466,7 +468,7 @@ static void vhost_memory_unmap(struct vhost_dev *dev, void *buffer,
                                hwaddr access_len)
 {
     if (!vhost_dev_has_iommu(dev)) {
-        cpu_physical_memory_unmap(buffer, len, is_write, access_len);
+        address_space_unmap(vdev->dma_as, buffer, len, is_write, access_len);
     }
 }
 
-- 
2.51.0


