Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C38E3337B0
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 09:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbhCJIof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 03:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbhCJIn7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 03:43:59 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307B0C061765;
        Wed, 10 Mar 2021 00:43:58 -0800 (PST)
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 540CD59F;
        Wed, 10 Mar 2021 09:43:54 +0100 (CET)
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
Subject: [PATCH v2 5/7] x86/boot/compressed/64: Add CPUID sanity check to 32-bit boot-path
Date:   Wed, 10 Mar 2021 09:43:23 +0100
Message-Id: <20210310084325.12966-6-joro@8bytes.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210310084325.12966-1-joro@8bytes.org>
References: <20210310084325.12966-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The 32-bit #VC handler has no GHCB and can only handle CPUID exit codes.
It is needed by the early boot code to handle #VC exceptions raised in
verify_cpu() and to get the position of the C bit.

But the CPUID information comes from the hypervisor, which is untrusted
and might return results which trick the guest into the no-SEV boot path
with no C bit set in the page-tables. All data written to memory would
then be unencrypted and could leak sensitive data to the hypervisor.

Add sanity checks to the 32-bit boot #VC handler to make sure the
hypervisor does not pretend that SEV is not enabled.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/mem_encrypt.S | 36 ++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/x86/boot/compressed/mem_encrypt.S b/arch/x86/boot/compressed/mem_encrypt.S
index 2ca056a3707c..8941c3a8ff8a 100644
--- a/arch/x86/boot/compressed/mem_encrypt.S
+++ b/arch/x86/boot/compressed/mem_encrypt.S
@@ -145,6 +145,34 @@ SYM_CODE_START(startup32_vc_handler)
 	jnz	.Lfail
 	movl	%edx, 0(%esp)		# Store result
 
+	/*
+	 * Sanity check CPUID results from the Hypervisor. See comment in
+	 * do_vc_no_ghcb() for more details on why this is necessary.
+	 */
+
+	/* Fail if Hypervisor bit not set in CPUID[1].ECX[31] */
+	cmpl    $1, %ebx
+	jne     .Lcheck_leaf
+	btl     $31, 4(%esp)
+	jnc     .Lfail
+	jmp     .Ldone
+
+.Lcheck_leaf:
+	/* Fail if SEV leaf not available in CPUID[0x80000000].EAX */
+	cmpl    $0x80000000, %ebx
+	jne     .Lcheck_sev
+	cmpl    $0x8000001f, 12(%esp)
+	jb      .Lfail
+	jmp     .Ldone
+
+.Lcheck_sev:
+	/* Fail if SEV bit not set in CPUID[0x8000001f].EAX[1] */
+	cmpl    $0x8000001f, %ebx
+	jne     .Ldone
+	btl     $1, 12(%esp)
+	jnc     .Lfail
+
+.Ldone:
 	popl	%edx
 	popl	%ecx
 	popl	%ebx
@@ -158,6 +186,14 @@ SYM_CODE_START(startup32_vc_handler)
 
 	iret
 .Lfail:
+	/* Send terminate request to Hypervisor */
+	movl    $0x100, %eax
+	xorl    %edx, %edx
+	movl    $MSR_AMD64_SEV_ES_GHCB, %ecx
+	wrmsr
+	rep; vmmcall
+
+	/* If request fails, go to hlt loop */
 	hlt
 	jmp .Lfail
 SYM_CODE_END(startup32_vc_handler)
-- 
2.30.1

