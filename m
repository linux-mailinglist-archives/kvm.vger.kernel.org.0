Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 328801590CA
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgBKNzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:55:06 -0500
Received: from 8bytes.org ([81.169.241.247]:51838 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729582AbgBKNx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:28 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id C936BE95; Tue, 11 Feb 2020 14:53:15 +0100 (CET)
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
Subject: [PATCH 48/62] x86/sev-es: Handle MONITOR/MONITORX Events
Date:   Tue, 11 Feb 2020 14:52:42 +0100
Message-Id: <20200211135256.24617-49-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Implement a handler for #VC exceptions caused by MONITOR and MONITORX
instructions.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[ jroedel@suse.de: Adapt to #VC handling infrastructure ]
Co-developed-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev-es.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index d5a14f277adb..865f510d11ba 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -318,6 +318,21 @@ static enum es_result handle_invd(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	return ghcb_hv_call(ghcb, ctxt, SVM_EXIT_INVD, 0, 0);
 }
 
+static enum es_result handle_monitor(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+{
+	phys_addr_t monitor_pa;
+	pgd_t *pgd;
+
+	pgd = __va(read_cr3_pa());
+	monitor_pa = es_slow_virt_to_phys(ghcb, ctxt->regs->ax);
+
+	ghcb_set_rax(ghcb, monitor_pa);
+	ghcb_set_rcx(ghcb, ctxt->regs->cx);
+	ghcb_set_rdx(ghcb, ctxt->regs->dx);
+
+	return ghcb_hv_call(ghcb, ctxt, SVM_EXIT_MONITOR, 0, 0);
+}
+
 static enum es_result handle_vc_exception(struct es_em_ctxt *ctxt,
 					  struct ghcb *ghcb,
 					  unsigned long exit_code,
@@ -354,6 +369,9 @@ static enum es_result handle_vc_exception(struct es_em_ctxt *ctxt,
 	case SVM_EXIT_WBINVD:
 		result = handle_wbinvd(ghcb, ctxt);
 		break;
+	case SVM_EXIT_MONITOR:
+		result = handle_monitor(ghcb, ctxt);
+		break;
 	case SVM_EXIT_NPF:
 		result = handle_mmio(ghcb, ctxt);
 		break;
-- 
2.17.1

