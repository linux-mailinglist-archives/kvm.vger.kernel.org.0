Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAC218AF58
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbgCSJOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:14:47 -0400
Received: from 8bytes.org ([81.169.241.247]:51922 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727493AbgCSJOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:46 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id CD01EECC; Thu, 19 Mar 2020 10:14:27 +0100 (CET)
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 62/70] x86/kvm: Add KVM specific VMMCALL handling under SEV-ES
Date:   Thu, 19 Mar 2020 10:13:59 +0100
Message-Id: <20200319091407.1481-63-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319091407.1481-1-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Implement the callbacks to copy the processor state required by KVM to
the GHCB.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[ jroedel@suse.de: - Split out of a larger patch
                   - Adapt to different callback functions ]
Co-developed-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/kvm.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6efe0410fb72..0e3fc798d719 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -34,6 +34,8 @@
 #include <asm/hypervisor.h>
 #include <asm/tlb.h>
 #include <asm/cpuidle_haltpoll.h>
+#include <asm/ptrace.h>
+#include <asm/svm.h>
 
 static int kvmapf = 1;
 
@@ -729,13 +731,34 @@ static void __init kvm_init_platform(void)
 	x86_platform.apic_post_init = kvm_apic_init;
 }
 
+#if defined(CONFIG_AMD_MEM_ENCRYPT)
+static void kvm_sev_es_hcall_prepare(struct ghcb *ghcb, struct pt_regs *regs)
+{
+	/* RAX and CPL are already in the GHCB */
+	ghcb_set_rbx(ghcb, regs->bx);
+	ghcb_set_rcx(ghcb, regs->cx);
+	ghcb_set_rdx(ghcb, regs->dx);
+	ghcb_set_rsi(ghcb, regs->si);
+}
+
+static bool kvm_sev_es_hcall_finish(struct ghcb *ghcb, struct pt_regs *regs)
+{
+	/* No checking of the return state needed */
+	return true;
+}
+#endif
+
 const __initconst struct hypervisor_x86 x86_hyper_kvm = {
-	.name			= "KVM",
-	.detect			= kvm_detect,
-	.type			= X86_HYPER_KVM,
-	.init.guest_late_init	= kvm_guest_init,
-	.init.x2apic_available	= kvm_para_available,
-	.init.init_platform	= kvm_init_platform,
+	.name				= "KVM",
+	.detect				= kvm_detect,
+	.type				= X86_HYPER_KVM,
+	.init.guest_late_init		= kvm_guest_init,
+	.init.x2apic_available		= kvm_para_available,
+	.init.init_platform		= kvm_init_platform,
+#if defined(CONFIG_AMD_MEM_ENCRYPT)
+	.runtime.sev_es_hcall_prepare	= kvm_sev_es_hcall_prepare,
+	.runtime.sev_es_hcall_finish	= kvm_sev_es_hcall_finish,
+#endif
 };
 
 static __init int activate_jump_labels(void)
-- 
2.17.1

