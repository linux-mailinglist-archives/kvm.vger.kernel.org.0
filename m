Return-Path: <kvm+bounces-59108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB52EBABFD4
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:22:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 203621922C1A
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 648D42F39D7;
	Tue, 30 Sep 2025 08:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ikh1syI8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0F52BE037
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 08:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759220519; cv=none; b=aORHUVvqJ7Uqn2uyV1JsywnP1CSkqBqIbLt9gPPDK3IhvmK+V/cbTPqhi9NrsfiT3yomnaINdVLPr0qXZ7vJzBwXFIrNjLydQnklm7Nqa1rrpa6LfPnX6YD7f82zRNaSkj2JUS/PQGDxto3DxalCRFEbo5QuqaSamoq/tZ3ekqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759220519; c=relaxed/simple;
	bh=E1pjphecjYvqgc5QOS49SmJqcn0hLUGrEYYUg5yqgV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bwHWUOYgZdhkm9ljka4bAUjjL5AV1eENXNsGAE9n9IGC88Wvndvsou5tUqZGWoczdk/9TtQ0/VhJNvDfInr1UxsHH4Jgqn9ZKJJGi/OPlrBzsTpJ4+/ZyYvLFw3Gjm3lWQbIOREgNwalS0higp1yVUsO1/iwuQigw3eY3uz2lEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ikh1syI8; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e52279279so14712235e9.3
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 01:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759220516; x=1759825316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TmN6KZRBDFIwLcWnEVDqbz1WHRvv8u+lRYP5Aq5aiQ8=;
        b=Ikh1syI8kLOK8KFWt0G361qfCxZL0XgbMV482/ndysaPcrw+hXj32ex/+gsGooPQih
         nPfC6bx6DAF7MSYbGlRMvEnn8WCNItVNbYyHj65HnncZj6yHThKY0SmEfBh//BZV2wBs
         KXOAfcOuIPLGMO5MGlstZjTW2EZM6rlm3/q5f607o22/pbHJ99HbPKHUf8cf48xB3L4G
         w0rF7kJQXEqzWVQGXiC+ePEDwAHT0nVWcOskPs+BxSkhzSr81j6CHZuul58QRwh0v9Hg
         daJKLtv+jXoU4SB8Sf1gnojPOMfsu/v4xjq9uZmXxll0sOsnUijrq7+wEiU39uVlKJE5
         8mow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759220516; x=1759825316;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TmN6KZRBDFIwLcWnEVDqbz1WHRvv8u+lRYP5Aq5aiQ8=;
        b=aXk9b4wVk4fNPf85paBqhJWgWUmbQbpI+VgiABY8+MBLgSvV4406IvXp1nnMnfauCl
         0EyjeePUPSh/0OrzYl9D63NCZLbqIdsoAzruRLUojE3G3U0rrHczO7dzJrT4+O3CODg7
         HiyQGpv7qaBgqTDGZaUKi8S0k723eOImfnM6GoLXkZEsDm7quj/1QgFaVY5os+BsywW0
         kamckU4613dkQmB45K5VX+kz0mI3RMM99rA1AZhPI/ow0/GejqkdPvACuLdEGkofY/Em
         8gOEdSQOt1Qj98EOByEWQSAexlwPHinFmqrLwSTS0EPhAD8rLbDQ8Mf2G4bqfL6ROmJG
         UkrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeN8EVDdXgnejjBr8qa9bBi8uFykb28dUEyyzjv5/V0L6y46/BwEtnx0z1Y/mpzOLxcQs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzS1vuoOxv2X8c94f9UwllgD6B1KQeknCIC9vLNcoybKmGgJQbS
	HQCDEAd35mIo4sP63HLSROc1uaMy6MSxNnX+XUdgKVL3I5mMCn6kc+GWXVlIplVHUJM=
X-Gm-Gg: ASbGncvJpj65YBW/qm2aWdZSwCWqWdFqRUH/8F4lb8zRhSJkLR5Z1FcBW+mGSDEHXl7
	2DNs4lcLgNewY29io/NvEZvtoRdh8uFl3DXBccqbcNOqdPMIEXvmn/iIZ+yC3wqqahJ1p6yw/oM
	brmZ1HzBNzocwktuN7QEXUbP9P4rY2EF1uuoz448oes5GDN16EH0hTP9tKuFfqLL6F268jCF5v8
	8w3tSTXZNxyOAbGPVhGaJntDgdIbrNGbAkh3jnkTXtaPLltB1hePJtNwjZeXVnIe5UaT+Z6XMMm
	uhgl9WDvQv30hFUjlW+zJFJZY1FY5MLH0lgrSpe3vNORRj2gagFfjQC41YZMOLM+1qkvRKi6ZAx
	wu0Mhqd067YPw3f/+jbSP+0M4ieVw/BLb6c1lcILfZMk1XYHgf45kOSis1gRcLb0pfnuFdnJUzb
	0a5gxQtOfpaNNxLUZMqQpunzcREefbNrU=
X-Google-Smtp-Source: AGHT+IFRoVQqdg8pFriDfOKg6AJHeYajBA5OHZoOOnjeKEw77YQUzMpfQKsIByPubJl8mIXC2txRhQ==
X-Received: by 2002:a05:600c:8b16:b0:468:7f92:5a80 with SMTP id 5b1f17b1804b1-46e329fbd2bmr146354195e9.27.1759220516099;
        Tue, 30 Sep 2025 01:21:56 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e56f65290sm44620345e9.13.2025.09.30.01.21.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 01:21:55 -0700 (PDT)
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
Subject: [PATCH v3 05/18] hw/s390x/sclp: Use address_space_memory_is_io() in sclp_service_call()
Date: Tue, 30 Sep 2025 10:21:12 +0200
Message-ID: <20250930082126.28618-6-philmd@linaro.org>
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

When cpu_address_space_init() isn't called during vCPU creation,
its single address space is the global &address_space_memory.

As s390x boards don't call cpu_address_space_init(),
cpu_get_address_space(CPU(cpu), 0) returns &address_space_memory.

We can then replace cpu_physical_memory_is_io() by the semantically
equivalent address_space_memory_is_io() call.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 hw/s390x/sclp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
index 9718564fa42..f507b36cd91 100644
--- a/hw/s390x/sclp.c
+++ b/hw/s390x/sclp.c
@@ -16,6 +16,7 @@
 #include "qemu/units.h"
 #include "qapi/error.h"
 #include "hw/boards.h"
+#include "system/memory.h"
 #include "hw/s390x/sclp.h"
 #include "hw/s390x/event-facility.h"
 #include "hw/s390x/s390-pci-bus.h"
@@ -301,6 +302,7 @@ int sclp_service_call(S390CPU *cpu, uint64_t sccb, uint32_t code)
     CPUS390XState *env = &cpu->env;
     SCLPDevice *sclp = get_sclp_device();
     SCLPDeviceClass *sclp_c = SCLP_GET_CLASS(sclp);
+    AddressSpace *as = cpu_get_address_space(CPU(cpu), 0);
     SCCBHeader header;
     g_autofree SCCB *work_sccb = NULL;
 
@@ -308,7 +310,7 @@ int sclp_service_call(S390CPU *cpu, uint64_t sccb, uint32_t code)
     if (env->psw.mask & PSW_MASK_PSTATE) {
         return -PGM_PRIVILEGED;
     }
-    if (cpu_physical_memory_is_io(sccb)) {
+    if (address_space_is_io(as, sccb)) {
         return -PGM_ADDRESSING;
     }
     if ((sccb & ~0x1fffUL) == 0 || (sccb & ~0x1fffUL) == env->psa
-- 
2.51.0


