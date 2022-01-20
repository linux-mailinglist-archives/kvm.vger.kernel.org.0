Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96088494E46
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 13:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243828AbiATMwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 07:52:14 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:41388 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243307AbiATMwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 07:52:11 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5BF211F3AA;
        Thu, 20 Jan 2022 12:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642683130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W/WPJseiDWII0ZLeJwuVUEstTgCWEJ8F8dVgfT5JFVA=;
        b=X1B4KuEPMUTMcs7CJGj7Lazen641an1iTyc6LhREI+s5aKeyclXqOnPhFzfc54Zvc3YRCE
        BmhLcRcCrAvmMEXMMxhh1tmz2lcOZc0Raup9alO64wumeIOD4OUpJ4if8srgMIAXcaBIOe
        59rFD1KfYbZJ5PHj8iKvybuqHTqg5zA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C04A413B51;
        Thu, 20 Jan 2022 12:52:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6FsHLfla6WGIagAAMHmgww
        (envelope-from <varad.gautam@suse.com>); Thu, 20 Jan 2022 12:52:09 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de,
        varad.gautam@suse.com
Subject: [kvm-unit-tests 09/13] x86: AMD SEV-ES: Handle CPUID #VC
Date:   Thu, 20 Jan 2022 13:51:18 +0100
Message-Id: <20220120125122.4633-10-varad.gautam@suse.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220120125122.4633-1-varad.gautam@suse.com>
References: <20220120125122.4633-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Using Linux's CPUID #VC processing logic.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 lib/x86/amd_sev_vc.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/lib/x86/amd_sev_vc.c b/lib/x86/amd_sev_vc.c
index 27a3ed0..91f57e0 100644
--- a/lib/x86/amd_sev_vc.c
+++ b/lib/x86/amd_sev_vc.c
@@ -2,6 +2,7 @@
 
 #include "amd_sev.h"
 #include "svm.h"
+#include "x86/xsave.h"
 
 extern phys_addr_t ghcb_addr;
 
@@ -115,6 +116,43 @@ static enum es_result vc_handle_wbinvd(struct ghcb *ghcb,
 	return sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_WBINVD, 0, 0);
 }
 
+static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
+				      struct es_em_ctxt *ctxt)
+{
+	struct ex_regs *regs = ctxt->regs;
+	u32 cr4 = read_cr4();
+	enum es_result ret;
+
+	ghcb_set_rax(ghcb, regs->rax);
+	ghcb_set_rcx(ghcb, regs->rcx);
+
+	if (cr4 & X86_CR4_OSXSAVE) {
+		/* Safe to read xcr0 */
+		u64 xcr0;
+		xgetbv_checking(XCR_XFEATURE_ENABLED_MASK, &xcr0);
+		ghcb_set_xcr0(ghcb, xcr0);
+	} else
+		/* xgetbv will cause #GP - use reset value for xcr0 */
+		ghcb_set_xcr0(ghcb, 1);
+
+	ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
+	if (ret != ES_OK)
+		return ret;
+
+	if (!(ghcb_rax_is_valid(ghcb) &&
+	      ghcb_rbx_is_valid(ghcb) &&
+	      ghcb_rcx_is_valid(ghcb) &&
+	      ghcb_rdx_is_valid(ghcb)))
+		return ES_VMM_ERROR;
+
+	regs->rax = ghcb->save.rax;
+	regs->rbx = ghcb->save.rbx;
+	regs->rcx = ghcb->save.rcx;
+	regs->rdx = ghcb->save.rdx;
+
+	return ES_OK;
+}
+
 static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 					 struct ghcb *ghcb,
 					 unsigned long exit_code)
@@ -125,6 +163,9 @@ static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
 	case SVM_EXIT_WBINVD:
 		result = vc_handle_wbinvd(ghcb, ctxt);
 		break;
+	case SVM_EXIT_CPUID:
+		result = vc_handle_cpuid(ghcb, ctxt);
+		break;
 	default:
 		/*
 		 * Unexpected #VC exception
-- 
2.32.0

