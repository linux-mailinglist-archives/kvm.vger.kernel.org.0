Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDEB332C65C
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346166AbhCDA2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347727AbhCCOSg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 09:18:36 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3016AC061793;
        Wed,  3 Mar 2021 06:17:28 -0800 (PST)
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id DD0A1451;
        Wed,  3 Mar 2021 15:17:23 +0100 (CET)
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
Subject: [PATCH 3/5] x86/sev-es: Optimize __sev_es_ist_enter() for better readability
Date:   Wed,  3 Mar 2021 15:17:14 +0100
Message-Id: <20210303141716.29223-4-joro@8bytes.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210303141716.29223-1-joro@8bytes.org>
References: <20210303141716.29223-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Reorganize the code and improve the comments to make the function more
readable and easier to understand.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev-es.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 28b0144daddd..e1eeb3ef58c5 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -137,29 +137,41 @@ static __always_inline bool on_vc_stack(struct pt_regs *regs)
 }
 
 /*
- * This function handles the case when an NMI is raised in the #VC exception
- * handler entry code. In this case, the IST entry for #VC must be adjusted, so
- * that any subsequent #VC exception will not overwrite the stack contents of the
- * interrupted #VC handler.
+ * This function handles the case when an NMI is raised in the #VC
+ * exception handler entry code, before the #VC handler has switched off
+ * its IST stack. In this case, the IST entry for #VC must be adjusted,
+ * so that any nested #VC exception will not overwrite the stack
+ * contents of the interrupted #VC handler.
  *
  * The IST entry is adjusted unconditionally so that it can be also be
- * unconditionally adjusted back in sev_es_ist_exit(). Otherwise a nested
- * sev_es_ist_exit() call may adjust back the IST entry too early.
+ * unconditionally adjusted back in __sev_es_ist_exit(). Otherwise a
+ * nested sev_es_ist_exit() call may adjust back the IST entry too
+ * early.
+ *
+ * The __sev_es_ist_enter() and __sev_es_ist_exit() functions always run
+ * on the NMI IST stack, as they are only called from NMI handling code
+ * right now.
  */
 void noinstr __sev_es_ist_enter(struct pt_regs *regs)
 {
 	unsigned long old_ist, new_ist;
 
 	/* Read old IST entry */
-	old_ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
+	new_ist = old_ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
 
-	/* Make room on the IST stack */
+	/*
+	 * If NMI happened while on the #VC IST stack, set the new IST
+	 * value below regs->sp, so that the interrupted stack frame is
+	 * not overwritten by subsequent #VC exceptions.
+	 */
 	if (on_vc_stack(regs))
-		new_ist = ALIGN_DOWN(regs->sp, 8) - sizeof(old_ist);
-	else
-		new_ist = old_ist - sizeof(old_ist);
+		new_ist = regs->sp;
 
-	/* Store old IST entry */
+	/*
+	 * Reserve additional 8 bytes and store old IST value so this
+	 * adjustment can be unrolled in __sev_es_ist_exit().
+	 */
+	new_ist -= sizeof(old_ist);
 	*(unsigned long *)new_ist = old_ist;
 
 	/* Set new IST entry */
-- 
2.30.1

