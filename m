Return-Path: <kvm+bounces-59120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 052EDBAC019
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:23:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DE2219267DA
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 105B22F3C27;
	Tue, 30 Sep 2025 08:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cW0fl6qJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F28B2D24B1
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220586; cv=none; b=ZBPfmV/tvEadsVxTFApRE8euqIxrmpzQrh3QSbtda5eicpJcTdyBq4jfKxlnbapM+KiBXK4Z0NgD7/Y37YleCZ6bSgmC8RVFXO2xFWWvlvCINnn1O+wpyzf9BoNdJ11wEqF5aHC76W5RyCW/Szm9aKx7CuPRyAJoY6ldkw9nUAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220586; c=relaxed/simple;
	bh=T+L3E1Gk1UKgHgjxhp8jcqrJsC8wXS4f8+0d4MDwT2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gm4acVm6kToNz7epSlwSO68JHOII4ZgqtThSXRzOm4PSC3d6dRl3Ajb6YePIIFluZnpMNliHns2fF5dD2jUVmv0cXFbApOEjFsmSZZF5mZU3Wo1qdJuuaVVsUU6K9YjB1dmP07l1FFLEyzSotVulb/qO/J9FRC9kiyEbZP9YBSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cW0fl6qJ; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3ee13baf2e1so4389326f8f.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220582; x=1759825382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=72P8ycFgSBQVWBZ3tJbVWDsHTvBRP8LSmdHVD/So9uo=;
        b=cW0fl6qJNObHn+ZPvdBvFR5Olu9lCZzjplUplsDfE78LwxLLb0HYXU66g5/KCWt5Es
         ygm+Rh9+ZGyTNhi1/KW6PxG4iLOHcwJsjvQ9/vl2O9tADEwstDtskOuzAENximyuewzI
         8UsVgvr3Dx2Cj1MIcXi/a6147l7N5tovBBnHIj6pzaBy2ZuwRqTeyQY+kRs5J031JjZk
         3ahVCAr2MiPURFnCuuVgqpHt9+tZ+93GUQ05s+kspi1ZXriRVR1f/sYcy2jqJDtp8yV8
         +hnN/DsRtvy/9IMr+YMwbOqcOakEaZU0HAhej8oxE0cgDImyDwFxP8asjrfS99QNmuCE
         H99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220582; x=1759825382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=72P8ycFgSBQVWBZ3tJbVWDsHTvBRP8LSmdHVD/So9uo=;
        b=s73LMvIczkeNoDAOaE1Vi8grmWVzjNgvF5YUliaPqZSsYUBYMWzSiwZvvJJSOzcZIK
         +nWHOc3Y/TKbE+0otpMmWKglC8GHs7V+WlVN0TIg3HiUcp7X9QtQ/PevMvFGuo64FT3P
         sFnMAZYOkanIy6L6HK1IIFHOKlOtjS2rsg0BvYeQn+spQW0x4AaQ1aBBqvb4EjhJdUIT
         gYDIernDctllpUlBD5pT4naXrhpHBn2pSNvXf2/2f4GQDXeovMMC608rHuhlYg6arE0o
         vdNdL98LY507LZ+AmsJilXJgu4IMM1h69AxDQ8rpq9S+19s0prFc0ci3sMpMCMVLg8PC
         DKqg==
X-Forwarded-Encrypted: i=1; AJvYcCUpSDU6eK4nF/K4yyz1VwtHcZ6J2hVZlG/80SytBNsz3eFg+O9zrTLSuvuLUV4URkNOZho=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSq/Nmy80lUeRGHlbYmo/Xed2YxeCzGL9dXbDMu7LITDSpYzL2
	HhfvfJ1sj5ucZ+5j3tgdH2CmgIIeztbcMY4AwkVZwIbXJKCpLcRVogLGoLUM95z1qiI=
X-Gm-Gg: ASbGncsq7A8Dln6wAwE8hGTK0byF0wQneeRdvzfalSwgTv3TsFar/2ghDcd0AFWM0do
	+nUoG/U6oMjYa9CH21bYDSC6Qw/Gh7hja/FpjcEwIXuI8PKHuK08r/jp3fPfRgdg2SjtHG2YahH
	XSS+wTCB/CJNLNT5UT1rGdktEtpWZiHAHiZBUjklwwmYj13BtIhS050UWq44yI7Zj9cusimRXRi
	5ZDyhHarwk0AoCZbb7/HtWr4Pa1zrcR9J5iJVYC9bEIm7IpEbMGLKvn8jy8cgYqdh/LvgIMfab+
	ec9FVHYzlwoQgbPUQO26nGXlabcjcEeqEfhbQdx6OBvhRZG+NqVhv4crdIHa62G0JWFgw42IHJ3
	b/0MDeGh6YK8YJfe4V+i+vm1vJtJvSoYU6fzUImD6RajfSkpYdF2DkHfOypy5PdL95sA/YG5Xk2
	ZoczbUHz27HHJ6uzFfa6Sz
X-Google-Smtp-Source: AGHT+IG0fDZU6KltrERn3higtjD7tJ2dh/0k92N8Tps8ggqNo2HbrRNaueeSukMTmfKt9k8lWLLnpA==
X-Received: by 2002:a05:6000:3101:b0:3e7:492f:72b4 with SMTP id ffacd0b85a97d-40e4be0c940mr16811180f8f.42.1759220581872;
        Tue, 30 Sep 2025 01:23:01 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72fb21esm21742490f8f.7.2025.09.30.01.23.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:23:01 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Stefano Garzarella <sgarzare@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	qemu-s390x@nongnu.org,
	Paul Durrant <paul@xen.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 17/18] hw/virtio/vhost: Replace legacy cpu_physical_memory_*map() calls
Date: Tue, 30 Sep 2025 10:21:24 +0200
Message-ID: <20250930082126.28618-18-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930082126.28618-1-philmd@linaro.org>
References: <20250930082126.28618-1-philmd@linaro.org>
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
 hw/virtio/vhost.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 6557c58d12a..efa24aee609 100644
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
+        return address_space_map(dev->vdev->dma_as, addr, plen, is_write,
+                                 MEMTXATTRS_UNSPECIFIED);
     } else {
         return (void *)(uintptr_t)addr;
     }
@@ -466,7 +468,8 @@ static void vhost_memory_unmap(struct vhost_dev *dev, void *buffer,
                                hwaddr access_len)
 {
     if (!vhost_dev_has_iommu(dev)) {
-        cpu_physical_memory_unmap(buffer, len, is_write, access_len);
+        address_space_unmap(dev->vdev->dma_as, buffer, len, is_write,
+                            access_len);
     }
 }
 
-- 
2.51.0


