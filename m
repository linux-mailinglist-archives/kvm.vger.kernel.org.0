Return-Path: <kvm+bounces-15332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E168AB323
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE89A1F22BAE
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA861132490;
	Fri, 19 Apr 2024 16:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U+QVchHS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954DA131180
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 16:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543395; cv=none; b=s/oYlSVNtJG9bNq6yuAg2rJUgy3bVrGznfI+bJf3Pa3w/gyURgYgvlrl0SUNgLbIPvA3Jif/LAJHzl7JeXNchCg4B1drkcNfQYrTU75/+ghG9MyPmb8G8W9PR99t79/g9HTrFGGqX9PJKMQUeiUjGExlfVswGHIfeYasxaf45sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543395; c=relaxed/simple;
	bh=jlzRV2K6Yk5P37o5pIvdKhOPjPch1/JMHXMqWSLs0o8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hzl2hd9y4Tlv5hb8/a+rcYmfB9d4Tcw9oRTxcgsCyWKStu6H1wbICaP9VGaKNFKCeb4XzPnV4HOEmUrs0ab3wjktWhA+YAqjKc1ZjFHmvr2W1/UClMttWPD+x5as5vNgDAZF1lcg2sl5d1Kum08BMxRiqalCh1MHKXof+G9ZZz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U+QVchHS; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3499f1bed15so1861701f8f.1
        for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 09:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713543389; x=1714148189; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tiorlk2dlDcfnkSswAs4Gpur4Z/j2t9yGm7jJiyiM5M=;
        b=U+QVchHSVDK7r9EtcHX0ElHhbmi2jBDqX+kbDdYefOL9oqpVRp3xonUZYpm2ZkeC+3
         G4Cqb8rfUOJyL9knUPU2teJ1W4Rsnz2p8bYoTS9vADQfiFOb2TTE6e8d7jk96f0RvnMt
         N2A8FtPpelxmn9pG+6q5+DRAdvjV4hoEHSvlSbJWBmu3XkMb1FKMjHO8f9P+ieooiUeC
         2ddJwDB8lLZGcxu5G46NYhiBUcxGWN+IbI//twB55KzfZ7UHM69Tsf/CuW0p3sb1D9S3
         UlEf22EUPeFasmhezN1qMN9+Jbm7kkt09W0MCLWhrVhWExkmuLh07OfXEBinwSMZSWFP
         9oyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713543389; x=1714148189;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tiorlk2dlDcfnkSswAs4Gpur4Z/j2t9yGm7jJiyiM5M=;
        b=ozTTV2KxET24HKZ/7WT2mRLFSWQEajkZMTh0SBQIj7G/u3giKrHOL1Ntx1LC84IoZs
         4VIJjBUqX4bzywDfiHXJbLP8nOv0kl0fMkWM37+SBmdKT6urNeawB+25HujbXHpaF50U
         YC38aRfmna0AGGdEQmvmxBcdW+TUe0us1vWw0lqHWxX/bZpkapekZYMEeL6wpQPvI2Zx
         LQGFYf3GSjE8665ZV7hOtqpIvJ7b/r259TxHjAGGXjC2DXuQkkhUPkgqgwFLSkCsFqtZ
         w5Bg8fKsKMQlipQXAJILVvY/A8+Cc9TVP4LF59wCOb/YxE0WFG2WvzBhg4KJ+chul5nJ
         5TjA==
X-Gm-Message-State: AOJu0Yy+WyreTr8ZxltR4WldUleanosvk1ggxZQZfAeeruVBruiiM4pB
	rrm7gmh7lGADDNrylfHHFl806XwDpQSlMzf6aM/i8tiNhSatIITFy6wOgrUY
X-Google-Smtp-Source: AGHT+IHT81CkIgEZcBwS2HYvFaUnPMdyNKtdQN6PlKUuHriyN/WPz2ZlAITaB+ZFcEuawh71vZ76aw==
X-Received: by 2002:a5d:528e:0:b0:343:d2e4:78b6 with SMTP id c14-20020a5d528e000000b00343d2e478b6mr4616112wrv.32.1713543389107;
        Fri, 19 Apr 2024 09:16:29 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab5e:9e00:8bce:ff73:6d2f:5c25])
        by smtp.gmail.com with ESMTPSA id je12-20020a05600c1f8c00b004183edc31adsm10742188wmb.44.2024.04.19.09.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 09:16:28 -0700 (PDT)
From: vsntk18@gmail.com
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	jroedel@suse.de,
	papaluri@amd.com,
	andrew.jones@linux.dev,
	Vasant Karasulli <vkarasulli@suse.de>,
	Varad Gautam <varad.gautam@suse.com>,
	Marc Orr <marcorr@google.com>
Subject: [kvm-unit-tests PATCH v7 01/11] x86: AMD SEV-ES: Setup #VC exception handler for AMD SEV-ES
Date: Fri, 19 Apr 2024 18:16:13 +0200
Message-Id: <20240419161623.45842-2-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419161623.45842-1-vsntk18@gmail.com>
References: <20240419161623.45842-1-vsntk18@gmail.com>
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


