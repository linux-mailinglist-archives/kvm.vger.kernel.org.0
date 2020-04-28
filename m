Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923AB1BC35B
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgD1PYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728099AbgD1PRs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 11:17:48 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BFEC03C1AB;
        Tue, 28 Apr 2020 08:17:48 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 0F00080A; Tue, 28 Apr 2020 17:17:42 +0200 (CEST)
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
Subject: [PATCH v3 04/75] x86/cpufeatures: Add SEV-ES CPU feature
Date:   Tue, 28 Apr 2020 17:16:14 +0200
Message-Id: <20200428151725.31091-5-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add CPU feature detection for Secure Encrypted Virtualization with
Encrypted State. This feature enhances SEV by also encrypting the
guest register state, making it in-accessible to the hypervisor.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/amd.c          | 3 ++-
 arch/x86/kernel/cpu/scattered.c    | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index db189945e9b0..ade59fca283a 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -234,6 +234,7 @@
 #define X86_FEATURE_EPT_AD		( 8*32+17) /* Intel Extended Page Table access-dirty bit */
 #define X86_FEATURE_VMCALL		( 8*32+18) /* "" Hypervisor supports the VMCALL instruction */
 #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
+#define X86_FEATURE_SEV_ES		( 8*32+20) /* AMD Secure Encrypted Virtualization - Encrypted State */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 547ad7bbf0e0..6b036291b9b3 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -610,7 +610,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 	 *	      If BIOS has not enabled SME then don't advertise the
 	 *	      SME feature (set in scattered.c).
 	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
-	 *            SEV feature (set in scattered.c).
+	 *            SEV and SEV_ES feature (set in scattered.c).
 	 *
 	 *   In all cases, since support for SME and SEV requires long mode,
 	 *   don't advertise the feature under CONFIG_X86_32.
@@ -641,6 +641,7 @@ static void early_detect_mem_encrypt(struct cpuinfo_x86 *c)
 		setup_clear_cpu_cap(X86_FEATURE_SME);
 clear_sev:
 		setup_clear_cpu_cap(X86_FEATURE_SEV);
+		setup_clear_cpu_cap(X86_FEATURE_SEV_ES);
 	}
 }
 
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 62b137c3c97a..30f354989cf1 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -41,6 +41,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
 	{ X86_FEATURE_SME,		CPUID_EAX,  0, 0x8000001f, 0 },
 	{ X86_FEATURE_SEV,		CPUID_EAX,  1, 0x8000001f, 0 },
+	{ X86_FEATURE_SEV_ES,		CPUID_EAX,  3, 0x8000001f, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
 
-- 
2.17.1

