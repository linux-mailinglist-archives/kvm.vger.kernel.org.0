Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19D44547C0
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 14:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237684AbhKQNwx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 08:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbhKQNwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 08:52:51 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29281C061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:49:53 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id k37-20020a05600c1ca500b00330cb84834fso4854594wms.2
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 05:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bpdX0/cbGSIRH9EAbU52Z8ghDudhvXZ6kpgw+p1G+wU=;
        b=ggkj16mU7NV4XDBbd3gv0STDTXa0QpKU2so6Le6PBOPbwgkcB+oRZv8OoXwVYz9bdT
         QcUKzXhqawDZOXj217XeQyWW32oY51fvFoY+awaG5HM+iYwjcfW9xBUT41Ie7GSvWEB4
         EdnRCkXOOSarQzzNcm92y2mgEdB5B/DsdFHeCScoDQ7UslAjmEM7CLIL+zwR55GrMAvr
         E95RzcoaaEgW/PEmVWfpm5x8M0VfG14kwAwsSIu6+KuXbmC8x/LYMSPfivmENTvGTd8D
         /b3UVUTDZEwwremdZheCUwUe7h77LywoEU7IULqXULkbot3hfNY9kYSh37IylDaERcht
         5ndA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bpdX0/cbGSIRH9EAbU52Z8ghDudhvXZ6kpgw+p1G+wU=;
        b=6KZ3uq+Lbg7QNzHAe+9423fwkYtK+XFe+1ZL07AzU/266n0votwbH1PYurYWlEdBfC
         IHPEtoW17nxHCxMN2j7KOAC8mFfxfPoFRV/Mzej/utPFC3LvgDFVfweVwYY2nOvsRWYr
         cBgHBpVzTddBc5AUEr5B2wmFQtnPc3prZkyGJLnVzWQy2VLN5bjm7RFfRAle+UQ7Pf6z
         WpzZAzyGsA3ZacvynNIYc+x5cp9fKGr5zHKThLr61NvAh2rHNo8W8lZRvusPA8P6pE5X
         Waj7Og6KaDfUB+ao5sUotO5/miHpXQgE7AzmECWYdg+NjhDGmyYEIVrOsv3woGVzcxvs
         cRCQ==
X-Gm-Message-State: AOAM531UsohP2+NSHhyT+M9GKYPQT5QQwzl3vxz6lBw8qLVEafZfqxKg
        i98vy5bgyhX2L667psRjpP1j0XPTs4UQKw==
X-Google-Smtp-Source: ABdhPJwTbfQtzC0mgr9pnQqybvNtJ/mzYxPz41AbFREa1MnZme1Akr3BIkrFQ3Li2OEvpdfIEdXtDw==
X-Received: by 2002:a1c:1dd8:: with SMTP id d207mr79838878wmd.46.1637156991330;
        Wed, 17 Nov 2021 05:49:51 -0800 (PST)
Received: from xps15.suse.de (ip5f5aa686.dynamic.kabel-deutschland.de. [95.90.166.134])
        by smtp.gmail.com with ESMTPSA id m14sm28290709wrp.28.2021.11.17.05.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:49:50 -0800 (PST)
From:   Varad Gautam <varadgautam@gmail.com>
X-Google-Original-From: Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, zxwang42@gmail.com,
        marcorr@google.com, erdemaktas@google.com, rientjes@google.com,
        seanjc@google.com, brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        jroedel@suse.de, bp@suse.de, varad.gautam@suse.com
Subject: [RFC kvm-unit-tests 01/12] x86: AMD SEV-ES: Setup #VC exception handler for AMD SEV-ES
Date:   Wed, 17 Nov 2021 14:47:41 +0100
Message-Id: <20211117134752.32662-2-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117134752.32662-1-varad.gautam@suse.com>
References: <20211117134752.32662-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SEV-ES defines a new guest exception that gets triggered on
some vmexits to allow the guest to control what state gets shared
with the host.

Install a #VC handler on early bootup to process these exits, just
after GHCB has been mapped.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/amd_sev.c    |  3 ++-
 lib/x86/amd_sev.h    |  1 +
 lib/x86/amd_sev_vc.c | 14 ++++++++++++++
 lib/x86/desc.c       | 17 +++++++++++++++++
 lib/x86/desc.h       |  1 +
 lib/x86/setup.c      |  8 ++++++++
 x86/Makefile.common  |  1 +
 7 files changed, 44 insertions(+), 1 deletion(-)
 create mode 100644 lib/x86/amd_sev_vc.c

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
index 16b7256..8cdb2f2 100644
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
@@ -293,6 +299,17 @@ void setup_idt(void)
     handle_exception(13, check_exception_table);
 }
 
+void setup_amd_sev_es_vc(void)
+{
+#ifdef TARGET_EFI
+	if (!amd_sev_es_enabled())
+		return;
+
+	set_idt_entry(29, &vc_fault, 0);
+	handle_exception(29, handle_sev_es_vc);
+#endif
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
index 24fe74e..a749df0 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -346,6 +346,14 @@ void setup_efi(efi_bootinfo_t *efi_bootinfo)
 	phys_alloc_init(efi_bootinfo->free_mem_start, efi_bootinfo->free_mem_size);
 	setup_efi_rsdp(efi_bootinfo->rsdp);
 	setup_page_table();
+
+	if (amd_sev_es_enabled()) {
+		/*
+		 * Switch away from the UEFI-installed #VC handler.
+		 * GHCB has already been mapped at this point.
+		 */
+		setup_amd_sev_es_vc();
+	}
 }
 
 #endif /* TARGET_EFI */
diff --git a/x86/Makefile.common b/x86/Makefile.common
index deaa386..18526f0 100644
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

