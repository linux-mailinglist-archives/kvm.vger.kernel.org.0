Return-Path: <kvm+bounces-30893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 765D29BE2DC
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:40:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D5E91F24C4E
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D159C1DA624;
	Wed,  6 Nov 2024 09:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zp/JyKYe"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709941D2B1A
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730886033; cv=none; b=bx17GZ+I9g5eqdGxA8P+JLzkelpKnn/MIlUsKhi4/IsWNfK60lmsLRVy4mN5+16rxJi1xQdDyVwlRsKW3u/Ha7Qd3lf539I4XAckDNoE0d0hQWeFVfoSSPztE0FxowHN28YxoCQFVdk7VxTGQIcAKDwScYHn3I1kzBd7YGZP1OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730886033; c=relaxed/simple;
	bh=xWzp4q/Yc610wE29WPq7MSJLwe8He07G8ngFGM4+zCw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e7VIR+VeJhB7m590zKNxLmO0wqz7SbnpnaWul3u4g2reEVyt/xNfA+L7jIXq11YxEsdkLB0gCCsaXARLlqVo9YHWl/XW7p9kZPPuMHTvgmH1aI5FlN2d3GpkSV+zCftVIu43aSskmIL9yEI+l/tKiZLuWb8iaEDPv45tTjW0JRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zp/JyKYe; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730886026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/Nf//oMm1jXKJtNESLqpXj4iYiNyKQ+J2gfB8vo39zw=;
	b=Zp/JyKYeEDdz1qFLHMY1j8zdPzEkVhXiBUdn2oyGFNZ8WllVtmQILTQIgf/+mQ761a/+Le
	TJrPkf+0S+Z67fFRBUbSjzY7twe7ZVb7m2Y48yzluyCWzRcqZn7OT6pQHtQwVFjsYb8MJu
	YFHpn1MJjLh2f2QAAyFIzeKZl8XTDJw=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH] riscv: sbi: Prepare for assembly entry points
Date: Wed,  6 Nov 2024 10:40:16 +0100
Message-ID: <20241106094015.21204-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: James Raphael Tiovalen <jamestiotio@gmail.com>

The HSM tests will need to test HSM start and resumption from HSM
suspend. Prepare for these tests, as well other tests, such as the
SUSP resume tests, by providing an assembly file for SBI tests.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/Makefile    |  3 ++-
 riscv/sbi-asm.S   | 12 ++++++++++++
 riscv/sbi-tests.h |  6 ++++++
 3 files changed, 20 insertions(+), 1 deletion(-)
 create mode 100644 riscv/sbi-asm.S
 create mode 100644 riscv/sbi-tests.h

diff --git a/riscv/Makefile b/riscv/Makefile
index 22fd273acac3..734441f94dad 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -43,6 +43,7 @@ cflatobjs += lib/riscv/timer.o
 ifeq ($(ARCH),riscv32)
 cflatobjs += lib/ldiv32.o
 endif
+cflatobjs += riscv/sbi-asm.o
 
 ########################################
 
@@ -82,7 +83,7 @@ CFLAGS += -mcmodel=medany
 CFLAGS += -std=gnu99
 CFLAGS += -ffreestanding
 CFLAGS += -O2
-CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
+CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib -I $(SRCDIR)/riscv
 
 asm-offsets = lib/riscv/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
diff --git a/riscv/sbi-asm.S b/riscv/sbi-asm.S
new file mode 100644
index 000000000000..fbf97cab39c8
--- /dev/null
+++ b/riscv/sbi-asm.S
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Helper assembly code routines for RISC-V SBI extension tests.
+ *
+ * Copyright (C) 2024, James Raphael Tiovalen <jamestiotio@gmail.com>
+ */
+#define __ASSEMBLY__
+
+#include "sbi-tests.h"
+
+.section .text
+
diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
new file mode 100644
index 000000000000..c28046f7cfbd
--- /dev/null
+++ b/riscv/sbi-tests.h
@@ -0,0 +1,6 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _RISCV_SBI_TESTS_H_
+#define _RISCV_SBI_TESTS_H_
+
+
+#endif /* _RISCV_SBI_TESTS_H_ */
-- 
2.47.0


