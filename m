Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A61B41590C7
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbgBKNyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:54:39 -0500
Received: from 8bytes.org ([81.169.241.247]:52240 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729591AbgBKNx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:29 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 5B2BDE9B; Tue, 11 Feb 2020 14:53:16 +0100 (CET)
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
Subject: [PATCH 51/62] x86/sev-es: Handle #AC Events
Date:   Tue, 11 Feb 2020 14:52:45 +0100
Message-Id: <20200211135256.24617-52-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Implement a handler for #VC exceptions caused by #AC exceptions. The #AC
exception is just forwarded to do_alignment_check() and not pushed down
to the hypervisor, as requested by the SEV-ES GHCB Standardization
Specification.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev-es.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 6bd2cae7eb9c..1b873d00e38f 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -375,6 +375,10 @@ static enum es_result handle_vc_exception(struct es_em_ctxt *ctxt,
 	case SVM_EXIT_WRITE_DR7:
 		result = handle_dr7_write(ghcb, ctxt, early);
 		break;
+	case SVM_EXIT_EXCP_BASE + X86_TRAP_AC:
+		do_alignment_check(ctxt->regs, 0);
+		result = ES_RETRY;
+		break;
 	case SVM_EXIT_RDTSC:
 	case SVM_EXIT_RDTSCP:
 		result = handle_rdtsc(ghcb, ctxt, exit_code);
-- 
2.17.1

