Return-Path: <kvm+bounces-59121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CF12BAC01C
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:23:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5F583C5EA3
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5132B2F3C0F;
	Tue, 30 Sep 2025 08:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="b85iEu9w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1232D24B1
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220590; cv=none; b=kx/9KSJlbgbb5u+N2A3PlxP6YHWiWqZtow7lOc/fDYaqczThYVXZuaohT4wMcoM9/MizOzNFThUZMyb5fdt4J7OUMgsNpiFw5Ifa/w5o/n9DkEVimU1ZPGXZM4RQ1Pf5329H+vF79xFBiKATyk6igpuiacNa65ZyLJV9u6TjEOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220590; c=relaxed/simple;
	bh=gpbrxqeVsUck1o447XlF65le5rCLL7mzuLZFTIOOjOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tMEUe5XnUEkRXPL56gqlwgNnxQxq4ZlSMIqVCkZqahk8CqtP9gUovF1R0AcxjZu27wpSfMul4BKH4MYhuF0//1yPrui+dBEQApZTuvTE39kTMAGvbpHj7OINQ85dXq0b7deO+B1NHldPqT4fQ80nDaL4qaxE6ae6k63L6ueo8og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=b85iEu9w; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e34bd8eb2so9968715e9.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220587; x=1759825387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+R20KfaeepivX48ztS5Qk+Utu4Wf2nP4nwxC8R0e4a4=;
        b=b85iEu9waAcdBVyubReWCccV0kobdfLeYZGAyqV0BodOUoj4ClCohPNhDk6ryMpREV
         oESVJBOOQL7k9zKjvLzgsRlzt3u7pi99hWyzcdO0SX+dyKGnRvDSQQHfA/BPWPdURLQD
         S1+WQnNXhq3vEwFR/ysNJmVGNEHydxE9OFQaehbQL8o7j6+zoUuD9g1FVCgb5y90U4Ed
         bz16IdrC3h67AHeiM1yT9ipVw9/WRpT5HbRF46cQTxGfrgl9xmQzZ4CVcmGnB5UC407c
         pkz7MSU+9ia/iQ3NVrdnNt88RSu8KFUdWciIDAAYpKiE+sAd5SV1a+NpSAKaEnIpQ25H
         guNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220587; x=1759825387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+R20KfaeepivX48ztS5Qk+Utu4Wf2nP4nwxC8R0e4a4=;
        b=SRczM5r5EYmyMjl9S5W6DOuySY28sUo3UNVbXvfOR0VyoER58ckn14hcHLp0uetNbB
         Jgw35fMYAcQwydGrlsNIgIn0cFbm86DQvAGqDrfJkNFBonLR0sydF7pdUZTBwgR9PVab
         BFFt/+gG1F5Qm3IPTyrBiVLd7lCmL2XJ0ThCy7J2WE+hLxj4hSjUr6lvnRN2QihzZmaH
         UfWHAkJto30uBjXuTiMAXH7u92a0p3nCgPzqEt+7IEbJVHX+zPYoSTmADDC4TyncdeI+
         F/1YX/T0BcerGNlQQ61zjJtki7u6QiPuO6/52T7cc7pBOYrarq5WmCR0DPYeqDY8bfYN
         1jPA==
X-Forwarded-Encrypted: i=1; AJvYcCU6OFKvWVdqIDY8Qx2lBkclUzp+h7J1ZGaH08buqORI7tsl1mxvxNyVOSk6l0mqnLkHM+w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxmakeBTm8nKotIHIzaD08GKNqYLJT7bTvPMW6HhyGqVisfUit
	4F7W+wTP9zJSBJfvG9QCmr7K6R9g2FH5uwp9JVQoMGiVzhQ4YQS96esrCwwhViMP6eo=
X-Gm-Gg: ASbGnctG5cbvqrT/i3bhBsvBJkdekyUWEp9nLOLpcpfRmBEZaz2bfq5mvsHPukh8veJ
	sd/rOK0uyQf8AY6vn0o/gyFoPKpO777gHPRqPUY0s/F9ZLeNYvoMiRIp1sUgwzL0I8pF4f3BJNe
	3BK1k7XYRZ2dgbkJW0PLEgLMYE7P49yulwNMhsl+yvEiFtNmP/VRrXY2G4ONytUPZiy2I5hxEJ4
	+UEZzVyHzl6zldxYvlA3k0KElAVBWTzwRoWZKKBH5X3MF5JrLwRirjLo3weKrCnH7Ym4vGjHWL/
	3F+eN5/ZX1OUd9pVwxRfblTmxW+maEkUTXLXBctIYTOkk2FUz+nBhSLozGH9DAjbXQf02gaXPyh
	L79tH2Is8ILlj3/eEzv6qBHlEoWr1b6JLHIBf4xhivZHJi0rYENEm25qYRiEevdeS4DlEf76T46
	lNP7Z9UXqCurB7HTEsBmaWOWsktmd/Fss=
X-Google-Smtp-Source: AGHT+IGvdNJkPsXhO7mhTBAmSS24HJr1NcQFoKlHMGEeSQcfQp9VTD/G8Mg1Kg5Mqclxy+K9+gFIZw==
X-Received: by 2002:a05:600c:4e8c:b0:46e:477a:16cc with SMTP id 5b1f17b1804b1-46e477a1b4emr94534015e9.24.1759220587242;
        Tue, 30 Sep 2025 01:23:07 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc82f2965sm21484653f8f.55.2025.09.30.01.23.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:23:06 -0700 (PDT)
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
Subject: [PATCH v3 18/18] hw/virtio/virtio: Replace legacy cpu_physical_memory_map() call
Date: Tue, 30 Sep 2025 10:21:25 +0200
Message-ID: <20250930082126.28618-19-philmd@linaro.org>
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


