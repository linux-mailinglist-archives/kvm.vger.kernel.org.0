Return-Path: <kvm+bounces-59074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE1FEBAB4E1
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:15:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24E803A1E81
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E10D220698;
	Tue, 30 Sep 2025 04:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AC1MF6Pl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD7324BD04
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205713; cv=none; b=dwWgVur2/oAJJzHeEW99DsEi89myZMUjohFpGaClU+HcyPF+J4wSMKhVtLk3Cus99V4eQbbQ7sDIatjAIuOxq3odZXZbDI+PCeBNA2lX5VfviPUEWzE/AN3EX0rE1FSvvC8jD5cBGgrEAc2a44ZgkiFD5RTwTPOxyZ8kYxKy6Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205713; c=relaxed/simple;
	bh=gpbrxqeVsUck1o447XlF65le5rCLL7mzuLZFTIOOjOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sbn/a+yy2tHS4rjUlHPyykI1zHyK2xT1dEPjGkPOYIlf6nfcfm1YayFwa06ODvvs+Nkxy3YSRtVc5e3zS9Wip/GNgorACZAVmSQKIc5pNIs7YKMcmdIhi/A6Ty3TbeE72jAPxG4/s5psx56dPJ1oXOzJg4fsf7kF3YZjCZwJ42w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AC1MF6Pl; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-46e34bd8eb2so7519635e9.3
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205710; x=1759810510; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+R20KfaeepivX48ztS5Qk+Utu4Wf2nP4nwxC8R0e4a4=;
        b=AC1MF6PlbLSYRuaiUXedquFl7VYDyzBpyh53QY62KwOlaqsuYj2MmCkPaBqu4WrAt6
         VxXgsXtn0jBJSOsyozS9Y9jYeVxjkHuX24iBo+b2GZ2rKJ2rkVNg9aaAn8u2/LWq2xnA
         vUCBsMpsUVfRyuBBQDzWbl/McESiRnBcPvFv53wOfcC1FtqOYJ92OmxztuZjalNnQtoI
         FzrNDW13DELC8sEW+eRa+Ao3Noi/cKvGIznlaXflZAJ2ItlrCXQmZl5Z4JDNl4/92cWr
         QKx3dehjMo5qaQpPRXRkqWckmJUmgFTj0NMIryvIacpXisLNghYJOEDCrejcT24PGIpx
         envw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205710; x=1759810510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+R20KfaeepivX48ztS5Qk+Utu4Wf2nP4nwxC8R0e4a4=;
        b=UPqaCvJZMh8d/0S7/yIaZ3MmwxHYqpIVuZYxP+wQMXFJsvtdSAnVI4fGZyAmTTh1ku
         G3S/bhYj8O2nt0QQrigeBrq5e51EoflukxaNuWfaSBNtJtuDndD2DFiUxvC0El9GrvGW
         WbGg1cyy1F7lS8U1f9oJtd/X4ivZZUEzBfBl1qcEuSVSfhI8ysRMXppxeuvDas5S072U
         vS+9PcS3JiS0P+H2s6dq1R4lEaS65f9mVYTXRVo9hQJeaKob7wCNhkC+magGUORxOZRQ
         CheccicZjQpBkUF6IreNKQZGEA9piI2W635VrG9Vz08zN9vgETTnxhaMMnRH8qBWrBSm
         iRxg==
X-Forwarded-Encrypted: i=1; AJvYcCWQTR7P6PrZHyMsx2lXva3PiURzXMA+876/cvB7DpSl9iKXkj1KuixnNlltI5jMWZjnsz4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFfixwM/QiyDAReEWeJjnFCU8z0XHib8gJtZaDL5KADftCibh6
	5t6RuNFzj9yHR3HNtUsuP0h9GiP9r/zaw0ljbJ9yj+SYpwlMgYVmnT7C+J9TiIJdBDc=
X-Gm-Gg: ASbGncu+6x41yoWpqWSmurmLBr9EBfhcMaF8WPhq3JGoUeb8Jiq+toaq1IyG7C+KyHO
	qGQLCmdVbjbmmNxBCtMxyVrrfR9yypFgus0aOTgIewbHs+eRVp0YY3C8Fk+ISLIe4ozMo99dAew
	urdbzktfW+uXY+UOQvL4LIcix9wFlBVhBf6gpzxhsZLRjFO3dm5Zu5PGqYBKvK+YkCxLeJiksn9
	iAMpkI6diNEN2A+WcighkzgoqfCm7GYEJ6XQzys/vQyNdn2a8BCL9WaVSG5YeQiBr6aQDw0e62g
	VEmqu4p3AJ6Bm4nik4I+pyP2PJ21kcJ+wgDeqSCeuFSX5My//llNTrv3q17IGVunVBIHZneIU2i
	DK4WJ2OkGYr3imvR/Xv0fwnLTcjSfcJu2UH9neYv//tdKhfqHx8+D7rKkV8Zl6BulutNU0uQmIm
	fBs+StSuIlXorVZivqSgoS/ZZSz0fV4y0=
X-Google-Smtp-Source: AGHT+IEUJE1IYP/kfT6NPYb+xEkszrcjL4tSyyPjenIF9G8p6iMdA3UofkAUQEEOCpstatyYsaodDw==
X-Received: by 2002:a05:600c:5290:b0:46e:394b:4991 with SMTP id 5b1f17b1804b1-46e394b4b1emr152224145e9.11.1759205710145;
        Mon, 29 Sep 2025 21:15:10 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e56f3dcacsm39499115e9.2.2025.09.29.21.15.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:15:09 -0700 (PDT)
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
Subject: [PATCH v2 17/17] hw/virtio/virtio: Replace legacy cpu_physical_memory_map() call
Date: Tue, 30 Sep 2025 06:13:25 +0200
Message-ID: <20250930041326.6448-18-philmd@linaro.org>
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

Propagate VirtIODevice::dma_as to virtqueue_undo_map_desc()
in order to replace the legacy cpu_physical_memory_unmap()
call by address_space_unmap().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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


