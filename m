Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B3C21F06F
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 14:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgGNMMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 08:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728575AbgGNMLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 08:11:18 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AC6C061755;
        Tue, 14 Jul 2020 05:11:18 -0700 (PDT)
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 61DA3FDE;
        Tue, 14 Jul 2020 14:11:08 +0200 (CEST)
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
Subject: [PATCH v4 64/75] x86/paravirt: Allow hypervisor specific VMMCALL handling under SEV-ES
Date:   Tue, 14 Jul 2020 14:09:06 +0200
Message-Id: <20200714120917.11253-65-joro@8bytes.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714120917.11253-1-joro@8bytes.org>
References: <20200714120917.11253-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 6807153c0410..0304e2931cd3 100644
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
 
@@ -236,10 +238,22 @@ struct x86_legacy_features {
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
index b0f08d9669f1..76104c71fc85 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -903,6 +903,9 @@ static enum es_result vc_handle_vmmcall(struct ghcb *ghcb,
 	ghcb_set_rax(ghcb, ctxt->regs->ax);
 	ghcb_set_cpl(ghcb, user_mode(ctxt->regs) ? 3 : 0);
 
+	if (x86_platform.hyper.sev_es_hcall_prepare)
+		x86_platform.hyper.sev_es_hcall_prepare(ghcb, ctxt->regs);
+
 	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_VMMCALL, 0, 0);
 	if (ret != ES_OK)
 		return ret;
@@ -912,6 +915,15 @@ static enum es_result vc_handle_vmmcall(struct ghcb *ghcb,
 
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
2.27.0

