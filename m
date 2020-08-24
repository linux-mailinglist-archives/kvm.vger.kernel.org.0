Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6882C24F789
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 11:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgHXJPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 05:15:38 -0400
Received: from 8bytes.org ([81.169.241.247]:37380 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730417AbgHXI4C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 04:56:02 -0400
Received: from cap.home.8bytes.org (p4ff2bb8d.dip0.t-ipconnect.de [79.242.187.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id ABCE1E50;
        Mon, 24 Aug 2020 10:56:00 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
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
Subject: [PATCH v6 27/76] x86/sev-es: Add CPUID handling to #VC handler
Date:   Mon, 24 Aug 2020 10:54:22 +0200
Message-Id: <20200824085511.7553-28-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824085511.7553-1-joro@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Link: https://lore.kernel.org/r/20200724160336.5435-27-joro@8bytes.org
---
 arch/x86/boot/compressed/sev-es.c |  4 ++++
 arch/x86/kernel/sev-es-shared.c   | 35 +++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
index 4f2fc7a85c2f..851d7af29d79 100644
--- a/arch/x86/boot/compressed/sev-es.c
+++ b/arch/x86/boot/compressed/sev-es.c
@@ -16,6 +16,7 @@
 #include <asm/trapnr.h>
 #include <asm/trap_pf.h>
 #include <asm/msr-index.h>
+#include <asm/fpu/xcr.h>
 #include <asm/ptrace.h>
 #include <asm/svm.h>
 
@@ -183,6 +184,9 @@ void do_boot_stage2_vc(struct pt_regs *regs, unsigned long exit_code)
 	case SVM_EXIT_IOIO:
 		result = vc_handle_ioio(boot_ghcb, &ctxt);
 		break;
+	case SVM_EXIT_CPUID:
+		result = vc_handle_cpuid(boot_ghcb, &ctxt);
+		break;
 	default:
 		result = ES_UNSUPPORTED;
 		break;
diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
index bae7cf28455b..a6b41910b8ab 100644
--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -432,3 +432,38 @@ static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 
 	return ret;
 }
+
+static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
+				      struct es_em_ctxt *ctxt)
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
+	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
+	if (ret != ES_OK)
+		return ret;
+
+	if (!(ghcb_rax_is_valid(ghcb) &&
+	      ghcb_rbx_is_valid(ghcb) &&
+	      ghcb_rcx_is_valid(ghcb) &&
+	      ghcb_rdx_is_valid(ghcb)))
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
2.28.0

