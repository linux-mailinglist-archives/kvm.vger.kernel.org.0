Return-Path: <kvm+bounces-15336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22B6A8AB328
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:17:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A7EC1C2335B
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03AAD1350EC;
	Fri, 19 Apr 2024 16:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ChNbrxI6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8000413118B
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543400; cv=none; b=GMeE2m6M5Nl4HeRutVLGQXLm+ev095ZvEiQBEKLLQhCf879uso+3eZ/XXi9Lsbg+Q4j4aSLpm1JHmcr3YulB/Yl80iFn/gfvR87atKoQuLG3WD9i3cjysd6D2y+KPNehivN7brHPo3ZKbIf2iNyd+i3RVrRzXynP/PJ1uJAlDnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543400; c=relaxed/simple;
	bh=S4MbuOxJxC/VtZjoRP2UulPuWcPiZRcja21uuUiaKO8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eT9eK5YGSco6AdGA843klvABZU0BG+2x3ACQ7VaIDY2au/HTML9V+0FBEctQ774eSSzJZ3q4GhnqC2tZdm8GGxHhG9QOYVbtllkQqjXl/5Gg+29I6+dAvV0rMP/wtP+utHh8IAqKMcTtpQn/ppw3hRV7GYB1Y8MEnlicXVrblCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ChNbrxI6; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4190a1bd2deso5863265e9.1
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713543396; x=1714148196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2AmFgND66Sq7R0Qi1yuH1soePbNmTqbpErfYtJy+2k=;
        b=ChNbrxI6K6ogLJuSxeN3QFVPVDTeMX8EvWU3VuoaIAM6WN2GZwNIN+cuZu34Rivwfj
         J7kiBvVlYer1BQFQ2qaMm2elspsrbow9xQNOlgvb6pcvZA0c1ORGJLb3qeyugPGiLo0A
         4sb3J5MR+NzNWpvVjPbvdPw/4hq+9AZlHmY6dcLW+Nc7pYOS/Pu/ltxX8KGbIs9Yizi3
         kjo3FItQjhP6rL2lam1xlMnNnvWoxae5IAhAJ6cWNBSdg4vrGmMdTPT5KnRKxDAztFMQ
         /4d7ZETFCqhrNtZMUMnvhc/CGwVOqGN2KvkE/Z/bBzDffjiWpEA6/UAm4AvbJUXs/4T8
         UWog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543396; x=1714148196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X2AmFgND66Sq7R0Qi1yuH1soePbNmTqbpErfYtJy+2k=;
        b=fuSC+e/43sQrt1+1M80KX76a0ZJ5Xkzryvrb/jI2wtiGMk/UsBTZk6JQam4vhyYqmd
         1hLxE2G8erNVl6Dr0xrkCjcdUx8kAdnJK6zZyKUa5cy8juPCfBxokZhMlsw9wqYRdTj+
         /hlhqaP12DiSZtl9nmxnWSdHXYJF/gdb+nQYyUULCe3UgBTCkK4b9h4+RmxrLhR5Ls/P
         rkV85Ep/8pysgMye7rRpOKmVoX3HYp/xI5jTYMg4yYqKa39gVHIW7rVQjHQpySv+RLKq
         RpUOp/zsho2MjBz0DBlHsFEHj/cVU3foqCBO+SlTJUWlezlyVXG6R4j3sC4S3785bTgB
         YhBA==
X-Gm-Message-State: AOJu0Yzju3nHC7FYtjqKkYWEXT8IjsFPgryl3uWcb/DA25Bk5VspcWlw
	4zSmu0H49Kjdka0iOSIFJl9DLGVr4GAZl8FJu/A3uDCdFdq5k7Byzk+am+zU
X-Google-Smtp-Source: AGHT+IHpWcDsQzDybucSCzCECDcsu85El4oBkOxV3F85H1D5c22V8zMjpmF3oylAeKjmUxVs37TWQQ==
X-Received: by 2002:a05:600c:45cd:b0:418:9ba3:ee76 with SMTP id s13-20020a05600c45cd00b004189ba3ee76mr1980795wmo.4.1713543396445;
        Fri, 19 Apr 2024 09:16:36 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab5e:9e00:8bce:ff73:6d2f:5c25])
        by smtp.gmail.com with ESMTPSA id je12-20020a05600c1f8c00b004183edc31adsm10742188wmb.44.2024.04.19.09.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 09:16:36 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	andrew.jones@linux.dev,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>,
	Marc Orr <marcorr@google.com>
Subject: [kvm-unit-tests PATCH v7 07/11] lib/x86: Move xsave helpers to lib/
Date: Fri, 19 Apr 2024 18:16:19 +0200
Message-Id: <20240419161623.45842-8-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419161623.45842-1-vsntk18@gmail.com>
References: <20240419161623.45842-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasant Karasulli <vkarasulli@suse.de>

Processing CPUID #VC for AMD SEV-ES requires copying xcr0 into GHCB.
Move the xsave read/write helpers used by xsave testcase to lib/x86
to share as common code.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
Reviewed-by: Marc Orr <marcorr@google.com>
---
 lib/x86/processor.h | 10 ----------
 lib/x86/xsave.c     | 26 ++++++++++++++++++++++++++
 lib/x86/xsave.h     | 15 +++++++++++++++
 x86/Makefile.common |  1 +
 x86/xsave.c         | 17 +----------------
 5 files changed, 43 insertions(+), 26 deletions(-)
 create mode 100644 lib/x86/xsave.c
 create mode 100644 lib/x86/xsave.h

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index b324cbf0..d839308f 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -477,16 +477,6 @@ static inline uint64_t rdpmc(uint32_t index)
 	return val;
 }

-static inline int xgetbv_safe(u32 index, u64 *result)
-{
-	return rdreg64_safe(".byte 0x0f,0x01,0xd0", index, result);
-}
-
-static inline int xsetbv_safe(u32 index, u64 value)
-{
-	return wrreg64_safe(".byte 0x0f,0x01,0xd1", index, value);
-}
-
 static inline int write_cr0_safe(ulong val)
 {
 	return asm_safe("mov %0,%%cr0", "r" (val));
diff --git a/lib/x86/xsave.c b/lib/x86/xsave.c
new file mode 100644
index 00000000..85aae78f
--- /dev/null
+++ b/lib/x86/xsave.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "libcflat.h"
+#include "xsave.h"
+#include "processor.h"
+
+int xgetbv_safe(u32 index, u64 *result)
+{
+	return rdreg64_safe(".byte 0x0f,0x01,0xd0", index, result);
+}
+
+int xsetbv_safe(u32 index, u64 value)
+{
+	return wrreg64_safe(".byte 0x0f,0x01,0xd1", index, value);
+}
+
+uint64_t get_supported_xcr0(void)
+{
+    struct cpuid r;
+    r = cpuid_indexed(0xd, 0);
+    printf("eax %x, ebx %x, ecx %x, edx %x\n",
+            r.a, r.b, r.c, r.d);
+    return r.a + ((u64)r.d << 32);
+}
+
+
diff --git a/lib/x86/xsave.h b/lib/x86/xsave.h
new file mode 100644
index 00000000..34c1c149
--- /dev/null
+++ b/lib/x86/xsave.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _X86_XSAVE_H_
+#define _X86_XSAVE_H_
+
+#define XCR_XFEATURE_ENABLED_MASK       0x00000000
+#define XCR_XFEATURE_ILLEGAL_MASK       0x00000010
+
+#define XSTATE_FP       0x1
+#define XSTATE_SSE      0x2
+#define XSTATE_YMM      0x4
+
+int xgetbv_safe(u32 index, u64 *result);
+int xsetbv_safe(u32 index, u64 value);
+uint64_t get_supported_xcr0(void);
+#endif
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 25ae6f78..c1e90b86 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -23,6 +23,7 @@ cflatobjs += lib/x86/stack.o
 cflatobjs += lib/x86/fault_test.o
 cflatobjs += lib/x86/delay.o
 cflatobjs += lib/x86/pmu.o
+cflatobjs += lib/x86/xsave.o
 ifeq ($(CONFIG_EFI),y)
 cflatobjs += lib/x86/amd_sev.o
 cflatobjs += lib/x86/amd_sev_vc.o
diff --git a/x86/xsave.c b/x86/xsave.c
index 5d80f245..f3cbfca4 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -1,6 +1,7 @@
 #include "libcflat.h"
 #include "desc.h"
 #include "processor.h"
+#include "xsave.h"

 #ifdef __x86_64__
 #define uint64_t unsigned long
@@ -8,22 +9,6 @@
 #define uint64_t unsigned long long
 #endif

-static uint64_t get_supported_xcr0(void)
-{
-    struct cpuid r;
-    r = cpuid_indexed(0xd, 0);
-    printf("eax %x, ebx %x, ecx %x, edx %x\n",
-            r.a, r.b, r.c, r.d);
-    return r.a + ((u64)r.d << 32);
-}
-
-#define XCR_XFEATURE_ENABLED_MASK       0x00000000
-#define XCR_XFEATURE_ILLEGAL_MASK       0x00000010
-
-#define XSTATE_FP       0x1
-#define XSTATE_SSE      0x2
-#define XSTATE_YMM      0x4
-
 static void test_xsave(void)
 {
     unsigned long cr4;
--
2.34.1


