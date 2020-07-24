Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA8622C9CF
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 18:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgGXQEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 12:04:23 -0400
Received: from 8bytes.org ([81.169.241.247]:59420 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbgGXQEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 12:04:23 -0400
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 1BA70FB9;
        Fri, 24 Jul 2020 18:04:13 +0200 (CEST)
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
Subject: [PATCH v5 31/75] x86/head/64: Load GDT after switch to virtual addresses
Date:   Fri, 24 Jul 2020 18:02:52 +0200
Message-Id: <20200724160336.5435-32-joro@8bytes.org>
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

Load the GDT right after switching to virtual addresses to make sure
there is a defined GDT for exception handling.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/head_64.S | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 800053219054..f958d4e4ee08 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -166,6 +166,14 @@ SYM_CODE_START(secondary_startup_64)
 1:
 	UNWIND_HINT_EMPTY
 
+	/*
+	 * We must switch to a new descriptor in kernel space for the GDT
+	 * because soon the kernel won't have access anymore to the userspace
+	 * addresses where we're currently running on. We have to do that here
+	 * because in 32bit we couldn't load a 64bit linear address.
+	 */
+	lgdt	early_gdt_descr(%rip)
+
 	/* Check if nx is implemented */
 	movl	$0x80000001, %eax
 	cpuid
@@ -193,14 +201,6 @@ SYM_CODE_START(secondary_startup_64)
 	pushq $0
 	popfq
 
-	/*
-	 * We must switch to a new descriptor in kernel space for the GDT
-	 * because soon the kernel won't have access anymore to the userspace
-	 * addresses where we're currently running on. We have to do that here
-	 * because in 32bit we couldn't load a 64bit linear address.
-	 */
-	lgdt	early_gdt_descr(%rip)
-
 	/* set up data segments */
 	xorl %eax,%eax
 	movl %eax,%ds
-- 
2.27.0

