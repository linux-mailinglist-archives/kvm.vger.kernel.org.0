Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8C510B131
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 15:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfK0OZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 09:25:10 -0500
Received: from foss.arm.com ([217.140.110.172]:48196 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbfK0OZJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 09:25:09 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66307328;
        Wed, 27 Nov 2019 06:25:09 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id ECB993F68E;
        Wed, 27 Nov 2019 06:25:07 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PATCH 03/18] lib: Add WRITE_ONCE and READ_ONCE implementations in compiler.h
Date:   Wed, 27 Nov 2019 14:23:55 +0000
Message-Id: <20191127142410.1994-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191127142410.1994-1-alexandru.elisei@arm.com>
References: <20191127142410.1994-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the WRITE_ONCE and READ_ONCE macros which are used to prevent to
prevent the compiler from optimizing a store or a load, respectively, into
something else.

Cc: Drew Jones <drjones@redhat.com>
Cc: Laurent Vivier <lvivier@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/linux/compiler.h | 81 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100644 lib/linux/compiler.h

diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
new file mode 100644
index 000000000000..aac84c1d711c
--- /dev/null
+++ b/lib/linux/compiler.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Taken from tools/include/linux/compiler.h, with minor changes. */
+#ifndef __LINUX_COMPILER_H
+#define __LINUX_COMPILER_H
+
+#ifndef __ASSEMBLY__
+
+#include <stdint.h>
+
+#define barrier()	asm volatile("" : : : "memory")
+
+#define __always_inline	inline __attribute__((always_inline))
+
+static __always_inline void __read_once_size(const volatile void *p, void *res, int size)
+{
+	switch (size) {
+	case 1: *(uint8_t *)res = *(volatile uint8_t *)p; break;
+	case 2: *(uint16_t *)res = *(volatile uint16_t *)p; break;
+	case 4: *(uint32_t *)res = *(volatile uint32_t *)p; break;
+	case 8: *(uint64_t *)res = *(volatile uint64_t *)p; break;
+	default:
+		barrier();
+		__builtin_memcpy((void *)res, (const void *)p, size);
+		barrier();
+	}
+}
+
+/*
+ * Prevent the compiler from merging or refetching reads or writes. The
+ * compiler is also forbidden from reordering successive instances of
+ * READ_ONCE and WRITE_ONCE, but only when the compiler is aware of some
+ * particular ordering. One way to make the compiler aware of ordering is to
+ * put the two invocations of READ_ONCE or WRITE_ONCE in different C
+ * statements.
+ *
+ * These two macros will also work on aggregate data types like structs or
+ * unions. If the size of the accessed data type exceeds the word size of
+ * the machine (e.g., 32 bits or 64 bits) READ_ONCE() and WRITE_ONCE() will
+ * fall back to memcpy(). There's at least two memcpy()s: one for the
+ * __builtin_memcpy() and then one for the macro doing the copy of variable
+ * - '__u' allocated on the stack.
+ *
+ * Their two major use cases are: (1) Mediating communication between
+ * process-level code and irq/NMI handlers, all running on the same CPU,
+ * and (2) Ensuring that the compiler does not fold, spindle, or otherwise
+ * mutilate accesses that either do not require ordering or that interact
+ * with an explicit memory barrier or atomic instruction that provides the
+ * required ordering.
+ */
+#define READ_ONCE(x)					\
+({							\
+	union { typeof(x) __val; char __c[1]; } __u =	\
+		{ .__c = { 0 } };			\
+	__read_once_size(&(x), __u.__c, sizeof(x));	\
+	__u.__val;					\
+})
+
+static __always_inline void __write_once_size(volatile void *p, void *res, int size)
+{
+	switch (size) {
+	case 1: *(volatile uint8_t *)p = *(uint8_t *)res; break;
+	case 2: *(volatile uint16_t *)p = *(uint16_t *)res; break;
+	case 4: *(volatile uint32_t *)p = *(uint32_t *)res; break;
+	case 8: *(volatile uint64_t *)p = *(uint64_t *)res; break;
+	default:
+		barrier();
+		__builtin_memcpy((void *)p, (const void *)res, size);
+		barrier();
+	}
+}
+
+#define WRITE_ONCE(x, val) \
+({							\
+	union { typeof(x) __val; char __c[1]; } __u =	\
+		{ .__val = (typeof(x)) (val) }; 	\
+	__write_once_size(&(x), __u.__c, sizeof(x));	\
+	__u.__val;					\
+})
+
+#endif /* !__ASSEMBLY__ */
+#endif /* !__LINUX_COMPILER_H */
-- 
2.20.1

