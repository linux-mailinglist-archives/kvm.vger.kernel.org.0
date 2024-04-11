Return-Path: <kvm+bounces-14297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01B4E8A1DD5
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:19:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 243151C24AB7
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D605A4E1;
	Thu, 11 Apr 2024 17:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PEUFTMw/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DBE59B76
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856601; cv=none; b=B10IHJIDZXfqT9qy3h2JPRRCe0YeJ6qu+SbUO1CLNzQEWwiEf+YMkXlWwzHkX8oFhP4jbN8tOX3+D6eJQhcmyg8SbjAbsZdRBrPFDOd1nCvLdPqz0yw/fZS01cnMVVDdnuh8aoKAr61qU7D4uyk4Y2v0dqMb/QItq5UZYf82eKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856601; c=relaxed/simple;
	bh=S4MbuOxJxC/VtZjoRP2UulPuWcPiZRcja21uuUiaKO8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HXnmWYEaLERj7oatQuz1jXX0v4BW0H9isM791n+1fXkH55/xol50i6reQf2+18sUdlHHd0HS9ZSw5KReimAyp4/XJH8uYxJWHiI1DmTffvTu+KcSu/quHoEx7xCu5A9gAO3fW5Aio+ZbzajTw+X7QcThTmTxpC3WhNJprBl3oIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PEUFTMw/; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-56e136cbcecso24446a12.3
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712856598; x=1713461398; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2AmFgND66Sq7R0Qi1yuH1soePbNmTqbpErfYtJy+2k=;
        b=PEUFTMw//fmunAwCPy2hOqQzNvA6H1fsOhLI7UIXNWah2tHIn2JodlLCgTcbpPH4b/
         hpPuv0AEPZYg8hcYiCD+jKqjxttKF1UJ61iFmsoEruscOd3mQRG/+/LlnOUgKJiKAUBh
         Gul+z3Lh32Rny+u0MAgjJMp577ddkSoHpZB6PJ2B7O+g4SbIFa24KQ+qL7YzZ9lkTaT4
         CuajaChhFfF44CCkvNqx/4x8adGvWKnwH2rWvYYbPhaEac14gH4UzskPrc+PIm9Nuv1P
         O+rwHt+tizhNisIbTRIgMOkQZlR3SC3OGtOvILYfwWilfnqIIzde+Y2xaa/TsWy0OzC+
         e45g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712856598; x=1713461398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X2AmFgND66Sq7R0Qi1yuH1soePbNmTqbpErfYtJy+2k=;
        b=j129o7ZoUUY3xdkl74iRccP5pPhJFJeyGhh4uWChCIAuggGv0aAubbqr8SFY7v2xPf
         XTQr1MS9Yt1nuSjpBdTp4DnYW8xTZM5/IUcK6FoTZCSlkINIbMEduKuRyqntQVcDxHPS
         KDDqUdNiuouQHjBewq48g8/J3TBO0fc8AyFJS4cPiULR85MRp29bWQEw3VOSoCDoEcag
         gsYoplpi++qPnuTxV/bd0dux4mHtC+mxq1nLOD6exo0r3IGYGjWg9hiMLbKIxaq21CZm
         kys597yFyMSabORZRIZR9x2wTOJ7RYt+KnLXcptTRPfX1rGOkqMK80fyv3KvZ1fFgWZV
         96GA==
X-Gm-Message-State: AOJu0YwSasXL72nvZcsONXWRfMKQ++QD9emKEUZnrA36/1Is63Bbaa6b
	Yetancrh6hwuu9jjlMMFOEBi54w8ofjyDXXiHveLpsDfOqhPaQOAy2rB7oGh
X-Google-Smtp-Source: AGHT+IGPSk06CogH86zVtY0To0YE2z8rb4FX6QgnwJL7F1eZK+UTf7cF1ie/hNiVWlfbWJlNTPv0Ng==
X-Received: by 2002:a50:d61d:0:b0:56b:e089:56ed with SMTP id x29-20020a50d61d000000b0056be08956edmr313812edi.39.1712856598035;
        Thu, 11 Apr 2024 10:29:58 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab51:1500:e6c:48bd:8b53:bc56])
        by smtp.gmail.com with ESMTPSA id j1-20020aa7de81000000b0056e62321eedsm863461edv.17.2024.04.11.10.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 10:29:57 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	zxwang42@gmail.com,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>,
	Marc Orr <marcorr@google.com>
Subject: [kvm-unit-tests PATCH v6 07/11] lib/x86: Move xsave helpers to lib/
Date: Thu, 11 Apr 2024 19:29:40 +0200
Message-Id: <20240411172944.23089-8-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411172944.23089-1-vsntk18@gmail.com>
References: <20240411172944.23089-1-vsntk18@gmail.com>
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


