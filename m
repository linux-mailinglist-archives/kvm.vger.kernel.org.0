Return-Path: <kvm+bounces-50217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A025AE262C
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 01:22:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4425189F1E9
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 23:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A17FF24DCFB;
	Fri, 20 Jun 2025 23:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3gqYClI4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688582494F0
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 23:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750461682; cv=none; b=k08f6/WiOmTQ4y/7q+3nYDXs9dHx3qt/SPsuZjx7j3ep9aTcm2e/XTwxhGHC5jxPnbIrFcLqd+4Y148Lm37Lt9hWF+ioYOjDyptAjtzA6/Bt8IdaIYanMfkxyr+2kiWm4IkYr1xwlr2jBdTDgwiF0RkJuaDoIiZWvwyp5kBbsd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750461682; c=relaxed/simple;
	bh=/gFFNVd7bwLeoJYgrwOu6qpw9rprLNcNtUCRwUJjaIQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YTVLdt1VEC5SJP5F+lI4cXviTBqvkJF0K0X3MzeVrneUDoca+UNZztYs280GqaMo7WPhlHya8NDCw0XHrH15et5LrqrzXlezvblCd+7Y6WI6uic97b8zQOhdg9q040C4s8zyzhP5L2KkV948yRewseCb7LVCYn47TuVSCWix8jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3gqYClI4; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31e1ef8890so1443564a12.2
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 16:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750461681; x=1751066481; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jNvLu7QFuLSzgFfb+o1cFiGO1Lra6YWueQxkEfGnMNs=;
        b=3gqYClI4srGQYD5yG9JQZw1fJvUkTcDzGbmDzEvZ7iWVgLvsqGBOueKqe6v1WA/gtB
         dD/53nLwZtX8vvozOrl4vYpKBA+LU1xynPljodicXV1voCtqXSp1VK9RSzrNqdfwcb+m
         2ECmsvc/tG0pe2k1boGsnMm9cOSIUMF29EAUOYp6LaofVKN1C97Dr7ix2StLZpGvKY0Y
         kBtv9vhu1ylxU4n+f4j24ChTR9GiGcbJz0KlCebGBv+BpbsswJuAoHECUv11cQtD8C5P
         GDauveoR9JSbU672N3iMNVCupZGUh6vb2rM85cTHU7CuVxIyyegByGyXB3tFpvEBuqzX
         yZgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750461681; x=1751066481;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jNvLu7QFuLSzgFfb+o1cFiGO1Lra6YWueQxkEfGnMNs=;
        b=JJfoa9W+18behTn+gpX4QaZETCeBdfeOJRsfrD803sZMKKnj9nqTEi2TzmyUvNrAl8
         /uFwnYadvutxoCyXqhNNQotfXFm0opXS0ZaVOdypHHrTZE9Pcj+gkSYC4DPCSLEOaiy3
         rCghzVmXTns27WxWI4BCLjBWkdYEEbimMS/fDHJ475F6iGYPdQnYnyS8TpfG2urv/HYI
         1+67EkJnbNN6FplP2jweR2P10KPvpg5cjwZaGUGHp2oCvwxxI0IOLgcZpMdVT+/eiIP0
         HiMy5Nnxc5Uj1aTRTT0VrTYyq7OWVURedXBT7y5LH1/JUTjPLC/WWiKbpmqpynFMs6Iw
         UpAA==
X-Forwarded-Encrypted: i=1; AJvYcCXgNpHDir/OkrEThUU2Xxr3pwil6uVLnaSIXXKkIjZY2xfHTLQuVOc9uu/JEyVomr46fCw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn7U5ZBfZKkgMMWzUp5Ubnxbx2gBu0JTq3IJDP+hCBQTs3GSGL
	C+S729G0RC601eF5p5xLqEQZcMxNCBIFif7Ma02QkMARsqv+QcKAE8/G5d4Llg40bRihehaWFqf
	VR7+Fjzqz56hfgg==
X-Google-Smtp-Source: AGHT+IE5U13pCesAd3SJBRAIp4RiZ7MjGkyuGqvxaCmz6abdXRn4Yx5dm8NsY5+C+uRgn5qVoevhE/+QEM0c8A==
X-Received: from pjbov4.prod.google.com ([2002:a17:90b:2584:b0:30e:6bb2:6855])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5647:b0:311:fc8b:31b5 with SMTP id 98e67ed59e1d1-3159d64820emr7798200a91.14.1750461680722;
 Fri, 20 Jun 2025 16:21:20 -0700 (PDT)
Date: Fri, 20 Jun 2025 23:20:10 +0000
In-Reply-To: <20250620232031.2705638-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250620232031.2705638-1-dmatlack@google.com>
X-Mailer: git-send-email 2.50.0.rc2.701.gf1e915cc24-goog
Message-ID: <20250620232031.2705638-13-dmatlack@google.com>
Subject: [PATCH 12/33] tools headers: Import iosubmit_cmds512()
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Bibo Mao <maobibo@loongson.cn>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, David Matlack <dmatlack@google.com>, dmaengine@vger.kernel.org, 
	Huacai Chen <chenhuacai@kernel.org>, James Houghton <jthoughton@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joel Granados <joel.granados@kernel.org>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, "Pratik R. Sampat" <prsampat@amd.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Wei Yang <richard.weiyang@gmail.com>, "Yury Norov [NVIDIA]" <yury.norov@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Import iosubmit_cmds512() from arch/x86/include/asm/io.h into tools/ so
it can be used by VFIO selftests to interact with Intel DSA devices.

Also pull in movdir64b() from arch/x86/include/asm/special_insns.h into
tools/, which is the underlying instruction used by iosubmit_cmds512().

Changes made when importing: None

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/arch/x86/include/asm/io.h            | 26 +++++++++++++++++++++
 tools/arch/x86/include/asm/special_insns.h | 27 ++++++++++++++++++++++
 2 files changed, 53 insertions(+)
 create mode 100644 tools/arch/x86/include/asm/special_insns.h

diff --git a/tools/arch/x86/include/asm/io.h b/tools/arch/x86/include/asm/io.h
index 4c787a2363de..ecad61a3ea52 100644
--- a/tools/arch/x86/include/asm/io.h
+++ b/tools/arch/x86/include/asm/io.h
@@ -4,6 +4,7 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include "special_insns.h"
 
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
@@ -72,4 +73,29 @@ build_mmio_write(__writeq, "q", u64, "r", )
 
 #include <asm-generic/io.h>
 
+/**
+ * iosubmit_cmds512 - copy data to single MMIO location, in 512-bit units
+ * @dst: destination, in MMIO space (must be 512-bit aligned)
+ * @src: source
+ * @count: number of 512 bits quantities to submit
+ *
+ * Submit data from kernel space to MMIO space, in units of 512 bits at a
+ * time.  Order of access is not guaranteed, nor is a memory barrier
+ * performed afterwards.
+ *
+ * Warning: Do not use this helper unless your driver has checked that the CPU
+ * instruction is supported on the platform.
+ */
+static inline void iosubmit_cmds512(void __iomem *dst, const void *src,
+				    size_t count)
+{
+	const u8 *from = src;
+	const u8 *end = from + count * 64;
+
+	while (from < end) {
+		movdir64b(dst, from);
+		from += 64;
+	}
+}
+
 #endif /* _TOOLS_ASM_X86_IO_H */
diff --git a/tools/arch/x86/include/asm/special_insns.h b/tools/arch/x86/include/asm/special_insns.h
new file mode 100644
index 000000000000..04af42a99c38
--- /dev/null
+++ b/tools/arch/x86/include/asm/special_insns.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TOOLS_ASM_X86_SPECIAL_INSNS_H
+#define _TOOLS_ASM_X86_SPECIAL_INSNS_H
+
+/* The dst parameter must be 64-bytes aligned */
+static inline void movdir64b(void *dst, const void *src)
+{
+	const struct { char _[64]; } *__src = src;
+	struct { char _[64]; } *__dst = dst;
+
+	/*
+	 * MOVDIR64B %(rdx), rax.
+	 *
+	 * Both __src and __dst must be memory constraints in order to tell the
+	 * compiler that no other memory accesses should be reordered around
+	 * this one.
+	 *
+	 * Also, both must be supplied as lvalues because this tells
+	 * the compiler what the object is (its size) the instruction accesses.
+	 * I.e., not the pointers but what they point to, thus the deref'ing '*'.
+	 */
+	asm volatile(".byte 0x66, 0x0f, 0x38, 0xf8, 0x02"
+		     : "+m" (*__dst)
+		     :  "m" (*__src), "a" (__dst), "d" (__src));
+}
+
+#endif /* _TOOLS_ASM_X86_SPECIAL_INSNS_H */
-- 
2.50.0.rc2.701.gf1e915cc24-goog


