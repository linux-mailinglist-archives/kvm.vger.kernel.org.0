Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAEF543AC20
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 08:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhJZGSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 02:18:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39715 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232553AbhJZGSD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Oct 2021 02:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635228939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mJsqqM2/684FT0TwstqLEKbletkgBGtXBJVjOMHdqD4=;
        b=jAUStqdUUcOVpyUD8Rv5153vnHtzsUVD+UMg3MXz/u93dPLBMAJzRhbpus+FgvS9bx8YYJ
        PHTLhWV4v9Iyq5+K+JS7JZu2df8ZIBAClQ133eSTwKDQkpMFD9tUlPrZYbaghvq+M/U0ez
        OlkuL4Bqb8LAoMtUFliHXaKkxxb6Hlc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-1VFxE8J9Ovyip5b-RoQx2g-1; Tue, 26 Oct 2021 02:15:37 -0400
X-MC-Unique: 1VFxE8J9Ovyip5b-RoQx2g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FC5F10A8E00;
        Tue, 26 Oct 2021 06:15:36 +0000 (UTC)
Received: from thuth.com (dhcp-192-183.str.redhat.com [10.33.192.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADC945C1A3;
        Tue, 26 Oct 2021 06:15:33 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>
Cc:     kvm-ppc@vger.kernel.org
Subject: [kvm-unit-tests PATCH] powerpc/emulator: Fix compilation with recent versions of GCC
Date:   Tue, 26 Oct 2021 08:15:32 +0200
Message-Id: <20211026061532.117368-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

New versions of GCC (e.g. version 11.2 from Fedora 34) refuse to compile
assembly with the lswx and lswi mnemonics in little endian mode since the
instruction is only allowed in big endian mode, thus emulator.c cannot be
compiled anymore. Re-arrange the tests a little bit to use hand-crafted
instructions in little endian mode to fix this issue. Additionally, the lswx
and lswi instructions generate an alignment exception with recent versions
of QEMU, too (see https://gitlab.com/qemu-project/qemu/-/commit/5817355ed0),
so we can turn the report_xfail() into proper report() statements now.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 powerpc/emulator.c | 69 +++++++++++++++++++++++++++-------------------
 1 file changed, 40 insertions(+), 29 deletions(-)

diff --git a/powerpc/emulator.c b/powerpc/emulator.c
index 147878e..65ae4b6 100644
--- a/powerpc/emulator.c
+++ b/powerpc/emulator.c
@@ -86,8 +86,25 @@ static void test_lswi(void)
 	for (i = 0; i < 128; i++)
 		addr[i] = 1 + i;
 
-	/* check incomplete register filling */
+#if  __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+
+	/*
+	 * lswi is supposed to cause an alignment exception in little endian
+	 * mode, but to be able to check this, we also have to specify the
+	 * opcode without mnemonic here since newer versions of GCC refuse
+	 * "lswi" when compiling in little endian mode.
+	 */
 	alignment = 0;
+	asm volatile ("mr r12,%[addr];"
+		      ".long 0x7d6c24aa;"       /* lswi r11,r12,4 */
+		      "std r11,0(%[regs]);"
+		       :: [addr] "r" (addr), [regs] "r" (regs)
+		       : "r11", "r12", "memory");
+	report(alignment, "alignment");
+
+#else
+
+	/* check incomplete register filling */
 	asm volatile ("li r12,-1;"
 		      "mr r11, r12;"
 		      "lswi r11, %[addr], %[len];"
@@ -99,19 +116,6 @@ static void test_lswi(void)
 		      [regs] "r" (regs)
 		      :
 		      "r11", "r12", "memory");
-
-#if  __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
-	/*
-	 * lswi is supposed to cause an alignment exception in little endian
-	 * mode, but QEMU does not support it. So in case we do not get an
-	 * exception, this is an expected failure and we run the other tests
-	 */
-	report_xfail(!alignment, alignment, "alignment");
-	if (alignment) {
-		report_prefix_pop();
-		return;
-	}
-#endif
 	report(regs[0] == 0x01020300 && regs[1] == (uint64_t)-1, "partial");
 
 	/* check NB = 0 ==> 32 bytes. */
@@ -191,6 +195,8 @@ static void test_lswi(void)
 	 */
 	report(regs[2] == (uint64_t)addr, "Don't overwrite Ra");
 
+#endif
+
 	report_prefix_pop();
 }
 
@@ -224,13 +230,29 @@ static void test_lswx(void)
 	report_prefix_push("lswx");
 
 	/* fill memory with sequence */
-
 	for (i = 0; i < 128; i++)
 		addr[i] = 1 + i;
 
-	/* check incomplete register filling */
+#if  __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
 
+	/*
+	 * lswx is supposed to cause an alignment exception in little endian
+	 * mode, but to be able to check this, we also have to specify the
+	 * opcode without mnemonic here since newer versions of GCC refuse
+	 * "lswx" when compiling in little endian mode.
+	 */
 	alignment = 0;
+	asm volatile ("mtxer %[len];"
+		      "mr r11,%[addr];"
+		      ".long 0x7d805c2a;"       /* lswx r12,0,r11 */
+		      "std r12,0(%[regs]);"
+		      :: [len]"r"(4), [addr]"r"(addr), [regs]"r"(regs)
+		      : "r11", "r12", "memory");
+	report(alignment, "alignment");
+
+#else
+
+	/* check incomplete register filling */
 	asm volatile ("mtxer %[len];"
 		      "li r12,-1;"
 		      "mr r11, r12;"
@@ -243,19 +265,6 @@ static void test_lswx(void)
 		      [regs] "r" (regs)
 		      :
 		      "xer", "r11", "r12", "memory");
-
-#if  __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
-	/*
-	 * lswx is supposed to cause an alignment exception in little endian
-	 * mode, but QEMU does not support it. So in case we do not get an
-	 * exception, this is an expected failure and we run the other tests
-	 */
-	report_xfail(!alignment, alignment, "alignment");
-	if (alignment) {
-		report_prefix_pop();
-		return;
-	}
-#endif
 	report(regs[0] == 0x01020300 && regs[1] == (uint64_t)-1, "partial");
 
 	/* check an old know bug: the number of bytes is used as
@@ -344,6 +353,8 @@ static void test_lswx(void)
 	 */
 	report(regs[1] == (uint64_t)addr, "Don't overwrite Rb");
 
+#endif
+
 	report_prefix_pop();
 }
 
-- 
2.27.0

