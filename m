Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB30130FE9
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgAFKEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:04:07 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31313 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726508AbgAFKEG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jan 2020 05:04:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iGnDFwqzynqo0Lekz3iG4OqSHRFQjgewZkI/i0FtSIg=;
        b=R9efa0DQjDj5L9gILjx46SCUkvFgfLwP6KweYKGEA4RUaswvRq/2KS9tDJsC33XFpKJ8Xu
        ehH9KYMJcdYhK3793s6DTySVn8dj7yDC02hNUaVayTGzbvAFBcOypF1J+jGp4VNc6+Mi2t
        YWMzZcXNAqiDc3PHmzP2jomRnV9zsCA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-6xcv7mg2Md6xTXIBdmuiBw-1; Mon, 06 Jan 2020 05:04:03 -0500
X-MC-Unique: 6xcv7mg2Md6xTXIBdmuiBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89853801E6C;
        Mon,  6 Jan 2020 10:04:02 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8647A63BCA;
        Mon,  6 Jan 2020 10:03:58 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Drew Jones <drjones@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: [PULL kvm-unit-tests 07/17] lib: Add WRITE_ONCE and READ_ONCE implementations in compiler.h
Date:   Mon,  6 Jan 2020 11:03:37 +0100
Message-Id: <20200106100347.1559-8-drjones@redhat.com>
In-Reply-To: <20200106100347.1559-1-drjones@redhat.com>
References: <20200106100347.1559-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

Add the WRITE_ONCE and READ_ONCE macros which are used to prevent the
compiler from optimizing a store or a load, respectively, into something
else.

Cc: Drew Jones <drjones@redhat.com>
Cc: Laurent Vivier <lvivier@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/linux/compiler.h | 83 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)
 create mode 100644 lib/linux/compiler.h

diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
new file mode 100644
index 000000000000..2d72f18c36e5
--- /dev/null
+++ b/lib/linux/compiler.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Taken from Linux commit 219d54332a09 ("Linux 5.4"), from the file
+ * tools/include/linux/compiler.h, with minor changes.
+ */
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
+static __always_inline void __read_once_size(const volatile void *p, voi=
d *res, int size)
+{
+	switch (size) {
+	case 1: *(uint8_t *)res =3D *(volatile uint8_t *)p; break;
+	case 2: *(uint16_t *)res =3D *(volatile uint16_t *)p; break;
+	case 4: *(uint32_t *)res =3D *(volatile uint32_t *)p; break;
+	case 8: *(uint64_t *)res =3D *(volatile uint64_t *)p; break;
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
+ * particular ordering. One way to make the compiler aware of ordering i=
s to
+ * put the two invocations of READ_ONCE or WRITE_ONCE in different C
+ * statements.
+ *
+ * These two macros will also work on aggregate data types like structs =
or
+ * unions. If the size of the accessed data type exceeds the word size o=
f
+ * the machine (e.g., 32 bits or 64 bits) READ_ONCE() and WRITE_ONCE() w=
ill
+ * fall back to memcpy and print a compile-time warning.
+ *
+ * Their two major use cases are: (1) Mediating communication between
+ * process-level code and irq/NMI handlers, all running on the same CPU,
+ * and (2) Ensuring that the compiler does not fold, spindle, or otherwi=
se
+ * mutilate accesses that either do not require ordering or that interac=
t
+ * with an explicit memory barrier or atomic instruction that provides t=
he
+ * required ordering.
+ */
+
+#define READ_ONCE(x)					\
+({							\
+	union { typeof(x) __val; char __c[1]; } __u =3D	\
+		{ .__c =3D { 0 } };			\
+	__read_once_size(&(x), __u.__c, sizeof(x));	\
+	__u.__val;					\
+})
+
+static __always_inline void __write_once_size(volatile void *p, void *re=
s, int size)
+{
+	switch (size) {
+	case 1: *(volatile uint8_t *) p =3D *(uint8_t  *) res; break;
+	case 2: *(volatile uint16_t *) p =3D *(uint16_t *) res; break;
+	case 4: *(volatile uint32_t *) p =3D *(uint32_t *) res; break;
+	case 8: *(volatile uint64_t *) p =3D *(uint64_t *) res; break;
+	default:
+		barrier();
+		__builtin_memcpy((void *)p, (const void *)res, size);
+		barrier();
+	}
+}
+
+#define WRITE_ONCE(x, val)				\
+({							\
+	union { typeof(x) __val; char __c[1]; } __u =3D	\
+		{ .__val =3D (val) }; 			\
+	__write_once_size(&(x), __u.__c, sizeof(x));	\
+	__u.__val;					\
+})
+
+#endif /* !__ASSEMBLY__ */
+#endif /* !__LINUX_COMPILER_H */
--=20
2.21.0

