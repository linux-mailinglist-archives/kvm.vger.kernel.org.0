Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1173A6873
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 15:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbhFNNzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 09:55:48 -0400
Received: from 8bytes.org ([81.169.241.247]:44526 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233180AbhFNNzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 09:55:47 -0400
Received: from cap.home.8bytes.org (p4ff2ba7c.dip0.t-ipconnect.de [79.242.186.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id ED05B4B7;
        Mon, 14 Jun 2021 15:53:42 +0200 (CEST)
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
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH v5 2/6] x86/sev-es: Make sure IRQs are disabled while GHCB is active
Date:   Mon, 14 Jun 2021 15:53:23 +0200
Message-Id: <20210614135327.9921-3-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614135327.9921-1-joro@8bytes.org>
References: <20210614135327.9921-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The #VC handler only cares about IRQs being disabled while the GHCB is
active, as it must not be interrupted by something which could cause
another #VC while it holds the GHCB (NMI is the exception for which the
backup GHCB exits).

Make sure nothing interrupts the code path while the GHCB is active by
disabling IRQs in sev_es_get_ghcb() and restoring the previous irq state
in sev_es_put_ghcb().

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev.c | 48 ++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 4fd997bbf059..f1bd95d451c3 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -192,7 +192,7 @@ void noinstr __sev_es_ist_exit(void)
 	this_cpu_write(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC], *(unsigned long *)ist);
 }
 
-static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
+static __always_inline struct ghcb *__sev_es_get_ghcb(struct ghcb_state *state)
 {
 	struct sev_es_runtime_data *data;
 	struct ghcb *ghcb;
@@ -231,6 +231,18 @@ static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
 	return ghcb;
 }
 
+static __always_inline struct ghcb *sev_es_get_ghcb(struct ghcb_state *state,
+						    unsigned long *flags)
+{
+	/*
+	 * Nothing shall interrupt this code path while holding the per-cpu
+	 * GHCB. The backup GHCB is only for NMIs interrupting this path.
+	 */
+	local_irq_save(*flags);
+
+	return __sev_es_get_ghcb(state);
+}
+
 /* Needed in vc_early_forward_exception */
 void do_early_exception(struct pt_regs *regs, int trapnr);
 
@@ -479,7 +491,7 @@ static enum es_result vc_slow_virt_to_phys(struct ghcb *ghcb, struct es_em_ctxt
 /* Include code shared with pre-decompression boot stage */
 #include "sev-shared.c"
 
-static __always_inline void sev_es_put_ghcb(struct ghcb_state *state)
+static __always_inline void __sev_es_put_ghcb(struct ghcb_state *state)
 {
 	struct sev_es_runtime_data *data;
 	struct ghcb *ghcb;
@@ -502,12 +514,21 @@ static __always_inline void sev_es_put_ghcb(struct ghcb_state *state)
 	}
 }
 
+static __always_inline void sev_es_put_ghcb(struct ghcb_state *state,
+					    unsigned long flags)
+{
+	__sev_es_put_ghcb(state);
+	local_irq_restore(flags);
+}
+
 void noinstr __sev_es_nmi_complete(void)
 {
 	struct ghcb_state state;
 	struct ghcb *ghcb;
 
-	ghcb = sev_es_get_ghcb(&state);
+	BUG_ON(!irqs_disabled());
+
+	ghcb = __sev_es_get_ghcb(&state);
 
 	vc_ghcb_invalidate(ghcb);
 	ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_NMI_COMPLETE);
@@ -517,7 +538,7 @@ void noinstr __sev_es_nmi_complete(void)
 	sev_es_wr_ghcb_msr(__pa_nodebug(ghcb));
 	VMGEXIT();
 
-	sev_es_put_ghcb(&state);
+	__sev_es_put_ghcb(&state);
 }
 
 static u64 get_jump_table_addr(void)
@@ -527,9 +548,7 @@ static u64 get_jump_table_addr(void)
 	struct ghcb *ghcb;
 	u64 ret = 0;
 
-	local_irq_save(flags);
-
-	ghcb = sev_es_get_ghcb(&state);
+	ghcb = sev_es_get_ghcb(&state, &flags);
 
 	vc_ghcb_invalidate(ghcb);
 	ghcb_set_sw_exit_code(ghcb, SVM_VMGEXIT_AP_JUMP_TABLE);
@@ -543,9 +562,7 @@ static u64 get_jump_table_addr(void)
 	    ghcb_sw_exit_info_2_is_valid(ghcb))
 		ret = ghcb->save.sw_exit_info_2;
 
-	sev_es_put_ghcb(&state);
-
-	local_irq_restore(flags);
+	sev_es_put_ghcb(&state, flags);
 
 	return ret;
 }
@@ -666,9 +683,10 @@ static bool __init sev_es_setup_ghcb(void)
 static void sev_es_ap_hlt_loop(void)
 {
 	struct ghcb_state state;
+	unsigned long flags;
 	struct ghcb *ghcb;
 
-	ghcb = sev_es_get_ghcb(&state);
+	ghcb = sev_es_get_ghcb(&state, &flags);
 
 	while (true) {
 		vc_ghcb_invalidate(ghcb);
@@ -685,7 +703,7 @@ static void sev_es_ap_hlt_loop(void)
 			break;
 	}
 
-	sev_es_put_ghcb(&state);
+	sev_es_put_ghcb(&state, flags);
 }
 
 /*
@@ -1335,6 +1353,8 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 	enum es_result result;
 	struct ghcb *ghcb;
 
+	BUG_ON(!irqs_disabled());
+
 	/*
 	 * Handle #DB before calling into !noinstr code to avoid recursive #DB.
 	 */
@@ -1353,7 +1373,7 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 	 * keep the IRQs disabled to protect us against concurrent TLB flushes.
 	 */
 
-	ghcb = sev_es_get_ghcb(&state);
+	ghcb = __sev_es_get_ghcb(&state);
 
 	vc_ghcb_invalidate(ghcb);
 	result = vc_init_em_ctxt(&ctxt, regs, error_code);
@@ -1361,7 +1381,7 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 	if (result == ES_OK)
 		result = vc_handle_exitcode(&ctxt, ghcb, error_code);
 
-	sev_es_put_ghcb(&state);
+	__sev_es_put_ghcb(&state);
 
 	/* Done - now check the result */
 	switch (result) {
-- 
2.31.1

