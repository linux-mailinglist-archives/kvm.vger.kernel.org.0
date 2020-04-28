Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803741BC31C
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgD1PSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728288AbgD1PSF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 11:18:05 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44496C03C1AB;
        Tue, 28 Apr 2020 08:18:05 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 86B32F14; Tue, 28 Apr 2020 17:17:48 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
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
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 34/75] x86/head/64: Switch to initial stack earlier
Date:   Tue, 28 Apr 2020 17:16:44 +0200
Message-Id: <20200428151725.31091-35-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Make sure there is a stack once the kernel runs from virual addresses.
At this stage any secondary CPU which boots will have lost its stack
because the kernel switched to a new page-table which does not map the
real-mode stack anymore.

This is needed for handling early #VC exceptions caused by instructions
like CPUID.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/head_64.S | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index b5ff38bb32f2..301a76f317f3 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -194,6 +194,12 @@ SYM_CODE_START(secondary_startup_64)
 	movl	initial_gs+4(%rip),%edx
 	wrmsr
 
+	/*
+	 * Setup a boot time stack - Any secondary CPU will have lost its stack
+	 * by now because the cr3-switch above unmaps the real-mode stack
+	 */
+	movq initial_stack(%rip), %rsp
+
 	/* Check if nx is implemented */
 	movl	$0x80000001, %eax
 	cpuid
@@ -214,9 +220,6 @@ SYM_CODE_START(secondary_startup_64)
 	/* Make changes effective */
 	movq	%rax, %cr0
 
-	/* Setup a boot time stack */
-	movq initial_stack(%rip), %rsp
-
 	/* zero EFLAGS after setting rsp */
 	pushq $0
 	popfq
-- 
2.17.1

