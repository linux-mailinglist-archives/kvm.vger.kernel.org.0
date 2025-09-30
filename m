Return-Path: <kvm+bounces-59069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF765BAB4D2
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89D3F3C17FF
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA68824BBF0;
	Tue, 30 Sep 2025 04:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NHUu9N/Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183BB24677D
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205684; cv=none; b=F9V1b45y6nD4yhyCH0ySYS4tqg9xsgbOJ8448G3vAkgJ79SIGPMct+OdggVxr9yIHDXvydqYwit7z5rCSMP/oQYCAu+Y2tpK4xHsuxJC8V3WQ1klvJxjTdMBOrvGpPKg9pF21ZJOz1OE/+tmLNvkJt2qXNiTmT4kGLaqyE7vQSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205684; c=relaxed/simple;
	bh=tunixSbJuiB73foP/BPqhxMl9n1OCdDtqenR/HYD550=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RzkeksDQYE17ldnnxV1gkbPPr4GCyL2J8m7Kj+8LN/xfqd4AlYXXYHkwo1P3SQ+qyGqdObCjfZbqVYVco2+6RzFPlhpCo38dFC4hLcbaH8yxzrEQx4Au8FToFSllQnQPORe3VTo4tT2z+2vBcvw9LJ26bQRtQ9y5d2gQn23Je6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NHUu9N/Q; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46b303f7469so36840895e9.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205681; x=1759810481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtU1C0M8U0OTbHcI2E95ZD2Zrsmz5/OESKETD6NudSM=;
        b=NHUu9N/Q23cOb875mSYLRApsOBRUTGsDz4dOoyhsrw9Wg/qcAsMLlbOpVtHDXQDSZ2
         P2mddXOP2xm0js9rSyvmlicqpmK0d/4E7PLKPDEHU2LAJcsjZDXX+rDy9KeACT+pENXy
         wHlQ1GT0SP+/9z80lt/a3fkGXnxl8qL77xqrl4NVn5luAMv06GcEyrivQE9dgxjMupcZ
         z2GmXA7UD7zg1KKPbnNggx9Whzu35Dmit7zd5MRG7eivZ+YxIGv9zgCRVfG+Olumyh0f
         kj6wAM11pjyPCF2hmZlBkTx5tDj30LMd5uQSbGpuWyfEBZtaaUemNeVvEgZvJtsxajaO
         GMqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205681; x=1759810481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QtU1C0M8U0OTbHcI2E95ZD2Zrsmz5/OESKETD6NudSM=;
        b=uAddVF9QZ8OWiGFaCxmO/hM+GtA1NTeUf20mLY27H/4KwxqB50wZbExN1+wbJ2FB1U
         yZA2y3PxKAURdzuVjahuyjVetUdeEjpw3NThwg6SvrIkVm35BxpKWDnhhopBJVdrpidg
         rhMi4wTna1I9FyWVkhr2KxwPuQQDdHCRXBT5LfPECN8ywtR5YG+ZwypCTQYjBTwONjv+
         UmJqXK7HV/A2BmzFRPTwISQcUxKuPgzqJocmPdpoem9HtTYk6lXk0E+B6wRO0yM6QFiM
         nynqHloLufX+65v+BwOPyBDde0YGggRIRaJiBVH9l30DBx2GmjECho+fgCZjsMnIzmjG
         /NpA==
X-Forwarded-Encrypted: i=1; AJvYcCXEZQdu3u1W2xo5k+eXqVeCcbVaZ9CImhDJZULYPsMfLvtc/AQAD9f66pUkVQH+tM5LogU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVCjGLpCo/sinpsOyciAG81eJvzcYpwNbM1CQ/hvT5FXTb440S
	jQh/3MsQAnCwql9IGpqFOh3cvg6t2MYgXw3XX5auUjApBc5iLKeS9QJhnm4IgsEFIkI=
X-Gm-Gg: ASbGncsfqcP3blyMa6qPoqb809xVA7f1Q6rbpWN9jWJyLfN8qNYKihGBK+Y31lEqv+k
	n3YrzcdpFOu3sAshYmrGjytTEjj3j9RzumDozTECbxxIb5k4HwOB5MzqWIvaNE7ifRqLHpTVLrS
	JphhRD56kGAj217fXsu9AC1sNjw+KfFwAy5uO9hNo9P6NdmUbrsrN9DLMtAW/+MkLlq6YY1Myh8
	qx2p7xB3RW5izGNU1xzZcXDg+zHCNYmTjJHF+LDLX24i2j7TqCIZ6MlVutpsurkel/t9I2DBvcq
	A79GbqGJeGmuKU+ufSShgLNZsDZoDJ60YNlOsrlY2CPG4uO8Pm8DtemJcQfTK0HQzNwrz7mALoH
	dkiaJZCHMzwSWMz/DF4slD14qHI1NbYIep5vkxPzMyLpFSyHsN4pk3fMbXlst93lwsIXfDokZpU
	6uvrU7d8lNgt586owt4PeD
X-Google-Smtp-Source: AGHT+IGUG79kearmVn7+9qugGuIF+Iaatq5RHrgppUdDi9qlZIXdMZGH9YdXisC+M3CCPhGM+TJyoQ==
X-Received: by 2002:a05:600c:a00c:b0:46e:41b0:f0cb with SMTP id 5b1f17b1804b1-46e41b0f464mr152474875e9.25.1759205681405;
        Mon, 29 Sep 2025 21:14:41 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e4ab0bf62sm98607665e9.9.2025.09.29.21.14.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:14:40 -0700 (PDT)
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
Subject: [PATCH v2 12/17] target/i386/nvmm: Inline cpu_physical_memory_rw() in nvmm_mem_callback
Date: Tue, 30 Sep 2025 06:13:20 +0200
Message-ID: <20250930041326.6448-13-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/nvmm/nvmm-all.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index ed424251673..2e442baf4b7 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -15,6 +15,7 @@
 #include "accel/accel-ops.h"
 #include "system/nvmm.h"
 #include "system/cpus.h"
+#include "system/memory.h"
 #include "system/runstate.h"
 #include "qemu/main-loop.h"
 #include "qemu/error-report.h"
@@ -516,7 +517,9 @@ nvmm_io_callback(struct nvmm_io *io)
 static void
 nvmm_mem_callback(struct nvmm_mem *mem)
 {
-    cpu_physical_memory_rw(mem->gpa, mem->data, mem->size, mem->write);
+    /* TODO: Get CPUState via mem->vcpu? */
+    address_space_rw(&address_space_memory, mem->gpa, MEMTXATTRS_UNSPECIFIED,
+                     mem->data, mem->size, mem->write);
 
     /* Needed, otherwise infinite loop. */
     current_cpu->vcpu_dirty = false;
-- 
2.51.0


