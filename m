Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69FCF159100
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgBKNxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:53:23 -0500
Received: from 8bytes.org ([81.169.241.247]:52198 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729504AbgBKNxW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:22 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id D2D04DF5; Tue, 11 Feb 2020 14:53:10 +0100 (CET)
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
Subject: [PATCH 21/62] x86/sev-es: Add CPUID handling to #VC handler
Date:   Tue, 11 Feb 2020 14:52:15 +0100
Message-Id: <20200211135256.24617-22-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Handle #VC exceptions caused by CPUID instructions. These happen in
early boot code when the KASLR code checks for RDTSC.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[ jroedel@suse.de: Adapt to #VC handling framework ]
Co-developed-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/sev-es.c |  4 ++++
 arch/x86/kernel/sev-es-shared.c   | 34 +++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
index b2a2d068dc12..270a23c05f53 100644
--- a/arch/x86/boot/compressed/sev-es.c
+++ b/arch/x86/boot/compressed/sev-es.c
@@ -10,6 +10,7 @@
 #include <asm/sev-es.h>
 #include <asm/trap_defs.h>
 #include <asm/msr-index.h>
+#include <asm/fpu/xcr.h>
 #include <asm/ptrace.h>
 #include <asm/svm.h>
 
@@ -117,6 +118,9 @@ void boot_vc_handler(struct pt_regs *regs)
 	case SVM_EXIT_IOIO:
 		result = handle_ioio(boot_ghcb, &ctxt);
 		break;
+	case SVM_EXIT_CPUID:
+		result = handle_cpuid(boot_ghcb, &ctxt);
+		break;
 	default:
 		result = ES_UNSUPPORTED;
 		break;
diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
index bd21a79da084..0f422e3b2077 100644
--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -449,3 +449,37 @@ static enum es_result handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 
 	return ret;
 }
+
+static enum es_result handle_cpuid(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+{
+	struct pt_regs *regs = ctxt->regs;
+	u32 cr4 = native_read_cr4();
+	enum es_result ret;
+
+	ghcb_set_rax(ghcb, regs->ax);
+	ghcb_set_rcx(ghcb, regs->cx);
+
+	if (cr4 & X86_CR4_OSXSAVE)
+		/* Safe to read xcr0 */
+		ghcb_set_xcr0(ghcb, xgetbv(XCR_XFEATURE_ENABLED_MASK));
+	else
+		/* xgetbv will cause #GP - use reset value for xcr0 */
+		ghcb_set_xcr0(ghcb, 1);
+
+	ret = ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
+	if (ret != ES_OK)
+		return ret;
+
+	if (!(ghcb_is_valid_rax(ghcb) &&
+	      ghcb_is_valid_rbx(ghcb) &&
+	      ghcb_is_valid_rcx(ghcb) &&
+	      ghcb_is_valid_rdx(ghcb)))
+		return ES_VMM_ERROR;
+
+	regs->ax = ghcb->save.rax;
+	regs->bx = ghcb->save.rbx;
+	regs->cx = ghcb->save.rcx;
+	regs->dx = ghcb->save.rdx;
+
+	return ES_OK;
+}
-- 
2.17.1

