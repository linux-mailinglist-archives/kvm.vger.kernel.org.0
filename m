Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA71494E45
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 13:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243875AbiATMwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 07:52:13 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:41380 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243439AbiATMwK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 07:52:10 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B51ED1F882;
        Thu, 20 Jan 2022 12:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642683129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HZ0by8choXV1carKDEo4kau3KDd/nl65wfiFtk4B0Ck=;
        b=KS9iNAp+pLu/54sWzb9x8uBnDaAGZTas6yX8AptQx1wmnpNSTHXrOHP0Ll2Y8E4n48UplT
        uMYr4eZXq4fjmP1KlnSFL+SvOGpZrdhGrfq01z8gopuWbKt287BBnfYlp8LgRfY+Vx4xr0
        XIxNOCr5tD9eIcBvy5y49VmHUd+MOfY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 24C5F13B51;
        Thu, 20 Jan 2022 12:52:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SPGXBvla6WGIagAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Thu, 20 Jan 2022 12:52:09 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de,
        varad.gautam@suse.com
Subject: [kvm-unit-tests 08/13] lib/x86: Move xsave helpers to lib/
Date:   Thu, 20 Jan 2022 13:51:17 +0100
Message-Id: <20220120125122.4633-9-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220120125122.4633-1-varad.gautam@suse.com>
References: <20220120125122.4633-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Processing CPUID #VC for AMD SEV-ES requires copying xcr0 into GHCB.
Move the xsave read/write helpers used by xsave testcase to lib/x86
to share as common code.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/xsave.c     | 37 +++++++++++++++++++++++++++++++++++++
 lib/x86/xsave.h     | 16 ++++++++++++++++
 x86/Makefile.common |  1 +
 x86/xsave.c         | 43 +------------------------------------------
 4 files changed, 55 insertions(+), 42 deletions(-)
 create mode 100644 lib/x86/xsave.c
 create mode 100644 lib/x86/xsave.h

diff --git a/lib/x86/xsave.c b/lib/x86/xsave.c
new file mode 100644
index 0000000..1c0f16e
--- /dev/null
+++ b/lib/x86/xsave.c
@@ -0,0 +1,37 @@
+#include "libcflat.h"
+#include "xsave.h"
+#include "processor.h"
+
+int xgetbv_checking(u32 index, u64 *result)
+{
+    u32 eax, edx;
+
+    asm volatile(ASM_TRY("1f")
+            ".byte 0x0f,0x01,0xd0\n\t" /* xgetbv */
+            "1:"
+            : "=a" (eax), "=d" (edx)
+            : "c" (index));
+    *result = eax + ((u64)edx << 32);
+    return exception_vector();
+}
+
+int xsetbv_checking(u32 index, u64 value)
+{
+    u32 eax = value;
+    u32 edx = value >> 32;
+
+    asm volatile(ASM_TRY("1f")
+            ".byte 0x0f,0x01,0xd1\n\t" /* xsetbv */
+            "1:"
+            : : "a" (eax), "d" (edx), "c" (index));
+    return exception_vector();
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
diff --git a/lib/x86/xsave.h b/lib/x86/xsave.h
new file mode 100644
index 0000000..f1851a3
--- /dev/null
+++ b/lib/x86/xsave.h
@@ -0,0 +1,16 @@
+#ifndef _X86_XSAVE_H_
+#define _X86_XSAVE_H_
+
+#define X86_CR4_OSXSAVE			0x00040000
+#define XCR_XFEATURE_ENABLED_MASK       0x00000000
+#define XCR_XFEATURE_ILLEGAL_MASK       0x00000010
+
+#define XSTATE_FP       0x1
+#define XSTATE_SSE      0x2
+#define XSTATE_YMM      0x4
+
+int xgetbv_checking(u32 index, u64 *result);
+int xsetbv_checking(u32 index, u64 value);
+uint64_t get_supported_xcr0(void);
+
+#endif
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 825318c..d5c4d64 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -22,6 +22,7 @@ cflatobjs += lib/x86/acpi.o
 cflatobjs += lib/x86/stack.o
 cflatobjs += lib/x86/fault_test.o
 cflatobjs += lib/x86/delay.o
+cflatobjs += lib/x86/xsave.o
 ifeq ($(TARGET_EFI),y)
 cflatobjs += lib/x86/amd_sev.o
 cflatobjs += lib/x86/amd_sev_vc.o
diff --git a/x86/xsave.c b/x86/xsave.c
index 892bf56..bd8fe11 100644
--- a/x86/xsave.c
+++ b/x86/xsave.c
@@ -1,6 +1,7 @@
 #include "libcflat.h"
 #include "desc.h"
 #include "processor.h"
+#include "xsave.h"
 
 #ifdef __x86_64__
 #define uint64_t unsigned long
@@ -8,48 +9,6 @@
 #define uint64_t unsigned long long
 #endif
 
-static int xgetbv_checking(u32 index, u64 *result)
-{
-    u32 eax, edx;
-
-    asm volatile(ASM_TRY("1f")
-            ".byte 0x0f,0x01,0xd0\n\t" /* xgetbv */
-            "1:"
-            : "=a" (eax), "=d" (edx)
-            : "c" (index));
-    *result = eax + ((u64)edx << 32);
-    return exception_vector();
-}
-
-static int xsetbv_checking(u32 index, u64 value)
-{
-    u32 eax = value;
-    u32 edx = value >> 32;
-
-    asm volatile(ASM_TRY("1f")
-            ".byte 0x0f,0x01,0xd1\n\t" /* xsetbv */
-            "1:"
-            : : "a" (eax), "d" (edx), "c" (index));
-    return exception_vector();
-}
-
-static uint64_t get_supported_xcr0(void)
-{
-    struct cpuid r;
-    r = cpuid_indexed(0xd, 0);
-    printf("eax %x, ebx %x, ecx %x, edx %x\n",
-            r.a, r.b, r.c, r.d);
-    return r.a + ((u64)r.d << 32);
-}
-
-#define X86_CR4_OSXSAVE			0x00040000
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
2.32.0

