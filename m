Return-Path: <kvm+bounces-9784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 523FD866FC3
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:03:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFF4C287401
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AFD05DF03;
	Mon, 26 Feb 2024 09:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aCwRTsUI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328C75D909;
	Mon, 26 Feb 2024 09:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708940355; cv=none; b=eooeFa8SFaukxyZ26kjpaZCpMzWv9U/P++eig6p/27cE/2LhvzhoovpkfEAMAiaZWNVkwXnjglMphV217dUhljz/84xeUrN8RVTOzQf9dDMAfie8M2Jo2PbQxsWdSq3Esv0W3BpLBTWRXvQWgqK0bSgyPWOyX7OL/d5FE3C+juI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708940355; c=relaxed/simple;
	bh=d2m4KiVJDyN7PsW2g2JBJpBikHcPI0nV2gmM4169iL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHmky5e8qkOgpOJfuJrqBjh7PbRHpqKHtaa0IdkwOh7nP5bzQERt6cenfFJsWoKvHyqfiwX1iNH7U+8V3YsvSwHKzEPZzv/8sLiCezSRwo4y7GitZZfxZNaAGM/TNZHrQRbj0BrKMqW5ewBiq43NDPAAw0AdvdJAkeBpw3Nx6V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aCwRTsUI; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3bd72353d9fso1911838b6e.3;
        Mon, 26 Feb 2024 01:39:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708940353; x=1709545153; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yFmFHP+QtAW/gWzWjKPE8XCHxHNjIB3oHgOxryrYW4g=;
        b=aCwRTsUIliA6bndK9+1jXsD66HhPrd6f+odRh+JnyC4OikWQB3Qj99xGP0XeLdY/ve
         n/ODLm1E1dxNMGvdqJN+iNYONKYHrOAY4kmjQu9wgjrwU/UhbVLNebhRnBBTYP1JhqLO
         M+Niismppq2MJBzqGpfzRT8apvdgRMjQfpq1M7RpvhuEBdQZ5WUYpkYuy2VZONvjSLYa
         ZmSn0PaNdLmgLQuZQZjbsM7ZOWHoeUZGX7ZjGQHzxqU4XIVA119NSAi/WPpyFaH4mz4U
         24NJ5wRQkcxq0dzHBHBCmdo11vvRgAXOyYj3cWYYsavY2B5nGYglGwCeDr1i8RecW8J0
         vhng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708940353; x=1709545153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yFmFHP+QtAW/gWzWjKPE8XCHxHNjIB3oHgOxryrYW4g=;
        b=s9LGcAAkG8KG+7UuXkleo8D3NocwVyuQ2U+lgh1ng5cya4gujtsvc3A3HJknqmZjzG
         LL/lforkYc/I5V3Jm3UBCNMV2PpI/t5BTdxpylDb7PK7Lh2NyyyEJu2Ee2+6JMVm8wqa
         1T01jBFBLX/HYcXBSBqbh3CxSXz1o6pj71oyfL8NO72K2S7oie4dbjg/y0m11OUV1H/l
         2pkxqCT+wThY5M92Os4fDrfFWFevB2DJmcSCMCZQZDqRQVyAPkLUclGZjyy805m8ccp0
         YJU+qDmUnT07CgAE3oSI102PhalzkKgAKZFWRHpkJlEl+2rdXuOFwW/PxLgNBm3iuNZ4
         BXqg==
X-Forwarded-Encrypted: i=1; AJvYcCWG0HQkatLxBj4uVF7TYFDxBrCIEh0NpF10Z2WCK88SwmEPbqWW87LsrbLvjxMpOOHaLnyZZERU1KFoifE912UCOOwR70vOeuCXqFTebgkU7PUOQwjQM/pNdIbHEzKZxQ==
X-Gm-Message-State: AOJu0YyCxu/MfXTAmVb5GxgzVHbA6JVDr6XS9oDtpaBXemssce0EF261
	Mrl5Lr7YYHIQJhHKOriPtMqRpHsHtXiOlgkuLvEzgZr1Kor1n9Vc
X-Google-Smtp-Source: AGHT+IEK7riyiXe4XBkSjXiTYaRk18fYrorXjR0yQSzy+Aw89puQe4obWJbTPsgNr5FUiDSgZ2fE9Q==
X-Received: by 2002:a05:6358:3386:b0:17b:b573:a437 with SMTP id i6-20020a056358338600b0017bb573a437mr73248rwd.8.1708940353115;
        Mon, 26 Feb 2024 01:39:13 -0800 (PST)
Received: from wheely.local0.net (220-235-194-103.tpgi.com.au. [220.235.194.103])
        by smtp.gmail.com with ESMTPSA id pa3-20020a17090b264300b0029929ec25fesm6036782pjb.27.2024.02.26.01.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 01:39:12 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 4/7] powerpc: add asm/time.h header with delay and get_clock_us/ms
Date: Mon, 26 Feb 2024 19:38:29 +1000
Message-ID: <20240226093832.1468383-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240226093832.1468383-1-npiggin@gmail.com>
References: <20240226093832.1468383-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This matches s390x clock and delay APIs, so common test code can start
using time facilities.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/processor.h | 21 ---------------------
 lib/powerpc/asm/time.h      | 30 ++++++++++++++++++++++++++++++
 lib/powerpc/processor.c     | 11 +++++++++++
 lib/powerpc/smp.c           |  1 +
 lib/ppc64/asm/time.h        |  1 +
 powerpc/spapr_vpa.c         |  1 +
 powerpc/sprs.c              |  1 +
 powerpc/tm.c                |  1 +
 8 files changed, 46 insertions(+), 21 deletions(-)
 create mode 100644 lib/powerpc/asm/time.h
 create mode 100644 lib/ppc64/asm/time.h

diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
index 4ad6612b3..fe1052939 100644
--- a/lib/powerpc/asm/processor.h
+++ b/lib/powerpc/asm/processor.h
@@ -43,25 +43,4 @@ static inline void mtmsr(uint64_t msr)
 	asm volatile ("mtmsrd %[msr]" :: [msr] "r" (msr) : "memory");
 }
 
-static inline uint64_t get_tb(void)
-{
-	return mfspr(SPR_TB);
-}
-
-extern void delay(uint64_t cycles);
-extern void udelay(uint64_t us);
-extern void sleep_tb(uint64_t cycles);
-extern void usleep(uint64_t us);
-
-static inline void mdelay(uint64_t ms)
-{
-	while (ms--)
-		udelay(1000);
-}
-
-static inline void msleep(uint64_t ms)
-{
-	usleep(ms * 1000);
-}
-
 #endif /* _ASMPOWERPC_PROCESSOR_H_ */
diff --git a/lib/powerpc/asm/time.h b/lib/powerpc/asm/time.h
new file mode 100644
index 000000000..72fcb1bd0
--- /dev/null
+++ b/lib/powerpc/asm/time.h
@@ -0,0 +1,30 @@
+#ifndef _ASMPOWERPC_TIME_H_
+#define _ASMPOWERPC_TIME_H_
+
+#include <libcflat.h>
+#include <asm/processor.h>
+
+static inline uint64_t get_tb(void)
+{
+	return mfspr(SPR_TB);
+}
+
+extern uint64_t get_clock_us(void);
+extern uint64_t get_clock_ms(void);
+extern void delay(uint64_t cycles);
+extern void udelay(uint64_t us);
+extern void sleep_tb(uint64_t cycles);
+extern void usleep(uint64_t us);
+
+static inline void mdelay(uint64_t ms)
+{
+	while (ms--)
+		udelay(1000);
+}
+
+static inline void msleep(uint64_t ms)
+{
+	usleep(ms * 1000);
+}
+
+#endif /* _ASMPOWERPC_TIME_H_ */
diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
index b224fc8eb..ad0d95666 100644
--- a/lib/powerpc/processor.c
+++ b/lib/powerpc/processor.c
@@ -7,6 +7,7 @@
 
 #include <libcflat.h>
 #include <asm/processor.h>
+#include <asm/time.h>
 #include <asm/ptrace.h>
 #include <asm/setup.h>
 #include <asm/barrier.h>
@@ -54,6 +55,16 @@ void do_handle_exception(struct pt_regs *regs)
 	abort();
 }
 
+uint64_t get_clock_us(void)
+{
+	return get_tb() * 1000000 / tb_hz;
+}
+
+uint64_t get_clock_ms(void)
+{
+	return get_tb() * 1000 / tb_hz;
+}
+
 void delay(uint64_t cycles)
 {
 	uint64_t start = get_tb();
diff --git a/lib/powerpc/smp.c b/lib/powerpc/smp.c
index afe436179..3e211eba8 100644
--- a/lib/powerpc/smp.c
+++ b/lib/powerpc/smp.c
@@ -7,6 +7,7 @@
  */
 
 #include <devicetree.h>
+#include <asm/time.h>
 #include <asm/setup.h>
 #include <asm/rtas.h>
 #include <asm/smp.h>
diff --git a/lib/ppc64/asm/time.h b/lib/ppc64/asm/time.h
new file mode 100644
index 000000000..326d2887a
--- /dev/null
+++ b/lib/ppc64/asm/time.h
@@ -0,0 +1 @@
+#include "../../powerpc/asm/time.h"
diff --git a/powerpc/spapr_vpa.c b/powerpc/spapr_vpa.c
index 6a3fe5e3f..c2075e157 100644
--- a/powerpc/spapr_vpa.c
+++ b/powerpc/spapr_vpa.c
@@ -10,6 +10,7 @@
 #include <util.h>
 #include <alloc.h>
 #include <asm/processor.h>
+#include <asm/time.h>
 #include <asm/setup.h>
 #include <asm/hcall.h>
 #include <asm/vpa.h>
diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index 57e487ceb..285976488 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -26,6 +26,7 @@
 #include <asm/handlers.h>
 #include <asm/hcall.h>
 #include <asm/processor.h>
+#include <asm/time.h>
 #include <asm/barrier.h>
 
 uint64_t before[1024], after[1024];
diff --git a/powerpc/tm.c b/powerpc/tm.c
index 7fa916366..6b1ceeb6e 100644
--- a/powerpc/tm.c
+++ b/powerpc/tm.c
@@ -8,6 +8,7 @@
 #include <libcflat.h>
 #include <asm/hcall.h>
 #include <asm/processor.h>
+#include <asm/time.h>
 #include <asm/handlers.h>
 #include <asm/smp.h>
 #include <asm/setup.h>
-- 
2.42.0


