Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A32118AF6F
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbgCSJQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:16:30 -0400
Received: from 8bytes.org ([81.169.241.247]:51922 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbgCSJOo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:44 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 95E19E97; Thu, 19 Mar 2020 10:14:26 +0100 (CET)
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
Subject: [PATCH 55/70] x86/sev-es: Handle RDTSCP Events
Date:   Thu, 19 Mar 2020 10:13:52 +0100
Message-Id: <20200319091407.1481-56-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319091407.1481-1-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Extend the RDTSC handler to also handle RDTSCP events.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev-es.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index a4f136b2e149..11947b648b43 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -665,19 +665,25 @@ static enum es_result vc_handle_wbinvd(struct ghcb *ghcb,
 	return sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_WBINVD, 0, 0);
 }
 
-static enum es_result vc_handle_rdtsc(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
+				      struct es_em_ctxt *ctxt,
+				      unsigned long exit_code)
 {
+	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
 	enum es_result ret;
 
-	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_RDTSC, 0, 0);
+	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
 	if (ret != ES_OK)
 		return ret;
 
-	if (!(ghcb_is_valid_rax(ghcb) && ghcb_is_valid_rdx(ghcb)))
+	if (!(ghcb_is_valid_rax(ghcb) && ghcb_is_valid_rdx(ghcb) &&
+	     (!rdtscp || ghcb_is_valid_rcx(ghcb))))
 		return ES_VMM_ERROR;
 
 	ctxt->regs->ax = ghcb->save.rax;
 	ctxt->regs->dx = ghcb->save.rdx;
+	if (rdtscp)
+		ctxt->regs->cx = ghcb->save.rcx;
 
 	return ES_OK;
 }
@@ -716,7 +722,8 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 		result = vc_handle_dr7_write(ghcb, ctxt, early);
 		break;
 	case SVM_EXIT_RDTSC:
-		result = vc_handle_rdtsc(ghcb, ctxt);
+	case SVM_EXIT_RDTSCP:
+		result = vc_handle_rdtsc(ghcb, ctxt, exit_code);
 		break;
 	case SVM_EXIT_RDPMC:
 		result = vc_handle_rdpmc(ghcb, ctxt);
-- 
2.17.1

