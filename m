Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D66DE159090
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgBKNx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:53:27 -0500
Received: from 8bytes.org ([81.169.241.247]:52306 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729551AbgBKNx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:26 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 5E10CE85; Tue, 11 Feb 2020 14:53:14 +0100 (CET)
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
Subject: [PATCH 40/62] x86/sev-es: Filter exceptions not supported from user-space
Date:   Tue, 11 Feb 2020 14:52:34 +0100
Message-Id: <20200211135256.24617-41-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Currently only CPUID caused #VC exceptions are supported from
user-space. Filter the others out early.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev-es.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index d128a9397639..84b5b8f7897a 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -209,6 +209,26 @@ static enum es_result handle_vc_exception(struct es_em_ctxt *ctxt,
 	return result;
 }
 
+static enum es_result context_filter(struct pt_regs *regs, long exit_code)
+{
+	enum es_result r = ES_OK;
+
+	if (user_mode(regs)) {
+		switch (exit_code) {
+		/* List of #VC exit-codes we support in user-space */
+		case SVM_EXIT_EXCP_BASE ... SVM_EXIT_LAST_EXCP:
+		case SVM_EXIT_CPUID:
+			r = ES_OK;
+			break;
+		default:
+			r = ES_UNSUPPORTED;
+			break;
+		}
+	}
+
+	return r;
+}
+
 static void forward_exception(struct es_em_ctxt *ctxt)
 {
 	long error_code = ctxt->fi.error_code;
@@ -245,6 +265,10 @@ dotraplinkage void do_vmm_communication(struct pt_regs *regs, unsigned long exit
 	ghcb_invalidate(ghcb);
 	result = init_em_ctxt(&ctxt, regs, exit_code);
 
+	/* Check if the exception is supported in the context we came from. */
+	if (result == ES_OK)
+		result = context_filter(regs, exit_code);
+
 	if (result == ES_OK)
 		result = handle_vc_exception(&ctxt, ghcb, exit_code);
 
-- 
2.17.1

