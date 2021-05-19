Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EE9388F91
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 15:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353824AbhESNyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 09:54:38 -0400
Received: from 8bytes.org ([81.169.241.247]:40204 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353770AbhESNyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 09:54:33 -0400
Received: from cap.home.8bytes.org (p549ad305.dip0.t-ipconnect.de [84.154.211.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id CEA4C4CA;
        Wed, 19 May 2021 15:53:10 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org, Hyunwook Baek <baekhw@google.com>
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
Subject: [PATCH v2 5/8] x86/sev-es: Leave NMI-mode before sending signals
Date:   Wed, 19 May 2021 15:52:48 +0200
Message-Id: <20210519135251.30093-6-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519135251.30093-1-joro@8bytes.org>
References: <20210519135251.30093-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The error path in the runtime #VC handler sends a signal to kill the
current task if the exception was raised from user-space. Some parts of
the #VC handler run in NMI mode, because it is critical that it is not
interrupted (except from an NMI) while the GHCB is in use.

But sending signals in NMI-mode is actually broken and triggers lockdep
warnings. On the other side, when the signal is sent, there is no reason
for the handler to still be in NMI-mode, as the GHCB is not used
anymore.

Leave NMI-mode before entering the error path to get rid of the lockdep
warnings.

Fixes: 62441a1fb532 ("x86/sev-es: Correctly track IRQ states in runtime #VC handler")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 4fd997bbf059..9a64030e74c0 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1343,9 +1343,10 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 		return;
 	}
 
+	instrumentation_begin();
+
 	irq_state = irqentry_nmi_enter(regs);
 	lockdep_assert_irqs_disabled();
-	instrumentation_begin();
 
 	/*
 	 * This is invoked through an interrupt gate, so IRQs are disabled. The
@@ -1395,13 +1396,19 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 		BUG();
 	}
 
-out:
-	instrumentation_end();
 	irqentry_nmi_exit(regs, irq_state);
+	instrumentation_end();
 
 	return;
 
 fail:
+	/*
+	 * Leave NMI mode - the GHCB is not busy anymore and depending on where
+	 * the #VC came from this code is about to either kill the task (when in
+	 * task context) or kill the machine.
+	 */
+	irqentry_nmi_exit(regs, irq_state);
+
 	if (user_mode(regs)) {
 		/*
 		 * Do not kill the machine if user-space triggered the
@@ -1423,7 +1430,9 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 		panic("Returned from Terminate-Request to Hypervisor\n");
 	}
 
-	goto out;
+	instrumentation_end();
+
+	return;
 }
 
 /* This handler runs on the #VC fall-back stack. It can cause further #VC exceptions */
-- 
2.31.1

