Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA4E1BC294
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbgD1PR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:17:57 -0400
Received: from 8bytes.org ([81.169.241.247]:37386 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728178AbgD1PRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:17:55 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 732BFE06; Tue, 28 Apr 2020 17:17:44 +0200 (CEST)
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
Subject: [PATCH v3 12/75] x86/boot/compressed/64: Switch to __KERNEL_CS after GDT is loaded
Date:   Tue, 28 Apr 2020 17:16:22 +0200
Message-Id: <20200428151725.31091-13-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

When the pre-decompression code loads its first GDT in startup_64, it is
still running on the CS value of the previous GDT. In the case of SEV-ES
this is the EFI GDT.

To make exception handling work (especially IRET) the CPU needs to
switch to a CS value in the current GDT, so jump to __KERNEL_CS after
the first GDT is loaded.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/head_64.S | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 4f7e6b84be07..6b11060c3a0f 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -393,6 +393,14 @@ SYM_CODE_START(startup_64)
 	addq	%rax, 2(%rax)
 	lgdt	(%rax)
 
+	/* Reload CS so IRET returns to a CS actually in the GDT */
+	pushq	$__KERNEL_CS
+	leaq	.Lon_kernel_cs(%rip), %rax
+	pushq	%rax
+	lretq
+
+.Lon_kernel_cs:
+
 	/*
 	 * paging_prepare() sets up the trampoline and checks if we need to
 	 * enable 5-level paging.
-- 
2.17.1

