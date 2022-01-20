Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDB2494E3D
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 13:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243428AbiATMwH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 07:52:07 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:41292 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243307AbiATMwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 07:52:06 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A33691F76B;
        Thu, 20 Jan 2022 12:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642683125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LBtj1TgonGKyClPEccqRAK8ugiYcdsUZoI7M9133Hz8=;
        b=kdjkC0VyjpG1UtS9bIleEwLPKHigUBTrABSZUjL9gCN57Sb9G7OUVrZsV7209PZOddQT+D
        3Xi81FH3cvlN0thGdeF8PTOUFRfBkcbiq3/2rZIb1TlvMCwt/FAiLBQLYzgJYHdkpMc6XR
        M9oms3X5+6S2pNwBrj7eIPEM7sxHhB8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1B34E13B51;
        Thu, 20 Jan 2022 12:52:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qE2SBPVa6WGIagAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Thu, 20 Jan 2022 12:52:05 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de,
        varad.gautam@suse.com
Subject: [kvm-unit-tests 02/13] x86: AMD SEV-ES: Setup #VC exception handler for AMD SEV-ES
Date:   Thu, 20 Jan 2022 13:51:11 +0100
Message-Id: <20220120125122.4633-3-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220120125122.4633-1-varad.gautam@suse.com>
References: <20220120125122.4633-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SEV-ES defines a new guest exception that gets triggered on
some vmexits to allow the guest to control what state gets shared
with the host. kvm-unit-tests currently relies on UEFI to provide
this #VC exception handler.

Switch the tests to install their own #VC handler on early bootup
to process these exits, just after GHCB has been mapped.

If --amdsev-efi-vc is passed during ./configure, the tests will
continue using the UEFI #VC handler.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 Makefile             |  3 +++
 configure            | 16 ++++++++++++++++
 lib/x86/amd_sev.c    |  3 ++-
 lib/x86/amd_sev.h    |  1 +
 lib/x86/amd_sev_vc.c | 14 ++++++++++++++
 lib/x86/desc.c       | 15 +++++++++++++++
 lib/x86/desc.h       |  1 +
 lib/x86/setup.c      | 10 ++++++++++
 x86/Makefile.common  |  1 +
 9 files changed, 63 insertions(+), 1 deletion(-)
 create mode 100644 lib/x86/amd_sev_vc.c

diff --git a/Makefile b/Makefile
index 4f4ad23..94a0162 100644
--- a/Makefile
+++ b/Makefile
@@ -46,6 +46,9 @@ else
 $(error Cannot build $(ARCH_NAME) tests as EFI apps)
 endif
 EFI_CFLAGS := -DTARGET_EFI
+ifeq ($(AMDSEV_EFI_VC),y)
+EFI_CFLAGS += -DAMDSEV_EFI_VC
+endif
 # The following CFLAGS and LDFLAGS come from:
 #   - GNU-EFI/Makefile.defaults
 #   - GNU-EFI/apps/Makefile
diff --git a/configure b/configure
index 41372ef..c687d9f 100755
--- a/configure
+++ b/configure
@@ -29,6 +29,7 @@ host_key_document=
 page_size=
 earlycon=
 target_efi=
+amdsev_efi_vc=
 
 usage() {
     cat <<-EOF
@@ -71,6 +72,8 @@ usage() {
 	                           Specify a PL011 compatible UART at address ADDR. Supported
 	                           register stride is 32 bit only.
 	    --target-efi           Boot and run from UEFI
+	    --amdsev-efi-vc        Use UEFI-provided #VC handlers on AMD SEV/ES. Requires
+	                           --target-efi.
 EOF
     exit 1
 }
@@ -138,6 +141,9 @@ while [[ "$1" = -* ]]; do
 	--target-efi)
 	    target_efi=y
 	    ;;
+	--amdsev-efi-vc)
+	    amdsev_efi_vc=y
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -197,8 +203,17 @@ elif [ "$processor" = "arm" ]; then
     processor="cortex-a15"
 fi
 
+if [ "$amdsev_efi_vc" ] && [ "$arch" != "x86_64" ]; then
+    echo "--amdsev-efi-vc requires arch x86_64."
+    usage
+fi
+
 if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
+    if [ "$amdsev_efi_vc" ] && [ -z "$target_efi" ]; then
+        echo "--amdsev-efi-vc requires --target-efi."
+        usage
+    fi
 elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     testdir=arm
     if [ "$target" = "qemu" ]; then
@@ -356,6 +371,7 @@ WA_DIVIDE=$wa_divide
 GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
 TARGET_EFI=$target_efi
+AMDSEV_EFI_VC=$amdsev_efi_vc
 EOF
 if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     echo "TARGET=$target" >> config.mak
diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
index 6672214..bde126b 100644
--- a/lib/x86/amd_sev.c
+++ b/lib/x86/amd_sev.c
@@ -14,6 +14,7 @@
 #include "x86/vm.h"
 
 static unsigned short amd_sev_c_bit_pos;
+phys_addr_t ghcb_addr;
 
 bool amd_sev_enabled(void)
 {
@@ -126,7 +127,7 @@ void setup_ghcb_pte(pgd_t *page_table)
 	 * function searches GHCB's L1 pte, creates corresponding L1 ptes if not
 	 * found, and unsets the c-bit of GHCB's L1 pte.
 	 */
-	phys_addr_t ghcb_addr, ghcb_base_addr;
+	phys_addr_t ghcb_base_addr;
 	pteval_t *pte;
 
 	/* Read the current GHCB page addr */
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 6a10f84..afbacf3 100644
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
index 0000000..8226121
--- /dev/null
+++ b/lib/x86/amd_sev_vc.c
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include "amd_sev.h"
+
+extern phys_addr_t ghcb_addr;
+
+void handle_sev_es_vc(struct ex_regs *regs)
+{
+	struct ghcb *ghcb = (struct ghcb *) ghcb_addr;
+	if (!ghcb) {
+		/* TODO: kill guest */
+		return;
+	}
+}
diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 16b7256..73aa866 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -3,6 +3,9 @@
 #include "processor.h"
 #include <setjmp.h>
 #include "apic-defs.h"
+#ifdef TARGET_EFI
+#include "amd_sev.h"
+#endif
 
 /* Boot-related data structures */
 
@@ -228,6 +231,9 @@ EX_E(ac, 17);
 EX(mc, 18);
 EX(xm, 19);
 EX_E(cp, 21);
+#ifdef TARGET_EFI
+EX_E(vc, 29);
+#endif
 
 asm (".pushsection .text \n\t"
      "__handle_exception: \n\t"
@@ -293,6 +299,15 @@ void setup_idt(void)
     handle_exception(13, check_exception_table);
 }
 
+void setup_amd_sev_es_vc(void)
+{
+	if (!amd_sev_es_enabled())
+		return;
+
+	set_idt_entry(29, &vc_fault, 0);
+	handle_exception(29, handle_sev_es_vc);
+}
+
 unsigned exception_vector(void)
 {
     unsigned char vector;
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index b65539e..4fcbf9f 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -220,6 +220,7 @@ void set_intr_alt_stack(int e, void *fn);
 void print_current_tss_info(void);
 handler handle_exception(u8 v, handler fn);
 void unhandled_exception(struct ex_regs *regs, bool cpu);
+void setup_amd_sev_es_vc(void);
 
 bool test_for_exception(unsigned int ex, void (*trigger_func)(void *data),
 			void *data);
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index bbd3468..6013602 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -327,6 +327,16 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	smp_init();
 	setup_page_table();
 
+#ifndef AMDSEV_EFI_VC
+	if (amd_sev_es_enabled()) {
+		/*
+		 * Switch away from the UEFI-installed #VC handler.
+		 * GHCB has already been mapped at this point.
+		 */
+		setup_amd_sev_es_vc();
+	}
+#endif /* AMDSEV_EFI_VC */
+
 	return EFI_SUCCESS;
 }
 
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 984444e..65d16e7 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -24,6 +24,7 @@ cflatobjs += lib/x86/fault_test.o
 cflatobjs += lib/x86/delay.o
 ifeq ($(TARGET_EFI),y)
 cflatobjs += lib/x86/amd_sev.o
+cflatobjs += lib/x86/amd_sev_vc.o
 cflatobjs += lib/efi.o
 cflatobjs += x86/efi/reloc_x86_64.o
 endif
-- 
2.32.0

