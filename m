Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D751590DC
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 14:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgBKNzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 08:55:48 -0500
Received: from 8bytes.org ([81.169.241.247]:52426 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729562AbgBKNx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 08:53:27 -0500
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id DF209E8A; Tue, 11 Feb 2020 14:53:14 +0100 (CET)
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
Subject: [PATCH 43/62] x86/sev-es: Handle WBINVD Events
Date:   Tue, 11 Feb 2020 14:52:37 +0100
Message-Id: <20200211135256.24617-44-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200211135256.24617-1-joro@8bytes.org>
References: <20200211135256.24617-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Implement a handler for #VC exceptions caused by WBINVD instructions.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
[ jroedel@suse.de: Adapt to #VC handling framework ]
Co-developed-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/sev-es.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index fcd67ab04d2d..491537b770fd 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -266,6 +266,12 @@ static enum es_result handle_dr7_read(struct ghcb *ghcb,
 	return ES_OK;
 }
 
+static enum es_result handle_wbinvd(struct ghcb *ghcb,
+				    struct es_em_ctxt *ctxt)
+{
+	return ghcb_hv_call(ghcb, ctxt, SVM_EXIT_WBINVD, 0, 0);
+}
+
 static enum es_result handle_vc_exception(struct es_em_ctxt *ctxt,
 					  struct ghcb *ghcb,
 					  unsigned long exit_code,
@@ -289,6 +295,9 @@ static enum es_result handle_vc_exception(struct es_em_ctxt *ctxt,
 	case SVM_EXIT_MSR:
 		result = handle_msr(ghcb, ctxt);
 		break;
+	case SVM_EXIT_WBINVD:
+		result = handle_wbinvd(ghcb, ctxt);
+		break;
 	case SVM_EXIT_NPF:
 		result = handle_mmio(ghcb, ctxt);
 		break;
-- 
2.17.1

