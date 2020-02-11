Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDF91590C6
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729770AbgBKNyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:54:38 -0500
Received: from 8bytes.org ([81.169.241.247]:52426 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729594AbgBKNx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:29 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id ACA7DEA0; Tue, 11 Feb 2020 14:53:16 +0100 (CET)
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
Subject: [PATCH 53/62] x86/paravirt: Allow hypervisor specific VMMCALL handling under SEV-ES
Date:   Tue, 11 Feb 2020 14:52:47 +0100
Message-Id: <20200211135256.24617-54-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Add two new paravirt callbacks to provide hypervisor specific processor
state in the GHCB and to copy state from the hypervisor back to the
processor.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/x86_init.h | 16 +++++++++++++++-
 arch/x86/kernel/sev-es.c        | 12 ++++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 96d9cd208610..c4790ec279cc 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -4,8 +4,10 @@
 
 #include <asm/bootparam.h>
 
+struct ghcb;
 struct mpc_bus;
 struct mpc_cpu;
+struct pt_regs;
 struct mpc_table;
 struct cpuinfo_x86;
 
@@ -238,10 +240,22 @@ struct x86_legacy_features {
 /**
  * struct x86_hyper_runtime - x86 hypervisor specific runtime callbacks
  *
- * @pin_vcpu:		pin current vcpu to specified physical cpu (run rarely)
+ * @pin_vcpu:			pin current vcpu to specified physical
+ *				cpu (run rarely)
+ * @sev_es_hcall_prepare:	Load additional hypervisor-specific
+ *				state into the GHCB when doing a VMMCALL under
+ *				SEV-ES. Called from the #VC exception handler.
+ * @sev_es_hcall_finish:	Copies state from the GHCB back into the
+ *				processor (or pt_regs). Also runs checks on the
+ *				state returned from the hypervisor after a
+ *				VMMCALL under SEV-ES.  Needs to return 'false'
+ *				if the checks fail.  Called from the #VC
+ *				exception handler.
  */
 struct x86_hyper_runtime {
 	void (*pin_vcpu)(int cpu);
+	void (*sev_es_hcall_prepare)(struct ghcb *ghcb, struct pt_regs *regs);
+	bool (*sev_es_hcall_finish)(struct ghcb *ghcb, struct pt_regs *regs);
 };
 
 /**
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 700f75fc13e7..6924bb1ad8b2 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -349,6 +349,9 @@ static enum es_result handle_vmmcall(struct ghcb *ghcb,
 	ghcb_set_rax(ghcb, ctxt->regs->ax);
 	ghcb_set_cpl(ghcb, user_mode(ctxt->regs) ? 3 : 0);
 
+	if (x86_platform.hyper.sev_es_hcall_prepare)
+		x86_platform.hyper.sev_es_hcall_prepare(ghcb, ctxt->regs);
+
 	ret = ghcb_hv_call(ghcb, ctxt, SVM_EXIT_VMMCALL, 0, 0);
 	if (ret != ES_OK)
 		return ret;
@@ -358,6 +361,15 @@ static enum es_result handle_vmmcall(struct ghcb *ghcb,
 
 	ctxt->regs->ax = ghcb->save.rax;
 
+	/*
+	 * Call sev_es_hcall_finish() after regs->ax is already set.
+	 * This allows the hypervisor handler to overwrite it again if
+	 * necessary.
+	 */
+	if (x86_platform.hyper.sev_es_hcall_finish &&
+	    !x86_platform.hyper.sev_es_hcall_finish(ghcb, ctxt->regs))
+		return ES_VMM_ERROR;
+
 	return ES_OK;
 }
 
-- 
2.17.1

