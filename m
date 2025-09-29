Return-Path: <kvm+bounces-59030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D981BAA4E1
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 20:33:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EFA016C128
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42BB423BF9E;
	Mon, 29 Sep 2025 18:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KJwSkmuL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C9B2253FF
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 18:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759170802; cv=none; b=jEJGUmzGXuz1G0+MYyn4Y+gmR/tfTRzrXAH9rDnNyJ3hlgLgA7s3I2atbZAajlcxXk/Exbo2JayDsLKwMetZBaD10gXUK0PyiqXS2geBi45Uj6bjmW/hCOwi7p+FbG8xd2ovUQkAomx5e4/pbKsqgCxWMgTszRW2ocXDsSLeUbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759170802; c=relaxed/simple;
	bh=SjqfL7oRreDXbyEhWpZSTocdOr1PVxDIuxbp+rUG3VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NruwmzHoXL5At52kW8oXyCvEIKomZx2x+gFYi949AiqljKPHVQDR0e560w8usoWHe/mXcCl9SVBl4PB5HDSke0Vazkt30r5lPR/t1cK0wHfI7oETditjQnasrbAJMo2yRWZL6/aFMZXoqjb0TkwdTX4n5ozZYnBamWiO4ZJSTHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KJwSkmuL; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e29d65728so34192765e9.3
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 11:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759170799; x=1759775599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P3WGf5UHYCyuY+qdMKaaLuq+dGZ/nmDgi/rxgNJ1Ah4=;
        b=KJwSkmuLQKlQTM5nv08s2zpandMu98FmV3g5RYzClx/Opgz4LWhePoostSfKcLEm+v
         sjfL2SXnBr/kl0OjAMD2FCNGfCq1lieoJNbEZ9SdKVFWNzFwnsH5xTWY0fDq7wRhObvE
         nO9W8lKD9odRcyHLqU1CVF7UDDyJjcw3Q43/3F9ybGAyc3jK6jSlHHj2nh12YebcCwg5
         Ma1ZLyuq5Yrs3FSotQ/w/j/E9HBWVAOkuBur+3TiUb4HfA8k2yH4SYiloP3rXo4LCc7D
         /pSnwWDKKjtCtaT97OAFL4e3VXoIuc+J14BgmJtC9VNHCmeLAhUjGE++BGEy3reXC7uv
         lEHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759170799; x=1759775599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P3WGf5UHYCyuY+qdMKaaLuq+dGZ/nmDgi/rxgNJ1Ah4=;
        b=oFZd2CP6ZY6u3bv5Tuki0twhJ6HUL2Wq+LdlLvFI/oQiXwEbNP8X9n+wa4F84y7/bG
         JpC6moYl24ce4E6Y/DXULY3JPAdxCttudAu56wLyUnpQ8yUzSUtJChjBdIYunYo2NKNM
         HeRkyXQi9nzv7OryqX7PD5e+OHx98Vg+vspucT/psrVOWBUnWcnaMa3b7yofvN25Zxlx
         6xBWPh9daUTPWJ7TthhNhkZrm6tOmHJbgK4MSeIDCADAYF1xSzrw57LiYzV8CO6INvod
         +qfq9hzoBVh51U0n0WWobaC4PEcSil5DW+qMzIEflNLLxortt+H3bjZFrOH4Dr7N37wH
         Q7cQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbn9u9IzkVK7h0Y3juglVC9bBxuVBYv/AXadQpdpjBYxbn+YVKDdxRd1hYIqsOwJXgpro=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkhkbQMUle/RHUB/+ETyNL8sx+K0sOY2eciMZpYd+vsDoP69gi
	RSxODtZhC6/8zESP79Qd6pK02YXh5BbyiZUPQeu516A5C/BxtGWj1hzp/Egj7xAiHC8=
X-Gm-Gg: ASbGnctOsdRfeidl/WpkVaA4xSdXXe1qbUou1WwHZzkGtdSaY82wAbuf9gCKyQCaOxO
	4K1dZ+6J2rDDeA6SCVWPaM0337NkqAWreyAhJVekmCMAtnVQmRjbHIm4d+fiPiB40gkfRgv+38k
	pfcKn+iBVv429hjaLDVCk7hEkPJ+1hjQjmc4L9vv//2F770yTYytC1d89+q/g0xyjVBtkTbxI8T
	ahJ2odetuPSfdcLalMcOtWCwpZ8iXBJcdcjoNKLIp34z+qOWSTGnEkv9UKaqu7ByfOBvJbrBxXt
	ahdNlsHx1XjauM582ET0yyfL7qbmRK/oE0k3LJkiTBo2Ucqg0a/V94DZfdkJ2VmAotNZwSUzI8X
	bBhYQuv2SO2MjdCQZxFifnLvryzV+Fe1PeSC7IP7T8D56AKTXTvEe5CHwcZJ1RVU1ae3CXZGMv2
	bytRiWKh5luGfsEvdT6g==
X-Google-Smtp-Source: AGHT+IECk0pxJcrABdWnp0wBblgE/rUdgkYk2QyHdrh6Fg0EQMQZuDnjhZ/xllYj8G986Z96HgDgnA==
X-Received: by 2002:a05:600c:1c01:b0:46e:5208:ded3 with SMTP id 5b1f17b1804b1-46e5208e228mr55680385e9.15.1759170798830;
        Mon, 29 Sep 2025 11:33:18 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc7d3780asm19281036f8f.52.2025.09.29.11.33.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 11:33:18 -0700 (PDT)
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
Subject: [PATCH 04/15] hw/s390x/sclp: Use address_space_memory_is_io() in sclp_service_call()
Date: Mon, 29 Sep 2025 20:32:43 +0200
Message-ID: <20250929183254.85478-5-philmd@linaro.org>
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

When cpu_address_space_init() isn't called during vCPU creation,
its single address space is the global &address_space_memory.

As s390x boards don't call cpu_address_space_init(),
cpu_get_address_space(CPU(cpu), 0) returns &address_space_memory.

We can then replace cpu_physical_memory_is_io() by the semantically
equivalent address_space_memory_is_io() call.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/s390x/sclp.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
index 9718564fa42..c0d8c335b44 100644
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
+    if (address_space_memory_is_io(as, sccb, 1)) {
         return -PGM_ADDRESSING;
     }
     if ((sccb & ~0x1fffUL) == 0 || (sccb & ~0x1fffUL) == env->psa
@@ -317,7 +319,8 @@ int sclp_service_call(S390CPU *cpu, uint64_t sccb, uint32_t code)
     }
 
     /* the header contains the actual length of the sccb */
-    cpu_physical_memory_read(sccb, &header, sizeof(SCCBHeader));
+    address_space_read(as, sccb, MEMTXATTRS_UNSPECIFIED,
+                       &header, sizeof(SCCBHeader));
 
     /* Valid sccb sizes */
     if (be16_to_cpu(header.length) < sizeof(SCCBHeader)) {
@@ -330,7 +333,8 @@ int sclp_service_call(S390CPU *cpu, uint64_t sccb, uint32_t code)
      * the host has checked the values
      */
     work_sccb = g_malloc0(be16_to_cpu(header.length));
-    cpu_physical_memory_read(sccb, work_sccb, be16_to_cpu(header.length));
+    address_space_read(as, sccb, MEMTXATTRS_UNSPECIFIED,
+                       work_sccb, be16_to_cpu(header.length));
 
     if (!sclp_command_code_valid(code)) {
         work_sccb->h.response_code = cpu_to_be16(SCLP_RC_INVALID_SCLP_COMMAND);
@@ -344,8 +348,8 @@ int sclp_service_call(S390CPU *cpu, uint64_t sccb, uint32_t code)
 
     sclp_c->execute(sclp, work_sccb, code);
 out_write:
-    cpu_physical_memory_write(sccb, work_sccb,
-                              be16_to_cpu(work_sccb->h.length));
+    address_space_write(as, sccb, MEMTXATTRS_UNSPECIFIED,
+                        work_sccb, be16_to_cpu(header.length));
 
     sclp_c->service_interrupt(sclp, sccb);
 
-- 
2.51.0


