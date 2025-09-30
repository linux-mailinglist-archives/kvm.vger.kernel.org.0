Return-Path: <kvm+bounces-59062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DAF9BAB4A5
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:14:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9513C1924C9F
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5544E24C068;
	Tue, 30 Sep 2025 04:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HbTHbVb+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59E0247284
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205640; cv=none; b=OT8gLxZ/PHErF1mPBmxqmA4DU5zf6pcv1LIwIvUydjwOTwwoNASxrA2YsB/cm8ACgxCuKRveHjVTyxE8aBlteiBdsAUxDTyN7Jhie5LZdBWnL8zqP0tORXhRg/x+bFNGAmOAPU7vu+MmaqzaGYY1I3s9oEYVcZQjf5MCkjYbsww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205640; c=relaxed/simple;
	bh=vQ1XP+EJjfISfUhqcAuz7EHNGolncv1rVCxDcJErohg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iLQedXoca88TRzS+qSTE7Hl0U51gcJb67vg1fw8xzZgosYrbpT9WJZtVjMti0ydpAtSYW68BLJ37PJE1XsS5chrY9un1xfQ1LUqagUM3hVRtYcFDrUNjoeLTnsVH/+fGBPo6n6kWwWf2Rg9pOGGxMwP3ejS2Bv3aLbt2XQnfG8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HbTHbVb+; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3fa528f127fso4221189f8f.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759205637; x=1759810437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UsPYBf9Y41DYeMpdEdOkBi/mu9mpDrkpGT9A+u43FVY=;
        b=HbTHbVb+00qctnvHWao+FDgG4vUaEp+HazG3V89KZYDOjrMGmsEHxvg0VuQzutYg+m
         X+6HZR+k1PFdxXOxzBXBLhLZQaXQ76uFbl3TyLICpq/TydOG6+RXngf2il5MY/G0XZrp
         sq1zOC6GeQ8wRg81tlkpkgJr/pq35XNl3CN+X6pgtDfvCe7YfdNEY8Hi43/Dkg+v45U4
         WCSTHvDxSFQgwMUR53iEQATiqgPoEw7D9bIp9sKP9hFSZDs3zDWbF2v8yDhZLP5LHW4+
         4N2B/qEd3rssn3MXwLNEQCkALfwLMoWAN0wC8bB4K7g0cHip6X8rHZbR5Bo5vhOr0vBU
         QheQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759205637; x=1759810437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UsPYBf9Y41DYeMpdEdOkBi/mu9mpDrkpGT9A+u43FVY=;
        b=sEzDZXi+Q5CeqOW6s9omAsa5gIoGjfmeEPkxp+8LZa5QIUOpm2miAN5QodKKguzpdv
         ucuECZKv3fZs1nE0G5IrFhIXjjF46jSBOBoDhwXpRw53+dnHVJI775S9HjknTE0cNyqq
         pKNhylJiXWm2GbttXtOeQeddxQh3rXhxgYJCd25Ggtn5j0staGtl3WD7JDawPiVeJqpy
         5WMKMwPuRdjcws+p0gvdLgrbKMdIbpxMBLK6vw6uPkZcpTcKYUpn/fx8FXtz9Wruunnn
         7Vxt2+XW86pfd/pMrFSbi9Bh48KyEYIZnCX9OUk4lPVlaHKHx4oDv/Uo9TqzvKIyIjId
         ef8w==
X-Forwarded-Encrypted: i=1; AJvYcCUxM++NZJ1i9xQn5lSbr1c6libk/i6dk3cCJNphgEAC7+G2qSHnXMvSGGpuKdYp+kXqQ3g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLXKBCOibH3uR0NvwzlJpDPttlYADKR7jwGGj3870wfursS5tU
	kKMvFloinkIyjVmSVC91vzqp66ZR67zhvgPJY7UgbpI3/dqXYOXiDobgKwZU9t2M+GM=
X-Gm-Gg: ASbGncuXyRJFBN55l37wUQGv/blKEj1VqwzszOTDz49UEw18WWGlfYTUy0tdwyq3+Ok
	D1JqWMVmnEUjWvpR5kwuSShEQyuQA4KxBhLUomvntIhaDg5iPAFsN617fQgafcjA83kNLDXqQaA
	OPj8zPJjNH38bq4Rtg1+oSjHY9EVIYiUfpB1T5Yd3YmwVdAyk65nnOSMn9mjPsI9usCreoxef8Q
	ynfa0xIDvXbWEke8y9q0+M56DoQMOuRHtt+eZnhpLDSxfAuWuH6jqsgxm1sWdPer9PoX3ub0/hp
	m0cZcc4CbHom4+82sRG3fJq8500iFies/DyMdICH75r6sOGHmyojOi55r4K0JwtETWuZuiuOb2w
	hxK1aVY98JfMY7R3XI/aQsV9gCPxRLxzMLaISl6/snK9dJ66GjAoVAN5mPrnajTKOZdfMqDnhAg
	j8v4wLNBRrNFbRO05GyKuS
X-Google-Smtp-Source: AGHT+IH3He/bgDcAVA0O1uM4KAZUJWAOZ5pxrLV0agMvoc3nOriIeKi2nLWEPRWZf/BAWQ6cyeIFXA==
X-Received: by 2002:a05:6000:40c7:b0:407:d776:4434 with SMTP id ffacd0b85a97d-4241227789emr2285457f8f.30.1759205636900;
        Mon, 29 Sep 2025 21:13:56 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab31e97sm251610955e9.14.2025.09.29.21.13.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 21:13:56 -0700 (PDT)
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
Subject: [PATCH v2 05/17] hw/s390x/sclp: Use address_space_memory_is_io() in sclp_service_call()
Date: Tue, 30 Sep 2025 06:13:13 +0200
Message-ID: <20250930041326.6448-6-philmd@linaro.org>
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

When cpu_address_space_init() isn't called during vCPU creation,
its single address space is the global &address_space_memory.

As s390x boards don't call cpu_address_space_init(),
cpu_get_address_space(CPU(cpu), 0) returns &address_space_memory.

We can then replace cpu_physical_memory_is_io() by the semantically
equivalent address_space_memory_is_io() call.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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


