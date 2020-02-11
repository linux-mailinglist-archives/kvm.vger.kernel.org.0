Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D189D1590AA
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbgBKNx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:53:28 -0500
Received: from 8bytes.org ([81.169.241.247]:52278 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729553AbgBKNx0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:26 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 86E79E7E; Tue, 11 Feb 2020 14:53:14 +0100 (CET)
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
Subject: [PATCH 41/62] x86/sev-es: Handle MSR events
Date:   Tue, 11 Feb 2020 14:52:35 +0100
Message-Id: <20200211135256.24617-42-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Implement a handler for #VC exceptions caused by RDMSR/WRMSR
instructions.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[ jroedel@suse.de: Adapt to #VC handling infrastructure ]
Co-developed-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev-es.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 84b5b8f7897a..b27d5b0a8ae1 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -134,6 +134,35 @@ static phys_addr_t es_slow_virt_to_phys(struct ghcb *ghcb, long vaddr)
 /* Include code shared with pre-decompression boot stage */
 #include "sev-es-shared.c"
 
+static enum es_result handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
+{
+	struct pt_regs *regs = ctxt->regs;
+	enum es_result ret;
+	bool write;
+	u64 exit_info_1;
+
+	write = (ctxt->insn.opcode.bytes[1] == 0x30);
+
+	ghcb_set_rcx(ghcb, regs->cx);
+	if (write) {
+		ghcb_set_rax(ghcb, regs->ax);
+		ghcb_set_rdx(ghcb, regs->dx);
+		exit_info_1 = 1;
+	} else {
+		exit_info_1 = 0;
+	}
+
+	ret = ghcb_hv_call(ghcb, ctxt, SVM_EXIT_MSR, exit_info_1, 0);
+	if (ret != ES_OK)
+		return ret;
+	else if (!write) {
+		regs->ax = ghcb->save.rax;
+		regs->dx = ghcb->save.rdx;
+	}
+
+	return ret;
+}
+
 /*
  * This function runs on the first #VC exception after the kernel
  * switched to virtual addresses.
@@ -196,6 +225,9 @@ static enum es_result handle_vc_exception(struct es_em_ctxt *ctxt,
 	case SVM_EXIT_IOIO:
 		result = handle_ioio(ghcb, ctxt);
 		break;
+	case SVM_EXIT_MSR:
+		result = handle_msr(ghcb, ctxt);
+		break;
 	case SVM_EXIT_NPF:
 		result = handle_mmio(ghcb, ctxt);
 		break;
-- 
2.17.1

