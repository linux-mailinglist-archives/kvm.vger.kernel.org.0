Return-Path: <kvm+bounces-59041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D166BAA52A
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:34:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABFEB1C610C
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E787253B66;
	Mon, 29 Sep 2025 18:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="emLlITBW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19DD78F5D
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170863; cv=none; b=lVwRnJHP8CVUs/s7/Pav0tOcI6t48HFn4B63Ky/UUedzcL3euMPNiaJhv4qmR6Vq4SUidqNfzRpbQmH1gpmyNuJK3vogPZkwtZifluo78J3wxRz2Xj4bcnyteHWCZuafJx090aQesrDD1UvrAsXroELvrXh+d2utHSWXJwXIKSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170863; c=relaxed/simple;
	bh=gpbrxqeVsUck1o447XlF65le5rCLL7mzuLZFTIOOjOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BhmWFU5j5NhAMW12jK6KFS5P81twvs+YSCdaKuscg396l5Mx0JWDAXeudP9VgZ119J6dgyehphOgRJaVzAohJ8jP/UvpqFFk+hQ8uHjzJLA8N0CnNYiaGNTJX/0Wlhi7RMDgt1FA/+/lKlkRxiz/XGyFbehuuc5a7JEI+km+Ha4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=emLlITBW; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e2e6a708fso32642315e9.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170859; x=1759775659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+R20KfaeepivX48ztS5Qk+Utu4Wf2nP4nwxC8R0e4a4=;
        b=emLlITBWvuyg5K8GSNu1m5shDXBuC2chEs0PzQxAnQCxFHpjCwmQko+Wj7j79ri23D
         zkShfXwcRlELOuS3zqRpRyXEV5a3deTPX4uKhfYGzHsf0Rgss8CM9L1WASZAY10bDF+i
         n8XPu4fIc6TfMGrA5xyHc6RlV2bw02bbjP7kD6UuDZaLVD0InK76P00ZS8kcyAYnvvbd
         ZP1kbIKrgvYNcWLwf/59kRvPLNs9K+1d2eFOKcJT2XRY7OsMLW/0mHQROTJeurwtahCI
         rBBMQgsn61c548A+EekBlRMY1mq31AoNmI4cTx+iOA44O88DXTXpi7I3Xsj6MpIdk/bI
         2FmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170859; x=1759775659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+R20KfaeepivX48ztS5Qk+Utu4Wf2nP4nwxC8R0e4a4=;
        b=bIJOl4o7WbM+rF9PhJlTmzZXA1K3RjymCmilVoNuo5oQNpYtKxz7IYDGQPcDeVXIIR
         fKahHqv4v4XRtxXuy4BLL6rQjqcAyD7fqUOgwoHuvV+RYn00e5P5SPDkZIGdTa+r1Jek
         FZKBGhcIeZX2v4/piaMjn0Ljflo+RPs5UsOslMcABML3jByPGUbuxO+hm+Ruw8ucsb9F
         nKdUVIAdav3UcHPMsG+IywouvKFOUOEvNtjj9TMtvR9HUHhKXn+yptujtCOxZylBzeYl
         2rE2Vf3iaL8tsn6Oq7BSTR1KaKLDMg3Op6ZoJMSchRQtFL0AVPB0Q8OSOhIqs8xuCMuF
         FGoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbUNlTD9/0gzy6jgVEa9HVCZaaWqyu23KcbFxO/7sCcyrLSiVvC8LKp1kzLsAADnOKrqg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkOxOXEP3w1FOv+FmKKs1WwCnddecyZkq+kQ3g2ded4yONvS6j
	YfjVVHR9YvOt1282gmn4P6qcgzaXTLcaGvqE4HlX5LkrUT196ykufUY10iK2/iJuDZM=
X-Gm-Gg: ASbGncsNwjnUgdQRGJQ8oa3aw6kWGzGJmH3L9MWbVo8aQf5jf+lgDOUPcE1dkVDTGcM
	XudVu/DYhU15sGOSB6WGjwgklfoC0IFCpdSWUMkm2tJ7QpnppsrcfZazwdLBGSC60OakjD8rtBL
	WMViFgkgQQFMIN3l9ce8TlR62uPwy+dte6FNxixFqqAOBteyWuRDouJ0zg8dgtU+4KIWhks7NAr
	XtmEu9+Lv+7HQG64Gjr7CKLc5Xuc1DPd2pVg1bn5qBCdXoh2Q1R5XOXg2I4XgtSozBaDUuktrnn
	5gQ5MbIwG1CoHVHG1JvRUB9Kj49XKPW72V7TExBIJeZ9jWsEx4gZhy837kiJkkKVXw9bN9KjrIz
	ebtpRPeCdHkYBVsF/lhsoL9KRiNEjGP1FJVIi63Kim0O4iLu20/e4qbL32a5IDl4i3cRSv3ryWz
	gIDb0mWTM=
X-Google-Smtp-Source: AGHT+IESuOr/9kkTMP61JEo78aO/qu+Se16k4y0bZLp5zO2vT4tUYcRGwPC2KF7trcFZOrvkB6y8nA==
X-Received: by 2002:a05:600c:5491:b0:46e:345d:dfde with SMTP id 5b1f17b1804b1-46e345de049mr203777245e9.16.1759170859187;
        Mon, 29 Sep 2025 11:34:19 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc6de90desm19572933f8f.47.2025.09.29.11.34.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:34:18 -0700 (PDT)
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
Subject: [PATCH 15/15] hw/virtio/virtio: Replace legacy cpu_physical_memory_map() call
Date: Mon, 29 Sep 2025 20:32:54 +0200
Message-ID: <20250929183254.85478-16-philmd@linaro.org>
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


