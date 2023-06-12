Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5038272B92A
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 09:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbjFLHut (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 03:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235962AbjFLHts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 03:49:48 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCC7E7A
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 00:49:15 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A050C22856;
        Mon, 12 Jun 2023 07:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686556093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ysuihcEcWEW4bmpE9s7xuKgIuhLNcCPzkmqCXSv8z0A=;
        b=H4CAxbpGKdf8fELNiU4CmFqaS+nwBzUbL3KJVM8YHjjPJ7l63ZhcTX5liF6n3lpd73DHpQ
        GO1xsTpu3CT2TPa0nofzaSDrWxgMTmRT6YQs1F1PPJJUbI0NG8QNCcr7BjRzT6JDlG9G1W
        Su+6nPMp+RXI4JQDw7GydSNSuvdHDf0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686556093;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ysuihcEcWEW4bmpE9s7xuKgIuhLNcCPzkmqCXSv8z0A=;
        b=PxZXmIjfQUyHhDN8TKrSvG4xm+XDAAZKEFHQaKv2PUxRVepgqUPhaMXy/6BvnFg/BLp90f
        XCLtA9Q5h2x91RBQ==
Received: from vasant-suse.fritz.box (unknown [10.163.24.134])
        by relay2.suse.de (Postfix) with ESMTP id 3698B2C141;
        Mon, 12 Jun 2023 07:48:13 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     pbonzini@redhat.com
Cc:     Thomas.Lendacky@amd.com, drjones@redhat.com, erdemaktas@google.com,
        jroedel@suse.de, kvm@vger.kernel.org, marcorr@google.com,
        rientjes@google.com, seanjc@google.com, zxwang42@gmail.com,
        Vasant Karasulli <vkarasulli@suse.de>,
        Varad Gautam <varad.gautam@suse.com>
Subject: [PATCH v4 01/11] x86: AMD SEV-ES: Setup #VC exception handler for AMD SEV-ES
Date:   Mon, 12 Jun 2023 09:47:48 +0200
Message-Id: <20230612074758.9177-2-vkarasulli@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230612074758.9177-1-vkarasulli@suse.de>
References: <20230612074758.9177-1-vkarasulli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 9 files changed, 72 insertions(+), 8 deletions(-)
 create mode 100644 lib/x86/amd_sev_vc.c

diff --git a/Makefile b/Makefile
index 6ed5dea..b7de565 100644
--- a/Makefile
+++ b/Makefile
@@ -42,6 +42,9 @@ OBJDIRS += $(LIBFDT_objdir)
 ifeq ($(CONFIG_EFI),y)
 EFI_ARCH = x86_64
 EFI_CFLAGS := -DCONFIG_EFI
+ifeq ($(AMDSEV_EFI_VC),y)
+EFI_CFLAGS += -DAMDSEV_EFI_VC
+endif
 # The following CFLAGS and LDFLAGS come from:
 #   - GNU-EFI/Makefile.defaults
 #   - GNU-EFI/apps/Makefile
diff --git a/configure b/configure
index c36fd29..46dd76d 100755
--- a/configure
+++ b/configure
@@ -32,6 +32,12 @@ enable_dump=no
 page_size=
 earlycon=
 efi=
+# For AMD SEV-ES, the tests build to use their own #VC exception handler
+# by default, instead of using the one installed by UEFI. This ensures
+# that the tests do not depend on UEFI state after ExitBootServices.
+# To continue using the UEFI #VC handler, ./configure can be run with
+# --amdsev-efi-vc.
+amdsev_efi_vc=
 
 # Enable -Werror by default for git repositories only (i.e. developer builds)
 if [ -e "$srcdir"/.git ]; then
@@ -89,6 +95,8 @@ usage() {
 	    --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 only)
 	    --[enable|disable]-werror
 	                           Select whether to compile with the -Werror compiler flag
+            --amdsev-efi-vc        Use UEFI-provided #VC handlers on AMD SEV/ES. Requires
+                                   --enable-efi.
 EOF
     exit 1
 }
@@ -174,6 +182,9 @@ while [[ "$1" = -* ]]; do
 	--disable-werror)
 	    werror=
 	    ;;
+	--amdsev-efi-vc)
+	    amdsev_efi_vc=y
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -240,8 +251,17 @@ elif [ "$processor" = "arm" ]; then
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
@@ -401,6 +421,7 @@ GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
 CONFIG_DUMP=$enable_dump
 CONFIG_EFI=$efi
+AMDSEV_EFI_VC=$amdsev_efi_vc
 CONFIG_WERROR=$werror
 GEN_SE_HEADER=$gen_se_header
 EOF
diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index 6672214..987b59f 100644
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
index ed6e338..713019c 100644
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
index 0000000..f622703
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
index b293ae4..dc8b901 100644
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
 
@@ -243,6 +246,9 @@ EX_E(ac, 17);
 EX(mc, 18);
 EX(xm, 19);
 EX_E(cp, 21);
+#ifdef CONFIG_EFI
+EX_E(vc, 29);
+#endif
 
 asm (".pushsection .text \n\t"
      "__handle_exception: \n\t"
@@ -309,6 +315,17 @@ void setup_idt(void)
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
index c023b93..c6505aa 100644
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
index dd15030..e97ea43 100644
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
index 365e199..79a8a9d 100644
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
-- 
2.34.1

