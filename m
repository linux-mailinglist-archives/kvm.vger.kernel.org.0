Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A104218A7
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 22:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhJDUvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 16:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbhJDUvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 16:51:33 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD016C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 13:49:43 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so628986pjb.1
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 13:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VZmYVBTYU6HJTLci6i04nKEFCPp+tbbCbVxTFDfMLQs=;
        b=cZE+DDWKARtSxW1ndBEm/4lpqnxFLAomSZ3FQ0CJpnptLmDPp06fXKqsDtx4t5sxV1
         aZOx91K+lD+4W311r1ae7RtEK8H0IfQTQ3du88TgdvXgJmzNpXCq7rXTBPgjKwEGgU4t
         dZKZ8Qy/1mV5GtEafL2QnxUDl8yhQ35TJWsqZEQ7pPIeUGHnBrZWbHx+J05j/HDtOn/k
         G2g7PfL/1R2YCFLi3asBrV3zNk+Fg1CnsGkcVq28B0o+SZ3dNqw1mbBhSPkCmOQoUEj3
         fckKtZq+aQjAnOtUT1wIO8A28fRuEqnoW/IuYHtwCUtTC9StnZGbTx4hB+t/iP/i1e2k
         3xUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VZmYVBTYU6HJTLci6i04nKEFCPp+tbbCbVxTFDfMLQs=;
        b=le1foSsGnlFwW9hsBcdH8ayBXox4Vsfp+X85LYzEfOArgpWgedWQGqw4q3Lao/jUq2
         7jIZR64/uDqBxbJygNvY45v4F5a3g20VE1HLouhqWfBKF/qTAI2iUwiB6j/FEC6MrKFg
         gFtuLtFjAt/4euiDFqvc4bpwPrtIh128eFOlVZK/W6ng/59MWfNlzO1Z0wwZgOuJ6tEI
         1T9R0FI5QEEgKGck0I4zLsNn/cyUwl/JkWOi17toDFqgC4fCsxvLdlyeog345DpgEQ6Q
         5eKYOojF5nC1+JWpYk6l/x4Bx4BklGwBht1WxQQR1ap82lPXuYi/7rjmWwrbFwnOn4FA
         sfAw==
X-Gm-Message-State: AOAM5307LXwyoxk7tZllsf5oeWEOp0g/NuqK5e/WF97aRvDt6TsyT9Nl
        yPoJAv2zzD9OGArJM7NrR/jFcR9Aif1Vdw==
X-Google-Smtp-Source: ABdhPJzaB1WIe89VeW+nRBIA3mx3lKPylq6ZnQ7Vja2hILfp56ZY5LowxU/r3l1egmcIvJVKsP/WPQ==
X-Received: by 2002:a17:90b:30c:: with SMTP id ay12mr11096456pjb.234.1633380582957;
        Mon, 04 Oct 2021 13:49:42 -0700 (PDT)
Received: from localhost.localdomain (netadmin.ucsd.edu. [137.110.160.224])
        by smtp.gmail.com with ESMTPSA id o12sm13635063pjm.57.2021.10.04.13.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 13:49:42 -0700 (PDT)
From:   Zixuan Wang <zxwang42@gmail.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
Subject: [kvm-unit-tests PATCH v3 06/17] x86 UEFI: Load IDT after UEFI boot up
Date:   Mon,  4 Oct 2021 13:49:20 -0700
Message-Id: <20211004204931.1537823-7-zxwang42@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004204931.1537823-1-zxwang42@gmail.com>
References: <20211004204931.1537823-1-zxwang42@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zixuan Wang <zixuanwang@google.com>

Interrupt descriptor table (IDT) is used by x86 arch to describe the
interrupt handlers. UEFI already setup an IDT before running the test
binaries, but this IDT is not compatible with the existing
KVM-Unit-Tests test cases, e.g., x86/msr.c triggers a #GP fault when
using UEFI IDT. This is because test cases setup new interrupt handlers
and register them into KVM-Unit-Tests' IDT, but it takes no effect if we
do not load KVM-Unit-Tests' IDT.

This commit fixes this issue by setting up and loding the IDT.

In this commit, the x86/msr.c can run in UEFI and generates same output
as the default Seabios version.

Co-developed-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 lib/x86/setup.c            |  5 +++++
 x86/Makefile.x86_64        |  2 +-
 x86/efi/README.md          |  4 ++--
 x86/efi/efistart64.S       | 12 ++++++++++++
 x86/efi/elf_x86_64_efi.lds |  6 +++++-
 5 files changed, 25 insertions(+), 4 deletions(-)
 create mode 100644 x86/efi/efistart64.S

diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 2fbf04f..8606fe8 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -163,9 +163,14 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 
 #ifdef TARGET_EFI
 
+/* From x86/efi/efistart64.S */
+extern void load_idt(void);
+
 void setup_efi(void)
 {
 	reset_apic();
+	setup_idt();
+	load_idt();
 	mask_pic_interrupts();
 	enable_apic();
 	enable_x2apic();
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index a5f8923..aa23b22 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -5,7 +5,7 @@ ifeq ($(TARGET_EFI),y)
 exe = efi
 bin = so
 FORMAT = efi-app-x86_64
-cstart.o = x86/efi/crt0-efi-x86_64.o
+cstart.o = $(TEST_DIR)/efi/efistart64.o
 else
 exe = flat
 bin = elf
diff --git a/x86/efi/README.md b/x86/efi/README.md
index d62758c..a39f509 100644
--- a/x86/efi/README.md
+++ b/x86/efi/README.md
@@ -22,13 +22,13 @@ To build:
 
 To run a test case with UEFI:
 
-    ./x86/efi/run ./x86/dummy.efi
+    ./x86/efi/run ./x86/msr.efi
 
 By default the runner script loads the UEFI firmware `/usr/share/ovmf/OVMF.fd`;
 please install UEFI firmware to this path, or specify the correct path through
 the env variable `EFI_UEFI`:
 
-    EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/dummy.efi
+    EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/msr.efi
 
 ## Code structure
 
diff --git a/x86/efi/efistart64.S b/x86/efi/efistart64.S
new file mode 100644
index 0000000..41e9185
--- /dev/null
+++ b/x86/efi/efistart64.S
@@ -0,0 +1,12 @@
+/* Startup code and pre-defined data structures */
+
+#include "crt0-efi-x86_64.S"
+
+.section .init
+.code64
+.text
+
+.globl load_idt
+load_idt:
+	lidtq idt_descr(%rip)
+	retq
diff --git a/x86/efi/elf_x86_64_efi.lds b/x86/efi/elf_x86_64_efi.lds
index 5eae376..3d92c86 100644
--- a/x86/efi/elf_x86_64_efi.lds
+++ b/x86/efi/elf_x86_64_efi.lds
@@ -1,4 +1,4 @@
-/* Copied from GNU-EFI/gnuefi/elf_x86_64_efi.lds, licensed under GNU GPL */
+/* Developed based on GNU-EFI/gnuefi/elf_x86_64_efi.lds, licensed under GNU GPL */
 /* Same as elf_x86_64_fbsd_efi.lds, except for OUTPUT_FORMAT below - KEEP IN SYNC */
 OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
 OUTPUT_ARCH(i386:x86-64)
@@ -38,6 +38,10 @@ SECTIONS
    *(.rodata*)
    *(.got.plt)
    *(.got)
+   /* Expected by lib/x86/desc.c to store exception_table */
+   exception_table_start = .;
+   *(.data.ex)
+   exception_table_end = .;
    *(.data*)
    *(.sdata)
    /* the EFI loader doesn't seem to like a .bss section, so we stick
-- 
2.33.0

