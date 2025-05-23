Return-Path: <kvm+bounces-47628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 78EDAAC2C3D
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 01:31:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C22701C06DC0
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 23:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C19182206BC;
	Fri, 23 May 2025 23:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3tlNTM4+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73119217F36
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 23:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748043047; cv=none; b=AU8DV15aQQuHTYLSeOY2tpbiFEBKWq5ZaEUcgN/RF9aAq+8tAXk7GAeR9oPnzbj+AgdngKD1juUQ41UvVt8/wUScbLP/OfbHArqoHsAcpMSe35SWrC9uBGlszyAfZDfozfScUy/6v2qyhS/5jbwor+MV7u81ySXoxIbN0PbNn4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748043047; c=relaxed/simple;
	bh=pSt6hqFp0TXiq3XNe4gBZ0pAPQcGa/uFxgZiBbkD8mE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OIuUfbrE5cfDGA35h69um8m7dUDScAaVEKKiP/BXaoQ8vnx+Ptzcm5C5f8d0SspqM7ygHat4RvgjcX//6KOWVu88h65ohftKw5y12oOaYzsj8vd6qd8XX1ISfugHYVnzdCiEGsp2w2djni2qkyEN9X5HJxAPd+Jn8StCkzi6lrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3tlNTM4+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30ed0017688so376944a91.2
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 16:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748043046; x=1748647846; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2956OZuGZreL0emM+nR7xbZnosCgEt+uYi1FTVeUB/g=;
        b=3tlNTM4+ebgdIoC9AQgUMwON6bHbAtufciRy486x4IkxSaqGyP44C7XJJSzzY92cTw
         e4u+wEuPr3Txs3WudXBxjFdL5QhIFhDh2QrUbFoam2egvsuuPV+gKtjGq6LsIwWi9seT
         LVJgGMWSvfBy11BdHYdgwiiGTzSt2CIURxlJhcLb4MoIeNjAl5w03/+PfNmV45GBUexp
         4zJybFzi6yTh2vXDP/35pKX+kVHd1vIeu1Z2o8IfbC9VrNUuFZ4CN9VLnXLU33/uIFBC
         LNVXu5eP2dHB6cq/KQuKrCcqCxTypbOyNclaqsTNMlQ6A2hO+wcMQdxiqsSv53J7LF5j
         6hUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748043046; x=1748647846;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2956OZuGZreL0emM+nR7xbZnosCgEt+uYi1FTVeUB/g=;
        b=d8jMReuwdxk8Yn2QISCD6eJG9rBCkN2pbeIyPT2z9itnkP5rZCwAIjDPETEUFFKR2i
         W2ZuVR/J8dU2KYDEpHN2JfJw53BMKqCRpopOuTRIhbjfsUUu451L3VKFQmuMnuBrdp7J
         QyIujwE1Q7yH01142s2W4lPujwmUEYMzBV2lzsdC45lnwBqkC8FKywu6ylavK/qFJfdV
         KQKytmhNJ/WpSmAGIwrl6yVHK3KSeBP/pcALER8SzN4tNH+woIkSNW9z4xelPDhh17Wj
         sU9GOfXzUr2SE8amv3N6TxYHPcqEu4u9fbAXlnfMTTg+shi3odfdY+ynfkTairDZ+d6Z
         mO0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXUta2GeFdSHZFkCr50HM2HxesimqkBjTrVnBJr56r9BvVraAEP1WNRPZnMLxb/v71kqlM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb3JMjTU6oW6Ixw3Wg7kr4SQAGaW2dNjAXEx+xmTh4TWHsSV5O
	zWeFKGafhfMOlFn6JNMZA2wJGzfXDwS1Rk1gyRSoiwpXh0Ae+oMdb0RAsY4JAzpu4rhaqoPWmge
	oeppfYtzN9nZJHA==
X-Google-Smtp-Source: AGHT+IEk+iX5N8w1Ax+WlWPsiyQA+3IBKByqgkAQCQVeSWGtQJFMLj/JAnWxv4OGtypjn7p8YoLzMSe4KwbHGA==
X-Received: from pjm6.prod.google.com ([2002:a17:90b:2fc6:b0:2fa:a101:755])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:55cb:b0:30a:883a:ea5b with SMTP id 98e67ed59e1d1-3110f30e9dbmr1644757a91.17.1748043045842;
 Fri, 23 May 2025 16:30:45 -0700 (PDT)
Date: Fri, 23 May 2025 23:29:56 +0000
In-Reply-To: <20250523233018.1702151-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523233018.1702151-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523233018.1702151-12-dmatlack@google.com>
Subject: [RFC PATCH 11/33] tools headers: Import x86 MMIO helper overrides
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, Vinod Koul <vkoul@kernel.org>, 
	Fenghua Yu <fenghua.yu@intel.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, Jiri Olsa <jolsa@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Takashi Iwai <tiwai@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, WangYuli <wangyuli@uniontech.com>, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Eric Auger <eric.auger@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"

Import the x86-specific overrides for <asm-generic/io.h> from the kernel
headers into tools/include/.

Changes made when importing:
 - Replace CONFIG_X86_64 with __x86_64__.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/arch/x86/include/asm/io.h | 75 +++++++++++++++++++++++++++++++++
 tools/include/asm/io.h          |  4 ++
 2 files changed, 79 insertions(+)
 create mode 100644 tools/arch/x86/include/asm/io.h

diff --git a/tools/arch/x86/include/asm/io.h b/tools/arch/x86/include/asm/io.h
new file mode 100644
index 000000000000..4c787a2363de
--- /dev/null
+++ b/tools/arch/x86/include/asm/io.h
@@ -0,0 +1,75 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TOOLS_ASM_X86_IO_H
+#define _TOOLS_ASM_X86_IO_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+#define build_mmio_read(name, size, type, reg, barrier) \
+static inline type name(const volatile void __iomem *addr) \
+{ type ret; asm volatile("mov" size " %1,%0":reg (ret) \
+:"m" (*(volatile type __force *)addr) barrier); return ret; }
+
+#define build_mmio_write(name, size, type, reg, barrier) \
+static inline void name(type val, volatile void __iomem *addr) \
+{ asm volatile("mov" size " %0,%1": :reg (val), \
+"m" (*(volatile type __force *)addr) barrier); }
+
+build_mmio_read(readb, "b", unsigned char, "=q", :"memory")
+build_mmio_read(readw, "w", unsigned short, "=r", :"memory")
+build_mmio_read(readl, "l", unsigned int, "=r", :"memory")
+
+build_mmio_read(__readb, "b", unsigned char, "=q", )
+build_mmio_read(__readw, "w", unsigned short, "=r", )
+build_mmio_read(__readl, "l", unsigned int, "=r", )
+
+build_mmio_write(writeb, "b", unsigned char, "q", :"memory")
+build_mmio_write(writew, "w", unsigned short, "r", :"memory")
+build_mmio_write(writel, "l", unsigned int, "r", :"memory")
+
+build_mmio_write(__writeb, "b", unsigned char, "q", )
+build_mmio_write(__writew, "w", unsigned short, "r", )
+build_mmio_write(__writel, "l", unsigned int, "r", )
+
+#define readb readb
+#define readw readw
+#define readl readl
+#define readb_relaxed(a) __readb(a)
+#define readw_relaxed(a) __readw(a)
+#define readl_relaxed(a) __readl(a)
+#define __raw_readb __readb
+#define __raw_readw __readw
+#define __raw_readl __readl
+
+#define writeb writeb
+#define writew writew
+#define writel writel
+#define writeb_relaxed(v, a) __writeb(v, a)
+#define writew_relaxed(v, a) __writew(v, a)
+#define writel_relaxed(v, a) __writel(v, a)
+#define __raw_writeb __writeb
+#define __raw_writew __writew
+#define __raw_writel __writel
+
+#ifdef __x86_64__
+
+build_mmio_read(readq, "q", u64, "=r", :"memory")
+build_mmio_read(__readq, "q", u64, "=r", )
+build_mmio_write(writeq, "q", u64, "r", :"memory")
+build_mmio_write(__writeq, "q", u64, "r", )
+
+#define readq_relaxed(a)	__readq(a)
+#define writeq_relaxed(v, a)	__writeq(v, a)
+
+#define __raw_readq		__readq
+#define __raw_writeq		__writeq
+
+/* Let people know that we have them */
+#define readq			readq
+#define writeq			writeq
+
+#endif /* __x86_64__ */
+
+#include <asm-generic/io.h>
+
+#endif /* _TOOLS_ASM_X86_IO_H */
diff --git a/tools/include/asm/io.h b/tools/include/asm/io.h
index 9ae219b12604..eed5066f25c4 100644
--- a/tools/include/asm/io.h
+++ b/tools/include/asm/io.h
@@ -2,6 +2,10 @@
 #ifndef _TOOLS_ASM_IO_H
 #define _TOOLS_ASM_IO_H
 
+#if defined(__i386__) || defined(__x86_64__)
+#include "../../arch/x86/include/asm/io.h"
+#else
 #include <asm-generic/io.h>
+#endif
 
 #endif /* _TOOLS_ASM_IO_H */
-- 
2.49.0.1151.ga128411c76-goog


