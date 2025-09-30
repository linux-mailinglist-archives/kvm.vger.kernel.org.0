Return-Path: <kvm+bounces-59073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 90764BAB4DE
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:15:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8B187A6006
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 328E81DE89A;
	Tue, 30 Sep 2025 04:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HOGg9XiT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8333C24DCFD
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205708; cv=none; b=P3ckPkcmn4KucE4euTW4xgr/Wcv9D7vzcG99vNZIW9wHgRPcCDGH21Txz4csTm2BTLxwE9nhZ0HUsiJhHLzT+ehhASTtAMEK3UW4tExj6Nwc2ZeY/jv0WWUIX4z8VtGmqpRUiqU2d09nYt0WwBoHQrIe5/YR0+n7dl+LvpI9AXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205708; c=relaxed/simple;
	bh=rJBut976i3Ontg0yP5OFR3vymw9qTwDePmzxvo2YQCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YBYGcie/7UUog43y1dUGjS9CAQKibyW2b6camEIpx0Dgvnd061tHcSXs2Lc8JfpGzySEX+ho9JWJmiCsx65VKZul6pCBoEjvWcLM+hjswwhGRLKNY7VTioEAgsPAswVuu3UPKdLlnRoNIpTCZWIiA+ptApmX+AJ8a7PdaZFVOy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HOGg9XiT; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3ed20bdfdffso4418740f8f.2
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205705; x=1759810505; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MBpejQiq0e/vydo49FSQoIaJ0P/BjZpeA7dR40L/9NI=;
        b=HOGg9XiTvIveuhjmL62y+5X7V5DJLXmIyiwOP2DNKPxoyDVANM+KZBQfrKZZFajEz+
         w7I5UqCqYv/gTZGrk/hhz9TQDB/MRze/2D+uNyAEtr5Ub7rtCklrRgEpsrlJbMBRr2ud
         ih6dE8LCXn0kdPFK7a3H9Stkfj6tcgiMmPeW9n9Bpp1NMZM94f25QDN5FzJAJkonru5Y
         3IuoA5pUZTlKJJWe74NHGJZ2MN2ttgAxGvGaZCwe2+6wmvD2rxSOZ6f9RHPQEfUFvmo+
         eMZDrHWUFpm2YipGnCIBI0iDxdjcolXn+tOIY+2fkOj9WEiezrr2pg+6JJYlEdKyIpaS
         eM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205705; x=1759810505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBpejQiq0e/vydo49FSQoIaJ0P/BjZpeA7dR40L/9NI=;
        b=P9b9PvGz7+FZe0+lF4GJH1xX8QQogE725TnnwqxWhYtIRWCyvyg6lPOThxs4PAqt5/
         InbwKOt5TJWStYg8gTIzweZO8EMYmLAZ4rhj8m1HXrVKDz9aKwb6GsKu+tGQ2n5QBvG/
         qJ/h5VCcDE7tW01v7QL7/xKDZy17xmtTIbTrjJDRPyEKrlRO6aZlRLRTcdjGArktNtuS
         ptUC4OXVIalGh5Nl/nkQgdRiqIYAuiszg2H5MqsUPQwrGmwFVCsBjVjErRFYGXb4Cgf2
         V/hDdNqt0xVQRSdYwHSMFOpYHOv+al/FalI/YzdjkAfxx9xpaglP2M6RF57md6NO/bVp
         8QrA==
X-Forwarded-Encrypted: i=1; AJvYcCUB3gElLf0UHDx47u0FcSw7o599BTC32tD8Edc0x+pZg8F2Ow0ivx3c57xD9GIMwP+0lQo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIamLsrV4phYJ8AIyarh8CCIZowao0rJ/G2MwFmNXdbmdJTmn7
	lXUsRtARuZ/Hd3fhn1USlIVf78AiPYb1ZYcNYAkjRjRTrJDKpwUfJvhmbvoP4OmrlVs=
X-Gm-Gg: ASbGncshMeTp5dfEFtCnOTNnBd5XegZ7oIBiKipGZB6yn0zFvuDGo2LVBiyfpezJ85T
	Fm7+Q4GAwTlx5uq03LfayABP5KtuC75DgVQENqTw7HJS8yvg19FxiDwf+GbXoUR4O4DYwfHWLto
	H+2LbYij2hKOIpgP2lD6OyUElCtdYdBbH1eeTR+LQn2VpnKioxp/PzjluOMEHc/rlFX4ebu4sId
	XWMEdD2VMOTbkRnIuuW/k8N05apq9NzrraluDu4aeX7yIWLfJf2Ixcr7fnUOfEvI98/UGiIl6pt
	WXfXx8Xmr/tIh2MOLS1trUcz/4+9kArhMUhidyah4MNW3ivSol/miQinCYPKqyl/IlZ7DicoS/L
	zBCo5eoaz8TU3ZN5csFndCT5nrJ6dJRYh/skTCsEkhfHLYaS/LpaEPpd9/TPFuxqugEs4YFPMxF
	fmhImMkvsexj/fYKikV0gim2XYdsiakUE=
X-Google-Smtp-Source: AGHT+IGgqJ0JuJ77y43D9HwYeERomJh5OkTJMDKGyPclR/IBy8JcemLZxj5L2abT5KLJLVAD5Z41ZA==
X-Received: by 2002:a05:6000:2385:b0:3da:d015:bf84 with SMTP id ffacd0b85a97d-40e481be8a9mr20254181f8f.25.1759205704783;
        Mon, 29 Sep 2025 21:15:04 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-410f2007372sm20002659f8f.16.2025.09.29.21.15.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:15:03 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	Eric Farman <farman@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	kvm@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 16/17] hw/virtio/vhost: Replace legacy cpu_physical_memory_*map() calls
Date: Tue, 30 Sep 2025 06:13:24 +0200
Message-ID: <20250930041326.6448-17-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930041326.6448-1-philmd@linaro.org>
References: <20250930041326.6448-1-philmd@linaro.org>
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


