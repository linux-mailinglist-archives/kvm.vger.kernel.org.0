Return-Path: <kvm+bounces-21071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A9B929761
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 12:11:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 772321C209A9
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2024 10:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559781BF3A;
	Sun,  7 Jul 2024 10:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aUQJynd0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4542A18633
	for <kvm@vger.kernel.org>; Sun,  7 Jul 2024 10:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720347094; cv=none; b=FMEuI0qywP/9GOwxlgQ9VgMevvAmTB6sT/vZSbVv8bU14hAh5lmvEW+Yp6LmmdGrKtBPo6XCgaWQbFNxogK1lqwgnjRhzjU/WVaLQuO3V/7JRw9GJV4JxphgciiiexHKGe9/N6i3bLkAF1whjsEvMBJTbEUyvFvl2cgfeD+lIhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720347094; c=relaxed/simple;
	bh=cJnkQZbsXC7GY9o0uzvLXzQTLZmTyvsDzpxNGj2DNzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZbR4P1DhpM/bdRAWhdjxedSZ5V6mTgHZfmMtdveUBkUDAdScwC7HUtX/578XdrP1XRBvlDoxbz5kq+n/7eIVldzQ5HvpHqXgbbXuoFvbHksYMXcbWDt1331AEg8Ve7YUA6UdAlQ+OfdxkLAzNYv1H5ZeHJXsigRHIsRlxZzFn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aUQJynd0; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1f9de13d6baso17006475ad.2
        for <kvm@vger.kernel.org>; Sun, 07 Jul 2024 03:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720347092; x=1720951892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OmZMt8vyZobiceZdyVHS451IlPPcAeGcJalWeFK/ZK0=;
        b=aUQJynd0tj0HMvSMv2g/Y83tfi/f/NZKULO4CpKojuduKHochSb4KYgsN+BOVPTuyP
         ImOafdp0JHXcdgNbsLMSVe6xj1G0/LrmsQs6zIlQaJDE+ISmqdVU6lGKQVhD8D0eCzok
         K3ozZ0aYn2m8Gs0qtDKk5IHcYQRGEIhWdDgVql4IOGbErK95OCcF5KBxcRhki+u3Ne5C
         NgXd30TuV+dLxRaXdKOZE2aeuX/dSd86jzd5ry4f5F+2feaJl/HozLzLZl0SvfvvZzAN
         i1MhlzDT6JDIUKrOHNQUwm1VWIXIgrai4zyfc8tu3RiMMQzhdsX9xPbNmtzXh4T/ql+3
         YaMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720347092; x=1720951892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OmZMt8vyZobiceZdyVHS451IlPPcAeGcJalWeFK/ZK0=;
        b=R15wDIDkgl2H4WXLI52qnFO4/yrz5eUAk8cTZa/cRwoqiSNvvtGlse8KYKYmVt9PsO
         GZ8DC1IyHAoogqfvWN1m5eFTGpjA9/723KIgWmMO2w8QQ25Ffd9OGZxny1xziz5WAu7p
         D6wPvxhgRHiMs0FkI/6G7wVFNTru9pAAc5RmRLT2O/+H040BBWi9SjMvNAZKEoNv2G3G
         VbPvVe1S+eTWm6P84ViUu43ouJjRdGbtJIw46qAvTZitjl6UX6UWnbTocfx2+dVAOBZ/
         lhRj8001qUPi6NxJJ6nwBUGcQCfaOimi9Wlz2z0D2HY9rRGA6wL+JCULZcHlIlqUUDbB
         uk4A==
X-Gm-Message-State: AOJu0Yyxcs4dv5Fa0Frppuh+HI3q/C4GsS2vU6N/r5vZ796fnSxoaTBa
	+0jUntn8Q0p0SeY522iFP3Gbp4uYISAeqlle6qWnCv2jN56gQmQbEWkXuP02
X-Google-Smtp-Source: AGHT+IFo88esak2xrjxpvZYKNKVYYkGvCFPyx/fwwA+gmQnKhSPXEIIzwpFfXIRO+0boMhe1k8dNgA==
X-Received: by 2002:a17:902:ce82:b0:1fb:58e3:7195 with SMTP id d9443c01a7336-1fb58e3731emr30210145ad.11.1720347091997;
        Sun, 07 Jul 2024 03:11:31 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fac1596818sm166648085ad.270.2024.07.07.03.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jul 2024 03:11:31 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v2 2/3] riscv: Update exception cause list
Date: Sun,  7 Jul 2024 18:10:51 +0800
Message-ID: <20240707101053.74386-3-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240707101053.74386-1-jamestiotio@gmail.com>
References: <20240707101053.74386-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the list of exception and interrupt causes to follow the latest
RISC-V privileged ISA specification (version 20240411 section 18.6.1).

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/csr.h       | 14 ++++++++++++++
 lib/riscv/asm/processor.h |  2 +-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/lib/riscv/asm/csr.h b/lib/riscv/asm/csr.h
index d6909d93..b3c48e8e 100644
--- a/lib/riscv/asm/csr.h
+++ b/lib/riscv/asm/csr.h
@@ -28,6 +28,7 @@
 #define EXC_SYSCALL		8
 #define EXC_HYPERVISOR_SYSCALL	9
 #define EXC_SUPERVISOR_SYSCALL	10
+#define EXC_MACHINE_SYSCALL	11
 #define EXC_INST_PAGE_FAULT	12
 #define EXC_LOAD_PAGE_FAULT	13
 #define EXC_STORE_PAGE_FAULT	15
@@ -36,6 +37,19 @@
 #define EXC_VIRTUAL_INST_FAULT		22
 #define EXC_STORE_GUEST_PAGE_FAULT	23
 
+/* Interrupt causes */
+#define IRQ_S_SOFT		1
+#define IRQ_VS_SOFT		2
+#define IRQ_M_SOFT		3
+#define IRQ_S_TIMER		5
+#define IRQ_VS_TIMER		6
+#define IRQ_M_TIMER		7
+#define IRQ_S_EXT		9
+#define IRQ_VS_EXT		10
+#define IRQ_M_EXT		11
+#define IRQ_S_GEXT		12
+#define IRQ_PMU_OVF		13
+
 #ifndef __ASSEMBLY__
 
 #define csr_swap(csr, val)					\
diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
index 6451adb5..4c9ad968 100644
--- a/lib/riscv/asm/processor.h
+++ b/lib/riscv/asm/processor.h
@@ -4,7 +4,7 @@
 #include <asm/csr.h>
 #include <asm/ptrace.h>
 
-#define EXCEPTION_CAUSE_MAX	16
+#define EXCEPTION_CAUSE_MAX	24
 #define INTERRUPT_CAUSE_MAX	16
 
 typedef void (*exception_fn)(struct pt_regs *);
-- 
2.43.0


