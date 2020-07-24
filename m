Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE2822CA57
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 18:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgGXQEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 12:04:25 -0400
Received: from 8bytes.org ([81.169.241.247]:59420 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727873AbgGXQEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 12:04:25 -0400
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 7FB82FBD;
        Fri, 24 Jul 2020 18:04:15 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v5 34/75] x86/head/64: Make fixup_pointer() static inline
Date:   Fri, 24 Jul 2020 18:02:55 +0200
Message-Id: <20200724160336.5435-35-joro@8bytes.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200724160336.5435-1-joro@8bytes.org>
References: <20200724160336.5435-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Also move it to a header file so that it can be used in the idt code
to setup the early IDT.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/setup.h | 10 ++++++++++
 arch/x86/kernel/head64.c     |  5 -----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 5c2fd05bd52c..8aa6ba0427b0 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -74,6 +74,16 @@ static inline void x86_ce4100_early_setup(void) { }
 extern struct boot_params boot_params;
 extern char _text[];
 
+/*
+ * This function is used in C code that runs while the kernel still runs on
+ * identity mapped addresses to get the correct address of kernel pointers in
+ * the identity mapping.
+ */
+static __always_inline void *fixup_pointer(void *ptr, unsigned long physaddr)
+{
+	return ptr - (void *)_text + (void *)physaddr;
+}
+
 static inline bool kaslr_enabled(void)
 {
 	return IS_ENABLED(CONFIG_RANDOMIZE_MEMORY) &&
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index b0ab5627900b..8703292a35e9 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -82,11 +82,6 @@ static struct desc_ptr startup_gdt_descr = {
 
 #define __head	__section(.head.text)
 
-static void __head *fixup_pointer(void *ptr, unsigned long physaddr)
-{
-	return ptr - (void *)_text + (void *)physaddr;
-}
-
 static unsigned long __head *fixup_long(void *ptr, unsigned long physaddr)
 {
 	return fixup_pointer(ptr, physaddr);
-- 
2.27.0

