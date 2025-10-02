Return-Path: <kvm+bounces-59406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8558ABB356A
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91FCC54631D
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7460D314B64;
	Thu,  2 Oct 2025 08:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XDaZlNzz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B606E3148C0
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394547; cv=none; b=NzK6/VQZPSZw+ziAmXf9EecA0sFNZlIekSQWv4TqVNCA5CmW/E9ab4IUwQpbSbMXy01r3hijq8dqLGc1aGyoHVoFf/10ByyrXbVBXhN8hHPdiiP38WNMq12xp4ZwKZZhhHjzvFAYerHDCBG00b6K+A+joTh+ljlxbjK0yFQCM5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394547; c=relaxed/simple;
	bh=y5DI4LkwZdxGX7B1TM5ysHL2RAmrjKMBy1Bn2UujQpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jBbh77oIyC1tiNr4lQ1gKxWbmByBv+ApUvYKbxyaI2pdPqVrdpwFOzM+lgfdC2mrTtgWhAZMKKC1EakooLM8rIIEF90jNSGBflV+Uon2UpjjF9/0r7kVGiogAnBnvlN3DllrrWHp060gjlT3jssuo1gkEtVSO5ALu0YUdg8Lcm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XDaZlNzz; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e4f2696bdso8986605e9.0
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759394544; x=1759999344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2534c4RtZyXLI9bpIizaZmKA+am5Tc7GXq0BfJ3FTIY=;
        b=XDaZlNzzNmEocLZlqCIGr+sKK9ZgkU34g4TV3MGHLPvZB+pMz4Rll4qGVWH8Z9uWsA
         XUoccGETAjhxGyE8Yy7ijms9DxL5qfbzdEPiYT7Xy1+/Lh59vxhtKOgOibrX4sYe6uFd
         j/Hdtat79VldyeAYGgF3XXc8pajSbsYA4H4oQFgnp4JL3VfItkzAx4YKjtHlLUVWNAM3
         wb6//kSvbywOEI10uPmiTteyhUx3B2C8/rOYbSAVj4UusWYUljkcj+Yn9aPGS5kUtVLt
         OFKgV17Go2VsIVv+8xXiN+eBUZbNP43IexXv7jxKU/zYEXWKyDbzZsfxPlRsPoOESUWw
         GVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394544; x=1759999344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2534c4RtZyXLI9bpIizaZmKA+am5Tc7GXq0BfJ3FTIY=;
        b=f6+SzAJDn933QRvfUh6YelYjltVW393eO5bpVLOf/iJ59AzuhvsVzkbk/ckk6SReBw
         xyRrqf9NheRhHivydSuLN1mx8N9cjYEiLz3losZcJ+LlUNujMbPD3Y6qskP7RnaYiy/E
         yBI733x29oekZD33IIdBNJ5mkhMLzbTpz89ffbOOVoLJMUq3bPw2Q82ZX+1CRwZgsJiw
         2R5DAeHLLuFL0z8E2Y9PSPk3IZoDcuKGKxFRKrm3caVLrgcz2Ghsx65uhS/U981pnD9D
         qoKooORSu3YC0yJUIoNPpzHO8xmzMTOpQqBf2UlNe/tX0NehsVDmhsVLaLO+3M69yE8v
         4feQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaNufGgbOMcQn7P++aYZMbtTnFx7mSRa8CiQXk3KJ4TLQEp8PVrjMo5ssZ7JBEMyG14gI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYAsaBBfaF2jguuCPRnEQ+j66yNbOixes4ghnnBjX4E+Td6OfH
	MoDShoSznG6inr8Uk+WIIGdHCz2hVzYFG92vUY4QVMcbidaGnDO0FwoSQ05PeLa4ohA=
X-Gm-Gg: ASbGnctk1eqWB5/M2XAHVTomgtONJb80X9yoWZPcbe2/2PsrjfBxvRXoZh2xVqjgf51
	UwsG6o4D0fcUQvB7w6b3hUQbLmrVUUzYcj8A5xVhMRhsog5aqWZWYJc1uKTrSMIyefFL2ZwhV1/
	klLMdE+T9gOZPQqiXUZ+AypZ2wnyhXtFPfpQLHgwfLESETMTbGGkXLTk2UO5LRAuqOqB0SzRQyK
	u4MssLXD/lZdwWKoN2LU+hvJrxS6aEmrZRaBdjh3GA8eddr1gDUE8Z3ZY21n7aKIL6NMWb784at
	CX/Tn47R1T0VzdiXyIrpjcDL7W1mjIOrvonKfGRv8ThmazKsroTMgLrIggNwVz5YrYeMsqTl3C5
	PuDs+qJh3KCrPZ/6AnVaVSTMmW7UXKuYxmtXif/jPigAG4OFpNNC0YkhVbx/MZFIly2M1l+tsFq
	cCLttmE/jlk8i3R4Pf6RZV0QUilSIOTQ==
X-Google-Smtp-Source: AGHT+IFP18ee6bgm/ejyh8kmRYFVi1hqLlMKkbtTf3ZacHJyOl7EopZwJsToQT2tvIjzxTw/P2KdoA==
X-Received: by 2002:a05:600c:3149:b0:46e:3b81:c3f9 with SMTP id 5b1f17b1804b1-46e61269212mr56566845e9.17.1759394543997;
        Thu, 02 Oct 2025 01:42:23 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e693c2e6fsm23962295e9.17.2025.10.02.01.42.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 02 Oct 2025 01:42:23 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v4 04/17] hw/s390x/sclp: Use address_space_memory_is_io() in sclp_service_call()
Date: Thu,  2 Oct 2025 10:41:49 +0200
Message-ID: <20251002084203.63899-5-philmd@linaro.org>
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

When cpu_address_space_init() isn't called during vCPU creation,
its single address space is the global &address_space_memory.

As s390x boards don't call cpu_address_space_init(), cpu->as
points to &address_space_memory.

We can then replace cpu_physical_memory_is_io() by the semantically
equivalent address_space_memory_is_io() call.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 hw/s390x/sclp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/hw/s390x/sclp.c b/hw/s390x/sclp.c
index 9718564fa42..16057356b11 100644
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
@@ -308,7 +309,7 @@ int sclp_service_call(S390CPU *cpu, uint64_t sccb, uint32_t code)
     if (env->psw.mask & PSW_MASK_PSTATE) {
         return -PGM_PRIVILEGED;
     }
-    if (cpu_physical_memory_is_io(sccb)) {
+    if (address_space_is_io(CPU(cpu)->as, sccb)) {
         return -PGM_ADDRESSING;
     }
     if ((sccb & ~0x1fffUL) == 0 || (sccb & ~0x1fffUL) == env->psa
-- 
2.51.0


