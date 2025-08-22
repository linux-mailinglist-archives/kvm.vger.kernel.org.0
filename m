Return-Path: <kvm+bounces-55546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF379B32455
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:29:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1794CB67ACE
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 21:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FD143375A1;
	Fri, 22 Aug 2025 21:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R/PJMAHd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5C434DCE6
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 21:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755897994; cv=none; b=e3NhmvVGeibMoW8AryM3biE5Uqxtwmai0QjwQhivNeN3i9E2MzEjai5pQQtdvq4SEx1u+B/vHmwEAi18SjNsdKLDmgfB7nY/vd22a1+jcJGwg6QXiGz8c5RoS0GGBLZbhXkXBpijgXOPJ1ziuEnI3F5x7uVPSgqheeM04s6zx3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755897994; c=relaxed/simple;
	bh=st2bAkDcHArqlZH/Ep7aZTmX2/+vCG37gQKkypE/wcU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OwuisY81IpoKPZyAnwI5FYqskZTu863jVKEgsFSC+Io/dCXLNKr8EPzjc7z7DGCZfbRWuitSexozeLQgZpBoJmJmfAV7jmA/IZnVgYbL03wq2BH7uw0B9FkiE5oC+KTJ+SB2zvTFLRQsu5xAu01Uzs3HS+vp1kv5+pmsJnakVIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R/PJMAHd; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b49ca6ba890so780400a12.2
        for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 14:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755897992; x=1756502792; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NewM7guCQbZ54DkrDr3Nbxt1PFBAZlwvsa0ASdQoorY=;
        b=R/PJMAHdKVQJkrjSs9IrpdXTb1LKRmoe/JxXHzJb8Z57Y9cYck9QgmNIFQKoJ/YIkI
         O1hAqPGBu9kRjpXvE+Dwo2RI7Z0fuOvZwAJpzJ/kNNkARUoVN3zGJ4VtFHFsAGO+ymTO
         +Q/b8+DhMv5sEQplZkXNwHDanXWTKXEGUkgS2u2NfNHzZtXj7YBarCwCSMtgsDQ0Y/jy
         AES63OUqDYwTAkJxWulKyN1SLK5ilXgrAwAX6IzCdBQ3XVbJG0URJbQEN+FbLv0Keojv
         X/lxCmYhhLxvx043iH/mQMSZgzp1S7y0qRDNML+k9OOIOn/i6MIflBfZ6lyt+LXu6mAC
         xTeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755897992; x=1756502792;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NewM7guCQbZ54DkrDr3Nbxt1PFBAZlwvsa0ASdQoorY=;
        b=L1HEafVpdKuB4QGUKIFGnMMb+HFjgqf1lHz14xsyqRJotwSpnVpbPNJF5H0u4bX9p8
         12t/YwPo//m3rVPp+bXOMeZrONHGdSNl6aMcUNkgzVwuudIOAI1gOUy//dRhSpd8FTV5
         AaJ9irQzB+fU4oOSiPrmvVAMoxO3l/5/bYrL6ZeAbB1wEkXRpI7zgLEVGMhuRxJBvUnd
         p/mylKw/3NW5Wy303h3xbtZtIDuC7oe5zRyKG6YE/M9H/15PlKQkONX0Ni0yE7m5Ox14
         LOyjwA9o2rKBMFfqKGhPgaXYM3PH8OI+D9/8oKfxIFvDK2U7jN+d0MX4j0/JH3vvLSBd
         yNGw==
X-Forwarded-Encrypted: i=1; AJvYcCUXg8r01osKA8ELwE8j3SejZzQcm7JvnQIxcDOWxRhSxscACmn3RtdDQ3XywOcWvKDreaQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTlPWEKsYBDr5aiDUQEieVIkWGQKS32d1A01XmPAHn/R7LRdVA
	1Do45Dzy8q1M1Y/IQCxQnb3FHCLNTRCpnMkxLche7xxuXMMl6K+L5zcVrPSAdllvopN8KVnpPE0
	kPW8yDfZDhQALXA==
X-Google-Smtp-Source: AGHT+IH0eU89n3fh/RFsflbfoqEeSyt3RNSN7kC81WRTN2L5uMvUPH4QIwTpFFDFaU6Xc6tjT4Fnadhoix3CHQ==
X-Received: from pgjh17.prod.google.com ([2002:a63:df51:0:b0:b42:c17:47ac])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7fa7:b0:243:15b9:7791 with SMTP id adf61e73a8af0-24340eb3d15mr6068245637.53.1755897992392;
 Fri, 22 Aug 2025 14:26:32 -0700 (PDT)
Date: Fri, 22 Aug 2025 21:25:03 +0000
In-Reply-To: <20250822212518.4156428-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822212518.4156428-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250822212518.4156428-17-dmatlack@google.com>
Subject: [PATCH v2 16/30] tools headers: Import x86 MMIO helper overrides
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	David Matlack <dmatlack@google.com>, dmaengine@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Joel Granados <joel.granados@kernel.org>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	"Yury Norov [NVIDIA]" <yury.norov@gmail.com>, Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

Import the x86-specific overrides for <asm-generic/io.h> from the kernel
headers into tools/include/.

Changes made when importing:
 - Replace CONFIG_X86_64 with __x86_64__.

Acked-by: Shuah Khan <skhan@linuxfoundation.org>
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
2.51.0.rc2.233.g662b1ed5c5-goog


