Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AED04218AD
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 22:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbhJDUvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 16:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236899AbhJDUvl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 16:51:41 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709ACC061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 13:49:52 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id j4so767612plx.4
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 13:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4pf7MMvUkYurjBtFBnw34EfDkowFQ0hcjHBvydN5AXU=;
        b=UFhCgMEeZDin9CVZAIC/IvQdzxPZWSIdT1bWvqkYRQcX/XV/ouQj+buUNpdaJDEw7/
         zkFcjA0W7BSi55n9WBLtp8cJHkG2YCQaHaw+bLLCm+llJPHjcYPErJCHWdPbhn/DC4Mw
         wW+ablFRBJ1FkG1rdVKME05vUfEzhY5u1BLjGHwCRQCwU25Z9gGoKLPATxB30yUkhZG6
         jsDqukxyr27TshI3AO4QQCyJkVLCqpn8GIjDgaT8Ytqwr7nTcObLPWzRfGTxMAzrwzkW
         m+YAZ81rVoEufec1Z6wERnvpTH/EUE6nM8FV69J8VQdFbccMBtSpme+Aim0uBWejGYyN
         tfJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4pf7MMvUkYurjBtFBnw34EfDkowFQ0hcjHBvydN5AXU=;
        b=D1fw0mEpTYemKShhQL7RTrr+o93NURnjsNZDtz3+EdRRit0E4o3JjJJd+E85fbDTdw
         GlWtYHR3/eYOb31Ci4Wk1jtkEO/DzDsK5L6hVMDrWaPGhJTtxB4rAHb+jOMx6WmMDAQA
         oedZxdbb74yVh8tBlLKRGsAN/EAA2TK7lMnvThfxXSRJ6da55O3o6GGzlqrsS6xVmOir
         B08CE2D9qPW5k+r2ZUgPincLPV3izXEC6MNjw/rvBjORgwckVfITPdoczJFXdmoW7S5T
         hUeN4/ed/1NuIL3vpcQf2fee+XobVL8z2UaHfv94kFkCSVLSdu65PYhulQrSPda2Pooq
         OC1g==
X-Gm-Message-State: AOAM532/Jn+vaH3vV0V7gSBT5wumys3u5iJkkNVJQ9Ut+17B+pex7pws
        HnNDoUf2UUIg4oXVitMYks/xt2Q2GY3eZA==
X-Google-Smtp-Source: ABdhPJybDboTcIoPrDromzX2NozKBWIAaGBiLcu1WvQuhqrFOAsjY55m14CEqiufm6Va+PtKDa0vBA==
X-Received: by 2002:a17:90b:2382:: with SMTP id mr2mr28309837pjb.148.1633380591556;
        Mon, 04 Oct 2021 13:49:51 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id o12sm13635063pjm.57.2021.10.04.13.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:49:51 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v3 12/17] x86 AMD SEV: Initial support
Date:   Mon,  4 Oct 2021 13:49:26 -0700
Message-Id: <20211004204931.1537823-13-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004204931.1537823-1-zxwang42@gmail.com>
References: <20211004204931.1537823-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

AMD Secure Encrypted Virtualization (SEV) is a hardware accelerated
memory encryption feature that protects guest VMs from host attacks.

This commit provides set up code and a test case for AMD SEV. The set up
code checks if SEV is supported and enabled, and then sets SEV c-bit for
each page table entry.

Co-developed-by: Hyunwook (Wooky) Baek <baekhw@google.com>
Signed-off-by: Hyunwook (Wooky) Baek <baekhw@google.com>
Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/amd_sev.c   | 75 +++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/amd_sev.h   | 45 +++++++++++++++++++++++++++
 lib/x86/asm/setup.h |  1 +
 lib/x86/setup.c     | 15 +++++++++
 x86/Makefile.common |  1 +
 x86/Makefile.x86_64 |  3 ++
 x86/amd_sev.c       | 64 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 204 insertions(+)
 create mode 100644 lib/x86/amd_sev.c
 create mode 100644 lib/x86/amd_sev.h
 create mode 100644 x86/amd_sev.c

diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
new file mode 100644
index 0000000..13e6455
--- /dev/null
+++ b/lib/x86/amd_sev.c
@@ -0,0 +1,75 @@
+/*
+ * AMD SEV support in kvm-unit-tests
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
+static unsigned short amd_sev_c_bit_pos;
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
+		if (rdmsr(MSR_SEV_STATUS) & SEV_ENABLED_MASK) {
+			sev_enabled = true;
+		}
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
+	amd_sev_c_bit_pos = (unsigned short)(cpuid_out.b & 0x3f);
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
index 0000000..68483c9
--- /dev/null
+++ b/lib/x86/amd_sev.h
@@ -0,0 +1,45 @@
+/*
+ * AMD SEV support in kvm-unit-tests
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
index 9cc135a..30ca341 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -12,6 +12,7 @@ unsigned long setup_tss(void);
 #include "x86/smp.h"
 #include "asm/page.h"
 #include "efi.h"
+#include "x86/amd_sev.h"
 
 /*
  * efi_bootinfo_t: stores EFI-related machine info retrieved by
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index c1aa82a..ad7f725 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -251,6 +251,18 @@ efi_status_t setup_efi_pre_boot(unsigned long *mapkey, efi_bootinfo_t *efi_booti
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
 
@@ -269,6 +281,9 @@ static void setup_page_table(void)
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
2.33.0

