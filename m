Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDAF1BC2DF
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgD1PST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:18:19 -0400
Received: from 8bytes.org ([81.169.241.247]:37910 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728413AbgD1PSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:18:18 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 6BC3EF42; Tue, 28 Apr 2020 17:17:54 +0200 (CEST)
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
Subject: [PATCH v3 63/75] x86/sev-es: Handle #DB Events
Date:   Tue, 28 Apr 2020 17:17:13 +0200
Message-Id: <20200428151725.31091-64-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Handle #VC exceptions caused by #DB exceptions in the guest. Do not
forward them to the hypervisor and handle them with do_debug() instead.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev-es.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 050a15da9ae5..03095bc7b563 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -882,6 +882,19 @@ static enum es_result vc_handle_trap_ac(struct ghcb *ghcb,
 	return ES_EXCEPTION;
 }
 
+static enum es_result vc_handle_trap_db(struct ghcb *ghcb,
+					struct es_em_ctxt *ctxt)
+{
+	/*
+	 * Calling do_debug() directly does not work, because it might enable
+	 * IRQs and the GHCB is active. Forward the exception and call it later
+	 * from vc_forward_exception().
+	 */
+	ctxt->fi.vector = X86_TRAP_DB;
+	ctxt->fi.error_code = 0;
+	return ES_EXCEPTION;
+}
+
 static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 					 struct ghcb *ghcb,
 					 unsigned long exit_code)
@@ -895,6 +908,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 	case SVM_EXIT_WRITE_DR7:
 		result = vc_handle_dr7_write(ghcb, ctxt);
 		break;
+	case SVM_EXIT_EXCP_BASE + X86_TRAP_DB:
+		result = vc_handle_trap_db(ghcb, ctxt);
+		break;
 	case SVM_EXIT_EXCP_BASE + X86_TRAP_AC:
 		result = vc_handle_trap_ac(ghcb, ctxt);
 		break;
@@ -960,6 +976,9 @@ static void vc_forward_exception(struct es_em_ctxt *ctxt)
 	case X86_TRAP_AC:
 		do_alignment_check(ctxt->regs, error_code);
 		break;
+	case X86_TRAP_DB:
+		do_debug(ctxt->regs, error_code);
+		break;
 	default:
 		pr_emerg("Unsupported exception in #VC instruction emulation - can't continue\n");
 		BUG();
-- 
2.17.1

