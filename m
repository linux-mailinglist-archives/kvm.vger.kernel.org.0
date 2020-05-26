Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BE81B8191
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 23:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgDXVSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 17:18:40 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:9377 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726027AbgDXVSk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 17:18:40 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Apr 2020 17:18:40 EDT
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 24 Apr 2020 14:03:32 -0700
Received: from mstunes-sid.eng.vmware.com (mstunes-sid.eng.vmware.com [10.118.100.24])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id CBB63405C8;
        Fri, 24 Apr 2020 14:03:35 -0700 (PDT)
From:   Mike Stunes <mstunes@vmware.com>
To:     <joro@8bytes.org>
CC:     <dan.j.williams@intel.com>, <dave.hansen@linux.intel.com>,
        <hpa@zytor.com>, <jgross@suse.com>, <jroedel@suse.de>,
        <jslaby@suse.cz>, <keescook@chromium.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <luto@kernel.org>,
        <peterz@infradead.org>, <thellstrom@vmware.com>,
        <thomas.lendacky@amd.com>,
        <virtualization@lists.linux-foundation.org>, <x86@kernel.org>,
        Mike Stunes <mstunes@vmware.com>
Subject: [PATCH] Allow RDTSC and RDTSCP from userspace
Date:   Fri, 24 Apr 2020 14:03:16 -0700
Message-ID: <20200424210316.848878-1-mstunes@vmware.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200319091407.1481-56-joro@8bytes.org>
References: <20200319091407.1481-56-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: mstunes@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joerg,

I needed to allow RDTSC(P) from userspace and in early boot in order to
get userspace started properly. Patch below.

---
SEV-ES guests will need to execute rdtsc and rdtscp from userspace and
during early boot. Move the rdtsc(p) #VC handler into common code and
extend the #VC handlers.

Signed-off-by: Mike Stunes <mstunes@vmware.com>
---
 arch/x86/boot/compressed/sev-es.c |  4 ++++
 arch/x86/kernel/sev-es-shared.c   | 23 +++++++++++++++++++++++
 arch/x86/kernel/sev-es.c          | 25 ++-----------------------
 3 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/arch/x86/boot/compressed/sev-es.c b/arch/x86/boot/compressed/sev-es.c
index 53c65fc09341..1d0290cc46c1 100644
--- a/arch/x86/boot/compressed/sev-es.c
+++ b/arch/x86/boot/compressed/sev-es.c
@@ -158,6 +158,10 @@ void boot_vc_handler(struct pt_regs *regs, unsigned long exit_code)
 	case SVM_EXIT_CPUID:
 		result = vc_handle_cpuid(boot_ghcb, &ctxt);
 		break;
+	case SVM_EXIT_RDTSC:
+	case SVM_EXIT_RDTSCP:
+		result = vc_handle_rdtsc(boot_ghcb, &ctxt, exit_code);
+		break;
 	default:
 		result = ES_UNSUPPORTED;
 		break;
diff --git a/arch/x86/kernel/sev-es-shared.c b/arch/x86/kernel/sev-es-shared.c
index a632b8f041ec..373ced468659 100644
--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -442,3 +442,26 @@ static enum es_result vc_handle_cpuid(struct ghcb *ghcb,
 
 	return ES_OK;
 }
+
+static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
+				      struct es_em_ctxt *ctxt,
+				      unsigned long exit_code)
+{
+	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
+	enum es_result ret;
+
+	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
+	if (ret != ES_OK)
+		return ret;
+
+	if (!(ghcb_is_valid_rax(ghcb) && ghcb_is_valid_rdx(ghcb) &&
+	     (!rdtscp || ghcb_is_valid_rcx(ghcb))))
+		return ES_VMM_ERROR;
+
+	ctxt->regs->ax = ghcb->save.rax;
+	ctxt->regs->dx = ghcb->save.rdx;
+	if (rdtscp)
+		ctxt->regs->cx = ghcb->save.rcx;
+
+	return ES_OK;
+}
diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
index 409a7a2aa630..82199527d012 100644
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -815,29 +815,6 @@ static enum es_result vc_handle_wbinvd(struct ghcb *ghcb,
 	return sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_WBINVD, 0, 0);
 }
 
-static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
-				      struct es_em_ctxt *ctxt,
-				      unsigned long exit_code)
-{
-	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
-	enum es_result ret;
-
-	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
-	if (ret != ES_OK)
-		return ret;
-
-	if (!(ghcb_is_valid_rax(ghcb) && ghcb_is_valid_rdx(ghcb) &&
-	     (!rdtscp || ghcb_is_valid_rcx(ghcb))))
-		return ES_VMM_ERROR;
-
-	ctxt->regs->ax = ghcb->save.rax;
-	ctxt->regs->dx = ghcb->save.rdx;
-	if (rdtscp)
-		ctxt->regs->cx = ghcb->save.rcx;
-
-	return ES_OK;
-}
-
 static enum es_result vc_handle_rdpmc(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 {
 	enum es_result ret;
@@ -1001,6 +978,8 @@ static enum es_result vc_context_filter(struct pt_regs *regs, long exit_code)
 		/* List of #VC exit-codes we support in user-space */
 		case SVM_EXIT_EXCP_BASE ... SVM_EXIT_LAST_EXCP:
 		case SVM_EXIT_CPUID:
+		case SVM_EXIT_RDTSC:
+		case SVM_EXIT_RDTSCP:
 			r = ES_OK;
 			break;
 		default:
-- 
2.26.1

