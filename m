Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6B6D1590D9
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbgBKNzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:55:48 -0500
Received: from 8bytes.org ([81.169.241.247]:52450 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729572AbgBKNx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:27 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 4B695E90; Tue, 11 Feb 2020 14:53:15 +0100 (CET)
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
Subject: [PATCH 45/62] x86/sev-es: Handle RDPMC Events
Date:   Tue, 11 Feb 2020 14:52:39 +0100
Message-Id: <20200211135256.24617-46-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Implement a handler for #VC exceptions caused by RDPMC instructions.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[ jroedel@suse.de: Adapt to #VC handling infrastructure ]
Co-developed-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev-es.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 061557515f75..e96332516c2a 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -289,6 +289,25 @@ static enum es_result handle_rdtsc(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ES_OK;
 }
 
+static enum es_result handle_rdpmc(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+{
+	enum es_result ret;
+
+	ghcb_set_rcx(ghcb, ctxt->regs->cx);
+
+	ret = ghcb_hv_call(ghcb, ctxt, SVM_EXIT_RDPMC, 0, 0);
+	if (ret != ES_OK)
+		return ret;
+
+	if (!(ghcb_is_valid_rax(ghcb) && ghcb_is_valid_rdx(ghcb)))
+		return ES_VMM_ERROR;
+
+	ctxt->regs->ax = ghcb->save.rax;
+	ctxt->regs->dx = ghcb->save.rdx;
+
+	return ES_OK;
+}
+
 static enum es_result handle_vc_exception(struct es_em_ctxt *ctxt,
 					  struct ghcb *ghcb,
 					  unsigned long exit_code,
@@ -306,6 +325,9 @@ static enum es_result handle_vc_exception(struct es_em_ctxt *ctxt,
 	case SVM_EXIT_RDTSC:
 		result = handle_rdtsc(ghcb, ctxt);
 		break;
+	case SVM_EXIT_RDPMC:
+		result = handle_rdpmc(ghcb, ctxt);
+		break;
 	case SVM_EXIT_CPUID:
 		result = handle_cpuid(ghcb, ctxt);
 		break;
-- 
2.17.1

