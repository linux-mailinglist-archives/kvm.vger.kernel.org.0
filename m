Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A323EF68E
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbhHRAKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237043AbhHRAKG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:10:06 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35B6C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:32 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n20-20020a2540140000b0290593b8e64cd5so987171yba.3
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=g1e1WEzulI/qW8EFIHbSbX5jFfcwcrpuQfCUljk8RHk=;
        b=gWVjCgotjyUmyCPXRuM3cNQoD7BH0xo2ZXjOw7NpKBHm0nOlDguYxR2C3kQqJ8xCg/
         b+QZ9wJkIUZKIElsCAqHcbAnp5MjFUjcSfpjxDsw7tUmY1WfHMcsbwe1BKxDlYdgBJoH
         KGq0L7mVgjPYvEjQDbJnkPTAu5uhVcQN75xri8HKrUjDYClZdJz0Y6TKTvyMFKW5l5i9
         M2/IGYoNewoLwUjiarMUR3O3jEbA3eJNJK/CrEAeMRvNbFgozXjgyF4NinlezxywWE00
         nh0v7Hcn9dtaRq4S9nbhCPDunLIzrZ4ffLpJS399jF+lrBIcWmeM+W1huYgYQbORDT9H
         GZ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=g1e1WEzulI/qW8EFIHbSbX5jFfcwcrpuQfCUljk8RHk=;
        b=fpNKGpAzpFv19i57sJ6rv1+Qm5PRf5O0JPoWjrhydMoE3VqpA/2rn7dHYmBOnlp62W
         NZY+RrGwXrsH1cTUY5v8q6z2IYHx/9kDXKoi9UM984cqtx5bprlWyO2i6rfpoiKDrCUh
         6IoZcJk6Zp4XTvi2YDe7YO7ot2kDq+8g6grJhLCj+1tt3ch/ltUSNRJzhDkwwW85/7Eu
         ArkdSjJmRaOtExT577F7+PM5a/p5t/9n+nN1AXUCj89OUykzNiDIB6g0dqk+QcTMdQVA
         PrygvPeT6CJSO6Jsrr3n4TXK6/68jSLXqQrGWENDzBqhVav7LUr2cfhhJ/xyJytdbvp9
         DFaQ==
X-Gm-Message-State: AOAM533RxP8tnjSLZ01QDk1X9fbA98SEZtbrRTnBQjCfeHun2sZBfWgW
        ccIceBBwvOF8SqLCKmyoXW8Cz4KSw2RbRr6pc5yTmvt/NUoQ2oNKJ9lYQy9Cp9nzahQndjngWKS
        8P49YcHUt7jC/KcWeANW+Swuamv5yjKPFFziNZUJP2H7UU0WAJpFVtuN4ECuypWZE/MGW
X-Google-Smtp-Source: ABdhPJw/DBBxWSZBULObvBikoETdpp24JkTVO7aUKoNRK07ILolguhM2PtaQ9f5PoExlS6QNMe8v7Z9YFklbA/MU
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a25:e7d0:: with SMTP id
 e199mr7960619ybh.203.1629245371930; Tue, 17 Aug 2021 17:09:31 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:08:59 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-11-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 10/16] x86 AMD SEV: Initial support
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        Zixuan Wang <zixuanwang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD Secure Encrypted Virtualization (SEV) is a hardware accelerated
memory encryption feature that protects guest VMs from host attacks.

This commit provides set up code and a test case for AMD SEV. The set up
code checks if SEV is supported and enabled, and then sets SEV c-bit for
each page table entry.

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
Co-developed-by: Hyunwook (Wooky) Baek <baekhw@google.com>
---
 configure           |  9 +++++++
 lib/x86/amd_sev.c   | 50 +++++++++++++++++++++++++++++++++++
 lib/x86/amd_sev.h   | 41 +++++++++++++++++++++++++++++
 lib/x86/asm/setup.h |  3 +++
 lib/x86/setup.c     | 24 +++++++++++++++++
 x86/Makefile.common | 10 +++++++
 x86/Makefile.x86_64 |  3 +++
 x86/amd_sev.c       | 64 +++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 204 insertions(+)
 create mode 100644 lib/x86/amd_sev.c
 create mode 100644 lib/x86/amd_sev.h
 create mode 100644 x86/amd_sev.c

diff --git a/configure b/configure
index 3094375..c165ba7 100755
--- a/configure
+++ b/configure
@@ -31,6 +31,8 @@ earlycon=
 target_efi=
 efi_include_path=
 efi_libs_path=
+amd_sev=
+amd_sev_variant=
 
 usage() {
     cat <<-EOF
@@ -77,6 +79,7 @@ usage() {
 	    --efi-libs-path        Path to GNU-EFI libraries, e.g. "/usr/lib/". This dir should
 	                           contain 3 files from GNU-EFI: crt0-efi-x86_64.o, libefi.a,
 	                           and libgnuefi.a
+	    --amd-sev=VARIANT      AMD SEV variant, [SEV|ES|SNP]
 EOF
     exit 1
 }
@@ -150,6 +153,10 @@ while [[ "$1" = -* ]]; do
 	--efi-libs-path)
 	    efi_libs_path="$arg"
 	    ;;
+	--amd-sev)
+	    amd_sev=y
+	    [ "${arg^^}" != "SEV" ] && amd_sev_variant="${arg^^}"
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -361,6 +368,8 @@ HOST_KEY_DOCUMENT=$host_key_document
 TARGET_EFI=$target_efi
 EFI_INCLUDE_PATH=$efi_include_path
 EFI_LIBS_PATH=$efi_libs_path
+AMD_SEV=$amd_sev
+AMD_SEV_VARIANT=$amd_sev_variant
 EOF
 if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     echo "TARGET=$target" >> config.mak
diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
new file mode 100644
index 0000000..bd8d536
--- /dev/null
+++ b/lib/x86/amd_sev.c
@@ -0,0 +1,50 @@
+/*
+ * AMD SEV support in KVM-Unit-Tests
+ *
+ * Copyright (c) 2021, Google Inc
+ *
+ * Authors:
+ *   Zixuan Wang <zixuanwang@google.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.0-or-later
+ */
+
+#include "amd_sev.h"
+#include "x86/processor.h"
+
+static unsigned long long amd_sev_c_bit_pos;
+
+EFI_STATUS setup_amd_sev(void)
+{
+	struct cpuid cpuid_out;
+
+	/* Test if we can query SEV features */
+	cpuid_out = cpuid(CPUID_FN_LARGEST_EXT_FUNC_NUM);
+	if (cpuid_out.a < CPUID_FN_ENCRYPT_MEM_CAPAB) {
+		return EFI_UNSUPPORTED;
+	}
+
+	/* Test if SEV is supported */
+	cpuid_out = cpuid(CPUID_FN_ENCRYPT_MEM_CAPAB);
+	if (!(cpuid_out.a & SEV_SUPPORT_MASK)) {
+		return EFI_UNSUPPORTED;
+	}
+
+	/* Test if SEV is enabled */
+	if (!(rdmsr(MSR_SEV_STATUS) & SEV_ENABLED_MASK)) {
+		return EFI_NOT_READY;
+	}
+
+	/* Extract C-Bit position from ebx[5:0]
+	 * AMD64 Architecture Programmer's Manual Volume 3
+	 *   - Section " Function 8000_001Fh - Encrypted Memory Capabilities"
+	 */
+	amd_sev_c_bit_pos = (unsigned long long)(cpuid_out.b & 0x3f);
+
+	return EFI_SUCCESS;
+}
+
+unsigned long long get_amd_sev_c_bit_mask(void)
+{
+	return 1ull << amd_sev_c_bit_pos;
+}
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
new file mode 100644
index 0000000..c1b08e8
--- /dev/null
+++ b/lib/x86/amd_sev.h
@@ -0,0 +1,41 @@
+/*
+ * AMD SEV support in KVM-Unit-Tests
+ *
+ * Copyright (c) 2021, Google Inc
+ *
+ * Authors:
+ *   Zixuan Wang <zixuanwang@google.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.0-or-later
+ */
+
+#ifndef _X86_AMD_SEV_H_
+#define _X86_AMD_SEV_H_
+
+#include "libcflat.h"
+#include "desc.h"
+#include "asm/page.h"
+
+#ifdef ALIGN
+#undef ALIGN
+#endif
+#include <efi.h>
+
+/* AMD Programmer's Manual Volume 3
+ *   - Section "Function 8000_0000h - Maximum Extended Function Number and Vendor String"
+ *   - Section "Function 8000_001Fh - Encrypted Memory Capabilities"
+ */
+#define CPUID_FN_LARGEST_EXT_FUNC_NUM 0x80000000
+#define CPUID_FN_ENCRYPT_MEM_CAPAB    0x8000001f
+#define SEV_SUPPORT_MASK              0b10
+
+/* AMD Programmer's Manual Volume 2
+ *   - Section "SEV_STATUS MSR"
+ */
+#define MSR_SEV_STATUS   0xc0010131
+#define SEV_ENABLED_MASK 0b1
+
+EFI_STATUS setup_amd_sev(void);
+unsigned long long get_amd_sev_c_bit_mask(void);
+
+#endif /* _X86_AMD_SEV_H_ */
diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index c32168e..1d69c6e 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -7,6 +7,9 @@
 #include "x86/processor.h"
 #include "x86/smp.h"
 #include "asm/page.h"
+#ifdef CONFIG_AMD_SEV
+#include "x86/amd_sev.h"
+#endif /* CONFIG_AMD_SEV */
 
 #ifdef ALIGN
 #undef ALIGN
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 0b0dbea..aaa1cce 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -214,6 +214,25 @@ EFI_STATUS setup_efi_pre_boot(UINTN *mapkey, efi_bootinfo_t *efi_bootinfo)
 		return status;
 	}
 
+#ifdef CONFIG_AMD_SEV
+	status = setup_amd_sev();
+	if (EFI_ERROR(status)) {
+		printf("setup_amd_sev() failed: ");
+		switch (status) {
+		case EFI_UNSUPPORTED:
+			printf("SEV is not supported\n");
+			break;
+		case EFI_NOT_READY:
+			printf("SEV is not enabled\n");
+			break;
+		default:
+			printf("Unknown error\n");
+			break;
+		}
+		return status;
+	}
+#endif /* CONFIG_AMD_SEV */
+
 	return EFI_SUCCESS;
 }
 
@@ -232,6 +251,11 @@ static void setup_page_table(void)
 	/* Set default flags */
 	flags = PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
+#ifdef CONFIG_AMD_SEV
+	/* Set AMD SEV C-Bit for page table entries */
+	flags |= get_amd_sev_c_bit_mask();
+#endif /* CONFIG_AMD_SEV */
+
 	/* Level 5 */
 	curr_pt = (pgd_t *)&ptl5;
 	curr_pt[0] = ((phys_addr_t)&ptl4) | flags;
diff --git a/x86/Makefile.common b/x86/Makefile.common
index e77de6b..8f9ddad 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -25,6 +25,9 @@ cflatobjs += lib/x86/delay.o
 ifeq ($(TARGET_EFI),y)
 cflatobjs += lib/x86/setup.o
 cflatobjs += lib/efi.o
+ifeq ($(AMD_SEV),y)
+cflatobjs += lib/x86/amd_sev.o
+endif
 endif
 
 OBJDIRS += lib/x86
@@ -38,6 +41,13 @@ COMMON_CFLAGS += -Wa,--divide
 endif
 COMMON_CFLAGS += -O1
 
+ifeq ($(AMD_SEV),y)
+COMMON_CFLAGS += -DCONFIG_AMD_SEV
+ifneq ($(AMD_SEV_VARIANT),)
+COMMON_CFLAGS += -DCONFIG_AMD_SEV_$(AMD_SEV_VARIANT)
+endif
+endif
+
 # stack.o relies on frame pointers.
 KEEP_FRAME_POINTER := y
 
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 7e8a57a..c1af80c 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -32,6 +32,9 @@ tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
 tests += $(TEST_DIR)/emulator.$(exe)
 tests += $(TEST_DIR)/vmware_backdoors.$(exe)
+ifeq ($(AMD_SEV),y)
+tests += $(TEST_DIR)/amd_sev.$(exe)
+endif
 
 # The following test cases are disabled when building EFI tests because they
 # use absolute addresses in their inline assembly code, which cannot compile
diff --git a/x86/amd_sev.c b/x86/amd_sev.c
new file mode 100644
index 0000000..a07a48f
--- /dev/null
+++ b/x86/amd_sev.c
@@ -0,0 +1,64 @@
+/*
+ * AMD SEV test cases
+ *
+ * Copyright (c) 2021, Google Inc
+ *
+ * Authors:
+ *   Hyunwook (Wooky) Baek <baekhw@google.com>
+ *   Zixuan Wang <zixuanwang@google.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.0-or-later
+ */
+
+#include "libcflat.h"
+#include "x86/processor.h"
+#include "x86/amd_sev.h"
+
+#define EXIT_SUCCESS 0
+#define EXIT_FAILURE 1
+
+static int test_sev_activation(void)
+{
+	struct cpuid cpuid_out;
+	u64 msr_out;
+
+	printf("SEV activation test is loaded.\n");
+
+	/* Tests if CPUID function to check SEV is implemented */
+	cpuid_out = cpuid(CPUID_FN_LARGEST_EXT_FUNC_NUM);
+	printf("CPUID Fn8000_0000[EAX]: 0x%08x\n", cpuid_out.a);
+	if (cpuid_out.a < CPUID_FN_ENCRYPT_MEM_CAPAB) {
+		printf("CPUID does not support FN%08x\n",
+		       CPUID_FN_ENCRYPT_MEM_CAPAB);
+		return EXIT_FAILURE;
+	}
+
+	/* Tests if SEV is supported */
+	cpuid_out = cpuid(CPUID_FN_ENCRYPT_MEM_CAPAB);
+	printf("CPUID Fn8000_001F[EAX]: 0x%08x\n", cpuid_out.a);
+	printf("CPUID Fn8000_001F[EBX]: 0x%08x\n", cpuid_out.b);
+	if (!(cpuid_out.a & SEV_SUPPORT_MASK)) {
+		printf("SEV is not supported.\n");
+		return EXIT_FAILURE;
+	}
+	printf("SEV is supported\n");
+
+	/* Tests if SEV is enabled */
+	msr_out = rdmsr(MSR_SEV_STATUS);
+	printf("MSR C001_0131[EAX]: 0x%08lx\n", msr_out & 0xffffffff);
+	if (!(msr_out & SEV_ENABLED_MASK)) {
+		printf("SEV is not enabled.\n");
+		return EXIT_FAILURE;
+	}
+	printf("SEV is enabled\n");
+
+	return EXIT_SUCCESS;
+}
+
+int main(void)
+{
+	int rtn;
+	rtn = test_sev_activation();
+	report(rtn == EXIT_SUCCESS, "SEV activation test.");
+	return report_summary();
+}
-- 
2.33.0.rc1.237.g0d66db33f3-goog

