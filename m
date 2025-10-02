Return-Path: <kvm+bounces-59419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BCCF4BB3596
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A956916BDEC
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 990362DC780;
	Thu,  2 Oct 2025 08:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k4ihuOBt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B697D2D7DFB
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394610; cv=none; b=exjfkxENv1OB+u4diDZQF3N9wtkbEg9O1tDypnHI1Etj++4n75ovpTjBvxEmE56UlVc7toY1lm9wSGGIThFI8kwRtOpIbvBC4bV/TwMq+PDgBY/oDH69fBxY5+hOllZpH2GiWm0NUTjHlfy1/f2p1fpAP/U1/SG1uj+tvl1ajFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394610; c=relaxed/simple;
	bh=Z/NE2taBiV5wsH3JcjmWW0tO1e/5lrJjuTutFIc6dmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NuDvI33I5B0+tYuYn9Sw8+SDi7GXhanOJRRw4g0ftys9Fr55FxmXjwKSd+C86IH2f5uZramDMhE7yrb++a4sKudWsvd71lu86NSYIlJ/jHVW8uiLYKykbe4fIHkIz/pQqRzNksPdPl4ZIHNm2rfcfdtp2qy2xR3AYINIalNAJlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k4ihuOBt; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e6a689bd0so4140715e9.1
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394607; x=1759999407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sizE8fixTdjMLNdHvH96mSdoNGp/FmemDWUp22VSw54=;
        b=k4ihuOBtoexWlBSWbeWSFrAuV4voAYDQdwMUkYiaOzMEg3Jt3fsarFLu79P8yFcxh4
         fdKx+qWzfJxVWvxulK4VIgwqCJIjhryoTSHrzlORCbl9rVpC9+DdBXjT20bR/grMdmnx
         kRYbNoLdh9u7KcOmVjBWgrYDzaq9pQoUzRfPP2fDdGukF366zqBFVWieowJ7/DD+yxNJ
         us9RLSJqFG9o8XkNO88H6+QETwBCuUC5o8BbJx/THZ1nUCI3BR47DSjtb6zLkJXTDBMX
         JEmKVc3k8F6TgxwgoCgeVUi4vaVm28BOwBBqrKNqihBFBh/PuYQIGlRPVwML0DB1dUVh
         SEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394607; x=1759999407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sizE8fixTdjMLNdHvH96mSdoNGp/FmemDWUp22VSw54=;
        b=NLJoQ65mQPk3Y+14iFM2d4AeyaKLtwHUkYZ1Ea3yL4hVN7J/EtRPBN5IFcSDCbetmu
         fs61muhCtn1rx2hJDyEhVv3GxCpHepxGNs0j3K1kFKZh5ccaMeLrM8Ox/M/DTrYP88CQ
         jqIfgkuDhuf8lkEnI+zbVBhyRg/R1+kUI7oTekKJ4xuWM3jzJcNGofLwQ4jxjCqSXr4v
         RPmJoqJB8SU0nPLn2s2BEQkWhQ9k93K2SrN+6w8xt1A196ujE7iTFWv9aT2rTXOlC7S2
         9WE33vhrm1AAkFIR2sGk99a/J26aOQ70A/AN383y6rhlHQukM0494pFGW1xnyhWMXgvf
         cPlg==
X-Forwarded-Encrypted: i=1; AJvYcCUsW9bZq0WAemMEUfebNyzOEOJujsBjak6DUVMnv0oIIva7YJzXDGOnWYbndQCL+Dl1ElY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGFgfTheRu2wQkTbgI94acz7p3mRxnu5XP4O07Rs2MdJWHeyVk
	8xBfmNUG6PtbbZEXNM9clywYD5xfgVDfj5M4vn4g6Neg8A15/3enlPCTvXlJt18g/8g=
X-Gm-Gg: ASbGncsfkVWP1QfW/1875UFNLIcUJfA1YCOgrr3P/SVdsJjQ3UiF+j7rJ5u5duM1XMn
	2P5TuQuM0RLoDYOXi7NtCO3rG4ubSb6widkz5XpxzERMnqqA/F8KosH8qltmtj8Zi0wJpFIWqYl
	hE3dxTrqVUNhrRnOvqUMrghxqRCpagr2/HKQIVGO5B8Bn+csWm8V6lm5TqsjfUP7/UDX+4vBVEW
	6ak0r+QCz+TaDF5mGKNFUPXLlGWAJqsxrpc7dWx/NsSbVYD6F2lwHzu2ZHv4AfpwJBT2FXBFRq7
	O6rMjZUCeecFNF8g/inwYrEXDZxdL5QxkPi/pAyCyFU3Z4c7AUDd2JBQOghFXBQVx2CogufSoX2
	aG8G80dZADjEg5HhqJt9ZXm1sSzHwvZVBlCfPUqhuivnUuvvcHuxfT4hTa6M7iYBDys5X4+WSbU
	PUbqUBOyHZog0+n+BIhINxVDD+exh/Yw==
X-Google-Smtp-Source: AGHT+IF9YgQxjGmfBS/VLSZ9Yn1NV8aiLQRYv9H/Rha4by/slLu+GOg0yeUsYkmlZm+Qs2ADprJnow==
X-Received: by 2002:a05:600c:5289:b0:46e:6d5f:f59 with SMTP id 5b1f17b1804b1-46e6d5f1183mr8939815e9.4.1759394606884;
        Thu, 02 Oct 2025 01:43:26 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e693bd655sm26669815e9.14.2025.10.02.01.43.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:43:26 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v4 17/17] hw/virtio/virtio: Replace legacy cpu_physical_memory_map() call
Date: Thu,  2 Oct 2025 10:42:02 +0200
Message-ID: <20251002084203.63899-18-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002084203.63899-1-philmd@linaro.org>
References: <20251002084203.63899-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Propagate VirtIODevice::dma_as to virtqueue_undo_map_desc()
in order to replace the legacy cpu_physical_memory_unmap()
call by address_space_unmap().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 hw/virtio/virtio.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 9a81ad912e0..1ed3aa6abab 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -31,6 +31,7 @@
 #include "hw/qdev-properties.h"
 #include "hw/virtio/virtio-access.h"
 #include "system/dma.h"
+#include "system/memory.h"
 #include "system/runstate.h"
 #include "virtio-qmp.h"
 
@@ -1622,7 +1623,8 @@ out:
  * virtqueue_unmap_sg() can't be used).  Assumes buffers weren't written to
  * yet.
  */
-static void virtqueue_undo_map_desc(unsigned int out_num, unsigned int in_num,
+static void virtqueue_undo_map_desc(AddressSpace *as,
+                                    unsigned int out_num, unsigned int in_num,
                                     struct iovec *iov)
 {
     unsigned int i;
@@ -1630,7 +1632,7 @@ static void virtqueue_undo_map_desc(unsigned int out_num, unsigned int in_num,
     for (i = 0; i < out_num + in_num; i++) {
         int is_write = i >= out_num;
 
-        cpu_physical_memory_unmap(iov->iov_base, iov->iov_len, is_write, 0);
+        address_space_unmap(as, iov->iov_base, iov->iov_len, is_write, 0);
         iov++;
     }
 }
@@ -1832,7 +1834,7 @@ done:
     return elem;
 
 err_undo_map:
-    virtqueue_undo_map_desc(out_num, in_num, iov);
+    virtqueue_undo_map_desc(vdev->dma_as, out_num, in_num, iov);
     goto done;
 }
 
@@ -1982,7 +1984,7 @@ done:
     return elem;
 
 err_undo_map:
-    virtqueue_undo_map_desc(out_num, in_num, iov);
+    virtqueue_undo_map_desc(vdev->dma_as, out_num, in_num, iov);
     goto done;
 }
 
-- 
2.51.0


