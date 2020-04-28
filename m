Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4961BC301
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgD1PSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:18:13 -0400
Received: from 8bytes.org ([81.169.241.247]:37910 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728348AbgD1PSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:18:12 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 4762EF2F; Tue, 28 Apr 2020 17:17:51 +0200 (CEST)
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
Subject: [PATCH v3 48/75] x86/sev-es: Wire up existing #VC exit-code handlers
Date:   Tue, 28 Apr 2020 17:16:58 +0200
Message-Id: <20200428151725.31091-49-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Re-use the handlers for CPUID and IOIO caused #VC exceptions in the
early boot handler.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev-es-shared.c | 7 +++----
 arch/x86/kernel/sev-es.c        | 6 ++++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
index 3d2299fb5e3f..3d645662ff10 100644
--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -324,8 +324,7 @@ static enum es_result vc_ioio_exitinfo(struct es_em_ctxt *ctxt, u64 *exitinfo)
 	return ES_OK;
 }
 
-static enum es_result __maybe_unused
-vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+static enum es_result vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 {
 	struct pt_regs *regs = ctxt->regs;
 	u64 exit_info_1, exit_info_2;
@@ -421,8 +420,8 @@ vc_handle_ioio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ret;
 }
 
-static enum es_result __maybe_unused vc_handle_cpuid(struct ghcb *ghcb,
-						     struct es_em_ctxt *ctxt)
+static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
+				      struct es_em_ctxt *ctxt)
 {
 	struct pt_regs *regs = ctxt->regs;
 	u32 cr4 = native_read_cr4();
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index bc3a58427028..85027fb4177e 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -424,6 +424,12 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 	enum es_result result;
 
 	switch (exit_code) {
+	case SVM_EXIT_CPUID:
+		result = vc_handle_cpuid(ghcb, ctxt);
+		break;
+	case SVM_EXIT_IOIO:
+		result = vc_handle_ioio(ghcb, ctxt);
+		break;
 	default:
 		/*
 		 * Unexpected #VC exception
-- 
2.17.1

