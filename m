Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63794338D45
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 13:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhCLMjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 07:39:02 -0500
Received: from 8bytes.org ([81.169.241.247]:58784 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230272AbhCLMih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 07:38:37 -0500
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 14B3A54C;
        Fri, 12 Mar 2021 13:38:32 +0100 (CET)
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 3/8] x86/boot/compressed/64: Reload CS in startup_32
Date:   Fri, 12 Mar 2021 13:38:19 +0100
Message-Id: <20210312123824.306-4-joro@8bytes.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210312123824.306-1-joro@8bytes.org>
References: <20210312123824.306-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Exception handling in the startup_32 boot path requires the CS
selector to be correctly set up. Reload it from the current GDT.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/head_64.S | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index e94874f4bbc1..c59c80ca546d 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -107,9 +107,16 @@ SYM_FUNC_START(startup_32)
 	movl	%eax, %gs
 	movl	%eax, %ss
 
-/* setup a stack and make sure cpu supports long mode. */
+	/* Setup a stack and load CS from current GDT */
 	leal	rva(boot_stack_end)(%ebp), %esp
 
+	pushl	$__KERNEL32_CS
+	leal	rva(1f)(%ebp), %eax
+	pushl	%eax
+	lretl
+1:
+
+	/* Make sure cpu supports long mode. */
 	call	verify_cpu
 	testl	%eax, %eax
 	jnz	.Lno_longmode
-- 
2.30.1

