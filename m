Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0545939F307
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 11:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhFHJ4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 05:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbhFHJ4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 05:56:42 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B43EC061787;
        Tue,  8 Jun 2021 02:54:50 -0700 (PDT)
Received: from cap.home.8bytes.org (p4ff2ba7c.dip0.t-ipconnect.de [79.242.186.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 0E26A4CA;
        Tue,  8 Jun 2021 11:54:48 +0200 (CEST)
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
Subject: [PATCH v3 7/7] x86/sev-es: Propagate #GP if getting linear instruction address failed
Date:   Tue,  8 Jun 2021 11:54:39 +0200
Message-Id: <20210608095439.12668-8-joro@8bytes.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608095439.12668-1-joro@8bytes.org>
References: <20210608095439.12668-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

When an instruction is fetched from user-space, segmentation needs to
be taken into account. This means that getting the linear address of
an instruction can fail. Hardware would raise a #GP
exception in that case, but the #VC exception handler would emulate it
as a page-fault.

The insn_fetch_from_user*() functions now provide the relevant
information in case of an failure. Use that and propagate a #GP when
the linear address of an instruction to fetch could not be calculated.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 2b499affb2fb..737d7198aab1 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -270,11 +270,18 @@ static enum es_result __vc_decode_user_insn(struct es_em_ctxt *ctxt)
 	int insn_bytes;
 
 	insn_bytes = insn_fetch_from_user_inatomic(ctxt->regs, buffer);
-	if (insn_bytes <= 0) {
+	if (insn_bytes == 0) {
+		/* Nothing could be copied */
 		ctxt->fi.vector     = X86_TRAP_PF;
 		ctxt->fi.error_code = X86_PF_INSTR | X86_PF_USER;
 		ctxt->fi.cr2        = ctxt->regs->ip;
 		return ES_EXCEPTION;
+	} else if (insn_bytes == -EINVAL) {
+		/* Effective RIP could not be calculated */
+		ctxt->fi.vector     = X86_TRAP_GP;
+		ctxt->fi.error_code = 0;
+		ctxt->fi.cr2        = 0;
+		return ES_EXCEPTION;
 	}
 
 	if (!insn_decode_from_regs(&ctxt->insn, ctxt->regs, buffer, insn_bytes))
-- 
2.31.1

