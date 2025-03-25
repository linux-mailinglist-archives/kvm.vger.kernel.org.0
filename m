Return-Path: <kvm+bounces-41891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AF07A6E8F6
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:59:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DB413ABD65
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 04:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D581A9B4A;
	Tue, 25 Mar 2025 04:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cope2sEI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9C631A89
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878765; cv=none; b=bQuh3uv+7iRsagNI775ymrb/awHxSqRNuKZWMGdezB9wnSsD/bOL+YR8W5ZGFBbGW0qlY0jcDgSPEH+fVwHTim6L6Mq4gz88t8N0SoMPB/CsplB4CNehe4b4+9N6dkfLFosUNh1gSQZD0r8SrFp+Kj/dEhcaE8AGLT3wx8hKq7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878765; c=relaxed/simple;
	bh=Ny5Bh9oYYPXTTCrYt/icci9ooqg22E+ZTMX1zNpAzG0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DgKs+3KmcFEFnhgFfqoJ6bvA7wJr4oaNLdOtQvVqP0iVEKB3K/UpUpzjz2eO5w/AhHr0zZxQHwbChnoHZpiza+4LXaOyqgSBh4+yKIUJrRyWxMT+rNUQHZzvD2ktTqysc77E69fjC0IiGsFIaJYWLLtDTVZUn7VoQVLuI2gNicA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cope2sEI; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3018e2d042bso6349867a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878763; x=1743483563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5F5Dzae+RyDol+flZMgGIl7VK6PFPHMGXCHLqJN/jSE=;
        b=cope2sEIr6SiqTzPoCCksrhaCyXbp+WQJuXsvST6ZAe6EzNDVFvFitCpVZlyR3QBv1
         QU708RJ+aFIakm5nF2LWxY2djSsZR+g65hqzNawAkVByAFDNmJce0Yr9IIx9mg0gEBP2
         cnlOIhG4VFILMzOAWXjJU7tjuIlfP+ZgcT3uLQyJVfA0OHaZvCjKa6Rs0OI+g7VBczZ7
         ciFwDeYoJS9YtQf3R/ywHjIf7F+w3zF9s5WDFMVX55MWwFj6Ny4E3RlyQp56c9VJgOIz
         M6a8n0wYQ+sXoZTMfCZkNTpCG+AU32dW/rf6ibdCfdcst1TRA0l5fv8rEBrmw6xQn/kr
         yNQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878763; x=1743483563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5F5Dzae+RyDol+flZMgGIl7VK6PFPHMGXCHLqJN/jSE=;
        b=P1SWt7d1ZCbBT1G63vr4eTARcsusX5xSz7YIxzVHtDJd+0Nu1qZiDiL8He52ItX5R8
         zSZ+UNEbUPhlev9cYUytkV9DlWCJcwlhwT1SNfox9wIdncQZ34tXsn5EzROb5jwHEIJ5
         QjKbGVePrmwLFZlfDXpKLzwQy5MBiNcxzu3ydsogDdE8sdCie7kOBI4JX2WrvFZmT1SC
         oPxVG2dY+2dfUrFkW6kLvvZbYR1ltkY1DpYHwyl5EOhPi5i2yuYfdsyW94oKxtoI35iU
         LeTI0oKAKbZea9g7Mk+SH4fK5dn7xQRaBk/mTbfffeKA7s5qhO8UESPd/2s0+LjjjuHY
         4AVw==
X-Forwarded-Encrypted: i=1; AJvYcCVjn3CWvhzzsD6EvuxTOPdcx+RQyoC77uYLoGK4rgbmwdMiaKWxss/eCCv4p5NKumwr6Fk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4kPj93Ibb+W+paR42enyUAq6YTij3T4avuvOliNmIS9hCh0MF
	vQCLRklz7UiVxM9Jo5f9cy2KW1VcsIVyqFr8eKgZKFIzqIyEkgDRE7vikX4gCqE=
X-Gm-Gg: ASbGnctEtS4hFTczGMiuY7uQxZ1HxiX+PCzTzPJlC9KmnZkCfV2+GHSu3StOSTfwiAj
	fA/ojWemyrxLfvWStnKVM1Ez6YofaiWoR53byu29lMBBgGd7sVDzJwyA6nzrSTBlcDjTpxAxTdq
	7746Fyw18Xlv0ebhav9sHZzwgUTp5+6zSTTck6U4peRW7uAHZUyLczeVtBiI7U68gTud1BqaFMp
	+/mqMLR0m+oXekXUw9mJ8I3lGRXD5WhLzygFBtMOJXOCiSeDnBlmjHfw3wo16dV6El1j+ogcLeI
	go1U1kCMCng12byq05feRqBL6EK66+v7e627+jfMh1yV
X-Google-Smtp-Source: AGHT+IH0t6uEZiEjwREkVEMOOv9C57dpUIwXt6vTK/JF30OlSjVJqYS2wxVP5/VT54dMYHTpk3oDTg==
X-Received: by 2002:a17:90b:1f81:b0:2fa:157e:c78e with SMTP id 98e67ed59e1d1-3030fe6a098mr26719254a91.7.1742878762798;
        Mon, 24 Mar 2025 21:59:22 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:22 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 01/29] exec/cpu-all: extract tlb flags defines to exec/tlb-flags.h
Date: Mon, 24 Mar 2025 21:58:46 -0700
Message-Id: <20250325045915.994760-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h               | 63 --------------------
 include/exec/tlb-flags.h             | 87 ++++++++++++++++++++++++++++
 accel/tcg/cputlb.c                   |  1 +
 accel/tcg/user-exec.c                |  1 +
 semihosting/uaccess.c                |  1 +
 target/arm/ptw.c                     |  1 +
 target/arm/tcg/helper-a64.c          |  1 +
 target/arm/tcg/mte_helper.c          |  1 +
 target/arm/tcg/sve_helper.c          |  1 +
 target/i386/tcg/system/excp_helper.c |  1 +
 target/riscv/op_helper.c             |  1 +
 target/riscv/vector_helper.c         |  1 +
 target/s390x/tcg/mem_helper.c        |  1 +
 target/sparc/mmu_helper.c            |  1 +
 14 files changed, 99 insertions(+), 63 deletions(-)
 create mode 100644 include/exec/tlb-flags.h

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 013fcc9412a..d2895fb55b1 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -36,69 +36,6 @@ CPUArchState *cpu_copy(CPUArchState *env);
 
 #include "cpu.h"
 
-#ifdef CONFIG_USER_ONLY
-
-/*
- * Allow some level of source compatibility with softmmu.  We do not
- * support any of the more exotic features, so only invalid pages may
- * be signaled by probe_access_flags().
- */
-#define TLB_INVALID_MASK    (1 << (TARGET_PAGE_BITS_MIN - 1))
-#define TLB_MMIO            (1 << (TARGET_PAGE_BITS_MIN - 2))
-#define TLB_WATCHPOINT      0
-
-#else
-
-/*
- * Flags stored in the low bits of the TLB virtual address.
- * These are defined so that fast path ram access is all zeros.
- * The flags all must be between TARGET_PAGE_BITS and
- * maximum address alignment bit.
- *
- * Use TARGET_PAGE_BITS_MIN so that these bits are constant
- * when TARGET_PAGE_BITS_VARY is in effect.
- *
- * The count, if not the placement of these bits is known
- * to tcg/tcg-op-ldst.c, check_max_alignment().
- */
-/* Zero if TLB entry is valid.  */
-#define TLB_INVALID_MASK    (1 << (TARGET_PAGE_BITS_MIN - 1))
-/* Set if TLB entry references a clean RAM page.  The iotlb entry will
-   contain the page physical address.  */
-#define TLB_NOTDIRTY        (1 << (TARGET_PAGE_BITS_MIN - 2))
-/* Set if TLB entry is an IO callback.  */
-#define TLB_MMIO            (1 << (TARGET_PAGE_BITS_MIN - 3))
-/* Set if TLB entry writes ignored.  */
-#define TLB_DISCARD_WRITE   (1 << (TARGET_PAGE_BITS_MIN - 4))
-/* Set if the slow path must be used; more flags in CPUTLBEntryFull. */
-#define TLB_FORCE_SLOW      (1 << (TARGET_PAGE_BITS_MIN - 5))
-
-/*
- * Use this mask to check interception with an alignment mask
- * in a TCG backend.
- */
-#define TLB_FLAGS_MASK \
-    (TLB_INVALID_MASK | TLB_NOTDIRTY | TLB_MMIO \
-    | TLB_FORCE_SLOW | TLB_DISCARD_WRITE)
-
-/*
- * Flags stored in CPUTLBEntryFull.slow_flags[x].
- * TLB_FORCE_SLOW must be set in CPUTLBEntry.addr_idx[x].
- */
-/* Set if TLB entry requires byte swap.  */
-#define TLB_BSWAP            (1 << 0)
-/* Set if TLB entry contains a watchpoint.  */
-#define TLB_WATCHPOINT       (1 << 1)
-/* Set if TLB entry requires aligned accesses.  */
-#define TLB_CHECK_ALIGNED    (1 << 2)
-
-#define TLB_SLOW_FLAGS_MASK  (TLB_BSWAP | TLB_WATCHPOINT | TLB_CHECK_ALIGNED)
-
-/* The two sets of flags must not overlap. */
-QEMU_BUILD_BUG_ON(TLB_FLAGS_MASK & TLB_SLOW_FLAGS_MASK);
-
-#endif /* !CONFIG_USER_ONLY */
-
 /* Validate correct placement of CPUArchState. */
 QEMU_BUILD_BUG_ON(offsetof(ArchCPU, parent_obj) != 0);
 QEMU_BUILD_BUG_ON(offsetof(ArchCPU, env) != sizeof(CPUState));
diff --git a/include/exec/tlb-flags.h b/include/exec/tlb-flags.h
new file mode 100644
index 00000000000..c371ae77602
--- /dev/null
+++ b/include/exec/tlb-flags.h
@@ -0,0 +1,87 @@
+/*
+ * TLB flags definition
+ *
+ *  Copyright (c) 2003 Fabrice Bellard
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation; either
+ * version 2.1 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this library; if not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef TLB_FLAGS_H
+#define TLB_FLAGS_H
+
+#include "exec/cpu-defs.h"
+
+#ifdef CONFIG_USER_ONLY
+
+/*
+ * Allow some level of source compatibility with softmmu.  We do not
+ * support any of the more exotic features, so only invalid pages may
+ * be signaled by probe_access_flags().
+ */
+#define TLB_INVALID_MASK    (1 << (TARGET_PAGE_BITS_MIN - 1))
+#define TLB_MMIO            (1 << (TARGET_PAGE_BITS_MIN - 2))
+#define TLB_WATCHPOINT      0
+
+#else
+
+/*
+ * Flags stored in the low bits of the TLB virtual address.
+ * These are defined so that fast path ram access is all zeros.
+ * The flags all must be between TARGET_PAGE_BITS and
+ * maximum address alignment bit.
+ *
+ * Use TARGET_PAGE_BITS_MIN so that these bits are constant
+ * when TARGET_PAGE_BITS_VARY is in effect.
+ *
+ * The count, if not the placement of these bits is known
+ * to tcg/tcg-op-ldst.c, check_max_alignment().
+ */
+/* Zero if TLB entry is valid.  */
+#define TLB_INVALID_MASK    (1 << (TARGET_PAGE_BITS_MIN - 1))
+/* Set if TLB entry references a clean RAM page.  The iotlb entry will
+   contain the page physical address.  */
+#define TLB_NOTDIRTY        (1 << (TARGET_PAGE_BITS_MIN - 2))
+/* Set if TLB entry is an IO callback.  */
+#define TLB_MMIO            (1 << (TARGET_PAGE_BITS_MIN - 3))
+/* Set if TLB entry writes ignored.  */
+#define TLB_DISCARD_WRITE   (1 << (TARGET_PAGE_BITS_MIN - 4))
+/* Set if the slow path must be used; more flags in CPUTLBEntryFull. */
+#define TLB_FORCE_SLOW      (1 << (TARGET_PAGE_BITS_MIN - 5))
+
+/*
+ * Use this mask to check interception with an alignment mask
+ * in a TCG backend.
+ */
+#define TLB_FLAGS_MASK \
+    (TLB_INVALID_MASK | TLB_NOTDIRTY | TLB_MMIO \
+    | TLB_FORCE_SLOW | TLB_DISCARD_WRITE)
+
+/*
+ * Flags stored in CPUTLBEntryFull.slow_flags[x].
+ * TLB_FORCE_SLOW must be set in CPUTLBEntry.addr_idx[x].
+ */
+/* Set if TLB entry requires byte swap.  */
+#define TLB_BSWAP            (1 << 0)
+/* Set if TLB entry contains a watchpoint.  */
+#define TLB_WATCHPOINT       (1 << 1)
+/* Set if TLB entry requires aligned accesses.  */
+#define TLB_CHECK_ALIGNED    (1 << 2)
+
+#define TLB_SLOW_FLAGS_MASK  (TLB_BSWAP | TLB_WATCHPOINT | TLB_CHECK_ALIGNED)
+
+/* The two sets of flags must not overlap. */
+QEMU_BUILD_BUG_ON(TLB_FLAGS_MASK & TLB_SLOW_FLAGS_MASK);
+
+#endif /* !CONFIG_USER_ONLY */
+
+#endif /* TLB_FLAGS_H */
diff --git a/accel/tcg/cputlb.c b/accel/tcg/cputlb.c
index 613f919fffb..b2db49e305e 100644
--- a/accel/tcg/cputlb.c
+++ b/accel/tcg/cputlb.c
@@ -34,6 +34,7 @@
 #include "qemu/error-report.h"
 #include "exec/log.h"
 #include "exec/helper-proto-common.h"
+#include "exec/tlb-flags.h"
 #include "qemu/atomic.h"
 #include "qemu/atomic128.h"
 #include "tb-internal.h"
diff --git a/accel/tcg/user-exec.c b/accel/tcg/user-exec.c
index ebc7c3ecf54..667c5e03543 100644
--- a/accel/tcg/user-exec.c
+++ b/accel/tcg/user-exec.c
@@ -21,6 +21,7 @@
 #include "disas/disas.h"
 #include "exec/vaddr.h"
 #include "exec/exec-all.h"
+#include "exec/tlb-flags.h"
 #include "tcg/tcg.h"
 #include "qemu/bitops.h"
 #include "qemu/rcu.h"
diff --git a/semihosting/uaccess.c b/semihosting/uaccess.c
index a9578911669..cb64725a37c 100644
--- a/semihosting/uaccess.c
+++ b/semihosting/uaccess.c
@@ -11,6 +11,7 @@
 #include "exec/cpu-all.h"
 #include "exec/cpu-mmu-index.h"
 #include "exec/exec-all.h"
+#include "exec/tlb-flags.h"
 #include "semihosting/uaccess.h"
 
 void *uaccess_lock_user(CPUArchState *env, target_ulong addr,
diff --git a/target/arm/ptw.c b/target/arm/ptw.c
index 43309003486..8d4e9e07a94 100644
--- a/target/arm/ptw.c
+++ b/target/arm/ptw.c
@@ -12,6 +12,7 @@
 #include "qemu/main-loop.h"
 #include "exec/exec-all.h"
 #include "exec/page-protection.h"
+#include "exec/tlb-flags.h"
 #include "cpu.h"
 #include "internals.h"
 #include "cpu-features.h"
diff --git a/target/arm/tcg/helper-a64.c b/target/arm/tcg/helper-a64.c
index 9244848efed..fa79d19425f 100644
--- a/target/arm/tcg/helper-a64.c
+++ b/target/arm/tcg/helper-a64.c
@@ -31,6 +31,7 @@
 #include "exec/cpu-common.h"
 #include "exec/exec-all.h"
 #include "exec/cpu_ldst.h"
+#include "exec/tlb-flags.h"
 #include "qemu/int128.h"
 #include "qemu/atomic128.h"
 #include "fpu/softfloat.h"
diff --git a/target/arm/tcg/mte_helper.c b/target/arm/tcg/mte_helper.c
index 80164a80504..888c6707547 100644
--- a/target/arm/tcg/mte_helper.c
+++ b/target/arm/tcg/mte_helper.c
@@ -31,6 +31,7 @@
 #endif
 #include "exec/cpu_ldst.h"
 #include "exec/helper-proto.h"
+#include "exec/tlb-flags.h"
 #include "accel/tcg/cpu-ops.h"
 #include "qapi/error.h"
 #include "qemu/guest-random.h"
diff --git a/target/arm/tcg/sve_helper.c b/target/arm/tcg/sve_helper.c
index d786b4b1118..e3bed77b48e 100644
--- a/target/arm/tcg/sve_helper.c
+++ b/target/arm/tcg/sve_helper.c
@@ -23,6 +23,7 @@
 #include "exec/exec-all.h"
 #include "exec/page-protection.h"
 #include "exec/helper-proto.h"
+#include "exec/tlb-flags.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "fpu/softfloat.h"
 #include "tcg/tcg.h"
diff --git a/target/i386/tcg/system/excp_helper.c b/target/i386/tcg/system/excp_helper.c
index 6876329de21..b0b74df72fd 100644
--- a/target/i386/tcg/system/excp_helper.c
+++ b/target/i386/tcg/system/excp_helper.c
@@ -22,6 +22,7 @@
 #include "exec/cpu_ldst.h"
 #include "exec/cputlb.h"
 #include "exec/page-protection.h"
+#include "exec/tlb-flags.h"
 #include "tcg/helper-tcg.h"
 
 typedef struct TranslateParams {
diff --git a/target/riscv/op_helper.c b/target/riscv/op_helper.c
index 72dc48e58d3..f3d26b6b957 100644
--- a/target/riscv/op_helper.c
+++ b/target/riscv/op_helper.c
@@ -25,6 +25,7 @@
 #include "exec/cputlb.h"
 #include "exec/cpu_ldst.h"
 #include "exec/helper-proto.h"
+#include "exec/tlb-flags.h"
 #include "trace.h"
 
 /* Exceptions processing helpers */
diff --git a/target/riscv/vector_helper.c b/target/riscv/vector_helper.c
index 67b3bafebbe..83978be0603 100644
--- a/target/riscv/vector_helper.c
+++ b/target/riscv/vector_helper.c
@@ -25,6 +25,7 @@
 #include "exec/cpu_ldst.h"
 #include "exec/page-protection.h"
 #include "exec/helper-proto.h"
+#include "exec/tlb-flags.h"
 #include "fpu/softfloat.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "internals.h"
diff --git a/target/s390x/tcg/mem_helper.c b/target/s390x/tcg/mem_helper.c
index 8187b917ba1..0ff2e10d816 100644
--- a/target/s390x/tcg/mem_helper.c
+++ b/target/s390x/tcg/mem_helper.c
@@ -29,6 +29,7 @@
 #include "exec/cputlb.h"
 #include "exec/page-protection.h"
 #include "exec/cpu_ldst.h"
+#include "exec/tlb-flags.h"
 #include "accel/tcg/cpu-ops.h"
 #include "qemu/int128.h"
 #include "qemu/atomic128.h"
diff --git a/target/sparc/mmu_helper.c b/target/sparc/mmu_helper.c
index 4a0cedd9e21..cce3046b694 100644
--- a/target/sparc/mmu_helper.c
+++ b/target/sparc/mmu_helper.c
@@ -23,6 +23,7 @@
 #include "exec/cputlb.h"
 #include "exec/cpu-mmu-index.h"
 #include "exec/page-protection.h"
+#include "exec/tlb-flags.h"
 #include "qemu/qemu-print.h"
 #include "trace.h"
 
-- 
2.39.5


