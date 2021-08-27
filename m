Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDFD3F92B7
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 05:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244143AbhH0DNd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 23:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244100AbhH0DNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 23:13:32 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805E8C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:44 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id z10-20020a170903018a00b00134def0a883so370685plg.0
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 20:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lvY+8GWji/ARTEhKIY5rBNP81l9FgFJzeMAybYzicOI=;
        b=sx/fDyVK+kVJAZiNNBRgwWLKTJZUtcY7LNauRS1BPDHfsrUWdmEChMkz3yy+K7GLZA
         4e9prciwNURGaxaZOND14RQ2Et8EiCc/YPPlmzBofonvZQw89Cl/GroasAgm9kkK5u+4
         8ds1Da0pbPEVgefnP572VieQSLHMPWVnAgXZ6kWGISP4HOWgzw3qWsUGFmT7nWgHxzkU
         KDD2E2WgWTvbG4kjWxuv8rEsBFqAmR6eMk4yb0Ek3y204h1/GLhv9npHxcvAyuDMBmSP
         WZo99Mnm7Yc1qCrIt71jcLTu935mNgLPE/cV8f6QoLHp8aSk3dCQXbYbUxUKQnBqjIdx
         3aXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lvY+8GWji/ARTEhKIY5rBNP81l9FgFJzeMAybYzicOI=;
        b=IG6iJZ7av8SUUjiXvQwvE9VYEWIMzJzHxNAvUmTt1ihskmeE7OqanW03nfkwYgY1pB
         8mkuqaKpxYeIzKxQ5w6UxCPmpVR5xrAjPNHjwd3sxQkgErP21Xvdr7JT+SGyjaCLbZ07
         91eWYFlrzJhqimlkXi5W+LWYLhzvcs5ydQUio8e4txwpf1ELK2eFjb2Fp+4zovbkjRTx
         zCJvcCxLVIbdaWiSAfvUDBrI/R/Os4r0Riig6gLUv99DmM8RaRuxFGRHnuEuuEv9XBJF
         AoSyU4OLvaG5Y3XuSu6WWe1MRK4idUjhNoLnQi14FBrk5ZGAkxMzmpe/mTSKIPqubZKU
         n1Sg==
X-Gm-Message-State: AOAM530i2qQ1nyCvPkq1oGg/ogHS+LedLbzboG/phI4z/2irQNRMoqGi
        dDhuD0kwue13drz4du4fGRYtKX/IQhqPlKpfDBBtWciZvLSf+DrcYvkoDiRJ8day87oeokrw4sp
        J3Ibw+D0IYdbaxKcXQ1sD+YTFtki9magfLXY9W0lAf6cQFfHc+ymLVtQjnLQHIPypN1t3
X-Google-Smtp-Source: ABdhPJxWe5g2ygm8GXyFdJBIbX2JQ0WzOsGIZrR+oLfCDHCIQ8fLAdInL4MyS0i8e0sJ4ARgcZUTTgAGDAqVXO5b
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a62:dd83:0:b029:30f:d69:895f with SMTP
 id w125-20020a62dd830000b029030f0d69895fmr6922410pff.17.1630033963875; Thu,
 26 Aug 2021 20:12:43 -0700 (PDT)
Date:   Fri, 27 Aug 2021 03:12:16 +0000
In-Reply-To: <20210827031222.2778522-1-zixuanwang@google.com>
Message-Id: <20210827031222.2778522-12-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210827031222.2778522-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [kvm-unit-tests PATCH v2 11/17] x86 AMD SEV: Initial support
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD Secure Encrypted Virtualization (SEV) is a hardware accelerated
memory encryption feature that protects guest VMs from host attacks.

This commit provides set up code and a test case for AMD SEV. The set up
code checks if SEV is supported and enabled, and then sets SEV c-bit for
each page table entry.

Co-developed-by: Hyunwook (Wooky) Baek <baekhw@google.com>
Signed-off-by: Hyunwook (Wooky) Baek <baekhw@google.com>
Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/amd_sev.c   | 77 +++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/amd_sev.h   | 45 ++++++++++++++++++++++++++
 lib/x86/asm/setup.h |  1 +
 lib/x86/setup.c     | 15 +++++++++
 x86/Makefile.common |  1 +
 x86/Makefile.x86_64 |  3 ++
 x86/amd_sev.c       | 64 +++++++++++++++++++++++++++++++++++++
 7 files changed, 206 insertions(+)
 create mode 100644 lib/x86/amd_sev.c
 create mode 100644 lib/x86/amd_sev.h
 create mode 100644 x86/amd_sev.c

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
new file mode 100644
index 0000000..5498ed6
--- /dev/null
+++ b/lib/x86/amd_sev.c
@@ -0,0 +1,77 @@
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
+bool amd_sev_enabled(void)
+{
+	struct cpuid cpuid_out;
+	static bool sev_enabled;
+	static bool initialized = false;
+
+	/* Check CPUID and MSR for SEV status and store it for future function calls. */
+	if (!initialized) {
+		sev_enabled = false;
+		initialized = true;
+
+		/* Test if we can query SEV features */
+		cpuid_out = cpuid(CPUID_FN_LARGEST_EXT_FUNC_NUM);
+		if (cpuid_out.a < CPUID_FN_ENCRYPT_MEM_CAPAB) {
+			return sev_enabled;
+		}
+
+		/* Test if SEV is supported */
+		cpuid_out = cpuid(CPUID_FN_ENCRYPT_MEM_CAPAB);
+		if (!(cpuid_out.a & SEV_SUPPORT_MASK)) {
+			return sev_enabled;
+		}
+
+		/* Test if SEV is enabled */
+		if (!(rdmsr(MSR_SEV_STATUS) & SEV_ENABLED_MASK)) {
+			return sev_enabled;
+		}
+
+		sev_enabled = true;
+	}
+
+	return sev_enabled;
+}
+
+efi_status_t setup_amd_sev(void)
+{
+	struct cpuid cpuid_out;
+
+	if (!amd_sev_enabled()) {
+		return EFI_UNSUPPORTED;
+	}
+
+	/*
+	 * Extract C-Bit position from ebx[5:0]
+	 * AMD64 Architecture Programmer's Manual Volume 3
+	 *   - Section " Function 8000_001Fh - Encrypted Memory Capabilities"
+	 */
+	cpuid_out = cpuid(CPUID_FN_ENCRYPT_MEM_CAPAB);
+	amd_sev_c_bit_pos = (unsigned long long)(cpuid_out.b & 0x3f);
+
+	return EFI_SUCCESS;
+}
+
+unsigned long long get_amd_sev_c_bit_mask(void)
+{
+	if (amd_sev_enabled()) {
+		return 1ull << amd_sev_c_bit_pos;
+	} else {
+		return 0;
+	}
+}
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
new file mode 100644
index 0000000..516d500
--- /dev/null
+++ b/lib/x86/amd_sev.h
@@ -0,0 +1,45 @@
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
+#ifdef TARGET_EFI
+
+#include "libcflat.h"
+#include "desc.h"
+#include "asm/page.h"
+#include "efi.h"
+
+/*
+ * AMD Programmer's Manual Volume 3
+ *   - Section "Function 8000_0000h - Maximum Extended Function Number and Vendor String"
+ *   - Section "Function 8000_001Fh - Encrypted Memory Capabilities"
+ */
+#define CPUID_FN_LARGEST_EXT_FUNC_NUM 0x80000000
+#define CPUID_FN_ENCRYPT_MEM_CAPAB    0x8000001f
+#define SEV_SUPPORT_MASK              0b10
+
+/*
+ * AMD Programmer's Manual Volume 2
+ *   - Section "SEV_STATUS MSR"
+ */
+#define MSR_SEV_STATUS   0xc0010131
+#define SEV_ENABLED_MASK 0b1
+
+bool amd_sev_enabled(void);
+efi_status_t setup_amd_sev(void);
+
+unsigned long long get_amd_sev_c_bit_mask(void);
+
+#endif /* TARGET_EFI */
+
+#endif /* _X86_AMD_SEV_H_ */
diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index 16bad0f..d494528 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -8,6 +8,7 @@
 #include "x86/smp.h"
 #include "asm/page.h"
 #include "efi.h"
+#include "x86/amd_sev.h"
 
 /*
  * efi_bootinfo_t: stores EFI-related machine info retrieved by
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 03598fe..bdda337 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -215,6 +215,18 @@ efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_booti
 		return status;
 	}
 
+	status = setup_amd_sev();
+	if (status != EFI_SUCCESS) {
+		switch (status) {
+		case EFI_UNSUPPORTED:
+			/* Continue if AMD SEV is not supported */
+			break;
+		default:
+			printf("Set up AMD SEV failed\n");
+			return status;
+		}
+	}
+
 	return EFI_SUCCESS;
 }
 
@@ -233,6 +245,9 @@ static void setup_page_table(void)
 	/* Set default flags */
 	flags = PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
+	/* Set AMD SEV C-Bit for page table entries */
+	flags |= get_amd_sev_c_bit_mask();
+
 	/* Level 5 */
 	curr_pt = (pgd_t *)&ptl5;
 	curr_pt[0] = ((phys_addr_t)&ptl4) | flags;
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 959379c..0913083 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -23,6 +23,7 @@ cflatobjs += lib/x86/stack.o
 cflatobjs += lib/x86/fault_test.o
 cflatobjs += lib/x86/delay.o
 ifeq ($(TARGET_EFI),y)
+cflatobjs += lib/x86/amd_sev.o
 cflatobjs += lib/x86/setup.o
 cflatobjs += lib/efi.o
 cflatobjs += x86/efi/reloc_x86_64.o
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 7e8a57a..8304939 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -32,6 +32,9 @@ tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
 tests += $(TEST_DIR)/emulator.$(exe)
 tests += $(TEST_DIR)/vmware_backdoors.$(exe)
+ifeq ($(TARGET_EFI),y)
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
2.33.0.259.gc128427fd7-goog

