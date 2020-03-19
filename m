Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD9FF18AF7D
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgCSJRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:17:13 -0400
Received: from 8bytes.org ([81.169.241.247]:52420 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbgCSJOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:39 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 351FD982; Thu, 19 Mar 2020 10:14:24 +0100 (CET)
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
Subject: [PATCH 42/70] x86/sev-es: Support nested #VC exceptions
Date:   Thu, 19 Mar 2020 10:13:39 +0100
Message-Id: <20200319091407.1481-43-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319091407.1481-1-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Handle #VC exceptions that happen while the GHCB is in use. This can
happen when an NMI happens in the #VC exception handler and the NMI
handler causes a #VC exception itself. Save the contents of the GHCB
when nesting is detected and restore it when the GHCB is no longer
used.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev-es.c | 63 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 97241d2f0f70..3b7bbc8d841e 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -32,9 +32,57 @@ struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
  */
 struct ghcb __initdata *boot_ghcb;
 
+struct ghcb_state {
+	struct ghcb *ghcb;
+};
+
 /* Runtime GHCB pointers */
 static struct ghcb __percpu *ghcb_page;
 
+/*
+ * Mark the per-cpu GHCB as in-use to detect nested #VC exceptions.
+ * There is no need for it to be atomic, because nothing is written to the GHCB
+ * between the read and the write of ghcb_active. So it is safe to use it when a
+ * nested #VC exception happens before the write.
+ */
+static DEFINE_PER_CPU(bool, ghcb_active);
+
+static struct ghcb *sev_es_get_ghcb(struct ghcb_state *state)
+{
+	struct ghcb *ghcb = (struct ghcb *)this_cpu_ptr(ghcb_page);
+	bool *active = this_cpu_ptr(&ghcb_active);
+
+	if (unlikely(*active)) {
+		/* GHCB is already in use - save its contents */
+
+		state->ghcb = kzalloc(sizeof(struct ghcb), GFP_ATOMIC);
+		if (!state->ghcb)
+			return NULL;
+
+		*state->ghcb = *ghcb;
+	} else {
+		state->ghcb = NULL;
+		*active = true;
+	}
+
+	return ghcb;
+}
+
+static void sev_es_put_ghcb(struct ghcb_state *state)
+{
+	bool *active = this_cpu_ptr(&ghcb_active);
+	struct ghcb *ghcb = (struct ghcb *)this_cpu_ptr(ghcb_page);
+
+	if (state->ghcb) {
+		/* Restore saved state and free backup memory */
+		*ghcb = *state->ghcb;
+		kfree(state->ghcb);
+		state->ghcb = NULL;
+	} else {
+		*active = false;
+	}
+}
+
 /* Needed in vc_early_vc_forward_exception */
 extern void early_exception(struct pt_regs *regs, int trapnr);
 
@@ -272,6 +320,7 @@ static void vc_forward_exception(struct es_em_ctxt *ctxt)
 
 dotraplinkage void do_vmm_communication(struct pt_regs *regs, unsigned long exit_code)
 {
+	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
 	enum es_result result;
 	struct ghcb *ghcb;
@@ -282,14 +331,20 @@ dotraplinkage void do_vmm_communication(struct pt_regs *regs, unsigned long exit
 	 * keep the IRQs disabled to protect us against concurrent TLB flushes.
 	 */
 
-	ghcb = (struct ghcb *)this_cpu_ptr(ghcb_page);
-
-	vc_ghcb_invalidate(ghcb);
-	result = vc_init_em_ctxt(&ctxt, regs, exit_code);
+	ghcb = sev_es_get_ghcb(&state);
+	if (!ghcb) {
+		/* This can only fail on an allocation error, so just retry */
+		result = ES_RETRY;
+	} else {
+		vc_ghcb_invalidate(ghcb);
+		result = vc_init_em_ctxt(&ctxt, regs, exit_code);
+	}
 
 	if (result == ES_OK)
 		result = vc_handle_exitcode(&ctxt, ghcb, exit_code);
 
+	sev_es_put_ghcb(&state);
+
 	/* Done - now check the result */
 	switch (result) {
 	case ES_OK:
-- 
2.17.1

