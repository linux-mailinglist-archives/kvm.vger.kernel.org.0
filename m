Return-Path: <kvm+bounces-14292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E147F8A1E47
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:31:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93AD5B2E01B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C73F158AD6;
	Thu, 11 Apr 2024 17:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gaM0eisk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE8457863
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 17:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712856594; cv=none; b=ca81407uo8rW/bxRxI6RiqRbLXq56dVOmgrYqMB/njTLO8G/wwr1Y24jnnTeZNVGfpbcTlGxgT6xZhgabnnkgNLzYLcMJHOTSLGtzRIkKoxUhQARTNxGy/s/uY4ZGyRzVoFMIslIfYyHS33RFamnhQgRFhu3HHrQ31TfwBX7THc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712856594; c=relaxed/simple;
	bh=jlzRV2K6Yk5P37o5pIvdKhOPjPch1/JMHXMqWSLs0o8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YNe/o0B1fIFba8Dd2zZG0s/l8//KBxxd53Nu6/Est8EE2j1yIfate9+3lSo4gvOQ7kKuZ9KCKyI4YbjM3/VYjgtCB7PiCJuZp/zQcUg8ijhEMeYoWzD9LAAgZInyBY1utZL0vApFRoa+MREhIuraxmf6Dq3S+H1b5QevTJ83d3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gaM0eisk; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-56e48d0a632so36814a12.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 10:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712856590; x=1713461390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tiorlk2dlDcfnkSswAs4Gpur4Z/j2t9yGm7jJiyiM5M=;
        b=gaM0eiskJG8AdcJHZg39CSLD/OWIrclg+UvkJO1wSwlbLKTPWKrXD4S0KplSYkQnO6
         IrEgy3c4jEaF2kgqSD/zdmUFoqwfB2xtGIzhgy2J1bCthm16QDiIvSkHRlsBboiCyUB7
         zyXpc/mprHDH6mTxlKpIiVa+syP24afbLsQ+VuCljqh1lcrcP+Lt+goKrWgW2uNpVxSv
         HsOdwkM3hgzZznks1m5zBIZ8NVa57HiLdFo5z5zVpZx3j1gErq9kRAWMpDKcfsNXYvmC
         GS78ijThKmQY/PA339zovNVMTH+mdru0LPaFn6soV0XC/DaAVDmgwS3x1LuLsJxJ8Dy8
         1HEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712856590; x=1713461390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tiorlk2dlDcfnkSswAs4Gpur4Z/j2t9yGm7jJiyiM5M=;
        b=vls5Lqdf+F5EcZza4hWuTYqn38sHf4lkTyBByiC+lJyTgfJFbNgkR8mNAfva3RMXbu
         medkfRXWAv7pWCqRxoNV10BE37Z4rRcGpO+vzYZQmXmDOGUrCLyLuUZJS0HPmOZOEsXc
         1ehve2JqBqRC735KnxgiaOW+/8WkKcmQ2IQuIAczUyGhd/hJFeNxmAAHxecKpNwiOqHv
         bPUSdQdNJP11y5ZOxYWJJylnlSgZ4x3HxIPO/7SPROOxpV2jmCOv81t9v1d2Uwz0u8Xw
         uEz+1FY15AnkOMsa4TnmsUt5wqUc06xPBi1Mo8IekkU1f840XORm3psKpS02ClnzUzT+
         t0tQ==
X-Gm-Message-State: AOJu0YxKkF+DhKF1OhQGMlMXlik50/ort/lCv+6G2pAKP7w73IQGA9KZ
	96wZXXnrB8kUSygEqDRBjxKPl3x8H1D/m0Y7GpMIhd3z1wfW1Ph0jNH4MGYz
X-Google-Smtp-Source: AGHT+IGoEmmTRyVczy9hW3IR5IfE98ayt6VOdUqU4WPUMeU8rK4MT3q6/+nLtD828zN4H0+3S4pgwg==
X-Received: by 2002:a50:8d5e:0:b0:568:cdf3:5cb2 with SMTP id t30-20020a508d5e000000b00568cdf35cb2mr372576edt.30.1712856589784;
        Thu, 11 Apr 2024 10:29:49 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab51:1500:e6c:48bd:8b53:bc56])
        by smtp.gmail.com with ESMTPSA id j1-20020aa7de81000000b0056e62321eedsm863461edv.17.2024.04.11.10.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 10:29:48 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	zxwang42@gmail.com,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>,
	Marc Orr <marcorr@google.com>
Subject: [kvm-unit-tests PATCH v6 01/11] x86: AMD SEV-ES: Setup #VC exception handler for AMD SEV-ES
Date: Thu, 11 Apr 2024 19:29:34 +0200
Message-Id: <20240411172944.23089-2-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240411172944.23089-1-vsntk18@gmail.com>
References: <20240411172944.23089-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vasant Karasulli <vkarasulli@suse.de>

AMD SEV-ES defines a new guest exception that gets triggered on
some vmexits to allow the guest to control what state gets shared
with the host. kvm-unit-tests currently relies on UEFI to provide
this #VC exception handler. This leads to the following problems:

1) The test's page table needs to map the firmware and the shared
   GHCB used by the firmware.
2) The firmware needs to keep its #VC handler in the current IDT
   so that kvm-unit-tests can copy the #VC entry into its own IDT.
3) The firmware #VC handler might use state which is not available
   anymore after ExitBootServices.
4) After ExitBootServices, the firmware needs to get the GHCB address
   from the GHCB MSR if it needs to use the kvm-unit-test GHCB. This
   requires keeping an identity mapping, and the GHCB address must be
   in the MSR at all times where a #VC could happen.

Problems 1) and 2) were temporarily mitigated via commits b114aa57ab
("x86 AMD SEV-ES: Set up GHCB page") and 706ede1833 ("x86 AMD SEV-ES:
Copy UEFI #VC IDT entry") respectively.

However, to make kvm-unit-tests reliable against 3) and 4), the tests
must supply their own #VC handler [1][2].

Switch the tests to install a #VC handler on early bootup, just after
GHCB has been mapped. The tests will use this handler by default.
If --amdsev-efi-vc is passed during ./configure, the tests will
continue using the UEFI #VC handler.

[1] https://lore.kernel.org/all/Yf0GO8EydyQSdZvu@suse.de/
[2] https://lore.kernel.org/all/YSA%2FsYhGgMU72tn+@google.com/

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
Reviewed-by: Marc Orr <marcorr@google.com>
---
 Makefile             |  3 +++
 configure            | 21 +++++++++++++++++++++
 lib/x86/amd_sev.c    | 13 +++++--------
 lib/x86/amd_sev.h    |  1 +
 lib/x86/amd_sev_vc.c | 15 +++++++++++++++
 lib/x86/desc.c       | 17 +++++++++++++++++
 lib/x86/desc.h       |  1 +
 lib/x86/setup.c      |  8 ++++++++
 x86/Makefile.common  |  1 +
 x86/efi/README.md    |  4 ++++
 10 files changed, 76 insertions(+), 8 deletions(-)
 create mode 100644 lib/x86/amd_sev_vc.c

diff --git a/Makefile b/Makefile
index 4f35fffc..61cd666a 100644
--- a/Makefile
+++ b/Makefile
@@ -41,6 +41,9 @@ OBJDIRS += $(LIBFDT_objdir)
 # EFI App
 ifeq ($(CONFIG_EFI),y)
 EFI_CFLAGS := -DCONFIG_EFI -DCONFIG_RELOC
+ifeq ($(AMDSEV_EFI_VC),y)
+EFI_CFLAGS += -DAMDSEV_EFI_VC
+endif
 # The following CFLAGS and LDFLAGS come from:
 #   - GNU-EFI/Makefile.defaults
 #   - GNU-EFI/apps/Makefile
diff --git a/configure b/configure
index 49f047cb..d4b4769e 100755
--- a/configure
+++ b/configure
@@ -33,6 +33,12 @@ page_size=
 earlycon=
 efi=
 efi_direct=
+# For AMD SEV-ES, the tests build to use their own #VC exception handler
+# by default, instead of using the one installed by UEFI. This ensures
+# that the tests do not depend on UEFI state after ExitBootServices.
+# To continue using the UEFI #VC handler, ./configure can be run with
+# --amdsev-efi-vc.
+amdsev_efi_vc=

 # Enable -Werror by default for git repositories only (i.e. developer builds)
 if [ -e "$srcdir"/.git ]; then
@@ -97,6 +103,8 @@ usage() {
 	                           system and run from the UEFI shell. Ignored when efi isn't enabled
 	                           and defaults to enabled when efi is enabled for riscv64.
 	                           (arm64 and riscv64 only)
+            --amdsev-efi-vc        Use UEFI-provided #VC handlers on AMD SEV/ES. Requires
+                                   --enable-efi.
 EOF
     exit 1
 }
@@ -188,6 +196,9 @@ while [[ "$1" = -* ]]; do
 	--disable-werror)
 	    werror=
 	    ;;
+	--amdsev-efi-vc)
+	    amdsev_efi_vc=y
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -278,8 +289,17 @@ elif [ "$processor" = "arm" ]; then
     processor="cortex-a15"
 fi

+if [ "$amdsev_efi_vc" ] && [ "$arch" != "x86_64" ]; then
+    echo "--amdsev-efi-vc requires arch x86_64."
+    usage
+fi
+
 if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
+    if [ "$amdsev_efi_vc" ] && [ -z "$efi" ]; then
+        echo "--amdsev-efi-vc requires --enable-efi."
+        usage
+    fi
 elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     testdir=arm
     if [ "$target" = "qemu" ]; then
@@ -451,6 +471,7 @@ HOST_KEY_DOCUMENT=$host_key_document
 CONFIG_DUMP=$enable_dump
 CONFIG_EFI=$efi
 EFI_DIRECT=$efi_direct
+AMDSEV_EFI_VC=$amdsev_efi_vc
 CONFIG_WERROR=$werror
 GEN_SE_HEADER=$gen_se_header
 EOF
diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index 66722141..987b59f9 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -14,6 +14,7 @@
 #include "x86/vm.h"

 static unsigned short amd_sev_c_bit_pos;
+phys_addr_t ghcb_addr;

 bool amd_sev_enabled(void)
 {
@@ -100,14 +101,10 @@ efi_status_t setup_amd_sev_es(void)

 	/*
 	 * Copy UEFI's #VC IDT entry, so KVM-Unit-Tests can reuse it and does
-	 * not have to re-implement a #VC handler. Also update the #VC IDT code
-	 * segment to use KVM-Unit-Tests segments, KERNEL_CS, so that we do not
+	 * not have to re-implement a #VC handler for #VC exceptions before
+	 * GHCB is mapped. Also update the #VC IDT code segment to use
+	 * KVM-Unit-Tests segments, KERNEL_CS, so that we do not
 	 * have to copy the UEFI GDT entries into KVM-Unit-Tests GDT.
-	 *
-	 * TODO: Reusing UEFI #VC handler is a temporary workaround to simplify
-	 * the boot up process, the long-term solution is to implement a #VC
-	 * handler in kvm-unit-tests and load it, so that kvm-unit-tests does
-	 * not depend on specific UEFI #VC handler implementation.
 	 */
 	sidt(&idtr);
 	idt = (idt_entry_t *)idtr.base;
@@ -126,7 +123,7 @@ void setup_ghcb_pte(pgd_t *page_table)
 	 * function searches GHCB's L1 pte, creates corresponding L1 ptes if not
 	 * found, and unsets the c-bit of GHCB's L1 pte.
 	 */
-	phys_addr_t ghcb_addr, ghcb_base_addr;
+	phys_addr_t ghcb_base_addr;
 	pteval_t *pte;

 	/* Read the current GHCB page addr */
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index ed6e3385..713019c2 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -54,6 +54,7 @@ efi_status_t setup_amd_sev(void);
 bool amd_sev_es_enabled(void);
 efi_status_t setup_amd_sev_es(void);
 void setup_ghcb_pte(pgd_t *page_table);
+void handle_sev_es_vc(struct ex_regs *regs);

 unsigned long long get_amd_sev_c_bit_mask(void);
 unsigned long long get_amd_sev_addr_upperbound(void);
diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
new file mode 100644
index 00000000..f6227030
--- /dev/null
+++ b/lib/x86/amd_sev_vc.c
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "amd_sev.h"
+
+extern phys_addr_t ghcb_addr;
+
+void handle_sev_es_vc(struct ex_regs *regs)
+{
+	struct ghcb *ghcb = (struct ghcb *) ghcb_addr;
+
+	if (!ghcb) {
+		/* TODO: kill guest */
+		return;
+	}
+}
diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index d054899c..2ca403bb 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -4,6 +4,9 @@
 #include "smp.h"
 #include <setjmp.h>
 #include "apic-defs.h"
+#ifdef CONFIG_EFI
+#include "amd_sev.h"
+#endif

 /* Boot-related data structures */

@@ -250,6 +253,9 @@ EX_E(ac, 17);
 EX(mc, 18);
 EX(xm, 19);
 EX_E(cp, 21);
+#ifdef CONFIG_EFI
+EX_E(vc, 29);
+#endif

 asm (".pushsection .text \n\t"
      "__handle_exception: \n\t"
@@ -316,6 +322,17 @@ void setup_idt(void)
 	}
 }

+#ifdef CONFIG_EFI
+void setup_amd_sev_es_vc(void)
+{
+	if (!amd_sev_es_enabled())
+		return;
+
+	set_idt_entry(29, &vc_fault, 0);
+	handle_exception(29, handle_sev_es_vc);
+}
+#endif
+
 void load_idt(void)
 {
 	lidt(&idt_descr);
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 7778a0f8..f8251194 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -252,6 +252,7 @@ void print_current_tss_info(void);
 handler handle_exception(u8 v, handler fn);
 void unhandled_exception(struct ex_regs *regs, bool cpu);
 const char* exception_mnemonic(int vector);
+void setup_amd_sev_es_vc(void);

 bool test_for_exception(unsigned int ex, void (*trigger_func)(void *data),
 			void *data);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index d509a248..65f5972a 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -363,6 +363,14 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	save_id();
 	bsp_rest_init();

+#ifndef AMDSEV_EFI_VC
+	/*
+	 * Switch away from the UEFI-installed #VC handler.
+	 * GHCB has already been mapped at this point.
+	 */
+	setup_amd_sev_es_vc();
+#endif /* AMDSEV_EFI_VC */
+
 	return EFI_SUCCESS;
 }

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 4ae9a557..bc0ed2c8 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -25,6 +25,7 @@ cflatobjs += lib/x86/delay.o
 cflatobjs += lib/x86/pmu.o
 ifeq ($(CONFIG_EFI),y)
 cflatobjs += lib/x86/amd_sev.o
+cflatobjs += lib/x86/amd_sev_vc.o
 cflatobjs += lib/efi.o
 cflatobjs += x86/efi/reloc_x86_64.o
 endif
diff --git a/x86/efi/README.md b/x86/efi/README.md
index aa1dbcdd..af6e339c 100644
--- a/x86/efi/README.md
+++ b/x86/efi/README.md
@@ -18,6 +18,10 @@ To build:
     ./configure --enable-efi
     make

+To make use of UEFI #VC handler for AMD SEV-ES:
+
+    ./configure --enable-efi --amdsev-efi-vc
+
 ### Run test cases with UEFI

 To run a test case with UEFI:
--
2.34.1


