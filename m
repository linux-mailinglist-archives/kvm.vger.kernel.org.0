Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B9D373C1B
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 15:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbhEENPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 09:15:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231459AbhEENPX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 09:15:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620220465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NWINzhtlXjUQSxmPL8NL6Sy7IaVCAblycSDLmVTRkxA=;
        b=A0YwIemqxn+g17ZhShXIu2zbpg9DVVZVKjr3sMqxu6oSkiv/7Q3miJ9zt32PjK+ae7W1/F
        ORkGUSMJvTiHE1GwN5yWI3PSGTzHozJBRTf1p5k++9jv5nvrZg7t4OWqZRxlXcrlpkQiZf
        xgdTcARpHeiCIdowHsAeb2SwEh7oQG4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-_BA_IGprNi6BOCtHSjuWEw-1; Wed, 05 May 2021 09:14:23 -0400
X-MC-Unique: _BA_IGprNi6BOCtHSjuWEw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2BD310866D9;
        Wed,  5 May 2021 13:14:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA6D91064146;
        Wed,  5 May 2021 13:14:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Bill Wendling <morbo@google.com>
Subject: [PATCH kvm-unit-tests] libcflat: provide long division routines
Date:   Wed,  5 May 2021 09:14:12 -0400
Message-Id: <20210505131412.654238-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The -nostdlib flag disables the driver from adding libclang_rt.*.a
during linking. Adding a specific library to the command line such as
libgcc then causes the linker to report unresolved symbols, because the
libraries that resolve those symbols aren't automatically added.

libgcc however is only needed for long division (64-bit by 64-bit).
Instead of linking the whole of it, implement the routines that are
needed.

Reported-by: Bill Wendling <morbo@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arm/Makefile.arm  |   1 +
 lib/ldiv32.c      | 105 ++++++++++++++++++++++++++++++++++++++++++++++
 x86/Makefile.i386 |   2 +-
 3 files changed, 107 insertions(+), 1 deletion(-)
 create mode 100644 lib/ldiv32.c

diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index d379a28..687a8ed 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -23,6 +23,7 @@ cstart.o = $(TEST_DIR)/cstart.o
 cflatobjs += lib/arm/spinlock.o
 cflatobjs += lib/arm/processor.o
 cflatobjs += lib/arm/stack.o
+cflatobjs += lib/ldiv32.o
 
 # arm specific tests
 tests =
diff --git a/lib/ldiv32.c b/lib/ldiv32.c
new file mode 100644
index 0000000..e9d434f
--- /dev/null
+++ b/lib/ldiv32.c
@@ -0,0 +1,105 @@
+#include <inttypes.h>
+
+extern uint64_t __udivmoddi4(uint64_t num, uint64_t den, uint64_t *p_rem);
+extern int64_t __moddi3(int64_t num, int64_t den);
+extern int64_t __divdi3(int64_t num, int64_t den);
+extern uint64_t __udivdi3(uint64_t num, uint64_t den);
+extern uint64_t __umoddi3(uint64_t num, uint64_t den);
+
+uint64_t __udivmoddi4(uint64_t num, uint64_t den, uint64_t *p_rem)
+{
+	uint64_t quot = 0;
+
+	/* Trigger a division by zero at run time (trick taken from iPXE).  */
+	if (den == 0)
+		return 1/((unsigned)den);
+
+	if (num >= den) {
+		/* Align den to num to avoid wasting time on leftmost zero bits.  */
+		int n = __builtin_clzll(den) - __builtin_clzll(num);
+		den <<= n;
+
+		do {
+			quot <<= 1;
+			if (num >= den) {
+				num -= den;
+				quot |= 1;
+			}
+			den >>= 1;
+		} while (n--);
+	}
+
+	if (p_rem)
+		*p_rem = num;
+
+	return quot;
+}
+
+int64_t __moddi3(int64_t num, int64_t den)
+{
+	uint64_t mask = num < 0 ? -1 : 0;
+
+	/* Compute absolute values and do an unsigned division.  */
+	num = (num + mask) ^ mask;
+	if (den < 0)
+		den = -den;
+
+	/* Copy sign of num into result.  */
+	return (__umoddi3(num, den) + mask) ^ mask;
+}
+
+int64_t __divdi3(int64_t num, int64_t den)
+{
+	uint64_t mask = (num ^ den) < 0 ? -1 : 0;
+
+	/* Compute absolute values and do an unsigned division.  */
+	if (num < 0)
+		num = -num;
+	if (den < 0)
+		den = -den;
+
+	/* Copy sign of num^den into result.  */
+	return (__udivdi3(num, den) + mask) ^ mask;
+}
+
+uint64_t __udivdi3(uint64_t num, uint64_t den)
+{
+	uint64_t rem;
+	return __udivmoddi4(num, den, &rem);
+}
+
+uint64_t __umoddi3(uint64_t num, uint64_t den)
+{
+	uint64_t rem;
+	__udivmoddi4(num, den, &rem);
+	return rem;
+}
+
+#ifdef TEST
+#include <assert.h>
+#define UTEST(a, b, q, r) assert(__udivdi3(a, b) == q && __umoddi3(a, b) == r)
+#define STEST(a, b, q, r) assert(__divdi3(a, b) == q && __moddi3(a, b) == r)
+int main()
+{
+	UTEST(1, 1, 1, 0);
+	UTEST(2, 2, 1, 0);
+	UTEST(5, 3, 1, 2);
+	UTEST(10, 3, 3, 1);
+	UTEST(120, 3, 40, 0);
+	UTEST(120, 1, 120, 0);
+	UTEST(0x7FFFFFFFFFFFFFFFULL, 17, 0x787878787878787, 8);
+	UTEST(0x7FFFFFFFFFFFFFFFULL, 0x787878787878787, 17, 8);
+	UTEST(0x8000000000000001ULL, 17, 0x787878787878787, 10);
+	UTEST(0x8000000000000001ULL, 0x787878787878787, 17, 10);
+	UTEST(0, 5, 0, 0);
+
+	STEST(0x7FFFFFFFFFFFFFFFULL, 17, 0x787878787878787, 8);
+	STEST(0x7FFFFFFFFFFFFFFFULL, -17, -0x787878787878787, 8);
+	STEST(-0x7FFFFFFFFFFFFFFFULL, 17, -0x787878787878787, -8);
+	STEST(-0x7FFFFFFFFFFFFFFFULL, -17, 0x787878787878787, -8);
+	STEST(33, 5, 6, 3);
+	STEST(33, -5, -6, 3);
+	STEST(-33, 5, -6, -3);
+	STEST(-33, -5, 6, -3);
+}
+#endif
diff --git a/x86/Makefile.i386 b/x86/Makefile.i386
index c04e5aa..960e274 100644
--- a/x86/Makefile.i386
+++ b/x86/Makefile.i386
@@ -3,7 +3,7 @@ bits = 32
 ldarch = elf32-i386
 COMMON_CFLAGS += -mno-sse -mno-sse2
 
-cflatobjs += lib/x86/setjmp32.o
+cflatobjs += lib/x86/setjmp32.o lib/ldiv32.o
 
 tests = $(TEST_DIR)/taskswitch.flat $(TEST_DIR)/taskswitch2.flat \
 	$(TEST_DIR)/cmpxchg8b.flat $(TEST_DIR)/la57.flat
-- 
2.26.2

